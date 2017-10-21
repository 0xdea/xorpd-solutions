;
; $Id: 0x28.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x28 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet takes advantage of the rcr instruction, which
; shifts the cf flag into the most-significant bit and shifts
; the least-significant bit into the cf flag.
;
; In detail, it does the following:
;
; 1. Right shift by 1 position the first byte of the string 
;    pointed by rsi.
; 2. Right shift by 1 position the next byte of the string
;    pointed by rsi. If the least-significant bit of the
;    previous byte was set (i.e. the value was odd), the
;    most-significant bit of the current byte is set to 1.
;    Otherwise, it is set to 0.
; 3. Repeat the previous step.
;
; In summary, this snippet right-shifts by one position a
; rcx-long buffer at address rsi. In other words, it divides
; by 2 a rcx byte long integer stored at the address pointed
; by rsi.
;

	BITS 64

	;SECTION .data		; added for the analysis
	;string db "ABCD"	; added for the analysis

	SECTION .text
	global main

main:
	;mov	rsi,string	; added for the analysis
	clc			; cf = 0
.loop:
	rcr	byte [rsi],1	; right rotate with carry
	inc	rsi		; rsi++
	loop	.loop		; keep looping
