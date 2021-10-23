#include "p18f45k50.inc"
    processor 18f45k50 	; (opcional).
    org 0x00
    goto CONFIGURA
    org 0x08 		; posición para interrupciones.
    retfie
    org 0x18		; posición para interrupciones.
    retfie
    org 0x30 		; Origen real (opcional pero recomendado).

; DEFINICION DE EQUIVALENCIAS.
var1		    EQU 0x00
var2		    EQU 0x01
var3		    EQU 0x02
_256		    EQU 0x03
_26		    EQU 0x04
puntaje		    EQU 0x05
boton_presionado    EQU 0x06
boton_esperado	    EQU 0x07
register_loser	    EQU 0x08
shifter		    EQU 0x09
sec1		    EQU 0x11
sec2		    EQU 0x12
sec3		    EQU 0x13
sec4		    EQU 0x14
sec5		    EQU 0x15
sec6		    EQU 0x16
sec7		    EQU 0x17
sec8		    EQU 0x18
sec9		    EQU 0x19
sec10		    EQU 0x1A


; DEFINICION DE LEDS Y BIT REPRESENTATIVO DE CADA COLOR.
    #define led_azul		LATA, 0, A
    #define led_amarillo	LATA, 1, A
    #define led_naranja		LATA, 2, A
    #define led_blanco		LATA, 3, A
    #define led_rojo		LATA, 4, A
    #define led_verde		LATA, 5, A
    #define fila1		PORTB, 0, A
    #define fila2		PORTB, 1, A
    #define bit_led_azul	boton_presionado, 0, A
    #define bit_led_amarillo	boton_presionado, 1, A
    #define bit_led_naranja	boton_presionado, 2, A
    #define bit_led_blanco	boton_presionado, 3, A
    #define RS			LATC, 0, A		; RB0 -> Register Select.
    #define E			LATC, 1, A		; RB1 -> Enable.
    #define RW			LATC, 2, A		; RB2 -> Read/Write.
    #define flag		PORTD, 7, A		; RD7 -> Busy flag.
    #define configFlag		TRISD, 7, A		; Switch flag from INPUT to OUTPUT and viceversa.
    #define dataLCD		LATD, A
    #define perdio		0x10, 0, A		; Se activa este bit cuando el usuario pierde.
    #define correcto		0x10, 1, A		; Se activa cuando se presiona el boton correcto.
    #define para		0x10, 2, A		; Se activa este bit cuando el usuario presiona el boton de paro.
    
CONFIGURA
    movlb   .15
    clrf    ANSELA, BANKED			; REGA -> DIGITAL.
    clrf    ANSELB, BANKED			; REGB -> DIGITAL.
    clrf    ANSELC, BANKED			; REGC -> DIGITAL.
    clrf    ANSELD, BANKED			; REGD -> DIGITAL.
    bcf	    INTCON2, 7				; ENABLE pull-ups.
    movlw   B'00000011'			
    movwf   TRISB				; 3 salidas, 2 entradas.
    movwf   WPUB				; habilitar 2 pull ups.
    clrf    TRISA				; REGA -> OUTPUT.
    clrf    TRISC				; REGC-> OUTPUT.
    clrf    TRISD				; REGD -> OUTPUT.
    clrf    LATA				; Limpiar la salida A.
    clrf    LATC				; Limpiar la salida C.
    clrf    LATD				; Limpiar la salida D.
    clrf    PR2, A				; CONFIGURA E INICIA TIMER2 PARA EL NUM ALEATORIO
    movlw   b'00000100'				; TMR2 ON, 1:1 , NO POST
    movwf   T2CON
    movlw   '0'
    movwf   puntaje, A
    bcf	    perdio				; Asegura que empieza desactivada la opcion de perder.
    bcf	    correcto				; Asegura que empieza desactivada el bit de boton correcto.
    bcf	    para				; Asegura que empieza desactivada la opcion de STOP.
    goto    MAIN
    
DELAY_100us
    movlw   .33
    movwf   var1
loop1				
    decfsz  var1 
    goto    loop1    
    return ; 100us approx.

DELAY_100ms
    movlw   .0		
    movwf   var1
    movlw   .128
    movwf   var2
loop2				
    decfsz  var1
    goto    loop2
    decfsz  var2
    goto    loop2
    return      ; 100ms approx.
    
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
    
TIMER_5s
    movlw   b'00000111'		; Configuración T0CON
    movwf   T0CON, A
    movlw   b'10110011'
    movwf   TMR0H,A
    movlw   b'10110100'
    bcf	    INTCON,2,A
    movwf   TMR0L,A   
    bsf	    T0CON,7,A		; Activa conteo
espera	
    btfsc   INTCON,2,A		; Si se activa la bandera del TIMER, ir a TIME_OUT.
    goto    TIME_OUT
    call    RECORRIDO_JUEGO	; Checar que boton se presiona.
    btfsc   para		; Si se presiono el boton de paro, ir a STOP.
    goto    STOP
    btfsc   correcto		; Si se presiono el boton correcto, continuar.
    return
    goto    espera
TIME_OUT
    call    _SAD_PIXELS
    call    SHOW_TIMES_OVER
GAME_OVER
    call    ON_RED
STOP
    call    _LOADING_CHARS_PERDER
    call    _WRITING_LOSER_ANIM
    ; TODO: Imprimir puntaje obtenido.
    call    SHOW_HIGHSCORE
    ; TODO: Guardar en la EEPROM si fue highscore.
    bsf	    perdio
    return
NIVEL_SUPERADO
    call    ON_GREEN
    call    _LOADING_CHARS_GANAR
    call    _WRITING_WINNER_ANIM
    ; TODO: Mostrar puntaje obtenido.
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
    nop				; Wait 1us to make sure the instruction was received.
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
    call    DELAY_100us		; Wait 100us.
    btfsc   flag		; Read bussy flag.
    goto    REGRESA		; If set, keep waiting.
    bcf	    E
    bcf	    configFlag		; RD7 -> OUTPUT again.
    return			; If not set, return.

CONFIGURE_LCD	
    bcf	    E
    call    DELAY_100ms
    movlw   b'00111000'		; 8-bit, 2 lines, 5x7.
    call    INSTRUCTION_WRITE
    movlw   b'00001111'		; Display on, cursor on, blynk on.
    call    INSTRUCTION_WRITE
    movlw   b'00000111'		; Increment cursor position, display shift.
    call    INSTRUCTION_WRITE
    movlw   b'00000001'		; Clear display and return to home position.
    call    INSTRUCTION_WRITE
    return

SHOW_MAIN_MENU
    movlw   'A'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE
    movlw   '-'			
    call    DATA_WRITE
    movlw   '>'			
    call    DATA_WRITE
    
    ;SPACE
    movlw   0x05	
    bsf     WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'N'			
    call    DATA_WRITE
    movlw   'E'			
    call    DATA_WRITE
    movlw   'W'			
    call    DATA_WRITE
    
    ;SPACE
    movlw   0x09
    bsf	WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'G'			
    call    DATA_WRITE
    movlw   'A'			
    call    DATA_WRITE
    movlw   'M'			
    call    DATA_WRITE
    movlw   'E'			
    call    DATA_WRITE
    
    ;SECOND LINE
    movlw   0x40
    bsf	WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'B'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE
    movlw   '-'			
    call    DATA_WRITE
    movlw   '>'			
    call    DATA_WRITE
    
    ;SPACE
    movlw   0x45	
    bsf	WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'H'			
    call    DATA_WRITE
    movlw   'I'			
    call    DATA_WRITE
    movlw   'G'			
    call    DATA_WRITE
    movlw   'H'			
    call    DATA_WRITE
    
    ;SPACE
    movlw   0x4A
    bsf	WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'S'			
    call    DATA_WRITE
    movlw   'C'			
    call    DATA_WRITE
    movlw   'O'			
    call    DATA_WRITE
    movlw   'R'			
    call    DATA_WRITE
    movlw   'E'			
    call    DATA_WRITE
    movlw   'S'			
    call    DATA_WRITE
    return
    
_LOADING_CHARS_TIEMPO
    ; write custom characters
    movlw .0
    bsf WREG, 6, A ; set CGRAM to address 0 to start loading custom char
    call INSTRUCTION_WRITE
    call _SAD_PIXELS
    return
 
 
_SAD_PIXELS
    ; first square .0 char
    movlw b'00000'
    call DATA_WRITE
    movlw b'00110'
    call DATA_WRITE
    movlw b'00110'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00001'
    call DATA_WRITE
    movlw b'00110'
    call DATA_WRITE
    movlw b'01000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    ; second square .8 char
    movlw b'00000'
    call DATA_WRITE
    movlw b'01100'
    call DATA_WRITE
    movlw b'01100'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'10000'
    call DATA_WRITE
    movlw b'01100'
    call DATA_WRITE
    movlw b'00010'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    return
    
_LOADING_CHARS_GANAR
    ; write custom characters
    movlw .0
    bsf WREG, 6, A ; set CGRAM to address 0 to start loading custom char
    call INSTRUCTION_WRITE
    call _WINNER_PIXELS
    return
 
 
_WINNER_PIXELS
    ; first square .0 char
    movlw b'00000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    movlw b'01110'
    call DATA_WRITE
    ; second square .8 char
    movlw b'00000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    movlw b'01110'
    call DATA_WRITE
    movlw b'10101'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    ; third square .16 char
    movlw b'00000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    movlw b'01110'
    call DATA_WRITE
    movlw b'10101'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    ; fourth square .24 char
    movlw b'00100'
    call DATA_WRITE
    movlw b'01110'
    call DATA_WRITE
    movlw b'10101'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    ; fifth square .32 char
    movlw b'10101'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    ; sixth square .40 char
    movlw b'00100'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    return

_LOADING_CHARS_PERDER
    ; write custom characters
    movlw .0
    bsf WREG, 6, A ; set CGRAM to address 0 to start loading custom char
    call INSTRUCTION_WRITE
    call _LOSING_PIXELS
    return
    
_LOSING_PIXELS
    ; first square .0 char
    movlw b'00011'
    call DATA_WRITE
    movlw b'01111'
    call DATA_WRITE
    movlw b'01111'
    call DATA_WRITE
    movlw b'11111'
    call DATA_WRITE
    movlw b'11111'
    call DATA_WRITE
    movlw b'11101'
    call DATA_WRITE
    movlw b'11001'
    call DATA_WRITE
    movlw b'11011'
    call DATA_WRITE
    ; second square .8 char
    movlw b'10000'
    call DATA_WRITE
    movlw b'11100'
    call DATA_WRITE
    movlw b'11100'
    call DATA_WRITE
    movlw b'11110'
    call DATA_WRITE
    movlw b'11110'
    call DATA_WRITE
    movlw b'01110'
    call DATA_WRITE
    movlw b'00110'
    call DATA_WRITE
    movlw b'10110'
    call DATA_WRITE
    ; third square .16 char
    movlw b'01111'
    call DATA_WRITE
    movlw b'01110'
    call DATA_WRITE
    movlw b'00111'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    movlw b'00101'
    call DATA_WRITE
    movlw b'00101'
    call DATA_WRITE
    movlw b'00111'
    call DATA_WRITE
    movlw b'00011'
    call DATA_WRITE
    ; fourth square .24 char
    movlw b'11100'
    call DATA_WRITE
    movlw b'11100'
    call DATA_WRITE
    movlw b'11000'
    call DATA_WRITE
    movlw b'01000'
    call DATA_WRITE
    movlw b'01000'
    call DATA_WRITE
    movlw b'01000'
    call DATA_WRITE
    movlw b'11000'
    call DATA_WRITE
    movlw b'10000'
    call DATA_WRITE
    
    ; fifth square .32 char
    movlw b'11100'
    call DATA_WRITE
    movlw b'10000'
    call DATA_WRITE
    movlw b'10000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00000'
    call DATA_WRITE
    movlw b'00010'
    call DATA_WRITE
    movlw b'00110'
    call DATA_WRITE
    movlw b'00100'
    call DATA_WRITE
    ; sixth square .40 char
    movlw b'01111'
    call DATA_WRITE
    movlw b'00011'
    call DATA_WRITE
    movlw b'00011'
    call DATA_WRITE
    movlw b'00001'
    call DATA_WRITE
    movlw b'00001'
    call DATA_WRITE
    movlw b'10001'
    call DATA_WRITE
    movlw b'11001'
    call DATA_WRITE
    movlw b'01001'
    call DATA_WRITE
    ; seventh square .48 char
    movlw b'10000'
    call DATA_WRITE
    movlw b'10001'
    call DATA_WRITE
    movlw b'11000'
    call DATA_WRITE
    movlw b'11011'
    call DATA_WRITE
    movlw b'11010'
    call DATA_WRITE
    movlw b'11010'
    call DATA_WRITE
    movlw b'11000'
    call DATA_WRITE
    movlw b'11100'
    call DATA_WRITE
    ; eight square .56 char
    movlw b'00011'
    call DATA_WRITE
    movlw b'00011'
    call DATA_WRITE
    movlw b'00111'
    call DATA_WRITE
    movlw b'10111'
    call DATA_WRITE
    movlw b'10111'
    call DATA_WRITE
    movlw b'10111'
    call DATA_WRITE
    movlw b'00111'
    call DATA_WRITE
    movlw b'01111'
    call DATA_WRITE
   
    return

_WRITING_LOSER_ANIM ; writing the chars into the lcd display 
    ; first line of lcd
    movlw   0x01 ; Move cursor to 0x00.
    bsf    WREG, 7, A 
    call    INSTRUCTION_WRITE
   
    movlw   .0 ; Write first square.
    call    DATA_WRITE
    movlw   .1 ; Write second square.
    call    DATA_WRITE
    
    movlw   .4 ; Write fifth square.
    call    DATA_WRITE
    movlw   .5 ; Write sixth square.
    call    DATA_WRITE
    ; one space
    movlw   0x06 ; Move cursor to 0x05.
    bsf    WREG, 7, A 
    call    INSTRUCTION_WRITE
    
    movlw   'G' ; Write a 'G'.
    call    DATA_WRITE
    movlw   'A' ; Write a 'A'.
    call    DATA_WRITE
    movlw   'M' ; Write a 'M'.
    call    DATA_WRITE
    movlw   'E' ; Write a 'E'.
    call    DATA_WRITE
    
    ; one space
    movlw   0x0B ; Move cursor to 0x0A.
    bsf    WREG, 7, A 
    call    INSTRUCTION_WRITE
    
    movlw   .0 ; Write firt square.
    call    DATA_WRITE
    movlw   .1 ; Write second square.
    call    DATA_WRITE
    
    movlw   .4 ; Write fifth square.
    call    DATA_WRITE
    movlw   .5 ; Write sixth square.
    call    DATA_WRITE
    ; one space
    movlw   0x10 ; Move cursor to 0x0E.
    bsf    WREG, 7, A 
    call    INSTRUCTION_WRITE
    
    movlw   'G' ; Write a 'G'.
    call    DATA_WRITE
    movlw   'A' ; Write a 'A'.
    call    DATA_WRITE
    movlw   'M' ; Write a 'M'.
    call    DATA_WRITE
    movlw   'E' ; Write a 'E'.
    call    DATA_WRITE
    ; one space
    movlw   0x15 ; Move cursor to 0x14.
    bsf    WREG, 7, A 
    call    INSTRUCTION_WRITE
   
    
    movlw   .0 ; Write first square.
    call    DATA_WRITE
    movlw   .1 ; Write second square.
    call    DATA_WRITE
    
    movlw   .4 ; Write fifth square.
    call    DATA_WRITE
    movlw   .5 ; Write sixth square.
    call    DATA_WRITE
    
    ; second line of lcd
    movlw   0x41 ; Move cursor to 0x40.
    bsf    WREG, 7, A 
    call    INSTRUCTION_WRITE
    
    movlw   .2 ; Write firt square.
    call    DATA_WRITE
    movlw   .3 ; Write second square.
    call    DATA_WRITE
    
    movlw   .6 ; Write fifth square.
    call    DATA_WRITE
    movlw   .7 ; Write sixth square.
    call    DATA_WRITE
    ; one space
    movlw   0x46 ; Move cursor to 0x05.
    bsf    WREG, 7, A 
    call    INSTRUCTION_WRITE
    
    movlw   'O' ; Write a 'O'.
    call    DATA_WRITE
    movlw   'V' ; Write a 'V'.
    call    DATA_WRITE
    movlw   'E' ; Write a 'E'.
    call    DATA_WRITE
    movlw   'R' ; Write a 'R'.
    call    DATA_WRITE
    ; one space
    movlw   0x4B ; Move cursor to 0x10.
    bsf    WREG, 7, A 
    call    INSTRUCTION_WRITE
    
    movlw   .2 ; Write firt square.
    call    DATA_WRITE
    movlw   .3 ; Write second square.
    call    DATA_WRITE
    
    movlw   .6 ; Write fifth square.
    call    DATA_WRITE
    movlw   .7 ; Write sixth square.
    call    DATA_WRITE
     ; one space
    movlw   0x50 ; Move cursor to 0x05.
    bsf    WREG, 7, A 
    call    INSTRUCTION_WRITE
    
    movlw   'O' ; Write a 'O'.
    call    DATA_WRITE
    movlw   'V' ; Write a 'V'.
    call    DATA_WRITE
    movlw   'E' ; Write a 'E'.
    call    DATA_WRITE
    movlw   'R' ; Write a 'R'.
    call    DATA_WRITE
    ; six spaces
    movlw   0x55 ; Move cursor to 0x20.
    bsf    WREG, 7, A 
    call    INSTRUCTION_WRITE
    
    movlw   .2 ; Write first square.
    call    DATA_WRITE
    movlw   .3 ; Write second square.
    call    DATA_WRITE
    
    movlw   .6 ; Write fifth square.
    call    DATA_WRITE
    movlw   .7 ; Write sixth square.
    call    DATA_WRITE
    
    ; display shift for animation
    movlw .240
    movwf register_loser, A
 
LOOP_LOSER_LEFT
    call DELAY_100us
    call DELAY_100us
    movlw b'00011000' ; set move display to the left
    call INSTRUCTION_WRITE
    incfsz register_loser, 1, A
    goto LOOP_LOSER_LEFT
    movlw .240
    movwf register_loser, A
 
LOOP_LOSER_RIGHT
    call DELAY_100us
    call DELAY_100us
    movlw b'00011100' ; set move display to the left
    call INSTRUCTION_WRITE
    incfsz register_loser, 1, A
    goto LOOP_LOSER_RIGHT
    return

_WRITING_WINNER_ANIM
    ;SECOND LINE
    movlw   0x44
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'L'			
    call    DATA_WRITE    
    movlw   'E'			
    call    DATA_WRITE    
    movlw   'V'			
    call    DATA_WRITE    
    movlw   'E'			
    call    DATA_WRITE    
    movlw   'L'			
    call    DATA_WRITE    
    
    ;SPACE
    movlw   0x4A
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'U'			
    call    DATA_WRITE    
    movlw   'P'			
    call    DATA_WRITE    
    
    movlw .5 ;Repeat animation 5 times
    movwf var3
WIN_ANIMATION_LOOP
   ;0  
    movlw   0x02
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .0			
    call    DATA_WRITE
    call    DELAY_100us
    
    
    movlw   0x0D
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .0			
    call    DATA_WRITE
    call    DELAY_100us
    
    
    ;1   
    movlw   0x02
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .1		
    call    DATA_WRITE
    call    DELAY_100us
    
    
    movlw   0x0D
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .1		
    call    DATA_WRITE
    call    DELAY_100us
    
    ;2   
    movlw   0x02
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .2		
    call    DATA_WRITE
    call    DELAY_100us
    
    
    movlw   0x0D
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .2		
    call    DATA_WRITE
    call    DELAY_100us
    
    ;3
    movlw   0x02
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .3		
    call    DATA_WRITE
    call    DELAY_100us
    
    
    movlw   0x0D
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .3		
    call    DATA_WRITE
    call    DELAY_100us
    
    ;4
    movlw   0x02
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .4		
    call    DATA_WRITE
    call    DELAY_100us
    
    
    movlw   0x0D
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .4		
    call    DATA_WRITE
    call    DELAY_100us
    
    ;5
    movlw   0x02
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .5		
    call    DATA_WRITE
    call    DELAY_100us
    
    
    movlw   0x0D
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .5	
    call    DATA_WRITE
    call    DELAY_100us
    
    DECFSZ var3
    goto WIN_ANIMATION_LOOP
    return

SHOW_HIGHSCORE
    movlw   '!'			
    call    DATA_WRITE   
    movlw   'N'			
    call    DATA_WRITE    
    movlw   'E'			
    call    DATA_WRITE
    movlw   'W'			
    call    DATA_WRITE
    
    ;SPACE
    movlw   0x05	
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'H'			
    call    DATA_WRITE
    movlw   'I'			
    call    DATA_WRITE
    movlw   'G'			
    call    DATA_WRITE
    movlw   'H'			
    call    DATA_WRITE
 
    ;SPACE
    movlw   0x0A
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'S'			
    call    DATA_WRITE
    movlw   'C'			
    call    DATA_WRITE
    movlw   'O'			
    call    DATA_WRITE
    movlw   'R'			
    call    DATA_WRITE
    movlw   'E'			
    call    DATA_WRITE
    movlw   '!'			
    call    DATA_WRITE   
    
    
    ;SECOND LINE
    movlw   0x40
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   '-'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE    
    movlw   '>'			
    call    DATA_WRITE    
    movlw   '0'			
    call    DATA_WRITE      
    movf    puntaje, W, A
    call    DATA_WRITE     
    movlw   '<'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE    
    return

SHOW_TIMES_OVER
    movlw   0x04	
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'T'			
    call    DATA_WRITE    
    movlw   'I'			
    call    DATA_WRITE
    movlw   'M'			
    call    DATA_WRITE
    movlw   'E'			
    call    DATA_WRITE
    movlw   'S'			
    call    DATA_WRITE
    
    ;SPACE
    movlw   0x0A
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'U'			
    call    DATA_WRITE
    movlw   'P'			
    call    DATA_WRITE    
    
    ;SECOND LINE
    movlw   0x47
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
 
    movlw   .0			; Write first square.
    call    DATA_WRITE
    movlw   .1			; Write a second square.
    call    DATA_WRITE
 
    return

RECORRIDO_JUEGO
    movlw   b'11111011'			; ACTIVAR COLUMNA 1 (verde, naranja).
    movwf   LATB, A
    btfss   fila1			; Revisar si se presiona el boton de START/STOP.
    call    BOTON_START_STOP
    btfss   fila2			; Revisar si se presiona el boton naranja.
    call    BOTON_NARANJA
    movlw   b'11110111'			; ACTIVAR COLUMNA 2 (blanco, azul).
    movwf   LATB, A
    btfss   fila1			; Revisar si se presiona el boton blanco.
    call    BOTON_BLANCO
    btfss   fila2			; Revisar si se presiona el boton azul.
    call    BOTON_AZUL
    movlw   b'11101111'			; ACTIVAR COLUMNA 3 (rojo, amarillo).
    movwf   LATB, A
    ;btfss   fila1			; Revisar si se presiona el boton de HIGHSCORE.
    ;call    BOTON_HIGHSCORE
    btfss   PORTB, 1, A			; Revisar si se presiona el boton amarillo.
    call    BOTON_AMARILLO
    return
    
BOTON_START_STOP
    btfss   fila1			; Revisar si sigue presionado el boton.
    goto    BOTON_START_STOP		; Si aun no se suleta, esperar.
    movlw   '0'
    movwf   puntaje
    call    DELAY_20ms			; Antirebote.
    bsf	    para			; Encender bit de que se presiono STOP.
    return
BOTON_NARANJA
    bsf	    led_naranja			; Prender el LED.
    btfss   fila2			; Revisar si sigue presionado el boton.
    goto    BOTON_NARANJA		; Si aun no se suleta, esperar.
    bcf	    led_naranja			; Apagar el LED.
    clrf    boton_presionado		; Limpiar el registro.
    bsf	    bit_led_naranja		; Encender el bit representativo del LED naranja.
    call    DELAY_20ms			; Antirebote.
    call    REVISAR_BOTON
    return
BOTON_BLANCO
    bsf	    led_blanco			; Prender el LED.
    btfss   fila1			; Revisar si sigue presionado el boton.
    goto    BOTON_BLANCO		; Si aun no se suleta, esperar.
    bcf	    led_blanco			; Apagar el LED.
    clrf    boton_presionado		; Limpiar el registro.
    bsf	    bit_led_blanco		; Encender el bit representativo del LED blanco.
    call    DELAY_20ms			; Antirebote.
    call    REVISAR_BOTON
    return
BOTON_AZUL
    bsf	    led_azul			; Prender el LED.
    btfss   fila2			; Revisar si sigue presionado el boton.
    goto    BOTON_AZUL			; Si aun no se suleta, esperar.
    bcf	    led_azul			; Apagar el LED.
    clrf    boton_presionado		; Limpiar el registro.
    bsf	    bit_led_azul		; Encender el bit representativo del LED azul.
    call    DELAY_20ms			; Antirebote.
    call    REVISAR_BOTON
    return
;BOTON_HIGHSCORE
    ;btfss   fila1			; Revisar si sigue presionado el boton.
    ;goto    BOTON_HIGHSCORE		; Si aun no se suleta, esperar.
    ;call    DELAY_20ms			; Antirebote.
    ;return
BOTON_AMARILLO
    bsf	    led_amarillo		; Prender el LED.
    btfss   fila2			; Revisar si sigue presionado el boton.
    goto    BOTON_AMARILLO		; Si aun no se suleta, esperar.
    bcf	    led_amarillo		; Apagar el LED.
    clrf    boton_presionado		; Limpiar el registro.
    bsf	    bit_led_amarillo		; Encender el bit representativo del LED amarillo.
    call    DELAY_20ms			; Antirebote.
    call    REVISAR_BOTON
    return
    
REVISAR_BOTON
    ; clrf  boton_esperado			; Limpiar el registro.
    ; bsf   boton_esperado, 0, A		; Esperamos que se presione el boton del LED azul.
    ; Estas dos lineas fueron pruebas para la simulacion.
    movf    boton_esperado, W, A		; Se resta boton_esperado - boton_presionado.
    subwf   boton_presionado, W, A		; Si son iguales, la resta debe dar 0.
    movf    WREG, W, A				; Se activa STATUS para WREG.
    btfsc   STATUS, Z, A			; Se revisa el bit de CERO en STATUS.
    bsf	    perdio				; Si no da 0, no era el boton correcto, pierde.
    btfss   STATUS, Z, A			; Se revisa el bit de CERO en STATUS.
    bsf	    correcto				; Si era 0, activa el bit de correcto.
    return
    
ON_GREEN
    bsf led_rojo
    call DELAY_100ms
    call DELAY_100ms
    call DELAY_100ms
    call DELAY_100ms
    call DELAY_100ms
    bcf led_rojo
    return
 
ON_RED
    bsf led_verde
    call DELAY_100ms
    call DELAY_100ms
    call DELAY_100ms
    call DELAY_100ms
    call DELAY_100ms
    bcf led_verde
    return
    
    
RANDOM_REGISTER ; REGRESA CON UN NUEVO VALOR EN REGISTRO SHIFTER 00,01,10,11
    clrf    shifter
    movf    TMR2, W, A
    btfsc   WREG, 0, A
    bsf	    shifter, 0, A
    btfsc   WREG, 1, A
    bsf	    shifter, 1, A
  
DECODER ; PONE boton_esperado EN LA MISMA CONFIG QUE boton_presionado
    clrf    boton_esperado
    movf    shifter , W, A 
    btfss   STATUS, 2, A		; checa si es 00
    goto    LED_01
    bsf	    boton_esperado, 0, A	; significa que 00 -> led azul es el esperado "0001"
    return
    
LED_01
    sublw   .1
    btfss   STATUS, 1 , A		; checa si restando 1 se vuelve 0
    goto    LED_10
    bsf	    boton_esperado, 1 , A	; significa que 01 -> led amar es el esperado "0010"
    return
    
LED_10 
    sublw   .1
    btfss   STATUS, 1 , A		; checa si restando 1 se vuelve 0
    goto    LED_11
    bsf	    boton_esperado, 2 , A	; significa que 01 -> led naranj es el esperado "0100"
    return

LED_11 
    bsf	    boton_esperado, 3 , A	; significa que 11 -> led blanco es el esperado "1000"
    return
