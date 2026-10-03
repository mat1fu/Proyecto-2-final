
% 1. CATALOGO DE EJERCICIOS Y BIOMECANICA
% Formato: ejercicio(ID, Division, Rol, NivelMin, Equipamiento)
% Divisiones: empuje | traccion | pierna | core
% Roles: principal | secundario | accesorio

ejercicio(press_banca_barra,        empuje,   principal,  intermedio,  barra).
ejercicio(press_mancuerna_inclinado,empuje,   secundario, principiante,mancuernas).
ejercicio(fondos_paralelas,         empuje,   secundario, intermedio,  peso_corporal).
ejercicio(flexiones_suelo,          empuje,   secundario, principiante,peso_corporal).
ejercicio(press_militar_barra,      empuje,   principal,  intermedio,  barra).
ejercicio(press_militar_mancuernas, empuje,   secundario, principiante,mancuernas).
ejercicio(elevaciones_laterales,    empuje,   accesorio,  principiante,mancuernas).
ejercicio(press_frances,            empuje,   accesorio,  intermedio,  barra).

ejercicio(dominadas_pronadas,       traccion, principal,  avanzado,    barra_fija).
ejercicio(jalon_polea,              traccion, principal,  principiante,maquina).
ejercicio(remo_barra,               traccion, principal,  intermedio,  barra).
ejercicio(remo_mancuerna_apoyo,     traccion, secundario, principiante,mancuernas).
ejercicio(face_pull,                traccion, accesorio,  principiante,polea).
ejercicio(curl_biceps_barra,        traccion, accesorio,  principiante,barra).
ejercicio(curl_biceps_mancuerna,    traccion, accesorio,  principiante,mancuernas).

ejercicio(sentadilla_trasera,       pierna,   principal,  intermedio,  barra).
ejercicio(prensa_inclinada,         pierna,   principal,  principiante,maquina).
ejercicio(sentadilla_goblet,        pierna,   secundario, principiante,mancuernas).
ejercicio(peso_muerto_rumano,       pierna,   principal,  intermedio,  barra).
ejercicio(curl_femoral,             pierna,   accesorio,  principiante,maquina).
ejercicio(elevacion_talones,        pierna,   accesorio,  principiante,peso_corporal).

ejercicio(plancha_abdominal,        core,     accesorio,  principiante,peso_corporal).
ejercicio(elevacion_piernas,        core,     accesorio,  principiante,peso_corporal).


carga_articulacion(press_banca_barra,        hombro).
carga_articulacion(press_banca_barra,        codo).
carga_articulacion(press_mancuerna_inclinado,hombro).
carga_articulacion(flexiones_suelo,          muneca).
carga_articulacion(flexiones_suelo,          hombro).
carga_articulacion(press_militar_barra,      hombro).
carga_articulacion(press_militar_barra,      lumbar).
carga_articulacion(fondos_paralelas,         hombro).
carga_articulacion(fondos_paralelas,         codo).
carga_articulacion(dominadas_pronadas,       hombro).
carga_articulacion(dominadas_pronadas,       codo).
carga_articulacion(remo_barra,               lumbar).
carga_articulacion(sentadilla_trasera,       rodilla).
carga_articulacion(sentadilla_trasera,       lumbar).
carga_articulacion(peso_muerto_rumano,       lumbar).
carga_articulacion(prensa_inclinada,         rodilla).


calcular_dosificacion(_, _, Edad, '3 series de 10 a 12 reps | Descanso: 120s (Enfoque articular seguro)') :-
    Edad >= 50, !.

calcular_dosificacion(_, principiante, _, '3 series de 10 a 12 reps | Descanso: 90s (Enfoque adaptacion)') :- !.

calcular_dosificacion(fuerza, _, _, '4 a 5 series de 3 a 5 reps | Descanso: 180-240s (Alta intensidad)') :- !.
calcular_dosificacion(hipertrofia, _, _, '3 a 4 series de 8 a 12 reps | Descanso: 90s (Tension mecanica)') :- !.
calcular_dosificacion(resistencia, _, _, '3 a 4 series de 15 a 20 reps | Descanso: 45s (Volumen metabolico)') :- !.
calcular_dosificacion(salud_general, _, _, '3 series de 10 a 12 reps | Descanso: 60s (Acondicionamiento general)') :- !.
calcular_dosificacion(_, _, _, '3 series de 10 a 12 reps | Descanso: 60s').


nivel_ok(principiante, principiante).
nivel_ok(intermedio,   principiante).
nivel_ok(intermedio,   intermedio).
nivel_ok(avanzado,     _).

equipo_ok(cualquiera, _).
equipo_ok(Equipo, Equipo).
equipo_ok(gimnasio, _).
equipo_ok(_, peso_corporal).

seguro_para(_, ninguna).
seguro_para(E, Lesion) :-
    Lesion \= ninguna,
    \+ carga_articulacion(E, Lesion).

ejercicio_apto_peso(dominadas_pronadas, Peso, Nivel) :-
    Peso > 95, Nivel \= avanzado, !, fail.
ejercicio_apto_peso(fondos_paralelas, Peso, Nivel) :-
    Peso > 95, Nivel \= avanzado, !, fail.
ejercicio_apto_peso(_, _, _).

ejercicio_disponible(E, Division, Nivel, Equipo, Lesion, Peso) :-
    ejercicio(E, Division, _, NivelMin, EqReq),
    nivel_ok(Nivel, NivelMin),
    equipo_ok(Equipo, EqReq),
    seguro_para(E, Lesion),
    ejercicio_apto_peso(E, Peso, Nivel).



armar_sesion_torso(Nivel, Equipo, Lesion, Peso, ListaFinal) :-
    findall(E, ejercicio_disponible(E, empuje, Nivel, Equipo, Lesion, Peso), L_Empuje),
    findall(T, ejercicio_disponible(T, traccion, Nivel, Equipo, Lesion, Peso), L_Traccion),
    findall(C, ejercicio_disponible(C, core, Nivel, Equipo, Lesion, Peso), L_Core),
    seleccionar_uno(L_Empuje, E1),
    seleccionar_uno(L_Traccion, E2),
    (seleccionar_uno(L_Core, E3) -> ListaFinal = [E1, E2, E3] ; ListaFinal = [E1, E2]).


armar_sesion_pierna(Nivel, Equipo, Lesion, Peso, ListaFinal) :-
    findall(P, ejercicio_disponible(P, pierna, Nivel, Equipo, Lesion, Peso), L_Pierna),
    findall(C, ejercicio_disponible(C, core, Nivel, Equipo, Lesion, Peso), L_Core),
    seleccionar_dos(L_Pierna, P1, P2),
    (seleccionar_uno(L_Core, C1) -> ListaFinal = [P1, P2, C1] ; ListaFinal = [P1, P2]).


armar_sesion_fullbody(Nivel, Equipo, Lesion, Peso, ListaFinal) :-
    findall(P, ejercicio_disponible(P, pierna, Nivel, Equipo, Lesion, Peso), L_Pierna),
    findall(E, ejercicio_disponible(E, empuje, Nivel, Equipo, Lesion, Peso), L_Empuje),
    findall(T, ejercicio_disponible(T, traccion, Nivel, Equipo, Lesion, Peso), L_Traccion),
    seleccionar_uno(L_Pierna, P1),
    seleccionar_uno(L_Empuje, E1),
    seleccionar_uno(L_Traccion, T1),
    ListaFinal = [P1, E1, T1].


seleccionar_uno([X | _], X) :- !.
seleccionar_uno([], sin_ejercicio_disponible).

seleccionar_dos([X, Y | _], X, Y) :- !.
seleccionar_dos([X], X, sin_variante) :- !.
seleccionar_dos([], sin_ejercicio_disponible, sin_ejercicio_disponible).



generar_plan_semanal(2, Nivel, Equipo, Lesion, Peso, [
    dia('Martes (Torso)', S1),
    dia('Viernes (Pierna)', S2)
]) :-
    armar_sesion_torso(Nivel, Equipo, Lesion, Peso, S1),
    armar_sesion_pierna(Nivel, Equipo, Lesion, Peso, S2).

generar_plan_semanal(3, Nivel, Equipo, Lesion, Peso, [
    dia('Lunes (Full Body A)', S1),
    dia('Miercoles (Full Body B)', S2),
    dia('Viernes (Full Body C)', S3)
]) :-
    armar_sesion_fullbody(Nivel, Equipo, Lesion, Peso, S1),
    armar_sesion_fullbody(Nivel, Equipo, Lesion, Peso, S2),
    armar_sesion_fullbody(Nivel, Equipo, Lesion, Peso, S3).

generar_plan_semanal(4, Nivel, Equipo, Lesion, Peso, [
    dia('Lunes (Torso 1)', S1),
    dia('Martes (Pierna 1)', S2),
    dia('Jueves (Torso 2)', S3),
    dia('Viernes (Pierna 2)', S4)
]) :-
    armar_sesion_torso(Nivel, Equipo, Lesion, Peso, S1),
    armar_sesion_pierna(Nivel, Equipo, Lesion, Peso, S2),
    armar_sesion_torso(Nivel, Equipo, Lesion, Peso, S3),
    armar_sesion_pierna(Nivel, Equipo, Lesion, Peso, S4).

generar_plan_semanal(5, Nivel, Equipo, Lesion, Peso, [
    dia('Lunes (Torso)', S1),
    dia('Martes (Pierna)', S2),
    dia('Miercoles (Full Body)', S3),
    dia('Viernes (Torso)', S4),
    dia('Sabado (Pierna)', S5)
]) :-
    armar_sesion_torso(Nivel, Equipo, Lesion, Peso, S1),
    armar_sesion_pierna(Nivel, Equipo, Lesion, Peso, S2),
    armar_sesion_fullbody(Nivel, Equipo, Lesion, Peso, S3),
    armar_sesion_torso(Nivel, Equipo, Lesion, Peso, S4),
    armar_sesion_pierna(Nivel, Equipo, Lesion, Peso, S5).