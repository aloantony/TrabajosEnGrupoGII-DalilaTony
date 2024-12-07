CREATE TABLE Paises (
    nombre_pais VARCHAR(25) PRIMARY KEY,
    nombre_corto VARCHAR(20) UNIQUE
);

CREATE TABLE Ciudades (
    nombre_ciudad VARCHAR(40) PRIMARY KEY,
    nombre_pais VARCHAR(25) NOT NULL,
    FOREIGN KEY (nombre_pais) REFERENCES Paises(nombre_pais)
);

CREATE TABLE Equipos (
    nombre VARCHAR(100) UNIQUE NOT NULL,
    nombre_corto VARCHAR(5) PRIMARY KEY,
    tipo_equipo VARCHAR(20) NOT NULL CHECK (tipo_equipo IN ('club','seleccion')),
	genero VARCHAR(15) NOT NULL CHECK (genero IN ('masculin','femenin')),
    nombre_pais VARCHAR(100) NOT NULL,
    nombre_ciudad VARCHAR(100),
    FOREIGN KEY (nombre_pais) REFERENCES Paises(nombre_pais),
    FOREIGN KEY (nombre_ciudad) REFERENCES Ciudades(nombre_ciudad)
);

CREATE TABLE Jugadores (
    id_jugador INTEGER PRIMARY KEY,
    nombre_deportivo VARCHAR(25),
    nombre_completo VARCHAR(100),
    estatura NUMERIC(4,2),
    peso NUMERIC(5,2),
    importe NUMERIC(15,2),
    fecha_final_contrato DATE
);

CREATE TABLE FichasJugadorEquipo (
    nombre_equipo VARCHAR(5),
    id_jugador VARCHAR(100),
    PRIMARY KEY (nombre_equipo, id_jugador, ano),
    FOREIGN KEY (nombre_equipo) REFERENCES Equipos(nombre_corto),
    FOREIGN KEY (id_jugador) REFERENCES Jugadores(id_jugador),
);

CREATE TABLE Competiciones (
    nombre_competicion VARCHAR(100),
	ano SMALLINT,
    genero VARCHAR(20) NOT NULL CHECK (genero IN ('masculin','femenin')),
    tipo_competicion VARCHAR(20) NOT NULL CHECK (tipo_competicion IN ('clubes','naciones')),
    nacional_internacional VARCHAR(20) CHECK ((tipo_competicion = 'clubes' AND nacional_internacional IN ('nacional','internacional'))
        OR (tipo_competicion = 'naciones' AND nacional_internacional IS NULL)),
    version_de VARCHAR(100),
	PRIMARY KEY (nombre_competicion, ano),
	FOREIGN KEY (ano) REFERENCES Temporadas(ano),
    FOREIGN KEY (version_de) REFERENCES Competiciones(nombre_competicion)
);

CREATE TABLE Inscripciones_JugadorEquipoCompeticion (
    id_jugador INTEGER,
    nombre_equipo VARCHAR(200),
    nombre_competicion VARCHAR(200),
    ano SMALLINT,
    fecha_alta DATE NOT NULL,
    fecha_baja DATE,
    PRIMARY KEY (id_jugador, nombre_equipo, nombre_competicion, ano),
    FOREIGN KEY (id_jugador) REFERENCES FichasJugadorEquipo(id_jugador),
    FOREIGN KEY (nombre_equipo) REFERENCES Equipos(nombre_corto),
    FOREIGN KEY (nombre_competicion, ano) REFERENCES Competiciones(nombre_competicion, ano)
);

CREATE TABLE Temporadas (
    ano SMALLINT PRIMARY KEY
);

CREATE TABLE Jornadas_Fases (
    nombre_jornada_fase VARCHAR(100),
    nombre_competicion VARCHAR(100),
    ano INTEGER,
    PRIMARY KEY (nombre_jornada_fase, nombre_competicion, ano),
    FOREIGN KEY (nombre_competicion, ano) REFERENCES Competiciones(nombre_competicion, ano)
);

CREATE TABLE Partidos (
    id_partido INTEGER PRIMARY KEY,
    fecha DATE NOT NULL,
    nombre_equipo_local VARCHAR(200) NOT NULL,
    nombre_equipo_visitante VARCHAR(200) NOT NULL,
    id_equipo_arbitral INTEGER NOT NULL,
    resultado_local INTEGER,
    resultado_visitante INTEGER,
    tipo_partido VARCHAR(20) NOT NULL CHECK (tipo_partido IN ('amistoso','competitivo')),
    nombre_jornada_fase VARCHAR(100),
    nombre_competicion VARCHAR(200),
    ano INTEGER,
    FOREIGN KEY (nombre_equipo_local) REFERENCES Equipos(nombre),
    FOREIGN KEY (nombre_equipo_visitante) REFERENCES Equipos(nombre),
    FOREIGN KEY (nombre_jornada_fase, nombre_competicion, ano) REFERENCES Jornadas_Fases(nombre_jornada_fase, nombre_competicion, ano)
    FOREIGN KEY (id_equipo_arbitral) REFERENCES Equipo_Arbitral(id_equipo_arbitral)
);

CREATE TABLE Arbitros (
    id_arbitro INTEGER,
    nombre VARCHAR(100),
    nacionalidad VARCHAR(100),
    PRIMARY KEY (id_arbitro),	
);

CREATE TABLE Roles_Arb (
    rol VARCHAR(50) PRIMARY KEY,
);

CREATE TABLE Equipo_Arbitral (
    id_equipo_arbitral INTEGER PRIMARY KEY,
    id_partido INTEGER UNIQUE NOT NULL REFERENCES Partidos(id_partido)
);

CREATE TABLE ArbitrosRol (
    id_arbitro INTEGER,
    id_equipo_arbitral INTEGER,
    rol VARCHAR(50),
    PRIMARY KEY (id_arbitro, id_equipo_arbitral, rol),
    FOREIGN KEY (id_equipo_arbitral) REFERENCES Equipo_Arbitral(id_equipo_arbitral),
    FOREIGN KEY (id_arbitro) REFERENCES Arbitros(id_arbitro),
    FOREIGN KEY (rol) REFERENCES Roles_Arb(rol)
);

CREATE TABLE Tipos_Lance (
    id_tipo_lance INTEGER PRIMARY KEY,
);

CREATE TABLE Lances (
    id_lance INTEGER PRIMARY KEY,
    id_partido INTEGER NOT NULL,
    id_tipo_lance INTEGER NOT NULL,
    momento_lance TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comentario VARCHAR(500),
    id_jugador INTEGER,
    id_arbitro INTEGER,
    FOREIGN KEY (id_partido) REFERENCES Partidos(id_partido),
    FOREIGN KEY (id_tipo_lance) REFERENCES Tipos_Lance(id_tipo_lance),
    FOREIGN KEY (id_jugador) REFERENCES Jugadores(id_jugador),
    FOREIGN KEY (id_arbitro) REFERENCES Arbitros(id_arbitro)
);
