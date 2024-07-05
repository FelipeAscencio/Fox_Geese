; Definicion de la macro "Puts" utilizada para imprimir por pantalla.
%macro mPuts 1
    mov     rdi,%1
    sub     rsp,8
    call    puts
    add     rsp,8
%endmacro

; Definicion de la macro "TextPuts" utilizada para escribir el archivo de guardado (strings).
%macro mTextPuts 1
    mov     rdi, %1
    mov     rsi, [idArchivoCopia]
    sub     rsp, 8
    call    fputs
    add     rsp, 8
%endmacro

; Definicion de la macro "TextPutc" utilizada para escribir el archivo de guardado (caracteres).
%macro mTextPutc 1
    mov     al, %1
    mov     edi, eax
    mov     rsi, [idArchivoCopia]
    sub     rsp, 8
    call    fputc
    add     rsp, 8
%endmacro

; Definicion de la macro que Limpia la terminal.
%macro  mLimpiar 0
    mov         rdi,cd_clear
    sub         rsp,8
    call        system
    add         rsp,8
%endmacro

; Imports utilizados.
global main
extern  fopen
extern  fgets
extern  fputs
extern  fputc
extern  printf
extern  fclose
extern  puts
extern  getchar
extern  procedimientoDelJuego
extern  system

; Definicion de constantes utilizadas en el programa.
section .data
    mensajeInicial1         db "¡Bienvenido a 'El zorro y las Ocas'!",0
    mensajeInicial2         db "Seleccione el tipo de partida que quiere jugar.",0
    mensajeInicial3         db "Para ello, digite el caracter de la opcion elegida:",0
    mensajeInicial4         db "-  Nuevo juego base (B): Nueva partida con configuraciones base.",0
    mensajeInicial5         db "-  Nuevo juego personalizado (N): Nueva partida con opciones de configuracion.",0
    mensajeInicial6         db "-  Cargar partida (C): Continuar una partida previa (tambien permite configurar opciones antes de cargar).",0
    mensajeInicial7         db "-  Salir del juego (F): Salir del juego, todos los cambios no guardados se perderan.",0
    mensajeInicioPartida    db "Que comience el juego!",0
    mensajeNueva            db "Vamos a iniciar una nueva partida, primero, ¿en que sentido quieres el tablero?",0
    mensajeCargar           db "Vamos a cargar una partida existente, ¿en que sentido esta la partida que quieres cargar?",0
    mensajeSentido1         db "-  Norte (N): Este es el sentido default del juego.",0
    mensajeSentido2         db "-  Sur (S): Este es el sentido invertido al default.",0
    mensajeSentido3         db "-  Este (E): Este es el sentido rotado a derecha al default.",0
    mensajeSentido4         db "-  Oeste (O): Este es el sentido rotado a izquierda al default.",0
    mensajeOpcionAnterior   db "-  Digite (X) si quiere volver a las opciones previas.",0
    mensajeEstadoTablero    db "El tablero elegido esta en este estado:",0
    mensajeFinJuego         db "Hasta pronto!",0

    mensajePersonalizacion1 db "¿Desea hacer alguna configuracion adicional?",0
    mensajePersonalizacion2 db "-  SI (S).",0
    mensajePersonalizacion3 db "-  NO (N).",0
    mensajePersonalizacion4 db "¿Que mas desea personalizar?",0
    mensajePersonalizacion5 db "-  Simbolo del Zorro (Z): Modificar el simbolo de representacion del Zorro.",0
    mensajePersonalizacion6 db "-  Simbolo de las Ocas (O): Modificar el simbolo de representacion de las Ocas.",0
    mensajePersonalizacion7 db "-  Mostrar tablero (M): Muestra el estado actual del tablero.",0
    mensajePersonalizacion8 db "-  Comenzar el juego (J): Para comenzar el juego con el estado actual del tablero.",0
    mensajeCambioZorro      db "Ingrese el nuevo simbolo del Zorro:",0
    mensajeCambioOcas       db "Ingrese el nuevo simbolo de las Ocas:",0

    mensajeTexto1           db "----------------------------------------------",0
    mensajeTexto2           db "Orden y explicacion de valores:",0
    mensajeTexto3           db "Matriz.",0
    mensajeTexto4           db "\N (Division de datos).",0
    mensajeTexto5           db "Sentido.",0
    mensajeTexto6           db "Simbolo del Zorro.",0
    mensajeTexto7           db "Simbolo de las Ocas.",0
    mensajeTexto8           db "Cantidad de mov. adelante.",0
    mensajeTexto9           db "Cantidad de mov. atras.",0
    mensajeTexto10          db "Cantidad de mov. izquierda.",0
    mensajeTexto11          db "Cantidad de mov. derecha.",0
    mensajeTexto12          db "Cantidad de mov. izq-arr.",0
    mensajeTexto13          db "Cantidad de mov. izq-aba.",0
    mensajeTexto14          db "Cantidad de mov. der-arr.",0
    mensajeTexto15          db "Cantidad de mov. der-aba.",0
    mensajeTexto16          db "Cantidad de ocas comidas.",0
    mensajeTexto17          db "Pos. X del Zorro.",0
    mensajeTexto18          db "Pos. Y del Zorro.",0
    mensajeTexto19          db "\N (Fin de los datos).",0
    mensajeTexto20          db "----------------------------------------------",0

    matriz_default          db '==OOO==', '==OOO==', 'OOOOOOO', 'O     O', 'O  Z  O', '==   ==', '==   =='
    matriz_invertida        db '==   ==', '==   ==', 'O  Z  O', 'O     O', 'OOOOOOO', '==OOO==', '==OOO=='
    matriz_rot_der          db '==OOO==', '==  O==', '    OOO', '  Z OOO', '    OOO', '==  O==', '==OOO=='
    matriz_rot_izq          db '==OOO==', '==O  ==', 'OOO    ', 'OOO Z  ', 'OOO    ', '==O  ==', '==OOO=='

    mensErrorOpcion         db "No existe la opcion ingresada.",0
    mensErrorAbrir          db "No se pudo abrir el archivo.",0
    mensErrorDireccion      db "Esa no es una direccion valida.",0
    mensErrorEscribir       db "Hubo un error al escribir el nuevo archivo.",0

    nombreArchivoW          db "W_sentido.txt",0
    nombreArchivoS          db "S_sentido.txt",0
    nombreArchivoA          db "A_sentido.txt",0
    nombreArchivoD          db "D_sentido.txt",0
    finDelTablero           db "\N",0
    salto_linea             db 10, 0      ; Codigo ASCII para nueva linea y terminador nulo.

    contadorChar            dq  0   ; Contador de caracteres.
    contadorLinea           dq  0   ; Contador de lineas leidas (Matriz programa).
    
    modoLectura             db "r",0
    modoEscritura           db "w",0
    formato                 db "%s",0
    formato_char            db "%c",0
    formato_num             db "%d", 0
    charBuffer              db  0   ; Buffer para almacenar un solo caracter.

    nombrePrueba            db "nuevo.txt",0

    cd_clear                db  "clear",0

; Definicion de variables utilizadas en el programa.
section .bss
    idArchivo           resq    1
    idArchivoCopia      resq    1
    registro            resb    65
    letra               resb    1   ; Letra ingresada por el usuario.
    matriz              resb    49  ; Matriz de 7x7 caracteres.
    linea_contador      resd    1   ; Contador de lineas leidas (Matriz archivo).
    nombre_archivo      resb    64  ; Nombre del archivo que contiene el tablero a jugar.

    ; Todos los elementos extra del archivo (ademas de la matriz).
    charSentido         resb    1
    charSentidoAux      resb    1
    charZorro           resb    1
    charOca             resb    1
    movArriba           resb    1
    movAbajo            resb    1
    movIzquierda        resb    1
    movDerecha          resb    1
    movArrIzq           resb    1
    movAbaIzq           resb    1
    movArrDer           resb    1
    movAbaDer           resb    1
    cantOcasComidas     resb    1
    posXZorro           resb    1
    posYZorro           resb    1

; Codigo de ejecucion del programa.
section .text

; Imprime las indicaciones basicas del tipo de partida.
main:
    mLimpiar
    mPuts mensajeInicial1
    mPuts mensajeInicial2
    mPuts mensajeInicial3
    mPuts mensajeInicial4
    mPuts mensajeInicial5
    mPuts mensajeInicial6
    mPuts mensajeInicial7

; Bucle de seleccion de juego.
seleccion_juego:

    ; Obtiene la letra que el usuario ingresa por consola (No se usa 'obtener_letra' porque se bugea).
    sub     rsp, 8            ; Alinear la pila
    call    getchar
    add     rsp, 8            ; Restaurar la pila
    mov     [letra], al
    
    ; Bifurca en base a la entrada del usuario.
    mov     al, [letra]
    cmp     al, 'B'
    je      juego_base
    cmp     al, 'b'
    je      juego_base
    cmp     al, 'N'
    je      nuevo_juego
    cmp     al, 'n'
    je      nuevo_juego
    cmp     al, 'C'
    je      cargar_juego
    cmp     al, 'c'
    je      cargar_juego
    cmp     al, 'F'
    je      salir_juego
    cmp     al, 'f'
    je      salir_juego
    jmp     errorOpcion1

; Inicia una nueva partida con configuracion predeterminada.
juego_base:
    call    limpiar_buffer
    mov rsi, nombreArchivoW
    lea rdi, [nombre_archivo]
    call copiar_cadena

    mov rsi, matriz_default
    lea rdi, [matriz]
    call copiar_matriz

    mov     byte [charSentido], 'W'
    mov     byte [posXZorro], '3'
    mov     byte [posYZorro], '4'

    call valores_base

    jmp guardar_archivo

; Inicia una nueva partida con opciones de configuracion.
nuevo_juego:
    mPuts   mensajeNueva
    mPuts   mensajeSentido1
    mPuts   mensajeSentido2
    mPuts   mensajeSentido3
    mPuts   mensajeSentido4
    mPuts   mensajeOpcionAnterior

    call    limpiar_buffer

    call    obtener_letra

    ; Bifurca en base a la entrada del usuario.
    mov     al, [letra]
    cmp     al, 'N'
    je      inicializar_tableroW
    cmp     al, 'n'
    je      inicializar_tableroW
    cmp     al, 'S'
    je      inicializar_tableroS
    cmp     al, 's'
    je      inicializar_tableroS
    cmp     al, 'E'
    je      inicializar_tableroD
    cmp     al, 'e'
    je      inicializar_tableroD
    cmp     al, 'O'
    je      inicializar_tableroA
    cmp     al, 'o'
    je      inicializar_tableroA
    cmp     al, 'X'
    je      main
    cmp     al, 'x'
    je      main
    jmp     errorDireccion1

; Carga una partida con opciones de configuracion.
cargar_juego:
    mPuts   mensajeCargar
    mPuts   mensajeSentido1
    mPuts   mensajeSentido2
    mPuts   mensajeSentido3
    mPuts   mensajeSentido4
    mPuts   mensajeOpcionAnterior

    call    limpiar_buffer

    call    obtener_letra

    ; Bifurca en base a la entrada del usuario.
    mov     al, [letra]
    cmp     al, 'N'
    je      archivo_W
    cmp     al, 'n'
    je      archivo_W
    cmp     al, 'S'
    je      archivo_S
    cmp     al, 's'
    je      archivo_S
    cmp     al, 'E'
    je      archivo_D
    cmp     al, 'e'
    je      archivo_D
    cmp     al, 'O'
    je      archivo_A
    cmp     al, 'o'
    je      archivo_A
    cmp     al, 'X'
    je      main
    cmp     al, 'x'
    je      main
    jmp     errorDireccion2

; Sale del bucle de eleccion y termina el juego.
salir_juego:
    mPuts mensajeFinJuego
    jmp     fin

; Inicializa un tablero base en sentido por defecto.
inicializar_tableroW:
    mov rsi, nombreArchivoW
    lea rdi, [nombre_archivo]
    call copiar_cadena

    mov rsi, matriz_default
    lea rdi, [matriz]
    call copiar_matriz

    mov     byte [charSentido], 'W'
    mov     byte [posXZorro], '3'
    mov     byte [posYZorro], '4'

    call valores_base
    
    jmp personalizacion

; Inicializa un tablero base en sentido invertido.
inicializar_tableroS:
    mov rsi, nombreArchivoS
    lea rdi, [nombre_archivo]
    call copiar_cadena

    mov rsi, matriz_invertida
    lea rdi, [matriz]
    call copiar_matriz

    mov     byte [charSentido], 'S'
    mov     byte [posXZorro], '3'
    mov     byte [posYZorro], '2'

    call valores_base
    
    jmp personalizacion

; Inicializa un tablero base en sentido rotado a la derecha.
inicializar_tableroD:
    mov rsi, nombreArchivoD
    lea rdi, [nombre_archivo]
    call copiar_cadena

    mov rsi, matriz_rot_der
    lea rdi, [matriz]
    call copiar_matriz

    mov     byte [charSentido], 'D'
    mov     byte [posXZorro], '2'
    mov     byte [posYZorro], '3'

    call valores_base
    
    jmp personalizacion

; Inicializa un tablero base en sentido rotado a la izquierda.
inicializar_tableroA:
    mov rsi, nombreArchivoA
    lea rdi, [nombre_archivo]
    call copiar_cadena

    mov rsi, matriz_rot_izq
    lea rdi, [matriz]
    call copiar_matriz

    mov     byte [charSentido], 'A'
    mov     byte [posXZorro], '4'
    mov     byte [posYZorro], '3'

    call valores_base
    
    jmp personalizacion

; Inicializa los valores base de la nueva partida.
valores_base:
    mov     byte [charZorro], 'Z'
    mov     byte [charOca], 'O'
    mov     byte [movArriba], '0'
    mov     byte [movAbajo], '0'
    mov     byte [movIzquierda], '0'
    mov     byte [movDerecha], '0'
    mov     byte [movArrIzq], '0'
    mov     byte [movAbaIzq], '0'
    mov     byte [movArrDer], '0'
    mov     byte [movAbaDer], '0'
    mov     byte [cantOcasComidas], '0'

    ret

; Imprime la matriz desde la matriz cargada en el programa.
mostrar_tablero:
    mPuts mensajeEstadoTablero

    mov         rbx,matriz
    mov         qword[contadorChar],0
    mov         qword[contadorLinea],0

; Imprime cada caracter de la matriz.
imprimirChar:
    cmp         qword[contadorChar],7
    je          siguienteLinea

    mov         rsi,0
    mov         sil,byte[rbx]
    mov         rdi,formato_char
    sub         rsp,8
    call        printf
    add         rsp,8 

    inc         rbx
    inc         qword[contadorChar]
    jmp         imprimirChar

; Avanza a la siguiente fila de la matriz.
siguienteLinea:
    mov         qword[contadorChar],0
    inc         qword[contadorLinea]

    mov         sil,10
    mov         rdi,formato_char
    sub         rsp,8
    call        printf
    add         rsp,8

    cmp         qword[contadorLinea],7
    je          finDeImpresion
    jmp         imprimirChar

; Termina la impresion de la matriz.
finDeImpresion:
    jmp menu_personalizacion

; Carga el estado de la partida guardada en sentido este en la matriz.
archivo_D:
    mov rsi, nombreArchivoD
    lea rdi, [nombre_archivo]
    call copiar_cadena

    mPuts mensajeEstadoTablero
    mov     rdi, nombreArchivoD
    jmp     abrir_archivo_lectura

; Carga el estado de la partida guardada en sentido norte en la matriz.
archivo_W:
    mov rsi, nombreArchivoW
    lea rdi, [nombre_archivo]
    call copiar_cadena

    mPuts mensajeEstadoTablero
    mov     rdi, nombreArchivoW
    jmp     abrir_archivo_lectura

; Carga el estado de la partida guardada en sentido oeste en la matriz.
archivo_A:
    mov rsi, nombreArchivoA
    lea rdi, [nombre_archivo]
    call copiar_cadena

    mPuts mensajeEstadoTablero
    mov     rdi, nombreArchivoA
    jmp     abrir_archivo_lectura

; Carga el estado de la partida guardada en sentido sur en la matriz.
archivo_S:
    mov rsi, nombreArchivoS
    lea rdi, [nombre_archivo]
    call copiar_cadena

    mPuts mensajeEstadoTablero
    mov     rdi, nombreArchivoS
    jmp     abrir_archivo_lectura

; Abre el archivo en modo lectura.
abrir_archivo_lectura:
    mov     rsi, modoLectura
    sub     rsp,8
    call    fopen
    add     rsp,8

    cmp     rax, 0
    jle     errorOPEN
    mov     qword[idArchivo],rax

; Si el archivo se abrio de forma exitosa llega a este punto.
archivo_abierto:
    mov     dword [linea_contador], 0
    mov     rdx,[idArchivo]

; Copia la matriz del archivo en la matriz del programa.
cargar_linea_matriz:
    ;Obtenemos el contenido de la linea del texto.
    mov     rdi,registro
    mov     rsi,64
    mov     rdx,[idArchivo]
    call    fgets

    cmp     rax,0
    je      obtenerDatos

    ; Comparamos si no es un fin de lectura de matriz.
    lea  rsi,registro
    lea  rdi,[finDelTablero]
    cmpsb
    je obtenerDatos

    ; Almacenar la línea leída en la matriz
    mov     ecx, [linea_contador]
    mov     rsi, registro
    imul    ecx, ecx, 7
    lea     rdi, [matriz + rcx]
    mov     rbx, 7

; Imprime la matriz desde el archivo.
imprimir_linea:
    movsb
    dec     rbx
    jnz     imprimir_linea

    ; Incrementar el contador de líneas y corta cuando se leyo toda la matriz.
    inc     dword [linea_contador]
    cmp     dword [linea_contador], 8
    je      obtenerDatos

    ; Imprimir la línea leída
    mov     rdi, formato
    mov     rsi, registro
    sub     rsp, 8
    call    printf
    add     rsp, 8

    jmp     cargar_linea_matriz

; Obtiene el resto de datos del archivo.
obtenerDatos:
    mov     rdi,registro
    mov     rsi,64
    mov     rdx,[idArchivo]
    call    fgets
    mov     rsi, registro
    mov     al, [rsi]
    mov     [charSentido], al

    mov     rdi,registro
    mov     rsi,64
    mov     rdx,[idArchivo]
    call    fgets
    mov     rsi, registro
    mov     al, [rsi]
    mov     [charZorro], al

    mov     rdi,registro
    mov     rsi,64
    mov     rdx,[idArchivo]
    call    fgets
    mov     rsi, registro
    mov     al, [rsi]
    mov     [charOca], al

    mov     rdi,registro
    mov     rsi,64
    mov     rdx,[idArchivo]
    call    fgets
    mov     rsi, registro
    mov     al, [rsi]
    mov     [movArriba], al

    mov     rdi,registro
    mov     rsi,64
    mov     rdx,[idArchivo]
    call    fgets
    mov     rsi, registro
    mov     al, [rsi]
    mov     [movAbajo], al

    mov     rdi,registro
    mov     rsi,64
    mov     rdx,[idArchivo]
    call    fgets
    mov     rsi, registro
    mov     al, [rsi]
    mov     [movIzquierda], al

    mov     rdi,registro
    mov     rsi,64
    mov     rdx,[idArchivo]
    call    fgets
    mov     rsi, registro
    mov     al, [rsi]
    mov     [movDerecha], al

    mov     rdi,registro
    mov     rsi,64
    mov     rdx,[idArchivo]
    call    fgets
    mov     rsi, registro
    mov     al, [rsi]
    mov     [movArrIzq], al

    mov     rdi,registro
    mov     rsi,64
    mov     rdx,[idArchivo]
    call    fgets
    mov     rsi, registro
    mov     al, [rsi]
    mov     [movAbaIzq], al

    mov     rdi,registro
    mov     rsi,64
    mov     rdx,[idArchivo]
    call    fgets
    mov     rsi, registro
    mov     al, [rsi]
    mov     [movArrDer], al

    mov     rdi,registro
    mov     rsi,64
    mov     rdx,[idArchivo]
    call    fgets
    mov     rsi, registro
    mov     al, [rsi]
    mov     [movAbaDer], al

    mov     rdi,registro
    mov     rsi,64
    mov     rdx,[idArchivo]
    call    fgets
    mov     rsi, registro
    mov     al, [rsi]
    mov     [cantOcasComidas], al

    mov     rdi,registro
    mov     rsi,64
    mov     rdx,[idArchivo]
    call    fgets
    mov     rsi, registro
    mov     al, [rsi]
    mov     [posXZorro], al

    mov     rdi,registro
    mov     rsi,64
    mov     rdx,[idArchivo]
    call    fgets
    mov     rsi, registro
    mov     al, [rsi]
    mov     [posYZorro], al

; Cierra el archivo y finaliza la lectura de datos.
finalizarLectura:
    mov     rdi, [idArchivo]
    sub     rsp, 8
    call    fclose
    add     rsp, 8

    mov     ecx, 0
    mov     rdi, salto_linea
    sub     rsp, 8
    call    printf
    add     rsp, 8

; Pregunta al usuario si quiere personalizar y da instrucciones basicas.
personalizacion:
    mPuts   mensajePersonalizacion1
    mPuts   mensajePersonalizacion2
    mPuts   mensajePersonalizacion3

    call    limpiar_buffer

    call    obtener_letra

    call    limpiar_buffer

    ; Bifurca en base a la entrada del usuario.
    mov     al, [letra]
    cmp     al, 'S'
    je      menu_personalizacion
    cmp     al, 's'
    je      menu_personalizacion
    cmp     al, 'N'
    je      guardar_archivo
    cmp     al, 'n'
    je      guardar_archivo
    jmp     errorOpcion2

; Inicia el juego llamando a la rutina externa 'procedimientoDelJuego'.
iniciar_juego:
    mLimpiar
    mPuts   mensajeInicioPartida

    ; Mover la direccion de nombre_archivo al rbx.
    lea rbx, [nombre_archivo]

    sub  rsp,8
    call procedimientoDelJuego
    add  rsp,8

    ret

; Ofrece las opciones de personalizacion al usuario.
menu_personalizacion:
    mPuts mensajeEstadoTablero

    mPuts   mensajePersonalizacion4
    mPuts   mensajePersonalizacion5
    mPuts   mensajePersonalizacion6
    mPuts   mensajePersonalizacion7
    mPuts   mensajePersonalizacion8
    mPuts   mensajeOpcionAnterior

    call    obtener_letra

    call    limpiar_buffer

    ; Bifurca en base a la entrada del usuario.
    mov     al, [letra]
    cmp     al, 'Z'
    je      cambio_zorro
    cmp     al, 'z'
    je      cambio_zorro
    cmp     al, 'O'
    je      cambio_ocas
    cmp     al, 'o'
    je      cambio_ocas
    cmp     al, 'M'
    je      mostrar_tablero
    cmp     al, 'm'
    je      mostrar_tablero
    cmp     al, 'J'
    je      guardar_archivo
    cmp     al, 'j'
    je      guardar_archivo
    cmp     al, 'X'
    je      personalizacion
    cmp     al, 'x'
    je      personalizacion
    jmp     errorOpcion3

; Cambia el simbolo que representa al Zorro.
cambio_zorro:
    mPuts   mensajeCambioZorro

    call obtener_letra

    call limpiar_buffer

    mov     al, [charZorro]
    mov     rcx, 0

; Busca y reemplaza al Zorro en el tablero.
buscar_y_reemplazar_zorro:
    cmp     rcx, 49
    jge     finReemplazoZorro

    mov     dl, [matriz + rcx]
    cmp     dl, al
    jne     siguienteZorro

    mov     al, [letra]

    mov     byte [matriz + rcx], al

    ; Actualizar el nuevo simbolo del Zorro.
    mov     [charZorro], al

    ; Salir del bucle despues de hacer el reemplazo.
    jmp     finReemplazoZorro

; Avanza una posicion para seguir buscando al Zorro.
siguienteZorro:
    inc     rcx
    jmp     buscar_y_reemplazar_zorro

; Terminar el reemplazo de simbolo del Zorro.
finReemplazoZorro:
    jmp     menu_personalizacion

; Cambia el simbolo que representa a las Ocas.
cambio_ocas:
    mPuts   mensajeCambioOcas

    call obtener_letra

    call limpiar_buffer

    mov     al, [charOca]
    mov     rcx, 0

; Busca y reemplaza las Ocas en el tablero.
buscar_y_reemplazar_oca:
    cmp     rcx, 49
    jge     finReemplazoOca

    mov     dl, [matriz + rcx]
    cmp     dl, al
    jne     siguienteOca

    mov     al, [letra]

    mov     byte [matriz + rcx], al

    mov     al, [charOca]

    ; Salir del bucle despues de hacer el reemplazo.
    jmp     siguienteOca

; Avanza una posicion para seguir buscando a las Ocas.
siguienteOca:
    inc     rcx
    jmp     buscar_y_reemplazar_oca

; Terminar el reemplazo de simbolo de las Ocas.
finReemplazoOca:
    mov     al, [letra]
    mov     [charOca], al
    jmp     menu_personalizacion

; Guardar los cambios realizados en el archivo actual.
guardar_archivo:
    ; Crear archivo de salida.
    mov     rdi, nombre_archivo
    mov     rsi, modoEscritura
    sub     rsp, 8
    call    fopen
    add     rsp, 8

    cmp     rax, 0
    jle     errorWRITE
    mov     qword[idArchivoCopia], rax

; Escribe el tablero en el archivo.
guardar_tablero:
    mov         rbx,matriz
    mov         qword[contadorChar],0
    mov         qword[contadorLinea],0

; Escribe cada caracter de la matriz.
EscribirChar:
    cmp         qword[contadorChar],7
    je          siguienteLineaEscrita

    movzx       eax, byte [rbx]
    mov         edi, eax
    mov         rsi, [idArchivoCopia]
    sub         rsp, 8
    call        fputc
    add         rsp, 8

    inc         rbx
    inc         qword[contadorChar]
    jmp         EscribirChar

; Avanza a la siguiente fila de la matriz.
siguienteLineaEscrita:
    mov         qword[contadorChar],0
    inc         qword[contadorLinea]

    mov     rdi, salto_linea
    mov     rsi, [idArchivoCopia]
    sub     rsp, 8
    call    fputs
    add     rsp, 8

    cmp         qword[contadorLinea],7
    je          finDeEscritura
    jmp         EscribirChar

; Añade el resto de elementos al archivo.
finDeEscritura:
    mTextPuts   finDelTablero

    mTextPuts   salto_linea

    mTextPuts   charSentido

    mTextPuts   salto_linea

    mTextPutc   [charZorro]

    mTextPuts   salto_linea

    mTextPutc   [charOca]

    mTextPuts   salto_linea

    mTextPutc   [movArriba]

    mTextPuts   salto_linea

    mTextPutc   [movAbajo]

    mTextPuts   salto_linea

    mTextPutc   [movIzquierda]

    mTextPuts   salto_linea

    mTextPutc   [movDerecha]

    mTextPuts   salto_linea

    mTextPutc   [movArrIzq]

    mTextPuts   salto_linea

    mTextPutc   [movAbaIzq]

    mTextPuts   salto_linea

    mTextPutc   [movArrDer]

    mTextPuts   salto_linea

    mTextPutc   [movAbaDer]

    mTextPuts   salto_linea

    mTextPutc   [cantOcasComidas]

    mTextPuts   salto_linea

    mTextPutc   [posXZorro]

    mTextPuts   salto_linea

    mTextPutc   [posYZorro]

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto1

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto2

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto3

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto4

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto5

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto6

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto7

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto8

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto9

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto10

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto11

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto12

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto13

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto14

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto15

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto16

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto17

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto18

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto19

    mTextPuts   salto_linea

    mTextPuts   mensajeTexto20

    mTextPuts   salto_linea

; Termina la escritura del texto.
finEscritura:
    mov     rdi, [idArchivoCopia]
    sub     rsp, 8
    call    fclose
    add     rsp, 8

    jmp iniciar_juego

; Obtiene la letra que el usuario ingresa por consola
obtener_letra:
    sub     rsp, 8            ; Alinear la pila
    call    getchar
    add     rsp, 8            ; Restaurar la pila
    mov     [letra], al
    ret

; Guarda el nombre (cadena de caracteres) del archivo seleccionado.
copiar_cadena:
    mov rcx, 64  ; Maximo numero de bytes a copiar

; Loop de copiado de la cadena.
copiar_cadena_loop:
    lodsb           ; Cargar byte de [RSI] en AL y avanzar RSI
    stosb           ; Almacenar byte de AL en [RDI] y avanzar RDI
    test al, al     ; Verificar si es el terminador nulo
    jz copiar_fin   ; Si es cero, fin de la cadena
    loop copiar_cadena_loop

; Finaliza la copia.
copiar_fin:
    ret

; Copia una matriz predeterminada en la matriz a jugar (tablero).
copiar_matriz:
    mov rcx, 49  ; Numero de bytes a copiar (7x7)

; Loop de copiado de la matriz.
copiar_matriz_loop:
    lodsb           ; Cargar byte de [RSI] en AL y avanzar RSI
    stosb           ; Almacenar byte de AL en [RDI] y avanzar RDI
    loop copiar_matriz_loop
    ret

; Funcion para limpiar el bufer de entrada.
limpiar_buffer:
    sub     rsp, 8            ; Alinear la pila

; Loop de limpieza.
limpiar_bucle:
    call    getchar
    cmp     al, 10            ; Verificar si es '\n'
    jne     limpiar_bucle
    add     rsp, 8            ; Restaurar la pila
    ret

; Manejo de error de opcion ingresada.
errorOpcion1:
    call    limpiar_buffer
    mPuts   mensErrorOpcion
    jmp     main

; Manejo de error de opcion ingresada.
errorOpcion2:
    mPuts   mensErrorOpcion
    jmp     personalizacion

; Manejo de error de opcion ingresada.
errorOpcion3:
    mPuts   mensErrorOpcion
    jmp     menu_personalizacion

; Manejo de error de apertura de archivo.
errorOPEN:
    mPuts   mensErrorAbrir
    jmp     main

; Manejo de error de direccion ingresada.
errorDireccion1:
    mPuts   mensErrorDireccion
    jmp     nuevo_juego

; Manejo de error de direccion ingresada.
errorDireccion2:
    mPuts   mensErrorDireccion
    jmp     cargar_juego

; Manejo de error de falla al escribir el archivo de la partida actual.
errorWRITE:
    mPuts   mensErrorEscribir
    jmp     fin

; Finaliza el programa.
fin:
    ret