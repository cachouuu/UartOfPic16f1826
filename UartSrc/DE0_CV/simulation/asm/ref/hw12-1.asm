#include	<p16Lf1826.inc>
;

sec_cnt		equ 0x21
sec			equ 0x22

count1		equ h'20'
count2		equ h'21'
count3 		equ h'22'

;****************************	

		org		0x00
		
start	movlw	.59			;w = 59
		movwf	sec			;sec = w
		clrf	sec_cnt		;clear sec_cnt
		clrw				;clear w
		
loop1	movlw	1			;w = 1
		addwf	sec_cnt, 1	;sec_cnt + 1
		movf	sec_cnt, 0	;store result in w
		movwf	PORTB		;portb = w
		call	delay
		decfsz	sec, 1		;sec--, skip if 0.	d=1, store in f
		bra		loop1		;goto loop1
		clrw				;clear w
		movwf	PORTB		;portb = w
		call	delay
		bra		start		;goto start
		
delay	movlw	.30
		movwf	count1
delay1	clrf	count2
delay2	clrf	count3
delay3	decfsz	count3, 1
		bra		delay3
		decfsz	count2, 1
		bra		delay2
		decfsz	count1, 1
		bra		delay1
		return
		end
		
		