;
; $Id: 0x17.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x17 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This cool snippet illustrates an elegant way to 
; calculate the absolute value of the content of rax. 
; It does so by performing the following operations:
;
; - use the cqo instruction to copy the sign of the
;   value in rax into every bit position in rdx
; - exploit the fact that x ^ 0xffffffffffffffff = ~x
;   and x ^ 0x0 = x
; - subtract rdx (either -1 or 0) from rax and voila!
;
; This analysis was facilitated by the assembly REPL rappel 
; by yrp604@yahoo.com:
;
; https://github.com/yrp604/rappel/
;
; Example:
; $ ./rappel
; > mov rax,5
; rax: 0x0000000000000005 rdx: 0x0000000000000000
; > cqo
; rax: 0x0000000000000005 rdx: 0x0000000000000000
; > xor rax,rdx
; rax: 0x0000000000000005 rdx: 0x0000000000000000
; > sub rax,rdx
; rax: 0x0000000000000005 rdx: 0x0000000000000000
; [...]
; > mov rax,-5
; rax: 0xfffffffffffffffb rdx: 0x0000000000000000
; > cqo
; rax: 0xfffffffffffffffb rdx: 0xffffffffffffffff
; > xor rax,rdx
; rax: 0x0000000000000004 rdx: 0xffffffffffffffff
; > sub rax,rdx
; rax: 0x0000000000000005 rdx: 0xffffffffffffffff
; 

	BITS 64
	SECTION .text
	global main

main:
	cqo			; if (rax < 0) rdx = 0xffffffffffffffff
				; else rdx = 0x0
	xor	rax,rdx		;
	sub	rax,rdx		; if (rax < 0) rax = ~rax + 1
				; else rax = rax
