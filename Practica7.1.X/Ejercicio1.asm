    #include "p18f45k50.inc"
    processor 18f45k50 	; (opcional).
    
    org 0x00
    goto CONFIGURE
    org 0x08 		; posición para interrupciones.
    retfie
    org 0x18		; posición para interrupciones.
    retfie
    
PORTS
    #define RS LATC, 0, A	; RC0 -> Register Select.
    #define RW LATC, 1, A	; RC1 -> Read/Write.
    #define E LATC, 2, A	; RC2 -> Enable.
    #define flag PORTD, 7, A	; RD7 -> Busy flag.
    #define configFlag TRISD, 7, A  ; Switch flag from INPUT to OUTPUT and viceversa.
    #define dataLCD LATD, A
    
; ETIQUETAS
var1	equ 0x10
var2	equ 0x11
var3	equ 0x12
	
CONFIGURE
    org	0x40			; Código principal.
    movlw   .15
    clrf    ANSELA, BANKED	; REGA -> Digital. 
    clrf    TRISA, A		; REGA -> Output.
    clrf    ANSELC, BANKED	; REGC -> Digital. 
    clrf    TRISC, A		; REGC -> Output.
    clrf    ANSELD, BANKED	; REGD -> Digital.
    clrf    TRISD, A		; REGD -> Output.

START	
    bcf	    E
    call    delay100ms
    movlw   b'00111000'		; 8-bit, 2 lines, 5x7.
    call    INSTRUCTION_WRITE
    movlw   b'00001111'		; Display on, cursor on, blynk on.
    call    INSTRUCTION_WRITE
    movlw   b'00010100'		; Increment cursor position, diplay shift.
    call    INSTRUCTION_WRITE
    movlw   b'00000001'		; Clear display and return to home position.
    call    INSTRUCTION_WRITE
LINE1
    movlw   0x02		; Move cursor to the third position of line 2.
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    movlw   'H'			; Write a 'H'.
    call    DATA_WRITE
    movlw   'o'			; Write a 'o'.
    call    DATA_WRITE
    movlw   'l'			; Write a 'l'.
    call    DATA_WRITE
    movlw   'a'			; Write a 'a'.
    call    DATA_WRITE
LINE2
    movlw   0x40		; Move cursor to the first position of line 2.
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    movlw   'M'			; Write a 'M'.
    call    DATA_WRITE
    movlw   'a'			; Write a 'a'.
    call    DATA_WRITE
    movlw   'e'			; Write a 'e'.
    call    DATA_WRITE
    movlw   's'			; Write a 's'.
    call    DATA_WRITE
    movlw   't'			; Write a 't'.
    call    DATA_WRITE
    movlw   'r'			; Write a 'r'.
    call    DATA_WRITE
    movlw   'a'			; Write a 'a'.
    call    DATA_WRITE
    movlw   '!'			; Write a '!'.
    call    DATA_WRITE
    call    delay1seg
    goto    START		; Infinite loop to keep the same screen.
    
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
    call    delay100ms		; Wait to see if LCD is done.
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
    
delay1seg
    call    delay100ms
    call    delay100ms
    call    delay100ms
    call    delay100ms
    call    delay100ms
    call    delay100ms
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