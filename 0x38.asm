;
; $Id: 0x38.asm,v 1.1.1.1 2016/03/27 08:40:13 raptor Exp $
;
; 0x38 explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; This snippet takes the value in rax and adds it to a value 
; calculated by keeping its least-significant bit and all 
; the following zeros, discarding all previous bits. Here 
; are some example results:
;
; 1   (00000001) -> 2   (00000010) = 00000001 + 1
; 5   (00000101) -> 6   (00000110) = 00000101 + 1
; 7   (00000111) -> 8   (00001000) = 00000111 + 1
; 28  (00011100) -> 32  (00100000) = 00011100 + 100
; 64  (01000000) -> 128 (10000000) = 01000000 + 1000000
; 100 (01100100) -> 104 (01101000) = 01100100 + 100
; 200 (11001000) -> 208 (11010000) = 11001000 + 1000
;
; The weird thing here is that this snippet seems to make
; some useless calculations. For instance, after the shift
; operations, the value in rdx is always 0. Therefore, this
; snippet can be simplified as illustrated by the following
; C helper:
;
; #include <stdio.h>
; main()
; {
; 	int in, out;
; 	for (in = 0; in <= 100; in++) {
; 		out = ((in - 1) | in) + 1;
; 		printf("in:\t%d\t\tout:\t%d\n", in, out);
; 	}
; }
;
; Example run:
; $ ./0x38_helper 
; in:	0		out:	0
; in:	1		out:	2
; in:	2		out:	4
; in:	3		out:	4
; in:	4		out:	8
; in:	5		out:	6
; in:	6		out:	8
; in:	7		out:	8
; [...]
; in:	60		out:	64
; in:	61		out:	62
; in:	62		out:	64
; in:	63		out:	64
; in:	64		out:	128
; in:	65		out:	66
; in:	66		out:	68
; in:	67		out:	68
; [...]
; in:	100		out:	104
;

	BITS 64

	SECTION .text
	global main

main:
	bsf	rcx,rax		; load rcx with the position of the LSB
				; that is set in rax (from position 0)

	mov	rdx,rax		;
	dec	rdx		;
	or	rdx,rax		; rdx = (rax - 1) | rax

	mov	rax,rdx		;
	inc	rax		; rax = ((rax - 1) | rax) + 1

	mov	rbx,rdx		;
	not	rbx		;
	inc	rdx		;
	and	rdx,rbx		;
	dec	rdx		; rdx = ((rdx + 1) & ~rdx) - 1
				
	; rdx = ((((rax - 1) | rax) + 1) & ~((rax - 1) | rax)) - 1
	; i.e. rdx contains n bits set to 1, where n is bsf(rax) + 1

	; rax = ((rax - 1) | rax) + 1

	shr	rdx,cl		; rdx = rdx>>cl
	shr	rdx,1		; rdx = rdx>>1

	; discard all LSBs not set plus the first set LSB in rdx
	; i.e. at this point rdx is always set to 0

	or	rax,rdx		; rax = rax | rdx
