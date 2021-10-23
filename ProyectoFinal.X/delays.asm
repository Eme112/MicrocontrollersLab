;#include "inicializacion.asm"
    
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
    goto    LOOP1		; (3)*256
    decfsz  _26
    goto    LOOP1		; (3)*256*26 + (3)*26 = 78*256 + 78
    ; 20046+4 = 20.05ms approx. 
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
    btfsc   correcto		; Si se presiono el boton correcto, continuar.
    return
    goto    espera
TIME_OUT
    call    _SAD_PIXELS
    call    SHOW_TIMES_OVER
GAME_OVER
    call    ON_RED
STOP
    call    _LOADING_CHARS_PERDER
    call    _WRITING_LOSER_ANIM
    ; TODO: Imprimir puntaje obtenido.
    call    SHOW_HIGHSCORE
    ; TODO: Guardar en la EEPROM si fue highscore.
    bsf	    perdio
    return
NIVEL_SUPERADO
    call    ON_GREEN
    call    _LOADING_CHARS_GANAR
    call    _WRITING_WINNER_ANIM
    ; TODO: Mostrar puntaje obtenido.
    return
    