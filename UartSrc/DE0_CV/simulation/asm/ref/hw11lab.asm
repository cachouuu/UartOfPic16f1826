#include <p16Lf1826.inc>

temp equ 	0x25
count1 equ 	h'20'
count2 equ 	h'21'
count3 equ 	h'22'
	
		org 	0x00
	
		clrf 	temp
		clrw 
		movlw 	1
		movwf 	temp
loop1 	lslf 	temp,1
		movf 	temp,0
		movwf 	PORTB

		movlw .3
		movwf count1
delay1	clrf  count2
delay2	clrf  count3
delay3	decfsz count3,1
		goto   delay3
		decfsz count2,1
		goto   delay2		
		decfsz count1,1
		goto   delay1		

		btfss 	temp,7
		goto 	loop1

loop2	lsrf 	temp,1
		movf 	temp,0
		movwf 	PORTB

		movlw .3
		movwf count1
delay1_	clrf  count2
delay2_	clrf  count3
delay3_	decfsz count3,1
		goto delay3_
		decfsz count2,1
		goto   delay2_		
		decfsz count1,1
		goto   delay1_		

		btfss 	temp,0
		goto 	loop2
		goto 	loop1
		end