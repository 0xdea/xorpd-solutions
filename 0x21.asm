;
; $Id: 0x21.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x21 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet takes 4 parameters as input (rax, rbx, rcx,
; and rdx) and calculates the following 2 outputs:
;
; rax = rax*rcx - rbx*rdx
; rbx = rax*rdx + rbx*rcx
;
; My high school algebra is more than a little rusty, but
; this reminds me of the multiplication of complex numbers:
;
; (a,b) * (c,d) = (ac - bd, ad + bc)
;
; I guess that's it! As a bonus, here's the helper program 
; that I put together to speed up my analysis:
;
; #include <stdio.h>
; main()
; {
; 	int rax = 1;
; 	int rbx = 2;
; 	int rcx = 3;
; 	int rdx = 4;
; 	int rsi = rax;
; 	int rdi = rdx;
; 	int rax_out, rbx_out;
; 	printf("rax: %d\n", rax);
; 	printf("rbx: %d\n", rbx);
; 	printf("rcx: %d\n", rcx);
; 	printf("rdx: %d\n\n", rdx);
; 	/*
; 	rax = rax + rbx;
; 	rdx = rdx - rcx;
; 	rdi = rdi + rcx;
; 	rax = rax * rcx;
; 	rsi = rsi * rdx;
; 	rdi = rdi * rbx;
; 	rsi = rsi + rax;
; 	rbx = rsi;
; 	rax = rax - rdi;
; 	*/
; 	rax_out = rax*rcx - rbx*rdx;
; 	rbx_out = rax*rdx + rbx*rcx;
; 	printf("rax: %d\n", rax_out);
; 	printf("rbx: %d\n", rbx_out);
; 	/*
; 	printf("rcx: %d\n", rcx);
; 	printf("rdx: %d\n", rdx);
; 	printf("rsi: %d\n", rsi);
; 	printf("rdi: %d\n", rdi);
; 	*/
; }
; 

	BITS 64

	SECTION .text
	global main

main:
	;mov	rax,1		; added for the analysis
	;mov	rbx,2		; added for the analysis
	;mov	rcx,3		; added for the analysis
	;mov	rdx,4		; added for the analysis

	mov	rsi,rax		; rsi = rax
	add	rax,rbx		; rax = rax + rbx
	mov	rdi,rdx		; rdi = rdx
	sub	rdx,rcx		; rdx = rdx - rcx
	add	rdi,rcx		; rdi = rdi + rcx

				; rax is rax + rbx
				; rbx is unchanged
				; rcx is unchanged
				; rdx is rdx - rcx
				; rsi is rax
				; rdi is rdx + rcx

	imul	rax,rcx		; rax = rax * rcx
	imul	rsi,rdx		; rsi = rsi * rdx
	imul	rdi,rbx		; rdi = rdi * rbx

				; rax is (rax + rbx) * rcx
				; rbx is unchanged
				; rcx is unchanged
				; rdx is rdx - rcx
				; rsi is rax * (rdx - rcx)
				; rdi is rbx * (rdx + rcx)
				
	add	rsi,rax		; rsi = rsi + rax
	mov	rbx,rsi		; rbx = rsi
	sub	rax,rdi		; rax = rax - rdi

				; rax is (rax + rbx) * rcx - rbx * (rdx + rcx) =
				; = rax*rcx + rbx*rcx - rdx*rbx - rcx*rbx =
				; = rax*rcx - rbx*rdx
				; rbx is rax * (rdx - rcx) + (rax + rbx) * rcx =
				; = rax*rdx - rax*rcx + rax*rcx + rbx*rcx =
				; = rax*rdx + rbx*rcx
				; rcx is unchanged
				; rdx is rdx - rcx
				; rsi is rax * (rdx - rcx) + (rax + rbx) * rcx =
				; = rax*rdx - rax*rcx + rax*rcx + rbx*rcx =
				; = rax*rdx + rbx*rcx
				; rdi is rbx * (rdx + rcx)

				; rax = rax*rcx - rbx*rdx
				; rbx = rax*rdx + rbx*rcx
