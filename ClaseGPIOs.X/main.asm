	#include "p18f45k50.inc"
	org 0x00
	goto start
	
	org 0x40
start	
	movlb .15	    ; BSR = 15
	clrf ANSELB, BANKED ; puerto como I/O digitales
	clrf TRISB, A	    ; activa el puerto B como salida 
	movlw b'00111111'   ; enciende b0-b5
	movwf LATB, A	    ; envía señal a puerto (enciende a-f)
loop	goto loop	
	end