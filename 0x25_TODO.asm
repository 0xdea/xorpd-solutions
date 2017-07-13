;
; $Id: 0x25_TODO.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x25 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; TODO: THIS EXPLANATION IS INCOMPLETE
;
; I have to come back to this snippet. I'll leave here some
; hopefully useful facts for future consideration:
;
; - There are no input values: rax is initialized to 0, rcx
;   to 0x0000000100000000; rbx and rdx are based on rcx.
; - In addition to the effect that all other instructions
;   have on the rcx register, it also gets manipulated as
;   a counter (i.e. decremented) by the loop instruction.
; - Basically, the rax register is incremented each time 
;   there's no overflow in the pow(cx, 2) + pow(rcx>>16, 2) 
;   operation. Here are the results of a sample run, ordered 
;   by loop count:
; #1) -	rax starts as 0 and becomes 1
;     -	rcx starts as 0x0000000100000000 and becomes 
;	0xffffffff (because of the loop instruction)
; #2) - rbx and rdx = 0xffff * 0xffff = 0xfffe0001 
;	(0b11111111111111100000000000000001)
;     - rbx = 0xfffe0001 + 0xfffe0001 = 0x1fffc0002
;	(0b111111111111111000000000000000010), which
;	shifted right of 32 positions becomes 1
;     -	rax stays 1
;     - rcx becomes 0xfffffffe
;	(0b11111111111111111111111111111110)
; #3) - rbx = 0xfffe * 0xfffe = 0xfffc0004
;	(0b11111111111111000000000000000100)
;     - rdx = 0xffff * 0xffff = 0xfffe0001
;	(0b11111111111111100000000000000001)
;     -	rbx = 0xfffc0004 + 0xfffe0001 = 0x1fffa0005
;	(0b11111111111111100000000000000001), which
;	shifted right of 32 positions becomes 1
;     -	rax stays 1
;     - rcx becomes 0xfffffffd
;	(0b11111111111111111111111111111101)
; #4) -	rbx = 0xfffd * 0xfffd = 0xfffa0009
;	(0b11111111111110100000000000001001)
;     - rdx = 0xffff * 0xffff = 0xfffe0001
;	(0b11111111111111100000000000000001)
;     -	rbx = 0xfffa0009 + 0xfffe0001 = 0x1fff8000a
;	(0b111111111111110000000000000001010), which
;	shifted right of 32 positions becomes 1
;     -	rax stays 1
;     - rcx becomes 0xfffffffd
; [...]
; ..) -	rbx = 0
;     -	rdx = 0xfffe0001
;     -	rbx = 0 + 0xfffe0001 = 0xfffe0001
;	(0b11111111111111100000000000000001), which
;	shifted right of 32 positions becomes 0
;     - rax = rax++
;     -	rcx becomes 0xfffeffff
; ..) -	rbx = 0xffff * 0xffff = 0xfffe0001
;	(0b11111111111111100000000000000001)
;     -	rdx = 0xfffe * 0xfffe = 0xfffc0004
;       (0b11111111111111000000000000000100)
;     -	rbx = 0xfffe0001 + 0xfffc0004 = 0x1fffa0005
;	(0b111111111111110100000000000000101), which
;	shifted right of 32 positions becomes 1
;     -	rax stays rax
;     - rcx becomes 0xfffefffe
; [...]
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
	xor	eax,eax		; eax = 0
	mov	rcx,1		;
	shl	rcx,0x20	; rcx = 0x0000000100000000
.loop:
	movzx	rbx,cx		; rbx = cx [padding with zeroes on the left]
	imul	rbx,rbx		; rbx = pow(rbx, 2)
				; i.e. rbx = pow([least 16 bits of rcx], 2)

	ror	rcx,0x10	; rotate rcx right by 16 positions
	movzx	rdx,cx		; rdx = cx [padding with zeroes on the left]
	imul	rdx,rdx		; rdx = pow(rdx, 2)
				; i.e. rdx = pow(rcx>>16, 2)
	rol	rcx,0x10	; restore rcx by rotating it back left

	add	rbx,rdx		; rbx = rbx + rdx
				; i.e. rbx = pow(cx, 2) + pow(rcx>>16, 2)
	shr	rbx,0x20	; shift rbx right by 32 positions
	cmp	rbx,1		;
	adc	rax,0		; if (rbx < 1) rax++ [overflow]
	loop	.loop		; rcx-- and keep looping until rcx is zero
