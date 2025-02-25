#include	<p16Lf1826.inc>
;

temp		equ 0x25
temp1		equ 0x24
count1		equ h'20'
count2		equ h'21'
count3 		equ h'22'

;***************************

		org		0x00

start	movlw	.15
		movwf	temp1		;temp1 = 15h
		clrf	temp		;temp = 0
		clrw				;w = 0
loop1	movlw	1			;w = 1
		addwf	temp, 1		;temp + 1
		movf	temp, 0		;store result in w
		movwf	PORTB		;portb = w
		call	delay		
		decfsz	temp1, 1	;temp1--, skip if 0
		goto	loop1
		movlw	.15
		movwf 	temp1
loop2	movlw	1
		subwf	temp, 1
		movf	temp, 0
		movwf	PORTB
		call	delay
		decfsz	temp1, 1
		goto	loop2
		goto	start

delay	movlw	.30
		movwf	count1
delay1	clrf	count2
delay2	clrf	count3
delay3	decfsz	count3, 1
		goto	delay3
		decfsz	count2, 1
		goto	delay2
		decfsz	count1, 1
		goto	delay1
		return
		end