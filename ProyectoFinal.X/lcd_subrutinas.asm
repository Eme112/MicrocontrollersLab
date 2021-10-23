;#include "delays.asm"
    
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
    nop				; Wait 1us to make sure the instruction was received.
    bcf	    E			; Stop Enable.
    call    ESPERA_LCD		; Wait to see if LCD is done.
    return
    
ESPERA_LCD
    bsf	    configFlag		; RD7 -> INPUT (to be able to  read it).
    bcf	    RS			; RS -> 0
    bsf	    RW			; RW -> 1
    bsf	    E			; E -> 1
    nop
REGRESA
    call    DELAY_100us		; Wait 100us.
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
    movlw   b'00001111'		; Display on, cursor on, blynk on.
    call    INSTRUCTION_WRITE
    movlw   b'00000111'		; Increment cursor position, display shift.
    call    INSTRUCTION_WRITE
    movlw   b'00000001'		; Clear display and return to home position.
    call    INSTRUCTION_WRITE
    return

SHOW_MAIN_MENU
    movlw   'A'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE
    movlw   '-'			
    call    DATA_WRITE
    movlw   '>'			
    call    DATA_WRITE
    
    ;SPACE
    movlw   0x05	
    bsf     WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'N'			
    call    DATA_WRITE
    movlw   'E'			
    call    DATA_WRITE
    movlw   'W'			
    call    DATA_WRITE
    
    ;SPACE
    movlw   0x09
    bsf	WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'G'			
    call    DATA_WRITE
    movlw   'A'			
    call    DATA_WRITE
    movlw   'M'			
    call    DATA_WRITE
    movlw   'E'			
    call    DATA_WRITE
    
    ;SECOND LINE
    movlw   0x40
    bsf	WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'B'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE
    movlw   '-'			
    call    DATA_WRITE
    movlw   '>'			
    call    DATA_WRITE
    
    ;SPACE
    movlw   0x45	
    bsf	WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'H'			
    call    DATA_WRITE
    movlw   'I'			
    call    DATA_WRITE
    movlw   'G'			
    call    DATA_WRITE
    movlw   'H'			
    call    DATA_WRITE
    
    ;SPACE
    movlw   0x4A
    bsf	WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'S'			
    call    DATA_WRITE
    movlw   'C'			
    call    DATA_WRITE
    movlw   'O'			
    call    DATA_WRITE
    movlw   'R'			
    call    DATA_WRITE
    movlw   'E'			
    call    DATA_WRITE
    movlw   'S'			
    call    DATA_WRITE
    return
