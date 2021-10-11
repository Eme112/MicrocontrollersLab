     #include "p18f45k50.inc"    
    org 0x00
    goto CONFIGURACION_TIMER1
    
CONFIGURACION_TIMER1
    org 0x20
    movlw b'00110010'		; Configuracion de TIMER1.
    movwf T1CON, A		; Instruction clock, 1:8, no S.O., 16-bit, stop.
    movlw b'11010100'
    movwf TMR1L, A		; Forza que inicien en 212 los 8 bits menos sign.
    movlw b'01111111'
    movwf TMR1H, A		; Forza que inicien en 32512 los 8 bits mas sign.
    bcf T1GCON, 7, A		; Timer1 cuenta normal.
    bsf T1CON, 0, A		; Activa conteo.
    call RETARDO1ms
    
RETARDO1ms
    call TIMER1_WAIT		; 264,250us approx.
    call TIMER1_WAIT		; 264,250us approx.
    call TIMER1_WAIT		; 264,250us approx.
    call TIMER1_WAIT		; 264,250us approx.
    return
    
TIMER1_WAIT
    btfss PIR1, 0, A		; Revisa si se desbordo la bandera.
    goto TIMER1_WAIT
    bcf PIR1, 0, A		; Apagar bandera.
    movlw b'11010011'
    movwf TMR1L, A		; Reset.
    movlw b'01111111'
    movwf TMR1H, A		; Reset.
    return
    
   end