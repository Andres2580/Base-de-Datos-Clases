--TRIGGER
create trigger TRIPersons on andres.Person
for insert
as
begin
	print ('Se actualizp un registro')
	select * from deleted
	select * from inserted

end
go
update andres.Person set FirstName = 'Pedro'
	where PersonID = 11
go
select * from andres.Person
go
--SQHEMA Y PONER VALORES
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
-- Pregunta 1
create database reclamos
go

use reclamos
go

create table estudiantes(
	codigo nchar(3) not null,
	nombre nvarchar(10) not null,
	apellido_paterno nvarchar(15) not null,
	apellido_materno nvarchar(15) not null,
	fecha_nacimiento date not null,
	direccion nvarchar(40) not null,
	categoria nvarchar(20) not null,
	constraint pk_estudiantes primary key (codigo)
)
go

create table cursos (
	codigo	int not null,
	nombre nvarchar(25) not null,
	vacantes int null,
	matriculados int null,
	profesor nvarchar(50) not null,
	costo money not null,
	creditos int not null,
	constraint pk_cursos primary key (codigo)
)
go

create table matriculas (
	codigo int not null identity(1,1),
	codigo_estudiante nchar(3) not null,
	codigo_curso int not null,
	horas int not null,
	fecha_reserva date null,
	fecha_matricula date null,
	mensualidad money not null,
	control_proceso nvarchar(15) not null,
	constraint pk_matriculas primary key (codigo),						--estamos sacando de la tabla estudiantes y la columna que estamos tomando es codigo
	constraint fk_estudiantes_matriculas foreign key (codigo_estudiante) references estudiantes (codigo),
	constraint fk_cursos_matriculas foreign key (codigo_curso) references cursos (codigo)
)
go
create table auditorias_matriculas (
	codigo int not null identity(1,1),
	fecha_registro date null,
	codigo_matricula int null,
	descripcion nvarchar(50) null,
	usuario nvarchar(50) null,
	constraint pk_auditorias_matriculas primary key (codigo)
)
go

--char (4) -> 4 caracteres (asignado 1 byte para cada caracter) - 8 bits 255
--nchar (4) -> 4 caracteres (asignado 2 byte para cada caracter) - 16 bits 256*256-1
--varchar (10) -> 0 a 10 caracteres

--PREGUNTA 3
create procedure insertar_matricula
	@codigo_estudiante nchar(3),
	@codigo_curso int,
	@horas int,
	@mensualidad money,
	@control_proceso nvarchar(15) = 'Reservado'
as
begin
	begin try
		begin transaction--empiezo la transaccion
			insert into matriculas (codigo_estudiante, codigo_curso, horas, fecha_reserva,
			mensualidad, control_proceso)
			values (@codigo_estudiante, @codigo_curso, @horas, getdate(), @mensualidad, @control_proceso)
			print ('Proceso de matrícula conforme')
		commit--confirmo
	end try
	begin catch
		print error_message()		
		rollback transaction
	end catch

end
go
--PREGUNTA 4
create procedure USPactualizar_matricula
    --para modificar matricula
	@codigo_matricula int,
	@control_proceso nvarchar(15) = 'Matriculado',
	@fecha_matricula date
as
begin
	begin try
		begin transaction
			update matriculas 
			set control_proceso = @control_proceso, fecha_matricula = getdate()
			where codigo = @codigo_matricula and control_proceso = 'Reservado'
			print ('Proceso de matrícula actualizado')--se debe controlar
		commit transaction
	end try
	begin catch 
		print error_message()
		rollback 
	end catch
end
go

create procedure actualizar_matricula
    --para modificar matricula
	@codigo_matricula int,
	@control_proceso nvarchar(15) = 'Matriculado',
	@fecha_matricula date
as
begin
	begin try
		begin transaction

			if (select count(*) from matriculas where codigo = @codigo_matricula and control_proceso = 'Reservado') = 0  
			begin
				update matriculas 
				set control_proceso = @control_proceso, fecha_matricula = getdate()
				where codigo = @codigo_matricula and control_proceso = 'Reservado'
				print ('Proceso de matrícula actualizado')
				commit transaction
			end 
			else 
			begin
				print ('La matrícula ya se encuentra en estado de matriculado')
				rollback
			end		
	end try
	begin catch 
		print error_message()
		rollback 
	end catch
end
go
exec actualizar_matricula @codigo_matricula = 123, @control_proceso = 'Matriculado', @fecha_matricula = '2023-11-07';
--PREGUNTA 5
create trigger tri_auditorias_matriculas 
on matriculas
for insert, update
as
begin--solamente voy a tener registros en deleted si es que habido una actualizacion
	--deleted: (delete) /update
	--inserted: insert / update

	--insertar
										--vamos a poner q sea el usuario que ha ejecutado el query(suser_sname())
	insert into auditorias_matriculas (codigo_matricula,descripcion, fecha_registro, usuario)
	select codigo, 'Matricula Actualizada', getdate(), suser_sname()  from inserted 
	
	--actualizar
	insert into auditorias_matriculas (codigo_matricula,descripcion, fecha_registro, usuario)
	select codigo, 'Matricula Reservada', getdate(), suser_sname()  from inserted 
	
	
end
go

create trigger tri_auditorias_matriculas 
on matriculas
for insert, update
as
begin
	-- que existan registros en deleted()
	if exists  (select * from inserted)
	begin -- que existan registros en deleted(que he actualizado) - no hay ningun registro en deleted - sino esta en borrado
		if exists (select * from deleted)
		begin											--vamos a poner q sea el usuario que ha ejecutado el query(suser_sname())
			insert into auditorias_matriculas (codigo_matricula,descripcion, fecha_registro, usuario)
			select codigo, 'Matricula Actualizada', getdate(), suser_sname()  from inserted 
		end
		else
		begin
			insert into auditorias_matriculas (codigo_matricula,descripcion, fecha_registro, usuario)
			select codigo, 'Matricula Reservada', getdate(), suser_sname()  from inserted 
		end
		
	end
end
go

--PREGUNTA 6
select count(codigo)
from estudiantes
where categoria  = @categoria
GO
													--TDato de...
create function f_cantidad_estudiantes_por_categoria(@categoria nvarchar(20)) returns int
as

begin
	declare @cantidad int
	set @cantidad = (select count(codigo)
				from estudiantes
				where categoria  = @categoria)
	return @cantidad
end
go

--PREGUNTA 7
create function f_cantidad_disponibles_por_curso(@codigo_curso int) returns int
as

begin
	declare @cantidad int		--se retorna
	set @cantidad = (select sum(vacantes-matriculados)
				from cursos
				where codigo  = @codigo_curso)
	return @cantidad
end
go
