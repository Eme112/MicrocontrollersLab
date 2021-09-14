; PRACTICA $
    RADIX DEC         ; USE DECIMALS
    PROCESSOR      18F45K50      ; SET PROCESSOR TYPE
    #INCLUDE <P18F45K50.INC>       ; INCLUDE PIC
    
; VARIABLE'S DEFINITION SECTION
VARIABLE1   EQU 0
VARIABLE2   EQU 1
   
; JUMP VECTORS
   ORG     0X00                       ; RESET VECTOR
   GOTO  SETUP
   
   ORG     0X1008                  ; HIGH INTERRUPT VECTOR
;  GOTO  ISR_HIGH               ; UNCOMMENT WHEN NEEDED
   
   ORG 0X1018                      ; LOW INTERRUPT VECTOR
;  GOTO  ISR_HIGH               ; UNCOMMENT WHEN NEEDED
   
; RESOURCE INITIALIZATION - SETUP
SETUP:
    MOVLB   15                       ; BSR = 15
    
    CLRF    ANSELC, BANKED       ; PORTC = DIGITAL
    BSF         TRISC, 0             ; PORTC, BIT0 = INPUT
    BSF         TRISC, 1             ; PORTC, BIT1 = INPUT
    
    CLRF    ANSELB, BANKED       ; PORTB = DIGITAL
    BCF         TRISB, 0             ; PORTB, BIT0 = OUTPUT
    BCF         TRISB, 1             ; PORTB, BIT1 = OUTPUT
    
    CLRF    LATB              ; PORTB = 0000 0000
    
; MAIN LOOP
MAIN:
    BTFSS   PORTC, 0             ; IF BIT0 = 0, CALL BOTON1
    CALL    BOTON1
    
    BTFSS   PORTC, 1             ; IF BIT1 = 0, CALL BOTON2
    CALL    BOTON2
    
    BRA        MAIN         ; LOOP UNTIL BIT0 OR BIT1 = 0
    
; BOTON 1 - ROUTINE
BOTON1:
    CALL    DELAY
    BSF         LATB, 0              ; SET PORTB, BIT0
    RETURN
    
; BOTON 2 - ROUTINE
BOTON2:
   CALL    DELAY
    BSF         LATB, 1              ; SET PORTB, BIT1
    RETURN
    
; DELAY - ROUTINE
DELAY:
    MOVLW   255                   ; W = 255
    MOVWF   VARIABLE1             ; VARIABLE1 = 255
    MOVWF   VARIABLE2             ; VARIABLE2 = 255
LOOP1:
    DECFSZ  VARIABLE2             ; VARIABLE2--
    GOTO    LOOP1		  ; if VARIABLE2 = 0, VARIABLE1--
    DECFSZ  VARIABLE1             ; (This happens 256*256 times)
    GOTO    LOOP1
    RETURN
    
  END
