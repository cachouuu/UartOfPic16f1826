temp   equ 0x25
count1 equ h'20'
count2 equ h'21'
count3 equ h'22'


	   org 0x00
	   clrf  temp
	   clrw 
	   movlw 1
	   movwf temp
	   
	  
lop1   lslf temp, 1 
	   movf temp, 0
	   movwf PORTB
	   btfss temp, 7
	   goto lop1
lop2   lslf temp, 1 
       movf temp, 0
       movwf PORTB
	   btfss temp, 0
	   goto lop2
	   goto lop1
	   end