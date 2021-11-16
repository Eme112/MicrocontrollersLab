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
    movlw   b'00000001'		; Clear display and return to home position.
    call    INSTRUCTION_WRITE
    call    DELAY_100ms
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
    call DELAY_100ms
    movlw b'00011000' ; set move display to the left
    call INSTRUCTION_WRITE
    incfsz register_loser, 1, A
    goto LOOP_LOSER_LEFT
    movlw .240
    movwf register_loser, A
 
LOOP_LOSER_RIGHT
    call DELAY_100ms
    movlw b'00011100' ; set move display to the left
    call INSTRUCTION_WRITE
    incfsz register_loser, 1, A
    goto LOOP_LOSER_RIGHT
    return

_WRITING_WINNER_ANIM
    movlw   b'00000001'		; Clear display and return to home position.
    call    INSTRUCTION_WRITE
    call    DELAY_100ms
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
    
    movlw   .2 ;Repeat animation 5 times
    movwf   var3
WIN_ANIMATION_LOOP
   ;0  
    movlw   0x02
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .0			
    call    DATA_WRITE
    
    
    movlw   0x0D
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .0			
    call    DATA_WRITE
    call    DELAY_100ms
    
    
    ;1   
    movlw   0x02
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .1		
    call    DATA_WRITE
    
    movlw   0x0D
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .1		
    call    DATA_WRITE
    call    DELAY_100ms
    
    ;2   
    movlw   0x02
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .2		
    call    DATA_WRITE
    
    movlw   0x0D
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .2		
    call    DATA_WRITE
    call    DELAY_100ms
    
    ;3
    movlw   0x02
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .3		
    call    DATA_WRITE
    
    
    movlw   0x0D
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .3		
    call    DATA_WRITE
    call    DELAY_100ms
    
    ;4
    movlw   0x02
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .4		
    call    DATA_WRITE
    
    
    movlw   0x0D
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .4		
    call    DATA_WRITE
    call    DELAY_100ms
    
    ;5
    movlw   0x02
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .5		
    call    DATA_WRITE
    
    
    movlw   0x0D
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   .5	
    call    DATA_WRITE
    call    DELAY_100ms
    
    decfsz  var3
    goto    WIN_ANIMATION_LOOP
    return

SHOW_HIGHSCORE
    movlw   b'00000001'		; Clear display and return to home position.
    call    INSTRUCTION_WRITE
    call    DELAY_100ms
    movlw   ' '			
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
    movlw   b'00000001'		; Clear display and return to home position.
    call    INSTRUCTION_WRITE
    call    DELAY_100ms
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

;Subrutina para puntaje obtenido (no highscore)
SHOW_PUNTAJE
    movlw   b'00000001'		; Clear display and return to home position.
    call    INSTRUCTION_WRITE
    call    DELAY_100ms
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
    movlw   ':'			
    call    DATA_WRITE
   
       
    ;SECOND LINE
    movlw   0x44
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   '-'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE    
    movlw   '-'			
    call    DATA_WRITE       
    movlw   '>'			
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
    return
    
SHOW_SCORES_MENU
    movlw   b'00000001'		; Clear display and return to home position.
    call    INSTRUCTION_WRITE
    call    DELAY_100ms
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
    movlw   ':'			
    call    DATA_WRITE
    movlw   '0'			
    call    DATA_WRITE
    ;acceder EEPROM3
    movlw   .3
    movwf   EEADR, A
    bsf	    EECON1, 0, A ;habilitar lectura
    movf    EEDATA, A
    call    DATA_WRITE
    movlw   '-'			
    call    DATA_WRITE
    movlw   '0'			
    call    DATA_WRITE
    ;acceder EEPROM2
    movlw   .2
    movwf   EEADR, A
    bsf	    EECON1, 0, A ;habilitar lectura
    movf    EEDATA, A
    call    DATA_WRITE
    movlw   '-'			
    call    DATA_WRITE
    movlw   '0'			
    call    DATA_WRITE 
     ;acceder EEPROM1 
    movlw   .1
    movwf   EEADR, A
    bsf	    EECON1, 0, A ;habilitar lectura
    movf    EEDATA, A
    call    DATA_WRITE
    
    ;SECOND LINE
    movlw   0x40
    bsf	    WREG, 7, A		
    call    INSTRUCTION_WRITE
    
    movlw   'B'			
    call    DATA_WRITE    
    movlw   'E'			
    call    DATA_WRITE    
    movlw   'S'			
    call    DATA_WRITE    
    movlw   'T'			
    call    DATA_WRITE    
    ;SPACE
    movlw   0x45
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
    movlw   '-'			
    call    DATA_WRITE    
    movlw   '>'			
    call    DATA_WRITE    
    movlw   '0'			
    call    DATA_WRITE    
    movlw   .0
    movwf   EEADR, A
    bsf	    EECON1, 0, A ;habilitar lectura
    movf    EEDATA, A
    bcf	    EECON1, 0 , A ; se inhabilita la lectura
    call    DATA_WRITE
    return
 
 
SHOW_MAIN_MENU
    movlw   b'00000001'		; Clear display and return to home position.
    call    INSTRUCTION_WRITE
    call    DELAY_100ms
    movlw   'S'			
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
    
    movlw   'P'			
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
    
    movlw   'P'			
    call    DATA_WRITE
    movlw   'R'			
    call    DATA_WRITE
    movlw   'E'			
    call    DATA_WRITE
    movlw   'V'			
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
