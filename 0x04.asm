;
; $Id: 0x04.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x04 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet flips the 6th least-significant bit (0x20 
; is 0b0100000) of the value stored in rax. Since lowercase 
; and uppercase letters in ascii are separated by a value 
; of 0x20 (A-Z is 0x41-0x5a and a-z is 0x61-0x7a), this 
; operation turns uppercase letters into lowercase and vice 
; versa.
;
; This analysis was facilitated by the assembly REPL rappel 
; by yrp604@yahoo.com:
;
; https://github.com/yrp604/rappel/
;
; Example:
; $ ./rappel
; > mov rax,'A'
; rax: 0x0000000000000041
; > xor al,0x20
; rax: 0x0000000000000061
; [...]
; $ echo -e "\x41 \x61"
; A a
; $ gdb
; (gdb) p/c 0b1000001
; $1 = 65 'A'
; (gdb) p/c 0b1100001
; $2 = 97 'a'
;

	BITS 64
	SECTION .text
	global main

main:
	xor	al,0x20		; flips the 6th bit (0x20 is 0b0100000)
