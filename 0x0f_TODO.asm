;
; $Id: 0x0f_TODO.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x0f explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; TODO: THIS EXPLANATION IS INCOMPLETE
;
; This snippet is roughly equivalent to the following C 
; code:
;
; #include <stdio.h>
; #include <string.h>
; main()
; {
;	char string[17] = "ABAABBBBCCCCDDDD";
;	char rax = 0x0;
;	int i;
;	printf("in string: %s\n", string);
;	printf("in rax: %d\n\n", rax);
;	for (i = 0; i < strlen(string); i++) {
;		string[i] = string[i] ^ rax;
;		rax = string[i];
;		printf("out string[%d]: 0x%x\n", i, string[i]);
;	}
; }
;
; Basically, it performs the following operations in a loop:
;
; string[0] = rax
; string[1] = string[0] ^ string[1]
; string[2] = string[1] ^ string[2]
; string[3] = string[2] ^ string[3]
; [...]
;
; Some random ideas for future reference:
; 
; - The most interesting case seems to be when rax is
;   initialized with the value 0
; - Which property of xor is the author demonstrating 
;   here?
;

	BITS 64

	;SECTION .data		; added for the analysis
	;string db "ABCDABCD"	; added for the analysis

	SECTION .text
	global main

main:
	;mov	rsi,string	; added for the analysis
	;mov	rax,0		; added for the analysis
.loop:
	xor	byte [rsi],al	; xor al with the least-significant byte
				; at the memory location pointed by rsi
	lodsb			; load byte at address rsi into al
				; and increments rsi by 1 (if df == 0)
	loop	.loop
