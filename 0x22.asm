;
; $Id: 0x22.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x22 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet illustrates a clever (if convoluted) way to perform an 
; Euclidean (integer) division by 3 of the value stored in rax. It does 
; so by exploiting the overflow of the unsigned multiplication performed 
; on rax and the constant value 0xaaaaaaaaaaaaaaab (which in binary is
; 0b1010101010101010101010101010101010101010101010101010101010101011).
;
; This analysis was facilitated by the assembly REPL rappel 
; by yrp604@yahoo.com:
;
; https://github.com/yrp604/rappel/
;
; Example:
; $ ./rappel
; > mov rax,5 
; rax: 0x0000000000000005 rdx: 0x0000000000000000
; > mov rdx,0xaaaaaaaaaaaaaaab
; rax: 0x0000000000000005 rdx: 0xaaaaaaaaaaaaaaab
; > mul rdx
; rax: 0x5555555555555557 rdx: 0x0000000000000003
; > shr rdx,1
; rax: 0x5555555555555557 rdx: 0x0000000000000001
; > mov rax,rdx
; rax: 0x0000000000000001 rdx: 0x0000000000000001	<- 5 / 3 = 1
; [...]
; > mov rax,766
; rax: 0x00000000000002fe rdx: 0x0000000000000000
; > mov rdx,0xaaaaaaaaaaaaaaab
; rax: 0x00000000000002fe rdx: 0xaaaaaaaaaaaaaaab
; > mul rdx
; rax: 0xaaaaaaaaaaaaabaa rdx: 0x00000000000001fe
; > shr rdx,1
; rax: 0xaaaaaaaaaaaaabaa rdx: 0x00000000000000ff
; > mov rax,rdx
; rax: 0x00000000000000ff rdx: 0x00000000000000ff	<- 766 / 3 = 255
;

	BITS 64

	SECTION .text
	global main

main:
	mov	rdx,0xaaaaaaaaaaaaaaab	; rdx = 0xaaaaaaaaaaaaaaab
	mul	rdx			; rdx:rax = rax * rdx
	shr	rdx,1			; rdx = (int)rdx / 2
	mov	rax,rdx			; rax = rdx
