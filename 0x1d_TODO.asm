;
; $Id: 0x1d_TODO.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x1d explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; TODO: THIS EXPLANATION IS INCOMPLETE
;
; This snippet illustrates the enter instruction, which is
; commonly used together with its companion leave to
; support block structured programming languages (such as
; C): enter is typically the first instruction in a 
; procedure and is used to set up a new stack frame; leave 
; is used at the end of the procedure (just before the ret 
; instruction) to release such stack frame.

; The "enter 0,n+1" instruction creates a stack frame for 
; a procedure with a dynamic storage of 0 bytes and a
; lexical nesting level of n+1. The nesting level 
; determines the number of frame pointers that are copied
; into the display area of the new stack frame from the
; preceding frame.
;
; If the nesting level is 0, the processor pushes the
; frame pointer (rbp) onto the stack, copies the current
; stack pointer (rsp) into rbp, and loads the rsp register
; with the current stack pointer value minus the value in
; the size operand (which is zero in this snippet). For
; nesting levels of 1 or greater, the processor pushes
; additional frame pointers on the stack before adjusting
; the stack pointer.
;
; That being said, I haven't understood yet the purpose
; of this snippet. I suppose this isn't just a convoluted
; way to copy the content of buff1 into buff2 for values
; of n of 1 or greater... See below for a few annotated 
; gdb runs:
; 
; $ gdb 0x1d # n=0
; (gdb) disas main
; Dump of assembler code for function main:
;    0x00000000004005f0 <+0>:	movabs $0x6009fd,%rsp
;    0x00000000004005fa <+10>:	movabs $0x6009f0,%rbp
;    0x0000000000400604 <+20>:	enterq $0x0,$0x1
;    0x0000000000400608 <+24>:	nopl   0x0(%rax,%rax,1)
; End of assembler dump.
; (gdb) b*0x00000000004005fa
; Breakpoint 1 at 0x4005fa
; (gdb) b*0x0000000000400604
; Breakpoint 2 at 0x400604
; (gdb) b*0x0000000000400608
; Breakpoint 3 at 0x400608
; (gdb) r
; Breakpoint 1, 0x00000000004005fa in main ()
; (gdb) i r rsp rbp
; rsp 0x6009fd	0x6009fd
; rbp 0x0	0x0
; (gdb) c
; Breakpoint 2, 0x0000000000400604 in main ()
; (gdb) i r rsp rbp
; rsp 0x6009fd	0x6009fd
; rbp 0x6009f0	0x6009f0
; (gdb) x/x 0x6009fd-8
; 0x6009f5: 0x42424242		<- buff2 is at 0x6009f5
; (gdb) x/x 0x6009f0
; 0x6009f0: 0x41414141		<- buff1 is at 0x6009f0
; (gdb) c
; Breakpoint 3, 0x0000000000400608 in main ()
; (gdb) i r rsp rbp
; rsp 0x6009ed	0x6009ed
; rbp 0x6009f5	0x6009f5
; (gdb) p/d 0x6009f5-0x6009f0
; $1 = 5
; (gdb) p/d 0x6009ed-0x6009fd	<- sub rsp,(n+1)*8 + 8
; $2 = -16
; (gdb) c
; Program received signal SIGSEGV, Segmentation fault.
; 0x00000000006009f5 in buff2 ()
; (gdb) x/x 0x6009f5
; 0x6009f5: 0x006009f0		<- ???
; (gdb) x/x 0x6009f0
; 0x6009f0: 0x00000000		<- ???
; 
; $ gdb 0x1d # n=1
; [...]
; Breakpoint 2, 0x0000000000400604 in main ()
; (gdb) i r rsp rbp
; rsp 0x600a05	0x600a05
; rbp 0x6009f8	0x6009f8
; (gdb) c
; Breakpoint 3, 0x0000000000400608 in main ()
; (gdb) i r rsp rbp
; rsp 0x6009ed	0x6009ed
; rbp 0x6009fd	0x6009fd
; (gdb) p/d 0x6009fd-0x6009f8
; $1 = 5
; (gdb) p/d 0x6009ed-0x600a05	<- sub rsp,(n+1)*8 + 8
; $2 = -24
; (gdb) c
; Program received signal SIGSEGV, Segmentation fault.
; 0x00000000006009fe in ?? ()
; (gdb) i r rsp rbp
; rsp 0x6009f5	0x6009f5
; rbp 0x6009fd	0x6009fd
; (gdb) x/x 0x6009f5
; 0x6009f5: 0x41414141	<- buff2 contains the string that used to be in buff1
; 
; $ gdb 0x1d # n=2
; [...]
; Breakpoint 2, 0x0000000000400604 in main ()
; (gdb) i r rsp rbp
; rsp 0x600a0d	0x600a0d <dtor_idx.6364+5>
; rbp 0x600a00	0x600a00 <completed.6362>
; (gdb) x/x 0x600a0d-24
; 0x6009f5: 0x42424242		<- buff2 is at 0x6009f5
; (gdb) x/x 0x600a00-16
; 0x6009f0: 0x41414141		<- buff1 is at 0x6009f0
; (gdb) c
; Breakpoint 3, 0x0000000000400608 in main ()
; (gdb) i r rsp rbp
; rsp 0x6009ed	0x6009ed
; rbp 0x600a05	0x600a05
; (gdb) p/d 0x600a05-0x600a00
; $1 = 5
; (gdb) p/d 0x6009ed-0x600a0d	<- sub rsp,(n+1)*8 + 8
; $2 = -32
; (gdb) x/x 0x600a05
; 0x600a05: 0x00600a0
; (gdb) x/x 0x6009ed
; 0x6009ed: 0x00600a05
; Program received signal SIGSEGV, Segmentation fault.
; 0x0000000000600a05 in ?? ()
; (gdb) i r rsp rbp
; rsp 0x6009f5	0x6009f5
; rbp 0x600a05	0x600a05
; (gdb) x/x 0x6009f5
; 0x6009f5: 0x41414141	<- buff2 contains the string that used to be in buff1
;

	BITS 64

	;%assign	n	1	; added for the analysis

	;SECTION .data			; added for the analysis
	;buff1 	db 	"AAAA",0	; added for the analysis
	;buff2 	db 	"BBBB",0	; added for the analysis

	SECTION .text
	global main

main:
	mov	rsp,buff2 + n*8 + 8	; load the address of buff2 + n*8 + 8
					; into the stack pointer (rsp)
	mov	rbp,buff1 + n*8		; load the address of buff1 + n*8
					; into the base pointer (rbp)
	enter	0,n+1			; push rbp [i.e.: buff1 + n*8]
					; mov rbp,rsp [i.e.: buff2 + n*8 + 8]
					; [push n+1 additional frame pointers]
					; sub rsp,(n+1)*8 + 8
