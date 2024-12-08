-- Eliminación de tablas si existen previamente
DROP TABLE IF EXISTS Jugadores_Equipos, Equipos, Partidas, Jugadores, Jugadores_Rivales cascade; 

-- Creación de la tabla Jugadores
CREATE TABLE Jugadores (
    ID_Jugador INTEGER PRIMARY KEY,
	Nombre_usuario VARCHAR(20),
    Region VARCHAR(20),
	Elo_MMR DECIMAL (6,2),
    Porcentaje_Victorias DECIMAL(5,2),
    Promedio_KDA DECIMAL(4,2)
);

-- Creación de la tabla Partidas
CREATE TABLE Partidas (
    ID_Partida INT PRIMARY KEY,
    Fecha TIMESTAMP,
	Duracion TIME,
    Tipo_Partida VARCHAR(15),
    Resultado_Equipo1 VARCHAR(10),
    Resultado_Equipo2 VARCHAR(10)
);

-- Creación de la tabla Equipos
CREATE TABLE Equipos (
    ID_Equipo INT PRIMARY KEY,
    ID_Partida INT,
    Equipo_Numero INT,
    Resultado VARCHAR(10),
    FOREIGN KEY (ID_Partida) REFERENCES Partidas(ID_Partida)
);

-- Creación de la tabla Jugadores_Equipos
CREATE TABLE Jugadores_Equipos (
    ID_Jugador INT,
    ID_Equipo INT,
    Elo_MMR_Partida DECIMAL(6,2),
    PRIMARY KEY (ID_Jugador, ID_Equipo),
    FOREIGN KEY (ID_Jugador) REFERENCES Jugadores(ID_Jugador),
    FOREIGN KEY (ID_Equipo) REFERENCES Equipos(ID_Equipo)
);

-- Creación de la tabla Jugadores_Rivales necesaria para la relación reflexiva
-- Esta tabla relaciona un jugador con su(s) rival(es)
-- Un mismo jugador (ID_Jugador) puede tener varios rivales (ID_Jugador_Rival).
CREATE TABLE Jugadores_Rivales (
    ID_Jugador INT,                  -- ID del jugador principal
    ID_Jugador_Rival INT,            -- ID del rival del jugador principal
    PRIMARY KEY (ID_Jugador, ID_Jugador_Rival),  -- Llave primaria compuesta
    FOREIGN KEY (ID_Jugador) REFERENCES Jugadores(ID_Jugador), -- Relación con la tabla Jugadores
    FOREIGN KEY (ID_Jugador_Rival) REFERENCES Jugadores(ID_Jugador) -- Relación con la tabla Jugadores (reflexiva)
);

COMMIT;

/*
Consulta 1. Una consulta que utilice la nueva relación reflexiva en el cálculo de una función de 
agregación. Naturalmente, la consulta tendrá agrupamiento.
*/

/*
Consulta 1.a.
Esta consulta utiliza la relación reflexiva "Jugadores_Rivales" para, por cada jugador, calcular el promedio 
del Elo_MMR de sus rivales. 

Explicación de la consulta:
- Partimos de la tabla Jugadores (j), que representa al jugador principal.
- Unimos con un join con la tabla Jugadores_Rivales (jr) para encontrar cuáles son los rivales de dicho jugador.
- Luego, unimos de nuevo con la tabla Jugadores (rival) para obtener el Elo_MMR de cada uno de esos rivales.
- Aplicamos la función de agregación AVG sobre el Elo_MMR de los rivales y agrupamos por el jugador principal 
  (j.ID_Jugador, j.Nombre_usuario).
- De esta manera, el resultado mostrará una fila por cada jugador, con el promedio del Elo_MMR de todos sus rivales.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(1, 'ShadowBlade', 'NA', 2500.50, 65.20, 3.45),
(7, 'NightShade', 'NA', 2550.00, 66.00, 3.60),
(19, 'GoldenKnight', 'NA', 2510.20, 65.50, 3.50);
INSERT INTO Jugadores_Rivales (ID_Jugador, ID_Jugador_Rival) VALUES
(1, 7),   -- ShadowBlade tiene como rival a NightShade
(1, 19),  -- ShadowBlade también rivaliza con GoldenKnight
(7, 1),   -- NightShade tiene como rival a ShadowBlade
(7, 19),  -- NightShade rivaliza con GoldenKnight
(19, 1);  -- GoldenKnight rivaliza con ShadowBlade

SELECT 
    j.ID_Jugador,
    j.Nombre_usuario,
    AVG(rival.Elo_MMR) AS Promedio_Elo_Rivales
FROM Jugadores j
JOIN Jugadores_Rivales jr ON j.ID_Jugador = jr.ID_Jugador
JOIN Jugadores rival ON jr.ID_Jugador_Rival = rival.ID_Jugador
GROUP BY j.ID_Jugador, j.Nombre_usuario;
ROLLBACK;
/*
Consulta 1.b.
Esta consulta utiliza la relación reflexiva "Jugadores_Rivales" para, por cada jugador, 
contar cuántos rivales tiene.

Explicación de la consulta:
- Partimos de la tabla Jugadores (j), que representa al jugador principal.
- Unimos con la tabla Jugadores_Rivales (jr) para encontrar las relaciones de rivalidad 
  de cada jugador.
- Luego, unimos de nuevo con la tabla Jugadores (rival) para identificar a los rivales 
  concretos (para el COUNT necesitaremos acceder a sus ID).
- Aplicamos la función de agregación COUNT sobre el ID del rival (rival.ID_Jugador) 
  para obtener la cantidad total de rivales que tiene cada jugador.
- Agrupamos por el jugador principal (j.ID_Jugador, j.Nombre_usuario) para que cada 
  fila resultante corresponda a un jugador y su número de rivales.
- De esta manera, el resultado mostrará una fila por cada jugador, con la cantidad total 
  de rivales que tiene.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(1, 'ShadowBlade', 'NA', 2500.50, 65.20, 3.45),
(7, 'NightShade', 'NA', 2550.00, 66.00, 3.60),
(19, 'GoldenKnight', 'NA', 2510.20, 65.50, 3.50);
INSERT INTO Jugadores_Rivales (ID_Jugador, ID_Jugador_Rival) VALUES
(1, 7),   -- ShadowBlade tiene como rival a NightShade
(1, 19),  -- ShadowBlade también rivaliza con GoldenKnight
(7, 1),   -- NightShade tiene como rival a ShadowBlade
(7, 19),  -- NightShade rivaliza con GoldenKnight
(19, 1);  -- GoldenKnight rivaliza con ShadowBlade

SELECT 
    j.ID_Jugador,
    j.Nombre_usuario,
    COUNT(rival.ID_Jugador) AS Cantidad_Rivales
FROM Jugadores j
JOIN Jugadores_Rivales jr ON j.ID_Jugador = jr.ID_Jugador
JOIN Jugadores rival ON jr.ID_Jugador_Rival = rival.ID_Jugador
GROUP BY j.ID_Jugador, j.Nombre_usuario;
ROLLBACK;


/*
Consulta 2. Una consulta que represente un anidamiento de funciones de agregación. Haz 2 versiones, 
una con subconsulta en el FROM y otra con subconsulta en el WITH
*/ 

/*
Consulta 2.a.a (con subconsulta en el FROM):

Esta consulta calcula, para cada región, cuántos jugadores tienen un Elo_MMR superior a la media global y 
están asociados al menos a un equipo.

Explicación:
- Primero, en la subconsulta (SELECT AVG(Elo_MMR) AS Global_Avg FROM Jugadores), calculamos la media global del Elo_MMR.
- La unimos con CROSS JOIN para disponer de Global_Avg en la consulta principal.
- Realizamos un LEFT JOIN con Jugadores_Equipos para que las regiones sin jugadores con equipo igualmente aparezcan, 
  aunque con conteo 0.
- En el SELECT contamos (con COUNT y CASE) cuántos jugadores superan la media y tienen ID_Jugador en Jugadores_Equipos (no nulo).
- El uso de LEFT JOIN (JOIN externo) es necesario para mostrar todas las regiones incluso sin jugadores aptos. 
  Con INNER JOIN, las regiones sin jugadores aptos desaparecerían.

Así, anidamos funciones de agregación: 
- La subconsulta calcula la media global (AVG).
- La consulta principal agrupa por región y cuenta jugadores (COUNT) que superan dicha media.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(2, 'LunaStar', 'EU', 2300.75, 58.30, 2.90),
(3, 'ThunderStrike', 'ASIA', 2450.00, 62.50, 3.10),
(4, 'PhoenixRising', 'NA', 2400.25, 60.00, 3.00),
(5, 'IceDragon', 'EU', 2200.80, 55.75, 2.70),
(10, 'CrystalMage', 'NA', 2420.30, 60.80, 3.15),
(18, 'RapidFire', 'ASIA', 2395.55, 61.50, 3.10);
INSERT INTO Partidas (ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES (1001, '2024-04-01', '00:35:20', 'Clasificatoria', 'Victoria', 'Derrota');
INSERT INTO Equipos (ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(2001, 1001, 1, 'Victoria'),
(2002, 1001, 2, 'Derrota');
INSERT INTO Jugadores_Equipos (ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(2, 2001, 2300.75),  
(3, 2001, 2450.00),  
(18, 2002, 2395.55);

SELECT
    j.Region,
    COUNT(CASE WHEN j.Elo_MMR > ga.Global_Avg AND je.ID_Jugador IS NOT NULL THEN 1 END) AS Num_Jugadores_Superan_Media
FROM Jugadores j
LEFT JOIN Jugadores_Equipos je ON j.ID_Jugador = je.ID_Jugador
CROSS JOIN (
    SELECT AVG(Elo_MMR) AS Global_Avg
    FROM Jugadores
) ga
GROUP BY j.Region;
ROLLBACK;
/*
Consulta 2.a.b. (con WITH):
Explicación:
- Usamos WITH para definir una consulta intermedia llamada GlobalAverage, que calcula la media global de Elo_MMR.
- Luego, en la consulta principal:
  - Hacemos un LEFT JOIN con Jugadores_Equipos para incluir todas las regiones, incluso aquellas sin jugadores asociados a equipos.
  - Filtramos los jugadores que tienen un Elo_MMR superior a la media global calculada en la consulta intermedia (ga.Global_Avg).
  - Contamos cuántos jugadores cumplen la condición de superar la media y estar asociados a un equipo.

Nuevamente, anidamos funciones de agregación:
- En la consulta intermedia (definida con WITH), calculamos AVG (la media global).
- En la consulta principal, contamos (COUNT) cuántos jugadores cumplen las condiciones especificadas.
- El LEFT JOIN (JOIN externo) sigue siendo necesario para conservar todas las regiones, incluso las que no tengan jugadores asociados a equipos.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(2, 'LunaStar', 'EU', 2300.75, 58.30, 2.90),
(3, 'ThunderStrike', 'ASIA', 2450.00, 62.50, 3.10),
(4, 'PhoenixRising', 'NA', 2400.25, 60.00, 3.00),
(5, 'IceDragon', 'EU', 2200.80, 55.75, 2.70),
(10, 'CrystalMage', 'NA', 2420.30, 60.80, 3.15),
(18, 'RapidFire', 'ASIA', 2395.55, 61.50, 3.10);
INSERT INTO Partidas (ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES (1001, '2024-04-01', '00:35:20', 'Clasificatoria', 'Victoria', 'Derrota');
INSERT INTO Equipos (ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(2001, 1001, 1, 'Victoria'),
(2002, 1001, 2, 'Derrota');
INSERT INTO Jugadores_Equipos (ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(2, 2001, 2300.75),  
(3, 2001, 2450.00),  
(18, 2002, 2395.55);

WITH GlobalAverage AS (
    SELECT AVG(Elo_MMR) AS Global_Avg
    FROM Jugadores
)
SELECT
    j.Region,
    COUNT(CASE WHEN j.Elo_MMR > ga.Global_Avg AND je.ID_Jugador IS NOT NULL THEN 1 END) AS Num_Jugadores_Superan_Media
FROM Jugadores j
LEFT JOIN Jugadores_Equipos je ON j.ID_Jugador = je.ID_Jugador
CROSS JOIN GlobalAverage ga
GROUP BY j.Region;
ROLLBACK;

/*
Consulta 2.b.a (con subconsulta en el FROM):
Determina, para cada región, el promedio del Porcentaje_Victorias de los jugadores que tienen un Elo_MMR superior 
al promedio global.
Explicación:
- Calculamos el promedio global de Elo_MMR en una subconsulta en el FROM.
- Usamos este promedio en la consulta principal para filtrar jugadores con Elo_MMR superior.
- Agrupamos por región y calculamos el promedio de Porcentaje_Victorias para los jugadores que cumplen la condición.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(2, 'LunaStar', 'EU', 2300.75, 58.30, 2.90),
(3, 'ThunderStrike', 'ASIA', 2450.00, 62.50, 3.10),
(4, 'PhoenixRising', 'NA', 2400.25, 60.00, 3.00),
(5, 'IceDragon', 'EU', 2200.80, 55.75, 2.70),
(10, 'CrystalMage', 'NA', 2420.30, 60.80, 3.15),
(18, 'RapidFire', 'ASIA', 2395.55, 61.50, 3.10);

SELECT
    j.Region,
    AVG(j.Porcentaje_Victorias) AS Promedio_Porcentaje_Superior
FROM Jugadores j
CROSS JOIN (
    SELECT AVG(Elo_MMR) AS Promedio_Global_Elo
    FROM Jugadores
) pg
WHERE j.Elo_MMR > pg.Promedio_Global_Elo
GROUP BY j.Region;
ROLLBACK;

/*
Consulta 2.b.b (con WITH):
Determina, para cada región, el promedio del Porcentaje_Victorias de los jugadores que tienen un Elo_MMR superior 
al promedio global.
Explicación:
- Usamos WITH para calcular el promedio global de Elo_MMR (PromedioEloGlobal).
- En la consulta principal, filtramos jugadores con Elo_MMR superior al promedio calculado.
- Agrupamos por región y calculamos el promedio de Porcentaje_Victorias para los jugadores que cumplen la condición.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(2, 'LunaStar', 'EU', 2300.75, 58.30, 2.90),
(3, 'ThunderStrike', 'ASIA', 2450.00, 62.50, 3.10),
(4, 'PhoenixRising', 'NA', 2400.25, 60.00, 3.00),
(5, 'IceDragon', 'EU', 2200.80, 55.75, 2.70),
(10, 'CrystalMage', 'NA', 2420.30, 60.80, 3.15),
(18, 'RapidFire', 'ASIA', 2395.55, 61.50, 3.10);

WITH PromedioEloGlobal AS (
    SELECT AVG(Elo_MMR) AS Promedio_Global_Elo
    FROM Jugadores
)
SELECT
    j.Region,
    AVG(j.Porcentaje_Victorias) AS Promedio_Porcentaje_Superior
FROM Jugadores j
CROSS JOIN PromedioEloGlobal peg
WHERE j.Elo_MMR > peg.Promedio_Global_Elo
GROUP BY j.Region;
ROLLBACK;

/*
Consulta 3. Modifica la versión con WITH haciendo que el resultado de la consulta anterior sea otra 
subconsulta que puedas utilizar en una nueva consulta principal.
Los datos insertados son los mismos que en las consultas anteriores. 
*/
/*
Consulta 3.a:
1. Calculamos la media global de Elo_MMR con PromedioEloGlobal.
2. Obtenemos por región el conteo de jugadores con Elo_MMR superior al promedio en JugadoresSuperanPromedio.
3. En la consulta principal, filtramos las regiones que tienen al menos un jugador que cumple con las condiciones.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(1, 'ShadowBlade', 'NA', 2500, 65.2, 3.45),
(2, 'LunaStar', 'EU', 2300.75, 58.3, 2.9),
(3, 'ThunderStrike', 'ASIA', 2450, 62.5, 3.1);
INSERT INTO Jugadores_Equipos (ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(1, 201, 2501),
(1, 202, 2502),
(2, 201, 2301),
(3, 203, 2451);

WITH PromedioEloGlobal AS (
    SELECT AVG(Elo_MMR) AS Promedio_Global
    FROM Jugadores
),
JugadoresSuperanPromedio AS (
    SELECT
        j.Region,
        COUNT(CASE WHEN j.Elo_MMR > pg.Promedio_Global AND je.ID_Jugador IS NOT NULL THEN 1 END) AS Jugadores_Superan_Promedio
    FROM Jugadores j
    LEFT JOIN Jugadores_Equipos je ON j.ID_Jugador = je.ID_Jugador
    CROSS JOIN PromedioEloGlobal pg
    GROUP BY j.Region
)
SELECT *
FROM JugadoresSuperanPromedio;
ROLLBACK;


/*
Consulta 3.b:
1. Calculamos el promedio global de Elo_MMR con PromedioEloGlobal.
2. Calculamos, por región, el promedio del Porcentaje_Victorias de jugadores con Elo_MMR superior al promedio global 
   en PromedioPorcentajeSuperior.
3. En la consulta principal, usamos los resultados de PromedioPorcentajeSuperior para realizar una consulta adicional, 
   como seleccionar regiones con un promedio superior a un valor dado (por ejemplo, 60).
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(1, 'ShadowBlade', 'NA', 2500, 65.2, 3.45),
(2, 'LunaStar', 'EU', 2300.75, 58.3, 2.9),
(3, 'ThunderStrike', 'ASIA', 2450, 62.5, 3.1);
WITH PromedioEloGlobal AS (
    SELECT AVG(Elo_MMR) AS Promedio_Global_Elo
    FROM Jugadores
),
PromedioPorcentajeSuperior AS (
    SELECT
        j.Region,
        AVG(j.Porcentaje_Victorias) AS Promedio_Porcentaje_Superior
    FROM Jugadores j
    CROSS JOIN PromedioEloGlobal peg
    WHERE j.Elo_MMR > peg.Promedio_Global_Elo
    GROUP BY j.Region
)
SELECT *
FROM PromedioPorcentajeSuperior
WHERE Promedio_Porcentaje_Superior > 60;
ROLLBACK;

/*
Consulta 4. Dos cocientes relacionales con subconsulta en HAVING. En lugar de pedir elementos del 
dividendo que se relacionan con todos los elementos del divisor, puedes relajarlo a 
elementos del dividendo que se relacionan al menos con un porcentaje de elementos del 
divisor, seguramente así te sea más fácil reutilizar algunas filas de ejemplo
 	1. Uno de los 2 cocientes ha de necesitar algún COUNT(DISTINCT) en la subconsulta, y 
	el otro lo ha de necesitar en la consulta principal. Tendrás que justificar en el script esa 
	necesidad a través de la información de los create tables (i.e., las claves). Por ejemplo, 
	como la clave es X, y agrupamos por Y, se pueden repetir las Zs dentro de cada grupo.
 	2. Al menos uno de los dos cocientes deberá de tener un WHERE en la subconsulta
*/

/*
Consulta 4.a.a. Jugadores asociados al menos con el 50% de los equipos en partidas de tipo 'Clasificatoria'.
Explicación: 
1. Calculamos cuántos equipos están asociados con cada jugador (`COUNT(DISTINCT je.ID_Equipo)`).
2. Calculamos el total de equipos únicos en partidas de tipo 'Clasificatoria' (subconsulta en el HAVING).
3. Comparamos el conteo del dividendo con el 50% del conteo del divisor para determinar si el jugador cumple la condición.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(1, 'ShadowBlade', 'NA', 2500, 65.2, 3.45),
(2, 'LunaStar', 'EU', 2300.75, 58.3, 2.9),
(3, 'ThunderStrike', 'ASIA', 2450, 62.5, 3.1);
INSERT INTO Partidas (ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(101, '2024-04-01', '00:35:20', 'Clasificatoria', 'Victoria', 'Derrota'),
(102, '2024-04-02', '00:28:45', 'Normal', 'Derrota', 'Victoria');
INSERT INTO Equipos (ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(201, 101, 1, 'Victoria'),
(202, 101, 2, 'Derrota'),
(203, 102, 1, 'Derrota');
INSERT INTO Jugadores_Equipos (ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(1, 201, 2501),
(1, 202, 2502),
(2, 201, 2301),
(3, 203, 2451);

SELECT j.ID_Jugador, j.Nombre_usuario
FROM Jugadores j
JOIN Jugadores_Equipos je ON j.ID_Jugador = je.ID_Jugador
GROUP BY j.ID_Jugador, j.Nombre_usuario
HAVING COUNT(DISTINCT je.ID_Equipo) >= 0.5 * (
    SELECT COUNT(DISTINCT e.ID_Equipo)
    FROM Equipos e
    JOIN Partidas p ON e.ID_Partida = p.ID_Partida
    WHERE p.Tipo_Partida = 'Clasificatoria'
);
ROLLBACK;

/*
Consulta 4.a.b.
Regiones donde al menos el 50% de los jugadores están asociados a equipos
que ganaron partidas clasificatorias.
Explicación: 
1. Relacionamos jugadores con partidas y equipos para identificar asociaciones con equipos ganadores 
   en partidas de tipo 'Clasificatoria'.
2. Agrupamos los resultados por región.
3. Comparamos el conteo de jugadores del dividendo con el 50% del total de jugadores de la región
   (subconsulta en HAVING).
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(1, 'ShadowBlade', 'NA', 2500, 65.2, 3.45),
(2, 'LunaStar', 'EU', 2300.75, 58.3, 2.9),
(3, 'ThunderStrike', 'ASIA', 2450, 62.5, 3.1);
INSERT INTO Partidas (ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(101, '2024-04-01', '00:35:20', 'Clasificatoria', 'Victoria', 'Derrota'),
(102, '2024-04-02', '00:28:45', 'Normal', 'Derrota', 'Victoria');
INSERT INTO Equipos (ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(201, 101, 1, 'Victoria'),
(202, 101, 2, 'Derrota'),
(203, 102, 1, 'Derrota');
INSERT INTO Jugadores_Equipos (ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(1, 201, 2501),
(1, 202, 2502),
(2, 201, 2301),
(3, 203, 2451);

SELECT j.Region
FROM Jugadores j
LEFT JOIN Jugadores_Equipos je ON j.ID_Jugador = je.ID_Jugador
LEFT JOIN Equipos e ON je.ID_Equipo = e.ID_Equipo
LEFT JOIN Partidas p ON e.ID_Partida = p.ID_Partida
WHERE p.Tipo_Partida = 'Clasificatoria' AND e.Resultado = 'Victoria'
GROUP BY j.Region
HAVING COUNT(DISTINCT j.ID_Jugador) >= 0.5 * (
    SELECT COUNT(*) 
    FROM Jugadores j2
    WHERE j2.Region = j.Region
);
ROLLBACK;

/*
Consulta 4.b.a.
Jugadores que participan en al menos el 65% de las partidas con duración > 30 minutos.
Explicación:
1. Contamos cuántas partidas >30min ha jugado cada jugador.
2. En la subconsulta (HAVING), contamos el total de partidas >30min.
3. Comparamos si las partidas >30min del jugador ≥ 0.65 * (total de partidas >30min).
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(1, 'ShadowBlade', 'NA', 2500, 65.2, 3.45),
(2, 'LunaStar', 'EU', 2300.75, 58.3, 2.9),
(3, 'ThunderStrike', 'ASIA', 2450, 62.5, 3.1);
INSERT INTO Partidas (ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(101, '2024-04-01', '00:35:20', 'Clasificatoria', 'Victoria', 'Derrota'),
(102, '2024-04-02', '00:28:45', 'Normal', 'Derrota', 'Victoria');
INSERT INTO Equipos (ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(201, 101, 1, 'Victoria'),
(202, 101, 2, 'Derrota'),
(203, 102, 1, 'Derrota');
INSERT INTO Jugadores_Equipos (ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(1, 201, 2501),
(1, 202, 2502),
(2, 201, 2301),
(3, 203, 2451);

SELECT j.ID_Jugador, j.Nombre_usuario
FROM Jugadores j
JOIN Jugadores_Equipos je ON j.ID_Jugador = je.ID_Jugador
JOIN Equipos eq ON je.ID_Equipo = eq.ID_Equipo
JOIN Partidas pa ON eq.ID_Partida = pa.ID_Partida
GROUP BY j.ID_Jugador, j.Nombre_usuario
HAVING COUNT(DISTINCT CASE WHEN pa.Duracion > '00:30:00' THEN pa.ID_Partida END) >= 0.65 * (
    SELECT COUNT(DISTINCT p2.ID_Partida)
    FROM Partidas p2
    WHERE p2.Duracion > '00:30:00'
);
ROLLBACK;

/*
Consulta 4.b.b
Equipos en los que al menos el 50% de sus jugadores tienen Elo_MMR > 2400.
Explicación:
1. Filtramos jugadores con Elo_MMR >2400 en la cláusula WHERE.
2. Contamos jugadores distintos (>2400) por equipo, usando COUNT(DISTINCT j.ID_Jugador).
3. Subconsulta en HAVING: Cuenta total de jugadores del equipo.
4. Comparamos si jugadores >2400 ≥ 0.5 * total jugadores.
5. LEFT JOIN para asegurar que todos los equipos aparezcan y luego se filtren con HAVING.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(1, 'ShadowBlade', 'NA', 2500, 65.2, 3.45),
(2, 'LunaStar', 'EU', 2300.75, 58.3, 2.9),
(3, 'ThunderStrike', 'ASIA', 2450, 62.5, 3.1);
INSERT INTO Partidas (ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(101, '2024-04-01', '00:35:20', 'Clasificatoria', 'Victoria', 'Derrota'),
(102, '2024-04-02', '00:28:45', 'Normal', 'Derrota', 'Victoria');
INSERT INTO Equipos (ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(201, 101, 1, 'Victoria'),
(202, 101, 2, 'Derrota'),
(203, 102, 1, 'Derrota');
INSERT INTO Jugadores_Equipos (ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(1, 201, 2501),
(1, 202, 2502),
(2, 201, 2301),
(3, 203, 2451);

SELECT eq.ID_Equipo
FROM Equipos eq
LEFT JOIN Jugadores_Equipos je ON eq.ID_Equipo = je.ID_Equipo
LEFT JOIN Jugadores j ON je.ID_Jugador = j.ID_Jugador
WHERE j.Elo_MMR > 2400
GROUP BY eq.ID_Equipo
HAVING COUNT(DISTINCT j.ID_Jugador) >= 0.5 * (
    SELECT COUNT(*) 
    FROM Jugadores_Equipos je2
    WHERE je2.ID_Equipo = eq.ID_Equipo
);
ROLLBACK;

/*
Consulta 5. Una consulta con subconsulta en el WHERE, que se pueda hacer tanto con MAX/MIN en la 
subconsulta, o como con ALL en la subconsulta. Presentar una versión con MAX/MIN, otra 
con ALL y otra con NOT EXISTS
*/
/*
Consulta 5.a.
*/

/*
Consulta con MAX:
Encontrar jugadores con Elo_MMR > MAX(Elo_MMR de jugadores en Clasificatoria).
Explicación:
1. Subconsulta: Hallar el MAX(Elo_MMR) de los jugadores que participaron en 'Clasificatoria'.
2. En el WHERE: Comparar Elo_MMR del jugador actual con este valor máximo.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(500, 'OverPower', 'NA', 2600, 65.0, 3.5),   -- Jugador muy fuerte
(501, 'MidPlayer', 'NA', 2500, 60.0, 3.0),   -- Jugador intermedio
(502, 'LowPlayer', 'NA', 2300, 55.0, 2.5);   -- Jugador más débil
INSERT INTO Partidas (ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(1001, '2025-01-01', '00:30:00', 'Clasificatoria', 'Victoria', 'Derrota'),
(1002, '2025-01-02', '00:28:00', 'Normal', 'Victoria', 'Derrota');
INSERT INTO Equipos (ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(1101, 1001, 1, 'Victoria'),  -- Equipo ganador en Clasificatoria
(1102, 1001, 2, 'Derrota'),   -- Equipo perdedor en Clasificatoria
(1103, 1002, 1, 'Victoria'),  -- Equipo ganador en Normal
(1104, 1002, 2, 'Derrota');   -- Equipo perdedor en Normal
INSERT INTO Jugadores_Equipos (ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(501, 1101, 2501), -- MidPlayer en partida clasificatoria (ganador)
(502, 1102, 2301), -- LowPlayer en partida clasificatoria (perdedor)
(500, 1103, 2601), -- OverPower en partida normal (ganador)
(501, 1104, 2502); -- MidPlayer en partida normal (perdedor)

SELECT j.ID_Jugador, j.Nombre_usuario
FROM Jugadores j
WHERE j.Elo_MMR > (
    SELECT MAX(j2.Elo_MMR)
    FROM Jugadores j2
    JOIN Jugadores_Equipos je2 ON j2.ID_Jugador = je2.ID_Jugador
    JOIN Equipos e2 ON je2.ID_Equipo = e2.ID_Equipo
    JOIN Partidas p2 ON e2.ID_Partida = p2.ID_Partida
    WHERE p2.Tipo_Partida = 'Clasificatoria'
);
ROLLBACK;
/*
Consulta con ALL:
Encontrar jugadores con Elo_MMR > todos los Elo_MMR de jugadores en Clasificatoria.
Explicación:
1. La subconsulta lista los Elo_MMR de jugadores que participaron en 'Clasificatoria'.
2. Con ALL: j.Elo_MMR > TODOS los Elo_MMR devueltos por la subconsulta.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(500, 'OverPower', 'NA', 2600, 65.0, 3.5),   -- Jugador muy fuerte
(501, 'MidPlayer', 'NA', 2500, 60.0, 3.0),   -- Jugador intermedio
(502, 'LowPlayer', 'NA', 2300, 55.0, 2.5);   -- Jugador más débil
INSERT INTO Partidas (ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(1001, '2025-01-01', '00:30:00', 'Clasificatoria', 'Victoria', 'Derrota'),
(1002, '2025-01-02', '00:28:00', 'Normal', 'Victoria', 'Derrota');
INSERT INTO Equipos (ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(1101, 1001, 1, 'Victoria'),  -- Equipo ganador en Clasificatoria
(1102, 1001, 2, 'Derrota'),   -- Equipo perdedor en Clasificatoria
(1103, 1002, 1, 'Victoria'),  -- Equipo ganador en Normal
(1104, 1002, 2, 'Derrota');   -- Equipo perdedor en Normal
INSERT INTO Jugadores_Equipos (ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(501, 1101, 2501), -- MidPlayer en partida clasificatoria (ganador)
(502, 1102, 2301), -- LowPlayer en partida clasificatoria (perdedor)
(500, 1103, 2601), -- OverPower en partida normal (ganador)
(501, 1104, 2502); -- MidPlayer en partida normal (perdedor)
SELECT j.ID_Jugador, j.Nombre_usuario
FROM Jugadores j
WHERE j.Elo_MMR > ALL (
    SELECT j2.Elo_MMR
    FROM Jugadores j2
    JOIN Jugadores_Equipos je2 ON j2.ID_Jugador = je2.ID_Jugador
    JOIN Equipos e2 ON je2.ID_Equipo = e2.ID_Equipo
    JOIN Partidas p2 ON e2.ID_Partida = p2.ID_Partida
    WHERE p2.Tipo_Partida = 'Clasificatoria'
);
ROLLBACK;

/*
Consulta con NOT EXISTS:
Encontrar jugadores para los cuales NO EXISTE un jugador de Clasificatoria con Elo_MMR igual o mayor.
Explicación:
1. Usamos NOT EXISTS para comprobar que no exista un jugador en Clasificatoria con Elo_MMR >= j.Elo_MMR.
2. Si no existe tal jugador, entonces j.Elo_MMR es mayor que todos los Elo_MMR de jugadores en Clasificatoria.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(500, 'OverPower', 'NA', 2600, 65.0, 3.5),   -- Jugador muy fuerte
(501, 'MidPlayer', 'NA', 2500, 60.0, 3.0),   -- Jugador intermedio
(502, 'LowPlayer', 'NA', 2300, 55.0, 2.5);   -- Jugador más débil
INSERT INTO Partidas (ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(1001, '2025-01-01', '00:30:00', 'Clasificatoria', 'Victoria', 'Derrota'),
(1002, '2025-01-02', '00:28:00', 'Normal', 'Victoria', 'Derrota');
INSERT INTO Equipos (ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(1101, 1001, 1, 'Victoria'),  -- Equipo ganador en Clasificatoria
(1102, 1001, 2, 'Derrota'),   -- Equipo perdedor en Clasificatoria
(1103, 1002, 1, 'Victoria'),  -- Equipo ganador en Normal
(1104, 1002, 2, 'Derrota');   -- Equipo perdedor en Normal
INSERT INTO Jugadores_Equipos (ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(501, 1101, 2501), -- MidPlayer en partida clasificatoria (ganador)
(502, 1102, 2301), -- LowPlayer en partida clasificatoria (perdedor)
(500, 1103, 2601), -- OverPower en partida normal (ganador)
(501, 1104, 2502); -- MidPlayer en partida normal (perdedor)

SELECT j.ID_Jugador, j.Nombre_usuario
FROM Jugadores j
WHERE NOT EXISTS (
    SELECT *
    FROM Jugadores j2
    JOIN Jugadores_Equipos je2 ON j2.ID_Jugador = je2.ID_Jugador
    JOIN Equipos e2 ON je2.ID_Equipo = e2.ID_Equipo
    JOIN Partidas p2 ON e2.ID_Partida = p2.ID_Partida
    WHERE p2.Tipo_Partida = 'Clasificatoria'
    AND j2.Elo_MMR >= j.Elo_MMR
);
ROLLBACK;

/*
Consulta 5.b.
*/
/*
Consulta con MAX:
Queremos jugadores que hayan jugado al menos una partida normal 
y cuyo Elo_MMR sea mayor que el Elo_MMR máximo de todos los jugadores de partidas clasificatorias.
Explicación:
1. Seleccionamos jugadores que participaron en partidas tipo 'Normal'.
2. Usamos una subconsulta en el WHERE con (SELECT MAX(...)) 
   para obtener el mayor Elo_MMR de los jugadores que participaron en 'Clasificatoria'.
3. Comparamos Elo_MMR del jugador con este valor máximo.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(500, 'OverPower', 'NA', 2600, 65.0, 3.5),   -- Jugador muy fuerte
(501, 'MidPlayer', 'NA', 2500, 60.0, 3.0),   -- Jugador intermedio
(502, 'LowPlayer', 'NA', 2300, 55.0, 2.5);   -- Jugador más débil
INSERT INTO Partidas (ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(1001, '2025-01-01', '00:30:00', 'Clasificatoria', 'Victoria', 'Derrota'),
(1002, '2025-01-02', '00:28:00', 'Normal', 'Victoria', 'Derrota');
INSERT INTO Equipos (ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(1101, 1001, 1, 'Victoria'),  -- Equipo ganador en Clasificatoria
(1102, 1001, 2, 'Derrota'),   -- Equipo perdedor en Clasificatoria
(1103, 1002, 1, 'Victoria'),  -- Equipo ganador en Normal
(1104, 1002, 2, 'Derrota');   -- Equipo perdedor en Normal
INSERT INTO Jugadores_Equipos (ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(501, 1101, 2501), -- MidPlayer en partida clasificatoria (ganador)
(502, 1102, 2301), -- LowPlayer en partida clasificatoria (perdedor)
(500, 1103, 2601), -- OverPower en partida normal (ganador)
(501, 1104, 2502); -- MidPlayer en partida normal (perdedor)

SELECT j.ID_Jugador, j.Nombre_usuario
FROM Jugadores j
JOIN Jugadores_Equipos je ON j.ID_Jugador = je.ID_Jugador
JOIN Equipos eq ON je.ID_Equipo = eq.ID_Equipo
JOIN Partidas pa ON eq.ID_Partida = pa.ID_Partida
WHERE pa.Tipo_Partida = 'Normal'
  AND j.Elo_MMR > (
      SELECT MAX(j2.Elo_MMR)
      FROM Jugadores j2
      JOIN Jugadores_Equipos je2 ON j2.ID_Jugador = je2.ID_Jugador
      JOIN Equipos eq2 ON je2.ID_Equipo = eq2.ID_Equipo
      JOIN Partidas p2 ON eq2.ID_Partida = p2.ID_Partida
      WHERE p2.Tipo_Partida = 'Clasificatoria'
  );
ROLLBACK;
/*
Consulta con ALL:
Misma lógica que la anterior, pero ahora:
Queremos jugadores que hayan jugado al menos una partida normal 
y cuyo Elo_MMR sea mayor que el Elo_MMR de TODOS los jugadores de partidas clasificatorias.
Explicación:
1. Seleccionamos jugadores con partidas 'Normal'.
2. La subconsulta devuelve una lista de Elo_MMR de jugadores de 'Clasificatoria'.
3. Usamos la condición > ALL (subconsulta) para verificar que el Elo_MMR del jugador sea mayor que cada uno de ellos.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(500, 'OverPower', 'NA', 2600, 65.0, 3.5),   -- Jugador muy fuerte
(501, 'MidPlayer', 'NA', 2500, 60.0, 3.0),   -- Jugador intermedio
(502, 'LowPlayer', 'NA', 2300, 55.0, 2.5);   -- Jugador más débil
INSERT INTO Partidas (ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(1001, '2025-01-01', '00:30:00', 'Clasificatoria', 'Victoria', 'Derrota'),
(1002, '2025-01-02', '00:28:00', 'Normal', 'Victoria', 'Derrota');
INSERT INTO Equipos (ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(1101, 1001, 1, 'Victoria'),  -- Equipo ganador en Clasificatoria
(1102, 1001, 2, 'Derrota'),   -- Equipo perdedor en Clasificatoria
(1103, 1002, 1, 'Victoria'),  -- Equipo ganador en Normal
(1104, 1002, 2, 'Derrota');   -- Equipo perdedor en Normal
INSERT INTO Jugadores_Equipos (ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(501, 1101, 2501), -- MidPlayer en partida clasificatoria (ganador)
(502, 1102, 2301), -- LowPlayer en partida clasificatoria (perdedor)
(500, 1103, 2601), -- OverPower en partida normal (ganador)
(501, 1104, 2502); -- MidPlayer en partida normal (perdedor)

SELECT j.ID_Jugador, j.Nombre_usuario
FROM Jugadores j
JOIN Jugadores_Equipos je ON j.ID_Jugador = je.ID_Jugador
JOIN Equipos eq ON je.ID_Equipo = eq.ID_Equipo
JOIN Partidas pa ON eq.ID_Partida = pa.ID_Partida
WHERE pa.Tipo_Partida = 'Normal'
  AND j.Elo_MMR > ALL (
      SELECT j2.Elo_MMR
      FROM Jugadores j2
      JOIN Jugadores_Equipos je2 ON j2.ID_Jugador = je2.ID_Jugador
      JOIN Equipos eq2 ON je2.ID_Equipo = eq2.ID_Equipo
      JOIN Partidas p2 ON eq2.ID_Partida = p2.ID_Partida
      WHERE p2.Tipo_Partida = 'Clasificatoria'
  );
ROLLBACK;
/*
Consulta con NOT EXISTS:
Misma idea, pero usando NOT EXISTS:
Buscamos jugadores de 'Normal' para los cuales NO EXISTA ningún jugador de 'Clasificatoria' 
con Elo_MMR mayor o igual al suyo, garantizando así que son mayores que todos los de 'Clasificatoria'.
Explicación:
1. Seleccionamos jugadores con partidas 'Normal'.
2. Verificamos con NOT EXISTS que no exista un jugador en 'Clasificatoria' con Elo_MMR >= j.Elo_MMR.
3. Si no existe tal jugador, significa que el Elo_MMR del jugador seleccionado es mayor que el de todos en 'Clasificatoria'.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(500, 'OverPower', 'NA', 2600, 65.0, 3.5),   -- Jugador muy fuerte
(501, 'MidPlayer', 'NA', 2500, 60.0, 3.0),   -- Jugador intermedio
(502, 'LowPlayer', 'NA', 2300, 55.0, 2.5);   -- Jugador más débil
INSERT INTO Partidas (ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(1001, '2025-01-01', '00:30:00', 'Clasificatoria', 'Victoria', 'Derrota'),
(1002, '2025-01-02', '00:28:00', 'Normal', 'Victoria', 'Derrota');
INSERT INTO Equipos (ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(1101, 1001, 1, 'Victoria'),  -- Equipo ganador en Clasificatoria
(1102, 1001, 2, 'Derrota'),   -- Equipo perdedor en Clasificatoria
(1103, 1002, 1, 'Victoria'),  -- Equipo ganador en Normal
(1104, 1002, 2, 'Derrota');   -- Equipo perdedor en Normal
INSERT INTO Jugadores_Equipos (ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(501, 1101, 2501), -- MidPlayer en partida clasificatoria (ganador)
(502, 1102, 2301), -- LowPlayer en partida clasificatoria (perdedor)
(500, 1103, 2601), -- OverPower en partida normal (ganador)
(501, 1104, 2502); -- MidPlayer en partida normal (perdedor)

SELECT j.ID_Jugador, j.Nombre_usuario
FROM Jugadores j
JOIN Jugadores_Equipos je ON j.ID_Jugador = je.ID_Jugador
JOIN Equipos eq ON je.ID_Equipo = eq.ID_Equipo
JOIN Partidas pa ON eq.ID_Partida = pa.ID_Partida
WHERE pa.Tipo_Partida = 'Normal'
  AND NOT EXISTS (
      SELECT 1
      FROM Jugadores j2
      JOIN Jugadores_Equipos je2 ON j2.ID_Jugador = je2.ID_Jugador
      JOIN Equipos eq2 ON je2.ID_Equipo = eq2.ID_Equipo
      JOIN Partidas p2 ON eq2.ID_Partida = p2.ID_Partida
      WHERE p2.Tipo_Partida = 'Clasificatoria'
        AND j2.Elo_MMR >= j.Elo_MMR
  );
ROLLBACK;

/*
Consulta 6.1  
Una consulta con subconsulta correlacionada en la cláusula SELECT que calcule una función de agregación.  
*/

/*
Consulta 6.1.a.
Esta consulta muestra, para cada jugador, su nombre y el promedio de Elo_MMR_Partida que ha tenido en 
todas las partidas que jugó. Para ello:
- Partimos de la tabla Jugadores (J).
- En la lista SELECT, usamos una subconsulta correlacionada que:
  - Filtra en Jugadores_Equipos (JE) por el ID_Jugador actual.
  - Calcula el promedio (AVG) de Elo_MMR_Partida.
- De este modo, cada jugador devuelve el promedio de su Elo_MMR_Partida.
- Si un jugador no ha jugado ninguna partida, el resultado será NULL en el promedio.
*/

INSERT INTO Jugadores(ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(1, 'SingleSlayer', 'EU', 2000.00, 55.00, 3.50),
(2, 'ThunderTail', 'NA', 1800.00, 49.00, 2.20),
(3, 'SpokenNightmare', 'EU', 2100.00, 60.00, 4.00),
(4, 'CursedPointer', 'NA', 1500.00, 30.00, 1.50); 

INSERT INTO Partidas(ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(1, '2024-12-08 10:00:00', '00:30:00', 'Clasificatoria', 'Victoria', 'Derrota'),
(2, '2024-12-08 11:00:00', '00:25:00', 'Normal', 'Derrota', 'Victoria');

INSERT INTO Equipos(ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(200, 1, 1, 'Victoria'),
(201, 1, 2, 'Derrota'),
(202, 2, 1, 'Derrota'),
(203, 2, 2, 'Victoria');

INSERT INTO Jugadores_Equipos(ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(1, 200, 2050.00), 
(2, 201, 1790.00), 
(1, 202, 1980.00), 
(3, 203, 2105.00); 

/*
 Consulta 6.1.a con subconsulta correlacionada
 Para SingleSlayer (ID=1): La subconsulta filtra JE.ID_Jugador=1 y encuentra Elo_MMR_Partida = 2050 y 1980,
 Promedio = (2050+1980)/2 = 2015.00
 Para CursedPointer (ID=4): Sin filas en Jugadores_Equipos, la subconsulta devuelve NULL.
*/
SELECT 
    J.Nombre_usuario,
    (SELECT AVG(JE.Elo_MMR_Partida)
     FROM Jugadores_Equipos JE
     JOIN Equipos E ON JE.ID_Equipo = E.ID_Equipo
     WHERE JE.ID_Jugador = J.ID_Jugador
    ) AS Promedio_Elo_MMR_Partidas
FROM Jugadores J;

ROLLBACK;

/*
Consulta 6.1.b.
Versión equivalente sin subconsulta, utilizando GROUP BY:
- Partimos de Jugadores (J).
- Hacemos LEFT JOIN con Jugadores_Equipos (JE) y Equipos (E).
- Agrupamos por Nombre_usuario.
- Calculamos AVG(JE.Elo_MMR_Partida) directamente en el SELECT.
- Si un jugador no tiene partidas, la función AVG devolverá NULL, ya que no hay filas que juntar.
*/

INSERT INTO Jugadores(ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(1, 'SingleSlayer', 'EU', 2000.00, 55.00, 3.50),
(2, 'ThunderTail', 'NA', 1800.00, 49.00, 2.20),
(3, 'SpokenNightmare', 'EU', 2100.00, 60.00, 4.00),
(4, 'CursedPointer', 'NA', 1500.00, 30.00, 1.50);

INSERT INTO Partidas(ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(1, '2024-12-08 10:00:00', '00:30:00', 'Clasificatoria', 'Victoria', 'Derrota'),
(2, '2024-12-08 11:00:00', '00:25:00', 'Normal', 'Derrota', 'Victoria');

INSERT INTO Equipos(ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(200, 1, 1, 'Victoria'),
(201, 1, 2, 'Derrota'),
(202, 2, 1, 'Derrota'),
(203, 2, 2, 'Victoria');

INSERT INTO Jugadores_Equipos(ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(1, 200, 2050.00),
(2, 201, 1790.00),
(1, 202, 1980.00),
(3, 203, 2105.00);

-- Consulta 6.1.b sin subconsulta con GROUP BY
SELECT 
    J.Nombre_usuario, 
    AVG(JE.Elo_MMR_Partida) AS Promedio_Elo_MMR_Partidas
FROM Jugadores J
LEFT JOIN Jugadores_Equipos JE ON J.ID_Jugador = JE.ID_Jugador
LEFT JOIN Equipos E ON JE.ID_Equipo = E.ID_Equipo
GROUP BY J.Nombre_usuario

ROLLBACK;

/*
Consulta 6.2  
Para cada jugador, mostrar su Elo_MMR actual (de la tabla Jugadores) y su pico máximo de Elo_MMR_Partida,
independientemente del tipo de partida.
*/

/*
Consulta 6.2.a.
Esta consulta muestra, para cada jugador, su Elo_MMR y el máximo Elo_MMR_Partida alcanzado.
- Partimos de la tabla Jugadores (J).
- En la lista SELECT, usamos una subconsulta correlacionada que:
- Filtra en Jugadores_Equipos (JE) por el ID_Jugador actual (J.ID_Jugador).
- Calcula el máximo (MAX) de Elo_MMR_Partida.
  
Si un jugador no ha jugado ninguna partida, el resultado será NULL en su pico máximo.
*/

-- Primero insertamos los datos necesarios
INSERT INTO Jugadores(ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(1, 'SingleSlayer',    'EU', 1900.00, 52.00, 2.90),
(2, 'ThunderTail',     'NA', 2100.00, 58.00, 3.80),
(3, 'SpokenNightmare', 'EU', 1750.00, 45.00, 2.00),
(4, 'CursedPointer',   'NA', 2200.00, 63.00, 4.00);

INSERT INTO Partidas(ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(1, '2024-12-08 10:00:00', '00:40:00', 'Clasificatoria', 'Victoria', 'Derrota'),
(2, '2024-12-08 11:30:00', '00:22:00', 'Normal', 'Derrota', 'Victoria');

INSERT INTO Equipos(ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(200, 1, 1, 'Victoria'),
(201, 1, 2, 'Derrota'),
(202, 2, 1, 'Derrota'),
(203, 2, 2, 'Victoria');

INSERT INTO Jugadores_Equipos(ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(1, 200, 1955.00),
(2, 201, 1800.00),
(2, 203, 2120.00),
(3, 202, 1795.00);

-- Consulta con subconsulta correlacionada
SELECT 
    J.Nombre_usuario,
    J.Elo_MMR AS Elo_Actual,
    (SELECT MAX(JE.Elo_MMR_Partida)
     FROM Jugadores_Equipos JE
     JOIN Equipos E ON JE.ID_Equipo = E.ID_Equipo
     WHERE JE.ID_Jugador = J.ID_Jugador
    ) AS pico_max_elo
FROM Jugadores J;

-- Deshaciendo la correlación para J.ID_Jugador=2 (ejemplo de fila con resultado):
SELECT MAX(JE.Elo_MMR_Partida)
FROM Jugadores_Equipos JE
JOIN Equipos E ON JE.ID_Equipo=E.ID_Equipo
WHERE JE.ID_Jugador=2;

-- Si hubiera un jugador sin partidas, por ejemplo ID_Jugador=4:
 SELECT MAX(JE.Elo_MMR_Partida)
 FROM Jugadores_Equipos JE
 JOIN Equipos E ON JE.ID_Equipo=E.ID_Equipo
 WHERE JE.ID_Jugador=4;

ROLLBACK;

/*
Consulta 6.2.b.
Versión equivalente sin subconsulta, utilizando GROUP BY:
- Partimos de Jugadores (J).
- Hacemos LEFT JOIN con Jugadores_Equipos (JE) y Equipos (E).
- Agrupamos por Nombre_usuario, J.Elo_MMR.
- Calculamos MAX(JE.Elo_MMR_Partida) directamente.
- Si un jugador no tiene partidas, MAX devolverá NULL.

No es necesario "deshacer" nada aquí, pues no hay correlación.
*/

INSERT INTO Jugadores(ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(1, 'SingleSlayer',    'EU', 1900.00, 52.00, 2.90),
(2, 'ThunderTail',     'NA', 2100.00, 58.00, 3.80),
(3, 'SpokenNightmare', 'EU', 1750.00, 45.00, 2.00);
(4, 'CursedPointer',   'NA', 2200.00, 63.00, 4.00);

INSERT INTO Partidas(ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(1, '2024-12-08 10:00:00', '00:40:00', 'Clasificatoria', 'Victoria', 'Derrota'),
(2, '2024-12-08 11:30:00', '00:22:00', 'Normal', 'Derrota', 'Victoria');

INSERT INTO Equipos(ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(200, 1, 1, 'Victoria'),
(201, 1, 2, 'Derrota'),
(202, 2, 1, 'Derrota'),
(203, 2, 2, 'Victoria');

INSERT INTO Jugadores_Equipos(ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(1, 200, 1955.00),
(2, 201, 1800.00),
(2, 203, 2120.00),
(3, 202, 1795.00);

SELECT 
    J.Nombre_usuario,
    J.Elo_MMR AS Elo_Actual,
    MAX(JE.Elo_MMR_Partida) AS pico_max_elo
FROM Jugadores J
LEFT JOIN Jugadores_Equipos JE ON J.ID_Jugador = JE.ID_Jugador
LEFT JOIN Equipos E ON JE.ID_Equipo = E.ID_Equipo
GROUP BY J.Nombre_usuario, J.Elo_MMR;

ROLLBACK;

/*
Consulta 7.2

Objetivo:
Jugadores que solo hayan jugado partidas normales y al menos hayan ganado una.
*/

-- 7.2.a. Versión con INTERSECT y EXCEPT
INSERT INTO Jugadores(ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(1, 'SingleSlayer',    'EU', 2000.00, 55.00, 3.50),
(2, 'ThunderTail',     'NA', 2100.00, 58.00, 3.80),
(3, 'SpokenNightmare', 'EU', 1900.00, 45.00, 2.00),
(4, 'CursedPointer',   'NA', 1700.00, 30.00, 1.80);

INSERT INTO Partidas(ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(1, '2024-12-08 09:00:00', '00:30:00', 'Clasificatoria', 'Victoria', 'Derrota'),
(2, '2024-12-08 10:00:00', '00:25:00', 'Normal', 'Victoria', 'Derrota');

INSERT INTO Equipos(ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(200, 1, 1, 'Victoria'),
(201, 1, 2, 'Derrota'),
(202, 2, 1, 'Victoria'),
(203, 2, 2, 'Derrota');

INSERT INTO Jugadores_Equipos(ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(1, 200, 2050.00),
(1, 202, 1980.00),
(2, 202, 2100.00),
(3, 201, 1800.00),
(4, 203, 1600.00);

WITH JugVictoria AS (
  -- Obtiene los IDs de jugadores que han estado en equipos victoriosos
  SELECT DISTINCT JE.ID_Jugador
  FROM Jugadores_Equipos JE
  JOIN Equipos E ON JE.ID_Equipo=E.ID_Equipo
  WHERE E.Resultado='Victoria'
),
JugNormal AS (
  -- Obtiene los IDs de jugadores que han jugado partidas normales
  SELECT DISTINCT JE.ID_Jugador
  FROM Jugadores_Equipos JE
  JOIN Equipos E ON JE.ID_Equipo=E.ID_Equipo
  JOIN Partidas P ON E.ID_Partida=P.ID_Partida
  WHERE P.Tipo_Partida='Normal'
),
JugClas AS (
  -- Obtiene los IDs de jugadores que han jugado partidas clasificatorias
  SELECT DISTINCT JE.ID_Jugador
  FROM Jugadores_Equipos JE
  JOIN Equipos E ON JE.ID_Equipo=E.ID_Equipo
  JOIN Partidas P ON E.ID_Partida=P.ID_Partida
  WHERE P.Tipo_Partida='Clasificatoria'
),
AllJug AS (
  -- Obtiene todos los IDs de jugadores existentes
  SELECT DISTINCT ID_Jugador FROM Jugadores
),
JugNoClas AS (
  -- Identifica jugadores que nunca han jugado partidas clasificatorias
  SELECT ID_Jugador FROM AllJug
  EXCEPT
  SELECT ID_Jugador FROM JugClas
)

-- Consulta final:
-- 1. Toma jugadores con victorias
-- 2. Que además hayan jugado partidas normales (INTERSECT)
-- 3. Excluye a los que nunca han jugado clasificatorias (EXCEPT)
SELECT ID_Jugador
FROM JugVictoria
INTERSECT
SELECT ID_Jugador FROM JugNormal
EXCEPT
SELECT ID_Jugador FROM JugNoClas;

ROLLBACK;



--7.2.b. Versión con EXISTS y NOT EXISTS

INSERT INTO Jugadores(ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(1, 'SingleSlayer',    'EU', 2000.00, 55.00, 3.50),
(2, 'ThunderTail',     'NA', 2100.00, 58.00, 3.80),
(3, 'SpokenNightmare', 'EU', 1900.00, 45.00, 2.00),
(4, 'CursedPointer',   'NA', 1700.00, 30.00, 1.80);

INSERT INTO Partidas(ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(1, '2024-12-08 09:00:00', '00:30:00', 'Clasificatoria', 'Victoria', 'Derrota'),
(2, '2024-12-08 10:00:00', '00:25:00', 'Normal', 'Victoria', 'Derrota');

INSERT INTO Equipos(ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(200, 1, 1, 'Victoria'),
(201, 1, 2, 'Derrota'),
(202, 2, 1, 'Victoria'),
(203, 2, 2, 'Derrota');

INSERT INTO Jugadores_Equipos(ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(1, 200, 2050.00),
(1, 202, 1980.00),
(2, 202, 2100.00),
(3, 201, 1800.00),
(4, 203, 1600.00);

-- Versión con EXISTS/NOT EXISTS
SELECT J.ID_Jugador
FROM Jugadores J
WHERE
  -- El jugador debe tener al menos una partida con Victoria
  EXISTS (
    SELECT 1
    FROM Jugadores_Equipos JE
    JOIN Equipos E ON JE.ID_Equipo=E.ID_Equipo
    WHERE JE.ID_Jugador=J.ID_Jugador
      AND E.Resultado='Victoria'
  )
AND
  -- El sjgador debe tener al menos una partida Normal
  EXISTS (
    SELECT 1
    FROM Jugadores_Equipos JE
    JOIN Equipos E ON JE.ID_Equipo=E.ID_Equipo
    JOIN Partidas P ON E.ID_Partida=P.ID_Partida
    WHERE JE.ID_Jugador=J.ID_Jugador
      AND P.Tipo_Partida='Normal'
  )
AND
  -- El jugador NO debe pertenecer a los que no han jugado Clasificatoria
  NOT EXISTS (
    SELECT 1
    FROM Jugadores X
    WHERE X.ID_Jugador=J.ID_Jugador
      AND X.ID_Jugador NOT IN (
        SELECT JE2.ID_Jugador
        FROM Jugadores_Equipos JE2
        JOIN Equipos E2 ON JE2.ID_Equipo=E2.ID_Equipo
        JOIN Partidas P2 ON E2.ID_Partida=P2.ID_Partida
        WHERE P2.Tipo_Partida='Clasificatoria'
      )
  );

ROLLBACK;

/*
Consulta 8. Una consulta con subconsulta correlacionada en el HAVING. Explica el resultado de la 
misma deshaciendo la correlación para una fila que salga en el resultado, y para otra que no salga. 
*/
/*
Consulta 8a. Encontrar jugadores cuya media de Elo_MMR_Partida sea mayor que la media de Elo_MMR_Partida de todos sus rivales.
Explicación:
1. Seleccionamos cada jugador que haya jugado (JOIN con Jugadores_Equipos, Equipos, Partidas).
2. Agrupamos por jugador para calcular su promedio Elo_MMR_Partida.
3. En el HAVING, subconsulta correlacionada (con referencia a j.ID_Jugador):
   - Calcula el promedio de Elo_MMR_Partida de los rivales de ese jugador.
4. Comparamos el promedio del jugador con el promedio de sus rivales.
   Si el promedio del jugador es mayor, el jugador aparece en el resultado.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(1, 'ProGamer', 'NA', 2600.00, 65.00, 3.50),   -- Jugador con alto Elo_MMR en general
(2, 'RivalX', 'NA', 2400.00, 60.00, 3.00),    -- Rival con Elo medio
(3, 'Casual', 'NA', 2200.00, 55.00, 2.50),    -- Rival con Elo más bajo
(4, 'Mediocre', 'NA', 2300.00, 58.00, 2.80);  -- Jugador con Elo algo más bajo que RivalX
INSERT INTO Partidas (ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(101, '2025-01-01', '00:30:00', 'Normal', 'Victoria', 'Derrota'),
(102, '2025-01-02', '00:35:00', 'Normal', 'Derrota', 'Victoria'),
(103, '2025-01-03', '00:32:00', 'Normal', 'Victoria', 'Derrota'),
(104, '2025-01-04', '00:40:00', 'Normal', 'Victoria', 'Derrota');
INSERT INTO Equipos (ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(201, 101, 1, 'Victoria'),
(202, 101, 2, 'Derrota'),
(203, 102, 1, 'Derrota'),
(204, 102, 2, 'Victoria'),
(205, 103, 1, 'Victoria'),
(206, 103, 2, 'Derrota'),
(207, 104, 1, 'Victoria'),
(208, 104, 2, 'Derrota');
INSERT INTO Jugadores_Equipos (ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
-- ProGamer
(1, 201, 2601.00), -- Partida 101
(1, 204, 2602.00), -- Partida 102
-- RivalX (Elo en partida ~2401, 2402)
(2, 202, 2401.00), -- Partida 101
(2, 203, 2402.00), -- Partida 102
-- Casual (Elo en partida ~2201, 2202)
(3, 205, 2201.00), -- Partida 103
(3, 206, 2202.00), -- Partida 103
-- Mediocre (Elo en partida ~2301, 2302)
(4, 207, 2301.00), -- Partida 104
(4, 208, 2302.00); -- Partida 104

-- ProGamer (1) tiene como rivales a RivalX (2)
INSERT INTO Jugadores_Rivales (ID_Jugador, ID_Jugador_Rival) VALUES (1, 2);
-- RivalX (2) tiene como rival a Casual (3)
INSERT INTO Jugadores_Rivales (ID_Jugador, ID_Jugador_Rival) VALUES (2, 3);
-- Mediocre (4) tiene como rival a RivalX (2)
INSERT INTO Jugadores_Rivales (ID_Jugador, ID_Jugador_Rival) VALUES (4, 2);

SELECT j.ID_Jugador, j.Nombre_usuario
FROM Jugadores j
JOIN Jugadores_Equipos je ON j.ID_Jugador = je.ID_Jugador
JOIN Equipos eq ON je.ID_Equipo = eq.ID_Equipo
JOIN Partidas pa ON eq.ID_Partida = pa.ID_Partida
GROUP BY j.ID_Jugador, j.Nombre_usuario
HAVING AVG(je.Elo_MMR_Partida) > (
    SELECT AVG(je2.Elo_MMR_Partida)
    FROM Jugadores_Rivales jr
    JOIN Jugadores_Equipos je2 ON jr.ID_Jugador_Rival = je2.ID_Jugador
    WHERE jr.ID_Jugador = j.ID_Jugador
);
/*
Jugador que SÍ sale en el resultado: ProGamer (ID=1)
Promedio Elo_MMR_Partida de ProGamer: 2601.5
Rivales de ProGamer: Solo RivalX (ID=2)
Promedio de RivalX: (2401 + 2402)/2 = 2401.5 La condición: 2601.5 > 2401.5 se cumple, ProGamer aparece.
*/

SELECT AVG(je.Elo_MMR_Partida)
FROM Jugadores_Equipos je
WHERE je.ID_Jugador = 1;  -- (ProGamer)

SELECT AVG(je2.Elo_MMR_Partida)
FROM Jugadores_Rivales jr
JOIN Jugadores_Equipos je2 ON jr.ID_Jugador_Rival = je2.ID_Jugador
WHERE jr.ID_Jugador = 1; -- rivales de ProGamer (RivalX)


/*
Jugador que NO sale en el resultado: Mediocre (ID=4)
Promedio Elo_MMR_Partida de Mediocre: (2301 + 2302)/2 = 2301.5
Rival de Mediocre: RivalX (ID=2) con promedio 2401.5 Comparamos: 2301.5 > 2401.5 es FALSO, por lo tanto Mediocre no aparece.
*/
SELECT AVG(je2.Elo_MMR_Partida)
FROM Jugadores_Rivales jr
JOIN Jugadores_Equipos je2 ON jr.ID_Jugador_Rival = je2.ID_Jugador
WHERE jr.ID_Jugador = 4; -- rivales de Mediocre (RivalX)
ROLLBACK;


/*
Consulta 8.b.
Consulta con subconsulta correlacionada en el HAVING:
Encontrar los equipos cuya media de Elo_MMR_Partida es mayor que la media de Elo_MMR_Partida 
de todos los equipos en la misma partida.
Explicación:
1. Agrupamos por equipo (ID_Equipo).
2. Calculamos la media de Elo_MMR_Partida de los jugadores de cada equipo.
3. En el HAVING, subconsulta correlacionada:
   - Se usa eq.ID_Partida de la consulta externa para filtrar equipos de la misma partida.
   - Calculamos la media general de Elo_MMR_Partida de todos los equipos de esa partida.
4. Comparamos si la media del equipo actual es mayor que la media general.
*/
INSERT INTO Jugadores (ID_Jugador, Nombre_usuario, Region, Elo_MMR, Porcentaje_Victorias, Promedio_KDA)
VALUES
(700, 'TeamLeader', 'NA', 2500.00, 60.00, 3.00),
(701, 'SupportHero', 'NA', 2400.00, 58.00, 2.80),
(702, 'CarryStar', 'NA', 2600.00, 65.00, 3.50),
(703, 'OffLane', 'NA', 2300.00, 55.00, 2.70);
-- Insertamos una partida con dos equipos
INSERT INTO Partidas (ID_Partida, Fecha, Duracion, Tipo_Partida, Resultado_Equipo1, Resultado_Equipo2)
VALUES
(2000, '2025-05-01', '00:35:00', 'Clasificatoria', 'Victoria', 'Derrota');
-- Insertamos los dos equipos de la partida
-- Equipo 1 (Ganador)
INSERT INTO Equipos (ID_Equipo, ID_Partida, Equipo_Numero, Resultado)
VALUES
(3000, 2000, 1, 'Victoria'),
(3001, 2000, 2, 'Derrota');
-- Asociamos jugadores a los equipos
-- Equipo 1 (3000) tendrá jugadores con Elo_MMR_Partida altos
INSERT INTO Jugadores_Equipos (ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(700, 3000, 2505.00),
(702, 3000, 2610.00); -- Este jugador sube la media del equipo 1
-- Equipo 2 (3001) tendrá jugadores con Elo_MMR_Partida más bajos
INSERT INTO Jugadores_Equipos (ID_Jugador, ID_Equipo, Elo_MMR_Partida)
VALUES
(701, 3001, 2405.00),
(703, 3001, 2305.00);

SELECT eq.ID_Equipo
FROM Equipos eq
JOIN Jugadores_Equipos je ON eq.ID_Equipo = je.ID_Equipo
GROUP BY eq.ID_Equipo, eq.ID_Partida
HAVING AVG(je.Elo_MMR_Partida) > (
    SELECT AVG(je2.Elo_MMR_Partida)
    FROM Equipos eq2
    JOIN Jugadores_Equipos je2 ON eq2.ID_Equipo = je2.ID_Equipo
    WHERE eq2.ID_Partida = eq.ID_Partida
);

/*
Jugador que SÍ sale en el resultado: ProGamer (ID=1) 
Promedio Elo_MMR_Partida de ProGamer: 2601.5 
Rivales de ProGamer: Solo RivalX (ID=2) 
Promedio de RivalX: (2401 + 2402)/2 = 2401.5 
La condición: 2601.5 > 2401.5 se cumple, ProGamer aparece.
*/
SELECT AVG(je.Elo_MMR_Partida)
FROM Jugadores_Equipos je
WHERE je.ID_Jugador = 1;  -- (ProGamer)

SELECT AVG(je2.Elo_MMR_Partida)
FROM Jugadores_Rivales jr
JOIN Jugadores_Equipos je2 ON jr.ID_Jugador_Rival = je2.ID_Jugador
WHERE jr.ID_Jugador = 1; -- rivales de ProGamer (RivalX)

/*
Jugador que NO sale en el resultado: Mediocre (ID=4)
Promedio Elo_MMR_Partida de Mediocre: (2301 + 2302)/2 = 2301.5 
Rival de Mediocre: RivalX (ID=2) con promedio 2401.5 
Comparamos: 2301.5 > 2401.5 es FALSO, por lo tanto Mediocre no aparece.
*/
SELECT AVG(je.Elo_MMR_Partida)
FROM Jugadores_Equipos je
WHERE je.ID_Jugador = 4; -- Mediocre

SELECT AVG(je2.Elo_MMR_Partida)
FROM Jugadores_Rivales jr
JOIN Jugadores_Equipos je2 ON jr.ID_Jugador_Rival = je2.ID_Jugador
WHERE jr.ID_Jugador = 4; -- rivales de Mediocre (RivalX)
ROLLBACK;
