USE bdupse


select *from bd_recursos_humanos..bd_Contratos
select * from bd_recursos_humanos..vw_Contratos

select * from bdupse.reh.personas where identificacion='2400254286'

select * from Bd_Personal..PF_PERSONAS where identificacion='2400088411'
--  select * from reh.lugares_marcacion where usuario_ingreso='2400254286'

 select * from bdupse.reh.lugares_marcacion where usuario_ingreso='2400091761'

select m.* from bdupse.reh.marcaciones m
--          inner join bdupse.reh.lugares_marcacion lm on lm.id = m.id_lugar_marcacion
         where m.id_persona = 2499


select * from aca.clases_asistencia

select * from aca.clase

select * from aca.tipo_espacio_fisico

select * from bd_sga_upse.[uath].[fn_marcacion](?1,?2,?3)
select * from man.personas where identificacion ='2400254286'

select * from aca.clase
select * from seg.usuarios where usuario='0604025130'
--     0914840947
--     0919659672
--     1309518445
select top(1) d.*  from [aca].[fn_lista_periodo_docente_carrera](36, 37943) as d

select * from aca.reglamento
select * from man.personas where identificacion ='2450103821'

select n.*  from aca.[fn_horario_academico_docente_actividad] (36,762,30) as n

select n.*  from aca.[fn_horario_academico_docente_actividad] (95,245,3) as n

select n.*  from aca.[fn_horario_academico_docente_actividad] (95,245,3) as n

select a.* from aca.malla_asignatura ma
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where ma.id_malla_asignatura = 3296

select n.*  from aca.[fn_horario_academico_docente_actividad] (92,305,3) as n

select * from aca.periodo_academico

SELECT *
FROM aca.fn_get_horario_posgrado (305, NULL, NULL, NULL)

SELECT *
FROM aca.horario_academico
WHERE id_docente = 305 and id_periodo_academico = 92


select  dia.id_dia as idDia, dep.nombre as departamento, o.descripcion as oferta, dia.descripcion as dia ,dia.orden as diaOrden ,
        CONVERT(nvarchar(30),FORMAT(auxFecha.fecha, 'yyyy-MM-dd') )+ ' ' + cast(h.hora_inicio as varchar(250)) AS fechaInicio,
        CONVERT(nvarchar(30),FORMAT(auxFecha.fecha, 'yyyy-MM-dd') )+ ' ' + cast(h.hora_fin as varchar(250)) AS fechaFin,
        cast ( GETDATE() as datetime2) as fechaActual
        , concat( a.descripcion ,' ',n.descripcion_corta,'/',p.descripcion_corta,' ',  o.descripcion,' ', ISNULL(EF.descripcion, ' ')) as asignatura
        ,ma.id_malla_asignatura as id_malla_asignatura,null as id_actividad,h.id_horario_academico as id_horario_academico,
        concat( a.descripcion ,' ',n.descripcion_corta,'/',p.descripcion_corta) as curso,ISNULL(EF.descripcion, 'ZOOM') as aula,'CLASES' as tipo,moa.descripcion as modalidad
from aca.horario_academico h
         inner join aca.malla_asignatura ma on ma.id_malla_asignatura=h.id_malla_asignatura
         inner join aca.nivel n on ma.id_nivel=n.id_nivel
         inner join aca.asignatura a on a.id_asignatura=ma.id_asignatura
         inner join aca.paralelo p on h.id_paralelo=p.id_paralelo
         inner join aca.dia dia on dia.id_dia = h.id_dia
         inner join aca.malla m on ma.id_malla=m.id_malla
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad=m.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta=o.id_oferta
         inner join aca.departamento_oferta dof on dof.id_oferta=om.id_oferta
         inner join man.departamentos dep on dof.id_departamento=dep.id
         inner join aca.planificacion_paralelo pp on pp.id_malla_asignatura = ma.id_malla_asignatura
         inner join aca.modalidad_asignatura moa on pp.id_modalidad_asignatura = moa.id_modalidad_asignatura
         left join aca.docente d on d.id_docente=h.id_docente and d.estado='A'
         left join man.personas per on d.id_persona=per.id and per.estado='AC'
         inner join  tut.fechas_rango ('01-01-2025','02-02-2025') as auxFecha on auxFecha.dia=lower(dia.descripcion)
         left join aca.espacio_fisico ef on ef.id_espacio_fisico=h.id_espacio_fisico and ef.estado='A'
where h.id_periodo_academico=92 and pp.id_periodo_academico=92 and  h.estado='A'
  and ( h.id_docente=305 or 305 is null)
