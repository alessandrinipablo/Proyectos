   use proyectofinal;
   
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
