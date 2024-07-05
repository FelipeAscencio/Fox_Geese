; Definicion de la macro "Puts".
%macro mPuts 1
    mov     rdi,%1
    sub     rsp,8
    call    puts
    add     rsp,8
%endmacro

; Definicion de la macro "TextPuts".
%macro mTextPuts 1
    mov     rdi, %1
    mov     rsi, [idArchivoCopia]
    sub     rsp, 8
    call    fputs
    add     rsp, 8
%endmacro

; Definicion de la macro "TextPutc".
%macro mTextPutc 1
    mov     al, %1
    mov     edi, eax
    mov     rsi, [idArchivoCopia]
    sub     rsp, 8
    call    fputc
    add     rsp, 8
%endmacro

; Definicion de la macro "Scanf 4".
%macro  mScanf 4
mov         rdi,%1
mov         rsi,%2
mov         rdx,%3
mov         rcx,%4
sub         rsp,8
call        sscanf
add         rsp,8
%endmacro

; Definicion de la macro "mGets 1".
%macro mGets 1
    mov     rdi,%1
    sub     rsp,8
    call    gets
    add     rsp,8
%endmacro

; Definicion de la macro "Printf 2".
%macro mPrintf 2
    mov     rdi,%1
    mov     rsi,%2
    sub     rsp,8
    call    printf
    add     rsp,8 
%endmacro

; Definicion de la macro "Mzorro 3".
%macro Mzorro 3
    mov         r8, %1
    add         r9, %2
    add         rcx, %3

    call        verificarmov

    cmp         rdi, -1
    je          turnoZorro
    cmp         rdi, 1
    je          movimientovalido

    mov         r10, r9
    mov         r11, rcx
    add         r9, %2
    add         rcx, %3
    jmp         oca_comestible
%endmacro

; Definicion de la macro "Moca 3".
%macro Moca 3
    mov         rdx, %1
    call        autorizacion
    cmp         rdi, 0
    je          moverOca

    add         r9, %2
    add         rcx, %3

    call        verificarmov
    cmp         rdi, 1
    je          hacermovoca

    jmp         moverOca
%endmacro

; Definicion de la macro que Limpia la terminal.
%macro  mLimpiar 0
    mov         rdi,cd_clear
    sub         rsp,8
    call        system
    add         rsp,8
%endmacro

; Definicion de la macro que controla el error de movimiento por parte de alguno de los 2 usuarios.
%macro  mErrorMov 1
    cmp         rdi,-1
    je          %1

    cmp         rdi,0
    je          %1
%endmacro

; Definicion de la macro que escribe enteros en el archivo.
%macro mTextPuti 1
    mov     rdi, [idArchivoCopia]
    mov     rsi, formatoEntero  
    mov     rdx, 0
    mov     rdx, %1   
    sub     rsp, 8             
    call    fprintf
    add     rsp, 8             
%endmacro

; Imports utilizados.
global procedimientoDelJuego
extern puts
extern gets
extern printf
extern fopen
extern fgets
extern fclose
extern sscanf
extern system
extern fputc
extern fputs
extern fprintf

; Definicion de constantes utilizadas en el programa.
section     .data
mensajeTurnoDelZorro    db  "Turno del Zorro (Pulse T para desplegar el tutorial):",0
mensajeTurnoDeOcas      db  "Turno de las Ocas (Pulse T para desplegar el tutorial):",0
insertarTecla           db  "Inserte siguiente movimiento:",0
mensajeSeleccionarOca   db  "Ingrese fila y columna de la oca que desea mover (separados por un espacio):",0
teclaInvalida           db  "La tecla ingresada no correzponde a ningun movimiento.",0
nohayoca                db  "No hay oca en la posicion elegida.",0
iratras                 db  "Seleccione direccion de movimiento de la Oca elegida (Pulse T para desplegar el tutorial).",0
mensajeMoverOca         db  "Elija una direccion para mover:",0
movimientoInvalido      db  "Movimiento de la oca invalido.",0
mensajeDeSalida         db  "Saliendo del juego.",0
errormov                db  "No se puede mover aqui.",0
modoArchivo             db  "r+",0
formato                 db  "%c",0
formatolinea            db  "%s",0
contadorChar            dq  0
contadorLinea           dq  0
contador                dq  0
filaZorro               dq  0
colZorro                dq  0
longfila                dq  7
formatoEntrada          db  "%ld %ld",0
disposicion             db  1,1,1,1  ;w,s,d,a
desplazamientos         dq -1,0,1,0,0,-1,0,1,-1,-1,1,-1,-1,1,1,1
mensajeganadoroca       db  "Ganaron las Ocas!.",0
mensajeganadorzorro     db  "Gano el Zorro!.",0
cd_clear                db  "clear",0
modoEscritura           db  "r+",0
salto_linea             db  10, 0      ; Codigo ASCII para nueva linea y terminador nulo.
finDelTablero           db "\N",0
mensErrorEscribir       db "Hubo un error al escribir el nuevo archivo.",0
mensajeDeGuardado       db "Partida guardada.",0
formatoEstadistica      db  "%hhi ",0
espacio                 db  " ",0
formatoEntero           db  "%d",0 

; Mensajes de tutoriales.
tutorialZorro1          db "Bienvenido al tutorial del Zorro, las acciones posibles son:",0
tutorialZorro2          db "-  (W): Moverse hacia Arriba.",0
tutorialZorro3          db "-  (S): Moverse hacia Abajo.",0
tutorialZorro4          db "-  (A): Moverse hacia la Izquierda.",0
tutorialZorro5          db "-  (D): Moverse hacia la Derecha.",0
tutorialZorro6          db "-  (E): Moverse hacia Arriba y a la Derecha.",0
tutorialZorro7          db "-  (Q): Moverse hacia Arriba y a la Izquierda.",0
tutorialZorro8          db "-  (C): Moverse hacia Abajo y a la Derecha.",0
tutorialZorro9          db "-  (Z): Moverse hacia Abajo y a la Izquierda.",0
tutorialZorro10         db "-  (G): Guardar Partida.",0
tutorialZorro11         db "-  (F): Finalizar Juego.",0
tutorialOca1            db "Bienvenido al primer tutorial de las Ocas (seleccion), las acciones posibles son:",0
tutorialOca2            db "-  (O): Seleccionar una Oca.",0
tutorialOca3            db "-  (G): Guardar Partida.",0
tutorialOca4            db "-  (F): Finalizar Juego.",0
tutorialOca5            db "Bienvenido al segundo tutorial de las Ocas (movimiento), las acciones posibles son:",0
tutorialOca6            db "-  (V): CambiarOcaElegida.",0
tutorialOca7            db "-  (W): Moverse hacia Arriba.",0
tutorialOca8            db "-  (S): Moverse hacia Abajo.",0
tutorialOca9            db "-  (A): Moverse hacia la Izquierda.",0
tutorialOca10           db "-  (D): Moverse hacia la Derecha.",0

; Textos de estadisticas finales.
textoEstadisticas1      db "Estadisticas finales del juego:",0
textoEstadisticas2      db "Orden: Cantidades de movimientos (W,S,A,D,Q,Z,E,C) y Cantidad de Ocas Comidas.",0
textoEstadisticas3      db "---------------------------------------------------------------------------------",0

; Definicion de variables utilizadas en el programa.
section     .bss
tecla                   resb    1
posicionOca             resb    1
zorro                   resb    1
oca                     resb    1
matriz                  resb    49
linea                   resb    20
idArchivo               resq    1
sentido                 resb    1
vectordatos             resb    14
filaOca                 resq    1
colOca                  resq    1
buffer                  resb    100
nombreArchivo           resb    64
idArchivoCopia          resq    1
turnoActual             resb    1

; Todos los elementos extra del archivo (ademas de la matriz).
dato                resb    1
charSentido         resb    1
charSentidoAux      resb    1
charZorro           resb    1
charOca             resb    1
auxiliarCasteo      resb    1

; Codigo de ejecucion del programa.
section     .text

; Calcula la dirección en memoria de un elemento específico de la matriz.
desplazamiento_matriz:
    mov         rbx,matriz
    mov         rax,r10
    imul        qword[longfila]
    add         rax,r11
    add         rbx,rax
    ret

; Obtiene la direccion del zorro.
dirzorro_en_var:
    mov         rbx,vectordatos
    add         rbx,12
    mov         rcx,0
    mov         cl,byte[rbx]
    movzx       rax,cl
    mov         [colZorro],rax

    inc         rbx
    mov         cl,byte[rbx]
    movzx       rax,cl
    mov         [filaZorro],rax
    ret

; Extrae y almacena los caracteres del zorro y la oca.
caracteres_en_var:
    mov         rcx,vectordatos
    add         rcx,1
    mov         bl,byte[rcx]
    mov         byte[zorro],bl;registro donode esta el char del zorro.
    add         rcx,1
    mov         bh,byte[rcx]
    mov         byte[oca],bh
    ret
; Actualiza la direccion de movimiento basada en el primer elemento de vectordatos.
actualizar_dispocision:
    mov         rbx,vectordatos
    mov         al,[rbx]

    cmp         al,"W"
    je          sentido_w

    cmp         al,"S"
    je          sentido_s

    cmp         al,"D"
    je          sentido_d

    cmp         al,"A"
    je          sentido_a
    
    ; Termina el proceso de actualizacion.
    fin_act:
        mov         rbx,disposicion
        add         rbx,rdx
        mov         byte[rbx],0
        ret

; Se compara con las distintas direcciones.
sentido_w:
    mov rdx,0
    jmp fin_act
sentido_s:
    mov rdx,1
    jmp fin_act
sentido_d:
    mov rdx,2
    jmp fin_act
sentido_a:
    mov rdx,3
    jmp fin_act
    
; En base a comparaciones de turno actual bifurca en el turno que corresponda.
cambiarTurno:
    mLimpiar
    cmp         byte[turnoActual],'z'   
    je          turnoOcas

    cmp         byte[turnoActual],'o'
    je          turnoZorro

    jmp         salirDelJuego

; Error mov zorro.
errorZorro:
    mLimpiar

    mPuts       errormov
    mov         rdi,1
    jmp         turnoZorro

; Inicializa el juego.
procedimientoDelJuego:
    sub         rsp,8
    call        cargarMatriz
    add         rsp,8

    call        dirzorro_en_var
    call        caracteres_en_var
    call        actualizar_dispocision

; Manejo del turno del zorro.
turnoZorro:
    mErrorMov   errorZorro

    mov         byte[turnoActual],'z'

    sub         rsp,8
    call        comprobarGanador
    add         rsp,8
    cmp         rdi,1
    je          salirDelJuego

    sub         rsp,8
    call        imprimirMatriz
    add         rsp,8

    mPuts       mensajeTurnoDelZorro
    mPuts       insertarTecla
    mGets       tecla
 
    mov         rbx,matriz
    mov         r9,[filaZorro]
    mov         rcx,[colZorro]

    cmp         byte[tecla],'w'
    je          moverZorroArriba
    cmp         byte[tecla],'W'
    je          moverZorroArriba

    cmp         byte[tecla],'s'
    je          moverZorroAbajo
    cmp         byte[tecla],'S'
    je          moverZorroAbajo

    cmp         byte[tecla],'a'
    je          moverZorroIzquierda
    cmp         byte[tecla],'A'
    je          moverZorroIzquierda

    cmp         byte[tecla],'d'
    je          moverZorroDerecha
    cmp         byte[tecla],'D'
    je          moverZorroDerecha

    cmp         byte[tecla],'q'
    je          moverZorroIzquierdaArriba
    cmp         byte[tecla],'Q'
    je          moverZorroIzquierdaArriba

    cmp         byte[tecla],'e'
    je          moverZorroDerechaArriba
    cmp         byte[tecla],'E'
    je          moverZorroDerechaArriba

    cmp         byte[tecla],'z'
    je          moverZorroIzquierdaAbajo
    cmp         byte[tecla],'Z'
    je          moverZorroIzquierdaAbajo

    cmp         byte[tecla],'c'
    je          moverZorroDerechaAbajo
    cmp         byte[tecla],'C'
    je          moverZorroDerechaAbajo

    cmp         byte[tecla],'g'
    je          guardarPartida
    cmp         byte[tecla],'G'
    je          guardarPartida

    cmp         byte[tecla],'t'
    je          imprimirTutorialZorro
    cmp         byte[tecla],'T'
    je          imprimirTutorialZorro

    cmp         byte[tecla],'f'
    je          salirDelJuego
    cmp         byte[tecla],'F'
    je          salirDelJuego

    mPuts       teclaInvalida
    jmp         turnoZorro

; Mueve el zorro hacia la direccion de arriba del tablero elegido.
moverZorroArriba:   
    Mzorro      3,-1,0

; Mueve el zorro hacia la direccion de abajo del tablero elegido.
moverZorroAbajo:
    Mzorro      4,1,0

; Mueve el zorro hacia la direccion de izquierda del tablero elegido.
moverZorroIzquierda: 
    Mzorro      5,0,-1

; Mueve el zorro hacia la direccion de derecha del tablero elegido.
moverZorroDerecha:
    Mzorro      6,0,1

; Mueve el zorro hacia la direccion de izquierda-arriba del tablero elegido.
moverZorroIzquierdaArriba:
    Mzorro      7,-1,-1

; Mueve el zorro hacia la direccion de derecha-arriba del tablero elegido.
moverZorroDerechaArriba:
    Mzorro      9,-1,1

; Mueve el zorro hacia la direccion de izquierda-abajo del tablero elegido.
moverZorroIzquierdaAbajo:
    Mzorro      8,1,-1

; Mueve el zorro hacia la direccion de derecha-abajo del tablero elegido.
moverZorroDerechaAbajo:
    Mzorro      10,1,1

; Verifica si el zorro se puede comer a la oca.
oca_comestible:
    call        verificarmov
    cmp         rdi,1
    je          comi_oca
    jmp         turnoZorro

; Actualiza la posicion del zorro y le da un turno mas por comer una oca.
comi_oca:
    call        prepararMovzorro
    call        moverElemento
    call        desplazamiento_matriz
    mov         byte[rbx],32 
    call        actualizar_mov
    call        actualizar_ocas_comidas
    mLimpiar
    jmp         turnoZorro

; Verifica que el movimiento del zorro sea valido.
movimientovalido:
    call        prepararMovzorro
    call        moverElemento
    call        actualizar_mov
    jmp         cambiarTurno

; Actualiza las posiciones de los elementos de la matriz.
actualizar_mov:
    mov         rdx,vectordatos
    add         rdx,r8
    inc         byte[rdx]
    ret

; Actualiza la cantidad de ocas comidas.
actualizar_ocas_comidas:
    mov         rdx,vectordatos
    add         rdx,11
    inc         byte[rdx]
    ret

; Verifica que sea un movimiento valido.
verificarmov:
    cmp         r9,6
    jg          invalido
    cmp         r9,0
    jl          invalido

    cmp         rcx,6
    jg          invalido
    cmp         rcx,0
    jl          invalido

    mov         rbx,matriz
    mov         rax,r9
    imul        qword[longfila]
    add         rax,rcx
    add         rbx,rax

    mov         rdx,0
    mov         dl,[rbx]
   
    cmp         dl,61
    je          invalido
    cmp         dl,32
    je          valido
    cmp         dl,[oca]
    je          veroca

    invalido:
        mov     rdi,-1  
        ret  
    veroca:
        mov     rdi,0
        ret
    valido:
        mov     rdi,1
        ret

; Prepara los registros con la posicion del zorro para moverlo de ubicacion.
prepararMovzorro:
    mov         rdi,1
    mov         r12, [filaZorro]
    mov         r13, [colZorro]
    mov         rax,0
    mov         al,[zorro]
    ret

; Prepara los registros con la posicion de la oca para moverla de ubicacion.
prepararMovoca:
    mov         rdi,0
    mov         r12, [filaOca]
    mov         r13, [colOca]
    mov         rax,0
    mov         al,[oca]
    ret

; Mueve el elemento guardado en los registros.
moverElemento:
    mov         byte[rbx],al

    mov         rbx,matriz
    mov         rax,r12
    imul        qword[longfila]
    add         rax,r13
    add         rbx,rax

    mov         byte[rbx],32
    
    cmp         rdi, 1
    je          actualizarZorro
    cmp         rdi, 0
    je          actualizarOca
    ret

; Actualiza la ubicacion del zorro en las var.
actualizarZorro:
    mov         [filaZorro], r9
    mov         [colZorro], rcx
    ret

; Actualiza la ubicacion de la oca en las var.
actualizarOca:
    mov         [filaOca], r9
    mov         [colOca], rcx
    ret

; Manejo del turno de la Oca.
turnoOcas:
    mov         byte[turnoActual],'o'

    sub         rsp,8
    call        comprobarGanador
    add         rsp,8
    cmp         rdi,1
    je          salirDelJuego
   
    sub         rsp,8
    call        imprimirMatriz
    add         rsp,8

    mPuts       mensajeTurnoDeOcas
    mPuts       insertarTecla
    mGets       tecla

    cmp         byte[tecla],'o'
    je          seleccionarOca
    cmp         byte[tecla],'O'
    je          seleccionarOca   

    cmp         byte[tecla],'g'
    je          guardarPartida
    cmp         byte[tecla],'G'
    je          guardarPartida

    cmp         byte[tecla],'t'
    je          imprimirTutorialOcas1
    cmp         byte[tecla],'T'
    je          imprimirTutorialOcas1

    cmp         byte[tecla],'f'
    je          salirDelJuego
    cmp         byte[tecla],'F'
    je          salirDelJuego

    mPuts       teclaInvalida
    jmp         turnoOcas

; Selecciona la oca que el usuario quioere mover. 
seleccionarOca: 
    mPuts       mensajeSeleccionarOca
    mGets       buffer
    mScanf      buffer,formatoEntrada,filaOca,colOca 

; Verifica la posicion de la oca. 
validarPosicion:
    mov         rbx,matriz
    mov         rax,[filaOca]
    imul        qword[longfila]
    add         rax,[colOca]
    add         rbx,rax

    mov         dl,[rbx]
    cmp         dl,byte[oca]
    je          moverOca

    mPuts       nohayoca
    jmp         seleccionarOca

; Error movimiento de la oca.
errorOca:
    mPuts       errormov
    mov         rdi,1
    jmp         moverOca

; Mueve la oca a la poscion indicada por la tecla.
moverOca:
    mErrorMov   errorOca
    mPuts       mensajeMoverOca
    mPuts       iratras
    mGets       tecla
    
    mov         r9,[filaOca]
    mov         rcx,[colOca]

    cmp         byte[tecla],'v'
    je          seleccionarOca
    cmp         byte[tecla],'V'
    je          seleccionarOca
    
    cmp         byte[tecla],'w'
    je          moverOcaArriba
    cmp         byte[tecla],'W'
    je          moverOcaArriba

    cmp         byte[tecla],'a'
    je          moverOcaIzquierda
    cmp         byte[tecla],'A'
    je          moverOcaIzquierda

    cmp         byte[tecla],'d'
    je          moverOcaDerecha
    cmp         byte[tecla],'D'
    je          moverOcaDerecha    

    cmp         byte[tecla],'s'
    je          moverOcaAbajo
    cmp         byte[tecla],'S'
    je          moverOcaAbajo

    cmp         byte[tecla],'t'
    je          imprimirTutorialOcas2
    cmp         byte[tecla],'T'
    je          imprimirTutorialOcas2

    mPuts       movimientoInvalido
    jmp         moverOca        

; Prepara y mueve la oca, despues cambia de turno.
hacermovoca:
    call        prepararMovoca
    call        moverElemento
    jmp         cambiarTurno   

; Mueve la oca para arriba.
moverOcaArriba:
    Moca        0,-1,0

; Mueve la oca para la izquierda.
moverOcaIzquierda:
    Moca        3,0,-1

; Mueve la oca para la derecha.
moverOcaDerecha:
    Moca        2,0,1

; Mueve la oca para abajo.
moverOcaAbajo:
    Moca        1,1,0

; Compruena si las ocas o el el zorro gano la partida.
comprobarGanador:
    call        ocascomidas
    cmp         rdi,12
    je          ganadorzorro

    mov         qword[contador],0
    call        zorroatrapado
    cmp         rdi,1
    je          ganadorocas
    mov         rdi,0
    ret

; Mensaje ganador ocas.
ganadorocas:
    mPuts       mensajeganadoroca
    mov         rdi,1
    ret

; Mensaje ganador zorro.
ganadorzorro:
    mPuts       mensajeganadorzorro
    mov         rdi,1
    ret

; Cuenta la cantidad de ocas comidas.
ocascomidas:
    mov         rbx,vectordatos
    add         rbx,11
    mov         rdi,0
    mov         dil,[rbx]
    ret

; Verifica si el zorro esta atrapado entre ocas.
zorroatrapado:
    cmp         qword[contador],112
    jg          nomovimiento

    mov         rsi,desplazamientos
    add         rsi,[contador]
    mov         r9,[filaZorro]
    mov         rcx,[colZorro]

    add         r9,[rsi]
    add         rsi,8
    add         rcx,[rsi]
    call        verificarmov
    cmp         rdi,1
    je          sepuedemover
    cmp         rdi,0
    je          vermovimiento

    add         qword[contador],16
    jmp         zorroatrapado

; Establece el rdi en 0, permitiendo que el personaje se pueda mover.
sepuedemover:
    mov         rdi,0
    ret

; Establece el rdi en 1, haciendo que el personaje no se mueva.
nomovimiento:
    mov         rdi,1
    ret

; Calcula nuevas posiciones para el movimiento del personaje, utilizando sepuedemover y nomoviento.
vermovimiento:   
    add         rcx,[rsi]
    sub         rsi,8
    add         r9,[rsi]
    call        verificarmov
    cmp         rdi,1
    je          sepuedemover
    add         qword[contador],16
    jmp         zorroatrapado    

; Obtiene y retorna el byte específico de la estructura de datos 'disposicion' indicado por el desplazamiento en rdx.
autorizacion:
    mov         rbx,disposicion
    add         rbx,rdx
    mov         rdi,0
    mov         dil,byte[rbx]
    ret

; Muestra las estadisticas del juego actual.
mostrarEstadisticas:
    mPuts       textoEstadisticas1
    mPuts       textoEstadisticas2
    mPuts       textoEstadisticas3
    mov         rbx,vectordatos
    add         rbx,3
    mov         qword[contador],0

; Procesa y muestra estadísticas finales. Convierte caracteres numéricos y los imprime.
caracteristicasFinales: 
    cmp         qword[contador],9
    je          finEstadisticas

; Sigue con el proceso de impresion.
seguirImprimiendo:
    mov         rax,0
    mov         al,byte[rbx]
    mov         [dato],rax   

    mPrintf     formatoEstadistica,[dato]

    inc         rbx
    inc         qword[contador]
    jmp         caracteristicasFinales

; Termina el proceso de las estadisticas.
finEstadisticas:
    mPuts       espacio
    ret

; Imprime tutorial sobre como usar las ocas de 1 - 4.
imprimirTutorialOcas1:
    mLimpiar
    mPuts       tutorialOca1
    mPuts       tutorialOca2
    mPuts       tutorialOca3
    mPuts       tutorialOca4
    jmp         turnoOcas

; Imprime tutorial sobre como usar las ocas de 5 - 10.
imprimirTutorialOcas2:
    mPuts       tutorialOca5
    mPuts       tutorialOca6
    mPuts       tutorialOca7
    mPuts       tutorialOca8
    mPuts       tutorialOca9
    mPuts       tutorialOca10
    jmp         moverOca
 
; Imprime tutorial sobre como usar el zorro.
imprimirTutorialZorro:
    mLimpiar
    mPuts       tutorialZorro1
    mPuts       tutorialZorro2
    mPuts       tutorialZorro3
    mPuts       tutorialZorro4
    mPuts       tutorialZorro5
    mPuts       tutorialZorro6
    mPuts       tutorialZorro7
    mPuts       tutorialZorro8
    mPuts       tutorialZorro9
    mPuts       tutorialZorro10
    mPuts       tutorialZorro11
    jmp         turnoZorro

; Guardar los cambios realizados en el archivo actual.
guardarPartida: 

    ; Crear archivo de salida.
    mov         rdi,[nombreArchivo]
    mov         rsi,modoEscritura
    sub         rsp, 8
    call        fopen
    add         rsp, 8

    cmp         rax, 0
    jle         errorWRITE
    mov         qword[idArchivoCopia], rax

; Escribe el tablero en el archivo.
guardar_tablero:
    mov         rbx,matriz
    mov         qword[contadorChar],0
    mov         qword[contadorLinea],0

; Escribe cada caracter de la matriz.
EscribirChar:
    cmp         qword[contadorChar],7
    je          siguienteLineaEscrita

    mov         rax,0
    mov         al,byte[rbx]
    mov         rdi,rax
    mov         rsi,[idArchivoCopia]
    sub         rsp,8
    call        fputc
    add         rsp,8

    inc         rbx
    inc         qword[contadorChar]
    jmp         EscribirChar

; Avanza a la siguiente fila de la matriz.
siguienteLineaEscrita:
    mov         qword[contadorChar],0
    inc         qword[contadorLinea]

    mov         rdi,salto_linea
    mov         rsi,[idArchivoCopia]
    sub         rsp, 8
    call        fputs
    add         rsp, 8

    cmp         qword[contadorLinea],7
    je          finDeEscritura
    jmp         EscribirChar

; Añade el resto de elementos al archivo.
finDeEscritura:

    mTextPuts   finDelTablero
    mTextPuts   salto_linea

    mov         rbx,vectordatos
    add         rbx,12
    mov         rcx,0
    mov         cl,[colZorro]

    mov         byte[rbx],cl
    inc         rbx
    mov         rcx,0
    mov         cl,[filaZorro]
    mov         byte[rbx],cl

    mov         rbx,vectordatos
    mov         qword[contador],0

; Escribe datos del vector, mostrando cada byte y saltando de línea después de cada uno.
escribirDatos:
    cmp         qword[contador],3
    je          castearVector

    mov         rdx,0
    mov         dl,byte[rbx]
    mov         [dato],rdx
    mTextPutc   [dato]

    inc         rbx
    inc         qword[contador]
    mTextPuts   salto_linea
    jmp         escribirDatos

; Convierte y muestra elementos del vector como caracteres numéricos, seguido de un salto de línea.
castearVector: 
    cmp         qword[contador],14
    je          finEscritura
    mov         rax,0
    mov         al,byte[rbx]
    mov         [dato],rax     
    mTextPuti   [dato]
    inc         rbx
    inc         qword[contador]
    mTextPuts   salto_linea
    jmp         castearVector

; Termina la escritura del texto.
finEscritura:
    mov         rdi, [idArchivoCopia]
    sub         rsp, 8
    call        fclose
    add         rsp, 8

    mLimpiar
    mPuts       mensajeDeGuardado

    cmp         byte[turnoActual],'z'
    je          turnoZorro

    cmp         byte[turnoActual],'o'
    je          turnoOcas

    jmp         salirDelJuego

; Lee y carga la matriz desde el archivo.
cargarMatriz:
    mov         [nombreArchivo],rbx
    mov         rdi, [nombreArchivo]
    mov         rsi, modoArchivo
    sub         rsp,8
    call        fopen
    add         rsp,8

    cmp         rax, 0
    jle         errorAlAbrir
    mov         qword[idArchivo],rax 
    mov         rbx,matriz

; Lee una linea desde un archivo identificado por idArchivo, y verifica si se abrio correctamente.
recorrerLineas:
    cmp         qword[contadorLinea],7
    je          demasdatos
    inc         qword[contadorLinea]

    mov         rdi,linea
    mov         rsi,10
    mov         rdx,[idArchivo]
    call        fgets

    cmp         rax,0
    jle         errorAlAbrir

    mov         r9,linea
    mov         qword[contadorChar],0   

; Copia caracteres de una linea a un buffer hasta alcanzar el limite de 7 caracteres.
recorrerLinea:
    cmp         qword[contadorChar],7
    je          recorrerLineas

    mov         rdx,0
    mov         dl,byte[r9]
    mov         [rbx],dl
    inc         rbx
    inc         r9
    inc         qword[contadorChar]
    
    jmp         recorrerLinea

; Lee lineas adicionales del archivo hasta alcanzar las condiciones de contadorLinea, luego guarda caracteres en vectordatos y continua el proceso.
demasdatos:
    mov         rdi,linea
    mov         rsi,20
    mov         rdx,[idArchivo]
    call        fgets

    inc         qword[contadorLinea]
    cmp         qword[contadorLinea],8
    je          demasdatos

    cmp         qword[contadorLinea],23
    je          finDeLectura

    mov         rax,0
    
    mov         al,[linea]
    mov         rbx,vectordatos
    add         rbx,[contador]
    cmp         qword[contadorLinea],12
    jge         entero
    mov         [rbx],al
    inc         qword[contador]
    jmp         demasdatos  

; Convierte el caracter en al a su equivalente numerico y lo guarda en vectordatos, luego incrementa contador y continua con demasdatos.
entero:
    sub         al,"0"
    mov         [rbx],al
    inc         qword[contador]
    jmp         demasdatos

; Cierra el archivo identificado por idArchivo y retorna.
finDeLectura:
    mov     rdi,[idArchivo]
    sub     rsp,8
    call    fclose
    add     rsp,8
    ret
    
; Error al abrir archivo.
errorAlAbrir:
    mPuts   errorAlAbrir
    ret

; Imprime la matriz almacenada.
imprimirMatriz:
    mov         rbx,matriz
    mov         qword[contadorChar],0
    mov         qword[contadorLinea],0

; Imprime caracter x caracter hasta saltar de linea.
imprimirChar:
    cmp         qword[contadorChar],7
    je          siguienteLinea

    mov         rsi,0
    mov         sil,byte[rbx]
    mov         rdi,formato
    sub         rsp,8
    call        printf
    add         rsp,8 

    inc         rbx
    inc         qword[contadorChar]
    jmp         imprimirChar

; Pasa a la siguente linea si es que existe.
siguienteLinea:
    mov         qword[contadorChar],0
    inc         qword[contadorLinea]
    mov         sil,10
    mov         rdi,formato
    sub         rsp,8
    call        printf
    add         rsp,8     
    cmp         qword[contadorLinea],7
    je          finDeImpresion
    jmp         imprimirChar

; Termina la impresion.
finDeImpresion:
    ret

; Error al escribir el archivo.
errorWRITE:
    mPuts       mensErrorEscribir
    ret

; Muestra las estadisticas del juego y lo termina.
salirDelJuego:
    sub         rsp,8
    call        mostrarEstadisticas
    add         rsp,8

    mPuts       mensajeDeSalida
    ret
