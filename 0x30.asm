;
; $Id: 0x30.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x30 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet illustrates the following property:
;
; rax & rdx = ((((rax & rdx) - rdx) & rdx) - 1) & rdx
;
; To help with the analysis, I've written a short
; C program:
;
; #include <stdio.h>
; main()
; {
; 	int rax, rdx;
; 	int r1, r2, r3;
; 	for (rax = 1; rax <= 5; rax++)
; 		for (rdx = 1; rdx <= 5; rdx++) {
; 			r1 = rax & rdx;
; 			r2 = (r1 - rdx) & rdx;
; 			r3 = (r2 - 1) & rdx;
; 			printf("rax,rdx:\t%d,%d\t\tout:\t%d,%d,%d\n", 
; 				rax, rdx, r1, r2, r3);
; 		}
; }
;
; Example run:
; $ ./0x30_helper
; rax,rdx:	1,1		out:	1,0,1
; rax,rdx:	1,2		out:	0,2,0
; rax,rdx:	1,3		out:	1,2,1
; rax,rdx:	1,4		out:	0,4,0
; rax,rdx:	1,5		out:	1,4,1
; rax,rdx:	2,1		out:	0,1,0
; rax,rdx:	2,2		out:	2,0,2
; rax,rdx:	2,3		out:	2,3,2
; rax,rdx:	2,4		out:	0,4,0
; rax,rdx:	2,5		out:	0,1,0
; rax,rdx:	3,1		out:	1,0,1
; rax,rdx:	3,2		out:	2,0,2
; rax,rdx:	3,3		out:	3,0,3
; rax,rdx:	3,4		out:	0,4,0
; rax,rdx:	3,5		out:	1,4,1
; rax,rdx:	4,1		out:	0,1,0
; rax,rdx:	4,2		out:	0,2,0
; rax,rdx:	4,3		out:	0,1,0
; rax,rdx:	4,4		out:	4,0,4
; rax,rdx:	4,5		out:	4,5,4
; rax,rdx:	5,1		out:	1,0,1
; rax,rdx:	5,2		out:	0,2,0
; rax,rdx:	5,3		out:	1,2,1
; rax,rdx:	5,4		out:	4,0,4
; rax,rdx:	5,5		out:	5,0,5
;

	BITS 64

	SECTION .text
	global main

main:
	and	rax,rdx		; rax = rax & rdx

	sub	rax,rdx		;
	and	rax,rdx		; rax = (rax - rdx) & rdx

	dec	rax		;
	and	rax,rdx		; rax = (rax - 1) & rdx

				; i.e. rax = ((((rax & rdx)-rdx)&rdx)-1)&rdx
