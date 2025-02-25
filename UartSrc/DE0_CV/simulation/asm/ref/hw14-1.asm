#include<p16Lf1826.inc>
;
		
;---------------program start---------------;
			org		0x00
			
loop		clrw				;w=0
			movwf	PORTB
			clrw
			movwf	PORTB
			movlw	.9			;w=9h
			movwf	PORTB
			movlw	.5
			movwf	PORTB
			movlw	.7
			movwf	PORTB
			movlw	.1
			movwf	PORTB
			movlw	.5
			movwf	PORTB
			movlw	.2
			movwf	PORTB
			goto	loop
			
			end
			
			
			