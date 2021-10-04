#include "p18f45k50.inc"
    processor 18f45k50 	; (opcional).
    org 0x00
    goto CONFIGURA
    org 0x08 		; posición para interrupciones.
    retfie
    org 0x18		; posición para interrupciones.
    retfie
    org 0x30 		; Origen real (opcional pero recomendado).

; DEFINICIÓN DE REGISTROS VARIABLES.
_255 EQU 0x00

 
CONFIGURA
    movlb   .15
    clrf    ANSELA, BANKED			; REGA -> DIGITAL.
    clrf    ANSELB, BANKED			; REGB -> DIGITAL.
    bcf	    INTCON2, 7				; ENABLE pull-ups.
    movlw   B'00111000'			
    movwf   TRISB				; 3 salidas, 3 entradas (una extra por si acaso).
    movwf   WPUB				; habilitar 3 pull ups.
    clrf    TRISA				; REGA -> OUTPUT.
    clrf    LATA				; Limpiar la salida A.