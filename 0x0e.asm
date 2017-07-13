;
; $Id: 0x0e.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x0e explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet performs the following logical operations:
;
; rcx = rax
; rcx = ~(rcx & rbx)
; rax = ~rax | ~rbx
;
; This is an example application of DeMorgan's laws. Since 
; rcx and rax have the same initial value, the resulting 
; rcx and rax will still be equal, regardless of their 
; initial value and of the initial value of rbx.
; 
; This snippet is roughly equivalent to the following C 
; code:
;
; #include <stdio.h>
; main()
; {
;	int rax = 124; // arbitrary value
;	int rbx = 666; // arbitrary value
;	int rcx = rax;
;	printf("in rax: %d\n", rax);
;	printf("in rbx: %d\n", rbx);
;	printf("in rcx: %d\n\n", rcx);
;	rcx = ~(rcx & rbx);
;	rax = ~rax | ~rbx;
;	printf("out rax: %d\n", rax);
;	printf("out rcx: %d\n", rcx);
; }
;

	BITS 64
	SECTION .text
	global main

main:
	mov	rcx,rax		; initialize rax and rcx with the same value
	and	rcx,rbx		; rcx = rcx & rbx
	not	rcx		; rcx = ~rcx

	not	rax		; rax = ~rax
	not	rbx		; rbx = ~rbx
	or	rax,rbx		; rax = rax | rbx

	cmp	rax,rcx		; compare rax and rcx
