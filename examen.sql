CREATE DATABASE BecasNeosRafaelRuiz
go
use BecasNeosRafaelRuiz
drop table AlumnosConBeca
go 
drop table AlumnosSolicitantes
go
create table AlumnosSolicitantes ( 
dni varchar (255) primary key   ,
nombre varchar (255),
nota int , 
cuantía int)
go
create table AlumnosConBeca(
dni varchar (255) references AlumnosSolicitantes(dni) primary key   ,
nombre varchar (255),
cuantía int)

go
insert into AlumnosSolicitantes values ('11111111A', 'Ana Albaricoque', 9.8, 150) 
insert into AlumnosSolicitantes values ('22222222B', 'Beatriz Blanco', 9.5, 200) 
insert into AlumnosSolicitantes values ('33333333C', 'Cristina Cortina', 7.6, 100) 
insert into AlumnosSolicitantes values ('44444444D', 'Daniel Dado', 7.6, 100) 
insert into AlumnosSolicitantes values ('55555555E', 'Enriqueta Espera', 6.9, 150) 
insert into AlumnosSolicitantes values ('66666666F', 'Federico Frio', 6.8, 50) 
insert into AlumnosSolicitantes values ('77777777G', 'Guillermo Gil', 6.1, 100) 

go
CREATE or alter PROCEDURE  asignarBecas
 @totalDinero int 
AS
BEGIN

DECLARE 
@dni varchar(255),
@nombre varchar(255),
@nota int,
@cuantía int
DECLARE ccAlumnosSolicitantes CURSOR FOR

SELECT dni, nombre, nota,cuantía
FROM AlumnosSolicitantes
order by nota desc, nombre asc

OPEN ccAlumnosSolicitantes
FETCH ccAlumnosSolicitantes INTO @dni, @nombre, @nota, @cuantía
WHILE (@@FETCH_STATUS = 0 )
BEGIN
if (@totalDinero-@cuantía<0) 
BEGIN
print 'No queda mas dinero para la beca' + @nombre + 'nota '+ cast (@nota as varchar (255))  
END

if (@totalDinero-@cuantía>0)
BEGIN
print '---------------------------------------' 
insert into AlumnosConBeca values (@dni, @nombre, @cuantía) 
print 'Beca concedida importe total ' + cast (@cuantía as varchar (255)) 
print '---------------------------------------' 
set @totalDinero=@totalDinero-@cuantía
END



PRINT 'dni: ' + @dni + 'nombre: ' + @nombre + 'nota: ' + cast(@nota as varchar(255)) + ' cuantia: ' +  cast(@cuantía as varchar(255))




FETCH ccAlumnosSolicitantes INTO @dni, @nombre, @nota, @cuantía
END
CLOSE ccAlumnosSolicitantes
DEALLOCATE ccAlumnosSolicitantes

print '---------------------------------------' 
print 'han sobrado ' + cast (@totalDinero as varchar (255)) 
print '---------------------------------------' 
END
GO


begin transaction 
exec asignarBecas 520
select * from AlumnosConBeca
rollback transaction
commit transaction


