use bd_sga_upse


begin
    declare     @id_periodo_academico INT=136,
        @id_facultad INT=null,
        @id_oferta_modalidad INT=20,
        @id_docente INT=null,
        @mes INT=7,
        @id_actividad_personal_docente int=2;
--     WITH distributivosVigentes AS
--              (
--                  SELECT MAX(aux.id_distributivo_oferta) AS id_distributivo_oferta
--                  FROM aca.fn_distributivo_oferta_max(@id_periodo_academico, 'A') aux
--                  GROUP BY aux.id_periodo_academico_oferta
--              ),
--          diasPeriodo AS
--              (
--                  SELECT DISTINCT DATEADD(DAY, v.number, cs.fecha_inicio) AS fecha,
--                                  DATEPART(WEEKDAY, DATEADD(DAY, v.number, cs.fecha_inicio)) AS diaSemana
--                  FROM aca.cal_semana cs
--                           INNER JOIN master..spt_values v ON v.type = 'P' AND v.number <= DATEDIFF(DAY, cs.fecha_inicio, cs.fecha_fin)
--                  WHERE cs.id_periodo_academico = @id_periodo_academico
--                    AND MONTH(DATEADD(DAY, v.number, cs.fecha_inicio)) = @mes
--              ),
--          feriados AS
--              (
--                  SELECT DISTINCT CAST(ISNULL(f.fecha_traslada, f.fecha) AS DATE) AS fecha
--                  FROM pro.feriados f
--              ),
--          reglamentoActividad AS
--              (
--                  SELECT rad.id_actividad_detalle, rad.id_reglamento_actividad, rado.id_reglamento,
--                         rado.id_actividad_personal
--                  FROM aca.reglamento_actividad_detalle rad
--                           INNER JOIN aca.reglamento_actividad_docente rado ON rado.id_reglamento_actividad = rad.id_reglamento_actividad
--                  WHERE rad.estado = 'A' AND rado.estado = 'A'
--              ),
--          horasAsignadas AS
--              (
--                  SELECT da_int.id_distributivo_docente, h.id_docente, ra.id_reglamento,
--                         SUM(DATEDIFF(MINUTE, h.hora_inicio, h.hora_fin) / 60.0) AS totalAsignadoMes,
--                         SUM(CASE WHEN apd.descripcion LIKE '%Vinculación%' THEN DATEDIFF(MINUTE, h.hora_inicio, h.hora_fin) / 60.0 ELSE 0 END) AS esperadasVinculacion,
--                         SUM(CASE WHEN apd.descripcion LIKE '%Investigación%' THEN DATEDIFF(MINUTE, h.hora_inicio, h.hora_fin) / 60.0 ELSE 0 END) AS esperadasInvestigacion
--                  FROM aca.docente_actividad da_int
--                           INNER JOIN aca.actividad_docente_detalle acdd ON acdd.id_actividad_detalle = da_int.id_actividad_detalle
--                           INNER JOIN reglamentoActividad ra ON ra.id_actividad_detalle = acdd.id_actividad_detalle
--                           INNER JOIN aca.actividad_personal_docente apd ON apd.id_actividad_personal = ra.id_actividad_personal
--                           INNER JOIN aca.horario_academico h ON h.id_actividad_detalle = da_int.id_actividad_detalle
--                           INNER JOIN diasPeriodo dm ON dm.diaSemana = h.id_dia
--                           LEFT JOIN feriados f ON f.fecha = dm.fecha
--                  WHERE h.id_periodo_academico = @id_periodo_academico AND h.estado = 'A' AND f.fecha IS NULL
--                    AND da_int.estado = 'A' AND acdd.estado = 'A' AND apd.estado = 'A'
--                  GROUP BY da_int.id_distributivo_docente, h.id_docente, ra.id_reglamento)
--
--     SELECT
--         ROW_NUMBER() OVER (ORDER BY p.apellidos, p.nombres) AS id, p.id AS idPersona, d.id_docente AS idDocente,
--         u.id AS idUsuario, p.identificacion, p.apellidos, p.nombres,
--         CONCAT(p.apellidos, ' ', p.nombres) AS nombresCompletos,
--         aca.fn_get_titulo_persona(p.id, 'PRETER') AS titulo_tercer_nivel,
--         aca.fn_get_titulo_persona_senecyt(p.id, 'PRETER') AS registro_senecyt_tercer_nivel,
--         aca.fn_get_titulo_persona(p.id, 'PRECUA') AS titulo_cuarto_nivel, ofa.facultad, ofa.carrera,
--         aca.fn_get_titulo_persona_senecyt(p.id, 'PRECUA') AS registro_senecyt_cuarto_nivel,
--         ddo.id_distributivo_docente AS idDistributivoDocente, dode.descripcion_corta AS dedicacion,
--         dca.tipo_relacion_laboral AS tipoContrato, dca.descripcion AS categoria,
--
--         (
--             SELECT *
--             FROM aca.fn_get_clases_por_mes(pao.id_periodo_academico, p.id, @mes)
--             FOR JSON PATH
--         ) AS horaClases,
--
--         (
--             SELECT sa.id_seguimiento_actividad, apd.codigo, apd.descripcion AS actividad, sa.horas, adde.descripcion AS detalle,
--                    adde.codigo AS codigoDetalle, sa.productos, sa.avance, apd.abreviatura
--             FROM aca.seguimiento_actividad sa
--                      INNER JOIN aca.actividad_personal_docente apd ON apd.id_actividad_personal = sa.id_tipo_actividad
--                      INNER JOIN aca.actividad_docente_detalle adde ON adde.id_actividad_detalle = sa.id_actividad_detalle
--             WHERE sa.estado = 'A' AND apd.estado = 'A' AND adde.estado = 'A'
--               AND sa.id_docente = d.id_docente AND sa.id_periodo_academico = @id_periodo_academico
--               AND MONTH(sa.fecha_cumplimiento) = @mes
--             FOR JSON PATH
--         ) AS actividades,
--
--         (
--             SELECT apd.id_actividad_personal, apd.codigo, apd.abreviatura, apd.descripcion AS actividad,
--                    CAST(SUM(da_int.valor) AS DECIMAL(10,2)) AS horas
--             FROM aca.docente_actividad da_int
--                      INNER JOIN aca.actividad_docente_detalle acdd ON acdd.id_actividad_detalle = da_int.id_actividad_detalle
--                      INNER JOIN reglamentoActividad ra ON ra.id_actividad_detalle = acdd.id_actividad_detalle
--                 AND ra.id_reglamento = pao.id_reglamento
--                      INNER JOIN aca.actividad_personal_docente apd ON apd.id_actividad_personal = ra.id_actividad_personal
--             WHERE da_int.id_distributivo_docente = ddo.id_distributivo_docente
--               AND da_int.estado = 'A' AND acdd.estado = 'A' AND apd.estado = 'A'
--             GROUP BY apd.id_actividad_personal, apd.codigo, apd.abreviatura, apd.descripcion
--             FOR JSON PATH
--         ) AS actividadesDistributivo,
--
--         (
--             SELECT
--                 im.id_informe_mensual AS idInformeMensual, ise.id_informe_seguimiento AS idInformeSeguimiento, p.descripcion AS proceso,
--                 r.descripcion AS rol, ic.id_actividad_personal_docente AS idActividadPersonalDocente, da.id_documento_archivo AS idDocumentoArchivo,
--                 da.file_name AS fileName
--             FROM pro.proceso p
--                      INNER JOIN pro.proceso_etapa pe ON pe.id_proceso = p.id_proceso
--                      INNER JOIN pro.proceso_etapa_rol per ON per.id_proceso_etapa = pe.id_proceso_etapa
--                      INNER JOIN seg.roles r ON r.id = per.id_rol
--                      INNER JOIN pro.etapa e ON e.id_etapa = pe.id_etapa
--                      INNER JOIN pro.etapa_calendario_mensual ec ON ec.id_proceso_etapa_rol = per.id_proceso_etapa_rol
--                      INNER JOIN aca.informe_configuracion ic ON ic.id_proceso = p.id_proceso AND ic.id_periodo = ec.id_periodo AND ic.mes = ec.mes
--                      INNER JOIN aca.informe_seguimiento ise ON ise.id_proceso_etapa_rol = per.id_proceso_etapa_rol
--                      INNER JOIN aca.informe_mensual im ON im.id_informe_mensual = ise.id_informe_mensual AND im.id_informe_configuracion = ic.id_informe_configuracion
--                      LEFT JOIN man.documentos_archivos da ON da.id_number = ise.id_informe_seguimiento AND da.table_name = 'aca_informe_seguimiento' AND da.estado = 'A'
--             WHERE p.estado = 'A' AND pe.estado = 'A' AND per.estado = 'A' AND e.estado = 'A'
--               AND ec.estado = 'A' AND ic.estado = 'A' AND ise.estado = 'A' AND im.estado = 'A'
--               AND ec.id_periodo = pa.id_periodo AND ec.mes = @mes
--               AND ic.id_actividad_personal_docente = @id_actividad_personal_docente AND im.id_docente = d.id_docente
--             FOR JSON PATH
--         ) as informes,
--
--         ROUND(COALESCE(ha.totalAsignadoMes,
--                        CASE dode.descripcion_corta WHEN 'TC' THEN 176 WHEN 'MT' THEN 88 ELSE 53 END), 2) AS horasEsperadas,
--         ROUND(ISNULL(ha.esperadasVinculacion, 0), 2) AS esperadasVinculacion,
--         ROUND(ISNULL(ha.esperadasInvestigacion, 0), 2) AS esperadasInvestigacion,
--
--         (
--             SELECT *
--             FROM cat.fn_obtener_director_y_decano_por_id_oferta(ofa.id_oferta)
--             FOR JSON PATH, INCLUDE_NULL_VALUES
--         ) AS rol,
--         ic.id_informe_configuracion as idInformeConfiguracion,im.id_informe_mensual AS idInformeMensual, im.observacion
--     FROM aca.distributivo_oferta dio
--              INNER JOIN distributivosVigentes dv ON dv.id_distributivo_oferta = dio.id_distributivo_oferta
--              INNER JOIN aca.periodo_academico_oferta pao ON pao.id_periodo_academico_oferta = dio.id_periodo_academico_oferta
--              INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = pao.id_periodo_academico
--              INNER JOIN aca.ofertas_facultad ofa ON ofa.id_oferta_modalidad = pao.id_oferta_modalidad
--              INNER JOIN aca.distributivo_docente ddo ON ddo.id_distributivo_oferta = dio.id_distributivo_oferta
--              INNER JOIN aca.distributivo_dedicacion dde ON dde.id_distributivo_docente = ddo.id_distributivo_docente
--              INNER JOIN aca.docente_dedicacion dode ON dode.id_docente_dedicacion = dde.id_docente_dedicacion
--              INNER JOIN aca.docente_categoria dca ON dca.id_docente_categoria = dde.id_docente_categoria
--              INNER JOIN aca.docente d ON d.id_docente = ddo.id_docente
--              INNER JOIN man.personas p ON p.id = d.id_persona
--              INNER JOIN seg.usuarios u ON u.persona_id = p.id
--              INNER JOIN aca.informe_configuracion ic ON ic.id_periodo = pa.id_periodo AND ic.mes = @mes
--         AND ic.id_actividad_personal_docente = @id_actividad_personal_docente
--              inner JOIN aca.informe_mensual im ON im.id_docente = d.id_docente AND im.id_informe_configuracion= ic.id_informe_configuracion AND im.estado = 'A'
--              LEFT JOIN horasAsignadas ha ON ha.id_distributivo_docente = ddo.id_distributivo_docente
--         AND ha.id_docente = d.id_docente AND ha.id_reglamento = pao.id_reglamento
--     WHERE ddo.estado = 'A' AND dio.estado IN ('A', 'V', 'D') AND pao.estado = 'A'
--       AND u.estado = 'AC' AND dde.estado = 'A'
--       AND (@id_docente IS NULL OR ddo.id_docente = @id_docente)
--       AND (@id_facultad IS NULL OR ofa.id_departamento = @id_facultad)
--       AND (@id_oferta_modalidad IS NULL OR pao.id_oferta_modalidad = @id_oferta_modalidad)
--       AND (@id_periodo_academico IS NULL OR pao.id_periodo_academico = @id_periodo_academico)
    WITH distributivosVigentes AS
             (
                 SELECT MAX(aux.id_distributivo_oferta) AS id_distributivo_oferta
                 FROM aca.fn_distributivo_oferta_max(@id_periodo_academico, 'A') aux
                 GROUP BY aux.id_periodo_academico_oferta
             ),
         reglamentoActividad AS
             (
                 SELECT rad.id_actividad_detalle, rad.id_reglamento_actividad,
                        rado.id_reglamento, rado.id_actividad_personal
                 FROM aca.reglamento_actividad_detalle rad
                          INNER JOIN aca.reglamento_actividad_docente rado ON rado.id_reglamento_actividad = rad.id_reglamento_actividad
                 WHERE rad.estado = 'A'
                   AND rado.estado = 'A'
             )
    SELECT
        ROW_NUMBER() OVER (ORDER BY p.apellidos, p.nombres) AS id,
        p.id AS idPersona,
        d.id_docente AS idDocente,
        u.id AS idUsuario,
        p.identificacion,
        p.apellidos,
        p.nombres,
        CONCAT(p.apellidos, ' ', p.nombres) AS nombresCompletos,
        aca.fn_get_titulo_persona(p.id, 'PRETER') AS titulo_tercer_nivel,
        aca.fn_get_titulo_persona_senecyt(p.id, 'PRETER') AS registro_senecyt_tercer_nivel,
        aca.fn_get_titulo_persona(p.id, 'PRECUA') AS titulo_cuarto_nivel,
        ofa.facultad,
        ofa.carrera,
        aca.fn_get_titulo_persona_senecyt(p.id, 'PRECUA') AS registro_senecyt_cuarto_nivel,
        ddo.id_distributivo_docente AS idDistributivoDocente,
        dode.descripcion_corta AS dedicacion,
        dca.tipo_relacion_laboral AS tipoContrato,
        dca.descripcion AS categoria,

        (
            SELECT *
            FROM aca.fn_get_clases_por_mes
                 (
                    pao.id_periodo_academico,
                    p.id,
                    @mes
                 )
            FOR JSON PATH
        ) AS horaClases,

        (
            SELECT
                sa.id_seguimiento_actividad,
                apd.codigo,
                apd.descripcion AS actividad,
                sa.horas,
                adde.descripcion AS detalle,
                adde.codigo AS codigoDetalle,
                sa.productos,
                sa.avance,
                apd.abreviatura
            FROM aca.seguimiento_actividad sa
                     INNER JOIN aca.actividad_personal_docente apd ON apd.id_actividad_personal = sa.id_tipo_actividad
                     INNER JOIN aca.actividad_docente_detalle adde ON adde.id_actividad_detalle = sa.id_actividad_detalle
            WHERE sa.estado = 'A'
              AND apd.estado = 'A'
              AND adde.estado = 'A'
              AND sa.id_docente = d.id_docente
              AND sa.id_periodo_academico = @id_periodo_academico
              AND MONTH(sa.fecha_cumplimiento) = @mes
            FOR JSON PATH
        ) AS actividades,

        (
            SELECT
                apd.id_actividad_personal,
                apd.codigo,
                apd.abreviatura,
                apd.descripcion AS actividad,
                CAST(SUM(da_int.valor) AS DECIMAL(10, 2)) AS horas
            FROM aca.docente_actividad da_int
                     INNER JOIN aca.actividad_docente_detalle acdd ON acdd.id_actividad_detalle = da_int.id_actividad_detalle
                     INNER JOIN reglamentoActividad ra ON ra.id_actividad_detalle = acdd.id_actividad_detalle
                AND ra.id_reglamento = pao.id_reglamento
                     INNER JOIN aca.actividad_personal_docente apd ON apd.id_actividad_personal = ra.id_actividad_personal
            WHERE da_int.id_distributivo_docente = ddo.id_distributivo_docente
              AND da_int.estado = 'A'
              AND acdd.estado = 'A'
              AND apd.estado = 'A'
            GROUP BY apd.id_actividad_personal, apd.codigo,
                     apd.abreviatura, apd.descripcion
            FOR JSON PATH
        ) AS actividadesDistributivo,

        (
            SELECT
                im_int.id_informe_mensual AS idInformeMensual,
                ise.id_informe_seguimiento AS idInformeSeguimiento,
                pr.descripcion AS proceso,
                r.descripcion AS rol,
                ic_int.id_actividad_personal_docente AS idActividadPersonalDocente,
                da.id_documento_archivo AS idDocumentoArchivo,
                da.file_name AS fileName
            FROM pro.proceso pr
                     INNER JOIN pro.proceso_etapa pe ON pe.id_proceso = pr.id_proceso
                     INNER JOIN pro.proceso_etapa_rol per ON per.id_proceso_etapa = pe.id_proceso_etapa
                     INNER JOIN seg.roles r ON r.id = per.id_rol
                     INNER JOIN pro.etapa e ON e.id_etapa = pe.id_etapa
                     INNER JOIN pro.etapa_calendario_mensual ec ON ec.id_proceso_etapa_rol = per.id_proceso_etapa_rol
                     INNER JOIN aca.informe_configuracion ic_int ON ic_int.id_proceso = pr.id_proceso
                AND ic_int.id_periodo = ec.id_periodo
                AND ic_int.mes = ec.mes
                     INNER JOIN aca.informe_seguimiento ise ON ise.id_proceso_etapa_rol = per.id_proceso_etapa_rol
                     INNER JOIN aca.informe_mensual im_int ON im_int.id_informe_mensual = ise.id_informe_mensual
                AND im_int.id_informe_configuracion = ic_int.id_informe_configuracion
                     LEFT JOIN man.documentos_archivos da ON da.id_number = ise.id_informe_seguimiento
                AND da.table_name = 'aca_informe_seguimiento'
                AND da.estado = 'A'
            WHERE pr.estado = 'A'
              AND pe.estado = 'A'
              AND per.estado = 'A'
              AND e.estado = 'A'
              AND ec.estado = 'A'
              AND ic_int.estado = 'A'
              AND ise.estado = 'A'
              AND im_int.estado = 'A'
              AND ec.id_periodo = pa.id_periodo
              AND ec.mes = @mes
              AND ic_int.id_actividad_personal_docente = @id_actividad_personal_docente
              AND im_int.id_docente = d.id_docente
            FOR JSON PATH
        ) AS informes,

        ROUND
        (  isnull(ha.totalAsignadoMes,0), 2) AS horasEsperadas,

        ROUND(ISNULL(ha.esperadasVinculacion, 0), 2) AS esperadasVinculacion,
        ROUND(ISNULL(ha.esperadasInvestigacion, 0), 2) AS esperadasInvestigacion,

        (
            SELECT *
            FROM cat.fn_obtener_director_y_decano_por_id_oferta(ofa.id_oferta)
            FOR JSON PATH, INCLUDE_NULL_VALUES
        ) AS rol,

        ic.id_informe_configuracion AS idInformeConfiguracion,
        im.id_informe_mensual AS idInformeMensual,
        im.observacion

    FROM aca.distributivo_oferta dio
             INNER JOIN distributivosVigentes dv ON dv.id_distributivo_oferta = dio.id_distributivo_oferta
             INNER JOIN aca.periodo_academico_oferta pao ON pao.id_periodo_academico_oferta = dio.id_periodo_academico_oferta
             INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = pao.id_periodo_academico
             INNER JOIN aca.ofertas_facultad ofa ON ofa.id_oferta_modalidad = pao.id_oferta_modalidad
             INNER JOIN aca.distributivo_docente ddo ON ddo.id_distributivo_oferta = dio.id_distributivo_oferta
             INNER JOIN aca.distributivo_dedicacion dde ON dde.id_distributivo_docente = ddo.id_distributivo_docente
             INNER JOIN aca.docente_dedicacion dode ON dode.id_docente_dedicacion = dde.id_docente_dedicacion
             INNER JOIN aca.docente_categoria dca ON dca.id_docente_categoria = dde.id_docente_categoria
             INNER JOIN aca.docente d ON d.id_docente = ddo.id_docente
             INNER JOIN man.personas p ON p.id = d.id_persona

             OUTER APPLY
         (
             SELECT
                 SUM(ISNULL(hapm.asignadas, 0)) AS totalAsignadoMes,

                 SUM
                 (
                         CASE
                             WHEN hapm.actividadPersonal LIKE '%Vinculación%'
                                 THEN ISNULL(hapm.asignadas, 0)
                             ELSE 0
                             END
                 ) AS esperadasVinculacion,

                 SUM
                 (
                         CASE
                             WHEN hapm.actividadPersonal LIKE '%Investigación%'
                                 THEN ISNULL(hapm.asignadas, 0)
                             ELSE 0
                             END
                 ) AS esperadasInvestigacion

             FROM aca.fn_get_actividades_docente_por_mes
                  (
                          @id_periodo_academico,
                          p.id,
                          @mes
                  ) hapm

             WHERE hapm.idDocente = d.id_docente
               AND hapm.idDistributivoDocente = ddo.id_distributivo_docente
               AND hapm.idDistributivoOferta = dio.id_distributivo_oferta
         ) ha

             INNER JOIN seg.usuarios u ON u.persona_id = p.id
             INNER JOIN aca.informe_configuracion ic ON ic.id_periodo = pa.id_periodo
        AND ic.mes = @mes
        AND ic.id_actividad_personal_docente = @id_actividad_personal_docente
             INNER JOIN aca.informe_mensual im ON im.id_docente = d.id_docente
        AND im.id_informe_configuracion = ic.id_informe_configuracion
        AND im.estado = 'A'

    WHERE ddo.estado = 'A'
      AND dio.estado IN ('A', 'V', 'D')
      AND pao.estado = 'A'
      AND u.estado = 'AC'
      AND dde.estado = 'A'
      AND (@id_docente IS NULL OR ddo.id_docente = @id_docente)
      AND (@id_facultad IS NULL OR ofa.id_departamento = @id_facultad)
      AND (@id_oferta_modalidad IS NULL OR pao.id_oferta_modalidad = @id_oferta_modalidad)
      AND (@id_periodo_academico IS NULL OR pao.id_periodo_academico = @id_periodo_academico)
end

select * from [aca].[fn_get_actividad_asignada_docente_por_mes]( 136, 2293, 7)

select  persona_id,id  from seg.usuarios u where u.id = 2293

select cp.* from aca.clase_proyectada cp
                     inner join aca.docente d on d.id_docente = cp.id_docente
where month(cp.fecha_ing)=7 and d.id_persona = 452

exec  aca.sp_registrar_clases_proyectadas 136, 452, 7, '2400254286'

select * from pro.etapa_calendario_mensual

--eliminar estooooo ya no se va a usar
SELECT *
from [aca].[fn_get_act_complem_por_mes_] (136  ,2293 ,7 )
union all
select 0,'Clases',0,'Clases','Docencia',0,
       '',136,'',SUM(horasAlMes),0
from aca.fn_get_clases_por_mes(136,    1193 ,    7 )

select * from aca.actividad_personal_docente

select * from aca.actividad_docente_detalle

select * from aca.estudiante_oferta where id_estudiante_oferta in (11611,10447,10976,11645)

exec  [egr].[sp_requisitos_oferta] 26936

SELECT er.id_estudiante_requisito, r.id_requisito, r.descripcion, r.abreviatura,
       mr.num_creditos, mr.horas_total
FROM aca.estudiante_oferta eo
         INNER JOIN aca.malla_requisito mr ON mr.id_malla = eo.id_malla
         INNER JOIN aca.requisito r ON r.id_requisito = mr.id_requisito
         LEFT JOIN egr.estudiante_requisito er ON er.id_estudiante_oferta = eo.id_estudiante_oferta AND er.id_requisito = r.id_requisito AND er.estado = 'A'

WHERE eo.id_estudiante_oferta = 26936
  AND eo.estado = 'A' AND mr.estado = 'A'
  AND r.estado = 'A'

select mr.* from aca.malla_requisito  mr
            inner join aca.requisito r on mr.id_requisito = r.id_requisito
         where mr.id_malla = 91

select * from aca.requisito

BEGIN
    DECLARE @id_periodo_academico INT = 136, @id_facultad INT = NULL,
        @id_oferta_modalidad INT = NULL, @id_docente INT = NULL,
        @mes INT = 7, @id_actividad_personal_docente INT = 2,
        @anioMes INT, @fechaInicio DATE, @fechaFin DATE;

    SELECT @anioMes = CASE WHEN @mes >= MONTH(pa.fecha_desde) THEN YEAR(pa.fecha_desde) ELSE YEAR(pa.fecha_hasta) END
    FROM aca.periodo_academico pa
    WHERE pa.id_periodo_academico = @id_periodo_academico;

    SET @fechaInicio = DATEFROMPARTS(@anioMes, @mes, 1);
    SET @fechaFin = DATEADD(MONTH, 1, @fechaInicio);

    DROP TABLE IF EXISTS #PersonasConsulta;
    DROP TABLE IF EXISTS #HorasDetalle;
    DROP TABLE IF EXISTS #HorasActividades;
    DROP TABLE IF EXISTS #HorasClases;

    SELECT DISTINCT p.id AS idPersona
    INTO #PersonasConsulta
    FROM aca.distributivo_oferta dio
             INNER JOIN aca.fn_distributivo_oferta_max(@id_periodo_academico, 'A') dv ON dv.id_distributivo_oferta = dio.id_distributivo_oferta
             INNER JOIN aca.periodo_academico_oferta pao ON pao.id_periodo_academico_oferta = dio.id_periodo_academico_oferta
             INNER JOIN aca.ofertas_facultad ofa ON ofa.id_oferta_modalidad = pao.id_oferta_modalidad
             INNER JOIN aca.distributivo_docente ddo ON ddo.id_distributivo_oferta = dio.id_distributivo_oferta
             INNER JOIN aca.distributivo_dedicacion dde ON dde.id_distributivo_docente = ddo.id_distributivo_docente
             INNER JOIN aca.docente d ON d.id_docente = ddo.id_docente
             INNER JOIN man.personas p ON p.id = d.id_persona
             INNER JOIN seg.usuarios u ON u.persona_id = p.id
    WHERE ddo.estado = 'A' AND dio.estado IN ('A','V','D') AND pao.estado = 'A'
      AND u.estado = 'AC' AND dde.estado = 'A'
      AND (@id_docente IS NULL OR ddo.id_docente = @id_docente)
      AND (@id_facultad IS NULL OR ofa.id_departamento = @id_facultad)
      AND (@id_oferta_modalidad IS NULL OR pao.id_oferta_modalidad = @id_oferta_modalidad)
      AND pao.id_periodo_academico = @id_periodo_academico;

    CREATE UNIQUE CLUSTERED INDEX IX_PersonasConsulta_idPersona ON #PersonasConsulta(idPersona);

    SELECT pc.idPersona, hapm.idDocente, hapm.idDistributivoDocente, hapm.idDistributivoOferta,
           hapm.idActividadDetalle, hapm.idActividadPersonal, hapm.actividadPersonal, hapm.asignadas
    INTO #HorasDetalle
    FROM #PersonasConsulta pc
             CROSS APPLY aca.fn_get_actividades_docente_por_mes(@id_periodo_academico, pc.idPersona, @mes) hapm;

    CREATE CLUSTERED INDEX IX_HorasDetalle_Distributivo
        ON #HorasDetalle(idPersona, idDocente, idDistributivoDocente, idDistributivoOferta);

    SELECT hd.idPersona, hd.idDocente, hd.idDistributivoDocente, hd.idDistributivoOferta,
           SUM(ISNULL(hd.asignadas, 0)) AS horasActividades,
           SUM(CASE WHEN hd.actividadPersonal LIKE '%Vinculación%' THEN ISNULL(hd.asignadas, 0) ELSE 0 END) AS esperadasVinculacion,
           SUM(CASE WHEN hd.actividadPersonal LIKE '%Investigación%' THEN ISNULL(hd.asignadas, 0) ELSE 0 END) AS esperadasInvestigacion
    INTO #HorasActividades
    FROM #HorasDetalle hd
    WHERE hd.idActividadPersonal <> 0
    GROUP BY hd.idPersona, hd.idDocente, hd.idDistributivoDocente, hd.idDistributivoOferta;

    CREATE UNIQUE CLUSTERED INDEX IX_HorasActividades_Distributivo
        ON #HorasActividades(idPersona, idDocente, idDistributivoDocente, idDistributivoOferta);

    SELECT hd.idPersona, SUM(ISNULL(hd.asignadas, 0)) AS horasClases
    INTO #HorasClases
    FROM #HorasDetalle hd
    WHERE hd.idActividadPersonal = 0
    GROUP BY hd.idPersona;

    CREATE UNIQUE CLUSTERED INDEX IX_HorasClases_idPersona ON #HorasClases(idPersona);

    WITH distributivosVigentes AS
             (
                 SELECT MAX(aux.id_distributivo_oferta) AS id_distributivo_oferta
                 FROM aca.fn_distributivo_oferta_max(@id_periodo_academico, 'A') aux
                 GROUP BY aux.id_periodo_academico_oferta
             ),
         reglamentoActividad AS
             (
                 SELECT rad.id_actividad_detalle, rad.id_reglamento_actividad, rado.id_reglamento, rado.id_actividad_personal
                 FROM aca.reglamento_actividad_detalle rad
                          INNER JOIN aca.reglamento_actividad_docente rado ON rado.id_reglamento_actividad = rad.id_reglamento_actividad
                 WHERE rad.estado = 'A' AND rado.estado = 'A'
             )
    SELECT ROW_NUMBER() OVER (ORDER BY p.apellidos, p.nombres) AS id, p.id AS idPersona,
           d.id_docente AS idDocente, u.id AS idUsuario, p.identificacion, p.apellidos,
           p.nombres, CONCAT(p.apellidos, ' ', p.nombres) AS nombresCompletos,
           aca.fn_get_titulo_persona(p.id, 'PRETER') AS titulo_tercer_nivel,
           aca.fn_get_titulo_persona_senecyt(p.id, 'PRETER') AS registro_senecyt_tercer_nivel,
           aca.fn_get_titulo_persona(p.id, 'PRECUA') AS titulo_cuarto_nivel, ofa.facultad,
           ofa.carrera, aca.fn_get_titulo_persona_senecyt(p.id, 'PRECUA') AS registro_senecyt_cuarto_nivel,
           ddo.id_distributivo_docente AS idDistributivoDocente, dode.descripcion_corta AS dedicacion,
           dca.tipo_relacion_laboral AS tipoContrato, dca.descripcion AS categoria,

           (
               SELECT *
               FROM aca.fn_get_clases_por_mes(pao.id_periodo_academico, p.id, @mes)
               FOR JSON PATH
           ) AS horaClases,

           (
               SELECT sum(sa.horas) as horasCumplidas
               FROM aca.seguimiento_actividad sa
                INNER JOIN aca.actividad_personal_docente apd ON apd.id_actividad_personal = sa.id_tipo_actividad
                INNER JOIN aca.actividad_docente_detalle adde ON adde.id_actividad_detalle = sa.id_actividad_detalle
               WHERE sa.estado = 'A' AND apd.estado = 'A' AND adde.estado = 'A'
                 AND sa.id_docente = d.id_docente AND sa.id_periodo_academico = @id_periodo_academico
                 AND sa.fecha_cumplimiento >= @fechaInicio AND sa.fecha_cumplimiento < @fechaFin and (sa.id_tipo_actividad = @id_actividad_personal_docente or @id_actividad_personal_docente is null)
           ) AS horasCumplidas,

           (
               SELECT apd.id_actividad_personal, apd.codigo, apd.abreviatura,
                      apd.descripcion AS actividad, CAST(SUM(da_int.valor) AS DECIMAL(10,2)) AS horas
               FROM aca.docente_actividad da_int
                        INNER JOIN aca.actividad_docente_detalle acdd ON acdd.id_actividad_detalle = da_int.id_actividad_detalle
                        INNER JOIN reglamentoActividad ra ON ra.id_actividad_detalle = acdd.id_actividad_detalle AND ra.id_reglamento = pao.id_reglamento
                        INNER JOIN aca.actividad_personal_docente apd ON apd.id_actividad_personal = ra.id_actividad_personal
               WHERE da_int.id_distributivo_docente = ddo.id_distributivo_docente
                 AND da_int.estado = 'A' AND acdd.estado = 'A' AND apd.estado = 'A'
               GROUP BY apd.id_actividad_personal, apd.codigo, apd.abreviatura, apd.descripcion
               FOR JSON PATH
           ) AS actividadesDistributivo,

           (
               SELECT im_int.id_informe_mensual AS idInformeMensual,
                      ise.id_informe_seguimiento AS idInformeSeguimiento,
                      pr.descripcion AS proceso, r.descripcion AS rol,
                      ic_int.id_actividad_personal_docente AS idActividadPersonalDocente,
                      da.id_documento_archivo AS idDocumentoArchivo, da.file_name AS fileName
               FROM pro.proceso pr
                        INNER JOIN pro.proceso_etapa pe ON pe.id_proceso = pr.id_proceso
                        INNER JOIN pro.proceso_etapa_rol per ON per.id_proceso_etapa = pe.id_proceso_etapa
                        INNER JOIN seg.roles r ON r.id = per.id_rol
                        INNER JOIN pro.etapa e ON e.id_etapa = pe.id_etapa
                        INNER JOIN pro.etapa_calendario_mensual ec ON ec.id_proceso_etapa_rol = per.id_proceso_etapa_rol
                        INNER JOIN aca.informe_configuracion ic_int ON ic_int.id_proceso = pr.id_proceso AND ic_int.id_periodo = ec.id_periodo AND ic_int.mes = ec.mes
                        INNER JOIN aca.informe_seguimiento ise ON ise.id_proceso_etapa_rol = per.id_proceso_etapa_rol
                        INNER JOIN aca.informe_mensual im_int ON im_int.id_informe_mensual = ise.id_informe_mensual AND im_int.id_informe_configuracion = ic_int.id_informe_configuracion
                        LEFT JOIN man.documentos_archivos da ON da.id_number = ise.id_informe_seguimiento AND da.table_name = 'aca_informe_seguimiento' AND da.estado = 'A'
               WHERE pr.estado = 'A' AND pe.estado = 'A' AND per.estado = 'A'
                 AND e.estado = 'A' AND ec.estado = 'A' AND ic_int.estado = 'A'
                 AND ise.estado = 'A' AND im_int.estado = 'A'
                 AND ec.id_periodo = pa.id_periodo AND ec.mes = @mes
                 AND ic_int.id_actividad_personal_docente = @id_actividad_personal_docente
                 AND im_int.id_docente = d.id_docente
               FOR JSON PATH
           ) AS informes,

           ROUND(ISNULL(ha.horasActividades, 0) + ISNULL(hc.horasClases, 0), 2) AS horasEsperadas,
           ROUND(ISNULL(ha.esperadasVinculacion, 0), 2) AS esperadasVinculacion,
           ROUND(ISNULL(ha.esperadasInvestigacion, 0), 2) AS esperadasInvestigacion,

           (
               SELECT *
               FROM cat.fn_obtener_director_y_decano_por_id_oferta(ofa.id_oferta)
               FOR JSON PATH, INCLUDE_NULL_VALUES
           ) AS rol,

           ic.id_informe_configuracion AS idInformeConfiguracion,
           im.id_informe_mensual AS idInformeMensual, im.observacion
    FROM aca.distributivo_oferta dio
             INNER JOIN distributivosVigentes dv ON dv.id_distributivo_oferta = dio.id_distributivo_oferta
             INNER JOIN aca.periodo_academico_oferta pao ON pao.id_periodo_academico_oferta = dio.id_periodo_academico_oferta
             INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = pao.id_periodo_academico
             INNER JOIN aca.ofertas_facultad ofa ON ofa.id_oferta_modalidad = pao.id_oferta_modalidad
             INNER JOIN aca.distributivo_docente ddo ON ddo.id_distributivo_oferta = dio.id_distributivo_oferta
             INNER JOIN aca.distributivo_dedicacion dde ON dde.id_distributivo_docente = ddo.id_distributivo_docente
             INNER JOIN aca.docente_dedicacion dode ON dode.id_docente_dedicacion = dde.id_docente_dedicacion
             INNER JOIN aca.docente_categoria dca ON dca.id_docente_categoria = dde.id_docente_categoria
             INNER JOIN aca.docente d ON d.id_docente = ddo.id_docente
             INNER JOIN man.personas p ON p.id = d.id_persona
             INNER JOIN seg.usuarios u ON u.persona_id = p.id
             INNER JOIN aca.informe_configuracion ic ON ic.id_periodo = pa.id_periodo AND ic.mes = @mes AND ic.id_actividad_personal_docente = @id_actividad_personal_docente
             INNER JOIN aca.informe_mensual im ON im.id_docente = d.id_docente AND im.id_informe_configuracion = ic.id_informe_configuracion AND im.estado = 'A'
             LEFT JOIN #HorasActividades ha ON ha.idPersona = p.id AND ha.idDocente = d.id_docente AND ha.idDistributivoDocente = ddo.id_distributivo_docente AND ha.idDistributivoOferta = dio.id_distributivo_oferta
             LEFT JOIN #HorasClases hc ON hc.idPersona = p.id
    WHERE ddo.estado = 'A' AND dio.estado IN ('A','V','D') AND pao.estado = 'A'
      AND u.estado = 'AC' AND dde.estado = 'A'
      AND (@id_docente IS NULL OR ddo.id_docente = @id_docente)
      AND (@id_facultad IS NULL OR ofa.id_departamento = @id_facultad)
      AND (@id_oferta_modalidad IS NULL OR pao.id_oferta_modalidad = @id_oferta_modalidad)
      AND pao.id_periodo_academico = @id_periodo_academico
    OPTION (RECOMPILE);

    DROP TABLE IF EXISTS #HorasClases;
    DROP TABLE IF EXISTS #HorasActividades;
    DROP TABLE IF EXISTS #HorasDetalle;
    DROP TABLE IF EXISTS #PersonasConsulta;
END;

select * from hdv.persona_capacitacion

select * from pro.tipo_parentesco

SELECT * FROM