--Indicar la cantidad de clientes por pais de procedencia
select Country, count(*)
from Customers
group by Country
go

--views: guardar conultas 
-- Functios: admite parametros y retorna un resultado
nombre, codigo -> albumes
duracion, codigo_album -> canciones

select albumes.nombre, sum(duracion) total
from albumes, canciones
where albumes.codigo = codigo_album
group by albumes.nombre
having sum(duracion) > 3000

select a.nombre, sum(duracion) total
from albumes a
	join canciones c on a.codigo = codigo_album
group by a.nombre
having sum(duracion) > 3000

--la fecha de review de los productos
--quiero el nameProduct y la dateReview
--Solo se va a listar los nombres de productos que tienen un review
select ProductoName, DateReview
from Producto p
	inner join ProductoReview r on ProductID = ProductReviewID

--Mostrar los nombres de los productos con la fecha de revision,
--incluyendo aquellos que no tienen review
select ProductoName, DateReview
from Producto p 
	left join ProductoReview r on ProductID = ProductReviewID

--Mostrar los nombres de los procductos que no tienen review
--si quires considerar solamente aquellos casos donde no tengan reviews
--el producto no tiene revision
select ProductoName, DateReview
from Producto p 
	left join ProductoReview r on ProductID = ProductReviewID
	where ProductReviewID is null

--Quiero el nombre del cliente y la cantidad de pedidos que hiso y luego la suma
--el monto total de todos los pedidos que a hecho un cliente
select NomCliente, count(*) Total, sum(PrecioUnidad*Cantidad) Monto
from Pedidoscabe p --cabecera
	join Cliente c on p.IdCliente = c.IdCliente
    join Pedidosdeta d on p.IdPedido = d.IdPedido--detalle
group by NomCliente
