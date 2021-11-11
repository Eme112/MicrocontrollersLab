ON_GREEN
    bsf	    led_verde
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    bcf	    led_verde
    return
 
ON_RED
    bsf	    led_rojo
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    bcf	    led_rojo
    return
    
ON_ORANGE
    bsf	    led_naranja
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    bcf	    led_naranja
    return
    
ON_WHITE
    bsf	    led_blanco
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    bcf	    led_blanco
    return
 
ON_BLUE
    bsf	    led_azul
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    bcf	    led_azul
    return
    
ON_YELLOW
    bsf	    led_amarillo
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    call    DELAY_100ms
    bcf	    led_amarillo
    return
    
    
RANDOM_REGISTER ; REGRESA CON UN NUEVO VALOR EN REGISTRO SHIFTER 00,01,10,11
    clrf    shifter
    movf    TMR2, W, A
    btfsc   WREG, 0, A
    bsf	    shifter, 0, A
    btfsc   WREG, 1, A
    bsf	    shifter, 1, A
DECODER ; PONE sec_aleatoria EN LA MISMA CONFIG QUE boton_presionado
    clrf    sec_aleatoria
    movf    shifter, W, A 
    btfss   STATUS, 2, A		; checa si es 00
    goto    LED_01
    bsf	    sec_aleatoria, 0, A		; significa que 00 -> led azul es el esperado "0001"
    return
    
LED_01
    movf    shifter, W, A 
    sublw   .1
    btfss   STATUS, 2, A		; checa si restando 1 se vuelve 0
    goto    LED_10
    bsf	    sec_aleatoria, 1, A	; significa que 01 -> led amar es el esperado "0010"
    return
    
LED_10 
    movf    shifter, W, A 
    sublw   .2
    btfss   STATUS, 2, A		; checa si restando 1 se vuelve 0
    goto    LED_11
    bsf	    sec_aleatoria, 2, A	; significa que 01 -> led naranj es el esperado "0100"
    return

LED_11 
    bsf	    sec_aleatoria, 3, A	; significa que 11 -> led blanco es el esperado "1000"
    return

ENCENDER_SECUENCIA 
    btfsc   encender_led, 0 , A
    call    ON_BLUE
    btfsc   encender_led, 1,  A
    call    ON_YELLOW
    btfsc   encender_led, 2,  A
    call    ON_ORANGE
    btfsc   encender_led, 3,  A
    call    ON_WHITE
    return