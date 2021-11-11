#include "inicializacion.asm"
#include "delays.asm"
#include "lcd_subrutinas.asm"
#include "lcd_caracteres.asm"
#include "teclado_subrutinas.asm"
#include "otras_subrutinas.asm"

; TODO: Quitar esto para la ultima entrega. 
CARGAR_SECUENCIA
    movlw   b'00000001'			; azul
    movwf   sec1, A 
    movlw   b'00000010'			; amarillo
    movwf   sec2, A
    movlw   b'00000001'			; azul
    movwf   sec3, A
    movlw   b'00001000'			; blanco
    movwf   sec4, A
    movlw   b'00001000'			; blanco
    movwf   sec5, A
    movlw   b'00000010'			; amarillo
    movwf   sec6, A
    movlw   b'00000001'			; azul
    movwf   sec7, A
    movlw   b'00000100'			; naranja
    movwf   sec8, A
    movlw   b'00000100'			; naranja
    movwf   sec9, A
    movlw   b'00001000'			; blanco
    movwf   sec10, A
    return

MAIN
    ; CONFIGURACION BASICA DE LCD.
    call    CONFIGURE_LCD
    call    CARGAR_SECUENCIA		; TODO: Quitar esto para la ultima entrega.
MENU_PRINCIPAL
    clrf    trayectoria
    ; IMPRIMIR MENU PRINCIPAL.
    call    SHOW_MAIN_MENU
    ; REVISAR SI SE PRESIONAN BOTONES DE START/STOP O HIGHSCORE.
    goto    RECORRIDO_MENU
    
PUNTAJES
    ; TODO: Mostrar puntajes (proxima entrega).
    call    SHOW_SCORES_MENU
    ; REVISAR SI SE PRESIONA START/STOP PARA REGRESAR A MENU PRINCIPAL.
    movlw   b'11111011'			; ACTIVAR COLUMNA 1 (verde, naranja).
    movwf   LATB, A
STOP_PUNTAJES
    btfsc   fila1			; Revisar si se presiona el boton de START/STOP.
    goto    STOP_PUNTAJES
ANTIRREBOTE_PUNTAJES
    btfss   fila1			; Revisar si sigue presionado el boton de START/STOP.
    goto    ANTIRREBOTE_PUNTAJES
    call    DELAY_20ms
    goto    MENU_PRINCIPAL
    
JUEGO
    movlw   '0'
    movwf   puntaje, A
    call    SHOW_PUNTAJE
NIVEL1
    call    RANDOM_REGISTER
    movff   sec_aleatoria, sec1
    ; MOSTRAR SECUENCIA.
    movff   sec1, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    
    ; SECUENCIA 1.
    movff   sec1, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    
    ; NIVEL SUPERADO.
    movlw   '1'
    movwf   puntaje, A
    call    NIVEL_SUPERADO
    
NIVEL2
    call    RANDOM_REGISTER
    movff   sec_aleatoria, sec2
    ; MOSTRAR SECUENCIA.
    movff   sec1, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec2, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    
    ; SECUENCIA 1.
    movff   sec1, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 2.
    movff   sec2, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    
    ; NIVEL SUPERADO.
    movlw   '2'
    movwf   puntaje, A
    call    NIVEL_SUPERADO
    
NIVEL3
    call    RANDOM_REGISTER
    movff   sec_aleatoria, sec3
    ; MOSTRAR SECUENCIA.
    movff   sec1, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec2, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec3, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    
    ; SECUENCIA 1.
    movff   sec1, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 2.
    movff   sec2, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 3.
    movff   sec3, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    
    ; NIVEL SUPERADO.
    movlw   '3'
    movwf   puntaje, A
    call    NIVEL_SUPERADO
    
NIVEL4
    call    RANDOM_REGISTER
    movff   sec_aleatoria, sec4
    ; MOSTRAR SECUENCIA.
    movff   sec1, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec2, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec3, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec4, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    
    ; SECUENCIA 1.
    movff   sec1, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 2.
    movff   sec2, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 3.
    movff   sec3, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 4.
    movff   sec4, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    
    ; NIVEL SUPERADO.
    movlw   '4'
    movwf   puntaje, A
    call    NIVEL_SUPERADO
    
NIVEL5
    call    RANDOM_REGISTER
    movff   sec_aleatoria, sec5
    ; MOSTRAR SECUENCIA.
    movff   sec1, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec2, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec3, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec4, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec5, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    
    ; SECUENCIA 1.
    movff   sec1, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 2.
    movff   sec2, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 3.
    movff   sec3, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 4.
    movff   sec4, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 5.
    movff   sec5, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    
    ; NIVEL SUPERADO.
    movlw   '5'
    movwf   puntaje, A
    call    NIVEL_SUPERADO
    
NIVEL6
    call    RANDOM_REGISTER
    movff   sec_aleatoria, sec6
    ; MOSTRAR SECUENCIA.
    movff   sec1, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec2, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec3, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec4, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec5, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec6, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    
    ; SECUENCIA 1.
    movff   sec1, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 2.
    movff   sec2, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 3.
    movff   sec3, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 4.
    movff   sec4, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 5.
    movff   sec5, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 6.
    movff   sec6, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    
    ; NIVEL SUPERADO.
    movlw   '6'
    movwf   puntaje, A
    call    NIVEL_SUPERADO
    
NIVEL7
    call    RANDOM_REGISTER
    movff   sec_aleatoria, sec7
    ; MOSTRAR SECUENCIA.
    movff   sec1, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec2, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec3, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec4, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec5, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec6, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec7, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    
    ; SECUENCIA 1.
    movff   sec1, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 2.
    movff   sec2, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 3.
    movff   sec3, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 4.
    movff   sec4, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 5.
    movff   sec5, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 6.
    movff   sec6, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 7.
    movff   sec7, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    
    ; NIVEL SUPERADO.
    movlw   '7'
    movwf   puntaje, A
    call    NIVEL_SUPERADO
    
NIVEL8
    call    RANDOM_REGISTER
    movff   sec_aleatoria, sec8
    ; MOSTRAR SECUENCIA.
    movff   sec1, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec2, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec3, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec4, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec5, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec6, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec7, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec8, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    
    ; SECUENCIA 1.
    movff   sec1, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 2.
    movff   sec2, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 3.
    movff   sec3, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 4.
    movff   sec4, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 5.
    movff   sec5, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 6.
    movff   sec6, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 7.
    movff   sec7, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 8.
    movff   sec8, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    
    ; NIVEL SUPERADO.
    movlw   '8'
    movwf   puntaje, A
    call    NIVEL_SUPERADO
    
NIVEL9
    call    RANDOM_REGISTER
    movff   sec_aleatoria, sec9
    ; MOSTRAR SECUENCIA.
    movff   sec1, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec2, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec3, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec4, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec5, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec6, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec7, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec8, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec9, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    
    ; SECUENCIA 1.
    movff   sec1, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 2.
    movff   sec2, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 3.
    movff   sec3, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 4.
    movff   sec4, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 5.
    movff   sec5, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 6.
    movff   sec6, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 7.
    movff   sec7, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 8.
    movff   sec8, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 9.
    movff   sec9, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    
    ; NIVEL SUPERADO.
    movlw   '9'
    movwf   puntaje, A
    call    NIVEL_SUPERADO
    
NIVEL10
    call    RANDOM_REGISTER
    movff   sec_aleatoria, sec10
    ; MOSTRAR SECUENCIA.
    movff   sec1, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec2, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec3, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec4, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec5, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec6, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec7, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec8, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec9, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    call    DELAY_100ms
    movff   sec10, encender_led		; Mostrarle la secuencia al usuario
    call    ENCENDER_SECUENCIA
    
    ; SECUENCIA 1.
    movff   sec1, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 2.
    movff   sec2, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 3.
    movff   sec3, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 4.
    movff   sec4, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 5.
    movff   sec5, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 6.
    movff   sec6, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 7.
    movff   sec7, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 8.
    movff   sec8, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 9.
    movff   sec9, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    ; SECUENCIA 10.
    movff   sec10, boton_esperado
    call    TIMER_5s			; Revisar si presiona boton correcto/STOP/pasan 5 seg.
    btfsc   perdio			; Revisa si perdio, en cuyo caso regresa a MENU_PRINCIPAL.
    goto    MENU_PRINCIPAL
    clrf    trayectoria			; Preparacion para siguiente secuencia.
    
    ; NIVEL SUPERADO.
    movlw   'A'
    movwf   puntaje, A
    call    NIVEL_SUPERADO

    goto    HIGHSCORE
    
  end