;
; $Id: 0x27.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x27 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet performs the following operation:
;
; rax = rax>>((cl>>1) + ((cl + 1)>>1))
;
; Which is equivalent to:
;
; rax = rax >> cl
;
; It performs a logical right shift of rax by the original 
; cl bits, supporting also shift by 64 bits (thanks @tuket!).
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
	mov	ch,cl		;
	inc	ch		; ch = cl + 1
	shr	ch,1		; ch = ch>>1
	shr	cl,1		; cl = cl>>1
	shr	rax,cl		; rax = rax>>cl
	xchg	ch,cl		;
	shr	rax,cl		; rax = rax>>ch
				; i.e. rax = rax>>((cl>>1) + ((cl + 1)>>1))

	; rax = 0xffffffffffffffff, cl = 64
	; direct shr rax, 64 -> rax = 0xffffffffffffffff (masked to shift by 0, wrong)
	; this snippet: shr rax, 32 -> rax = 0x00000000ffffffff
	; 							shr rax, 32 -> rax = 0x0000000000000000 (correct)
