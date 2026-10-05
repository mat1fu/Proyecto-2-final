% ==============================================================================
% CHATBOT DE ENTRENAMIENTO EN PROLOG (ESTILO ELIZA: PALABRAS CLAVE)
% ==============================================================================
% Uso:   swipl chatbot1_consola.pl      y luego      ?- iniciar.
%
% Como funciona cada mensaje:
%   1. leer_mensaje: el texto se convierte en una lista de palabras.
%   2. responder:    la primera regla cuyas palabras clave aparezcan en el
%                    mensaje decide la respuesta, consultando la base de conocimiento.
% ==============================================================================

:- consult('base_conocimiento.pl').

% perfil(Dato, Valor): lo que el bot recuerda del usuario durante la conversacion
:- dynamic perfil/2.


% ------------------------------------------------------------------------------
% BUCLE PRINCIPAL
% ------------------------------------------------------------------------------
iniciar :-
    retractall(perfil(_, _)),
    nl,
    writeln('================================================================'),
    writeln('            ASISTENTE VIRTUAL DE ENTRENAMIENTO                  '),
    writeln('================================================================'),
    writeln('Escribeme normalmente (sin corchetes ni punto). Ejemplos:'),
    writeln('  que ejercicios hay de pierna'),
    writeln('  me duele el hombro'),
    writeln('  soy principiante y tengo 55 anos'),
    writeln('  hazme una rutina de 3 dias'),
    writeln('  cuantas repeticiones para fuerza'),
    writeln('  ayuda   |   adios'),
    nl,
    bucle_chat.

bucle_chat :-
    write('Usuario > '),
    leer_mensaje(Palabras),
    (   despedida(Palabras)
    ->  writeln('Bot > Hasta pronto, que tengas un excelente entrenamiento!')
    ;   responder(Palabras, Respuesta),
        format('Bot > ~w~n~n', [Respuesta]),
        bucle_chat
    ).

despedida(Palabras) :- alguna([adios, chao, chau, salir], Palabras).


% ------------------------------------------------------------------------------
% LECTURA DEL MENSAJE: texto -> lista de palabras
% ------------------------------------------------------------------------------
% "Que ejercicios hay de PIERNA?"  ->  [que, ejercicios, hay, de, pierna]
% Los numeros quedan como numeros: "tengo 55 anos" -> [tengo, 55, anos]
leer_mensaje(Palabras) :-
    read_line_to_string(user_input, Linea),
    (   Linea == end_of_file
    ->  Palabras = [adios]
    ;   string_lower(Linea, Minusculas),
        string_codes(Minusculas, Codigos),
        limpiar(Codigos, Limpios),
        string_codes(Texto, Limpios),
        split_string(Texto, " ", " ", Trozos),
        trozos_a_palabras(Trozos, Palabras)
    ).

% limpiar: quita tildes y reemplaza signos por espacios
limpiar([], []).
limpiar([C | Resto], [L | RestoLimpio]) :-
    letra(C, L),
    limpiar(Resto, RestoLimpio).

letra(C, L) :- sin_tilde(C, L), !.
letra(C, C) :- code_type(C, alnum), !.
letra(_, 0' ).

% sin_tilde(CodigoConTilde, CodigoSinTilde): a, e, i, o, u, u con dieresis y n con tilde
sin_tilde(225, 0'a).
sin_tilde(233, 0'e).
sin_tilde(237, 0'i).
sin_tilde(243, 0'o).
sin_tilde(250, 0'u).
sin_tilde(252, 0'u).
sin_tilde(241, 0'n).

trozos_a_palabras([], []).
trozos_a_palabras(["" | Resto], Palabras) :-
    !,
    trozos_a_palabras(Resto, Palabras).
trozos_a_palabras([Trozo | Resto], [Palabra | Palabras]) :-
    atom_string(Atomo, Trozo),
    (   atom_number(Atomo, Numero) -> Palabra = Numero ; Palabra = Atomo ),
    trozos_a_palabras(Resto, Palabras).


% ------------------------------------------------------------------------------
% HERRAMIENTAS PARA BUSCAR PALABRAS EN EL MENSAJE
% ------------------------------------------------------------------------------
% raiz: quita la 's' o 'es' final para tratar singular y plural igual (barra / barras)
raiz(Palabra, Raiz) :-
    atom(Palabra),
    atom_concat(Base, es, Palabra),
    atom_length(Base, Largo), Largo >= 5, !,
    Raiz = Base.
raiz(Palabra, Raiz) :-
    atom(Palabra),
    atom_concat(Base, s, Palabra),
    atom_length(Base, Largo), Largo >= 3, !,
    Raiz = Base.
raiz(Palabra, Palabra).

igual(A, B) :- raiz(A, R), raiz(B, R).

% esta(Palabra, Mensaje): la palabra aparece en el mensaje
esta(Palabra, Mensaje) :-
    member(P, Mensaje),
    igual(P, Palabra), !.

% alguna(Palabras, Mensaje): aparece al menos una de las palabras
alguna(Palabras, Mensaje) :-
    member(P, Palabras),
    esta(P, Mensaje), !.

% todas(Palabras, Mensaje): aparecen todas las palabras
todas([], _).
todas([P | Resto], Mensaje) :-
    esta(P, Mensaje),
    todas(Resto, Mensaje).


% ------------------------------------------------------------------------------
% VOCABULARIO: que significa cada palabra del usuario
% ------------------------------------------------------------------------------
% significa(Palabra, Tipo, Valor)
significa(hombro,      articulacion, hombro).
significa(codo,        articulacion, codo).
significa(muneca,      articulacion, muneca).
significa(lumbar,      articulacion, lumbar).
significa(espalda,     articulacion, lumbar).
significa(rodilla,     articulacion, rodilla).

significa(empuje,      division, empuje).
significa(traccion,    division, traccion).
significa(pierna,      division, pierna).
significa(core,        division, core).
significa(abdomen,     division, core).
significa(abdominal,   division, core).

significa(principiante, nivel, principiante).
significa(novato,       nivel, principiante).
significa(intermedio,   nivel, intermedio).
significa(avanzado,     nivel, avanzado).

significa(fuerza,       objetivo, fuerza).
significa(hipertrofia,  objetivo, hipertrofia).
significa(masa,         objetivo, hipertrofia).
significa(resistencia,  objetivo, resistencia).
significa(salud,        objetivo, salud_general).

significa(mancuerna,    equipo, mancuernas).
significa(barra,        equipo, barra).
significa(fija,         equipo, barra_fija).
significa(maquina,      equipo, maquina).
significa(polea,        equipo, polea).
significa(gimnasio,     equipo, gimnasio).
significa(casa,         equipo, peso_corporal).

significa(pecho,        musculo, pectoral).
significa(pectoral,     musculo, pectoral).
significa(hombro,       musculo, deltoides).
significa(triceps,      musculo, triceps).
significa(biceps,       musculo, biceps).
significa(espalda,      musculo, dorsal).
significa(dorsal,       musculo, dorsal).
significa(cuadriceps,   musculo, cuadriceps).
significa(isquiotibial, musculo, isquiotibiales).
significa(isquios,      musculo, isquiotibiales).
significa(gemelo,       musculo, gemelos).
significa(pantorrilla,  musculo, gemelos).
significa(abdomen,      musculo, abdomen).
significa(abdominal,    musculo, abdomen).

% buscar(Mensaje, Tipo, Valor): el mensaje menciona algo de ese tipo
buscar(Mensaje, Tipo, Valor) :-
    significa(Palabra, Tipo, Valor),
    esta(Palabra, Mensaje).

% nombres de ejercicios: alias(Ejercicio, PalabrasQueLoIdentifican)
% Van primero los mas especificos (mas palabras), porque se usa el primero que coincide.
alias(press_militar_mancuernas,  [press, militar, mancuerna]).
alias(press_militar_barra,       [press, militar]).
alias(press_mancuerna_inclinado, [press, inclinado]).
alias(press_banca_barra,         [press, banca]).
alias(press_frances,             [press, frances]).
alias(fondos_paralelas,          [fondos]).
alias(flexiones_suelo,           [flexiones]).
alias(elevaciones_laterales,     [elevaciones, laterales]).
alias(elevacion_piernas,         [elevacion, piernas]).
alias(elevacion_talones,         [talones]).
alias(dominadas_pronadas,        [dominadas]).
alias(jalon_polea,               [jalon]).
alias(remo_mancuerna_apoyo,      [remo, mancuerna]).
alias(remo_barra,                [remo]).
alias(face_pull,                 [face, pull]).
alias(curl_femoral,              [curl, femoral]).
alias(curl_biceps_mancuerna,     [curl, mancuerna]).
alias(curl_biceps_barra,         [curl]).
alias(sentadilla_goblet,         [sentadilla, goblet]).
alias(sentadilla_trasera,        [sentadilla]).
alias(prensa_inclinada,          [prensa]).
alias(peso_muerto_rumano,        [peso, muerto]).
alias(plancha_abdominal,         [plancha]).

% menciona_ejercicio(Mensaje, Ejercicio)
menciona_ejercicio(Mensaje, Ejercicio) :-
    alias(Ejercicio, Palabras),
    todas(Palabras, Mensaje), !.


% ------------------------------------------------------------------------------
% PERFIL DEL USUARIO (lo que el bot recuerda)
% ------------------------------------------------------------------------------
guardar(Dato, Valor) :-
    retractall(perfil(Dato, _)),
    assertz(perfil(Dato, Valor)).

% valor(Dato, Defecto, Valor): lo guardado, o el valor por defecto
valor(Dato, _, Valor) :- perfil(Dato, Valor), !.
valor(_, Defecto, Defecto).

% numero_con(Mensaje, Unidades, N): un numero seguido de una unidad ("75 kg", "3 dias")
numero_con(Mensaje, Unidades, N) :-
    append(_, [N, U | _], Mensaje),
    number(N),
    member(Unidad, Unidades),
    igual(U, Unidad), !.

% edad_en(Mensaje, Edad): "55 anos" o "tengo 55"
edad_en(Mensaje, Edad) :-
    numero_con(Mensaje, [ano], Edad), !.
edad_en(Mensaje, Edad) :-
    append(_, [tengo, Edad | Resto], Mensaje),
    number(Edad),
    \+ ( Resto = [U | _], member(U, [dia, dias, vez, veces, kg, kilo, kilos]) ), !.

% Lo que el mensaje diga tiene prioridad sobre lo guardado.
nivel_de(Mensaje, Nivel)  :- buscar(Mensaje, nivel, Nivel), !.
nivel_de(_, Nivel)        :- valor(nivel, intermedio, Nivel).

equipo_de(Mensaje, Equipo) :- buscar(Mensaje, equipo, Equipo), !.
equipo_de(_, Equipo)       :- valor(equipo, gimnasio, Equipo).

lesion_de(Mensaje, Lesion) :-
    alguna([duele, dolor, molestia, lesion, lesionado, lastimado], Mensaje),
    buscar(Mensaje, articulacion, Lesion), !.
lesion_de(_, Lesion) :- valor(lesion, ninguna, Lesion).

peso_de(Mensaje, Peso) :- numero_con(Mensaje, [kg, kilo, kilogramo], Peso), !.
peso_de(_, Peso)       :- valor(peso, 75, Peso).

edad_de(Mensaje, Edad) :- edad_en(Mensaje, Edad), !.
edad_de(_, Edad)       :- valor(edad, 25, Edad).

objetivo_de(Mensaje, Objetivo) :- buscar(Mensaje, objetivo, Objetivo), !.
objetivo_de(_, Objetivo)       :- perfil(objetivo, Objetivo).


% ------------------------------------------------------------------------------
% REGLAS DE RESPUESTA (el orden importa: gana la primera que se cumple)
% ------------------------------------------------------------------------------
responder(Mensaje, Respuesta) :-
    respuesta(Mensaje, Respuesta), !.
responder(_, 'No entendi tu consulta. Prueba con: "que ejercicios hay de pierna", "me duele el hombro", "rutina de 3 dias" o escribe "ayuda".').

% --- Puedo hacer un ejercicio si me duele una articulacion? ---
respuesta(Mensaje, Respuesta) :-
    menciona_ejercicio(Mensaje, Ejercicio),
    buscar(Mensaje, articulacion, Articulacion),
    alguna([puedo, seguro, peligroso, evitar, riesgo, malo, recomendable], Mensaje),
    nombre(Ejercicio, Nombre),
    (   carga_articulacion(Ejercicio, Articulacion)
    ->  format(atom(Respuesta), 'No es recomendable: ~w carga la articulacion ~w. Pregunta por una alternativa a ~w.', [Nombre, Articulacion, Nombre])
    ;   format(atom(Respuesta), 'Respecto a ~w, ~w es una opcion segura: no esta registrado como carga para esa articulacion.', [Articulacion, Nombre])
    ).

% --- Alternativa a un ejercicio ---
respuesta(Mensaje, Respuesta) :-
    menciona_ejercicio(Mensaje, Ejercicio),
    alguna([alternativa, reemplazo, reemplazar, sustituir, cambiar], Mensaje),
    nivel_de(Mensaje, Nivel),
    equipo_de(Mensaje, Equipo),
    lesion_de(Mensaje, Lesion),
    peso_de(Mensaje, Peso),
    findall(Alt, alternativa(Ejercicio, Alt, Nivel, Equipo, Lesion, Peso), Lista),
    nombre(Ejercicio, Nombre),
    (   Lista = []
    ->  format(atom(Respuesta), 'No encontre alternativas a ~w compatibles con tu perfil.', [Nombre])
    ;   nombres(Lista, Texto),
        format(atom(Respuesta), 'Alternativas a ~w compatibles con tu perfil: ~w.', [Nombre, Texto])
    ).

% --- Que musculo trabaja un ejercicio ---
respuesta(Mensaje, Respuesta) :-
    menciona_ejercicio(Mensaje, Ejercicio),
    alguna([musculo, trabaja, entrena], Mensaje),
    musculo_principal(Ejercicio, Musculo),
    nombre(Ejercicio, Nombre),
    format(atom(Respuesta), '~w trabaja principalmente: ~w.', [Nombre, Musculo]).

% --- Rutina semanal (necesita los dias) ---
respuesta(Mensaje, Respuesta) :-
    alguna([rutina, plan, programa], Mensaje),
    numero_con(Mensaje, [dia, vez], Dias),
    (   plan_semanal(Dias, _)
    ->  guardar_lesion(Mensaje),
        nivel_de(Mensaje, Nivel),
        equipo_de(Mensaje, Equipo),
        lesion_de(Mensaje, Lesion),
        peso_de(Mensaje, Peso),
        (   generar_plan(Dias, Nivel, Equipo, Lesion, Peso, Plan)
        ->  texto_plan(Plan, TextoPlan),
            format(atom(Respuesta), 'Rutina de ~w dias (nivel ~w, equipo ~w, molestia ~w, ~w kg):~n~w',
                   [Dias, Nivel, Equipo, Lesion, Peso, TextoPlan])
        ;   Respuesta = 'Con tu perfil no encontre ejercicios suficientes para armar esa rutina.'
        )
    ;   Respuesta = 'Solo puedo armar rutinas de 2, 3, 4 o 5 dias por semana.'
    ).

respuesta(Mensaje, 'Cuantos dias a la semana quieres entrenar? Puedo armar rutinas de 2, 3, 4 o 5 dias.') :-
    alguna([rutina, plan, programa], Mensaje).

% --- Ya no me duele ---
respuesta(Mensaje, Respuesta) :-
    alguna([duele, dolor, molestia, lesion], Mensaje),
    alguna([no, ninguna, recupere], Mensaje),
    retractall(perfil(lesion, _)),
    Respuesta = 'Perfecto, no tendre en cuenta ninguna molestia.'.

% --- Me duele una articulacion ---
respuesta(Mensaje, Respuesta) :-
    alguna([duele, dolor, molestia, lesion, lesionado, lastimado], Mensaje),
    buscar(Mensaje, articulacion, Articulacion),
    guardar(lesion, Articulacion),
    findall(E, carga_articulacion(E, Articulacion), Evitar),
    findall(S, ( ejercicio(S, _, _, _, _), seguro_para(S, Articulacion) ), Seguros),
    nombres(Evitar, TextoEvitar),
    nombres(Seguros, TextoSeguros),
    format(atom(Respuesta), 'Si te duele ~w, evita: ~w.~nEjercicios que no cargan esa articulacion: ~w.~nHe anotado tu molestia para adaptar tus rutinas. Si el dolor es intenso o persiste, consulta a un profesional de la salud.',
           [Articulacion, TextoEvitar, TextoSeguros]).

% --- Series, repeticiones y descanso ---
respuesta(Mensaje, Respuesta) :-
    alguna([serie, repeticion, descanso, dosis], Mensaje),
    nivel_de(Mensaje, Nivel),
    edad_de(Mensaje, Edad),
    (   objetivo_de(Mensaje, Objetivo)
    ->  dosis(Objetivo, Nivel, Edad, Series, Reps, Descanso, Enfoque),
        format(atom(Respuesta), 'Para ~w (nivel ~w, ~w anos): ~w series de ~w repeticiones, descanso de ~w segundos (~w).',
               [Objetivo, Nivel, Edad, Series, Reps, Descanso, Enfoque])
    ;   Respuesta = 'Dime tu objetivo (fuerza, hipertrofia, resistencia o salud general) para recomendarte la dosis.'
    ).

% --- Ejercicios para un musculo ---
respuesta(Mensaje, Respuesta) :-
    alguna([ejercicio, trabajar], Mensaje),
    buscar(Mensaje, musculo, Musculo),
    findall(E, musculo_principal(E, Musculo), Lista),
    Lista \= [],
    nombres(Lista, Texto),
    format(atom(Respuesta), 'Ejercicios para ~w: ~w.', [Musculo, Texto]).

% --- Listar ejercicios (por division, nivel o equipo) ---
respuesta(Mensaje, Respuesta) :-
    alguna([ejercicio], Mensaje),
    findall(D, ( division(D), ( buscar(Mensaje, division, D) ; \+ buscar(Mensaje, division, _) ) ), Divisiones),
    findall(Linea,
            ( member(D, Divisiones),
              findall(E, ejercicio_listado(Mensaje, E, D), Lista),
              Lista \= [],
              nombres(Lista, Texto),
              format(atom(Linea), '  - ~w: ~w', [D, Texto]) ),
            Lineas),
    (   Lineas = []
    ->  Respuesta = 'No encontre ejercicios con esas condiciones.'
    ;   atomic_list_concat(Lineas, '\n', Cuerpo),
        format(atom(Respuesta), 'Ejercicios disponibles:~n~w', [Cuerpo])
    ).

% --- Ficha de un ejercicio ---
respuesta(Mensaje, Respuesta) :-
    menciona_ejercicio(Mensaje, Ejercicio),
    ejercicio(Ejercicio, Division, Rol, Nivel, Equipo),
    musculo_principal(Ejercicio, Musculo),
    findall(A, carga_articulacion(Ejercicio, A), Articulaciones),
    nombre(Ejercicio, Nombre),
    nombres(Articulaciones, TextoArticulaciones),
    format(atom(Respuesta), '~w: division ~w, rol ~w, nivel minimo ~w, equipo ~w. Musculo principal: ~w. Articulaciones que carga: ~w.',
           [Nombre, Division, Rol, Nivel, Equipo, Musculo, TextoArticulaciones]).

% --- Datos del usuario ---
respuesta(Mensaje, Respuesta) :-
    alguna([soy, tengo, mi, peso, entreno, uso, estoy, objetivo], Mensaje),
    (   buscar(Mensaje, nivel, Nivel)       -> guardar(nivel, Nivel)       ; true ),
    (   buscar(Mensaje, objetivo, Objetivo) -> guardar(objetivo, Objetivo) ; true ),
    (   buscar(Mensaje, equipo, Equipo)     -> guardar(equipo, Equipo)     ; true ),
    (   edad_en(Mensaje, Edad)              -> guardar(edad, Edad)         ; true ),
    (   numero_con(Mensaje, [kg, kilo, kilogramo], Peso) -> guardar(peso, Peso) ; true ),
    (   buscar(Mensaje, nivel, _) ; buscar(Mensaje, objetivo, _) ; buscar(Mensaje, equipo, _)
    ;   edad_en(Mensaje, _) ; numero_con(Mensaje, [kg, kilo, kilogramo], _) ), !,
    descripcion_perfil(Texto),
    format(atom(Respuesta), 'Perfecto, lo tendre en cuenta. ~w', [Texto]).

respuesta(Mensaje, Respuesta) :-
    alguna([perfil, sabes], Mensaje),
    descripcion_perfil(Respuesta).

respuesta(Mensaje, 'Listo, olvide tus datos.') :-
    alguna([olvida, reiniciar, borra], Mensaje),
    retractall(perfil(_, _)).

% --- Conversacion basica ---
respuesta(Mensaje, 'Puedo ayudarte con:\n  - Ejercicios: "que ejercicios hay de empuje", "ejercicios con mancuernas para principiante"\n  - Musculos: "que musculo trabaja el press banca", "ejercicios para biceps"\n  - Lesiones: "me duele la rodilla", "puedo hacer sentadilla si me duele la espalda"\n  - Alternativas: "alternativa a las dominadas"\n  - Dosificacion: "cuantas series y repeticiones para hipertrofia"\n  - Rutinas: "rutina de 4 dias"\n  - Tu perfil: "soy principiante", "tengo 55 anos", "peso 100 kg", "solo tengo mancuernas"') :-
    alguna([ayuda, puedes, comandos], Mensaje).

respuesta(Mensaje, 'Hola! Soy tu asistente de entrenamiento. Escribe "ayuda" para ver que puedo hacer.') :-
    alguna([hola, buenas, buenos, saludos], Mensaje).

respuesta(Mensaje, 'De nada! Cualquier otra duda de entrenamiento, aqui estoy.') :-
    alguna([gracias, genial, perfecto], Mensaje).


% ejercicio_listado: ejercicio de la division que cumple el nivel y equipo mencionados (si los hay)
ejercicio_listado(Mensaje, E, Division) :-
    ejercicio(E, Division, _, NivelMin, EquipoReq),
    (   buscar(Mensaje, nivel, Nivel) -> nivel_ok(Nivel, NivelMin) ; true ),
    (   buscar(Mensaje, equipo, Equipo) -> equipo_ok(Equipo, EquipoReq) ; true ).

% ------------------------------------------------------------------------------
% TEXTOS
% ------------------------------------------------------------------------------
guardar_lesion(Mensaje) :-
    (   alguna([duele, dolor, molestia, lesion, lesionado, lastimado], Mensaje),
        buscar(Mensaje, articulacion, Articulacion)
    ->  guardar(lesion, Articulacion)
    ;   true
    ).

texto_plan([], '').
texto_plan([dia(Nombre, Ejercicios) | Resto], Texto) :-
    nombres(Ejercicios, Lista),
    texto_plan(Resto, TextoResto),
    format(atom(Texto), '  - ~w: ~w~n~w', [Nombre, Lista, TextoResto]).

descripcion_perfil(Texto) :-
    findall(Parte, parte_perfil(Parte), Partes),
    (   Partes = []
    ->  Texto = 'Todavia no tengo datos tuyos. Cuentame tu nivel, edad, peso, equipo u objetivo.'
    ;   atomic_list_concat(Partes, ', ', Lista),
        format(atom(Texto), 'Datos guardados: ~w.', [Lista])
    ).

parte_perfil(Parte) :- perfil(nivel, V),    format(atom(Parte), 'nivel ~w', [V]).
parte_perfil(Parte) :- perfil(objetivo, V), format(atom(Parte), 'objetivo ~w', [V]).
parte_perfil(Parte) :- perfil(edad, V),     format(atom(Parte), '~w anos', [V]).
parte_perfil(Parte) :- perfil(peso, V),     format(atom(Parte), '~w kg', [V]).
parte_perfil(Parte) :- perfil(equipo, V),   format(atom(Parte), 'equipo ~w', [V]).
parte_perfil(Parte) :- perfil(lesion, V),   format(atom(Parte), 'molestia en ~w', [V]).

% nombre(press_banca_barra, 'press banca barra'): cambia los _ por espacios
nombre(Atomo, Texto) :-
    atomic_list_concat(Partes, '_', Atomo),
    atomic_list_concat(Partes, ' ', Texto).

% nombres([a_b, c_d], 'a b, c d')
nombres([], ninguna).
nombres([X | Resto], Texto) :-
    nombres_aux([X | Resto], Nombres),
    atomic_list_concat(Nombres, ', ', Texto).

nombres_aux([], []).
nombres_aux([X | Resto], [Nombre | Nombres]) :-
    nombre(X, Nombre),
    nombres_aux(Resto, Nombres).
