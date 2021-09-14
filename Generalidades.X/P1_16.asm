	#include "p18f45k50.inc"
	org 0x00
	goto start
	
start   org 0x20	
	clrf d'32', A
startloop
	movlw d'6'
	subwf d'32', W, A
	btfsc STATUS, 4, A
	goto prende1	    ;=1
	movlw d'10'
	subwf d'32', W, A
	btfsc STATUS, 4, A
	goto prende2
	btfsc STATUS, 2, A
	goto prende3
incrementa
	incf d'32', F, A
	goto startloop
prende1
	clrf d'33', A
	goto incrementa
prende2
	bsf d'33', 0, A
	goto incrementa
prende3
	bcf d'33', 0, A
	bsf d'33', 7, A
	goto start
	end