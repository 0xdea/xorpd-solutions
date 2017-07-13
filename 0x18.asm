;
; $Id: 0x18.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x18 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet introduces the rdtsc instruction, which
; loads the current value of the processor's timestamp
; counter (a 64-bit Machine State Register) into edx:eax.
; The edx register is loaded with the high-order 32 bits
; of the timestamp and the eax register is loaded with
; the low-order 32 bits. On x86_64, the high-order 32 
; bits of both rax and rdx are cleared.
;
; This snippet simply uses the shift left and or 
; instructions to load the high-order 32 bits of the 
; timestamp stored in edx into the cleared high-order 32 
; bits of rax. It does that two times (the first time
; storing the result in rcx) and then compares the
; results. Of course, the second/newer timestamp stored 
; in rax will always end up being greater than the
; first/older timestamp stored in rcx.
;
; This analysis was facilitated by the assembly REPL rappel 
; by yrp604@yahoo.com:
;
; https://github.com/yrp604/rappel/
; 

	BITS 64
	SECTION .text
	global main

main:
	rdtsc			; load timestamp counter into edx:eax
	shl	rdx,0x20	; left shift rdx by 32 bits
	or	rax,rdx		;
	mov	rcx,rax		; rcx = rax | rdx

	rdtsc			; load timestamp counter into edx:eax
	shl	rdx,0x20	; left shift rdx by 32 bits
	or	rax,rdx		; rax = rax | rdx

	cmp	rcx,rax		; rax (the newer timestamp) will always be
				; greater than rcx (the older timestamp)
				; and therefore the cf flag will be set
