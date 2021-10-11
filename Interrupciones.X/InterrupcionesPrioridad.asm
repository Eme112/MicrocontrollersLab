     #include "p18f45k50.inc"
    org 0x00
         goto start	
	 
    org 0x08
        goto highInt
	
    org 0x18
	goto lowInt
    
    org 0x40
start
    call configPtos    
    call configInt    
    
loop 	goto loop
    
highInt ; ISR (alta prioridad)
    movf PORTB, W, A
    ;movf PORTC, W, A    
    bcf INTCON, 0, A ; Clears flag   
    retfie

lowInt ; ISR (baja prioridad)
    movf PORTB, W, A
    movf PORTC, W, A    
    bcf INTCON, 0, A ; Clears flag   
    retfie
    
; Otras rutinas
configPtos    
    movlb .15
    clrf ANSELB, BANKED
    clrf ANSELC, BANKED
    setf TRISB, A
    setf TRISC, A    
    return
    
configInt
    movlw b'10001000'	    ; High Priority, IOC enable, flag off
    movwf INTCON, A
    bsf RCON, 7, A	    ; Enables dual priority mode
    bsf INTCON2, 0, A	    ; Sets high priority for IOC
    movlw  b'11110000'	    ; Enable all RBs with IOC
    movwf IOCB, A
    movlw  b'11110111'; Enable all RCs with IOC
    movwf IOCC, A
    return
    
    end