/*
Este trabajo implementa un esquema de base de datos diseñado para gestionar el sistema de 
matchmaking de un videojuego. 
En cada partida compiten dos equipos, los equipos son únicos y se forman a continuación de la creación
de la partida. En cada partida solo hay un equipo ganador, no está permitido el empate. 

Cada jugador tiene un ID único que los identifica y un nombre (no es necesariamente único).
Además, éstos tienen dos métricas: 
- Elo_MMR. Representa la habilidad actual del jugador. 
- Promedio_KDA. Refleja su desempeño promedio en términos de asesinatos, muertes y asistencias. 

Las partidas se desempeñan entre jugadores con un Elo_MMR similar. El Elo_MMR con el que jugaron en un determinado
equipo quedan registrados en Historico_Elo_MMR_Jugador.
*/

DROP TABLE IF EXISTS Jugadores, Partidas, Equipos, Jugadores_Equipos CASCADE;

-- Creación de la tabla Jugadores
CREATE TABLE Jugadores (
    ID_Jugador INTEGER PRIMARY KEY,
    Nombre_usuario VARCHAR(20),
    Región VARCHAR(20),
    Elo_MMR DECIMAL (6,2),
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
    Historico_Elo_MMR_Jugador DECIMAL (6,2),
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

Jugadores:         {ID_Jugador -> Nombre_usuario, Región, Elo_MMR, Promedio_KDA}
Partidas:          {ID_Partida -> Fecha, Duración, Tipo_Partida}
Equipos:           {ID_Equipo -> ID_Partida, Equipo_Numero, Resultado}
                   {ID_Partida, Equipo_Numero -> ID_Equipo}
Jugadores_Equipos: {ID_Jugador, ID_Equipo -> ID_Jugador, ID_Equipo}

Las tablas Jugadores, Partidas y Equipos cumplen la condición 1.
La tabla Jugadores_Equipos cumple la condición 2.
*/
DROP VIEW IF EXISTS PrimeraVista CASCADE;

CREATE VIEW PrimeraVista AS
SELECT j.ID_Jugador, p.ID_Partida, j.Nombre_usuario
FROM Jugadores j
JOIN Jugadores_Equipos je USING (ID_Jugador)
JOIN Equipos e USING (ID_Equipo)
JOIN Partidas p USING (ID_Partida)

select * FROM PrimeraVista;
/*
Redundancias:
Para cada ID_Jugador en distintos partidos (distinto ID_Partida) se repite el Nombre_usuario.
*/

/* Dependencias:
Dependencias de partida -> F= {ID_Jugador -> Nombre_usuario}

Conjunto de dependencias minimal y demostración de que es minimal:

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
    Combinando ID_Jugador con ID_Partida sí que conseguimos determinar toda la relación.
    Por lo tanto, la clave es {ID_Jugador, ID_Partida}.
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

/* Algoritmo de síntesis de Bernstein:
    Recubrimiento minimal: G = {ID_Jugador -> Nombre_usuario}
    1. Juntar las dependencias con el mismo determinante.
        En este caso no se aplica.
    2. Crear una relación por cada dependencia resultante. 
        R1 = {ID_Jugador, Nombre_usuario}
    3. Eliminar las relaciones que estén contenidas en otras.
        En este caso no se aplica.
    4.  Finalmente, para garantizar que no haya pérdidas de producto, si ninguna de las relaciones resultantes de la
    descomposición contiene alguna de las claves de partida calculadas en el paso 1, se añade una última
    relación con los atributos de una cualquiera de esa claves.
        R1 no contiene la clave {ID_Jugador, ID_Partida}, entonces añadimos R2 = {ID_Jugador, ID_Partida}.
        Resultado de la descomposición: R1, R2
*/

DROP VIEW IF EXISTS SegundaVista CASCADE;

CREATE VIEW SegundaVista AS
SELECT ID_Equipo, ID_Partida, tipo_Partida, fecha
FROM Equipos JOIN Partidas USING (ID_Partida);

SELECT * FROM SegundaVista;

/*
Redundancias:
Para cada ID_Partida único se duplicarán el tipo_partida y la fecha debido a que una partida es jugada 
por 2 equipos.*/

/* Dependencias:
Dependencias de partida -> F = {ID_Equipo -> ID_Partida, ID_Partida -> tipo_Partida, fecha}


Conjunto de dependencias minimal y demostración de que es minimal:

Pasos del algoritmo para hallar un recubrimiento minimal equivalente:
1. Pasar F a forma canónica usando la regla de descomposición.
    {ID_Equipo -> ID_Partida,
    ID_Partida -> tipo_Partida,
    ID_Partida -> fecha}
2. Descomponer las dependencias que no sean elementales.
    No hay dependencias no elementales.
3. Eliminar las dependencias redundantes.
    ¿Sobra la dependencia ID_Equipo -> ID_Partida?
    G = F - {ID_Equipo -> ID_Partida}
    ID_Equipo⁺₍G₎ = ID_Equipo --> No sobra

    ¿Sobra ID_Partida -> tipo_Partida, fecha?
    G = F - {ID_Partida -> tipo_Partida, fecha}
    ID_Partida⁺₍G₎ = ID_Partida --> No sobra

Entonces, el recubrimiento minimal equivalente es 
F = {ID_Equipo -> ID_Partida, ID_Partida -> tipo_Partida, fecha}
*/

/*Procedimiento para hallar la clave:
Si el recubrimiento es el conjunto vacío (es porque todas las dependencias son triviales),
entonces la única clave está formada por todos los atributos de la relación.

    Como el recubrimiento no es el conjunto vacío, pasamos a buscar todos los atributos 
    que nunca están a la derecha de ninguna dependencia del recubrimiento minimal (Atts). 
    Atts: {ID_Equipo}

    Ahora analizamos si el ID_Equipo, por sí solo, determina a todos los demás atributos
    de la relación.
    ID_Equipo determina la relación completa, porque este determina el ID_Partida y el 
    ID_Partida determina el tipo_Partida y la fecha. 
    
    Por lo tanto ID_Equipo es la clave.
    */

/*Justificación de que la vista alcanza la 2FN pero no la 3FN:

    DEFINICIONES:
        2FN: "Definición: Una dependencia funcional A → B sobre una relación R, se denomina dependencia funcional
parcial, si existe un X ⊆ R, tal que X ⊂ A y X → B. En tal caso diremos que B depende parcialmente de A."

        3FN: "En el caso de que estuviéramos manejando un recubrimiento minimal bastaría ver si R está en 2FN y las
partes izquierdas de las dependencias son claves o están contenidas en alguna clave."

    Alcanza la 2FN porque no hay ningún atributo no clave que dependa parcialmente de la clave.
    No alcanza la 3FN porque conociendo el recubrimiento minimal, observamos que la parte izquierda 
    de la dependencia {ID_Partida -> tipo_Partida, fecha}, ni es clave, ni pertenece a una clave.
*/

/* Algoritmo de síntesis de Bernstein:
    Recubrimiento minimal: F = {ID_Equipo -> ID_Partida, ID_Partida -> tipo_Partida, fecha}
    1. Juntar las dependencias con el mismo determinante.
        En este caso no se aplica.
    2. Crear una relación por cada dependencia resultante. 
        R1 = {ID_Equipo, ID_Partida}
        R2 = {ID_Partida, tipo_Partida, fecha}
    3. Eliminar las relaciones que estén contenidas en otras.
        En este caso no se aplica.
    4.  Finalmente, para garantizar que no haya pérdidas de producto, si ninguna de las relaciones resultantes de la
    descomposición contiene alguna de las claves de partida calculadas en el paso 1, se añade una última
    relación con los atributos de una cualquiera de esa claves.
        En este caso, no se aplica porque R1 contiene la clave ID_Equipo.
        Resultado de la descomposición: R1, R2.
*/

DROP VIEW IF EXISTS TerceraVista CASCADE;
CREATE VIEW TerceraVista AS
SELECT ID_Jugador, ID_Equipo, Historico_Elo_MMR_Jugador, Elo_MMR
FROM Jugadores_Equipos JOIN Jugadores USING (ID_Jugador);

SELECT * FROM TerceraVista;

/*
Redundancias:
Para cada id_equipo de un mismo jugador, el Elo_MMR se repite.
*/

/* Dependencias:
Dependencias de partida -> F = {ID_Jugador -> Elo_MMR,
                                ID_Jugador, ID_Equipo -> Historico_Elo_MMR_Jugador}

Conjunto de dependencias minimal y demostración de que es minimal:

Pasos del algoritmo para hallar un recubrimiento minimal equivalente:
1. Pasar F a forma canónica usando la regla de descomposición.
    {ID_Jugador -> Elo_MMR,
     ID_Jugador, ID_Equipo -> Historico_Elo_MMR_Jugador}
2. Descomponer las dependencias que no sean elementales.
    Tenemos 1 dependencia con más de un atributo en el lado izquierdo:
    {ID_Jugador, ID_Equipo -> Historico_Elo_MMR_Jugador}
    Sea G = F - {ID_Jugador, ID_Equipo -> Historico_Elo_MMR_Jugador} U {ID_Jugador -> Historico_Elo_MMR_Jugador}
        Comprobamos si F ⊆ G⁺:
            ¿podemos deducir que ID_Jugador, ID_Equipo -> Historico_Elo_MMR_Jugador en G?
            ID_Jugador,ID_Equipo⁺₍G₎ = ID_Jugador, ID_Equipo, Elo_MMR, Historico_Elo_MMR_Jugador (esto siempre se cumple).
        Comprobamos si G ⊆ F⁺:
            ¿podemos deducir que ID_Jugador -> Historico_Elo_MMR_Jugador en F? 
            ID_Jugador⁺₍F₎ = ID_Jugador, Elo_MMR --> Por lo tanto, como falta el ID_Equipo para poder deducir Historico_Elo_MMR_Jugador,
            no podemos simplificarlo.
    Sea H = F - {ID_Jugador, ID_Equipo -> Historico_Elo_MMR_Jugador} U {ID_Equipo -> Historico_Elo_MMR_Jugador}
            Comprobamos si F ⊆ H⁺:
            ¿podemos deducir que ID_Jugador, ID_Equipo -> Historico_Elo_MMR_Jugador en G?
            ID_Jugador,ID_Equipo⁺₍H₎ = ID_Jugador, ID_Equipo, Elo_MMR, Historico_Elo_MMR_Jugador (esto siempre se cumple).
        Comprobamos si H ⊆ F⁺:
            ¿podemos deducir que ID_Equipo -> Historico_Elo_MMR_Jugador en F? 
            ID_Equipo⁺₍F₎ = ID_Equipo --> Por lo tanto, no podemos simplificarlo.
3. Eliminar las dependencias redundantes.
    ¿Sobra la dependencia ID_Jugador -> Elo_MMR?
    G = F - {ID_Jugador -> Elo_MMR}
    ID_Jugador⁺₍G₎ = ID_Jugador --> Por lo tanto, no sobra.

    ¿Sobra ID_Jugador, ID_Equipo -> Historico_Elo_MMR_Jugador?
    H = F - {ID_Jugador, ID_Equipo -> Historico_Elo_MMR_Jugador}
    ID_Jugador, ID_Equipo⁺₍H₎ = Elo_MMR, ID_Jugador, ID_Equipo --> Por lo tanto, faltaría Historico_Elo_MMR_Jugador y no sobra.


Entonces, el recubrimiento minimal equivalente es F = {ID_Jugador -> Elo_MMR,
                                                       ID_Jugador, ID_Equipo -> Historico_Elo_MMR_Jugador}
*/

/*Procedimiento para hallar la clave:
Si el recubrimiento es el conjunto vacío (es porque todas las dependencias son triviales),
entonces la única clave está formada por todos los atributos de la relación.

    Como el recubrimiento no es el conjunto vacío, pasamos a buscar todos los atributos 
    que nunca están a la derecha de ninguna dependencia del recubrimiento minimal (Atts). 
    Atts: {ID_Jugador, ID_Equipo}

    Ahora analizamos si el ID_Jugador, por sí solo, determina a todos los demás atributos
    de la relación.
    ID_Jugador no determina la relación (no determina ni Historico_Elo_MMR_Jugador ni ID_Equipo).
    La combinación {ID_Jugador, ID_Equipo} sí que determina toda la relación.
    Por lo tanto, la clave es {ID_Jugador, ID_Equipo}.
    */

/*Justificación de que la vista alcanza la 3FN pero no la FNBC:

    DEFINICIONES:
        3FN: "En el caso de que estuviéramos manejando un recubrimiento minimal bastaría ver si R está en 2FN y las
partes izquierdas de las dependencias son claves o están contenidas en alguna clave."
    
        FNBC: "si el conjunto de dependencias fuese un minimal, bastaría ver si todo determinante (parte
izquierda de una dependencia) es clave candidata, ya que en un minimal no hay dependencias triviales, y
si un determinante es clave, como en un minimal los determinantes están simplificados al máximo, sería
clave."


    Alcanza la 2FN porque no hay ningún atributo no clave que dependa parcialmente de la clave.
    No alcanza la 3FN porque conociendo el recubrimiento minimal, observamos que la parte izquierda 
    de la dependencia {ID_Jugador -> Elo_MMR}, no es clave candidata.
*/

/* Algoritmo de síntesis de Bernstein:
    Recubrimiento minimal: F = {ID_Jugador -> Elo_MMR,
                                ID_Jugador, ID_Equipo -> Historico_Elo_MMR_Jugador}
    1. Juntar las dependencias con el mismo determinante.
        En este caso no se aplica.
    2. Crear una relación por cada dependencia resultante. 
        R1 = {ID_Jugador, Elo_MMR}
        R2 = {ID_Jugador, ID_Equipo, Historico_Elo_MMR_Jugador}
    3. Eliminar las relaciones que estén contenidas en otras.
        En este caso no se aplica.
    4.  Finalmente, para garantizar que no haya pérdidas de producto, si ninguna de las relaciones resultantes de la
    descomposición contiene alguna de las claves de partida calculadas en el paso 1, se añade una última
    relación con los atributos de una cualquiera de esa claves.
        En este caso, no se aplica porque R2 contiene la clave {ID_Jugador, ID_Equipo}.
        Resultado de la descomposición: R1, R2.
*/
