;Practica 5 Ejercicio 1
;Diseña un programa que cuando se active, el bit menos significativo (NNNN-NNNX)
;encienda por un segundo y luego se apague por otro segundo (el LED debe parpadear)

;DESGINAMOS 4 BOTONES PARA NUESTRAS RUTINAS
;B1: ACTIVA LA RUTINA A
;B2: ACTIVA LA RUTINA B
;B3: ACTIVA LA RUTINA B
;B4: NUESTRO BOTON DE PAUSA
    
#include "p18f45k50.inc"
    processor 18F45K50 
    RADIX DEC ;DEFINIMO COMO TRABAJARA NUESTRO RADIX
    org 0x00
;X	EQU 0 ; DEFICINMOS NUESTRA VARIABLE X
;Y	EQU 1 ; DEFINIMOS NUESTRA VARIABLE Y
; Equivalencias botones
b1	EQU 0
b2	EQU 1
b3	EQU 2
b4	EQU 6
; Equivalencias para variables.
LED	EQU 0 ; GUARDAMOS EL VALOR DEL LED
; Equivalencias para el delay de 500ms.
_256_1	EQU 10
_256_2	EQU 11
_2	EQU 12
_137	EQU 13
; Equivalencias para el delay de 20ms.
_26	EQU 14
   
MAIN_CONF
    MOVLB 15
    CLRF ANSELB,BANKED ; DESIGNAMOS UN PUERTO DIGITAL
    CLRF ANSELC,BANKED ; DESIGNAMOS UN SEGUNDO PUERTO DIGITAL
    CLRF TRISB ; ACTIVAMOS EL PUERTO 'B' COMO SALIDA
    SETF TRISC ; ACTIVAMOS PUERTO 'C' COMO ENTRADA
    CLRF LATB  ; LIMPIAMOS EL PUERTO DE B
    MOVLW D'1' ; MOVEMOS EL VALOR HACIA EL WREG
    MOVWF LED,0 ; MOVEMOS EL VALOR DEL WREF A NUESTRO REGISTRO LED

MENU ; ASIGNAMOS EL PUERTO 'C' PARA NUESTROS BOTONES DE SALIDA
    BTFSS PORTC,b1  ; SALTA UNA LINEA SI EL BOTÓN 1 ESTA ACTIVO.
    GOTO RUTINA_A 
    BTFSS PORTC,b2  ; SALTA UNA LINEA SI EL BOTÓN 2 ESTA ACTIVO.
    GOTO RUTINA_B
    BTFSS PORTC,b3  ; SALTA UNA LINEA SI EL BOTÓN 3 ESTA ACTIVO.
    GOTO RUTINA_C
    BTFSS PORTC,b4  ; SALTA UNA LINEA SI EL BOTÓN 4 ESTA ACTIVO.
    CALL PAUSE
    GOTO PARPADEO    

PARPADEO ;RUTINA PARA QUE NUESTRO LED PARPADEE
    MOVFF LED,LATB ;MOVEMOS DIRECTO NUESTRO REGISTRO
    CALL rutinaAntiRebote	 ;ANTIREBOTE
    CLRF LATB		 ;LIMPIAMOS EL PUERTO 'B' QUE DEFINE SALIDA
    CALL rutinaAntiRebote	 ;ANTIREBOTE
    GOTO MENU
    
RUTINA_A ;LEDS SE ENCIENDEN DE DERECHA --> IZQUIERDA AL PRESIONAR 'B1'
    CALL rutinaAntiRebote	;ANTIREBOTE
    MOVFF LED,LATB
    GOTO B1    

B1 ;BOTON PARA ACTIVAS NUESTRA RUTINA 'A'
    RRNCF LATB,F,A
    MOVFF LATB,LED
    CALL rutinaAntiRebote	;ANTIREBOTE					    OJO AQUI QUE SE MANDA DOS VECES
    BTFSS PORTC,b4 ;REVISAMOS SI NUESTROO BOTON 'B4' (PAUSA) ESTA PRESIONADO
    CALL PAUSE
    BTFSC PORTC,b1 ;REVISAMOS SI DESEAMOS SALIR DE LA RUTINA ACTIVADA 
    GOTO B1
    CALL rutinaAntiRebote	;ANTIREBOTE
    GOTO MENU

RUTINA_B ;LEDS SE ENCIENDEN DE IZQUIERDA --> DERECHA AL PRESIONAR 'B2'
    
    CALL rutinaAntiRebote	;ANTIREBOTE
    MOVFF LED,LATB
    GOTO B2
   
B2	;BOTON RUTINA 'B'
    RLNCF LATB,F,A
    MOVFF LATB,LED
    CALL rutinaAntiRebote	;ANTIREBOTE
    BTFSS PORTC,b4 ;REVISAMOS SI NUESTROO BOTON 'B4' (PAUSA) ESTA PRESIONADO
    CALL PAUSE
    BTFSC PORTC,b2 ;REVISAMOS SI DESEAMOS SALIR DE LA RUTINA ACTIVADA 
    GOTO B2
    CALL rutinaAntiRebote	;ANTIREBOTE
    GOTO MENU

RUTINA_C ;LEDS SE ENCIENDEN DE DERECHA -> IZQUIERDA Y DE REGRESO AL PULSAR 'B3' 
    
    CALL rutinaAntiRebote	;ANTIREBOTE
    MOVFF LED,LATB
    GOTO B3
B3 ;BOTON RUTINA 'C'
    RRNCF LATB,F,A
    MOVFF LATB,LED
    CALL rutinaAntiRebote	;ANTIREBOTE
    BTFSS PORTC,b4 ;REVISAMOS SI NUESTROO BOTON 'B4' (PAUSA) ESTA PRESIONADO
    CALL PAUSE
    BTFSC PORTC,b2 ;REVISAMOS SI DESEAMOS SALIR DE LA RUTINA ACTIVADA 
    GOTO RevisarB3
    CALL rutinaAntiRebote	;ANTIREBOTE
    GOTO MENU
RevisarB3 ; REVISAMOS SI SE ESTA MOVIENDO A LA DERECHA EL ENCENDIDO
    BTFSC LATB,0 ;REVISA SI NUESTRO LED ENCENDIDO ESTA AL EXTREMO 
    GOTO B3
    GOTO B3.2
	
B3.2	;LEDS ENCENDIENDO A LA IZQUIERDA
    RLNCF LATB,F,A
    MOVFF LATB,LED
    CALL rutinaAntiRebote	;ANTIREBOTE
    BTFSS PORTC,b4
    CALL PAUSE
    BTFSC PORTC,b3
    GOTO RevisarB3.2
    CALL rutinaAntiRebote	;ANTIREBOTE
    GOTO MENU
RevisarB3.2;REVISAMOS SI SE ESTA MOVIENDO A LA IZQUIERDA EL ENCENDIDO
    BTFSC LATB,7 ;REVISA SI NUESTRO LED ENCENDIDO ESTA AL EXTREMO  
    GOTO B3
    GOTO B3.2
	
PAUSE ;RUTINA PARA NUESTRO BOTON DE PAUSADO
    CALL rutinaAntiRebote	 ;ANTIREBOTE
    BTFSS PORTC,b4 ;REVISAMOS SI NUESTROO BOTON 'B4' (PAUSA) ESTA PRESIONADO
    RETURN
    GOTO PAUSE
    	
;ANTIR  ;RUTINA ANTIREBOTE
    ;MOVLW 0XFF
    ;MOVWF X
    ;MOVWF Y

;LOOP
    ;DECFSZ Y
    ;GOTO LOOP
    ;DECFSZ X
    ;GOTO LOOP
    ;RETURN   
    
delay500ms
    movlw   .0			
    movwf   _256_1
    movwf   _256_2
    movlw   .2
    movwf   _2	
    movlw   .137
    movwf   _137	
    ; 7us approx. in this section    
loop1				
    decfsz  _256_1
    goto    loop1		; (3)*256^2
    decfsz  _256_2
    goto    loop1		; (3)*256
    decfsz  _2
    goto    loop1		; (3)*(256^2+256)*2 + (3)*2 = 6*256^2 + 6*256 + 6
    ; 394,758us approx.
loop2				
    decfsz  _256_1		
    goto    loop2		; (3)*256
    decfsz  _137		
    goto    loop2		; (3)*256*137 + (3)*137 = 411*256 + 411
    ; 105,627us approx.
    ; === 500,385ms approx.===
    return

rutinaAntiRebote
    movlw   .0			
    movwf   _256_1
    movlw   .26
    movwf   _26	
loop3
    decfsz  _256_1
    goto    loop3		; (3)*256
    decfsz  _26
    goto    loop3		; (3)*256*26 + (3)*26 = 78*256 + 78
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
