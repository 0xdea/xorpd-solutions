;
; $Id: 0x20.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x20 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; I guess the hidden message of this halfway snippet is: 
; "If you've come this far, you're pretty l33t;)". It 
; simply outputs rax * 1337.
;
; It does so by using the following formula:
; ((((x * 4 + x) * 8 + x) * 2 + x) * 2 + x) * 8 + x
; If x = 1:
; ((((4 + 1) * 8 + 1) * 2 + 1) * 2 + 1) * 8 + 1 = 
; = 1024 + 8 + (8 * 2) + (8 * 2 * 2) + (8 * 8 * 2 * 2) + 1
; = 1337
;
; Example:
; $ cat 0x20_helper.c
; #include <stdio.h>
; main()
; {
;	int rax, rcx;
;	for (rax = 0; rax <= 10; rax++) {
;		rcx=((((rax*4+rax)*8+rax)*2+rax)*2+rax)*8+rax;
;		printf("rax: %5d\t", rax);
;		printf("rcx: %5d\n", rcx);
;	}
; }
; $ make 0x20_helper
; $ ./0x20_helper
; rax:     0	rcx:     0
; rax:     1	rcx:  1337
; rax:     2	rcx:  2674
; rax:     3	rcx:  4011
; rax:     4	rcx:  5348
; rax:     5	rcx:  6685
; rax:     6	rcx:  8022
; rax:     7	rcx:  9359
; rax:     8	rcx: 10696
; rax:     9	rcx: 12033
; rax:    10	rcx: 13370
; 

	BITS 64

	SECTION .text
	global main

main:
	mov	rcx,rax	;
	shl	rcx,2	;
	add	rcx,rax	;
	shl	rcx,3	;
	add	rcx,rax	;
	shl	rcx,1	;
	add	rcx,rax	;
	shl	rcx,1	;
	add	rcx,rax	;
	shl	rcx,3	;
	add	rcx,rax	; rcx=((((rax*4+rax)*8+rax)*2+rax)*2+rax)*8+rax
