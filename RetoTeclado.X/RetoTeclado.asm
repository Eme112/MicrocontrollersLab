    #include "p18f45k50.inc"
    processor 18f45k50 	; (opcional).
    org 0x00
    goto CONFIGURA
    org 0x08 		; posición para interrupciones.
    retfie
    org 0x18		; posición para interrupciones.
    retfie
    org 0x30 		; Origen real (opcional pero recomendado).

; Definicion de filas (entradas).
    #define f1 PORTB, 5, A
    #define f2 PORTB, 6, A
    
; Equivalencias para el delay de 20ms.
_256	EQU 20
_26	EQU 21
 
CONFIGURA
    movlb .15
    clrf ANSELA, BANKED			; REGA -> DIGITAL.
    clrf ANSELB, BANKED			; REGB -> DIGITAL.
    bcf INTCON2, 7			; ENABLE pull-ups.		
    clrf TRISA				; REGA -> OUTPUT.
    movlw b'01100000'	
    movwf TRISB				; Configurar entradas y salidas RB.
    movwf WPUB				; Configurar pull ups.
    clrf LATA				; Apagar todos los LEDs.
    
RECORRIDO
    movlw b'11111110'			; ACTIVAR COLUMNA 1 (1, 2).
    movwf LATB, A
    btfss f1				; Revisar si se presiona el 1.
    goto UNO
    btfss f2				; Revisar si se presiona el 2.
    goto DOS
    movlw b'11111101'			; ACTIVAR COLUMNA 2 (3, 4).
    movwf LATB, A
    btfss f1				; Revisar si se presiona el 3.
    goto TRES
    btfss f2				; Revisar si se presiona el 4.
    goto CUATRO
    movlw b'11111011'			; ACTIVAR COLUMNA 3 (5, 6).
    movwf LATB, A
    btfss f1				; Revisar si se presiona el 5.
    goto CINCO
    btfss f2				; Revisar si se presiona el 6.
    goto SEIS
    movlw b'11110111'			; ACTIVAR COLUMNA 4 (7, 8).
    movwf LATB, A
    btfss f1				; Revisar si se presiona el 7.
    goto SIETE
    btfss f2				; Revisar si se presiona el 8.
    goto OCHO
    movlw b'11101111'			; ACTIVAR COLUMNA 5 (9, 0).
    movwf LATB, A
    btfss f1				; Revisar si se presiona el 9.
    goto NUEVE
    btfss f2				; Revisar si se presiona el 0.
    goto CERO
    goto RECORRIDO			; Si no se presiona nada, seguir en espera.
    
UNO
    btfss f1				; Revisar si sigue presionado el 1.
    goto UNO				; Si aun no se suleta, esperar.
    movlw .1
    movwf LATA, A			; Prender un 1 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
DOS
    btfss f2				; Revisar si sigue presionado el 2.
    goto DOS				; Si aun no se suleta, esperar.
    movlw .2
    movwf LATA, A			; Prender un 2 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
TRES
    btfss f1				; Revisar si sigue presionado el 3.
    goto TRES				; Si aun no se suleta, esperar.
    movlw .3
    movwf LATA, A			; Prender un 3 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
CUATRO
    btfss f2				; Revisar si sigue presionado el 1.
    goto CUATRO				; Si aun no se suleta, esperar.
    movlw .4
    movwf LATA, A			; Prender un 4 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
CINCO
    btfss f1				; Revisar si sigue presionado el 1.
    goto CINCO				; Si aun no se suleta, esperar.
    movlw .5
    movwf LATA, A			; Prender un 5 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
SEIS
    btfss f2				; Revisar si sigue presionado el 1.
    goto SEIS				; Si aun no se suleta, esperar.
    movlw .6
    movwf LATA, A			; Prender un 6 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
SIETE
    btfss f1				; Revisar si sigue presionado el 1.
    goto SIETE				; Si aun no se suleta, esperar.
    movlw .7
    movwf LATA, A			; Prender un 7 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
OCHO
    btfss f2				; Revisar si sigue presionado el 1.
    goto OCHO				; Si aun no se suleta, esperar.
    movlw .8
    movwf LATA, A			; Prender un 8 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
NUEVE
    btfss f1				; Revisar si sigue presionado el 1.
    goto NUEVE				; Si aun no se suleta, esperar.
    movlw .9
    movwf LATA, A			; Prender un 9 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
CERO
    btfss f2				; Revisar si sigue presionado el 1.
    goto CERO				; Si aun no se suleta, esperar.
    movlw .0
    movwf LATA, A			; Prender un 0 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
    
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