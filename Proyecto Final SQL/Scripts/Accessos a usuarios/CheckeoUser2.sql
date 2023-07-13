-- Verficacion de usuario 2 Sobre la Tabla Proyecto Final
-- Condicion Usuario 2
-- Permisos de Lectura, Inserción y Modificación de datos.

use proyecto_final;
-- verifico la lectura (select)
select*from areas;
select*from compras;

--  valido que funcione insercion   (validado)

Insert into areas(descripcion) values('Contador');
insert into compras(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta)
	   values(1,2,'2021-08-11',6,2,12714);
 
-- Verifico la carga correcta (insercion) (validacion ok)
select*from areas
Where descripcion='Contador';

-- verifico la carga de  la tabla compras (venta 1001)
select*from compras
where id_producto=1 and id_cliente=2 and fecha_venta='2021-08-11' and id_forma_de_pago=6 and forma_compra=2 and monto_venta=12714;

-- verifico que funcione la modificacion de datos

Update areas set descripcion='Admistrativo Junior'
where id_area=1;

-- verifico cambio
select*from areas
where descripcion='Admistrativo Junior';

-- prueba de cambiar un nombre de un vendedor cuando el id=1
update vendedores set nombre='Pablo', apellido='Alessandrini'
where id_vendedor=1;
-- verifico cmabio de vendedor
select*from vendedores
where id_vendedor=1;

-- valido que no funcione delete (validado)
-- eliminar desde la tabla areas, cuando la descripcion sea Administrativo Junior
Delete from areas 
Where descripcion='Admistrativo Junior';

-- eliminar desde la tabla vendedores cuando la descripcion sea Pablo
Delete from vendedores
where nombre='Pablo';