#include "Part1.asm"
 
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
    goto _A
    btfss PORTB, 1, A			; Revisar si se presiona el B.
    goto _B
    btfss PORTB, 2, A			; Revisar si se presiona el C.
    goto _C
    btfss PORTB, 3, A			; Revisar si se presiona el D.
    goto _D
    goto RECORRIDO			; Si no se presiona nada, seguir en espera.
    
UNO
    btfss PORTB, 3, A			; Revisar si sigue presionado el 1.
    goto UNO				; Si aun no se suleta, esperar.
    movlw .1
    movwf LATA, A			; Prender un 1 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
DOS
    btfss PORTB, 3, A			; Revisar si sigue presionado el 2.
    goto DOS				; Si aun no se suleta, esperar.
    movlw .2
    movwf LATA, A			; Prender un 2 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
TRES
    btfss PORTB, 3, A			; Revisar si sigue presionado el 3.
    goto TRES				; Si aun no se suleta, esperar.
    movlw .3
    movwf LATA, A			; Prender un 3 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
_A
    btfss PORTB, 3, A			; Revisar si sigue presionado el A.
    goto _A				; Si aun no se suleta, esperar.
    movlw .10
    movwf LATA, A			; Prender un 10 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
CUATRO
    btfss PORTB, 2, A			; Revisar si sigue presionado el 4.
    goto CUATRO				; Si aun no se suleta, esperar.
    movlw .4
    movwf LATA, A			; Prender un 4 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
CINCO
    btfss PORTB, 2, A			; Revisar si sigue presionado el 5.
    goto CINCO				; Si aun no se suleta, esperar.
    movlw .5
    movwf LATA, A			; Prender un 5 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
SEIS
    btfss PORTB, 2, A			; Revisar si sigue presionado el 6.
    goto SEIS				; Si aun no se suleta, esperar.
    movlw .6
    movwf LATA, A			; Prender un 6 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
_B
    btfss PORTB, 2, A			; Revisar si sigue presionado el B.
    goto _B				; Si aun no se suleta, esperar.
    movlw .11
    movwf LATA, A			; Prender un 11 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
SIETE
    btfss PORTB, 1, A			; Revisar si sigue presionado el 7.
    goto SIETE				; Si aun no se suleta, esperar.
    movlw .7
    movwf LATA, A			; Prender un 7 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
OCHO
    btfss PORTB, 1, A			; Revisar si sigue presionado el 8.
    goto OCHO				; Si aun no se suleta, esperar.
    movlw .8
    movwf LATA, A			; Prender un 8 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
NUEVE
    btfss PORTB, 1, A			; Revisar si sigue presionado el 9.
    goto NUEVE				; Si aun no se suleta, esperar.
    movlw .9
    movwf LATA, A			; Prender un 9 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
_C
    btfss PORTB, 1, A			; Revisar si sigue presionado el C.
    goto _C				; Si aun no se suleta, esperar.
    movlw .12
    movwf LATA, A			; Prender un 12 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
ASTERISCO
    btfss PORTB, 0, A			; Revisar si sigue presionado el *.
    goto ASTERISCO			; Si aun no se suleta, esperar.
    movlw b'11110000'
    movwf LATA, A			; Prender la primera mitad de los LEDs.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
CERO
    btfss PORTB, 0, A			; Revisar si sigue presionado el 0.
    goto CERO				; Si aun no se suleta, esperar.
    movlw .0
    movwf LATA, A			; Prender un 0 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
GATO
    btfss PORTB, 0, A			; Revisar si sigue presionado el #.
    goto GATO				; Si aun no se suleta, esperar.
    movlw b'00001111'
    movwf LATA, A			; Prender la segunda mitad de los LEDs.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
_D
    btfss PORTB, 0, A			; Revisar si sigue presionado el D.
    goto _D				; Si aun no se suleta, esperar.
    movlw .13
    movwf LATA, A			; Prender un 13 en binario.
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

  end