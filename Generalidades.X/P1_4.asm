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
	;6->4
	;5->3
	;4->2
	;3->1
	;2->0
	movlw .85
	btfsc WREG, 6, A
	bsf 0x10, 4, A	    ;si esta activo, prender el otro bit
	btfsc WREG, 5, A
	bsf 0x10, 3, A	    ;si esta activo, prender el otro bit
	btfsc WREG, 4, A
	bsf 0x10, 2, A	    ;si esta activo, prender el otro bit
	btfsc WREG, 3, A
	bsf 0x10, 1, A	    ;si esta activo, prender el otro bit
	btfsc WREG, 2, A
	bsf 0x10, 0, A	    ;si esta activo, prender el otro bit
	end