use bd_sga_upse

---funciones creadas para nivelacion
select * from rel.fn_relaciones_ofertas_nivelacion_grado(15)

select * from aca.fn_recuperar_jornada_postulante_nivelacion(32,49370)

--matriculados por paralelo
select d.facultad,d.carrera,d.id_oferta_modalidad,d.paralelo,count(d.id_estudiante_oferta) as matriculados,
COUNT(CASE WHEN d.aprobado = 1 THEN 1 END) AS total_aprobados,COUNT(CASE WHEN d.aprobado = 0 THEN 1 END) AS total_reprobados from (
select d.nombre as facultad,o.descripcion as carrera,om.id_oferta_modalidad,ea.id_paralelo as paralelo,em.id_estudiante_matricula,eo.id_estudiante_oferta,p.identificacion,p.apellidos,p.nombres,
iif((
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
),1,0 ) as aprobado
from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.periodo_academico pa on pa.id_periodo_academico =  mg.id_periodo_academico
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
inner join man.departamentos d on d.id= do.id_departamento
where  em.estado ='A' and pa.estado='A' and ea.estado='A'
and eo.estado='A' and pa.id_periodo_academico = 32 --and u.estado='AC'
group by  d.nombre,o.descripcion,om.id_oferta_modalidad, ea.id_paralelo,em.id_estudiante_matricula,eo.id_estudiante_oferta,
p.identificacion,p.apellidos,p.nombres
)as d
group by d.facultad,d.carrera,d.paralelo,d.id_oferta_modalidad
order by d.facultad,d.carrera,d.paralelo

select * from aca.periodo_academico where id_tipo_oferta = 1
select * from aca.tipo_matricula_fecha
select * from seg.usuarios where usuario='2400425522'

--LISTA DE ESTUDIANTES CON CRUCES DE PARALELO NIVELACION
select * from (
                  select o.descripcion,p.identificacion,p.apellidos,p.nombres,eo.id_malla,(select count(ea.id_paralelo) from aca.estudiante_asignatura ea
                                                                                           where ea.id_estudiante_matricula = em.id_estudiante_matricula and ea.estado='A' and ea.id_paralelo = 1) as cantidadParalelo1,
                         (select count(ea.id_paralelo) from aca.estudiante_asignatura ea
                          where ea.id_estudiante_matricula = em.id_estudiante_matricula and ea.estado='A' and ea.id_paralelo = 2) as cantidadParalelo2,
                         (select count(ea.id_paralelo) from aca.estudiante_asignatura ea
                          where ea.id_estudiante_matricula = em.id_estudiante_matricula and ea.estado='A' and ea.id_paralelo = 3) as cantidadParalelo3
                  from aca.estudiante_oferta eo
                           inner join man.personas p on p.id = eo.id_persona
                           inner join aca.oferta_modalidad om on om.id_oferta_modalidad=eo.id_oferta_modalidad
                           inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
                           inner join aca.oferta o on o.id_oferta = om.id_oferta
                           inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
                           inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
                  where om.estado='A' and eo.estado='A' --and tee.codigo ='ACT'
                    and o.id_tipo_oferta =1 and p.estado='AC'
                    and mg.id_periodo_academico = 127
                  -- and eo.id_estudiante_oferta not in
--     (select estudiante_matricula.id_estudiante_oferta from aca.estudiante_matricula where id_estudiante_oferta in
--                                   (select eo.id_estudiante_oferta from aca.estudiante_oferta eo where eo.id_periodo_academico is not null))
-- and eo.id_periodo_academico is not null
                  group by o.descripcion,p.identificacion,p.apellidos,p.nombres,eo.id_malla,em.id_estudiante_matricula
-- order by o.descripcion,p.apellidos,p.nombres
              )as d
where (cantidadParalelo1>0 and cantidadParalelo2>0) or
    (cantidadParalelo1>0 and cantidadParalelo3>0) or  (cantidadParalelo2>0 and cantidadParalelo3>0)


select * from dbo.aspirantes_segunda_matricula


select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 1

--VER LOS JOVENES
select distinct p.identificacion,p.apellidos,p.nombres,tee.codigo,tee.descripcion,eo.*
from aca.estudiante_oferta eo
         inner join man.personas p on p.id = eo.id_persona
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad=eo.id_oferta_modalidad
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.oferta o on o.id_oferta = om.id_oferta
where
    om.estado='A' and eo.estado='A'  and o.id_tipo_oferta =1 and p.estado='AC' and tee.codigo in ('ACT')
  and p.identificacion  in (select d.identificacion from dbo.aspirantes_segunda_matricula as d
)

--ESTUDIANTES QUE TIENE QUE VER POR SEGUNDA VEZ
-- select * from dbo.aspirantes_segunda_matricula as d
select  tee.codigo ,d.*from dbo.aspirantes_segunda_matricula as d
                                inner join man.personas p on p.identificacion = d.identificacion
                                inner join aca.estudiante_oferta eo on eo.id_persona = p.id
                                inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
                                inner join aca.oferta_modalidad om on om.id_oferta_modalidad=eo.id_oferta_modalidad
                                inner join aca.oferta o on o.id_oferta = om.id_oferta
where o.id_tipo_oferta = 1 and
    d.identificacion not in (select p.identificacion
                             from aca.estudiante_oferta eo
                                      inner join man.personas p on p.id = eo.id_persona
                                      inner join aca.oferta_modalidad om on om.id_oferta_modalidad=eo.id_oferta_modalidad
                                      inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
                                      inner join aca.oferta o on o.id_oferta = om.id_oferta
                             where
                                 om.estado='A' and eo.estado='A'  and o.id_tipo_oferta =1 and p.estado='AC' and tee.codigo in ('ACT'))



--SABER POBLACION ACTIVA QUE SE PUEDE MATRICULAR A NIVELACION DESDE EL PROCESO DE INGRESO PROPIO DE LA U
select * from niv.consultar_lista_Usuarios_cupos (127,1,null,
                                                  null,null,null,null,null,null) c



select d.idParalelo as idParalelo, d.paralelo as paralelo,	d.idJornada  as idJornada,
       d.jornada as jornada, d.idOfertaModalidad as idOfertaModalidad	from aca.fn_get_jornada_by_carrera
                                                                              (31415,28) as d

select * from [aca].[fn_recuperar_jornada_postulante_nivelacion](38,62088)

select * from aca.tipo_jornada_laboral
select * from rel.fn_relaciones_ofertas_nivelacion_grado(127)


select * from aca.ofertas_facultad where id_tipo_oferta in (1,2)
select * from aca.periodo_academico_oferta where id_periodo_academico = 127
select * from aca.periodo_academico where id_tipo_oferta = 1

exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 44132,30,2,1

--TABLAS AUXILIARES DE NIVELACION PARA PROCESOS ANTES DEL 2023-1
select * from dbo.aspirantes_segunda_matricula as d
where d.id_periodo_academico = 15

select * from aca.aspirantes_pregrado ap where ap.id_periodo_academico = 14 and ap.identificacion='2400230831'

select * from  dbo.INACTIVACIONES2012_2023  as d
--PERIODOS
select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 1
select * from aca.tipo_estado_estudiante

exec [aca].[sp_list_all_matriculas_carreras] '2450537713',null

exec [aca].[sp_list_all_carreras_records] '2450560566',null,null,null,null


select * from dbo.aspirantes_segunda_matricula as d
where d.id_periodo_academico = 15

select * from aca.aspirantes_pregrado ap where ap.id_periodo_academico = 14 and ap.identificacion='2400166365'


-- update tmp.actualizar_estado_cupo_2024_2 set ESTADO='A'
select * from tmp.actualizar_estado_cupo_2024_2 where OBSERVACION <>'HABILITAR PARA SEGUNDA MATRÍCULA'

--LISTAR LOS CUPOS ACTIVOS POR PERIODO ACADEMICO AQUII
--2023-1 752 cupos estaban activos
--10 ya uso de segunda matricula
--742 no uso de segunda matricula
--2023-2 1224 cupos estaban activos
--30 ya uso de segunda matricula
--1194 habilitados para segunda matricula
--2024-1
--1179 habilitados para segunda matricula
--acuas
--2417 habilitados para segunda matricula segun matriz
--2373 habilitados para segunda matricula segun sga
--2024-1
--No uso de su segunda matricula en el 2025-1 -> 1115
begin
    declare @pi_id_perido_academico int = 127,@id_periodo_matricula int = 127
-- update eo set eo.id_tipo_estado_estudiante = 9,eo.usuario_mod ='2400254286',eo.fecha_hasta= getdate(),eo.fecha_mod = getdate()
    select d.*
    from (
             select pa.codigo as periodo_cupo,eo.id_estudiante_oferta,om.facultad, om.carrera,p.identificacion,p.apellidos,p.nombres,--p.celular,p.telefono,
                    isnull((
                                         select count(em1.id_estudiante_matricula) from aca.estudiante_matricula em1
                                         where em1.id_estudiante_oferta = eo.id_estudiante_oferta and em1.estado ='A'
                                     ),0) as vecesMatriculado,
                    (
                        select count(ea1.promedio) from aca.estudiante_asignatura ea1
                                                            inner join aca.estudiante_matricula em1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                                                            inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                                                            inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
                        where em1.id_estudiante_oferta = eo.id_estudiante_oferta and ea1.estado ='A'
                          and mg1.id_periodo_academico = @pi_id_perido_academico
                    ) as TOTALES1,
                    isnull((
                               select count(ea1.promedio) from aca.estudiante_asignatura ea1
                                                                   inner join aca.estudiante_matricula em1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                                                                   inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                                                                   inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
                               where em1.id_estudiante_oferta = eo.id_estudiante_oferta and ea1.estado ='A' and ea1.aprobado = 1
                                 and mg1.id_periodo_academico = @pi_id_perido_academico
                           ),0) as APROBADAS1,
                 case when (
                                  select count(ea1.promedio) from aca.estudiante_asignatura ea1
                                                                      inner join aca.estudiante_matricula em1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                                                                      inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                                                                      inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
                                  where em1.id_estudiante_oferta = eo.id_estudiante_oferta and ea1.estado ='A'
                                    and mg1.id_periodo_academico = @pi_id_perido_academico
                              ) =
                              isnull((
                                         select count(ea1.promedio) from aca.estudiante_asignatura ea1
                                                                             inner join aca.estudiante_matricula em1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                                                                             inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                                                                             inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
                                         where em1.id_estudiante_oferta = eo.id_estudiante_oferta and ea1.estado ='A' and ea1.aprobado = 1
                                           and mg1.id_periodo_academico = @pi_id_perido_academico
                                     ),0) then 'APROBADO' else 'REPROBADO' end as APROBACION1,
                  (
                        select count(ea1.promedio) from aca.estudiante_asignatura ea1
                        inner join aca.estudiante_matricula em1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                        inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                        inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
                        where em1.id_estudiante_oferta = eo.id_estudiante_oferta and ea1.estado ='A'
                          and mg1.id_periodo_academico = @id_periodo_matricula
                    ) as TOTALES2,
                    isnull((
                               select count(ea1.promedio) from aca.estudiante_asignatura ea1
                               inner join aca.estudiante_matricula em1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                               inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                               inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
                               where em1.id_estudiante_oferta = eo.id_estudiante_oferta and ea1.estado ='A' and ea1.aprobado = 1
                                 and mg1.id_periodo_academico = @id_periodo_matricula
                           ),0) as APROBADAS2,
                    case when (
                                  select count(ea1.promedio) from aca.estudiante_asignatura ea1
                                                                      inner join aca.estudiante_matricula em1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                                                                      inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                                                                      inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
                                  where em1.id_estudiante_oferta = eo.id_estudiante_oferta and ea1.estado ='A'
                                    and mg1.id_periodo_academico = @id_periodo_matricula
                              ) =
                              isnull((
                                         select count(ea1.promedio) from aca.estudiante_asignatura ea1
                                                                             inner join aca.estudiante_matricula em1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                                                                             inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                                                                             inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
                                         where em1.id_estudiante_oferta = eo.id_estudiante_oferta and ea1.estado ='A' and ea1.aprobado = 1
                                           and mg1.id_periodo_academico = @id_periodo_matricula
                                     ),0) then 'APROBADO' else 'REPROBADO' end as APROBACION2,
                    case when (
                                  select top 1 ea1.codigo_estado_matricula from aca.estudiante_matricula em1
                                                                                    inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
                                                                                    inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                                  where em1.id_estudiante_oferta = eo.id_estudiante_oferta and em1.estado <>'I' and mg1.estado='A'
                                    and ea1.estado <>'I'and ea1.codigo_estado_matricula='SEG'
                              )='SEG' then 'SEGUNDA VEZ' else 'PRIMERA VEZ' end as NUM_VECES,eo.id_tipo_estado_estudiante,tee.descripcion as ESTADO_CUPO,tie.descripcion as tipo_ingreso,
                    iif((select d.idEstudianteMatricula from [rel].[fn_get_detalle_matricula_by_estudiante_oferta]
                                                             (eo.id_estudiante_oferta,null,1) as d) is null,'NO','SI') as matricula_nivelacion,
                    iif((select d.idEstudianteMatricula from [rel].[fn_get_detalle_matricula_by_estudiante_oferta]
                                                             (eo.id_estudiante_oferta,null,1) as d) is null,'NO APLICA',
                        (select d.periodoAcademico from [rel].[fn_get_detalle_matricula_by_estudiante_oferta](eo.id_estudiante_oferta,null,1) as d)
                    ) as periodo_nivelacion,
                    isnull((select d.estadoMatricula from [rel].[fn_get_detalle_matricula_by_estudiante_oferta]
                                                          (eo.id_estudiante_oferta,null,1) as d),'NO REGISTRA') as estadoMatriculaNivelacion,
                    ae.OBSERVACION,ae.PERIODO
             -- update eo set eo.id_periodo_academico = 24
             from man.personas p
              inner join aca.estudiante_oferta eo on eo.id_persona = p.id
              inner join aca.periodo_academico pa on pa.id_periodo_academico= eo.id_periodo_academico
              inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
              inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
              inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
              left join tmp.actualizar_estado_cupo_2024_2 ae on ae.CEDULA = p.identificacion and ae.CARRERA = om.carrera and ae.PERIODO=pa.codigo
             where eo.estado='A'
               and om.id_tipo_oferta = 1
               and eo.id_periodo_academico in (@pi_id_perido_academico)
               and tee.codigo  in ('ACT')

             -- and cast(eo.fecha_ingreso as date) ='2022-11-29'
             --     and eo.id_estudiante_oferta>30000
             -- and p.identificacion  in ('0928162544','0928023597','2450303314','0928419340','2400440976','2400135014','2450617382','2450653866',
             -- '0929639045','0928012988','2400445272','0928271634','2450827932','2450915109','2400268336','2450000381','2450231135','2450489691','2450573379','2450811852')
             -- order by p.identificacion,p.apellidos,p.nombres
         )as d
             inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = d.id_estudiante_oferta
--         where d.NUM_VECES ='PRIMERA VEZ'
    -- d.aprobado ='REPROBADO'
    -- and d.VECESMATRICULA <=2
    -- and d.MATRICULADO_NIVELACION ='SI'
--     order by d.facultad,d.carrera,d.identificacion,d.apellidos,d.nombres
-- )
end
--1046 2024-2 segunda vez
--678 2025-1 segunda vez
select * from tmp.actualizar_estado_cupo_2024_2
select * from aca.tipo_estado_estudiante

select * from aca.tipo_ingreso_estudiante
-- EXEC [aca].[sp_migrate_estudiantes_postulantes_nivelacion_to_oferta_nivelacion] 127
select * from aca.estudiante_oferta where id_promocion is not null

select * from tit.promocion


--LISTADO DE PERSONAS QUE TIENE DOBLE CUPO ACTIVOS DE NIVELACION
begin
    declare @id_periodo_academico int = 127
--     update eo  set eo.mantiene_gratuidad = 0 from
    select d.* from
        (
            select p.id as id_persona,p.identificacion,p.apellidos,p.nombres,eo.id_estudiante_oferta as id_estudiante_oferta_cupo_actual,
                   om.id_oferta_modalidad as id_oferta_modalidad_cupo_actual,o.descripcion as carrera__cupo_actual,
                   eo.id_periodo_academico as id_periodo_academico_cupo_actual,pa.codigo as periodo_cupo_actual,tee.descripcion as estado_cupo_actual,
                   ISNULL(cast(aux.fecha_ing as varchar(150)),'NO MATRICULADO') as fechaMatricula__cupo_actual,
                   ofer.id_estudiante_oferta as id_estudiante_oferta_anterior,ofer.id_oferta_modalidad as id_oferta_modalidad_anterior,ofer.carrera as carrera_anterior,ofer.id_periodo_academico as id_periodo_academico_anterior,
                   ofer.tipoEstado as estado_cupo_anterior,ofer.periodo as periodoAnterior,
                   ISNULL(cast(ofer.fechaMatricula as varchar(150)),'NO MATRICULADO') as fechaMatricula_anterior, iif(aux.fecha_ing is not null and
                                                                                                                      ofer.fechaMatricula is not null,'SI','NO') AS matriculadoAmbasCarreras,
                   iif(om.id_oferta_modalidad = ofer.id_oferta_modalidad,'SI','NO') AS mismaCarrrera

            from man.personas p
                     inner join aca.estudiante_oferta eo on eo.id_persona = p.id
                     inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
                     inner join aca.oferta o on o.id_oferta = om.id_oferta
                     inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
                     inner join man.departamentos d on d.id= do.id_departamento
                     inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
                     left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
                     left join (select eox.id_persona,eox.id_estudiante_oferta,eox.id_oferta_modalidad,em.id_estudiante_matricula,em.fecha_ing from  aca.estudiante_oferta eox
                                                                                                                                                         inner join aca.estudiante_matricula em  on  eox.id_estudiante_oferta=em.id_estudiante_oferta
                                                                                                                                                         inner join aca.matricula_general mg  on mg.id_matricula_general=em.id_matricula_general
                                where em.estado='A' and mg.id_periodo_academico = @id_periodo_academico
            ) as aux on aux.id_estudiante_oferta = eo.id_estudiante_oferta
                     inner join (
                select eo1.id_estudiante_oferta,om1.id_oferta_modalidad,o1.descripcion as carrera,eo1.id_periodo_academico,pa1.codigo as periodo,tee1.descripcion as tipoEstado,
                       p1.id as id_persona,p1.identificacion,aux1.fecha_ing as fechaMatricula
                from man.personas p1
                         inner join aca.estudiante_oferta eo1 on eo1.id_persona = p1.id
                         inner join aca.oferta_modalidad om1 on om1.id_oferta_modalidad = eo1.id_oferta_modalidad
                         inner join aca.oferta o1 on o1.id_oferta = om1.id_oferta
                         inner join aca.departamento_oferta do1 on do1.id_oferta = o1.id_oferta
                         inner join man.departamentos d1 on d1.id= do1.id_departamento
                         inner join aca.tipo_estado_estudiante tee1 on tee1.id_tipo_estado_estudiante = eo1.id_tipo_estado_estudiante
                         left join aca.periodo_academico pa1 on pa1.id_periodo_academico = eo1.id_periodo_academico
                         left join (
                    select eo22.id_persona,eo22.id_estudiante_oferta,eo22.id_oferta_modalidad,em.id_estudiante_matricula,em.fecha_ing from  aca.estudiante_oferta eo22
                    inner join aca.estudiante_matricula em  on  eo22.id_estudiante_oferta=em.id_estudiante_oferta
                    inner join aca.matricula_general mg  on mg.id_matricula_general=em.id_matricula_general
                    where em.estado='A' and mg.id_periodo_academico = @id_periodo_academico
                ) as aux1 on aux1.id_estudiante_oferta = eo1.id_estudiante_oferta
                where eo1.estado='A' and p1.estado='AC' and o1.estado='A'
                  and o1.id_tipo_oferta = 1 --and tee1.id_tipo_estado_estudiante = 1
                  and eo1.id_periodo_academico <> @id_periodo_academico
            ) as ofer on ofer.id_persona = p.id
            where eo.estado='A' and p.estado='AC' and o.estado='A'
              and o.id_tipo_oferta = 1 and tee.id_tipo_estado_estudiante = 1
              and eo.id_periodo_academico = @id_periodo_academico
              and p.identificacion in (select p.identificacion as cupos
                                       from man.personas p
                                                inner join aca.estudiante_oferta eo on eo.id_persona = p.id
                                                inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
                                                inner join aca.oferta o on o.id_oferta = om.id_oferta
                                                inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
                                                inner join man.departamentos d on d.id= do.id_departamento
                                                inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
                                       where eo.estado='A' --and tee.id_tipo_estado_estudiante = 1
                                         and o.id_tipo_oferta = 1
                                       group by p.identificacion,p.id
                                       having count(eo.id_estudiante_oferta)>1
            )
-- group by p.identificacion, om.id_oferta_modalidad,p.id, o.descripcion, eo.id_periodo_academico, pa.descripcion
-- order by p.identificacion,p.apellidos,p.nombres
        ) as d
        where
--          inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = d.id_estudiante_oferta_2024_1
--          where d.periodoAnterior<>'2022-2'
--          where d.matriculadoAmbasCarreras='SI'
         d.mismaCarrrera='SI' and d.estado_cupo_anterior='ACTIVO' --and d.identificacion='0924681216'
--          and d.identificacion not in ('2450399684','0956669972')
--          and d.fechaMatricula_2023_2  not in ('NO MATRICULADO') and d.fechaMatricula_anterior = 'NO MATRICULADO'
--          or d.identificacion in ('0928121987')
--           d.identificacion in ('1729924504','2400188971','0928168145','2450927534','2400458663','2450153115','0928121987','2450629122',
-- '2450253535','2400267304','0915445316','2450037755')
--          and d.fechaMatricula_anterior  in ('NO MATRICULADO') and d.fechaMatricula_2023_2  in ('NO MATRICULADO')
    order by d.apellidos,d.nombres
end




--VER MATRICULAS REPETIDAS
select p.identificacion, em.id_matricula_general, em.id_estudiante_oferta, count(em.id_estudiante_matricula)
from aca.estudiante_oferta eo
         inner join man.personas p on p.id = eo.id_persona
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.oferta o on o.id_oferta = om.id_oferta
         inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
         inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
-- inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
where eo.estado = 'A'
  and em.estado = 'A' --and ea.estado='A'
  and om.estado = 'A'
  and mg.estado = 'A'
  and o.id_tipo_oferta = 1
  and mg.id_periodo_academico = 138
group by em.id_estudiante_oferta, em.id_matricula_general, p.identificacion
having count(em.id_estudiante_matricula) > 1



--actualizar matriculas a otro cupo
BEGIN
    declare @id_periodo_academico int = 138
-- update em set em.id_estudiante_oferta = ofer.id_estudiante_oferta
select p.id as id_persona,
       p.identificacion,  p.apellidos, p.nombres,om.id_oferta_modalidad as id_oferta_modalidad_actual, o.descripcion  as carrera_actual,
       eo.id_periodo_academico as id_periodo_academico_actual, pa.codigo as periodo_actual,tee.descripcion as estadoCupo_actual,eo.id_estudiante_oferta as id_estudiante_oferta_actual,eo.id_malla as id_malla_actual,
       ISNULL(cast(em.id_estudiante_matricula as varchar(150)), 'NO MATRICULADO') as id_estudiante_matricula_actual,
       ISNULL(cast(em.fecha_ing as varchar(150)),'NO MATRICULADO') as fechaMatricula_actual,
-- ofer.id_oferta_modalidad as id_oferta_modalidad_anterior,ofer.carrera as carrera_anterior,
-- ofer.id_periodo_academico as id_periodo_academico_anterior,
       ofer.tipoEstado as estadoCupo_anterior,
       ofer.id_estudiante_oferta as id_estudiante_oferta_anterior,
       ofer.id_malla as id_malla_anterior,ofer.periodo as periodo_anterior,
       ISNULL(cast(ofer.fechaMatricula as varchar(150)),'NO MATRICULADO') as fechaMatricula_anterior,
       ISNULL(cast(ofer.id_estudiante_matricula as varchar(150)),'NO MATRICULADO') as id_estudiante_matricula_anterior,
       iif(em.fecha_ing is not null and ofer.fechaMatricula is not null,'SI','NO') AS matriculadoAmbasCarreras,
       iif(om.id_oferta_modalidad = ofer.id_oferta_modalidad,'SI','NO') AS mismaCarrrera
        from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.oferta o on o.id_oferta = om.id_oferta
         inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
         inner join man.departamentos d on d.id= do.id_departamento
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
         left join aca.estudiante_matricula em  on  eo.id_estudiante_oferta=em.id_estudiante_oferta
         left join aca.matricula_general mg  on mg.id_matricula_general=em.id_matricula_general and mg.id_periodo_academico = @id_periodo_academico
         inner join (select eo1.id_estudiante_oferta,eo1.id_malla,om1.id_oferta_modalidad,o1.descripcion as carrera,eo1.id_periodo_academico,pa1.codigo as periodo,tee1.descripcion as tipoEstado,
                            p1.id as id_persona,p1.identificacion, aux1.fecha_ing as fechaMatricula,aux1.id_estudiante_matricula
                     from man.personas p1
                              inner join aca.estudiante_oferta eo1 on eo1.id_persona = p1.id
                              inner join aca.oferta_modalidad om1 on om1.id_oferta_modalidad = eo1.id_oferta_modalidad
                              inner join aca.oferta o1 on o1.id_oferta = om1.id_oferta
                              inner join aca.departamento_oferta do1 on do1.id_oferta = o1.id_oferta
                              inner join man.departamentos d1 on d1.id= do1.id_departamento
                              inner join aca.tipo_estado_estudiante tee1 on tee1.id_tipo_estado_estudiante = eo1.id_tipo_estado_estudiante
                              left join aca.periodo_academico pa1 on pa1.id_periodo_academico = eo1.id_periodo_academico
                              left join (select eo22.id_persona,eo22.id_estudiante_oferta,eo22.id_oferta_modalidad,em.id_estudiante_matricula,em.fecha_ing from  aca.estudiante_oferta eo22
                                         inner join aca.estudiante_matricula em  on  eo22.id_estudiante_oferta=em.id_estudiante_oferta
                                         inner join aca.matricula_general mg  on mg.id_matricula_general=em.id_matricula_general
                                         where em.estado='A' and mg.id_periodo_academico = @id_periodo_academico
                     ) as aux1 on aux1.id_estudiante_oferta = eo1.id_estudiante_oferta
                     where eo1.estado='A' and p1.estado='AC' and o1.estado='A' and o1.id_tipo_oferta = 1 --and tee1.id_tipo_estado_estudiante <> 7
                       and eo1.id_periodo_academico <> @id_periodo_academico) as ofer on ofer.id_persona = p.id
where eo.estado='A' and p.estado='AC' and o.estado='A' and o.id_tipo_oferta = 1 --and tee.id_tipo_estado_estudiante <> 7
and eo.id_periodo_academico = @id_periodo_academico and p.identificacion in ('2400334047',
                                                                             '2400442980',
                                                                             '2450486531',
                                                                             '2450344128',
                                                                             '0928020866'

    ) and ofer.periodo in ('2024-2')
-- order by p.apellidos,p.nombres
END




select * from  aca.tipo_estado_estudiante
--INACTIVAR POBLACION QUE NO EFECTIVISO SU CUPO
    --2025-1 196 inactivos
-- update eo set eo.id_tipo_estado_estudiante = 7,eo.fecha_hasta=getdate(),eo.usuario_mod='2400254286'
select distinct o.descripcion,pa.codigo,em.id_estudiante_matricula,eo.id_estudiante_oferta,tee.id_tipo_estado_estudiante,tee.codigo,p.identificacion,
       p.nombres,p.apellidos,ea.id_paralelo,em.id_estudiante_matricula,em.fecha_ing,em.estado,ea.estado
from aca.estudiante_oferta eo
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join man.personas p on p.id = eo.id_persona
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
         inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
         left join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
         left join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
         left join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general and mg.id_periodo_academico= eo.id_periodo_academico
where eo.id_periodo_academico = 138 and (em.id_estudiante_matricula is null or em.estado='I') AND o.id_tipo_oferta = 1 and tee.codigo='ACT'
  and eo.estado='A' and om.estado='A' and do.estado='A' and pa.estado='A'
-- and p.identificacion in ('0927943738','0928019843','0955521901','1207318450',
-- '2400312779','2450236860','2450361676','2450545534')

select id_periodo_academico,codigo_tipo_periodo,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 1



-------AQUIII
select * from aca.tipo_estado_estudiante


--ESTUDIANTES POR COHORTES
select pa.codigo,count(p.identificacion) as estudiantes
from aca.estudiante_oferta eo
--     inner join aca.documentos_matricula dm on dm.id_estudiante_oferta = eo.id_estudiante_oferta
         inner join man.personas p on p.id = eo.id_persona
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad=eo.id_oferta_modalidad
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.oferta o on o.id_oferta = om.id_oferta
         inner join aca.malla m on  m.id_oferta_modalidad = om.id_oferta_modalidad AND m.estado in ('A','P') and m.fecha_hasta is null
         inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
where om.estado='A' and eo.estado='A' and tee.codigo ='ACT' and o.id_tipo_oferta =1 and p.estado='AC'
  and eo.id_periodo_academico is not null
group by pa.codigo


select * from niv.consultar_lista_Usuarios_cupos(126, 1, null,
                                                 null, null, null
                  , null, null, null) as c

select * from niv.estado_cupo
select * from aca.estudiante_calificacion
select * from aca.estudiante_matricula where observacion is not null and observacion='MATRICULADA ANULADA POR RETIRO VOLUNTARIO DE MANERA DEFINITIVA'
select * from mig.estados_academicos_automatic where identificacion='2400334047'
select * from aca.tipo_estado_estudiante
select * from aca.periodo_academico where id_tipo_oferta = 1
--     MATRICULADA ANULADA POR SOLICITUD DE RETIRO DEFINITIVO
--RETIROS DEFINITIVOS
begin
    declare @id_periodo_academico int=127
    select       --ea.id_estudiante_asignatura,ea.id_asignatura_aprendizaje,ea.id_paralelo,ea.estado
    distinct   eo.*
--         distinct  ea.*
--         distinct  mr.*
--             distinct em.*
--             distinct eo.id_estudiante_oferta,pa.codigo,d.nombre,o.descripcion,p.identificacion,p.apellidos,p.nombres,em.promedio
--                  eo.numero_matricula, ma.id_nivel, ma.id_malla_asignatura,ea.id_paralelo,ea.id_estudiante_asignatura,a.descripcion,
--                  case
--                      when ea.estado is null then 'NO MATRICULADO'
--                      when ea.estado = 'X' then 'ANULADA'
--                      when ea.estado = 'A' then 'ACTIVA'
--                      else ea.estado end as estadoMat,em.fecha_ing as fechaMatricula,em.fecha_mod as fechaModMatricula,
--                  concat(pu.nombres, ' ', pu.apellidos)   as usuarioCreaMatricula,
--                  concat(pu2.nombres, ' ', pu2.apellidos) as usuarioModificomatricula--,dea.*
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
             inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
             inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
             inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
             left join aca.matricula_rubro mr on em.id_estudiante_matricula = mr.id_estudiante_matricula
--         inner join aca.detalle_estudiante_asignatura dea on ea.id_estudiante_asignatura = dea.id_estudiante_asignatura
             inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
             inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
             inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
             inner join aca.oferta o on o.id_oferta = om.id_oferta
             inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
             inner join man.departamentos d on d.id = do.id_departamento
             left join seg.usuarios u on u.usuario = ea.usuario_ing
             left join man.personas pu on pu.id = u.persona_id
             left join seg.usuarios u2 on u2.usuario = ea.usuario_mod
             left join man.personas pu2 on pu2.id = u2.persona_id
    where mg.id_periodo_academico = @id_periodo_academico
      and p.identificacion in
          ('2450317462',
           '0928222595',
           '0927946996',
           '0928236132'
              ) and eo.id_estudiante_oferta not in (73576)
end


---2022-1 58 totales 40 ni presencial ni hibrido, 18 no presencial si hibrido, 14 valido hibrido, 4 no valido hibrido
---2022-2 35
---2023-1 33
---2023-2 56
select id_periodo_academico,codigo,codigo_tipo_periodo,descripcion from aca.periodo_academico where id_tipo_oferta = 1

select * from man.personas where porcentaje_dis like'%%%'
------------REPORTE FINAL SABER QUIENES SON LOS JOVENES QUE NO DEBEN ESTAR MATRICULADOS EN PRIMER SEMESTRE
begin

    declare @pi_id_perido_academico int =138,@id_oferta_modalidad int= null
--         select distinct eo.* from (
    select distinct xd.* from (
          select
              --ina.CARRERA,ina.CEDULA,ina.USU_NOMBRES,ina.USU_APELLIDOS,ina.PERIODO_ASIGNACION_CUPO,
              PA.codigo AS per_academico,eo.id_estudiante_oferta,om.id_oferta_modalidad,d.nombre as facultad,o.descripcion as carrera,p.id as id_persona,p.identificacion,p.apellidos,p.nombres,
              case when (
                            select count(ea1.promedio) from aca.estudiante_asignatura ea1
                                                                inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                                                                inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = aa1.id_malla_asignatura
                                                                inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
                            where ea1.id_estudiante_matricula = em.id_estudiante_matricula and ea1.estado <>'I'
                        ) =
                        (
                            select count(ea1.promedio) from aca.estudiante_asignatura ea1
                                                                inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                                                                inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = aa1.id_malla_asignatura
                                                                inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
                            where ea1.id_estudiante_matricula = em.id_estudiante_matricula and ea1.estado <>'I' and ea1.aprobado = 1
                        ) then 'APROBADO' else 'REPROBADO' end as aprobado,round(cast (avg(ea.promedio) as decimal(10,2)),0) as promedioRedondeado,
              cast (avg(ea.promedio) as decimal(10,2)) as promedioReal,em.id_paralelo as paralelo,isnull(d2.descripcion,'NINGUNA') as discapacidad,
              iif(p.porcentaje_dis is null or p.porcentaje_dis='',0,p.porcentaje_dis) as porcentajeDiscapacidad,p.celular,p.email_personal,em.fecha_mod as fecha_matricula,p.direccion,
              case when (
                            select top 1 ea1.codigo_estado_matricula from aca.estudiante_matricula em1
                                                                              inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
                                                                              inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                            where em1.id_estudiante_oferta = eo.id_estudiante_oferta and em1.estado <>'I' and mg1.estado='A'
                              and ea1.estado <>'I'and ea1.codigo_estado_matricula='SEG'
                        )='SEG' then 'SEGUNDA VEZ' else 'PRIMERA VEZ' end as VECES,tee.descripcion as estado_cupo,
              iif((select d.idEstudianteMatricula from [rel].[fn_get_detalle_matricula_by_estudiante_oferta]
                                                       (eog.id_estudiante_oferta,null,0) as d) is null,'NO','SI') as matricula_primer_semestre,
              iif((select d.idEstudianteMatricula from [rel].[fn_get_detalle_matricula_by_estudiante_oferta]
                                                       (eog.id_estudiante_oferta,null,0) as d) is null,'NO APLICA',
                  (select d.periodoAcademico from [rel].[fn_get_detalle_matricula_by_estudiante_oferta](eog.id_estudiante_oferta,null,0) as d)
              ) as periodo_primer_semestre,
              isnull(eog.id_estudiante_oferta,0) as idEstudianteOferta1Semestre,
              isnull((select d.estadoMatricula from [rel].[fn_get_detalle_matricula_by_estudiante_oferta]
                                                    (eog.id_estudiante_oferta,null,1) as d),'NO REGISTRA') as estadoMatricula1Semestre
          --         ,iif((select d.idEstudianteMatricula from [rel].[fn_get_detalle_matricula_by_estudiante_oferta]
    --                                                  (eogh.id_estudiante_oferta,null,0) as d) is null,'NO','SI') as matricula_primer_semestre_hi,
    --         iif((select d.idEstudianteMatricula from [rel].[fn_get_detalle_matricula_by_estudiante_oferta]
    --                                                  (eogh.id_estudiante_oferta,null,0) as d) is null,'NO APLICA',
    --             (select d.periodoAcademico from [rel].[fn_get_detalle_matricula_by_estudiante_oferta](eogh.id_estudiante_oferta,null,0) as d)
    --         ) as periodo_primer_semestre_hi,
    --         isnull(eogh.id_estudiante_oferta,0) as idEstudianteOferta1Semestre_hi,
    --         isnull((select d.estadoMatricula from [rel].[fn_get_detalle_matricula_by_estudiante_oferta]
    --                                               (eogh.id_estudiante_oferta,null,0) as d),'NO REGISTRA') as estadoMatricula1SemestreHi
            from man.personas p
                left join man.discapacidad d2 on p.id_discapacidad = d2.id_discapacidad
            inner join aca.estudiante_oferta eo on eo.id_persona = p.id
--             inner join rel.fn_relaciones_ofertas_nivelacion_grado(@pi_id_perido_academico) ore on ore.idOfertaModalidadNivelacion = eo.id_oferta_modalidad
--             left join aca.estudiante_oferta eog on eog.id_persona = p.id and eog.id_oferta_modalidad = ore.idOfertaModalidadPregrado
            --         inner join rel.fn_relaciones_ofertas_nivelacion_grado(24) oreh on oreh.idOfertaModalidadNivelacion = eo.id_oferta_modalidad
            --         left join aca.estudiante_oferta eogh on eogh.id_persona = p.id and eogh.id_oferta_modalidad = oreh.idOfertaModalidadPregrado
            left join aca.estudiante_oferta eog on eog.id_estudiante_oferta_padre = eo.id_estudiante_oferta
            inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
            inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta and em.estado<>'I'
            inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula  and ea.estado<>'I'
            inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
            inner join aca.periodo_academico pa on pa.id_periodo_academico =  mg.id_periodo_academico
            inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
            inner join aca.oferta o on o.id_oferta = om.id_oferta
            inner join aca.tipo_oferta tof on o.id_tipo_oferta = tof.id_tipo_oferta
            inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
            inner join man.departamentos d on d.id= do.id_departamento
            inner join seg.usuarios u on u.persona_id = p.id
          where  pa.id_periodo_academico = @pi_id_perido_academico and( om.id_oferta_modalidad = @id_oferta_modalidad or @id_oferta_modalidad is null)
            and tof.codigo='NIVELACION'
            AND eo.estado='A' and u.estado='AC' and tof.estado='A' --and p.identificacion='0958799066'
          --         AND tee.codigo ='APR'
--             and om.id_oferta_modalidad = 43
          group by eo.id_estudiante_oferta,om.id_oferta_modalidad,u.id,p.id,p.identificacion,p.nombres,p.apellidos,
                   em.id_estudiante_matricula, d.nombre,o.descripcion,u.usuario,eo.id_oferta_modalidad,em.id_paralelo,pa.codigo,tee.descripcion,
                   p.porcentaje_dis,p.celular,p.email_personal,em.fecha_mod,p.direccion,eo.id_estudiante_oferta,eog.id_estudiante_oferta,d2.descripcion
    --         ,eogh.id_estudiante_oferta,ore.idOfertaModalidadPregrado,
          -- 			         , ina.CARRERA, ina.CEDULA,
          -- 			ina.USU_NOMBRES,ina.USU_APELLIDOS,INA.PERIODO_ASIGNACION_CUPO,pa.codigo
          -- 			order by d.nombre,o.descripcion,p.apellidos,p.nombres
      ) as xd
    --         inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = xd.idEstudianteOferta1Semestre
--         where xd.aprobado ='APROBADO' and xd.matricula_primer_semestre = 'SI'
--            and xd.matricula_primer_semestre='NO'
--             and xd.matricula_primer_semestre_hi='NO'
--         and xd.matricula_primer_semestre='SI'
--           and xd.estadoMatricula1Semestre<>'A'
--           and xd.idEstudianteOferta1Semestre <>xd.idEstudianteOferta1Semestre_hi
--         and xd.identificacion not in ('2450221425','0931086060')
--           --condicion periodo 2022-1 15
--         and (  xd.matricula_primer_semestre = 'SI' and xd.periodo_primer_semestre in ('2023-2','2024-1','2024-2'))
    --condicion periodo 2022-2 24
--         and (  xd.matricula_primer_semestre = 'SI' and xd.periodo_primer_semestre in ('2024-1','2024-2'))
    --condicion periodo 2023-1 28
--         and (  xd.matricula_primer_semestre = 'SI' and xd.periodo_primer_semestre in ('2024-2'))
--         and xd.identificacion='1729799195'
    order by xd.facultad,xd.carrera,xd.apellidos,xd.nombres
end


select * from aca.tipo_estado_estudiante

select * from aca.tipo_ingreso_estudiante
select pa.id_periodo_academico,pa.codigo,pa.descripcion,fecha_desde,fecha_hasta from aca.periodo_academico pa
where pa.id_tipo_oferta = 1

---3635
-- se deben inhabilitar 228 estado 7
--     6032 id_persona
-- 61407
--     12016591353	12016591353-RED
---actualizar malla nueva a personas por 2da vez
--     update eo set eo.id_malla=m.id_malla
select --eo.*
       eo.id_estudiante_oferta,eo.id_oferta_modalidad,p.id as id_persona,p.identificacion,p.apellidos,p.nombres,
       om.carrera,eo.numero_matricula,eo.id_periodo_academico,eo.id_malla,m.id_malla,count(em.id_estudiante_matricula) as matriculas
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
    inner join aca.malla m on m.id_oferta_modalidad = eo.id_oferta_modalidad and m.estado in ('A','P') and m.vigente=1
        left join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta and em.estado='A'
where  -- o.id_tipo_oferta = 1 and
eo.id_periodo_academico <>138 and eo.id_oferta_modalidad in (42,47,57,58,106,112,115) and
eo.id_tipo_estado_estudiante =1 and eo.estado='A' and om.id_tipo_oferta =1
-- and eo.id_malla <>m.id_malla
group by eo.id_estudiante_oferta, p.identificacion, p.apellidos, p.nombres, eo.numero_matricula, eo.id_periodo_academico, p.id, om.carrera, eo.id_oferta_modalidad, eo.id_malla, m.id_malla
--     eo.id_tipo_ingreso_estudiante =9
-- p.identificacion  in ('2400470338')

select * from aca.tipo_ingreso_estudiante
select * from aca.tipo_estado_estudiante
select * from aca.ofertas_facultad where id_tipo_oferta =1
select * from pro.proceso_usuario where usuario_ing ='2400470338'

select * from aca.movilidad where id_estudiante_oferta = 79374

select * from aca.detalle_movilidad WHERE id_movilidad = 9680
-- 0924921927 0802736314  casos de sisweb
--     in ('2450221425','0931086060') casos de sga ya resueltos

--     202110320300887
-- 2022132300887

select * from aca.estudiante_oferta where id_tipo_ingreso_estudiante = 9

select o.descripcion,om.* from aca.oferta_modalidad om
inner join aca.oferta o on om.id_oferta = o.id_oferta
where om.estado='A' and o.id_tipo_oferta = 2
select * from Bd_Academico..TE_MATRICULAS te where te.ID_PERSONA = 48668 and MATRICULA='202110320300887'

select * from mig.estado_academicos where identificacion in ('0924921927','0802736314','2450221425','0931086060')

select * from rel.fn_relaciones_ofertas_nivelacion_grado(15)

select * from rel.fn_relaciones_ofertas_nivelacion_grado(32)

select * from aca.estudiante_oferta where id_estudiante_oferta in (996,1014,968,1466,981)

select * from aca.malla where id_oferta_modalidad = 59

select * from aca.estudiante_matricula em where id_estudiante_oferta in (11370,11762)


--generar numero de matricula
begin
    declare @id_oferta_modalidad int = 59,@id_periodo_academico int = 14
select
CONCAT('20221',RIGHT('000' + Ltrim(Rtrim(Rtrim((0)+@id_oferta_modalidad))),3),RIGHT('00' + Ltrim(Rtrim(Rtrim((0)+3))),2) ,RIGHT('00000' + Ltrim(Rtrim(Rtrim((0)+
(select count(p.identificacion) from aca.estudiante_oferta eo
      inner join man.personas p on p.id = eo.id_persona
where eo.id_oferta_modalidad = @id_oferta_modalidad and p.estado='AC' and eo.estado='A')+1))),5) )
end

select * from aca.periodo_academico where id_tipo_oferta = 2
select ma.id_malla_asignatura,a.descripcion from aca.malla m
inner join aca.malla_asignatura ma on m.id_malla = ma.id_malla
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
inner join aca.asignatura_aprendizaje aa on ma.id_malla_asignatura = aa.id_malla_asignatura
where m.id_malla=62


exec [aca].[sp_list_all_carreras_records]  '2400304966' ,null, null , null, null
select  * from aca.tipo_estado_estudiante
---cupos innabilitados
select --eo.*
    distinct eo.id_periodo_academico,p.identificacion,p.apellidos,p.nombres,o.descripcion,eo.id_tipo_estado_estudiante,tee.descripcion,em.id_estudiante_matricula,em.estado
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    --         inner join rel.fn_relaciones_ofertas_nivelacion_grado(24) oreh on oreh.idOfertaModalidadNivelacion = eo.id_oferta_modalidad
--         left join aca.estudiante_oferta eogh on eogh.id_persona = p.id and eogh.id_oferta_modalidad = oreh.idOfertaModalidadPregrado
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.oferta o on o.id_oferta = om.id_oferta
         inner join aca.tipo_oferta tof on o.id_tipo_oferta = tof.id_tipo_oferta
         inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
         inner join man.departamentos d on d.id= do.id_departamento
         inner join seg.usuarios u on u.persona_id = p.id
         left join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta and em.estado<>'I'
         left join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula  and ea.estado<>'I'
         left join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
         left join aca.periodo_academico pa on pa.id_periodo_academico =  mg.id_periodo_academico and pa.id_periodo_academico = 37
where tee.codigo = 'ACT' and o.id_tipo_oferta = 1 and (em.id_estudiante_matricula is null or em.estado<>'A')
  and tof.codigo='NIVELACION' and p.identificacion in (
                                                       '0924929466','0924929466','0928019330','0928019330','0928121987','0928121987','0928862762','0928862762',
                                                       '0944065135','0944065135','0956669972','0956669972','1317303095','1317303095','2400023376','2400023376',
                                                       '2450118373','2450118373','2450337031','2450337031','2450629122','2450629122'    )


select * from aca.tipo_estado_estudiante


--ver jornada estudiante
select * from aca.fn_recuperar_jornada_postulante_nivelacion(32,49370)

select * from rel.fn_relaciones_ofertas_nivelacion_grado(15) as d
where d.idOfertaModalidadNivelacion = 49
select * from rel.fn_relaciones_ofertas_nivelacion_grado(24)

select om.id_oferta_modalidad,om.id_modalidad,o.* from aca.oferta_modalidad om
                                                           inner join aca.oferta o on om.id_oferta = o.id_oferta
where om.id_oferta_modalidad in (25,59,103)


select * from aca.estudiante_oferta eo where eo.id_persona in (14979,14790) and eo.id_oferta_modalidad = 59

exec niv.[sp_consultar_estudiante_aprobado_pre] 37

select * from [rel].[fn_get_detalle_matricula_by_estudiante_oferta](17279,null,0)

select pa.id_periodo_academico,pa.codigo,pa.descripcion,pap.id_periodo_academico,pap.codigo,pap.descripcion from aca.periodo_academico pa
                                                                                                                     inner join aca.periodo_academico pap on pap.codigo=pa.codigo and pap.id_tipo_oferta = 2 and pap.estado='A'
where pa.id_tipo_oferta = 1 and pa.id_periodo_academico<40


select * from man.tipo_identificacion

select * from sri.tipo_identificacion


select * from aca.horario_academico where id_dia = 6 and usuario_ing='0916480932'

select * from niv.calificaciones_nivelacion
--casos atipicos estudiantes que cursaron derecho en playas  em nivelacion y estan en
--     2450221425
--     {bcrypt}$2a$10$xpwSQkaDSK0w0HwcZFgxfu1WuVDKmct4Gg4Kxiry.dQKBdzMhMb6O
-- {MD5}9668ae99363fef20b9d377693a0971aa
select * from seg.usuarios where usuario='0911009819'
select concat('{MD5}',Bd_Academico.[dbo].[fn_Md5]('2450221425'))

--     0931086060
--     {bcrypt}$2a$10$g1Gdk56j/Zfyo8XWMGxvT.FREvJ5MnybgsrTLq3JSDQlrLZBAUmqW
-- {MD5}05bd1ac578b1a79569e121dddcb5c86b
select * from seg.usuarios where usuario='0931086060'
select concat('{MD5}',Bd_Academico.[dbo].[fn_Md5]('0931086060'))
--acuas2
---habilitar nueva poblacion 2024-2 +35 de reubicacion
--3529+47
--3576
-- 3552+47 playas  no ofertado
select eo.id_estudiante_oferta,ore.idOfertaModalidadNivelacion,c.CARRERA,m.CARRERA as carrera_excel, c.id_persona,c.IDENTIFICACION,concat(c.apellidos,' ',c.nombres) as nombres,1,
       u.id,c.id_periodo_academico,iif(em.id_estudiante_matricula is null,'NO','SI') as matriculado,c.JORNADA
from niv.consultar_lista_Usuarios_cupos (126,1,null,null,
                                         null,null,null,null,null) c
         left join tmp.[matriz_asignacion_2024-2] m on m.CEDULA = c.IDENTIFICACION
         inner join seg.usuarios u on u.persona_id = c.id_persona
         left join rel.fn_relaciones_ofertas_nivelacion_grado(38) ore on ore.idOfertaModalidadPregrado = c.id_oferta_modalidad
         left join aca.estudiante_oferta eo on eo.id_persona = c.id_persona and eo.id_oferta_modalidad = ore.idOfertaModalidadNivelacion and eo.estado='A'
        left join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta and em.estado='A' and eo.id_periodo_academico = 38
where  u.estado='AC' and m.CARRERA=c.CARRERA --and eo.id_estudiante_oferta is null
group by ore.idOfertaModalidadNivelacion,c.CARRERA, c.id_persona,c.IDENTIFICACION,c.apellidos,c.JORNADA,
         c.nombres,u.id,c.id_periodo_academico, m.CARRERA, m.CEDULA, em.id_estudiante_matricula, eo.id_estudiante_oferta
order by c.CARRERA,c.APELLIDOS,c.NOMBRES




select * from aca.tipo_jornada_laboral

select * from niv.consultar_lista_total_cupos_asignados (38,null,124,null)

select * from rel.fn_relaciones_ofertas_nivelacion_grado(38)

-- exec [aca].[sp_migrate_estudiantes_postulantes_nivelacion_to_oferta_nivelacion] 126
--3726
select * from niv.consultar_lista_Usuarios_cupos(127, 1, null,
                                                 null, null, null , null, null, null) as c


exec [aca].[sp_migrate_estudiantes_postulantes_nivelacion_to_oferta_nivelacion] 38

exec [aca].[pa_generar_asignaturas_a_matricular_sga] 53967,35,2,1
exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 53967,35,2,1

--todos los manes que tengan matricula activa en un cupo viejo de los periodos 2023-2 y 2024-1 pierden gratuidad
--los manes que tengan de tenga cupo activo en carrera tambien pierde gratuidad
--segunda matricula se innabilitan los manes de los periodos que no han hecho su segunda matricula hasta el 2023-1
--


--listar ofertas de nivelacion
select eo.id_estudiante_oferta,pa.codigo,p.identificacion,p.apellidos,p.nombres,o.descripcion as carrera,tee.codigo,tee.descripcion
from aca.estudiante_oferta eo
    inner join aca.periodo_academico pa on eo.id_periodo_academico = pa.id_periodo_academico
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join man.personas p on eo.id_persona = p.id
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
where --o.id_tipo_oferta = 1 and eo.id_periodo_academico is null and eo.estado='A'
--      eo.id_estudiante_oferta =30560
    p.identificacion='2400348302'

exec [aca].[sp_list_all_carreras_records] '2300860547',null,null,null,null


select * from aca.estudiante_matricula where id_estudiante_oferta = 21524

select * from man.personas where apellidos like '%VALAREZO LUISA%' and nombres like '%EDISON DAVID%'

select * from man.personas where identificacion='0000000305'
select * from aca.oferta_modalidad where id_oferta_modalidad = 56
select * from aca.modalidad

select * from aca.tipo_estado_estudiante
select 1 from tes.fn_cobros_tasas_fecha_corte_sistema_anterior ('2450466848','2025-09-01 13:29:01.770') as cv
WHERE cv.abono>0 and cv.periodo_academico='2025-2'
--acuas
select * from aca.fn_requisitos_matricula(96491,127)
select d.*  from aca.fn_datos_estudiante_matricula(127,96491) as d
-- select * from  aca.fn_Fechas_habilitas_matricula_estudiante_oferta ( 96491,127)
select * from niv.consultar_lista_Usuarios_cupos(127, 1, null,
                                                 null, null, null
                  , null, null, null) as c

select * from [aca].[fn_recuperar_jornada_postulante_nivelacion](127,96491)

select d.idParalelo as idParalelo, d.paralelo as paralelo,	d.idJornada  as idJornada,
 d.jornada as jornada, d.idOfertaModalidad as idOfertaModalidad	from aca.fn_get_jornada_by_carrera  (96491,127) as d

SELECT TOP (1)  em1.id_estudiante_oferta
FROM aca.estudiante_matricula em1
         INNER JOIN aca.estudiante_oferta eo1 ON eo1.id_estudiante_oferta = em1.id_estudiante_oferta
         INNER JOIN aca.estudiante_asignatura ea1 ON em1.id_estudiante_matricula = ea1.id_estudiante_matricula
         INNER JOIN aca.matricula_general  mg1 ON em1.id_matricula_general = mg1.id_matricula_general
WHERE ea1.estado = 'A'
  AND mg1.id_periodo_academico = 127
  AND eo1.id_persona = 90117
ORDER BY em1.id_estudiante_matricula DESC;

select * from aca.periodo_academico_oferta

select * from aca.nivel_formacion

--POBLACION ACTIVA QUE SE PUEDE MATRICULAR A NIVELACION   5901
--3753 cupos nuevos
--1725 habilitados para segunda matricula segun sga
begin
    declare @id_periodo_cademico int =126
select * from (
select --at.*
       pa.codigo,om.facultad,eo.id_oferta_modalidad,om.carrera,p.identificacion,p.apellidos,p.nombres,tee.descripcion,eo.mantiene_gratuidad,eo.vez_proyectada,
       iif(pa.codigo='2026-1','APLICAN 1 VEZ','APLICAN 2 VEZ') as status,aux.id_estudiante_matricula,
--     (select jornada from [aca].[fn_recuperar_jornada_postulante_nivelacion](127,eo.id_estudiante_oferta)) as jornada,
    aux.id_paralelo,aud.archivos_sub,info.info_sub
--        eo.*
from aca.estudiante_oferta eo
        inner join aca.periodo_academico_oferta pao on pao.id_oferta_modalidad = eo.id_oferta_modalidad and pao.id_periodo_academico = @id_periodo_cademico
         inner join man.personas p on p.id = eo.id_persona
         inner join seg.usuarios u on p.id = u.persona_id
         inner join aca.ofertas_facultad om on om.id_oferta_modalidad=eo.id_oferta_modalidad
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
        left join (select count(dm.id_documentos_matricula) as archivos_sub,dm.id_estudiante_oferta from aca.documentos_matricula dm where dm.id_periodo_academico = @id_periodo_cademico
         group by dm.id_estudiante_oferta) as aud on aud.id_estudiante_oferta = eo.id_estudiante_oferta
        left join( select count(iap.id_informacion_academica_persona) as info_sub,iap.id_persona  from man.informacion_academica_persona iap
    where iap.id_nivel_formacion = 2 and iap.estado='A' group by iap.id_persona ) as info on info.id_persona = eo.id_persona
        left join ( select em.id_estudiante_matricula,em.id_estudiante_oferta,ea.id_paralelo from aca.estudiante_matricula em
    inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
    inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
                                              where em.estado='A' and ea.estado='A' and mg.id_periodo_academico= @id_periodo_cademico
                                              group by em.id_estudiante_matricula,em.id_estudiante_oferta,ea.id_paralelo) as aux on aux.id_estudiante_oferta = eo.id_estudiante_oferta
where eo.estado='A' and om.id_tipo_oferta =1 and p.estado='AC'  and tee.codigo ='ACT'
  and eo.id_periodo_academico is not null
) as d
--          where d.jornada<>d.jornada_pos and d.jornada_pos<>'HÍBRIDA'
--          and d.id_oferta_modalidad not in (44,61,45,64,63,108)
order by d.codigo,d.carrera,d.nombres,d.apellidos
end

select * from aca.documentos_matricula where usuario_ing='2450622820'
-- DBCC CHECKIDENT ('aca.documentos_matricula', RESEED, 41551);
select * from aca.documentos_matricula
-- where c.IDENTIFICACION='2400470106'

select * from aca.jornada

select * from niv.estado_cupo



exec [aca].[pa_generar_asignaturas_a_matricular_sga] 74525,38,2,1
exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 74525,38,2,1



select id_periodo_academico,codigo,descripcion,numero_semanas from aca.periodo_academico where id_tipo_oferta = 1

begin
    declare @id_periodo_academico int=38
    select distinct pa.codigo,d.nombre,o.descripcion as carrera,p.identificacion,p.apellidos,p.nombres,
           eo.numero_matricula,p.email_institucional,p.fecha_ing,p.fecha_mod,p.usuario_ing,p.usuario_mod
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
             inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
             inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
             inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
             inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
             inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
             inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
             inner join aca.oferta o on o.id_oferta = om.id_oferta
             inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
             inner join man.departamentos d on d.id = do.id_departamento
             left join seg.usuarios u on u.usuario = ea.usuario_ing
             left join man.personas pu on pu.id = u.persona_id
             left join seg.usuarios u2 on u2.usuario = ea.usuario_mod
             left join man.personas pu2 on pu2.id = u2.persona_id
    where   mg.id_periodo_academico = @id_periodo_academico and em.estado='A' and ea.estado='A' and p.email_institucional like '%-%'
end;

select * from aca.ofertas_facultad where id_tipo_oferta=1
select * from aca.fn_listar_docentes_asignaturas (null,105,138) as d
exec [aca].[sp_rpt_comprobante_matricula_estudiante] 152416,null


begin
    declare @pi_id_oferta_modalidad int = 105
select distinct  daa.id_docente_asignatura_aprend,aa.id_asignatura_aprendizaje,pl.id_paralelo,aux.id_docente,ma.id_malla_asignatura,asig.descripcion,n.orden,
-- 		concat(n.descripcion_corta ,'/', pl.descripcion_corta,' DOCENTE ASIGNADO') as docente ,
                 concat(n.descripcion_corta ,'/', pl.descripcion_corta,'  ' ,aux.nombres) as docente ,
                 daa.num_estudiantes,
                 isnull([aca].[fn_esc_get_numero_estudiantes_matriculados_by_asignatura_paralelo](ma.id_malla_asignatura,pl.id_paralelo,@pi_id_periodo_academico,null),0) as nuMatriculados,
                 co.codigo as cod,aux.id_distributivo_docente
from aca.malla m
         inner join aca.malla_asignatura ma on m.id_malla= ma.id_malla
         inner join aca.asignatura asig on asig.id_asignatura = ma.id_asignatura
         inner join aca.nivel n on ma.id_nivel = n.id_nivel
         inner join aca.asignatura_aprendizaje aa on aa.id_malla_asignatura = ma.id_malla_asignatura
         inner join aca.componente_aprendizaje co on  co.id_componente_aprendizaje = aa.id_componente_aprendizaje
         inner join aca.docente_asignatura_aprend daa on daa.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje and daa.estado='A'
         inner join aca.paralelo pl on daa.id_paralelo = pl.id_paralelo  and pl.estado='A'
         inner join
     (
         select case when aux.id_docente is null THEN 'DOCENTE AÚN POR DEFINIR' ELSE concat(aux.apellidos,' ',aux.nombres) END as nombres,
                ddo.id_distributivo_docente,ddo.id_distributivo_oferta,aux.id_docente,pao.id_reglamento
         from aca.distributivo_oferta dio
                  inner join aca.periodo_academico_oferta pao on pao.id_periodo_academico_oferta = dio.id_periodo_academico_oferta
                  inner join aca.distributivo_docente ddo on ddo.id_distributivo_oferta = dio.id_distributivo_oferta
                  left join
              (
                  select d.id_docente,p.nombres,p.apellidos from aca.docente d
                                                                     inner join man.personas p on p.id = d.id_persona
                  where d.estado='A' and p.estado='AC'
              ) as aux on ddo.id_docente = aux.id_docente

         where  ddo.id_distributivo_oferta =
                (SELECT max(dio1.id_distributivo_oferta) FROM  aca.periodo_academico pa
                                                                   inner join aca.periodo_academico_oferta pao1  on pao1.id_periodo_academico=pa.id_periodo_academico
                                                                   inner join aca.distributivo_oferta dio1  on pao1.id_periodo_academico_oferta = dio1.id_periodo_academico_oferta
                                                                   inner join aca.distributivo_docente ddo1 on ddo1.id_distributivo_oferta = dio1.id_distributivo_oferta
                 where
                     pao1.id_oferta_modalidad= @idOfertaModalidadAux
                   and dio1.estado in ('A','V','D') and pao1.estado='A'
                   and pa.id_periodo_academico= @idPeriodoAcademicoAux
                    --and (pa.id_periodo_academico =@pi_id_periodo_academico
                    --    or [aca].[fn_esc_get_periodo_by_relacion_mallas](m.id_malla,pa.id_periodo_academico)=@pi_id_periodo_academico
                    --)
                )
           and ddo.estado='A' and dio.estado in ('A','V','D') and pao.estado='A'
         --condicion para que agregue las asignaturas de las otras carreras
         --or ()
         group by aux.apellidos,aux.nombres, ddo.id_distributivo_docente,ddo.id_distributivo_oferta,aux.id_docente,pao.id_reglamento
     )
         as aux on aux.id_distributivo_docente =  daa.id_distributivo_docente
         left join
     (
         select daa.id_distributivo_docente, ma.id_malla_asignatura ,pl.id_paralelo,count (co.codigo) as cantidad
         from aca.malla_asignatura ma
                  inner join aca.malla mal on mal.id_malla = ma.id_malla
                  inner join aca.nivel n on ma.id_nivel = n.id_nivel
                  inner join aca.asignatura_aprendizaje aa on aa.id_malla_asignatura = ma.id_malla_asignatura
                  inner join aca.docente_asignatura_aprend daa on daa.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                  inner join aca.paralelo pl on daa.id_paralelo = pl.id_paralelo
                  inner join aca.componente_aprendizaje co on  co.id_componente_aprendizaje = aa.id_componente_aprendizaje
         where  co.codigo in (select d.codigoHijo from aca.fn_listar_componentes_aprendizajes_reglamento(@idReglamentoMatricula) as d)
           and (daa.id_tipo_docente is null or daa.id_tipo_docente = 1)
           and daa.estado='A' and ma.estado='A' and aa.estado='A' and pl.estado='A' and co.estado='A'
         group by daa.id_distributivo_docente, ma.id_malla_asignatura  ,pl.id_paralelo
     )
         as auxx on auxx.id_distributivo_docente = daa.id_distributivo_docente and auxx.id_malla_asignatura=ma.id_malla_asignatura and auxx.id_paralelo=pl.id_paralelo
         LEFT JOIN aca.tipo_oferta as tof on n.id_tipo_oferta = tof.id_tipo_oferta
where
  --cambiar esta condicion en caso de postgrados si falla
    (
        (auxx.cantidad = 2 and co.codigo in
                               (select d.codigoHijo from aca.fn_listar_componentes_aprendizajes_reglamento(@idReglamentoMatricula) as d
                                where d.codigoPadre in ('DOCENCIA')
                               )) OR
        (auxx.cantidad = 1 and  co.codigo in (select d.codigoHijo from aca.fn_listar_componentes_aprendizajes_reglamento(@idReglamentoMatricula) as d))
            OR (tof.codigo = 'POSGRADO' and co.codigo in
                                            (select d.codigoHijo
                                             from aca.fn_listar_componentes_aprendizajes_reglamento(@idReglamentoMatricula) as d)
            )
        )
  AND  ma.estado='A' and aa.estado='A' and co.estado='A' and asig.estado='A' and n.estado='A'
  and m.id_oferta_modalidad = @pi_id_oferta_modalidad
end

select distinct  ddo.id_distributivo_oferta,ddo.id_distributivo_docente,n.descripcion_corta as nivel,pl.descripcion_corta as paralelo,aux.id_docente,
                 ofa.facultad,ofa.carrera,ma.id_malla_asignatura,asig.descripcion,
                 concat(n.descripcion_corta ,'/', pl.descripcion_corta) as curso,
                 daa.num_estudiantes,case when aux.id_docente is null THEN 'DOCENTE AÚN POR DEFINIR' ELSE concat(aux.apellidos,' ',aux.nombres) END as docente,
                 isnull([aca].[fn_esc_get_numero_estudiantes_matriculados_by_asignatura_paralelo](ma.id_malla_asignatura,pl.id_paralelo,
                                                                                                  @id_periodo_academico,null),0) as nuMatriculados,
                 co.codigo as componente,daa.id_docente_asignatura_aprend,aa.id_asignatura_aprendizaje,pao.id_periodo_academico,m.id_oferta_modalidad,
                 pao.id_reglamento
from aca.distributivo_oferta dio
         inner join aca.periodo_academico_oferta pao on pao.id_periodo_academico_oferta = dio.id_periodo_academico_oferta
         inner join aca.distributivo_docente ddo on ddo.id_distributivo_oferta = dio.id_distributivo_oferta
         inner join aca.docente_asignatura_aprend daa on daa.id_distributivo_docente = ddo.id_distributivo_docente
         inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = daa.id_asignatura_aprendizaje
         inner join aca.componente_aprendizaje co on  co.id_componente_aprendizaje = aa.id_componente_aprendizaje
         inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
         inner join aca.malla m on ma.id_malla = m.id_malla
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
         inner join aca.asignatura asig on asig.id_asignatura = ma.id_asignatura
         inner join aca.nivel n on ma.id_nivel = n.id_nivel
         inner join aca.paralelo pl on daa.id_paralelo = pl.id_paralelo
         inner join (
    SELECT dio1.id_distributivo_oferta, pao1.id_oferta_modalidad, pao1.estado AS estado_pao,  dio1.estado AS estado_dio,  pa.id_periodo_academico,pa.codigo,
           ROW_NUMBER() OVER (PARTITION BY pao1.id_oferta_modalidad ORDER BY dio1.id_distributivo_oferta DESC) AS rn
    FROM aca.periodo_academico pa
             INNER JOIN aca.periodo_academico_oferta pao1  ON pao1.id_periodo_academico = pa.id_periodo_academico
             INNER JOIN aca.distributivo_oferta dio1 ON pao1.id_periodo_academico_oferta = dio1.id_periodo_academico_oferta
    WHERE dio1.estado IN ('A','V','D') AND pao1.estado = 'A'   and  (pa.id_periodo_academico = @id_periodo_academico or pa.id_periodo_academico_padre = @id_periodo_academico)
) as ud ON ddo.id_distributivo_oferta = ud.id_distributivo_oferta AND ud.rn = 1
         left join
     (
         select d.id_docente,p.nombres,p.apellidos from aca.docente d
                                                            inner join man.personas p on p.id = d.id_persona
         where d.estado='A' and p.estado='AC'
     ) as aux on ddo.id_docente = aux.id_docente
where ddo.estado='A' and daa.estado='A' and aa.estado='A' and dio.estado in ('A','V','D') and pao.estado='A' and pl.estado='A'
  and  ma.estado='A' and co.estado='A' and asig.estado='A' and n.estado='A' and (m.id_oferta_modalidad = @id_oferta_modalidad or @id_oferta_modalidad is null)
  and  co.codigo in (select dd.codigoHijo from aca.fn_listar_componentes_aprendizajes_reglamento((select mg.id_reglamento from aca.matricula_general mg
                                                                                                  where mg.id_periodo_academico = @id_periodo_academico) ) as dd)
  and ofa.id_tipo_oferta = (select pa.id_tipo_oferta from aca.periodo_academico pa where pa.id_periodo_academico = @id_periodo_academico)
group by aux.apellidos,aux.nombres, ddo.id_distributivo_docente,ddo.id_distributivo_oferta,aux.id_docente,
         ma.id_malla_asignatura, asig.descripcion, n.orden, n.descripcion_corta, daa.num_estudiantes,pl.descripcion_corta, pl.id_paralelo, pao.id_reglamento,
         co.codigo, daa.id_docente_asignatura_aprend, aa.id_asignatura_aprendizaje, pao.id_periodo_academico, m.id_oferta_modalidad, ofa.facultad, ofa.carrera

select * from seg.usuarios where usuario ='0925652190'
select * from man.personas where personas.identificacion ='0925652190'

--director de carrera
--     0911009819
--    {bcrypt}$2a$10$QBmAnqq/YmZmipmTrchQouo.wvDLs0NyUhkM1yNUKhMRgSq6G60x2
-- {MD5}b81058de7584b6b201f9573dfcdcc3a4
select * from seg.usuarios where usuario='0911009819'
select concat('{MD5}',Bd_Academico.[dbo].[fn_Md5]('0911009819'))
select id_periodo_academico,id_periodo_academico_siguiente,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 2


select identificacion,apellidos,nombres,id_estado_civil,fecha_nace,id_pais_nacionalidad,id_provincia_nacionalidad,id_canton_nacionalidad,id_parroquia_nacionalidad,defuncion from man.personas where identificacion
in ('1043585677','gl227930'
   )


select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta =1
--saber jornada y paralelo de los manes de segunda vez
begin
    declare @id_periodo_academico int = 126
    select distinct pa.codigo,p.identificacion,p.apellidos,p.nombres,eo.numero_matricula,om.id_oferta_modalidad,om.facultad,om.carrera,ea.codigo_estado_matricula,
         (select top (1) par.orden as paralelo
         from aca.matricula_general mg
                  inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
                  inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
                  inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
                  inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
                  inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
                  inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
                  inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
         where   mg.id_periodo_academico = @id_periodo_academico and eo1.id_estudiante_oferta = eo.id_estudiante_oferta
           and eo1.estado='A' and em1.estado='A' and ea.estado='A'
           and mg.estado='A'   and aa.estado='A'
           and ma.estado='A' and niv.estado='A'
         group by em1.id_estudiante_matricula,niv.descripcion_corta ,niv.ORDEN,par.descripcion_corta,par.orden
         order by  count (ea.id_asignatura_aprendizaje) desc,count (par.descripcion_corta) desc) as PARALELO

        ,om.modalidad, --isnull(aula.jornada ,'DIURNA') as jornada
         isnull((
            select top 1 tjl.descripcion
            from aca.horario_academico h
            inner join aca.tipo_horario_jornada_lab thj on thj.id_tipo_horario_jornada_lab = h.id_tipo_horario_jornada_lab
            inner join aca.tipo_jornada_laboral tjl on thj.id_tipo_jornada_laboral = tjl.id_tipo_jornada_laboral
            where  h.estado='A' and h.id_paralelo = ea.id_paralelo and h.id_periodo_academico =mg.id_periodo_academico and h.id_malla_asignatura = aa.id_malla_asignatura
            group by tjl.descripcion
            order by  count (tjl.descripcion) desc
        ),'DIURNA') as horario
    from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join man.tipo_identificacion te on te.id_tipo_identificacion = p.id_tipo_identificacion
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
    inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
    inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
    inner join aca.tipo_matricula tm on em.id_tipo_matricula = tm.id_tipo_matricula
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
--     left join
--         (select h.id_malla_asignatura,h.id_paralelo,h.id_periodo_academico,h.id_tipo_horario_jornada_lab,tjl.descripcion as jornada,
--                       ROW_NUMBER() OVER (PARTITION BY h.id_malla_asignatura,h.id_paralelo,tjl.descripcion ORDER BY count (tjl.descripcion) DESC) AS rn from aca.horario_academico h
--                inner join aca.tipo_horario_jornada_lab thj on thj.id_tipo_horario_jornada_lab = h.id_tipo_horario_jornada_lab
--                inner join aca.tipo_jornada_laboral tjl on thj.id_tipo_jornada_laboral = tjl.id_tipo_jornada_laboral
--                where  h.estado='A'
--                group by  h.id_malla_asignatura,h.id_paralelo,h.id_periodo_academico,h.id_tipo_horario_jornada_lab,tjl.descripcion) as aula on aula.id_malla_asignatura=aa.id_malla_asignatura
--         and aula.id_paralelo = ea.id_paralelo and aula.id_periodo_academico =mg.id_periodo_academico and aula.rn =1
    where p.estado='AC' and eo.estado='A' and em.estado = 'A' and ea.codigo_estado_matricula='SEG'
    and  mg.id_periodo_academico in (@id_periodo_academico)
    group by pa.codigo,te.descripcion,p.id,p.identificacion,p.apellidos,p.nombres,eo.mantiene_gratuidad,eo.id_estudiante_oferta, eo.numero_matricula, om.facultad, om.carrera ,
             om.modalidad, ea.codigo_estado_matricula,aa.id_malla_asignatura,ea.id_paralelo,mg.id_periodo_academico, om.id_oferta_modalidad
    order by om.facultad,om.carrera
end


select * from aca.periodo_academico where id_tipo_oferta = 5

--ver las jornadas disponibles de las carreras
select  d.nombre as facultad,ofe.descripcion,mo.descripcion,p.id_paralelo,p.descripcion as paralelo,tjl1.id_tipo_jornada_laboral as idJornada,tjl1.descripcion as jornada,om.id_oferta_modalidad
from  aca.horario_academico h1
          inner join aca.paralelo p on h1.id_paralelo=p.id_paralelo
          inner join aca.tipo_horario_jornada_lab thj1 on thj1.id_tipo_horario_jornada_lab = h1.id_tipo_horario_jornada_lab
          inner join aca.tipo_jornada_laboral tjl1 on tjl1.id_tipo_jornada_laboral = thj1.id_tipo_jornada_laboral
          inner join aca.dia dia1 on dia1.id_dia = h1.id_dia
          inner join aca.malla_asignatura ma on h1.id_malla_asignatura = ma.id_malla_asignatura
          inner join aca.malla m on m.id_malla = ma.id_malla
          inner join aca.oferta_modalidad om on m.id_oferta_modalidad=om.id_oferta_modalidad
          inner join aca.oferta ofe on om.id_oferta=ofe.id_oferta
          inner join aca.departamento_oferta do on ofe.id_oferta = do.id_oferta
          inner join man.departamentos d on do.id_departamento = d.id
          inner join aca.asignatura a on ma.id_asignatura=a.id_asignatura and a.estado='A'
          inner join aca.modalidad mo on om.id_modalidad = mo.id_modalidad
where h1.id_periodo_academico=127 --and om.id_oferta_modalidad= 48
  and h1.estado='A' and do.estado='A' and d.estado='AC'
group by d.nombre,ofe.descripcion,om.id_oferta_modalidad, mo.descripcion,p.id_paralelo,p.descripcion,tjl1.id_tipo_jornada_laboral,tjl1.descripcion


--REPORTE DE PARALELOS POR JORNADA
select distinct d.nombre as facultad,ofe.descripcion,mo.descripcion,om.id_oferta_modalidad,ma.id_nivel as semestre,a.descripcion as asignatura,p.id_paralelo,p.descripcion as paralelo,
                (   select top 1 d.jornada from (
                            select hac.id_malla_asignatura,p1.id_paralelo,p1.descripcion as paralelo,tjl1.id_tipo_jornada_laboral as idJornada,tjl1.descripcion as jornada,
                            datediff(hour,hac.hora_inicio,hac.hora_fin) as hora from aca.horario_academico hac
                            inner join aca.tipo_horario_jornada_lab thj1 on thj1.id_tipo_horario_jornada_lab = hac.id_tipo_horario_jornada_lab
                            inner join aca.tipo_jornada_laboral tjl1 on tjl1.id_tipo_jornada_laboral = thj1.id_tipo_jornada_laboral
                            inner join aca.dia dia on dia.id_dia = hac.id_dia
                            inner join aca.paralelo p1 on hac.id_paralelo=p1.id_paralelo
                            where   hac.estado='A' and hac.id_malla_asignatura = ma.id_malla_asignatura and hac.id_paralelo = p.id_paralelo and hac.id_periodo_academico = 15
                            group by hac.id_malla_asignatura,p1.id_paralelo,p1.descripcion,tjl1.id_tipo_jornada_laboral,tjl1.descripcion,hac.hora_inicio,hac.hora_fin
                    ) as d
                    order by d.id_malla_asignatura,d.hora desc
                ) as jornada
--
from aca.horario_academico h1
         inner join aca.paralelo p on h1.id_paralelo=p.id_paralelo
         inner join aca.malla_asignatura ma on h1.id_malla_asignatura = ma.id_malla_asignatura
         inner join aca.malla m on m.id_malla = ma.id_malla
         inner join aca.oferta_modalidad om on m.id_oferta_modalidad=om.id_oferta_modalidad
         inner join aca.oferta ofe on om.id_oferta=ofe.id_oferta
         inner join aca.departamento_oferta do on ofe.id_oferta = do.id_oferta
         inner join man.departamentos d on do.id_departamento = d.id
         inner join aca.asignatura a on ma.id_asignatura=a.id_asignatura and a.estado='A'
         inner join aca.modalidad mo on om.id_modalidad = mo.id_modalidad
where h1.id_periodo_academico=138 --and om.id_oferta_modalidad= 48
  and h1.estado='A' and do.estado='A' and d.estado='AC'
group by d.nombre,ofe.descripcion,om.id_oferta_modalidad, mo.descripcion,p.id_paralelo,p.descripcion,ma.id_malla_asignatura,a.descripcion,ma.id_nivel
order by d.nombre,ofe.descripcion,ma.id_nivel,a.descripcion,p.id_paralelo

--ver quien falta de llenar horarios
select ofe.descripcion oferta ,om.id_oferta_modalidad, a.descripcion as asignatura, CASE WHEN  per.apellidos IS NOT NULL THEN concat(per.apellidos,' ',per.nombres) ELSE 'NO DEFINIDO'END  as docente,concat (n.descripcion_corta,'/', p.descripcion_corta) as nivel
     ,isnull(di.descripcion,'') as dia, isnull(h1.hora_inicio,'') as hora_inicio, isnull(h1.hora_fin,'') hora_fin,isnull (tjl1.descripcion,'') as jornada
from aca.periodo_academico_oferta pao
         inner join aca.distributivo_oferta do on pao.id_periodo_academico_oferta=do.id_periodo_academico_oferta
         inner join aca.distributivo_docente dd on do.id_distributivo_oferta=dd.id_distributivo_oferta
         inner join aca.docente_asignatura_aprend daa on dd.id_distributivo_docente=daa.id_distributivo_docente
         inner join aca.asignatura_aprendizaje aa on daa.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
         inner join aca.docente d on dd.id_docente=d.id_docente
         inner join man.personas per on d.id_persona=per.id
         inner join aca.malla_asignatura ma on ma.id_malla_asignatura=aa.id_malla_asignatura
         inner join aca.asignatura a on ma.id_asignatura=a.id_asignatura
         inner join aca.paralelo p on daa.id_paralelo=p.id_paralelo
         inner join aca.nivel n on n.id_nivel=ma.id_nivel
         inner join aca.malla m on m.id_malla=ma.id_malla
         inner join aca.oferta_modalidad om on m.id_oferta_modalidad=om.id_oferta_modalidad
         inner join aca.oferta ofe on om.id_oferta=ofe.id_oferta
         left join aca.horario_academico h1 on h1.id_malla_asignatura = ma.id_malla_asignatura
    and h1.id_paralelo=daa.id_paralelo and h1.id_periodo_academico=138 and h1.estado='A'
         left join aca.dia di on h1.id_dia=di.id_dia
         left join aca.tipo_horario_jornada_lab thj1 on thj1.id_tipo_horario_jornada_lab = h1.id_tipo_horario_jornada_lab
         left join aca.tipo_jornada_laboral tjl1 on tjl1.id_tipo_jornada_laboral = thj1.id_tipo_jornada_laboral
where pao.estado='A' and do.estado='A' and dd.estado='A' and daa.estado='A'  and pao.id_periodo_academico=136
  and aa.estado='A' and  ma.id_nivel=11 and d.estado='A' and pER.estado='AC'

--incativar cupos por perdida de gratuidad en otra institucion
-- insert into aca.matricula_rubro
select distinct --eo.*,aux.id_estudiante_matricula,pg.identificacion,pg.carrera
    pa.codigo,om.facultad,om.carrera, eo.id_estudiante_oferta,p.id as id_persona,p.identificacion,
       p.nombres,p.apellidos,eo.id_oferta_modalidad, eo.mantiene_gratuidad as mantiene_gratuidad,
       aux.id_estudiante_matricula,pg.identificacion,pg.carrera
--     aux.id_estudiante_matricula,6,200,'S/N','A',0,getdate(),getdate(),p.identificacion,p.identificacion
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.periodo_academico pa on pa.id_periodo_academico =  eo.id_periodo_academico
         inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    left join ( select em.id_estudiante_matricula,em.id_estudiante_oferta,ea.id_paralelo from aca.estudiante_matricula em
    inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
    inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
                                              where em.estado='A' and ea.estado='A' and mg.id_periodo_academico= 127
                                              group by em.id_estudiante_matricula,em.id_estudiante_oferta,ea.id_paralelo) as aux on aux.id_estudiante_oferta = eo.id_estudiante_oferta
    left join tmp.perdida_gratuidad_2025_2 pg on pg.identificacion = p.identificacion and pg.carrera =om.carrera and pa.codigo<>'2025-2'

where  --p.identificacion in ('0927943738') --and em.estado ='A' and pa.estado='A'
   eo.estado='A' and tee.codigo='ACT' and om.id_tipo_oferta = 1-- and pa.codigo='2025-2' and pg.identificacion is not null
and pg.identificacion is not null and p.identificacion not in (
    select pg1.identificacion
    from man.personas p1
    inner join aca.estudiante_oferta eo1 on eo1.id_persona = p1.id
    inner join aca.periodo_academico pa1 on pa1.id_periodo_academico =  eo1.id_periodo_academico
    inner join aca.ofertas_facultad om1 on om1.id_oferta_modalidad = eo1.id_oferta_modalidad
    inner join tmp.perdida_gratuidad_2025_2 pg1 on pg1.identificacion = p1.identificacion and pg1.carrera =om1.carrera and pa1.codigo='2025-2'
    where eo1.estado='A' and pa1.codigo='2025-2'
    )

select * from aca.matricula_rubro where id_estudiante_matricula= 182671

--   and pa.id_periodo_academico = 3

select pg.*,aux.identificacion,aux.carrera from tmp.perdida_gratuidad_2025_2 pg
left join (select p.identificacion,p.nombres,p.apellidos,om.carrera,pa.codigo from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.periodo_academico pa on pa.id_periodo_academico =  eo.id_periodo_academico
         inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    where eo.estado='A' and pa.codigo='2025-2') as aux on aux.identificacion =pg.identificacion and aux.carrera=pg.carrera

select pg.* from tmp.perdida_gratuidad_2025_2 pg

begin
    declare @id_periodo_academico int = 127
    select p.id
         , pa.codigo
         , do.id_departamento_oferta
         ,  ofr.descripcion                as oferta
         , rofg.idOfertaModalidadPregrado as idOfertaModalidadPregrado
         , ofr2.descripcion               as oferta2
         , p.nombres
         , p.apellidos
         , em.id_estudiante_matricula
         , eo.id_persona
         , p.identificacion
         , pp.descripcion                 as PARALELO
         , EA.codigo_estado_matricula
         , em.fecha_ingreso
    from aca.matricula_general mg
             inner join aca.estudiante_matricula em
                        on em.id_matricula_general = mg.id_matricula_general
             inner join aca.estudiante_asignatura ea
                        on em.id_estudiante_matricula = ea.id_estudiante_matricula
             inner join aca.paralelo pp on pp.id_paralelo = ea.id_paralelo
             inner join aca.estudiante_oferta eo
                        on em.id_estudiante_oferta = eo.id_estudiante_oferta
             inner join man.personas p on p.id = eo.id_persona
             inner join aca.oferta_modalidad om
                        on om.id_oferta_modalidad = eo.id_oferta_modalidad
             left join rel.fn_relaciones_ofertas_nivelacion_grado(@id_periodo_academico) rofg
                       on rofg.idOfertaModalidadNivelacion = om.id_oferta_modalidad
             left join aca.oferta_modalidad om2
                       on om2.id_oferta_modalidad = rofg.idOfertaModalidadPregrado
             inner join aca.oferta ofr2 on ofr2.id_oferta = om2.id_oferta
             inner join aca.oferta ofr on ofr.id_oferta = om.id_oferta
             inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
             inner join aca.periodo_academico pa
                        on pa.id_periodo_academico = mg.id_periodo_academico
             inner join man.departamentos d on d.id = do.id_departamento
    where mg.id_periodo_academico = @id_periodo_academico
      and eo.estado = 'A'
      and em.estado = 'A'
      and ea.codigo_estado_matricula = 'PRI'
      and mg.estado = 'A'
      and om.estado = 'A'
      and do.estado = 'A'
      and pa.estado = 'A'
      and ea.estado = 'A' --and p.nombres like '%angel%'
    group by p.id, pa.codigo, do.id_departamento_oferta, ofr.descripcion
           , ofr2.descripcion, rofg.idOfertaModalidadPregrado, p.nombres, p.apellidos
           , em.id_estudiante_matricula, eo.id_persona, p.identificacion
           , pp.descripcion, EA.codigo_estado_matricula, em.fecha_ingreso) mat
    on mat.id_persona = ca.id_persona and
        mat.idOfertaModalidadPregrado = ca.id_oferta_modalidad
    end

select * from aca.periodo_academico where id_tipo_oferta =1
select * from dbo.persona_nivelacion

 exec   aca.sp_matricula_libro_estudiante 126,5,null
--3543
--libro de matricula de nivelacion y ver si son gays
begin
--     declare @pi_id_periodo_academico int = 127
    select * from (
    select pa.codigo as periodo,dep.nombre as facultad,
           o.descripcion as oferta, m.descripcion as modalidad, omo.id_oferta_modalidad ,
           p.identificacion,p.nombres,p.apellidos,isnull(p.email_institucional,'') as email_institucional,
           isnull(p.email_personal,'') as email_personal,p.fecha_nace,isnull(p.sexo,'') as sexo,
           isnull(ec.descripcion,'')as estado_civil,isnull(n.descripcion ,'')as nacionalidad,
           isnull(provNac.descripcion,'') as prov_nac,isnull(cantNac.descripcion,'') as canton_nac,
           isnull (parrNac.descripcion,'') as parr_nac,isnull(paisNac.descripcion,'') as pais_origen,
           isnull(provRes.descripcion,'') as prov_reside,isnull(cantRes.descripcion,'') as canton_reside,
           isnull(parrRes.descripcion,'') as parr_reside,isnull(p.barrio,'') as barrio,isnull(p.direccion,'') as direccion,
           isnull(p.telefono,'')as telefono,isnull(p.celular,'') as celular,
           isnull(p.email_institucional,'') as email_inst,eo.numero_matricula,
           em.fecha_ingreso as fecha_matricula,
           (select [aca].[fn_semestre_activo_estudiante](eo.id_estudiante_oferta,mg.id_periodo_academico)) as denominacion,
           11 AS id_nivel,em.promedio as calificacion,
           isnull((STUFF((select char(10)+ isNULL(ta.descripcion,iap.otro_titulo)
                          from man.informacion_academica_persona iap
                                   left join aca.institucion ins on ins.id_institucion=iap.id_institucion and ins.estado='A'
                                   left join aca.titulos_academicos ta on ta.id_titulo_academico=iap.id_titulo_academico and ta.estado='A'
                                   left join aca.nivel_formacion nf on ta.id_nivel_formacion=nf.id_nivel_formacion and nf.estado='A'
                          where   iap.id_persona=p.id and iap.estado='A'
                          for xml path ('')),1,1,'')),'NO REGISTRA') as titulo_academico ,
           isNULL( (STUFF((select char(10)+ isnull(ins.descripcion,iap.otra_institucion)
                           from man.informacion_academica_persona iap
                                    left join aca.institucion ins on ins.id_institucion=iap.id_institucion and ins.estado='A'
                                    left join aca.titulos_academicos ta on ta.id_titulo_academico=iap.id_titulo_academico and ta.estado='A'
                                    left join aca.nivel_formacion nf on ta.id_nivel_formacion=nf.id_nivel_formacion and nf.estado='A'  and nf.id_nivel_formacion =2
                           where   iap.id_persona=p.id and iap.estado='A'

                           for xml path ('')),1,1,'')),'NO REGISTRA') as COLEGIO ,
           isNULL( (STUFF((select char(10)+ isnull(tin.descripcion,'NO REGISTRA')
                           from man.informacion_academica_persona iap
                                    left join aca.institucion ins on ins.id_institucion=iap.id_institucion and ins.estado='A'
                                    left join aca.tipo_institucion tin on ins.id_tipo_institucion = tin.id_tipo_institucion
                                    left join aca.nivel_formacion nf on iap.id_nivel_formacion=nf.id_nivel_formacion and nf.estado='A'  and nf.id_nivel_formacion =2
                           where   iap.id_persona=p.id and iap.estado='A'
                           for xml path ('')),1,1,'')),'NO REGISTRA') as TIPO_COLEGIO ,
           ISNULL(et.descripcion,'') as etnia,
           isnull(p.porcentaje_dis, 0)as discapacidad,
           case  when p.num_carnet_conadis is not null then concat(isnull(dis.descripcion, ''), ' ',cast(isnull(p.num_carnet_conadis,'') as varchar(20)))
                 else isnull(p.num_carnet_conadis,'') end
               as num_carnet_conadis,tm.descripcion as tipo_matricula, tm.codigo as codigo_tipo_matricula,
           case when (select MIN(ea.codigo_estado_matricula) from  aca.estudiante_asignatura ea
                      where ea.id_estudiante_matricula=em.id_estudiante_matricula and ea.estado='A')='PRI' THEN '1 VEZ'
                WHEN (select MIN(ea.codigo_estado_matricula) from  aca.estudiante_asignatura ea
                      where ea.id_estudiante_matricula=em.id_estudiante_matricula and ea.estado='A')='SEG' THEN '2 VEZ' ELSE '' END numVez
    from aca.matricula_general mg
             inner join aca.estudiante_matricula em on em.id_matricula_general = mg.id_matricula_general
             inner join aca.tipo_matricula tm on em.id_tipo_matricula=tm.id_tipo_matricula
             inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
             inner join aca.oferta_modalidad omo on eo.id_oferta_modalidad=omo.id_oferta_modalidad
             inner join aca.modalidad m on omo.id_modalidad=m.id_modalidad
             inner join aca.oferta o on omo.id_oferta=o.id_oferta
             inner join aca.departamento_oferta dof on dof.id_oferta=o.id_oferta
             inner join man.departamentos dep on  dof.id_departamento=dep.id
             inner join man.personas p on eo.id_persona=p.id
             inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
             inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
             inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
             inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
             left join man.estado_civil ec on p.id_estado_civil=ec.id_estado_civil  and ec.estado='A'
             left join man.nacionalidad n on p.id_nacionalidad =n.id_nacionalidad and n.estado='A'
             left join man.lugar provRes on  p.id_provincia_residencia=provRes.id_lugar and provRes.estado='A'
             left join man.lugar cantRes on  p.id_canton_residencia=cantRes.id_lugar and cantRes.estado='A'
             left join man.lugar parrRes on p.id_parroquia_residencia=parrRes.id_lugar  and parrRes.estado='A'
             left join man.lugar provNac on  p.id_provincia_nacionalidad=provNac.id_lugar  and provNac.estado='A'
             left join man.lugar cantNac on  p.id_canton_nacionalidad=cantNac.id_lugar and cantNac.estado='A'
             left join man.lugar parrNac on p.id_parroquia_nacionalidad=parrNac.id_lugar  and parrNac.estado='A'
             left join man.lugar paisNac on p.id_pais_nacionalidad=paisNac.id_lugar    and paisNac.estado='A'
             LEFT join man.discapacidad dis on p.id_discapacidad=dis.id_discapacidad -- and dis.estado='A'
             left join man.etnia et on et.id_etnia=p.id_etnia and et.estado='A'
    where mg.id_periodo_academico in (138,126,127,37,38)
--         mg.id_periodo_academico =@pi_id_periodo_academico
      and eo.estado='A' and em.estado='A' and ea.estado='A' --and niv.id_nivel>1
      and mg.estado='A' and omo.estado='A' 	and pa.estado='A'   and par.estado='A' and aa.estado='A'
      and ma.estado='A' and niv.estado='A'  and tm.estado='A' -- AND tm.codigo not in ('ESP')
    group by pa.codigo,p.identificacion,p.nombres,p.apellidos,p.email_institucional,p.email_personal,p.fecha_nace,p.sexo,
             ec.descripcion ,n.descripcion, provNac.descripcion ,cantNac.descripcion ,parrNac.descripcion ,paisNac.descripcion,
             provRes.descripcion, cantRes.descripcion ,parrRes.descripcion,p.barrio,p.direccion,p.telefono,p.celular,p.email_institucional,
             eo.numero_matricula, em.fecha_ingreso,et.descripcion  ,p.porcentaje_dis  ,p.num_carnet_conadis,dis.descripcion,p.id_discapacidad,
             o.descripcion, m.descripcion , omo.id_oferta_modalidad ,dep.nombre,tm.descripcion , tm.codigo,em.promedio,
             em.id_estudiante_matricula,p.id ,eo.id_estudiante_oferta,mg.id_periodo_academico,eo.vez_proyectada
    ) as d
    order by d.periodo,d.facultad,d.oferta,d.apellidos,d.nombres
end


begin
    select distinct d.* from (
 select distinct p.id as idPersona,p.identificacion,p.nombres,p.apellidos,tin.descripcion as tipoColegio,iap.id_informacion_academica_persona,iap.id_institucion,
                             iif(iap.id_institucion is null,iap.otra_institucion,ins.descripcion) as colegio,nf.descripcion as nivelFormacion,
                             ROW_NUMBER() OVER (PARTITION BY iap.id_institucion,iap.id_nivel_formacion,p.id ORDER BY iap.fecha_ing DESC) AS rn
--      ROW_NUMBER() OVER (PARTITION BY iap.otra_institucion,nf.id_nivel_formacion,p.id ORDER BY iap.fecha_ing DESC) AS rn
                      from aca.matricula_general mg
                               inner join aca.estudiante_matricula em on em.id_matricula_general = mg.id_matricula_general
                               inner join aca.tipo_matricula tm on em.id_tipo_matricula=tm.id_tipo_matricula
                               inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
                               inner join aca.oferta_modalidad omo on eo.id_oferta_modalidad=omo.id_oferta_modalidad
                               inner join aca.modalidad m on omo.id_modalidad=m.id_modalidad
                               inner join aca.oferta o on omo.id_oferta=o.id_oferta
                               inner join aca.departamento_oferta dof on dof.id_oferta=o.id_oferta
                               inner join man.departamentos dep on  dof.id_departamento=dep.id
                               inner join man.personas p on eo.id_persona=p.id
                               inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
                               inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
                               inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
                               inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
                               inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
                               inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
                                inner join man.informacion_academica_persona iap on iap.id_persona=p.id
                               inner join aca.institucion ins on ins.id_institucion=iap.id_institucion and ins.estado='A'
                               inner join aca.titulos_academicos ta on ta.id_titulo_academico=iap.id_titulo_academico and ta.estado='A'
                               inner join aca.nivel_formacion nf on ta.id_nivel_formacion=nf.id_nivel_formacion and nf.estado='A'
                                left join aca.tipo_institucion tin on ins.id_tipo_institucion = tin.id_tipo_institucion and tin.estado='A'
                      where mg.id_periodo_academico in (138,126,127,37,38) and p.identificacion='1729983500'
--         mg.id_periodo_academico =@pi_id_periodo_academico
                        and eo.estado='A' and em.estado='A' and ea.estado='A' and iap.estado='A' --and nf.id_nivel_formacion =2
                        and mg.estado='A' and omo.estado='A' 	and pa.estado='A'   and par.estado='A' and aa.estado='A'
                        and ma.estado='A' and niv.estado='A'  and tm.estado='A' -- AND tm.codigo not in ('ESP')
      group by p.identificacion,p.nombres,p.apellidos,p.id ,eo.id_estudiante_oferta,mg.id_periodo_academico,eo.vez_proyectada, tin.descripcion, iap.id_informacion_academica_persona,nf.descripcion,
               iap.id_institucion, ins.descripcion, iap.otra_institucion,iap.id_nivel_formacion,iap.fecha_ing
               ,nf.id_nivel_formacion) as d
             inner join man.informacion_academica_persona iap on iap.id_informacion_academica_persona = d.id_informacion_academica_persona
--     where d.rn=1

end

select * from aca.nivel_formacion
--saber que rayos hizo joelito

select * from niv.pre_inscripcion
where id_persona = 96148


select * from niv.inscripcion_nivelacion where id_persona = 96148
select * from niv.inscripcion_postulacion

select * from niv.oferta_postulacion

select * from rlx.actividad_internacional

select * from pro.tipo_proceso_estado

select *
from niv.inscripcion_proceso_etapa where id_inscripcion_nivelacion = 46935

select * from pro.proceso_usuario

select e.descripcion,pe.* from pro.proceso_etapa pe
                                   inner join pro.etapa e on pe.id_etapa = e.id_etapa
where pe.id_proceso_etapa in (27,133,36)

select e.descripcion,e.codigo,pe.* from pro.proceso_etapa pe
                                   inner join pro.etapa e on pe.id_etapa = e.id_etapa
where pe.id_proceso = 7

select * from pro.proceso_general where id_proceso = 7

select u.* from seg.usuario_opcion u
                    left join seg.usuarios us on u.id_usuario = us.id
where us.persona_id = 96148

select * from seg.usuarios
where persona_id = 96148

select * from man.opciones where nombre='Procesos de Admisión'

select * from niv.estado_cupo

select * from niv.estado_upse

select * from niv.nivelacion_cupos

select * from niv.temp_persona

select * from niv.calificaciones_nivelacion

select * from aca.aspirantes_pregrado

-- exec fnc_pre_inscripcion_nivelacion

select * from persona_nivelacion where identificacion='2400255325'

select * from niv.pre_inscripcion

select * from aca.inscripcion

select * from niv.inscripcion_nivelacion

select * from niv.asignacion_orden_accion_ff

select * from niv.cupos_activos

select * from niv.inscripcion_postulacion

select * from niv.estado_postulacion

select * from  niv.inscripcion_admision

select * from seg.usuario_opcion uo
inner join seg.usuarios u on uo.id_usuario = u.id
where u.usuario ='2400088411'

select * from seg.usuarios u
where u.usuario  in ('2400088411','0918672643')

select * from man.opciones where nombre like '%estados académicos%'

select * from man.opciones where id =856