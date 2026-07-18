use bd_sga_upse

select n.*  from aca.[fn_horario_academico_estudiante] (95,54960,null) as n

--actualizar rn produccion
select n.*  from aca.[fn_horario_academico_estudiante] (95,null,8637) as n

select n.*  from aca.[fn_get_classes_from_student_academic_schedule] (95,null,8637, 1) as n


select * from aca.fn_listar_docentes_asignaturas(null,31,95)

select ha.*,DATEADD(SECOND, -DATEPART(SECOND, hora_inicio), hora_inicio) from aca.horario_academico ha
WHERE DATEPART(SECOND, ha.hora_inicio) <> 0;

-- UPDATE ACA.horario_academico
-- SET hora_inicio = DATEADD(SECOND, -DATEPART(SECOND, hora_inicio), hora_inicio)
-- WHERE DATEPART(SECOND, hora_inicio) <> 0;
--
-- UPDATE aca.horario_academico
-- SET hora_fin = DATEADD(SECOND, -DATEPART(SECOND, hora_fin), hora_fin)
-- WHERE DATEPART(SECOND, hora_fin) <> 0;

-- Asistencia   184
-- Asistencia Clases    741
select * from aca.clase where fecha ='2026-04-06'

select
--     p.apellidos,p.nombres,p.identificacion,o.descripcion as opcion,
       uo.* from seg.usuario_opcion uo
inner join man.opciones o on uo.id_opcion = o.id
inner join seg.usuarios u on uo.id_usuario = u.id
inner join man.personas p on u.persona_id = p.id
where uo.estado='A'
and p.identificacion in ('1203235518','2400007478')
-- and p.identificacion not in ('2400255440','2450610940','1203235518')

select * from seg.usuarios where usuario ='2400007478'
SELECT id_docente, id_malla_asignatura, id_paralelo, id_periodo_academico, id_modalidad_asignatura, fecha, hora_inicio_horario, hora_fin_horario,
       count(*)
FROM aca.clase as c
where c.estado='A'
group by id_docente, id_malla_asignatura, id_paralelo, id_periodo_academico, id_modalidad_asignatura, fecha, hora_inicio_horario, hora_fin_horario
having count(*) > 1
order by fecha desc

select distinct --a.descripcion,ma.id_malla_asignatura,c.tema,
                ca.* from aca.clase c
inner join aca.clases_asistencia ca on c.id_clase = ca.id_clase
inner join aca.malla_asignatura ma on c.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where c.estado='A' and ca.estado='A' and ca.id_estudiante_oferta =64973 and c.id_malla_asignatura=1517 --and c.id_clase not in (39395)
-- and c.id_clase in(52186)

SELECT * FROM  aca.fn_asistencia_clases_por_persona_oferta(48964) as d ORDER BY d.oferta

select id,identificacion,apellidos,nombres from man.personas where identificacion='0957596968'
select * from mig.listar_carreras_sga where identificacion='0957596968'

select * from aca.clase where id_periodo_academico = 140 and fecha='2026-01-09' and hora_inicio_horario='07:30:00' and id_modalidad_asignatura in (2,3)

select * from aca.clase_recuperacion where id_clase = 19613

select * from aca.modalidad_asignatura

    begin
WITH horarios AS (
    SELECT *
    FROM aca.fn_get_horario_academico_docente_aux(96)
    WHERE idZoom IS NOT NULL AND linkSesionVirtual IS NOT NULL
)
SELECT distinct
    h1.idNumber,
    h1.idDia,
    h1.descripcion,
    h1.id_nivel,
    h1.idHorarioAcademico AS idHorario1,
    h2.idHorarioAcademico AS idHorario2,
    h1.horaInicio AS horaInicio1,
    h1.horaFin AS horaFin1,
    h2.horaInicio AS horaInicio2,
    h2.horaFin AS horaFin2,
    DATEDIFF(MINUTE, h1.horaFin, h2.horaInicio) AS diferenciaMinutos,
    h1.docente,h1.identificacion,h1.id_malla_asignatura
FROM horarios h1
JOIN horarios h2
  ON h1.idNumber = h2.idNumber
 AND h1.idDia = h2.idDia
 AND h1.idHorarioAcademico < h2.idHorarioAcademico
 AND DATEDIFF(MINUTE, h1.horaFin, h2.horaInicio) BETWEEN 0 AND 60
ORDER BY h1.idNumber, h1.idDia, h1.horaInicio
end

select c.* from  aca.clase c
inner join aca.periodo_academico pa on pa.id_periodo_academico = c.id_periodo_academico
		left join aca.silabo s on s.id_malla_asignatura = c.id_malla_asignatura and  s.estado in ('A','P')
		left join aca.silabo_periodo_academico spa on spa.id_silabo = s.id_silabo and spa.id_periodo_academico = pa.id_periodo_academico and spa.estado='A'

         where  c.id_periodo_academico =96  and c.estado ='A'


select * from  [aca].[fn_get_horario_by_docente_periodo_academico](191,96,1)  as m
select * from  [aca].[fn_get_horario_by_docente_periodo_academico](12,96,1)  as m

-- DBCC CHECKIDENT ('aca.clase', RESEED, 6299);
select * from aca.clase
where fecha = cast(getdate() as date)
order by id_clase desc

select distinct
c.*
--     concat(cp.orden,'.',ccc.orden) as indice,cp.orden,ccc.orden,ccc.descripcion,cc.*
from aca.clase c
inner join aca.docente d on d.id_docente = c.id_docente
inner join man.personas p on d.id_persona = p.id
left join aca.clase_contenido cc on c.id_clase = cc.id_clase
left join aca.contenidos ccc on ccc.id_contenidos = cc.id_contenido
left join aca.contenidos cp on cp.id_contenidos = ccc.id_contenido_padre
where p.identificacion='0960242659' and c.id_periodo_academico =136


--Doctora Lascano
select distinct
--     a.descripcion,
    c.*
--     concat(cp.orden,'.',ccc.orden) as indice,cp.orden,ccc.orden,ccc.descripcion,cc.*
from aca.clase c
inner join aca.docente d on d.id_docente = c.id_docente
inner join aca.malla_asignatura ma on c.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
         left join aca.clase_contenido cc on c.id_clase = cc.id_clase
         left join aca.contenidos ccc on ccc.id_contenidos = cc.id_contenido
         left join aca.contenidos cp on cp.id_contenidos = ccc.id_contenido_padre
where d.id_docente = 101 and c.id_periodo_academico = 96 and c.estado = 'A' and c.id_malla_asignatura = 807
  and c.id_paralelo = 1

select distinct c.*
from aca.clase c
         inner join aca.docente d on d.id_docente = c.id_docente
        inner join man.personas p on d.id_persona = p.id
         inner join aca.malla_asignatura ma on c.id_malla_asignatura = ma.id_malla_asignatura
         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where p.identificacion ='0702163668'

select * from aca.clase_recuperacion where id_clase = 123860


SELECT
    d.id_docente, ma.id_malla_asignatura, pa.id_paralelo, ha.id_periodo_academico,
    NULL, moa.id_modalidad_asignatura, auxFecha.fecha,
    MIN((TIMEFROMPARTS(DATEPART(HOUR, ha.hora_inicio), DATEPART(MINUTE, ha.hora_inicio), 0, 0, 0))) AS horaInicioHorario,
    MAX((TIMEFROMPARTS(DATEPART(HOUR, ha.hora_fin), DATEPART(MINUTE, ha.hora_fin), 0, 0, 0)))    AS horaFinHorario,
    NULL AS horaInicio, NULL AS horaFin,
    SUM(CAST(DATEDIFF(MINUTE, (TIMEFROMPARTS(DATEPART(HOUR, ha.hora_inicio), DATEPART(MINUTE, ha.hora_inicio), 0, 0, 0)), (TIMEFROMPARTS(DATEPART(HOUR, ha.hora_fin), DATEPART(MINUTE, ha.hora_fin), 0, 0, 0))) / 60.0 AS NUMERIC(9,2))) AS duracionHoras,
    CONCAT('{"idDia":', dia.id_dia, ',"dia":"', dia.descripcion, '","asignatura":"',
           CONCAT(a.descripcion, ' ', niv.descripcion_corta, '/', pa.descripcion_corta, ' ', o.descripcion),
           '","modalidad":"', moa.descripcion, '"}') AS tema,
    0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, 'A', 0, SYSDATETIME(), SYSDATETIME(), '1312063199', '1312063199', 49
FROM aca.horario_academico ha
         INNER JOIN aca.malla_asignatura ma      ON ma.id_malla_asignatura = ha.id_malla_asignatura
         INNER JOIN aca.paralelo pa              ON pa.id_paralelo         = ha.id_paralelo
         INNER JOIN aca.malla m                  ON m.id_malla             = ma.id_malla
         INNER JOIN aca.oferta_modalidad om      ON om.id_oferta_modalidad = m.id_oferta_modalidad
         INNER JOIN aca.oferta o                 ON o.id_oferta            = om.id_oferta
         INNER JOIN aca.departamento_oferta deo  ON deo.id_oferta          = o.id_oferta AND deo.estado='A'
         INNER JOIN aca.asignatura a             ON a.id_asignatura        = ma.id_asignatura
         INNER JOIN aca.planificacion_paralelo pp
                    ON pp.id_malla_asignatura   = ma.id_malla_asignatura
                        AND pp.id_periodo_academico  = ha.id_periodo_academico
         INNER JOIN aca.planificacion_paralelo_detalle ppd
                    ON ppd.id_planificacion_paralelo = pp.id_planificacion_paralelo
                        AND ppd.id_paralelo               = ha.id_paralelo
         INNER JOIN aca.docente d                ON d.id_docente           = ha.id_docente
         INNER JOIN man.personas p               ON p.id                   = d.id_persona
         INNER JOIN aca.dia dia                  ON dia.id_dia             = ha.id_dia
         INNER JOIN aca.modalidad_asignatura moa ON moa.id_modalidad_asignatura = ppd.id_modalidad_asignatura
         INNER JOIN aca.oferta_docente od        ON od.id_docente          = d.id_docente
         INNER JOIN aca.periodo_academico_oferta peo
                    ON peo.id_periodo_academico_oferta = od.id_periodo_academico_oferta
                        AND peo.id_periodo_academico        = ha.id_periodo_academico
         INNER JOIN aca.periodo_academico pea     ON pea.id_periodo_academico = peo.id_periodo_academico
         INNER JOIN aca.nivel niv                 ON niv.id_nivel            = ma.id_nivel
         LEFT  JOIN aca.espacio_fisico ef         ON ef.id_espacio_fisico    = ha.id_espacio_fisico
         CROSS APPLY tut.fechas_rango('01-08-2025', '06-08-2025') auxFecha
WHERE m.estado IN ('A','P')
  AND pa.estado = 'A'
  AND p.estado  = 'AC'                    and d.id_docente =101
  AND LOWER(auxFecha.dia) = LOWER(dia.descripcion)
  AND ma.estado = 'A' AND ha.estado = 'A' AND a.estado = 'A'
  AND pp.estado = 'A' AND d.estado = 'A' AND ppd.estado = 'A'
  AND od.estado = 'A' AND peo.estado = 'A'
  AND peo.id_periodo_academico = ha.id_periodo_academico
  AND ha.id_periodo_academico  = 96
  AND o.id_oferta not in (31,25,59)
  AND NOT EXISTS (
    SELECT 1
    FROM aca.clase c
    WHERE c.id_docente          = d.id_docente
      AND c.id_malla_asignatura = ma.id_malla_asignatura
      AND c.id_paralelo         = ppd.id_paralelo
      AND c.id_periodo_academico= pea.id_periodo_academico
      AND c.fecha               = auxFecha.fecha
      AND c.estado              = 'A'
)
GROUP BY ha.id_periodo_academico, ma.id_nivel, ma.id_malla_asignatura, pa.id_paralelo,
         auxFecha.fecha, dia.id_dia, dia.descripcion, p.id, p.identificacion, p.nombres,
         p.apellidos, p.email_institucional, moa.descripcion, a.descripcion, ma.id_nivel,
         o.descripcion, om.id_oferta_modalidad, d.id_docente, pa.id_paralelo, moa.id_modalidad_asignatura, niv.descripcion_corta, pa.descripcion_corta;


--enfermeria
-- INSERT INTO aca.clase
-- (
--     id_docente, id_malla_asignatura, id_paralelo, id_periodo_academico, id_contenido,
--     id_modalidad_asignatura, fecha, hora_inicio_horario, hora_fin_horario, hora_inicio,
--     hora_fin, duracion, tema, es_recuperacion, fecha_recuperacion, observacion, justificacion,
--     validado, latitud, longitud, id_campus, distance, inside, accuracy, ubicacion,
--     estado, version, fecha_ing, fecha_mod, usuario_ing, usuario_mod, id_tipo_proceso_estado
-- )
SELECT
    d.id_docente, ma.id_malla_asignatura, ppd.id_paralelo, pea.id_periodo_academico,
    NULL, ppd.id_modalidad_asignatura, auxFecha.fecha,
    MIN((TIMEFROMPARTS(DATEPART(HOUR, ha.hora_inicio), DATEPART(MINUTE, ha.hora_inicio), 0, 0, 0))) AS horaInicioHorario,
    MAX((TIMEFROMPARTS(DATEPART(HOUR, ha.hora_fin), DATEPART(MINUTE, ha.hora_fin), 0, 0, 0)))    AS horaFinHorario,
    NULL AS horaInicio, NULL AS horaFin,
    CAST(DATEDIFF(MINUTE, MIN((TIMEFROMPARTS(DATEPART(HOUR, ha.hora_inicio), DATEPART(MINUTE, ha.hora_inicio), 0, 0, 0))), MAX((TIMEFROMPARTS(DATEPART(HOUR, ha.hora_fin), DATEPART(MINUTE, ha.hora_fin), 0, 0, 0)))) / 60.0 AS NUMERIC(9,2)) AS duracionHoras,
    CONCAT('{"idDia":', dia.id_dia, ',"dia":"', dia.descripcion, '","asignatura":"',
           CONCAT(a.descripcion, ' ', niv.descripcion_corta, '/', pa.descripcion_corta, ' ', o.descripcion,
                  ' ', ISNULL(ef.descripcion,'')),
           '","modalidad":"', moa.descripcion, '"}') AS tema,
    0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, 'A', 0, SYSDATETIME(), SYSDATETIME(), '1312063199', '1312063199', 49
FROM aca.horario_academico ha
         INNER JOIN aca.malla_asignatura ma      ON ma.id_malla_asignatura = ha.id_malla_asignatura
         INNER JOIN aca.paralelo pa              ON pa.id_paralelo         = ha.id_paralelo
         INNER JOIN aca.malla m                  ON m.id_malla             = ma.id_malla
         INNER JOIN aca.oferta_modalidad om      ON om.id_oferta_modalidad = m.id_oferta_modalidad
         INNER JOIN aca.oferta o                 ON o.id_oferta            = om.id_oferta
         INNER JOIN aca.departamento_oferta deo  ON deo.id_oferta          = o.id_oferta AND deo.estado='A'
         INNER JOIN aca.asignatura a             ON a.id_asignatura        = ma.id_asignatura
         INNER JOIN aca.planificacion_paralelo pp
                    ON pp.id_malla_asignatura   = ma.id_malla_asignatura
                        AND pp.id_periodo_academico  = ha.id_periodo_academico
         INNER JOIN aca.planificacion_paralelo_detalle ppd
                    ON ppd.id_planificacion_paralelo = pp.id_planificacion_paralelo
                        AND ppd.id_paralelo               = ha.id_paralelo
         INNER JOIN aca.docente d                ON d.id_docente           = ha.id_docente
         INNER JOIN man.personas p               ON p.id                   = d.id_persona
         INNER JOIN aca.dia dia                  ON dia.id_dia             = ha.id_dia
         INNER JOIN aca.modalidad_asignatura moa ON moa.id_modalidad_asignatura = ppd.id_modalidad_asignatura
         INNER JOIN aca.oferta_docente od        ON od.id_docente          = d.id_docente
         INNER JOIN aca.periodo_academico_oferta peo
                    ON peo.id_periodo_academico_oferta = od.id_periodo_academico_oferta
                        AND peo.id_periodo_academico        = ha.id_periodo_academico
         INNER JOIN aca.periodo_academico pea     ON pea.id_periodo_academico = peo.id_periodo_academico
         INNER JOIN aca.nivel niv                 ON niv.id_nivel            = ma.id_nivel
         LEFT  JOIN aca.espacio_fisico ef         ON ef.id_espacio_fisico    = ha.id_espacio_fisico
         CROSS APPLY tut.fechas_rango('01-09-2025', '06-09-2025') auxFecha
WHERE m.estado IN ('A','P')
  AND pa.estado = 'A'
  AND LOWER(auxFecha.dia) = LOWER(dia.descripcion)
  AND ma.estado = 'A' AND ha.estado = 'A' AND a.estado = 'A'
  AND pp.estado = 'A' AND ppd.estado = 'A' AND od.estado = 'A'
  AND peo.estado = 'A'
  AND peo.id_periodo_academico = ha.id_periodo_academico
  AND ha.id_periodo_academico  = 96      and d.id_docente =101
  AND o.id_oferta in (31,25,59)
  AND NOT EXISTS (
    SELECT 1
    FROM aca.clase c
    WHERE c.id_docente          = d.id_docente
      AND c.id_malla_asignatura = ma.id_malla_asignatura
      AND c.id_paralelo         = ppd.id_paralelo
      AND c.id_periodo_academico= pea.id_periodo_academico
      AND c.fecha               = auxFecha.fecha
      AND c.estado              = 'A'
)
GROUP BY om.id_oferta_modalidad, deo.id_departamento, ha.id_periodo_academico,
         ma.id_nivel, ma.id_malla_asignatura, pa.id_paralelo, auxFecha.fecha,
         dia.id_dia, dia.descripcion, p.id, p.identificacion, p.nombres, p.apellidos,
         p.email_institucional, moa.descripcion, a.descripcion, ma.id_malla_asignatura,
         ma.id_nivel, o.descripcion, om.id_oferta_modalidad, d.id_docente, ppd.id_paralelo,
         pea.id_periodo_academico, ppd.id_modalidad_asignatura, niv.descripcion_corta,
         pa.descripcion_corta, ef.descripcion,ha.hora_inicio;


select c.* from aca.clase c
inner join aca.docente d on d.id_docente = c.id_docente

where d.id_docente = 326 and c.id_periodo_academico = 96 and c.estado = 'A' and c.id_malla_asignatura = 3340

select * from aca.clases_asistencia where id_clases_asistencia = 527565
select c.duracion,round(c.duracion,1)as redondeado,ca.*
--     update ca set ca.duracion=round(c.duracion,1)
-- update ca set ca.duracion=c.duracion
from aca.clases_asistencia ca
inner join aca.clase c on c.id_clase = ca.id_clase
where ca.duracion is null and ca.validar=1 and ca.duracion =0
--   and c.duracion is not null --and c.duracion  in (3.25)

exec aca.sp_generar_clases_del_dia

-- select c.id_clase, c.fecha,c.hora_inicio_horario, c.hora_fin_horario,c.hora_inicio, c.hora_fin,ca.*
-- -- update ca set ca.duracion=c.duracion
-- from (
select distinct c.id_clase,c.duracion,--round(c.duracion,1)as redondeado,
       c.fecha,c.hora_inicio_horario, c.hora_fin_horario,c.hora_inicio, c.hora_fin,
       (SELECT aca.fn_esc_get_diferencia_horas(c.hora_inicio, c.hora_fin  )) as duracion_real
--        ,ca.*
--     update ca set ca.duracion=round(c.duracion,1)
-- update ca set ca.duracion=c.duracion
from aca.clases_asistencia ca
         inner join aca.clase c on c.id_clase = ca.id_clase
where ca.validar=1 and ca.duracion =0 and c.id_periodo_academico = 96
--     ) as d
-- inner join aca.clase c on c.id_clase = d.id_clase
-- inner join aca.clases_asistencia ca on c.id_clase = ca.id_clase
-- where d.duracion_real<'00:35:05' and  ca.validar=1 and ca.duracion =0 and c.id_periodo_academico = 96
-- and c.hora_fin is not null and ca.observacion =''

select *,
       CAST( CAST(DATEDIFF(SECOND, '00:00:00',(SELECT aca.fn_esc_get_diferencia_horas(c.hora_inicio_horario, c.hora_fin_horario  ))) AS DECIMAL(18, 9)) / 3600.0 AS DECIMAL(18, 9) )
-- update c set c.duracion=CAST( CAST(DATEDIFF(SECOND, '00:00:00',(SELECT aca.fn_esc_get_diferencia_horas(c.hora_inicio_horario, c.hora_fin_horario  ))) AS DECIMAL(18, 9)) / 3600.0 AS DECIMAL(18, 9) )
             from aca.clase c where c.duracion is null and fecha>'2025-07-01'
and c.hora_inicio_horario is not null and c.hora_fin_horario is not null and c.hora_fin is not null


select CAST(DATEADD(DAY, 1, GETDATE()) AS DATE) AS DATE
select * from  [aca].[fn_get_horario_vigente](?,?)  as m
select * from  [aca].[fn_get_horario_by_docente_periodo_academico](?,?,?)
select * from  [aca].[fn_horas_sincronica_restante](96,1571,1,8557)
exec aca.sp_grabar_clase_contenido 96,1571,1,7896,1,?
select * from aca.clase_contenido where id_clase in (7896,8556,8557)
select * from aca.clases_asistencia where id_clase in (7896,8556,8557)
select * from aca.clase where id_malla_asignatura =1571 and id_periodo_academico = 96 and id_paralelo=1
select * from aca.clase where usuario_ing='0201721610'
select * from aca.clase_contenido where id_clase_contenido in (649)

begin
    declare @pi_id_periodo_academico int = 96,@pi_id_malla_asignatura int = 1571,@pi_id_paralelo int =1,@pi_id_clase int =8557
 select TOP (5) d.* from (
    SELECT TOP (5)
        cc.id_clase,
        ch.id_contenidos idContenido,concat( C.orden,'.',Ch.orden) as tema, c.descripcion as unidad,
        ch.descripcion,
        ch.horas_sincronica - ISNULL((
            SELECT SUM(clc.horas)
            FROM aca.clase cl
            INNER JOIN aca.clase_contenido clc ON cl.id_clase = clc.id_clase
            WHERE cl.estado = 'A'
              AND clc.estado = 'A'
              AND cl.id_periodo_academico = @pi_id_periodo_academico
              AND cl.id_malla_asignatura = @pi_id_malla_asignatura
              AND cl.id_paralelo = @pi_id_paralelo
			  and clc.id_contenido=ch.id_contenidos
              AND (@pi_id_clase IS NULL OR clc.id_clase <> @pi_id_clase)
        ), 0) AS horasSincronicassss, ch.horas_sincronica
        ,cc.id_clase_contenido id,
        isnull (cc.horas,cl.duracion) horas
    FROM aca.silabo s
    INNER JOIN aca.silabo_periodo_academico spa ON s.id_silabo = spa.id_silabo
    INNER JOIN aca.malla_asignatura ma ON S.id_malla_asignatura = ma.id_malla_asignatura
    INNER JOIN aca.contenidos c ON s.id_silabo = c.id_silabo
    INNER JOIN aca.contenidos ch ON c.id_contenidos = ch.id_contenido_padre
	LEFT JOIN aca.clase cl ON cl.id_malla_asignatura=ma.id_malla_asignatura and spa.id_periodo_academico = cl.id_periodo_academico and cl.id_clase =@pi_id_clase and cl.estado='A'
    left join aca.clase_contenido cc on cc.id_clase = cl.id_clase and cc.id_contenido = ch.id_contenidos and cc.estado='A'
    WHERE s.estado IN ('A', 'P') AND c.estado = 'A'  AND ch.estado = 'A' AND spa.estado = 'A'
      AND spa.id_periodo_academico = @pi_id_periodo_academico AND ma.id_malla_asignatura = @pi_id_malla_asignatura
      AND ch.horas_sincronica <> ISNULL((
            SELECT SUM(clc.horas)
            FROM aca.clase cl
            INNER JOIN aca.clase_contenido clc ON cl.id_clase = clc.id_clase
            WHERE cl.estado = 'A'
              AND clc.estado = 'A'
			  and clc.id_contenido=ch.id_contenidos
              AND cl.id_periodo_academico = @pi_id_periodo_academico
              AND cl.id_malla_asignatura = @pi_id_malla_asignatura
              AND cl.id_paralelo = @pi_id_paralelo
              AND (@pi_id_clase IS NULL OR clc.id_clase <> @pi_id_clase)
        ), 0)
    ) as d
--     where d.horasSincronica<=d.horas
    order by d.tema asc
end
BEGIN
    DECLARE @pi_id_periodo_academico INT = 96,
            @pi_id_malla_asignatura INT = 1571,
            @pi_id_paralelo INT = 1,
            @pi_id_clase INT = 8557;

    ;WITH DatosBase AS (
        SELECT
            cc.id_clase,
            ch.id_contenidos AS idContenido,
            CONCAT(c.orden, '.', ch.orden) AS tema,
            c.descripcion AS unidad,
            ch.descripcion,
            ch.horas_sincronica
                - ISNULL((
                    SELECT SUM(clc.horas)
                    FROM aca.clase cl
                    INNER JOIN aca.clase_contenido clc ON cl.id_clase = clc.id_clase
                    WHERE cl.estado = 'A'
                      AND clc.estado = 'A'
                      AND cl.id_periodo_academico = @pi_id_periodo_academico
                      AND cl.id_malla_asignatura = @pi_id_malla_asignatura
                      AND cl.id_paralelo = @pi_id_paralelo
                      AND clc.id_contenido = ch.id_contenidos
                      AND (@pi_id_clase IS NULL OR clc.id_clase <> @pi_id_clase)
                ), 0) AS horasSincronica,
            cc.id_clase_contenido AS id,
            ISNULL(cc.horas, cl.duracion) AS horas
        FROM aca.silabo s
        INNER JOIN aca.silabo_periodo_academico spa ON s.id_silabo = spa.id_silabo
        INNER JOIN aca.malla_asignatura ma ON s.id_malla_asignatura = ma.id_malla_asignatura
        INNER JOIN aca.contenidos c ON s.id_silabo = c.id_silabo
        INNER JOIN aca.contenidos ch ON c.id_contenidos = ch.id_contenido_padre
        LEFT JOIN aca.clase cl ON cl.id_malla_asignatura = ma.id_malla_asignatura
                              AND spa.id_periodo_academico = cl.id_periodo_academico
                              AND cl.id_clase = @pi_id_clase
                              AND cl.estado = 'A'
        LEFT JOIN aca.clase_contenido cc ON cc.id_clase = cl.id_clase
                                       AND cc.id_contenido = ch.id_contenidos
                                       AND cc.estado = 'A'
        WHERE s.estado IN ('A', 'P')
          AND c.estado = 'A'
          AND ch.estado = 'A'
          AND spa.estado = 'A'
          AND spa.id_periodo_academico = @pi_id_periodo_academico
          AND ma.id_malla_asignatura = @pi_id_malla_asignatura
          AND ch.horas_sincronica <> ISNULL((
                    SELECT SUM(clc.horas)
                    FROM aca.clase cl
                    INNER JOIN aca.clase_contenido clc ON cl.id_clase = clc.id_clase
                    WHERE cl.estado = 'A'
                      AND clc.estado = 'A'
                      AND clc.id_contenido = ch.id_contenidos
                      AND cl.id_periodo_academico = @pi_id_periodo_academico
                      AND cl.id_malla_asignatura = @pi_id_malla_asignatura
                      AND cl.id_paralelo = @pi_id_paralelo
                      AND (@pi_id_clase IS NULL OR clc.id_clase <> @pi_id_clase)
          ), 0)
    ),
    DatosConAcumulado AS (
        SELECT *,
               SUM(iif(horasSincronica<0,0,horasSincronica)) OVER (ORDER BY tema ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS horasAcumuladas
        FROM DatosBase
    ),
    Elegibles AS (
        SELECT id_clase, idContenido, tema, unidad, descripcion,iif(horasSincronica<0,0,horasSincronica) as horasSincronica, id, horas, horasAcumuladas FROM DatosConAcumulado
        WHERE horasAcumuladas <= horas
    ),
    PrimerTemaMinimo AS (
        SELECT TOP 1
            id_clase,
            idContenido,
            tema,
            unidad,
            descripcion,
            horasSincronica = horas, -- se usa la hora disponible como tiempo dictado
            id,
            horas
        FROM DatosConAcumulado
        ORDER BY tema ASC
    )
    SELECT id_clase,idContenido,tema,unidad,descripcion, horasSincronica ,  id, horas
--          ,horasAcumuladas
    FROM Elegibles
    where horasSincronica>0
    UNION ALL

    SELECT *
    FROM PrimerTemaMinimo
    WHERE NOT EXISTS (SELECT 1 FROM Elegibles)
    ORDER BY tema ASC;
END
-- delete tb  from dbo.token_black_list tb
-- inner join seg.usuarios u on u.id = tb.user_id
--          where u.usuario='0918670548'

-- 494 registros
--generar clases de docentes
-- TODAY 1
-- ESTA SEMANA 2
-- NO REGISTRADAS 3
-- REGISTRADAS 4
-- MAÑANA 5
-- TODAS 0
begin
    declare @pi_id_periodo_academico int =96,@id_reglamento int =0, @num_dia int,@date date,@pi_option int=5
        IF @pi_option = 1
        begin
            set @num_dia = DATEPART(dw, CAST(DATEADD(DAY, -1, GETDATE()) AS DATE))
            Set @date = cast(getdate() as date)
        end
        ELSE IF @pi_option = 5
        begin
            set @num_dia = DATEPART(dw, CAST(DATEADD(DAY, 1, GETDATE()) AS DATE))
            Set @date = CAST(DATEADD(DAY, 1, GETDATE()) AS DATE)
        end
        ELSE
        begin
            set @num_dia = null
            Set @date = null
        end
      select @id_reglamento=pao.id_reglamento from aca.periodo_academico_oferta pao where pao.estado='A' and pao.id_periodo_academico = @pi_id_periodo_academico
    ;WITH horarios AS (
            SELECT *
            FROM aca.fn_get_horario_academico_docente_aux(96)
            WHERE idZoom IS NOT NULL AND linkSesionVirtual IS NOT NULL
        ),
        horarios_con_cercania AS (
            SELECT distinct
            h1.idNumber, h1.idDia, h1.descripcion,
            h1.idHorarioAcademico AS idHorario1,  h2.idHorarioAcademico AS idHorario2,
            h1.horaInicio AS horaInicio1, h1.horaFin AS horaFin1,h2.horaInicio AS horaInicio2, h2.horaFin AS horaFin2,
            DATEDIFF(MINUTE, h1.horaFin, h2.horaInicio) AS diferenciaMinutos, h1.docente,h1.identificacion,h1.id_malla_asignatura
            FROM horarios h1
            JOIN horarios h2
            ON h1.idNumber = h2.idNumber
            AND h1.idDia = h2.idDia
            AND h1.idHorarioAcademico < h2.idHorarioAcademico
            AND DATEDIFF(MINUTE, h1.horaFin, h2.horaInicio) BETWEEN 0 AND 60
        )
     insert into  aca.clase
        select distinct
            d.idDocente,d.id_malla_asignatura,d.id_paralelo,@pi_id_periodo_academico as id_periodo_academico,null as id_contenido,d.idModalidadAsignatura,d.fecha,d.horaInicio as horaInicio,
            isnull(hs.horaFin2,d.horaFin) as horaFin,
            null as inicio_clase,null as fin_clase,
            iif(hs.diferenciaMinutos is not null,CAST( CAST(DATEDIFF(SECOND, '00:00:00',
        (SELECT aca.fn_esc_get_diferencia_horas(d.horaInicio, ISNULL(hs.horaFin2, d.horaFin))) ) AS DECIMAL(18, 9)) / 3600.0 - (CAST(hs.diferenciaMinutos AS DECIMAL(10,2)) / 60.0) AS DECIMAL(10,2)),
                   cast(   CAST(DATEDIFF(SECOND, '00:00:00', (select aca.fn_esc_get_diferencia_horas(d.horaInicio,isnull(hs.horaFin2,d.horaFin)))) AS DECIMAL(18, 9)) / 3600 as decimal(10,2)))  duracionHorario,

--             d.modalidad as modalidad,d.idDia,d.ordenDia,d.dia as dia,d.asignatura,
                    REPLACE((
                SELECT
                    d.idDia,
                    d.dia,
                    d.asignatura,
                    d.modalidad
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            ) , '\/', '/') AS tema,0 es_recuperacion,null as fecha_recuperacion,null as observacion,null as justificacion,null as validado,null as latitud,null as longitud, null as id_campus,null as distance,
                      null as inside, null as accurancy,null as ubicaicon,'A' as estado,0 as version, getdate() as fecha_ing, getdate() as fecha_mod,p.identificacion as usuario_ing,p.identificacion as usuario_mod
--                         ,c.id_clase
        from aca.[fn_horario_academico_docente_actividad] (@pi_id_periodo_academico,null,null,@id_reglamento) as d
        inner join aca.docente dd on dd.id_docente = d.idDocente
        inner join man.personas p on dd.id_persona = p.id
        inner join aca.periodo_academico pa on pa.id_periodo_academico=@pi_id_periodo_academico
        left join horarios_con_cercania hs on hs.idHorario1 = d.id_horario_academico
        left join aca.clase c on c.id_malla_asignatura = d.id_malla_asignatura and c.id_paralelo = d.id_paralelo and c.id_periodo_academico =@pi_id_periodo_academico  and c.fecha=d.fecha and c.estado ='A'
        where d.tipo='CLASES' and c.id_clase is null
     and (
		(d.fecha = @date and  @pi_option in (1,5))
		or (@date IS  NULL and @pi_option = 2
				AND d.fecha >= DATEADD(DAY, - (DATEPART(WEEKDAY, GETDATE()) + @@DATEFIRST - 2) % 7, CAST(GETDATE() AS DATE))
				AND d.fecha < DATEADD(DAY, 7 - (DATEPART(WEEKDAY, GETDATE()) + @@DATEFIRST - 2) % 7, CAST(GETDATE() AS DATE))
			)
		or ( @pi_option =3 and d.fecha is not null and c.fecha is null)
		or ( @pi_option =4 and d.fecha is not null and c.fecha is not  null)
		or ( @pi_option =0)
		)
        and d.id_horario_academico not in  (
            SELECT idHorario2 FROM horarios_con_cercania
        )
     order by d.fecha,d.horaInicio
end

select cast(getdate() as date)
begin
     declare @num_dia int,@date date,@id_reglamento int,@pi_id_docente int=12,@pi_id_periodo_academico int=96,@pi_options int=1
        IF @pi_options = 1
        begin
            set @num_dia = DATEPART(dw, CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)) --DATEPART(dw, getdate())
            Set @date =cast(getdate() as date)
        end
        else
        begin
            set @num_dia = null
            Set @date = null
        end
        select @date

        select @id_reglamento=pao.id_reglamento from aca.periodo_academico_oferta pao where pao.estado='A' and pao.id_periodo_academico = @pi_id_periodo_academico

        select distinct @date,
            c.id_malla_asignatura,c.id_paralelo,c.id_modalidad_asignatura,c.tema as detalle_asignatura,
			--d.modalidad as modalidad,d.idDia,d.ordenDia,d.dia as dia,d.asignatura,
            c.fecha,c.fecha_recuperacion,c.es_recuperacion,c.hora_inicio_horario as horaInicio,c.hora_fin_horario,c.hora_inicio as horaInicio,c.hora_fin as horaFin,
            c.id_clase,
            case
                 when
                     c.fecha =-- CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)
				        cast(getdate() as date)
                         and c.hora_fin is null
                         and c.hora_inicio is null
                     then 'INICIAR'
			--     when  d.fecha = cast(getdate() as date) and c.id_clase is not null and c.hora_fin is not null and c.hora_inicio is not null then 'EDITAR'
                 when
                     c.fecha = cast(getdate() as date)
                         and c.hora_fin is null
                         and c.hora_inicio is not null
                     then 'FINALIZAR'

--                  when d.fecha <-- CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)
--                      cast(getdate() as date) and c.fecha is null
-- 			         then 'RECUPERAR'
            --	WHEN  d.fecha <=cast(getdate() as date)  and c.id_clase is not null and c.hora_fin is not  null and c.hora_inicio is not null THEN 'REGISTRADA'
                 else 'VER DETALLE'
                end as botonClase,
            case
                 when
                       c.hora_fin is null and c.hora_inicio is null
                     then 'NO INICIADA'
                 when
						c.hora_fin is null
                         and c.hora_inicio is not null
                         and c.fecha_recuperacion is null
                         AND CAST(GETDATE() AS DATE) = c.fecha
                     then 'EN CURSO'
-- 				 when
-- 				      c.id_clase is not null
-- 				          and c.hora_fin is null
-- 				          and c.hora_inicio is not null
-- 				          and c.fecha_recuperacion is not null
-- 				      then 'EN CURSO '+char(10)+'CLASE DE RECUPERACION'
                 when
                        c.hora_fin is not null
                        and c.hora_inicio is not null
                    then 'FINALIZADA'
                 when
                         c.hora_fin is null
                         and c.hora_inicio is not null
                         and c.fecha_recuperacion is null
                         AND CAST(GETDATE() AS DATE) > c.fecha
                     then 'NO FINALIZADA'
                 else null
                end as labelClase,c.duracion as duracionHorario,
            (select aca.fn_esc_get_diferencia_horas(c.hora_inicio,c.hora_fin)) as duracionClase,
            (select aca.fn_esc_get_diferencia_horas(c.hora_inicio_horario,c.hora_inicio)) as atraso,
            (select aca.fn_esc_get_diferencia_horas(c.hora_fin_horario,c.hora_fin)) as minutosExtras,
            case when DATEDIFF(MI , c.hora_fin_horario , c.hora_fin)>0 and c.hora_fin is not null then 'Terminó la clases minutos despues'
                 when DATEDIFF(MI , c.hora_fin_horario , c.hora_fin)<0 and c.hora_fin is not null then 'Terminó la clases minutos antes'
                 when DATEDIFF(MI , c.hora_fin_horario , c.hora_fin)=0 and c.hora_fin is not null then 'Clase finalizada a tiempo'
                 when  c.hora_inicio is not null and c.hora_fin is null then 'No finalizó la clase' else 'No inicio la clase' end as observacion,si.id_silabo,
				 @id_reglamento as idReglamento,cast(getdate() as date) as fechaActual,
				 ( (select aca.fn_silabo_componente_horas_sincrona (@pi_id_periodo_academico,@id_reglamento, c.id_malla_asignatura))*pa.numero_semanas) horasSincrona,
				 isnull ((select isnull(sum(ch.horas_sincronica),0) from aca.silabo s
        inner join aca.contenidos c on s.id_silabo=c.id_silabo
        inner join aca.contenidos ch on c.id_contenidos=ch.id_contenidos
        where s.estado in ('A','P') and c.estado='A' and ch.estado='A'
        and s.id_silabo=si.id_silabo  and c.estado='A' and ch.estado='A' ),0)
        from aca.clase c
		inner join aca.periodo_academico pa on pa.id_periodo_academico = c.id_periodo_academico
		left join aca.silabo si on si.id_malla_asignatura = c.id_malla_asignatura and  si.estado in ('A','P')
		left join aca.silabo_periodo_academico spa on spa.id_silabo = si.id_silabo and spa.id_periodo_academico = pa.id_periodo_academico and spa.estado='A'
         where  c.id_periodo_academico =@pi_id_periodo_academico and spa.id_periodo_academico =@pi_id_periodo_academico  and c.estado ='A' and c.id_docente = @pi_id_docente

     and (
		(c.fecha = @date and  @pi_options=1)
		or (@date IS  NULL and @pi_options = 2
				AND c.fecha >= DATEADD(DAY, - (DATEPART(WEEKDAY, GETDATE()) + @@DATEFIRST - 2) % 7, CAST(GETDATE() AS DATE))
				AND c.fecha < DATEADD(DAY, 7 - (DATEPART(WEEKDAY, GETDATE()) + @@DATEFIRST - 2) % 7, CAST(GETDATE() AS DATE))
			)
		or ( @pi_options =3 and c.hora_inicio is null and c.hora_fin is null)
		or ( @pi_options =4 and c.hora_inicio is not null and c.hora_fin is not  null)
		or ( @pi_options =0 )
		)
     order by c.fecha,c.hora_inicio_horario
end

select * from aca.fn_get_horario_academico_docente(96)

select * from aca.ciclo_aprendizaje where estado='A'

select distinct ca.id_ciclo_aprendizaje,rca.id_reglamento,c.id_ciclo,c.descripcion,caa.id_componente_aprendizaje,caa.codigo,caa.descripcion,ca.ponderacion_calificacion from aca.ciclo c
inner join aca.reglamento_ciclo rc on rc.id_ciclo = c.id_ciclo
inner join aca.ciclo_aprendizaje ca on rc.id_reglamento_ciclo = ca.id_reglamento_ciclo
inner join aca.reglamento_comp_aprendizaje rca on ca.id_reglamento_comp_aprendizaje = rca.id_reglamento_comp_aprendizaje
inner join aca.componente_aprendizaje caa on rca.id_comp_aprendizaje = caa.id_componente_aprendizaje
where c.estado='A' and rc.estado='A' and ca.estado='A' and rca.estado='A' and caa.estado='A'
and caa.codigo='SUMATIVA'

select * from aca.componente_aprendizaje
select * from aca.ciclo_componente_moodle

select * from aca.clase

SELECT * FROM aca.horario_ciclo_aprendizaje

select * from aca.detalle_movilidad

begin
    declare @pi_id_periodo_academico int = 136,@id_oferta_modalidad int = 20
    select distinct
                    ofa.facultad,ofa.carrera,c.id_malla_asignatura,a.descripcion as asignatura,concat(ma.id_nivel,'/',c.id_paralelo) as curso,moa.descripcion as modalidad,
                    concat(per.titulo_prefijo,per.apellidos,' ',per.nombres,per.titulo_sufijo) as docente,--c.tema as detalle_asignatura,
                    c.fecha,cr.fecha as fechaRecuperacion,c.es_recuperacion,c.hora_inicio_horario as horaInicio,c.hora_fin_horario,c.duracion as duracionHorario,
                    concat('SEMANA: ',cs.fecha_inicio,' - ',cs.fecha_fin) as semana,
                    c.id_clase,
--                     case
--                         when c.hora_fin is null and c.hora_inicio is null then 'NO INICIADA'
--                         when c.hora_fin is null and c.hora_inicio is not null and c.fecha_recuperacion is null AND CAST(GETDATE() AS DATE) = c.fecha then 'EN CURSO'
--                         when c.hora_fin is not null and c.hora_inicio is not null then 'FINALIZADA'
--                         when c.hora_fin is null and c.hora_inicio is not null and c.fecha_recuperacion is null AND CAST(GETDATE() AS DATE) > c.fecha then 'NO FINALIZADA'
--                         else null end as labelClase,
        iif(cr.id_clase is not null,'PENDIENTE DE AUTORIZACIÓN','NO INICIADA') as estado
    from aca.clase c
    inner join aca.malla_asignatura ma on c.id_malla_asignatura = ma.id_malla_asignatura
    inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
    inner join aca.malla m on ma.id_malla = m.id_malla
    inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
    inner join aca.modalidad_asignatura moa on ma.id_modalidad_asignatura = moa.id_modalidad_asignatura
    inner join aca.periodo_academico pa on pa.id_periodo_academico = c.id_periodo_academico
    inner join aca.docente d on c.id_docente = d.id_docente
    inner join man.personas per on d.id_persona = per.id
    inner join aca.cal_semana cs on cs.id_periodo_academico = c.id_periodo_academico and
                                    c.fecha between cs.fecha_inicio and cs.fecha_fin and
                                    cs.id_periodo_academico = @pi_id_periodo_academico
    left join aca.clase_recuperacion cr on cr.id_clase = c.id_clase and cr.estado='A' and cr.id_estado_clase = 49
    where ma.estado='A' and c.id_periodo_academico =@pi_id_periodo_academico   and c.estado ='A'
    and (m.id_oferta_modalidad = @id_oferta_modalidad or @id_oferta_modalidad is null) and c.hora_fin is null and c.hora_inicio is null
    order by semana
end

SELECT * FROM dbo.fn_clases_no_iniciadas(136,null, 20) ORDER BY semana;

select * from  [aca].[fn_get_clase_periodo_oferta](?,?,?,?)  as m order by m.fecha desc


