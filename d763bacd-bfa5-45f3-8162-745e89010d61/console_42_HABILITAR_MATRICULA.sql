use bd_sga_upse;

--------------NIVELACION--------------------

begin
    select
--     distinct  em.*
        --       distinct  ea.*--,p.identificacion
        distinct eo.*
--         distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,p.identificacion,p.apellidos,p.nombres,tee.descripcion,tie.descripcion
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
    where --eo.id_periodo_academico = @id_periodo_academico and
--         p.identificacion ='0928381037'
          p.identificacion in ('2450542317')
end;
select * from man.personas where identificacion='0917398794'

select * from [aca].[fn_recuperar_jornada_postulante_nivelacion](138,102611)

select d.idParalelo as idParalelo, d.paralelo as paralelo,	d.idJornada  as idJornada,
       d.jornada as jornada, d.idOfertaModalidad as idOfertaModalidad	from aca.fn_get_jornada_by_carrera
                                                                              (102611,138) as d


--listar info de los estudiantes
select d.*  from aca.fn_datos_estudiante_matricula(138,84888) as d


--rquisitos de matricula
select distinct pr.* from   aca.requisito_nivel_estudiante rne
INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = rne.id_matricula_general
INNER JOIN pro.proceso_requisito pr ON pr.id_proceso_requisito= rne.id_proceso_requisito
where pr.estado= 'A' AND mg.estado= 'A' AND rne.estado= 'A' and pr.codigo in ('TENERCUPOACTIVO','NOSANCIONADO','MATRICULAHABILITADA','NODEUDAS','DIAMATRICULA')

select distinct pr.* from   aca.requisito_nivel_estudiante rne
INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = rne.id_matricula_general
INNER JOIN pro.proceso_requisito pr ON pr.id_proceso_requisito= rne.id_proceso_requisito
where pr.estado= 'A' AND mg.estado= 'A' AND rne.estado= 'A' and mg.id_periodo_academico=127

select * from aca.fn_requisitos_matricula(84888,138)

select * from pro.proceso_requisito WHERE id_proceso_requisito IN (6,7,24,27,119,140)

select * from  aca.requisito_nivel_estudiante rne
----------------------------
---fechas de matricula

select * from aca.matricula_general mg where id_periodo_academico in (126,138)

select tmf.* from aca.tipo_matricula_fecha tmf
inner join aca.matricula_general mg on tmf.id_matricula_general = mg.id_matricula_general
where mg.id_periodo_academico in (136,138,150)

select tmf.* from aca.matricula_general mg
                      inner join aca.tipo_matricula_fecha tmf on mg.id_matricula_general = tmf.id_matricula_general
                      inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
where pa.id_tipo_oferta = 4 and pa.id_periodo_academico = 150

select mfn.* from aca.matricula_fecha_nivel mfn
inner join aca.tipo_matricula_fecha tmf on mfn.id_tipo_matricula_fecha = tmf.id_tipo_matricula_fecha
inner join aca.matricula_general mg on tmf.id_matricula_general = mg.id_matricula_general
inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
where pa.id_tipo_oferta = 1

select * from aca.matricula_fecha_nivel

select * from mig.periodo_academico_ponderacion

select * from aca.periodo_academico

---habilitar carrera matricula
select --om.facultad,om.carrera,om.id_oferta_modalidad,
       pao.* from aca.periodo_academico_oferta pao
                     inner join aca.ofertas_facultad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
where pao.id_periodo_academico = 136 and pao.id_oferta_modalidad  in (21)

--jornada de paralelos

select
    po.*
--     om.facultad,om.carrera,pao.id_periodo_academico_oferta,om.id_oferta_modalidad,po.id_paralelo,po.id_tipo_jornada_laboral,tjl.descripcion
     from aca.planificacion_oferta po
                     inner join aca.periodo_academico_oferta pao on po.id_periodo_academico_oferta = pao.id_periodo_academico_oferta
                     inner join aca.ofertas_facultad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
                     inner join aca.tipo_jornada_laboral tjl on po.id_tipo_jornada_laboral = tjl.id_tipo_jornada_laboral
where pao.id_periodo_academico = 138
select * from [aca].[fn_recuperar_jornada_postulante_nivelacion](138,96480)

select d.idParalelo as idParalelo, d.paralelo as paralelo,	d.idJornada  as idJornada,
       d.jornada as jornada, d.idOfertaModalidad as idOfertaModalidad	from aca.fn_get_jornada_by_carrera
                                                                              (96480,138) as d

---asignar menus a los roles de estudiante

-- 427 requisito-matricula-nivelacion-code	Matricula Nivelación 2025-2
-- 75 matriculacion-estudiante	Matriculación de Asignaturas
-- 170 upload-documents-matricula-students	Subida de Archivos
-- 169 REGISTRO-ASPIRANTE	Registro información Académica aspirante
select-- o.codigo,o.nombre,
      uo.* from seg.usuario_opcion uo
                    inner join man.opciones o on uo.id_opcion = o.id
where uo.id_usuario in (44695,39037,70736)

select * from man.opciones where url like '%requisitos-matricula-nivelacion%'
    or nombre like '%Registro información Académica aspirante%'
    or nombre like '%Subida de Archivos%'
    or nombre like '%Matriculación de Asignaturas%'

select * from seg.usuario_opcion where id_usuario = 62084
select * from seg.usuario_opcion where id_usuario = 2588

select * from mig.record_oferta where identificacion='1750397273'
select * from mig.listar_carreras_sga where identificacion='1750397273'
select * from man.opciones where id in (427,75,170)
--caso repetir turismo
select * from seg.usuarios where usuario='2450262635'
--prima viviana
select  * from seg.usuarios where usuario='2450542317'
--amiga de jkaren
select  * from seg.usuarios where usuario='0917080822'

--ver horarios de los paralelos
select * from [aca].[fn_rpt_distributivo_horario] (38)

--generar numero de matricula
select p.identificacion,d.*
--     update eo set eo.numero_matricula = d.matri
from (
         select ROW_NUMBER() OVER (PARTITION BY eo.id_oferta_modalidad  ORDER BY eo.fecha_ing asc )as indice,eo.id_estudiante_oferta,eo.numero_matricula,
                CONCAT('20261',RIGHT('000' + Ltrim(Rtrim(Rtrim((0)+eo.id_oferta_modalidad))),3),RIGHT('00' + Ltrim(Rtrim(Rtrim((0)+1))),2),
                       RIGHT('00000' + Ltrim(Rtrim(Rtrim((0)+( ROW_NUMBER() OVER (PARTITION BY eo.id_oferta_modalidad  ORDER BY eo.fecha_ing asc  ))))),5) ) as matricula
         from aca.estudiante_oferta eo where eo.id_periodo_academico = 136) as d
         inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = d.id_estudiante_oferta
        inner join man.personas p on p.id= eo.id_persona
where eo.id_oferta_modalidad = 85


--HABILITAR ESTUDIANTES DE NIVELACION
--3689
SELECT paf.id_oferta_modalidad as id_oferta_modalidad_niv,ofa.carrera,cu.id_oferta_modalidad as id_modalida_postulacion ,cu.*
FROM [niv].[consultar_lista_Usuarios_cupos](138,1,null,null,null,null,
                                            null,null,null) cu
    inner join aca.periodo_academico_oferta paf on paf.id_oferta_modalidad_admision=cu.id_oferta_modalidad
    inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = paf.id_oferta_modalidad
    where paf.id_periodo_academico=138

select m.* from aca.malla m
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
where ofa.id_tipo_oferta=1 --and m.vigente=1
order by ofa.carrera,id_malla


--CREAR LOS ESTUDIANTES OFERTAS DE LA POBLACION DE NIVELACIÓN
exec [aca].[sp_migrate_estudiantes_postulantes_nivelacion_to_oferta_nivelacion] 138,null;

--4037
-- 🔥 1. PRECALCULAR TODO
WITH base_eo AS (
        SELECT
            p.identificacion,
            SUM(CASE WHEN ee.id_tipo_oferta IN (1,2)
                AND ee.estado_carrera='ACTIVO' THEN 1 ELSE 0 END) AS activos,
            SUM(CASE WHEN ee.id_tipo_oferta = 2
                AND ee.estado_carrera in ('CARRERANOOCUPADA','PERDIDACARRERA') THEN 1 ELSE 0 END) AS adicionales,
            SUM(CASE WHEN (ee.id_tipo_oferta = 2
                AND ee.estado_carrera IN ('EGRESADO','GRADUADO')
                AND ee.periodo < '2012-2')
                OR ee.id_tipo_oferta = 3 THEN 1 ELSE 0 END) AS historico
        FROM aca.estudiante_oferta eo2
        INNER JOIN man.personas p ON eo2.id_persona = p.id
        INNER JOIN aca.estudiantes_ofertas ee ON ee.id_estudiante_oferta = eo2.id_estudiante_oferta
        WHERE EE.periodo<'2026-1'
        GROUP BY p.identificacion
        ),
     base_ro AS (
         SELECT
             identificacion,SUM(CASE WHEN id_tipo_oferta = 2 AND estado='A' AND periodo >= '2012-2' THEN 1 ELSE 0 END) AS activos_ro,
             SUM(CASE WHEN id_tipo_oferta = 2 AND estado='A' AND periodo < '2012-2' AND id_tipo_estado_estudiante IN (4,5) THEN 1 ELSE 0 END) AS historico_ro
         FROM mig.record_oferta
         GROUP BY identificacion
     )
SELECT
    paf.id_oferta_modalidad AS idOfertaModalidadNivelacion, c.CARRERA, c.id_persona, c.IDENTIFICACION, CONCAT(c.apellidos,' ',c.nombres) AS nombres,
    -- 🔥 GRATUIDAD
    IIF(ISNULL(eo.activos,0) + ISNULL(ro.activos_ro,0)+ ISNULL(eo.historico,0)  + ISNULL(eo.adicionales,0) > 0,0,1) AS mantiene_gratuidad_cal,  u.id,c.id_periodo_academico,c.id_oferta_modalidad,m.id_malla,m.descripcion
    ,eo_chk.id_estudiante_oferta,eo_chk.mantiene_gratuidad as mantiene_gratuidad_actual,c.JORNADA
    -- 🔥 GRATUIDAD NUEVA
    ,IIF(ISNULL(eo.historico,0) + ISNULL(eo.adicionales,0) > 0,0,1) AS mantiene_gratuidad_new
FROM [niv].[consultar_lista_Usuarios_cupos](138,1,null,null,null,null,null,null,null) c

         INNER JOIN seg.usuarios u ON u.persona_id = c.id_persona AND u.estado='AC'
         INNER JOIN aca.periodo_academico_oferta paf ON paf.id_oferta_modalidad_admision = c.id_oferta_modalidad AND paf.id_periodo_academico = 138
        inner join aca.malla m on m.id_oferta_modalidad = paf.id_oferta_modalidad and m.estado in ('A','P') and m.vigente=1
--          INNER JOIN aca.ofertas_facultad ofa ON ofa.id_oferta_modalidad = paf.id_oferta_modalidad
         LEFT JOIN aca.estudiante_oferta eo_chk  ON eo_chk.id_persona = c.id_persona AND eo_chk.id_oferta_modalidad = paf.id_oferta_modalidad  AND eo_chk.estado='A'  AND eo_chk.id_periodo_academico = 138
-- 🔥 joins a datos precalculados
         LEFT JOIN base_eo eo ON eo.identificacion = c.IDENTIFICACION
         LEFT JOIN base_ro ro ON ro.identificacion = c.IDENTIFICACION
WHERE eo_chk.id_estudiante_oferta IS NULL
ORDER BY c.CARRERA, c.APELLIDOS, c.NOMBRES;

--casos de prueba
--     2450558834 1 vez
--     2450542317
--  2450103136 2vez
select * from tmp.perdida_gratuidad_nivelacion pg

--actualizar perdidad de gratuidad por cupo activo
select pg.*,aux.identificacion,aux.carrera from tmp.perdida_gratuidad_nivelacion pg
left join (select p.identificacion,p.nombres,p.apellidos,om.carrera,pa.codigo from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.periodo_academico pa on pa.id_periodo_academico =  eo.id_periodo_academico
         inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    where eo.estado='A' and pa.codigo='2025-2') as aux on aux.identificacion =pg.identificacion and aux.carrera=pg.carrera
where pg.periodo='2026-1'

--     update eo set eo.mantiene_gratuidad =0
select p.identificacion,p.nombres,p.apellidos,om.carrera,pa.codigo,eo.id_estudiante_oferta,eo.mantiene_gratuidad,tee.descripcion
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.periodo_academico pa on pa.id_periodo_academico =  eo.id_periodo_academico
         inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join tmp.perdida_gratuidad_nivelacion pg on pg.identificacion = p.identificacion and pg.periodo='2026-1'
    where eo.estado='A' and pa.id_periodo_academico in (138) and eo.id_tipo_estado_estudiante=1 and eo.mantiene_gratuidad=1


--planificacion paralelos
select ofa.carrera,ppd.id_paralelo,null as jornada from aca.periodo_academico_oferta pao
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = pao.id_oferta_modalidad
inner join aca.malla m on m.id_oferta_modalidad= ofa.id_oferta_modalidad
inner join aca.malla_asignatura ma on m.id_malla = ma.id_malla
inner join aca.planificacion_paralelo pp on pp.id_periodo_academico = pao.id_periodo_academico and ma.id_malla_asignatura=pp.id_malla_asignatura
inner join aca.planificacion_paralelo_detalle ppd on pp.id_planificacion_paralelo = ppd.id_planificacion_paralelo
where pao.estado='A' and pp.estado='A' and pp.ofertada = 1 and pao.id_periodo_academico = 138 and ppd.estado='A'
group by  ofa.carrera, ppd.id_paralelo
order by ofa.carrera,ppd.id_paralelo
--           pp.num_paralelos, ppd.id_planificacion_paralelo
select * from aca.tipo_jornada_laboral
-- select * from aca.planificacion_oferta

--jornada de las carreras
select d.idParalelo as idParalelo, d.paralelo as paralelo,	d.idJornada  as idJornada,
       d.jornada as jornada, d.idOfertaModalidad as idOfertaModalidad	from aca.fn_get_jornada_by_carrera
                                                                              (73957,38) as d

SELECT c.*
FROM [niv].[consultar_lista_Usuarios_cupos](138,1,null,null,
                                            null,null,null,null,null) c

select

    distinct
--     mr.id_matricula_rubro,mr.id_estudiante_matricula,mr.id_rubro,mr.valor,
--     p.identificacion,eo.id_estudiante_oferta,eo.ultimo_periodo,
--     ea.id_estudiante_asignatura,ea.id_numero_vez,ea.codigo_estado_matricula,
em.* from aca.estudiante_oferta eo
              inner join man.personas p on p.id = eo.id_persona
              inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
              inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
              inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
              inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
where  mg.id_periodo_academico = 150 and ea.estado='A'

