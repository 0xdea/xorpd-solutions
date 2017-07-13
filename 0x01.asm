;
; $Id: 0x01.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x01 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet demonstrates an elegant way to generate the
; Fibonacci Sequence: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...
;
; Example:
; uncomment the added lines
; $ nasm -f elf64 0x01.asm
; $ gcc 0x01.o -o 0x01
; $ gdb 0x01
; (gdb) b main.loop
; (gdb) r
; (gdb) i r rax
; rax            0x0	0
; (gdb) c
; (gdb) i r rax
; rax            0x1	1
; (gdb) c
; (gdb) i r rax
; rax            0x1	1
; (gdb) c
; (gdb) i r rax
; rax            0x2	2
; (gdb) c
; (gdb) i r rax
; rax            0x3	3
; (gdb) c
; (gdb) i r rax
; rax            0x5	5
;

	BITS 64
	SECTION .text
	global main

main:
	;mov	rax,0		; initialize the rax register
	;mov	rdx,1 		; initialize the rdx register
.loop:
	xadd	rax,rdx
	loop	.loop
