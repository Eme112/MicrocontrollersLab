    #include "p18f45k50.inc"
    processor 18f45k50 	; (opcional).
    
    org 0x00
    goto PORTS_CONFIG
    org 0x08 		; posición para interrupciones.
    retfie
    org 0x18		; posición para interrupciones.
    retfie

; DEFINICION DE REGISTROS.
CONFIG0	equ 0x00
TIMER0L	equ 0x01
TIMER0H	equ 0X02
_256	equ 0x10
_26	equ 0x11

PORTS_CONFIG
    org 0x30
    movlb   .15
    clrf    ANSELA, BANKED
    clrf    ANSELD, BANKED
    clrf    TRISA			; REGA --> LEDs, salidas.
    setf    TRISD			; REGD --> Botones, entradas.
    clrf    LATA  
    
; Menu principal.
MENU_START
    btfss   PORTD, 0			; Boton 0.
    goto    TIMER_50ms			; Timer de 50 ms.
    btfss   PORTD, 1			; Boton 1.
    goto    TIMER_250ms			; Timer de 250 ms.
    btfss   PORTD, 2			; Boton 2.
    goto    TIMER_500ms			; Timer de 500 ms.
    btfss   PORTD, 3			; Boton 3.
    goto    TIMER_1000ms		; Timer de 1 seg.
    btfss   PORTD, 4			; Boton 4.
    goto    TIMER_MAX			; Máximo delay con TMR0.
    goto    MENU_START
    
MENU_SUB
    btfss   PORTD, 0			; Boton 0.
    goto    TIMER_50ms			; Timer de 50 ms.
    btfss   PORTD, 1			; Boton 1.
    goto    TIMER_250ms			; Timer de 250 ms.
    btfss   PORTD, 2			; Boton 2.
    goto    TIMER_500ms			; Timer de 500 ms.
    btfss   PORTD, 3			; Boton 3.
    goto    TIMER_1000ms		; Timer de 1 seg.
    btfss   PORTD, 4			; Boton 4.
    goto    TIMER_MAX			; Máximo delay con TMR0.
    return
    
TIMER_CONFIG
    movff   CONFIG0, T0CON
    movff   TIMER0L, TMR0L
    movff   TIMER0H, TMR0H
    bcf	    INTCON, 2			; Apaga bandera.
    bsf	    T0CON, 7			; Iniciar timer.
    goto    TIMER
    
TIMER					; Revisar bandera y apagar timer.
    btfss   INTCON, 2			; Revisa la bandera.
    bra	    TIMER
    btg	    LATA, 7			; Invertir estado del LED.
    bcf	    INTCON, 2			; Apaga bandera.
    movff   TIMER0L, TMR0L		; Reset del timer.
    movff   TIMER0H, TMR0H		; Reset del timer.
    call    MENU_SUB
    bra	    TIMER
    
TIMER_50ms
    btfss   PORTD, 0, A			; Revisa si boton sigue presionado.
    bra	    TIMER_50ms
    movlw   b'01000101'			; 1:64
    movwf   CONFIG0	
    movlw   .61
    movwf   TIMER0L
    clrf    TIMER0H
    call    DELAY_20ms			; Antirebote.
    goto    TIMER_CONFIG
	
TIMER_250ms
    btfss   PORTD, 1, A			; Revisa si boton sigue presionado.
    bra	    TIMER_250ms
    movlw   b'01000111'			;1:256
    movwf   CONFIG0	
    movlw   .12
    movwf   TIMER0L
    clrf    TIMER0H
    call    DELAY_20ms			; Antirebote.
    goto    TIMER_CONFIG
    
TIMER_500ms
    btfss   PORTD, 2, A			; Revisa si boton sigue presionado.
    bra	    TIMER_500ms
    movlw   b'00000000'			; 1:2
    movwf   CONFIG0	
    movlw   b'11011100'
    movwf   TIMER0L
    movlw   b'00001011'
    movwf   TIMER0H
    call    DELAY_20ms			; Antirebote.
    goto    TIMER_CONFIG
    
TIMER_1000ms
    btfss   PORTD, 3, A			; Revisa si boton sigue presionado.
    bra	    TIMER_1000ms
    movlw   b'00000001'			; 1:4
    movwf   CONFIG0	
    movlw   b'11011100'
    movwf   TIMER0L
    movlw   b'00001011'
    movwf   TIMER0H
    call    DELAY_20ms			; Antirebote.
    goto    TIMER_CONFIG
    
TIMER_MAX   
    btfss   PORTD, 4, A			; Revisa si boton sigue presionado.
    bra	    TIMER_MAX
    movlw   b'00000111'			; 1:256
    movwf   CONFIG0	
    movlw   h'00'
    movwf   TIMER0L
    movlw   h'00'
    movwf   TIMER0H
    call    DELAY_20ms			; Antirebote.
    goto    TIMER_CONFIG
	
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
