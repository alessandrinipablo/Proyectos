-- Script Proyecto Final -- 

-- Codigo--
-- cree un esquema  donde alojo la base
create schema proyectoFinal;

use proyectofinal;
-- CREACION DE TABLAS
    -- Ejecuto estas que son las que no tienen foraneas en ella/s.
    -- tabla de los medios de pago que efectuan los clientes
    Create Table Medios_de_Pago(
		id_formas_de_pago  int not null auto_increment primary KEY,
		descripción varchar(255)
    );
    
    -- tabla de las formas de compras (web o presencial)
    create table forma_compra (
id_forma_compra	INT AUTO_INCREMENT PRIMARY KEY,
descripcion varchar (100)
);

-- tabla con las categorias de productos
create table productos (
id_productos INT AUTO_INCREMENT PRIMARY KEY,
descripcion varchar (100)
);

-- tabla con la areas de trabajos
create table areas (
id_area INT AUTO_INCREMENT PRIMARY KEY,
descripcion varchar (255)
);

-- TABLA PERSONAL 
Create Table Personal(
    id_personal int not null auto_increment primary KEY,
    id_area int not null ,
    nombre text,
    apellido text,
    dni varchar(255),
    fecha_nacimiento date,
    fecha_ingreso date,
    direccion varchar(255),
    localidad varchar(255),
    provincia varchar(255),
    pais varchar(255),
    email varchar(255)
); 
-- tabla vendedores
-- Tabla que va a detallar los vendedores de la empresa.
-- y AGREGO LA fk que la referencio con  tabla personal.
Create Table Vendedores(
	id_vendedor int not null auto_increment primary KEY,
	id_personal int not null ,
	FOREIGN KEY (id_personal) REFERENCES Personal(id_personal),
	nombre text,
	apellido text
);

-- tabla que detalla los datos de los clientes
-- y agrego las foranea que se referencia con vendedores.
Create Table Clientes(
	id_cliente int not null auto_increment primary KEY,
	fecha_alta date,
	nombre varchar(255),
	direccion text	,
	id_vendedor int not null,
    FOREIGN KEY (id_vendedor) REFERENCES Vendedores(id_vendedor),
	localidad varchar(255),
	provincia varchar(255),
	país varchar(255),
	telefono varchar(255), 
	mail varchar(255),
	contacto_personal varchar(255),
	usuario_web varchar(255)
    );
    
    --  detalle de las compras hechas por los clientes
    --  agrego las FK que referencio con clientes (id_cliente)
    --  con productos (id_producto)
    --  con medios de pago (id_forma_de_pago)producto
    --  con  forma_compra(id_forma_compra)
    Create Table compras(
		id_venta int not null auto_increment primary KEY,
		id_producto	int not null, 
		id_cliente  int not null,
        FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
        foreign key (id_producto) references productos (id_productos),
        fecha_venta date,
		id_forma_de_pago int not null,
        FOREIGN KEY (id_forma_de_pago) REFERENCES Medios_de_Pago(id_formas_de_pago),
		forma_compra int not null,
        FOREIGN KEY (forma_compra ) REFERENCES forma_compra(id_forma_compra),
		monto_venta float
    );
    
    -- CREACION DE LAS 5 VISTAS-- 
    
-- creacion de vista numero 1
-- Creo una vista que me muestra la cantidad de compras hechas en base a la forma(web/presencial)
CREATE VIEW vw_cant_compras_forma AS
select  fc.descripcion, 
		count(id_producto) as cantidad_compras
from compras as co
inner join forma_compra as fc
on co.forma_compra=fc.id_forma_compra
group by fc.descripcion;

-- creacion de vista numero 2
-- creo una venta que me muestre las cantidad de ventas hechas por producto(NOMBRE)
CREATE VIEW vw_ventas_por_producto AS
SELECT p.descripcion as Producto, sum(co.monto_venta) as total_ventas
FROM compras as co
inner join productos as p
on co.id_producto=p.id_productos
group by p.descripcion ;

-- creacion de vista numero 3
-- Vista que saca la cantidad de clientes a cargo que tiene cada vendedor, para luego sacar un promedio de cuanto tienen cada uno, 
-- y al final mostrar los que estan por debajo.

create view vw_vendedores_bajos as 
select Concat(v.nombre,'',v.apellido) as Vendedor,
	   count(c.id_cliente) as cantidad_clientes_a_cargo
from vendedores as v
inner join clientes as c
on v.id_vendedor=c.id_vendedor
group by Concat(v.nombre,'',v.apellido)
Having count(c.id_cliente) <
        (
			Select Truncate(avg(cantidad_clientes),0) as promedio_CxV 
			from
			(
			 select concat(v.nombre,' ',v.apellido)as nombre_vendedor,
				   count(c.id_cliente) cantidad_clientes
			 from vendedores as v
			 inner join clientes as c
			 on v.id_vendedor=c.id_vendedor
			 group by concat(v.nombre,' ',v.apellido)
			 )
			  AS SUBCONSULTA
			  );
              
-- vista numero 4
-- cuento la cantidad de personas por area que hay para luego mostrarla con su descripcion, y
-- ver el porcentaje sobre el total
select*from personal;
create view vw_personas_por_areas as
	SELECT p.id_area,
		   a.descripcion as Area_empresa,
		   COUNT(*) AS cantidad_personas,
		   ROUND(COUNT(*) / (SELECT COUNT(*) FROM personal) * 100, 1) AS porcentaje
	FROM personal as p
	inner join areas as a
	on p.id_area=a.id_area
	GROUP BY p.id_area
	order by p.id_area ;
    
    
-- vista numero 5
-- muestra los  5 mejores clientes que mas dinero mueven en las compras
create view vw_5_mejores_clientes as
	select cl.nombre as Cliente,
		   sum(co.monto_venta) as total_dinero
	from clientes as cl
	inner join compras as co
	on cl.id_cliente=co.id_cliente
	group by cl.nombre
	order by sum(co.monto_venta) desc
	Limit 5
;

-- Insercion de datos
-- insercion de datos de  la tabla Productos.

insert into productos(descripcion) values ('celulares');
insert into productos(descripcion) values ('computadoras y notebook');
insert into productos(descripcion) values ('bazar');
insert into productos(descripcion) values ('jugueteria');
insert into productos(descripcion) values ('cocinas');
 
-- insercion de datos de  la tabla forma de PAGO
insert into forma_compra (descripcion) values ('web');
insert into forma_compra (descripcion) values ('presencial');

-- insercion de datos de forma de compra
Insert into medios_de_pago (descripción) values ('canje');
Insert into medios_de_pago (descripción) values ('transferencia bancaria');
Insert into medios_de_pago (descripción) values ('tarjeta de debito');
Insert into medios_de_pago (descripción) values ('tarjeta de credito');
Insert into medios_de_pago (descripción) values ('cheque');
Insert into medios_de_pago (descripción) values ('efectivo');

-- insercion de datos sobre la tabla Areas
Insert into areas (descripcion) values ('Administrativo');
Insert into areas (descripcion) values ('Vendedores');
Insert into areas (descripcion) values ('Operarios Deposito');
Insert into areas (descripcion) values ('Programadores');
Insert into areas (descripcion) values ('Repartidores');

-- insercion de datos de la tabla personal
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' Beatriz',' Herrera',' 20103681','1981-01-28','2020-04-21',' Avenida 9 de Julio ',' Puerto Madryn','Buenos Aires','Argentina',' Beatriz. Herrera@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' María',' Fernandez',' 42086520','1996-11-23','2020-04-21',' Calle Lavalle 1500',' La Plata','Mendoza','Argentina',' María. Fernandez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Raúl',' Campos',' 40174516','1992-08-07','2020-06-19',' Avenida Juan B. Jus',' Tandil','Córdoba','Argentina',' Raúl. Campos@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Hugo',' De la Cruz','12390094','2003-12-02','2020-06-20',' Calle Pellegrini 60',' San Carlos Centro','Córdoba','Argentina',' Hugo. De la Cruz@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' Rosa María',' Villegas','26819010','1999-12-05','2020-08-23',' Calle Entre Ríos 80',' Choele Choel','Santa Fe','Argentina',' Rosa María. Villegas@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' Eduardo',' Salas','20697711','1990-07-12','2020-09-05',' Calle Venezuela 200',' Alta Gracia','Córdoba','Argentina',' Eduardo. Salas@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Miguel',' Castro',' 20108047','1981-05-10','2020-04-16',' Calle Perón 1700',' San Carlos de Bariloche','Córdoba','Argentina',' Miguel. Castro@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Laura María',' Valdez','15075024','1984-03-11','2020-06-21','Calle 25 de Mayo 200',' Venado Tuerto','Corrientes','Argentina',' Laura María. Valdez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' Carmen María',' Lara',' 20036823','1973-09-21','2020-02-12',' Calle Alem 800',' General Pico','Santa Fe','Argentina',' Carmen María. Lara@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Rosa',' Aguilar',' 30121467','1980-04-30','2020-09-26',' Avenida Rivadavia 9',' Goya','Santa Fe','Argentina',' Rosa. Aguilar@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' María Isabel',' Chacon','21027950','1977-09-02','2020-10-13',' Calle Mendoza 1700',' San Vicente','Río Negro','Argentina',' María Isabel. Chacon@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Sofía',' Gomez',' 30174575','1981-08-08','2020-06-20',' Calle Reconquista 1',' Mar del Plata','Salta','Argentina',' Sofía. Gomez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Víctor',' Espinoza',' 42081950','1998-09-16','2020-05-21',' Avenida Entre Ríos ',' Lincoln','Córdoba','Argentina',' Víctor. Espinoza@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Inés',' Gallegos','23308320','1990-09-01','2020-07-21',' Calle Uruguay 700',' Río Segundo','Córdoba','Argentina',' Inés. Gallegos@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Borja',' Vasquez','20145049','1989-01-22','2020-07-28','Calle Belgrano 1400',' Monte Caseros','Buenos Aires','Argentina',' Borja. Vasquez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' Laura',' Torres',' 40202017','1990-12-24','2020-05-16',' Calle Tucumán 1000',' Santiago del Estero','Corrientes','Argentina',' Laura. Torres@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Héctor',' Aguirre','16705144','1991-05-02','2020-09-06',' Calle Jujuy 1100',' San Pedro','Santa Fe','Argentina',' Héctor. Aguirre@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Alejandro',' Reyes',' 40177727','1992-09-04','2020-09-12',' Avenida 25 de Mayo ',' Trelew','Santa Fe','Argentina',' Alejandro. Reyes@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Alba',' Quintero',' 20106872','1975-02-19','2020-11-21',' Calle Maipú 1200',' Concepción del Uruguay','Misiones','Argentina',' Alba. Quintero@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Lorena',' Nunez',' 40131895','1988-06-10','2020-03-01',' Calle Lavalleja 500',' Firmat','Río Negro','Argentina',' Lorena. Nunez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Sergio',' Guerrero',' 30090018','1979-10-26','2020-02-13',' Calle Bartolomé Mit',' Jesús María','Córdoba','Argentina',' Sergio. Guerrero@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Teresa',' Cabrera',' 42092272','1999-08-08','2020-08-29',' Avenida Córdoba 600',' San Pedro','Córdoba','Argentina',' Teresa. Cabrera@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Loreto',' Valencia','27667386','1997-02-15','2020-03-29','Calle 9 de Julio 120',' La Rioja','Buenos Aires','Argentina',' Loreto. Valencia@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Guillermo',' Rubio',' 20079477','1974-05-16','2020-12-09',' Calle Alem 100',' Olavarría','Córdoba','Argentina',' Guillermo. Rubio@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Lucía',' Moreno',' 30064299','1983-06-14','2020-09-05',' Avenida Juan B. Jus',' Bahía Blanca','Misiones','Argentina',' Lucía. Moreno@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Ana María',' Cabello',' 30072325','1982-10-19','2020-05-17',' Calle Venezuela 150',' Mercedes','Buenos Aires','Argentina',' Ana María. Cabello@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Paula María',' Rojo',' 40138436','1988-06-29','2020-07-14',' Calle Rodríguez Peñ',' General Cabrera','Buenos Aires','Argentina',' Paula María. Rojo@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Paula',' Ramos',' 30112897','1986-07-16','2020-06-15',' Avenida Entre Ríos ',' Catamarca','Jujuy','Argentina',' Paula. Ramos@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Emilio',' Jurado',' 30118916','1980-03-09','2020-02-20',' Calle Carlos Pelleg',' Cosquín','Neuquén','Argentina',' Emilio. Jurado@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' José',' Rodriguez',' 20065522','1974-02-14','2020-07-29',' Calle Florida 300',' Rosario','Santa Fe','Argentina',' José. Rodriguez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' Santiago',' Escobar','30718902','1976-08-01','2020-05-30',' Calle Rawson 1300',' Plottier','Santa Fe','Argentina',' Santiago. Escobar@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Ignacio',' Castillo',' 40164445','1991-12-22','2020-10-02',' Calle Lavalleja 300',' Villa María','La Pampa','Argentina',' Ignacio. Castillo@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Patricia María',' Santos','10592313','1972-11-01','2020-08-30','Calle 14 3100',' Federal','Santa Fe','Argentina',' Patricia María. Santos@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Carlos',' Gonzalez',' 40264473','1991-09-30','2020-04-30',' Calle San Martín 20',' San Miguel de Tucumán','Buenos Aires','Argentina',' Carlos. Gonzalez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' Olga',' Duran',' 30099453','1984-11-25','2020-02-02',' Calle Montevideo 60',' Reconquista','Buenos Aires','Argentina',' Olga. Duran@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Elena Isabel',' Zavala','27908175','1987-10-01','2020-06-19',' Calle Gobernador Pa',' Gualeguay','Buenos Aires','Argentina',' Elena Isabel. Zavala@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Pablo',' Diaz',' 20033262','1972-12-11','2020-03-26',' Avenida Córdoba 400',' Resistencia','Santiago del Estero','Argentina',' Pablo. Diaz@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Luis Miguel',' Soto','13634292','1982-05-18','2020-01-24','Calle 24 900',' Crespo','Entre Ríos','Argentina',' Luis Miguel. Soto@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Sara',' Carrasco',' 30151136','1984-08-23','2020-10-30',' Calle Bartolomé Mit',' Río Cuarto','San Luis','Argentina',' Sara. Carrasco@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Joaquín',' Ponce',' 40198648','1987-11-28','2020-10-06',' Calle San Luis 3000',' San Jorge','Río Negro','Argentina',' Joaquín. Ponce@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Javier María',' Morales',' 42129311','1997-06-17','2020-02-22',' Calle Florida 1000',' Cutral-Có','Entre Ríos','Argentina',' Javier María. Morales@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Belén',' Gil',' 30105710','1981-07-20','2020-10-04',' Avenida San Juan 35',' Morteros','Córdoba','Argentina',' Belén. Gil@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Jorge',' Benitez',' 40143944','1990-09-13','2020-06-16',' Calle Maipú 800',' Junín','Córdoba','Argentina',' Jorge. Benitez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' Andrea María',' Cortez','22493275','1993-03-01','2020-07-27',' Calle Olavarría 300',' Las Varillas','Santa Fe','Argentina',' Andrea María. Cortez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Enrique',' Vera','13030927','1978-03-14','2020-01-02',' Calle Dorrego 1500',' Bell Ville','Buenos Aires','Argentina',' Enrique. Vera@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' Patricia',' Flores',' 40074581','1988-02-14','2020-03-24',' Calle Carlos Pelleg',' Rafaela','Corrientes','Argentina',' Patricia. Flores@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' Javier',' Jimenez',' 42131613','1998-07-29','2020-08-13',' Calle Uruguay 800',' Paraná','Buenos Aires','Argentina',' Javier. Jimenez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Adrián',' Arias',' 30155271','1986-12-26','2020-12-08',' Calle Rodríguez Peñ',' Villa Carlos Paz','Santa Fe','Argentina',' Adrián. Arias@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Antonio José',' Bustamante','15515947','1996-11-03','2020-04-18',' Calle Lavalle 900',' Cinco Saltos','Buenos Aires','Argentina',' Antonio José. Bustamante@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Guillermo José',' Rojas',' 20122136','1977-11-13','2020-01-13',' Avenida del Liberta',' Tartagal','Santa Fe','Argentina',' Guillermo José. Rojas@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Guillermo Anto',' Franco','19676353','1988-02-02','2020-11-19',' Calle Tucumán 1500',' San José de Feliciano','Santa Fe','Argentina',' Guillermo Anto. Franco@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' David',' Vazquez',' 40189827','1993-03-28','2020-05-06',' Calle Sarmiento 500',' San Luis','Río Negro','Argentina',' David. Vazquez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Ana Belén',' Vargas','27604439','2000-09-30','2020-01-28','Avenida San Martín 2',' Chajarí','Santa Fe','Argentina',' Ana Belén. Vargas@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Elena María',' Ibañez',' 20109828','1979-01-07','2020-02-04',' Calle Balcarce 1800',' San Lorenzo','Chaco','Argentina',' Elena María. Ibañez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' Cristina',' Molina',' 40168581','1992-02-09','2020-09-04',' Calle Florida 800',' San Rafael','Córdoba','Argentina',' Cristina. Molina@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' Óscar',' Sandoval','22131891','1987-06-27','2020-04-04','Avenida de Mayo 500',' Viedma','La Rioja','Argentina',' Óscar. Sandoval@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Ana',' Martinez',' 30032352','1983-03-01','2020-09-19',' Avenida Corrientes ',' Córdoba','Córdoba','Argentina',' Ana. Martinez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Manuel',' Cortes',' 20092262','1976-10-04','2020-06-27',' Avenida Belgrano 50',' Vera','Santa Fe','Argentina',' Manuel. Cortes@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Rocío',' Zepeda','20947852','1994-08-01','2020-11-07',' Calle Intendente Ca',' Santo Tomé','La Rioja','Argentina',' Rocío. Zepeda@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Israel',' Valenzuela','13401651','1984-03-12','2020-07-29','Calle 3 de Febrero 1',' Casilda','Buenos Aires','Argentina',' Israel. Valenzuela@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Carmen',' Perez',' 40197022','1994-05-17','2020-05-02',' Avenida Santa Fe 30',' Santa Fe','Tucumán','Argentina',' Carmen. Perez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Diego',' Leon',' 99976555','1970-11-08','2020-03-18',' Avenida San Juan 25',' Jujuy','Entre Ríos','Argentina',' Diego. Leon@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Aitana',' Peña',' 42037803','1995-05-09','2020-12-12',' Avenida Santa Fe 70',' Villa Dolores','Córdoba','Argentina',' Aitana. Peña@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Marta',' Romero',' 20113848','1979-01-18','2020-05-17',' Avenida Paseo Colón',' San Juan','Chaco','Argentina',' Marta. Romero@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Nerea',' Mora',' 30105898','1986-01-30','2020-08-03',' Avenida Corrientes ',' Rawson','Santa Fe','Argentina',' Nerea. Mora@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' Iván',' Garrido',' 30105931','1981-11-08','2020-05-20',' Avenida Jujuy 1300',' Bell Ville','Neuquén','Argentina',' Iván. Garrido@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Nuria',' Rios',' 30099503','1983-11-18','2020-03-08',' Calle San Luis 2000',' Chivilcoy','Buenos Aires','Argentina',' Nuria. Rios@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Fernando',' Silva',' 30100018','1984-03-06','2020-10-26',' Calle Balcarce 600',' Villa Mercedes','Córdoba','Argentina',' Fernando. Silva@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Julia',' Nieto',' 20071735','1977-02-15','2020-08-03',' Avenida del Liberta',' Gualeguaychú','Santa Fe','Argentina',' Julia. Nieto@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Esther',' Rivera',' 30125331','1983-12-22','2020-03-18',' Calle Salta 1500',' San Antonio Oeste','Santa Fe','Argentina',' Esther. Rivera@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Isabel',' Serrano',' 30192651','1985-06-01','2020-01-04',' Calle Paraguay 1500',' Neuquén','Entre Ríos','Argentina',' Isabel. Serrano@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Ana Paula',' Dominguez','23844481','1985-12-08','2020-12-11',' Calle Quintana 1800',' Presidencia Roque Sáenz Peña','Chubut','Argentina',' Ana Paula. Dominguez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Andrea',' Munoz',' 30117918','1986-04-03','2020-01-25',' Avenida Belgrano 30',' Formosa','San Luis','Argentina',' Andrea. Munoz@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Rubén',' Hurtado',' 42118187','1999-02-05','2020-04-12',' Calle Defensa 1200',' Esquel','Buenos Aires','Argentina',' Rubén. Hurtado@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Rafael',' Espinosa',' 40095568','1988-07-20','2020-06-28',' Avenida Corrientes ',' Caleta Olivia','Chubut','Argentina',' Rafael. Espinosa@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Jorge Alberto',' Yanez','19183961','1983-04-27','2020-07-31',' Calle Formosa 1200',' La Paz','Córdoba','Argentina',' Jorge Alberto. Yanez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' Clara',' Salazar','29679868','1999-02-23','2020-02-15',' Avenida Juan B. Jus',' Villa Regina','Buenos Aires','Argentina',' Clara. Salazar@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Martina',' Calvo',' 40194391','1993-09-24','2020-02-12',' Avenida Pueyrredón ',' Santa Rosa','Chaco','Argentina',' Martina. Calvo@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Antonio',' Sanchez',' 40169724','1990-09-05','2020-11-28',' Avenida Callao 600',' Salta','San Juan','Argentina',' Antonio. Sanchez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Arturo',' Guzman','30718789','1995-04-02','2020-11-17',' Avenida Alvear 2000',' Fraile Pintado','Buenos Aires','Argentina',' Arturo. Guzman@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Carla','Hernandez','24673875','1982-11-01','2020-11-14',' Avenida Pueyrredón ',' San José de Jáchal','Córdoba','Argentina',' Carla.Hernandez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Lucas',' Chavez','30221803','1986-06-01','2020-04-25',' Calle Neuquén 1200',' San Javier','Santa Fe','Argentina',' Lucas. Chavez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Claudia',' Navarro',' 20015083','1977-01-27','2020-05-02',' Avenida Jujuy 800',' Comodoro Rivadavia','Chubut','Argentina',' Claudia. Navarro@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Ana Isabel',' Vega','25111678','1984-02-25','2020-11-04',' Calle Chacabuco 700',' Chacabuco','Entre Ríos','Argentina',' Ana Isabel. Vega@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' José Luis',' Pardo',' 20083446','1978-12-28','2020-07-07',' Avenida Rivadavia 1',' Cipolletti','Salta','Argentina',' José Luis. Pardo@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Ángel',' Montes',' 40072631','1986-09-19','2020-01-27',' Avenida 9 de Julio ',' Eldorado','Río Negro','Argentina',' Ángel. Montes@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Luis',' Lopez',' 30138057','1996-01-10','2020-03-01',' Avenida Rivadavia 5',' Mendoza','Santa Fe','Argentina',' Luis. Lopez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Silvia',' Fuentes',' 20104448','1983-12-26','2020-03-06',' Calle Perú 800',' Venado Tuerto','Buenos Aires','Argentina',' Silvia. Fuentes@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Daniel',' Medina',' 20003211','1993-09-26','2020-02-03',' Avenida Santa Fe 50',' San Francisco','Santa Fe','Argentina',' Daniel. Medina@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (1,' Juan',' Garcia',' 20010597','1993-02-27','2020-01-20',' Avenida 9 de Julio ',' Buenos Aires','Buenos Aires','Argentina',' Juan. Garcia@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Lorena María',' Blanco','27582617','1982-07-12','2020-02-07',' Calle La Rioja 500',' Firmat','Entre Ríos','Argentina',' Lorena María. Blanco@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Elena',' Ortiz',' 30146053','1975-04-18','2020-10-01',' Calle Defensa 400',' Concordia','Buenos Aires','Argentina',' Elena. Ortiz@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Cristina María',' Flores','24673936','1992-10-17','2020-07-13',' Calle Salta 1000',' Pérez','Chaco','Argentina',' Cristina María. Flores@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Álvaro',' Vega',' 30108673','1972-02-22','2020-12-25',' Calle Salta 1000',' Azul','La Pampa','Argentina',' Álvaro. Vega@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (4,' Pedro',' Ramirez',' 30138675','1981-08-16','2020-11-20',' Avenida Córdoba 800',' Morteros','Entre Ríos','Argentina',' Pedro. Ramirez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Mario',' Ruiz',' 20128999','1985-11-30','2020-03-24',' Avenida del Liberta',' Corrientes','Neuquén','Argentina',' Mario. Ruiz@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (3,' Gonzalo',' Vallejo','18932109','1990-11-10','2020-07-15','Avenida 25 de Mayo 5',' San Justo','Río Negro','Argentina',' Gonzalo. Vallejo@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' Ángela',' Zelaya','24293102','1998-05-16','2020-07-07',' Calle Hipólito Yrig',' Río Colorado','Córdoba','Argentina',' Ángela. Zelaya@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (5,' Francisco',' Alvarez',' 42094712','1987-12-27','2020-04-22',' Avenida Pueyrredón ',' Posadas','Formosa','Argentina',' Francisco. Alvarez@argentina.com');
 INSERT INTO personal(id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email)VALUES (2,' Victoria',' Hidalgo',' 99973961','1993-01-12','2020-12-30',' Avenida 25 de Mayo ',' Río Tercero','Entre Ríos','Argentina',' Victoria. Hidalgo@argentina.com');


-- insercion de datos de la tabla vendedores
Insert into vendedores (id_personal, nombre, apellido) values (2,' María',' Fernandez');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Laura',' Torres');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Javier',' Jimenez');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Patricia',' Flores');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Beatriz',' Herrera');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Cristina',' Molina');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Olga',' Duran');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Iván',' Garrido');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Victoria',' Hidalgo');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Carmen María',' Lara');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Eduardo',' Salas');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Clara',' Salazar');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Óscar',' Sandoval');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Rosa María',' Villegas');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Ángela',' Zelaya');
Insert into vendedores (id_personal, nombre, apellido) values (2,' María Isabel',' Chacon');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Andrea María',' Cortez');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Santiago',' Escobar');
Insert into vendedores (id_personal, nombre, apellido) values (2,' María',' Fernandez');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Laura',' Torres');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Javier',' Jimenez');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Patricia',' Flores');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Beatriz',' Herrera');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Cristina',' Molina');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Olga',' Duran');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Iván',' Garrido');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Victoria',' Hidalgo');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Carmen María',' Lara');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Eduardo',' Salas');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Clara',' Salazar');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Óscar',' Sandoval');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Rosa María',' Villegas');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Ángela',' Zelaya');
Insert into vendedores (id_personal, nombre, apellido) values (2,' María Isabel',' Chacon');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Andrea María',' Cortez');
Insert into vendedores (id_personal, nombre, apellido) values (2,' Santiago',' Escobar');

-- insercion de datos de la tabla clientes
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-04',' Alfa Innovación S.A.',' Av. San Martín 123',11,' Córdoba','Córdoba','Argentina','3512054698',' Alfa Innovación S.A.@clientes.argentina.com',' Ana Torres','@ Alfa Innovación S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-07-03',' Atlántico Soluciones Empresariales S.R.L.',' Calle Belgrano 456',15,' Rosario','Santa Fe','Argentina','3425896325',' Atlántico Soluciones Empresariales S.R.L.@clientes.argentina.com',' Carlos Vega','@ Atlántico Soluciones Empresariales S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-22',' BioTech Systems S.A.',' Av. Corrientes 789',2,' La Plata','Buenos Aires','Argentina','1168569874',' BioTech Systems S.A.@clientes.argentina.com',' Sofia Perez','@ BioTech Systems S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-05-22',' Calidad en Servicios S.R.L.',' Av. Paseo Colón 234',16,' Santa Fe','Córdoba','Argentina','2305489632',' Calidad en Servicios S.R.L.@clientes.argentina.com',' David Hernandez','@ Calidad en Servicios S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-31',' Centro de Comunicación Digital S.A.',' Calle Lavalle 567',18,' Villa María','Córdoba','Argentina','3569842130',' Centro de Comunicación Digital S.A.@clientes.argentina.com',' Laura Castillo','@ Centro de Comunicación Digital S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-05-28',' Conecta Seguros S.R.L.',' Av. Rivadavia 890',15,' San Francisco','Santa Fe','Argentina','3418759632',' Conecta Seguros S.R.L.@clientes.argentina.com',' Juan Santos','@ Conecta Seguros S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-04-01',' Convergencia Tecnológica S.A.',' Calle Reconquista 123',13,' Rafaela','Santa Fe','Argentina','1158963254',' Convergencia Tecnológica S.A.@clientes.argentina.com',' Isabel Rodriguez','@ Convergencia Tecnológica S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-05-17',' Cosmética Natural S.R.L.',' Av. Santa Fe 456',14,' Villa Carlos Paz','Córdoba','Argentina','2479865412',' Cosmética Natural S.R.L.@clientes.argentina.com',' Francisco Chavez','@ Cosmética Natural S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-02-20',' Crece Rápido S.A.',' Calle Uruguay 789',17,' Venado Tuerto','Santa Fe','Argentina','3532147896',' Crece Rápido S.A.@clientes.argentina.com',' Lucía Diaz','@ Crece Rápido S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-08',' Crecimiento Empresarial S.R.L.',' Av. 9 de Julio 234',11,' Río Cuarto','Córdoba','Argentina','3412569843',' Crecimiento Empresarial S.R.L.@clientes.argentina.com',' Eduardo Gutierrez','@ Crecimiento Empresarial S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-01-18',' Creencias y Valores S.A.',' Calle Tucumán 567',10,' San Nicolás de los Arroyos','Buenos Aires','Argentina','1156325478',' Creencias y Valores S.A.@clientes.argentina.com',' Martina Flores','@ Creencias y Valores S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-02-12',' Dataservice S.R.L.',' Av. Callao 890',15,' San Pedro','Santa Fe','Argentina','2305478963',' Dataservice S.R.L.@clientes.argentina.com',' Pedro Valenzuela','@ Dataservice S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-30',' Delphi Consulting S.A.',' Calle Florida 123',14,' Marcos Juárez','Córdoba','Argentina','3578965324',' Delphi Consulting S.A.@clientes.argentina.com',' Paula Cárdenas','@ Delphi Consulting S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-09',' Desarrollo y Futuro S.R.L.',' Av. Libertador 456',14,' Pergamino','Buenos Aires','Argentina','3416985234',' Desarrollo y Futuro S.R.L.@clientes.argentina.com',' Miguel Vargas','@ Desarrollo y Futuro S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-02-28',' Desarrollos Inmobiliarios S.A.',' Calle Sarmiento 789',11,' Junín','Buenos Aires','Argentina','1156982354',' Desarrollos Inmobiliarios S.A.@clientes.argentina.com',' Carmen Rios','@ Desarrollos Inmobiliarios S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-05-11',' Desarrollos Sustentables S.R.L.',' Av. Córdoba 234',10,' Bell Ville','Córdoba','Argentina','2497856321',' Desarrollos Sustentables S.R.L.@clientes.argentina.com',' Daniel Sandoval','@ Desarrollos Sustentables S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-02-14',' Diseño e Innovación S.A.',' Calle Perón 567',10,' Capilla del Monte','Córdoba','Argentina','3548965214',' Diseño e Innovación S.A.@clientes.argentina.com',' Valentina Ortiz','@ Diseño e Innovación S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-13',' Ecológicos del Sur S.R.L.',' Av. Mayo 890',15,' Firmat','Santa Fe','Argentina','3415698742',' Ecológicos del Sur S.R.L.@clientes.argentina.com',' Luisa Miranda','@ Ecológicos del Sur S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-03',' EcoSolutions S.A.',' Calle Alem 123',5,' San Jorge','Santa Fe','Argentina','1169586324',' EcoSolutions S.A.@clientes.argentina.com',' Rafaela Mendoza','@ EcoSolutions S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-23',' Eficiencia Energética S.R.L.',' Av. Cabildo 456',11,' Cañada de Gómez','Santa Fe','Argentina','2325489631',' Eficiencia Energética S.R.L.@clientes.argentina.com',' Jorge Navarro','@ Eficiencia Energética S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-07',' Eléctrica del Centro S.A.',' Calle Balcarce 789',11,' Chajarí','Santa Fe','Argentina','3569587412',' Eléctrica del Centro S.A.@clientes.argentina.com',' Diana Marquez','@ Eléctrica del Centro S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-25',' Emprendimientos Tecnológicos S.R.L.',' Av. Entre Ríos 234',7,' San Lorenzo','Córdoba','Argentina','3418745963',' Emprendimientos Tecnológicos S.R.L.@clientes.argentina.com',' Marco Rojas','@ Emprendimientos Tecnológicos S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-02-09',' Energía Renovable S.A.',' Calle Montevideo 567',1,' Villa María del Río Seco','Santa Fe','Argentina','1158964325',' Energía Renovable S.A.@clientes.argentina.com',' Raquel Benitez','@ Energía Renovable S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-23',' Equipo de Trabajo S.R.L.',' Av. Corrientes 890',9,' San José de la Esquina','Córdoba','Argentina','2479856312',' Equipo de Trabajo S.R.L.@clientes.argentina.com',' Mateo Castillo','@ Equipo de Trabajo S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-04-05',' Espectáculos y Eventos S.A.',' Calle Suipacha 123',6,' Villa Dolores','Córdoba','Argentina','3532148965',' Espectáculos y Eventos S.A.@clientes.argentina.com',' Gisela Aguilar','@ Espectáculos y Eventos S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-26',' Estudio Jurídico S.R.L.',' Av. Santa Fe 456',7,' Arroyito','Santa Fe','Argentina','3412569873',' Estudio Jurídico S.R.L.@clientes.argentina.com',' Mauricio Rosales','@ Estudio Jurídico S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-16',' Experiencia y Calidad S.A.',' Calle Esmeralda 789',1,' Casilda','Córdoba','Argentina','1156325487',' Experiencia y Calidad S.A.@clientes.argentina.com',' Cecilia Guerrero','@ Experiencia y Calidad S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-01-06',' Finanzas Corporativas S.R.L.',' Av. Paseo Colón 234',18,' Santa Rosa de Calamuchita','Córdoba','Argentina','2305478965',' Finanzas Corporativas S.R.L.@clientes.argentina.com',' Julio Hernandez','@ Finanzas Corporativas S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-01-23',' Fortalecimiento Empresarial S.A.',' Calle Tucumán 567',12,' Morteros','Santa Fe','Argentina','3511234567',' Fortalecimiento Empresarial S.A.@clientes.argentina.com',' Daniela Torres','@ Fortalecimiento Empresarial S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-01-30',' Gabinete de Consultores S.R.L.',' Av. San Martín 890',9,' Funes','Córdoba','Argentina','3519876543',' Gabinete de Consultores S.R.L.@clientes.argentina.com',' Hector Ramirez','@ Gabinete de Consultores S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-02-07',' Global Business S.A.',' Calle Florida 123',10,' Río Tercero','Córdoba','Argentina','3515551111',' Global Business S.A.@clientes.argentina.com',' Estefania Guzman','@ Global Business S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-23',' Grupo Industrial S.R.L.',' Av. Rivadavia 456',15,' Jesús María','Santa Fe','Argentina','3518889999',' Grupo Industrial S.R.L.@clientes.argentina.com',' Felipe Espinoza','@ Grupo Industrial S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-23',' Innovación y Desarrollo S.A.',' Calle Perón 789',10,' Reconquista','Santa Fe','Argentina','3514440000',' Innovación y Desarrollo S.A.@clientes.argentina.com',' Adriana Castro','@ Innovación y Desarrollo S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-18',' Inversiones en el Exterior S.R.L.',' Av. Callao 234',5,' San Francisco Solano','Buenos Aires','Argentina','3516663333',' Inversiones en el Exterior S.R.L.@clientes.argentina.com',' Antonio Ortega','@ Inversiones en el Exterior S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-02-06',' IT Solutions S.A.',' Calle Lavalle 567',6,' Marcos Paz','Santa Fe','Argentina','3517778888',' IT Solutions S.A.@clientes.argentina.com',' Monica Ramos','@ IT Solutions S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-02-26',' Laboratorios Biomédicos S.R.L.',' Av. 9 de Julio 890',8,' Gálvez','Córdoba','Argentina','3513332222',' Laboratorios Biomédicos S.R.L.@clientes.argentina.com',' Angelica Dominguez','@ Laboratorios Biomédicos S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-01-16',' Logística y Distribución S.A.',' Calle Uruguay 123',14,' Villa Allende','Córdoba','Argentina','3516667777',' Logística y Distribución S.A.@clientes.argentina.com',' Roberto Hernandez','@ Logística y Distribución S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-01',' Marketing y Comunicación S.R.L.',' Av. Santa Fe 456',4,' Esperanza','Santa Fe','Argentina','3517776666',' Marketing y Comunicación S.R.L.@clientes.argentina.com',' Lorena Chavez','@ Marketing y Comunicación S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-07-03',' Mejora Continua S.A.',' Calle Alem 789',18,' Alta Gracia','Santa Fe','Argentina','3519993333',' Mejora Continua S.A.@clientes.argentina.com',' Guillermo Duarte','@ Mejora Continua S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-05-08',' Mercados Internacionales S.R.L.',' Av. Cabildo 234',12,' Villa Constitución','Córdoba','Argentina','3518881111',' Mercados Internacionales S.R.L.@clientes.argentina.com',' Claudia Salazar','@ Mercados Internacionales S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-14',' Meta Consultora S.A.',' Calle Belgrano 567',3,' Rufino','Santa Fe','Argentina','3515554444',' Meta Consultora S.A.@clientes.argentina.com',' Samuel Sánchez','@ Meta Consultora S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-19',' Nuevas Ideas S.R.L.',' Av. Corrientes 890',6,' Roldán','Córdoba','Argentina','3514445555',' Nuevas Ideas S.R.L.@clientes.argentina.com',' Ivonne Rangel','@ Nuevas Ideas S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-11',' Nuevo Horizonte S.A.',' Calle Reconquista 123',8,' Villa Nueva','Santa Fe','Argentina','3516661111',' Nuevo Horizonte S.A.@clientes.argentina.com',' Rodrigo Perez','@ Nuevo Horizonte S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-02-23',' Obras y Proyectos S.R.L.',' Av. Libertador 456',5,' Brinkmann','Córdoba','Argentina','3517774444',' Obras y Proyectos S.R.L.@clientes.argentina.com',' Natalia Ponce','@ Obras y Proyectos S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-20',' Optimización de Procesos S.A.',' Calle Sarmiento 789',7,' Santo Tomé','Buenos Aires','Argentina','3514448888',' Optimización de Procesos S.A.@clientes.argentina.com',' Ruben Flores','@ Optimización de Procesos S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-05-22',' Organización Empresarial S.R.L.',' Av. Córdoba 234',11,' San Guillermo','Santa Fe','Argentina','3515553333',' Organización Empresarial S.R.L.@clientes.argentina.com',' Marcela Torres','@ Organización Empresarial S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-05-24',' Pegasus Emprendimientos S.A.',' Calle Perón 567',17,' Bell Ville','Buenos Aires','Argentina','3516668888',' Pegasus Emprendimientos S.A.@clientes.argentina.com',' Fernando Vega','@ Pegasus Emprendimientos S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-06',' Planificación Estratégica S.R.L.',' Av. Mayo 890',5,' El Tío','Córdoba','Argentina','3517773333',' Planificación Estratégica S.R.L.@clientes.argentina.com',' Paola Lopez','@ Planificación Estratégica S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-01-11',' Política y Desarrollo S.A.',' Calle Esmeralda 123',13,' Santa Fe','Santa Fe','Argentina','3514449999',' Política y Desarrollo S.A.@clientes.argentina.com',' Emilio Gonzalez','@ Política y Desarrollo S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-02-20',' Proyecciones Empresariales S.R.L.',' Av. Entre Ríos 456',14,' Rosario de la Frontera','Santa Fe','Argentina','3515556666',' Proyecciones Empresariales S.R.L.@clientes.argentina.com',' Jimena Herrera','@ Proyecciones Empresariales S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-07-21',' Redes de Negocios S.A.',' Calle Suipacha 789',16,' La Calera','Córdoba','Argentina','3516665555',' Redes de Negocios S.A.@clientes.argentina.com',' Diego Rojas','@ Redes de Negocios S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-04-15',' Renovación Tecnológica S.R.L.',' Av. San Martín 234',17,' Las Parejas','Santa Fe','Argentina','3517779999',' Renovación Tecnológica S.R.L.@clientes.argentina.com',' Ana Maria Mendez','@ Renovación Tecnológica S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-08',' Satisfacción del Cliente S.A.',' Calle Montevideo 567',5,' Villa Santa Rita','Córdoba','Argentina','3518885555',' Satisfacción del Cliente S.A.@clientes.argentina.com',' Oscar Velez','@ Satisfacción del Cliente S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-01-22',' Servicios Corporativos S.R.L.',' Av. Corrientes 890',18,' Arroyo Cabral','Santa Fe','Argentina','3513337777',' Servicios Corporativos S.R.L.@clientes.argentina.com',' Blanca Garcia','@ Servicios Corporativos S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-04-01',' Soluciones Creativas S.A.',' Calle Tucumán 123',6,' San Carlos Centro','Córdoba','Argentina','3514442222',' Soluciones Creativas S.A.@clientes.argentina.com',' Adrian Rios','@ Soluciones Creativas S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-05-25',' Soluciones Integrales S.R.L.',' Av. Paseo Colón 456',3,' Cavanagh','Buenos Aires','Argentina','3515557777',' Soluciones Integrales S.R.L.@clientes.argentina.com',' Norma Medina','@ Soluciones Integrales S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-21',' Soluciones Tecnológicas S.A.',' Calle Belgrano 789',9,' Monte Buey','Córdoba','Argentina','3516664444',' Soluciones Tecnológicas S.A.@clientes.argentina.com',' Isaac Morales','@ Soluciones Tecnológicas S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-14',' Soporte Empresarial S.R.L.',' Av. 9 de Julio 234',5,' San Jerónimo Norte','Santa Fe','Argentina','3517772222',' Soporte Empresarial S.R.L.@clientes.argentina.com',' Valeria Castillo','@ Soporte Empresarial S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-02-24',' Speedy Solutions S.A.',' Calle Alem 567',18,' La Cumbre','Santa Fe','Argentina','3518884444',' Speedy Solutions S.A.@clientes.argentina.com',' Arturo Ortega','@ Speedy Solutions S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-20',' Strategic Consulting S.R.L.',' Av. Cabildo 890',12,' San Jerónimo Sud','Córdoba','Argentina','3513334444',' Strategic Consulting S.R.L.@clientes.argentina.com',' Paola Herrera','@ Strategic Consulting S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-01-06',' Subproductos Agroindustriales S.A.',' Calle Reconquista 123',6,' Las Toscas','Córdoba','Argentina','3514443333',' Subproductos Agroindustriales S.A.@clientes.argentina.com',' Rodrigo Cárdenas','@ Subproductos Agroindustriales S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-22',' Suministros Industriales S.R.L.',' Av. Libertador 456',5,' San Cristóbal','Buenos Aires','Argentina','3515552222',' Suministros Industriales S.R.L.@clientes.argentina.com',' Silvia Nava','@ Suministros Industriales S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-27',' Sustentabilidad Ambiental S.A.',' Calle Sarmiento 789',14,' Villa General Belgrano','Santa Fe','Argentina','3516669999',' Sustentabilidad Ambiental S.A.@clientes.argentina.com',' Cesar Munoz','@ Sustentabilidad Ambiental S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-07',' Sustentabilidad Energética S.R.L.',' Av. Santa Fe 234',14,' Cerrito','Córdoba','Argentina','3517775555',' Sustentabilidad Energética S.R.L.@clientes.argentina.com',' Antonia Flores','@ Sustentabilidad Energética S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-01-03',' Tala Forestal S.A.',' Calle Perón 567',6,' Villa del Dique','Buenos Aires','Argentina','3518883333',' Tala Forestal S.A.@clientes.argentina.com',' René Sanchez','@ Tala Forestal S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-01-24',' Tecnología Aplicada S.R.L.',' Av. Callao 890',15,' Santa Isabel','Córdoba','Argentina','3513331111',' Tecnología Aplicada S.R.L.@clientes.argentina.com',' Vanessa Rodriguez','@ Tecnología Aplicada S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-05-09',' Telecomunicaciones y Redes S.A.',' Calle Lavalle 123',18,' Cañuelas','Santa Fe','Argentina','3514447777',' Telecomunicaciones y Redes S.A.@clientes.argentina.com',' Hugo Rivera','@ Telecomunicaciones y Redes S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-04-24',' Tierra Fértil S.R.L.',' Av. Corrientes 456',5,' Viamonte','Santa Fe','Argentina','3515559999',' Tierra Fértil S.R.L.@clientes.argentina.com',' Alma Reyes','@ Tierra Fértil S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-04',' Traducciones e Interpretaciones S.A.',' Calle Suipacha 789',15,' Mina Clavero','Córdoba','Argentina','3516662222',' Traducciones e Interpretaciones S.A.@clientes.argentina.com',' Julian Espinoza','@ Traducciones e Interpretaciones S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-12',' Transporte y Logística S.R.L.',' Av. Entre Ríos 234',6,' Río Segundo','Buenos Aires','Argentina','3517771111',' Transporte y Logística S.R.L.@clientes.argentina.com',' Lorena Perez','@ Transporte y Logística S.R.L.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-04-03',' Turismo y Aventura S.A.',' Calle Montevideo 567',10,' Fray Luis Beltrán','Córdoba','Argentina','3518887777',' Turismo y Aventura S.A.@clientes.argentina.com',' Ivan Mendoza','@ Turismo y Aventura S.A.');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-07-11',' Globaltech Solutions SRL',' Av. Córdoba 890',4,' Leones','Córdoba','Argentina','3513336666',' Globaltech Solutions SRL@clientes.argentina.com',' Araceli Vega','@ Globaltech Solutions SRL');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-16',' Skyline Enterprises SA',' Calle Tucumán 123',7,' Sunchales','Buenos Aires','Argentina','3514441111',' Skyline Enterprises SA@clientes.argentina.com',' Esteban Torres','@ Skyline Enterprises SA');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-04',' Fresh Foods SRL',' Av. Paseo Colón 456',3,' San Marcos Sud','Córdoba','Argentina','3515558888',' Fresh Foods SRL@clientes.argentina.com',' Victoria Sánchez','@ Fresh Foods SRL');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-01',' Oceanic Ventures SA',' Calle Belgrano 789',4,' San Francisco del Chañar','Córdoba','Argentina','3516667777',' Oceanic Ventures SA@clientes.argentina.com',' Rafaela Pacheco','@ Oceanic Ventures SA');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-01',' Emerald Enterprises SRL',' Av. San Martín 234',5,' San José de Feliciano','Buenos Aires','Argentina','3517774444',' Emerald Enterprises SRL@clientes.argentina.com',' Ramiro Ramirez','@ Emerald Enterprises SRL');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-19',' Quantum Consulting SA','Avenida Belgrano 456',12,' Alta Gracia','Santa Fe','Argentina','3518881111',' Quantum Consulting SA@clientes.argentina.com',' Patricia Vargas','@ Quantum Consulting SA');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-04-14',' Clearview Industries SRL','Calle San Martín 987',1,' Marcos Juárez','Córdoba','Argentina','3513333333',' Clearview Industries SRL@clientes.argentina.com',' Gerardo Mendoza','@ Clearview Industries SRL');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-05-15',' Phoenix Trading SA','Avenida Corrientes 2323',16,' Carlos Casares','Córdoba','Argentina','3514445555',' Phoenix Trading SA@clientes.argentina.com',' Andrea Suarez','@ Phoenix Trading SA');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-04',' Silverstone Holdings SRL','Calle Reconquista 1120',14,' Salsipuedes','Santa Fe','Argentina','3515554444',' Silverstone Holdings SRL@clientes.argentina.com',' Santiago Diaz','@ Silverstone Holdings SRL');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-04-26',' Diamond Dynamics SA','Avenida 9 de Julio 145',4,' Villa del Rosario','Córdoba','Argentina','3516661111',' Diamond Dynamics SA@clientes.argentina.com',' Marisol Moreno','@ Diamond Dynamics SA');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-01',' Sunflower Corporation SRL','Calle Florida 520',6,' General Roca','Buenos Aires','Argentina','3517778888',' Sunflower Corporation SRL@clientes.argentina.com',' Octavio Guerrero','@ Sunflower Corporation SRL');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-05-09',' Neptune Logistics SA','Avenida Córdoba 1500',3,' San Basilio','Córdoba','Argentina','3518885555',' Neptune Logistics SA@clientes.argentina.com',' Diana Perez','@ Neptune Logistics SA');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-01-05',' Ivy League Enterprises SRL','Calle Lavalle 745',12,' Monte Maíz','Córdoba','Argentina','3513337777',' Ivy League Enterprises SRL@clientes.argentina.com',' Ruben Rojas','@ Ivy League Enterprises SRL');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-05-25',' Moonstone Innovations SA','Avenida Callao 200',4,' General Deheza','Buenos Aires','Argentina','3514442222',' Moonstone Innovations SA@clientes.argentina.com',' Mariana Ramirez','@ Moonstone Innovations SA');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-19',' Vantagepoint Solutions SRL',' Calle Santa Fe 890',1,' Totoras','Santa Fe','Argentina','3515557777',' Vantagepoint Solutions SRL@clientes.argentina.com',' Diego Gomez','@ Vantagepoint Solutions SRL');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-02-10',' Blackhawk Industries SA',' Avenida Rivadavia 2500',14,' Capitán Bermúdez','Córdoba','Argentina','3516664444',' Blackhawk Industries SA@clientes.argentina.com',' Susana Ruiz','@ Blackhawk Industries SA');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-15',' Cascade Financial Services SRL',' Calle Uruguay 765',14,' Monte Cristo','Santa Fe','Argentina','3517772222',' Cascade Financial Services SRL@clientes.argentina.com',' Luis Vazquez','@ Cascade Financial Services SRL');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-01-19',' Titan Technology SA',' Avenida Paseo Colón 300',2,' La Francia','Santa Fe','Argentina','3518884444',' Titan Technology SA@clientes.argentina.com',' Raquel Moreno','@ Titan Technology SA');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-02-09',' Timberland Partners SRL',' Calle Maipú 550',2,' San Justo','Córdoba','Argentina','3513334444',' Timberland Partners SRL@clientes.argentina.com',' Rodrigo Castro','@ Timberland Partners SRL');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-07-31',' Onyx Enterprises SA',' Avenida Juan B. Justo 1500',6,' Venado Tuerto','Buenos Aires','Argentina','3514443333',' Onyx Enterprises SA@clientes.argentina.com',' Ximena González','@ Onyx Enterprises SA');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-04-21',' Seaside Productions SRL',' Calle Azopardo 670',3,' Ceres','Córdoba','Argentina','3515552222',' Seaside Productions SRL@clientes.argentina.com',' Sergio Gallegos','@ Seaside Productions SRL');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-07-08',' Firefly Innovations SA',' Avenida Santa Fe 1200',14,' Coronda','Córdoba','Argentina','3516669999',' Firefly Innovations SA@clientes.argentina.com',' Ana Karen Morales','@ Firefly Innovations SA');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-26',' Bluebird Corporation SRL',' Calle Paraguay 980',4,' San José de la Dormida','Buenos Aires','Argentina','3517775555',' Bluebird Corporation SRL@clientes.argentina.com',' Damian Mendoza','@ Bluebird Corporation SRL');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-03-25',' Echo Bay Industries SA',' Avenida del Libertador 2500',7,' Chabás','Santa Fe','Argentina','3518883333',' Echo Bay Industries SA@clientes.argentina.com',' Marina Ortiz','@ Echo Bay Industries SA');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-04-12',' Delta Global Partners SRL',' Calle Tucumán 440',4,' San Genaro','Santa Fe','Argentina','3513331111',' Delta Global Partners SRL@clientes.argentina.com',' Alejandro Torres','@ Delta Global Partners SRL');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-04-17',' Stormy Seas SA',' Avenida Figueroa Alcorta 1500',8,' El Trébol','Córdoba','Argentina','3514447777',' Stormy Seas SA@clientes.argentina.com',' Lorena Sosa','@ Stormy Seas SA');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-04-24',' Zenith Solutions SRL',' Calle Balcarce 660',3,' Hernando','Santa Fe','Argentina','3515559999',' Zenith Solutions SRL@clientes.argentina.com',' Guillermo Martinez','@ Zenith Solutions SRL');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-06-22',' Apollo Enterprises SA',' Avenida Las Heras 2100',12,' Los Surgentes','Santa Fe','Argentina','3516662222',' Apollo Enterprises SA@clientes.argentina.com',' Karina Aguilar','@ Apollo Enterprises SA');
INSERT INTO CLIENTES(fecha_alta, nombre, direccion, id_vendedor, localidad, provincia, país, telefono, mail, contacto_personal, usuario_web) VALUES ('2021-05-22',' Meridian Innovations SRL',' Calle Sarmiento 980',6,' General Rodríguez','Santa Fe','Argentina','3517771111',' Meridian Innovations SRL@clientes.argentina.com',' Roberto Rosales','@ Meridian Innovations SRL');

 -- insercion de la tabla compras
 
 INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,12,'2021-08-11',6,2,12713);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,100,'2022-08-01',1,1,38354);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,27,'2021-12-05',3,1,12075);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,80,'2022-12-01',6,1,2282);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,26,'2021-10-18',4,1,27264);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,60,'2022-05-20',3,1,16533);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,92,'2022-07-15',2,2,36553);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,33,'2022-08-16',3,1,11646);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,53,'2022-02-17',1,1,41909);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,26,'2022-09-06',2,1,41871);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,68,'2022-04-17',3,1,35031);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,18,'2023-02-15',4,2,1715);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,63,'2022-11-09',3,2,36938);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,61,'2021-12-09',3,2,16174);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,96,'2021-11-07',3,2,27977);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,5,'2023-03-23',1,1,42325);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,3,'2022-11-11',4,1,26103);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,20,'2021-10-03',4,2,39898);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,99,'2023-01-07',2,2,9713);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,22,'2023-02-12',2,2,22643);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,71,'2022-11-01',4,2,33901);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,34,'2022-02-17',6,2,27570);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,67,'2022-10-12',2,1,41310);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,31,'2021-10-21',4,1,5992);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,4,'2022-03-15',2,1,23517);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,45,'2021-12-14',4,2,4497);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,21,'2022-09-04',6,2,15117);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,26,'2022-04-02',6,1,35410);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,10,'2022-03-13',2,1,16950);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,32,'2022-03-22',3,1,3925);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,54,'2021-12-30',4,1,8083);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,56,'2023-01-16',3,1,40614);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,17,'2022-05-07',3,1,27828);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,81,'2022-09-10',2,1,28043);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,28,'2021-11-24',2,2,43228);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,57,'2022-08-01',3,2,7899);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,69,'2022-08-15',5,1,22342);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,23,'2023-01-27',4,2,37964);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,65,'2022-12-16',4,1,1920);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,20,'2022-08-24',6,2,19822);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,64,'2022-05-17',5,1,16818);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,100,'2022-10-15',2,2,36473);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,12,'2022-10-08',4,2,12339);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,59,'2022-03-23',3,2,6577);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,97,'2022-12-29',2,1,1947);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,75,'2022-04-09',2,2,24951);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,99,'2022-02-22',3,2,2466);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,71,'2022-02-11',2,2,11258);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,79,'2022-04-09',3,1,40591);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,94,'2022-09-11',1,1,33174);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,64,'2022-05-13',5,1,2338);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,55,'2022-09-25',5,1,15284);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,39,'2023-03-17',5,1,12585);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,97,'2023-01-26',3,1,19227);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,55,'2023-03-29',6,1,14273);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,56,'2022-08-17',6,2,38999);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,27,'2022-10-11',5,1,16888);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,77,'2022-09-17',3,1,3063);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,7,'2022-07-28',1,1,17963);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,23,'2022-03-15',5,2,30857);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,77,'2023-02-07',2,2,11241);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,80,'2021-09-28',1,1,10824);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,10,'2021-11-19',5,2,31889);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,1,'2022-08-03',6,2,34765);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,90,'2021-09-09',5,2,9776);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,62,'2021-10-04',6,1,19557);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,22,'2023-01-30',3,1,26709);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,3,'2023-01-28',4,1,44646);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,85,'2021-08-06',3,1,4450);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,25,'2021-10-09',3,1,35889);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,75,'2023-01-25',4,1,13799);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,18,'2023-01-12',3,1,9576);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,90,'2022-02-21',3,1,7981);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,43,'2022-07-28',3,2,14079);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,77,'2022-05-20',5,2,24622);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,100,'2022-03-22',5,1,13173);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,65,'2023-02-11',1,1,30521);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,8,'2022-09-03',5,2,7836);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,83,'2022-01-28',1,2,24877);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,7,'2022-08-30',1,2,28179);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,81,'2022-08-04',5,1,43737);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,91,'2022-10-19',4,2,18749);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,87,'2022-07-16',4,2,19374);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,16,'2022-03-26',4,2,4667);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,68,'2022-12-04',5,1,13765);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,20,'2021-10-23',2,1,14588);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,48,'2022-04-03',3,1,35940);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,7,'2022-03-05',3,2,34532);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,81,'2022-06-17',2,1,24045);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,5,'2022-08-04',3,2,31004);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,1,'2022-05-31',2,2,35004);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,22,'2022-08-20',3,1,10990);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,37,'2022-09-25',4,2,19878);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,90,'2022-05-14',6,1,10345);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,73,'2022-04-15',5,2,16816);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,39,'2021-11-04',4,2,2093);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,90,'2022-10-04',1,1,4037);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,68,'2022-09-30',5,1,11725);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,59,'2021-11-16',2,2,19090);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,59,'2022-04-22',6,1,21487);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,55,'2022-11-04',3,2,41477);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,8,'2022-02-04',5,1,14809);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,91,'2021-08-11',1,1,44802);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,15,'2021-10-04',4,2,1803);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,94,'2023-02-12',6,2,20091);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,16,'2021-09-17',5,1,34538);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,90,'2022-11-10',3,2,15723);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,10,'2022-07-30',6,1,38652);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,19,'2022-02-17',6,1,12984);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,56,'2022-01-17',6,1,3544);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,6,'2022-05-08',1,2,15854);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,35,'2023-03-07',1,1,7403);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,92,'2021-10-14',3,1,9019);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,3,'2021-11-28',3,2,26410);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,9,'2022-05-16',5,1,23230);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,71,'2022-07-26',1,2,28822);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,26,'2022-01-06',3,1,36527);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,50,'2021-12-17',2,2,12875);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,20,'2022-09-30',4,1,22260);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,68,'2022-12-02',6,1,17104);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,17,'2022-01-29',3,1,37897);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,86,'2021-10-29',1,2,1932);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,99,'2022-04-04',5,2,25953);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,69,'2023-02-06',4,1,36763);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,35,'2023-03-19',4,2,43504);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,21,'2023-03-24',4,2,16763);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,37,'2023-03-28',3,2,5449);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,45,'2022-07-16',6,2,28872);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,7,'2022-11-29',4,1,14937);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,90,'2023-01-16',1,1,27401);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,96,'2022-12-31',1,1,40552);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,4,'2022-09-29',4,2,43873);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,5,'2023-03-25',6,2,19430);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,25,'2022-05-09',1,1,26260);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,27,'2022-11-03',6,2,26161);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,14,'2022-03-13',3,2,40873);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,8,'2022-02-19',3,2,8844);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,27,'2021-11-30',5,2,19748);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,29,'2022-07-27',1,1,32806);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,68,'2022-03-20',6,1,35283);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,88,'2022-06-05',6,1,7839);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,98,'2022-03-05',3,2,6885);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,19,'2022-05-30',1,2,5684);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,79,'2022-01-07',2,2,35999);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,16,'2021-08-20',3,1,29725);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,6,'2022-10-15',1,2,40228);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,34,'2022-08-14',6,2,22886);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,41,'2021-10-28',5,1,27810);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,62,'2022-10-29',3,1,44541);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,59,'2022-11-03',1,2,21753);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,19,'2021-10-21',5,2,42861);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,36,'2023-01-12',3,1,10986);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,73,'2022-08-14',5,2,8393);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,57,'2022-03-21',4,2,4700);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,78,'2022-12-03',6,2,40082);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,19,'2023-01-02',5,1,25481);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,82,'2022-12-23',3,1,34739);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,97,'2021-08-01',5,2,5060);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,27,'2022-05-05',1,1,26769);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,67,'2022-11-30',4,2,44916);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,21,'2022-11-28',3,2,38604);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,16,'2022-10-17',4,2,1635);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,12,'2021-11-25',2,1,29363);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,5,'2022-09-08',3,2,37350);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,58,'2022-06-17',3,1,27593);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,48,'2022-05-05',2,2,21362);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,41,'2022-01-18',3,1,22422);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,78,'2021-08-09',3,2,39376);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,27,'2022-06-26',1,1,16093);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,21,'2022-03-20',2,1,23554);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,74,'2023-01-21',3,1,22550);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,41,'2022-11-25',5,1,30534);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,44,'2021-10-14',6,1,4000);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,18,'2022-05-13',4,1,31765);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,31,'2021-08-20',4,2,11629);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,21,'2023-01-02',2,1,33337);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,44,'2022-09-29',1,1,28064);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,47,'2022-12-14',4,2,2417);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,28,'2023-01-15',5,2,24901);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,36,'2023-01-06',6,1,17634);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,61,'2022-10-05',1,1,40494);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,71,'2022-11-10',2,2,25022);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,43,'2022-08-19',1,1,31523);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,91,'2021-08-16',2,2,22701);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,99,'2022-07-17',2,1,32652);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,47,'2021-11-12',4,1,39787);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,61,'2021-10-22',3,1,38919);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,1,'2022-07-15',1,2,21465);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,36,'2022-05-08',1,2,44036);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,13,'2021-09-30',2,2,19867);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,100,'2021-08-16',3,1,30130);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,20,'2022-02-05',3,2,10637);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,80,'2022-06-13',2,1,41888);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,45,'2022-03-01',5,2,27423);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,37,'2023-03-20',6,2,32518);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,89,'2022-04-14',3,1,28830);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,83,'2022-08-08',2,2,5374);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,40,'2021-12-27',1,1,23501);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,99,'2021-11-09',4,1,2150);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,79,'2022-02-05',1,2,17612);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,67,'2022-03-14',6,1,9276);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,90,'2021-09-10',6,2,22794);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,74,'2023-03-27',1,1,10315);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,12,'2022-01-30',2,1,24718);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,100,'2022-11-20',5,2,38287);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,12,'2021-08-13',1,2,13580);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,23,'2023-02-27',3,1,43807);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,47,'2022-02-03',3,1,17713);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,77,'2022-01-21',3,1,21371);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,19,'2021-12-23',6,2,7621);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,46,'2022-01-29',6,1,10894);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,12,'2022-01-11',6,1,35197);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,32,'2022-10-13',4,2,32969);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,13,'2022-03-12',6,1,8546);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,90,'2021-12-17',3,2,21571);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,73,'2022-03-01',2,2,3701);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,17,'2023-02-11',4,2,27846);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,36,'2021-11-30',6,2,44385);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,75,'2022-09-15',2,2,40993);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,62,'2022-07-15',4,2,7298);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,89,'2023-01-25',5,2,5725);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,85,'2022-10-20',6,1,23904);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,5,'2022-07-14',3,1,4778);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,70,'2022-10-26',2,1,35489);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,31,'2023-02-11',3,2,29493);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,19,'2021-12-04',6,1,40910);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,54,'2021-12-21',6,2,44641);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,46,'2022-04-06',4,1,5026);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,44,'2021-12-26',2,2,10527);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,94,'2021-12-15',1,1,10967);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,97,'2023-01-30',5,2,38862);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,14,'2022-04-26',2,2,22041);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,53,'2021-10-03',6,1,37796);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,1,'2022-03-24',1,1,32240);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,12,'2022-03-04',4,2,14080);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,19,'2022-11-12',2,1,13451);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,38,'2022-06-19',5,2,35752);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,40,'2023-02-04',4,2,42236);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,52,'2022-05-22',4,1,36546);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,86,'2022-01-04',4,1,8282);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,15,'2022-06-24',6,1,17955);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,81,'2021-12-17',3,2,38342);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,88,'2023-01-23',3,1,24556);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,58,'2023-01-06',6,1,32412);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,24,'2022-09-08',1,1,28188);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,54,'2021-10-20',1,1,28047);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,21,'2022-11-19',1,2,23891);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,15,'2022-07-10',6,2,34557);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,1,'2022-04-22',5,1,35274);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,94,'2021-12-12',4,1,8814);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,17,'2022-02-24',1,1,31513);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,76,'2023-01-06',4,1,44359);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,66,'2021-12-28',4,1,19590);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,98,'2023-01-08',5,1,8648);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,70,'2023-01-03',5,1,7606);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,55,'2023-01-04',5,2,39039);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,86,'2021-08-23',6,1,20171);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,84,'2022-11-21',3,1,38622);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,18,'2022-11-14',2,2,42702);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,75,'2022-04-12',5,2,23075);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,63,'2021-12-29',5,2,14817);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,49,'2022-11-01',5,2,22725);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,25,'2022-04-29',6,1,25310);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,61,'2021-09-29',2,2,11805);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,19,'2022-06-24',3,1,24651);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,27,'2022-09-23',3,2,9590);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,98,'2023-01-18',2,2,21930);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,91,'2022-03-29',5,2,2005);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,94,'2021-12-12',5,2,35313);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,13,'2022-03-13',3,1,11239);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,49,'2022-05-24',4,2,9998);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,51,'2022-11-10',4,2,10222);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,57,'2022-06-16',6,1,15584);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,55,'2023-03-22',4,2,29852);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,85,'2021-11-02',6,1,3550);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,46,'2022-05-03',2,1,11471);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,89,'2022-11-17',5,2,41480);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,30,'2022-12-04',2,1,27887);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,14,'2021-08-29',3,1,6599);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,4,'2022-05-16',1,1,7196);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,75,'2022-01-21',1,1,22366);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,12,'2022-05-09',2,2,15575);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,65,'2022-12-16',4,1,28746);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,61,'2021-10-14',3,2,26026);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,91,'2021-12-02',1,1,11927);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,41,'2021-08-24',5,2,27382);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,64,'2023-01-15',1,2,7111);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,60,'2023-03-27',1,2,14654);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,1,'2022-05-02',1,2,22855);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,80,'2022-03-24',6,2,37939);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,17,'2022-01-09',1,2,20749);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,29,'2022-10-29',4,2,23337);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,23,'2022-02-18',6,1,20850);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,36,'2022-02-01',6,1,10743);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,70,'2021-10-29',5,2,19118);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,48,'2022-04-28',4,1,38250);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,72,'2023-01-27',5,2,35845);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,33,'2022-11-23',5,1,2463);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,30,'2022-10-13',1,2,19418);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,48,'2022-01-26',1,1,23498);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,80,'2022-07-25',5,2,38278);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,58,'2023-02-22',6,1,36900);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,96,'2021-10-12',5,1,22060);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,56,'2022-06-19',1,2,34952);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,71,'2022-07-01',5,2,19903);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,52,'2022-12-19',6,2,37033);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,95,'2021-09-16',5,1,9425);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,81,'2022-07-11',3,2,29798);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,13,'2023-03-19',5,1,21631);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,70,'2022-07-25',6,1,41768);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,79,'2022-03-02',1,1,27384);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,16,'2022-07-10',2,2,40826);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,24,'2022-02-09',3,2,8504);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,45,'2022-07-21',3,2,41558);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,60,'2022-06-10',5,1,11840);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,58,'2022-10-19',5,2,41865);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,42,'2021-11-14',4,1,10916);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,9,'2022-05-16',3,1,35385);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,53,'2022-09-10',4,2,13919);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,79,'2021-08-02',6,2,9547);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,79,'2023-03-10',6,2,44241);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,43,'2021-11-19',2,2,4090);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,90,'2023-01-20',5,1,15861);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,52,'2022-12-22',3,1,26501);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,71,'2022-02-06',5,2,31052);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,51,'2022-04-12',5,1,5354);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,55,'2022-11-14',1,1,15627);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,7,'2022-12-23',6,1,7927);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,43,'2022-07-01',1,1,17724);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,82,'2022-06-27',6,2,15030);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,59,'2021-09-30',5,2,5700);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,55,'2022-01-11',6,1,26971);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,21,'2022-05-30',2,1,40979);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,17,'2022-04-17',2,1,36417);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,81,'2022-09-22',3,2,38375);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,85,'2023-01-27',4,2,19857);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,18,'2021-08-05',5,1,9185);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,5,'2021-09-27',2,2,41335);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,21,'2022-11-03',3,2,29521);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,18,'2021-08-02',2,2,35164);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,35,'2022-08-05',6,2,43946);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,58,'2022-10-05',4,2,6439);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,85,'2022-10-16',4,2,36315);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,36,'2022-11-25',1,2,37721);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,99,'2022-12-18',1,1,8418);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,31,'2022-07-23',2,1,31650);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,25,'2022-10-06',4,1,36315);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,67,'2022-06-06',3,2,38907);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,47,'2022-09-15',3,1,10081);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,79,'2022-11-13',5,1,37928);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,32,'2022-06-12',3,1,25326);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,80,'2023-01-14',2,2,21671);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,57,'2022-11-23',1,2,5328);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,96,'2023-03-17',3,1,29808);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,31,'2023-01-15',4,2,2386);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,21,'2022-06-06',5,1,36166);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,50,'2022-04-14',6,2,30829);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,17,'2023-02-26',5,2,24839);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,5,'2022-11-22',5,1,7994);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,91,'2021-11-04',6,2,7345);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,48,'2021-09-19',5,2,40107);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,57,'2022-08-21',2,2,17029);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,35,'2023-01-02',6,1,7873);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,37,'2022-08-05',6,1,4746);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,41,'2022-10-18',4,2,34859);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,58,'2023-02-28',2,1,37205);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,100,'2022-07-24',6,2,37282);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,75,'2021-08-08',5,2,30040);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,77,'2022-12-26',2,2,20956);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,55,'2022-02-06',1,1,22414);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,29,'2022-03-07',1,2,27481);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,76,'2022-03-03',3,1,3036);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,94,'2021-12-31',4,1,33306);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,22,'2022-06-22',1,1,13425);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,47,'2022-05-24',6,1,11040);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,64,'2022-03-25',2,1,31959);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,89,'2022-12-15',6,1,14197);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,60,'2022-03-21',5,2,29840);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,29,'2022-04-22',1,1,30493);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,11,'2022-08-16',4,2,7458);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,76,'2022-06-27',5,2,40582);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,68,'2022-10-03',1,2,25802);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,57,'2022-01-10',6,1,21049);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,94,'2022-04-22',1,1,6837);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,80,'2022-01-08',1,1,2621);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,34,'2021-11-23',4,2,11656);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,31,'2021-12-30',1,1,11092);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,58,'2022-01-10',3,2,6494);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,81,'2022-12-22',5,2,42050);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,69,'2022-10-06',3,1,14124);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,27,'2022-06-16',1,1,5392);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,2,'2021-08-03',5,2,18841);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,11,'2022-08-18',2,1,11283);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,71,'2022-07-09',5,2,35384);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,10,'2021-09-07',6,1,37381);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,79,'2022-06-22',4,2,27615);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,47,'2022-06-23',5,1,11957);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,67,'2023-01-29',3,2,23240);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,90,'2021-09-15',3,1,16535);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,72,'2022-12-11',2,1,14730);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,24,'2022-01-22',2,2,7692);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,9,'2021-11-26',4,2,32500);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,66,'2022-04-23',5,1,35884);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,93,'2023-01-30',1,2,20804);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,100,'2021-10-27',3,2,13387);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,35,'2022-06-26',6,2,6617);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,91,'2023-02-08',3,1,5769);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,3,'2021-09-28',5,1,12389);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,64,'2022-04-06',5,1,12891);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,98,'2022-11-10',5,1,2833);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,28,'2022-02-24',2,2,38426);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,94,'2022-12-03',5,1,34919);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,43,'2021-08-02',1,1,15440);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,6,'2022-06-02',5,1,30463);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,82,'2021-10-01',4,2,22251);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,64,'2023-02-07',1,2,30343);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,93,'2023-02-27',4,2,21246);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,36,'2022-06-02',4,1,25930);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,81,'2022-03-08',5,1,27175);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,40,'2022-11-28',2,1,2096);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,8,'2021-10-28',2,1,14528);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,30,'2023-01-11',5,2,39626);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,88,'2022-10-16',1,2,39765);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,12,'2021-08-20',4,2,30542);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,85,'2022-03-04',4,2,19720);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,5,'2023-03-28',6,1,24028);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,15,'2022-03-08',2,2,37825);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,7,'2021-10-03',4,2,16067);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,11,'2022-04-17',4,2,25477);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,56,'2021-09-15',5,1,2986);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,36,'2021-11-05',2,2,27260);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,52,'2022-08-04',1,1,20555);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,91,'2022-01-21',5,1,19861);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,67,'2022-04-24',6,2,29511);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,77,'2022-12-03',4,2,12101);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,86,'2022-04-11',6,1,4272);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,4,'2022-02-06',1,2,5293);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,3,'2023-01-10',5,1,16184);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,68,'2022-08-09',4,1,36715);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,40,'2022-01-21',3,1,44031);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,66,'2022-10-18',5,2,21284);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,89,'2021-11-20',5,1,1898);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,72,'2022-10-18',4,1,20790);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,3,'2023-03-14',4,1,35702);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,87,'2022-10-10',2,1,37245);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,64,'2022-06-04',1,1,5284);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,69,'2022-04-28',4,2,44649);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,8,'2022-10-22',5,2,43835);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,46,'2021-12-26',1,1,26227);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,45,'2022-12-20',1,2,37867);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,35,'2022-03-15',5,2,7824);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,84,'2022-03-14',4,1,13368);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,85,'2022-01-23',3,1,42149);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,31,'2022-05-12',2,1,28080);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,5,'2022-09-02',2,2,28799);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,24,'2021-10-18',1,2,24203);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,45,'2021-11-04',4,2,33564);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,57,'2022-08-13',1,2,39558);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,80,'2022-10-24',6,2,13794);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,55,'2021-08-27',5,2,19060);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,18,'2022-10-24',4,2,41463);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,83,'2022-10-16',5,1,39355);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,38,'2022-01-02',1,1,9785);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,34,'2021-10-13',2,1,11380);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,71,'2022-01-10',4,1,30804);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,27,'2021-09-15',5,2,42684);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,94,'2021-10-29',2,2,29000);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,57,'2022-04-11',2,1,9554);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,75,'2022-08-05',6,2,43994);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,28,'2021-10-10',4,2,9800);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,89,'2022-05-04',5,2,31542);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,63,'2022-03-30',2,1,24873);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,72,'2021-10-26',6,1,27389);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,37,'2021-09-03',3,2,11546);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,93,'2022-11-03',6,2,20524);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,26,'2021-08-24',2,1,33112);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,45,'2022-08-22',3,1,33530);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,32,'2021-09-16',6,2,31596);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,75,'2022-01-12',2,2,33709);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,7,'2022-03-17',1,2,10347);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,3,'2022-09-07',2,2,40604);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,87,'2022-11-04',1,2,12542);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,15,'2021-10-01',3,1,31338);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,46,'2021-11-10',6,2,10305);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,72,'2022-12-18',2,2,40553);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,44,'2022-06-13',4,1,13313);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,88,'2022-07-30',6,1,44657);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,96,'2022-09-06',3,2,22793);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,96,'2021-08-12',5,1,39178);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,53,'2022-03-01',4,1,40967);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,78,'2022-01-03',5,1,22708);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,49,'2021-08-17',2,2,8301);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,33,'2021-12-03',1,2,43591);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,22,'2023-02-07',2,1,17120);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,41,'2022-04-02',2,1,9109);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,93,'2023-01-28',6,2,40767);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,11,'2022-07-02',1,2,9812);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,40,'2021-11-10',5,1,6031);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,32,'2022-01-31',5,2,20509);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,6,'2022-08-11',1,1,11398);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,25,'2022-10-19',4,2,4484);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,88,'2022-03-21',2,1,38299);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,57,'2022-05-24',6,2,14685);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,41,'2021-09-08',5,2,23579);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,20,'2023-01-07',2,1,35802);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,45,'2022-05-16',4,1,5099);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,40,'2022-08-24',3,2,42254);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,86,'2022-02-01',3,2,26677);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,87,'2022-10-30',3,1,4957);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,42,'2022-11-22',6,1,2070);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,33,'2022-09-11',4,1,33513);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,14,'2022-09-04',2,1,21472);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,52,'2022-08-16',2,2,16928);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,3,'2021-10-24',5,2,26392);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,59,'2022-11-08',1,1,34697);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,99,'2022-04-04',6,1,28001);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,73,'2022-03-17',6,2,38187);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,61,'2022-02-02',3,1,10267);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,69,'2022-05-27',2,1,33990);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,3,'2021-10-27',1,1,36745);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,16,'2021-10-28',6,2,24964);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,57,'2021-10-15',2,2,18302);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,74,'2021-08-25',1,2,1981);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,42,'2022-07-22',5,1,17985);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,87,'2022-11-23',3,1,13356);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,87,'2022-07-09',3,1,21393);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,50,'2022-10-26',2,2,44318);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,17,'2021-09-13',3,2,3779);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,36,'2021-11-21',2,2,42305);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,86,'2021-08-08',4,1,35774);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,16,'2022-04-30',2,2,27040);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,42,'2022-10-31',5,1,1896);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,51,'2021-10-10',2,1,19678);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,92,'2023-02-03',6,1,41122);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,58,'2022-04-14',4,2,6327);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,76,'2022-02-18',2,1,14321);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,28,'2021-08-31',5,2,27667);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,36,'2022-01-24',5,2,32438);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,74,'2021-11-13',1,2,24183);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,96,'2022-10-23',1,2,10629);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,95,'2022-04-30',2,1,9115);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,49,'2022-07-11',6,2,33184);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,72,'2022-07-11',5,1,24620);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,71,'2022-03-12',4,1,44969);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,92,'2022-10-22',3,1,2055);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,9,'2021-12-10',5,1,24177);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,98,'2022-01-07',6,1,44636);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,25,'2022-08-19',2,2,32175);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,32,'2023-03-16',5,1,37216);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,58,'2021-11-12',1,1,2374);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,18,'2023-03-16',6,2,38455);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,33,'2023-02-25',6,2,35376);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,81,'2022-04-15',5,1,43631);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,92,'2021-09-07',2,2,27528);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,57,'2021-11-30',4,2,28676);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,57,'2021-11-09',1,1,12283);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,81,'2022-08-06',5,2,44178);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,46,'2021-09-02',5,1,6231);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,4,'2022-08-01',3,1,32259);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,84,'2021-10-27',6,1,8108);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,45,'2022-04-29',6,2,38801);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,62,'2022-12-07',1,1,5915);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,90,'2022-01-23',6,2,29852);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,36,'2022-03-17',1,2,40255);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,4,'2022-05-03',2,1,4569);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,56,'2022-07-28',6,2,4827);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,10,'2022-12-31',5,2,18328);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,55,'2023-01-10',3,2,19677);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,36,'2022-01-16',3,2,5487);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,47,'2021-12-28',1,2,30099);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,68,'2021-12-21',1,2,32434);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,100,'2022-02-09',4,2,43447);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,20,'2022-07-27',6,2,7001);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,25,'2022-11-07',2,2,10443);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,62,'2022-08-05',4,1,42632);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,80,'2021-11-16',4,1,6786);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,14,'2022-09-16',2,2,5611);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,25,'2022-01-04',2,2,6645);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,91,'2021-10-18',1,2,6328);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,51,'2022-11-07',1,2,15048);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,37,'2021-08-15',5,1,21866);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,50,'2022-04-21',4,1,38259);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,52,'2023-02-21',5,1,31439);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,17,'2022-03-19',4,1,19596);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,23,'2022-03-26',2,1,20127);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,94,'2023-03-14',6,2,20904);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,88,'2022-05-07',4,1,14444);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,91,'2022-07-03',5,1,17104);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,89,'2021-11-13',1,1,26397);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,65,'2022-07-02',5,2,35824);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,39,'2022-09-01',2,1,38530);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,56,'2022-04-06',2,1,34411);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,50,'2022-09-26',6,2,30689);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,2,'2022-03-09',3,1,35112);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,40,'2023-02-14',6,2,32825);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,59,'2021-10-01',1,1,18124);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,26,'2022-09-29',2,1,25050);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,28,'2022-02-11',6,2,26959);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,18,'2022-10-20',1,1,17035);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,81,'2021-11-29',2,2,44269);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,1,'2023-03-22',5,2,18721);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,85,'2022-05-23',5,2,33759);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,18,'2022-02-26',1,2,22934);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,37,'2022-01-02',3,1,22381);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,8,'2022-08-22',3,1,27547);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,7,'2022-04-04',2,2,35174);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,17,'2023-03-13',3,1,11515);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,35,'2023-01-13',4,2,24924);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,95,'2022-09-05',5,1,15003);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,20,'2022-06-29',5,2,18341);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,94,'2022-04-25',6,2,13253);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,68,'2021-09-02',6,1,16335);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,21,'2022-02-17',4,2,40920);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,59,'2022-10-19',3,1,35164);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,96,'2022-06-23',6,2,20690);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,30,'2023-02-07',4,1,24332);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,97,'2022-09-26',5,1,40144);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,41,'2023-02-08',3,1,41789);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,12,'2023-02-17',4,1,42225);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,16,'2022-08-26',6,2,17222);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,14,'2023-01-03',2,1,37348);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,1,'2021-12-07',5,1,26238);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,35,'2022-12-09',5,1,42165);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,57,'2022-07-13',5,1,4905);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,41,'2022-04-27',5,1,38955);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,36,'2021-11-13',3,2,36622);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,78,'2022-02-20',3,1,40198);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,60,'2022-03-28',6,2,14315);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,59,'2022-03-05',5,1,6017);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,78,'2022-01-09',2,2,25713);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,88,'2022-09-14',6,2,17445);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,34,'2022-07-20',2,1,34852);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,13,'2022-04-23',3,1,9144);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,75,'2023-02-18',2,1,15599);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,72,'2021-08-17',4,2,30574);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,49,'2023-02-08',2,1,37384);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,22,'2021-10-01',3,2,17132);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,85,'2023-03-26',2,2,37677);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,34,'2022-12-19',5,2,25578);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,55,'2022-01-26',4,1,22415);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,73,'2022-09-25',6,1,3060);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,66,'2022-10-14',6,2,31461);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,63,'2021-10-08',2,1,24292);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,17,'2022-03-30',3,2,29644);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,99,'2023-01-02',6,2,3793);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,77,'2023-03-30',3,1,27769);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,4,'2023-02-23',3,1,35890);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,43,'2022-02-18',2,2,40273);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,32,'2021-09-29',3,2,15596);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,70,'2022-11-07',1,2,33961);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,86,'2022-10-30',2,1,34042);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,31,'2022-03-07',2,2,6910);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,84,'2022-08-30',2,1,28261);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,59,'2023-01-07',4,1,41787);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,10,'2023-03-09',4,2,28838);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,25,'2022-07-23',3,1,18923);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,55,'2022-12-27',1,2,15845);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,79,'2023-03-20',6,1,17625);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,57,'2022-05-31',3,1,27580);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,83,'2022-10-04',2,1,13982);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,87,'2022-02-14',5,2,24516);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,12,'2022-07-09',3,2,27090);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,81,'2023-02-26',2,2,27012);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,44,'2022-11-11',6,1,3608);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,70,'2022-08-15',4,2,17566);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,12,'2023-02-13',3,1,44801);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,47,'2022-11-02',1,2,23338);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,40,'2023-03-08',5,2,25288);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,26,'2021-09-26',6,2,31045);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,98,'2022-02-28',4,2,36896);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,69,'2023-03-23',3,1,15269);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,27,'2021-11-26',5,2,10296);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,98,'2022-10-01',5,1,4820);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,17,'2022-10-30',4,2,37393);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,81,'2022-05-07',2,1,39177);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,16,'2022-02-05',1,1,41015);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,46,'2022-10-29',3,1,27046);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,72,'2022-01-15',2,1,21497);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,21,'2023-02-11',3,2,15615);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,60,'2022-01-31',2,1,5342);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,72,'2022-05-23',4,2,23284);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,39,'2023-01-22',1,2,1730);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,19,'2021-10-31',6,1,16351);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,90,'2022-08-01',4,1,28960);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,36,'2023-01-10',5,1,30252);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,59,'2022-01-05',3,1,3369);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,29,'2021-11-20',4,1,39234);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,75,'2023-01-23',1,1,15495);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,84,'2022-05-04',5,1,18580);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,94,'2023-03-22',6,2,31970);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,82,'2022-02-15',4,1,20254);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,59,'2022-01-08',5,2,26918);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,45,'2022-04-23',3,1,27416);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,47,'2022-06-15',4,1,34585);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,46,'2023-02-05',3,1,3923);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,43,'2023-03-18',3,1,25015);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,77,'2023-03-29',2,1,36360);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,20,'2022-07-11',2,2,23638);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,61,'2022-06-21',4,2,17537);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,79,'2023-01-10',2,1,1649);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,2,'2021-10-08',6,2,30159);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,13,'2022-06-10',2,1,2427);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,97,'2022-02-15',5,2,29937);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,73,'2021-09-27',6,1,29177);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,1,'2022-05-19',4,1,42074);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,58,'2022-03-18',4,1,25654);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,44,'2022-07-06',5,1,32986);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,63,'2023-03-06',6,2,29334);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,3,'2021-10-07',2,1,8216);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,1,'2021-08-11',5,1,22451);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,84,'2021-08-25',4,2,38868);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,46,'2022-10-26',6,1,6722);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,58,'2022-05-10',1,2,20698);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,84,'2021-12-16',2,1,7590);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,15,'2022-01-08',3,2,22274);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,62,'2023-01-27',4,1,25336);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,64,'2022-09-28',4,1,39371);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,86,'2021-11-23',5,1,38657);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,37,'2022-07-02',4,2,1501);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,60,'2022-05-06',3,2,18273);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,74,'2023-01-10',3,2,6653);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,99,'2022-04-25',3,1,42756);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,15,'2023-02-01',6,2,22781);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,59,'2022-08-24',6,1,8964);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,58,'2022-05-17',3,1,8353);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,51,'2022-05-25',4,1,1908);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,92,'2022-04-16',6,2,3098);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,37,'2021-08-24',5,1,26279);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,60,'2021-11-21',2,2,36475);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,16,'2022-05-29',2,2,14884);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,91,'2022-07-16',2,1,42946);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,48,'2021-10-05',1,1,21826);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,94,'2022-06-06',1,1,19755);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,7,'2022-10-20',6,2,18278);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,55,'2021-12-27',3,1,9710);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,55,'2022-03-24',6,1,38583);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,66,'2022-05-29',3,1,28567);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,70,'2021-08-04',3,2,34607);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,91,'2021-08-30',4,1,42622);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,35,'2022-12-23',1,1,13231);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,45,'2022-12-09',5,2,3375);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,28,'2021-11-05',3,1,10063);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,54,'2022-03-05',2,1,21123);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,78,'2022-04-09',5,1,24650);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,50,'2022-01-02',6,2,15275);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,36,'2022-01-29',2,2,22259);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,16,'2021-11-28',4,1,26366);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,77,'2022-04-28',1,2,4297);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,58,'2022-08-04',2,2,31629);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,75,'2021-11-07',6,2,41700);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,84,'2021-10-12',5,1,9269);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,70,'2022-08-02',1,2,25408);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,27,'2022-07-15',1,2,21218);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,64,'2021-09-02',5,2,34321);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,27,'2021-08-02',1,1,5722);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,75,'2022-07-15',3,1,39936);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,32,'2021-08-21',4,2,42796);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,14,'2021-09-23',1,1,44908);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,8,'2022-10-29',4,2,26359);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,91,'2022-09-20',2,2,35644);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,51,'2021-11-04',3,1,37030);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,64,'2022-05-17',1,1,19995);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,35,'2022-02-15',4,2,34019);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,33,'2022-09-05',4,1,43121);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,4,'2023-03-21',3,1,33936);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,64,'2022-02-16',2,1,3441);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,83,'2022-05-04',1,1,34833);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,59,'2023-02-15',6,1,42322);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,38,'2022-09-16',1,1,26580);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,85,'2022-07-31',4,2,5129);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,95,'2022-09-08',5,1,7811);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,69,'2022-03-09',1,2,18893);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,31,'2022-01-22',6,2,2494);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,51,'2022-03-14',3,1,19677);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,41,'2023-01-15',2,2,37979);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,37,'2023-03-21',6,1,9895);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,47,'2022-07-27',1,2,38243);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,18,'2022-09-23',3,2,2687);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,13,'2022-11-30',1,1,19138);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,6,'2021-09-03',5,1,41254);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,17,'2022-01-30',4,2,29842);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,87,'2022-07-06',5,1,11595);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,83,'2021-08-04',3,2,28515);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,75,'2022-03-24',3,1,14214);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,93,'2022-05-05',5,1,8873);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,80,'2022-01-12',2,1,15767);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,30,'2022-05-02',1,2,10799);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,36,'2022-05-01',2,1,14286);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,100,'2023-03-14',1,1,25204);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,4,'2022-07-04',5,2,43161);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,62,'2022-09-29',1,2,10740);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,37,'2022-12-26',6,2,9066);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,1,'2021-12-28',3,1,39390);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,68,'2022-12-03',2,2,3968);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,50,'2023-02-12',5,1,21804);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,65,'2022-11-21',3,1,4124);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,55,'2022-05-09',3,2,43017);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,54,'2022-09-14',2,1,15016);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,98,'2022-04-05',2,2,11266);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,68,'2021-12-09',5,2,39643);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,17,'2021-12-05',4,2,5236);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,20,'2022-08-21',1,2,38225);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,10,'2022-04-10',5,1,21625);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,47,'2022-02-03',4,1,24305);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,47,'2022-12-15',2,2,10889);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,82,'2021-10-22',1,1,2450);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,16,'2023-02-17',4,2,25827);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,57,'2021-10-23',6,2,28976);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,93,'2022-02-28',5,2,40512);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,62,'2022-06-01',6,2,8201);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,14,'2022-12-30',2,1,22531);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,56,'2021-11-15',6,1,2360);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,32,'2022-04-06',6,1,33751);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,30,'2022-10-06',3,1,9200);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,10,'2022-12-24',4,1,32582);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,92,'2023-01-24',2,2,22816);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,80,'2022-09-29',6,1,11114);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,81,'2022-02-19',3,2,14706);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,76,'2022-10-13',3,1,8791);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,7,'2021-10-14',2,2,34707);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,78,'2023-01-17',6,2,32647);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,19,'2022-01-06',5,2,25556);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,98,'2021-11-23',2,2,3503);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,16,'2021-12-29',2,1,3749);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,59,'2022-08-04',2,2,1712);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,29,'2022-03-25',4,2,5428);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,6,'2022-03-19',5,2,3418);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,55,'2022-10-03',6,1,2101);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,30,'2022-11-25',4,1,41993);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,5,'2022-08-23',5,1,34465);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,5,'2022-06-18',3,2,25315);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,98,'2022-04-09',3,1,34458);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,98,'2022-01-05',3,2,1614);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,61,'2022-03-02',3,2,2940);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,2,'2022-02-25',6,2,42223);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,46,'2022-02-11',2,1,19319);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,35,'2023-01-01',4,1,35065);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,92,'2022-07-01',4,1,15083);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,72,'2021-11-19',6,2,16363);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,54,'2022-05-28',5,2,3467);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,13,'2022-07-28',3,1,4709);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,73,'2022-07-30',5,1,28677);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,86,'2022-05-20',4,2,2627);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,49,'2022-12-12',6,1,27260);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,42,'2022-01-26',3,1,21681);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,37,'2022-11-03',5,2,2313);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,41,'2021-11-27',1,1,33076);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,7,'2022-03-29',2,2,38340);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,65,'2022-01-17',4,2,44367);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,87,'2022-09-26',3,1,4271);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,31,'2021-09-14',2,1,20949);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,99,'2022-01-30',6,1,13225);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,94,'2021-11-07',5,2,30307);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,21,'2022-05-31',3,1,44668);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,98,'2022-08-15',2,1,8504);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,36,'2022-12-22',4,1,11968);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,29,'2021-11-06',6,1,18152);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,50,'2022-10-13',5,2,41214);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,22,'2021-11-20',5,2,20685);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,20,'2022-11-05',1,1,2242);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,18,'2022-10-13',1,2,44254);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,16,'2023-02-11',4,2,30205);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,30,'2023-01-20',1,1,34652);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,67,'2022-10-14',5,1,22429);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,68,'2022-06-29',2,1,12701);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,22,'2023-03-24',6,1,10784);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,72,'2021-08-19',3,2,38130);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,99,'2021-08-11',3,1,31509);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,26,'2023-03-26',4,1,2551);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,82,'2022-06-04',3,2,34696);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,62,'2021-10-07',4,2,32103);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,36,'2022-11-05',3,1,11659);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,30,'2023-02-21',6,2,4254);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,41,'2021-11-07',1,1,24413);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,1,'2022-03-24',3,2,19389);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,42,'2022-06-05',2,1,14601);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,96,'2023-02-24',3,1,14482);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,89,'2023-02-18',3,1,18427);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,85,'2022-10-13',4,1,41392);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,35,'2022-08-05',6,2,10810);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,96,'2022-03-19',6,2,11931);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,12,'2022-05-05',2,1,5390);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,96,'2023-02-13',6,1,4063);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,53,'2022-07-13',6,2,17448);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,61,'2022-07-29',2,1,36070);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,17,'2022-09-16',4,1,37541);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,73,'2021-10-26',5,2,20989);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,41,'2022-11-11',2,2,5490);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,79,'2023-01-08',1,2,44678);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,68,'2023-03-11',3,1,19618);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,9,'2021-08-24',3,2,19537);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,69,'2022-10-13',4,2,2415);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,83,'2022-04-07',4,2,8698);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,36,'2022-10-17',1,1,16970);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,80,'2021-10-21',5,2,15554);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,64,'2022-01-07',4,1,33437);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,1,'2021-08-05',5,1,38527);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,18,'2022-04-08',1,2,14353);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,51,'2022-09-08',1,2,24108);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,69,'2023-01-22',6,2,4782);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,72,'2022-01-09',2,2,5897);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,86,'2022-01-20',4,1,6738);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,48,'2023-02-15',1,1,43614);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,65,'2022-07-16',3,2,13833);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,79,'2022-03-12',4,2,17973);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,56,'2022-11-03',4,2,25838);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,94,'2022-12-10',1,1,15462);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,21,'2021-10-18',6,1,18024);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,80,'2022-12-06',4,2,19127);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,55,'2022-04-16',5,2,20035);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,58,'2022-01-14',5,1,34574);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,50,'2022-06-12',3,1,4970);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,36,'2022-01-05',4,1,5659);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,6,'2021-10-18',5,1,13905);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,88,'2022-02-20',4,2,30732);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,95,'2021-08-05',6,2,40765);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,6,'2021-09-09',1,2,27848);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,33,'2022-11-20',3,1,12389);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,14,'2022-04-24',5,1,12352);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,25,'2022-01-18',3,2,20134);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,90,'2022-10-30',5,1,3902);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,23,'2022-11-11',6,2,9189);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,84,'2022-07-26',2,2,12689);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,54,'2021-10-03',4,2,40610);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,44,'2022-11-27',4,1,18417);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,64,'2021-12-01',2,2,40055);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,99,'2022-03-13',6,1,43430);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,18,'2023-01-20',1,1,35880);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,72,'2021-12-05',4,2,4195);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,60,'2022-02-14',5,1,33953);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,39,'2021-11-04',5,2,4419);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,42,'2023-03-30',1,1,14548);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,51,'2021-10-22',5,1,34053);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,52,'2022-06-03',2,1,2740);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,46,'2023-01-17',5,1,26226);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,95,'2021-11-12',4,2,7109);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,53,'2021-12-04',3,2,35095);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,2,'2022-04-15',2,2,12402);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,12,'2021-08-12',1,2,39344);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,36,'2022-08-19',5,2,35495);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,9,'2021-11-10',3,2,12516);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,22,'2021-11-19',3,1,14273);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,86,'2022-12-02',2,1,40181);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,39,'2022-07-03',4,1,16270);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,100,'2022-12-21',3,2,5192);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,39,'2022-10-11',2,1,43251);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,93,'2021-08-13',3,1,30032);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,10,'2023-03-07',5,1,20259);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,90,'2023-01-24',5,1,35106);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,69,'2022-12-20',4,1,11210);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,31,'2022-10-11',5,2,17810);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,52,'2022-07-29',1,2,27470);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,70,'2022-06-06',2,1,43076);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,86,'2022-05-11',2,1,36941);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,80,'2022-11-02',5,1,9168);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,79,'2021-12-06',2,1,7399);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,47,'2023-02-23',2,2,31870);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,54,'2021-08-09',6,2,41950);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,36,'2023-02-18',1,2,16006);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,23,'2022-03-08',3,1,3161);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,96,'2023-02-01',2,1,31851);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,31,'2022-07-14',5,1,21804);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,89,'2022-01-21',6,1,8825);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,91,'2023-03-25',3,1,34110);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,85,'2022-06-13',6,2,28715);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,6,'2022-02-23',5,2,5556);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,17,'2022-04-17',6,2,6677);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,22,'2022-12-02',5,1,36040);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,44,'2022-03-31',2,2,34354);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,1,'2023-02-18',1,2,5111);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,78,'2021-08-11',5,1,6654);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,61,'2022-10-14',4,1,32092);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,82,'2021-09-24',1,1,43072);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,62,'2022-06-08',4,1,27923);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,99,'2022-10-06',4,1,44050);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,81,'2022-05-26',5,1,18909);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,87,'2022-12-12',3,2,7347);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,24,'2023-01-22',4,1,16255);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,1,'2021-08-14',1,1,37188);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,29,'2022-10-17',3,2,33848);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,50,'2022-09-28',5,1,15913);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,6,'2023-02-17',6,1,10341);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,60,'2022-08-13',2,2,29849);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,50,'2022-08-06',6,1,16696);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,33,'2022-01-14',1,2,21945);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,6,'2022-10-29',4,2,12162);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,100,'2022-10-14',4,1,37138);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,63,'2021-11-22',5,1,5986);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,62,'2023-01-15',2,1,6721);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,5,'2023-03-29',2,2,8761);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,18,'2021-12-08',4,2,5777);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (2,82,'2022-07-11',3,2,38224);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,85,'2022-06-13',3,2,37378);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,43,'2022-06-12',6,1,37112);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,28,'2023-03-02',6,1,10684);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,33,'2022-09-26',3,2,1959);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (1,5,'2021-12-06',6,1,17738);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (3,24,'2022-05-24',6,2,30098);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (4,28,'2023-03-11',3,1,22684);
INSERT INTO COMPRAS(id_producto, id_cliente, fecha_venta, id_forma_de_pago, forma_compra, monto_venta) VALUES (5,24,'2022-01-12',6,1,22689);

-- Procedimiento Almacenado que permite automatizar el ingreso de datos en la tabla personal
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Insertar_personal`(
    IN id_area INT,
    IN nombre text,
    IN apellido text,
    IN dni VARCHAR(255),
    IN fecha_nacimiento DATE,
    IN fecha_ingreso DATE,
    IN direccion VARCHAR(255),
    IN localidad VARCHAR(255),
    IN provincia VARCHAR(255),
    IN pais VARCHAR(255),
    IN email VARCHAR(255)
)
BEGIN
    -- controlo que el id sea entre 1 y 5
    IF id_area BETWEEN 1 AND 5 THEN
        -- procedo a ingresar
        INSERT INTO Personal (Id_Area, Nombre, Apellido, DNI, Fecha_Nacimiento, Fecha_Ingreso, Direccion, Localidad, Provincia, Pais, Email)
        VALUES (id_area, nombre, apellido, dni, fecha_nacimiento, fecha_ingreso, direccion, localidad, provincia, pais, email);
    ELSE
        -- si se ingresa mal mostrar mensaje de error
        SELECT 'El valor de id_area debe estar entre 1 y 5';
    END IF;
END$$
DELIMITER ;

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

-- ------------------------------------------------------------------------

-- Triggers (Creacion de tablas auditoria tambien)
-- Creacion de Trigger  Numero 1.
-- Se dispara cuando en la tabla personal , se ingresa un nuevo Usuario
-- Solo va a cargar id_area, nombre, apellido, dni, email,fecha_accion,usuario,accion
-- Use el SP  De ingreso Personal (solicitado en entrega anterior ) para automatizarlo.
-- Creacion de la tabla auditoria  que va a llevar un registro de la insercion nuevos empleados en la tabla personal

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


-- Creacion de Triggers numero 2
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

