-- fUNCION QUE INGRESANDO EL NUMERO DE COMPRA ME DICE QUE CLIENTE LA HIZO
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `cliente_por_nro_compra`(nro_compra int) RETURNS varchar(50) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	DECLARE cliente_nombre VARCHAR(50);
	SELECT c.nombre INTO cliente_nombre 
	FROM clientes as c 
	INNER JOIN compras as co
    ON co.id_cliente = c.id_cliente 
	WHERE co.id_venta= nro_compra;
	RETURN cliente_nombre;
END$$
DELIMITER ;