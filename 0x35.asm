;
; $Id: 0x35.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x35 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet illustrates how to add different amounts of
; bits (1 bit, 2 bits, nybble, byte, word) in a dword (32 
; bits).
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
	mov	edx,eax		; edx = eax
	and	eax,0x55555555	; eax = eax & 0x55555555
	shr	edx,0x1		; edx = edx>>1
	and	edx,0x55555555	; edx = edx & 0x55555555
	add	eax,edx		; eax = eax + edx

	; eax = (eax & 0x55555555) + ((eax>>1) & 0x55555555)
	; (0x55555555 is 0b1010101010101010101010101010101)
	;
	; add each adjacent bit, two by two:
	; 0x0 (0b0000) -> 0b0 + 0b0 = 0x0 (0b0000)
	; 0x1 (0b0001) -> 0b0 + 0b1 = 0x1 (0b0001)
	; 0x2 (0b0010) -> 0b1 + 0b0 = 0x1 (0b0001)
	; 0x3 (0b0011) -> 0b1 + 0b1 = 0x2 (0b0010)
	; 0x4 (0b0100) -> 0x4 (0b0100)
	; 0x5 (0b0101) -> 0x5 (0b0101)
	; 0x6 (0b0110) -> 0x5 (0b0101)
	; 0x7 (0b0111) -> 0x6 (0b0110)
	; 0x8 (0b1000) -> 0x4 (0b0100)
	; 0x9 (0b1001) -> 0x5 (0b0101)
	; 0xa (0b1010) -> 0x5 (0b0101)
	; 0xb (0b1011) -> 0x6 (0b0110)
	; 0xc (0b1100) -> 0x8 (0b1000)
	; 0xd (0b1101) -> 0x9 (0b1001)
	; 0xe (0b1110) -> 0x9 (0b1001)
	; 0xf (0b1111) -> 0xa (0b1010)

	mov	edx,eax		; edx = eax
	and	eax,0x33333333	; eax = eax & 0x33333333
	shr	edx,0x2		; edx = edx>>2
	and	edx,0x33333333	; edx = edx & 0x33333333
	add	eax,edx		; eax = eax + edx

	; eax = (eax & 0x33333333) + ((eax>>2) & 0x33333333)
	; (0x33333333 is 0b110011001100110011001100110011)
	; 
	; add each adjacent pair of bits, two by two:
	; 0x0 (0b0000) -> 0b00 + 0b00 = 0x0 (0b0000)
	; 0x1 (0b0001) -> 0b00 + 0b01 = 0x1 (0b0001)
	; 0x2 (0b0010) -> 0b00 + 0b10 = 0x2 (0b0010)
	; 0x3 (0b0011) -> 0b00 + 0b11 = 0x3 (0b0011)
	; 0x4 (0b0100) -> 0b01 + 0b00 = 0x1 (0b0001)
	; 0x5 (0b0101) -> 0b01 + 0b01 = 0x2 (0b0010)
	; 0x6 (0b0110) -> 0b01 + 0b10 = 0x3 (0b0011)
	; 0x7 (0b0111) -> 0b01 + 0b11 = 0x4 (0b0100)
	; 0x8 (0b1000) -> 0b10 + 0b00 = 0x2 (0b0010)
	; 0x9 (0b1001) -> 0b10 + 0b01 = 0x3 (0b0011)
	; 0xa (0b1010) -> 0b10 + 0b10 = 0x4 (0b0100)
	; 0xb (0b1011) -> 0b10 + 0b11 = 0x5 (0b0101)
	; 0xc (0b1100) -> 0b11 + 0b00 = 0x3 (0b0011)
	; 0xd (0b1101) -> 0b11 + 0b01 = 0x4 (0b0100)
	; 0xe (0b1110) -> 0b11 + 0b10 = 0x5 (0b0101)
	; 0xf (0b1111) -> 0b11 + 0b11 = 0x6 (0b0110)

	mov	edx,eax		; edx = eax
	and	eax,0x0f0f0f0f	; eax = eax & 0x0f0f0f0f
	shr	edx,0x4		; edx = edx>>4
	and	edx,0x0f0f0f0f	; edx = edx & 0x0f0f0f0f
	add	eax,edx		; eax = eax + edx

	; eax = (eax & 0x0f0f0f0f) + ((edx>>4) & 0x0f0f0f0f)
	; (0x0f0f0f0f is 0b1111000011110000111100001111)
	;
	; add each adjacent nybble, two by two:
	; 0b00010010001101000101011001111000 ->
	;   0001+0010 0011+0100 0101+0110 0111+1000
	; = 0000 0011 0000 0111 0000 1011 0000 1111 =
	; = 0b00000011000001110000101100001111

	mov	edx,eax		; edx = eax
	and	eax,0x00ff00ff	; eax = eax & 0x00ff00ff
	shr	edx,0x8		; edx = edx>>8
	and	edx,0x00ff00ff	; edx = edx & 0x00ff00ff
	add	eax,edx		; eax = eax + edx

	; eax = (eax & 0x00ff00ff) + ((edx>>8) & 0x00ff00ff)
	; (0x00ff00ff is 0b00000000111111110000000011111111)
	;
	; add each adjacent byte, two by two:
	; 0b00010010001101000101011001111000 ->
	;   00010010+00110100 01010110+01111000 =
	; = 0000000001000110  0000000011001110 =
	; = 0b10001100000000011001110

	mov	edx,eax		; edx = eax
	and	eax,0x0000ffff	; eax = eax & 0x0000ffff
	shr	edx,0x10	; edx = edx>>16
	and	edx,0x0000ffff	; edx = edx & 0x0000ffff
	add	eax,edx		; eax = eax + edx

	; eax = (eax & 0x0000ffff) + ((edx>>16) & 0x0000ffff)
	; (0x0000ffff is 0b00000000000000001111111111111111)
	;
	; add each adjacent word, two by two:
	; 0b00010010001101000101011001111000 ->
	; 0b1001000110100 + 0b101011001111000 = 0b110100010101100
