;
; $Id: 0x1e_TODO.asm,v 1.1.1.1 2016/03/27 08:40:12 raptor Exp $
;
; 0x1e explanation - from xchg rax,rax by xorpd@xorpd.net
; Copyright (c) 2016 Marco Ivaldi <raptor@0xdeadbeef.info>
;
; TODO: THIS EXPLANATION IS INCOMPLETE
;
; This was a weird one. First of all, the das instruction 
; is not valid in 64-bit mode, therefore this snippet needs 
; specific compiler and linker options to be compiled in 
; 32-bit (see example below). The das instruction adjusts 
; the result of the subtraction of two packed BCD values in 
; al to create a packed BCD result in al. It is only useful 
; when it follows a sub instruction that subtracts one
; 2-digit packed BCD value from another and stores a byte 
; result in the al register. The das instruction then
; adjusts the contents of the al register to contain the
; correct 2-digit packed BCD result.
;
; A short digression about Binary-Coded Decimal (BCD) is 
; needed. The term packed BCD implies the encoding of two 
; decimal digits within a single byte, by taking advantage of 
; the fact that 4 bits are enough to represent the range 0-9. 
; The following table represents decimal digits from 0 to 9 
; in the Simple Binary-Coded Decimal (SBCD) method or BCD 8421
; (see https://en.wikipedia.org/wiki/Binary-coded_decimal for
; the other variants) used by IA32:
;
; 0	0000
; 1	0001
; 2	0010
; 3	0011
; 4	0100
; 5	0101
; 6	0110
; 7	0111
; 8	1000
; 9	1001
;
; For example, using this encoding the number 87 is represented
; by the binary 10000111.
;
; This snippet takes the value in al (e.g. 0x87) and subtracts
; from it the hardcoded value 0x69, treating them as BCD values
; (e.g. 0x87 - 0x69 = 0x18). Inputs lower than zero are treated 
; slightly differently (see cf flag) and results not between 0 and
; 100 are converted to modulo 100. The following C code emulates
; this behavior for all inputs ranging from 0 to 99:
;
; #include <stdio.h>
; main()
; {
;	int i, o;
;	int c = 69;
;	for (i = 0; i < 100; i++) {
;		o = (100 + (i - c)) % 100;
;		if (i < 10) o--;
;		printf("in: %3d\t\t", i);
;		printf("out: %3d\n", o);
;	}
; }
;
; Running it, we get the following results:
; $ ./0x1e_helper
; in:   0		out:  30
; in:   1		out:  31
; in:   2		out:  32
; in:   3		out:  33
; in:   4		out:  34
; in:   5		out:  35
; in:   6		out:  36
; in:   7		out:  37
; in:   8		out:  38
; in:   9		out:  39
; in:  10		out:  41
; [...]
; in:  66		out:  97
; in:  67		out:  98
; in:  68		out:  99
; in:  69		out:   0
; in:  70		out:   1
; [...]
; in:  97		out:  28
; in:  98		out:  29
; in:  99		out:  30
;
; This is all well and good, but I haven't understood what 
; is the real purpose of this snippet... What is the 
; significance of hardcoded values, especially of 0x69 (which 
; is 01101001 in BCD)? Why are we treating inputs from 0 to 9
; differently? What are we trying to achieve here? I guess
; only xorpd knows;)
;
; Example:
; $ nasm -felf32 0x1e.asm
; $ gcc -m32 0x1e.o -o 0x1e
; $ gdb 0x1e # al=0x87
; (gdb) disas main
; Dump of assembler code for function main:
;    0x080484e0 <+0>:	mov    $0x9,%al
;    0x080484e2 <+2>:	cmp    $0xa,%al
;    0x080484e4 <+4>:	sbb    $0x69,%al
;    0x080484e6 <+6>:	das    
;    0x080484e7 <+7>:	xchg   %ax,%ax	<- notice the cool 32-bit nops here;)
;    0x080484e9 <+9>:	xchg   %ax,%ax
;    0x080484eb <+11>:	xchg   %ax,%ax
;    0x080484ed <+13>:	xchg   %ax,%ax
;    0x080484ef <+15>:	nop
; End of assembler dump.
; (gdb) b*0x080484e7
; (gdb) i r eax
; eax 0x18	24	<- 87 - 69 = 18
;

	BITS 32			; changed from 64 to 32 for the analysis

	SECTION .text
	global main

main:
	;mov	al,0x87		; added for the analysis
	cmp	al,0x0a		; if (al < 10) cf = 1
				; else cf = 0
	sbb	al,0x69		; al = al - 105 - cf [0x69 is 01101001]
	das			; adjust al to contain the correct 2-digit
				; packed BCD result of the subtraction
