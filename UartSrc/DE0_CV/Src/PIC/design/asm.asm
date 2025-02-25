#include <p16Lf1826.inc>

tmp	 	equ 0x25
tmp1 	equ 0x24
sec		equ 0x22
min		equ 0x21
cnt1 	equ h'20'
cnt2 	equ h'21'
cnt3 	equ h'22'
		
		org 0x00
	 
start   movlw 	.59		;w <= 59
		movwf 	tmp1	;move w to f  tmp <= 59
		clrf  	sec     ;clear f
		clrw			;clear w
		movwf 	PORTB
			
lop1	movlw 	1
		addwf 	sec,1
		movf  	sec,0
		movwf 	PORTB
		;call    delay
		decfsz  tmp1,1
		bra    lop1
		bra    start
		
;delay   movlw .30
;		movwf  cnt1
;delay1  clrf   cnt2
;delay2  clrf   cnt3
;delay3  decfsz cnt3,1
;		bra    delay3
;		decfsz cnt2,1
;		bra    delay2
;		decfsz cnt1,1
;		bra    delay1
;		return
		end