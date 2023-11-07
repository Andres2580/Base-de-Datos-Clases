--Ordenados en base a Precio Unitario'
--Listar los nombres de los productos cuyo precio unitario sea mayor a 18 pero menor a 100,
--mostrando primero los productos de mayor precio
select ProductName, UnitPrice
from Products
where UnitPrice > 18 and UnitPrice < 100
order by UnitPrice desc

--Ejercicio 2
--Indicar los países de procedencia de los clientes
--el Distinct -> para que no se repite
select Distinct Country 
from Customers
order by Country
go

--Ejercicio 3
--Indicar los nombres de los clientes que no sean de los siguientes países de Francia, Brasil y México
select CompanyName, Country
from Customers
where Country <> 'France' and Country <> 'Brazil' and Country <> 'Mexico'
go
--Opcion 2
select CompanyName, Country
from Customers
where Country not in ('France','Brazil','Mexico')
go

--Ejercicio 4
--Indicar los nombres de clientes que comiencen con la letra L o la letra M
select CompanyName
from Customers
where substring(CompanyName,1,1) = 'L' or substring(CompanyName,1,1) = 'M'
go

select CompanyName
from Customers
where CompanyName like 'L%' or CompanyName like 'M%'
go

select CompanyName
from Customers
where CompanyName like '[LM]%'
go

--Ejercicio 5
--. Indicar la cantidad de clientes
select count(CustomerID) as CustomerQuantity 
from Customers
go
--Ejercicio 6
--Indicar el mayor precio unitario de los productos
--min
select max(UnitPrice)
from Products
go

--Indicar la cantidad de paises de procedencia de los clientes
select count(distinct Country) as CountryQuantity 
from Customers
go

--Indicar la cantidad de clientes cuya procedencia sea Alemania
select count(*)
from Customers
where Country in ('Germany')
go
--Indicar la cantidad de clientes por pais de procedenca
select Country, count(*) as CantidadClientes
from Customers
group by Country
go
--Estamos mostrando los paises de cada uno de los clientes
select Country
from Customers
order by Country
