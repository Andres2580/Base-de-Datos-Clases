-- ddl:definir las estructuras de base datos (base datos, tablas, etc.)
create database stayhub
go

use stayhub
go

create table servicios (
    codigo int not null,
    nombre varchar(100) not null,
    constraint pk_servicios primary key (codigo)
)
go

--dml: manipulacion de datos
-- insert: agrega/inserta nuevas filas a una tabla
insert into servicios (codigo, nombre) values (1, 'Wi-fi')
go

--select: recupera filas de acuerdo a una condicion
select * from servicios

drop table servicios


CREATE TABLE alojamientos
(
  codigo             int          NOT NULL,
  titulo             varchar(100),
  precio             money       ,
  cantidad_huespedes int         ,
  direccion          varchar(255),
  codigo_anfitrion   int          NOT NULL,
  codigo_ciudad      int          NOT NULL,
  codigo_alojamiento int          NOT NULL,
  CONSTRAINT PK_alojamientos PRIMARY KEY (codigo)
)
GO

CREATE TABLE anfitriones
(
  codigo             int          NOT NULL,
  nombres            varchar(100),
  apellido_paterno   varchar(100),
  apellido_materno   varchar(100),
  correo_electronico varchar(100),
  CONSTRAINT PK_anfitriones PRIMARY KEY (codigo)
)
GO

CREATE TABLE calificaciones
(
  codigo_reservas int  NOT NULL,
  calificacion    int ,
  comentario      text,
  fecha           date,
  CONSTRAINT PK_calificaciones PRIMARY KEY (codigo_reservas)
)
GO

CREATE TABLE ciudades
(
  codigo      int          NOT NULL,
  nombre      varchar(100),
  codigo_pais int          NOT NULL,
  CONSTRAINT PK_ciudades PRIMARY KEY (codigo)
)
GO

CREATE TABLE contactos
(
  telefono         varchar(20) NOT NULL,
  codigo_anfitrion int         NOT NULL,
  CONSTRAINT PK_contactos PRIMARY KEY (telefono)
)
GO

CREATE TABLE estados
(
  codigo int          NOT NULL,
  nombre varchar(100),
  CONSTRAINT PK_estados PRIMARY KEY (codigo)
)
GO

CREATE TABLE estados_reservas
(
  codigo_reserva int  NOT NULL,
  codigo_estado  int  NOT NULL,
  fecha          date,
  CONSTRAINT PK_estados_reservas PRIMARY KEY (codigo_reserva, codigo_estado)
)
GO

CREATE TABLE paises
(
  codigo int          NOT NULL,
  nombre varchar(100),
  CONSTRAINT PK_paises PRIMARY KEY (codigo)
)
GO

CREATE TABLE reservas
(
  codigo             int  NOT NULL,
  fecha_reserva      date,
  fecha_entrada      date,
  fecha_salida       date,
  codigo_alojamiento int  NOT NULL,
  codigo_usuario     int  NOT NULL,
  CONSTRAINT PK_reservas PRIMARY KEY (codigo)
)
GO

CREATE TABLE servicios
(
  codigo int          NOT NULL,
  nombre varchar(100),
  CONSTRAINT PK_servicios PRIMARY KEY (codigo)
)
GO

CREATE TABLE servicios_alojamientos
(
  codigo_alojamiento int NOT NULL,
  codigo_servicio    int NOT NULL,
  CONSTRAINT PK_servicios_alojamientos PRIMARY KEY (codigo_alojamiento, codigo_servicio)
)
GO

CREATE TABLE tipo_alojamientos
(
  codigo      int  NOT NULL,
  descripcion text,
  CONSTRAINT PK_tipo_alojamientos PRIMARY KEY (codigo)
)
GO

CREATE TABLE usuarios
(
  codigo             int          NOT NULL,
  nombre             varchar(100),
  apellido_paterno   varchar(100),
  apellido_materno   varchar(100),
  correo_electronico varchar(100),
  telefono           varchar(100),
  CONSTRAINT PK_usuarios PRIMARY KEY (codigo)
)
GO

ALTER TABLE alojamientos
  ADD CONSTRAINT FK_anfitriones_TO_alojamientos
    FOREIGN KEY (codigo_anfitrion)
    REFERENCES anfitriones (codigo)
GO

ALTER TABLE contactos
  ADD CONSTRAINT FK_anfitriones_TO_contactos
    FOREIGN KEY (codigo_anfitrion)
    REFERENCES anfitriones (codigo)
GO

ALTER TABLE alojamientos
  ADD CONSTRAINT FK_ciudades_TO_alojamientos
    FOREIGN KEY (codigo_ciudad)
    REFERENCES ciudades (codigo)
GO

ALTER TABLE servicios_alojamientos
  ADD CONSTRAINT FK_alojamientos_TO_servicios_alojamientos
    FOREIGN KEY (codigo_alojamiento)
    REFERENCES alojamientos (codigo)
GO

ALTER TABLE servicios_alojamientos
  ADD CONSTRAINT FK_servicios_TO_servicios_alojamientos
    FOREIGN KEY (codigo_servicio)
    REFERENCES servicios (codigo)
GO

ALTER TABLE ciudades
  ADD CONSTRAINT FK_paises_TO_ciudades
    FOREIGN KEY (codigo_pais)
    REFERENCES paises (codigo)
GO

ALTER TABLE alojamientos
  ADD CONSTRAINT FK_tipo_alojamientos_TO_alojamientos
    FOREIGN KEY (codigo_alojamiento)
    REFERENCES tipo_alojamientos (codigo)
GO

ALTER TABLE calificaciones
  ADD CONSTRAINT FK_reservas_TO_calificaciones
    FOREIGN KEY (codigo_reservas)
    REFERENCES reservas (codigo)
GO

ALTER TABLE reservas
  ADD CONSTRAINT FK_alojamientos_TO_reservas
    FOREIGN KEY (codigo_alojamiento)
    REFERENCES alojamientos (codigo)
GO

ALTER TABLE reservas
  ADD CONSTRAINT FK_usuarios_TO_reservas
    FOREIGN KEY (codigo_usuario)
    REFERENCES usuarios (codigo)
GO

ALTER TABLE estados_reservas
  ADD CONSTRAINT FK_reservas_TO_estados_reservas
    FOREIGN KEY (codigo_reserva)
    REFERENCES reservas (codigo)
GO

ALTER TABLE estados_reservas
  ADD CONSTRAINT FK_estados_TO_estados_reservas
    FOREIGN KEY (codigo_estado)
    REFERENCES estados (codigo)
GO

insert paises (codigo, nombre)
values (1, 'Peru'),
    (2, 'Bolivia'),
    (3, 'Chile')
GO

insert ciudades (codigo, nombre, codigo_pais)
values (1, 'Lima', 1)
GO

create table empleados (
    codigo int not null  identity (1,1),
    nombre varchar(100) not null,
    constraint pk_empleados primary key (codigo)
)
GO

insert empleados (nombre)
values ('David'), ('Rosa'), ('Carmen'), ('Jorge')
go
-- recuperar filas(select)
-- * te va devolver todas las columnas
select codigo, nombre from empleados
where codigo = 3

update empleados
set nombre = 'Carla'
where codigo = 3
go
--No exsite este tabla es temporal
select * from empleados
go

select codigo as id, nombre as city from ciudades
go

delete from empleados
where nombre = 'Jorge'
go

select * from empleados
go

insert empleados (nombre) values  ('Eduardo')
go

select * from empleados
go
