-- Procecimiento Almacenado que ordena la tabla segun tres parametros que voy a pasar
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ordenamiento`(
    -- parametros que ingreso 
    IN nombre_tabla VARCHAR(50), -- > nombre de la tabla que voy a reordenar
    IN columna_ordenar VARCHAR(50), -- > columna que elijo para ordenar 
    IN tipo_orden VARCHAR(4) -- > tipo de orden  asc o desc
)
BEGIN
    -- concanteno lo que obtuve para crear el Order by 
    SET @accion = CONCAT('SELECT * FROM ',nombre_tabla, ' ORDER BY ', columna_ordenar, ' ', tipo_orden);
    PREPARE stmt FROM @accion;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;