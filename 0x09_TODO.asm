;
; $Id: 0x09_TODO.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x09 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; TODO: THIS EXPLANATION IS INCOMPLETE
;
; For values of rax greater than or equal to zero, this
; snippet performs an Euclidean (integer) division by 8
; of the content of rax and then adds the content of the
; carry flag (cf) to the result. Such flag is set with
; the value of the last bit that was shifted out: in this 
; case, the third least-significant bit (0b100). This
; means that 1 is added for odd values of (int)rax / 4.
;
; The following table illustrates sample inputs and 
; outputs, along with the status of the cf flag:
;
; input		output		cf
; 0-3		0		0
; 4-7		1		1
; 8-11		1		0
; 12-15		2		1
; 16-19		2		0
; 20-23		3		1
; 24-27		3		0
; 28-31		4		1
; 32-35		4		0
; 36-39		5		1
; 40-43		5		0
;
; That being said, I'm not sure of the point of this 
; snippet...
;

	BITS 64
	SECTION .text
	global main

main:
	shr	rax,3		; rax = (int)rax / 8; cf = 1 if 3rd bit is 1
	adc	rax,0		; rax = rax + cf
