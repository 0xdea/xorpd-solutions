;
; $Id: 0x23.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x23 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet is related to the previous snippet 0x22. It
; calculates the remainder after the Euclidean (integer) 
; division of one number (stored in rax) by number 3. This 
; operation is commonly called "modulo". 
;
; This snippet is roughly equivalent to the following C code:
;
; #include <stdio.h>
; main()
; {
; 	int rax = 511; // arbitrary value
; 	int out = rax % 3;
; 	printf("in: %d\tout: %d\n", rax, out);
; }
;

	BITS 64

	SECTION .text
	global main

main:
	;mov	rax,511		; added for the analysis
.loop:
	cmp	rax,5		;
	jbe	.exit_loop	; if (rax <= 5) exit_loop
	mov	rdx,rax		;
	shr	rdx,2		;
	and	rax,3		;
	add	rax,rdx		; rax = (rax & 0b11) + ((int)rax / 4)
	jmp	.loop		; keep looping
.exit_loop:

	cmp	rax,3		;
	cmc			; toggle cf flag
				; i.e. if (rax < 3) cf = 0
				; else cf = 1
	sbb	rdx,rdx		; rdx = rdx - rdx - cf
				; i.e. if (rax < 3) rdx = 0 
				; else rdx = -1 = 0xffffffffffffffff
	and	rdx,3		; rdx = rdx & 0b11
				; i.e. if (rax < 3) rdx = 0
				; else rdx = 3
	sub	rax,rdx		; rax = rax - rdx
				; i.e. if (rax < 3) rax = rax
				; else rax = rax - 3
