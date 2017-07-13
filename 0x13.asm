;
; $Id: 0x13.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x13 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet adds the contents of rax and rbx, storing
; the result in rax, by performing a set of recursive
; logical operations. It is roughly equivalent to the
; following C code:
;
; #include <stdio.h>
; main()
; {
;	int rax = 6; // arbitrary value
;	int rbx = 12; // arbitrary value
;	int rcx, rdx;
;	printf("in rax: %d\n", rax);
;	printf("in rbx: %d\n\n", rbx);
;	for (rcx = 0x40; rcx > 0; rcx--) { 
;		rdx = rax;
;		rax = rax ^ rbx;
;		rbx = (rbx & rdx) * 2;
;		printf("out rax: %d\t", rax);
;		printf("out rbx: %d\n", rbx);
;	}
; }
;
; For example, for rax = 2 and rbx = 4, the following
; operations are executed:
; (rax ^ rbx) ^ ((rax & rbx) * 2) =
; = (6 ^ 4) ^ ((6 & 4) * 2) = 6 ^ (0 * 2) = 6 ^ 0 = 6
;
; For rax = 2 and rbx = 3:
; (rax ^ rbx) ^ ((rax & rbx) * 2) =
; = (2 ^ 3) ^ ((2 & 3) * 2) = 1 ^ (2 * 2) = 1 ^ 4 = 5
;
; For rax = 6 and rbx = 12:
; (rax ^ rbx) ^ ((rax & rbx) * 2) ^ ((rax ^ rbx) & ((rax & rbx) * 2)) =
; = (6 ^ 12) ^ ((6 & 12) * 2) ^ ((6 ^ 12) & ((6 & 12) * 2)) =
; = 10 ^ (4 * 2) ^ ((10 & 8) * 2)) = 10 ^ 8 ^ 16 = 2 ^ 16 = 18
;

	BITS 64
	SECTION .text
	global main

main:
	mov	rcx,0x40	; initialize the loop counter to 64
	;mov	rax,6		; added for the analysis
	;mov	rbx,12		; added for the analysis
.loop:
	mov	rdx,rax		; rdx = rax
	xor	rax,rbx		; rax = rax ^ rbx
	and	rbx,rdx		; rbx = rbx & rdx
	shl	rbx,0x1		; rbx = rbx * 2
	loop	.loop
