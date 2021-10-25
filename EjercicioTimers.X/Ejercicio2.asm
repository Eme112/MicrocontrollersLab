     #include "p18f45k50.inc"    
    org 0x00
    goto TIME_OUT
TIME_OUT
    org 0x20
    movlw b'00000111'; Configuración T0CON
    movwf T0CON, A
    movlw b'10110011'
    movwf TMR0H,A
    movlw b'10110100'
    movwf TMR0L,A   
    bcf INTCON,2,A
    bsf T0CON,7,A	; Activa conteo
espera	
    btfss INTCON,2,A
    goto espera
    bcf INTCON,2,A
    ;call ON_RED
    return

    end