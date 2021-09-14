	#include "p18f45k50.inc"
	processor 18f45k50 	; (opcional)
	org 0x00
	goto configura
	org 0x08 		; posición para interrupciones
	retfie
	org 0x18		; posición para interrupciones
	retfie
	org 0x30 		; Origen real (opcional pero recomendado)
configura			; Configuración
	setf TRISA, A
	?
	; Código principal
	org 0x40


start		
	movlw .1
	movwf 0x10, A
	movlw .2
	movwf 0x11, A
	movlw .3
	movwf 0x12, A
	movlw .4
	movwf 0x13, A
	movlw .5
	movwf 0x14, A
	movlw .6
	movwf 0x15, A	
	
	
	movf 0x10, W, A	    ;save 0x10
	movff 0x15, 0x10    ;move 0x15 to 0x10
	movwf 0x15, A	    ;move prev 0x10 to 0x15
	movf 0x11, W, A	    ;save 0x11
	movff 0x14, 0x11    ;move 0x14 to 0x11
	movwf 0x14, A	    ;move prev 0x11 to 0x14
	movf 0x12, W, A	    ;save 0x12
	movff 0x13, 0x12    ;move 0x13 to 0x12
	movwf 0x13, A	    ;move prev 0x12 to 0x13
	end