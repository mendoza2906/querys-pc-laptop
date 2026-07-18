use bd_sga_upse


--datos reales
--usuarios
select count(distinct  identificacion) from  seg.token_persona_acceso tpa where year( tpa.fecha_ing)='2025'
select count(*) as total_usuarios
from seg.usuarios u
         inner join man.personas p on u.persona_id = p.id and u.estado='AC' and p.estado='AC'
where u.fecha_ing  <'2026-01-01'

select count(*) as total_usuarios
from seg.usuarios u
         inner join man.personas p on u.persona_id = p.id and u.estado='AC' and p.estado='AC'
where u.fecha_ing <'2025-01-01'
--
--     Incremento (%) = ((67441 - 54668) / 54668) * 100
--     ✅ Resultado
-- Diferencia: 12,773
-- Incremento: 23.36% ≈ 23%
--silabos


select
    year(fecha) as anio,
    month(fecha) as mes,
    sum(case when accion = 'Cerró sesión' then 1 else 0 end) as total_cierres
from seg.logs
where fecha >= '2025-01-01'
  and fecha <  '2026-01-01'
group by year(fecha), month(fecha)
order by anio, mes;
select p.codigo as periodo,count(distinct spa.id_silabo) as numeroSilabos from aca.silabo_periodo_academico spa
                                                                                   inner join aca.periodo_academico pa on spa.id_periodo_academico = pa.id_periodo_academico
                                                                                   inner join aca.periodo p on pa.id_periodo = p.id_periodo
where pa.estado='A' and spa.estado='A' and pa.id_periodo_academico in (35,36,95,96)
group by p.codigo

--materias planificadas
select p.codigo as periodo,count(pap.id_planificacion_paralelo) as numeroSilabos
from aca.malla_asignatura ma
         inner join aca.planificacion_paralelo pap on pap.id_malla_asignatura = ma.id_malla_asignatura
         inner join aca.periodo_academico pa on pap.id_periodo_academico = pa.id_periodo_academico
         inner join aca.periodo p on pa.id_periodo = p.id_periodo
where pa.id_periodo_academico in (95,96) and pap.estado='A'
group by p.codigo

--silabos publicados y no publicados
SELECT
    p.codigo AS periodo,
    COUNT(DISTINCT CASE
                       WHEN s.estado IN ('A','P') THEN spa.id_silabo
        END) AS numeroSilabosExistentes,
    COUNT(DISTINCT CASE
                       WHEN s.estado = 'P' THEN spa.id_silabo
        END) AS numeroSilabosPublicados
FROM aca.silabo s
         INNER JOIN aca.silabo_periodo_academico spa ON s.id_silabo = spa.id_silabo
         INNER JOIN aca.periodo_academico pa ON spa.id_periodo_academico = pa.id_periodo_academico
         INNER JOIN aca.periodo p ON pa.id_periodo = p.id_periodo
WHERE spa.estado = 'A'AND pa.estado = 'A' AND pa.id_periodo_academico IN (95,96)
GROUP BY p.codigo;

select distinct m.*
from aca.movilidad m
         inner join aca.detalle_movilidad dm on  m.id_movilidad = dm.id_movilidad
         inner join aca.estudiante_oferta eo1 on m.id_estudiante_oferta = eo1.id_estudiante_oferta
         inner join aca.malla_asignatura ma on dm.id_malla_asignatura=ma.id_malla_asignatura
         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where m.id_estudiante_oferta in (76116)

--     registro oportuno de calificaciones y cierre de actas en tiempo
BEGIN
    DECLARE @pi_id_tipoOferta VARCHAR(50)='PREGRADO',
            @pi_id_periodo_academico INT=96;

    ;WITH base AS
    (
        SELECT pa.codigo,
            c.id_ciclo,
            ec.id_docente,
            MAX(ac.fecha_mod) AS fecha_cierre_acta,
            cc.fecha_hasta,
            CASE
                WHEN MAX(ac.fecha_mod) <= DATEADD(DAY, -1, cc.fecha_hasta) THEN 1
                ELSE 0
            END AS en_tiempo,
             CASE
                WHEN MAX(ac.fecha_mod) <= cc.fecha_hasta THEN 1
                ELSE 0
            END AS en_cierre
        FROM aca.periodo_academico pa
        INNER JOIN aca.matricula_general mg
            ON pa.id_periodo_academico=mg.id_periodo_academico
        INNER JOIN aca.estudiante_matricula em
            ON mg.id_matricula_general=em.id_matricula_general
        INNER JOIN aca.estudiante_oferta eo
            ON em.id_estudiante_oferta=eo.id_estudiante_oferta
        INNER JOIN man.personas p
            ON eo.id_persona=p.id
        INNER JOIN aca.estudiante_asignatura ea
            ON em.id_estudiante_matricula=ea.id_estudiante_matricula
        INNER JOIN aca.asignatura_aprendizaje aa
            ON aa.id_asignatura_aprendizaje=ea.id_asignatura_aprendizaje
        INNER JOIN aca.malla_asignatura ma
            ON ma.id_malla_asignatura=aa.id_malla_asignatura
        INNER JOIN aca.nivel ni
            ON ma.id_nivel=ni.id_nivel
        INNER JOIN aca.asignatura a
            ON ma.id_asignatura=a.id_asignatura
        INNER JOIN aca.malla m
            ON m.id_malla=ma.id_malla
        INNER JOIN aca.oferta_modalidad omo
            ON m.id_oferta_modalidad=omo.id_oferta_modalidad
        INNER JOIN aca.oferta o
            ON omo.id_oferta=o.id_oferta
        INNER JOIN aca.departamento_oferta dof
            ON o.id_oferta=dof.id_oferta
        INNER JOIN man.departamentos dep
            ON dof.id_departamento=dep.id
        INNER JOIN aca.calificacion_general cg
            ON cg.id_periodo_academico=pa.id_periodo_academico
        INNER JOIN aca.calificacion_ciclo cc
            ON cg.id_calificacion_general=cc.id_calificacion_general
        INNER JOIN aca.reglamento_ciclo rc
            ON cc.id_reglamento_ciclo=rc.id_reglamento_ciclo
           AND rc.id_reglamento=cg.id_reglamento
        INNER JOIN aca.ciclo c
            ON rc.id_ciclo=c.id_ciclo
        INNER JOIN aca.ciclo_aprendizaje ca
            ON rc.id_reglamento_ciclo=ca.id_reglamento_ciclo
        INNER JOIN aca.reglamento_comp_aprendizaje rca
            ON ca.id_reglamento_comp_aprendizaje=rca.id_reglamento_comp_aprendizaje
           AND rca.id_reglamento=cg.id_reglamento
        INNER JOIN aca.acta_calificacion ac
            ON cg.id_calificacion_general=ac.id_calificacion_general
           AND ac.id_ciclo=c.id_ciclo
           AND ma.id_malla_asignatura=ac.id_malla_asignatura
           AND ac.id_paralelo=ea.id_paralelo
        INNER JOIN aca.estudiante_calificacion ec
            ON ec.id_estudiante_oferta=eo.id_estudiante_oferta
           AND ec.id_acta_calificacion=ac.id_acta_calificacion
        INNER JOIN aca.paralelo par
            ON par.id_paralelo=ac.id_paralelo
        INNER JOIN aca.componente_aprendizaje cap
            ON cap.id_componente_aprendizaje=rca.id_comp_aprendizaje
           AND ec.id_componente_aprendizaje=cap.id_componente_aprendizaje
        WHERE mg.estado='A'
          AND em.estado='A'
          AND eo.estado='A'
          AND ea.estado='A'
          AND aa.estado='A'
          AND ma.estado='A'
          AND a.estado='A'
          AND m.estado IN ('A','P')
          AND p.estado='AC'
          AND cg.estado='A'
          AND cc.estado='A'
          AND rc.estado='A'
          AND c.estado='A'
          AND ca.estado='A'
          AND rca.estado='A'
          AND cap.estado='A'
          AND ac.estado IN ('A','C')
          AND ec.estado='A'
          AND cap.id_componente_aprendizaje IN (9)
          AND pa.id_periodo_academico=@pi_id_periodo_academico
        GROUP BY pa.codigo,
            c.id_ciclo,
            ec.id_docente,
            cc.fecha_hasta
    )
    SELECT
    COUNT(*) AS total_registros,
    SUM(en_tiempo) AS en_tiempo,sum(en_cierre) as en_cierre,
    COUNT(*) - SUM(en_tiempo) AS fuera_tiempo,
    CAST(SUM(en_tiempo) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS registro_oportuno,
     CAST(SUM(en_cierre) * 100.0 / COUNT(*) AS DECIMAL(10,2))  AS cierre_actas
    FROM base;
END

select d.codigo,sum(numero_aprobados) as aprobados,sum(numero_matriculados) as matriculados
from [rep].[fn_get_cantidad_matriculados_porcentajes](95, null, null, null) as d
group by d.codigo

--     de cumplimientos de resultados de aprendizaje
EXEC aca.sp_resultado_aprendizaje_reporte 96,NULL,NULL,null

--usuarios activos mensuales (promedio)
    select
    year(fecha) as anio,
    month(fecha) as numero_mes,
    datename(month, fecha) as mes,
    count(distinct usuario) as usuarios_activos_mensuales
from seg.logs
where accion = 'Cerró sesión'
  and fecha >= '2025-01-01'
  and fecha <  '2026-01-01'
  and usuario is not null
group by year(fecha), month(fecha), datename(month, fecha)
order by anio, numero_mes;


select count( distinct p.identificacion) from seg.usuarios u
inner join man.personas p on u.persona_id = p.id
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
where eo.estado='A' and u.estado='AC' and eo.id_tipo_estado_estudiante = 1

select
    tipo,
    total,
    gestionados_sga,
    cast(gestionados_sga * 100.0 / nullif(total, 0) as decimal(10,2)) as porcentaje
from (
         select
             'Administrativos' as tipo,
             count(distinct cm.identificacion) as total,
             count(distinct case when u.id is not null then cm.identificacion end) as gestionados_sga
         from uath.contratos_migracion_06_02_2024 cm
                  left join man.personas p
                            on p.identificacion = cm.identificacion
                                and p.estado = 'AC'
                  left join seg.usuarios u
                            on u.persona_id = p.id
         where cm.EstadoContrato = 'A'
--            and cm.cg_relacion_IES_txt <> 'NOMBRAMIENTO'
           and cm.defTipoContrato_txt in ('ADMINISTRATIVO', 'SERVICIOS')

         union all

         select
             'Docentes' as tipo,
             count(distinct cm.identificacion) as total,
             count(distinct case when u.id is not null then cm.identificacion end) as gestionados_sga
         from uath.contratos_migracion_06_02_2024 cm
                  left join man.personas p
                            on p.identificacion = cm.identificacion
                  left join seg.usuarios u
                            on u.persona_id = p.id
         where cm.EstadoContrato = 'A'
--            and cm.defContrato_txt not in ('NOMBRAMIENTO', 'ACCION PERSONAL')
           and cm.cgTipoTrabajador_txt = 'PROFESIONAL DOC'
     ) t;

