#include<p16Lf1826.inc>
;
	a		equ		0x25
	c		equ		0x24
	answer	equ 	0x23
	check	equ 	0x22
	remain	equ		0x21
			
;---------------program start---------------;

			org		0x00
			
			movlw	.36
			movwf	a
			movlw	.21
			movwf	c
			movwf	remain
			
			;a/c
loop		movf	c, 0
			subwf	a, 1
			btfss	a, 7
			bra		loop
			
			;remain=a%c
			comf	a, 1
			incf	a, 1
			movf	a, 0
			subwf	c, 0
			movwf	remain
			
			movf	c, 0
			movwf	a			;a=c
			movf	remain, 0
			movwf	c			;c=remain
			movwf	check
			decf	check, 1	;if( remain <= 0 ) skip
			btfss	check, 7	;else keep modding
			bra		loop
			
			movf	a, 0		
			movwf	answer
			movwf	PORTB
			;#goto 	$
			end
			
			
			