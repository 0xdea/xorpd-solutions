;
; $Id: title.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; title explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; The title of the book translates to a nop instruction.
;
; Usage:
; $ nasm title.asm 
; $ od -x title   
; 0000000 9048
; 0000002
; $ nasm -f elf64 title.asm
; $ gcc title.o -o title
; $ gdb title
; (gdb) disas main
; Dump of assembler code for function main:
; => 0x00000000004005f0 <+0>:	rex.W nop
;    0x00000000004005f2 <+2>:	nopw   %cs:0x0(%rax,%rax,1)
;    0x00000000004005fc <+12>:	nopl   0x0(%rax)
; End of assembler dump.
;

	BITS 64
	SECTION .text
	global main

main:
	xchg	rax,rax		; this is the nop instruction (0x90)
