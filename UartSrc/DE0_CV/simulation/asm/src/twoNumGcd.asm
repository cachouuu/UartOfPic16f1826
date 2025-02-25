#include	<p16LF1826.inc>

num1		equ 0x25
num2		equ 0x26
ans			equ	0x23
check		equ	0x22
remain		equ	0x21

;***************************************
;           Program start              *
;***************************************

			org 	0x00		; reset vector
			
init		clrf	ans
			clrf 	check
			clrf	remain
			clrf	num1
			clrf 	num2
			clrw				; w=0

polling1	btfss 	PIR1, 5
			goto	polling1
			movf	RCREG, 0	; w=RCREG
			clrf	PIR1
			movwf	num1		; ram[25]=w

polling2	btfss	PIR1, 5
			goto	polling2
			movf	RCREG, 0	; w=RCREG				0819
			clrf	PIR1		;						0191
			movwf	num2		; ram[26]=w				00A6
			movwf	remain		; remain=w				00A1

divide		movf	num2, 0		; w=num2				0826
			subwf	num1, 1		; num1=num1-w 			02a5
			btfss	num1, 7		; if(num1[7]<0) skip	1fa5	
			goto	divide		; 						33fc(bra)

remainder	comf	num1, 1		; num1=~num1			09a5
			incf	num1, 1		; num1++				0aa5
			movf	num1, 0		; w=num1				0825
			subwf	num2, 0		; w=num2-num1			0226
			movwf	remain		;						00A1

			movf	num2, 0		; w=num2				0826						
			movwf	num1		; num1=2				00a5
			movf	remain, 0	; w=remain				0821	
			movwf	num2		; num2=w				00a6
			movwf	check		;						00a2
			decf 	check, 1	;						03a2
			btfss	check, 7	;						ifa2				
			goto	divide		;						33ef(bra)

			movf 	num1, 0		;						0825
			movwf	TXREG		;						009a
				
			goto	init		;						2800
			end