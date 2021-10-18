     #include "p18f45k50.inc"    
    org 0x00
    goto start
    
var1	equ 0x00
var2	equ 0x01
var3	equ 0x02
   
start
    org 0x30
    call    TMR2_CONFIG
    
TMR2_CONFIG
    movlw   b'00000000'
    movwf   T2CON, A
    movlw   .25
    movwf   PR2, A
    clrf    TMR2, A
    bsf	    T2CON, 2, A
COUNT_25ms
    btfss   PIR1, 1, A
    goto    COUNT_25ms
    bcf	    PIR1, 1, A
    return
    end