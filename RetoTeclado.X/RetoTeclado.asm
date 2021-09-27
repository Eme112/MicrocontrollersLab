    #include "p18f45k50.inc"
    processor 18f45k50 	; (opcional).
    org 0x00
    goto CONFIGURA
    org 0x08 		; posición para interrupciones.
    retfie
    org 0x18		; posición para interrupciones.
    retfie
    org 0x30 		; Origen real (opcional pero recomendado).
    
; VARIABLES
V1 EQU 0
V2 EQU 1
 
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
    org	0x40				; Código principal.
    
RECORRIDO
    movlw b'11101111'			; ACTIVAR COLUMNA 1 (1, 4, 7, *).
    movwf TRISB, A
    btfss PORTB, 3, A			; Revisar si se presiona el 1.
    goto UNO
    btfss PORTB, 2, A			; Revisar si se presiona el 4.
    goto CUATRO
    btfss PORTB, 1, A			; Revisar si se presiona el 7.
    goto SIETE
    btfss PORTB, 0, A			; Revisar si se presiona el *.
    goto ASTERISCO
    movlw b'11011111'			; ACTIVAR COLUMNA 2 (2, 5, 8, 0).
    movwf TRISB, A
    btfss PORTB, 3, A			; Revisar si se presiona el 2.
    goto DOS
    btfss PORTB, 2, A			; Revisar si se presiona el 5.
    goto CINCO
    btfss PORTB, 1, A			; Revisar si se presiona el 8.
    goto OCHO
    btfss PORTB, 0, A			; Revisar si se presiona el 0.
    goto CERO
    movlw b'10111111'			; ACTIVAR COLUMNA 3 (3, 6, 9, #).
    movwf TRISB, A
    btfss PORTB, 3, A			; Revisar si se presiona el 3.
    goto TRES
    btfss PORTB, 2, A			; Revisar si se presiona el 6.
    goto SEIS
    btfss PORTB, 1, A			; Revisar si se presiona el 9.
    goto NUEVE
    btfss PORTB, 0, A			; Revisar si se presiona el #.
    goto GATO
    movlw b'01111111'			; ACTIVAR COLUMNA 4 (A, B, C, D).
    movwf TRISB, A
    btfss PORTB, 3, A			; Revisar si se presiona el A.
    goto A
    btfss PORTB, 2, A			; Revisar si se presiona el B.
    goto B
    btfss PORTB, 1, A			; Revisar si se presiona el C.
    goto C
    btfss PORTB, 0, A			; Revisar si se presiona el D.
    goto D
    goto RECORRIDO			; Si no se presiona nada, seguir en espera.
    
UNO
    btfss PORTB, 3, A			; Revisar si sigue presionado el 1.
    goto UNO				; Si aun no se suleta, esperar.
    movlw .1
    movwf TRISA, A			; Prender un 1 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
DOS
    btfss PORTB, 3, A			; Revisar si sigue presionado el 2.
    goto DOS				; Si aun no se suleta, esperar.
    movlw .2
    movwf TRISA, A			; Prender un 2 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
TRES
    btfss PORTB, 3, A			; Revisar si sigue presionado el 3.
    goto TRES				; Si aun no se suleta, esperar.
    movlw .3
    movwf TRISA, A			; Prender un 3 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
A
    btfss PORTB, 3, A			; Revisar si sigue presionado el A.
    goto A				; Si aun no se suleta, esperar.
    movlw .10
    movwf TRISA, A			; Prender un 10 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
CUATRO
    btfss PORTB, 2, A			; Revisar si sigue presionado el 4.
    goto CUATRO				; Si aun no se suleta, esperar.
    movlw .4
    movwf TRISA, A			; Prender un 4 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
CINCO
    btfss PORTB, 2, A			; Revisar si sigue presionado el 5.
    goto CINCO				; Si aun no se suleta, esperar.
    movlw .5
    movwf TRISA, A			; Prender un 5 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
SEIS
    btfss PORTB, 2, A			; Revisar si sigue presionado el 6.
    goto SEIS				; Si aun no se suleta, esperar.
    movlw .6
    movwf TRISA, A			; Prender un 6 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
B
    btfss PORTB, 2, A			; Revisar si sigue presionado el B.
    goto B				; Si aun no se suleta, esperar.
    movlw .11
    movwf TRISA, A			; Prender un 11 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
SIETE
    btfss PORTB, 1, A			; Revisar si sigue presionado el 7.
    goto SIETE				; Si aun no se suleta, esperar.
    movlw .7
    movwf TRISA, A			; Prender un 7 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
OCHO
    btfss PORTB, 1, A			; Revisar si sigue presionado el 8.
    goto OCHO				; Si aun no se suleta, esperar.
    movlw .8
    movwf TRISA, A			; Prender un 8 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
NUEVE
    btfss PORTB, 1, A			; Revisar si sigue presionado el 9.
    goto NUEVE				; Si aun no se suleta, esperar.
    movlw .9
    movwf TRISA, A			; Prender un 9 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
C
    btfss PORTB, 1, A			; Revisar si sigue presionado el C.
    goto C				; Si aun no se suleta, esperar.
    movlw .12
    movwf TRISA, A			; Prender un 12 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
ASTERISCO
    btfss PORTB, 0, A			; Revisar si sigue presionado el *.
    goto ASTERISCO			; Si aun no se suleta, esperar.
    movlw b'11110000'
    movwf TRISA, A			; Prender la primera mitad de los LEDs.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
CERO
    btfss PORTB, 0, A			; Revisar si sigue presionado el 0.
    goto CERO				; Si aun no se suleta, esperar.
    movlw .0
    movwf TRISA, A			; Prender un 0 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
GATO
    btfss PORTB, 0, A			; Revisar si sigue presionado el #.
    goto GATO				; Si aun no se suleta, esperar.
    movlw b'00001111'
    movwf TRISA, A			; Prender la segunda mitad de los LEDs.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
D
    btfss PORTB, 0, A			; Revisar si sigue presionado el D.
    goto D				; Si aun no se suleta, esperar.
    movlw .13
    movwf TRISA, A			; Prender un 13 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
    
  end