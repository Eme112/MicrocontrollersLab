; PRACTICA #4
    RADIX DEC			    ; USE DECIMALS
    PROCESSOR      18F45K50	    ; SET PROCESSOR TYPE
    #INCLUDE <P18F45K50.INC>	    ; INCLUDE PIC
    
; VARIABLE'S DEFINITION SECTION
VARIABLE1   EQU 0
VARIABLE2   EQU 1
   
; JUMP VECTORS
   ORG     0X00			    ; RESET VECTOR
   GOTO  SETUP
   
   ORG     0X1008		    ; HIGH INTERRUPT VECTOR
;  GOTO  ISR_HIGH		    ; UNCOMMENT WHEN NEEDED
   
   ORG 0X1018			    ; LOW INTERRUPT VECTOR
;  GOTO  ISR_HIGH		    ; UNCOMMENT WHEN NEEDED
   
; RESOURCE INITIALIZATION - SETUP
SETUP:
    MOVLB   15                      ; BSR = 15
    CLRF    ANSELA, BANKED	    ; PORTA = DIGITAL
    SETF    TRISA
    SETF    LATA
  END