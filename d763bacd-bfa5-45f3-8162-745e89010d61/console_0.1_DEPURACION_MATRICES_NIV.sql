use bd_sga_upse

--para listar carreras
SELECT   * FROM  Bd_Academico.dbo.VW_CARRERAS_OFERTADAS where ID_CARRERA_LOCAL in (2,23)
select * from Bd_Academico..TE_CARRERAS

select * from Bd_Academico..TE_CARRERAS_LOCALIDAD

select * from Bd_Academico..CARRERAS_LOCALES_MODALIDAD_SISTEMA

select * from aca.oferta_modalidad

select * from aca.sistema_estudio

select * from rel.oferta_relaciones

select * from mig.oferta_conexion

select * from mig.oferta_correspondencia

select * from mig.record_oferta where carrera like '%INGLES - MATRIZ%'
--migraciones de ofertas
select distinct ro.id_carrera_ofertada,carrera,facultad,modalidad,sistema_estudio,id_tipo_oferta from mig.record_oferta ro
left join migracion_sga..registros_migracion rm on rm.id_origen = ro.id_carrera_ofertada and rm.id_entidad_relacion = 2
where rm.id_destino is null

select distinct ro.id_carrera_ofertada,carrera,facultad,modalidad,sistema_estudio,id_tipo_oferta,identificacion from mig.record_oferta ro
left join migracion_sga..registros_migracion rm on rm.id_origen = ro.id_carrera_ofertada and rm.id_entidad_relacion = 2
where rm.id_destino is null

select distinct ro.* from mig.record_oferta ro
left join migracion_sga..registros_migracion rm on rm.id_origen = ro.id_carrera_ofertada and rm.id_entidad_relacion = 2
where ro.id_carrera_ofertada in (58,56,96,57,97) and rm.id_destino is null

select * from aca.tipo_ingreso_estudiante

select min(pa.fecha_desde) as fecha_desde,min(rm.fecha_matricula) as fecha_ing,min(ro.id_estudiante_oferta) as id_estudiante_oferta,eo.id_persona
from mig.record_oferta ro
         inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_estudiante_oferta
         inner join mig.record_oferta rod on rod.id_record_oferta = ro.id_record_oferta_padre
         inner join mig.record_matricula rm on rod.id_record_oferta = rm.id_record_oferta
         inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
         inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A' and rod.estado='A' and rod.id_tipo_oferta = 2
and ro.id_estudiante_oferta = 5253
group by eo.id_persona


--     0923132211
select * from mig.record_asignaturas where id_record_oferta = 36364

select * from mig.record_matricula where id_record_matricula = 42703
select * from mig.record_oferta where identificacion='0919799049' order by periodo,id_tipo_oferta
select * from aca.tipo_ingreso_estudiante

select * from Bd_Academico.dbo.TE_INSCRIPCIONES where ID =14370

select distinct ro.id_carrera_ofertada,ro.carrera,ro.facultad,ro.modalidad,ro.sistema_estudio,ro.id_tipo_oferta,ro.identificacion,ro.apellidos,ro.nombres,ro.periodo,
 asp.*                from mig.record_oferta ro
left join bdupse.snu.aspirante asp on asp.identificacion = ro.identificacion
left join migracion_sga..registros_migracion rm on rm.id_origen = ro.id_carrera_ofertada and rm.id_entidad_relacion = 2
where ro.id_carrera_ofertada in (58,56,96,57,97) and rm.id_destino is null

select ID_CARRERA_LOCAL,CG_MODALIDAD,CG_SISTEMA_ESTUDIO,c.ID_CARRERA,c.DURACION,c.CENTRO,c.CODIGO from [bd_academico].[dbo].TE_CARRERAS_LOCALIDAD
   inner join [bd_academico].[dbo].TE_CARRERAS c on TE_CARRERAS_LOCALIDAD.ID_CARRERA = c.ID_CARRERA
where  TE_CARRERAS_LOCALIDAD.ID_CARRERA_LOCAL in (63,64)

select
    eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.id_periodo_academico,p.identificacion,p.apellidos,p.nombres,pa.codigo,o.descripcion,
    te.descripcion,tee.descripcion,tie.descripcion,eo.mantiene_gratuidad,eo.id_malla,eo.fecha_desde,eo.fecha_hasta
--     eo.*
from aca.estudiante_oferta eo
         inner join man.personas p on eo.id_persona = p.id
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
         inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
         left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
where --eo.id_periodo_academico = 91
--     eo.id_estudiante_oferta in (28356,31313)
p.identificacion in ('0919799049')

select distinct id_carrera_ofertada,carrera,modalidad,sistema_estudio   from mig.record_oferta where id_tipo_oferta = 1 and sistema_estudio ='SEMESTRAL'

select * from Bd_Academico..TE_MATRICULAS te where ID_PERSONA = 47187

select * from Bd_Academico..TE_MATRICULAS te where MATRICULA = '12010150946' and ID_PERSONA = 10955

select * from aca.oferta_modalidad

select * from mig.estado_academicos where identificacion ='0302173109'

select * from tmp.SEM_2013_2

--446
select * from aca.tipo_ingreso_estudiante

select * from aca.tipo_estado_estudiante

select * from tmp.SEM_2012_2

select * from  tmp.NIVELACION_SEM_HIS sem
--          where PERIODO in ('2013-1')
-- and sem.CEDULA not in (select s1.CEDULA from tmp.SEM_2014_1 s1)
order by APELLIDOS,NOMBRES

select * from tmp.CASOS_ESPECIALES_NIV-- where periodo is null


--     update ro2 set ro2.id_record_oferta_padre = ro1.id_record_oferta
select
    ro2.*

--     sem.*,ro1.table_name,ro1.id_tipo_estado_estudiante,ro1.id_tipo_ingreso_estudiante
from  tmp.NIVELACION_SEM_HIS sem
         inner join mig.record_oferta ro1 on ro1.identificacion = sem.CEDULA and sem.CARRERA_ACEPTA_CUPO = ro1.carrera
-- inner join mig.record_oferta ro2 on ro2.id_carrera_ofertada = ro1.id_carrera_ofertada and ro2.identificacion = ro1.identificacion and ro2.id_tipo_oferta = 2
inner join mig.record_oferta ro2 on ro2.id_record_oferta_padre = ro1.id_record_oferta
where sem.PERIODO in ('2014-1') and ro1.periodo='2014-1' and sem.EXONERADO='SI'
-- order by sem.APELLIDOS,sem.NOMBRES

-- update sem set sem.EXONERADO = s1.EXONERADO,sem.TIPO_MATRICULA_NIVELACIÓN = s1.[TIPO DE MATRICULA NIVELACIÓN],sem.PERIODO_MATRICULA_NIVELACION=s1.[PERÍODO QUE SE MATRICULA EN NIVELACIÓN],
--                sem.AREA_CURRICULO = s1.[ÁREA DE CURRÍCULO],sem.ESTADO_NIVELACION=s1.[ESTADO DE LA NIVELACIÒN],sem.NOTA_FINAL = s1.[NOTA FINAL]
-- -- select sem.*,s1.USU_ID
-- from  tmp.NIVELACION_SEM_HIS sem
-- inner join tmp.SEM_2013_2 s1 on s1.USU_ID = sem.USU_ID
--  where  sem.PERIODO in ('2013-2')
--comparar matrices validas con la matriz completa
select s1.* from tmp.SEM_2012_2 s1
where s1.CEDULA not in (select sem.CEDULA from  tmp.NIVELACION_SEM_HIS sem where PERIODO in ('2012-2'))
order by APELLIDOS,NOMBREs

select sem.* from tmp.NIVELACION_SEM_HIS sem
where sem.PERIODO in ('2012-2') and sem.CEDULA not in (select s1.CEDULA from  tmp.SEM_2012_2 s1)
order by APELLIDOS,NOMBREs

select s1.* from tmp.SEM_2013_1 s1
where s1.CEDULA not in (select sem.CEDULA from  tmp.NIVELACION_SEM_HIS sem where PERIODO in ('2013-1'))
order by APELLIDOS,NOMBREs

select sem.* from tmp.NIVELACION_SEM_HIS sem
where sem.PERIODO in ('2013-1') and sem.CEDULA not in (select s1.CEDULA from  tmp.SEM_2013_1 s1)
order by APELLIDOS,NOMBREs

select s1.* from tmp.SEM_2013_2 s1
where s1.CEDULA not in (select sem.CEDULA from  tmp.NIVELACION_SEM_HIS sem where PERIODO in ('2013-2'))
order by APELLIDOS,NOMBREs

select sem.* from tmp.NIVELACION_SEM_HIS sem
where sem.PERIODO in ('2013-2') and sem.CEDULA not in (select s1.CEDULA from  tmp.SEM_2013_2 s1)
order by APELLIDOS,NOMBREs

select s1.* from tmp.SEM_2014_1 s1
where s1.CEDULA not in (select sem.CEDULA from  tmp.NIVELACION_SEM_HIS sem where PERIODO in ('2014-1'))
order by APELLIDOS,NOMBREs

select sem.* from tmp.NIVELACION_SEM_HIS sem
where sem.PERIODO in ('2014-1') and sem.CEDULA not in (select s1.CEDULA from  tmp.SEM_2014_1 s1)
order by APELLIDOS,NOMBREs

select sem.* from tmp.NIVELACION_SEM_HIS sem
where sem.PERIODO in ('2014-2') and sem.CEDULA not in (select s1.CEDULA from  tmp.SEM_2014_2 s1)
order by APELLIDOS,NOMBREs

select s1.* from  tmp.SEM_2014_2 s1

select * from man.tipo_identificacion
select * from man.personas where identificacion in ('2250122096')

select * from man.persona_identificacion where id_persona in (72117,59282,64427)

--actualizar matriz general a partir de matriz individual
-- select sem.*
-- update sem set sem.EXONERADO=s1.EXONERADO,sem.TIPO_MATRICULA_NIVELACIÓN=s1.[TIPO DE MATRICULA NIVELACIÓN],sem.PERIODO_MATRICULA_NIVELACION=s1.[PERÍODO QUE SE MATRICULA EN NIVELACIÓN],
--                sem.AREA_CURRICULO=s1.[ÁREA DE CURRÍCULO],sem.ESTADO_NIVELACION=s1.[ESTADO DE LA NIVELACIÒN],sem.NOTA_FINAL=s1.[NOTA FINAL]
-- from tmp.NIVELACION_SEM_HIS sem
-- inner join tmp.SEM_2012_2 s1 on s1.CEDULA = sem.CEDULA
-- where sem.PERIODO in ('2012-2')
--acuas
--446 en 2012-1
--2013-1  real->777     actual->801
--2013-2  real->720     actual->615   faltan 105 sobran 40
--2014-1  real->893     actual->753   faltan->140 por insertar->192  total despues->944 sobran->51
--2014-2  real->987     actual->809   faltan->178 por insertar->186  total despues->944 sobran->51
select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 2
--setear valores de aprobacione en cupos migrados
begin
    declare @periodo varchar(25)='2013-1'
select distinct  --rop.*
    ro.*,SEM.ESTADO_NIVELACION,SEM.NOTA_FINAL,tse.descripcion,rop.id_record_oferta,rop.carrera
from tmp.NIVELACION_SEM_HIS sem
inner join mig.record_oferta ro on ro.identificacion = sem.CEDULA and ro.carrera = sem.CARRERA_ACEPTA_CUPO
and  ro.estado='A' and ro.sistema_estudio='SEMESTRAL' and ro.id_tipo_oferta = 1 and ro.periodo=@periodo
inner join aca.tipo_estado_estudiante tse on tse.id_tipo_estado_estudiante = ro.id_tipo_estado_estudiante
    left join mig.record_oferta rop on rop.id_record_oferta_padre = ro.id_record_oferta and rop.estado='A'
left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
left join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
-- left join bdupse.snu.aspirante asp on asp.identificacion = ro.identificacion
where  sem.PERIODO=@periodo
--      and tse.descripcion='EXONERADO' --and rop.id_record_oferta is null
end

--ver los manes de segunda vez
begin
    declare @periodo varchar(25)='2013-2',@periodo_next varchar(25)='2014-1'
    select distinct
        ro.*,SEM.ESTADO_NIVELACION,SEM.NOTA_FINAL,rm.id_record_matricula,rm.estado_matricula,tse.descripcion
    from tmp.NIVELACION_SEM_HIS sem
     inner join tmp.CASOS_ESPECIALES_NIV ce on ce.CEDULA = sem.CEDULA and ce.PERIODO=@periodo_next
     inner join mig.record_oferta ro on ro.identificacion = sem.CEDULA and ro.carrera = sem.CARRERA_ACEPTA_CUPO
        and  ro.estado='A' and ro.sistema_estudio='SEMESTRAL' and ro.id_tipo_oferta = 1 and ro.periodo=@periodo
    inner join aca.tipo_estado_estudiante tse on tse.id_tipo_estado_estudiante = ro.id_tipo_estado_estudiante
             left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
             left join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
-- left join bdupse.snu.aspirante asp on asp.identificacion = ro.identificacion
    where  sem.PERIODO=@periodo --and ro.id_record_oferta is null
end


--actualizar label aprobados en los records migrados.
-- update ra set ra.aprobado=0,estado_aprobacion='REPROBADO'
-- update ra set ra.aprobado=1,estado_aprobacion='APROBADO'
select distinct rm.*,ro.identificacion
from mig.record_oferta ro
inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
left join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
where ro.id_record_oferta=9702
--rm.periodo='2012-2' and ro.id_tipo_oferta =1 and ra.promedio>=7
select * from mig.record_oferta ro where ro.id_tipo_oferta = 1 and ro.periodo='2014-2' and ro.estado='A'

--actualizar segundas matriculas 2013-1
--     update rm2 set rm2.id_record_oferta = ro1.id_record_oferta
    select distinct ro1.*
--     update rh2 set rh2.id_record_oferta_padre =ro1.id_record_oferta
-- select  distinct ce.CEDULA, ce.NOMBRES,ce.APELLIDOS, ce.PERIODO_ACEPTA_CUPO, ce.NOMBRE_IES, ce.CAMPUS_IES,ce.CURRICULO_ACEPTA_CUPO, ce.CARRERA_ACEPTA_CUPO, ce.EXONERADO, ce.TIPO_MATRICULA_NIVELACION,
--        ce.PERIODO_MATRICULA_NIVELACION, ce.AREA_DE_CURRICULO, ce.CARRERA, ce.ESTADO_NIVELACION, ce.NOTA_FINAL,sem.CARRERA_ACEPTA_CUPO,
--        ro1.id_record_oferta,ro1.periodo,rm1.id_record_matricula,ro2.id_record_oferta,ro2.periodo,rm2.id_record_matricula,rh2.id_record_oferta_padre,rh2.id_record_oferta
from tmp.CASOS_ESPECIALES_NIV ce
inner join tmp.NIVELACION_SEM_HIS sem on sem.CEDULA = ce.CEDULA
left join mig.record_oferta ro1 on ro1.identificacion = sem.CEDULA and sem.CARRERA_ACEPTA_CUPO = ro1.carrera and ro1.periodo='2012-2'
left join mig.record_matricula rm1 on ro1.id_record_oferta = rm1.id_record_oferta
left join mig.record_asignaturas ra1 on rm1.id_record_matricula = ra1.id_record_matricula
left join mig.record_oferta ro2 on ro2.identificacion = sem.CEDULA and sem.CARRERA_ACEPTA_CUPO = ro2.carrera and ro2.periodo='2013-1' and ro2.estado='I'
left join mig.record_oferta rh2 on rh2.id_record_oferta_padre = ro2.id_record_oferta
left join mig.record_matricula rm2 on ro2.id_record_oferta = rm2.id_record_oferta
where ro1.estado='A' and ro2.id_record_oferta is null  and ce.ESTADO_NIVELACION<>'APRUEBA'
-- where ce.CEDULA in (select sem.CEDULA from tmp.SEM_2012_2 as sem)

select * from mig.record_matricula rm
where rm.id_record_oferta in (9702)

select * from mig.causistica
select * from mig.listar_carreras_sisweb niv where identificacion in ('2450060120')
select * from mig.listar_carreras_sga niv where identificacion in ('2400302739')

select
--     eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.id_periodo_academico,p.identificacion,p.apellidos,p.nombres,pa.codigo,o.descripcion,te.descripcion,tee.descripcion,tie.descripcion,eo.mantiene_gratuidad,eo.id_malla,
--     eo.estado
eo.*
from aca.estudiante_oferta eo
         inner join man.personas p on eo.id_persona = p.id
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
         inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
         left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
where
--     eo.id_estudiante_oferta in (79400)
p.identificacion in ('2400302739')


select * from mig.record_asignaturas where id_record_oferta = 9834
select * from mig.record_matricula where id_record_oferta = 9834
select * from mig.record_calificaciones

select * from mig.record_oferta where identificacion='2400302739' order by periodo,id_tipo_oferta
select * from mig.listar_carreras_sisweb niv where niv.id_record_oferta in (9702,    9782,26638,27608    )
and niv.estado_registro='A' order by id_tipo_oferta,periodo_cupo

select * from aca.periodo_academico where id_tipo_oferta = 2
--revisar en el lea manes que usaron su segunda matrícula
select * from mig.estado_academicos where identificacion in ('0802830463',    '0923310163','0925597312',
'0926609769','0926915422','0927264762','0928073386','0928704196','0928869122','0941929184','1313179309',
'1804469870','2350220659','2400022220','2400091811','2400095440','2400106353','2400111148','2400123127',
'2400135840','2400205254','2400216012','2400256265','2400256497','2400257982','2400259137','2400286197',
'2400306045','2450008897','2450010323','2450010422','2450014333','2450014960','2450088568','2450099904',
'2450118340','2450122615','2450127986','2450157314','2450178179'    )
select * from aca.tipo_jornada_laboral

select * from man.personas where identificacion ='0965061229'

select * from man.persona_identificacion
select * from man.tipo_identificacion
select * from man.lugar where descripcion ='COLOMBIA'
select * from man.nacionalidad where descripcion ='COLOMBIANA'

select * from man.estado_civil

select id_periodo_academico,codigo,descripcion,codigo_tipo_periodo from aca.periodo_academico where id_tipo_oferta =1
select * from Bd_Academico.dbo.TP_CODIGOS where ID_CLASIFICACION = 33

select * from aca.tipo_estado_estudiante

--ver los manes que realmente no optuvieron un cupo nuevo en el 2013-2 si no que hicieron uso de su cupo en el 2013-1
--casos de dobles matriculas
begin
    declare @periodo_1_vez varchar(25)='2014-1',@periodo_2_vez varchar(25)='2014-2'
-- update rm set rm.id_record_oferta = rov1.id_record_oferta
-- update roh set roh.id_record_oferta_padre = rov1.id_record_oferta,roh.fecha_mod = getdate()
    select distinct
--         niv.*,rov1.id_record_oferta,rov.id_record_oferta
                rov.*
--            rm.*
--          roh.*
    --        aux.id_record_oferta,aux.id_number,aux.table_name,aux.estado,aux.carrera
    -- ,aux1.id_record_oferta,aux1.id_number,aux1.table_name,aux1.estado,aux1.carrera
    from tmp.NIVELACION_SEM_HIS niv
    inner join (
        select distinct ro.id_record_oferta,ro.identificacion,ro.apellidos,ro.nombres,ro.periodo,ro.carrera,ro.id_number,ro.table_name,ro.estado from mig.record_oferta ro
        where ro.id_tipo_oferta = 1 and ro.estado='A' and ro.periodo in (@periodo_2_vez) and ro.identificacion  not in (select s.CEDULA from tmp.NIVELACION_SEM_HIS  s where s.periodo=@periodo_2_vez)
    ) as aux on aux.identificacion = niv.CEDULA and aux.carrera = niv.CARRERA_ACEPTA_CUPO
    inner join mig.record_oferta rov on rov.id_record_oferta = aux.id_record_oferta
--     left join mig.record_oferta roh on roh.id_record_oferta_padre = rov.id_record_oferta
--     left join mig.record_matricula rm on rov.id_record_oferta = rm.id_record_oferta
--     inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
    inner join (select r1.id_record_oferta,r1.identificacion,r1.apellidos,r1.nombres,r1.periodo,r1.carrera,r1.id_number,r1.table_name,r1.estado from mig.record_oferta r1
                where r1.identificacion in (select distinct ro.identificacion from mig.record_oferta ro
                                            where ro.id_tipo_oferta = 1 and ro.estado='A' and ro.periodo in (@periodo_2_vez) and ro.identificacion  not in (select s.CEDULA from tmp.NIVELACION_SEM_HIS  s where s.periodo=@periodo_2_vez))
                  and r1.periodo=@periodo_1_vez) as aux1 on aux1.identificacion = niv.CEDULA and aux1.carrera = niv.CARRERA_ACEPTA_CUPO
    inner join mig.record_oferta rov1 on rov1.id_record_oferta = aux1.id_record_oferta
    left join mig.record_oferta roh on roh.id_record_oferta_padre = rov1.id_record_oferta
--     left join mig.record_matricula rm on rov1.id_record_oferta = rm.id_record_oferta
--     inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
    where niv.CEDULA in (select distinct ro.identificacion from mig.record_oferta ro
                     where ro.id_tipo_oferta = 1 and ro.estado='A' and ro.periodo in (@periodo_2_vez) and ro.identificacion  not in (select s.CEDULA from tmp.NIVELACION_SEM_HIS  s where s.periodo=@periodo_2_vez))
    and niv.PERIODO =@periodo_1_vez
--     and roh.id_record_oferta is  null
end

--cupos que no pertenecen a esta matriz 8
--acuas
select distinct ro.*
from mig.record_oferta ro
left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
left join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
where ro.id_tipo_oferta = 1 and ro.estado='A' and ro.periodo in ('2015-1') and ro.identificacion  not in (select s.CEDULA from tmp.NIVELACION_SEM_HIS  s where s.periodo='2014-2')

select distinct periodo,id_periodo_academico,id_periodo_academico_cg from mig.record_oferta where id_tipo_oferta =1
select * from mig.listar_carreras_sisweb niv where niv.id_record_oferta in (9702,     9782,26638,27608    )
and niv.estado_registro='A' order by id_tipo_oferta,periodo_cupo


select id_estado_academico,apellidos,nombres,carrera_sga,id_estado_academico,periodo,id_estado_cauistica from mig.estado_academicos where identificacion in ('0924274087',
    '0961814357','2400138901','2400141848','2400290470','2450003666','2450300484','2450429325'    )

select * from mig.listar_carreras_sisweb where  identificacion in ('0924274087',
    '0961814357','2400138901','2400141848','2400290470','2450003666','2450300484','2450429325'    )

select distinct rm.id_record_matricula,rm.periodo,rm.id_periodo_academico,rm.id_periodo_academico_cg,ra.id_record_asignatura,ra.periodo,ra.id_periodo_academico,ra.id_periodo_academico_cg
from mig.record_oferta ro
         left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
         left join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
where ro.id_record_oferta =34279

select distinct * from tmp.NIVELACION_SEM_HIS s
where s.periodo='2014-2' and s.CEDULA  not in (select distinct ro.identificacion
                                               from man.personas ro where ro.estado='AC')

select sem.* from tmp.NIVELACION_SEM_HIS sem
where sem.PERIODO in ('2014-2')


select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 1
--acuas
--446 en 2012-1
--2013-1  real->777     actual->801
--2013-2  real->720     actual->615   faltan 105 sobran 40
--2014-1  real->893     actual->753   faltan->140 por insertar->192  total despues->944 sobran->51
--2014-2  real->987     actual->809   faltan->178 por insertar->186  total despues->987 sobran->6
select * from aca.tipo_ingreso_estudiante
select * from aca.tipo_estado_estudiante
select * from mig.record_oferta
--migrar cupos que no estan en el SGA ni en siswebsito
begin
    declare @periodo varchar(10)='2014-2',@id_periodo_academico int = 109,@id_periodo_academico_cg int= 5676,@id_tipo_estado_estudiante int = 7,@id_tipo_ingreso_estudiante int = 17
-- insert into mig.record_oferta
    select distinct
        null as id_record_oferta_padre, @id_periodo_academico as id_periodo_academico, @id_periodo_academico_cg as id_periodo_academico_cg,
        isnull((select case ea.JORNADA when 'MATUTINA' then 1 when 'VESPERTINA' then 2 when 'NOCTURNA' then 3 else 4 end
         from mig.estado_academicos ea where ea.identificacion=sem.CEDULA and ea.periodo=sem.PERIODO and
                                             ea.id_carrera_ofertada= (select top 1 ro1.id_carrera_ofertada from mig.record_oferta ro1
                                                                   where ro1.carrera=sem.CARRERA_ACEPTA_CUPO and ro1.id_tipo_oferta=1 and ro1.periodo=@periodo)),4) as id_tipo_jornada_laboral,
--         4 as id_tipo_jornada_laboral,
        1 as id_tipo_estudiante,
        @id_tipo_ingreso_estudiante as id_tipo_ingreso_estudiante, @id_tipo_estado_estudiante as id_tipo_estado_estudiante, ro.id_persona_cg,
        (select top 1 ro1.id_carrera_ofertada from mig.record_oferta ro1 where ro1.carrera=sem.CARRERA_ACEPTA_CUPO and ro1.id_tipo_oferta=1 and ro1.periodo=@periodo) as id_carrera_ofertada,
        null as id_area, 1 as id_tipo_oferta, 2 as id_sistema_estudio,
        200 as id_sistema_estudio_cg,(select top 1 ro1.id_oferta_modalidad from mig.record_oferta ro1 where ro1.carrera=sem.CARRERA_ACEPTA_CUPO and ro1.id_tipo_oferta=1 and ro1.periodo=@periodo) as id_oferta_modalidad,
        ro.id_estudiante_oferta, ro.id_estudiante_oferta_destino,227 as id_modalidad_cg,'PRESENCIAL'  as modalidad, @periodo as periodo,
        'SEMESTRAL' as sistema_estudio, (select top 1 ro1.facultad from mig.record_oferta ro1 where ro1.carrera=sem.CARRERA_ACEPTA_CUPO and ro1.id_tipo_oferta=1 and ro1.periodo=@periodo) as facultad,
        sem.CARRERA_ACEPTA_CUPO as carrera, sem.CARRERA as carrera_original,
        (select top 1 ro1.escuela from mig.record_oferta ro1 where ro1.carrera=sem.CARRERA_ACEPTA_CUPO and ro1.id_tipo_oferta=1 and ro1.periodo=@periodo) as escuela,
        sem.CURRICULO_ACEPTA_CUPO as area, 'POR DEFINIR' as numero_matricula, 'POR DEFINIR' as numero_matricula_cg, 1 as mantiene_gratuidad, 0 as  promedio,
        sem.CEDULA as identificacion,sem.NOMBRES as nombres, sem.APELLIDOS as apellidos, getdate() as fecha_registro, sem.USU_ID as id_number, 'tmp.NIVELACION_SEM_HIS.USU_ID' as table_name, 'A' as estado, 0 as version,
        getdate() as fecha_ing, getdate() as fecha_mod, '2400254286' as usuario_ing,'2400254286' as usuario_mod
    from tmp.NIVELACION_SEM_HIS sem
    left join mig.record_oferta ro on ro.identificacion = sem.CEDULA and ro.carrera = sem.CARRERA_ACEPTA_CUPO
--     left join mig.record_oferta ro on concat(dbo.quitarTildes(ro.apellidos),' ',dbo.quitarTildes(ro.nombres)) = concat(dbo.quitarTildes(sem.APELLIDOS),' ',dbo.quitarTildes(sem.NOMBRES))
        and ro.carrera = sem.CARRERA_ACEPTA_CUPO
    and  ro.estado='A' and ro.sistema_estudio='SEMESTRAL' and ro.id_tipo_oferta = 1 and ro.periodo=@periodo
    left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
    left join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
    left join man.personas p on p.identificacion = ro.identificacion and p.estado='AC'
    where sem.PERIODO=@periodo and ro.id_record_oferta is null
--     and p.id is null
end

--replicate matriculas y asignaturas from other cupos
begin
--     insert into mig.record_matricula
    select d.id_record_oferta, id_periodo_academico, id_periodo_academico_cg, id_tipo_matricula, id_tipo_jornada_laboral, id_paralelo, id_nivel,
           id_nivel_cg, nivel, aula, curso, vez, promedio, valor_total, observacion, estado_matricula, fecha_matricula, periodo, id_number,
           table_name, id_number_old, table_name_old, estado, version, fecha_ing, fecha_mod, usuario_ing, usuario_mod from (
    select distinct  ro.id_record_oferta, rm.id_periodo_academico, rm.id_periodo_academico_cg, rm.id_tipo_matricula, rm.id_tipo_jornada_laboral,
                rm.id_paralelo, rm.id_nivel, rm.id_nivel_cg, rm.nivel, rm.aula, rm.curso, rm.vez, 0 as promedio, rm.valor_total, rm.observacion, rm.estado_matricula,
                rm.fecha_matricula, rm.periodo,sem.USU_ID as id_number, 'tmp.NIVELACION_SEM_HIS.USU_ID' as table_name, rm.id_number_old, rm.table_name_old, 'A' as estado, 0 as version,
                getdate() as fecha_ing, getdate() as fecha_mod, ro.usuario_ing, ro.usuario_mod,ROW_NUMBER() OVER (PARTITION BY ro.id_record_oferta ORDER BY rm.fecha_matricula) as orden
    --     sem.USU_ID, sem.CEDULA, sem.CC_NUM, sem.NOMBRES, sem.APELLIDOS, sem.PERIODO_ACEPTA_CUPO, sem.IES_ID, sem.NOMBRE_IES, sem.CAM_ID,
    --     sem.CAMPUS_IES, sem.PRD_ID, sem.CURRICULO_ACEPTA_CUPO, sem.CCP_ID, sem.CAR_ID, sem.CARRERA_ACEPTA_CUPO,sem.TIPO_MATRICULA_NIVELACIÓN,SEM.ESTADO_NIVELACION
    --         ,ro.id_record_oferta,ro.periodo,ro.id_carrera_ofertada,ro.id_oferta_modalidad,rm.*
    -- update ro set ro.id_oferta_modalidad = rm.id_destino
    from tmp.NIVELACION_SEM_HIS sem
    inner join mig.record_oferta ro on ro.identificacion = sem.CEDULA and ro.carrera = sem.CARRERA_ACEPTA_CUPO
                                        and  ro.estado='A' and ro.sistema_estudio='SEMESTRAL' and ro.id_tipo_oferta = 1 and ro.periodo='2013-1'
        inner join mig.record_oferta ror on ror.id_carrera_ofertada = ro.id_carrera_ofertada and ror.periodo='2013-1'
        left join mig.record_matricula rms on ro.id_record_oferta = rms.id_record_oferta
        inner join tmp.NIVELACION_SEM_HIS nir on ror.identificacion = nir.CEDULA and nir.ESTADO_NIVELACION = sem.ESTADO_NIVELACION
        inner join mig.record_matricula rm on ror.id_record_oferta = rm.id_record_oferta and rm.estado='A'
        left join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
    -- left join bdupse.snu.aspirante asp on asp.identificacion = ro.identificacion
    where  sem.PERIODO='2013-1' --and ro.id_record_oferta is null --and sem.TIPO_MATRICULA_NIVELACIÓN is null
    and sem.CEDULA in ('2400269581','0919460071','0951522044') and rms.id_record_matricula is null
    ) as d
    where d.orden = 1
end

select * from mig.record_matricula where id_record_oferta in (68047,68048,68046)
select * from man.personas where identificacion in ('0959801234')
select * from man.personas where personas.apellidos ='BENAVIDES CHALACAN'
select * from man.persona_identificacion
select * from tmp.NIVELACION_SEM_HIS where PERIODO ='2014-2'
-- RN25642259	RN25642259	CRISTIAN CAMILO	GARCIA LONDOÑO
-- AP389882	AP389882	JOHN ALEJANDRO	REVELO HERNANDEZ
-- AP305451	AP305451	ALDEMAR ALEJANDRO	TUTALCHA GUERRON
-- 8400094333	8400094333	YESSICA FERNANDA	DIAZ ANAYA
-- 2450635186	2450635186	BRYAN ANDRES	LIMONES PRUDENTE
-- 359192	359192	ADOLFO LEANRO	CUASPA BENAVIDES

--inserta personas que faltaban de otro cupos
-- insert into man.personas
select distinct 1 as id_tipo_identificacion,4 as id_estado_civil, id_tipo_sangre, id_discapacidad,5 as id_nacionalidad,164 as id_pais_nacionalidad,
                id_provincia_nacionalidad, id_canton_nacionalidad, id_parroquia_nacionalidad, id_etnia, id_nacionalidad_indigena,164 as id_pais_residencia,
                id_provincia_residencia, id_canton_residencia, id_parroquia_residencia, num_carnet_conadis,0 as porcentaje_dis, sem.CEDULA,  sem.nombres,
                sem.apellidos,'M' as sexo, fecha_nace, ciudad, barrio, direccion, telefono, celular, email_personal, email_institucional, foto, titulo_prefijo,
                titulo_sufijo, url_firma, imagen, profesion, ppl, azure, directory, apellido_paterno, apellido_materno, primer_nombre, segundo_nombre,
                numero_domicilio, defuncion,'AC' as estado,  getdate() as fecha_ing,'2400254286' as  usuario_ing,0 as version,getdate() as  fecha_mod,'2400254286' as  usuario_mod,
                getdate() as  fecha_ingreso,664 as usuario_ingreso_id,
                verificadoNombresSistema, verificadoFechaNacSistema, verificadoNombres, verificadoFechaNac
from tmp.NIVELACION_SEM_HIS sem
    left join man.personas p on p.identificacion = sem.CEDULA and p.estado='AC'
         left join mig.record_oferta ro on ro.identificacion = sem.CEDULA and ro.carrera = sem.CARRERA_ACEPTA_CUPO
    and  ro.estado='A' and ro.sistema_estudio='SEMESTRAL' and ro.id_tipo_oferta = 1 --and ro.periodo in ('2012-2','2013-1','2013-2','2014-1','2014-2','2015-1')
where  p.id is null and concat(sem.APELLIDOS, ' ',sem.NOMBRES) not in (select concat(p1.APELLIDOS, ' ',p1.NOMBRES) from man.personas p1 where p1.estado='AC')


--310
-- select ro.* from (
-- insert into man.personas
select
--     distinct ro.*,LEN(ro.apellidos) - LEN(REPLACE(ro.apellidos, ' ', '')) AS cantidad_espacios_apellidos,LEN(ro.nombres) - LEN(REPLACE(ro.nombres, ' ', '')) AS cantidad_espacios_nombres
    distinct 1 as id_tipo_identificacion,4 as id_estado_civil, id_tipo_sangre, id_discapacidad,5 as id_nacionalidad,164 as id_pais_nacionalidad,
                id_provincia_nacionalidad, id_canton_nacionalidad, id_parroquia_nacionalidad, id_etnia, id_nacionalidad_indigena,164 as id_pais_residencia,
                id_provincia_residencia, id_canton_residencia, id_parroquia_residencia, num_carnet_conadis,0 as porcentaje_dis, ro.identificacion,  ro.nombres,
                ro.apellidos,'M' as sexo, fecha_nace, ciudad, barrio, direccion, telefono, celular, email_personal, email_institucional, foto, titulo_prefijo,
                titulo_sufijo, url_firma, imagen, profesion, ppl, azure, directory, apellido_paterno, apellido_materno, primer_nombre, segundo_nombre,
                numero_domicilio, defuncion,'AC' as estado,  getdate() as fecha_ing,'2400254286' as  usuario_ing,0 as version,getdate() as  fecha_mod,'2400254286' as  usuario_mod,
                getdate() as  fecha_ingreso,664 as usuario_ingreso_id,
                verificadoNombresSistema, verificadoFechaNacSistema, verificadoNombres, verificadoFechaNac
from mig.record_oferta ro
         left join man.personas p on p.identificacion = ro.identificacion and p.estado='AC'
   --and ro.sistema_estudio='SEMESTRAL' and ro.id_tipo_oferta = 1 --and ro.periodo in ('2012-2','2013-1','2013-2','2014-1','2014-2','2015-1')
where p.id is null --and concat(ro.APELLIDOS, ' ',ro.NOMBRES)  in (select concat(p1.APELLIDOS, ' ',p1.NOMBRES) from man.personas p1 where p1.estado='AC')
--   and concat(dbo.quitarTildes(ro.APELLIDOS),' ',dbo.quitarTildes(ro.NOMBRES)) in (select concat(dbo.quitarTildes(p1.APELLIDOS),' ',dbo.quitarTildes(p1.NOMBRES)) from man.personas p1 where p1.estado='AC')
  and  ro.estado='A'
-- ) as d
-- inner join mig.record_oferta ro on ro.id_record_oferta = d.id_record_oferta
-- where d.cantidad_espacios_nombres=2
  --homonimos
--   or ro.identificacion  in ('0928418482','2400000457','0930625298','2400164071','0916061294')

select * from man.estado_civil
select * from man.persona_identificacion
select * from man.tipo_identificacion
select id_lugar,descripcion from man.lugar where id_lugar_padre is null and estado='A'
select id_lugar,descripcion from man.lugar where estado='A' and sub_tipo = 1
select id_lugar,descripcion from man.lugar where estado='A' and sub_tipo = 2
select id_lugar,id_lugar_padre,descripcion from man.lugar where estado='A' and sub_tipo = 3
select * from man.lugar where estado='A' and sub_tipo = 3

--     fecha_nace is null and estado='AC'
-- DBCC CHECKIDENT ('man.lugar', RESEED, 1589);
-- cnosultar en matrices LEA
select * from man.personas
select USU_ID,CEDULA,CC_NUM,APELLIDOS,NOMBRES,CARRERA_ACEPTA_CUPO,PERIODO,NOTA_FINAL from tmp.NIVELACION_SEM_HIS where CEDULA in ('12013310309')

select id_estado_academico,apellidos,nombres,carrera_sga,id_estado_academico,periodo,id_estado_cauistica from mig.estado_academicos where identificacion in ('12013310309')

select id_estado_academico,apellidos,nombres,carrera_sga,id_estado_academico,periodo,id_casuistica from mig.estados_academicos_2025_1 where identificacion in ('12013310309')

select asp.identificacion,asp.nombres,asp.apellidos,asp.carrera,asp.campus,asp.fecha_ing,asp.fecha_mod from bdupse.snu.aspirante asp where asp.identificacion in ('12013310309')

select *   from mig.estados_academicos_2025_1

select * from man.personas where identificacion='1306390013'
select * from man.personas where apellidos LIKE '%VILLON LUCIN%'
select * from man.persona_identificacion where id_persona = 48703
select * from man.tipo_identificacion
select * from mig.record_oferta where identificacion in ('0605123801')
select * from mig.record_oferta where identificacion in ('0919714809','0919714709')


select concat(p.apellidos,' ',nombres) as nombres,count(p.identificacion) as cedulas from man.personas p where p.estado='AC'
group by p.nombres, p.apellidos

select * from man.personas p where concat(p.apellidos,' ',p.nombres) = 'DE LA ROSA ORRALA JEAN PIERRE'
select * from man.informacion_academica_persona
select * from aca.nivel_formacion
SELECT * FROM aca.area_conocimiento
select * from aca.titulos_academicos

select * from dbo.actualizacion_profesional
select * from dbo.produccion_cientifica





select distinct --ro.periodo,rm.id_record_matricula,rm.periodo,rm.id_periodo_academico,rm.id_periodo_academico_cg,ra.id_record_asignatura,ra.periodo,ra.id_periodo_academico,ra.id_periodo_academico_cg
ra.*
from mig.record_oferta ro
         left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
         left join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
where ro.id_record_oferta in (26828,26830)

select * from mig.record_oferta where PERIODO ='2014-2' and id_tipo_oferta =1 and estado='A'
--update verdadero periodo a los datos migrados
begin
--  CEDULAS PREVIAS   2450098708
    --     5394 sisiweb 105 sga 2012-2
--     5439 sisiweb 106 sga 2013-1
    declare @identificacion varchar(15)='0924274087',@periodo_par varchar(15)='2014-2',@periodo_new varchar(15)='2015-1',@id_periodo_academico int = 110,@id_periodo_academico_cg int = 5798,
        @id_number_old int= null,@table_old varchar(30)='tmp.NIVELACION_SEM_HIS.USU_ID',@id_record_oferta int = 34279
update ra set ra.periodo =@periodo_new,ra.id_periodo_academico =@id_periodo_academico,ra.id_periodo_academico_cg =@id_periodo_academico_cg,ra.usuario_mod ='2400254286',ra.fecha_mod = getdate(),
              ra.table_name_old=@table_old,ra.id_number_old =@id_number_old

-- select distinct rm.*
from mig.record_oferta ro
inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
where ro.id_tipo_oferta = 1 and  ro.identificacion=@identificacion and ro.periodo in (@periodo_par)  and ra.periodo in (@periodo_par) and ro.id_record_oferta = @id_record_oferta

update rm set rm.periodo =@periodo_new,rm.id_periodo_academico =@id_periodo_academico,rm.id_periodo_academico_cg =@id_periodo_academico_cg,rm.usuario_mod ='2400254286',rm.fecha_mod = getdate(),
              rm.table_name_old=@table_old,rm.id_number_old =@id_number_old
-- select distinct rm.*
from mig.record_oferta ro
inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
left join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
where ro.id_tipo_oferta = 1 and  ro.identificacion=@identificacion and ro.periodo in (@periodo_par) and rm.periodo in (@periodo_par) and ro.id_record_oferta = @id_record_oferta


update ro set ro.periodo =@periodo_new,ro.id_periodo_academico =@id_periodo_academico,ro.id_periodo_academico_cg =@id_periodo_academico_cg,ro.usuario_mod ='2400254286',ro.fecha_mod = getdate()
-- select distinct rm.*
from mig.record_oferta ro
left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
left join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
where ro.id_tipo_oferta = 1 and  ro.identificacion=@identificacion and ro.periodo in (@periodo_par)  and ro.id_record_oferta = @id_record_oferta

end


--actualizar el id_ofertad_modalidad nuevos cupos creados
--migrar cupos del 2012-2 que no estan en el SGA ni en siswebsito
-- insert into mig.record_oferta
select distinct ro.*,
    (select top 1 ro1.id_carrera_ofertada from mig.record_oferta ro1 where ro1.carrera=sem.CARRERA_ACEPTA_CUPO and ro1.id_tipo_oferta=1 and ro1.periodo='2013-1') as id_carrera_ofertada,
  (select top 1 ro1.id_oferta_modalidad from mig.record_oferta ro1 where ro1.carrera=sem.CARRERA_ACEPTA_CUPO and ro1.id_tipo_oferta=1 and ro1.periodo='2013-1') as id_oferta_modalidad
--     update ro set ro.id_oferta_modalidad=(select top 1 ro1.id_oferta_modalidad from mig.record_oferta ro1 where ro1.carrera=sem.CARRERA_ACEPTA_CUPO and ro1.id_tipo_oferta=1 and ro1.periodo='2013-1'),
--                   ro.id_carrera_ofertada=(select top 1 ro1.id_carrera_ofertada from mig.record_oferta ro1 where ro1.carrera=sem.CARRERA_ACEPTA_CUPO and ro1.id_tipo_oferta=1 and ro1.periodo='2013-1')
from tmp.NIVELACION_SEM_HIS sem
         left join mig.record_oferta ro on ro.identificacion = sem.CEDULA and ro.carrera = sem.CARRERA_ACEPTA_CUPO
    and  ro.estado='A' and ro.sistema_estudio='SEMESTRAL' and ro.id_tipo_oferta = 1 and ro.periodo='2012-2'
         left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
         left join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
where cast(ro.fecha_ing as date)=cast(getdate() as date)

select * from man.estado_civil
--identificar personas que tengan el records dividido por tener diferentes identificaciones
select * from man.personas where identificacion='0923358592'
select * from man.lugar
-- select * from(
select distinct ro.*
--     ro.id_record_oferta,ro.identificacion,ro.apellidos,ro.nombres,ro.carrera,ro.estado
--                 count(ro.identificacion) as numeroIden,count(concat(ro.apellidos,' ',ro.nombres)) as numeroNopmbres
from mig.record_oferta ro
left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
    left join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
where ro.estado='A' --and ro.identificacion='0923358592'
-- group by ro.id_record_oferta, ro.identificacion, ro.apellidos, ro.nombres, ro.carrera, ro.estado
-- ) as d
-- where d.numeroIden <>d.numeroNopmbres