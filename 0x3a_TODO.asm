;
; $Id: 0x3a_TODO.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x3a explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; TODO: THIS EXPLANATION IS INCOMPLETE
;
; This snippet loads in al a byte from memory, located at 
; [rbx + unsigned al]. Unsigned al is calculated as follows:
;
; - if the original value in rax is odd, al = 0; therefore,
;   load byte [rbx] in al
; - if the original value in rax is even, al is populated
;   with the 6 most-significant bits in rax (not the ones 
;   that overflow in rdx) following the multiplication
;   between the least-significant bit set to 1 plus any 
;   following zeros of the original rax and the hardcoded
;   number 0x218a392cd3d5dbf, which is 151050438420815295 or
;   0b1000011000101000111001001011001101001111010101110110111111.
;
; I couldn't figure out the ultimate purpose of this snippet.
; Specifically, the role of the multiplication overflow (see
; the mul instruction) and the significance of the hardcoded
; number 0x218a392cd3d5dbf are unclear to me at this point.
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
	mov	rdx,rax			;
	neg	rdx			;
	and	rax,rdx			; rax = rax & (0 - rax)

	; this operation returns a value determined by the least-significant 
	; bit set to 1 plus any following zeros, e.g.:
	; in:     0 (0b0)         out:    0 (0b0)
	; in:     1 (0b1)         out:    1 (0b1)
	; in:     2 (0b10)        out:    2 (0b10)
	; in:     3 (0b11)        out:    1 (0b1)
	; in:     4 (0b100)       out:    4 (0b100)
	; in:     5 (0b101)       out:    1 (0b1)
	; in:     6 (0b110)       out:    2 (0b10)
	; the result is always a power of two; it is 1 if rax is odd

	mov	rdx,0x218a392cd3d5dbf	; rdx = 0x218a392cd3d5dbf
	mul	rdx			; rdx:rax = rax * rdx
	shr	rax,0x3a		; rax = rax>>58
					; i.e. keep the 6 most-significant bits

	; if the original input value in rax was odd, the result is 0
	;
	; if the original input value in rax was even, the result is
	; determined by the multiplication between the least-significant
	; bit set to 1 plus any following zeros and the hardcoded number 
	; 0x218a392cd3d5dbf; only the 6 most-significant bits in rax (not
	; the ones that overflow in rdx) are kept

	xlatb				; al = memory byte [rbx + unsigned al]

	; the resulting number is used to load in al a byte from memory, 
	; located at [rbx + unsigned al]
