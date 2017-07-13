;
; $Id: 0x2c.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x2c explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; Despite having some difficulties with this kind of
; snippets (apparently, it's kinda hard to wrap one's mind
; around operations involving arrays in assembly, at least 
; for me), I managed to solve this one.
;
; Basically, this snippet does the following:
;
; 	if (rcx == rdx) rax = rdi;
; 	else rax = rsi;
;
; It does so by cleverly using the stack as follows. First, 
; it loads a 0 qword (64 bits) into the memory location pointed 
; by rbx + 8*rcx. Then, it loads a 0 qword into the memory
; location pointed by rbx + 8*rdx. If rcx == rdx, the second
; qword (1) overwrites the first one (0). Afterwards, it
; loads the value at memory location rbx + 8*rcx (which can
; either be 0 or 1 based on the values of the rcx and rdx 
; parameters) into the rax register.
;
; After this preparation, this snippet loads the value of rsi
; into the memory location pointed by rbx and the value of
; rdi into the memory location pointed by rbx + 8. Finally,
; the value stored at memory location rbx + 8*rax (which can
; either be rsi or rdi based on the current value of rax) is 
; loaded into the rax register. Pretty straightforward, isn't
; it?;)
;
; Example:
; $ gdb 0x2c # rcx == rdx
; (gdb) disas main
; Dump of assembler code for function main:
;    0x00000000004005f0 <+0>:	movabs $0x600a20,%rbx
;    0x00000000004005fa <+10>:	movabs $0x600a28,%rsi
;    0x0000000000400604 <+20>:	movabs $0x600a30,%rdi
;    0x000000000040060e <+30>:	mov    $0x4,%ecx	<- rcx = 4
;    0x0000000000400613 <+35>:	mov    $0x4,%edx	<- rdx = 4
;    0x0000000000400618 <+40>:	movq   $0x0,(%rbx,%rcx,8)
;    0x0000000000400620 <+48>:	movq   $0x1,(%rbx,%rdx,8)
;    0x0000000000400628 <+56>:	mov    (%rbx,%rcx,8),%rax
;    0x000000000040062c <+60>:	mov    %rsi,(%rbx)
;    0x000000000040062f <+63>:	mov    %rdi,0x8(%rbx)
;    0x0000000000400633 <+67>:	mov    (%rbx,%rax,8),%rax
;    0x0000000000400637 <+71>:	nopw   0x0(%rax,%rax,1)
; End of assembler dump.
; (gdb) b*0x0000000000400637
; (gdb) r
; Breakpoint 10, 0x0000000000400637 in main ()
; (gdb) i r rax rsi rdi
; rax            0x600a30	6294064			<- rax = rdi
; rsi            0x600a28	6294056
; rdi            0x600a30	6294064
; [...]
; (gdb) load 0x2c # rcx != rdx
; (gdb) disas main
; Dump of assembler code for function main:
;    0x00000000004005f0 <+0>:	movabs $0x600a20,%rbx
;    0x00000000004005fa <+10>:	movabs $0x600a28,%rsi
;    0x0000000000400604 <+20>:	movabs $0x600a30,%rdi
;    0x000000000040060e <+30>:	mov    $0x1,%ecx	<- rcx = 1
;    0x0000000000400613 <+35>:	mov    $0x4,%edx	<- rdx = 4
;    0x0000000000400618 <+40>:	movq   $0x0,(%rbx,%rcx,8)
;    0x0000000000400620 <+48>:	movq   $0x1,(%rbx,%rdx,8)
;    0x0000000000400628 <+56>:	mov    (%rbx,%rcx,8),%rax
;    0x000000000040062c <+60>:	mov    %rsi,(%rbx)
;    0x000000000040062f <+63>:	mov    %rdi,0x8(%rbx)
;    0x0000000000400633 <+67>:	mov    (%rbx,%rax,8),%rax
; => 0x0000000000400637 <+71>:	nopw   0x0(%rax,%rax,1)
; End of assembler dump.
; (gdb) r
; Breakpoint 10, 0x0000000000400637 in main ()
; (gdb) i r rax rsi rdi
; rax            0x600a28	6294056			<- rax = rsi
; rsi            0x600a28	6294056
; rdi            0x600a30	6294064
;

	BITS 64

	;SECTION .data			; added for the analysis
	;string0 db 1,2,3,4,5,6,7,8	; added for the analysis
	;string1 db 1,1,1,1,1,1,1,1	; added for the analysis
	;string2 db 2,2,2,2,2,2,2,2	; added for the analysis

	SECTION .text
	global main

main:
	;mov	rbx,string0		; added for the analysis
	;mov	rsi,string1		; added for the analysis
	;mov	rdi,string2		; added for the analysis
	;mov	rcx,1			; added for the analysis
	;mov	rdx,4			; added for the analysis
	mov	qword [rbx + 8*rcx],0	; string[rbx + 8*rcx] = 0
	mov	qword [rbx + 8*rdx],1	; string[rbx + 8*rdx] = 1
	mov	rax,qword [rbx + 8*rcx]	; rax = string[rbx + 8*rcx]
					; i.e. if (rcx == rdx) rax = 1
					; else rax = 0

	mov	qword [rbx],rsi		; string[rbx] = rsi
	mov	qword [rbx + 8],rdi	; string[rbx + 8] = rdi
	mov	rax,qword [rbx + 8*rax]	; rax = string[rbx + 8*rax]
					; i.e. if (rcx == rdx) rax = rdi
					; else rax = rsi
