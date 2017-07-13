;
; $Id: 0x33.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x33 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet is roughly equivalent to the following C
; code (for values of rax in the range 0-19):
;
; #include <stdio.h>
; #include <math.h>
; main()
; {
;         long long i, j, rax;
;         for (i = 0; i < 20; i++) {
;                 rax = i;
;                 for (j = 0; j <= 5; j++)
;                         rax = rax ^ (rax>>(long long)(pow(2, j)));
;                 printf("in:\t%d\t\tout:\t%d\n", i, rax);
;         }
; }
;
; However, inspired by the next 0x34 snippet, I've decided 
; to consider each step as a separate snippet, reinitializing 
; rax to the chosen input. This way, this snippet illustrates
; how to xor different amounts of bits (1 bit, 2 bits, 1 nybble,
; 1 byte, 1 word, 1 dword) with each other.
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
	mov	rdx,rax		;
	shr	rdx,0x1		;
	xor	rax,rdx		; rax = rax ^ (rax>>1)

	; xor 0b0 with 1st bit, 1st bit with 2nd, 2nd with 3rd, etc.
	; 10010001101000101011001111000 -> 11011001011100111110101000100

	mov	rdx,rax		;
	shr	rdx,0x2		;
	xor	rax,rdx		; rax = rax ^ (rax>>2)

	; xor 0b00 with 1st 2 bits, 1st 2 bits with 2nd 2 bits, etc.
	; 10010001101000101011001111000 -> 10110101110010100001111100110

	mov	rdx,rax		;
	shr	rdx,0x4		;
	xor	rax,rdx		; rax = rax ^ (rax>>4)

	; xor 0x0 with 1st nybble, 1st nybble with 2nd nybble, etc.
	; 10010001101000101011001111000 -> 10011000101110001001100011111

	mov	rdx,rax		;
	shr	rdx,0x8		;
	xor	rax,rdx		; rax = rax ^ (rax>>8)

	; xor 0x00 with 1st byte, 1st byte with 2nd byte, etc.
	; 10010001101000101011001111000 -> 10010001001100110001000101110

	mov	rdx,rax		;
	shr	rdx,0x10	;
	xor	rax,rdx		; rax = rax ^ (rax>>16)

	; xor 0x0000 with first word (16 bit), 1st word with 2nd word, etc.
	; 10010001101000101011001111000 -> 10010001101000100010001001100

	mov	rdx,rax		;
	shr	rdx,0x20	;
	xor	rax,rdx		; rax = rax ^ (rax>>32)

	; xor 0x00000000 with first dword (32 bits), 1st dword with 2nd, etc.
	; 10010001101000101011001111000 -> 10010001101000101011001111000
