;
; $Id: 0x03.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x03 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet sets rax to the lower value between rax and
; rdx, using the cf flag to check for carry in a way similar 
; to the previous snippet 0x02. 
; 
; In detail, it subtracts rax from rdx, sets a mask in rcx 
; based on the result (0 if rax <= rdx; 0xffffffffffffffff 
; if rdx < rax) and uses it to return rax if rax <= rdx or 
; return rax + (rdx - rax) = rdx if rdx < rax. In a higher
; level language:
;
; if (rdx < rax) rax = rdx
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
	;mov	rax,1		; initialize the rax register
	;mov	rdx,2		; initialize the rdx register
	sub	rdx,rax		; rdx = rdx - rax; cf = 1 if rdx < rax
	sbb	rcx,rcx		; rcx = rcx - rcx - cf (either 0 or -1)
	and	rcx,rdx		; rcx = (rdx - rax) if (cf); rcx = 0 if (!cf)
	add	rax,rcx		; rax = rax + (rdx - rax) if (cf); rax if (!cf)
