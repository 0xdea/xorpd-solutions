;
; $Id: 0x3e_TODO.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x3e explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; TODO: THIS EXPLANATION IS INCOMPLETE
;
; This snippet is roughly equivalent to the following C 
; code:
;
; #include <stdio.h>
; int number_of_ones(unsigned int x)
; {
;         int total_ones = 0;
;         while (x != 0) {
;                 x = x & (x-1);
;                 total_ones++;
;         }
;         return total_ones;
; }
; main()
; {
;         int in, out;
;         for (in = 0; in < 30; in++) {
;                 out = number_of_ones(in ^ (in>>1)) & 3;
;                 printf("in:\t%d\t\tout:\t%d\n", in, out);
;         }
; }
;
; Example run:
; $ ./0x3e_helper 
; in:	0		out:	0
; in:	1		out:	1
; in:	2		out:	2
; in:	3		out:	1
; in:	4		out:	2
; in:	5		out:	3
; in:	6		out:	2
; in:	7		out:	1
; in:	8		out:	2
; in:	9		out:	3
; [...]
; in:	25		out:	3
; in:	26		out:	0
; in:	27		out:	3
; in:	28		out:	2
; in:	29		out:	3
;
; Once again, its ultimate purpose is not clear to me.
;

	BITS 64

	SECTION .text
	global main

main:
	mov	rdx,rax		;
	shr	rdx,1		;
	xor	rax,rdx		;

	popcnt	rax,rax		;
	and	rax,0x3		; rax = number_of_ones(rax ^ (rax>>1)) & 3
