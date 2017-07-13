;
; $Id: 0x3f_TODO.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x3f explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; TODO: THIS EXPLANATION IS INCOMPLETE
;
; Whoa, this is the last snippet of the book! Thanks to
; xorpd@xorpd.net for the amazing ride!
;
; This snippet calculates the following based on the 
; initial value of rax:
;
; rsi = (rax & (rax - 1)) % 3
; rdi = ((rax | (rax - 1)) % 3) + 1
; rax = position of the least-significant bit set in rax
;
; Unfortunately, so far I haven't figured out its purpose. I
; suspect the outcome of the bsf operation is important here.
; It is always 0 for odd numbers, obviously, and for even
; numbers it goes in a series like: 1, 2, 1, 3, 1, 2, 1, 4, 
; 1, 2, 1, 3, 1, 2, 1, 5... See also:
;
; https://oeis.org/A001511 [The ruler function: 2^a(n) divides 2n]
; https://oeis.org/A007814 [Exponent of highest power of 2 dividing n]
;
; I've written the following C code to help with the analysis:
;
; #include <stdio.h>
; main()
; {
; 	int rsi, rdi, i;
; 	for (i = 1; i <= 100; i++) {
; 		rsi = (i & (i - 1)) % 3;
; 		rdi = ((i | (i - 1)) % 3) + 1;
; 		printf("rax:\t%d\t\trsi,rdi:\t%d,%d\n", i, rsi, rdi);
; 	}
; }
;
; Example run:
; $ ./0x3f_helper
; rax:	1		rsi,rdi:	0,2
; rax:	2		rsi,rdi:	0,1
; rax:	3		rsi,rdi:	2,1
; rax:	4		rsi,rdi:	0,2
; rax:	5		rsi,rdi:	1,3
; rax:	6		rsi,rdi:	1,2
; rax:	7		rsi,rdi:	0,2
; rax:	8		rsi,rdi:	0,1
; rax:	9		rsi,rdi:	2,1
; rax:	10		rsi,rdi:	2,3
; [...]
; rax:	96		rsi,rdi:	1,2
; rax:	97		rsi,rdi:	0,2
; rax:	98		rsi,rdi:	0,1
; rax:	99		rsi,rdi:	2,1
; rax:	100		rsi,rdi:	0,2
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
	mov	rbx,3		;
	mov	r8,rax		; save the original input rax in r8
	mov	rcx,rax		;
	dec	rcx		;

	and	rax,rcx		;
	xor	edx,edx		;
	div	rbx		;
				;
	mov	rsi,rdx		; rsi = (rax & (rax - 1)) % 3

	mov	rax,r8		;
	or	rax,rcx		;
	xor	edx,edx		;
	div	rbx		;
				;
	inc	rdx		;
	cmp	rdx,rbx		; this is a clever hack, although useless here
	sbb	rdi,rdi		; if (rdx > 3) rdi = 0 // impossible
	and	rdi,rdx		; else rdi = ((rax | (rax - 1)) % 3) + 1

	bsf	rax,r8		; load rax with the position of the LSB (from
				; position 0) that is set in the original input 
				; rax, regardless of the other operations
