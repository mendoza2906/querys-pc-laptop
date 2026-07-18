use bd_sga_upse

select * from pro.proceso where id_tipo_proceso =17

select * from seg.roles

select * from aca.estudiante_matricula

select * from man.documentos_archivos where id_documento_ubicacion in (18,19,20)

select * from aca.matricula_general

select * from aca.tipo_matricula_fecha where id_matricula_general = 26

select * from aca.tipo_clasificacion_documento

select * from tes.tipo_documento_contable

select distinct pu.* from pro.proceso_usuario pu
                              left join pro.proceso_etapa_ejecucion pej on pu.id_proceso_usuario = pej.id_proceso_usuario
                              left join pro.etapa_ejecucion_responsable eer on pej.id_proceso_etapa_ejecucion = eer.id_proceso_etapa_ejecucion
                              left join pro.etapa_ejecucion_documento ejd on pej.id_proceso_etapa_ejecucion = ejd.id_proceso_etapa_ejecucion
where pu.id_proceso_usuario in (5360) and
    pu.estado='A' and pej.estado='A' and eer.estado='A'

select * from pro.proceso_calendario

select * from pro.proceso_general

select * from pro.proceso

select * from pro.tipo_proceso
--44 50 64
select * from pro.etapa where id_etapa between 44 and 49

select * from pro.etapa where descripcion like '%DIR%'

select --p.descripcion,
       p.* from pro.proceso_etapa pe
inner join pro.proceso p on pe.id_proceso = p.id_proceso
where pe.id_etapa in (50)

select * from pro.solicitud_cambio_carrera

select --e.descripcion,
       pc.* from pro.proceso_etapa pe
inner join pro.etapa e on pe.id_etapa = e.id_etapa
left join pro.proceso_calendario pc on pe.id_proceso_etapa = pc.id_proceso_etapa
         where pe.id_proceso between 12 and 12

select * from pro.proceso_general where id_proceso = 12

SELECT * FROM MAN.lugar where descripcion like '%MILAGRO%'

select * from aca.reglamento where id_tipo_reglamento = 2

select * from man.personas where identificacion='2450476417'

select identificacion,telefono--,(STUFF(telefono, 1, 1, ''))
from man.personas where telefono is not null and telefono ='_________'
-- update man.personas set  telefono=(STUFF(telefono, 1, 1, '')) where telefono is not null and telefono like ' %'
-- update man.personas set  telefono=null where telefono is not null and telefono ='_________'
-- update man.personas set  telefono=null where telefono is not null and telefono ='099999999'
-- update man.personas set  telefono=(STUFF(telefono, 8, 2, '')) where telefono is not null and  CHARINDEX('__', telefono) > 0;
-- update man.personas set  telefono=null   WHERE  CHARINDEX('0000000', telefono) > 0 and telefono is not null and CHARINDEX('1', telefono) = 0 and CHARINDEX('2', telefono) = 0 and CHARINDEX('3', telefono) = 0
-- and CHARINDEX('4', telefono) = 0 and CHARINDEX('5', telefono) = 0 and CHARINDEX('6', telefono) =  0 and CHARINDEX('7', telefono) =  0 and CHARINDEX('8', telefono) =  0 and CHARINDEX('9', telefono) =  0
-- update man.personas set  telefono=concat('0',telefono) from man.personas WHERE len(telefono)=9 and telefono like '9%'

select identificacion,telefono from man.personas
WHERE CHARINDEX(' ', telefono) > 0 or CHARINDEX('_', telefono) > 0;

select identificacion,celular,telefono, STUFF(telefono, len(telefono), 0, '') from man.personas where telefono is not null
and celular='0982325080'

select identificacion,telefono from man.personas
WHERE  CHARINDEX('0000000', telefono) > 0 and telefono is not null and CHARINDEX('1', telefono) = 0 and CHARINDEX('2', telefono) = 0 and CHARINDEX('3', telefono) = 0
  and CHARINDEX('4', telefono) = 0 and CHARINDEX('5', telefono) = 0 and CHARINDEX('6', telefono) =  0 and CHARINDEX('7', telefono) =  0 and CHARINDEX('8', telefono) =  0 and CHARINDEX('9', telefono) =  0

select identificacion,celular,telefono from man.personas
WHERE  telefono like '9%'

select p.identificacion,p.ciudad,p.barrio,p.direccion from man.personas p

-- update man.personas set ciudad=upper(ciudad), barrio=UPPER(barrio),direccion=upper(direccion) where estado='AC'


select p.identificacion,p.apellidos,p.nombres,p.email_personal,p.email_institucional from man.personas p
inner join aca.estudiante_oferta eo on p.id = eo.id_persona
where p.identificacion in ('40070040','41795183','42361252','42377541','43417882','44404915','44905653','45143587','893183')
select * from aca.tipo_estudiante


select * from aca.detalle_estudiante_asignatura

select * from aca.documentos_matricula

select top 10 * from aca.estudiante_matricula
order by id_estudiante_matricula desc

select * from man.documentos_ubicacion


select * from man.documentos_archivos where id_documento_ubicacion in (18,19,20,22)

select * from tes.cobro_asignatura

select * from man.documentos_archivos where id_documento_ubicacion = 22

select * from man.documentos_archivos where id_documento_ubicacion in (18,19,20,22)

select * from pro.etapa_requisito


-- DBCC CHECKIDENT ('man.documentos_archivos', RESEED, 34845);

select top 10 * from man.documentos_archivos
order by id_documento_archivo desc

select distinct mr.* from aca.estudiante_matricula em
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
left join aca.matricula_rubro mr on em.id_estudiante_matricula = mr.id_estudiante_matricula
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
inner join man.personas p on eo.id_persona = p.id
where p.identificacion='0927960724' and  mg.id_periodo_academico = 38


select * from man.documentos_archivos where id_documento_ubicacion in (18,19,20,22)