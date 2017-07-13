;
; $Id: 0x3c_TODO.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x3c explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; TODO: THIS EXPLANATION IS INCOMPLETE
;
; This snippet is roughly equivalent to the following C code:
;
; #include <stdio.h>
; int number_of_ones(unsigned int x)
; {
;         int total_ones = 0;
;         while (x != 0) {
;                 x = x & (x-1);
;                 total_ones++;
;         }
;         return total_ones;
; }
; main()
; {
;         int i, rax, rbx, rdx;
;         for (i = 0; i < 20; i++) {
;                 rbx = number_of_ones(((i&0xaaaaaaaaaaaaaaaa)>>1)&i)&1;
;                 rax = number_of_ones((((0-i)&0xaaaaaaaaaaaaaaaa)>>1)&(0-i))&1;
;                 printf("rax:\t%d\t\trax,rbx:\t%d,%d\n", i, rax, rbx);
;                 rdx = rax - rbx;
;                 rax = 0 - (rax + rbx - 1);
;                 printf("rax:\t%d\t\trax,rdx:\t%d,%d\n\n", i, rax, rdx);
;         }
; }
;
; Example run:
; $ ./0x3c_helper 
; rax:	0		rax,rbx:	0,0
; rax:	0		rax,rdx:	1,0
; 
; rax:	1		rax,rbx:	0,0
; rax:	1		rax,rdx:	1,0
; 
; rax:	2		rax,rbx:	1,0
; rax:	2		rax,rdx:	0,1
; 
; rax:	3		rax,rbx:	1,1
; rax:	3		rax,rdx:	-1,0
; 
; rax:	4		rax,rbx:	1,0
; rax:	4		rax,rdx:	0,1
; 
; rax:	5		rax,rbx:	1,0
; rax:	5		rax,rdx:	0,1
; [...]
;
; I have no idea on its ultimate purpose... These things
; are getting harder and harder. Luckily I'm almost at the
; end of the book, after a long positive streak;)
;
; This analysis was facilitated by the assembly REPL rappel 
; by yrp604@yahoo.com:
;
; https://github.com/yrp604/rappel/
;

	BITS 64

	SECTION .text
	global main

main:
	mov	rbx,rax			;
	mov	rdx,rbx			;
	mov	rcx,0xaaaaaaaaaaaaaaaa	; 0xa is 0b1010
	and	rbx,rcx			; 
	shr	rbx,1			;
	and	rbx,rdx			;
	popcnt	rbx,rbx			;
	and	rbx,1			;

	; rbx = number_of_ones(((rax & 0xaaaaaaaaaaaaaaaa)>>1) & rax) &1

	neg	rax			;
	mov	rdx,rax			;
	mov	rcx,0xaaaaaaaaaaaaaaaa	; useless instruction
	and	rax,rcx			;
	shr	rax,1			;
	and	rax,rdx			;
	popcnt	rax,rax			;
	and	rax,1			;

	; rax = number_of_ones((((0-rax) & 0xaaaaaaaaaaaaaaaa)>>1) & (0-rax)) &1

	mov	rdx,rax			;
	add	rax,rbx			; 
	dec	rax			; 
	neg	rax			;
	sub	rdx,rbx			;

	; rdx = rax - rbx
	; rax = 0 - (rax + rbx - 1)
