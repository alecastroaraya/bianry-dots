;--------------------------------------------Portada-------------------------------------------------------------------------------------
; Tarea diagnostico de ASM: Binary Dots
; Curso: Arquitectura de Computadores
; Grupo: 2
; Escuela de Computacion
; Instituto Tecnologico de Costa Rica
; Fecha de entrega: Miercoles 9 de setiembre del 2020
; Estudiante: Alejandro Castro Araya
; Carne: 2020034944
; Profesor: Kirstein Gätjens S.
;--------------------------------------------Manual de Usuario---------------------------------------------------------------------------
; Este programa recibe un numero binario dado en la linea de comandos y luego despliega la cantidad dada en puntos. Si no se escribe nada, despliega la ayuda del programa. Si no se escribe un numero binario valido da un error y se sale ;del programa.
;--------------------------------------------Analisis------------------------------------------------------------------------------------ 
;+---------------------------------------------------------------------------------------------+------+----------------------+
;|                                            Parte                                            | Nota | Explicacion Adicional|
;+---------------------------------------------------------------------------------------------+------+----------------------+
;| Desplegar el acerca de                                                                      |  A   | Concluido con exito  |
;| Leer de izquierda a derecha el numero binario en la linea de comandos                       |  A   | Concluido con exito  |
;| Desplegar la ayuda                                                                          |  A   | Concluido con exito  |
;| Traducir de texto a binario                                                                 |  A   | Concluido con exito  |
;| Contar los puntos                                                                           |  A   | Concluido con exito  |
;| Desplegar mensajes de error                                                                 |  A   | Concluido con exito  |
;| Documentación (Portada, manual de usuario y analisis de resultados con ABCDE) y comentarios |  A   | Concluido con exito  |
;---------------------------------------------------------------------------------------------------------------------------------------


data segment

	acercade db 'Arquitectura de Computadores Grupo 2 Alejandro Castro Araya - Tarea Binary Dots' ,13, 10, 'Carne 2020034944 Ver. 0.74-3 01/09/2020', 13, 10, ' ', 13, 10, '$'
	ayuda db 'Recibe un numero binario en la linea de comandos y luego despliega esa cantidad en puntos.$'
	punto db '.$'
	daerror db 'Error: No escribio un numero binario valido. Terminando el programa...$'
	

data ends


pila segment stack 'stack'
   dw 256 dup(?)

pila ends


code segment
.model small
.386

        assume  cs:code, ds:data, ss:pila

start:

	mov ax,ds ; Se mueve ds a es
	mov es,ax

	mov ax,data ; Inicializa el data segment mandandolo al ds register
	mov ds,ax

	mov ax,pila ; Inicializa la pila mandandola al ss register
	mov ss,ax

	mov si,82h ; Se mueve lo que se puso en la command line al source index

	lea dx,acercade ; Asigna la address del acerca de al registro dx
	mov ah,9h ; Hace un DOS interrupt y hace display del acerca de que tiene la address cargada en DX
	int 21h

	mov bx,0 ; Le pongo 0 a bx para poder luego enciclarlo para conseguir todos los bytes de lo que se desea convertir
	mov cl,0 ; Le muevo 0 a cl para asegurarme que su valor inicial sea 0 para luego usar a cl en operaciones aritmeticas como add y dec

leerNumero1:

	mov al,byte ptr es:[si] ; Muevo el primer byte a al. Luego reviso si esta en blanco (y muestro la ayuda), o si es mayor a 1 o menor a 0 (y muestro un error). Si no es nada de esto, es 1 o 0.
	cmp al,0h
	je darAyuda
	cmp al,31h
	jg darError
	cmp al,30h
	jl darError
	cmp al,31h ; Si es 1, voy al procedimiento es1
	je es1
	cmp al,30h ; Si es 0, voy al procedimiento es0
	je es0

darAyuda:

	lea dx,ayuda ; Este procedimiento muestra el rotulo de la ayuda  y luego termina el programa
	mov ah,9h
	int 21h
	jmp terminar

ciclo:

	inc bx                      ; Este procedimiento empieza a revisar de izquierda a derecha a partir del segundo byte del numero binario dado, por medio de enciclarse e incrementar bx por 1 cada ciclo.
	mov al,byte ptr es:[si+bx]  ; Muevo el segundo, luego tercero, luego cuarto, etc. byte a al
	cmp al,20h		    ; Si el byte esta vacio, ya se termina de leer de el numero binario y se procede a desplegar los puntos
	jl printearPuntos
	cmp al,31h		    ; Si el byte es 1, se multiplica el valor inicial por 2 y luego se le suma 1
	je multiPor2ySuma
	cmp al,30h
	je multiPor2		    ; Si el byte es 0, se multiplica el valor inicial por 2
	cmp al,31h		    ; Si el byte es mayor que 1 o menor que 0, da error porque entonces el numero dado no es valido
	jg darError
	cmp al,30h
	jl darError

darError:

	lea dx,daerror		    ; Despliega un rotulo que dice que hubo un error
	mov ah,9h
	int 21h
	jmp terminar

es1:

	mov cl,1		   ; Si el primer byte es 1, se le mueve el valor inicial 1 a cl, para ser usado en operaciones aritmeticas luego, y despues se devuelve  al ciclo
	jmp ciclo

es0:

	mov cl,0		   ; Si el primer byte es 0, se le mueve el valor inicial 0 a cl, para ser usado en operaciones aritmeticas luego, y despues se devuelve al ciclo
	jmp ciclo

multiPor2ySuma:

	add cl,cl		   ; Se multiplica el valor inicial dado al cl por el mismo, y luego se le suma 1 porque el byte leido fue 1
	inc cl
	jmp ciclo

multiPor2:

	add cl,cl		   ; Se multiplica el valor inicial dado al cl por el mismo porque el byte leido fue 0
	jmp ciclo

printearPuntos:

	cmp cl,0		   ; Se crea un ciclo en el cualm, usando el valor total de cl, se despliegan puntos hasta que cl se haya reducido a 0, y luego se termina el programa
	je terminar
	lea dx,punto
	mov ah,9h
	int 21h
	dec cl
	jmp printearPuntos

terminar:

	mov ah,4ch ; Hace interrupt para hacer exit hacia DOS para terminar el programa
	int 21h

code ends

end start