#include <p16Lf1826.inc>

min_dec	 	equ 0x83
hou_dec		equ 0x84
min			equ 0x22
hou			equ 0x21
;cnt1 	equ h'20'
;cnt2 	equ h'21'
;cnt3 	equ h'22'
		org 0x00
houclr  movlw 	.24		
		movwf 	hou_dec	 
		clrf  	hou     
		clrw			
		
minclr  movlw 	.59		
		movwf 	min_dec	 
		clrf  	min     
		clrw			

lop		movlw 	1
		addwf 	min,1
		;call    delay
		decfsz  min_dec,1
		bra     lop
		clrf    min
		movlw   1
		addwf 	hou,1
		;call    delay
		decfsz  hou_dec,1
		bra     minclr
		clrf    min
        clrf    hou
		goto $
;delay   movlw .30
;		 movwf  cnt1
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