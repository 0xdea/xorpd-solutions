;
; $Id: 0x31.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x31 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet returns 1 if the initial value stored in 
; the rax register is even. This works because the
; expression ((x>>1) ^ x ) ^ (((x+1)>>1) ^ (x+1)) is
; equal to 1 only for even values of x. For example:
;
; x = 6 = 0b110
; (011^110)^(011^111) = 101^100 = 1
;
; x = 9 = 0b1001
; (0100^1001)^(0101^1010) = (1101)^(1111) = 10
;
; This is based on the fact that in case of an even
; value of x, ((x>>1) ^ x ) and (((x+1)>>1) ^ (x+1))
; differ only by a single unity (that is, the least
; significant bit).
;
; To help with the analysis, I've written a short
; C program:
;
; #include <stdio.h>
; main()
; {
; 	int rax, rcx, rdx;
; 	for (rax = 0; rax < 20; rax++) {
; 		rcx = (rax>>1) ^ rax;
; 		rdx = ((rax + 1)>>1) ^ (rax + 1);
; 		printf("rax:\t%d\t\trcx,rdx:\t%d,%d\t\trcx^rdx:\t%d\n",
; 			rax, rcx, rdx, rcx ^ rdx);
; 	}
; }
;
; Example run:
; ./0x31_helper
; rax:	0		rcx,rdx:	0,1		rcx^rdx:	1
; rax:	1		rcx,rdx:	1,3		rcx^rdx:	2
; rax:	2		rcx,rdx:	3,2		rcx^rdx:	1
; rax:	3		rcx,rdx:	2,6		rcx^rdx:	4
; rax:	4		rcx,rdx:	6,7		rcx^rdx:	1
; rax:	5		rcx,rdx:	7,5		rcx^rdx:	2
; rax:	6		rcx,rdx:	5,4		rcx^rdx:	1
; rax:	7		rcx,rdx:	4,12		rcx^rdx:	8
; rax:	8		rcx,rdx:	12,13		rcx^rdx:	1
; rax:	9		rcx,rdx:	13,15		rcx^rdx:	2
; rax:	10		rcx,rdx:	15,14		rcx^rdx:	1
; [...]
;

	BITS 64

	SECTION .text
	global main

main:
	mov	rcx,rax		; rcx = rax
	shr	rcx,1		; rcx = rcx>>1
	xor	rcx,rax		; rcx = rcx ^ rax
				; i.e. rcx = (rax>>1) ^ rax

	inc	rax		; rax = rax + 1

	mov	rdx,rax		; rdx = rax
	shr	rdx,1		; rdx = rdx>>1
	xor	rdx,rax		; rdx = rdx ^ rax
				; i.e. rdx = ((rax + 1)>>1) ^ (rax + 1)

	xor	rdx,rcx		; rdx = rdx ^ rcx
				; i.e. rdx=((rax>>1)^rax)^(((rax+1)>>1)^(rax+1))
