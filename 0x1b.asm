;
; $Id: 0x1b.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x1b explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This is yet another variation on the theme of the x86_64 
; call stack. This snippet puts the address in rax on top 
; of the stack (via the push instruction) and then transfers
; program control to the instruction(s) located at such
; address. Because in my setup rax is initialized to the
; address of main, this effectively creates an infinite loop.
;
; Example:
; $ gdb 0x1b
; (gdb) disas main
; Dump of assembler code for function main:
;    0x00000000004005f0 <+0>:	push   %rax
;    0x00000000004005f1 <+1>:	retq   
;    0x00000000004005f2 <+2>:	nopw   %cs:0x0(%rax,%rax,1)
;    0x00000000004005fc <+12>:	nopl   0x0(%rax)
; End of assembler dump.
; (gdb) b*0x00000000004005f0
; Breakpoint 1 at 0x4005f0
; (gdb) b*0x00000000004005f1
; Breakpoint 2 at 0x4005f1
; (gdb) b*0x00000000004005f2
; Breakpoint 3 at 0x4005f2
; (gdb) r
; Breakpoint 1, 0x00000000004005f0 in main ()
; (gdb) i r rax rsp rip
; rax 0x4005f0	4195824
; rsp 0x7fffffffe1c8	0x7fffffffe1c8
; rip 0x4005f0	0x4005f0 <main>
; (gdb) x/x 0x7fffffffe1c8
; 0x7fffffffe1c8: 0xf7a30d05
; (gdb) c
; Breakpoint 2, 0x00000000004005f1 in main ()
; (gdb) i r rax rsp rip
; rax 0x4005f0	4195824
; rsp 0x7fffffffe1c0	0x7fffffffe1c0
; rip 0x4005f1	0x4005f1 <main+1>
; (gdb) x/x 0x7fffffffe1c0
; 0x7fffffffe1c0: 0x004005f0
; (gdb) c
; Breakpoint 1, 0x00000000004005f0 in main ()
; [...]
; Breakpoint 3 is never reached.
;

	BITS 64

	SECTION .text
	global main

main:
	push	rax		; decrement rsp and store rax on top of stack
	ret			; transfer program control to the return
				; address located on top of the stack
