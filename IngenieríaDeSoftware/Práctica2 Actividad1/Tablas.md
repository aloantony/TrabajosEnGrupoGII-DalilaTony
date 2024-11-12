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

### Tabla de Requerimientos Funcionales

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

### TAbla 2.
| Nº Req. Funcional | Tipo Relación Binaria/Ternaria | Conjunto de Dato 1 | Cardinalidad del conjunto de Datos 2 con el Conj. Datos 1 | Asociación/Relación         | Cardinalidad del conjunto de Datos 1 con el Conj. Datos 2 | Conjunto de Dato 2 | Conjunto de Dato 3 |
|--------------------|--------------------------------|---------------------|-----------------------------------------------------------|-----------------------------|-----------------------------------------------------------|---------------------|--------------------|
| RF-1.a             | Binaria                       | Empleados           | N    | Colaboran en reparaciones        | N    | Automóviles         |                |
| RF-1.b             | Ternaria                      | Empleados           |      | Tiempo dedicado a reparaciones   |      | Reparaciones        | Automóviles    |
| RF-1.c             | Binaria                       | Empleados           |      | Sueldo por hora                  |      |                     |                |
| RF-1.d             | Binaria                       | Empleados           |      | Subordinado-Jefe                 |      | Empleados           |                |
| RF-2.a             | Binaria                       | Reparaciones        | N    | Tiempo total de reparación       | 1    | Automóviles         |                |
| RF-2.b             | Binaria                       | Reparaciones        | N    | Coste total de reparación        | 1    | Automóviles         |                |
| RF-3.a             | Ternaria                      | Empleados           |      | Número de reparaciones           |      | Reparaciones        | Automóviles    |
| RF-3.b             | Ternaria                      | Empleados           |      | Fechas de reparación             |      | Reparaciones        | Automóviles    |
| RF-4.a             | Binaria                       | Piezas              | N    | Piezas en automóviles            | 1    | Automóviles         |                |
| RF-4.b             | Binaria                       | Proveedores         | N    | Suministran piezas               | N    | Piezas              |                |
| RF-4.c             | Binaria                       | Proveedores         | N    | Precio por pieza                 | N    | Piezas              |                |
| RF-4.d             | Ternaria                      | Empleados           |      | Pedidos piezas bajo stock mínimo |      | Proveedore          | Piezas         |
| RF-5.a             | Binaria                       | Clientes            | 1    | Fechas de alquiler de automóviles| N    | Automóviles         |                |
| RF-5.b             | Binaria                       | Clientes            | 1    | Compra de automóviles            | N    | Automóviles         |                |
| RF-5.c             | Binaria                       | Clientes            | 1    | Importe de compra                | 1    | Automóviles         |                |
| RF-5.d             | Binaria                       | Automóviles         | 1    | Garaje de almacenamiento         | N    | Garajes             |                |

# PREGUNTAR EN EL FORO

