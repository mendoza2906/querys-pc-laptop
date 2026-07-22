use bd_sga_upse


begin
    declare     @id_periodo_academico INT=136,
        @id_facultad INT=null,
        @id_oferta_modalidad INT=null,
        @id_docente INT=null,
        @mes INT=7,
        @id_actividad_personal_docente int=2;
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
                 SUM (CASE WHEN hapm.actividadPersonal LIKE '%Vinculación%' THEN ISNULL(hapm.asignadas, 0)  ELSE 0  END) AS esperadasVinculacion,
                 SUM
                 (CASE WHEN hapm.actividadPersonal LIKE '%Investigación%' THEN ISNULL(hapm.asignadas, 0) ELSE 0 END ) AS esperadasInvestigacion
                    FROM aca.fn_get_actividades_docente_por_mes(   @id_periodo_academico, p.id, @mes) hapm
                WHERE
                (
                    hapm.idDocente = d.id_docente
                    AND hapm.idDistributivoDocente = ddo.id_distributivo_docente
                    AND hapm.idDistributivoOferta = dio.id_distributivo_oferta
                )
                OR hapm.idActividadPersonal = 0
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


--eliminar estooooo ya no se va a usar
SELECT *
from [aca].[fn_get_act_complem_por_mes_] (136  ,2293 ,7 )
union all
select 0,'Clases',0,'Clases','Docencia',0,
       '',136,'',SUM(horasAlMes),0
from aca.fn_get_clases_por_mes(136,    1193 ,    7 )

SELECT
    idDocente,idDistributivoDocente,nombreDocente, idActividadDetalle,actividadPersonal,dedicacion,
    idDistributivoOferta,distributivoOferta,idPeriodoAcademico,periodoAcademico, asignadas,idActividadPersonal
FROM aca.fn_get_actividades_docente_por_mes(136,51410,7);

select * from aca.seguimiento_actividad where id_docente = 1207 and month(fecha_cumplimiento)=7


CREATE OR ALTER FUNCTION aca.fn_get_actividades_docente_por_mes
(
    @idPeriodoAcademico INT,
    @idPersona INT,
    @idMes INT
)
RETURNS TABLE
AS
RETURN
(
    WITH DatosUsuario AS
    (
        SELECT u.id AS idUsuario, p.id AS idPersona, d.id_docente AS idDocente,
               CONCAT(p.apellidos, ' ', p.nombres) AS nombreDocente
        FROM seg.usuarios u
        INNER JOIN man.personas p ON p.id = u.persona_id
        INNER JOIN aca.docente d ON d.id_persona = p.id
        WHERE p.id = @idPersona AND p.estado = 'AC' AND d.estado = 'A'
    ),
    DatosPeriodo AS
    (
        SELECT pa.id_periodo_academico, pa.descripcion AS periodoAcademico, pa.fecha_desde, pa.fecha_hasta,
               CASE WHEN @idMes >= MONTH(pa.fecha_desde) THEN YEAR(pa.fecha_desde) ELSE YEAR(pa.fecha_hasta) END AS anioMes
        FROM aca.periodo_academico pa
        WHERE pa.id_periodo_academico = @idPeriodoAcademico AND pa.estado = 'A'
    ),
    ParametrosFecha AS
    (
        SELECT dp.id_periodo_academico, dp.periodoAcademico,
               DATEFROMPARTS(dp.anioMes, @idMes, 1) AS fechaInicio,
               EOMONTH(DATEFROMPARTS(dp.anioMes, @idMes, 1)) AS fechaFin
        FROM DatosPeriodo dp
    ),
    FechasMes AS
    (
        SELECT fr.fecha, LOWER(fr.dia) AS dia
        FROM ParametrosFecha pf
        CROSS APPLY tut.fechas_rango(pf.fechaInicio, pf.fechaFin) fr
    ),
    Feriados AS
    (
        SELECT DISTINCT CAST(ISNULL(f.fecha_traslada, f.fecha) AS DATE) AS fecha
        FROM pro.feriados f
        WHERE f.estado = 'A'
    ),
    RangoPregrado AS
    (
        SELECT cs.id_periodo_academico, MIN(cs.fecha_inicio) AS fechaInicio, MAX(cs.fecha_fin) AS fechaFin
        FROM aca.cal_semana cs
        WHERE cs.id_periodo_academico = @idPeriodoAcademico
        GROUP BY cs.id_periodo_academico
    ),
    RangoNivelacion AS
    (
        SELECT ce.id_periodo_academico, MIN(ce.fecha_inicio) AS fechaInicio, MAX(ce.fecha_fin) AS fechaFin
        FROM aca.cal_evento ce
        GROUP BY ce.id_periodo_academico
    ),
    ActividadesBase AS
    (
        SELECT DISTINCT du.idDocente, du.nombreDocente, acdd.id_actividad_detalle AS idActividadDetalle,
               apd.descripcion AS actividadPersonal, CONCAT(acdd.codigo, ' ', acdd.descripcion) AS dedicacion,
               dof.id_distributivo_oferta AS idDistributivoOferta, dof.descripcion AS distributivoOferta,
               pa.id_periodo_academico AS idPeriodoAcademico, pa.descripcion AS periodoAcademico,
               apd.id_actividad_personal AS idActividadPersonal, dd.id_distributivo_docente AS idDistributivoDocente
        FROM DatosUsuario du
        INNER JOIN aca.distributivo_docente dd ON dd.id_docente = du.idDocente
        INNER JOIN aca.distributivo_oferta dof ON dof.id_distributivo_oferta = dd.id_distributivo_oferta
        INNER JOIN aca.periodo_academico_oferta pao ON pao.id_periodo_academico_oferta = dof.id_periodo_academico_oferta
        INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = pao.id_periodo_academico
        INNER JOIN aca.oferta_modalidad omo ON omo.id_oferta_modalidad = pao.id_oferta_modalidad
        INNER JOIN aca.docente_actividad da ON da.id_distributivo_docente = dd.id_distributivo_docente
        INNER JOIN aca.actividad_docente_detalle acdd ON acdd.id_actividad_detalle = da.id_actividad_detalle
        INNER JOIN aca.reglamento_actividad_detalle rad ON rad.id_actividad_detalle = acdd.id_actividad_detalle
        INNER JOIN aca.reglamento_actividad_docente rado ON rado.id_reglamento_actividad = rad.id_reglamento_actividad AND rado.id_reglamento = pao.id_reglamento
        INNER JOIN aca.actividad_personal_docente apd ON apd.id_actividad_personal = rado.id_actividad_personal
        INNER JOIN aca.fn_distributivo_oferta_max(@idPeriodoAcademico, 'A') dom ON dom.id_distributivo_oferta = dof.id_distributivo_oferta
        WHERE pa.id_periodo_academico = @idPeriodoAcademico AND pa.estado = 'A' AND pao.estado = 'A'
          AND dof.estado IN ('A','D','V') AND dd.estado = 'A' AND da.estado = 'A'
          AND acdd.estado = 'A' AND rad.estado = 'A' AND rado.estado = 'A'
          AND apd.estado = 'A' AND omo.estado = 'A'
    ),
    HorasActividades AS
    (
        SELECT ab.idDocente, ab.idActividadDetalle, ab.idDistributivoOferta,
               CAST(SUM(CASE WHEN fer.fecha IS NULL
                             THEN DATEDIFF(MINUTE, h.hora_inicio, h.hora_fin) / 60.0
                             ELSE 0 END) AS DECIMAL(10,2)) AS horasAsignadas
        FROM ActividadesBase ab
        INNER JOIN aca.horario_academico h ON h.id_actividad_detalle = ab.idActividadDetalle AND h.id_periodo_academico = ab.idPeriodoAcademico AND h.id_docente = ab.idDocente AND h.estado = 'A'
        INNER JOIN aca.dia di ON di.id_dia = h.id_dia
        INNER JOIN FechasMes fm ON fm.dia = LOWER(di.descripcion)
        LEFT JOIN Feriados fer ON fer.fecha = fm.fecha
        GROUP BY ab.idDocente, ab.idActividadDetalle, ab.idDistributivoOferta
    ),
    ActividadesResultado AS
    (
        SELECT ab.idDocente, ab.idDistributivoDocente, CAST(ab.nombreDocente AS VARCHAR(250)) AS nombreDocente,
               ab.idActividadDetalle, CAST(ab.actividadPersonal AS VARCHAR(MAX)) AS actividadPersonal,
               CAST(ab.dedicacion AS VARCHAR(MAX)) AS dedicacion, ab.idDistributivoOferta,
               CAST(ab.distributivoOferta AS VARCHAR(250)) AS distributivoOferta,
               ab.idPeriodoAcademico, CAST(ab.periodoAcademico AS VARCHAR(150)) AS periodoAcademico,
               CAST(ISNULL(ha.horasAsignadas, 0) AS DECIMAL(10,2)) AS asignadas, ab.idActividadPersonal
        FROM ActividadesBase ab
        LEFT JOIN HorasActividades ha ON ha.idDocente = ab.idDocente AND ha.idActividadDetalle = ab.idActividadDetalle AND ha.idDistributivoOferta = ab.idDistributivoOferta
    ),
    AsignaturasDocente AS
    (
        SELECT DISTINCT dd.id_docente AS idDocente, ma.id_malla_asignatura AS idMallaAsignatura,
               p.id_paralelo AS idParalelo, pa.id_periodo_academico AS idPeriodoAcademico,
               pa.id_periodo_academico_padre AS idPeriodoAcademicoPadre,
               dd.id_distributivo_docente AS idDistributivoDocente
        FROM DatosUsuario du
        INNER JOIN aca.distributivo_docente dd ON dd.id_docente = du.idDocente
        INNER JOIN aca.distributivo_oferta dof ON dof.id_distributivo_oferta = dd.id_distributivo_oferta
        INNER JOIN aca.periodo_academico_oferta pao ON pao.id_periodo_academico_oferta = dof.id_periodo_academico_oferta
        INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = pao.id_periodo_academico
        INNER JOIN aca.docente_asignatura_aprend daa ON daa.id_distributivo_docente = dd.id_distributivo_docente
        INNER JOIN aca.paralelo p ON p.id_paralelo = daa.id_paralelo
        INNER JOIN aca.asignatura_aprendizaje aa ON aa.id_asignatura_aprendizaje = daa.id_asignatura_aprendizaje
        INNER JOIN aca.malla_asignatura ma ON ma.id_malla_asignatura = aa.id_malla_asignatura
        INNER JOIN aca.malla m ON m.id_malla = ma.id_malla
        INNER JOIN aca.oferta_modalidad omo ON omo.id_oferta_modalidad = m.id_oferta_modalidad
        INNER JOIN aca.oferta o ON o.id_oferta = omo.id_oferta
        INNER JOIN aca.tipo_oferta tof ON tof.id_tipo_oferta = o.id_tipo_oferta
        INNER JOIN aca.fn_distributivo_oferta_max(@idPeriodoAcademico, 'A') dom ON dom.id_distributivo_oferta = dof.id_distributivo_oferta
        WHERE pa.id_periodo_academico = @idPeriodoAcademico AND pa.estado = 'A' AND pao.estado = 'A'
          AND dof.estado IN ('A','D','V') AND dd.estado = 'A' AND daa.estado = 'A'
          AND p.estado = 'A' AND aa.estado = 'A' AND ma.estado = 'A'
          AND m.estado IN ('A','P') AND omo.estado = 'A' AND o.estado = 'A'
          AND tof.estado = 'A'
    ),
    HorariosClases AS
    (
        SELECT DISTINCT h.id_horario_academico, ad.idDocente, h.id_periodo_academico,
               h.id_dia, h.hora_inicio, h.hora_fin,
               ad.idPeriodoAcademico, ad.idPeriodoAcademicoPadre
        FROM AsignaturasDocente ad
        INNER JOIN aca.horario_academico h ON h.id_malla_asignatura = ad.idMallaAsignatura AND h.id_paralelo = ad.idParalelo AND h.id_docente = ad.idDocente AND h.estado = 'A' AND h.id_periodo_academico IN (ad.idPeriodoAcademico, ad.idPeriodoAcademicoPadre)
    ),
    TotalClases AS
    (
        SELECT CAST(ISNULL(SUM(
                   CASE
                       WHEN fer.fecha IS NOT NULL THEN 0
                       WHEN hc.id_periodo_academico = hc.idPeriodoAcademico
                            AND fm.fecha BETWEEN rp.fechaInicio AND rp.fechaFin
                           THEN DATEDIFF(MINUTE, hc.hora_inicio, hc.hora_fin) / 60.0
                       WHEN hc.id_periodo_academico = hc.idPeriodoAcademicoPadre
                            AND fm.fecha BETWEEN rn.fechaInicio AND rn.fechaFin
                           THEN DATEDIFF(MINUTE, hc.hora_inicio, hc.hora_fin) / 60.0
                       ELSE 0
                   END
               ), 0) AS DECIMAL(10,2)) AS horasClases
        FROM HorariosClases hc
        INNER JOIN aca.dia di ON di.id_dia = hc.id_dia
        INNER JOIN FechasMes fm ON fm.dia = LOWER(di.descripcion)
        LEFT JOIN Feriados fer ON fer.fecha = fm.fecha
        LEFT JOIN RangoPregrado rp ON rp.id_periodo_academico = hc.idPeriodoAcademico
        LEFT JOIN RangoNivelacion rn ON rn.id_periodo_academico = hc.idPeriodoAcademicoPadre
    )
    SELECT ar.idDocente, ar.idDistributivoDocente, ar.nombreDocente, ar.idActividadDetalle,
           ar.actividadPersonal, ar.dedicacion, ar.idDistributivoOferta, ar.distributivoOferta,
           ar.idPeriodoAcademico, ar.periodoAcademico, ar.asignadas, ar.idActividadPersonal
    FROM ActividadesResultado ar

    UNION ALL

    SELECT 0 AS idDocente, 0 AS idDistributivoDocente, CAST('Clases' AS VARCHAR(250)) AS nombreDocente,
           0 AS idActividadDetalle, CAST('Clases' AS VARCHAR(MAX)) AS actividadPersonal,
           CAST('Docencia' AS VARCHAR(MAX)) AS dedicacion, 0 AS idDistributivoOferta,
           CAST('' AS VARCHAR(250)) AS distributivoOferta, @idPeriodoAcademico AS idPeriodoAcademico,
           CAST('' AS VARCHAR(150)) AS periodoAcademico, tc.horasClases AS asignadas,
           0 AS idActividadPersonal
    FROM TotalClases tc
);
GO
--version optimizada para procedimientos almacenados

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
               SELECT sa.id_seguimiento_actividad, apd.codigo, apd.descripcion AS actividad,
                      sa.horas, adde.descripcion AS detalle, adde.codigo AS codigoDetalle,
                      sa.productos, sa.avance, apd.abreviatura
               FROM aca.seguimiento_actividad sa
               INNER JOIN aca.actividad_personal_docente apd ON apd.id_actividad_personal = sa.id_tipo_actividad
               INNER JOIN aca.actividad_docente_detalle adde ON adde.id_actividad_detalle = sa.id_actividad_detalle
               WHERE sa.estado = 'A' AND apd.estado = 'A' AND adde.estado = 'A'
                 AND sa.id_docente = d.id_docente AND sa.id_periodo_academico = @id_periodo_academico
                 AND sa.fecha_cumplimiento >= @fechaInicio AND sa.fecha_cumplimiento < @fechaFin
               FOR JSON PATH
           ) AS actividades,

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