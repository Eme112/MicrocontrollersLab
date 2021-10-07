    #include "p18f45k50.inc"
    processor 18f45k50 	; (opcional).
    org 0x00
    goto PORTS
    org 0x08 		; posición para interrupciones.
    retfie
    org 0x18		; posición para interrupciones.
    retfie
    org 0x30 		; Origen real (opcional pero recomendado).
PORTS
    #define RS LATB, 0, A	; RB0 -> Register Select.
    #define E LATB, 1, A	; RB1 -> Enable.
    #define RW LATB, 2, A	; RB2 -> Read/Write.
    #define flag PORTD, 7, A	; RD7 -> Busy flag.
    #define configFlag TRISD, 7, A  ; Switch flag from INPUT to OUTPUT and viceversa.
    #define dataLCD LATD, A
; ETIQUETAS
var1	equ 0x10
var2	equ 0x11
var3	equ 0x12
CONFIGURE
    movlw	.15
    clrf	ANSELB, BANKED	; REGB -> Digital. 
    clrf	ANSELD, BANKED	; REGD -> Digital.
    clrf	TRISB, A	; REGB -> Output.
    clrf	TRISD, A	; REGD -> Output.
    org	0x40		; Código principal.
START	
    bcf	    E
    call    delay100ms
    movlw   b'00111000'		; 8-bit, 2 lines, 5x7.
    call    INSTRUCTION_WRITE
    movlw   b'00001111'		; Display on, cursor on, blynk on.
    call    INSTRUCTION_WRITE
    movlw   b'00000111'		; Increment cursor position, diplay shift.
    call    INSTRUCTION_WRITE
    movlw   b'00000001'		; Clear display and return to home position.
    call    INSTRUCTION_WRITE
INFINITE    goto    INFINITE	; Infinite loop.    
WRITING
    movlw   0x45		; Move cursor to 0x45.
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    movlw   'c'			; Write a 'c'.
    call    DATA_WRITE
    movlw   '4'			; Write a '4'.
    call    DATA_WRITE
    

    
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
    nop				; Wait 1us to make sure the instruction was recieved.
    bcf	    E			; Stop Enable.
    clrf    dataLCD
    call    ESPERA_LCD		; Wait to see if LCD is done.
    return
    
ESPERA_LCD
    bsf	    configFlag		; RD7 -> INPUT (to be able to  read it).
    bcf	    RS			; RS -> 0
    bsf	    RW			; RW -> 1
    bsf	    E			; E -> 1
    nop
REGRESA
    call    delay100us		; Wait 100us.
    btfsc   flag		; Read bussy flag.
    goto    REGRESA		; If set, keep waiting.
    bcf	    E
    bcf	    configFlag		; RD7 -> OUTPUT again.
    return			; If not set, return.
    
delay100us
    movlw   .33
    movwf   var1
loop1				
    decfsz  var1
    goto    loop1
    ; 100us approx.
    return

delay100ms
    movlw   .0			; 256
    movwf   var1
    movlw   .128
    movwf   var2
loop2				
    decfsz  var1
    goto    loop2
    decfsz  var2
    goto    loop2
    ; 100ms approx.
    return
	end