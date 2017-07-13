;
; $Id: 0x2d.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x2d explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This nifty snippet determines if the positive integer 
; in rax is a power of two, by performing the following 
; operation:
;
; rax & (rax - 1)
;
; If the result is 0, the integer in rax is a power of two.
;
; This works because if rax is a power of two and its lone 
; 1 bit is in position n, then in (rax - 1) the borrow 
; propagates all the way to position n, bit n becomes 0 and 
; all lower bits become 1. Since rax and (rax - 1) have no
; bits in common, rax & (rax - 1) is equal to 0. This is
; how the check is implemented in malloc.c in the glibc:
;
; int isPowerOfTwo (unsigned int x)
; {
;	return ((x != 0) && !(x & (x - 1)));
; }
;
; For another interesting property of x & (x-1), see:
; http://articles.leetcode.com/number-of-1-bits/
;
; Example:
; $ cat 0x2d_helper.c
; #include <stdio.h>
; main()
; {
;	int rax;
;	for (rax = 1; rax <= 20; rax ++)
;		printf("in:\t%d\t\tout:\t%d\n", 
;			rax, (rax - 1) & rax);
; }
; $ make 0x2d_helper
; $ ./0x2d_helper
; in:	1		out:	0
; in:	2		out:	0
; in:	3		out:	2
; in:	4		out:	0
; in:	5		out:	4
; in:	6		out:	4
; in:	7		out:	6
; in:	8		out:	0
; in:	9		out:	8
; in:	10		out:	8
; [...]
;

	BITS 64

	SECTION .text
	global main

main:
	mov	rdx,rax		; rdx = rax
	dec	rax		; rax = rax - 1
	and	rax,rdx		; rax = rax & rdx
				; i.e. rax = rax & (rax - 1)
