- Creacion de Triggers numero 2
-- creacion de la tabla Auditoria que tratara sobre cambio de clientes a cargo
-- Esta pensado que ante una actualizacion de los clientes que tienen a cargo los vendedores, se dispare el mensaje del cambio.
-- (Puede ser pensado desde el punto de vista gerencial, ya que si un cliente compra mucho en la tienda, el cambio sea 
-- sospecho de vendedor a vendedor)
-- aca creo la tabla auditoria donde van a registrar los cambios
--
Create Table auditoria_tr_cambio_clientes_a_cargo(
id_tr int not null auto_increment Primary Key,
nombre varchar(255),
id_vendedor int not null,  -- > id vendedor viejo
mail varchar(255),
nuevo_id_vendedor int not null, -- > id vendedor nuevo
usuario varchar(255), 
fecha_accion datetime,
accion varchar(255)
 );
DELIMITER //

-- Trigger que se dispara cuando se actualiza la tabla cliente, y va a guardar
-- el id viejo y el actualizado.
CREATE TRIGGER tr_registros_cambios_cliente_vendedor_BU
BEFORE UPDATE ON CLIENTES
	FOR EACH ROW
	BEGIN
		INSERT INTO auditoria_tr_cambio_clientes_a_cargo 
					(nombre, id_vendedor, mail, nuevo_id_vendedor, fecha_accion, usuario, accion)
		VALUES      (OLD.nombre, OLD.id_vendedor, OLD.mail, NEW.id_vendedor, CURRENT_TIMESTAMP(), SYSTEM_USER(), 'update');
	END;
//
DELIMITER ;
