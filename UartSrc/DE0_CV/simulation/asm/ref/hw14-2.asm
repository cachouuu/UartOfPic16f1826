#include<p16Lf1826.inc>
;
	a		equ		0x25
	c		equ		0x24
	answer	equ 	0x23
	cnt		equ 	0x22
			
;---------------program start---------------;
			
			org		0x00
			
			movlw	.5
			movwf	a
			movlw	.3
			movwf	c
			movwf	cnt
			clrf	answer
			
loop		movf	a, 0			; w=f
			addwf	answer, 1		; f=f+w
			decfsz	cnt, 1			; if( (cnt--)==0 ) break;
			goto	loop	
			movf	answer, 0   	; w=f
			movwf	PORTB
			end
			
			