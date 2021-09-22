; Practica 5 Ejercicio 2
; Elabora un programa con 3 contadores: contador Gray, contador de números impares y contador
; de números pares. El programa inicia esperando a que se seleccione una rutina (B1, B2 o B3), cuando
; se activa dicha rutina, para salir o cambiar de rutina debe presionarse el botón de la rutina deseada. 
; B1: Gray
; B2: Impar
; B3: Par
; B4: Más
; B5: Menos
    
#include "p18f45k50.inc"
    processor 18F45K50 
    RADIX DEC ;DEFINIMO COMO TRABAJARA NUESTRO RADIX
    org 0x00
;X	EQU 0 ; DEFICINMOS NUESTRA VARIABLE X
;Y	EQU 1 ; DEFINIMOS NUESTRA VARIABLE Y
; Equivalencias botones
gray	EQU 0
impar	EQU 1
par	EQU 2
mas	EQU 6			    
menos	EQU 7
; Equivalencias para variables.
counter	EQU 10
; Equivalencias para el delay de 20ms.
_256	EQU 20
_26	EQU 21

MAIN_CONF
    MOVLB   15
    CLRF    ANSELA,BANKED	    ; Puerto A = Digital.
    CLRF    ANSELB,BANKED	    ; Puerto B = Digital.
    CLRF    ANSELC,BANKED	    ; Puerto C = Digital.
    CLRF    TRISA		    ; Puerto A = Salida.
    CLRF    TRISB		    ; Puerto B = Salida.
    SETF    TRISC		    ; Puerto C = Entrada.
    CLRF    LATA		    ; Puerto A = 0000 0000.
    CLRF    LATB		    ; Puerto B = 0000 0000.
    GOTO    WAITING

WAITING_REBOTE
    btfss   PORTC, gray	    
    goto    WAITING_REBOTE	    ; Si esta activo el boton 1, repetir.
    btfss   PORTC, impar	    
    goto    WAITING_REBOTE	    ; Si esta activo el boton 2, repetir.
    btfss   PORTC, par    
    goto    WAITING_REBOTE	    ; Si esta activo el boton 3, repetir.
    call    RUTINA_ANTIREBOTE	    ; Llamar rutina antirebote para evitar señales de regreso.
WAITING
    btfss   PORTC, gray
    goto    RUTINA_A_REBOTE	    ; Si se presiona el boton 1, ir a RUTINA_A.
    btfss   PORTC, impar
    goto    RUTINA_B_REBOTE	    ; Si se presiona el boton 2, ir a RUTINA_B.
    btfss   PORTC, par
    goto    RUTINA_C_REBOTE	    ; Si se presiona el boton 3, ir a RUTINA_C.
    goto    WAITING
    
RUTINA_A_REBOTE
    btfss   PORTC, gray		    ; Esperar a que se suelte el boton.
    goto    RUTINA_A_REBOTE	    ; Si aun no se suelta, ciclarse.
    call    RUTINA_ANTIREBOTE	    ; Llamar rutina antirebote para evitar señales de regreso.
RUTINA_A			    ; CONTADOR GRAY.
    BCF	    LATA, 7		    
    BCF	    LATA, 6		    ; Apagar todos los LEDs menos el 4.
    BCF	    LATA, 5		    ; LED 4 = Estamos en la rutina A.
    BSF	    LATA, 4
    btfss   PORTC, gray
    goto    WAITING_REBOTE	    ; Si se vuelve a presionar el boton 1, ir a espera.
    btfss   PORTC, impar
    goto    RUTINA_B_REBOTE	    ; Si se presiona el boton 2, ir a rutina b.
    btfss   PORTC, par
    goto    RUTINA_C_REBOTE	    ; Si se presiona el boton 3, ir a rutina c.
    btfss   PORTC, mas
    call    INCREMENTAR		    ; Si se presiona el boton 4, aumentar el contador.
    btfss   PORTC, menos
    call    DECREMENTAR		    ; Si se presiona el boton 5, decrementar el contador.
    
RUTINA_B_REBOTE			    ; CONTADOR IMPAR.
    btfss   PORTC, impar	    ; Esperar a que se suelte el boton.
    goto    RUTINA_B_REBOTE	    ; Si aun no se suelta, ciclarse.
    call    RUTINA_ANTIREBOTE	    ; Llamar rutina antirebote para evitar señales de regreso.
RUTINA_B_START			    ; CONTADOR IMPAR.
    BCF	    LATA, 7		    
    BCF	    LATA, 6		    ; Apagar todos los LEDs menos el 5.
    BSF	    LATA, 5		    ; LED 5 = Estamos en la rutina B.
    BCF	    LATA, 4
    clrf    counter, A		    ; Empezar en 0s
    movff   counter, LATB	    ; Apagar todos los LEDs.
    btfss   PORTC, mas
    goto    INCREMENTAR_1	    ; Solo en la primera ocasion se incrementa 1 en lugar de 2.
    btfss   PORTC, menos
    goto    DECREMENTAR_1	    ; Solo en la primera ocasion se decrementa 1 en lugar de 2.
    goto    RUTINA_B_START	    ; Esperar a que se aumente o decremente para seguir.
INCREMENTAR_1
    btfss   PORTC, mas		    ; Esperar a que se suelte el boton.
    goto    INCREMENTAR_1	    ; Si aun no se suelta, ciclarse.
    call    RUTINA_ANTIREBOTE	    ; Llamar rutina antirebote para evitar señales de regreso.
    incf    counter, F, A	    ; Incrementar en uno el contador.
    goto    RUTINA_B_LOOP
DECREMENTAR_1
    btfss   PORTC, menos	    ; Esperar a que se suelte el boton.
    goto    DECREMENTAR_1	    ; Si aun no se suelta, ciclarse.
    call    RUTINA_ANTIREBOTE	    ; Llamar rutina antirebote para evitar señales de regreso.
    decf    counter, F, A	    ; Decrementar en uno el contador.
    goto    RUTINA_B_LOOP
RUTINA_B_LOOP
    movff   counter, LATB	    ; Prender los LEDs correspondientes.
    btfss   PORTC, gray
    goto    RUTINA_A_REBOTE	    ; Si se presiona el boton 1, ir a rutina a.
    btfss   PORTC, impar
    goto    WAITING_REBOTE	    ; Si se vuelve a presionar el boton 2, ir a espera.
    btfss   PORTC, par
    goto    RUTINA_C_REBOTE	    ; Si se presiona el boton 3, ir a rutina c.
    btfss   PORTC, mas
    call    INCREMENTAR_2	    ; Si se presiona el boton 4, aumentar el contador en 2.
    btfss   PORTC, menos
    call    DECREMENTAR_2	    ; Si se presiona el boton 5, decrementar el contador en 2.
    goto    RUTINA_B_LOOP	    ; Repetir hasta salir de la rutina.
    
RUTINA_C_REBOTE			    ; CONTADOR IMPAR.
    btfss   PORTC, par		    ; Esperar a que se suelte el boton.
    goto    RUTINA_C_REBOTE	    ; Si aun no se suelta, ciclarse.
    call    RUTINA_ANTIREBOTE	    ; Llamar rutina antirebote para evitar señales de regreso.
RUTINA_C_START			    ; CONTADOR IMPAR.
    BCF	    LATA, 7		    
    BSF	    LATA, 6		    ; Apagar todos los LEDs menos el 6.
    BCF	    LATA, 5		    ; LED 6 = Estamos en la rutina C.
    BCF	    LATA, 4
    clrf    counter, A		    ; Empezar en 0s
RUTINA_C_LOOP
    movff   counter, LATB	    ; Prender los LEDs correspondientes.
    btfss   PORTC, gray
    goto    RUTINA_A_REBOTE	    ; Si se presiona el boton 1, ir a rutina A.
    btfss   PORTC, impar
    goto    RUTINA_B_REBOTE	    ; Si se presiona el boton 2, ir a rutina B.
    btfss   PORTC, par
    goto    WAITING_REBOTE	    ; Si se vuelve a presionar el boton 3, ir a espera.
    btfss   PORTC, mas
    call    INCREMENTAR_2	    ; Si se presiona el boton 4, aumentar el contador en 2.
    btfss   PORTC, menos
    call    DECREMENTAR_2	    ; Si se presiona el boton 5, decrementar el contador en 2.
    goto    RUTINA_C_LOOP	    ; Repetir hasta salir de la rutina.

INCREMENTAR
    btfss   PORTC, mas		    ; Esperar a que se suelte el boton.
    goto    INCREMENTAR		    ; Si aun no se suelta, ciclarse.
    call    RUTINA_ANTIREBOTE	    ; Llamar rutina antirebote para evitar señales de regreso.
    incf    counter, F, A	    ; Incrementar en uno el contador.
    return
DECREMENTAR
    btfss   PORTC, menos	    ; Esperar a que se suelte el boton.
    goto    DECREMENTAR		    ; Si aun no se suelta, ciclarse.
    call    RUTINA_ANTIREBOTE	    ; Llamar rutina antirebote para evitar señales de regreso.
    decf    counter, F, A	    ; Decrementar en uno el contador.
    return
    
INCREMENTAR_2
    btfss   PORTC, mas		    ; Esperar a que se suelte el boton.
    goto    INCREMENTAR_2	    ; Si aun no se suelta, ciclarse.
    call    RUTINA_ANTIREBOTE	    ; Llamar rutina antirebote para evitar señales de regreso.
    incf    counter, F, A
    incf    counter, F, A	    ; Incrementar dos veces el contador.
    return
DECREMENTAR_2
    btfss   PORTC, menos	    ; Esperar a que se suelte el boton.
    goto    DECREMENTAR_2	    ; Si aun no se suelta, ciclarse.
    call    RUTINA_ANTIREBOTE	    ; Llamar rutina antirebote para evitar señales de regreso.
    decf    counter, F, A
    decf    counter, F, A	    ; Decrementar dos veces el contador.
    return
    
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
  
    
  END