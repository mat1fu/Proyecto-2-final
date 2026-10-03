

:- consult('base_conocimiento.pl').


iniciar :-
    nl,
    writeln('      ORGANIZADOR INTELIGENTE DE ENTRENAMIENTO PERSONALIZADO    '),
    nl,
    preguntar_dias(Dias),
    preguntar_edad(Edad),
    preguntar_peso(Peso),
    preguntar_objetivo(Objetivo),
    preguntar_nivel(Nivel),
    preguntar_equipo(Equipo),
    preguntar_lesion(Lesion),
    % Iniciar bucle de evaluacion y ajuste con los parametros base
    ciclo_planificacion(Dias, Edad, Peso, Objetivo, Nivel, Equipo, Lesion).



ciclo_planificacion(Dias, Edad, Peso, Objetivo, Nivel, Equipo, Lesion) :-
    nl,
    writeln('                TU PLAN DE ENTRENAMIENTO PERSONAL               '),
    calcular_dosificacion(Objetivo, Nivel, Edad, Dosis),
    format('Esquema personalizado para ~w anos (~w kg):~n', [Edad, Peso]),
    format('>>> ~w~n~n', [Dosis]),
    generar_plan(Dias, Nivel, Equipo, Lesion, Peso),
    consultar_satisfaccion(Dias, Edad, Peso, Objetivo, Nivel, Equipo, Lesion).

consultar_satisfaccion(Dias, Edad, Peso, Objetivo, Nivel, Equipo, Lesion) :-
    nl,
    writeln('Estas satisfecho con este plan de entrenamiento?'),
    writeln('Opciones: [si, no]'),
    write('-> Ingrese opcion con punto (ej: si. o no.): '),
    read(Respuesta),
    procesar_respuesta(Respuesta, Dias, Edad, Peso, Objetivo, Nivel, Equipo, Lesion).

procesar_respuesta(si, _, _, _, _, _, _, _) :-
    nl,
    writeln('   Genial! Tu plan ha quedado registrado con exito. A entrenar! '),
    nl, !.

procesar_respuesta(no, Dias, Edad, Peso, Objetivo, Nivel, Equipo, Lesion) :-
    nl,
    writeln('Entendido, ajustemos las condiciones de tu plan.'),
    writeln('Que parametro te gustaria modificar?'),
    writeln('1. Dias a la semana'),
    writeln('2. Objetivo de entrenamiento'),
    writeln('3. Nivel de experiencia'),
    writeln('4. Equipamiento disponible'),
    writeln('5. Lesion o molestia articular'),
    writeln('0. Cancelar y quedarme con este plan'),
    write('-> Elige una opcion con punto (ej: 1. o 4.): '),
    read(Opcion),
    ejecutar_modificacion(Opcion, Dias, Edad, Peso, Objetivo, Nivel, Equipo, Lesion).

procesar_respuesta(_, Dias, Edad, Peso, Objetivo, Nivel, Equipo, Lesion) :-
    writeln('Opcion no reconocida. Por favor ingresa si. o no.'),
    consultar_satisfaccion(Dias, Edad, Peso, Objetivo, Nivel, Equipo, Lesion).



ejecutar_modificacion(1, _, Edad, Peso, Objetivo, Nivel, Equipo, Lesion) :-
    preguntar_dias(NuevosDias),
    ciclo_planificacion(NuevosDias, Edad, Peso, Objetivo, Nivel, Equipo, Lesion).

ejecutar_modificacion(2, Dias, Edad, Peso, _, Nivel, Equipo, Lesion) :-
    preguntar_objetivo(NuevoObj),
    ciclo_planificacion(Dias, Edad, Peso, NuevoObj, Nivel, Equipo, Lesion).

ejecutar_modificacion(3, Dias, Edad, Peso, Objetivo, _, Equipo, Lesion) :-
    preguntar_nivel(NuevoNivel),
    ciclo_planificacion(Dias, Edad, Peso, Objetivo, NuevoNivel, Equipo, Lesion).

ejecutar_modificacion(4, Dias, Edad, Peso, Objetivo, Nivel, _, Lesion) :-
    preguntar_equipo(NuevoEquipo),
    ciclo_planificacion(Dias, Edad, Peso, Objetivo, Nivel, NuevoEquipo, Lesion).

ejecutar_modificacion(5, Dias, Edad, Peso, Objetivo, Nivel, Equipo, _) :-
    preguntar_lesion(NuevaLesion),
    ciclo_planificacion(Dias, Edad, Peso, Objetivo, Nivel, Equipo, NuevaLesion).

ejecutar_modificacion(0, _, _, _, _, _, _, _) :-
    nl,
    writeln('Se conserva el plan actual. Sesion finalizada.'),
    nl, !.

ejecutar_modificacion(_, Dias, Edad, Peso, Objetivo, Nivel, Equipo, Lesion) :-
    writeln('Opcion de modificacion invalida.'),
    procesar_respuesta(no, Dias, Edad, Peso, Objetivo, Nivel, Equipo, Lesion).


preguntar_dias(Dias) :-
    nl,
    writeln('Cuantos dias a la semana deseas entrenar?'),
    writeln('Opciones disponibles: 2, 3, 4 o 5.'),
    write('-> Ingrese numero con punto (ej: 3. o 4.): '),
    read(Dias).

preguntar_edad(Edad) :-
    nl,
    writeln('Cual es tu edad?'),
    write('-> Ingrese edad en anos con punto (ej: 21. o 55.): '),
    read(Edad).

preguntar_peso(Peso) :-
    nl,
    writeln('Cual es tu peso corporal aproximado en kg?'),
    write('-> Ingrese peso con punto (ej: 75. o 85.): '),
    read(Peso).

preguntar_objetivo(Obj) :-
    nl,
    writeln('Cual es tu objetivo principal?'),
    writeln('Opciones: [fuerza, hipertrofia, resistencia, salud_general]'),
    write('-> Ingrese opcion con punto (ej: hipertrofia.): '),
    read(Obj).

preguntar_nivel(Nivel) :-
    nl,
    writeln('Cual es tu nivel de entrenamiento?'),
    writeln('Opciones: [principiante, intermedio, avanzado]'),
    write('-> Ingrese opcion con punto (ej: principiante.): '),
    read(Nivel).

preguntar_equipo(Equipo) :-
    nl,
    writeln('Que equipamiento tienes disponible?'),
    writeln('Opciones: [peso_corporal, mancuernas, barra, gimnasio, cualquiera]'),
    write('-> Ingrese opcion con punto (ej: gimnasio.): '),
    read(Equipo).

preguntar_lesion(Lesion) :-
    nl,
    writeln('Tienes alguna lesion o molestia articular?'),
    writeln('Opciones: [ninguna, hombro, codo, rodilla, lumbar, muneca]'),
    write('-> Ingrese opcion con punto (ej: ninguna.): '),
    read(Lesion).



generar_plan(Dias, Nivel, Equipo, Lesion, Peso) :-
    (   generar_plan_semanal(Dias, Nivel, Equipo, Lesion, Peso, Plan)
    ->  imprimir_dias(Plan)
    ;   writeln('Lo sentimos: no fue posible armar un plan balanceado con esas restricciones.'),
        writeln('Intenta cambiar el equipamiento o revisar las limitaciones articulares.')
    ),
    nl.

imprimir_dias([]).
imprimir_dias([dia(NombreDia, Ejercicios) | Resto]) :-
    format('>>> ~w:~n', [NombreDia]),
    imprimir_ejercicios(Ejercicios),
    nl,
    imprimir_dias(Resto).

imprimir_ejercicios([]).
imprimir_ejercicios([E | Resto]) :-
    format('   - ~w~n', [E]),
    imprimir_ejercicios(Resto).