#include	<p16LF1826.inc>

num1		equ 0x25

;***************************************
;           Program start              *
;***************************************

			org 	0x00		; reset vector
			
init		clrf	num1		; ram[25]=0
			clrw				; w=0

polling1	btfss 	PIR1, 0x05
			goto	polling1
			movf	RCREG, 0	; w=RCREG
			addwf	num1, 1		; ram[25]=ram[25]+w

polling2	btfss	PIR1, 0x05
			goto	polling2
			movf	RCREG, 0	; w=RCREG
			addwf	num1, 0		; w=ram[25]+w
			movwf	TXREG
			
			goto	init
			end