#include<p16Lf1826.inc>
;
	a		equ		0x25
	c		equ		0x24
	answer	equ 	0x23
	cnt		equ 	0x22
	remain	equ		0x21
			
;---------------program start---------------;

			org		0x00
				
			movlw	.21
			movwf	a
			movlw	.3
			movwf	c
			clrw	
			movwf	cnt
			movwf	remain
;a/c
loop		movf	c, 0		; w=f
			subwf	a, 1		; f=f-w
			incf	cnt, 1  	; f=f+1
			btfss	a, 7		; if( a[7]<0 ) skip
			goto	loop	
			decf	cnt, 1 		; f=f-1
			movf	cnt, 0		; w=f
			movwf	answer
			movwf	PORTB	
;a%c				
			comf	a, 1		; f=~f
			incf	a, 1		; f=f+1
			movf	a, 0   		; w=f (w=-a)
			subwf	c, 0		; w=f-w 
			movwf	remain
			end
			
			