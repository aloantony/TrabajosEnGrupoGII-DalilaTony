-- Tabla Provincias
DROP TABLE IF EXISTS Provincias CASCADE;
CREATE TABLE Provincias (
    acronimo VARCHAR(3) PRIMARY KEY,
    nombre VARCHAR(30)
);

DROP TABLE IF EXISTS Ciudades CASCADE;
-- Tabla Ciudades (entidad débil)
CREATE TABLE Ciudades (
    nombreC VARCHAR(20),
    provincia VARCHAR(3),
    PRIMARY KEY (nombreC, provincia),
    FOREIGN KEY (provincia) REFERENCES Provincias(acronimo) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Formas_de_Pago CASCADE;
-- Tabla Formas de Pago
CREATE TABLE Formas_de_Pago (
    nombreFP VARCHAR(40) PRIMARY KEY,
    descripcion VARCHAR(50)
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
    provincia VARCHAR(3),
    FOREIGN KEY (nombreC, provincia) REFERENCES Ciudades(nombreC, provincia),
    FOREIGN KEY (forma_pago_defecto) REFERENCES Formas_de_Pago(nombreFP)
);

DROP TABLE IF EXISTS Clientes_Formas_Pago_Autorizados CASCADE;
-- Tabla intermedia para la relación muchos a muchos (Clientes, Formas_de_Pago)
CREATE TABLE Clientes_Formas_Pago_Autorizados (
    CIF VARCHAR(9),
    nombreFP VARCHAR(40),
    PRIMARY KEY (CIF, nombreFP),
    FOREIGN KEY (CIF) REFERENCES Clientes(CIF) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (nombreFP) REFERENCES Formas_de_Pago(nombreFP) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Comerciales CASCADE;
-- Tabla Comerciales
CREATE TABLE Comerciales (
    dni VARCHAR(9) PRIMARY KEY,
    nombre VARCHAR(30),
    ape1 VARCHAR(30),
    ape2 VARCHAR(30),
    e_mail VARCHAR(50),
    tlfno NUMERIC(9)
);

DROP TABLE IF EXISTS tipos_clientes CASCADE;
-- Tabla Tipos Clientes
CREATE TABLE tipos_clientes (
    nombreTC VARCHAR(20) PRIMARY KEY,
    descripcion VARCHAR(50),
    dniComerciales VARCHAR(9) UNIQUE NOT NULL,
    FOREIGN KEY (dniComerciales) REFERENCES Comerciales(dni)
);

DROP TABLE IF EXISTS cliente_es_tipo CASCADE;
-- Tabla intermedia para la relación muchos a muchos entre Clientes y Tipos de Clientes
CREATE TABLE cliente_es_tipo (
    CIF VARCHAR(9),
    nombreTC VARCHAR(20),
    PRIMARY KEY (CIF, nombreTC),
    FOREIGN KEY (CIF) REFERENCES Clientes(CIF) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (nombreTC) REFERENCES tipos_clientes(nombreTC) ON DELETE CASCADE ON UPDATE CASCADE
);
DROP TABLE IF EXISTS Facturas CASCADE;
-- Tabla Facturas
CREATE TABLE Facturas (
    IDfactura NUMERIC(8),
    CIF VARCHAR(9),
    nombreFP VARCHAR(40),
    fecha DATE,
    PRIMARY KEY (IDfactura, CIF, nombreFP),
    FOREIGN KEY (CIF) REFERENCES Clientes(CIF) ON DELETE CASCADE ON UPDATE CASCADE,
    -- Clientes es la entidad fuerte de la que dependen las facturas.
    FOREIGN KEY (nombreFP) REFERENCES Formas_de_Pago(nombreFP)
);

DROP TABLE IF EXISTS lineas_factura CASCADE;
-- Tabla Líneas de Factura
CREATE TABLE lineas_factura (
    IDfactura NUMERIC(8),
    CIF VARCHAR(9),
    nombreFP VARCHAR(40),
    concepto VARCHAR(50),
    precio_unitario DECIMAL(10,2),
    cantidad INTEGER,
    PRIMARY KEY (IDfactura, CIF, nombreFP, concepto),
    FOREIGN KEY (IDfactura, CIF, nombreFP) REFERENCES Facturas(IDfactura, CIF, nombreFP)
        ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Contactos CASCADE;
-- Tabla Contactos
CREATE TABLE Contactos (
    dniComercial VARCHAR(9),
    CIF VARCHAR(9),
    fecha DATE,
    PRIMARY KEY (dniComercial, CIF, fecha),
    UNIQUE (CIF, fecha),
    FOREIGN KEY (dniComercial) REFERENCES Comerciales(dni),
    FOREIGN KEY (CIF) REFERENCES Clientes(CIF)
);

DROP TABLE IF EXISTS colores CASCADE;
-- Tabla Colores
CREATE TABLE colores (
    nombreC VARCHAR(20) PRIMARY KEY,
    R NUMERIC(3),
    G NUMERIC(3),
    B NUMERIC(3)
);

DROP TABLE IF EXISTS productos CASCADE;
-- Tabla Productos
CREATE TABLE productos (
    referenciaFamilia VARCHAR(20),
    familia VARCHAR(30),
    color VARCHAR(20),
    FOREIGN KEY (color) REFERENCES colores(nombreC),
    PRIMARY KEY (referenciaFamilia, familia, color)
);

DROP TABLE IF EXISTS pedidos CASCADE;
-- Tabla Pedidos
CREATE TABLE pedidos (
    nro_pedido NUMERIC(8) PRIMARY KEY,
    CIFClientePorContacto VARCHAR(9),
    CIFclienteSinContacto VARCHAR(9),
    dniComercial VARCHAR(9),
    fecha DATE,
    tieneContacto BOOLEAN NOT NULL,
    FOREIGN KEY (CIFClienteSinContacto) REFERENCES Clientes(CIF),
    FOREIGN KEY (dniComercial, CIFClientePorContacto, fecha) REFERENCES Contactos(dniComercial, CIF, fecha),
    CHECK (
        (tieneContacto = TRUE AND CIFClientePorContacto IS NOT NULL 
         AND CIFClienteSinContacto IS NULL AND fecha IS NOT NULL AND dniComercial IS NOT NULL) 
        OR
        (tieneContacto = FALSE AND CIFClientePorContacto IS NULL 
         AND CIFClienteSinContacto IS NOT NULL AND fecha IS NULL AND dniComercial IS NULL)
    )
);

DROP TABLE IF EXISTS productos_pedidos_lineasfacturas CASCADE;
-- Tabla intermedia (Productos, Pedidos, Facturas)
CREATE TABLE productos_pedidos_lineasfacturas (
    referenciaFamilia VARCHAR(20),
    familia VARCHAR(30),
    color VARCHAR(20),
    IDfactura NUMERIC(8),
    CIF VARCHAR(9),
    nombreFP VARCHAR(40),
    concepto VARCHAR(50),
    nro_pedido NUMERIC(8),
    PRIMARY KEY (referenciaFamilia, familia, color, IDfactura, CIF, nombreFP, concepto),
    UNIQUE (IDfactura, CIF, nombreFP, concepto, nro_pedido),
    UNIQUE (nro_pedido, referenciaFamilia, familia, color),
    FOREIGN KEY (referenciaFamilia, familia, color) REFERENCES productos(referenciaFamilia, familia, color),
    FOREIGN KEY (IDfactura, CIF, nombreFP, concepto) REFERENCES lineas_factura(IDfactura, CIF, nombreFP, concepto),
    FOREIGN KEY (nro_pedido) REFERENCES pedidos(nro_pedido)
);