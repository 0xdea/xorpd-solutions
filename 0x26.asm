;
; $Id: 0x26.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x26 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet is equivalent to the following asm code:
;
; ror	rax,7
;
; It rotates rax to the right by 7 positions, by exploiting
; the fact that shift instructions introduce new zeroes and
; that the or instruction preserves values or'ed with zero.
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
	mov	rdx,rax		; rdx = rax
	shr	rax,7		; rax = (int)(rax / pow(2,7)) = (int)(rax / 128)
				; i.e. shift rax right by 7 positions (64 - 57)
	shl	rdx,0x39	; rdx = rdx * (pow(2,57)
				; i.e. shift rax left by 57 positions (64 - 7)
	or	rax,rdx		; rax = rax | rdx
				; i.e. ror rax,7
