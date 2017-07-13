;
; $Id: 0x14.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x14 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; For positive integer values of rax and rdx, this snippet
; calculates the mean value (average), without taking into
; account the remainder of the Euclidean division (if any).
;
; It shows another interesting property of logical operators:
;
; (rax & rdx) + ((int)(rax ^ rdx) / 2) = (int)((rax + rdx) / 2)
;
; This snippet is roughly equivalent to the following C code:
;
; #include <stdio.h>
; main()
; {
; 	int rax = 29; // arbitrary value
; 	int rdx = 56; // arbitrary value
; 	int rcx = rax;
; 	printf("in rax: %d\n", rax);
; 	printf("in rdx: %d\n\n", rdx);
; 	rcx = rax & rdx;
; 	rax = (int)(rax ^ rdx) / 2;
; 	rax = rax + rcx;
; 	printf("out rax: %d\n", rax);
; }
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
	mov	rcx,rax		;
	and	rcx,rdx		; rcx = rax & rdx

	xor	rax,rdx		;
	shr	rax,1		; rax = (int)(rax ^ rdx) / 2

	add	rax,rcx		; rax = rax + rcx
