#include	<p16LF1826.inc>

num1		equ 0x25
num2		equ 0x26
cnt			equ 0x22

;***************************************
;           Program start              *
;***************************************

			org 	0x00		; reset vector
			
init		clrf	num1		; ram[25]=0
			clrf	num2
			clrf	cnt
			clrw				; w=0

polling1	btfss 	PIR1, 5
			goto	polling1
			movf	RCREG, 0	; w=RCREG
			addwf	num1, 1		; ram[25]=ram[25]+w

polling2	btfss	PIR1, 5
			goto	polling2
			movf	RCREG, 0	; w=RCREG
			addwf	num2, 1		; ram[26]=ram[26]+w

divide		movf	num2, 0		; w=ram[26]
			subwf	num1, 1		; ram[25]=ram[25]-w
			incf	cnt, 1		; cnt++
			btfss	num1, 7		; if(num1[7]<0) skip
			goto	divide
			decf	cnt, 1		; cnt--
			movf	cnt, 0		; w=cnt
			movwf	TXREG

remainder	comf	num1, 1		; num1=~num1
			incf	num1, 1		; num1++
			movf	num1, 0		; w=num1
			subwf	num2, 0		; w=num2-num1	
			movwf	PORTB	
				
			goto	init
			end