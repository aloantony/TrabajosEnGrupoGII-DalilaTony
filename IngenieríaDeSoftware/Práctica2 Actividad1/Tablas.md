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
| **R1.a**          | Los empleados que colaboran juntos en la reparación de cada automóvil.                           |
| **R1.b**          | El tiempo dedicado por cada empleado en la reparación de cada automóvil.                         |
| **R1.c**          | El sueldo por hora que cobra cada empleado.                                                      |
| **R1.d**          | Por cada empleado, conocer qué empleados tiene como subordinados y qué empleado es su jefe.      |
| **R2.a**          | El tiempo total requerido en la reparación de cada automóvil.                                    |
| **R2.b**          | El coste total de la reparación de cada automóvil.                                               |
| **R3.a**          | El número de veces que un mismo empleado ha participado en la reparación de un mismo automóvil.  |
| **R3.b**          | Todas las fechas en que un mismo empleado ha participado en la reparación de un mismo automóvil. |
| **R4.a**          | Las piezas de cada automóvil, la cantidad de cada una y su color.                                |
| **R4.b**          | Los proveedores que suministran cada pieza, con la posibilidad de varios proveedores por pieza.  |
| **R4.c**          | El precio al que cada proveedor suministra cada pieza.                                           |
| **R4.d**          | Hacer pedidos de piezas a proveedores cuando estén bajo el stock mínimo.                         |
| **R5.a**          | Los clientes que alquilan cada automóvil y las fechas en que lo han hecho.                       |
| **R5.b**          | Los compradores que han comprado automóviles, considerando compras compartidas.                  |
| **R5.c**          | El importe de compra de cada automóvil por cada persona compradora.                              |
| **R5.d**          | El garaje en el que está almacenado cada automóvil, con posibilidad de más de un automóvil por garaje. |

### TAbla 2.
| Nº Req. Funcional | Tipo Relación Binaria/Ternaria | Conjunto de Dato 1 | Cardinalidad del conjunto de Datos 2 con el Conj. Datos 1 | Asociación/Relación         | Cardinalidad del conjunto de Datos 1 con el Conj. Datos 2 | Conjunto de Dato 2 | Conjunto de Dato 3 |
|--------------------|--------------------------------|---------------------|-----------------------------------------------------------|-----------------------------|-----------------------------------------------------------|---------------------|--------------------|
| RF-1.1             | Binaria                       | Empleados           | N:N    | Colaboran en reparaciones   | N:N | Reparaciones        |                |
| RF-1.2             | Ternaria                      | Empleados           |        | Tiempo dedicado a reparaciones |      | Reparaciones        | Automóviles    |
| RF-1.3             | Binaria                       | Empleados           | 1:1    | Sueldo por hora             | 1:1     | Sueldo              |                |
| RF-1.4             | Binaria                       | Empleados           | N:1    | Subordinado-Jefe            | 1:N     | Empleados           |                |
| RF-2.1             | Binaria                       | Reparaciones        | 1:N    | Tiempo total de reparación  | N:1     | Automóviles         |                |
| RF-2.2             | Binaria                       | Reparaciones        | 1:N    | Coste total de reparación   | N:1     | Automóviles         |                |
| RF-3.1             | Ternaria                      | Empleados           |        | Participan en reparaciones  |         | Reparaciones        | Automóviles    |
| RF-3.2             | Ternaria                      | Empleados           |        | Fechas de participación     |         | Reparaciones        | Fechas         |
| RF-4.1             | Binaria                       | Piezas              | 1:N    | Utiliza piezas en automóviles | 1:1     | Automóviles       |                |
| RF-4.2             | Binaria                       | Proveedores         | 1:N    | Suministran piezas          | N:1     | Piezas              |                |
| RF-4.3             | Binaria                       | Proveedores         | 1:N    | Precio por pieza            | N:1     | Piezas              |                |
| RF-4.4             | Binaria                       | Reparaciones        | 1:N    | Pedidos automáticos         | N:1     | Proveedores         |                |
| RF-5.1             | Ternaria                      | Clientes            | None   | Alquiler de automóviles     | None    | Automóviles         | Fechas         |
| RF-5.2             | Binaria                       | Clientes            | 1:N    | Compra de automóviles       | N:1     | Automóviles         |                |
| RF-5.3             | Binaria                       | Clientes            | 1:N    | Importe de compra           | N:1     | Automóviles         |                |
| RF-5.4             | Binaria                       | Automóviles         | N:N    | Garaje de almacenamiento    | N:N     | Garajes             |                |




