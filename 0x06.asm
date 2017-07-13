;
; $Id: 0x06.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x06 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet sets rax with its initial value, by doing
; the following operations:
;
; 1. bitwise not of rax (one's complement negation)
; 2. rax = rax + 1
; 3. bitwise not of rax + 1 (two's complement negation)
;
; It is structurally equivalent to this (inverted) snippet:
;
; neg	rax
; dec	rax
; not	rax
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
	not	rax		; one's complement negation (bitwise not)
	inc	rax		; rax = rax + 1
	neg	rax		; two's complement negation (bitwise not + 1)
