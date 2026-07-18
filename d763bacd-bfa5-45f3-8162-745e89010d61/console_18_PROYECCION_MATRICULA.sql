use bd_sga_upse;


--NUMERO_ESTUDIANTES_POR_CARRERA_SEMESTRE_ASIGNATURA
select d.facultad,d.carrera,d.id_oferta_modalidad,d.semestre,d.orden,id_nivel,d.id_asignatura as id_asignatura,d.asignatura as asignatura,count(d.id_estudiante_matricula) as num,avg(d.promedio)
from  aca.fn_get_cantidad_matriculados_por_oferta (null,null,35) as d
-- where d.id_nivel =@pi_id_nivel or @pi_id_nivel is null
group by d.semestre,d.orden,
         d.facultad,d.carrera,id_nivel,d.id_oferta_modalidad,d.id_asignatura,d.asignatura
order by d.carrera, d.orden asc

select id_periodo_academico,codigo,descripcion,codigo_tipo_periodo from aca.periodo_academico where id_tipo_oferta =2
order by codigo


select d.* from [aca].[fn_get_list_promedio_asignaturas_carrera](95,null,13)as d


select * from aca.oferta_asignatura_resultados



select * from aca.fn_calculo_de_numero_de_estudiantes_a_matricular (1,1)

select * from tmp.matricula_proyeccion where cast(fecha_mod as date)>='2026-02-24'

-- delete from tmp.matricula_proyeccion where cast(fecha_mod as date)>='2026-02-24'

exec [tmp].[sp_generar_pronostico_matriculados_siguiente_periodo_v2] 96, null, null,null

SELECT * FROM rep.fn_get_cantidad_matriculados_porcentajes_inline(136,NULL,NULL)
ORDER BY facultad,carrera,id_nivel;

select *

SELECT * FROM tmp.matricula_proyeccion where id_periodo_academico = 96

update  tmp.matricula_proyeccion set codigo_periodo='2025-2' where id_periodo_academico = 96

-- SELECT * FROM tmp.matricula_proyeccion WITH (NOLOCK)

select dep.nombre as facultad, o.descripcion as carrera,om.id_oferta_modalidad,asi.id_asignatura,m.id_malla, ma.id_malla_asignatura,ni.id_nivel as semestre, asi.descripcion as asignatura
from aca.malla m
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = m.id_oferta_modalidad
         inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
         inner join man.departamentos dep on dep.id = do.id_departamento
         inner join aca.oferta o on o.id_oferta = do.id_oferta
         inner join aca.malla_asignatura ma on ma.id_malla = m.id_malla
         inner join aca.asignatura asi on ma.id_asignatura = asi.id_asignatura
         inner join aca.nivel ni on ni.id_nivel = ma.id_nivel
         inner join aca.periodo_academico_oferta pao on om.id_oferta_modalidad = pao.id_oferta_modalidad
         left join tmp.matricula_proyeccion mp on mp.id_malla_asignatura = ma.id_malla_asignatura and mp.id_periodo_academico = pao.id_periodo_academico
where pao.id_periodo_academico = 95 and m.vigente = 1 --and mp.id is null
--           and om.id_oferta_modalidad = 80
  and ma.id_nivel <= m.id_nivel_max_aperturado
--   and (om.id_oferta_modalidad = @id_oferta_modalidad or @id_oferta_modalidad is null)
--   and (dep.id =@id_facultad or @id_facultad is null)
--   and (ma.id_nivel = @id_nivel or @id_nivel is null)
  and ma.estado in ('A', 'P') and om.estado = 'A' and do.estado = 'A' and o.estado = 'A' and ma.estado = 'A' and asi.estado = 'A' and ni.estado = 'A'
group by asi.id_asignatura, asi.descripcion, ni.descripcion, ni.orden, dep.nombre, o.descripcion,ma.id_malla_asignatura, om.id_oferta_modalidad, ni.id_nivel, m.id_malla
order by dep.nombre, o.descripcion, ni.orden, asi.descripcion
--     fn_get_cantidad_matriculados_porcentajes_docente
--     fn_get_cantidad_matriculados_porcentajes
select pm.*
-- update pm set pm.pronostico_1_aprobados_menos_reprobados = pm.pronostico_3_matriculados_historicos
-- update pm set pm.pronostico_1_aprobados_menos_reprobados = (select avg(mp.matriculados_actuales) from tmp.matricula_proyeccion mp where mp.id_oferta_modalidad=pm.id_oferta_modalidad and mp.id_periodo_academico = 95
--                                                                                                                                     and mp.id_nivel=(pm.id_nivel-1) )
from  tmp.matricula_proyeccion pm
where pm.id_periodo_academico = 95 and pm.fecha_mod is not null --and pm.pronostico_1_aprobados_menos_reprobados =0
-- and pm.pronostico_1_aprobados_menos_reprobados=0 and pm.pronostico_3_matriculados_historicos >0

select mp.carrera,mp.id_nivel,avg(mp.matriculados_actuales)from tmp.matricula_proyeccion mp where mp.id_periodo_academico = 95
group by mp.carrera, mp.id_nivel

select * from  tmp.matricula_proyeccion pm
-- VALUES (@id_periodo_academico_siguiente,'2024-2',@facultad_cur, @carrera_cur, @id_oferta_modalidad_cur, @id_asignatura_cur, @id_malla_cur,@id_malla_asignatura_cur,@semestre_cur,
--         @numeroPrerrequisitos,@numero_periodos, @asignatura_cur,@detalle_prerrequisitos,@detalle_periodos,
--         @observacion_detalle,@matriculadosPeriodoActual,@estimados_1er,@estimados_2do,@estimados_3ro)



--reporte de numero de paralelos por materia y carrera, con modalidad
WITH CursosConParalelos AS (
        SELECT
            id_malla_asignatura, codigo_periodo, facultad,carrera,nivel,asignatura,detalle_prerrequisitos,observacion,modalidad,horas,pronostico,
            CASE WHEN modalidad = 'ONLINE' THEN
                    CASE WHEN pronostico <= 77 THEN 1 ELSE CEILING(pronostico / 70.0) END
                ELSE CEILING(pronostico / 50.0)
                END AS numero_paralelos
        FROM (
                 SELECT pm.id_malla_asignatura, pm.codigo_periodo,pm.facultad,pm.carrera, pm.id_nivel as nivel,pm.asignatura,pm.detalle_prerrequisitos,
                     pm.observacion, ma2.codigo AS modalidad,(select sum(aa.valor) from aca.asignatura_aprendizaje aa
                                                       inner join aca.componente_aprendizaje ca on aa.id_componente_aprendizaje = ca.id_componente_aprendizaje
                                                       where aa.id_malla_asignatura= pm.id_malla_asignatura and aa.estado='A'
                                                       and ca.codigo in ('DOCENCIA','PRACTICA','ASISTIDODOCENTE','SINCRONICO','SINCRONICOP')) as horas,
                     pm.pronostico_1_aprobados_menos_reprobados AS pronostico
                 FROM tmp.matricula_proyeccion pm
                INNER JOIN aca.malla_asignatura ma ON pm.id_malla_asignatura = ma.id_malla_asignatura
                INNER JOIN aca.modalidad_asignatura ma2 ON ma.id_modalidad_asignatura = ma2.id_modalidad_asignatura
                 where pm.id_periodo_academico = 95
             ) a
    )
    SELECT * FROM CursosConParalelos
    ORDER BY id_malla_asignatura



select id_periodo_academico,codigo,descripcion,id_periodo_academico_anterior from aca.periodo_academico where id_tipo_oferta = 2

select m.* from aca.malla m
inner join aca.oferta_modalidad om on m.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
where o.id_tipo_oferta = 2 and om.id_oferta_modalidad in (123,119,124)



select pa.id_periodo_academico,pa.codigo,dep.nombre as facultad,o.descripcion as carrera,om.id_oferta_modalidad
from aca.malla ma
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = ma.id_oferta_modalidad
inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
inner join man.departamentos dep on dep.id = do.id_departamento
inner join aca.oferta o on o.id_oferta = do.id_oferta
inner join aca.malla_asignatura mas on ma.id_malla = mas.id_malla
inner join aca.asignatura asi on mas.id_asignatura = asi.id_asignatura
inner join aca.nivel ni  on ni.id_nivel = mas.id_nivel
inner join aca.planificacion_paralelo pp on pp.id_malla_asignatura=mas.id_malla_asignatura
and pp.ofertada=1 and pp.estado='A'
inner join aca.periodo_academico pa on pa.id_periodo_academico = pp.id_periodo_academico

where pp.id_periodo_academico =35
and ma.estado in ('A','P') and om.estado='A' and do.estado='A' and pa.estado='A' and pa.codigo_tipo_periodo ='PAORD'
and o.estado='A' and mas.estado='A' and asi.estado='A' and ni.estado='A'
group by dep.nombre,o.descripcion,om.id_oferta_modalidad,pa.id_periodo_academico,pa.codigo
order by dep.nombre,o.descripcion



select * from tmp.matricula_proyeccion




select d.periodoAcademico,d.facultad,d.carrera,d.orden as semestre,d.idParalelo as paralelo,d.asignatura,d.nombreDocente,d.numMatriculados from [rep].[rpt_matriz_aprobacion_estudiantes](36,null,null) as d
order by d.facultad,d.carrera,d.orden,d.asignatura,d.idParalelo

select d.facultad,d.carrera,d.numReprobados,d.porcentajeReprobados,d.asignatura,concat(d.orden,'/',d.idParalelo) as curso_paralelo,d.nombreDocente,d.numMatriculados,'2024-1' as PAO,'S/N' as  accionesMejorar
   from [rep].[rpt_matriz_aprobacion_estudiantes](35,null,119) as d


select * from aca.periodo_academico where id_tipo_oferta = 2
--aprobados_reprobados_periodo
select d.codigo as periodo,d.facultad,d.carrera,d.orden as semestre,d.asignatura,d.numero_matriculados,
d.numero_aprobados,d.numero_reprobados,d.porcentaje_reprobados from [rep].[fn_get_cantidad_matriculados_porcentajes](27,null,null,null) as d
-- where d.id_oferta_modalidad in (119,95)

--948
select ddd.id_asignatura,ddd.asignatura,avg(ddd.porcentaje_reprobados) as repitencia from (select *
               from [rep].[fn_get_cantidad_matriculados_porcentajes](36, null, 89, null) as d
               union all
               select *
               from [rep].[fn_get_cantidad_matriculados_porcentajes](95, null, 38, null) as d) as ddd
group by ddd.id_asignatura,ddd.asignatura

select d.codigo,d.facultad,d.carrera,d.id_asignatura,d.asignatura,avg(d.porcentaje_reprobados) as repitencia
from [rep].[fn_get_cantidad_matriculados_porcentajes](96, null, null, null) as d
group by d.codigo,d.facultad,d.carrera,d.id_asignatura,d.asignatura

-- where d.id_oferta_modalidad in (89)
select * from [rep].[fn_get_cantidad_matriculados_porcentajes_por_paralelo](96,null,88,null) a
select * from aca.periodo_academico where id_tipo_oferta = 2
select * from aca.ofertas_facultad where id_tipo_oferta = 2

select * from aca.ofertas_facultad where id_tipo_oferta = 2

select * from rel.fn_relaciones_ofertas_nivelacion_grado(37)
select * from aca.ciclo c

select * from aca.periodo_academico where id_tipo_oferta = 2

select --distinct pao.*
 distinct m.*
--     dep.nombre as facultad, o.descripcion as carrera,om.id_oferta_modalidad,asi.id_asignatura,m.id_malla, ma.id_malla_asignatura,ni.id_nivel as semestre, asi.descripcion as asignatura
from aca.malla m
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = m.id_oferta_modalidad
         inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
         inner join man.departamentos dep on dep.id = do.id_departamento
         inner join aca.oferta o on o.id_oferta = do.id_oferta
         inner join aca.malla_asignatura ma on ma.id_malla = m.id_malla
         inner join aca.asignatura asi on ma.id_asignatura = asi.id_asignatura
         inner join aca.nivel ni on ni.id_nivel = ma.id_nivel
         inner join aca.periodo_academico_oferta pao on om.id_oferta_modalidad = pao.id_oferta_modalidad
where pao.id_periodo_academico = 95 and m.vigente = 1
--           and om.id_oferta_modalidad = 80
  and ma.id_nivel <= m.id_nivel_max_aperturado
--   and (om.id_oferta_modalidad = @id_oferta_modalidad or @id_oferta_modalidad is null)
--   and (dep.id =@id_facultad or @id_facultad is null)
--   and (ma.id_nivel = @id_nivel or @id_nivel is null)
  and ma.estado in ('A', 'P') and om.estado = 'A' and do.estado = 'A' and o.estado = 'A' and ma.estado = 'A' and asi.estado = 'A' and ni.estado = 'A'
-- group by asi.id_asignatura, asi.descripcion, ni.descripcion, ni.orden, dep.nombre, o.descripcion,ma.id_malla_asignatura, om.id_oferta_modalidad, ni.id_nivel, m.id_malla
-- order by dep.nombre, o.descripcion, ni.orden, asi.descripcion



--NUMERO DE REPROBADOS POR SEMESTRE
begin
    declare @pi_id_periodo_academico int = 35,@pi_id_facultad int =null, @pi_id_oferta_modalidad int =null

    select dd.periodo,dd.facultad,dd.carrera,dd.semestre,count(CASE WHEN dd.numero_reprobados = 1 THEN 1 END) AS reprobados_1,
           count(CASE WHEN dd.numero_reprobados = 2 THEN 1 END) AS reprobados_2,
        count(CASE WHEN dd.numero_reprobados = 3 THEN 1 END) AS reprobados_3,
    count(CASE WHEN dd.numero_reprobados = 4 THEN 1 END) AS reprobados_4,
    count(CASE WHEN dd.numero_reprobados = 5 THEN 1 END) AS reprobados_5,
        count(CASE WHEN dd.numero_reprobados > 5 THEN 1 END) AS reprobados_mas5 from(
                    select d.id_periodo_academico,d.codigo as periodo,d.facultad,d.carrera,d.id_oferta_modalidad,d.id_estudiante_matricula,d.identificacion,d.estudiante,d.semestre,
        --                   d.orden,id_nivel, d.id_malla_asignatura,d.id_asignatura as id_asignatura,d.asignatura as asignatura
                   count(d.id_estudiante_asignatura) as numero_matriculados,
                    count(CASE WHEN Isnull(d.aprobado,0) = 1 THEN 1 END) AS numero_aprobados,
                    count(CASE WHEN Isnull(d.aprobado,0) = 0 THEN 1 END) AS numero_reprobados,iif(count(d.id_estudiante_asignatura)=0,0,
                    ((cast(count(CASE WHEN Isnull(d.aprobado,0) = 0 THEN 1 END) as decimal(5,2)))*100/count(d.id_estudiante_asignatura))) as porcentaje_reprobados from (
                    select pa.id_periodo_academico,dep.nombre as facultad,o.descripcion as carrera,om.id_oferta_modalidad,p.identificacion,concat(p.apellidos,' ',p.nombres) as estudiante,em.id_estudiante_matricula,
                           ea.id_estudiante_asignatura,ea.aprobado,
                           pa.codigo,(select top 1 ma1.id_nivel  from  aca.estudiante_asignatura ea1
                                     inner join aca.paralelo par1 on ea1.id_paralelo=par1.id_paralelo
                                     inner join aca.asignatura_aprendizaje aa1 on ea1.id_asignatura_aprendizaje=aa1.id_asignatura_aprendizaje
                                     inner join aca.malla_asignatura ma1 on aa1.id_malla_asignatura=ma1.id_malla_asignatura
                                     inner join aca.nivel niv1 on ma1.id_nivel=niv1.id_nivel
                                     where ea1.estado='A' and ea1.id_estudiante_matricula = em.id_estudiante_matricula
                                     group by ma1.id_nivel, ea1.id_estudiante_matricula
                                     order by count(ea1.id_estudiante_asignatura) desc) as semestre
        --                    asi.id_asignatura,mas.id_malla_asignatura,asi.descripcion as asignatura,ni.orden,ni.id_nivel
                    from aca.malla ma
                    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = ma.id_oferta_modalidad
                    inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
                    inner join man.departamentos dep on dep.id = do.id_departamento
                    inner join aca.oferta o on o.id_oferta = do.id_oferta
                    inner join aca.malla_asignatura mas on ma.id_malla = mas.id_malla
                    inner join aca.asignatura asi on mas.id_asignatura = asi.id_asignatura
                    inner join aca.nivel ni  on ni.id_nivel = mas.id_nivel
                    inner join aca.planificacion_paralelo pp on pp.id_malla_asignatura=mas.id_malla_asignatura
                    and pp.ofertada=1 and pp.estado='A'
                    inner join aca.asignatura_aprendizaje aap on mas.id_malla_asignatura = aap.id_malla_asignatura
                    inner join aca.estudiante_asignatura ea on ea.id_asignatura_aprendizaje = aap.id_asignatura_aprendizaje
                    inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
                    inner join aca.estudiante_matricula em on em.id_estudiante_matricula = ea.id_estudiante_matricula
                    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
                    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico and pp.id_periodo_academico = pa.id_periodo_academico
                    inner join aca.estudiante_oferta eo on em.id_estudiante_oferta=eo.id_estudiante_oferta
                    inner join man.personas p on eo.id_persona = p.id
                    where (eo.id_oferta_modalidad =@pi_id_oferta_modalidad or @pi_id_oferta_modalidad is null) and
                          aap.estado='A' AND ea.estado='A' and par.estado='A' and em.estado='A' and mg.estado='A'
                    and (dep.id =@pi_id_facultad or @pi_id_facultad is null) and mg.id_periodo_academico = @pi_id_periodo_academico
                    and ma.estado in ('A','P') and om.estado='A' and do.estado='A' and pa.estado='A' and pa.codigo_tipo_periodo ='PAORD'
                    and o.estado='A' and mas.estado='A' and asi.estado='A' and ni.estado='A'
                    group by asi.id_asignatura,asi.descripcion,ni.orden,dep.nombre,o.descripcion,em.id_estudiante_matricula,ea.id_estudiante_asignatura,ea.aprobado,pp.id_periodo_academico,
                             ea.id_paralelo,ni.descripcion_corta,ni.id_nivel,om.id_oferta_modalidad,mas.id_malla_asignatura,pa.id_periodo_academico,pa.codigo,p.identificacion,p.nombres,p.apellidos

                ) as d
            group by d.facultad,d.carrera,d.id_oferta_modalidad, d.id_periodo_academico, d.codigo, d.identificacion,d.estudiante,d.id_estudiante_matricula,d.semestre
            )as dd
    where dd.numero_reprobados>0
    group by dd.periodo,dd.carrera,dd.facultad,dd.semestre
    order by dd.facultad,dd.carrera,dd.semestre
end




---DETALLE DE ESTUDIANTES REPROBADOS
begin
    declare @pi_id_periodo_academico int = 35,@pi_id_facultad int =null, @pi_id_oferta_modalidad int =null
            select d.id_periodo_academico,d.codigo as periodo,d.facultad,d.carrera,d.id_oferta_modalidad,d.id_estudiante_matricula,d.identificacion,d.estudiante,d.semestre,
    --                   d.orden,id_nivel, d.id_malla_asignatura,d.id_asignatura as id_asignatura,d.asignatura as asignatura
               count(d.id_estudiante_asignatura) as numero_matriculados,
                count(CASE WHEN Isnull(d.aprobado,0) = 1 THEN 1 END) AS numero_aprobados,
                count(CASE WHEN Isnull(d.aprobado,0) = 0 THEN 1 END) AS numero_reprobados,
                iif(count(d.id_estudiante_asignatura)=0,0,
                   cast(((cast(count(CASE WHEN Isnull(d.aprobado,0) = 0 THEN 1 END) as decimal(5,2)))*100/count(d.id_estudiante_asignatura))as decimal(5,2))) as porcentaje_reprobados,
                   (SELECT STUFF((
                                     SELECT ', ' + concat(ma2.id_nivel, ' - ', a.descripcion)
                                     FROM aca.asignatura AS a
                                              inner join aca.malla_asignatura ma2 on a.id_asignatura = ma2.id_asignatura
                                              inner join aca.asignatura_aprendizaje aa1 on ma2.id_malla_asignatura=aa1.id_malla_asignatura
                                                inner join aca.estudiante_asignatura ea2 on aa1.id_asignatura_aprendizaje = ea2.id_asignatura_aprendizaje
                                     where ea2.id_estudiante_matricula = d.id_estudiante_matricula and ea2.estado='A'
                                     FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '')) AS materias_reprobadas from (
                select pa.id_periodo_academico,dep.nombre as facultad,o.descripcion as carrera,om.id_oferta_modalidad,p.identificacion,concat(p.apellidos,' ',p.nombres) as estudiante,em.id_estudiante_matricula,
                       ea.id_estudiante_asignatura,ea.aprobado,asi.descripcion as asignatura,ni.id_nivel,asi.id_asignatura,
                       pa.codigo,(select top 1 ma1.id_nivel  from  aca.estudiante_asignatura ea1
                                 inner join aca.paralelo par1 on ea1.id_paralelo=par1.id_paralelo
                                 inner join aca.asignatura_aprendizaje aa1 on ea1.id_asignatura_aprendizaje=aa1.id_asignatura_aprendizaje
                                 inner join aca.malla_asignatura ma1 on aa1.id_malla_asignatura=ma1.id_malla_asignatura
                                 inner join aca.nivel niv1 on ma1.id_nivel=niv1.id_nivel
                                 where ea1.estado='A' and ea1.id_estudiante_matricula = em.id_estudiante_matricula
                                 group by ma1.id_nivel, ea1.id_estudiante_matricula
                                 order by count(ea1.id_estudiante_asignatura) desc) as semestre
                from aca.malla ma
                inner join aca.oferta_modalidad om on om.id_oferta_modalidad = ma.id_oferta_modalidad
                inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
                inner join man.departamentos dep on dep.id = do.id_departamento
                inner join aca.oferta o on o.id_oferta = do.id_oferta
                inner join aca.malla_asignatura mas on ma.id_malla = mas.id_malla
                inner join aca.asignatura asi on mas.id_asignatura = asi.id_asignatura
                inner join aca.nivel ni  on ni.id_nivel = mas.id_nivel
                inner join aca.planificacion_paralelo pp on pp.id_malla_asignatura=mas.id_malla_asignatura
                and pp.ofertada=1 and pp.estado='A'
                inner join aca.asignatura_aprendizaje aap on mas.id_malla_asignatura = aap.id_malla_asignatura
                inner join aca.estudiante_asignatura ea on ea.id_asignatura_aprendizaje = aap.id_asignatura_aprendizaje
                inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
                inner join aca.estudiante_matricula em on em.id_estudiante_matricula = ea.id_estudiante_matricula
                inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
                inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico and pp.id_periodo_academico = pa.id_periodo_academico
                inner join aca.estudiante_oferta eo on em.id_estudiante_oferta=eo.id_estudiante_oferta
                inner join man.personas p on eo.id_persona = p.id
                where (eo.id_oferta_modalidad =@pi_id_oferta_modalidad or @pi_id_oferta_modalidad is null) and
                      aap.estado='A' AND ea.estado='A' and par.estado='A' and em.estado='A' and mg.estado='A'
                and (dep.id =@pi_id_facultad or @pi_id_facultad is null) and mg.id_periodo_academico = @pi_id_periodo_academico
                and ma.estado in ('A','P') and om.estado='A' and do.estado='A' and pa.estado='A' and pa.codigo_tipo_periodo ='PAORD'
                and o.estado='A' and mas.estado='A' and asi.estado='A' and ni.estado='A'
                group by asi.id_asignatura,asi.descripcion,ni.orden,dep.nombre,o.descripcion,em.id_estudiante_matricula,ea.id_estudiante_asignatura,ea.aprobado,pp.id_periodo_academico,
                         ea.id_paralelo,ni.descripcion_corta,ni.id_nivel,om.id_oferta_modalidad,mas.id_malla_asignatura,pa.id_periodo_academico,pa.codigo,p.identificacion,p.nombres,p.apellidos

            ) as d
        group by d.facultad,d.carrera,d.id_oferta_modalidad, d.id_periodo_academico, d.codigo, d.identificacion,d.estudiante,d.id_estudiante_matricula,d.semestre
        having count(CASE WHEN Isnull(d.aprobado,0) = 0 THEN 1 END)>0
        order by  d.facultad,d.carrera,d.estudiante

end

select * from tmp.matricula_proyeccion pm where pm.id_periodo_academico = 136
order by facultad,carrera,id_nivel,asignatura

--reportes de aulas necesarias por carrera
begin
    declare @id_periodo_academico int = 136;
    WITH CursosConParalelos AS (
        SELECT
            id_malla_asignatura,codigo_periodo,facultad,carrera,nivel,asignatura,detalle_prerrequisitos,observacion,
            modalidad,horas,pronostico,(pronostico /
                                        NULLIF(
                                                CASE
                                                    WHEN modalidad = 'ONLINE' THEN
                                                        CASE
                                                            WHEN pronostico <= 77 THEN 1
                                                            ELSE CEILING(pronostico / 70.0)
                                                            END
                                                    ELSE CEILING(pronostico / 50.0)
                                                    END
                                            ,0)
                ) AS cantidad_paralelo, CASE WHEN modalidad = 'ONLINE' THEN
                                                   CASE WHEN pronostico <= 77 THEN 1 ELSE CEILING(pronostico / 70.0)  END
                                               ELSE CEILING(pronostico / 50.0)
                END AS numero_paralelos
        FROM ( SELECT  pm.id_malla_asignatura, pm.codigo_periodo,pm.facultad,pm.carrera,pm.id_nivel as nivel,pm.asignatura,pm.detalle_prerrequisitos, pm.observacion,
                   ma2.codigo AS modalidad,(select sum(aa.valor) from aca.asignatura_aprendizaje aa
                                          inner join aca.componente_aprendizaje ca on aa.id_componente_aprendizaje = ca.id_componente_aprendizaje
                                        where aa.id_malla_asignatura= pm.id_malla_asignatura and aa.estado='A'
                                              and ca.codigo in ('DOCENCIA','PRACTICA','ASISTIDODOCENTE','SINCRONICO','SINCRONICOP')) as horas,
                   pm.pronostico_1_aprobados_menos_reprobados AS pronostico
               FROM tmp.matricula_proyeccion pm
                        INNER JOIN aca.malla_asignatura ma ON pm.id_malla_asignatura = ma.id_malla_asignatura
                        INNER JOIN aca.modalidad_asignatura ma2 ON ma.id_modalidad_asignatura = ma2.id_modalidad_asignatura
               where pm.id_periodo_academico = @id_periodo_academico
             ) a
    )

    SELECT c.codigo_periodo,c.facultad,c.carrera,--sum(c.numero_paralelos) as paralelos,sum(c.numero_paralelos) /5 as aulas_necesarias,
           isnull((SELECT sum(c1.numero_paralelos) /5 as aulas_necesarias FROM CursosConParalelos as c1
                   where c1.modalidad='PRESENCIAL' and c1.cantidad_paralelo>=40 and c1.carrera=c.carrera
                   group by c1.codigo_periodo, c1.facultad, c1.carrera),0) as cursos_50_estudiantes,
           cast(round(isnull((SELECT sum(c1.numero_paralelos) /5 as aulas_necesarias FROM CursosConParalelos as c1
                              where c1.modalidad='PRESENCIAL' and c1.cantidad_paralelo>=40 and c1.carrera=c.carrera
                              group by c1.codigo_periodo, c1.facultad, c1.carrera),0),0) as decimal(10,0)) as cursos_50_estudiantes_redon,
           isnull((SELECT sum(c1.numero_paralelos) /5 as aulas_necesarias FROM CursosConParalelos as c1
                   where c1.modalidad='PRESENCIAL' and c1.cantidad_paralelo<40 and c1.carrera=c.carrera
                   group by c1.codigo_periodo, c1.facultad, c1.carrera),0) as cursos_35_estudiantes,
           cast(round(isnull((SELECT sum(c1.numero_paralelos) /5 as aulas_necesarias FROM CursosConParalelos as c1
                              where c1.modalidad='PRESENCIAL' and c1.cantidad_paralelo<40 and c1.carrera=c.carrera
                              group by c1.codigo_periodo, c1.facultad, c1.carrera),0),0) as decimal(10,0)) as cursos_35_estudiantes_redon FROM CursosConParalelos as c
    where c.modalidad='PRESENCIAL'
    group by c.codigo_periodo, c.facultad, c.carrera
    ORDER BY c.facultad,c.carrera;

end


