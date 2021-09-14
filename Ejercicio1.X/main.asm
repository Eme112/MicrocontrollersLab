	#include "p18f45k50.inc"
	processor 18f45k50 	; (opcional)
	org 0x00
	goto start
	org 0x08 		; posición para interrupciones
	retfie
	org 0x18		; posición para interrupciones
	retfie
	org 0x30 		; Origen real (opcional pero recomendado)
start
REG1 equ 0x42		    ;REG1 = 0x42
IFREG equ 0x30		    ;IFREG = 0x30
BIT2 equ 2		    ;BIT2 = 2
	clrf 0x42, A	    ;clear register.
inverter_right		    ;Inverts from right to left.
	btg REG1, 0, A
	btg REG1, 1, A
	btg REG1, 2, A
	btg REG1, 3, A
	btg REG1, 4, A
	btg REG1, 5, A
	btg REG1, 6, A
	btg REG1, 7, A
	
	setf IFREG, A	    ;Testing
	
	btfss IFREG, BIT2, A    ;Verify bit 2 of 0x030.
	goto inverter_right ;If bit = 0 (continue to inverter_right)
			    ;If bit = 1 (continue to inverter_left)
inverter_left		    ;Inverts from left to right.
	btg REG1, 7, A
	btg REG1, 6, A
	btg REG1, 5, A
	btg REG1, 4, A
	btg REG1, 3, A
	btg REG1, 2, A
	btg REG1, 1, A
	btg REG1, 0, A
	
	btfss IFREG, BIT2, A    ;Verify bit 2 of 0x030.
	goto inverter_right ;If bit = 0 (continue to inverter_right)
	goto inverter_left  ;If bit = 1 (continue to inverter_left)
	
	nop
	end
