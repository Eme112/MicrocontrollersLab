#include "Part1.asm"
    
START
    movlw .0
    movwf _255
LOOP 
    decfsz  _255
    goto LOOP
    goto CONFIGURA
    
end