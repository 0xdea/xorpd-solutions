;
; $Id: 0x3d_TODO.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x3d explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; TODO: THIS EXPLANATION IS INCOMPLETE
;
; This cryptic snippet returns the following values, for 
; different values of the input parameters rax and rdx:
;
; - if rax is even:
;   - rax = rax + 1
;   - rdx doesn't change
;
; - if rax is odd:
;   - if rdx is even:
;     - rax = rax - 1
;     - rdx = rdx + 1
;   - if rdx is odd:
;     - if ((rax % 4) == 1
;       - rax = rax + 1
;       - rdx = rdx - 1
;     - if ((rax % 4) == 3
;       - rax = [a power of two calculated how? TBC]
;       - rdx = [either rdx + 1 or rdx - rax? TBC]
;
; I've written the following C program to help me
; with the analysis:
;
; #include <stdio.h>
; main()
; {
;         int rax, rdx, rcx;
;         int i, j;
;         for (i = 0; i < 11; i++) {
;                 for (j = 0; j < 11; j++) {
;                         rcx = 1;
;                         rax = i;
;                         rdx = j;
;                         while (rcx != 0) {
;                                 rax = (rax ^ rcx);
;                                 rcx = rcx & (~rax);
;                                 rdx = (rdx ^ rcx);
;                                 rcx = rcx & (~rdx);
;                                 rcx = rcx * 2;
;                         }
;                         printf("rax,rdx:\t%d,%d\t\trax,rdx:\t%d,%d\n",
;                                 i, j, rax, rdx);
;                 }
;                 printf("\n");
;         }
; }
;

	BITS 64

	SECTION .text
	global main

main:
	;mov	rax,7		; added for the analysis
	;mov	rdx,3		; added for the analysis
	mov	rcx,1		; rcx = 1
.loop:
	xor	rax,rcx		;
	not	rax		;
	and	rcx,rax		; rcx = rcx & (~(rax ^ rcx))
	not	rax		; rax = (rax ^ rcx)

	xor	rdx,rcx		;
	not	rdx		;
	and	rcx,rdx		; rcx = rcx & (~(rdx ^ rcx))
	not	rdx		; rdx = (rdx ^ rcx)

	shl	rcx,1		; rcx = rcx * 2
	jnz	.loop		; if (rcx != 0) keep looping
