CREATE DATABASE T22C;

\c T22C;
-- Tabla Provincias
CREATE TABLE Provincias (
    acronimo VARCHAR(3) PRIMARY KEY,
    nombre VARCHAR(30)
);

-- Tabla Ciudades (entidad débil)
CREATE TABLE Ciudades (
    nombreC VARCHAR(20),
    provincia VARCHAR(3),
    PRIMARY KEY (nombreC, provincia),
    FOREIGN KEY (provincia) REFERENCES Provincias(acronimo)
);

DROP TABLE IF EXISTS Formas_de_Pago CASCADE;
-- Tabla Formas de Pago
CREATE TABLE Formas_de_Pago (
    nombreFP VARCHAR(40) PRIMARY KEY,
    descripcion VARCHAR(50)
);

-- Tabla intermedia para la relación muchos a muchos
CREATE TABLE Clientes_Formas_Pago_Autorizados (
    CIF VARCHAR(9),
    nombreFP VARCHAR(50),
    PRIMARY KEY (CIF, nombreFP),
    FOREIGN KEY (CIF) REFERENCES Clientes(CIF),
    FOREIGN KEY (nombreFP) REFERENCES Formas_de_Pago(nombreFP)
);
DROP TABLE IF EXISTS tipos_clientes CASCADE;
-- Tabla Tipos Clientes
CREATE TABLE tipos_clientes (
    nombreTC VARCHAR(20) PRIMARY KEY,
    descripcion VARCHAR(50)
);

-- Tabla intermedia para la relación muchos a muchos entre Clientes y Tipos de Clientes
CREATE TABLE cliente_es_tipo (
    CIF VARCHAR(9),
    nombreTC VARCHAR(20),
    PRIMARY KEY (CIF, nombreTC),
    FOREIGN KEY (CIF) REFERENCES Clientes(CIF),
    FOREIGN KEY (nombreTC) REFERENCES tipos_clientes(nombreTC)
);


DROP TABLE IF EXISTS Clientes CASCADE;
-- Tabla Clientes
CREATE TABLE Clientes (
    CIF VARCHAR(9) PRIMARY KEY,
    telefono NUMERIC(9),
    fax NUMERIC(9),
    email VARCHAR(30),
    nro_cuenta_bancaria VARCHAR(24),
    direccion VARCHAR(80),
    nombre VARCHAR(15),
    forma_pago_defecto VARCHAR(20),
    nombreC VARCHAR(20),
    provincia VARCHAR(20),
    FOREIGN KEY (nombreC, provincia) REFERENCES Ciudades(nombreC, provincia),
    FOREIGN KEY (forma_pago_defecto) REFERENCES Formas_de_Pago(nombreFP)
    );


DROP TABLE IF EXISTS Facturas CASCADE;
    CREATE TABLE Facturas (
        IDfactura NUMERIC(8),
        CIF VARCHAR(9),
        nombreFP VARCHAR(40),
        fecha DATE,
        PRIMARY KEY (IDfactura, CIF, nombreFP),
        FOREIGN KEY (CIF) REFERENCES Clientes(CIF),
        FOREIGN KEY (nombreFP) REFERENCES Formas_de_Pago(nombreFP)
    );

DROP TABLE IF EXISTS lineas_factura CASCADE;
    CREATE TABLE lineas_factura (
        IDfactura NUMERIC(8),
        CIF VARCHAR(9),
        nombreFP VARCHAR(40),
        concepto VARCHAR(50),
        precio_unitario DECIMAL(10,2),
        cantidad INTEGER,
        PRIMARY KEY (IDfactura, CIF, nombreFP, concepto),
        FOREIGN KEY (IDfactura, CIF, nombreFP) REFERENCES Facturas(IDfactura, CIF, nombreFP)
    );

    DROP TABLE IF EXISTS Comerciales CASCADE;
    CREATE TABLE Comerciales (
        dni VARCHAR(9) PRIMARY KEY,
        nombre VARCHAR(30),
        ape1 VARCHAR(30),
        ape2 VARCHAR(30),
        e_mail VARCHAR(50),
        tlfno NUMERIC(9)
    );
DROP TABLE IF EXISTS Contactos CASCADE;
    CREATE TABLE Contactos (
        dniComercial VARCHAR(9),
        CIF VARCHAR(9),
        fecha DATE,
        PRIMARY KEY (dniComercial, CIF, fecha),
        FOREIGN KEY (dniComercial) REFERENCES Comerciales(dni),
        FOREIGN KEY (CIF) REFERENCES Clientes(CIF)
    );

    CREATE TABLE colores (
        nombreC VARCHAR(20) PRIMARY KEY,
        R NUMERIC(3),
        G NUMERIC(3),
        B NUMERIC(3)
    );

CREATE TABLE productos (
    referenciaFamilia VARCHAR(20),
    familia VARCHAR(30),
    color VARCHAR(20),
    FOREIGN KEY (color) REFERENCES colores(nombreC),
    PRIMARY KEY (referenciaFamilia, familia, color)
);