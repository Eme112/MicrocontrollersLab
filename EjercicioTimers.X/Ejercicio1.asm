     #include "p18f45k50.inc"    
    org 0x00
    goto start
start
    org 0x20
    movlw b'01001000'		; Ponga su configuracion de prueba
    movwf T0CON, A
    clrf TMR0L,A		; Forza que inicie en 0    
    bsf T0CON,7,A		; Activa conteo
espera  btfss INTCON,2,A
	goto espera
	bcf INTCON,2,A
    goto start
    end