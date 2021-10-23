#include "inicializacion.asm"
#include "delays.asm"
#include "lcd_subrutinas.asm"
#include "lcd_caracteres.asm"
#include "teclado_subrutinas.asm"
#include "otras_subrutinas.asm"


MAIN
    call    ON_RED
    call    ON_GREEN
    goto    MAIN

  end