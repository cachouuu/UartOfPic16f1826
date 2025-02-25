#include <p16Lf1826.inc>

temp	equ	0x25
	org	0x00
	clrf	temp
	clrw	
	movlw	28
	movwf	temp
	asrf	temp,1
	rlf 	temp,0
	lsrf	temp,1
	lslf 	temp,0
	rrf	temp,1
	swapf	temp,0
	goto	$
	end