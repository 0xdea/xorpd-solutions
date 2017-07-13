;
; $Id: 0x2e.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x2e explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet is similar to the previous 0x2d. In fact,
; it serves the same purpose. It determines if the positive
; integer in rax is a power of two, by comparing the
; following values:
;
; ((rax ^ (rax - 1))>>1)
; (rax - 1)
;
; If they are equal, the integer in rax is a power of two.
;
; It works as follows: if rax is a power of two and its lone
; 1 bit is in position n, then in (rax - 1) the borrow
; propagates all the way to position n, bit n becomes 0 and
; all lower bits become 1. Since rax and (rax - 1) have no
; bits in common, rax ^ (rax - 1) has all bits set to 1. By
; right shifting this value by 1 position, we obtain exactly 
; (rax - 1).
;
; Example:
; $ cat 0x2e_helper.c
; #include <stdio.h>
; main()
; {
; 	int rax;
; 	for (rax = 1; rax <= 20; rax++)
; 		printf("in:\t%d\t\trax - rdx:\t%d\n", 
; 			rax, ((rax ^ (rax - 1))>>1) - (rax - 1));
; }
; $ make 0x2e_helper
; $ ./0x2e_helper
; in:	1		rax - rdx:	0
; in:	2		rax - rdx:	0
; in:	3		rax - rdx:	-2
; in:	4		rax - rdx:	0
; in:	5		rax - rdx:	-4
; in:	6		rax - rdx:	-4
; in:	7		rax - rdx:	-6
; in:	8		rax - rdx:	0
; in:	9		rax - rdx:	-8
; in:	10		rax - rdx:	-8
; [...]
;

	BITS 64

	SECTION .text
	global main

main:
	mov	rdx,rax		; rdx = rax
	dec	rdx		; rdx = rdx - 1
				; i.e. rdx = rax - 1
	xor	rax,rdx		; rax = rax ^ rdx
	shr	rax,1		; rax = rax>>1
				; i.e. rax = (rax ^ (rax - 1))>>1
	cmp	rax,rdx		; compare rax and rdx
