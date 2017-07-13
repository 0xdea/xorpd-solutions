;
; $Id: 0x1c.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x1c explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This single-instruction snippet loads the value on top
; of the stack (pointed by rsp) into rsp itself. If this
; value is an invalid memory address, it might cause an
; error. For instance, in my setup I have the following:
;
; $ gdb 0x1c
; (gdb) disas main
; Dump of assembler code for function main:
; => 0x00000000004005f0 <+0>:	pop    %rsp
;    0x00000000004005f1 <+1>:	nopw   %cs:0x0(%rax,%rax,1)
;    0x00000000004005fb <+11>:	nopl   0x0(%rax,%rax,1)
; End of assembler dump.
; (gdb) b*0x00000000004005f0
; Breakpoint 1 at 0x4005f0
; (gdb) b*0x00000000004005f1
; Breakpoint 2 at 0x4005f0
; (gdb) i r rsp
; rsp 0x7fffffffe1c8	0x7fffffffe1c8
; (gdb) x/x 0x7fffffffe1c8
; 0x7fffffffe1c8: 0xf7a30d05
; (gdb) c
; Breakpoint 3, 0x00000000004005f1 in main ()
; (gdb) i r rsp
; rsp 0x7ffff7a30d05	0x7ffff7a30d05 <__libc_start_main+245>
; (gdb) c
; Program received signal SIGSEGV, Segmentation fault.
; 0x0000000000400600 in __libc_csu_init ()
; (gdb) disas 0x0000000000400600
; Dump of assembler code for function __libc_csu_init:
; => 0x0000000000400600 <+0>:	push   %r15
;
; At the beginning, rsp points to 0x7fffffffe1c8, which
; contains the address 0xf7a30d05 <__libc_start_main+245>.
; This address is then loaded into rsp. When the program 
; tries to push a value onto the stack (when rip reaches 
; 0x400600 <__libc_csu_init>), a SIGSEGV is generated, 
; because the address 0xf7a30d05 is not writable.
;
; This snippet brings to mind stack pivoting, a technique
; used by what today is called Return-Oriented Programming
; (ROP). Just a fancy name for old-school return-into-libc,
; if you ask me;) Anyway, these are gadgets that point the
; stack pointer to an attacker-owned buffer, effectively
; building a fake stack (usually rax points to an address
; in the heap) and providing more flexibility to carry out
; a complex ROP exploit:
;
; push	rax
; pop	rsp
; ret
;
; or:
;
; xchg	rsp,rax
; ret
;

	BITS 64

	SECTION .text
	global main

main:
	pop	rsp		; load the value on top of the stack (pointed
				; by rsp) into rsp itself, building a new stack
