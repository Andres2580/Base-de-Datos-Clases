create database test
go
use test
go
create schema customer_orders
go
--Esta tabla es de la esquema
create table customer_orders.customers(
	id int not null identity(1,1),
	name varchar(100),
	constraint pk_customers primary key (id)

)
go
create view VTotalOrderByCustomer as
	select O.CustomerID, CompanyName, count(*) as TotalOrders
		from Orders as O
			join Customers as C on O.CustomerID = C.CustomerID
		group by O.CustomerID, CompanyName
go
select * from VTotalOrderByCustomer
go
select CompanyName from VTotalOrderByCustomer
where TotalOrders = (select max(TotalOrders) from VTotalOrderByCustomer)
go
--Crear las sentencias que permitan realizar las siguientes consultas:

--Crear una sentencia que permita determinar el usuario con la mayor cantidad de listas creadas
--Debe incluir sentencias que permitan crear las tablas sobre las cuales se haran las consultas. Cada tabla
--debe estar dentro de un esquema.

--No va venir Recover
--Sobre ese caso se le va pedir que creen las tablas que ustedes consideren necesarias y sobre esas tablas
--que deben estar dentro de una esquema crean las consultas q se le pida en el caso
--==========================================================================
--Ejercicio1 - Muestre el nombre del producto y el nombre su categoría para cada producto.
select ProductName, CategoryName
from Products as P
	join Categories as C on P.CategoryID = C.CategoryID
go
--==========================================================================
--Ejercicio2 - Indicar el nombre del producto con la mayor cantidad de órdenes
--una vista nos permite crear una tabla temporal
--la cantidad de ordenes que hay por cada cliente
--Indicar el nombre del producto con la mayor cantidad de órdenes(PREGUNTA)
select * from VTotalOrderByCustomer
go
--la cantidad de ordenes por cada producto
--donde tenemos la relacion de productos ya las ordenes? (ORDENDETAILS)
select ProductID, OrderID
from [Order Details]
--38 1(Que ese producto ha estado en 38 ordenes)
--Cantidad de ordenes
select ProductID, OrderID,Quantity
from [Order Details]
Order by ProductID
--group by->porque estamos contando las ordenes en base al codigo del producto
select ProductID, count(OrderID) as Total
from [Order Details]
group by ProductID
go
--q hacemos con esta consulta, creamos un view
select OD.ProductID, ProductName, count(OrderID) as Total
from [Order Details] as OD
	join Products as P on OD.ProductID = P.ProductID
group by OD.ProductID, ProductName
go
--CREAR VISTA
create view VTotalOrdersByProduct as
	select OD.ProductID, ProductName, count(OrderID) as Total
	from [Order Details] as OD
		join Products as P on OD.ProductID = P.ProductID
	group by OD.ProductID, ProductName
go
--como puedo ver los datos que me genera esa vista?
select * from VTotalOrdersByProduct
go
--maximo valor
select max(total)
from VTotalOrdersByProduct
go
select ProductID, ProductName, Total
from VTotalOrdersByProduct
where Total = (select max(total)
				from VTotalOrdersByProduct)
go
--==================================================================
--Ejercicio 3 - Indicar la cantidad de órdenes atendidas por cada empleado (mostrar el nombre y apellido de cada empleado)
--que la orden 10258 ha sido antendido por el empleado de codigo 1
--que el empleado del codigo 1 a atendido 123 ordenes
--count(OrderID)-> contar la cantidad de ordenes en base al codigo del empleado
select EmployeeID, OrderID
from Orders
go
select EmployeeID, count(OrderID) as Total 
from Orders
group by EmployeeID
go

--O.EmployeeID(llave foranea en ordenes) E.EmployeeID(PK en empleados)
select O.EmployeeID, concat(LastName,', ',FirstName) as FullName, count(OrderID) as Total
from Orders as O
	join Employees as E on O.EmployeeID = E.EmployeeID
group by O.EmployeeID, LastName, FirstName
go

-- Ejercicio 3.1
-- Mostar los nonbres de los empleados que atendieron una mayor cantidad de pedidos
-- al promedio
create view VTotalOrdersByEmployee as
	select O.EmployeeID, concat(LastName,', ',FirstName) as FullName, count(OrderID) as Total
	from Orders as O
		join Employees as E on O.EmployeeID = E.EmployeeID
	group by O.EmployeeID, LastName, FirstName
go
--el promedio de la columna total
select *
from VTotalOrdersByEmployee
go
select avg(Total)
from VTotalOrdersByEmployee
go
--los clientes han hecho mas de 92 ordenes
select FullName, Total
from VTotalOrdersByEmployee
where Total > (select avg(Total)
				from VTotalOrdersByEmployee)
go
--===========================================================
--¿En que momento vas a aplicar vistas?
--cuando tengas una tabla temporal, una consulta que nos va servir para mas consultas 
--CustomerID no valla ser 2 compañias con el mismo nombre 
-- Ejercicio 4 - Indicar la cantidad de órdenes realizadas por cada cliente (mostrar el nombre de la compañía de cada cliente).
select O.CustomerID, CompanyName, count(OrderID) as Total
from Orders as O
	join Customers as C on O.CustomerID = C.CustomerID
group by O.CustomerID, CompanyName
go
-- Ejercicio 5 - Identificar la relación de clientes (nombre de compañía) que no han realizado pedidos
select CustomerID from Orders
go
select CompanyName
from Customers
where CustomerID not in (select CustomerID from Orders)
go

-- Ejercicio 6 - Muestre el código y nombre de todos los clientes (nombre de compañía) que tienen órdenes pendientes de despachar.
select distinct O.CustomerID, CompanyName
from Orders as O
	join Customers as C on O.CustomerID = C.CustomerID
where ShippedDate is null
go
-- Ejercicio 7 - . Muestre el código y nombre de todos los clientes (nombre de compañía) que tienen órdenes
-- pendientes de despachar, y la cantidad de órdenes con esa característica.
select O.CustomerID, CompanyName, count(OrderID) as Total
from Orders as O
	join Customers as C on O.CustomerID = C.CustomerID
where ShippedDate is null
group by O.CustomerID, CompanyName
go
select ShipCountry, ShipCity, ShipPostalCode
from Orders
go
--codigo postal de cliente y la ciudad del cliente
select ShipCountry, ShipCity, ShipPostalCode, Country, City, PostalCode
from Orders as O
	join Customers as C on O.CustomerID = C.CustomerID
go
--hay 42 ordenes que han sido enviados a una direccion diferente al cliente
select ShipCountry, ShipCity, ShipPostalCode, Country, City, PostalCode
from Orders as O
	join Customers as C on O.CustomerID = C.CustomerID
where ShipCity <> City or ShipPostalCode <> PostalCode
go
-- Ejercicio 8
--Encontrar los pedidos que debieron despacharse a una ciudad o código postal diferente de la ciudad
--o código postal del cliente que los solicitó. Para estos pedidos, mostrar el país, ciudad y código postal
--del destinatario, así como la cantidad total de pedidos por cada destino.

select ShipCountry, ShipCity, ShipPostalCode, count(OrderID) as Total
from Orders as O
	join Customers as C on O.CustomerID = C.CustomerID
where ShipCity <> City or ShipPostalCode <> PostalCode
group by ShipCountry, ShipCity, ShipPostalCode
go
--======================================================================
select * 
from Employees
-- Ejercicio 10 - Mostrar los nombres y apellidos de los empleados junto con los nombres y apellidos de sus respectivos jefes

select E.EmployeeID, E.LastName, E.FirstName, E.ReportsTo, B.LastName, B.FirstName
from Employees as E
	left join Employees as B on E.ReportsTo = B.EmployeeID

