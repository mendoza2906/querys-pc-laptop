use bd_sga_upse

select * from aca.informe_configuracion

select * from aca.informe_mensual
select * from aca.informe_seguimiento
-- insert into aca.informe_mensual
 begin
SELECT distinct 4,d.id_docente,12,concat('INFORME ',p.identificacion,' - ',p.apellidos,' ',p.nombres , ' - JULIO 2026') as descripcion,
                null,'A',0,getdate(),getdate(),p.identificacion,p.identificacion

FROM aca.distributivo_oferta dio
         INNER JOIN aca.periodo_academico_oferta pao ON pao.id_periodo_academico_oferta = dio.id_periodo_academico_oferta
         inner join aca.periodo_academico pa on pa.id_periodo_academico = pao.id_periodo_academico
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = pao.id_oferta_modalidad
         INNER JOIN aca.distributivo_docente ddo ON ddo.id_distributivo_oferta = dio.id_distributivo_oferta
         inner join aca.distributivo_dedicacion dde on ddo.id_distributivo_docente = dde.id_distributivo_docente
         inner join aca.docente_dedicacion dode on dde.id_docente_dedicacion = dode.id_docente_dedicacion
         inner join aca.docente_categoria dca on dca.id_docente_categoria =dde.id_docente_categoria
         inner join aca.docente d on ddo.id_docente=d.id_docente
         inner join man.personas p on d.id_persona=p.id
         inner join seg.usuarios u on p.id = u.persona_id
         left join aca.informe_mensual im on im.id_docente = d.id_docente and im.id_informe_configuracion = 4  and im.estado='A'
WHERE
    ddo.estado='A'   AND dio.estado IN ('A','V','D') AND pao.estado='A' and u.estado='AC'
  and dde.estado='A' and pao.id_periodo_academico=136 and im.id_informe_mensual is null
  AND dio.id_distributivo_oferta IN (SELECT id_distributivo_oferta
                                     FROM aca.fn_distributivo_oferta_max(136, 'A'))


end

select * from aca.informe_seguimiento
select * from aca.actividad_docente_detalle ado
begin
    declare @idInformeConfiguracion int = 6, @id_periodo_academica  int = 136,@codigoActividad varchar(25)='I.29.02',@actividad varchar(50)='INVESTIGACIÓN '
--     declare @idInformeConfiguracion int = 5, @id_periodo_academica  int = 136, @codigoActividad varchar(25)='V.32.02',@actividad varchar(50)='VINCULACIÓN '
-- insert into aca.informe_mensual
SELECT distinct @idInformeConfiguracion,d.id_docente,12,concat('INFORME ',@actividad,p.identificacion,' - ',p.apellidos,' ',p.nombres , ' - JULIO 2026') as descripcion,
                null,'A',0,getdate(),getdate(),p.identificacion,p.identificacion
--                 ,p.apellidos,p.nombres,ado.codigo,ado.descripcion

FROM aca.distributivo_oferta dio
         INNER JOIN aca.periodo_academico_oferta pao ON pao.id_periodo_academico_oferta = dio.id_periodo_academico_oferta
         inner join aca.periodo_academico pa on pa.id_periodo_academico = pao.id_periodo_academico
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = pao.id_oferta_modalidad
         INNER JOIN aca.distributivo_docente ddo ON ddo.id_distributivo_oferta = dio.id_distributivo_oferta
         inner join aca.distributivo_dedicacion dde on ddo.id_distributivo_docente = dde.id_distributivo_docente
         inner join aca.docente_dedicacion dode on dde.id_docente_dedicacion = dode.id_docente_dedicacion
         inner join aca.docente_categoria dca on dca.id_docente_categoria =dde.id_docente_categoria
         inner join aca.docente d on ddo.id_docente=d.id_docente
         inner join man.personas p on d.id_persona=p.id
         inner join seg.usuarios u on p.id = u.persona_id
         inner join aca.docente_actividad da on ddo.id_distributivo_docente = da.id_distributivo_docente
         inner join aca.actividad_docente_detalle ado on da.id_actividad_detalle = ado.id_actividad_detalle
         left join aca.informe_mensual im on im.id_docente = d.id_docente and im.id_informe_configuracion = @idInformeConfiguracion  and im.estado='A'
WHERE
    ddo.estado='A'   AND dio.estado IN ('A','V','D') AND pao.estado='A' and u.estado='AC' and da.estado='A' and ado.estado='A'
  and ado.codigo=@codigoActividad
  and dde.estado='A' and pao.id_periodo_academico=@id_periodo_academica and im.id_informe_mensual is null
  AND dio.id_distributivo_oferta IN (SELECT id_distributivo_oferta
                                     FROM aca.fn_distributivo_oferta_max(@id_periodo_academica, 'A'))
end

-- insert into aca.informe_seguimiento
SELECT distinct im.id_informe_mensual,104 as id_proceso_etapa_rol,41 as id_tipo_proceso_estado,null,'A',0,getdate(),getdate(),p.identificacion,p.identificacion
FROM aca.distributivo_oferta dio
         INNER JOIN aca.periodo_academico_oferta pao ON pao.id_periodo_academico_oferta = dio.id_periodo_academico_oferta
         inner join aca.periodo_academico pa on pa.id_periodo_academico = pao.id_periodo_academico
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = pao.id_oferta_modalidad
         INNER JOIN aca.distributivo_docente ddo ON ddo.id_distributivo_oferta = dio.id_distributivo_oferta
         inner join aca.distributivo_dedicacion dde on ddo.id_distributivo_docente = dde.id_distributivo_docente
         inner join aca.docente_dedicacion dode on dde.id_docente_dedicacion = dode.id_docente_dedicacion
         inner join aca.docente_categoria dca on dca.id_docente_categoria =dde.id_docente_categoria
         inner join aca.docente d on ddo.id_docente=d.id_docente
         inner join man.personas p on d.id_persona=p.id
         inner join seg.usuarios u on p.id = u.persona_id
         inner join aca.informe_mensual im on im.id_docente = d.id_docente and im.id_informe_configuracion= 4 and im.estado='A'
         left join aca.informe_seguimiento ise on ise.id_informe_mensual = im.id_informe_mensual and ise.estado='A' and ise.id_proceso_etapa_rol=104
WHERE
    ddo.estado='A'   AND dio.estado IN ('A','V','D') AND pao.estado='A' and u.estado='AC'
  and dde.estado='A' and pao.id_periodo_academico=136 and ise.id_informe_seguimiento is null
  AND dio.id_distributivo_oferta IN (SELECT id_distributivo_oferta
                                     FROM aca.fn_distributivo_oferta_max(136, 'A'))

----consultas de proyectos
begin
    declare @idPersona int = 886
select ip.id_informacion_proyecto as idProyecto,ip.codigo,ip.titulo,'CODIRECTOR' as rol,tc.descripcion,ip.inicio as fechaInicio,ip.fin as fechaFin,
       CASE
           WHEN ip.inicio IS NOT NULL   AND CAST(GETDATE() AS DATE) < CAST(ip.inicio AS DATE)  THEN 'Por iniciar'
           WHEN ip.fin IS NOT NULL AND CAST(GETDATE() AS DATE) > CAST(ip.fin AS DATE) THEN 'Finalizado'
           WHEN ip.inicio IS NOT NULL AND ip.fin IS NOT NULL AND CAST(GETDATE() AS DATE) BETWEEN CAST(ip.inicio AS DATE) AND CAST(ip.fin AS DATE) THEN 'En Ejecución'
           WHEN ip.inicio IS NULL AND ip.fin IS NOT NULL  AND CAST(GETDATE() AS DATE) <= CAST(ip.fin AS DATE) THEN 'En Ejecución'
           WHEN ip.inicio IS NOT NULL  AND ip.fin IS NULL AND CAST(GETDATE() AS DATE) >= CAST(ip.inicio AS DATE) THEN 'En Ejecución'
           ELSE ISNULL(tep.nombre, 'Sin estado') END AS estadoProyecto
from sgai.proyecto_codirector pc
         inner join sgai.informacion_proyecto ip on pc.id_proyecto = ip.id_informacion_proyecto
         inner join sgai.tipo_estado_proyecto tep ON tep.id_tipo_estado_proyecto = ip.id_tipo_estado_proyecto
         inner join sgai.tipo_colaboracion tc on tc.id_tipo_colaboracion = pc.id_tipo_colaboracion
where pc.id_persona = @idPersona and pc.estado='A'
union
select ip.id_informacion_proyecto as idProyecto,ip.codigo,ip.titulo,'DIRECTOR' as rol,tc.descripcion,ip.inicio as fechaInicio,ip.fin as fechaFin,
       CASE
           WHEN ip.inicio IS NOT NULL   AND CAST(GETDATE() AS DATE) < CAST(ip.inicio AS DATE)  THEN 'Por iniciar'
           WHEN ip.fin IS NOT NULL AND CAST(GETDATE() AS DATE) > CAST(ip.fin AS DATE) THEN 'Finalizado'
           WHEN ip.inicio IS NOT NULL AND ip.fin IS NOT NULL AND CAST(GETDATE() AS DATE) BETWEEN CAST(ip.inicio AS DATE) AND CAST(ip.fin AS DATE) THEN 'En Ejecución'
           WHEN ip.inicio IS NULL AND ip.fin IS NOT NULL  AND CAST(GETDATE() AS DATE) <= CAST(ip.fin AS DATE) THEN 'En Ejecución'
           WHEN ip.inicio IS NOT NULL  AND ip.fin IS NULL AND CAST(GETDATE() AS DATE) >= CAST(ip.inicio AS DATE) THEN 'En Ejecución'
           ELSE ISNULL(tep.nombre, 'Sin estado') END AS estadoProyecto
from sgai.proyecto_director pd
         inner join sgai.informacion_proyecto ip on pd.id_proyecto = ip.id_informacion_proyecto
         inner join sgai.tipo_estado_proyecto tep ON tep.id_tipo_estado_proyecto = ip.id_tipo_estado_proyecto
         inner join sgai.tipo_colaboracion tc on tc.id_tipo_colaboracion = pd.id_tipo_colaboracion
where pd.id_persona = @idPersona and pd.estado='A'
union
select ip.id_informacion_proyecto as idProyecto,ip.codigo,ip.titulo,'COLABORADOR' as rol,tc.descripcion,ip.inicio as fechaInicio,ip.fin as fechaFin,
       CASE
           WHEN ip.inicio IS NOT NULL   AND CAST(GETDATE() AS DATE) < CAST(ip.inicio AS DATE)  THEN 'Por iniciar'
           WHEN ip.fin IS NOT NULL AND CAST(GETDATE() AS DATE) > CAST(ip.fin AS DATE) THEN 'Finalizado'
           WHEN ip.inicio IS NOT NULL AND ip.fin IS NOT NULL AND CAST(GETDATE() AS DATE) BETWEEN CAST(ip.inicio AS DATE) AND CAST(ip.fin AS DATE) THEN 'En Ejecución'
           WHEN ip.inicio IS NULL AND ip.fin IS NOT NULL  AND CAST(GETDATE() AS DATE) <= CAST(ip.fin AS DATE) THEN 'En Ejecución'
           WHEN ip.inicio IS NOT NULL  AND ip.fin IS NULL AND CAST(GETDATE() AS DATE) >= CAST(ip.inicio AS DATE) THEN 'En Ejecución'
           ELSE ISNULL(tep.nombre, 'Sin estado') END AS estadoProyecto
from sgai.proyecto_persona pp
         inner join sgai.informacion_proyecto ip on pp.id_proyecto = ip.id_informacion_proyecto
         inner join sgai.tipo_estado_proyecto tep ON tep.id_tipo_estado_proyecto = ip.id_tipo_estado_proyecto
         inner join sgai.tipo_colaboracion tc on tc.id_tipo_colaboracion = pp.id_tipo_colaboracion
where pp.id_persona = @idPersona and pp.estado='A'
end

select distinct ip.*
from sgai.proyecto_director pd
        inner join man.personas p on p.id = pd.id_persona
         inner join sgai.informacion_proyecto ip on pd.id_proyecto = ip.id_informacion_proyecto
         inner join sgai.tipo_estado_proyecto tep ON tep.id_tipo_estado_proyecto = ip.id_tipo_estado_proyecto
         inner join sgai.tipo_colaboracion tc on tc.id_tipo_colaboracion = pd.id_tipo_colaboracion
where p.apellidos like '%DE LA O POZO%' and pd.estado='A'

begin
    DECLARE @idPersona INT = 886;
    DECLARE @hoy DATE = CAST(GETDATE() AS DATE);

    WITH participaciones AS
             (
                 SELECT pc.id_proyecto, pc.id_tipo_colaboracion, 'CODIRECTOR' AS rol
                 FROM sgai.proyecto_codirector pc
                 WHERE pc.id_persona = @idPersona AND pc.estado = 'A'

                 UNION ALL

                 SELECT pd.id_proyecto, pd.id_tipo_colaboracion, 'DIRECTOR' AS rol
                 FROM sgai.proyecto_director pd
                 WHERE pd.id_persona = @idPersona AND pd.estado = 'A'

                 UNION ALL

                 SELECT
                     pp.id_proyecto,
                     pp.id_tipo_colaboracion,
                     'COLABORADOR' AS rol
                 FROM sgai.proyecto_persona pp
                 WHERE pp.id_persona = @idPersona
                   AND pp.estado = 'A'
             )
    SELECT
        ip.id_informacion_proyecto AS idProyecto,  ip.codigo, ip.titulo as nombre, p.rol,ip.inicio AS fechaInicio, ip.fin AS fechaFin,
        CASE
            WHEN ip.inicio IS NOT NULL   AND ip.inicio >= DATEADD(DAY, 1, @hoy) THEN 'Por iniciar'
            WHEN ip.fin IS NOT NULL AND ip.fin < @hoy THEN 'Finalizado'
            WHEN ( ip.inicio IS NULL OR ip.inicio < DATEADD(DAY, 1, @hoy)) AND ( ip.fin IS NULL OR ip.fin >= @hoy) THEN 'En Ejecución'
            ELSE ISNULL(tep.nombre, 'Sin estado')
            END AS estadoProyecto
    FROM participaciones p
             INNER JOIN sgai.informacion_proyecto ip  ON ip.id_informacion_proyecto = p.id_proyecto
             INNER JOIN sgai.tipo_colaboracion tc ON tc.id_tipo_colaboracion = p.id_tipo_colaboracion
             LEFT JOIN sgai.tipo_estado_proyecto tep  ON tep.id_tipo_estado_proyecto = ip.id_tipo_estado_proyecto;
end

-- =========================================================================
-- CONSULTA 1: PROYECTOS DE INVESTIGACION
-- =========================================================================
SELECT
    proy.id AS idProyecto,
--     prog.nombre AS programa,
    proy.codigo AS codigo,
    proy.nombre AS nombre,'DIRECTOR' as rol,
    proy.fecha_inicio AS fechainicio,
    proy.fecha_fin AS fechafin,
    CASE
        WHEN CAST(GETDATE() AS DATE) <= DATEADD(DAY, 15, CAST(proy.fecha_fin AS DATE))
            THEN 'En Ejecución'
        ELSE 'Finalizado'
        END AS estadoProyecto

FROM vcc.proyecto proy
         INNER JOIN man.personas per  ON proy.id_persona = per.id
         INNER JOIN vcc.programa prog  ON proy.id_programa = prog.id
WHERE proy.estado = 'A' AND proy.id_persona = 886 AND proy.aprobado = 1
  and   YEAR(proy.fecha_inicio) <= YEAR(GETDATE()) AND YEAR(proy.fecha_fin) >= YEAR(GETDATE())
GROUP BY proy.id, prog.nombre,per.id, proy.codigo, proy.nombre, proy.fecha_inicio,  proy.fecha_fin

UNION ALL
SELECT
    proy.id AS idProyecto,
--     prog.nombre AS programa,
    proy.codigo AS codigo,
    proy.nombre AS nombre,'COLABORADOR' as rol,
    proy.fecha_inicio AS fechainicio,
    proy.fecha_fin AS fechafin,
    CASE
        WHEN CAST(GETDATE() AS DATE) <= DATEADD(DAY, 3, CAST(proy.fecha_fin AS DATE))
            THEN 'En Ejecución'
        ELSE 'Finalizado'
        END AS estadoProyecto

FROM vcc.proyecto proy
         INNER JOIN vcc.docente_proyecto docproy ON proy.id = docproy.id_proyecto
         INNER JOIN man.personas per  ON docproy.id_persona = per.id
         INNER JOIN vcc.programa prog ON proy.id_programa = prog.id
WHERE proy.estado = 'A'
  AND docproy.id_persona = 886
  AND proy.aprobado = 1
  and docproy.estado='A' and prog.estado='A'
  and   YEAR(proy.fecha_inicio) <= YEAR(GETDATE())
  AND YEAR(proy.fecha_fin) >= YEAR(GETDATE())
GROUP BY proy.id, prog.nombre, proy.cantidad_actividades, proy.codigo, proy.nombre, proy.fecha_inicio, proy.fecha_fin


SELECT
    im.id_informe_mensual,ise.id_informe_seguimiento, p.descripcion AS proceso, r.descripcion as rol,
    ic.id_actividad_personal_docente AS idActividadPersonalDocente,im.id_informe_mensual,da.id_documento_archivo,da.file_name
FROM pro.proceso p
         INNER JOIN pro.proceso_etapa pe ON pe.id_proceso = p.id_proceso
         INNER JOIN pro.proceso_etapa_rol per ON per.id_proceso_etapa = pe.id_proceso_etapa
         INNER JOIN seg.roles r ON r.id = per.id_rol
         INNER JOIN pro.etapa e ON e.id_etapa = pe.id_etapa
         INNER JOIN pro.etapa_calendario_mensual ec ON ec.id_proceso_etapa_rol = per.id_proceso_etapa_rol
         INNER JOIN aca.informe_configuracion ic ON ic.id_proceso = p.id_proceso AND ic.id_periodo = ec.id_periodo AND ic.mes = ec.mes
         inner join aca.informe_seguimiento ise on per.id_proceso_etapa_rol = ise.id_proceso_etapa_rol
         inner join aca.informe_mensual im on ise.id_informe_mensual = im.id_informe_mensual and im.id_informe_configuracion= ic.id_informe_configuracion
         LEFT JOIN man.documentos_archivos da ON da.id_number = ise.id_informe_seguimiento AND da.table_name = 'aca_informe_seguimiento' AND da.estado = 'A'
WHERE p.estado = 'A'  AND pe.estado = 'A' AND per.estado = 'A'
  AND e.estado = 'A' AND ec.estado = 'A' and ic.estado='A' and ise.estado='A' and im.estado='A'
  AND ec.id_periodo = 28 AND ec.mes = 6 and ic.id_actividad_personal_docente= 3 and im.id_docente = 64

select * from aca.fn_listar_docentes_asignaturas (null,null,136)

select * from aca.fn_listar_horas_laboradas_docente(136,12,null,null,6)

SELECT aca.fn_distribucion_docente_json(136,323,6) AS json

select * from aca.fn_listar_horas_laboradas_docente(136,5,134,null,6)

select * from aca.fn_listar_horas_laboradas_docente(136,null,null,null,6)


select * from aca.fn_listar_horas_laboradas_docente(136,7,116,null,6)



select * from aca.informe_mensual where id_informe_mensual = 25


SELECT * FROM aca.informe_seguimiento where id_informe_mensual = 25

-- update  aca.informe_mensual set id_actividad_personal_docente = 2


select * from man.documentos_archivos where table_name ='aca_informe_seguimiento'
-- select * from aca.fn_seguimiento_docentes_actividades(28,6,1152,'DOCENTE','INF-MENSUAL-ACT-DOC')
-- select * from aca.fn_seguimiento_docentes_actividades(28,6,1152,null,'INF-MENSUAL-ACT-DOC')
-- select * from aca.fn_seguimiento_docentes_actividades(28,6,1152,null,'INF-MENSUAL-ACT-DOC')


select * from [aca].[fn_get_actividad_asignada_docente_por_mes]( 136, 19629, 6)

select * from [aca].[fn_get_actividad_asignada_docente_por_mes]( 136, 3879, 6)

select * from  [aca].[fn_get_avance_actividades_docente_xmes](1076, 6, 136) ORDER BY orden

select * from aca.fn_listar_horas_laboradas_docente(136,5,38,null,6,2)

select * from aca.fn_listar_horas_laboradas_docente(136,null,20,null,7,2)

select * from aca.fn_listar_horas_laboradas_docente(136,null,96,326,7,2)

select * from aca.fn_listar_horas_laboradas_docente(136,null,null,null,7,2)

SELECT * FROM aca.fn_get_actividades_docente_por_mes( 136,452,7);

select * from aca.actividad_personal_docente


select * from aca.ofertas_facultad where id_tipo_oferta = 2

select sa.* from aca.seguimiento_actividad sa
                     inner join aca.docente d on d.id_docente = sa.id_docente
                     inner join man.personas p on d.id_persona = p.id
where p.identificacion='0960185593' and month(sa.fecha_cumplimiento)=7

select * from aca.actividad_docente_detalle

select * from man.personas where identificacion='2400254286'

select * from aca.seguimiento_actividad sa

select pii.* from man.persona_imagen pii
         inner join man.personas p on p.id =pii.id_persona
         where p.identificacion in ('2400239287','2450508250')

select * from aca.informe_mensual where id_docente = 1152 and id_informe_configuracion = 1

select * from aca.fn_get_calendario_informe_rol(28,7,'DIRECTOR')

select * from man.documentos_archivos where table_name ='aca_informe_seguimiento' and  month(fecha_ing) = 7

select * from aca.actividad_docente_detalle
select * from man.opciones where url like '%plan-seguimiento-actividad%'

select * from seg.roles where codigo ='DIRCENTROINVESTIGACION'

select * from pro.etapa_calendario_mensual
select * from pro.proceso_etapa_rol
select * from pro.proceso_etapa
select * from aca.informe_seguimiento where id_proceso_etapa_rol in (105,106)
select * from pro.etapa_calendario_mensual where id_proceso_etapa_rol   in (105,106)

-- delete  from aca.informe_seguimiento where id_proceso_etapa_rol in (105,106)

select * from seg.roles where id in (23,24,25,26,27,29,104)


select * from aca.fn_seguimiento_docentes_actividades(64,null,1)

select * from aca.fn_seguimiento_docentes_actividades(64,null,2)

select * from aca.fn_seguimiento_docentes_actividades(64,null,3)

select * from man.documentos_archivos where id_documento_archivo = 48512

SELECT * FROM aca.fn_get_clases_por_mes (136,1076 ,6)

SELECT * FROM aca.fn_get_clases_por_mes_2 (136,1076 ,6)

select * from [aca].fn_get_actividades_xcomponent_proyecto_vinc2(262,2273,1076,6)

select * from [aca].[fn_get_actividades_por_dedicacion](1076,3,136,6) ORDER BY fechaCumplimiento desc

select * from aca.fn_get_proyectos_persona(886,'INV') as d
union all
select * from aca.fn_get_proyectos_persona(886,'VINC') as d
order by fechaInicio

select * from aca.seguimiento_actividad where descripcion ='Adquisición de computadoras'

select * from aca.fn_get_componentes_proyecto(262,'VINC')
select * from aca.fn_get_componentes_proyecto(246,'INV')
select * from [aca].[fn_get_actividad_asignada_docente_por_mes]( 136, 14399, 6)

select * from [aca].fn_get_actividades_xcomponent_proyecto_inv2(232,355,1215,7)
select * from [aca].fn_get_actividades_xcomponent_proyecto_inv2(232,355,1215,7)
select * from aca.actividad_personal_docente

select * from aca.actividad_docente_detalle where descripcion like '%colaborador%'

select * from [aca].fn_get_actividades_xcomponent_proyecto_inv2(232,355,1215,7)
select * from [aca].fn_get_actividades_xcomponent_proyecto_vinc2(262,1496,1076,7)

--eliminar de ser posible
exec [aca].[sp_get_proyectos_dirigidos_tipo] 1076,1
SELECT distinct * FROM [aca].[fn_consultar_proyectos_investigacion] (1076)
exec [vcc].[sp_get_proyectos_dirigidos_directores_colaboradores] 1076
select  * from [vcc].[fn_get_components_proyectos](262)
select id_marco_logico as id, descripcion as descripcion  from [aca].[fn_get_components_proyectos](246)


select top 1000 * from aca.seguimiento_actividad
                  where month(fecha_ing)=7
order by id_seguimiento_actividad desc

select cp.* from aca.clase_proyectada cp
inner join aca.docente d on d.id_docente = cp.id_docente
where month(cp.fecha_ing)=7 and d.id_persona = 452

exec  aca.sp_registrar_clases_proyectadas 136, 1076, 7, '2400254286'

select * from [aca].fn_get_actividades_xcomponent_proyecto_inv2(246,1579,1076,6)
select * from [aca].fn_get_actividades_xcomponent_proyecto_vinc2(262,1496,1076,6)
select * from [aca].[fn_get_actividades_por_dedicacion_xproy](934,1076, 3, 136, 6, 246) ORDER BY fechaCumplimiento desc

SELECT aca.fn_distribucion_docente_json(136,  1255,7) AS json

select m.* from aca.malla m
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
where ofa.id_tipo_oferta =2 and m.id_nivel_max_aperturado <8


select * from aca.seguimiento_actividad

select * from sgai.proyecto_codirector
select * from sgai.proyecto_director
select * from sgai.proyecto_persona
select * from sgai.proyecto_persona_externa

select * from sgai.proyecto_externo_persona

select * from sgai.proyecto_externo_persona_externa

select * from sgai.informacion_proyecto_externo

select * from sgai.proyecto_externo_documento

select * from sgai.tipo_colaboracion

select * from sgai.informacion_proyecto

select * from vcc.proyecto

select * from vcc.docente_proyecto


select * from man.personas where identificacion = '1600494106'

-- DBCC CHECKIDENT ('aca.tipo_documento', RESEED, 205);

select * from aca.informe_mensual
--where observacion is not null
--2016
-- DBCC CHECKIDENT ('aca.informe_mensual', RESEED, 509);
select * from aca.informe_seguimiento
-- DBCC CHECKIDENT ('aca.informe_seguimiento', RESEED, 1014);
select * from aca.informe_configuracion

-- update aca.informe_seguimiento set id_informe_seguimiento_aux=id_informe_seguimiento

select * from pro.etapa_calendario_mensual

-- select ise.id_informe_seguimiento,da.*
-- -- update da set da.id_number = ise.id_informe_seguimiento
-- from man.documentos_archivos da
-- inner join aca.informe_seguimiento ise on ise.id_informe_seguimiento_aux= da.id_number
--     where da.table_name ='aca_informe_seguimiento'


select * from man.documentos_archivos da    where da.table_name ='aca_informe_seguimiento'

select * from aca.tipo_documento

select * from man.documentos_archivos where id_tipo_documento = 204

select * from man.documentos_ubicacion

select * from pro.etapa_calendario_mensual

select * from aca.periodo


select * from aca.docente_categoria
select * from aca.docente_dedicacion


select * from aca.actividad_personal_docente

select r.nombre,ad.descripcion,rad.* from aca.reglamento_actividad_docente rad
inner join aca.reglamento r on rad.id_reglamento = r.id_reglamento
inner join aca.actividad_personal_docente ad on ad.id_actividad_personal = rad.id_actividad_personal
where r.estado='A' and rad.estado='A' and r.id_tipo_reglamento

select * from aca.actividad_docente_detalle

select * from pro.unidad_tiempo

select * from pro.proceso_general

SELECT * FROM pro.etapa
-- DBCC CHECKIDENT ('pro.etapa', RESEED, 82);

select * from aca.docente where id_persona=1259
select * from man.opciones where id in (6)

-- DBCC CHECKIDENT ('man.opciones', RESEED, 869);

select  distinct per.id_proceso_etapa_rol,per.id_rol,pe.id_proceso_etapa,pe.id_proceso,p.descripcion,e.descripcion as etapa,e.codigo,pe.descripcion
-- p.*
from pro.proceso_etapa_rol per
inner join pro.proceso_etapa pe on per.id_proceso_etapa = pe.id_proceso_etapa
inner join pro.etapa e on pe.id_etapa = e.id_etapa
inner join pro.proceso p on pe.id_proceso = p.id_proceso

where p.estado='A' and pe.estado='A' and per.estado='A' and pe.id_proceso =15

select  distinct pe.id_proceso_etapa,pe.id_proceso,p.descripcion,e.descripcion as etapa,e.codigo,pe.descripcion
-- p.*
from pro.proceso_etapa pe
         inner join pro.etapa e on pe.id_etapa = e.id_etapa
         inner join pro.proceso p on pe.id_proceso = p.id_proceso

where p.estado='A' and pe.estado='A' and pe.id_proceso =16

select * from pro.proceso_etapa_rol

select * from seg.roles

select tp.* from pro.tipo_proceso tp
left join pro.proceso p on tp.id_tipo_proceso = p.id_tipo_proceso
where p.id_proceso is null

select * from pro.proceso where estado='I' or id_proceso IN  (15,16, 17)


select * from pro.tipo_proceso_estado

SELECT * FROM pro.proceso where id_proceso in (15,16, 17)

select * from pro.tipo_proceso

select * from pro.proceso_etapa where id_proceso in (15,16, 17)

select * from pro.proceso_etapa_rol

select * from pro.etapa
--     82
-- 45
-- 46
-- 49


select * from pro.vacante_asignatura

select * from aca.docente_dedicacion

select * from aca.seguimiento_actividad

select * from aca.docente where id_docente = 297

SELECT * FROM aca.informe_mensual_consolidado



select id,apellidos,nombres,identificacion from man.personas where id = 9398

select sa.* from aca.seguimiento_actividad sa
                     inner join aca.docente d on d.id_docente = sa.id_docente
where d.id_persona = 18444  and id_periodo_academico = 136 and sa.id_tipo_actividad = 2 and month(fecha_cumplimiento)=7