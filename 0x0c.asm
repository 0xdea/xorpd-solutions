;
; $Id: 0x0c.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x0c explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet takes the value stored in rax and rcx, which
; is the same for both registers, and performs the following
; operations respectively:
;
; - rcx is first xor'ed with rbx and then rotated 13 
;   positions to the right
; - rax is first rotated 13 positions to the right and then
;   xor'ed with rbx which has been previously rotated 13
;   positions to the right as well.
; - Finally, the contents of rax and rcx are compared. They
;   will equal, regardless of their initial value and of 
;   the value of the mask contained in rbx, because of the
;   associative property of xor and ror.
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
	mov	rcx,rax		; initialize rax and rcx with the same value
	xor	rcx,rbx		; rcx = rcx ^ rbx
	ror	rcx,0xd		; rotate rcx right 13 positions

	ror	rax,0xd		; rotate rax right 13 positions
	ror	rbx,0xd		; rotate rbx right 13 positions
	xor	rax,rbx		; rax = rax ^ rbx

	cmp	rax,rcx		; compare rax and rcx
