#include "p18f45k50.inc"
    processor 18f45k50 	; (opcional).
    org 0x00
    goto CONFIGURA
    org 0x08 		; posición para interrupciones.
    retfie
    org 0x18		; posición para interrupciones.
    retfie
    org 0x30 		; Origen real (opcional pero recomendado).
; Definicion de registros variables.
NUM1	EQU 0x10
NUM2	EQU 0x11
OP	EQU 0x12
TEMP	EQU 0x13
TEMP2	EQU 0x14
COUNTER	EQU 0x15
; Definicion de registros para el delay de 20ms.
_256	EQU 0x20
_26	EQU 0x21
; Definicion de equivalencias para bit que representa operaciones.
	#define BIT_SUMA OP, 7, A
	#define BIT_RESTA OP, 6, A
	#define BIT_MULT OP, 5, A
	#define BIT_DIV OP, 4, A
 
CONFIGURA
    movlb .15
    clrf ANSELA, BANKED			; REGA -> DIGITAL.
    clrf ANSELB, BANKED			; REGB -> DIGITAL.
    bcf INTCON2, 7			; ENABLE pull-ups.
    movlw B'00001111'			
    movwf TRISB				; Mitad entradas/salidas.
    movwf WPUB				; Mitad pull-ups.
    clrf TRISA				; REGA -> OUTPUT.
    clrf LATA				; Limpiar la salida A.
    clrf NUM1				; El numero 1 empieza en 0.

; PROCESO PARA RECIBIR DATOS Y MANDAR LLAMAR LA OPERACION ADECUADA.
NUMERO1
    movff NUM1, LATA			; Antes, encender el resultado anterior.
    call RECORRIDO
    movff TEMP, NUM1			; El ultimo numero presionado sera NUM1.
    movff TEMP2, OP			; El ultimo operando presionado sera OP.
    movf OP, F, A			; Activar OP en STATUS.
    btfsc STATUS, Z, A			; Revisa si OP = 0.
    goto NUMERO1			; Eso significa RESET.
    
NUMERO2
    call RECORRIDO
    movff TEMP, NUM2			; El ultimo numero presionado sera NUM2.
    movf OP, F, A			; Activar OP en STATUS.
    btfsc STATUS, Z, A			; Revisa si OP = 0.
    goto NUMERO1			; Eso significa RESET.
    
OPERACIONES
    btfsc BIT_SUMA
    call SUMA				; Si esta activo el bit de suma, ir a SUMA.
    btfsc BIT_RESTA
    call RESTA				; Si esta activo el bit de suma, ir a SUMA.
    btfsc BIT_MULT
    call MULTIPLICACION			; Si esta activo el bit de suma, ir a SUMA.
    btfsc BIT_DIV
    call DIVISION			; Si esta activo el bit de suma, ir a SUMA.
    movf OP, F, A			; Activar OP en STATUS.
    btfsc STATUS, Z, A			; Revisa si OP = 0.
    goto NUMERO1			; Eso significa RESET.
    movff NUM1, TEMP			; Cargar el mismo numero en TEMP que en NUM1
    goto NUMERO1			; (para la proxima repeticion en NUMERO1).

; PROCESO PARA HACER UN RECORRIDO Y DETECTAR ENTRADA DEL TECLADO.
RECORRIDO
    movlw b'11101111'			; ACTIVAR COLUMNA 1 (1, 4, 7, *).
    movwf LATB, A
    btfss PORTB, 0, A			; Revisar si se presiona el 1.
    goto UNO
    btfss PORTB, 1, A			; Revisar si se presiona el 4.
    goto CUATRO
    btfss PORTB, 2, A			; Revisar si se presiona el 7.
    goto SIETE
    btfss PORTB, 3, A			; Revisar si se presiona el *.
    goto ASTERISCO_RETURN
    movlw b'11011111'			; ACTIVAR COLUMNA 2 (2, 5, 8, 0).
    movwf LATB, A
    btfss PORTB, 0, A			; Revisar si se presiona el 2.
    goto DOS
    btfss PORTB, 1, A			; Revisar si se presiona el 5.
    goto CINCO
    btfss PORTB, 2, A			; Revisar si se presiona el 8.
    goto OCHO
    btfss PORTB, 3, A			; Revisar si se presiona el 0.
    goto CERO
    movlw b'10111111'			; ACTIVAR COLUMNA 3 (3, 6, 9, #).
    movwf LATB, A
    btfss PORTB, 0, A			; Revisar si se presiona el 3.
    goto TRES
    btfss PORTB, 1, A			; Revisar si se presiona el 6.
    goto SEIS
    btfss PORTB, 2, A			; Revisar si se presiona el 9.
    goto NUEVE
    btfss PORTB, 3, A			; Revisar si se presiona el #.
    goto GATO_RETURN
    movlw b'01111111'			; ACTIVAR COLUMNA 4 (A, B, C, D).
    movwf LATB, A
    btfss PORTB, 0, A			; Revisar si se presiona el A.
    goto _A_RETURN			; Los operandos son motivo para salir del ciclo.
    btfss PORTB, 1, A			; Revisar si se presiona el B.
    goto _B_RETURN			; Los operandos son motivo para salir del ciclo.
    btfss PORTB, 2, A			; Revisar si se presiona el C.
    goto _C_RETURN			; Los operandos son motivo para salir del ciclo.
    btfss PORTB, 3, A			; Revisar si se presiona el D.
    goto _D_RETURN			; Los operandos son motivo para salir del ciclo.
    goto RECORRIDO			; Si no se presiona un operando, seguir en espera.

; MENU DE BOTONES QUE NO LLEVAN A UN RETURN.
UNO
    btfss PORTB, 0, A			; Revisar si sigue presionado el 1.
    goto UNO				; Si aun no se suleta, esperar.
    movlw .1
    movwf TEMP, A
    movwf LATA, A			; Prender un 1 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
DOS
    btfss PORTB, 0, A			; Revisar si sigue presionado el 2.
    goto DOS				; Si aun no se suleta, esperar.
    movlw .2
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 2 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
TRES
    btfss PORTB, 0, A			; Revisar si sigue presionado el 3.
    goto TRES				; Si aun no se suleta, esperar.
    movlw .3
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 3 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
CUATRO
    btfss PORTB, 1, A			; Revisar si sigue presionado el 4.
    goto CUATRO				; Si aun no se suleta, esperar.
    movlw .4
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 4 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
CINCO
    btfss PORTB, 1, A			; Revisar si sigue presionado el 5.
    goto CINCO				; Si aun no se suleta, esperar.
    movlw .5
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 5 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
SEIS
    btfss PORTB, 1, A			; Revisar si sigue presionado el 6.
    goto SEIS				; Si aun no se suleta, esperar.
    movlw .6
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 6 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
SIETE
    btfss PORTB, 2, A			; Revisar si sigue presionado el 7.
    goto SIETE				; Si aun no se suleta, esperar.
    movlw .7
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 7 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
OCHO
    btfss PORTB, 2, A			; Revisar si sigue presionado el 8.
    goto OCHO				; Si aun no se suleta, esperar.
    movlw .8
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 8 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
NUEVE
    btfss PORTB, 2, A			; Revisar si sigue presionado el 9.
    goto NUEVE				; Si aun no se suleta, esperar.
    movlw .9
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 9 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
CERO
    btfss PORTB, 3, A			; Revisar si sigue presionado el 0.
    goto CERO				; Si aun no se suleta, esperar.
    movlw .0
    movwf TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf LATA, A			; Prender un 0 en binario.
    call DELAY_20ms			; Antirebote.
    goto RECORRIDO			; Regresar a ver si se presiona otro boton.
    
; MENU DE BOTONES QUE LLEVAN A UN RETURN.
_A_RETURN				; SUMA.
    btfss PORTB, 0, A			; Revisar si sigue presionado el A.
    goto _A_RETURN			; Si aun no se suleta, esperar.
    movlw b'10000000'			; Se enciende bit de suma.
    movwf TEMP2, A			; TEMP sirve para guardar el operando.
    movwf LATA, A			; Prender bit 7.
    call DELAY_20ms			; Antirebote.
    return
_B_RETURN				; RESTA.
    btfss PORTB, 1, A			; Revisar si sigue presionado el B.
    goto _B_RETURN			; Si aun no se suleta, esperar.
    movlw b'01000000'			; Se enciende bit de resta.
    movwf TEMP2, A			; TEMP sirve para guardar el operando.
    movwf LATA, A			; Prender bit 6.
    call DELAY_20ms			; Antirebote.
    return
_C_RETURN				; MULTIPLICACION.
    btfss PORTB, 2, A			; Revisar si sigue presionado el C.
    goto _C_RETURN			; Si aun no se suleta, esperar.
    movlw b'00100000'			; Se enciende bit de multiplicacion.
    movwf TEMP2, A			; TEMP sirve para guardar el operando.
    movwf LATA, A			; Prender bit 5.
    call DELAY_20ms			; Antirebote.
    return
_D_RETURN				; DIVISION.
    btfss PORTB, 3, A			; Revisar si sigue presionado el D.
    goto _D_RETURN			; Si aun no se suleta, esperar.
    movlw b'00010000'			; Se enciende bit de division.
    movwf TEMP2, A			; TEMP sirve para guardar el operando.
    movwf LATA, A			; Prender bit 4.
    call DELAY_20ms			; Antirebote.
    return
ASTERISCO_RETURN			; IGUAL.
    btfss PORTB, 3, A			; Revisar si sigue presionado el *.
    goto ASTERISCO_RETURN		; Si aun no se suleta, esperar.
    call DELAY_20ms			; Antirebote.
    return				; Ir a la seleccion de operaciones.
GATO_RETURN				; RESET.
    btfss PORTB, 3, A			; Revisar si sigue presionado el #.
    goto GATO_RETURN			; Si aun no se suleta, esperar.
    clrf WREG				; Borrar todo.
    clrf NUM1
    clrf NUM2
    clrf OP
    clrf TEMP
    clrf TEMP2
    clrf LATA
    call DELAY_20ms			; Antirebote.
    return

; OPERACIONES
SUMA
    movf NUM1, W, A			; Mover NUM1 a WREG.
    addwf NUM2, W, A			; Sumarle NUM2.
    movwf NUM1, A			; Guardar el resultado en NUM1.
    return
RESTA
    movf NUM2, W, A			; Mover NUM2 a WREG.
    subwf NUM1, W, A			; Restar NUM1-NUM2.
    movwf WREG, A			; Activar WREG en STATUS.
    btfsc STATUS, N, A			; Checar si dio un numero negativo.
    goto NEGATIVO
    movwf NUM1, A			; Guardar el resultado en NUM1.
    return
NEGATIVO
    movf NUM1, W, A			; Mover NUM1 a WREG.
    subwf NUM2, W, A			; Restar NUM2-NUM1 (al reves).
    movwf NUM1				; Guardar en NUM1.
    bsf NUM1, 7, A			; Activar bit de negativo.
    return
MULTIPLICACION
    movf NUM1, W, A			; Mover NUM1 a WREG.
    mulwf NUM2, A			; Multiplicar NUM1*NUM2.
    movff PRODL, NUM1			; Copiar el resultado guardado en PRODL a NUM1.
    return
DIVISION
    movf NUM2, F, A			; Activar NUM2 en STATUS.
    btfsc STATUS, Z, A
    goto _ERROR				; Si NUM2 = 0, ir a _ERROR.
    movlw .0
    movwf COUNTER, A			; Resetear el contador.
    movf NUM2, W, A			; Cargar NUM2 en WREG.
CUENTA
    subwf NUM1, F, A			; Se resta NUM1-NUM2 y se guarda en NUM1.
    movf NUM1, F, A			; Activar NUM1 en STATUS.
    btfsc STATUS, N, A
    goto CUENTA_FINAL			; Si NUM1 ya es negativo, hacer procedimientos antes de regresar.
    incf COUNTER			; De lo contrario, aumentar el contador y repetir.
    goto CUENTA
CUENTA_FINAL
    movff COUNTER, NUM1			; NUM1 es igual a la cuenta almacenada.
    return
_ERROR
    movlw 0xFF
    movwf NUM1				; En caso de error, encender todos los LEDs.
    return
    
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