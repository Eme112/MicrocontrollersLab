    #include "p18f45k50.inc"
    processor 18f45k50 	; (opcional).
    
    org 0x00
    goto CONFIGURE
    org 0x08 		; posición para interrupciones.
    retfie
    org 0x18		; posición para interrupciones.
    retfie
    
; DEFINICIÓN DE PUERTOS.
    #define RS LATC, 0, A	; RC0 -> Register Select.
    #define RW LATC, 1, A	; RC1 -> Read/Write.
    #define E LATC, 2, A	; RC2 -> Enable.
    #define flag PORTD, 7, A	; RD7 -> Busy flag.
    #define configFlag TRISD, 7, A  ; Switch flag from INPUT to OUTPUT and viceversa.
    #define dataLCD LATD, A
; DEFINICIÓN DE BITS QUE REPRESENTAN OPERACIONES.
    #define BIT_SUMA OP, 7, A
    #define BIT_RESTA OP, 6, A
    #define BIT_MULT OP, 5, A
    #define BIT_DIV OP, 4, A
; DEFINICIÓN DE REGISTROS VARIABLES.
NUM1		    EQU 0x10
NUM2		    EQU 0x11
OP		    EQU 0x12
TEMP		    EQU 0x13
TEMP2		    EQU 0x14
COUNTER		    EQU 0x15
DECENAS_UNIDADES    EQU 0x16
DECENAS		    EQU 0X17
UNIDADES	    EQU 0X18
OPERACION	    EQU 0X19
POSICION	    EQU 0x1A
NEG		    EQU 0X1B
; DEFINICION DE REGISTROS PARA DELAYS.
var1		    EQU 0x20
var2		    EQU 0x21
var3		    EQU 0x22
_256		    EQU 0x23
_26		    EQU 0x24
	
CONFIGURE
    org	0x40			; Código principal.
    movlb   .15
    bcf	    INTCON2, 7		; ENABLE pull-ups.
    clrf    ANSELB, BANKED	; REGB -> DIGITAL.
    movlw   b'00001111'	
    movwf   TRISB		; REGB -> Mitad entradas/salidas.
    movwf   WPUB		; REGB -> Mitad pull-ups.
    clrf    ANSELC, BANKED	; REGC -> Digital. 
    clrf    TRISC, A		; REGC -> Output.
    clrf    ANSELD, BANKED	; REGD -> Digital.
    clrf    TRISD, A		; REGD -> Output.
    clrf    NUM1		; El numero 1 empieza en 0.
    clrf    DECENAS_UNIDADES	; Empieza en 0.
    clrf    DECENAS		; Empieza en 0.
    clrf    UNIDADES		; Empieza en 0.
    


LCD_CONFIGURATION	
    bcf	    E
    call    delay100ms
    movlw   b'00111000'			; 8-bit, 2 lines, 5x7.
    call    INSTRUCTION_WRITE
    movlw   b'00000110'			; No display shift.
    call    INSTRUCTION_WRITE
    movlw   b'00010100'			; Increment cursor position, diplay shift.
    call    INSTRUCTION_WRITE
    movlw   b'00001111'			; Display on, cursor on, blynk on.
    call    INSTRUCTION_WRITE
    movlw   b'00000001'			; Clear display and return to home position.
    call    INSTRUCTION_WRITE
    
; PROCESO PARA RECIBIR DATOS Y MANDAR LLAMAR LA OPERACION ADECUADA.
NUMERO1
    movlw   0x00
    movwf   POSICION			; Posicion = 0x00.
    call    RECORRIDO
    movff   TEMP, NUM1			; El ultimo numero presionado sera NUM1.
    movff   TEMP2, OP			; El ultimo operando presionado sera OP.
    movf    OP, F, A			; Activar OP en STATUS.
    btfsc   STATUS, Z, A		; Revisa si OP = 0.
    goto    NUMERO1			; Eso significa RESET.
    movlw   b'00000001'			; Clear display and return to home position.
    call    INSTRUCTION_WRITE
    movf    TEMP, W, A
    call    CONVERSION			; Convertir el numero a decenas y unidades.
    movf    DECENAS, W, A		; Cargar decenas y enviar a la LCD.
    call    WRITE_NUMBER
    movf    UNIDADES, W, A		; Cargar unidades y enviar a la LCD.
    call    WRITE_NUMBER
    movf    OPERACION, W, A		; Cargar operacion y enviar a la LCD.
    call    DATA_WRITE
    
NUMERO2
    movlw   0x03
    movwf   POSICION			; Posicion = 0x03.
    call    RECORRIDO
    movff   TEMP, NUM2			; El ultimo numero presionado sera NUM2.
    movf    OP, F, A			; Activar OP en STATUS.
    btfsc   STATUS, Z, A		; Revisa si OP = 0.
    goto    NUMERO1			; Eso significa RESET.
    movf    NUM2, W, A
    movlw   '='				; Cargar igual y enviar a la LCD.
    call    DATA_WRITE
    movlw   0x40			; Mover cursor al segundo renglon para el resultado.
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
OPERACIONES
    btfsc   BIT_SUMA
    call    SUMA			; Si esta activo el bit de suma, llamar a SUMA.
    btfsc   BIT_RESTA
    call    RESTA			; Si esta activo el bit de resta, llamar a RESTA.
    btfsc   BIT_MULT
    call    MULTIPLICACION		; Si esta activo el bit de multiplicacion, llamar a MULTIPLICACION.
    btfsc   BIT_DIV
    call    DIVISION			; Si esta activo el bit de division, llamar a DIVISION.
    movf    OP, F, A			; Activar OP en STATUS.
    btfsc   STATUS, Z, A		; Revisa si OP = 0.
    goto    NUMERO1			; Eso significa RESET.
    movff   NUM1, TEMP			; Cargar el mismo numero en TEMP que en NUM1
    movf    NUM1, W, A			; Convertir el resultado almacenado en NUM1 a decenas y unidades.
    call    CONVERSION			; Convertir a decenas y unidades antes de la proxima repeticion.
    btfsc   NEG, 0
    call    IMPRIMIR_SIGNO		; Si el numero es negativo, cargar el signo a la LCD.
    movf    DECENAS, W, A		; Cargar decenas y enviar a la LCD.
    call    WRITE_NUMBER
    movf    UNIDADES, W, A		; Cargar unidades y enviar a la LCD.
    call    WRITE_NUMBER
    clrf    NEG
    
    goto    NUMERO1

IMPRIMIR_SIGNO
    movlw   '-'
    call    DATA_WRITE
    return
    
; PROCESO PARA HACER UN RECORRIDO Y DETECTAR ENTRADA DEL TECLADO.
RECORRIDO
    movlw   b'11101111'			; ACTIVAR COLUMNA 1 (1, 4, 7, *).
    movwf   LATB, A
    btfss   PORTB, 0, A			; Revisar si se presiona el 1.
    goto    UNO
    btfss   PORTB, 1, A			; Revisar si se presiona el 4.
    goto    CUATRO
    btfss   PORTB, 2, A			; Revisar si se presiona el 7.
    goto    SIETE
    btfss   PORTB, 3, A			; Revisar si se presiona el *.
    goto    ASTERISCO_RETURN
    movlw   b'11011111'			; ACTIVAR COLUMNA 2 (2, 5, 8, 0).
    movwf   LATB, A
    btfss   PORTB, 0, A			; Revisar si se presiona el 2.
    goto    DOS
    btfss   PORTB, 1, A			; Revisar si se presiona el 5.
    goto    CINCO
    btfss   PORTB, 2, A			; Revisar si se presiona el 8.
    goto    OCHO
    btfss   PORTB, 3, A			; Revisar si se presiona el 0.
    goto    CERO
    movlw   b'10111111'			; ACTIVAR COLUMNA 3 (3, 6, 9, #).
    movwf   LATB, A
    btfss   PORTB, 0, A			; Revisar si se presiona el 3.
    goto    TRES
    btfss   PORTB, 1, A			; Revisar si se presiona el 6.
    goto    SEIS
    btfss   PORTB, 2, A			; Revisar si se presiona el 9.
    goto    NUEVE
    btfss   PORTB, 3, A			; Revisar si se presiona el #.
    goto    GATO_RETURN
    movlw   b'01111111'			; ACTIVAR COLUMNA 4 (A, B, C, D).
    movwf   LATB, A
    btfss   PORTB, 0, A			; Revisar si se presiona el A.
    goto    _A_RETURN			; Los operandos son motivo para salir del ciclo.
    btfss   PORTB, 1, A			; Revisar si se presiona el B.
    goto    _B_RETURN			; Los operandos son motivo para salir del ciclo.
    btfss   PORTB, 2, A			; Revisar si se presiona el C.
    goto    _C_RETURN			; Los operandos son motivo para salir del ciclo.
    btfss   PORTB, 3, A			; Revisar si se presiona el D.
    goto    _D_RETURN			; Los operandos son motivo para salir del ciclo.    
    goto    RECORRIDO			; Si no se presiona un operando, seguir en espera.
    
; MENU DE BOTONES QUE NO LLEVAN A UN RETURN.
UNO
    btfss   PORTB, 0, A			; Revisar si sigue presionado el 1.
    goto    UNO				; Si aun no se suleta, esperar.
    movlw   .1
    movwf   TEMP, A
    movwf   LATA, A			; Prender un 1 en binario.
    call    DELAY_20ms			; Antirebote.
    goto    NEW_NUMBER			; Regresar a ver si se presiona otro boton.
DOS
    btfss   PORTB, 0, A			; Revisar si sigue presionado el 2.
    goto    DOS				; Si aun no se suleta, esperar.
    movlw   .2
    movwf   TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf   LATA, A			; Prender un 2 en binario.
    call    DELAY_20ms			; Antirebote.
    goto    NEW_NUMBER			; Regresar a ver si se presiona otro boton.
TRES
    btfss   PORTB, 0, A			; Revisar si sigue presionado el 3.
    goto    TRES			; Si aun no se suleta, esperar.
    movlw   .3
    movwf   TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf   LATA, A			; Prender un 3 en binario.
    call    DELAY_20ms			; Antirebote.
    goto    NEW_NUMBER			; Regresar a ver si se presiona otro boton.
CUATRO
    btfss   PORTB, 1, A			; Revisar si sigue presionado el 4.
    goto    CUATRO			; Si aun no se suleta, esperar.
    movlw   .4
    movwf   TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf   LATA, A			; Prender un 4 en binario.
    call    DELAY_20ms			; Antirebote.
    goto    NEW_NUMBER			; Regresar a ver si se presiona otro boton.
CINCO
    btfss   PORTB, 1, A			; Revisar si sigue presionado el 5.
    goto    CINCO			; Si aun no se suleta, esperar.
    movlw   .5
    movwf   TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf   LATA, A			; Prender un 5 en binario.
    call    DELAY_20ms			; Antirebote.
    goto    NEW_NUMBER			; Regresar a ver si se presiona otro boton.
SEIS
    btfss   PORTB, 1, A			; Revisar si sigue presionado el 6.
    goto    SEIS			; Si aun no se suleta, esperar.
    movlw   .6
    movwf   TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf   LATA, A			; Prender un 6 en binario.
    call    DELAY_20ms			; Antirebote.
    goto    NEW_NUMBER			; Regresar a ver si se presiona otro boton.
SIETE
    btfss   PORTB, 2, A			; Revisar si sigue presionado el 7.
    goto    SIETE			; Si aun no se suleta, esperar.
    movlw   .7
    movwf   TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf   LATA, A			; Prender un 7 en binario.
    call    DELAY_20ms			; Antirebote.
    goto    NEW_NUMBER			; Regresar a ver si se presiona otro boton.
OCHO
    btfss   PORTB, 2, A			; Revisar si sigue presionado el 8.
    goto    OCHO			; Si aun no se suleta, esperar.
    movlw   .8
    movwf   TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf   LATA, A			; Prender un 8 en binario.
    call    DELAY_20ms			; Antirebote.
    goto    NEW_NUMBER			; Regresar a ver si se presiona otro boton.
NUEVE
    btfss   PORTB, 2, A			; Revisar si sigue presionado el 9.
    goto    NUEVE			; Si aun no se suleta, esperar.
    movlw   .9
    movwf   TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf   LATA, A			; Prender un 9 en binario.
    call    DELAY_20ms			; Antirebote.
    goto    NEW_NUMBER			; Regresar a ver si se presiona otro boton.
CERO
    btfss   PORTB, 3, A			; Revisar si sigue presionado el 0.
    goto    CERO			; Si aun no se suleta, esperar.
    movlw   .0
    movwf   TEMP, A			; TEMP sirve para guardar el ultimo valor de WREG.
    movwf   LATA, A			; Prender un 0 en binario.
    call    DELAY_20ms			; Antirebote.
    goto    NEW_NUMBER			; Regresar a ver si se presiona otro boton.
NEW_NUMBER
    movf    POSICION, W, A		; Mover cursor a la posicion guardada.
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    movf    TEMP, W, A
    call    CONVERSION			; Convertir el numero a decenas y unidades.
    movf    DECENAS, W, A		; Cargar decenas y enviar a la LCD.
    call    WRITE_NUMBER
    movf    UNIDADES, W, A		; Cargar unidades y enviar a la LCD.
    call    WRITE_NUMBER
    goto    RECORRIDO
    
; MENU DE BOTONES QUE LLEVAN A UN RETURN.
_A_RETURN				; SUMA.
    btfss   PORTB, 0, A			; Revisar si sigue presionado el A.
    goto    _A_RETURN			; Si aun no se suleta, esperar.
    movlw   b'10000000'			; Se enciende bit de suma.
    movwf   TEMP2, A			; TEMP sirve para guardar el operando.
    movlw   '+'
    movwf   OPERACION			; Guardar símbolo.
    movwf   LATA, A			; Prender LED 7.
    call    DELAY_20ms			; Antirebote.
    return
_B_RETURN				; RESTA.
    btfss   PORTB, 1, A			; Revisar si sigue presionado el B.
    goto    _B_RETURN			; Si aun no se suleta, esperar.
    movlw   b'01000000'			; Se enciende bit de resta.
    movwf   TEMP2, A			; TEMP sirve para guardar el operando.
    movlw   '-'
    movwf   OPERACION			; Guardar símbolo.
    movwf   LATA, A			; Prender LED 6.
    call    DELAY_20ms			; Antirebote.
    return
_C_RETURN				; MULTIPLICACION.
    btfss   PORTB, 2, A			; Revisar si sigue presionado el C.
    goto    _C_RETURN			; Si aun no se suleta, esperar.
    movlw   b'00100000'			; Se enciende bit de multiplicacion.
    movwf   TEMP2, A			; TEMP sirve para guardar el operando.
    movlw   '*'
    movwf   OPERACION			; Guardar símbolo.
    movwf   LATA, A			; Prender LED 5.
    call    DELAY_20ms			; Antirebote.
    return
_D_RETURN				; DIVISION.
    btfss   PORTB, 3, A			; Revisar si sigue presionado el D.
    goto    _D_RETURN			; Si aun no se suleta, esperar.
    movlw   b'00010000'			; Se enciende bit de division.
    movwf   TEMP2, A			; TEMP sirve para guardar el operando.
    movlw   '/'
    movwf   OPERACION			; Guardar símbolo.
    movwf   LATA, A			; Prender LED 4.
    call    DELAY_20ms			; Antirebote.
    return
ASTERISCO_RETURN			; IGUAL.
    btfss   PORTB, 3, A			; Revisar si sigue presionado el *.
    goto    ASTERISCO_RETURN		; Si aun no se suleta, esperar.
    call    DELAY_20ms			; Antirebote.
    return				; Ir a la seleccion de operaciones.
GATO_RETURN				; RESET.
    btfss   PORTB, 3, A			; Revisar si sigue presionado el #.
    goto    GATO_RETURN			; Si aun no se suleta, esperar.
    clrf    WREG			; Borrar todo.
    clrf    NUM1
    clrf    NUM2
    clrf    OP
    clrf    TEMP
    clrf    TEMP2
    clrf    DECENAS_UNIDADES
    clrf    DECENAS
    clrf    UNIDADES
    clrf    LATA
    call    DELAY_20ms			; Antirebote.
    movlw   b'00000001'			; Clear display and return to home position.
    call    INSTRUCTION_WRITE
    return

; OPERACIONES
SUMA
    movf    NUM1, W, A			; Mover NUM1 a WREG.
    addwf   NUM2, W, A			; Sumarle NUM2.
    movwf   NUM1, A			; Guardar el resultado en NUM1.
    return
    
RESTA
    movf    NUM2, W, A			; Mover NUM2 a WREG.
    subwf   NUM1, W, A			; Restar NUM1-NUM2.
    movwf   WREG, A			; Activar WREG en STATUS.
    btfsc   STATUS, N, A		; Checar si dio un numero negativo.
    goto    NEGATIVO
    movwf   NUM1, A			; Guardar el resultado en NUM1.
    return
NEGATIVO
    movf    NUM1, W, A			; Mover NUM1 a WREG.
    subwf   NUM2, W, A			; Restar NUM2-NUM1 (al reves).
    movwf   NUM1			; Guardar en NUM1.
    setf    NEG			; Encender el registro para representar num negativo.
    return
    
MULTIPLICACION
    movf    NUM1, W, A			; Mover NUM1 a WREG.
    mulwf   NUM2, A			; Multiplicar NUM1*NUM2.
    movff   PRODL, NUM1			; Copiar el resultado guardado en PRODL a NUM1.
    return
    
DIVISION
    movf    NUM2, F, A			; Activar NUM2 en STATUS.
    btfsc   STATUS, Z, A
    goto    _ERROR			; Si NUM2 = 0, ir a _ERROR.
    clrf    COUNTER, A			; Resetear el contador.
    movf    NUM2, W, A			; Cargar NUM2 en WREG.
CUENTA
    subwf   NUM1, F, A			; Se resta NUM1-NUM2 y se guarda en NUM1.
    movf    NUM1, F, A			; Activar NUM1 en STATUS.
    btfsc   STATUS, N, A
    goto    CUENTA_FINAL		; Si NUM1 ya es negativo, hacer procedimientos antes de regresar.
    incf    COUNTER			; De lo contrario, aumentar el contador y repetir.
    goto    CUENTA
CUENTA_FINAL
    movff   COUNTER, NUM1		; NUM1 es igual a la cuenta almacenada.
    return
    
_ERROR
    movlw   0x40			; Mover cursor al segundo renglon para el resultado.
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    movlw   'E'				; Escribir mensaje de error.
    call    DATA_WRITE
    movlw   'R'
    call    DATA_WRITE
    movlw   'R'
    call    DATA_WRITE
    movlw   'O'
    call    DATA_WRITE
    movlw   'R'
    call    DATA_WRITE
    movlw   b'10111111'			; ACTIVAR COLUMNA 3 (3, 6, 9, #).
    movwf   LATB, A
loop 
    btfss   PORTB, 3, A			; Revisar si se presiona el #.
    goto    GATO_RETURN
    goto    loop
    
CONVERSION
    movwf   DECENAS_UNIDADES		; Cargar el numero a convertir en DECENAS_UNIDADES.
    clrf    COUNTER, A			; Resetear el contador.
    movlw   .10				; Cargar un 10 en WREG.
CUENTA_DECENAS
    movff   DECENAS_UNIDADES, UNIDADES	; Antes de restarle, guardar el resultado anterior en UNIDADES.
    subwf   DECENAS_UNIDADES, F, A	; Se resta DECENAS-10 y se guarda en NUM1.
    movf    DECENAS_UNIDADES, F, A	; Activar DECENAS en STATUS.
    btfsc   STATUS, N, A
    goto    CUENTA_DECENAS_FINAL	; Si NUM1 ya es negativo, hacer procedimientos antes de regresar.
    incf    COUNTER			; De lo contrario, aumentar el contador y repetir.
    goto    CUENTA_DECENAS
CUENTA_DECENAS_FINAL
    movff   COUNTER, DECENAS_UNIDADES	
    movff   COUNTER, DECENAS		; DECENAS es igual a la cuenta almacenada de decenas.
    movf    UNIDADES, W, A		; Mover el valor almacenado en TEMP2 (residuo) a WREG.
    return

WRITE_NUMBER
    movwf   var1			; Guardar el numero a convertir en var1.
    movlw   .48				; Sumarle 48 y guardar en WREG
    addwf   var1, W, A			; para convertir en ASCII.	
    call    DATA_WRITE
    return
    
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
    call    ESPERA_LCD		; Wait to see if LCD is done.
    return
    
ESPERA_LCD
    bsf	    configFlag		; RD7 -> INPUT (to be able to  read it).
    bcf	    RS			; RS -> 0
    bsf	    RW			; RW -> 1
    bsf	    E			; E -> 1
    nop
REGRESA
    ;call    delay100ms		; Wait 100us.
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