use bd_sga_upse;
-- 0603208117
select * from   Bd_Academico.dbo.TE_INSCRIPCIONES tins

select * from  Bd_Academico.dbo.MATERIA_PRE_INS

select * from Bd_Academico..MATERIAS_TOMADAS mt

select * from Sis..NOTAS

select * from oauth_access_token

select * from aca.malla

select  top 100 * from Bd_Academico..CALIFICACIONES

EXECUTE Bd_Academico..sp_historia_docente_upse '0603932450'
EXECUTE Bd_Academico..sp_historia_docente_upse '1003533310'

--ACTUALIZAR RECORD ASIGNATURA EL CAMPO RECORD OFERTA:
select  rm.id_record_oferta,ra.*
-- update ra set ra.id_record_oferta = rm.id_record_oferta
from mig.record_asignaturas ra
         inner join mig.record_matricula rm on ra.id_record_matricula = rm.id_record_matricula
where rm.id_record_oferta<>ra.id_record_oferta

select distinct  ro.carrera_original,ro.area,hd.carrera,hd.sede,hd.docente,ra.*
--     update ra set ra.fecha_mod = getdate(),ra.docente = hd.docente, ra.identificacion_docente=hd.identificacion
from mig.record_asignaturas ra
         inner join mig.record_oferta ro on ra.id_record_oferta = ro.id_record_oferta
         inner join aca.tipo_oferta tof on ro.id_tipo_oferta = tof.id_tipo_oferta
         inner join aca.nivel n on ra.id_nivel = n.id_nivel
         inner join mig.historial_docente hd on hd.asignatura = ra.asignatura and hd.curso = concat(n.descripcion_corta,'/',ra.id_paralelo) and ra.periodo=hd.periodo
    and tof.descripcion= hd.tipo_oferta
    and (concat(hd.carrera,iif(hd.sede='SEDE UPSE CANTON PLAYAS',' - PLAYAS',iif(hd.sede='MATRIZ-LA LIBERTAD',' - MATRIZ',hd.sede)))=ro.carrera
        or ro.carrera like concat(hd.carrera,'%') or ro.area like concat(hd.carrera,'%')
        or ro.carrera =iif(hd.sede='' +
                                   'SEDE UPSE CANTON PLAYAS' and hd.carrera='INGENIERIA INDUSTRIAL','INGENIERIA INDUSTRIAL - PLAYAS',
                           iif(hd.sede='MATRIZ-LA LIBERTAD' and hd.carrera='INGENIERIA INDUSTRIAL','INGENIERIA INDUSTRIAL - MATRIZ',hd.carrera)))
where ra.id_record_matricula is not null and identificacion_docente ='NO REGISTRA' and hd.periodo not in ('2022-1','2022-2','2022','2023-1','2023-2','2024','2024-1','2024-2')

select * from mig.historial_docente where tipo_oferta =''

select identificacion,count( distinct docente)from mig.historial_docente
group by identificacion
having count( distinct docente)>1

select ro.id_carrera_ofertada,ro.carrera,ra.* from mig.record_asignaturas ra
inner join mig.record_oferta ro on ro.id_record_oferta = ra.id_record_oferta
where cast(ra.fecha_mod as date)=cast(getdate() as date)

select *from mig.record_asignaturas ra where --ra.id_periodo_academico_cg = 16840-- and ra.id_paralelo = 2 and ra.id_nivel = 2
--                                          and
                                             ra.asignatura='INTRODUCCION A LA INGENIERIA INDUSTRIAL'

select ro.carrera,ra.* from mig.record_asignaturas ra
inner join mig.record_oferta ro on ra.id_record_oferta = ro.id_record_oferta
         where ra.id_record_matricula is not null and identificacion_docente ='NO REGISTRA'

select * from mig.historial_docente hd where hd.asignatura like '%ACUACULTURA%' and hd.periodo ='2014-1'

select * from mig.record_asignaturas where id_record_asignatura = 492062

select ra.* from mig.record_oferta ro
                     inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
where ro.identificacion='0923001564'

select * from  mig.record_oferta ro

select * from aca.nivel
select * from mig.oferta_correspondencia

select * from mig.historial_docente

select * from mig.oferta_conexion

select * from aca.tipo_oferta

select * from mig.record_oferta

select  * from mig.record_asignaturas where identificacion_docente in ('1803738580','0603932450','1309869723','1707326813')

select * from mig.record_asignaturas ra where ra.estado='A' and ra.identificacion_docente in ('1707326813')

select * from mig.historial_docente where identificacion='1707326813' and tipo_oferta <>'OTROS'

select * from mig.historial_docente where identificacion='1003533310'

EXECUTE Bd_Academico..sp_historia_docente_upse '0603932450'
EXECUTE Bd_Academico..sp_historia_docente_upse '1003533310'

select *from mig.record_asignaturas ra where ra.periodo = '2021-2' and ra.id_paralelo = 1 and ra.id_nivel = 6  and
    ra.asignatura='INGENIERIA DE METODOS' and ra.id_record_matricula is not null and identificacion_docente ='NO REGISTRA'


select p.id,p.identificacion,p.apellidos,p.nombres from man.personas p where p.identificacion in ('1803738580','0603932450','1309869723','1707326813')

select * from Bd_Academico..DC_HISTORIA_DOCENTE
select  * from mig.record_asignaturas where table_name='Bd_Academico.dbo.MATERIA_PRE_INS'

--seteear cursos correctos
select docente,tipo_oferta,asignatura,curso,len(curso) as long,
--     update hd set hd.curso =
       case when len(hd.curso)=6 then SUBSTRING(hd.curso, 4, 3)
            when len(hd.curso) in (4) and hd.curso like '%-%' and SUBSTRING(hd.curso, 1, 1)=0 then CONCAT('NIV/',SUBSTRING(hd.curso, 4, 1))
            when len(hd.curso) in (4) and hd.curso like '%-%' and SUBSTRING(hd.curso, 1, 1)<>0 then CONCAT(SUBSTRING(hd.curso, 1, 1),'/',SUBSTRING(hd.curso, 4, 1))
            when len(hd.curso) in (5) and hd.curso like '%-%' then CONCAT(SUBSTRING(hd.curso, 1, 2),'/',SUBSTRING(hd.curso, 5, 1))
            when len(hd.curso) in (7) and hd.curso like '%.%' then SUBSTRING(hd.curso, 4, 3)
            when len(hd.curso) in (7) and hd.curso like '%-%' and SUBSTRING(hd.curso, 1, 2)=11 then SUBSTRING(hd.curso, 5, 3)
            else hd.curso end --as curso_nuevo
from mig.historial_docente hd
where hd.curso is not null and hd.curso not like '%NIV%' and len(hd.curso)<>3 and len(hd.curso)<>4 and curso not in ('',' - ') and curso not in ('0- --Ninguno--','1- --Ninguno--','CARGA COMPLEMENTARIA')

-- delete from mig.historial_docente
-- DBCC CHECKIDENT ('mig.historial_docente', RESEED, 455);

-- delete from mig.historial_docente where id_historial_docente>455


EXECUTE Bd_Academico..sp_historia_docente_upse '0603932450'

EXECUTE Bd_Academico..sp_historia_docente_upse '1750397273'

EXECUTE Bd_Academico..sp_historia_docente_upse '1312849720'

select * from mig.historial_docente where identificacion='1721343166'

select * from mig.historial_docente where tipo_oferta is null or tipo_oferta =''


-- update  mig.historial_docente set tipo_oferta = 'PREGRADO' where tipo_oferta is null or tipo_oferta =''
-- update  mig.historial_docente set titulo = 'NO REGISTRA' where titulo is null or titulo =''
-- update  mig.historial_docente set curso = 'CARGA COMPLEMENTARIA' where curso  in ('0- --Ninguno--','1- --Ninguno--') or curso is null or curso ='' or curso =' - '
-- update  mig.historial_docente set abreviatura='NO REGISTA' where abreviatura is null or abreviatura =''


select count(id_historial_docente) from mig.historial_docente
-- exec [mig].[sp_migrate_historial_docente_sisweb] null
select * from mig.historial_docente
select identificacion,docente,count(id_historial_docente)from mig.historial_docente hd
where hd.curso<>''
group by identificacion, docente

select p.id,p.identificacion,p.apellidos,p.nombres from man.personas p
where p.estado='AC'
  and p.identificacion not in (select hd.identificacion from mig.historial_docente hd)
  and (p.identificacion in ('1312849720') or '1312849720' is null)

SELECT p.id, p.identificacion, p.apellidos, p.nombres
FROM man.personas p

WHERE p.estado = 'AC'
  AND p.identificacion IN
                    (
                        SELECT bp.identificacion
                        FROM bdupse.seg.personas bp


        );


-- DBCC CHECKIDENT ('mig.historial_docente', RESEED, 53820);
-- exec [mig].[sp_migrate_historial_docente_sisweb] null
ALTER PROCEDURE [mig].[sp_migrate_historial_docente_sisweb]
(
    @ceduladoc varchar(20) = NULL
)
    WITH
        EXECUTE AS CALLER
AS
BEGIN TRY

    BEGIN TRANSACTION;

    DECLARE @id_persona int,
        @identificacion varchar(100),
        @nombres varchar(250),
        @apellidos varchar(250),
        @registros_origen int,
        @registros_nuevos int,
        @docentes_procesados int = 0

    DECLARE @tempRecordAsignaturasTemporal TABLE
                                           (
                                               PERIODO NVARCHAR(10),
                                               TIPO_OFERTA NVARCHAR(50),
                                               DOCENTE NVARCHAR(75),
                                               ABR_TTN NVARCHAR(50),
                                               CARRERA NVARCHAR(2000),
                                               ASIGNATURA NVARCHAR(2000),
                                               CURSO NVARCHAR(50),
                                               CARGA_SEMANAL INT,
                                               titulo_tn NVARCHAR(1000),
                                               inicia DATE,
                                               finaliza DATE,
                                               sede VARCHAR(500)
                                           );

    /*==============================================================*/
    /* Obtener docentes a procesar                                  */
    /* Si se envía cédula, se procesa directamente                  */
    /* Si es NULL, se procesan los docentes con los roles indicados */
    /*==============================================================*/
    DECLARE cursorPersonas CURSOR LOCAL FAST_FORWARD FOR
--         SELECT p.id, p.identificacion, p.apellidos, p.nombres
--         FROM man.personas p
--         WHERE p.estado = 'AC'
--           AND
--             (
--                 (@ceduladoc IS NOT NULL AND p.identificacion = @ceduladoc)
--                     OR
--                 (
--                     @ceduladoc IS NULL
--                         AND p.identificacion IN
--                             (
--                                 SELECT bp.identificacion
--                                 FROM bdupse.seg.personas bp
--                             )
--                     )
--                 );
        select  p.id, p.identificacion, p.apellidos, p.nombres
        from pro.proceso_usuario2 pu
                 inner join pro.tipo_proceso_estado tpe on pu.id_tipo_proceso_estado = tpe.id_tipo_proceso_estado
                 inner join man.personas p on p.id = pu.id_persona
                 inner join pro.postulacion_vacante pv on pv.id_proceso_usuario = pu.id_proceso_usuario
                 inner join pro.proceso_vacante prv on prv.id_proceso_vacante = pv.id_proceso_vacante
                 inner join pro.vacante v on v.id_vacante = prv.id_vacante
                 inner join aca.docente_categoria dc on dc.id_docente_categoria = v.id_docente_categoria
                 inner join aca.oferta o on o.id_oferta = v.id_oferta
                 inner join aca.departamento_oferta dof on dof.id_oferta = o.id_oferta
                 inner join man.departamentos d on dof.id_departamento = d.id
                 inner join pro.proceso_etapa_ejecucion2 pee2 on pee2.id_proceso_usuario = pu.id_proceso_usuario
        where  pu.estado='A' and pv.estado='A' and prv.estado='A' and v.estado='A'
          and pee2.estado='A' and pee2.id_proceso_etapa = 1
          and pu.id_proceso_general = 105
        group by d.nombre,o.descripcion,v.asignatura,p.id,p.identificacion,p.apellidos,p.nombres,pu.id_proceso_usuario,v.id_docente_categoria,tpe.codigo,
                 pee2.id_proceso_etapa_ejecucion,p.email_institucional,email_personal,dc.descripcion,pee2.calificacion

    OPEN cursorPersonas

    FETCH NEXT FROM cursorPersonas INTO @id_persona, @identificacion, @apellidos, @nombres

    WHILE @@FETCH_STATUS = 0
        BEGIN

            SET @docentes_procesados = @docentes_procesados + 1
            SET @registros_origen = 0
            SET @registros_nuevos = 0

            DELETE FROM @tempRecordAsignaturasTemporal

            PRINT '============================================================'
            PRINT CONCAT('PROCESANDO DOCENTE: ', @identificacion, ' - ', @apellidos, ' ', @nombres)

            /*==============================================================*/
            /* Consultar historial del docente en SISWEB                    */
            /*==============================================================*/
            INSERT INTO @tempRecordAsignaturasTemporal
            (
                PERIODO,
                TIPO_OFERTA,
                DOCENTE,
                ABR_TTN,
                CARRERA,
                ASIGNATURA,
                CURSO,
                CARGA_SEMANAL,
                titulo_tn,
                inicia,
                finaliza,
                sede
            )
                EXECUTE Bd_Academico..sp_historia_docente_upse @identificacion

            SELECT @registros_origen = COUNT(*)
            FROM @tempRecordAsignaturasTemporal

            PRINT CONCAT('REGISTROS EN SISWEB: ', @registros_origen)

            /*==============================================================*/
            /* Insertar únicamente los registros que hacen falta            */
            /*==============================================================*/
            INSERT INTO mig.historial_docente
            (
                periodo,
                tipo_oferta,
                identificacion,
                docente,
                abreviatura,
                carrera,
                sede,
                asignatura,
                curso,
                carga_semanal,
                titulo,
                fecha_inicio,
                fecha_fin,
                estado,
                usuario_mod,
                fecha_mod
            )
            SELECT t.PERIODO, t.TIPO_OFERTA, @identificacion, t.DOCENTE, t.ABR_TTN, t.CARRERA, t.sede, t.ASIGNATURA,
                   c.curso_normalizado, t.CARGA_SEMANAL, t.titulo_tn, t.inicia, t.finaliza, 'A', '2400254286', NULL
            FROM @tempRecordAsignaturasTemporal t
                     CROSS APPLY
                 (
                     SELECT CASE
                                WHEN LEN(t.CURSO) = 6
                                    THEN SUBSTRING(t.CURSO, 4, 3)

                                WHEN LEN(t.CURSO) = 4
                                    AND t.CURSO LIKE '%-%'
                                    AND SUBSTRING(t.CURSO, 1, 1) = '0'
                                    THEN CONCAT('NIV/', SUBSTRING(t.CURSO, 4, 1))

                                WHEN LEN(t.CURSO) = 4
                                    AND t.CURSO LIKE '%-%'
                                    AND SUBSTRING(t.CURSO, 1, 1) <> '0'
                                    THEN CONCAT(SUBSTRING(t.CURSO, 1, 1), '/', SUBSTRING(t.CURSO, 4, 1))

                                WHEN LEN(t.CURSO) = 5
                                    AND t.CURSO LIKE '%-%'
                                    THEN CONCAT(SUBSTRING(t.CURSO, 1, 2), '/', SUBSTRING(t.CURSO, 5, 1))

                                WHEN LEN(t.CURSO) = 7
                                    AND t.CURSO LIKE '%.%'
                                    THEN SUBSTRING(t.CURSO, 4, 3)

                                WHEN LEN(t.CURSO) = 7
                                    AND t.CURSO LIKE '%-%'
                                    AND SUBSTRING(t.CURSO, 1, 2) = '11'
                                    THEN SUBSTRING(t.CURSO, 5, 3)

                                ELSE t.CURSO
                                END AS curso_normalizado
                 ) c
            WHERE NOT EXISTS
                      (
                          SELECT 1
                          FROM mig.historial_docente h
                          WHERE h.identificacion = @identificacion
                            AND ISNULL(h.periodo, '') = ISNULL(t.PERIODO, '')
                            AND ISNULL(h.tipo_oferta, '') = ISNULL(t.TIPO_OFERTA, '')
                            AND ISNULL(h.docente, '') = ISNULL(t.DOCENTE, '')
                            AND ISNULL(h.abreviatura, '') = ISNULL(t.ABR_TTN, '')
                            AND ISNULL(h.carrera, '') = ISNULL(t.CARRERA, '')
                            AND ISNULL(h.sede, '') = ISNULL(t.sede, '')
                            AND ISNULL(h.asignatura, '') = ISNULL(t.ASIGNATURA, '')
                            AND ISNULL(h.curso, '') = ISNULL(c.curso_normalizado, '')
                            AND ISNULL(h.carga_semanal, 0) = ISNULL(t.CARGA_SEMANAL, 0)
                            AND ISNULL(h.titulo, '') = ISNULL(t.titulo_tn, '')
                            AND ISNULL(h.fecha_inicio, CONVERT(date, '19000101')) =
                                ISNULL(t.inicia, CONVERT(date, '19000101'))
                            AND ISNULL(h.fecha_fin, CONVERT(date, '19000101')) =
                                ISNULL(t.finaliza, CONVERT(date, '19000101'))
                      );

            SET @registros_nuevos = @@ROWCOUNT

            IF @registros_nuevos > 0
                BEGIN
                    PRINT CONCAT('REGISTROS NUEVOS INSERTADOS: ', @registros_nuevos)
                END
            ELSE
                BEGIN
                    PRINT 'NO EXISTEN REGISTROS NUEVOS PARA MIGRAR'
                END

            FETCH NEXT FROM cursorPersonas INTO @id_persona, @identificacion, @apellidos, @nombres

        END

    CLOSE cursorPersonas
    DEALLOCATE cursorPersonas

    IF @docentes_procesados = 0
        BEGIN
            PRINT 'NO SE ENCONTRARON DOCENTES PARA PROCESAR'
        END
    ELSE
        BEGIN
            PRINT '============================================================'
            PRINT CONCAT('DOCENTES PROCESADOS: ', @docentes_procesados)
        END

    COMMIT TRANSACTION;

    PRINT 'TRANSACCION REALIZADA CON EXITO';

END TRY

BEGIN CATCH

    DECLARE @Error_Number int,
        @Error_Severity int,
        @Error_State int,
        @Error_Procedure varchar(1000),
        @Error_Line int,
        @Error_Message varchar(8000)

    SELECT @Error_Number = ERROR_NUMBER(),
           @Error_Severity = ERROR_SEVERITY(),
           @Error_State = ERROR_STATE(),
           @Error_Procedure = ERROR_PROCEDURE(),
           @Error_Line = ERROR_LINE(),
           @Error_Message = ERROR_MESSAGE()

    IF CURSOR_STATUS('local', 'cursorPersonas') >= 0
        CLOSE cursorPersonas

    IF CURSOR_STATUS('local', 'cursorPersonas') > -3
        DEALLOCATE cursorPersonas

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    PRINT CONCAT('ERROR NUMERO: ', @Error_Number)
    PRINT CONCAT('PROCEDIMIENTO: ', ISNULL(@Error_Procedure, ''))
    PRINT CONCAT('LINEA: ', @Error_Line)
    PRINT CONCAT('MENSAJE: ', @Error_Message)
    PRINT 'HA OCURRIDO UN ERROR. NO SE REALIZO LA TRANSACCION'

    RAISERROR(@Error_Message, @Error_Severity, @Error_State)

END CATCH
GO

--1253
select * from bdupse.seg.personas p where identificacion in (select identificacion from seg.usuarios u inner join bdupse.seg.usuarios_roles ur on u.id=ur.usuarios_id
                                                           where roles_id in (151,187))
and identificacion not in  (select pp.identificacion from man.personas pp where pp.estado='AC')
--  and   concat(p.apellidos, ' ',p.nombres) in (select concat(d.apellidos, ' ',d.nombres) from  man.personas d)
-- and identificacion not in (select  distinct historial_docente.identificacion from mig.historial_docente)

select * from mig.historial_docente
select * from mig.historial_docente_detalle
-- delete from mig.historial_docente_detalle

-- DBCC CHECKIDENT ('mig.historial_docente_detalle', RESEED, 8587);
--
--5761
begin
    declare @identificacion varchar(15)='1804570636'
    insert into mig.historial_docente_detalle
select ra.id_record_asignatura,ro.identificacion,concat(ro.apellidos,' ',ro.nombres) as estudiante,p.fecha_nace,isnull(ec.descripcion,'SOLTERO') as estado_civil,iif(p.sexo='F','FEMENINO','MASCULINO') as sexo,
       DATEDIFF(YEAR, p.fecha_nace, GETDATE()) - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, p.fecha_nace, GETDATE()), p.fecha_nace) > GETDATE() THEN 1 ELSE 0 END AS EdadActual,
       DATEDIFF(YEAR, p.fecha_nace, substring(ra.periodo,1,4)) AS EdadTomoAsignatura,
       ro.carrera,ra.periodo,ra.asignatura,concat(n.descripcion_corta,'/',par.descripcion_corta) as curso,ra.promedio,ra.estado_aprobacion as aprobadoFinal,
--        rc.ciclo,rc.calificacion,
       (select rc.calificacion from mig.record_calificaciones rc where rc.id_record_asignatura = ra.id_record_asignatura and rc.ciclo='CICLO 1') as ciclo1,0 as vecesActualizadasCiclo1,
       (select rc.calificacion from mig.record_calificaciones rc where rc.id_record_asignatura = ra.id_record_asignatura and rc.ciclo='CICLO 2') as ciclo2,0 as vecesActualizadasCiclo2,
       (select rc.calificacion from mig.record_calificaciones rc where rc.id_record_asignatura = ra.id_record_asignatura and rc.ciclo='CICLO 3') as ciclo3,
       (select rc.calificacion from mig.record_calificaciones rc where rc.id_record_asignatura = ra.id_record_asignatura and rc.ciclo='CICLO 4') as ciclo4,
       (select rc.calificacion from mig.record_calificaciones rc where rc.id_record_asignatura = ra.id_record_asignatura and rc.ciclo in ('MEJORAMIENTO','RECUPERACION')) as mejoramiento_recuperacion,
       null as vecesActualizadasRecuperacion,
       iif(((select avg(rc.calificacion) from mig.record_calificaciones rc where rc.id_record_asignatura = ra.id_record_asignatura and rc.ciclo not in ('MEJORAMIENTO','RECUPERACION'))>=70
           and ((select rc.calificacion from mig.record_calificaciones rc where rc.id_record_asignatura = ra.id_record_asignatura and rc.ciclo in ('MEJORAMIENTO','RECUPERACION')) is null
               or (select rc.calificacion from mig.record_calificaciones rc where rc.id_record_asignatura = ra.id_record_asignatura and rc.ciclo in ('MEJORAMIENTO','RECUPERACION'))=0 )
           or ra.estado_aprobacion='REPROBADO'),'NO','SI') as aprobo_mejoramiento_recuperacion,
       ra.identificacion_docente, ra.docente,'SISWEB' as origen,'A' as estado, getdate() as fecha_mod from mig.record_oferta ro
inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
-- inner join mig.record_calificaciones rc on rc.id_record_asignatura = ra.id_record_asignatura
inner join aca.nivel n on ra.id_nivel = n.id_nivel
inner join aca.paralelo par on ra.id_paralelo = par.id_paralelo
inner join man.personas p on p.identificacion = ro.identificacion
left join man.estado_civil ec on p.id_estado_civil = ec.id_estado_civil
-- where ra.identificacion_docente in ('1803738580','0603932450','1309869723','1707326813','0603208117')
where ra.identificacion_docente in (@identificacion)
and ra.estado='A' and ro.estado='A'
union all
    select ea.id_estudiante_asignatura,p.identificacion,concat(p.apellidos,' ',p.nombres) as estudiante, p.fecha_nace,
           isnull(ec.descripcion,'SOLTERO') as estado_civil,iif(p.sexo='F','FEMENINO','MASCULINO') as sexo,
       DATEDIFF(YEAR, p.fecha_nace, GETDATE()) -CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, p.fecha_nace, GETDATE()), p.fecha_nace) > GETDATE() THEN 1 ELSE 0 END AS EdadActual,
       DATEDIFF(YEAR, p.fecha_nace, substring(pa.codigo,1,4)) AS EdadTomoAsignatura,o.descripcion as carrera,pa.codigo as periodo,a.descripcion as asignatura,
       concat(n.descripcion_corta,'/',par.descripcion_corta) as curso,ea.promedio,
        iif(ea.aprobado= 1,'APROBADO','REPROBADO') as aprobadoFinal,
        (select ec.calificacion from aca.acta_calificacion ac
                inner join aca.ciclo c on ac.id_ciclo = c.id_ciclo
                inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
                inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
                inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                where ec.id_estudiante_oferta = eo.id_estudiante_oferta and  ac.id_malla_asignatura=ma.id_malla_asignatura and cg.id_periodo_academico =mg.id_periodo_academico
                  and ac.id_paralelo = ea.id_paralelo
                and (ca.codigo ='SUMA'  and c.codigo in ('CIC1'))
                and ac.estado in ('A','C') and ec.estado='A'
                ) as ciclo1,isnull((select count( distinct ec.id_estudiante_calificacion) from aca.acta_calificacion ac
                              inner join aca.ciclo c on ac.id_ciclo = c.id_ciclo
                              inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
                              inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
                              inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                                inner join aud.estudiante_calificacion ecc on ecc.id_estudiante_calificacion = ec.id_estudiante_calificacion
                              where ec.id_estudiante_oferta = eo.id_estudiante_oferta and  ac.id_malla_asignatura=ma.id_malla_asignatura
                                and cg.id_periodo_academico =mg.id_periodo_academico and ac.id_paralelo = ea.id_paralelo
                                and (ca.codigo ='SUMA'  and c.codigo in ('CIC1'))
                                and ac.estado in ('A','C') and ec.estado='A' and ecc.calificacion <>ec.calificacion
                ),0) as vecesActualizadasCiclo1, (select ec.calificacion from aca.acta_calificacion ac
                inner join aca.ciclo c on ac.id_ciclo = c.id_ciclo
                inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
                inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
                inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                where ec.id_estudiante_oferta = eo.id_estudiante_oferta and  ac.id_malla_asignatura=ma.id_malla_asignatura and cg.id_periodo_academico =mg.id_periodo_academico
                  and ac.id_paralelo = ea.id_paralelo
                and  (ca.codigo ='SUMA'  and c.codigo in ('CIC2'))
                and ac.estado in ('A','C') and ec.estado='A'
                ) as ciclo2,isnull((select count( distinct ec.id_estudiante_calificacion) from aca.acta_calificacion ac
                          inner join aca.ciclo c on ac.id_ciclo = c.id_ciclo
                          inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
                          inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
                          inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                          inner join aud.estudiante_calificacion ecc on ecc.id_estudiante_calificacion = ec.id_estudiante_calificacion
                         where ec.id_estudiante_oferta = eo.id_estudiante_oferta and  ac.id_malla_asignatura=ma.id_malla_asignatura
                           and cg.id_periodo_academico =mg.id_periodo_academico and ac.id_paralelo = ea.id_paralelo
                           and (ca.codigo ='SUMA'  and c.codigo in ('CIC2'))
                           and ac.estado in ('A','C') and ec.estado='A' and ecc.calificacion <>ec.calificacion
           ),0) as vecesActualizadasCiclo2,null as ciclo3, null ciclo4, (select ec.calificacion from aca.acta_calificacion ac
                inner join aca.ciclo c on ac.id_ciclo = c.id_ciclo
                inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
                inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
                inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                where ec.id_estudiante_oferta = eo.id_estudiante_oferta and  ac.id_malla_asignatura=ma.id_malla_asignatura and cg.id_periodo_academico =mg.id_periodo_academico
                  and ac.id_paralelo = ea.id_paralelo
                and (ca.codigo ='SUMATIVA'  and c.codigo in ('RECU') )
                and ac.estado in ('A','C') and ec.estado='A'

            ) as mejoramiento_recuperacion,(select count( distinct ec.id_estudiante_calificacion) from aca.acta_calificacion ac
                                    inner join aca.ciclo c on ac.id_ciclo = c.id_ciclo
                                    inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
                                    inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
                                    inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                                    inner join aud.estudiante_calificacion ecc on ecc.id_estudiante_calificacion = ec.id_estudiante_calificacion
                                    where ec.id_estudiante_oferta = eo.id_estudiante_oferta and  ac.id_malla_asignatura=ma.id_malla_asignatura
                                    and cg.id_periodo_academico =mg.id_periodo_academico  and ac.id_paralelo = ea.id_paralelo and (ca.codigo ='SUMATIVA'  and c.codigo in ('RECU'))
                                    and ac.estado in ('A','C') and ec.estado='A' and ecc.calificacion <>ec.calificacion
           ) as vecesActualizadasRecuperacion,
        iif( ((ea.aprobado=1) and isnull((select ec.calificacion from aca.acta_calificacion ac
                inner join aca.ciclo c on ac.id_ciclo = c.id_ciclo
                inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
                inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
                inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                where ec.id_estudiante_oferta = eo.id_estudiante_oferta and  ac.id_malla_asignatura=ma.id_malla_asignatura and cg.id_periodo_academico =mg.id_periodo_academico
                  and ac.id_paralelo = ea.id_paralelo
                and  (ca.codigo ='SUMATIVA'  and c.codigo in ('RECU'))
                and ac.estado in ('A','C') and ec.estado='A'
                ),0)=0) or (ea.aprobado=0),'NO','SI') as aprobo_mejoramiento_recuperacion,
       pu.identificacion as identificacionDocente,concat(pu.apellidos,' ',pu.nombres) as docente,'SGA' as origen,'A' as estado, getdate() as fecha_mod
from man.personas p
    left join man.estado_civil ec on p.id_estado_civil = ec.id_estado_civil
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
    inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
    inner join aca.docente d on ea.id_docente = d.id_docente
    inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
    inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
    inner join aca.nivel n on ma.id_nivel = n.id_nivel
    inner join aca.paralelo par on ea.id_paralelo = par.id_paralelo
    inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.oferta o on o.id_oferta = om.id_oferta
    inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
    inner join man.departamentos dep on dep.id = do.id_departamento
    inner join man.personas pu on pu.id = d.id_persona
    where --pa.id_tipo_oferta  in (1,2,3) --
     ea.estado='A' and em.estado='A' and d.estado='A' and eo.estado='A'
--     and pu.identificacion in ('1803738580','0603932450','1309869723','1707326813','0603208117')
        and pu.identificacion in (@identificacion)
end
select * from [rep].[fn_get_cantidad_matriculados_porcentajes](36,null,null,null)

-- insert into mig.tasa_reprobacion_estudiantes
-- select id_periodo_academico, codigo, facultad,carrera,id_oferta_modalidad,nivel,paralelo ,curso,id_malla_asignatura,id_asignatura ,asignatura ,
--         numero_matriculados, numero_aprobados,numero_reprobados,numero_reprobados_hombres,numero_reprobados_mujeres ,porcentaje_reprobados,
--         porcentaje_reprobados_hombres,porcentaje_reprobados_mujeres,docente,'SGA' as origen,'A' as estado, getdate() as fecha_mod
-- from [rep].[fn_get_cantidad_matriculados_porcentajes_por_paralelo](42,null,null,null) as d

select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta =3
-- DBCC CHECKIDENT ('mig.tasa_reprobacion_estudiantes', RESEED, 0);
-- update  te set te.docente=concat('DOCENTE NO REGISTRADO ',te.curso)
-- from mig.tasa_reprobacion_estudiantes te
-- where docente is null or docente in ('NO REGISTRA','NO APLICA')

    select * from mig.tasa_reprobacion_estudiantes te
---38489  --25277
-- insert into mig.tasa_reprobacion_estudiantes
select ra.id_periodo_academico,ra.periodo,ro.facultad,ro.carrera,ro.id_carrera_ofertada,n.descripcion_corta,p.descripcion_corta,concat(n.descripcion_corta,'/',p.descripcion_corta) as curso,
ra.id_malla_asignatura,ra.id_malla_asignatura,ra.asignatura,count(ra.id_record_asignatura) as matriculados,
       count(CASE WHEN Isnull(ra.aprobado,0) = 1 THEN 1 END) AS numero_aprobados,
       count(CASE WHEN Isnull(ra.aprobado,0) = 0 THEN 1 END) AS numero_reprobados,count(CASE WHEN Isnull(ra.aprobado,0) = 0 and per.sexo='M'  THEN 1 END) as numero_reprobados_hombres,
       count(CASE WHEN Isnull(ra.aprobado,0) = 0 and per.sexo='F'  THEN 1 END) as numero_reprobados_mujeres, cast(round(iif(count(ra.id_record_asignatura)=0,0,
             (cast(count(CASE WHEN Isnull(ra.aprobado,0) = 0 THEN 1 END) as decimal(5,2)))*100/count(ra.id_record_asignatura)),2) as decimal(5,2) )as porcentaje_reprobados,
       cast(round(iif(count(CASE WHEN Isnull(ra.aprobado,0) = 0 THEN 1 END)>0,
                      ((cast(count(CASE WHEN Isnull(ra.aprobado,0) = 0 and per.sexo='M'  THEN 1 END) as decimal(5,2)))*100/ count(CASE WHEN Isnull(ra.aprobado,0) = 0 THEN 1 END)),0),2) as decimal(5,2)) as porcentaje_reprobados_hombres,
       cast(round(iif(count(CASE WHEN Isnull(ra.aprobado,0) = 0 THEN 1 END)>0,
           ((cast(count(CASE WHEN Isnull(ra.aprobado,0) = 0 and per.sexo='F'  THEN 1 END) as decimal(5,2)))*100/ count(CASE WHEN Isnull(ra.aprobado,0) = 0 THEN 1 END)),0),2) as decimal(5,2)) as porcentaje_reprobados_mujeres
        , (select top 1 ra1.docente as docente from mig.record_asignaturas ra1
            inner join mig.record_oferta ro1 on ra1.id_record_oferta = ro1.id_record_oferta
           where ra1.periodo=ra.periodo and ra1.id_paralelo = ra.id_paralelo and ra1.id_nivel=ra.id_nivel and ro1.carrera=ro.carrera and ra1.asignatura=ra.asignatura
           and ra1.estado='A' and ro1.estado='A') as docente,'SISWEB' as origen,'A' as estado, getdate() as fecha_mod
from mig.record_oferta ro
inner join man.personas per on per.identificacion = ro.identificacion
inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
inner join aca.nivel n on ra.id_nivel = n.id_nivel
inner join aca.paralelo p on ra.id_paralelo = p.id_paralelo
where ro.estado='A' and ra.estado='A' and ra.periodo is not null
group by ra.id_periodo_academico, ra.periodo, ro.facultad, ro.carrera, ro.id_carrera_ofertada, n.descripcion_corta, p.descripcion_corta,
         n.descripcion_corta, p.descripcion_corta, ra.id_malla_asignatura, ra.asignatura,ra.id_paralelo,ra.id_nivel

select * from mig.record_asignaturas where periodo is null

select * from mig.historial_docente_detalle where  vecesActualizadasCiclo1 is null

alter view mig.listar_docentes_rendimiento_academico_estudiantes as
select hd.id_historial_docente,hd.identificacion as identificacion_historial,hd.docente as docente_historial,hd.tipo_oferta,hd.carrera as carrera_historial,hd.periodo as periodo_historial,
       hd.asignatura as asignatura_historial,hd.curso as curso_historial,
       t.* from mig.tasa_reprobacion_estudiantes t
inner join mig.historial_docente hd on hd.asignatura = t.asignatura
where hd.identificacion in ('1803738580','0603932450','1309869723','1707326813','0603208117')

select * from mig.listar_docentes_rendimiento_academico_estudiantes
-- update mig.tasa_reprobacion_estudiantes set identificacion ='NO REGISTRA' where identificacion is null
-- select t.*,p.identificacion
-- update t set t.identificacion=p.identificacion
-- from mig.tasa_reprobacion_estudiantes t
-- left join man.personas p on concat(p.apellidos,' ',p.nombres)= t.docente
-- where p.estado='AC'



-- update mig.historial_docente_detalle set vecesActualizadasRecuperacion=0 where vecesActualizadasRecuperacion is null

-- update mig.historial_docente_detalle set vecesActualizadasCiclo1=0 where vecesActualizadasCiclo1 is null
-- DBCC CHECKIDENT ('mig.historial_docente_detalle', RESEED, 0);


select * from aud.estudiante_calificacion

select * from mig.historial_docente where  identificacion in ('1804570636')-- and periodo='2024-2'



select identificacion,ro.carrera,iif(ra.estado_aprobacion='APROBADO',1,0),ra.*
--     update ra set aprobado = iif(ra.estado_aprobacion='APROBADO',1,0)
from mig.record_asignaturas ra
inner join mig.record_oferta ro on ra.id_record_oferta = ro.id_record_oferta
         where ra.aprobado is null and ra.id_record_matricula is not null


select * from man.personas where identificacion ='1804570636'
select pp.identificacion,pp.apellidos,pp.nombres,pp.fecha_nace,pp.estado,p.FEC_NACIMIENTO
--     update pp set pp.fecha_nace = p.FEC_NACIMIENTO
from man.personas pp
inner join Bd_Academico..PERSONAS p on p.IDENTIFICACION = pp.identificacion
where pp.fecha_nace is null  or pp.fecha_nace<'1900-01-01' and p.FEC_NACIMIENTO is not null

select * from Bd_Academico..PERSONAS where IDENTIFICACION in ('AQ483790','FB513830','AR302557')

select top 20 ro.identificacion,ro.apellidos,ro.nombres,c.NOTA,ra.asignatura,ra.promedio,ra.periodo,te.VALOR_TEXTO,tc.VALOR_TEXTO,c.ID_MATERIA_TOMADA,c.CG_PERIODO_EVALUACION,c.CG_TIPO_CALIFICACION
from Bd_Academico.dbo.SI_SUM_PARCIALES p
         inner join bd_Academico.dbo.CALIFICACIONES c on p.ID_SUM_PARCIAL = c.ID_SUM_PARCIAL
         inner join Bd_Academico.dbo.TP_CODIGOS tc on tc.CORRELATIVO = c.CG_TIPO_CALIFICACION
         inner join Bd_Academico.dbo.TP_CODIGOS te on te.CORRELATIVO = c.CG_PERIODO_EVALUACION
         inner join mig.record_asignaturas ra on ra.id_number = p.ID_MATERIA_TOMADA and ra.table_name ='Bd_Academico..MATERIAS_TOMADAS'
         inner join mig.record_oferta ro on ra.id_record_oferta = ro.id_record_oferta
where p.ESTADO='A' and c.ESTADO='A' and ra.estado='A' and ro.estado='A' and ro.identificacion='2400254286'
-- and ra.periodo='2006'
--   and  ra.id_record_asignatura =121538
group by ro.identificacion,ro.apellidos,ro.nombres,c.NOTA,ra.asignatura,ra.promedio,te.VALOR_TEXTO,tc.VALOR_TEXTO,c.ID_MATERIA_TOMADA,c.CG_PERIODO_EVALUACION,c.CG_TIPO_CALIFICACION, ra.periodo

--dividir por componente
SELECT
    ro.id_record_oferta,p.ID_SUM_PARCIAL,
    JSON_QUERY((
        SELECT iif(te.VALOR_TEXTO='MEJORAMIENTO','RECUPERACION',te.VALOR_TEXTO) AS ciclo,tc.VALOR_TEXTO AS componente,
               case tc.VALOR_TEXTO when 'CALIFICACION DOCENTE DE AREA' then 'CA-DOC-AREA' WHEN 'COMPONENTE PRACTICO' THEN 'COMP-PRAC'
                                   WHEN 'COMPONENTE TEORICO' THEN 'COMP-TEO'  WHEN 'EVALUACION FINAL DE CICLO' THEN 'EFC'
                                   WHEN 'SUMA DE ESTRATEGIAS EVALUATIVAS' THEN 'SEV'
                   WHEN 'SUSTENTACION TRIBUNAL UIC' THEN 'SUS-TRI-UIC' else te.CODIGO END AS codigo,
               cast(c1.nota as int) as nota

        FROM bd_Academico.dbo.CALIFICACIONES c1
                 inner join Bd_Academico.dbo.TP_CODIGOS tc on tc.CORRELATIVO = c1.CG_TIPO_CALIFICACION
                 inner join Bd_Academico.dbo.TP_CODIGOS te on te.CORRELATIVO = c1.CG_PERIODO_EVALUACION
        WHERE  c1.ID_MATERIA_TOMADA = p.ID_MATERIA_TOMADA
          and c1.ESTADO='A'
        FOR JSON PATH
    )) AS notas
from Bd_Academico.dbo.SI_SUM_PARCIALES p
         inner join mig.record_asignaturas ra on ra.id_number = p.ID_MATERIA_TOMADA and ra.table_name ='Bd_Academico..MATERIAS_TOMADAS'
         inner join mig.record_oferta ro on ra.id_record_oferta = ro.id_record_oferta
where p.ESTADO='A' and ra.estado='A' and ro.estado='A'
  and  p.ID_MATERIA_TOMADA = 381195
group by ro.identificacion,ro.apellidos,ro.nombres,ra.asignatura,ra.promedio, ro.id_record_oferta,p.ID_MATERIA_TOMADA, p.ID_SUM_PARCIAL

select * from mig.record_asignaturas where id_record_asignatura = 142035

 select *  FROM bd_Academico.dbo.CALIFICACIONES c1
                 inner join Bd_Academico.dbo.TP_CODIGOS tc on tc.CORRELATIVO = c1.CG_TIPO_CALIFICACION
    inner join Bd_Academico.dbo.TP_CODIGOS te on te.CORRELATIVO = c1.CG_PERIODO_EVALUACION
WHERE  c1.ID_SUM_PARCIAL = 58763 and c1.ID_MATERIA_TOMADA = 1276

select * from mig.record_calificaciones

--dividir por ciclo
-- insert into  mig.record_calificaciones

SELECT
    ra.id_record_asignatura,c.CG_PERIODO_EVALUACION,te.VALOR_TEXTO AS ciclo,
--     iif(te.VALOR_TEXTO='MEJORAMIENTO','RECUPERACION',te.VALOR_TEXTO) AS ciclo,
    sum(c.NOTA) as nota,
    JSON_QUERY((
        SELECT case WHEN tc.VALOR_TEXTO= 'EX' THEN 'EVALUACION FINAL DE CICLO'
                                   WHEN tc.VALOR_TEXTO in ('A 1','A 2','A 3','A 4')  THEN 'SUMA DE ESTRATEGIAS EVALUATIVAS'
                                    else tc.VALOR_TEXTO END AS componente,
               case tc.VALOR_TEXTO when 'CALIFICACION DOCENTE DE AREA' then 'CA-DOC-AREA' WHEN 'COMPONENTE PRACTICO' THEN 'COMP-PRAC'
                                   WHEN 'COMPONENTE TEORICO' THEN 'COMP-TEO'  WHEN 'EVALUACION FINAL DE CICLO' THEN 'EFC' WHEN 'EX' THEN 'EFC'
                                   WHEN 'SUMA DE ESTRATEGIAS EVALUATIVAS'  THEN 'SEV'
                                   WHEN 'A 1' THEN 'SEV'  WHEN 'A 2' THEN 'SEV'  WHEN 'A 3' THEN 'SEV'  WHEN 'A 4' THEN 'SEV'
                                   WHEN 'SUSTENTACION TRIBUNAL UIC' THEN 'SUS-TRI-UIC' else te.CODIGO END AS codigo,
               cast(c1.nota as int) as nota

        FROM bd_Academico.dbo.CALIFICACIONES c1
                 inner join Bd_Academico.dbo.TP_CODIGOS tc on tc.CORRELATIVO = c1.CG_TIPO_CALIFICACION
                 inner join Bd_Academico.dbo.TP_CODIGOS te on te.CORRELATIVO = c1.CG_PERIODO_EVALUACION
        WHERE  c1.ID_MATERIA_TOMADA = p.ID_MATERIA_TOMADA and c1.CG_PERIODO_EVALUACION = c.CG_PERIODO_EVALUACION
          and c1.ESTADO='A'
        FOR JSON PATH
    )) AS detalle,p.FECHA_INGRESO,p.ID_SUM_PARCIAL,'Bd_Academico.dbo.SI_SUM_PARCIALES' as tableName,'A',0,getdate(),getdate(),'2400254286','2400254286'
from Bd_Academico.dbo.SI_SUM_PARCIALES p
         inner join bd_Academico.dbo.CALIFICACIONES c on p.ID_SUM_PARCIAL = c.ID_SUM_PARCIAL
         inner join Bd_Academico.dbo.TP_CODIGOS tc on tc.CORRELATIVO = c.CG_TIPO_CALIFICACION
         inner join Bd_Academico.dbo.TP_CODIGOS te on te.CORRELATIVO = c.CG_PERIODO_EVALUACION
         inner join mig.record_asignaturas ra on ra.id_number = p.ID_MATERIA_TOMADA and ra.table_name ='Bd_Academico..MATERIAS_TOMADAS'
         inner join mig.record_oferta ro on ra.id_record_oferta = ro.id_record_oferta
where p.ESTADO='A' and ra.estado='A' and ro.estado='A'
--   and  p.ID_MATERIA_TOMADA < 381195
group by ra.id_record_asignatura,p.ID_MATERIA_TOMADA, c.CG_PERIODO_EVALUACION, te.VALOR_TEXTO, p.FECHA_INGRESO, p.ID_SUM_PARCIAL

select * from aca.componente_aprendizaje

select * from aca.ciclo

--ver todas las maneras en las que se calificaba antes
select  distinct ra.periodo,te.VALOR_TEXTO,tc.VALOR_TEXTO,c.CG_PERIODO_EVALUACION,c.CG_TIPO_CALIFICACION
from Bd_Academico.dbo.SI_SUM_PARCIALES p
         inner join bd_Academico.dbo.CALIFICACIONES c on p.ID_SUM_PARCIAL = c.ID_SUM_PARCIAL
         inner join Bd_Academico.dbo.TP_CODIGOS tc on tc.CORRELATIVO = c.CG_TIPO_CALIFICACION
         inner join Bd_Academico.dbo.TP_CODIGOS te on te.CORRELATIVO = c.CG_PERIODO_EVALUACION
         inner join mig.record_asignaturas ra on ra.id_number = p.ID_MATERIA_TOMADA and ra.table_name ='Bd_Academico..MATERIAS_TOMADAS'
         inner join mig.record_oferta ro on ra.id_record_oferta = ro.id_record_oferta
where p.ESTADO='A' and c.ESTADO='A' and ra.estado='A' and ro.estado='A'
--   and  p.ID_MATERIA_TOMADA = 381195
group by ra.periodo,te.VALOR_TEXTO,tc.VALOR_TEXTO,c.CG_PERIODO_EVALUACION,c.CG_TIPO_CALIFICACION

select top 100000 * from Bd_Academico.dbo.CALIFICACIONES

select top 100000 * from Bd_Academico.dbo.SI_SUM_PARCIALES

select * from man.personas where identificacion ='0928236975'

select * from Bd_Academico.dbo.TP_CODIGOS
where estado ='A' and ID_CLASIFICACION in (74,75) --and VALOR_TEXTO like '%-3%'
order by VALOR_TEXTO

select * from Bd_Academico.dbo.TP_CODIGOS
where CORRELATIVO in  (2307,4590,4591)
select * from Bd_Academico.dbo.CLASIFICACIONES_GENERALES cg
where ID_CLASIFICACION in (115,33)

select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta =4
-- 41231
--actualiza docentes en las matriculas SGA
begin
    declare @pi_id_periodo_academico int= 136, @pi_id_malla_asignatura int=null,@pi_id_paralelo int=null
--     select ea.id_docente,d.id_docente,per.apellidos,per.nombres,pea.apellidos,pea.nombres,ma.id_malla_asignatura,p.descripcion_corta,a.descripcion,ofe.descripcion,ea.*
    update ea set ea.id_docente = d.id_docente
    from aca.periodo_academico_oferta pao
             inner join aca.periodo_academico pa on pao.id_periodo_academico = pa.id_periodo_academico
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
             inner join aca.estudiante_asignatura ea on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje and ea.id_paralelo = p.id_paralelo
             inner join aca.docente dea on ea.id_docente=dea.id_docente
             inner join man.personas pea on dea.id_persona=pea.id
             inner join aca.estudiante_matricula em on ea.id_estudiante_matricula = em.id_estudiante_matricula
             inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general and mg.id_periodo_academico = pao.id_periodo_academico
             left join aca.tipo_docente td on td.id_tipo_docente=daa.id_tipo_docente

    where pao.estado='A' and do.estado in ('A','D', 'V') and dd.estado='A' and daa.estado='A' and mg.estado='A'
--       and (td.id_tipo_docente is null or td.codigo='AUTOR')

      and pao.id_periodo_academico=@pi_id_periodo_academico
      and (ma.id_malla_asignatura=@pi_id_malla_asignatura or @pi_id_malla_asignatura is null)
      and (p.id_paralelo=@pi_id_paralelo or @pi_id_paralelo is null)
      and do.id_distributivo_oferta in (select ddA.id_distributivo_oferta from [aca].[fn_distributivo_oferta_max] (@pi_id_periodo_academico,'A') AS DDA)
      and aa.estado='A' and d.estado='A' and per.estado='AC' and ea.id_docente <>d.id_docente
--         and  ea.id_docente is null
end

select ddA.id_distributivo_oferta from [aca].[fn_distributivo_oferta_max] (126,'A') AS DDA

select * from aca.estudiante_oferta eo
                  inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
                  inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
                  inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
where ea.id_docente is null and ea.estado='A'
--   and mg.id_periodo_academico = 36


--actualizar docentes en la migracion sisweb
select distinct  ro.carrera_original,ro.area,ro.identificacion,ro.apellidos,ro.nombres,p.IDENTIFICACION,p.APELLIDOS,p.NOMBRES,ra.*
--     update ra set ra.fecha_mod = getdate(),ra.docente = concat(p.APELLIDOS,' ',p.NOMBRES), ra.identificacion_docente=p.identificacion
from mig.record_asignaturas ra
         inner join mig.record_oferta ro on ra.id_record_oferta = ro.id_record_oferta
         inner join aca.tipo_oferta tof on ro.id_tipo_oferta = tof.id_tipo_oferta
         inner join aca.nivel n on ra.id_nivel = n.id_nivel
        inner join Bd_Academico..MATERIAS_TOMADAS mt on mt.ID_MATERIA_TOMADA = ra.id_number
        inner join Bd_Academico.dbo.SI_SUM_PARCIALES sp on mt.ID_MATERIA_TOMADA = sp.ID_MATERIA_TOMADA
        inner join Bd_Academico.dbo.CAB_ACTAS_CALIFICACIONES ca on ca.ID_ACTA = sp.ID_ACTA
        inner join Bd_Academico.dbo.CAB_ACTAS_DOCENTES cad on ca.ID_ACTA = cad.ID_ACTA
        inner join Bd_Personal..PF_PERSONAS p on p.ID_PERSONA = cad.ID_PERSONA
where ra.id_record_matricula is not null and identificacion_docente ='NO REGISTRA'-- and p.IDENTIFICACION='0926250804'
  and ra.table_name ='Bd_Academico..MATERIAS_TOMADAS' and p.IDENTIFICACION<>''


select * from aca.nivel

select * from mig.historial_docente where identificacion in ('1710178615')


EXECUTE Bd_Academico..sp_historia_docente_upse '1710178615'

--
-- WITH duplicados AS
--          (
--              SELECT id_historial_docente,
--                     ROW_NUMBER() OVER
--                         (
--                         PARTITION BY periodo, tipo_oferta, identificacion, docente, abreviatura, carrera, sede,
--                         asignatura, curso, carga_semanal, titulo, fecha_inicio, fecha_fin
--                         ORDER BY id_historial_docente
--                         ) AS numero
--              FROM mig.historial_docente
--          )
-- SELECT COUNT(*) AS registrosDuplicados
-- FROM duplicados
-- WHERE numero > 1;
--
-- WITH duplicados AS
--          (
--              SELECT id_historial_docente, periodo, tipo_oferta, identificacion, docente, abreviatura, carrera, sede,
--                     asignatura, curso, carga_semanal, titulo, fecha_inicio, fecha_fin,
--                     ROW_NUMBER() OVER
--                         (
--                         PARTITION BY periodo, tipo_oferta, identificacion, docente, abreviatura, carrera, sede,
--                         asignatura, curso, carga_semanal, titulo, fecha_inicio, fecha_fin
--                         ORDER BY id_historial_docente
--                         ) AS numero
--              FROM mig.historial_docente
--          )
-- SELECT *
-- FROM duplicados
-- -- WHERE numero > 1
-- ORDER BY identificacion, periodo, asignatura;

-- BEGIN TRANSACTION;
--
-- WITH duplicados AS
--          (
--              SELECT id_historial_docente,
--                     ROW_NUMBER() OVER
--                         (
--                         PARTITION BY periodo, tipo_oferta, identificacion, docente, abreviatura, carrera, sede,
--                         asignatura, curso, carga_semanal, titulo, fecha_inicio, fecha_fin
--                         ORDER BY id_historial_docente
--                         ) AS numero
--              FROM mig.historial_docente
--          )
-- DELETE
-- FROM duplicados
-- WHERE numero > 1;
--
-- SELECT @@ROWCOUNT AS registrosEliminados;
--
-- -- COMMIT TRANSACTION;
-- ROLLBACK TRANSACTION;