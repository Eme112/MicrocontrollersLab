#include "p18f45k50.inc"
    processor 18f45k50 	; (opcional).
    
    org 0x00
    goto PORTS_CONFIG
    org 0x08 		; posición para interrupciones.
    retfie
    org 0x18		; posición para interrupciones.
    retfie

PORTS_CONFIG
    org 0x30
    movlb   .15
    clrf    ANSELA, BANKED
    clrf    ANSELC, BANKED
    clrf    TRISA			; REGA --> LEDs, salidas.
    setf    TRISC			; REGC --> Botones, entradas (RC0).
    clrf    LATA  
    
CONFIG_TIMERS
    movlw   b'00000011'			; TMR0 CONFIG.
    movwf   T0CON, A
    ;movlw   b'11000010'
    ;movwf   TMR0H, A
    ;movlw   b'11111000'			; 49,911 en un inicio.
    ;movwf   TMR0L, A

    movlw   b'11101011'
    movwf   TMR0H, A
    movlw   b'10101000'			; 49,911 en un inicio.
    movwf   TMR0L, A
    ;b'10101000'	
    
    movlw   b'10001010'			; TMR1 CONFIG.
    movwf   T1CON, A
    
    ;bcf	    T1GCON, 7, A
    
    bsf	    T0CON, 7, A			; Empieza la cuenta de tiempo.
    bsf	    T1CON, 0, A			; Empieza la cuenta de pulsos.
    clrf    TMR1L, A
    
LOOP					; Incrementar contador con cada cuenta.
    btfss   INTCON, 2			; Revisa la bandera.
    goto    LOOP
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    bcf	    T1CON, 0, A			; Detener cuenta de pulsos.
    bcf	    T0CON, 7, A			; Detener cuenta de tiempo.
    bcf	    INTCON, 2			; Apagar la bandera.
    movff   TMR1L, LATA			; Mostrar LEDs.
    goto    CONFIG_TIMERS		; Reiniciar.

    
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