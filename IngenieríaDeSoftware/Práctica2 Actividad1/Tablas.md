# Enunciado:

---

**A continuación se indica un contexto sobre el que modelar una serie de requerimientos funcionales: Un taller en el que se realizan reparaciones, ventas y compras de los automóviles.**

**Tarea 1:** Se pide modelar, separadamente, uno a uno los siguientes Requisitos Funcionales, rellenando para ello las Tablas pedidas. Cada Requerimiento puede dar lugar a una o más filas en cada una de las 3 tablas.iu0jp
1. **R1.** Se desea conocer/modelar los hechos:
   a) Los empleados que colaboran juntos en la reparación de cada automóvil, sabiendo que un mismo empleado puede participar en la reparación de varios automóviles.  
   b) El tiempo dedicado por cada empleado en la reparación de cada automóvil.  
   c) El sueldo por hora que cobra cada empleado.  
   d) Por cada empleado: conocer qué empleados tiene como subordinados, y qué empleado es su jefe.

2. **R2.** Partiendo de lo anterior se desea poder conocer:  
   a) El tiempo total requerido en la reparación de cada automóvil.  
   b) El coste total de la reparación de cada automóvil.

3. **R3.** Partiendo de lo anterior, se desea conocer:  
   a) El número de veces que un mismo empleado ha participado en la reparación de un mismo automóvil.  
   b) Todas las fechas en que un mismo empleado ha participado en la reparación de un mismo automóvil.

4. **R4.** Se desea conocer los hechos:  
   a) Las diferentes piezas de cada automóvil y la cantidad que hay de cada una de ellas en cada automóvil, así como el color de cada pieza sabiendo que cada una es de un único color de entre varios posibles.  
   b) Los proveedores que suministran cada una de las piezas sabiendo que una misma pieza puede ser suministrada por varios proveedores.  
   c) Saber el precio al que cada proveedor suministra cada pieza.  
   d) Sobre el apartado b, se deben hacer pedidos a los proveedores de las piezas que estén bajo stock mínimo.

5. **R5.** Se desea conocer:  
   a) Los clientes que toman en alquiler cada automóvil, y todas las fechas en que un mismo cliente haya tomado en alquiler un mismo automóvil.  
   b) Los compradores que han comprado automóviles, sabiendo que una misma persona puede haber comprado varios automóviles, y que un automóvil puede haber sido comprado entre varias personas.  
   c) El importe de compra de cada automóvil por cada persona compradora.  
   d) Conocer el garaje en el que está almacenado cada automóvil de la empresa, sabiendo que en un mismo garaje pueden guardarse más de un automóvil.

--- 

### Tabla 1. Tabla de Requerimientos Funcionales

| **Requerimiento** | **Descripción**                                                                                  |
|-------------------|--------------------------------------------------------------------------------------------------|
| **R1.a**          | Los empleados que colaboran juntos en la reparación de cada automóvil, sabiendo que un mismo empleado puede participar en la reparación de varios automóviles. |
| **R1.b**          | El tiempo dedicado por cada empleado en la reparación de cada automóvil.                         |
| **R1.c**          | El sueldo por hora que cobra cada empleado.                                                      |
| **R1.d**          | Por cada empleado: conocer qué empleados tiene como subordinados, y qué empleado es su jefe.     |
| **R2.a**          | El tiempo total requerido en la reparación de cada automóvil.                                     |
| **R2.b**          | El coste total de la reparación de cada automóvil.                                               |
| **R3.a**          | El número de veces que un mismo empleado ha participado en la reparación de un mismo automóvil.  |
| **R3.b**          | Todas las fechas en que un mismo empleado ha participado en la reparación de un mismo automóvil. |
| **R4.a**          | Las diferentes piezas de cada automóvil y la cantidad que hay de cada una de ellas en cada automóvil, así como el color de cada pieza sabiendo que cada una es de un único color de entre varios posibles. |
| **R4.b**          | Los proveedores que suministran cada una de las piezas sabiendo que una misma pieza puede ser suministrada por varios proveedores. |
| **R4.c**          | Saber el precio al que cada proveedor suministra cada pieza.                                     |
| **R4.d**          | Sobre el apartado b, se deben hacer pedidos a los proveedores de las piezas que estén bajo stock mínimo. |
| **R5.a**          | Los clientes que toman en alquiler cada automóvil, y todas las fechas en que un mismo cliente haya tomado en alquiler un mismo automóvil. |
| **R5.b**          | Los compradores que han comprado automóviles, sabiendo que una misma persona puede haber comprado varios automóviles, y que un automóvil puede haber sido comprado entre varias personas. |
| **R5.c**          | El importe de compra de cada automóvil por cada persona compradora.                              |
| **R5.d**          | Conocer el garaje en el que está almacenado cada automóvil de la empresa, sabiendo que en un mismo garaje pueden guardarse más de un automóvil. |

### Tabla 2. Tabla de asociaciones entre los conjuntos de datos con sus cardinalidades
| Nº Req. Funcional | Tipo Relación Binaria/Ternaria | Conjunto de Dato 1 | Cardinalidad del conjunto de Datos 2 con el Conj. Datos 1 | Asociación/Relación         | Cardinalidad del conjunto de Datos 1 con el Conj. Datos 2 | Conjunto de Dato 2 | Conjunto de Dato 3 |
|--------------------|--------------------------------|---------------------|-----------------------------------------------------------|-----------------------------|-----------------------------------------------------------|---------------------|--------------------|
| RF-1.a             | Binaria                       | Empleados           | N    | Colaboran en reparaciones        | N    | Reparaciones        |                |
| RF-1.b             | Binaria                      | Empleados           | N     | Tiempo empleado en reparaciones   | N     | Reparaciones        |                 |
| RF-1.c             |                               | Empleados           |      | Sueldo por hora                  |      |                     |                |
| RF-1.d             | Binaria                       | Empleados (jefes)   | 1     | Subordinado-Jefe                 | N     | Empleados (subordinados)|                |
| RF-2.a             | Binaria                       | Reparaciones        | N    | Tiempo total de reparación       | 1    | Automóviles         |                |
| RF-2.b             | Binaria                       | Reparaciones        | N    | Coste total de reparación        | 1    | Automóviles         |                |
| RF-3.a             | Binaria                      | Empleados           | N     | Participan en un número de reparaciones en un coche           | N     | Reparaciones        |                |
| RF-3.b             | Ternaria                      | Empleados           |      | Fechas de reparación             |      | Reparaciones        | Automóviles    |
| RF-4.a             | Binaria                       | Piezas              | N    | Piezas en automóviles            | 1    | Automóviles         |                |
| RF-4.b             | Binaria                       | Proveedores         | N    | Suministro de piezas             | N    | Piezas              |                |
| RF-4.c             | Binaria                       | Proveedores         | N    | Precio por pieza                 | N    | Piezas              |      |
| RF-4.d             | Ternaria                      | Piezas           |      | Pedidos piezas bajo stock mínimo |      | Proveedores         | Pedido suministro         |
| RF-5.a             | Ternaria                      | Clientes            |      | Fechas de alquiler de automóviles|      | Automóviles         | Alquileres     |
| RF-5.b             | Binaria                       | Clientes            | N    | Compra de automóviles            | N    | Automóviles         |                |
| RF-5.c             | Binaria                      | Clientes            | N     | Importe de compra                | N      | Automóviles         |         |
| RF-5.d             | Binaria                       | Automóviles         | N    | Garaje de almacenamiento         | 1    | Garajes             |                |

### Tabla 3.
| Nº Req. Funcional | Conjunto de Datos 1                                        | Conjunto de Datos 2                                      | Conjunto de Datos 3                                                          |
|--------------------|------------------------------------------------------------|----------------------------------------------------------|------------------------------------------------------------------------------|
| RF-1.a             | Empleados = {__ID_Empleado__}                              | Automóviles = {__ID_Automovil__}                         |                                                                              |
| RF-1.b             | Empleados = {__ID_Empleado__}                              | Reparaciones = {__ID_Reparacion__, Tiempo}               | Automóviles = {__ID_Automovil__}                                             |
| RF-1.c             | Empleados = {__ID_Empleado__, Sueldo}                      |                                                          |                                                                              |
| RF-1.d             | Empleados = {__ID_Empleado__, ID_Jefe}                     | Empleados = {__ID_Empleado__}                            |                                                                              |
| RF-2.a             | Reparaciones = {__ID_Reparacion__, tiempoReparación}       | Automóviles = {__ID_Automovil__}                         |                                                                              |
| RF-2.b             | Reparaciones = {__ID_Reparacion__, costeReparación}        | Automóviles = {__ID_Automovil__}                         |                                                                              |
| RF-3.a             | Empleados = {__ID_Empleado__}                              | Reparaciones = {__ID_Reparacion__}                       | Automóviles = {__ID_Automovil__}                                             |
| RF-3.b             | Empleados = {__ID_Empleado__}                              | Reparaciones = {__ID_Reparacion__, Fecha}                | Automóviles = {__ID_Automovil__}                                             |
| RF-4.a             | Piezas = {__ID_Pieza_Única__, Nombre_Pieza, Color}         | Automóviles = {__ID_Automovil__}                         |                                                                              |
| RF-4.b             | Proveedores = {__ID_Proveedor__}                           | Piezas = {__ID_Pieza_Única__}                            |                                                                              |
| RF-4.c             | Proveedores = {__ID_Proveedor__}                           | Piezas = {__ID_Pieza_Única__, Pieza}                            | Proveedores_Piezas = {ID_Proveedor, Pieza, Precio}                 |
| RF-4.d             | Piezas = {__ID_Pieza_Única__, Nombre_Pieza, Stock_Actual, Stock_Mínimo} |  Proveedores = {__ID_Proveedor__}                                                                            | Pedido suministros = {ID_Proveedor, Pieza, Cantidad_A_Suministrar, Stock_Actual, Stock_Mínimo} |
| RF-5.a             | Clientes = {__ID_Cliente__}                                | Automóviles = {__ID_Automovil__}                         | Alquileres = {ID_Alquiler, ID_Cliente, ID_Automovil, Fecha_Alquiler}        |
| RF-5.b             | Clientes = {__ID_Cliente__}                                | Automóviles = {__ID_Automovil__}                         | Clientes_Automóviles = {ID_Cliente, ID_Automovil}           |
| RF-5.c             | Clientes = {__ID_Cliente__}  |  Automóviles = {__ID_Automovil__}                                                   |  Compras = {ID_Compra, ID_Cliente, ID_Automovil, Importe_Compra}                                                                            |
| RF-5.d             | Automóviles = {__ID_Automovil__}                           | Garajes = {__ID_Garaje__}                                |                                                                              |

# PREGUNTAR EN EL FORO

