;
; $Id: 0x02.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x02 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet sets rax to 1 for all its initial values but
; 0, in which case it sets it to 0. To analyze it, I've used
; the handy assembly REPL rappel by yrp604@yahoo.com:
;
; https://github.com/yrp604/rappel/
;
; Example:
; $ ./rappel 
; > mov rax,0
; > neg rax
; > sbb rax,rax
; > neg rax
; rax: 0x0000000000000000
; [...]
; > mov rax,1
; > neg rax
; > sbb rax,rax
; > neg rax
; rax: 0x0000000000000001
;

	BITS 64
	SECTION .text
	global main

main:
	;mov	rax,1		; initialize the rax register
	neg	rax		; two's complement (0 - rax); cf = 1 if rax != 0
	sbb	rax,rax		; rax - rax - cf (it can be either 0 or -1)
	neg	rax		; two's complement (it can be either 0 or 1)
