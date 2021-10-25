#include "p18f45k50.inc"
    processor 18f45k50 	; (opcional).
    org 0x00
    goto CONFIGURA
    

CONFIGURA    
    ; DEFINICION DE REGISTROS VARIABLES.
boton_esperado EQU 0x21
sim_portB      EQU 0X23	; para la sim servira como el registro de portB del teclado	    
    ; DEFINICION REGISTROS PARA RANDOMIZER
shifter	       EQU 0X22
#define boton PORTB, 5, A	       
	       
 
;  CONFIGURA E INICIA TIMER2 PARA EL NUM ALEATORIO
   setf    PR2, A
   movlw   b'00000100'	; TMR2 ON, 1:1 , NO POST
   movwf   T2CON 

   movlb   .15
   clrf    ANSELB, BANKED			; REGB -> DIGITAL.
   setf    TRISB,A				; entrada simulando el boton start.
   bcf	   INTCON2, 7, A	; ENABLE PULL-UPs.
   bsf	   WPUB, 5, A		; ENABLE PULL-UP RB5.
   clrf    ANSELA, BANKED			; REGA -> DIGITAL.
   clrf    TRISA,A; todas salidas para leds y comprobar aleatoriedad, 

 
start			; para la simulacion de que se presione un boton
	btfsc boton	;checa si se presiono el boton start/stop
	goto start 
	call RANDOM_REGISTER
	movff boton_esperado, LATA
	goto start  
    
RANDOM_REGISTER		; REGRESA CON UN NUEVO VALOR EN REGISTRO SHIFTER 00,01,10,11
	btfss	boton
	goto	RANDOM_REGISTER
	clrf	boton_esperado
	nop
	nop
	clrf    shifter
	movf    TMR2, W, A
	nop
	btfsc   WREG, 0, A
	bsf	shifter, 0, A
	btfsc   WREG, 1, A
	bsf	shifter, 1, A

DECODER ; PONE boton_esperado EN LA MISMA CONFIG QUE boton_presionado
	movf shifter , W, A 
	movf WREG,W,A
	btfss STATUS, Z, A		; checa si es 00
	goto LED_01
	bsf boton_esperado, 0, A	; significa que 00 -> led azul es el esperado "0001"
	return

LED_01
	sublw .1
	movf WREG,W,A
	btfss STATUS, 2 , A		; checa si restando 1 se vuelve 0
	goto LED_10
	bsf boton_esperado, 1 , A	; significa que 01 -> led amar es el esperado "0010"
	return

LED_10 
	movff shifter, WREG
	sublw .2
	movf WREG,W,A
	btfss STATUS, 2 , A		; checa si restando 1 se vuelve 0
	goto LED_11
	bsf boton_esperado, 2 , A	; significa que 01 -> led naranj es el esperado "0100"
	return

LED_11 
	bsf boton_esperado, 1 , A	; significa que 11 -> led blanco es el esperado "1000"
	return

  end