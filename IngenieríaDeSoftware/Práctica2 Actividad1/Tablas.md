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
| Nº Req. Funcional | Tipo Relación Binaria/Ternaria | Conjunto de Dato 1 | Asociación/Relación         | Conjunto de Dato 2 | Conjunto de Dato 3 |
|--------------------|--------------------------------|---------------------|-----------------------------|---------------------|--------------------|
| RF-1.1             | Binaria                       | Empleados           | Colaboran en reparaciones   | Reparaciones        | None               |
| RF-1.2             | Ternaria                      | Empleados           | Tiempo dedicado a reparaciones | Reparaciones        | Automóviles        |
| RF-1.3             | Binaria                       | Empleados           | Sueldo por hora             | Sueldo              | None               |
| RF-1.4             | Binaria                       | Empleados           | Subordinado-Jefe            | Empleados           | None               |
| RF-2.1             | Binaria                       | Reparaciones        | Tiempo total de reparación  | Automóviles         | None               |
| RF-2.2             | Binaria                       | Reparaciones        | Coste total de reparación   | Automóviles         | None               |
| RF-3.1             | Ternaria                      | Empleados           | Participan en reparaciones  | Reparaciones        | Automóviles        |
| RF-3.2             | Ternaria                      | Empleados           | Fechas de participación     | Reparaciones        | Fechas             |
| RF-4.1             | Ternaria                      | Piezas              | Utiliza piezas en automóviles | Reparaciones       | Automóviles        |
| RF-4.2             | Binaria                       | Proveedores         | Suministran piezas          | Piezas              | None               |
| RF-4.3             | Binaria                       | Proveedores         | Precio por pieza            | Piezas              | None               |
| RF-4.4             | Binaria                       | Reparaciones        | Pedidos automáticos         | Proveedores         | None               |
| RF-5.1             | Ternaria                      | Clientes            | Alquiler de automóviles     | Automóviles         | Fechas             |
| RF-5.2             | Binaria                       | Clientes            | Compra de automóviles       | Automóviles         | None               |
| RF-5.3             | Binaria                       | Clientes            | Importe de compra           | Automóviles         | None               |
| RF-5.4             | Binaria                       | Automóviles         | Garaje de almacenamiento    | Garajes             | None               |