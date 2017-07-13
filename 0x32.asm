;
; $Id: 0x32.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x32 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet illustrates the following property:
;
; (number_of_ones(rax ^ (rax>>1)) ^ rax) & 1 = 0
; [number_of_ones() counts the number of bits set to 1]
;
; It always returns 0 regardless of the initial input.
;
; Only even numbers return 0 when they are and'ed with 1. 
; Therefore, we must demonstrate that the operation 
; number_of_ones(rax ^ (rax>>1)) ^ rax always returns an 
; even number. This means that if rax is odd, then also
; number_of_ones(rax ^ (rax>>1)) must be odd; conversely,
; if rax is even, then number_of_ones(rax ^ (rax>>1)) 
; must also be even.
;
; The following C code shows exactly that:
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
;         int i;
;         for (i = 0; i < 20; i++)
;                 printf("in:\t%d\t\tout:\t%d\n",
;                         i, number_of_ones(i ^ (i>>1)));
; }
;
; Example run:
; $ ./0x32_helper
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
; in:	10		out:	4
; [...]
;
; This happens because:
; number_of_ones(odd_bits ^ odd_bits) = even_number
; number_of_ones(even_bits ^ even_bits) = even_number
; number_of_ones(odd_bits ^ even_bits) = odd_number
; number_of_ones(even_bits ^ odd_bits) = odd_number
;
; And:
; 00: even_number_even_bits>>1 = even_bits
; 01: odd_number_odd_bits>>1 = even_bits
; 10: even_number_odd_bits>>1 = odd_bits
; 11: odd_number_even_bits>>1 = odd bits
;
; Therefore:
; number_of_ones(00 ^ 00) ^ 00 = 00 ^ 00 = 00 (even)
; number_of_ones(01 ^ 00) ^ 01 = 01 ^ 01 = 00 (even)
; number_of_ones(10 ^ 01) ^ 10 = 10 ^ 10 = 00 (even)
; number_of_ones(11 ^ 01) ^ 11 = 01 ^ 11 = 10 (even)
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
	mov	rcx,rax		; rcx = rax

	mov	rdx,rax		; rdx = rax
	shr	rdx,1		; rdx = rdx>>1
	xor	rax,rdx		; rax = rax ^ rdx
				; i.e. rax = rax ^ (rax>>1)

	popcnt	rax,rax		; rax = number_of_ones(rax)
	xor	rax,rcx		; rax = rax ^ rcx
	and	rax,1		; rax = rax & 1
				; i.e. rax = (number_of_ones(rax) ^ rax) & 1

				; i.e. rax=(number_of_ones(rax^(rax>>1))^rax)&1
