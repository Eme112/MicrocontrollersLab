    #include "p18f45k50.inc"
    processor 18f45k50 	; (opcional).
    
    org 0x00
    goto PORTS_CONFIG
    org 0x08 		; posición para interrupciones.
    retfie
    org 0x18		; posición para interrupciones.
    retfie

; DEFINICION DE REGISTROS.
CONFIG0	equ 0x00
TIMER0L	equ 0x01
TIMER0H	equ 0X02
_256	equ 0x10
_26	equ 0x11

PORTS_CONFIG
    org 0x30
    movlb   .15
    clrf    ANSELA, BANKED
    clrf    ANSELB, BANKED
    clrf    TRISA			; REGA --> LEDs, salidas.
    setf    TRISB			; REGB --> Botones, entradas.
    clrf    LATA  
    
; Menu principal.
MENU_START
    btfss   PORTB, 0			; Boton 0.
    goto    TIMER_50ms			; Timer de 50 ms.
    btfss   PORTB, 1			; Boton 1.
    goto    TIMER_250ms			; Timer de 250 ms.
    btfss   PORTB, 2			; Boton 2.
    goto    TIMER_500ms			; Timer de 500 ms.
    btfss   PORTB, 3			; Boton 3.
    goto    TIMER_1000ms		; Timer de 1 seg.
    btfss   PORTB, 4			; Boton 4.
    goto    TIMER_MAX			; Máximo delay con TMR0.
    goto    MENU_START
    
MENU_SUB
    btfss   PORTB, 0			; Boton 0.
    goto    TIMER_50ms			; Timer de 50 ms.
    btfss   PORTB, 1			; Boton 1.
    goto    TIMER_250ms			; Timer de 250 ms.
    btfss   PORTB, 2			; Boton 2.
    goto    TIMER_500ms			; Timer de 500 ms.
    btfss   PORTB, 3			; Boton 3.
    goto    TIMER_1000ms		; Timer de 1 seg.
    btfss   PORTB, 4			; Boton 4.
    goto    TIMER_MAX			; Máximo delay con TMR0.
    return
    
TIMER_CONFIG
    movff   CONFIG0, T0CON
    movff   TIMER0L, TMR0L
    movff   TIMER0H, TMR0H
    bcf	    INTCON, 2			; Apaga bandera.
    bsf	    T0CON, 7			; Iniciar timer.
    goto    TIMER
    
TIMER					; Revisar bandera y apagar timer.
    btfss   INTCON, 2			; Revisa la bandera.
    bra	    TIMER
    btg	    LATA, 7			; Invertir estado del LED.
    bcf	    INTCON, 2			; Apaga bandera.
    movff   TIMER0L, TMR0L		; Reset del timer.
    movff   TIMER0H, TMR0H		; Reset del timer.
    call    MENU_SUB
    bra	    TIMER
    
TIMER_50ms
    btfss   PORTB, 0, A			; Revisa si boton sigue presionado.
    bra	    TIMER_50ms
    movlw   b'01000101'			; 1:64
    movwf   CONFIG0	
    movlw   .61
    movwf   TIMER0L
    clrf    TIMER0H
    call    DELAY_20ms			; Antirebote.
    goto    TIMER_CONFIG
	
TIMER_250ms
    btfss   PORTB, 1, A			; Revisa si boton sigue presionado.
    bra	    TIMER_250ms
    movlw   b'01000111'			;1:256
    movwf   CONFIG0	
    movlw   .12
    movwf   TIMER0L
    clrf    TIMER0H
    call    DELAY_20ms			; Antirebote.
    goto    TIMER_CONFIG
    
TIMER_500ms
    btfss   PORTB, 2, A			; Revisa si boton sigue presionado.
    bra	    TIMER_500ms
    movlw   b'00000000'			; 1:2
    movwf   CONFIG0	
    movlw   b'11011100'
    movwf   TIMER0L
    movlw   b'00001011'
    movwf   TIMER0H
    call    DELAY_20ms			; Antirebote.
    goto    TIMER_CONFIG
    
TIMER_1000ms
    btfss   PORTB, 3, A			; Revisa si boton sigue presionado.
    bra	    TIMER_1000ms
    movlw   b'00000001'			; 1:4
    movwf   CONFIG0	
    movlw   b'11011100'
    movwf   TIMER0L
    movlw   b'00001011'
    movwf   TIMER0H
    call    DELAY_20ms			; Antirebote.
    goto    TIMER_CONFIG
    
TIMER_MAX   
    btfss   PORTB, 4, A			; Revisa si boton sigue presionado.
    bra	    TIMER_MAX
    movlw   b'00000111'			; 1:256
    movwf   CONFIG0	
    movlw   h'00'
    movwf   TIMER0L
    movlw   h'00'
    movwf   TIMER0H
    call    DELAY_20ms			; Antirebote.
    goto    TIMER_CONFIG
	
DELAY_20ms
    movlw   .0			
    movwf   _256
    movlw   .26
    movwf   _26	
LOOP1
    decfsz  _256
    goto    LOOP1		; (3)*256
    decfsz  _26
    goto    LOOP1		; (3)*256*26 + (3)*26 = 78*256 + 78
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
