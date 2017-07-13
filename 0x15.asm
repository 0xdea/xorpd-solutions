;
; $Id: 0x15.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x15 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; "Sign extension is the operation of increasing the number
; of bits of a binary number while preserving the number's
; sign (positive/negative) and value. This is done by
; appending digits to the most significant side of the
; number." -- https://en.wikipedia.org/wiki/Sign_extension
;
; Assuming the upper half of rax is zero, this snippet sign 
; extends eax (32-bit) into rax (64-bit). See also the cdqe
; x86_64 intruction. An alternative way to write it would be 
; (h/t to harold at http://bitmath.blogspot.it/):
; 
; mov	edx,0x80000000		; sign extend to 33 bits by carrying into
; add	rax,rdx			; the lowest bit of the upper half of rax
; xor	rax,rdx			; and then restoring the lower half (eax)
;
; mov	rdx,0xffffffff00000000	; two's complement negation ~(x - 1)
; add	rax,rdx			; applied only to the upper half of rax
; xor	rax,rdx			; that turns 0x00000001 into 0xffffffff
; 
; This analysis was facilitated by the assembly REPL rappel 
; by yrp604@yahoo.com:
;
; https://github.com/yrp604/rappel/
;
; Example:
; $ ./rappel
; > mov eax,5
; rax: 0x0000000000000005 rbx: 0x0000000000000000 
; rcx: 0x0000000000000000 rdx: 0x0000000000000000
; > mov rdx,0xffffffff80000000
; rax: 0x0000000000000005 rbx: 0x0000000000000000 
; rcx: 0x0000000000000000 rdx: 0xffffffff80000000
; > add rax,rdx
; rax: 0xffffffff80000005 rbx: 0x0000000000000000 
; rcx: 0x0000000000000000 rdx: 0xffffffff80000000
; > xor rax,rdx
; rax: 0x0000000000000005 rbx: 0x0000000000000000 
; rcx: 0x0000000000000000 rdx: 0xffffffff80000000
; [...]
; > mov eax,-5
; rax: 0x00000000fffffffb rbx: 0x0000000000000000 
; rcx: 0x0000000000000000 rdx: 0x0000000000000000
; > mov rdx,0xffffffff80000000
; rax: 0x0000000000000005 rbx: 0x0000000000000000 
; rcx: 0x0000000000000000 rdx: 0xffffffff80000000
; > add rax,rdx
; rax: 0x000000007ffffffb rbx: 0x0000000000000000 
; rcx: 0x0000000000000000 rdx: 0xffffffff80000000
; > xor rax,rdx
; rax: 0xfffffffffffffffb rbx: 0x0000000000000000 
; rcx: 0x0000000000000000 rdx: 0xffffffff80000000
; [...]
; (gdb) p/d 0xfffffffffffffffb
; $1 = -5
;

	BITS 64
	SECTION .text
	global main

main:
	;mov	rax,-5			; added for the analysis
	mov	rdx,0xffffffff80000000	; 0b10000000000000000000000000000000
	add	rax,rdx			; rax = rax + 0xffffffff80000000
	xor	rax,rdx			; rax = rax ^ 0xffffffff80000000
