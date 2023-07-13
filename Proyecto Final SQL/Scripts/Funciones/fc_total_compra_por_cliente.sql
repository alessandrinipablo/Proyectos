-- Funciones 
-- Funcion que calcula el monto total (suma de todas las compras) que hizo  un cliente (iNGRESANDO EL NUMERO DE CLIENTE )
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `calcular_total_compras`(cliente INT) RETURNS float
    DETERMINISTIC
BEGIN
	DECLARE monto_total FLOAT;
    SELECT SUM(monto_venta) INTO monto_total FROM compras WHERE id_cliente = cliente;
    RETURN monto_total;
END$$
DELIMITER ;