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

Todas las partes izquierdas de todas las dependencias son claves.

Dependencias:



*/

