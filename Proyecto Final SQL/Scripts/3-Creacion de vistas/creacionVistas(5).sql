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