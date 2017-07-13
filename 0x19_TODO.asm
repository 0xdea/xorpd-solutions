;
; $Id: 0x19_TODO.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x19 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet plays with the x86_64 call stack, which
; should be very familiar to exploit developers;) It 
; illustrates how to call a C function from assembly code 
; (see http://www.nasm.us/doc/nasmdoc9.html#section-9.1.2).
;
; I believe the intent of this snippet is to make the external 
; function "print_str" print the string "hello world!", 
; which is hardcoded in the .text of main in a part of the 
; code that never gets executed. I have fiddled with this, 
; with an helper mini-library I created and gdb (handy 
; commands: disass addr+4, b*addr, x/s) but I was unable to 
; reproduce the (most likely) intended behavior in practice.
;
; However, I've discovered a few interesting things:
;
; - The pseudo instruction that declares the string
;   "hello world!" never gets executed, because 
;   main.skip never returns.
; - The address of this string is pushed onto the
;   stack as the saved rip of main to return to
;   after main.skip. This way, it can be used as
;   the parameter to the "print_str" external
;   function.
; - Bonus: when it doesn't cause a SEGFAULT, the 
;   "print_str" function gets executed twice, 
;   because its .text is located after the main.skip 
;   code (at least in my setup).
;
; I consider this to still be in the TODO state, because 
; I'd like to come back to it in the future and see if 
; I've missed something (especially with the helper 
; mini-library in which my "print_str" is defined).
;
; Example:
; $ cat lib0x19.c
; #include <stdio.h>
; void print_str(char *c)
; {
; 	printf("%s\n", c);
; }
; $ gcc -c -fPIC lib0x19.c -o lib0x19.a
; $ nasm -felf64 0x19.asm
; $ gcc 0x19.o -L. -l0x19 -o 0x19
; $ gdb 0x19
; [...]
; (gdb) disass main
; Dump of assembler code for function main:
;    0x0000000000400630 <+0>:	callq  0x400642 <main.skip>
;    0x0000000000400635 <+5>:	pushq  $0x6f6c6c65
;    0x000000000040063a <+10>:	and    %dh,0x6f(%rdi)
;    0x000000000040063d <+13>:	jb     0x4006ab <__libc_csu_init+59>
;    0x000000000040063f <+15>:	and    %eax,%fs:(%rax)
; End of assembler dump.
; (gdb) x/s 0x0000000000400635
; 0x400635 <main+5>:	"hello world!"
; (gdb) disass 0x400642 
; Dump of assembler code for function main.skip:
;    0x0000000000400642 <+0>:	callq  0x40064c <print_str>
;    0x0000000000400647 <+5>:	add    $0x8,%rsp
;    0x000000000040064b <+9>:	nop
; End of assembler dump.
; (gdb) disass 0x000000000040064b+4
; Dump of assembler code for function print_str:
;    0x000000000040064c <+0>:	push   %rbp
;    0x000000000040064d <+1>:	mov    %rsp,%rbp
;    0x0000000000400650 <+4>:	sub    $0x10,%rsp
;    0x0000000000400654 <+8>:	mov    %rdi,-0x8(%rbp)
;    0x0000000000400658 <+12>:	mov    -0x8(%rbp),%rax
;    0x000000000040065c <+16>:	mov    %rax,%rdi
;    0x000000000040065f <+19>:	callq  0x4004b0 <puts@plt>
;    0x0000000000400664 <+24>:	leaveq 
;    0x0000000000400665 <+25>:	retq   
; End of assembler dump.
;

	BITS 64

	SECTION .text
	global main
	;extern print_str		; added for the analysis

main:
	call	.skip			; save procedure linking information
					; on the stack and branch to the
					; main.skip procedure
	db	'hello world!',0	; this pseudo-instruction declares
					; the string "hello world!"; it is
					; never executed
.skip:
	call	print_str		; save procedure linking information
					; on the stack and branch to the
					; external print_str function
	add	rsp,8			; release 8 bytes of stack space
