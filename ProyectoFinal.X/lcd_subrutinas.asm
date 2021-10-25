INSTRUCTION_WRITE
    bcf	    RS			; RS -> 0
    bcf	    RW			; RW -> 0
    goto    SEND_DATA
DATA_WRITE
    bsf	    RS			; RS -> 1
    bcf	    RW			; RW -> 0
    goto    SEND_DATA
DATA_READ
    bsf	    RS			; RS -> 1
    bsf	    RW			; RW -> 1
    goto    SEND_DATA
    
SEND_DATA
    bsf	    E			; Enable.
    movwf   dataLCD		; Data transmission.
    call    DELAY_100us
    bcf	    E			; Stop Enable.
    call    DELAY_100us
    ;call    ESPERA_LCD		; Wait to see if LCD is done.
    return
    
ESPERA_LCD
    bsf	    configFlag		; RD7 -> INPUT (to be able to  read it).
    bcf	    RS			; RS -> 0
    bsf	    RW			; RW -> 1
    bsf	    E			; E -> 1
    nop
REGRESA
    call    DELAY_100ms		; Wait 100us.
    btfsc   flag		; Read bussy flag.
    goto    REGRESA		; If set, keep waiting.
    bcf	    E
    bcf	    configFlag		; RD7 -> OUTPUT again.
    return			; If not set, return.

CONFIGURE_LCD	
    bcf	    E
    call    DELAY_100ms
    movlw   b'00111000'		; 8-bit, 2 lines, 5x7.
    call    INSTRUCTION_WRITE
    movlw   b'00001100'		; Display on, cursor off, blink off.
    call    INSTRUCTION_WRITE
    call    DELAY_100ms
    movlw   b'00011100'		; Increment cursor position, display shift.
    call    INSTRUCTION_WRITE
    movlw   b'00000001'		; Clear display and return to home position.
    call    INSTRUCTION_WRITE
    call    DELAY_100ms
    return