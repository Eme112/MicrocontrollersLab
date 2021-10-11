     #include "p18f45k50.inc"
   org 0x00
        goto start	
   org 0x08
        goto highInt
	
start org 0x40
    movlb .15
    clrf ANSELD, BANKED
    clrf TRISD, A
    clrf LATD, A
    movlw b'01001000'	    ; timer config for 512us delay (2 MHz)
    movwf T0CON, A
    movlw .0		    ; initial value for TMR0
    movwf TMR0L, A
    bsf	INTCON, 7, A	    ; Enable interruptions
    bsf	INTCON, 5, A	    ; Config TMR0 interrupt
    bcf	INTCON, 2, A	    ; Clear TMR0 flag
    bsf T0CON, 7, A	    ; starts timer
    
loop 	goto loop ; infinite loop?
    
highInt
    btg LATD, 1, A	    ; flip LED
    bcf	INTCON, 2, A	    ; Clear TMR0 flag
    movlw .5		    ; reset TMR0 value (because of delays)
    addwf TMR0L, F, A
    retfie

    end