use bd_sga_upse;
select * from man.personas where identificacion like '%2400418931%'

-- DBCC CHECKIDENT ('even.evento_asistencia', RESEED, 0)
select ea.* from even.evento_asistencia ea
inner join man.personas p on p.id = ea.id_persona
where p.identificacion = '2400418931'


select * from aca.periodo_academico where id_tipo_oferta = 4

select * from even.eventos

select * from even.identificadores

select * from even.tipo_acceso

select * from even.tipo_estado_asistencia

select * from even.tipo_identificador

select * from even.fn_pa_obtener_informacion_de_asistencia_Json('0924275779')

select aca.fn_pa_obtener_informacion_de_asistencia('0927947499')


select * from mov.becario_consumo

select * from man.opciones where descripcion like '%evento%'

select * from even.eventos
select * from aca.estudiante_oferta where cast(fecha_ing as date)='29-07-2024' and id_periodo_academico = 38 and id_estudiante_oferta not in (
select distinct xd.estudiante_oferta_primer_semestre from (
                              select
                                  --ina.CARRERA,ina.CEDULA,ina.USU_NOMBRES,ina.USU_APELLIDOS,ina.PERIODO_ASIGNACION_CUPO,
                                  PA.codigo AS per_academico,eo.id_estudiante_oferta,d.nombre as facultad,o.descripcion as carreraSGA,
                                  p.id as idPersona,p.identificacion,p.apellidos,p.nombres,
                                  case when (
                                                select count(ea1.promedio) from aca.estudiante_asignatura ea1
                                                                                    inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                                                                                    inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = aa1.id_malla_asignatura
                                                                                    inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
                                                where ea1.id_estudiante_matricula = em.id_estudiante_matricula and ea1.estado ='A'
                                            ) =
                                            (
                                                select count(ea1.promedio) from aca.estudiante_asignatura ea1
                                                                                    inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                                                                                    inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = aa1.id_malla_asignatura
                                                                                    inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
                                                where ea1.id_estudiante_matricula = em.id_estudiante_matricula and ea1.estado ='A' and ea1.aprobado = 1
                                            ) then 'APROBADO' else 'REPROBADO' end as aprobado,round(cast (avg(ea.promedio) as decimal(10,2)),0) as promedioRedondeado,
                                  cast (avg(ea.promedio) as decimal(10,2)) as promedioReal,ea.id_paralelo,
                                  ISNULL(p.porcentaje_dis,0) as porcentajeDiscapacidad,p.celular,p.email_personal,em.fecha_mod,p.direccion,
                                  case when (
                                                select top 1 ea1.codigo_estado_matricula from aca.estudiante_matricula em1
                                                                                                  inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
                                                                                                  inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                                                -- 		    inner join aca.matricula_rubro mr on mr.id_estudiante_matricula = em1.id_estudiante_matricula
                                                where em1.id_estudiante_oferta = eo.id_estudiante_oferta and em1.estado ='A' and mg1.estado='A'  and ea1.estado ='A' and ea1.codigo_estado_matricula='SEG'--and mr.estado='A'
                                                -- 			and mg1.id_periodo_academico =@pi_id_perido_academico
                                            )='SEG' then 'SEGUNDA VEZ' else 'PRIMERA VEZ' end as VECES,
                                  iif(
                                          (select top 1 em1.id_estudiante_matricula from  aca.estudiante_oferta eopre
                                                                                              left join aca.estudiante_matricula em1 on em1.id_estudiante_oferta = eopre.id_estudiante_oferta and em1.estado='A'
                                                                                              left join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general and mg1.estado='A'
                                                                                              left join aca.periodo_academico pa1 on pa1.id_periodo_academico = mg1.id_periodo_academico and pa1.estado='A'
                                                                                              left join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula and ea1.estado='A'
                                           where eopre.estado='A' and eopre.id_oferta_modalidad = ore.id_oferta_modalidad_pregrado and eopre.id_persona = p.id
                                           group by eopre.id_estudiante_oferta,eopre.id_oferta_modalidad,eopre.id_persona,em1.id_estudiante_matricula,pa1.codigo,pa1.id_periodo_academico
                                           order by pa1.id_periodo_academico asc
                                          ) is null,'NO','SI') as matricula_primer_semestre,
                                  iif((select top 1 em1.id_estudiante_matricula from  aca.estudiante_oferta eopre
                                                                                          left join aca.estudiante_matricula em1 on em1.id_estudiante_oferta = eopre.id_estudiante_oferta and em1.estado='A'
                                                                                          left join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general and mg1.estado='A'
                                                                                          left join aca.periodo_academico pa1 on pa1.id_periodo_academico = mg1.id_periodo_academico and pa1.estado='A'
                                                                                          left join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula and ea1.estado='A'
                                       where eopre.estado='A' and eopre.id_oferta_modalidad = ore.id_oferta_modalidad_pregrado and eopre.id_persona = p.id
                                       group by eopre.id_estudiante_oferta,eopre.id_oferta_modalidad,eopre.id_persona,em1.id_estudiante_matricula,pa1.codigo,pa1.id_periodo_academico
                                       order by pa1.id_periodo_academico asc) is null,'NO APLICA',
                                      (select top 1 pa1.codigo from  aca.estudiante_oferta eopre
                                                                         left join aca.estudiante_matricula em1 on em1.id_estudiante_oferta = eopre.id_estudiante_oferta and em1.estado='A'
                                                                         left join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general and mg1.estado='A'
                                                                         left join aca.periodo_academico pa1 on pa1.id_periodo_academico = mg1.id_periodo_academico and pa1.estado='A'
                                                                         left join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula and ea1.estado='A'
                                       where eopre.estado='A' and eopre.id_oferta_modalidad = ore.id_oferta_modalidad_pregrado and eopre.id_persona = p.id
                                       group by eopre.id_estudiante_oferta,eopre.id_oferta_modalidad,eopre.id_persona,em1.id_estudiante_matricula,pa1.codigo,pa1.id_periodo_academico
                                       order by pa1.id_periodo_academico asc)
                                  ) as periodo_primer_semestre,
                                  iif((select top 1 em1.id_estudiante_matricula from  aca.estudiante_oferta eopre
                                                                                          left join aca.estudiante_matricula em1 on em1.id_estudiante_oferta = eopre.id_estudiante_oferta and em1.estado='A'
                                                                                          left join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general and mg1.estado='A'
                                                                                          left join aca.periodo_academico pa1 on pa1.id_periodo_academico = mg1.id_periodo_academico and pa1.estado='A'
                                                                                          left join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula and ea1.estado='A'
                                       where eopre.estado='A' and eopre.id_oferta_modalidad = ore.id_oferta_modalidad_pregrado and eopre.id_persona = p.id
                                       group by eopre.id_estudiante_oferta,eopre.id_oferta_modalidad,eopre.id_persona,em1.id_estudiante_matricula,pa1.codigo,pa1.id_periodo_academico
                                       order by pa1.id_periodo_academico asc) is null,0,
                                      (select top 1 eopre.id_estudiante_oferta from  aca.estudiante_oferta eopre
                                                                                         left join aca.estudiante_matricula em1 on em1.id_estudiante_oferta = eopre.id_estudiante_oferta and em1.estado='A'
                                                                                         left join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general and mg1.estado='A'
                                                                                         left join aca.periodo_academico pa1 on pa1.id_periodo_academico = mg1.id_periodo_academico and pa1.estado='A'
                                                                                         left join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula and ea1.estado='A'
                                       where eopre.estado='A' and eopre.id_oferta_modalidad = ore.id_oferta_modalidad_pregrado and eopre.id_persona = p.id
                                       group by eopre.id_estudiante_oferta,eopre.id_oferta_modalidad,eopre.id_persona,em1.id_estudiante_matricula,pa1.codigo,pa1.id_periodo_academico
                                       order by pa1.id_periodo_academico asc)
                                  ) as estudiante_oferta_primer_semestre
                              from man.personas p
                                       inner join aca.estudiante_oferta eo on eo.id_persona = p.id
                                       inner join aca.oferta_relacion ore on ore.id_oferta_modalidad_nivelacion = eo.id_oferta_modalidad and ore.id_periodo_academico = 30
                                       inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
                                       inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
                                       inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
                                       inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
                                       inner join aca.periodo_academico pa on pa.id_periodo_academico =  mg.id_periodo_academico
                                       inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
                                       inner join aca.oferta o on o.id_oferta = om.id_oferta
                                       inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
                                       inner join man.departamentos d on d.id= do.id_departamento
                                       inner join seg.usuarios u on u.persona_id = p.id
-- 			inner join dbo.INACTIVACIONES2012_2023 ina on ina.CEDULA = p.identificacion

                              where  em.estado ='A' -- and pa.id_periodo_academico = @pi_id_perido_academico
                                and o.id_tipo_oferta = 1 and mg.id_periodo_academico = 37
                                AND eo.estado='A' and ea.estado='A' and u.estado='AC' --and p.identificacion='0958799066'
                              group by eo.id_estudiante_oferta,u.id,p.id,p.identificacion,p.nombres,p.apellidos,
                                       --m.id_malla,
                                       em.id_estudiante_matricula, d.nombre,o.descripcion,u.usuario,eo.id_oferta_modalidad,ea.id_paralelo,pa.codigo,
                                       p.porcentaje_dis,p.celular,p.email_personal,em.fecha_mod,p.direccion,ore.id_oferta_modalidad_pregrado,eo.id_estudiante_oferta
-- 			         , ina.CARRERA, ina.CEDULA,
-- 			ina.USU_NOMBRES,ina.USU_APELLIDOS,INA.PERIODO_ASIGNACION_CUPO,pa.codigo
-- 			order by d.nombre,o.descripcion,p.apellidos,p.nombres

                          ) as xd
-- inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = xd.id_estudiante_oferta
where xd.aprobado='APROBADO' )
