-- En la primera tabla, si tiene registros, deberás eliminar algunos de ellos iniciando previamente una transacción. 
-- Si no tiene registros la tabla, reemplaza eliminación por inserción.
-- Deja en una línea siguiente, comentado la sentencia Rollback, y en una línea posterior, la sentencia Commit.
-- Si eliminas registros importantes, deja comenzado las sentencias para re-insertarlos.
Start Transaction;
-- que contiene (datos)
describe areas;
-- leo que tiene la tabla
select*from areas;
-- verifico si tiene algun registro
select count(*)from areas;
-- ELIMINO EL AREA 6
delete from areas
where id_area=6;
-- INSERTO DATOS
insert into areas(descripcion) values ('Programador Junior');
insert into areas(descripcion) values ('Programador Semi-Senior');
insert into areas(descripcion) values ('Programador Senior');
insert into areas(descripcion) values ('Data Analitics');
insert into areas(descripcion) values ('Data Science');
insert into areas(descripcion) values ('Data Enginier');
-- VERIFICO LA INSERCION DE DATOS  SI FUE EXITOSA
SELECT*FROM AREAS;
-- VUELVO PARA ATRAS LA INSERCION
ROLLBACK;
-- CONFIRMO LA TRANSACCION
COMMIT;
