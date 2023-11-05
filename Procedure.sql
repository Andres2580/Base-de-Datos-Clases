-- Crear un procedimiento con los nombres que empiese con CA 
select CompanyName
from Customers
where CompanyName like 'ca%'
go
--alter -> '%'
create procedure USPFindCustomerByCompanyName
	@CompanyName varchar(15) -- ='' TODOS LOS CLIENTES
as
begin
	select CompanyName
	from Customers
	where CompanyName like concat('%',@CompanyName, '%')
end
go

exec USPFindCustomerByCompanyName @CompanyName = 'l'--0
go

--crear schema -> un conjunto de tablas que se encuentra en una base de datos
-- ddl (Data definition language)
-- Crear, modificar, eliminar los objetos de base de datos (estructuras)
-- database / schema / table / view / function / stored procedure
-- create
-- alter ->modificar
-- drop ->es para la estructura

-- dml (Data manipulation language)
-- Insertar, actualizar, eliminar filas (registros) en las tablas
-- insert ->insertar datos agregar filas
-- update ->actualisar datos
-- delete ->modificar data
-- select

--insertar un nuevo cliente(fila)
insert into Customers(CustomerID, CompanyName)
	values ('ZARAA', 'Zara Company')
go
--ERROR con insert
create procedure USPInsertCustomer
	@CustomerID nchar(5),
	@CompanyName nvarchar(40)
as
begin
	insert into Customers (CustomerID, CompanyName)
	values (@CustomerID, @CompanyName)
end
go
--=====================
create procedure USPInsertCustomer
	@CustomerID nchar(5),
	@CompanyName nvarchar(40)
as
begin
	begin try
		begin transaction
			insert into Customers (CustomerID, CompanyName)
			values (@CustomerID, @CompanyName)
		commit transaction
		print 'Cliente insertado'
	end try
	begin catch
		print error_message()
		rollback transaction
	end catch
end
go

exec USPInsertCustomer @CustomerID = 'ZAARB', @CompanyName = 'Zara Company'
go

select * from Customers
go
--
--la cantidad de pedidos que hay en un año 
--la fecha de orden
select count(OrderID)
from Orders
where YEAR(OrderDate) = 2017
go
--
create procedure USPTotalOrdersByYear
	@Year int, @Total int output
as
begin
	set @Total =(select count(OrderID)
				from Orders
				where YEAR(OrderDate) = @Year)
end
go

declare @Quantity int
exec USPTotalOrdersByYear @Year = 2017, @Total = @Quantity output
select @Quantity
go
--
--Crear un procedimiento que me borre clientes deacuerdo al codigo
--podria ser que un cliente tenga una orden y entonces no deberia poder borrarlo
create procedure USPDeleteCustomer
@CustomerID nchar(5)
as
begin
	begin try
	begin transaction
		delete from Customers where CustomerID = @CustomerID
	print (concat('Cliente eliminado:', @CustomerID))
	commit transaction
	end try
	begin catch
		print error_message()
		rollback transaction
	end catch
end
go

exec USPDeleteCustomer @CustomerID = 'zaarb'
go
select * from Customers
go
--Transaction(mas de una operacion)

--disparador(TRIGGER - un objeto mas de BD)
create trigger TRCustomer on Customers
for insert
as
begin
	print('Cliente ingresado de manera satisfactoria')
end
go
exec USPInsertCustomer @CustomerID = 'ZAARA', @CompanyName = 'Zara Company'
go
