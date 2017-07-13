;
; $Id: 0x3b_TODO.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x3b explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; TODO: THIS EXPLANATION IS INCOMPLETE
;
; This snippet does the following:
;
; if (eax >= 0) 
;	eax = eax * 2
; else 
;	eax = (eax * 2) ^ 0xc0000401
;
; It is roughly equivalent to the following C code:
;
; #include <stdio.h>
; main()
; {
; 	short in, out;
; 	for (in = -2050; in < 100; in++) {
; 		if (in >= 0) 
; 			out = in * 2;
; 		else
; 			out = (in * 2) ^ 0xc0000401;
; 		printf ("in:\t%d\t\tout:\t%d\n", in, out);
; 	}
; }
;
; Once again, the significance of the constant value (in this 
; case 0xc0000401 or 0b11000000000000000000010000000001) is 
; lost on me. Therefore, I couldn't figure out the true purpose
; of this snippet...
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
	cdq			; copy the sign (bit 31) of the value in 
				; eax into every bit position in edx
	shl	eax,1		; eax = eax<<1
				; i.e. eax = eax * 2
	and	edx,0xc0000401	; edx = edx & 0xc0000401
				; if (eax >= 0) edx = 0
				;          else edx = 0xc0000401
	xor	eax,edx		; eax = eax ^ edx

	; if (eax >= 0) eax = eax * 2
	;          else eax = (eax * 2) ^ 0xc0000401
