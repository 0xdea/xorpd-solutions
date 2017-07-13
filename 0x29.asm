;
; $Id: 0x29.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x29 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet copies rcx bytes of the 3-bytes string
; pointed by rsi to the string pointed by rdi (which is
; located at address rsi + 3).
;
; It illustrates two interesting things: the rep instruction,
; used for block moves of rcx bytes, words, or doublewords;
; and the no-operands movsb instruction.
;
; Example:
; $ gdb 0x29
; [...]
; (gdb) disas main
; Dump of assembler code for function main:
;    0x00000000004005f0 <+0>:	mov    $0x6,%ecx
;    0x00000000004005f5 <+5>:	movabs $0x6009f0,%rsi
; => 0x00000000004005ff <+15>:	lea    0x3(%rsi),%rdi
;    0x0000000000400603 <+19>:	rep movsb %ds:(%rsi),%es:(%rdi)
;    0x0000000000400605 <+21>:	nopw   %cs:0x0(%rax,%rax,1)
;    0x000000000040060f <+31>:	nop
; End of assembler dump.
; (gdb) r
; [...]
; Breakpoint 8, 0x0000000000400603 in main ()
; (gdb) i r rsi rdi rcx
; rsi            0x6009f0	6294000
; rdi            0x6009f3	6294003
; rcx            0x6	6
; (gdb) x/4x 0x6009f0
; 0x6009f0: 0x00434241 0x00000000 0x00000000 0x00000000
; (gdb) c
; [...]
; Breakpoint 9, 0x0000000000400605 in main ()
; (gdb) i r rsi rdi rcx
; rsi            0x6009f6	6294006
; rdi            0x6009f9	6294009
; rcx            0x0	0
; (gdb) x/4x 0x6009f0
; 0x6009f0: 0x41434241 0x42414342 0x00000043 0x00000000
;

	BITS 64

	;SECTION .data		; added for the analysis
	;string1 db "ABC",0	; added for the analysis

	SECTION .text
	global main

main:
	;mov	rcx,6		; added for the analysis
	;mov	rsi,string1	; added for the analysis
	lea	rdi,[rsi + 3]	; rdi = rsi + 3
	rep movsb		; move rcx bytes from address rsi to rdi
