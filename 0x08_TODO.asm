;
; $Id: 0x08_TODO.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x08 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; TODO: THIS EXPLANATION IS INCOMPLETE
;
; For positive values of rax and rdx, this snippet performs
; an Euclidean (integer) division by two of the sum of the
; rax and rdx registers. In C:
;
; rax = rax + rdx;
; rax = (int)rax / 2;
;
; This also works when both rax and rdx have a negative
; value, because of the clever use of the rcr instruction
; (right rotate with carry) that uses the carry flag (cf): 
; it shifts cf into the most-significant bit and shifts 
; the least-significant bit into cf. When one of the input 
; values is positive and the other is negative and their 
; sum is also negative, however, we get another result:
;
; $ ./rappel
; > mov rax,1
; > mov rdx,-2
; rax: 0x0000000000000001 rbx: 0x0000000000000000 
; rcx: 0x0000000000000000 rdx: 0xfffffffffffffffe
; > add rax,rdx
; rax: 0xffffffffffffffff rbx: 0x0000000000000000
; rcx: 0x0000000000000000 rdx: 0xfffffffffffffffe
; flags: 0x0000000000000286 [cf:0, zf:0, of:0, sf:1, pf:0, af:0]
; > rcr rax,1
; rax: 0x7fffffffffffffff rbx: 0x0000000000000000
; rcx: 0x0000000000000000 rdx: 0xfffffffffffffffe
; flags: 0x0000000000000a87 [cf:1, zf:0, of:0, sf:1, pf:0, af:0]
;
; For this reason, I suspect this explanation might be 
; incomplete.
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
	add	rax,rdx		; rax = rax + rdx
	rcr	rax,1		; right rotate with carry
