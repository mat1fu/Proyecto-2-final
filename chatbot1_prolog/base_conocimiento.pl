% ==============================================================================
% BASE DE CONOCIMIENTO: ENTRENAMIENTO DE FUERZA Y ARMADO DE RUTINAS
% ==============================================================================
% Dominio: ejercicios con pesas, musculos, articulaciones, lesiones, dosificacion
% y rutinas semanales.
%
% FASE 1: LENGUAJE LOGICO
%   Constantes: los ejercicios (press_banca_barra, ...), las divisiones
%   (empuje, traccion, pierna, core), los niveles (principiante, intermedio,
%   avanzado), los equipos, las articulaciones y los objetivos.
%
%   Predicado            Aridad  Representa
%   -------------------  ------  --------------------------------------------
%   division/1           1       Propiedad de ser una division de ejercicios
%   articulacion/1       1       Propiedad de ser una articulacion
%   nivel/1              1       Propiedad de ser un nivel de entrenamiento
%   ejercicio/5          5       Ejercicio(Id, Division, Rol, NivelMin, Equipo)
%   musculo_principal/2  2       Relacion entre ejercicio y musculo
%   carga_articulacion/2 2       Relacion entre ejercicio y articulacion que exige
%   restriccion_peso/3   3       Ejercicio, peso maximo y nivel que lo exime
%   dosificacion/5       5       Objetivo, series, repeticiones, descanso, enfoque
%   nivel_ok/2           2       Un nivel alcanza el nivel minimo exigido
%
% FASE 2: HECHOS (conocimiento dado)    FASE 3: REGLAS (conocimiento inferido)
%
% En logica de primer orden, una regla  A :- B, C.  significa  B(x) ^ C(x) -> A(x)
% y  \+ G  es la negacion como falla: "G es falso si no se puede probar".
% ==============================================================================


% ------------------------------------------------------------------------------
% FASE 2: HECHOS
% ------------------------------------------------------------------------------

% Vocabulario
division(empuje).
division(traccion).
division(pierna).
division(core).

articulacion(hombro).
articulacion(codo).
articulacion(muneca).
articulacion(lumbar).
articulacion(rodilla).

nivel(principiante).
nivel(intermedio).
nivel(avanzado).

% Catalogo: ejercicio(Id, Division, Rol, NivelMin, Equipo)
% Roles: principal | secundario | accesorio
% Equipos: barra | barra_fija | mancuernas | maquina | polea | peso_corporal
% IMPORTANTE: dentro de cada division van primero los ejercicios principales,
% porque al armar una rutina se elige el primero de la lista.

% empuje
ejercicio(press_banca_barra,         empuje,   principal,  intermedio,   barra).
ejercicio(press_militar_barra,       empuje,   principal,  intermedio,   barra).
ejercicio(press_mancuerna_inclinado, empuje,   secundario, principiante, mancuernas).
ejercicio(fondos_paralelas,          empuje,   secundario, intermedio,   peso_corporal).
ejercicio(flexiones_suelo,           empuje,   secundario, principiante, peso_corporal).
ejercicio(press_militar_mancuernas,  empuje,   secundario, principiante, mancuernas).
ejercicio(elevaciones_laterales,     empuje,   accesorio,  principiante, mancuernas).
ejercicio(press_frances,             empuje,   accesorio,  intermedio,   barra).

% traccion
ejercicio(dominadas_pronadas,        traccion, principal,  avanzado,     barra_fija).
ejercicio(jalon_polea,               traccion, principal,  principiante, maquina).
ejercicio(remo_barra,                traccion, principal,  intermedio,   barra).
ejercicio(remo_mancuerna_apoyo,      traccion, secundario, principiante, mancuernas).
ejercicio(face_pull,                 traccion, accesorio,  principiante, polea).
ejercicio(curl_biceps_barra,         traccion, accesorio,  principiante, barra).
ejercicio(curl_biceps_mancuerna,     traccion, accesorio,  principiante, mancuernas).

% pierna
ejercicio(sentadilla_trasera,        pierna,   principal,  intermedio,   barra).
ejercicio(prensa_inclinada,          pierna,   principal,  principiante, maquina).
ejercicio(peso_muerto_rumano,        pierna,   principal,  intermedio,   barra).
ejercicio(sentadilla_goblet,         pierna,   secundario, principiante, mancuernas).
ejercicio(curl_femoral,              pierna,   accesorio,  principiante, maquina).
ejercicio(elevacion_talones,         pierna,   accesorio,  principiante, peso_corporal).

% core
ejercicio(plancha_abdominal,         core,     accesorio,  principiante, peso_corporal).
ejercicio(elevacion_piernas,         core,     accesorio,  principiante, peso_corporal).


% Musculo que trabaja cada ejercicio: musculo_principal(Ejercicio, Musculo)
musculo_principal(press_banca_barra,         pectoral).
musculo_principal(press_mancuerna_inclinado, pectoral).
musculo_principal(fondos_paralelas,          triceps).
musculo_principal(flexiones_suelo,           pectoral).
musculo_principal(press_militar_barra,       deltoides).
musculo_principal(press_militar_mancuernas,  deltoides).
musculo_principal(elevaciones_laterales,     deltoides).
musculo_principal(press_frances,             triceps).
musculo_principal(dominadas_pronadas,        dorsal).
musculo_principal(jalon_polea,               dorsal).
musculo_principal(remo_barra,                dorsal).
musculo_principal(remo_mancuerna_apoyo,      dorsal).
musculo_principal(face_pull,                 deltoides_posterior).
musculo_principal(curl_biceps_barra,         biceps).
musculo_principal(curl_biceps_mancuerna,     biceps).
musculo_principal(sentadilla_trasera,        cuadriceps).
musculo_principal(prensa_inclinada,          cuadriceps).
musculo_principal(sentadilla_goblet,         cuadriceps).
musculo_principal(peso_muerto_rumano,        isquiotibiales).
musculo_principal(curl_femoral,              isquiotibiales).
musculo_principal(elevacion_talones,         gemelos).
musculo_principal(plancha_abdominal,         abdomen).
musculo_principal(elevacion_piernas,         abdomen).


% Articulacion que exige cada ejercicio: carga_articulacion(Ejercicio, Articulacion)
carga_articulacion(press_banca_barra,         hombro).
carga_articulacion(press_banca_barra,         codo).
carga_articulacion(press_mancuerna_inclinado, hombro).
carga_articulacion(flexiones_suelo,           muneca).
carga_articulacion(flexiones_suelo,           hombro).
carga_articulacion(press_militar_barra,       hombro).
carga_articulacion(press_militar_barra,       lumbar).
carga_articulacion(fondos_paralelas,          hombro).
carga_articulacion(fondos_paralelas,          codo).
carga_articulacion(dominadas_pronadas,        hombro).
carga_articulacion(dominadas_pronadas,        codo).
carga_articulacion(remo_barra,                lumbar).
carga_articulacion(sentadilla_trasera,        rodilla).
carga_articulacion(sentadilla_trasera,        lumbar).
carga_articulacion(peso_muerto_rumano,        lumbar).
carga_articulacion(prensa_inclinada,          rodilla).
carga_articulacion(press_militar_mancuernas,  hombro).
carga_articulacion(elevaciones_laterales,     hombro).
carga_articulacion(face_pull,                 hombro).
carga_articulacion(press_frances,             codo).
carga_articulacion(curl_biceps_barra,         codo).
carga_articulacion(curl_biceps_mancuerna,     codo).
carga_articulacion(sentadilla_goblet,         rodilla).


% Con mas de PesoMax kg solo puede hacerlo quien tiene el nivel indicado
% restriccion_peso(Ejercicio, PesoMax, NivelQueLoExime)
restriccion_peso(dominadas_pronadas, 95, avanzado).
restriccion_peso(fondos_paralelas,   95, avanzado).


% Dosificacion: dosificacion(Objetivo, Series, Repeticiones, DescansoSeg, Enfoque)
dosificacion(fuerza,        '4 a 5', '3 a 5',   '180-240', 'Alta intensidad').
dosificacion(hipertrofia,   '3 a 4', '8 a 12',  '90',      'Tension mecanica').
dosificacion(resistencia,   '3 a 4', '15 a 20', '45',      'Volumen metabolico').
dosificacion(salud_general, '3',     '10 a 12', '60',      'Acondicionamiento general').
dosificacion(adulto_mayor,  '3',     '10 a 12', '120',     'Enfoque articular seguro').
dosificacion(principiante,  '3',     '10 a 12', '90',      'Enfoque adaptacion').

edad_adulto_mayor(50).

% Que nivel alcanza a cada nivel minimo: nivel_ok(NivelPersona, NivelMinimo)
nivel_ok(principiante, principiante).
nivel_ok(intermedio,   principiante).
nivel_ok(intermedio,   intermedio).
nivel_ok(avanzado,     principiante).
nivel_ok(avanzado,     intermedio).
nivel_ok(avanzado,     avanzado).

% Plan semanal: plan_semanal(Dias, [dia(Nombre, TipoDeSesion, Variante)])
% La variante cambia los ejercicios elegidos para que los dias no se repitan.
plan_semanal(2, [dia('Martes (Torso)',   torso,  0),
                 dia('Viernes (Pierna)', pierna, 0)]).
plan_semanal(3, [dia('Lunes (Full Body A)',     fullbody, 0),
                 dia('Miercoles (Full Body B)', fullbody, 1),
                 dia('Viernes (Full Body C)',   fullbody, 2)]).
plan_semanal(4, [dia('Lunes (Torso 1)',    torso,  0),
                 dia('Martes (Pierna 1)',  pierna, 0),
                 dia('Jueves (Torso 2)',   torso,  1),
                 dia('Viernes (Pierna 2)', pierna, 1)]).
plan_semanal(5, [dia('Lunes (Torso)',         torso,    0),
                 dia('Martes (Pierna)',       pierna,   0),
                 dia('Miercoles (Full Body)', fullbody, 0),
                 dia('Viernes (Torso)',       torso,    1),
                 dia('Sabado (Pierna)',       pierna,   1)]).


% ------------------------------------------------------------------------------
% FASE 3: REGLAS
% ------------------------------------------------------------------------------

% El equipo disponible sirve para el equipo requerido.
equipo_ok(_, peso_corporal) :- !.     % el peso corporal no necesita equipo
equipo_ok(gimnasio, _) :- !.          % en un gimnasio hay de todo
equipo_ok(Equipo, Equipo).

% El ejercicio no carga la articulacion lesionada (con lesion = ninguna siempre es seguro).
seguro_para(Ejercicio, Lesion) :-
    \+ carga_articulacion(Ejercicio, Lesion).

% Un ejercicio con restriccion de peso no es apto si la persona pesa mas y no tiene el nivel.
peso_ok(Ejercicio, Peso, Nivel) :-
    \+ ( restriccion_peso(Ejercicio, PesoMax, NivelExento),
         Peso > PesoMax,
         Nivel \= NivelExento ).

% Un ejercicio esta disponible para una persona si cumple todo lo anterior.
ejercicio_disponible(E, Division, Nivel, Equipo, Lesion, Peso) :-
    ejercicio(E, Division, _, NivelMin, EquipoReq),
    nivel_ok(Nivel, NivelMin),
    equipo_ok(Equipo, EquipoReq),
    seguro_para(E, Lesion),
    peso_ok(E, Peso, Nivel).

% Alternativa: otro ejercicio de la misma division que tambien sea apto.
alternativa(E1, E2, Nivel, Equipo, Lesion, Peso) :-
    ejercicio(E1, Division, _, _, _),
    ejercicio_disponible(E2, Division, Nivel, Equipo, Lesion, Peso),
    E1 \= E2.

% Dosificacion segun edad, nivel y objetivo (se aplica la primera que corresponda).
categoria_dosis(_, _, Edad, adulto_mayor) :-
    edad_adulto_mayor(EdadMin),
    Edad >= EdadMin, !.
categoria_dosis(_, principiante, _, principiante) :- !.
categoria_dosis(Objetivo, _, _, Objetivo).

dosis(Objetivo, Nivel, Edad, Series, Reps, Descanso, Enfoque) :-
    categoria_dosis(Objetivo, Nivel, Edad, Categoria),
    dosificacion(Categoria, Series, Reps, Descanso, Enfoque).


% ------------------------------------------------------------------------------
% ARMADO DE RUTINAS
% ------------------------------------------------------------------------------

% elegir(Division, Variante, ..., Ejercicio): toma un ejercicio disponible de la division.
% La variante indica cual de la lista (0 = el primero, 1 = el segundo, ...).
elegir(Division, Variante, Nivel, Equipo, Lesion, Peso, Elegido) :-
    findall(E, ejercicio_disponible(E, Division, Nivel, Equipo, Lesion, Peso), Lista),
    Lista \= [],
    length(Lista, Largo),
    Indice is Variante mod Largo,
    nth0(Indice, Lista, Elegido).

% Igual que elegir, pero entrega [Ejercicio] o [] si no hay ninguno disponible.
elegir_lista(Division, Variante, Nivel, Equipo, Lesion, Peso, [E]) :-
    elegir(Division, Variante, Nivel, Equipo, Lesion, Peso, E), !.
elegir_lista(_, _, _, _, _, _, []).

% armar_sesion(Tipo, Variante, Nivel, Equipo, Lesion, Peso, ListaDeEjercicios)
armar_sesion(torso, V, N, Eq, L, P, Sesion) :-
    elegir_lista(empuje,   V, N, Eq, L, P, Empuje),
    elegir_lista(traccion, V, N, Eq, L, P, Traccion),
    elegir_lista(core,     V, N, Eq, L, P, Core),
    append(Empuje, Traccion, Parcial),
    append(Parcial, Core, Sesion),
    Sesion \= [].

armar_sesion(pierna, V, N, Eq, L, P, Sesion) :-
    V2 is V + 1,
    elegir_lista(pierna, V,  N, Eq, L, P, Pierna1),
    elegir_lista(pierna, V2, N, Eq, L, P, Pierna2),
    elegir_lista(core,   V,  N, Eq, L, P, Core),
    (   Pierna1 \= Pierna2
    ->  append(Pierna1, Pierna2, Pierna)
    ;   Pierna = Pierna1
    ),
    append(Pierna, Core, Sesion),
    Sesion \= [].

armar_sesion(fullbody, V, N, Eq, L, P, Sesion) :-
    elegir_lista(pierna,   V, N, Eq, L, P, Pierna),
    elegir_lista(empuje,   V, N, Eq, L, P, Empuje),
    elegir_lista(traccion, V, N, Eq, L, P, Traccion),
    append(Pierna, Empuje, Parcial),
    append(Parcial, Traccion, Sesion),
    Sesion \= [].

% generar_plan(Dias, Nivel, Equipo, Lesion, Peso, Plan): Plan = [dia(Nombre, Ejercicios), ...]
generar_plan(Dias, Nivel, Equipo, Lesion, Peso, Plan) :-
    plan_semanal(Dias, Definicion),
    armar_dias(Definicion, Nivel, Equipo, Lesion, Peso, Plan).

armar_dias([], _, _, _, _, []).
armar_dias([dia(Nombre, Tipo, Variante) | Resto], Nivel, Equipo, Lesion, Peso,
           [dia(Nombre, Sesion) | PlanResto]) :-
    armar_sesion(Tipo, Variante, Nivel, Equipo, Lesion, Peso, Sesion),
    armar_dias(Resto, Nivel, Equipo, Lesion, Peso, PlanResto).


% ------------------------------------------------------------------------------
% VERIFICACION DE LA BASE (util antes de una demostracion):  ?- verificar_base.
% ------------------------------------------------------------------------------
verificar_base :-
    forall(( ejercicio(E, _, _, _, _), \+ musculo_principal(E, _) ),
           format('Falta musculo_principal para ~w~n', [E])),
    forall(( ejercicio(E, D, _, _, _), \+ division(D) ),
           format('Division invalida en ~w: ~w~n', [E, D])),
    forall(( ejercicio(E, _, _, N, _), \+ nivel(N) ),
           format('Nivel invalido en ~w: ~w~n', [E, N])),
    forall(( carga_articulacion(E, A), \+ articulacion(A) ),
           format('Articulacion desconocida en ~w: ~w~n', [E, A])),
    writeln('Verificacion terminada.').
