;
; $Id: 0x1a.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x1a explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This is another variation on the theme of the x86_64 call 
; stack. This snippet manages to load into rax the address 
; of the main.next procedure, by exploiting how the call 
; instruction works. In detail, this is what happens:
;
; 1. The main function calls main.next. In the process,
;    the address of the next instruction (which in this
;    specific case happens to also be the address of
;    main.next) is pushed onto the stack as part of the 
;    activation record of the main.next function.
; 2. The main.next function uses the pop instruction
;    to load the value from the top of the stack (which
;    is the return address, which in this specific case
;    is the address of main.next itself) into rax.
;
; Example:
; $ gdb 0x1a
; (gdb) b main
; Breakpoint 1 at 0x4005f0
; (gdb) b main.next
; Breakpoint 2 at 0x4005f5
; (gdb) b*0x00000000004005f6
; Breakpoint 3 at 0x4005f6
; (gdb) r
; Breakpoint 1, 0x00000000004005f0 in main ()
; (gdb) i r rax rsp
; rax 0x4005f0	4195824
; rsp 0x7fffffffe1c8	0x7fffffffe1c8
; (gdb) x/8x 0x7fffffffe1c8
; 0x7fffffffe1c8: 0xf7a30d05	0x00007fff	0x00000000	0x00000000
; 0x7fffffffe1d8: 0xffffe2a8	0x00007fff	0x00000000	0x00000001
; (gdb) c
; Breakpoint 2, 0x00000000004005f5 in main.next ()
; (gdb) i r rax rsp
; rax 0x4005f0	4195824
; rsp 0x7fffffffe1c0	0x7fffffffe1c0
; (gdb) x/8x 0x7fffffffe1c0
; 0x7fffffffe1c0: 0x004005f5	0x00000000	0xf7a30d05	0x00007fff
; 0x7fffffffe1d0: 0x00000000	0x00000000	0xffffe2a8	0x00007fff
; (gdb) disas 0x4005f5
; Dump of assembler code for function main.next:
;    0x00000000004005f5 <+0>:	pop    %rax
; => 0x00000000004005f6 <+1>:	nopw   %cs:0x0(%rax,%rax,1)
; End of assembler dump.
; (gdb) c
; Breakpoint 3, 0x00000000004005f6 in main.next ()
; (gdb) i r rax rsp
; rax 0x4005f5	4195829
; rsp 0x7fffffffe1c8	0x7fffffffe1c8
; (gdb) x/8x 0x7fffffffe1c8
; 0x7fffffffe1c8: 0xf7a30d05	0x00007fff	0x00000000	0x00000000
; 0x7fffffffe1d8: 0xffffe2a8	0x00007fff	0x00000000	0x00000001
;

	BITS 64

	SECTION .text
	global main

main:
	call	.next		; save procedure linking information on the
				; stack and branch to the main.next procedure
.next:
	pop	rax		; load the return address from the top of the 
				; stack into rax and increment rsp accordingly
