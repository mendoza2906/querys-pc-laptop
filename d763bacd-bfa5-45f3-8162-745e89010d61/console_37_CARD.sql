use bd_sga_upse

select * from card.actividad

select * from card.deporte
select * from aca.tipo_estado_estudiante

select * from card.deporte_responsable


select d.*,p.apellidos,p.nombres from card.deporte d
inner join card.deporte_responsable dr on d.id_deporte = dr.id_deporte
inner join man.personas p on dr.id_persona = p.id

exec [card].[sp_get_horarios_comunes] 'ATLETISMO',4

select * from man.horario_comun hc

select * from  aca.dia

select * from card.fn_obtener_horarios_por_deporte(4)
select * from card.fn_obtener_horarios_por_deporte(22)

select * from card.reserva_card where id_cupo_rutina_horario in (18615,18616)

select * from card.cupo_rutina_horario where id in (18615,18616)

select  
             crh.id as id, 
             rh.id_rutina as idrutina, 
             rh.fecha as fecha, 
             convert(varchar, rh.hora_inicio, 8) as inicio, 
             convert(varchar, rh.hora_fin, 8) as fin, 
             crh.cantidad as cupos, 
             rh.codigo as codigo, 
             c.descripcion as campus 
             from card.cupo_rutina_horario crh 
             inner join card.rutina_horario rh on crh.id_rutina_horario = rh.id 
             left join aca.campus c on rh.id_campus = c.id_campus 
--              where crh.estado = 'A' and rh.estado = 'A'
--              and crh.visible = 1
             order by rh.fecha, rh.hora_inicio

select * from card.reserva_card

exec [card].[sp_get_mis_reservas] 323, null

select top 100 * from man.personas where imagen is  null

select foto from man.personas where foto is not null

select * from man.persona_imagen

select * from seg.usuarios where file_name is not null

select * from card.grupo_instrucciones

select * from card.tipo_instruccion

select * from card.instrucciones

select * from card.deporte_grupo_instrucciones


select * from card.deporte where secondary_text is not null

select * from aca.planificacion_paralelo_detalle
select * from man.documentos_archivos
-- /opt/tomcat/apache-tomcat-9.0.78/tmp/disciplinas-deportivas/basket.jpg
-- /opt/tomcat/apache-tomcat-9.0.78/tmp/disciplinas-deportivas/fut.jpg
-- /opt/tomcat/apache-tomcat-9.0.78/tmp/disciplinas-deportivas/musculacion.png
-- /opt/tomcat/apache-tomcat-9.0.78/tmp/disciplinas-deportivas/formacion.jpg
-- /opt/tomcat/apache-tomcat-9.0.78/tmp/disciplinas-deportivas/natacion.jpg
-- /opt/tomcat/apache-tomcat-9.0.78/tmp/disciplinas-deportivas/atletismo.jpg
-- /opt/tomcat/apache-tomcat-9.0.78/tmp/disciplinas-deportivas/opengym.jpeg
-- /opt/tomcat/apache-tomcat-9.0.78/tmp/disciplinas-deportivas/taekwondo.jpg
-- /opt/tomcat/apache-tomcat-9.0.78/tmp/disciplinas-deportivas/zumba.jpeg
-- /opt/tomcat/apache-tomcat-9.0.78/tmp/disciplinas-deportivas/defensa-personal.jpg


select * from man.opciones where descripcion like '%estadisticas-casd%'
select * from man.opciones where url like '%estadisticas-casd%'

select d.id_deporte,d.codigo,d.nombre,d.descripcion,d.primary_text,d.secondary_text,d.color,d.imagen,concat(p.nombres,' ',p.apellidos) as entrenador from card.deporte d
inner join card.deporte_responsable dr on d.id_deporte = dr.id_deporte
inner join man.personas p on dr.id_persona = p.id
where d.estado='A' and dr.estado='A' and p.estado='AC'
order by d.orden

select * from card.fn_get_all_sports_enabled(null,null)
select * from card.fn_obtener_horarios_por_deporte(21)

select * from card.deporte_responsable
select * from card.deporte where secondary_text is not null


begin
    declare @idPersona int = null,@idDeporte int = null
    if @idPersona is not null
    begin

    select d.id_deporte as idDeporte,d.codigo,d.nombre as deporte,d.descripcion,d.primary_text as primaryText,d.secondary_text as secondaryText,
           d.color,d.imagen,'URL' as tipoImagen,p.id as idPersona, concat(p.nombres,' ',p.apellidos) as entrenador,
           iif((select count(*)  from card.deporte_grupo_instrucciones dgi where dgi.estado='A' and dgi.id_deporte=d.id_deporte )>0,1,0) as tieneIndicaciones,
           iif((select count(*) from card.fn_obtener_horarios_por_deporte(d.id_deporte))>0,1,0) as tieneHorario,
           CASE WHEN dr.fecha_inicio > GETDATE() THEN 'PROXIMAMENTE' WHEN dr.fecha_inicio >= DATEADD(DAY, -7, GETDATE()) THEN 'NUEVO' ELSE NULL  END AS estado_novedad,
           iif(p.sexo='F','INSTRUCTORA','INSTRUCTOR') as instructorText,dr.observacion as lugar,
           iif((select count(*)  from card.planificacion_deportiva pd
                                          INNER JOIN card.planificacion_deportiva_agenda pda ON pd.id_planificacion_deportiva = pda.id_planificacion_deportiva
                                          inner join card.planificacion_deportiva_agenda_detalle pdad on pda.id_planificacion_deportiva_agenda = pdad.id_planificacion_deportiva_agenda
                where pd.estado='A' and pdad.estado='A' and pda.estado='A'  AND pda.fecha = cast(getdate() as date) and pd.id_deporte=d.id_deporte )>0,1,0) as tienePlanificacion
    from card.deporte d
             inner join card.deporte_responsable dr on d.id_deporte = dr.id_deporte
             inner join man.personas p on dr.id_persona = p.id
    where d.estado='A' and dr.estado='A' and p.estado='AC'
      and (p.id = @idPersona or @idPersona is null) and (d.id_deporte= @idDeporte or @idDeporte is null)
      and (dr.fecha_fin is null or dr.fecha_fin>cast(getdate() as date))
    order by d.orden
    end
    else
    begin
        SELECT
            d.id_deporte AS idDeporte, d.codigo,d.nombre AS deporte,d.descripcion, d.primary_text AS primaryText,d.secondary_text AS secondaryText,
            d.color,d.imagen,'URL' AS tipoImagen,null as idPersona,
            --Entrenadores agrupados
            isnull(STUFF((
                      SELECT ', ' + CONCAT(p2.nombres, ' ', p2.apellidos)
                      FROM card.deporte_responsable dr2
                               INNER JOIN man.personas p2 ON dr2.id_persona = p2.id
                      WHERE dr2.id_deporte = d.id_deporte AND dr2.estado = 'A' AND p2.estado = 'AC' AND (dr2.fecha_fin IS NULL OR dr2.fecha_fin > CAST(GETDATE() AS DATE))
                      FOR XML PATH(''), TYPE
                  ).value('.', 'NVARCHAR(MAX)'), 1, 2, ''),'INSTRUCTOR') AS entrenador,
            IIF((
                    SELECT COUNT(*)
                    FROM card.deporte_grupo_instrucciones dgi
                    WHERE dgi.estado='A'
                      AND dgi.id_deporte=d.id_deporte
                ) > 0, 1, 0) AS tieneIndicaciones,
            IIF((
                    SELECT COUNT(*)
                    FROM card.fn_obtener_horarios_por_deporte(d.id_deporte)
                ) > 0, 1, 0) AS tieneHorario,
            CASE
                WHEN d.fecha_inicio > GETDATE() THEN 'PROXIMAMENTE'
                WHEN d.fecha_inicio >= DATEADD(DAY, -7, GETDATE()) THEN 'NUEVO'
                ELSE NULL
                END AS estado_novedad,
            --Texto dinámico instructor / instructores
            isnull(CASE
                WHEN (
                         SELECT COUNT(*)
                         FROM card.deporte_responsable dr2
                                  INNER JOIN man.personas p2 ON dr2.id_persona = p2.id
                         WHERE dr2.id_deporte = d.id_deporte AND dr2.estado = 'A' AND p2.estado = 'AC' AND (dr2.fecha_fin IS NULL OR dr2.fecha_fin > CAST(GETDATE() AS DATE))
                     ) > 1 THEN 'ENTRENADORES'
                ELSE
                    (SELECT TOP 1
                         CASE WHEN p2.sexo = 'F' THEN 'INSTRUCTORA' ELSE 'INSTRUCTOR' END
                     FROM card.deporte_responsable dr2
                              INNER JOIN man.personas p2 ON dr2.id_persona = p2.id
                     WHERE dr2.id_deporte = d.id_deporte AND dr2.estado = 'A' AND p2.estado = 'AC' AND (dr2.fecha_fin IS NULL OR dr2.fecha_fin > CAST(GETDATE() AS DATE))
                    )
                END,'NO HAY UN ENTRENADOR REGISTRADO') AS instructorText,
            'UPSE' AS lugar,
            IIF((
                    SELECT COUNT(*)
                    FROM card.planificacion_deportiva pd
                             INNER JOIN card.planificacion_deportiva_agenda pda
                                        ON pd.id_planificacion_deportiva = pda.id_planificacion_deportiva
                             INNER JOIN card.planificacion_deportiva_agenda_detalle pdad
                                        ON pda.id_planificacion_deportiva_agenda = pdad.id_planificacion_deportiva_agenda
                    WHERE pd.estado='A'
                      AND pdad.estado='A'
                      AND pda.estado='A'
                      AND pda.fecha = CAST(GETDATE() AS DATE)
                      AND pd.id_deporte=d.id_deporte
                ) > 0, 1, 0) AS tienePlanificacion
        FROM card.deporte d
        WHERE d.estado='A'
          AND (d.fecha_fin IS NULL OR d.fecha_fin > CAST(GETDATE() AS DATE))
        AND (d.id_deporte = @idDeporte OR @idDeporte IS NULL)
        ORDER BY d.orden
    end
end

select * from card.rutina_horario
select * from card.cupo_rutina_horario where id_rutina_horario in (19941,20017,20056,20095,20139,20177)
select * from card.rutina
select * from card.deporte where secondary_text is not null
select * from man.personas where identificacion='0923403794'
select * from card.deporte_responsable
select * from man.horario_comun

select * from card.reserva_card where usuario_ing='2400254286'

select * from aca.periodo_academico_oferta where id_periodo_academico = 130

select * from card.fn_validate_cruce_horarios_sport(323,1,'2026-01-14')

exec [card].[sp_get_reservas] 'MUSCULACION','11:00:00','12:00:00','2026-01-15','2026-01-15'
exec [card].[sp_get_mis_reservas] 323,null
-- select * from card.reserva_card res where res.asistio= 1 and estado_reserva='RESERVADO'

select * from card.reserva_card res where usuario_ing='2400254286'

begin
    select ofa.carrera,eo.id_oferta_modalidad,
--            res.fecha   as fechaReserva,convert(varchar, rh.hora_inicio, 8)  as inicio, convert(varchar, rh.hora_fin, 8)  as fin,
           rh.codigo   as disciplina,count(res.fecha) as vecesAsistidas,
           per.identificacion,concat(per.apellidos, ' ', per.nombres) as persona,isnull(per.email_institucional,per.email_personal) as email,per.celular,iif(per.sexo='F','MUJER','HOMBRE') as sexo,
           em.id_nivel as semestre
    from card.reserva_card res
    inner join card.cupo_rutina_horario crh on res.id_cupo_rutina_horario = crh.id
    inner join card.rutina_horario rh on crh.id_rutina_horario = rh.id
    inner join man.personas per on res.id_persona = per.id
    inner join aca.estudiante_oferta eo on eo.id_persona = per.id
    inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
    inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
    where res.estado != 'I' and rh.codigo='NATACION' and ofa.id_departamento = 5 and mg.id_periodo_academico = 136 and em.estado='A' and YEAR( res.fecha) in ('2026','2025')
    and res.asistio= 1
    group by ofa.carrera, eo.id_oferta_modalidad, rh.codigo, per.identificacion, per.apellidos, per.nombres, per.email_institucional, per.email_personal, per.celular, per.sexo, em.id_nivel
    order by vecesAsistidas desc
end


select * from card.membresia

select * from man.horario_comun

select * from aca.espacio_fisico

SELECT * FROM card.ufn_obtener_rutina_diaria(3, '2026-02-03')
ORDER BY orden ASC;

select * from card.fn_get_all_sports_enabled(null,null)

select dd.* from card.planificacion_deportiva_agenda d
        inner join card.planificacion_deportiva pd on d.id_planificacion_deportiva = pd.id_planificacion_deportiva
         inner join card.planificacion_deportiva_agenda_detalle dd on d.id_planificacion_deportiva_agenda = dd.id_planificacion_deportiva_agenda
         where d.fecha='2026-02-04' and pd.id_deporte = 5

select * from card.planificacion_deportiva_agenda_detalle

    SELECT b.habilitado, b.tipo_incentivo, s.nombre as nombre_semana
    FROM card.semana_actividades s
    LEFT JOIN card.beneficiario b ON s.id_semana = b.id_semana AND b.id_persona = 323
    WHERE
        CAST(GETDATE() AS DATE) BETWEEN s.fecha_inicio AND s.fecha_fin
      AND s.estado = 'A';




CREATE OR ALTER PROCEDURE card.usp_procesar_incentivos_semanales
AS
BEGIN
    SET NOCOUNT ON;
    SET DATEFIRST 1; -- Lunes = 1

    ---------------------------------------------------------
    -- 1. IDENTIFICAR SEMANAS (ANTERIOR Y ACTUAL)
    ---------------------------------------------------------
    DECLARE @id_semana_anterior INT;
    DECLARE @fecha_inicio_ant DATE, @fecha_fin_ant DATE;

    DECLARE @id_semana_actual INT;

    -- Buscamos la semana anterior (basado en ayer domingo)
    SELECT @id_semana_anterior = id_semana,
           @fecha_inicio_ant = fecha_inicio,
           @fecha_fin_ant = fecha_fin
    FROM card.semana_actividades
    WHERE CAST(DATEADD(day, -1, GETDATE()) AS DATE) BETWEEN fecha_inicio AND fecha_fin;

    -- Buscamos la semana actual (basado en hoy lunes)
    SELECT @id_semana_actual = id_semana
    FROM card.semana_actividades
    WHERE CAST(GETDATE() AS DATE) BETWEEN fecha_inicio AND fecha_fin;

    -- Si no encontramos configuración de semanas, detenemos el proceso
    IF @id_semana_anterior IS NULL OR @id_semana_actual IS NULL
        BEGIN
            RAISERROR('No se encontraron semanas configuradas en card.semana_actividades para la fecha actual.', 16, 1);
            RETURN;
        END

    ---------------------------------------------------------
    -- 2. CALCULAR Y GUARDAR
    ---------------------------------------------------------
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Limpiamos la semana actual por si se re-ejecuta el job
        DELETE FROM card.beneficiario WHERE id_semana = @id_semana_actual;

        -- Insertamos los ganadores
        INSERT INTO card.beneficiario
        (id_persona, id_semana, dias_asistidos, habilitado, tipo_incentivo)
        SELECT
            resumen.id_persona,
            @id_semana_actual, -- Se le asigna el premio para ESTA semana
            resumen.total_dias,
            1 AS habilitado,   -- TRUE porque cumplió la meta
            CASE
                WHEN resumen.total_dias >= 6 THEN 'PLUS'      -- 120% (Lunes a Sábado)
                ELSE 'ESTANDAR'                               -- 100% (5 días)
                END AS tipo_incentivo
        FROM (
                 -- Subconsulta de conteo de asistencia de la semana ANTERIOR
                 SELECT
                     rc.id_persona,
                     COUNT(DISTINCT rh.fecha) as total_dias
                 FROM card.rutina_horario rh
                          INNER JOIN card.cupo_rutina_horario crh ON rh.id = crh.id_rutina_horario
                          INNER JOIN card.reserva_card rc ON rc.id_cupo_rutina_horario = crh.id
                 WHERE
                     rh.fecha BETWEEN @fecha_inicio_ant AND @fecha_fin_ant
                   AND rh.estado = 'A'
                   AND rc.estado = 'A'
                   AND rc.codigo != 'CANCELADO'
                   AND rc.asistio = 1 -- OJO: Solo cuenta si asistió
                 GROUP BY rc.id_persona
             ) as resumen
        WHERE resumen.total_dias >= 5; -- REGLA: Mínimo 5 días para ganar

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMsg, 16, 1);
    END CATCH
END;
GO

select * from card.beneficiario

select * from card.deporte

select * from card.semana_actividades

select * from card.tipo_incentivo

select * from card.beneficiario_incentivo

-- DBCC CHECKIDENT ('card.entrega_incentivo', RESEED, 0);
select * from card.entrega_incentivo

select * from card.fn_get_all_sports_enabled(null,null)

select * from card.fn_get_all_beneficiarios_by_week(null,5,null)


