;
; $Id: 0x05.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x05 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; "Fun with flags!" -- Dr. Sheldon Cooper
;
; "[This snippet] allows you to check if a number is between 
; 5-9 using only one jump. I think it's the most vague one on 
; this list. Sorry for that :)" -- xorpd
;
; The jump instructions that can be used are jbe and jna.
;
; While trying to understand this snippet, I had a nice brush
; up on the RFLAGS register. In detail:
;
; cf: carry flag (for sub/cmp, it indicates a borrow)
;     - set when rax = 5,6,7,8 (see sf)
; zf: zero flag (set if sub/cmp produces zero value)
;     - set when rax = 9
; sf: sign flag (set if sub/cmp produced a negative result)
;     - set when rax = 5,6,7,8 (see cf)
; af: adjust flag (set if there is a borrow from the high 
;     nibble to the low), not really relevant here
; of: overflow flag (set if both operands are positive and the 
;     result is negative or if both operands are negative and 
;     the result is positive), not relevant here
; pf: parity flag, not relevant here
;

	BITS 64
	SECTION .text
	global main

main:
	;mov	rax,8		; initialize the rax register
	sub	rax,5		; rax = rax - 5, modify status flags accordigly
	cmp	rax,4		; tmp = rax - 4, modify status flags accordigly
	;jbe	label		; example jump
	;ret			; return if rax is not between 5-9
;label:
	;nop			; only reached if rax is between 5-9
