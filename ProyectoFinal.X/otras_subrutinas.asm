;#include "teclado_subrutinas.asm"
    
ON_GREEN
    bsf led_rojo
    call DELAY_100ms
    call DELAY_100ms
    call DELAY_100ms
    call DELAY_100ms
    call DELAY_100ms
    bcf led_rojo
    return
 
ON_RED
    bsf led_verde
    call DELAY_100ms
    call DELAY_100ms
    call DELAY_100ms
    call DELAY_100ms
    call DELAY_100ms
    bcf led_verde
    return
    
    
RANDOM_REGISTER ; REGRESA CON UN NUEVO VALOR EN REGISTRO SHIFTER 00,01,10,11
    clrf    shifter
    movf    TMR2, W, A
    btfsc   WREG, 0, A
    bsf	    shifter, 0, A
    btfsc   WREG, 1, A
    bsf	    shifter, 1, A
  
DECODER ; PONE boton_esperado EN LA MISMA CONFIG QUE boton_presionado
    clrf    boton_esperado
    movf    shifter , W, A 
    btfss   STATUS, 2, A		; checa si es 00
    goto    LED_01
    bsf	    boton_esperado, 0, A	; significa que 00 -> led azul es el esperado "0001"
    return
    
LED_01
    sublw   .1
    btfss   STATUS, 1 , A		; checa si restando 1 se vuelve 0
    goto    LED_10
    bsf	    boton_esperado, 1 , A	; significa que 01 -> led amar es el esperado "0010"
    return
    
LED_10 
    sublw   .1
    btfss   STATUS, 1 , A		; checa si restando 1 se vuelve 0
    goto    LED_11
    bsf	    boton_esperado, 2 , A	; significa que 01 -> led naranj es el esperado "0100"
    return

LED_11 
    bsf	    boton_esperado, 3 , A	; significa que 11 -> led blanco es el esperado "1000"
    return
