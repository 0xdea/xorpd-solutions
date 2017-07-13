;
; $Id: 0x39.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x39 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; Values of rax that do not have even bits set are
; unaffected by this snippet (e.g. 0 -> 0; 1 -> 1; 4 -> 4; 
; 5 -> 5, etc.). Conversely, bytes with even bits set
; get added to 0xa, which determines a carry, and the 
; result gets then xor'ed with 0xa. 

; Let's examine its effect against different bytes:
; 00 ->  00 (i.e. unaffected)
; 01 ->  01 (i.e. unaffected)
; 10 -> 110 (i.e. 10 with carry)
; 11 -> 111 (i.e. 11 with carry)
;
; Here are some example calculations based on this,
; carried on byte by byte:
; 
; 0x2 (0b0010)
; starting with the least-significant byte, we have: 10 -> 110
; the most-significant byte then becomes: 00 + 01 = 01
; we know that byte 01 is unaffected, therefore: 0x2 (0b0010) -> 0x6 (0b0110)
;
; 0x3 (0b0011)
; starting with the least-significant byte, we have: 11 -> 111
; the most-significant byte then becomes: 00 + 01 = 01
; we know that byte 01 is unaffected, therefore: 0x3 (0b0011) -> 0x7 (0b00111)
;
; 0xa (0b1010)
; starting with the least-significant byte, we have: 10 -> 110
; the most-significant byte then becomes: 10 + 01 = 11
; we know that byte 11 becomes 111, therefore: 0xa (0b1010) -> 0x1e (0b11110)
;
; I don't think there's much more to say about this one.
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
	mov	rdx,0xaaaaaaaaaaaaaaaa	; rdx = 0xaaaaaaaaaaaaaaaa
	add	rax,rdx			; rax = rax + rdx
	xor	rax,rdx			; rax = rax ^ rdx

	; rax = (rax + 0xaaaaaaaaaaaaaaaa) ^ 0xaaaaaaaaaaaaaaaa
