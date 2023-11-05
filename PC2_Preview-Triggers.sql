--constraint: restricciones/condiciones para las tablas y columnas
--primary key, foreign key, not null, unique, default, check

create database PC2
go

use PC2
go

create schema andres
go

create table andres.Person (
	PersonID int identity(1,1),
	LastName varchar(50) not null,
	FirstName varchar(50) not null,
	City varchar(50),
	Age int,
	constraint PKPersons primary key (PersonID),
	constraint CKPersonAge check (Age > 0)
)
go

insert into andres.Person(LastName, FirstName, City,Age)
	values ('Campos', 'Luis', 'Lima', 25),
			('Toledo', 'Alan', 'Ica', 40),
			('Fuentes', 'Carmen', 'Lima', 35),
			('Catillo', 'Ana', 'Huancayo', 30),
			('Fuentes', 'Pedro', 'Lima', 27)
go

insert into andres.Person(LastName, FirstName,City,Age)
	values ('Towsend', 'Carlos', 'Trujillo', -5)
go

select * from andres.Person
--transaction 
-- Un conjunto	de operaciones (update/insert/delete)

--implicit(el mismo SQL te lo ha cancleado)
--crear transacciones de manera explicit(a) 

begin transaction --iniciar una transaccion explicita 

--cerrar una transaccion
commit transaction --confirma todo el bloque de operaciones dentro de la transaccion 
rollback transaction --cancela todo el bloque de operaciones dentro de la transaccion 

begin try --sentecias que pueden generar errores
	insert into andres.Person(LastName, FirstName,City,Age)
	values ('Towsend', 'Carlos', 'Trujillo', -5)
end try--

begin catch --capturar el error y ejecutar sentencias
	print error_message()
end catch

select @@trancount -- cuenta las transacciones abiertas
go
--que no hay ningun error
select error_message() --muestra el mensaje del error detectado	
select @@error --si el valor es 0 no hya errores
go

select @@TRANCOUNT as OpenTransactions
begin tran
	select @@TRANCOUNT as OpenTransactions
	insert into andres.Person(LastName, FirstName,City,Age)
	values ('Towsend', 'Carlos', 'Trujillo', 15)
commit tran
select @@TRANCOUNT as OpenTransactions
go

select * from andres.Person
go

--Bloque de transacciones
begin tran 
	update andres.Person
	set FirstName = 'Pedro'
	where PersonID = 9

	select * from andres.Person where PersonID = 9
rollback tran
select * from andres.Person where PersonID = 9
go

--triggers
--son procedimientos almacenados que se ejecutan automaticamente ante un evento
--insert /update(actualisas) / delete (dml)
--create / alter / drop (ddl)
--Durante la ejecucion de un trigger sql provee dos tablas temporales
--insert: guardan los datos ingresados/ actualizados / guardan los datos nuevos (despues de hacer update)
--deleted: guardan los datos borrados / guardan los datos antiguos (antes de hacer update)


-- as(vista, funcion, procedimiento)
--si quieres borrarlo agrega el drop y la esquema
create trigger TRIPersons on andres.Person
for insert
as
begin
	print ('Registro de persona ingresado')
end
go
--solo puedes crear 3 triggers
create trigger TRIPersons on andres.Person
for insert
as
begin
	print ('Registro de persona ingresado')
	select * from inserted
end
go

create trigger TRIPersons on andres.Person
for insert
as
begin
	print ('Se elimino un registro')
	select * from deleted
end
go

--quieres hacer algo con esos datos ingresados(automatico)
insert into andres.Person (LastName,FirstName, City, Age)
	values ('Mendoza', 'Frank', 'Lima', 22)
go

select * from andres.Person
go
--se esta guardando el dato de la persona que se acaba de eliminar
delete from andres.Person where PersonID = 12
go

create trigger TRIPersons on andres.Person
for insert
as
begin
	print ('Se actualizp un registro')
	select * from deleted
	select * from inserted

end
go
update andres.Person set FirstName = 'Juan'
	where PersonID = 11
-------------
alter trigger andres.TRIPersons on andres.Person
for insert
as
begin
	print ('Se actualizo un registro')
	select * from deleted
	select LastName,FirstName from inserted
end
go
update andres.Person set FirstName = 'Juan'
	where PersonID = 11
go
