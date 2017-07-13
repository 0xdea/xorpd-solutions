;
; $Id: 0x2b_TODO.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x2b explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; TODO: THIS EXPLANATION IS INCOMPLETE
;
; This snippet does the following:
;
; 1. Initialize eax and rdx to 0. Register rbx must point
;    to a valid memory location.
; 2. Copy rbx[al] into rdx, while preserving the original
;    value of rdx in rax.
; 3. Copy rbx[rbx[al]] into rdx, while preserving the value
;    of rdx in rax.
; 4. Loop back to step 2 until al == dl.
; 5. Initialize eax to 0. Register rdx maintains the value
;    calculated in the previous loop.
; 6. Copy rbx[al] into rdx, while preserving the original
;    value of rdx in rax.
; 7. Copy rbx[al] into rdx, while preserving the value
;    of rdx in rax.
; 8. Loop back to step 6 until al == dl.
;
; That being said, I have yet to understand the purpose 
; of this snippet. I'll leave here some thoughts for
; future consideration:
;
; - The first and the second loop are almost equal. The
;   only differences are in step 3 and step 6 (in the
;   first loop the no-operands xlatb instruction is
;   executed twice in a row, while in the second loop it 
;   is executed only once) and in the fact that edx is not
;   reinitialized to 0 before entering the second loop.
; - The second loop is executed only once, if eax = 0 
;   (always true) and edx = 0 (to be investigated),
;   because if al == dl then rbx[al] == rbx[dl].
; - The first loop exits when rbx[al] == rbx[rbx[dl]],
;   i.e. the values in the array are used as an index fori
;   the array itself.
;
; Example:
; $ gdb 0x2b
; (gdb) disas main
; Dump of assembler code for function main:
;   0x00000000004005f0 <+0>:	movabs $0x600a00,%rbx
;   0x00000000004005fa <+10>:	xor    %eax,%eax
;   0x00000000004005fc <+12>:	xor    %edx,%edx
; End of assembler dump.
; (gdb) disas main+18
; Dump of assembler code for function main.loop1:
;    0x00000000004005fe <+0>:	xlat   %ds:(%rbx)
;    0x00000000004005ff <+1>:	xchg   %rax,%rdx
;    0x0000000000400601 <+3>:	xlat   %ds:(%rbx)
;    0x0000000000400602 <+4>:	xlat   %ds:(%rbx)
;    0x0000000000400603 <+5>:	xchg   %rax,%rdx
;    0x0000000000400605 <+7>:	cmp    %dl,%al
;    0x0000000000400607 <+9>:	jne    0x4005fe <main.loop1>
;    0x0000000000400609 <+11>:	xor    %eax,%eax
; End of assembler dump.
; (gdb) disas main+36
; Dump of assembler code for function main.loop2:
;    0x000000000040060b <+0>:	xlat   %ds:(%rbx)
;    0x000000000040060c <+1>:	xchg   %rax,%rdx
;    0x000000000040060e <+3>:	xlat   %ds:(%rbx)
;    0x000000000040060f <+4>:	xchg   %rax,%rdx
;    0x0000000000400611 <+6>:	cmp    %dl,%al
;    0x0000000000400613 <+8>:	jne    0x40060b <main.loop2>
;    0x0000000000400615 <+10>:	nopw   %cs:0x0(%rax,%rax,1)
;    0x000000000040061f <+20>:	nop
; End of assembler dump.
; (gdb) x/4x 0x600a00
; 0x600a00:	0x00030201	0x00000000	0x00000000	0x00000000
; [...]
; 

	BITS 64

	;SECTION .data		; added for the analysis
	;string db 1,2,3,0	; added for the analysis

	SECTION .text
	global main

main:
	;mov	rbx,string	; added for the analysis
	xor	eax,eax		; eax = 0
	xor	edx,edx		; edx = 0
.loop1:
	xlatb			; set al to memory byte [rbx + unsigned al]
	xchg	rax,rdx		; exchange the content of rax with rdx
				; i.e. rdx = rbx[al], rax = rdx
	xlatb			; set al to memory byte [rbx + unsigned al]
	xlatb			; set al to memory byte [rbx + unsigned al]
	xchg	rax,rdx		; exchange the content of rax with rdx
				; i.e. rdx = rbx[rbx[al]], rax = rdx
	cmp	al,dl		; if (al == dl) exit loop
				; i.e. if (rbx[al] == rbx[rbx[dl]]) exit loop
	jnz	.loop1		; else keep looping

	xor	eax,eax		; eax = 0
.loop2:
	xlatb			; set al to memory byte [rbx + unsigned al]
	xchg	rax,rdx		; exchange the content of rax with rdx
				; i.e. rdx = rbx[al], rax = rdx
	xlatb			; set al to memory byte [rbx + unsigned al]
	xchg	rax,rdx		; exchange the content of rax with rdx
				; i.e. rdx = rbx[al], rax = rdx
	cmp	al,dl		; if (al == dl) exit
				; i.e. if (rbx[al] == rbx[dl]) exit
	jnz	.loop2		; else keep looping
