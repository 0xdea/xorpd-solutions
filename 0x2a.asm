;
; $Id: 0x2a.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x2a explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet shifts the qword(s) pointed by rbx by 1 
; qword (64 bits) in the stack. For instance, if the 
; string "ABCDEFGHIJKLMNOPPQRSTUVW" (3 qwords) is 
; initially located at address 0x6009f0-0x600a07, this 
; snippet moves it at address 0x6009f8-0x600a0f.
;
; Example:
; $ gdb 0x2a
; (gdb) disas main+18
; Dump of assembler code for function main.loop:
;    0x0000000000400600 <+0>:	lods   %ds:(%rsi),%rax
; => 0x0000000000400602 <+2>:	xchg   %rax,(%rbx)
;    0x0000000000400605 <+5>:	stos   %rax,%es:(%rdi)
;    0x0000000000400607 <+7>:	loop   0x400600 <main.loop>
;    0x0000000000400609 <+9>:	nopl   0x0(%rax)
; End of assembler dump.
; [...]
; (gdb) r
; Breakpoint 8, 0x0000000000400602 in main.loop ()
; (gdb) i r rax rbx rcx rsi rdi
; rax            0x4847464544434241	5208208757389214273
; rbx            0x6009f0	6294000		<- initial address of string
; rcx            0x0	0			<- loop counter
; rsi            0x6009f8	6294008
; rdi            0x6009f0	6294000
; (gdb) x/16x 0x6009f0
; 0x6009f0:	0x44434241	0x48474645	0x4c4b4a49	0x504f4e4d
; 0x600a00:	0x53525150	0x57565554	0x00000000	0x00000000
; 0x600a10:	0x00000000	0x00000000	0x00000000	0x00000000
; 0x600a20:	0x00000000	0x00000000	0x00000000	0x00000000
; [...]
; Breakpoint 10, 0x0000000000400607 in main.loop ()
; (gdb) i r rax rbx rcx rsi rdi
; rax            0x0	0
; rbx            0x6009f0	6294000		<- initial address of string
; rcx            0xfffffffffffffff4	-12	<- loop counter
; rsi            0x600a58	6294104
; rdi            0x600a58	6294104
; (gdb) x/16x 0x6009f0
; 0x6009f0:	0x00000000	0x00000000	0x44434241	0x48474645
; 0x600a00:	0x4c4b4a49	0x504f4e4d	0x53525150	0x57565554
; 0x600a10:	0x00000000	0x00000000	0x00000000	0x00000000
; 0x600a20:	0x00000000	0x00000000	0x00000000	0x00000000
; 

	BITS 64

	;SECTION .data		; added for the analysis
	;string1 db "ABCDEFGH"	; added for the analysis
	;string2 db "IJKLMNOP"	; added for the analysis
	;string3 db "PQRSTUVW"	; added for the analysis

	SECTION .text
	global main

main:
	;mov	rbx,string1	; added for the analysis
	mov	rsi,rbx		; rsi = rbx
	mov	rdi,rbx		; rdi = rbx
.loop:
	lodsq			; load qword at address rsi into rax
	xchg	rax,qword [rbx]	; exchange qword at address rbx with rax
	stosq			; store rax at address rdi
	loop	.loop		; keep looping
