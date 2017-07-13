;
; $Id: 0x37.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x37 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet takes the value in rax and replaces each 0x00 byte 
; (including leading zeros) with a 0x80, setting any other byte 
; to 0x00.
;
; Here are a couple of interesting observations:
; - In 0x0101010101010101 the last bit of each byte is set, that is:
;   0b0000000100000001000000010000000100000001000000010000000100000001
; - In 0x8080808080808080 the first bit of each byte is set, that is:
;   0b1000000010000000100000001000000010000000100000001000000010000000
;
; I've written the following C code to help with the analysis:
; #include <stdio.h>
; main()
; {
;	long long rax, i;
;	for (i = 0x00; i < 0xff; i++) {
;		rax = i;
;		rax = (rax - 0x0101010101010101) & (~rax & 0x8080808080808080);
;		printf("in:\t0x%llx\t\tout:\t0x%llx\n", i, rax);
;	}
; }
;

	BITS 64

	SECTION .text
	global main

main:
	mov	rdx,rax			;
	not	rdx			;
	mov	rcx,0x8080808080808080	;
	and	rdx,rcx			; rdx = ~rax & 0x8080808080808080
	mov	rcx,0x0101010101010101	;
	sub	rax,rcx			; rax = rax - 0x0101010101010101
	and	rax,rdx			;

	; rax = (rax - 0x0101010101010101) & (~rax & 0x8080808080808080)
