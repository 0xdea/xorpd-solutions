;
; $Id: 0x12.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x12 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet adds the contents of rax and rdx, showing
; an interesting property of logical operators, summarized
; in the following formula:
;
; (rax | rdx) + (rax & rdx) = rax + rdx
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
	mov	rcx,rdx		; initialize rcx and rdx with the same value
	and	rdx,rax		;
	or	rax,rcx		;
	add	rax,rdx		; rax = (rax | rcx) + (rax & rdx) =
				; = (rax | rdx) + (rax & rdx) = rax + rdx
