;
; $Id: 0x10.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x10 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This is the funniest snippet so far. It illustrates
; different ways to exchange the content of rax with rcx.
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
	push	rax		; push the value of rax onto the stack
	push	rcx		; push the value of rcx onto the stack
	pop	rax		; load the value on top of the stack into rax
	pop	rcx		; load the value on top of the stack into rcx

	xor	rax,rcx		; 
	xor	rcx,rax		; rcx = rcx ^ (rax ^ rcx) = rax
	xor	rax,rcx		; rax = (rax ^ rcx) ^ (rcx ^ (rax ^ rcx)) = rcx

	add	rax,rcx		;
	sub	rcx,rax		; rcx = rcx - (rax + rcx) = -rax
	add	rax,rcx		; rax = (rax + rcx) - rax = rcx
	neg	rcx		; rcx = 0 - rcx = 0 + rax = rax

	xchg	rax,rcx		; exchange the content of rax with rcx
