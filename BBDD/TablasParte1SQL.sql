CREATE TABLE Paises (
    nombre_pais VARCHAR(100) PRIMARY KEY,
    nombre_corto VARCHAR(20) UNIQUE
);

CREATE TABLE Ciudades (
    nombre_ciudad VARCHAR(100) PRIMARY KEY,
    nombre_pais VARCHAR(100) NOT NULL,
    FOREIGN KEY (nombre_pais) REFERENCES Paises(nombre_pais)
);

CREATE TABLE Equipos (
    nombre VARCHAR(200) UNIQUE NOT NULL,
    nombre_corto VARCHAR(50) PRIMARY KEY,
    tipo_equipo VARCHAR(20) NOT NULL CHECK (tipo_equipo IN ('club','seleccion')),
	genero VARCHAR(15) NOT NULL CHECK (genero IN ('masculin','femenin')),
    nombre_pais VARCHAR(100) NOT NULL,
    nombre_ciudad VARCHAR(100),
    FOREIGN KEY (nombre_pais) REFERENCES Paises(nombre_pais),
    FOREIGN KEY (nombre_ciudad) REFERENCES Ciudades(nombre_ciudad)
);

CREATE TABLE Jugadores (
    id_jugador INTEGER PRIMARY KEY,
    nombre_deportivo VARCHAR(100),
    nombre_completo VARCHAR(200),
    estatura NUMERIC(4,2),
    peso NUMERIC(5,2),
    importe NUMERIC(15,2),
    fecha_final_contrato DATE
);

CREATE TABLE FichasJugadorEquipo (
    nombre_equipo VARCHAR(200),
    id_jugador VARCHAR(200),
    PRIMARY KEY (nombre_equipo, id_jugador, ano),
    FOREIGN KEY (nombre_equipo) REFERENCES Equipos(nombre_corto),
    FOREIGN KEY (id_jugador) REFERENCES Jugadores(id_jugador),
);

CREATE TABLE Competiciones (
    nombre_competicion VARCHAR(200),
	ano INTEGER,
    genero VARCHAR(20) NOT NULL CHECK (genero IN ('masculin','femenin')),
    tipo_competicion VARCHAR(20) NOT NULL CHECK (tipo_competicion IN ('clubes','naciones')),
    nacional_internacional VARCHAR(20) CHECK ((tipo_competicion = 'clubes' AND nacional_internacional IN ('nacional','internacional'))
        OR (tipo_competicion = 'naciones' AND nacional_internacional IS NULL)),
    competicion_previa VARCHAR(200),
	PRIMARY KEY (nombre_competicion, ano),
	FOREIGN KEY (ano) REFERENCES Temporadas(ano),
    FOREIGN KEY (competicion_previa) REFERENCES Competiciones(nombre_competicion)
);

CREATE TABLE Temporadas (
    ano INTEGER PRIMARY KEY
);

CREATE TABLE Jornadas_Fases (
    nombre_jornada_fase VARCHAR(100),
    nombre_competicion VARCHAR(200),
    ano INTEGER,
    PRIMARY KEY (nombre_jornada_fase, nombre_competicion, ano),
    FOREIGN KEY (nombre_competicion) REFERENCES Competiciones(nombre_competicion),
    FOREIGN KEY (ano) REFERENCES Temporadas(ano)
);

CREATE TABLE Inscripciones_Jugador (
    id_jugador INTEGER,
    nombre_equipo VARCHAR(200),
    nombre_competicion VARCHAR(200),
    ano INTEGER,
    fecha_alta DATE NOT NULL,
    fecha_baja DATE,
    PRIMARY KEY (id_jugador, nombre_equipo, nombre_competicion, ano),
    FOREIGN KEY (id_jugador) REFERENCES Jugadores(id_jugador),
    FOREIGN KEY (nombre_equipo) REFERENCES Equipos(nombre),
    FOREIGN KEY (nombre_competicion) REFERENCES Competiciones(nombre_competicion),
    FOREIGN KEY (ano) REFERENCES Temporadas(ano)
);

CREATE TABLE Partidos (
    id_partido INTEGER PRIMARY KEY,
    fecha DATE NOT NULL,
    resultado_local INTEGER,
    resultado_visitante INTEGER,
    nombre_equipo_local VARCHAR(200) NOT NULL,
    nombre_equipo_visitante VARCHAR(200) NOT NULL,
    tipo_partido VARCHAR(20) NOT NULL CHECK (tipo_partido IN ('amistoso','competitivo')),
    nombre_jornada_fase VARCHAR(100),
    nombre_competicion VARCHAR(200),
    ano INTEGER,
    FOREIGN KEY (nombre_equipo_local) REFERENCES Equipos(nombre),
    FOREIGN KEY (nombre_equipo_visitante) REFERENCES Equipos(nombre),
    FOREIGN KEY (nombre_jornada_fase, nombre_competicion, ano) REFERENCES Jornadas_Fases(nombre_jornada_fase, nombre_competicion, ano)
);

CREATE TABLE Arbitros (
    id_arbitro INTEGER PRIMARY KEY,
    nombre VARCHAR(200),
    nacionalidad VARCHAR(100)
);

CREATE TABLE Roles_Arb (
    rol VARCHAR(50) PRIMARY KEY,
    descripcion VARCHAR(200)
);

CREATE TABLE Equipo_Arbitral (
    id_partido INTEGER,
    id_arbitro INTEGER,
    rol VARCHAR(50),
    PRIMARY KEY (id_partido, id_arbitro, rol),
    FOREIGN KEY (id_partido) REFERENCES Partidos(id_partido),
    FOREIGN KEY (id_arbitro) REFERENCES Arbitros(id_arbitro),
    FOREIGN KEY (rol) REFERENCES Roles_Arb(rol)
);

CREATE TABLE Tipos_Lance (
    id_tipo_lance INTEGER PRIMARY KEY,
    descripcion VARCHAR(200)
);

CREATE TABLE Lances (
    id_lance INTEGER PRIMARY KEY,
    id_partido INTEGER NOT NULL,
    id_tipo_lance INTEGER NOT NULL,
    minuto INTEGER NOT NULL,
    segundo INTEGER NOT NULL,
    comentario VARCHAR(500),
    id_jugador INTEGER,
    id_arbitro INTEGER,
    FOREIGN KEY (id_partido) REFERENCES Partidos(id_partido),
    FOREIGN KEY (id_tipo_lance) REFERENCES Tipos_Lance(id_tipo_lance),
    FOREIGN KEY (id_jugador) REFERENCES Jugadores(id_jugador),
    FOREIGN KEY (id_arbitro) REFERENCES Arbitros(id_arbitro)
);