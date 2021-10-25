DELAY_100us
    movlw   .33
    movwf   var1
loop1				
    decfsz  var1 
    goto    loop1    
    return ; 100us approx.

DELAY_100ms
    movlw   .0		
    movwf   var1
    movlw   .128
    movwf   var2
loop2				
    decfsz  var1
    goto    loop2
    decfsz  var2
    goto    loop2
    return      ; 100ms approx.
    
DELAY_20ms
    movlw   .0			
    movwf   _256
    movlw   .26
    movwf   _26	
LOOP1
    decfsz  _256
    goto    LOOP1			; (3)*256
    decfsz  _26
    goto    LOOP1			; (3)*256*26 + (3)*26 = 78*256 + 78
    ; 20046+4 = 20.05ms approx. 
    return
    
DELAY_1s
    movlw   .0			
    movwf   _256_1
    movwf   _256_2
    movlw   .5
    movwf   _5
    movlw   .17
    movwf   _17	
    ; 7us approx. in this section
DELAY_1s_LOOP1				
    decfsz  _256_1
    goto    DELAY_1s_LOOP1		; (3)*256^2
    decfsz  _256_2
    goto    DELAY_1s_LOOP1		; (3)*256
    decfsz  _5
    goto    DELAY_1s_LOOP1		; (3)*(256^2+256)*5 + (3)*5 = 15*256^2 + 15*256 + 15
    ; 986,907us approx.
DELAY_1s_LOOP2				
    decfsz  _256_1		
    goto    DELAY_1s_LOOP2		; (3)*256
    decfsz  _17		
    goto    DELAY_1s_LOOP2		; (3)*256*17 + (3)*17 = 51*256 + 51
    ; 13,107us approx.
    ; ===1.000021 seg approx.===
    return
    
TIMER_5s
    movlw   b'00000111'		; Configuración T0CON
    movwf   T0CON, A
    movlw   b'10110011'
    movwf   TMR0H,A
    movlw   b'10110100'
    bcf	    INTCON,2,A
    movwf   TMR0L,A   
    bsf	    T0CON,7,A		; Activa conteo
espera	
    btfsc   INTCON,2,A		; Si se activa la bandera del TIMER, ir a TIME_OUT.
    goto    TIME_OUT
    call    RECORRIDO_JUEGO	; Checar que boton se presiona.
    btfsc   para		; Si se presiono el boton de paro, ir a STOP.
    goto    STOP
    btfsc   correcto		; Si se presiono el boton correcto, regresar.
    return
    btfsc   perdio		; Si se presiono un boton incorrecto, ir a GAME_OVER
    goto    GAME_OVER
    goto    espera		; Si no se ha presionado nada, continuar.
TIME_OUT
    call    _LOADING_CHARS_TIEMPO
    call    SHOW_TIMES_OVER
    call    DELAY_1s
GAME_OVER
    call    ON_RED
    call    DELAY_1s
STOP
    call    _LOADING_CHARS_PERDER
    call    _WRITING_LOSER_ANIM
    call    DELAY_1s
    ; TODO: Imprimir puntaje obtenido.
    call    SHOW_HIGHSCORE
    call    DELAY_1s
    ; TODO: Guardar en la EEPROM si fue highscore.
    bsf	    perdio
    call    DELAY_1s
    return
NIVEL_SUPERADO
    call    ON_GREEN
    call    _LOADING_CHARS_GANAR
    call    _WRITING_WINNER_ANIM
    call    DELAY_1s
    call    SHOW_PUNTAJE
    call    DELAY_1s
    return
    