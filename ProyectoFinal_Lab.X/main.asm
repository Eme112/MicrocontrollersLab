 #include "p18f45k50.inc"
    processor 18f45k50 	; (opcional).
 #define _XTAL_FREQ 800000
    org 0x00
    goto PORTS_CONFIG
    org 0x08 		; posición para interrupciones de alta prioridad.
    goto HIGH_INT
    org 0x18		; posición para interrupciones de baja prioridad.
    retfie


PWM	EQU 0x10    

; Esto es lo que se tiene que cambiar
    movlw	.100 ; para un 100%
    movwf	CCPR1L
    
HIGH_INT
    bcf	    INTCON, 2, A		; Clear TMR0 flag
    btg	    LATB, 0, A			; Parpadear para mostrar error.
    retfie
    
PORTS_CONFIG
    org 0x30
    movlb   .15
    clrf    ANSELB, BANKED
    clrf    ANSELC, BANKED
    clrf    TRISB, A			; REGB --> LEDs, salidas.
    setf    TRISC, A			; REGC, b7 --> Rx (receptor).
    clrf    LATB
    bcf	TRISC, 2, A	; Convertir en salida el PWM.
    
TIMER_CONFIG
    movlw   0xFF		; A esto cambiar el prescalador a uno de 32
    movwf   T2CON
    movlw   0x0F
    movwf   CCP1CON		; Configurar modulo PWM
    movlw   0xBF
    movwf   OSCCON
    movlw   .100
    movwf   PR2
    
    movlw   b'00000000'			; Pre-escalador 1:2
    movwf   T0CON	
    movlw   b'11011100'
    movwf   TMR0L
    movlw   b'00001011'
    movwf   TMR0H
    bsf	    INTCON, 7, A	    ; Enable interruptions
    bsf	    INTCON, 5, A	    ; Config TMR0 interrupt
    bcf	    INTCON, 2, A	    ; Clear TMR0 flag
    
DATA_TRANSMISSION
    movlw   b'10010000'			; EN, 8bit, cont. rec.
    movwf   RCSTA, A
    clrf    TXSTA, A			; Low baud rate option.
    movlw   .12				; Baud Rate, para 1200.
    movwf   SPBRG
    movlw   b'00110010'			; Para entrar en modo sleep.
    movwf   OSCCON, A
R1  
    movff   PWM, CCPR1L
WAIT
    btfss   PIR1, RCIF, A
    bra	    WAIT
    
    ; Si llega hasta aqui significa que ya recibio una entrada del teclado.
    movf    RCREG, W, A
    sublw   '0'			; Checar si se presiono un 0 en el teclado.
    btfsc   STATUS, Z, A
    goto    CERO
    movf    RCREG, W, A
    sublw   '1'				; Checar si se presiono un 1 en el teclado.
    btfsc   STATUS, Z, A
    goto    UNO
    movf    RCREG, W, A
    sublw   '2'				; Checar si se presiono un 2 en el teclado.
    btfsc   STATUS, Z, A
    goto    DOS
    movf    RCREG, W, A
    sublw   '3'				; Checar si se presiono un 3 en el teclado.
    btfsc   STATUS, Z, A
    goto    TRES
    movf    RCREG, W, A
    sublw   '4'				; Checar si se presiono un 4 en el teclado.
    btfsc   STATUS, Z, A
    goto    CUATRO
    movf    RCREG, W, A
    sublw   '5'				; Checar si se presiono un 5 en el teclado.
    btfsc   STATUS, Z, A
    goto    CINCO
    goto    _ERROR			; Si no se presiono ningun numero del 1-5.
    
CERO
    bcf	    T0CON, 7, A			; Detener TIMER 0 para interrupciones.
    clrf    LATB, A			; Borrar LEDs.
    movlw   .11230
    movwf   PWM	
    goto    R1				; Listo para recibir siguiente dato.
    
UNO
    bcf	    T0CON, 7, A			; Detener TIMER 0 para interrupciones.
    clrf    LATB, A
    bsf	    LATB, 0, A			; Marcador de intensidad 1.
    movlw   .90
    movwf   PWM				; 60%
    goto    R1				; Listo para recibir siguiente dato.
    
DOS
    bcf	    T0CON, 7, A			; Detener TIMER 0 para interrupciones.
    clrf    LATB, A
    bsf	    LATB, 1, A			; Marcador de intensidad 2.
    movlw   .70
    movwf   PWM				; 70%
    goto    R1				; Listo para recibir siguiente dato.
    
TRES
    bcf	    T0CON, 7, A			; Detener TIMER 0 para interrupciones.
    clrf    LATB, A
    bsf	    LATB, 2, A			; Marcador de intensidad 3.
    movlw   .50
    movwf   PWM				; 80%
    goto    R1				; Listo para recibir siguiente dato.
    
CUATRO
    bcf	    T0CON, 7, A			; Detener TIMER 0 para interrupciones.
    clrf    LATB, A
    bsf	    LATB, 3, A			; Marcador de intensidad 4.
    movlw   .30
    movwf   PWM				; 90%
    goto    R1				; Listo para recibir siguiente dato.
    
CINCO
    bcf	    T0CON, 7, A			; Detener TIMER 0 para interrupciones.
    clrf    LATB, A
    bsf	    LATB, 4, A			; Marcador de intensidad 5.
    movlw   .5
    movwf   PWM				; 100%
    goto    R1				; Listo para recibir siguiente dato.
    
_ERROR
    movlw   b'00000000'			; Pre-escalador 1:2
    movwf   T0CON	
    movlw   b'00001011'
    movwf   TMR0H
    movlw   b'11011100'
    movwf   TMR0L
    bsf	    T0CON, 7, A			; Encender TIMER0 500ms.
    clrf    LATB, A			; Apagar LEDs.
    bsf	    LATB, 0, A			; El LED que parpadea comienza encendido.
    goto    R1				; Listo para recibir siguiente dato.
    
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