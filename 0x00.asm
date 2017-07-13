;
; $Id: 0x00.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x00 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This is the snippet #0: it sets registers to 0 in different ways.
;
; Example:
; uncomment the added lines
; $ nasm -f elf64 0x00.asm
; $ gcc 0x00.o -o 0x00
; $ gdb 0x00
; (gdb) b debug
; (gdb) r
; (gdb) i r
; rax            0x0	0
; rbx            0x0	0
; rcx            0x0	0
; rdx            0x0	0
; rsi            0x0	0
; rdi            0x0	0
; rbp            0x0	0x0
; [...]
;

	BITS 64
	SECTION .text
	global main

main:
	xor	eax,eax		; set rax to 0 by xor'ing it with itself
	lea	rbx,[0]		; set rbx to 0 by loading the value 0 into it
	;mov	ecx,10		; added to make the following loop faster
	loop	$		; set rcx to 0 by decrementing it via loop
	mov	rdx,0 		; set rdx to 0 using the mov instruction
	and	esi,0		; set rsi to 0 by and'ing it with 0
	sub	edi,edi		; set rdi to 0 by subtracting its current value
	push	0
	pop	rbp		; set rbp to 0 using push and pop instructions
