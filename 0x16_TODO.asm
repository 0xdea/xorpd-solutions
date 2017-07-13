;
; $Id: 0x16_TODO.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x16 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; TODO: THIS EXPLANATION IS INCOMPLETE
;
; This snippet takes rax, rbx, rcx as input and compares
; rax and rsi resulting from the following operations:
;
; rsi = (rax ^ rbx) + (rbx ^ rcx)
; if this addition sets the cf flag: rax = 0
; otherwise: rax = rax ^ rcx
; 
; As far as I've understood, the cf flag is set by add if:
;
; - both arguments are negative numbers
; - one argument is positive and the other one is negative, 
;   and the result is greater than or equal to 0
;
; However, this should be investigated further.
;

	BITS 64
	SECTION .text
	global main

main:
	xor	rax,rbx		;
	xor	rbx,rcx		;
	mov	rsi,rax		;
	add	rsi,rbx		; rsi = (rax ^ rbx) + (rbx ^ rcx)
	cmovc	rax,rbx		;
	xor	rax,rbx		; if (cf) rax = (rbx ^ rcx) ^ (rbx ^ rcx) = 0
				; else rax = rax ^ rbx ^ rbx ^ rcx = rax ^ rcx
	cmp	rax,rsi		; compare rax and rsi
