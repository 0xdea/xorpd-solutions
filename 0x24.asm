;
; $Id: 0x24.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x24 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet is similar to the previous snippet 0x23. It
; illustrates a clever/convoluted way to determine if the 
; value contained in rax is even or odd. If the result in 
; rcx is 0, rax is even; if the result in rcx is 1, rax is 
; odd. As a bonus, the original input value is preserved in 
; the rbx register.
;

	BITS 64

	SECTION .text
	global main

main:
	;mov	rax,150		; added for the analysis
	mov	rbx,rax		; rbx = rax
	mov	rsi,rax		; rsi = rax
.loop:
	mul	rbx		; rdx:rax = rax * rbx
				; i.e. rdx:rax = rax * rax = pow(rax, 2)
	mov	rcx,rax		; rcx = rax
				; i.e. rcx = pow(rax, 2)

	sub	rax,2		; rax = rax - 2
				; i.e. rax = pow(rax, 2) - 2
	neg	rax		; rax = ~rax + 1
				; i.e. rax = ~(pow(rax, 2) - 2) + 1
	mul	rsi		; rdx:rax = rax * rsi
				; i.e. (~(pow(rax, 2) - 2) + 1) * rax
	mov	rsi,rax		; rsi = rax
				; i.e. rsi = (~(pow(rax, 2) - 2) + 1) * rax

	cmp	rcx,1		; if (pow(rax, 2) <= 1) exit
	ja	.loop		; else keep looping
.exit_loop:
