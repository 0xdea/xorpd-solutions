;
; $Id: 0x2f.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x2f explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This cool snippet takes an unsigned integer and returns the 
; number of 1 bits it has. For example, the integer 11 has 
; binary representation 0b00000000000000000000000000001011, 
; so the snippet returns 3.
;
; It implements the algorithm that I've pointed out earlier
; in the solution of snippet 0x2d. In C:
;
; int number_of_ones(unsigned int x)
; {
; 	int total_ones = 0;
;  	while (x != 0) {
;    		x = x & (x-1);
;    		total_ones++;
;  	}
;  	return total_ones;
;}
;
; See also:
; http://articles.leetcode.com/number-of-1-bits/
;
; Example:
; $ gdb 0x2f # rcx = 8
; (gdb) b main.exit_loop
; (gdb) r
; Breakpoint 1, 0x0000000000400607 in main.exit_loop ()
; (gdb) i r rax
; rax            0x1	1
; (gdb) load # rcx = 11
; (gdb) r
; Breakpoint 1, 0x0000000000400607 in main.exit_loop ()
; (gdb) i r rax
; rax            0x3    3
;

	BITS 64

	SECTION .text
	global main

main:
	;mov	rcx,11		; added for the analysis
	xor	eax,eax		; eax = 0
.loop:
	jrcxz	.exit_loop	; if (rcx == 0) exit
	inc	rax		; rax = rax + 1
	mov	rdx,rcx		;
	dec	rdx		;
	and	rcx,rdx		; rcx = rcx & (rcx - 1)
	jmp	.loop		; keep looping
.exit_loop:
