    #include "p18f45k50.inc"
    processor 18f45k50 	; (opcional).
    org 0x00
    goto CONFIGURA
    org 0x08 		; posición para interrupciones.
    retfie
    org 0x18		; posición para interrupciones.
    retfie
    org 0x30 		; Origen real (opcional pero recomendado).
; Definicion de registros variables.
NUM1	EQU 0x10
NUM2	EQU 0x11
OP	EQU 0x12
TEMP	EQU 0x13
; Definicion de registros para el delay de 20ms.
_256	EQU 0x20
_26	EQU 0x21
; Definicion de equivalencias para bit que representa operaciones.
BIT_SUMA    EQU 7
BIT_RESTA   EQU 6
BIT_MULT    EQU 5
BIT_DIV	    EQU 4
 
CONFIGURA
    movlb .15
    clrf ANSELA, BANKED			; REGA -> DIGITAL.
    clrf ANSELB, BANKED			; REGB -> DIGITAL.
    bcf INTCON2, 7			; ENABLE pull-ups.
    movlw B'00001111'			
    movwf TRISB				; Mitad entradas/salidas.
    movwf WPUB				; Mitad pull-ups.
    clrf TRISA				; REGA -> OUTPUT.
    clrf LATA				; Limpiar la salida A.

NUMERO1
    call RECORRIDO
    movff TEMP, NUM1			; El ultimo numero presionado sera NUM1.
    movwf OP, A				; El ultimo operando presionado sera OP.
    
RECORRIDO
    movlw b'11101111'			; ACTIVAR COLUMNA 1 (1, 4, 7, *).
    movwf LATB, A
    btfss PORTB, 0, A			; Revisar si se presiona el 1.
    goto UNO
    btfss PORTB, 1, A			; Revisar si se presiona el 4.
    goto CUATRO
    btfss PORTB, 2, A			; Revisar si se presiona el 7.
    goto SIETE
    btfss PORTB, 3, A			; Revisar si se presiona el *.
    goto ASTERISCO
    movlw b'11011111'			; ACTIVAR COLUMNA 2 (2, 5, 8, 0).
    movwf LATB, A
    btfss PORTB, 0, A			; Revisar si se presiona el 2.
    goto DOS
    btfss PORTB, 1, A			; Revisar si se presiona el 5.
    goto CINCO
    btfss PORTB, 2, A			; Revisar si se presiona el 8.
    goto OCHO
    btfss PORTB, 3, A			; Revisar si se presiona el 0.
    goto CERO
    movlw b'10111111'			; ACTIVAR COLUMNA 3 (3, 6, 9, #).
    movwf LATB, A
    btfss PORTB, 0, A			; Revisar si se presiona el 3.
    goto TRES
    btfss PORTB, 1, A			; Revisar si se presiona el 6.
    goto SEIS
    btfss PORTB, 2, A			; Revisar si se presiona el 9.
    goto NUEVE
    btfss PORTB, 3, A			; Revisar si se presiona el #.
    goto GATO
    movlw b'01111111'			; ACTIVAR COLUMNA 4 (A, B, C, D).
    movwf LATB, A
    btfss PORTB, 0, A			; Revisar si se presiona el A.
    goto _A_RETURN			; Los operandos son motivo para salir del ciclo.
    btfss PORTB, 1, A			; Revisar si se presiona el B.
    goto _B_RETURN			; Los operandos son motivo para salir del ciclo.
    btfss PORTB, 2, A			; Revisar si se presiona el C.
    goto _C_RETURN			; Los operandos son motivo para salir del ciclo.
    btfss PORTB, 3, A			; Revisar si se presiona el D.
    goto _D_RETURN			; Los operandos son motivo para salir del ciclo.
    goto RECORRIDO			; Si no se presiona un operando, seguir en espera.

; MENU DE BOTONES QUE NO LLEVAN A UN RETURN.
UNO
    btfss PORTB, 0, A			; Revisar si sigue presionado el 1.
    goto UNO				; Si aun no se suleta, esperar.
    movlw .1
    movwf TEMP, A
    movwf LATA, A			; Prender un 1 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
DOS
    btfss PORTB, 0, A			; Revisar si sigue presionado el 2.
    goto DOS				; Si aun no se suleta, esperar.
    movlw .2
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 2 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
TRES
    btfss PORTB, 0, A			; Revisar si sigue presionado el 3.
    goto TRES				; Si aun no se suleta, esperar.
    movlw .3
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 3 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
_A
    btfss PORTB, 0, A			; Revisar si sigue presionado el A.
    goto _A				; Si aun no se suleta, esperar.
    movlw '10000000'			; Se enciende bit de suma.
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 10 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
CUATRO
    btfss PORTB, 1, A			; Revisar si sigue presionado el 4.
    goto CUATRO				; Si aun no se suleta, esperar.
    movlw .4
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 4 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
CINCO
    btfss PORTB, 1, A			; Revisar si sigue presionado el 5.
    goto CINCO				; Si aun no se suleta, esperar.
    movlw .5
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 5 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
SEIS
    btfss PORTB, 1, A			; Revisar si sigue presionado el 6.
    goto SEIS				; Si aun no se suleta, esperar.
    movlw .6
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 6 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
_B
    btfss PORTB, 1, A			; Revisar si sigue presionado el B.
    goto _B				; Si aun no se suleta, esperar.
    movlw '01000000'			; Se enciende bit de resta.
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 11 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
SIETE
    btfss PORTB, 2, A			; Revisar si sigue presionado el 7.
    goto SIETE				; Si aun no se suleta, esperar.
    movlw .7
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 7 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
OCHO
    btfss PORTB, 2, A			; Revisar si sigue presionado el 8.
    goto OCHO				; Si aun no se suleta, esperar.
    movlw .8
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 8 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
NUEVE
    btfss PORTB, 2, A			; Revisar si sigue presionado el 9.
    goto NUEVE				; Si aun no se suleta, esperar.
    movlw .9
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 9 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
_C
    btfss PORTB, 2, A			; Revisar si sigue presionado el C.
    goto _C				; Si aun no se suleta, esperar.
    movlw '00100000'			; Se enciende bit de multiplicacion.
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 12 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
ASTERISCO
    btfss PORTB, 3, A			; Revisar si sigue presionado el *.
    goto ASTERISCO			; Si aun no se suleta, esperar.
    movlw b'11110000'
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender la primera mitad de los LEDs.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
CERO
    btfss PORTB, 3, A			; Revisar si sigue presionado el 0.
    goto CERO				; Si aun no se suleta, esperar.
    movlw .0
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 0 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
GATO
    btfss PORTB, 3, A			; Revisar si sigue presionado el #.
    goto GATO				; Si aun no se suleta, esperar.
    movlw b'00001111'
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender la segunda mitad de los LEDs.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
_D
    btfss PORTB, 3, A			; Revisar si sigue presionado el D.
    goto _D				; Si aun no se suleta, esperar.
    movlw '00010000'			; Se enciende bit de division.
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 13 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
    
; MENU DE BOTONES QUE LLEVAN A UN RETURN.
UNO_RETURN
    btfss PORTB, 0, A			; Revisar si sigue presionado el 1.
    goto UNO_RETURN			; Si aun no se suleta, esperar.
    movlw .1
    movwf LATA, A			; Prender un 1 en binario.
    call DELAY_20ms			; Antirebote.
    return
DOS_RETURN
    btfss PORTB, 0, A			; Revisar si sigue presionado el 2.
    goto DOS_RETURN			; Si aun no se suleta, esperar.
    movlw .2
    movwf LATA, A			; Prender un 2 en binario.
    call DELAY_20ms			; Antirebote.
    return
TRES_RETURN
    btfss PORTB, 0, A			; Revisar si sigue presionado el 3.
    goto TRES_RETURN			; Si aun no se suleta, esperar.
    movlw .3
    movwf LATA, A			; Prender un 3 en binario.
    call DELAY_20ms			; Antirebote.
    return
_A_RETURN
    btfss PORTB, 0, A			; Revisar si sigue presionado el A.
    goto _A_RETURN			; Si aun no se suleta, esperar.
    movlw '10000000'			; Se enciende bit de suma.
    movwf LATA, A			; Prender un 10 en binario.
    call DELAY_20ms			; Antirebote.
    return
CUATRO_RETURN
    btfss PORTB, 1, A			; Revisar si sigue presionado el 4.
    goto CUATRO_RETURN			; Si aun no se suleta, esperar.
    movlw .4
    movwf LATA, A			; Prender un 4 en binario.
    call DELAY_20ms			; Antirebote.
    return
CINCO_RETURN
    btfss PORTB, 1, A			; Revisar si sigue presionado el 5.
    goto CINCO_RETURN			; Si aun no se suleta, esperar.
    movlw .5
    movwf LATA, A			; Prender un 5 en binario.
    call DELAY_20ms			; Antirebote.
    return
SEIS_RETURN
    btfss PORTB, 1, A			; Revisar si sigue presionado el 6.
    goto SEIS_RETURN			; Si aun no se suleta, esperar.
    movlw .6
    movwf LATA, A			; Prender un 6 en binario.
    call DELAY_20ms			; Antirebote.
    return
_B_RETURN
    btfss PORTB, 1, A			; Revisar si sigue presionado el B.
    goto _B_RETURN			; Si aun no se suleta, esperar.
    movlw '00010000'			; Se enciende bit de resta.
    movwf LATA, A			; Prender un 11 en binario.
    call DELAY_20ms			; Antirebote.
    return
SIETE_RETURN
    btfss PORTB, 2, A			; Revisar si sigue presionado el 7.
    goto SIETE_RETURN			; Si aun no se suleta, esperar.
    movlw .7
    movwf LATA, A			; Prender un 7 en binario.
    call DELAY_20ms			; Antirebote.
    return
OCHO_RETURN
    btfss PORTB, 2, A			; Revisar si sigue presionado el 8.
    goto OCHO_RETURN			; Si aun no se suleta, esperar.
    movlw .8
    movwf LATA, A			; Prender un 8 en binario.
    call DELAY_20ms			; Antirebote.
    return
NUEVE_RETURN
    btfss PORTB, 2, A			; Revisar si sigue presionado el 9.
    goto NUEVE_RETURN			; Si aun no se suleta, esperar.
    movlw .9
    movwf LATA, A			; Prender un 9 en binario.
    call DELAY_20ms			; Antirebote.
    return
_C_RETURN
    btfss PORTB, 2, A			; Revisar si sigue presionado el C.
    goto _C_RETURN			; Si aun no se suleta, esperar.
    movlw '00100000'			; Se enciende bit de multiplicacion.
    movwf LATA, A			; Prender un 12 en binario.
    call DELAY_20ms			; Antirebote.
    return
ASTERISCO_RETURN
    btfss PORTB, 3, A			; Revisar si sigue presionado el *.
    goto ASTERISCO_RETURN		; Si aun no se suleta, esperar.
    movlw b'11110000'
    movwf LATA, A			; Prender la primera mitad de los LEDs.
    call DELAY_20ms			; Antirebote.
    return
CERO_RETURN
    btfss PORTB, 3, A			; Revisar si sigue presionado el 0.
    goto CERO_RETURN			; Si aun no se suleta, esperar.
    movlw .0
    movwf LATA, A			; Prender un 0 en binario.
    call DELAY_20ms			; Antirebote.
    return
GATO_RETURN
    btfss PORTB, 3, A			; Revisar si sigue presionado el #.
    goto GATO_RETURN			; Si aun no se suleta, esperar.
    movlw b'00001111'
    movwf LATA, A			; Prender la segunda mitad de los LEDs.
    call DELAY_20ms			; Antirebote.
    return
_D_RETURN
    btfss PORTB, 3, A			; Revisar si sigue presionado el D.
    goto _D_RETURN			; Si aun no se suleta, esperar.
    movlw '00010000'			; Se enciende bit de division.
    movwf LATA, A			; Prender un 13 en binario.
    call DELAY_20ms			; Antirebote.
    return
    
DELAY_20ms
    movlw   .0			
    movwf   _256
    movlw   .26
    movwf   _26	
LOOP1
    decfsz  _256
    goto    LOOP1		; (3)*256
    decfsz  _26
    goto    LOOP1		; (3)*256*26 + (3)*26 = 78*256 + 78
    ; 20046+4 = 20.05ms approx. 
    return
  
;
; CONFIGURATION BITS SETTING, THIS IS REQUIRED TO CONFITURE THE OPERATION OF THE MICROCONTROLLER
; AFTER RESET. ONCE PROGRAMMED IN THIS PRACTICA THIS IS NOT NECESARY TO INCLUDE IN FUTURE PROGRAMS
; IF THIS SETTINGS ARE NOT CHANGED. SEE SECTION 26 OF DATA SHEET. 
;   


; CONFIG1L
  CONFIG  PLLSEL = PLL4X        ; PLL Selection (4x clock multiplier)
  CONFIG  CFGPLLEN = OFF        ; PLL Enable Configuration bit (PLL Disabled (firmware controlled))
  CONFIG  CPUDIV = NOCLKDIV     ; CPU System Clock Postscaler (CPU uses system clock (no divide))
  CONFIG  LS48MHZ = SYS24X4     ; Low Speed USB mode with 48 MHz system clock (System clock at 24 MHz, USB clock divider is set to 4)

; CONFIG1H
  CONFIG  FOSC = INTOSCIO       ; Oscillator Selection (Internal oscillator)
  CONFIG  PCLKEN = ON           ; Primary Oscillator Shutdown (Primary oscillator enabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  nPWRTEN = OFF         ; Power-up Timer Enable (Power up timer disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable (BOR enabled in hardware (SBOREN is ignored))
  CONFIG  BORV = 190            ; Brown-out Reset Voltage (BOR set to 1.9V nominal)
  CONFIG  nLPBOR = OFF          ; Low-Power Brown-out Reset (Low-Power Brown-out Reset disabled)

; CONFIG2H
  CONFIG  WDTEN = OFF           ; Watchdog Timer Enable bits (WDT disabled in hardware (SWDTEN ignored))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscaler (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = RC1          ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<5:0> pins are configured as analog input channels on Reset)
  CONFIG  T3CMX = RC0           ; Timer3 Clock Input MUX bit (T3CKI function is on RC0)
  CONFIG  SDOMX = RB3           ; SDO Output MUX bit (SDO function is on RB3)
  CONFIG  MCLRE = ON            ; Master Clear Reset Pin Enable (MCLR pin enabled; RE3 input disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset (Stack full/underflow will cause Reset)
  CONFIG  LVP = ON              ; Single-Supply ICSP Enable bit (Single-Supply ICSP enabled if MCLRE is also 1)
  CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port Enable (ICPORT disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled)
  
  end