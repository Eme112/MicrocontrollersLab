    #include "p18f45k50.inc"
    processor 18f45k50		; (opcional)
    
    org	0x00
    goto start
    org	0x08			; posición para interrupciones.
    retfie
    org	0x18			; posición para interrupciones.
    retfie
    org	0x30			; Origen real (opcional pero recomendado).
start
_256_1	EQU 0x10
_256_2	EQU 0x11
_5	EQU 0x12
_17	EQU 0x13
    call rutRetardo
    nop
    
rutRetardo
    movlw   .0			
    movwf   _256_1
    movwf   _256_2
    movlw   .5
    movwf   _5
    movlw   .17
    movwf   _17	
    ; 7us approx. in this section
    
loop1				
    decfsz  _256_1
    goto    loop1		; (3)*256^2
    decfsz  _256_2
    goto    loop1		; (3)*256
    decfsz  _5
    goto    loop1		; (3)*(256^2+256)*5 + (3)*5 = 15*256^2 + 15*256 + 15
    ; 986,907us approx.
    
loop2				
    decfsz  _256_1		
    goto    loop2		; (3)*256
    decfsz  _17		
    goto    loop2		; (3)*256*17 + (3)*17 = 51*256 + 51
    ; 13,107us approx.
    ; ===1.000021 seg approx.===
    return
  end
