-- Verficacion de usuario 1 Sobre la Tabla Proyecto Final
-- Condicion del Usuario 1:
-- Uno de los usuarios creados deberá tener permisos de sólo lectura sobre todas las tablas(ergo no tiene que funcionar insercion ni update, ni delete).

-- el permiso de lectura funciona perfecto
use proyecto_final;
select*from areas;
select*from compras;

--  valido que no funcione insercion   (validado)

Insert into areas(descripcion) values('Contador');
insert into compras(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta)
	   values(1,2,'2021-08-11',6,2,12714);

-- -- valido que no funcione udpate  (validado)
-- prueba de actualizacion de id_area=1 de Administrativo a Administrativo Junior

Update areas set descripcion='Admistrativo Junior'
where id_area=1;

-- prueba de cambiar un nombre de un vendedor cuando el id=1
update vendedores set nombre='Pablo', apellido='Alessandrini'
where id_vendedor=1;


-- valido que no funcione delete (validado)
-- eliminar desde la tabla areas, cuando la descripcion sea Administrativo
Delete from areas 
Where descripcion='Admistrativo';

-- eliminar desde la tabla vendedores cuando la descripcion sea Maria
Delete from vendedores
where nombre='Maria';