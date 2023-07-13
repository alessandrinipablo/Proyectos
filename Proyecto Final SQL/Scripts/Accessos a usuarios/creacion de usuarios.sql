Use proyecto_final;
DROP USER 'usuario1'@'localhost';
DROP USER 'usuario2'@'localhost';
-- Creo el primer usuario con permiso de lectura  (usuario1)
CREATE USER 'usuario1'@'localhost' IDENTIFIED BY 'usuario1';

-- creo el usuario que puede leer, insertar y modificar (usuario2)
CREATE USER 'usuario2'@'localhost' IDENTIFIED BY 'usuario2';

-- verifico que los dos usuarios fueron creados correctamente
SELECT user FROM mysql.user WHERE user = 'usuario1';
SELECT user FROM mysql.user WHERE user = 'usuario2';

-- otorgo permiso al usuario1 que se solo de lectura (select)
GRANT SELECT ON *.* TO 'usuario1'@'localhost';

-- otorgo los permiso de lectura, insercion y modificacion (select, insert, update)
GRANT SELECT, INSERT, UPDATE ON *.* TO 'usuario2'@'localhost';

-- verifico que los permisos sean tal cual los cree
 SHOW GRANTS FOR 'usuario1'@'localhost';
 SHOW GRANTS FOR 'usuario2'@'localhost';
 
 -- le aclaro que no otorge permisos de eliminado ( me aseguro que no lo tenga)
 REVOKE DELETE ON *.* FROM 'usuario1'@'localhost';
 REVOKE DELETE ON *.* FROM 'usuario2'@'localhost';

-- vuelvo a verificar los permisos, al no estar delete, no tiene el permiso
 SHOW GRANTS FOR 'usuario1'@'localhost';
 SHOW GRANTS FOR 'usuario2'@'localhost';
 
 