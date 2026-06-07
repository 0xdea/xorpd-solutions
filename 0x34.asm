;
; $Id: 0x34.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x34 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet performs a 32-bit bitwise reversal of eax by 
; executing five successive pairwise-swap passes at 
; granularities of 16, 8, 4, 2, and 1 bits (thanks @tuket!).
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
	mov	ecx,eax		; ecx = eax
	and	ecx,0xffff0000	; ecx = ecx & 0xffff0000
	shr	ecx,0x10	; ecx = ecx>>16
				; i.e. ecx = (eax & 0xffff0000)>>16
	and	eax,0x0000ffff	; eax = eax & 0x0000ffff
	shl	eax,0x10	; eax = eax<<16
				; i.e. eax = (eax & 0x0000ffff)>>16
	or	eax,ecx		; eax = eax | ecx

	; swap 1st word (16 bits) with 2nd word
	; 0x12345678 = 00010010001101000101011001111000 -> 0x56781234 = 01010110011110000001001000110100

	mov	ecx,eax		; ecx = eax
	and	ecx,0xff00ff00	; ecx = ecx & 0xff00ff00
	shr	ecx,0x8		; ecx = ecx>>8
	and	eax,0x00ff00ff	; eax = eax & 0x00ff00ff
	shl	eax,0x8		; eax = eax<<8
	or	eax,ecx		; eax = eax | ecx

	; swap 1st byte (8 bits) with 2nd byte and 3rd byte with 4th byte
	; 0x56781234 = 01010110011110000001001000110100 -> 0x78563412 = 01111000010101100011010000010010

	mov	ecx,eax		; ecx = eax
	and	ecx,0xcccccccc	; ecx = ecx & 0xcccccccc
	shr	ecx,0x2		; ecx = ecx>>2
	and	eax,0x33333333	; eax = eax & 0x33333333
	shl	eax,0x2		; eax = eax<<2
	or	eax,ecx		; eax = eax | ecx

	; swap 1st 2 bits with 2nd 2 bits, 3rd 2 bits with 4th 2 bits, etc.
	; 0x78563412 = 01111000010101100011010000010010 -> 0xd259c148 = 11010010010110011100000101001000

	mov	ecx,eax		; ecx = eax
	and	ecx,0xf0f0f0f0	; ecx = ecx & 0xf0f0f0f0
	shr	ecx,0x4		; ecx = ecx>>4
	and	eax,0x0f0f0f0f	; eax = eax & 0x0f0f0f0f
	shl	eax,0x4		; eax = eax<<4
	or	eax,ecx		; eax = eax | ecx

	; swap 1st nibble (4 bits) with 2nd nibble, 3rd nibble with 4th, etc.
	; 0xd259c148 = 11010010010110011100000101001000 -> 0x2d951c84 = 00101101100101010001110010000100

	mov	ecx,eax		; ecx = eax
	and	ecx,0xaaaaaaaa	; ecx = ecx & 0xaaaaaaaa
	shr	ecx,0x1		; ecx = ecx>>1
	and	eax,0x55555555	; eax = eax & 0x55555555
	shl	eax,0x1		; eax = eax<<1
	or	eax,ecx		; eax = eax | ecx

	; swap 1st bit with 2nd bit, 3rd bit with 4th bit, etc.
	; 0x2d951c84 = 00101101100101010001110010000100 -> 0x1e6a2c48 = 00011110011010100010110001001000
