;
; $Id: 0x0d.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x0d explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet performs the following logical operations:
;
; rdx = rbx
; rbx = (rbx ^ rcx) & rax = (rbx & rax) ^ (rcx & rax)
; rax = (rcx & rax) ^ (rdx & rax)
;
; This is an example of the distributive property of and 
; and xor logical operators. Since rdx and rbx have the 
; same initial value, the resulting rax and rbx will be 
; equal, regardless of the initial values stored in rax, 
; rbx, rcx, and rdx.

; This snippet is roughly equivalent to the following C 
; code:
;
; #include <stdio.h>
; main()
; {
;	int rax = 129; // arbitrary value
;	int rbx = 999; // arbitrary value
;	int rcx = 534; // arbitrary value
;	int rdx = rbx;
;	printf("in rax: %d\n", rax);
;	printf("in rbx: %d\n", rbx);
;	printf("in rcx: %d\n", rcx);
;	printf("in rdx: %d\n\n", rdx);
;	rbx = (rbx ^ rcx) & rax;
;	rax = (rax & rcx) ^ (rdx & rax);
;	printf("out rax: %d\n", rax);
;	printf("out rbx: %d\n", rbx);
; }
;

	BITS 64
	SECTION .text
	global main

main:
	mov 	rdx,rbx		; initialize rbx and rdx with the same value

	xor	rbx,rcx		; rbx = rbx ^ rcx
	and	rbx,rax		; rbx = rbx & rax

	and	rdx,rax		; rdx = rdx & rax
	and	rax,rcx		; rax = rax & rcx
	xor	rax,rdx		; rax = rax ^ rdx

	cmp	rax,rbx		; compare rax and rbx
