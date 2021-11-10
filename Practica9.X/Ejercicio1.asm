     #include "p18f45k50.inc"
    org 0x00
         goto START	
    org 0x08
        goto HIGH_INT
    org 0x18
	goto LOW_INT
    org 0x40
    
; EQUIVALENCIAS.
counter	    EQU 0x10
_256	    EQU 0x11
_26	    EQU 0x12
direction   EQU	0x13
   
HIGH_INT ; High priority interruptions.
    call    RUTINA_ANTIREBOTE
    bcf	    INTCON, INT0IF, A	    ; Clear flag INT0.
    incf    counter, F, A	    ; counter++
    movlw   .3
    subwf   counter, W, A
    movf    WREG, W, A
    btfsc   STATUS, Z, A	    ; Check if counter = 3.
    call    RESET_COUNTER	    ; if counter = 3.
    retfie   
RESET_COUNTER
    btg	    direction, 0, A	    ; Toggle the direction of LEDs.
    clrf    counter, A
    return
    
LOW_INT
    bcf	    INTCON, TMR0IF, A	    ; Clear flag TMR0.
    movlw   b'00001011'
    movwf   TMR0H		    ; For a 500ms delay.
    movlw   b'11011100'
    movwf   TMR0L		    ; For a 500ms delay.
    
    ; Rotation direction depends on the bit 0 of the direction register.
    btfss   direction, 0, A
    rrncf   LATA, A
    btfsc   direction, 0, A
    rlncf   LATA, A
    
    retfie
    
CONFIG_PORTS 
    movlb   .15
    clrf    ANSELB, BANKED
    clrf    ANSELA, BANKED
    setf    TRISB, A	    	    ; PORTB input.
    clrf    TRISA, A		    ; PORTA output.
    movlw   b'00000001'
    movwf   LATA, A		    ; Ouput -> 0000 0001
    return
    
CONFIG_INT
    movlw   b'01000000'
    movwf   T0CON, A		    ; Pre-esc. 1:2
    movlw   b'00001011'
    movwf   TMR0H		    ; For a 500ms delay.
    movlw   b'11011100'
    movwf   TMR0L		    ; For a 500ms delay.
    
    bsf	    INTCON, 5, A	    ; Enable interruptions TMR0.
    bcf	    INTCON, 2, A	    ; Clear flag.
    bcf	    INTCON2, 2, A	    ; Low priority interruption.
    
    movlw   b'11010000'		    ; Priority, INT0 enable, flag off.
    movwf   INTCON, A
    bsf	    RCON, 7, A		    ; Enables dual priority mode
    bsf	    INTCON2, INTEDG0, A	    ; INT0 works on rising edge (when button is released).
    
    return
    
START
    call    CONFIG_PORTS    
    call    CONFIG_INT
    clrf    counter
    clrf    direction
    bsf	    T0CON, TMR0ON, A	    ; Start TMR0.
    
INFINITE
    goto    INFINITE
    
RUTINA_ANTIREBOTE
    movlw   .0			
    movwf   _256
    movlw   .26
    movwf   _26	
loop1
    decfsz  _256
    goto    loop1		; (3)*256
    decfsz  _26
    goto    loop1		; (3)*256*26 + (3)*26 = 78*256 + 78
    ; 20046+4 = 20.05ms approx. 
    return
  
;
; CONFIGURATION BITS SETTING, THIS IS REQUIRED TO CONFITURE THE OPERATION OF THE MICROCONTROLLER
; AFTER RESET. ONCE PROGRAMMED IN THIS PRACTICA THIS IS NOT NECESARY TO INCLUDE IN FUTURE PROGRAMS
; IF THIS SETTINGS ARE NOT CHANGED. SEE SECTION 26 OF DATA SHEET. 
;   


; CONFIG1L
  CONFIG  PLLSEL = PLL4X        ; PLL Selection (4x clock multiplier)
  CONFIG  CFGPLLEN = OFF        ; PLL Enable Configuration bit (PLL Disabled (firmware controlled))
  CONFIG  CPUDIV = NOCLKDIV     ; CPU System Clock Postscaler (CPU uses system clock (no divide))
  CONFIG  LS48MHZ = SYS24X4     ; Low Speed USB mode with 48 MHz system clock (System clock at 24 MHz, USB clock divider is set to 4)

; CONFIG1H
  CONFIG  FOSC = INTOSCIO       ; Oscillator Selection (Internal oscillator)
  CONFIG  PCLKEN = ON           ; Primary Oscillator Shutdown (Primary oscillator enabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  nPWRTEN = OFF         ; Power-up Timer Enable (Power up timer disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable (BOR enabled in hardware (SBOREN is ignored))
  CONFIG  BORV = 190            ; Brown-out Reset Voltage (BOR set to 1.9V nominal)
  CONFIG  nLPBOR = OFF          ; Low-Power Brown-out Reset (Low-Power Brown-out Reset disabled)

; CONFIG2H
  CONFIG  WDTEN = OFF           ; Watchdog Timer Enable bits (WDT disabled in hardware (SWDTEN ignored))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscaler (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = RC1          ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<5:0> pins are configured as analog input channels on Reset)
  CONFIG  T3CMX = RC0           ; Timer3 Clock Input MUX bit (T3CKI function is on RC0)
  CONFIG  SDOMX = RB3           ; SDO Output MUX bit (SDO function is on RB3)
  CONFIG  MCLRE = ON            ; Master Clear Reset Pin Enable (MCLR pin enabled; RE3 input disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset (Stack full/underflow will cause Reset)
  CONFIG  LVP = ON              ; Single-Supply ICSP Enable bit (Single-Supply ICSP enabled if MCLRE is also 1)
  CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port Enable (ICPORT disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled)
  
    end