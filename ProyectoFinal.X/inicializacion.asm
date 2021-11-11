#include "p18f45k50.inc"
    processor 18f45k50 	; (opcional).
    org 0x00
    goto CONFIGURA
    org 0x08 		; posición para interrupciones.
    retfie
    org 0x18		; posición para interrupciones.
    retfie
    org 0x30 		; Origen real (opcional pero recomendado).

; DEFINICION DE EQUIVALENCIAS.
var1		    EQU 0x00
var2		    EQU 0x01
var3		    EQU 0x02
_256		    EQU 0x03
_26		    EQU 0x04
puntaje		    EQU 0x05
boton_presionado    EQU 0x06
boton_esperado	    EQU 0x07
register_loser	    EQU 0x08
shifter		    EQU 0x09
trayectoria	    EQU 0x0A
encender_led	    EQU 0x0B
sec_aleatoria	    EQU 0x0C
sec1		    EQU 0x11
sec2		    EQU 0x12
sec3		    EQU 0x13
sec4		    EQU 0x14
sec5		    EQU 0x15
sec6		    EQU 0x16
sec7		    EQU 0x17
sec8		    EQU 0x18
sec9		    EQU 0x19
sec10		    EQU 0x1A
_256_1		    EQU 0x20
_256_2		    EQU 0x21
_5		    EQU 0x22
_17		    EQU 0x23


; DEFINICION DE LEDS Y BIT REPRESENTATIVO DE CADA COLOR.
    #define led_azul		LATA, 0, A
    #define led_amarillo	LATA, 1, A
    #define led_naranja		LATA, 2, A
    #define led_blanco		LATA, 3, A
    #define led_rojo		LATA, 4, A
    #define led_verde		LATA, 5, A
    #define fila1		PORTB, 0, A
    #define fila2		PORTB, 1, A
    #define bit_led_azul	boton_presionado, 0, A
    #define bit_led_amarillo	boton_presionado, 1, A
    #define bit_led_naranja	boton_presionado, 2, A
    #define bit_led_blanco	boton_presionado, 3, A
    #define RS			LATC, 0, A		; RB0 -> Register Select.
    #define RW			LATC, 1, A		; RB2 -> Read/Write.
    #define E			LATC, 2, A		; RB1 -> Enable.
    #define flag		PORTD, 7, A		; RD7 -> Busy flag.
    #define configFlag		TRISD, 7, A		; Switch flag from INPUT to OUTPUT and viceversa.
    #define dataLCD		LATD, A
    #define perdio		trayectoria, 0, A	; Se activa este bit cuando el usuario pierde.
    #define correcto		trayectoria, 1, A	; Se activa cuando se presiona el boton correcto.
    #define para		trayectoria, 2, A	; Se activa este bit cuando el usuario presiona el boton de paro.
    
CONFIGURA
    movlb   .15
    clrf    ANSELA, BANKED			; REGA -> DIGITAL.
    clrf    ANSELB, BANKED			; REGB -> DIGITAL.
    clrf    ANSELC, BANKED			; REGC -> DIGITAL.
    clrf    ANSELD, BANKED			; REGD -> DIGITAL.
    bcf	    INTCON2, 7				; ENABLE pull-ups.
    movlw   B'00000011'			
    movwf   TRISB				; 3 salidas, 2 entradas.
    movwf   WPUB				; habilitar 2 pull ups.
    clrf    TRISA				; REGA -> OUTPUT.
    clrf    TRISC				; REGC-> OUTPUT.
    clrf    TRISD				; REGD -> OUTPUT.
    clrf    LATA				; Limpiar la salida A.
    clrf    LATC				; Limpiar la salida C.
    clrf    LATD				; Limpiar la salida D.
    setf    PR2, A				; CONFIGURA E INICIA TIMER2 PARA EL NUM ALEATORIO
    movlw   b'00000100'				; TMR2 ON, 1:1 , NO POST
    movwf   T2CON
    movlw   '0'
    movwf   puntaje, A
    bcf	    perdio				; Asegura que empieza desactivada la opcion de perder.
    bcf	    correcto				; Asegura que empieza desactivada el bit de boton correcto.
    bcf	    para				; Asegura que empieza desactivada la opcion de STOP.
    goto    MAIN