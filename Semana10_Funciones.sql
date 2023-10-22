-- Views: guardar consultas
-- Functions: admite parámetros y retorna un resultado
select *
from [Order Details]
go
--Ejercicio 11 Mostrar el ranking de venta anual por país de origen del empleado, tomando como base la fecha de
--las órdenes, y mostrando el resultado por año y venta total (descendente). 

--Si yo quisiera calcular el monto de que se ha vendido en este producto 
select *, UnitPrice*Quantity from [Order Details]
go
select *, UnitPrice*Quantity*(1-Discount) from [Order Details]
go
--El costo total de la orden 
select OrderID, sum(UnitPrice*Quantity*(1-Discount)) from [Order Details]
group by OrderID
go
--El monto total que vendio ese empleado
select EmployeeID, sum(UnitPrice*Quantity*(1-Discount))
from [Order Details] as OD
	join Orders as O on OD.OrderID = O.OrderID
group by EmployeeID
go
--ya tenemos el monto total
select Country, sum(UnitPrice*Quantity*(1-Discount))
from [Order Details] as OD
	join Orders as O on OD.OrderID = O.OrderID
	join Employees as E on O.EmployeeID = E.EmployeeID
group by Country
go
select Country, YEAR(OrderDate) as Year, sum(UnitPrice * Quantity * (1 - Discount)) as Total
from [Order Details] as OD
         join Orders as O on OD.OrderID = O.OrderID
         join Employees as E on O.EmployeeID = E.EmployeeID
group by Country, YEAR(OrderDate)
order by Total desc
go
-- FUNCIONES--------------------------------------------------------
select count(OrderID)
from Orders
where YEAR(OrderDate) = 2016
-- Crear una función que retorne la cantidad de pedidos realizados en un
-- determinado año

create function FOrdersQuantityByYear(@Year int) returns int 
begin
    declare @Quantity int
    set @Quantity = (select count(OrderID)
                     from Orders
                     where YEAR(OrderDate) = @Year)
    return @Quantity
end
go
select dbo.FOrdersQuantityByYear(2018)
go
--
create function FUnitsQuantityByCountry(@Country varchar(15)) returns int
begin
    declare @Quantity int
    set @Quantity = (select sum(Quantity) as Quantity
                     from [Order Details] as OD
                              join Orders as O on OD.OrderID = O.OrderID
                     where ShipCountry = @Country
                     group by ShipCountry)
    if @Quantity is null
        set @Quantity = 0
    return @Quantity
end
go

select dbo.FUnitsQuantityByCountry('Peru')
go

--------------------------------------------
-- Indicar los nombres de los clientes que no hicieron pedidos en un
-- determinado año

create function FCustomersWithoutOrdersByYear(@Year int)
    returns table
        return
            (
                select CustomerID, CompanyName
                from Customers
                where CustomerID not in (select distinct CustomerID
                                         from Orders
                                         where Year(OrderDate) = @Year)
            )
go

select *
from dbo.FCustomersWithoutOrdersByYear (2018)
go

