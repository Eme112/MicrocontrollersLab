     #include "p18f45k50.inc"
   org 0x00
        goto CONFIGURATION	
   org 0x08
        goto HIGH_INT
   org 0x18
	goto LOW_INT
	
CONFIGURATION 
    org 0x40
    movlb   .15
    clrf    ANSELD, BANKED
    clrf    TRISD, A		    ; RegD --> OUTPUT
    clrf    LATD, A
    clrf    ANSELB, BANKED
    setf    TRISB, A		    ; RegB --> INPUT
    clrf    ANSELC, BANKED
    setf    TRISC, A		    ; RegC --> INPUT
    
    movlw   b'00010000'		    ; Enable RB4 interruption
    movwf   IOCB, A
    movlw   b'00000001'		    ; Enable RC0 interruption
    movwf   IOCC, A
    
    bsf	    RCON, 7, A		    ; Enables dual priority mode
    bsf	    INTCON2, 2, A	    ; TMR0, high priority
    bcf	    INTCON2, 0, A	    ; IOC, low priority
    bcf	    INTCON, 0, A
    movlw   b'11101000'		    ; TMR 0 and IOC config, HIGH and LOW priority.
    movwf   INTCON, A
    
    movlw   b'00000011'		    ; timer config for 1 seg (16 bits, 1:16)
    
    movwf   T0CON, A
    
loop 	goto loop		    ; Waiting for interruptions  
  
HIGH_INT
    bcf	    LATD, 0, A		    ; Turn off LED
    bcf	    T0CON, 7, A		    ; Stop timer
    bcf	    INTCON, 2, A	    ; Clear flag
    retfie
    
LOW_INT
    movf    PORTB, W, A
    movf    PORTC, W, A
    bcf	    INTCON, 0, A ; Clears flag 
    btfsc   PORTB, 4, A
    goto    TIMER_1seg
    btfsc   PORTC, 0, A
    goto    TIMER_500ms
    retfie
    
TIMER_500ms  
    movlw   b'00001100'
    movwf   TMR0L, A		    ; initial value for TMR0
    movlw   b'11011100'
    movwf   TMR0H, A
    bsf	    T0CON, 7, A		    ; starts timer
    bsf	    LATD, 0, A		    ; Turn on LED
    retfie
    
TIMER_1seg
    movlw   b'11101110'
    movwf   TMR0L, A		    ; initial value for TMR0
    movlw   b'10000101'
    movwf   TMR0H, A
    bsf	    T0CON, 7, A		    ; starts timer
    bsf	    LATD, 0, A		    ; Turn on LED
    retfie
 
    
    end