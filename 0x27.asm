;
; $Id: 0x27.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x27 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet performs the following operation:
;
; rax = rax>>((cl>>1) + ((cl + 1)>>1))
;
; It calculates the result of the Euclidean (integer) 
; division of the value in rax by the following values, 
; depending on the initial value stored in the cl 
; register:
;
; 0	>>0			2^0	= 1
; 1	>>1			2^1	= 2
; 2	>>1+2=3			2^3	= 8
; 3	>>1+2+3=6		2^6	= 64
; 4	>>1+2+3+4=10		2^10	= 1024
; 5	>>1+2+3+4+5=15		2^15	= 32768
; 6	>>1+2+3+4+5+6=21	2^21	= 2097152
; 7	>>1+2+3+4+5+6+7=28	2^28	= 268435456
; 8	>>1+2+3+4+5+6+7+8=36	2^36	= 68719476736
; [...]
;
; For instance, if rax = 0xffffffff and cl = 5, the output
; of the snippet will be (int)(0xffffffff / pow(2, 15)) = 
; = (int)(4294967295 / 32768) = (int)131071.99 = 131071 =
; = 0x1ffff.
;
; See also:
; https://en.wikipedia.org/wiki/Triangular_number
; https://oeis.org/A006125
;
; I wrote a short C program to simplify the analysis:
;
; #include <stdio.h>
; #include <stdint.h>
; main()
; {
; 	unsigned char cl;
; 	int64_t rax = 0xffffffff;
; 	int i;
; 	for (i = 0; i < 256; i++) {
; 		cl = i;
; 		printf("cl:\t%u\t\t", cl);
; 		rax = rax>>((cl>>1) + ((cl + 1)>>1));
; 		printf("rax:\t0x%llx\n", rax);
; 	}
; }
;
; Example run:
; $ ./0x27_helper
; cl:	0		rax:	0xffffffff
; cl:	1		rax:	0x7fffffff
; cl:	2		rax:	0x1fffffff
; cl:	3		rax:	0x3ffffff
; cl:	4		rax:	0x3fffff
; cl:	5		rax:	0x1ffff
; cl:	6		rax:	0x7ff
; cl:	7		rax:	0xf
; cl:	8		rax:	0x0
; [...]
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
	mov	ch,cl		;
	inc	ch		; ch = cl + 1
	shr	ch,1		; ch = ch>>1
	shr	cl,1		; cl = cl>>1
	shr	rax,cl		; rax = rax>>cl
	xchg	ch,cl		;
	shr	rax,cl		; rax = rax>>ch
				; i.e. rax = rax>>((cl>>1) + ((cl + 1)>>1))
