RECORRIDO_JUEGO
    movlw   b'11111011'			; ACTIVAR COLUMNA 1 (verde, naranja).
    movwf   LATB, A
    btfss   fila1			; Revisar si se presiona el boton de START/STOP.
    call    BOTON_START_STOP
    btfss   fila2			; Revisar si se presiona el boton naranja.
    call    BOTON_NARANJA
    movlw   b'11110111'			; ACTIVAR COLUMNA 2 (blanco, azul).
    movwf   LATB, A
    btfss   fila1			; Revisar si se presiona el boton blanco.
    call    BOTON_BLANCO
    btfss   fila2			; Revisar si se presiona el boton azul.
    call    BOTON_AZUL
    movlw   b'11101111'			; ACTIVAR COLUMNA 3 (rojo, amarillo).
    movwf   LATB, A
    ;btfss   fila1			; Revisar si se presiona el boton de HIGHSCORE.
    ;call    BOTON_HIGHSCORE
    btfss   PORTB, 1, A			; Revisar si se presiona el boton amarillo.
    call    BOTON_AMARILLO
    return
    
RECORRIDO_MENU
    movlw   b'11111011'			; ACTIVAR COLUMNA 1 (START/STOP, naranja).
    movwf   LATB, A
    btfss   fila1			; Revisar si se presiona el boton de START/STOP.
    goto    BOTON_START_MENU
    movlw   b'11101111'			; ACTIVAR COLUMNA 3 (HIGHSCORE, amarillo).
    movwf   LATB, A
    btfss   fila1			; Revisar si se presiona el boton de HIGHSCORE.
    goto    BOTON_HIGHSCORE
    goto    RECORRIDO_MENU
    
BOTON_START_STOP
    btfss   fila1			; Revisar si sigue presionado el boton.
    goto    BOTON_START_STOP		; Si aun no se suleta, esperar.
    movlw   '0'
    movwf   puntaje
    call    DELAY_20ms			; Antirebote.
    bsf	    para			; Encender bit de que se presiono STOP.
    return
BOTON_NARANJA
    bsf	    led_naranja			; Prender el LED.
    btfss   fila2			; Revisar si sigue presionado el boton.
    goto    BOTON_NARANJA		; Si aun no se suleta, esperar.
    bcf	    led_naranja			; Apagar el LED.
    clrf    boton_presionado		; Limpiar el registro.
    bsf	    bit_led_naranja		; Encender el bit representativo del LED naranja.
    call    DELAY_20ms			; Antirebote.
    call    REVISAR_BOTON
    return
BOTON_BLANCO
    bsf	    led_blanco			; Prender el LED.
    btfss   fila1			; Revisar si sigue presionado el boton.
    goto    BOTON_BLANCO		; Si aun no se suleta, esperar.
    bcf	    led_blanco			; Apagar el LED.
    clrf    boton_presionado		; Limpiar el registro.
    bsf	    bit_led_blanco		; Encender el bit representativo del LED blanco.
    call    DELAY_20ms			; Antirebote.
    call    REVISAR_BOTON
    return
BOTON_AZUL
    bsf	    led_azul			; Prender el LED.
    btfss   fila2			; Revisar si sigue presionado el boton.
    goto    BOTON_AZUL			; Si aun no se suleta, esperar.
    bcf	    led_azul			; Apagar el LED.
    clrf    boton_presionado		; Limpiar el registro.
    bsf	    bit_led_azul		; Encender el bit representativo del LED azul.
    call    DELAY_20ms			; Antirebote.
    call    REVISAR_BOTON
    return
BOTON_AMARILLO
    bsf	    led_amarillo		; Prender el LED.
    btfss   fila2			; Revisar si sigue presionado el boton.
    goto    BOTON_AMARILLO		; Si aun no se suleta, esperar.
    bcf	    led_amarillo		; Apagar el LED.
    clrf    boton_presionado		; Limpiar el registro.
    bsf	    bit_led_amarillo		; Encender el bit representativo del LED amarillo.
    call    DELAY_20ms			; Antirebote.
    call    REVISAR_BOTON
    return
    
BOTON_START_MENU
    btfss   fila1			; Revisar si sigue presionado el boton.
    goto    BOTON_START_MENU		; Si aun no se suleta, esperar.
    call    DELAY_20ms			; Antirebote.
    call    ON_GREEN
    goto    JUEGO
    
BOTON_HIGHSCORE
    btfss   fila1			; Revisar si sigue presionado el boton.
    goto    BOTON_HIGHSCORE		; Si aun no se suleta, esperar.
    call    DELAY_20ms			; Antirebote.
    call    ON_RED
    goto    PUNTAJES    
    
REVISAR_BOTON
    movf    boton_esperado, W, A		; Se resta boton_esperado - boton_presionado.
    subwf   boton_presionado, W, A		; Si son iguales, la resta debe dar 0.
    movf    WREG, W, A				; Se activa STATUS para WREG.
    btfss   STATUS, Z, A			; Se revisa el bit de CERO en STATUS.
    bsf	    perdio				; Si no da 0, no era el boton correcto, pierde.
    btfsc   STATUS, Z, A			; Se revisa el bit de CERO en STATUS.
    bsf	    correcto				; Si era 0, activa el bit de correcto.
    return