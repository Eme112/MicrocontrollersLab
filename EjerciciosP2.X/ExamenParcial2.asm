#include "p18f45k50.inc"    
Reg1 EQU 0x32
    org 0x00
    goto etiq1
    
etiq1
    clrf    Reg1, A
    movlw   b'01110011'
    movwf   T2CON, A
    movlw   d'49'
    movwf   PR2, A
etiq2
    bcf	PIR1, 1, A
    bsf	T2CON, 2, A
etiq3
    btfss   PIR1, 1, A
	goto	etiq3
    goto    etiq2
    nop
    call    etiq4
    nop
here	goto	here
    
etiq4
    incf    Reg1, F, A
    btfss   STATUS, 2
	goto	etiq4
    return
    
  end