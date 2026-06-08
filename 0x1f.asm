;
; $Id: 0x1f_TODO.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x1f explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet is an optimized implementation of the Collatz
; conjecture (https://en.wikipedia.org/wiki/Collatz_conjecture),
; also known as the 3n+1 problem (thanks to @AlexAltea for 
; pointing this out). The classic formulation is:
;
;   - If n is even: n = n / 2
;   - If n is odd:  n = 3n + 1
;   - Repeat until n = 1
;
; This version merges all consecutive "divide by 2" steps into a
; single right shift, using bsf to count the trailing zero bits:
;
; - bsf rcx,rax finds the position of the lowest set bit in rax,
;   i.e. the number of trailing zeros.
; - shr rax,cl discards all those trailing zeros at once, leaving
;   rax odd (or 1 if rax was a power of two).
; - If rax == 1 we are done (the Collatz sequence has converged).
; - Otherwise rax = rax + 2*rax + 1 = 3*rax + 1. Since rax is
;   always odd at this point, the lea operand can be read as:
;   take rax, left-shift it by one (giving an even value), then
;   set the LSB, and add the original rax — the standard Collatz
;   odd step implemented with a single instruction.
; - Jump back and repeat.
;
; Two properties worth noting:
;
; - Any power of two (1, 2, 4, 8, ...) causes an immediate exit:
;   bsf+shr strips all the trailing zeros in one shot, leaving 1.
; - The result of the lea instruction is always even (odd + odd
;   + 1 = even), so the next iteration always strips at least one
;   trailing zero before reaching another odd number.
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
