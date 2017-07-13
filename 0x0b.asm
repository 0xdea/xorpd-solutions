;
; $Id: 0x0b.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x0b explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet performs either a neg (two's complement
; negation) or a not (one's complement negation) operation
; on the value present in rdx, based on the content of rax.
; Specifically, if rax contains 0, then a neg operation is 
; performed; if rax contains any other value, a not
; operation is performed instead.
;
; Therefore, this snippet is roughly equivalent to the 
; following C code:
;
; #include <stdio.h>
; main()
; {
; 	int rax = 0; // use 0 for neg, any other value for not
; 	int rdx = 5;
; 	printf("in rdx: %d\n", rdx);
; 	printf("in rax: %d\n", rax);
; 	if (rax)
; 		rdx = ~rdx; // not
; 	else
; 		rdx = ~rdx + 1; // neg
; 	printf("out rdx: %d\n", rdx);
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
	not	rdx		; rdx = ~rdx = 0 - (rdx + 1) = 0 - rdx - 1
	neg	rax		; cf = 1 if rax; cf = 0 if !rax
	sbb	rdx,-1		; rdx = rdx + 1 - cf
