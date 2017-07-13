;
; $Id: 0x36.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x36 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; For positive integer values of rax, this snippet 
; calculates the next power of two, using a pretty cool
; technique.
;
; This analysis was facilitated by the assembly REPL rappel 
; by yrp604@yahoo.com:
;
; https://github.com/yrp604/rappel/
;
; Example:
; $ gdb 0x36
; [...]
; (gdb) b*0x0000000000400636
; (gdb) r 	<- rax = 1027
; Breakpoint 1, 0x0000000000400636 in main ()
; (gdb) i r rax
; rax            0x800	2048
; (gdb) load
; (gdb) r	<- rax = 2049
; Breakpoint 1, 0x0000000000400636 in main ()
; (gdb) i r rax
; rax            0x1000	4096
; (gdb) load
; (gdb) r	<- rax = 0x11111111
; Breakpoint 1, 0x0000000000400636 in main ()
; (gdb) i r rax
; rax            0x20000000	536870912
;

	BITS 64

	SECTION .text
	global main

main:
	dec	rax		; rax = rax - 1

	mov	rdx,rax		;
	shr	rdx,0x1		;
	or	rax,rdx		; rax = (rax) | ((rax)>>1)

	mov	rdx,rax		;
	shr	rdx,0x2		;
	or	rax,rdx		; rax = (rax) | ((rax)>>2)

	mov	rdx,rax		;
	shr	rdx,0x4		;
	or	rax,rdx		; rax = (rax) | ((rax)>>4)

	mov	rdx,rax		;
	shr	rdx,0x8		;
	or	rax,rdx		; rax = (rax) | ((rax)>>8)

	mov	rdx,rax		;
	shr	rdx,0x10	;
	or	rax,rdx		; rax = (rax) | ((rax)>>16)

	mov	rdx,rax		;
	shr	rdx,0x20	;
	or	rax,rdx		; rax = (rax) | ((rax)>>32)

	inc	rax		;
