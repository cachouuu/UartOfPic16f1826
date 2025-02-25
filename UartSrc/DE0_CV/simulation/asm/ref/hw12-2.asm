#include	<p16Lf1826.inc>
;

	min			equ 0x23
	sec			equ 0x24
	min_cnt		equ 0x21		;ram[33]
	sec_cnt		equ 0x22		;ram[34]
	
	count1		equ h'20'
	count2		equ h'21'
	count3 		equ h'22'

;****************************	

			org		0x00
		
start		movlw	.59			;w = 59h
			movwf	sec			;sec = w
			movlw	.60			;w = 60h
			movwf	min			;min = w
			clrf	min_cnt		;clear min_cnt
			clrf	sec_cnt		;clear sec_cnt
		
loop_sec	movlw	1			;w = 1
			addwf	sec_cnt, 1	;sec_cnt + 1
			call	delay
			decfsz	sec, 1		;sec--, skip if 0.	d=1, store in f
			bra		loop_sec
		
loop_min	movlw	1
			addwf	min_cnt, 1
			call	delay
			movlw	.59			;w = 59h
			movwf	sec			;reset sec = w
			clrf	sec_cnt		;clear sec_cnt
			decfsz	min, 1		;sec--, skip if 0.	d=1, store in f
			bra		loop_sec
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