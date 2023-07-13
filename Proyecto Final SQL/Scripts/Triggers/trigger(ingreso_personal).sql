Create Table auditoria_tr_personal(
id_tr int not null auto_increment Primary Key,
id_area int , 
nombre text, 
apellido text, 
dni varchar(255), 
email varchar(255),
fecha_accion datetime,
usuario varchar (255),
accion varchar (255)
 );
 
 delimiter //
CREATE TRIGGER tr_registros_ingresos_personal_AI
AFTER INSERT ON personal
	FOR EACH ROW
		BEGIN
			INSERT INTO auditoria_tr_personal (id_area, nombre, apellido, dni, email, fecha_accion, usuario, accion)
			VALUES (NEW.id_area, NEW.nombre, NEW.apellido, NEW.dni, NEW.email, CURRENT_TIMESTAMP(), SYSTEM_USER(), 'insert');
		END;
//
delimiter ;

-- codigo sp ( codigo de sp para probar el trigers)
-- call proyectofinal.sp_Insertar_personal(2, 'PABLO', 'Alessandrini', '32973376', '1987-09-08', '2022-01-01', 'Buena vista 537', 'Rio Cuarto', 'Cordoba', 'Argentina', 'pablo.alessandrini@argentina.com');
-- checkeo
select*from auditoria_tr_personal;