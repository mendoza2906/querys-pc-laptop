use bd_sga_upse


select p.identificacion,p.apellidos,p.nombres from seg.usuarios u
inner join man.personas p on u.persona_id = p.id
where u.id = 14375

select departamento, oferta,docente,idDocente,docente_dedicacion,identificacion
from aca.fn_get_horario_docente_facultad_con_horas( 35 , null,null,null,null ) AS d
group by departamento, oferta,docente,idDocente,docente_dedicacion,identificacion


select *
from aca.fn_get_horario_docente_facultad_con_horas( 35 , 12 , 101 ,null ,  null ) AS d
where d.idDocente=  265

select * from aca.fn_get_horario_docente_facultad(35, 12, 101, null, 265)

select * from aca.horario_academico ha
where ha.estado='A' and ha.id_docente = 265 and ha.id_periodo_academico = 35

select * from seg.roles
--numero de estudiantes por jornada
select d.dia,sum(d.estudiantes) as estudiantes from (
select  distinct
    de.nombre as departamento,
    concat(o.descripcion,' - ',mo.descripcion) as oferta,
    n.id_nivel as idNivel,
    n.descripcion as nivel,
    n.orden as nivelOrden,
--     par.id_paralelo as idParalelo,
    par.descripcion as paralelo,
--     par.orden as paraleloOrden,
--     h.id_horario_academico as idHorario,
    case when h.hora_inicio<'13:00:00' then 1 when h.hora_inicio>='13:00:00' and h.hora_fin<='18:00:00' then 2 else 3 end as idJornadaLaboral, --jl.id_jornada_laboral as idJornadaLaboral,
--     dia.id_dia as idDia,
    dia.descripcion as dia ,
--     dia.orden as diaOrden ,
    [aca].[fn_esc_get_numero_estudiantes_matriculados_by_asignatura_paralelo](ma.id_malla_asignatura,h.id_paralelo,35,null)
                 as estudiantes,
    cast(h.hora_inicio as varchar(250)) AS horaInicio, --jl.hora_inicio as horaInicio,
    cast(h.hora_fin as varchar(250)) AS horaFin,
    CONCAT((SELECT  [pro].[ProperCase](o1.descripcion_corta)),char((10)),(SELECT  [pro].[ProperCase](a.descripcion)),' - '--,(SELECT [pro].[ProperCase] (moa.descripcion)),' - '
        ,
           n.descripcion_corta,'/',par.descripcion_corta ,' ',  isnull(ef.codigo_completo,'VIRTUAL') ) as dedicacion,
--     ma.id_malla_asignatura as idMallaAsignatura,
--     h.id_espacio_fisico as idEspacioFisico, aux.id_docente,
    CONCAT(aux.apellidos,' ',aux.nombres) as docente,
    aux.identificacion,s.codigo_sector
from aca.horario_academico h
         inner join aca.dia dia on dia.id_dia = h.id_dia
         left join aca.espacio_fisico ef on h.id_espacio_fisico=ef.id_espacio_fisico and ef.estado='A'
        left join aca.edificacion e on ef.id_edificacion = e.id_edificacion and e.estado='A'
        left join aca.sector s on e.id_sector = s.id_sector
         inner join aca.paralelo par on h.id_paralelo  = par.id_paralelo
         inner join( select pao.id_periodo_academico, d.id_docente,p.identificacion, p.apellidos, p.nombres, aa.id_malla_asignatura, daa.id_paralelo, u.id as id_usuario from  aca.docente d
inner join man.personas p on p.id = d.id_persona and p.estado='AC'
inner join seg.usuarios u on p.id=u.persona_id and u.estado='AC'
inner join aca.distributivo_docente dd on d.id_docente=dd.id_docente and dd.estado='A'
inner join aca.distributivo_oferta do on dd.id_distributivo_oferta=do.id_distributivo_oferta
inner join aca.periodo_academico_oferta pao on pao.id_periodo_academico_oferta=do.id_periodo_academico_oferta
inner join aca.docente_asignatura_aprend daa on daa.id_distributivo_docente=dd.id_distributivo_docente
inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje=daa.id_asignatura_aprendizaje
                     where        d.estado='A' and daa.estado='A' and dd.estado='A'  and p.estado='AC' and u.estado='AC' and pao.id_periodo_academico=35
)  as aux on aux.id_malla_asignatura=h.id_malla_asignatura and aux.id_paralelo=h.id_paralelo and h.id_docente=aux.id_docente
         inner join aca.periodo_academico_oferta pao on aux.id_periodo_academico=pao.id_periodo_academico
         inner join aca.oferta_modalidad omo on pao.id_oferta_modalidad=omo.id_oferta_modalidad
         inner join aca.modalidad mo  on mo.id_modalidad=omo.id_modalidad
         inner join aca.oferta o on o.id_oferta  = omo.id_oferta
         inner join aca.departamento_oferta dof on o.id_oferta=dof.id_oferta
         inner join man.departamentos de on dof.id_departamento=de.id
         inner join aca.malla_asignatura ma on   ma.id_malla_asignatura = h.id_malla_asignatura  and aux.id_malla_asignatura=ma.id_malla_asignatura-- (m1.id_malla=ma.id_malla or pm.id_malla=ma.id_malla )and
         inner join aca.nivel n on n.id_nivel = ma.id_nivel
         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
         inner join aca.malla m on m.id_malla=ma.id_malla and m.estado in ('A', 'P')
         inner join aca.oferta_modalidad om1  on om1.id_oferta_modalidad =m.id_oferta_modalidad
         inner join aca.oferta o1 on o1.id_oferta  = om1.id_oferta
         inner join aca.oferta_docente odo on odo.id_docente=aux.id_docente and odo.id_periodo_academico_oferta=pao.id_periodo_academico_oferta
    and 	odo.estado='A'
where h.id_periodo_academico in( 36) and h.id_espacio_fisico is not null
  and o.id_oferta not in(31,20,85) and o.id_campus = 1
  and h.estado='A' and dof.estado='A' and de.estado='AC'
  and omo.estado='A' and m.estado IN ('A','P')
) as d
where d.idJornadaLaboral = 1  --and d.codigo_sector in ('D','E')
group by d.dia

select * from aca.oferta where id_tipo_oferta = 2
select top 1 * from aca.horario_academico

select * from aca.sector


select * from aca.tipo_jornada_laboral


select cast(hora_inicio as time(0))as hora_fin,cast(hora_fin as time(0))as hora_fin from aca.tipo_horario_jornada_lab

select * from aca.horario_academico where
                                        hora_inicio<cast('07:00:00' as time(0)) and
                                        id_periodo_academico = 35
--                                       and usuario_ing='0913031423'

select * from  [aca].[fn_get_horario_by_malla_asignatura_paralelo_periodo_academico](1933,1,36,1)

select n.descripcion,ma.id_malla_asignatura,a.descripcion, par.descripcion,h.id_dia,di.orden,
       iif(c.fecha is not null,c.fecha ,DATEADD(DAY, -(DATEPART(dw, getdate())) + di.orden, getdate())) as fecha,di.descripcion as dia,
       h.hora_inicio as horaInicio,h.hora_fin horaFin,moa.id_modalidad_asignatura,moa.descripcion as modalidad,
       c.id_clase,c.fecha_recuperacion as fechaRecuperacion,
       case when di.orden not in (DATEPART(dw, getdate())) then 'NO HABILITADA'
            when c.id_clase is not null and c.hora_fin is not null and c.hora_inicio is not null then 'EDITAR'
            when c.id_clase is not null and c.hora_fin is null and c.hora_inicio is not null then 'REANUDAR'
            when c.id_clase is null and c.hora_fin is null and c.hora_inicio is null then 'INICIAR' end as botonClase,
       case when c.id_clase is not null and c.hora_fin is not null and c.hora_inicio is not null then 'FINALIZADA'
            when c.id_clase is not null and c.hora_fin is null and c.hora_inicio is not null then 'EMPEZADA'
            when c.id_clase is null and c.hora_fin is null and c.hora_inicio is null then 'NO INICIADA' end as estadoClase,
       cast(CAST(DATEDIFF(SECOND, '00:00:00', (select aca.fn_esc_get_diferencia_horas(h.hora_inicio,h.hora_fin))) AS DECIMAL(18, 9)) / 3600 as decimal(10,2))  duracionHorario,
       (select aca.fn_esc_get_diferencia_horas(c.hora_inicio,c.hora_fin)) as duracionClase,
       (select aca.fn_esc_get_diferencia_horas(h.hora_inicio,c.hora_inicio)) as atraso,
       (select aca.fn_esc_get_diferencia_horas(h.hora_fin,c.hora_fin)) as minutosExtras,
       case when DATEDIFF(MI , h.hora_fin , c.hora_fin)>0 and c.hora_fin is not null then 'Terminó la clases minutos despues'
            when DATEDIFF(MI , h.hora_fin , c.hora_fin)<0 and c.hora_fin is not null then 'Terminó la clases minutos antes' else 'No registro Clase' end as observacion
        from aca.horario_academico h
         inner join aca.periodo_academico pa on pa.id_periodo_academico=h.id_periodo_academico
         inner join aca.malla_asignatura ma on h.id_malla_asignatura=ma.id_malla_asignatura
         inner join aca.nivel n on ma.id_nivel=n.id_nivel
         inner join aca.asignatura a on ma.id_asignatura=a.id_asignatura
         inner join aca.paralelo par on par.id_paralelo=h.id_paralelo
         inner join aca.malla  m on m.id_malla=ma.id_malla
         inner join aca.dia di on di.id_dia=h.id_dia
         inner join aca.planificacion_paralelo pp on pp.id_malla_asignatura = ma.id_malla_asignatura and pp.id_periodo_academico = h.id_periodo_academico
         inner join aca.modalidad_asignatura moa on moa.id_modalidad_asignatura = pp.id_modalidad_asignatura
         left join aca.clase c on c.id_malla_asignatura = ma.id_malla_asignatura and c.id_paralelo = par.id_paralelo
    and c.id_periodo_academico =h.id_periodo_academico  and c.estado ='A'
        and (
            (di.orden = DATEPART(dw, c.fecha) and c.fecha = cast(getdate() as date))
            or (di.orden = DATEPART(dw, c.fecha_recuperacion) and c.fecha_recuperacion = cast(getdate() as date))
            )
where h.estado='A' and h.id_periodo_academico =  36 and ma.estado='A' and pp.estado ='A'
  and ma.id_malla_asignatura = 2684
--   and (par.id_paralelo = @pi_id_paralelo or @pi_id_paralelo is null)
--   and (di.orden  = @num_dia or @num_dia is null)
group by  n.descripcion,a.descripcion  ,par.descripcion, di.descripcion,h.id_dia,h.id_periodo_academico,di.orden,moa.id_modalidad_asignatura,
          moa.descripcion,c.id_clase,c.hora_inicio,c.hora_fin,h.hora_inicio,h.hora_fin, c.fecha_recuperacion, ma.id_malla_asignatura, c.fecha

select * from aca.clase where fecha_recuperacion is not null

select  DATEPART(dw, getdate()) ,cast(getdate() as date)

select DATEADD(DAY, -(DATEPART(dw, getdate())) + 2, getdate())

select * from aca.clases_asistencia

begin
DECLARE @startDate DATE = '2024-08-05'; -- Fecha de inicio del rango
DECLARE @endDate DATE = '2024-12-31';   -- Fecha de fin del rango

WITH DateRange AS (
    SELECT @startDate AS Fecha
    UNION ALL
    SELECT DATEADD(DAY, 1, Fecha)
    FROM DateRange
    WHERE DATEADD(DAY, 1, Fecha) <= @endDate
)

SELECT
    n.descripcion, ma.id_malla_asignatura,   a.descripcion,  par.descripcion,  h.id_dia,  di.orden,
    IIF(c.fecha IS NOT NULL, c.fecha, ran.Fecha) AS fecha, -- Usamos la fecha generada por el CTE
    di.descripcion AS dia,  h.hora_inicio AS horaInicio,  h.hora_fin AS horaFin,  moa.id_modalidad_asignatura,  moa.descripcion AS modalidad,   c.id_clase,
    c.fecha_recuperacion AS fechaRecuperacion,
    CASE
        WHEN di.orden NOT IN (DATEPART(dw, ran.Fecha)) THEN 'NO HABILITADA'
        WHEN c.id_clase IS NOT NULL AND c.hora_fin IS NOT NULL AND c.hora_inicio IS NOT NULL THEN 'EDITAR'
        WHEN c.id_clase IS NOT NULL AND c.hora_fin IS NULL AND c.hora_inicio IS NOT NULL THEN 'REANUDAR'
        WHEN c.id_clase IS NULL AND c.hora_fin IS NULL AND c.hora_inicio IS NULL THEN 'INICIAR'
        END AS botonClase,
    CASE
        WHEN c.id_clase IS NOT NULL AND c.hora_fin IS NOT NULL AND c.hora_inicio IS NOT NULL THEN 'FINALIZADA'
        WHEN c.id_clase IS NOT NULL AND c.hora_fin IS NULL AND c.hora_inicio IS NOT NULL THEN 'EMPEZADA'
        WHEN c.id_clase IS NULL AND c.hora_fin IS NULL AND c.hora_inicio IS NULL THEN 'NO INICIADA'
        END AS estadoClase,
    CAST(CAST(DATEDIFF(SECOND, '00:00:00', (SELECT aca.fn_esc_get_diferencia_horas(h.hora_inicio, h.hora_fin))) AS DECIMAL(18, 9)) / 3600 AS DECIMAL(10,2)) AS duracionHorario,
    (SELECT aca.fn_esc_get_diferencia_horas(c.hora_inicio, c.hora_fin)) AS duracionClase,
    (SELECT aca.fn_esc_get_diferencia_horas(h.hora_inicio, c.hora_inicio)) AS atraso,
    (SELECT aca.fn_esc_get_diferencia_horas(h.hora_fin, c.hora_fin)) AS minutosExtras,
    CASE
        WHEN DATEDIFF(MI, h.hora_fin, c.hora_fin) > 0 AND c.hora_fin IS NOT NULL THEN 'Terminó la clases minutos despues'
        WHEN DATEDIFF(MI, h.hora_fin, c.hora_fin) < 0 AND c.hora_fin IS NOT NULL THEN 'Terminó la clases minutos antes'
        ELSE 'No registro Clase'
        END AS observacion
FROM aca.horario_academico h
         INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = h.id_periodo_academico
         INNER JOIN aca.malla_asignatura ma ON h.id_malla_asignatura = ma.id_malla_asignatura
         INNER JOIN aca.nivel n ON ma.id_nivel = n.id_nivel
         INNER JOIN aca.asignatura a ON ma.id_asignatura = a.id_asignatura
         INNER JOIN aca.paralelo par ON par.id_paralelo = h.id_paralelo
         INNER JOIN aca.malla m ON m.id_malla = ma.id_malla
         INNER JOIN aca.dia di ON di.id_dia = h.id_dia
         INNER JOIN aca.planificacion_paralelo pp ON pp.id_malla_asignatura = ma.id_malla_asignatura AND pp.id_periodo_academico = h.id_periodo_academico
         INNER JOIN aca.modalidad_asignatura moa ON moa.id_modalidad_asignatura = pp.id_modalidad_asignatura
         JOIN DateRange ran ON di.orden = DATEPART(dw, ran.Fecha) -- Filtra las fechas dentro del rango especificado
         LEFT JOIN aca.clase c ON c.id_malla_asignatura = ma.id_malla_asignatura AND c.id_paralelo = par.id_paralelo AND c.id_periodo_academico = h.id_periodo_academico
                                      AND c.estado = 'A' AND (
                                      (di.orden = DATEPART(dw, c.fecha) AND c.fecha = ran.Fecha)
                                          OR (di.orden = DATEPART(dw, c.fecha_recuperacion) AND c.fecha_recuperacion = ran.Fecha)
                                      )

WHERE h.estado = 'A' AND h.id_periodo_academico =  36 AND ma.estado = 'A' AND pp.estado = 'A' AND ma.id_malla_asignatura = 1933
--   and (par.id_paralelo = 2 or 2 is null)
GROUP BY
    n.descripcion, a.descripcion, par.descripcion, di.descripcion, h.id_dia, h.id_periodo_academico,
    di.orden, moa.id_modalidad_asignatura, moa.descripcion, c.id_clase, c.hora_inicio, c.hora_fin,
    h.hora_inicio, h.hora_fin, c.fecha_recuperacion, ma.id_malla_asignatura, c.fecha, ran.Fecha
order by fecha
OPTION (MAXRECURSION 0); -- Asegura que el CTE puede generar suficientes filas
end

select ha.* from aca.horario_academico ha
         inner join aca.malla_asignatura ma on ma.id_malla_asignatura = ha.id_malla_asignatura
         inner join aca.malla m on ma.id_malla = m.id_malla
where ha.id_periodo_academico = 96 and m.id_oferta_modalidad = 31 and ma.id_nivel = 2


--set jornada laboral horario
-- select  distinct  h.id_periodo_academico,ofa.facultad, ofa.carrera as oferta,  par.descripcion as paralelo,
--     case when h.hora_inicio<'13:00:00' then 1 when h.hora_inicio>='13:00:00' and h.hora_fin<='18:00:00' then 2 else 3 end as idJornadaLaboral,dia.descripcion as dia
    update h set h.id_tipo_horario_jornada_lab=case when h.hora_inicio<'12:00:00' then 1 when h.hora_inicio>='12:00:00' and h.hora_fin<='18:00:00' then 2 else 3 end
from aca.horario_academico h
         inner join aca.dia dia on dia.id_dia = h.id_dia
         left join aca.espacio_fisico ef on h.id_espacio_fisico=ef.id_espacio_fisico and ef.estado='A'
         left join aca.edificacion e on ef.id_edificacion = e.id_edificacion and e.estado='A'
         left join aca.sector s on e.id_sector = s.id_sector
         inner join aca.paralelo par on h.id_paralelo  = par.id_paralelo
         inner join aca.malla_asignatura ma on   ma.id_malla_asignatura = h.id_malla_asignatura  and h.id_malla_asignatura=ma.id_malla_asignatura
            inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
where h.id_periodo_academico in( 138)  and
      h.estado='A' and h.id_tipo_horario_jornada_lab is  null


select * from aca.horario_academico h where h.id_tipo_horario_jornada_lab is null
