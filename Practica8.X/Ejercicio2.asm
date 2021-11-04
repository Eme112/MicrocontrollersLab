#include "p18f45k50.inc"
    processor 18f45k50 	; (opcional).
    
    org 0x00
    goto PORTS_CONFIG
    org 0x08 		; posición para interrupciones.
    retfie
    org 0x18		; posición para interrupciones.
    retfie
 
; DEFINICION DE REGISTROS.
vel	equ 0x40
TIMER0L	equ 0x41
TIMER0H	equ 0X42
_256	equ 0x50
_26	equ 0x51

PORTS_CONFIG
    org 0x30
    movlb   .15
    clrf    ANSELA, BANKED
    clrf    ANSELB, BANKED
    clrf    TRISA			; REGA --> LEDs, salidas.
    setf    TRISB			; REGB --> Botones, entradas.
    clrf    LATA  
    clrf    vel, A
    bsf	    vel, 0, A			; vel --> b'0000 0001'.
    movlw   b'11011100'
    movwf   TIMER0L
    movlw   b'00001011'
    movwf   TIMER0H
    goto    TIMER_CONFIG
    
; Menu principal. 
MENU_SUB
    btfss   PORTB, 0			; Boton 0.
    goto    PAUSA			; Pausa.
    btfss   PORTB, 1			; Boton 1.
    goto    _RESET			; Reset.
    btfss   PORTB, 2			; Boton 2.
    goto    VELOCIDAD			; Velocidad.
    return
    
TIMER_CONFIG
    movlw   b'00000001'			; Pre-escalador 1:4
    movwf   T0CON	
    movff   TIMER0H, TMR0L		; Reset del timer.
    movff   TIMER0L, TMR0H		; Reset del timer.
    bcf	    INTCON, 2			; Apaga bandera.
    bsf	    T0CON, 7			; Iniciar timer.
    goto    TIMER
    
TIMER					; Incrementar contador con cada cuenta.
    btfss   INTCON, 2			; Revisa la bandera.
    goto    TIMER
    bcf	    INTCON, 2			; Apaga bandera.
    incf    LATA, F, A			; Aumentar la cuenta en 1.
    movff   TIMER0H, TMR0L		; Reset del timer.
    movff   TIMER0L, TMR0H		; Reset del timer.
    call    MENU_SUB
    bra	    TIMER
    
PAUSA
    btfss   PORTB, 0			; Revisar si sigue presionado.
    bra	    PAUSA
    bcf	    T0CON, 7			; Pausar timer.
    call    DELAY_20ms
PLAY
    btfsc   PORTB, 0			; Revisar si se presiona.
    bra	    PLAY
PLAY2
    btfss   PORTB, 0			; Revisar si sigue presionado.
    bra	    PLAY2
    bsf	    T0CON, 7			; Iniciar timer.
    call    DELAY_20ms
    goto    MENU_SUB
    
_RESET
    btfss   PORTB, 1			; Revisar si sigue presionado.
    bra	    _RESET
    clrf    LATA, A			; Resetear la cuenta.
    goto    MENU_SUB
    
VELOCIDAD
    btfss   PORTB, 2			; Revisar si sigue presionado.
    bra	    VELOCIDAD
    call    DELAY_20ms			; Anti-rebote.
    btfsc   vel, 0, A			; Velocidad 1.
    goto    VELOCIDAD1_2
    btfsc   vel, 1, A			; Velocidad 2.
    goto    VELOCIDAD2_3
    btfsc   vel, 2, A			; Velocidad 3.
    goto    VELOCIDAD3_4
    btfsc   vel, 3, A			; Velocidad 4.
    goto    VELOCIDAD4_5
    btfsc   vel, 4, A			; Velocidad 5.
    goto    VELOCIDAD5_1
    
VELOCIDAD1_2
    movlw   b'10000010'			; Pre-escalador 1:8
    movwf   T0CON
    rlncf   vel, F, A			; vel --> b'0000 0010'.
    goto    MENU_SUB
VELOCIDAD2_3
    movlw   b'10000011'			; Pre-escalador 1:16
    movwf   T0CON
    rlncf   vel, F, A			; vel --> b'0000 0100'.
    goto    MENU_SUB
VELOCIDAD3_4
    movlw   b'10000100'			; Pre-escalador 1:32
    movwf   T0CON
    rlncf   vel, F, A			; vel --> b'0000 1000'.
    goto    MENU_SUB
VELOCIDAD4_5
    movlw   b'10000101'			; Pre-escalador 1:64
    movwf   T0CON
    rlncf   vel, F, A			; vel --> b'0001 0000'.
    goto    MENU_SUB
VELOCIDAD5_1
    movlw   b'10000001'			; Pre-escalador 1:4
    movwf   T0CON
    rlncf   vel, F, A
    bsf	    vel, 0, A			; vel --> b'0000 0001'.
    goto    MENU_SUB
    
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