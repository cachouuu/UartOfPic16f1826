#include	<p16Lf1826.inc>
;

	hour		equ 0x23
	min			equ 0x24
	hour_cnt	equ 0x21		;ram[33]
	min_cnt		equ 0x22		;ram[34]
	
	count1		equ h'20'
	count2		equ h'21'
	count3 		equ h'22'

;****************************	

			org		0x00
		
start		movlw	.59			;w = 59h
			movwf	min			;min = w
			movlw	.24			;w = 24h
			movwf	hour		;hour = w
			clrf	hour_cnt	;clear hour_cnt
			clrf	min_cnt		;clear min_cnt
		
loop_min	movlw	1			;w = 1
			addwf	min_cnt, 1	;min_cnt + 1
			;call	delay
			decfsz	min, 1		;min--, skip if 0.	d=1, store in f
			bra		loop_min
		
loop_hour	movlw	1
			addwf	hour_cnt, 1
			;call	delay
			movlw	.59			;w = 59h
			movwf	min			;reset min = w
			clrf	min_cnt		;clear min_cnt
			decfsz	hour, 1		;hour--, skip if 0.	d=1, store in f
			bra		loop_min
			bra		start
		
delay		movlw	.30
			movwf	count1
delay1		clrf	count2
delay2		clrf	count3
delay3		decfsz	count3, 1
			bra		delay3
			decfsz	count2, 1
			bra		delay2
			decfsz	count1, 1
			bra		delay1
			return
			end
			
			
			
			