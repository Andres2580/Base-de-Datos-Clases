--Ordenados en base a Precio Unitario
select ProductName, UnitPrice
from Products
where UnitPrice > 18 and UnitPrice < 100
order by UnitPrice desc

--Ejercicio 2
select Distinct Country from Customers
order by Country
go

--Ejercicio 3
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
select count(CustomerID) as CustomerQuantity from Customers
go
--Ejercicio 6
--min
select max(UnitPrice)
from Products
go

--Indicar la cantidad de paises de procedencia de los clientes
select count(distinct Country) as CountryQuantity from Customers
go

--Indicar la cantidad de clientes cuya procedencia sea Alemania
select count(*)
from Customers
where Country in ('Germany')
go
--Indicar la cantidad de clientes por pais de procedenca
select Country, count(*)
from Customers
group by Country
go
--Estamos mostrando los paises de cada uno de los clientes
select Country
from Customers
order by Country
