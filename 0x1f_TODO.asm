;
; $Id: 0x1f_TODO.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x1f explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; TODO: THIS EXPLANATION IS INCOMPLETE
;
; Here's another incomplete solution. Hopefully these 
; snippets aren't getting too complicated... This one
; does the following:
;
; - Discard all least-significant bits not set (0)
;   in rax by shifting it right a number of positions
;   specified by the result of the bsf instruction.
; - If the resulting value in rax is 1, then exit
;   (this condition is true only if the previous
;   value of rax was a power of two, see below).
; - Otherwise, rax = rax + 2 * rax + 1 = rax * 3 + 1.
;   However, this can also be interpreted as rax + left
;   shift of rax + 1, which in turn means "add rax with
;   its left shifted value with a 1 in the LSB instead
;   of a 0".
; - Go back to the first step and keep looping.
;
; Here's an example to clarify the described operations:
;
; - rax = 9 (in binary 0b00001001)
; - There are no LSBs not set to discard, so we move on.
; - rax = 0b00001001 + 0b00010011 = 0b00011100 (even)
; - Discard all LSBs not set: rax = 0b00000111 (odd)
; - rax = 0b00000111 + 0b00001111 = 0b00010110 (even)
; - Discard all LSBs not set: rax = 0b00001011 (odd)
; - rax = 0b00001011 + 0b00010111 = 0b00100010 (even)
; - Discard all LSBs not set: rax = 0b00010001 (odd)
; - rax = 0b00010001 + 0b00100011 = 0b00110100 (even)
; - Discard all LSBs not set: rax = 0b00001101 (odd)
; - rax = 0b00001101 + 0b00011011 = 0b00101000 (even)
; - Discard all LSBs not set: rax = 0b00000101 (odd)
; - rax = 0b00000101 + 0b00001011 = 0b00010000 (even)
; - Discard all LSBs not set: rax = 0b00000001 (odd)
; - rax is 1, exit the loop!
;
; My analysis highlighted a couple of properties:
;
; - Powers of two (e.g. 0, 1, 2, 4, 8...) make the
;   program exit right away.
; - The result of the lea operation (which by the
;   way seems to be the key to fully understand this
;   snippet) is always even, because it is the sum
;   of two odd numbers.
;
; Example:
; $ gdb 0x1f
; (gdb) disas main
; Dump of assembler code for function main:
;    0x00000000004005f0 <+0>:	mov    $0x1,%eax
; End of assembler dump.
; (gdb) disas 0x00000000004005f0+5
; Dump of assembler code for function main.loop:
;    0x00000000004005f5 <+0>:	bsf    %rax,%rcx
;    0x00000000004005f9 <+4>:	shr    %cl,%rax
;    0x00000000004005fc <+7>:	cmp    $0x1,%rax
;    0x0000000000400600 <+11>:	je     0x400609 <main.exit_loop>
;    0x0000000000400602 <+13>:	lea    0x1(%rax,%rax,2),%rax
;    0x0000000000400607 <+18>:	jmp    0x4005f5 <main.loop>
; End of assembler dump.
; (gdb) disas main+25
; Dump of assembler code for function main.exit_loop:
;    0x0000000000400609 <+0>:	nopl   0x0(%rax)
; End of assembler dump.
; 

	BITS 64

	SECTION .text
	global main

main:
	;mov	rax,9			; added for the analysis
.loop:
	bsf	rcx,rax			; load rcx with the position of the LSB 
					; that is set in rax (from position 0)
	shr	rax,cl			; rax = (int)(rax / pow(2, rcx))
					; i.e.: discard all LSBs not set
	cmp	rax,1			;
	je	.exit_loop		; if (rax == 1) exit
	lea	rax,[rax + 2*rax + 1]	; rax = rax + 2*rax +1
					; i.e.: rax + (left shift of rax) + 1
	jmp	.loop			; keep looping
.exit_loop:
