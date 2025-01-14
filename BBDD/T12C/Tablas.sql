CREATE DATABASE T12C;

DROP TABLE IF EXISTS Jugadores, Partidas, Equipos, Jugadores_Equipos CASCADE;

CREATE TABLE Jugadores (
    ID_Jugador INTEGER PRIMARY KEY,
    Nombre_usuario VARCHAR(20),
    Región VARCHAR(20),
    Elo_MMR DECIMAL (5,2),
    Promedio_KDA DECIMAL(4,2)
);

-- Creación de la tabla Partidas
CREATE TABLE Partidas (
    ID_Partida INTEGER PRIMARY KEY,
    Fecha DATE,
    Duración TIME,
    Tipo_Partida VARCHAR(15)
);

-- Creación de la tabla Equipos
CREATE TABLE Equipos (
    ID_Equipo INTEGER PRIMARY KEY,
    ID_Partida INTEGER,
    Equipo_Numero INTEGER,
	Resultado VARCHAR(15),
    FOREIGN KEY (ID_Partida) REFERENCES Partidas(ID_Partida)
);

-- Creación de la tabla Jugadores_Equipos
CREATE TABLE Jugadores_Equipos (
    ID_Jugador INTEGER,
    ID_Equipo INTEGER,
    PRIMARY KEY (ID_Jugador, ID_Equipo),
    FOREIGN KEY (ID_Jugador) REFERENCES Jugadores(ID_Jugador),
    FOREIGN KEY (ID_Equipo) REFERENCES Equipos(ID_Equipo)
);

select * FROM Jugadores;

select * FROM Equipos;

select * FROM Partidas;

select * FROM Jugadores_Equipos;
    
/*
Justificación de que las 4 tablas alcanzan la FNBC (Forma Normal de Boyce-Codd):

Requisitos:
1. Todas las partes izquierdas de todas las dependencias son claves candidatas. 
2. Si no hay dependencias también está en FNBC, pues no hay dependencias que incumplan
que la parte izquierda sea clave. 

A continuación las dependencias de cada tabla:

Jugadores: ID_Jugador -> Nombre_usuario, Región, Elo_MMR, Promedio_KDA
Partidas: ID_Partida -> Fecha, Duración, Tipo_Partida
Equipos: ID_Equipo -> ID_Partida, Equipo_Numero, Resultado
         ID_Partida, Equipo_Numero -> ID_Equipo
Jugadores_Equipos: ID_Jugador, ID_Equipo -> ID_Jugador, ID_Equipo

Las tablas Jugadores, Partidas y Equipos cumplen la condición 1.
La tabla Jugadores_Equipos cumple la condición 2.
*/

CREATE VIEW JugadoresPartidas AS
SELECT DISTINCT j.ID_Jugador, p.ID_Partida, j.Nombre_usuario
FROM Jugadores j
JOIN Jugadores_Equipos je USING (ID_Jugador)
JOIN Equipos e USING (ID_Equipo)
JOIN Partidas p USING (ID_Partida)

/*
Redundancias:
Para cada ID_Jugador en distintos partidos (distinto ID_Partida) se repite el Nombre_usuario.
*/

/* Dependencias:
Dependencias de partida -> F= {ID_Jugador -> Nombre_usuario}

Pasos del algoritmo para hallar un recubrimiento minimal equivalente:
1. Pasar F a forma canónica usando la regla de descomposición.
    Ya están en forma canónica.
2. Descomponer las dependencias que no sean elementales.
    No hay dependencias no elementales.
3. Eliminar las dependencias redundantes.
    No hay dependencias redundantes.

Entonces, el recubrimiento minimal equivalente es G = {ID_Jugador -> Nombre_usuario}
*/

/*Procedimiento para hallar la clave:
Si el recubrimiento es el conjunto vacío (es porque todas las dependencias son triviales),
entonces la única clave está formada por todos los atributos de la relación.

    Como el recubrimiento no es el conjunto vacío, pasamos a buscar todos los atributos 
    que nunca están a la derecha de ninguna dependencia del recubrimiento minimal (Atts). 
    Atts: {ID_Jugador}

    Ahora analizamos si el ID_Jugador, por sí solo, determina a todos los demás atributos
    de la relación.
    ID_Jugador no determina la relación (no determina ID_Partida). 
    Combinando ID_Jugador con ID_Partida sí que conseguimos determinar toda la relación,
    entonces, la clave es {ID_Jugador, ID_Partida}.
    */

/*Justificación de que la vista alcanza la 1FN pero no la 2FN:

    DEFINICIONES:
        1FN: "una relación está en primera forma normal (1FN) si dada una fila y un campo de esa tabla le corresponde
        un único valor. Esto significa:
            1. Que no puede haber atributos multivaluados, tipo array, vector, lista etc...
            2. Que no puede haber atributos compuestos, a modo de lo que sería un registro o struct en determinados
            lenguajes de programación"
        2FN: "Definición: Una dependencia funcional A → B sobre una relación R, se denomina dependencia funcional
parcial, si existe un X ⊆ R, tal que X ⊂ A y X → B. En tal caso diremos que B depende parcialmente de A."

    Alcanza la 1FN porque todos los atributos son atómicos.
    No alcanza la 2FN  porque el atributo no clave Nombre_usuario depende de una parte de la clave (ID_Jugador).
*/