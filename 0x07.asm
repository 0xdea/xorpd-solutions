;
; $Id: 0x07.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x07 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet sets rax with its initial value, in a way
; similar to the previous snippet 0x06. The following C
; code performs the same calculations:
;
; #include <stdio.h>
; main()
; {
; 	int rax = 5;
; 	printf("in:  %d\n", rax);
; 	rax = ~((~(rax + 1) + 1) + 1) + 1;
; 	printf("out: %d\n", rax);
; }
;
; I guess the main takeway here (as in the previous snippet) 
; is that "not rax" can be rewritten as:
;
; inc	rax
; neg	rax
;
; Similarly, "neg rax" can be rewritten as:
;
; not	rax
; inc	rax
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
	inc	rax		; rax = rax + 1
	neg	rax		; rax = ~rax + 1
	inc	rax		; rax = rax + 1
	neg	rax		; rax = ~rax + 1
