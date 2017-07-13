;
; $Id: 0x11.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x11 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet compares two strings, one char at a time.
; Until the two strings differ, the value in rax remains
; 0. The two strings are not modified in the process.
;
; Example:
; $ gdb ./0x11
; (gdb) b main.mov
; Breakpoint 1 at 0x40060b
; (gdb) b main.xor
; Breakpoint 2 at 0x40060d
; (gdb) b main.or 
; Breakpoint 3 at 0x400615
; (gdb) r
; Breakpoint 1, 0x000000000040060b in main.mov ()
; (gdb) x/2x 0x600a00
; 0x600a00:	0x41414141	0x41414141
; (gdb) x/2x 0x600a08
; 0x600a08:	0x42424141	0x42424141
; (gdb) i r al dl 
; al             0x0	0
; dl             0x41	65
; (gdb) c
; Breakpoint 2, 0x000000000040060d in main.xor ()
; (gdb) i r al dl 
; al             0x0	0
; dl             0x0	0
; (gdb) c
; Breakpoint 3, 0x0000000000400615 in main.or ()
; (gdb) i r al dl 
; al             0x0	0
; dl             0x0	0
; [...]
; (gdb) c
; Breakpoint 1, 0x000000000040060b in main.mov ()
; (gdb) i r al dl 
; al             0x0	0
; dl             0x41	65
; (gdb) c
; Breakpoint 2, 0x000000000040060d in main.xor ()
; (gdb) i r al dl 
; al             0x0	0
; dl             0x3	3
; (gdb) c
; Breakpoint 3, 0x0000000000400615 in main.or ()
; (gdb) i r al dl 
; al             0x3	3
; dl             0x3	3
;

	BITS 64

	;SECTION .data		; added for the analysis
	;string1 db "AAAAAAAA"	; added for the analysis
	;string2 db "AABBAABB"	; added for the analysis

	SECTION .text
	global main

main:
	;mov	rsi,string1	; added for the analysis
	;mov	rdi,string2	; added for the analysis
	;mov	rax,0		; added for the analysis
.loop:
	mov	dl,byte [rsi]	; copy the least-significant byte at the
				; memory location pointed by rsi into dl
	xor	dl,byte [rdi]	; xor dl with the least-significant byte
				; at the memory address pointed by rdi
	inc	rsi		; rsi++
	inc	rdi		; rdi++
	or	al,dl		; al = al | dl
				; both registers must contain 0 in order
				; for the result of this operation to be 0
	loop	.loop
