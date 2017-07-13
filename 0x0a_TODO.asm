;
; $Id: 0x0a_TODO.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x0a explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; TODO: THIS EXPLANATION IS INCOMPLETE
;
; This snippet increments the least-significant byte at the
; memory location pointed by rdi. Then, in a loop, it keeps
; incrementing the memory pointer in rdi and increments again
; the least-significant byte at the memory location pointed
; by rdi, but only if the carry flag (cf) is set. 
;
; It is interesting to note that the inc instruction allows 
; a loop counter to be updated without disturbing the cf 
; flag. Conversely, an add instruction with an immediate
; operand of 1 does update the cf flag.
;
; I haven't understood yet the point of this snippet, but
; I'm leaving here some hints for future consideration:
;
; - rdi is commonly used as the "destination index" for
;   string operations
; - in order to fully understand what's going on here (and
;   in the previous snippet 0x08) I must first understand
;   how the cf flag is updated by add/adc instructions.
;
; "I'll be back." -- A. Schwarzenegger
;

	BITS 64

	;SECTION .data		; added for the analysis
	;string db "ABCD"	; added for the analysis

	SECTION .text
	global main

main:
	;mov	rdi,string	; added for the analysis
	add	byte [rdi],1	; increment the least-significant byte
				; at the memory location pointed by rdi
.loop:
	inc	rdi		; increment the memory pointer in rdi
				; while preserving the status of the cf
				; flag
	adc	byte [rdi],0	; increment the least-significant byte
				; at the memory location pointed by rdi
				; if cf = 1
	loop	.loop
