use bd_sga_upse


select * from aud.AuditSchemaChanges where cast(EventDate as date) = cast(getdate() as date)
select * from aud.AuditSchemaChanges where cast(EventDate as date) = cast('2025-05-30' as date)
-- DBCC CHECKIDENT ('aca.tipo_competencia', RESEED, 3);
select * from aca.tipo_competencia

select * from uath.tipo_competencia

select * from aca.tipo_resultado_aprendizaje

--no
select * from aca.silabo_malla_asignatura

select * from aca.silabo_componente_item
select * from aca.silabo_componente

select ofa.* from aca.ofertas_facultad ofa
inner join aca.periodo_academico_oferta pao on pao.id_oferta_modalidad = ofa.id_oferta_modalidad
         where ofa.id_departamento = 5 and ofa.id_tipo_oferta = 2 and pao.id_periodo_academico = 35



select  distinct m.* from aca.ofertas_facultad ofa
inner join aca.periodo_academico_oferta pao on pao.id_oferta_modalidad = ofa.id_oferta_modalidad
inner join aca.malla m on m.id_oferta_modalidad = pao.id_oferta_modalidad
inner join aca.malla_asignatura ma on m.id_malla = ma.id_malla
         where ofa.id_tipo_oferta = 2

select * from aca.asignatura_resultado_aprendizaje where id_malla_asignatura IN (661,1869)

select ma.id_malla_asignatura,a.descripcion from aca.malla_asignatura ma
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where ma.estado='A' and ma.id_malla IN (82)-- and ma.id_nivel<=m.id_nivel_max_aperturado
order by ma.id_nivel

select * from aca.silabo_componente_item

SELECT --sc.aplica_relacion_actividad, sc.descripcion,sci.nombre,
       sir.*
FROM aca.silabo_item_relacion sir
         INNER JOIN aca.silabo_componente_item as sci ON sir.id_silabo_componente_item = sci.id_silabo_componente_item
         INNER JOIN aca.silabo_componente as sc ON sci.id_silabo_componente = sc.id_silabo_componente
WHERE sir.estado = 'I'
  AND sir.id_silabo = 6843

  AND sc.aplica_relacion_actividad = 1
--     71 164
--94 95
select m.* from aca.ofertas_facultad ofa
inner join aca.malla m on m.id_oferta_modalidad = ofa.id_oferta_modalidad
where ofa.id_tipo_oferta = 2

SELECT 'aca.oferta_competencia', MAX(id_oferta_competencia) FROM aca.oferta_competencia
UNION ALL
SELECT 'aca.oferta_resultado_aprendizaje', MAX(id_oferta_resultado_aprendizaje) FROM aca.oferta_resultado_aprendizaje
UNION ALL
SELECT 'aca.oferta_competencia_resultados' AS tabla, MAX(id_oferta_competencia_resultado) AS ultimo_id FROM aca.oferta_competencia_resultados
UNION ALL
SELECT 'aca.asignatura_resultado_aprendizaje', MAX(id_asignatura_resultado_aprendizaje) FROM aca.asignatura_resultado_aprendizaje
UNION ALL
SELECT 'aca.oferta_asignatura_resultados', MAX(id_oferta_asignatura_resultado) FROM aca.oferta_asignatura_resultados;



select * from aca.tipo_competencia
select * from aca.tipo_resultado_aprendizaje

-- DBCC CHECKIDENT ('aca.oferta_resultado_aprendizaje', RESEED, 558);
-- delete from aca.oferta_resultado_aprendizaje
select * from aca.oferta_resultado_aprendizaje

select * from aca.oferta_resultado_aprendizaje where id_malla =164

-- DBCC CHECKIDENT ('aca.oferta_competencia', RESEED, 1101);
-- delete from aca.oferta_competencia
select * from aca.oferta_competencia

select * from aca.oferta_competencia where id_malla =164

-- DBCC CHECKIDENT ('aca.oferta_competencia_resultados', RESEED, 0);
-- truncate table aca.oferta_competencia_resultados
select * from aca.oferta_competencia_resultados

select ocr.* from aca.oferta_competencia_resultados ocr
inner join aca.oferta_competencia oc on ocr.id_oferta_competencia = oc.id_oferta_competencia
where oc.id_malla = 164

select * from aca.malla where id_malla = 71

-- DBCC CHECKIDENT ('aca.oferta_asignatura_resultados', RESEED, 95);
-- delete from aca.oferta_asignatura_resultados
select * from aca.oferta_asignatura_resultados

select oar.* from aca.oferta_asignatura_resultados oar
inner join aca.asignatura_resultado_aprendizaje ara on oar.id_asignatura_resultado_aprendizaje = ara.id_asignatura_resultado_aprendizaje
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = ara.id_malla_asignatura
where ma.id_malla in (71)


-- DBCC CHECKIDENT ('aca.asignatura_resultado_aprendizaje', RESEED, 3660);
-- delete from aca.asignatura_resultado_aprendizaje
select * from aca.asignatura_resultado_aprendizaje

select ara.* from aca.asignatura_resultado_aprendizaje ara
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = ara.id_malla_asignatura
where ma.id_malla in (164)



-- DBCC CHECKIDENT ('aca.resultado_aprendizaje_item_relacion', RESEED, 0);
-- delete from aca.resultado_aprendizaje_item_relacion
select * from aca.resultado_aprendizaje_item_relacion

select * from aca.silabo_componente_item_actividad

select * from aca.silabo_item_relacion


-- DBCC CHECKIDENT ('aca.resultado_aprendizaje_inteligencia_artificial', RESEED, 0);
-- delete from aca.resultado_aprendizaje_inteligencia_artificial
select * from aca.resultado_aprendizaje_inteligencia_artificial

-- DBCC CHECKIDENT ('mood.recurso_actividad_resultado_aprendizaje', RESEED, 0);
-- delete from mood.recurso_actividad_resultado_aprendizaje
select * from mood.recurso_actividad_resultado_aprendizaje

-- DBCC CHECKIDENT ('aca.contenido_resultado_aprendizaje', RESEED, 0);
-- delete from aca.contenido_resultado_aprendizaje
select * from aca.contenido_resultado_aprendizaje

select * from mood.recursos_actividad


-- ALTER SCHEMA aca TRANSFER dbo.oferta_asignatura_resultados


select d.* from [aca].[fn_get_list_promedio_asignaturas_carrera](35,80,1)as d



begin
    declare @id_periodo int = 35,@id_oferta_modalidad int =89
    select distinct ofa.facultad,ofa.carrera,concat(ma.id_nivel,' - ',a.descripcion) as asignatura,cont.promedio as promedio_real,cast(round(cont.promedio,0)as numeric(10,0)) as promedio
--                     (select count(d.id_estudiante_matricula) as num from aca.fn_get_cantidad_matriculados_por_oferta (pao.id_oferta_modalidad,null,@id_periodo) as d
--                               where d.id_malla_asignatura = ma.id_malla_asignatura) as numero_estudiantes,
--          (select count(d.id_estudiante_matricula) as num from aca.fn_get_cantidad_matriculados_por_oferta (pao.id_oferta_modalidad,null,@id_periodo) as d
--                               where d.id_malla_asignatura = ma.id_malla_asignatura and d.aprobado=1) as aprobados,
-- ,         isnull((select avg(d.promedio) as num from aca.fn_get_cantidad_matriculados_por_oferta (pao.id_oferta_modalidad,null,@id_periodo) as d
--                               where d.id_malla_asignatura = ma.id_malla_asignatura and d.aprobado=1),0) as promedio
                    --,ara.descripcion,concat(tr.descripcion,' - ',tr.descripcion_corta) as tipo_resultado
    from aca.ofertas_facultad ofa
    inner join aca.periodo_academico_oferta pao on pao.id_oferta_modalidad = ofa.id_oferta_modalidad
    inner join aca.malla m on m.id_oferta_modalidad = pao.id_oferta_modalidad
    inner join aca.malla_asignatura ma on m.id_malla = ma.id_malla
    inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
    inner join aca.asignatura_resultado_aprendizaje ara on ma.id_malla_asignatura = ara.id_malla_asignatura
    inner join aca.oferta_asignatura_resultados oar on ara.id_asignatura_resultado_aprendizaje = oar.id_asignatura_resultado_aprendizaje
    inner join aca.tipo_resultado_aprendizaje tr on ara.id_tipo_resultado_aprendizaje = tr.id_tipo_resultado_aprendizaje
    inner join (
        select aap.id_malla_asignatura,avg(eas.promedio) as promedio
        from aca.asignatura_aprendizaje aap
        inner join aca.estudiante_asignatura eas on eas.id_asignatura_aprendizaje = aap.id_asignatura_aprendizaje
        inner join aca.paralelo p on eas.id_paralelo=p.id_paralelo
        inner join aca.estudiante_matricula ema on ema.id_estudiante_matricula = eas.id_estudiante_matricula
        inner join aca.matricula_general mg on mg.id_matricula_general = ema.id_matricula_general
        inner join aca.estudiante_oferta eo on ema.id_estudiante_oferta=eo.id_estudiante_oferta
        where mg.id_periodo_academico = @id_periodo  and eas.aprobado = 1
        and aap.estado='A' AND eas.estado='A' and p.estado='A' and ema.estado='A' and mg.estado='A'
        group by aap.id_malla_asignatura
	) as cont on cont.id_malla_asignatura = ma.id_malla_asignatura
    where --ofa.id_departamento = 5 and ofa.id_tipo_oferta = 2 and
          pao.id_periodo_academico = @id_periodo and pao.id_oferta_modalidad = @id_oferta_modalidad
end

-- insert into aca.asignatura_resultado_aprendizaje
select d.*
--     d.id_malla_asignatura,1 as id_tipo_resultado,d.resultado_aprendizaje_individual,'A',0,getdate(),getdate(),'2400254286','2400254286'
    from (
SELECT
    s.id_silabo,
    s.descripcion,
    m.id_oferta_modalidad,sma.id_silabo_malla_asignatura,
    sma.id_malla_asignatura,sma.resultado_aprendizaje,
    LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(value, '•', ''), '?', ''), CHAR(9), ''))) AS resultado_aprendizaje_individual
--     LTRIM(RTRIM(value)) AS resultado_aprendizaje_individual
FROM ACA.silabo s
INNER JOIN aca.silabo_malla_asignatura sma    ON s.id_silabo = sma.id_silabo
INNER JOIN aca.malla_asignatura ma     ON sma.id_malla_asignatura = ma.id_malla_asignatura
INNER JOIN aca.malla m     ON ma.id_malla = m.id_malla
INNER JOIN aca.silabo_periodo_academico spa     ON s.id_silabo = spa.id_silabo
CROSS APPLY STRING_SPLIT(
    REPLACE(
        REPLACE(
            REPLACE(sma.resultado_aprendizaje, CHAR(13) + CHAR(10), '|'),  -- Saltos de línea Windows
        CHAR(10), '|'),  -- Saltos de línea UNIX
    '- ', '|'),  -- Guiones
    '|'
)
WHERE
    spa.id_periodo_academico = 36
    AND m.id_oferta_modalidad IN (89, 90, 80, 29)
    AND s.estado IN ('A','P')
    AND sma.estado = 'A'
    AND sma.resultado_aprendizaje IS NOT NULL) as d
-- where d.resultado_aprendizaje_individual not in ('','Al finalizar el curso, el estudiante será capaz de:','•','Al final del curso, los estudiantes podrán:',
--                                                 'Procedimentales:','Conceptuales:')
where d.resultado_aprendizaje_individual like  '% ser%'


--version optimizada
BEGIN
    DECLARE @id_periodo INT = 35, @id_oferta_modalidad INT = 89;

    SELECT
        d.facultad,
        d.carrera,
        d.descripcion,
        d.tipo_resultado,
        d.numero_materias,
        d.promedio_materias,
        d.etiqueta_promedio,

        -- % Excelente (90–100)
        CAST(100.0 * d.excelente / NULLIF(d.numero_materias, 0) AS INT) AS excelente,
        -- % Muy bueno (80–89)
        CAST(100.0 * d.muy_bueno / NULLIF(d.numero_materias, 0) AS INT) AS muy_bueno,
        -- % Bueno (70–79)
        CAST(100.0 * d.bueno / NULLIF(d.numero_materias, 0) AS INT) AS bueno

    FROM (
        SELECT
            ofa.facultad,
            ofa.carrera,
            ora.descripcion,
            CONCAT(tr.descripcion, ' - ', tr.descripcion_corta) AS tipo_resultado,
            ora.id_oferta_resultado_aprendizaje,

            -- Conteo de materias
            COUNT(p.id_malla_asignatura) AS numero_materias,

            -- Promedio general
            ISNULL(AVG(p.promedio), 0) AS promedio_materias,

            -- Etiqueta del promedio
            CASE
                WHEN AVG(p.promedio) BETWEEN 90 AND 100 THEN 'Excelente'
                WHEN AVG(p.promedio) BETWEEN 80 AND 89 THEN 'Muy bueno'
                WHEN AVG(p.promedio) BETWEEN 70 AND 79 THEN 'Bueno'
                ELSE 'Sin categoría'
            END AS etiqueta_promedio,

            -- Conteos para % etiquetas
            SUM(CASE WHEN p.promedio BETWEEN 90 AND 100 THEN 1 ELSE 0 END) AS excelente,
            SUM(CASE WHEN p.promedio BETWEEN 80 AND 89 THEN 1 ELSE 0 END) AS muy_bueno,
            SUM(CASE WHEN p.promedio BETWEEN 70 AND 79 THEN 1 ELSE 0 END) AS bueno

        FROM aca.ofertas_facultad ofa
        INNER JOIN aca.periodo_academico_oferta pao ON pao.id_oferta_modalidad = ofa.id_oferta_modalidad
        INNER JOIN aca.malla m ON m.id_oferta_modalidad = pao.id_oferta_modalidad
        INNER JOIN aca.oferta_resultado_aprendizaje ora ON m.id_malla = ora.id_malla
        INNER JOIN aca.tipo_resultado_aprendizaje tr ON ora.id_tipo_resultado_aprendizaje = tr.id_tipo_resultado_aprendizaje
        INNER JOIN aca.oferta_asignatura_resultados oar ON ora.id_oferta_resultado_aprendizaje = oar.id_oferta_resultado_aprendizaje

        -- Aquí traemos las materias
        OUTER APPLY (
            SELECT *
            FROM [aca].[fn_get_list_promedio_asignaturas_carrera](@id_periodo, @id_oferta_modalidad, ora.id_oferta_resultado_aprendizaje)
        ) AS p

        WHERE
            ofa.id_departamento = 5
            AND ofa.id_tipo_oferta = 2
            AND pao.id_periodo_academico = @id_periodo
            AND pao.id_oferta_modalidad = @id_oferta_modalidad

        GROUP BY
            ofa.facultad,
            ofa.carrera,
            ora.descripcion,
            tr.descripcion,
            tr.descripcion_corta,
            ora.id_oferta_resultado_aprendizaje
    ) AS d;
END;