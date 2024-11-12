### Tabla 1. Requerimientos Funcionales

| Nº Req. Funcional | Descripción                                                                                                                 |
|--------------------|-----------------------------------------------------------------------------------------------------------------------------|
| RF-1.1             | Identificar empleados que colaboran en la reparación de cada automóvil.                                                     |
| RF-1.2             | Registrar tiempo dedicado por cada empleado en la reparación de cada automóvil.                                             |
| RF-1.3             | Registrar sueldo por hora de cada empleado.                                                                                 |
| RF-1.4             | Identificar subordinados y jefe de cada empleado.                                                                           |
| RF-2.1             | Calcular tiempo total requerido en la reparación de cada automóvil.                                                         |
| RF-2.2             | Calcular coste total de la reparación de cada automóvil.                                                                    |
| RF-3.1             | Determinar el número de veces que un empleado ha participado en la reparación de un mismo automóvil.                        |
| RF-3.2             | Registrar fechas en que un empleado ha participado en la reparación de un mismo automóvil.                                  |
| RF-4.1             | Identificar piezas de cada automóvil, su cantidad y color.                                                                  |
| RF-4.2             | Registrar proveedores que suministran cada pieza (varios posibles por pieza).                                                |
| RF-4.3             | Registrar precio que cada proveedor cobra por pieza.                                                                         |
| RF-4.4             | Generar pedidos automáticos a proveedores cuando el stock de piezas esté bajo.                                              |
| RF-5.1             | Registrar clientes que alquilan automóviles y las fechas de cada alquiler por cliente.                                       |
| RF-5.2             | Registrar compradores de automóviles, permitiendo múltiples compradores para un mismo automóvil.                             |
| RF-5.3             | Registrar importe de compra de cada automóvil por cada comprador.                                                            |
| RF-5.4             | Registrar el garaje donde se almacena cada automóvil, permitiendo múltiples automóviles por garaje.                          |

### TAbla 2.
| Nº Req. Funcional | Tipo Relación Binaria/Ternaria | Conjunto de Dato 1 | Cardinalidad del conjunto de Datos 2 con el Conj. Datos 1 | Asociación/Relación              | Cardinalidad del conjunto de Datos 1 con el Conj. Datos 2 | Conjunto de Dato 2 | Conjunto de Dato 3 |
|--------------------|--------------------------------|---------------------|-----------------------------------------------------------|----------------------------------|-----------------------------------------------------------|---------------------|--------------------|
| RF-1.1             | Binaria                       | Empleados           | N:N                                                       | Colaboran en la reparación       | N:N                                                       | Automóviles         | None               |
| RF-1.2             | Terciaria                     | Empleados           | None                                                      | Tiempo dedicado a reparación     | None                                                      | Automóviles         | Horas              |
| RF-1.3             | Binaria                       | Empleados           | 1:1                                                       | Sueldo por hora                  | 1:1                                                       | Sueldo              | None               |
| RF-1.4             | Binaria                       | Empleados           | N:N                                                       | Subordinado-Jefe                 | N:N                                                       | Empleados           | None               |
| RF-2.1             | Binaria                       | Automóviles         | 1:1                                                       | Tiempo total de reparación       | 1:1                                                       | Automóviles         | None               |
| RF-2.2             | Binaria                       | Automóviles         | 1:1                                                       | Coste total de reparación        | 1:1                                                       | Automóviles         | None               |
| RF-3.1             | Binaria                       | Empleados           | N:N                                                       | Participación en reparaciones    | N:N                                                       | Automóviles         | None               |
| RF-3.2             | Terciaria                     | Empleados           | None                                                      | Fechas de participación          | None                                                      | Automóviles         | Fechas             |
| RF-4.1             | Binaria                       | Piezas              | N:N                                                       | Cantidad y color de piezas       | N:N                                                       | Automóviles         | None               |
| RF-4.2             | Binaria                       | Piezas              | N:N                                                       | Proveedores de piezas            | N:N                                                       | Proveedores         | None               |
| RF-4.3             | Binaria                       | Proveedores         | 1:N                                                       | Precio de piezas                 | N:1                                                       | Piezas              | None               |
| RF-4.4             | Binaria                       | Piezas              | 1:N                                                       | Pedidos automáticos              | N:1                                                       | Proveedores         | None               |
| RF-5.1             | Terciaria                     | Clientes            | None                                                      | Alquileres y fechas              | None                                                      | Automóviles         | Fechas             |
| RF-5.2             | Binaria                       | Compradores         | N:N                                                       | Compras múltiples                | N:N                                                       | Automóviles         | None               |
| RF-5.3             | Binaria                       | Automóviles         | 1:N                                                       | Importe de compra                | N:1                                                       | Compradores         | None               |
| RF-5.4             | Binaria                       | Automóviles         | N:N                                                       | Garaje de almacenamiento         | N:N                                                       | Garajes             | None               |




PRUEBA PARA HACER COMMIT