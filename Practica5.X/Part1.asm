    #include "p18f45k50.inc"
    processor 18f45k50		; (opcional)
    
    org	0x00
    goto configura
    org	0x08			; posición para interrupciones.
    retfie
    org	0x18			; posición para interrupciones.
    retfie
    org	0x30			; Origen real (opcional pero recomendado).
configura			; Configuración.
    movlb   .15			; BSR = 15.
    clrf    ANSELA, BANKED	; RA = DIGITAL.
    clrf    TRISA, BANKED	; RA = OUTPUT.	Usado para LEDs.
    clrf    ANSELB, BANKED	; RB = DIGITAL.
    setf    TRISB, BANKED	; RB = INPUT.	Usado para botones.
    
; Equivalencias
numLED	EQU 0x10
B1	EQU 0
B2	EQU 1
B3	EQU 2
B4	EQU 3
; Equivalencias para el delay de 500ms.
_256_1	EQU 0x20
_256_2	EQU 0x21
_2	EQU 0x22
_137	EQU 0x23
; Equivalencias para el delay de 20ms.
_26	EQU 0x24

	org	0x40		; Código principal.
start
    movlw   .1
    movwf   numLED, A		; numLED = .1
    
LED1_parpadea
    btg	    LATA, 0, A		; Invierte el LED0.
    call    delay500ms		; Espera 500ms.
    btfsc   PORTB, B1, A	; Si no se presiona el botón, se cicla.
    goto    LED1_parpadea
    call    rutinaAntiRebote	; Si se presiona B1, hacer rutina de anti-rebote e ir a rutinaA.
    goto    rutinaA
    
rutinaA
    
    
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
    call    delay20ms
    btfss   PORTB, B1, A
    goto    rutinaAntiRebote
    return
delay20ms
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
  end
