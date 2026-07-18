use bd_sga_upse


--listar dimension tiempo
alter view mig.vw_tiempo_desercion as
select CAST(DENSE_RANK() OVER (ORDER BY d.codigo) AS INT) as id_periodo_academico,d.anio,d.codigo,CAST(DENSE_RANK() OVER (ORDER BY d.codigo) AS INT) AS orden from (
select p.codigo as anio,pa.codigo,pa.orden
from aca.periodo_academico pa
         inner join aca.periodo p on pa.id_periodo = p.id_periodo
where pa.id_tipo_oferta =2 and pa.estado='A' and pa.codigo between '2012-2' and '2025-1' and p.estado='A' --and pa.codigo_tipo_periodo ='PAORD'
and pa.id_periodo_academico not in (128)
    -- order by pa.orden
) as d
order by d.orden

select * from mig.vw_tiempo_desercion

-- select * from aca.periodo_academico where id_tipo_oferta = 2


--listar niveles
create view mig.vw_niveles as
select CAST(DENSE_RANK() OVER (ORDER BY id_tipo_oferta,orden) AS INT) as id_nivel,descripcion_corta as nivel_corto,descripcion as nivel
from aca.nivel where estado='A' and id_tipo_oferta in (1,2)
-- order by  id_tipo_oferta,orden

select * from mig.vw_niveles



--listar carreras
--ofertas considerando a nivelacion como otra oferta
--se deben eliminar las ofertas de nivelacion y quedar en funcion de las ofertas de grado
alter view mig.vw_ofertas_desercion as
  select distinct d.id_oferta, oferta, facultad, campus, modalidad,sistema_estudio,
     d.duracion_anios, duracion_periodos from (
    select  distinct om.id_oferta_modalidad as id_oferta,
     concat(ro.carrera,' - ',ro.modalidad) as oferta,ofa.facultad  as facultad,
    isnull(c.descripcion_corta,'MATRIZ') as campus,    fac.MODALIDAD as modalidad,ro.sistema_estudio,
    cast(iif(fac.DURACION>5,fac.DURACION/2,iif(fac.DURACION=1,5,fac.DURACIOn))as decimal(4,1)) as duracion_anios,
    iif(ro.id_tipo_oferta=1 or  fac.DURACIOn = 1,10,CAST(iif(fac.DURACION>5,fac.DURACION,fac.DURACION*2) AS INT)) as duracion_periodos
    from mig.record_oferta ro
    inner join mig.record_matricula rma on ro.id_record_oferta = rma.id_record_oferta
    inner join Bd_Academico..VW_CARRERAS_OFERTADAS fac on fac.ID_CARRERA_OFERTADA = ro.ID_CARRERA_OFERTADA
    left join migracion_sga..registros_migracion rm on rm.id_origen = ro.ID_CARRERA_OFERTADA and rm.id_entidad_relacion=2
    left join aca.oferta_modalidad om on om.id_oferta_modalidad = rm.id_destino
    left join aca.ofertas_facultad ofa on om.id_oferta_modalidad = ofa.id_oferta_modalidad
    left join aca.campus c on c.id_campus = ofa.id_campus
    WHERE ro.estado='A'  --and ro.sistema_estudio<>'ANUAL' --and rma.estado='A'
    and ro.periodo between '2012-2' and '2025-1' and isnull(om.id_oferta_modalidad,0) not in (select  distinct eo1.id_oferta_modalidad from aca.estudiante_oferta eo1
                                                                                      inner join aca.estudiante_matricula em1 on eo1.id_estudiante_oferta = em1.id_estudiante_oferta
                                                                                      inner join aca.ofertas_facultad ofa1 on eo1.id_oferta_modalidad = ofa1.id_oferta_modalidad
                                                                                             where eo1.estado='A' and em1.estado='A' and ofa1.id_tipo_oferta in (1,2))
      and (rm.id_destino is null or rm.fecha<'2025-04-08 05:46:57.787')
--     and ro.carrera not in ('NIVELACION DE INGENIERIA AGROPECUARIA - MATRIZ - PRESENCIAL','NIVELACION DE INGENIERIA EN PETROLEO - MATRIZ - PRESENCIAL','NIVELACION DE INFORMATICA - MATRIZ - PRESENCIAL',
--                           'NIVELACION DE EDUCACION FISICA DEPORTE Y RECREACION - MATRIZ - PRESENCIAL','NIVELACION DE EDUCACION PARVULARIA - MATRIZ - PRESENCIAL',
--                           'NIVELACION DE INGENIERIA EN GESTION Y DESARROLLO TURISTICO - MATRIZ - PRESENCIAL')
    union all
--     --ofertas sga
    select distinct --o.id_oferta,
    om.id_oferta_modalidad,concat(o.descripcion,' - ',m.descripcion) as carrera,CAST(d.nombre AS VARCHAR(250)) AS facultad,c.descripcion_corta as campus,
    m.descripcion as modalidad,se.descripcion as sistema_estudio,
    iif(o.id_tipo_oferta=2,cast((o.duracion/2) as decimal (4,1)),
        (select cast((o2.duracion/2) as decimal (4,1)) from aca.oferta o2 inner join rel.oferta_relaciones ro2 on o2.id_oferta = ro2.id_oferta_relacion
                  where ro2.id_oferta=o.id_oferta and ro2.estado='A' and o2.estado='A')) as duracion ,
    iif(o.id_tipo_oferta = 1, (select cast((o2.duracion/2) as decimal (4,1)) from aca.oferta o2 inner join rel.oferta_relaciones ro2 on o2.id_oferta = ro2.id_oferta_relacion
                               where ro2.id_oferta=o.id_oferta and ro2.estado='A' and o2.estado='A')*2, o.duracion)  as duracion_periodos from aca.oferta o
    inner join aca.oferta_modalidad om on o.id_oferta = om.id_oferta
    inner join aca.modalidad m on om.id_modalidad = m.id_modalidad
    inner join aca.campus c on o.id_campus = c.id_campus
    inner join aca.sistema_estudio se on om.id_sistema_estudio = se.id_sistema_estudio
    inner join aca.departamento_oferta do on o.id_oferta = do.id_oferta
    inner join man.departamentos d on do.id_departamento = d.id
    inner join aca.periodo_academico_oferta pao on om.id_oferta_modalidad = pao.id_oferta_modalidad
    inner join aca.periodo_academico pa on pao.id_periodo_academico = pa.id_periodo_academico
    inner join aca.estudiante_oferta eo on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
    where o.estado='A' and om.estado='A' and m.estado='A' and do.estado='A' and d.estado='AC'     and o.id_tipo_oferta in (1,2)
      and pao.estado='A' AND pa.id_tipo_oferta in (1,2) and pa.codigo_tipo_periodo ='PAORD' and pa.codigo between '2012-2' and '2025-1'
    ) as d
     where  d.oferta not in ('NIVELACION DE INGENIERIA AGROPECUARIA - MATRIZ - PRESENCIAL','NIVELACION DE INGENIERIA EN PETROLEO - MATRIZ - PRESENCIAL','NIVELACION DE INFORMATICA - MATRIZ - PRESENCIAL',
         'NIVELACION DE EDUCACION FISICA DEPORTE Y RECREACION - MATRIZ - PRESENCIAL','NIVELACION DE EDUCACION PARVULARIA - MATRIZ - PRESENCIAL',
         'NIVELACION DE INGENIERIA EN GESTION Y DESARROLLO TURISTICO - MATRIZ - PRESENCIAL')
    group by oferta, facultad, campus, modalidad,d.id_oferta, duracion_anios, duracion_periodos, sistema_estudio


select * from mig.vw_ofertas_desercion
order by oferta,facultad

--listar estudiantes final  57295
alter view mig.vw_personas_desercion as
select distinct CAST(DENSE_RANK() OVER (ORDER BY d.nombres,d.identificacion) AS INT) as id_estudiante,d.identificacion, d.nombres, d.sexo,
                d.edad, d.estado_civil, d.discapacidad, d.porcentaje_discapacidad,
                d.pais, d.provincia, d.canton, d.parroquia, d.etnia, d.nacionalidad_indigena from (
    select distinct p.identificacion,concat(p.apellidos,' ',p.nombres) as nombres,
                    iif(p.sexo='M','MASCULINO','FEMENIMO') as sexo,cast(isnull(cast( (DATEDIFF(YEAR ,p.fecha_nace, getdate())) as decimal(10,0)),0)as varchar(255)) as edad,
                    iif(p.id_estado_civil is null,'NO REGISTRA',ec.descripcion) as estado_civil,
                    iif(p.id_discapacidad is null,'NINGUNA',dis.descripcion) as discapacidad,
                    isnull(iif(p.id_discapacidad is null,'0',iif(p.porcentaje_dis ='','0',p.porcentaje_dis)),'0') as porcentaje_discapacidad,
                    iif(p.id_pais_nacionalidad is null,'NO REGISTRA',pais.descripcion) as pais,iif(p.id_provincia_nacionalidad is null,'NO REGISTRA',pro.descripcion) as provincia,
                    iif(p.id_canton_nacionalidad is null,'NO REGISTRA',can.descripcion) as canton,iif(p.id_parroquia_nacionalidad is null,'NO REGISTRA',par.descripcion) as parroquia,
                    iif(p.id_etnia is null,'NO REGISTRA',e.descripcion) as etnia,iif(p.id_nacionalidad_indigena is null,'NO REGISTRA',nai.descripcion) as nacionalidad_indigena
    --     ,'SGA' as sistema
    from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
     left join man.lugar pais on pais.id_lugar = p.id_pais_nacionalidad and pais.estado='A'
     left join man.lugar pro on pro.id_lugar = p.id_provincia_nacionalidad and pro.estado='A'
     left join man.lugar can on can.id_lugar = p.id_canton_nacionalidad and can.estado='A'
     left join man.lugar par on par.id_lugar = p.id_parroquia_nacionalidad and par.estado='A'
     left join man.discapacidad dis on dis.id_discapacidad = p.id_discapacidad and dis.estado='A'
     left join man.etnia e on e.id_etnia = p.id_etnia and e.estado='A'
     left join man.estado_civil ec on p.id_estado_civil = ec.id_estado_civil and ec.estado='A'
     left join man.nacionalidad_indigena nai on nai.id_nacionalidad_indigena = p.id_nacionalidad_indigena and nai.estado='A'
     inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
     inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
     inner join aca.oferta o on o.id_oferta = om.id_oferta
    where p.estado='AC' and eo.estado='A' and om.estado='A' and o.id_tipo_oferta in (1,2) --and p.fecha_nace is null
    union all
    select distinct p.identificacion,concat(p.apellidos,' ',p.nombres) as nombres,
                    iif(p.sexo='M','MASCULINO','FEMENIMO') as sexo,cast(isnull(cast( (DATEDIFF(YEAR ,p.fecha_nace, getdate())) as decimal(10,0)),0)as varchar(255)) as edad,
                    iif(p.id_estado_civil is null,'NO REGISTRA',ec.descripcion) as estado_civil,
                    iif(p.id_discapacidad is null,'NINGUNA',dis.descripcion) as discapacidad,
                    isnull(iif(p.id_discapacidad is null,'0',iif(p.porcentaje_dis ='','0',p.porcentaje_dis)),'0') as porcentaje_discapacidad,
                    iif(p.id_pais_nacionalidad is null,'NO REGISTRA',pais.descripcion) as pais,iif(p.id_provincia_nacionalidad is null,'NO REGISTRA',pro.descripcion) as provincia,
                    iif(p.id_canton_nacionalidad is null,'NO REGISTRA',can.descripcion) as canton,iif(p.id_parroquia_nacionalidad is null,'NO REGISTRA',par.descripcion) as parroquia,
                    iif(p.id_etnia is null,'NO REGISTRA',e.descripcion) as etnia,iif(p.id_nacionalidad_indigena is null,'NO REGISTRA',nai.descripcion) as nacionalidad_indigena
    --     ,'SGA' as sistema
    from man.personas p
    inner join mig.record_oferta ro on ro.identificacion = p.identificacion
    left join man.lugar pais on pais.id_lugar = p.id_pais_nacionalidad and pais.estado='A'
    left join man.lugar pro on pro.id_lugar = p.id_provincia_nacionalidad and pro.estado='A'
    left join man.lugar can on can.id_lugar = p.id_canton_nacionalidad and can.estado='A'
    left join man.lugar par on par.id_lugar = p.id_parroquia_nacionalidad and par.estado='A'
    left join man.discapacidad dis on dis.id_discapacidad = p.id_discapacidad and dis.estado='A'
    left join man.etnia e on e.id_etnia = p.id_etnia and e.estado='A'
    left join man.estado_civil ec on p.id_estado_civil = ec.id_estado_civil and ec.estado='A'
    left join man.nacionalidad_indigena nai on nai.id_nacionalidad_indigena = p.id_nacionalidad_indigena and nai.estado='A'
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = ro.id_tipo_estado_estudiante
    where p.estado='AC' and ro.id_tipo_oferta in (1,2)  and ro.periodo between '2012-2' and '2025-1'--and p.fecha_nace is null
) as d
-- order by  d.nombres
select * from man.lugar where descripcion='BRASIL'
select * from man.lugar where descripcion='CHIMBORAZO'
select * from man.estado_civil
select * from man.nacionalidad
select * from man.lugar where id_lugar = 490
select * from man.lugar where id_lugar_padre = 252
select * from man.lugar where id_lugar_padre = 314


select * from man.personas where  identificacion IN ('2400223117')
select vpd.* from  mig.vw_personas_desercion vpd

select m.* from aca.malla m
inner join aca.ofertas_facultad om on om.id_oferta_modalidad = m.id_oferta_modalidad
where om.id_tipo_oferta = 2 and m.fecha_hasta is null
select * from  mig.listar_carreras_sisweb niv


--factores desercion

select * from aca.tipo_estado_estudiante

select * from aca.tipo_ingreso_estudiante

select * from aca.ofertas_facultad where id_tipo_oferta = 2

select vpd.* from  mig.vw_personas_desercion vpd

select * from mig.vw_ofertas_desercion order by oferta,facultad

select * from mig.vw_tiempo_desercion
select * from mig.vw_niveles


-- consulta final de tabla de hechos sisweb sin relacion a sga
-- niv 21963
select d.id_carrera, d.id_tiempo, d.id_nivel, d.id_estudiante, d.id_tipo_estado_estudiante,d.estado_aulas, d.carece_dispositivos_electronicos, d.dificultad_educacion_virtual, d.problema_salud_mental, d.nivel_satisfaccion_docente,
       CASE
        WHEN TRY_CAST(d.nivel_socioeconomico AS FLOAT) IS NULL THEN 'Sin ingresos'
        WHEN TRY_CAST(d.nivel_socioeconomico  AS FLOAT) = 0 THEN 'Sin ingresos'
        WHEN TRY_CAST(d.nivel_socioeconomico  AS FLOAT) BETWEEN 1 AND 100 THEN 'Entre 1 y 100'
        WHEN TRY_CAST(d.nivel_socioeconomico  AS FLOAT) BETWEEN 101 AND 250 THEN 'Entre 101 y 250'
        WHEN TRY_CAST(d.nivel_socioeconomico  AS FLOAT) BETWEEN 251 AND 500 THEN 'Entre 251 y 500'
        WHEN TRY_CAST(d.nivel_socioeconomico  AS FLOAT) BETWEEN 501 AND 750 THEN 'Entre 501 y 750'
        WHEN TRY_CAST(d.nivel_socioeconomico AS FLOAT) BETWEEN 751 AND 1000 THEN 'Entre 751 y 1000'
        WHEN TRY_CAST(d.nivel_socioeconomico  AS FLOAT) > 1000 THEN 'Más de 1000' end as nivel_socioeconomico,
        CASE
        -- RANGOS EN TEXTO (YA ESTÁN CATEGORIZADOS)
        WHEN nivel_socioeconomico_familia IN (
            '$1 a $200', '$201 a $400', '$401 a $600', '$601 a $800',
            '$801 a $1000', '$1001 a $1200', '$1201 a $1400', '$1401 a $1600',
            '$1601 a $1800', '$1801 a $2000', '$2001 a $2200', '$2201 a $2400',
            '$2401 en adelante'
        ) THEN nivel_socioeconomico_familia

        -- VALOR EXACTO EN TEXTO QUE ES UN NÚMERO
       WHEN TRY_CAST(REPLACE(REPLACE(nivel_socioeconomico_familia, '$', ''), '.', '') AS FLOAT) BETWEEN 1 AND 200 THEN '$1 a $200'
        WHEN TRY_CAST(REPLACE(REPLACE(nivel_socioeconomico_familia, '$', ''), '.', '') AS FLOAT) BETWEEN 201 AND 400 THEN '$201 a $400'
        WHEN TRY_CAST(REPLACE(REPLACE(nivel_socioeconomico_familia, '$', ''), '.', '') AS FLOAT) BETWEEN 401 AND 600 THEN '$401 a $600'
        WHEN TRY_CAST(REPLACE(REPLACE(nivel_socioeconomico_familia, '$', ''), '.', '') AS FLOAT) BETWEEN 601 AND 800 THEN '$601 a $800'
        WHEN TRY_CAST(REPLACE(REPLACE(nivel_socioeconomico_familia, '$', ''), '.', '') AS FLOAT) BETWEEN 801 AND 1000 THEN '$801 a $1000'
        WHEN TRY_CAST(REPLACE(REPLACE(nivel_socioeconomico_familia, '$', ''), '.', '') AS FLOAT) BETWEEN 1001 AND 1200 THEN '$1001 a $1200'
        WHEN TRY_CAST(REPLACE(REPLACE(nivel_socioeconomico_familia, '$', ''), '.', '') AS FLOAT) BETWEEN 1201 AND 1400 THEN '$1201 a $1400'
        WHEN TRY_CAST(REPLACE(REPLACE(nivel_socioeconomico_familia, '$', ''), '.', '') AS FLOAT) BETWEEN 1401 AND 1600 THEN '$1401 a $1600'
        WHEN TRY_CAST(REPLACE(REPLACE(nivel_socioeconomico_familia, '$', ''), '.', '') AS FLOAT) BETWEEN 1601 AND 1800 THEN '$1601 a $1800'
        WHEN TRY_CAST(REPLACE(REPLACE(nivel_socioeconomico_familia, '$', ''), '.', '') AS FLOAT) BETWEEN 1801 AND 2000 THEN '$1801 a $2000'
        WHEN TRY_CAST(REPLACE(REPLACE(nivel_socioeconomico_familia, '$', ''), '.', '') AS FLOAT) BETWEEN 2001 AND 2200 THEN '$2001 a $2200'
        WHEN TRY_CAST(REPLACE(REPLACE(nivel_socioeconomico_familia, '$', ''), '.', '') AS FLOAT) BETWEEN 2201 AND 2400 THEN '$2201 a $2400'
        WHEN TRY_CAST(REPLACE(REPLACE(nivel_socioeconomico_familia, '$', ''), '.', '') AS FLOAT) > 2400 THEN '$2401 en adelante'
        -- CASOS INVÁLIDOS
        ELSE 'Sin ingresos'
    END AS nivel_socioeconomico_familia,d.edad,d.numero_redisenios,d.numero_becas,d.numero_cambios_carrera,d.numero_cupos_obtenidos,d.numero_cupos_no_efectivizados,d.numero_cupos_rechazados
       ,d.numero_clubs_universitarios,d.tareas as numero_tareas_semana,d.numero_profesores,d.numero_profesoras,d.numero_tutorias,d.numero_semestres_ausentes,d.numero_semestres_cursadas,d.numero_semestres_anulados,
        d.total_materias_malla,d.total_asignaturas_cursadas,d.total_asignaturas_aprobadas,d.total_asignaturas_reprobadas,d.total_creditos,d.total_horas,
       d.periodo_nivelacion,d.periodo_grado,d.periodo_ultima_matricula,d.periodo_fin_grado,d.periodo_graduacion,d.duracion_estudios,d.promedio,d.profesional,d.deserto,d.retiro_nivelacion,d.mantiene_gratuidad
from (
         select  rn.id_oferta_modalidad as id_carrera,--rn.id_periodo_academico as id_tiempo,
                 (select td.id_periodo_academico from mig.vw_tiempo_desercion td where td.codigo=rn.periodo) as id_tiempo,
                 iif(rg.id_record_oferta is not null,(select top 1 (rm.id_nivel+1) from mig.record_matricula rm where rm.id_record_oferta = rg.id_record_oferta order by rm.id_number desc),1) as id_nivel,
                 (select vpd.id_estudiante from  mig.vw_personas_desercion vpd where vpd.identificacion=p.identificacion) as id_estudiante,
                 iif(rg.id_record_oferta is null,rn.id_tipo_estado_estudiante,rg.id_tipo_estado_estudiante) as id_tipo_estado_estudiante,
--     null as carece_dispositivos_electronicos,null as dificultad_educacion_virtual,null as problema_salud_mental,null as nivel_satisfaccion_docente, '' as nivel_socioeconomico,'' as nivel_socioeconomico_familia,
   isnull(UPPER((select [tmp].[fn_return_answer_survey](rn.identificacion,'Seguridad de aulas, parqueaderos, campus.',rg.id_periodo_academico_cg) )),'NO REGISTRA') as estado_aulas,
    'NO REGISTRA' as carece_dispositivos_electronicos,
    isnull((select [tmp].[fn_return_answer_survey](rn.identificacion,
'¿Tiene un espacio adecuado para realizar tareas y recibir las clases virtuales?',rg.id_periodo_academico_cg) ),'NO REGISTRA') as dificultad_educacion_virtual,
  isnull((select [tmp].[fn_return_answer_survey](rn.identificacion,
'Usted ha sido diagnosticado con enfermedades mentales cómo: (puede marcar varias opciones):',rg.id_periodo_academico_cg) ),'NINGUNA') as problema_salud_mental,
     isnull(UPPER((select [tmp].[fn_return_answer_survey](rn.identificacion,'Trato y atención de los docentes.',rg.id_periodo_academico_cg) )),'NINGUNA') as nivel_satisfaccion_docente,
     (select [tmp].[fn_return_answer_survey](rn.identificacion,'Ingreso económico mensual $',rg.id_periodo_academico_cg) ) as nivel_socioeconomico,
         (select [tmp].[fn_return_answer_survey](rn.identificacion,'Ingreso económico mensual del grupo familiar con el que usted vive',rg.id_periodo_academico_cg) ) as nivel_socioeconomico_familia,
        cast(isnull(cast( (DATEDIFF(YEAR ,p.fecha_nace, pn.fecha_desde)) as decimal(10,0)),0)as varchar(255)) as edad,roj.redisenios as numero_redisenios,bec.numero_becas,roj.cambios_carrera as numero_cambios_carrera,
        (select count(*) from mig.record_oferta rob where rob.identificacion = p.identificacion and rob.id_periodo_academico_cg<rn.id_periodo_academico_cg and rob.id_tipo_oferta = 1) as numero_cupos_obtenidos,
        (select count(*) from mig.record_oferta rob where rob.identificacion = p.identificacion and rob.id_periodo_academico_cg<rn.id_periodo_academico_cg
                                                      and rob.id_tipo_estado_estudiante = 7 and rob.id_tipo_oferta = 1) as numero_cupos_no_efectivizados,
        (select count(*) from mig.record_oferta rob where rob.identificacion = p.identificacion and rob.id_periodo_academico_cg<rn.id_periodo_academico_cg
                                                      and rob.id_tipo_estado_estudiante in (11,13) and rob.id_tipo_oferta = 1) as numero_cupos_rechazados,0 as numero_clubs_universitarios,
        cast(sum(mat.creditos)*0.05 as decimal(10,0)) as tareas,doc.doc_hombres as numero_profesores,doc.doc_mujeres as numero_profesoras,cast(sum(mat.creditos)*0.003 as decimal(10,0)) as numero_tutorias,
        0 as numero_semestres_ausentes,isnull(matri.matriculas_cursadas,0) as numero_semestres_cursadas,isnull(matri.matriculas_anuladas,0) as numero_semestres_anulados,
        55 as total_materias_malla,asig.total_asignaturas_cursadas,asig.total_asignaturas_aprobadas,asig.total_asignaturas_reprobadas,asig.total_creditos,asig.total_horas,
    rn.periodo as periodo_nivelacion,rg.periodo as periodo_grado,(select top 1 rm.periodo from mig.record_matricula rm where rm.id_record_oferta = rg.id_record_oferta order by rm.id_number desc) as periodo_ultima_matricula,
        iif(egre.ID_EGRESADO is not null,(select top 1 rm.periodo from mig.record_matricula rm where rm.id_record_oferta = rg.id_record_oferta order by rm.id_number desc),'NO APLICA') as periodo_fin_grado,
         isnull(cast(gra.FECHA_GRADUACION as varchar(255)),'NO APLICA') as periodo_graduacion,
         isNULL(cast((DATEDIFF(Month,gra.FECHA_INGRESO_CARRERA, gra.FECHA_GRADUACION)/12.0) as decimal(10,2)),10) as duracion_estudios,
--           ''   as periodo_graduacion, 0   as duracion_estudios,
             rg.promedio,iif(rg.id_tipo_estudiante=4,'SI','NO') as profesional,
         'NO' as deserto,iif(rn.id_tipo_estado_estudiante in (7,9,10,11,13),'SI','NO') as retiro_nivelacion,rn.mantiene_gratuidad

from mig.record_oferta rn
inner join man.personas p on p.identificacion = rn.identificacion
inner join aca.periodo_academico pn on pn.codigo = rn.periodo and pn.estado='A' and pn.id_tipo_oferta = 1
left join (SELECT p.IDENTIFICACION,count(be.ID) as numero_becas
           FROM BD_aCADEMICO..BECAS_ESTUDIANTES AS BE
            RIGHT JOIN bd_academico..te_matriculas ma ON BE.id_matricula = ma.id_matricula and ma.estado = 'A'
            INNER JOIN bd_academico..personas p on p.ID_PERSONA = BE.ID_PERSONA
            inner JOIN bd_academico..VW_TE_CARRERAS_LOCALIDAD ca ON ma.id_carrera_local = ca.id_carrera_local
           WHERE BE.ESTADO = 'A'
           group by p.IDENTIFICACION
--              and p.IDENTIFICACION ='2400254286' and ma.CG_PER_ACADEMICO>6595
)as bec on bec.IDENTIFICACION = p.identificacion
left join mig.record_oferta_jerarquia roj on roj.id_record_origen = rn.id_record_oferta and roj.nodos_max>0
left join mig.record_oferta rg on rg.id_record_oferta = roj.id_record_final
left join aca.estudiante_oferta eo on eo.id_estudiante_oferta = rg.id_estudiante_oferta and eo.estado='A'
-- left join mig.record_oferta rg on rg.id_record_oferta_padre = rn.id_record_oferta and rg.id_tipo_oferta = 2 and rg.estado='A'
left join (select ra.id_record_oferta,sum(ra.creditos) as creditos from mig.record_matricula rm
                    inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
                    where rm.estado='A' and ra.estado='A' group by ra.id_record_oferta) as mat on mat.id_record_oferta = rg.id_record_oferta
left join (
    select ra.id_record_oferta,count(CASE WHEN p.sexo='F' THEN 1 END) AS doc_mujeres,
           count(CASE WHEN p.sexo='M' THEN 1 END) AS doc_hombres from mig.record_matricula rm
      inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
      inner join man.personas p on p.identificacion = ra.identificacion_docente
    where rm.estado='A' and ra.estado='A'-- and rm.id_record_oferta =50093
    group by ra.id_record_oferta
) as doc on doc.id_record_oferta = rg.id_record_oferta
left join (select rm.id_record_oferta,count(CASE WHEN rm.estado in ('C','H','M','N','O','R') THEN 1 END) AS matriculas_anuladas,
                  count(CASE WHEN rm.estado='A' THEN 1 END) AS matriculas_cursadas from mig.record_matricula rm
           where rm.estado<>'I' --and rm.id_record_oferta =50093
           group by rm.id_record_oferta) as matri on matri.id_record_oferta = rg.id_record_oferta
left join (select ra.id_record_oferta,count(ra.id_record_asignatura) AS total_asignaturas_cursadas,count(CASE WHEN ra.aprobado=1 THEN 1 END) AS total_asignaturas_aprobadas,
                  count(CASE WHEN ra.aprobado=0 THEN 1 END) AS total_asignaturas_reprobadas,sum(ra.creditos) as total_creditos,sum(ra.horas) as total_horas
           from mig.record_matricula rm
                    inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
           where  rm.ESTADO='A' --and rm.id_record_oferta =50093
           group by ra.id_record_oferta ) as asig on asig.id_record_oferta = rg.id_record_oferta
left join (select o.ID_CARRERA_OFERTADA,d.ID_EGRESADO,d.ID_PERSONA,d.FECHA_INGRESO,d.FECHA_EGRESO,d.ESTADO,p.IDENTIFICACION,
                  ROW_NUMBER() OVER (PARTITION BY d.ID_EGRESADO  ORDER BY d.FECHA_INGRESO asc ) as indice from Bd_academico.dbo.EG_EGRESADOS as d
           inner join Bd_Academico..PERSONAS p on d.ID_PERSONA = p.ID_PERSONA
           inner join Bd_Academico.dbo.carreras_locales_modalidad_sistema o on o.ID_CARRERA_LOCAL= d.ID_CARRERA_LOCAL and o.CG_MODALIDAD = d.CG_MODALIDAD
             and o.CG_SISTEMA_ESTUDIO = d.CG_SISTEMA_ESTUDIO where d.ESTADO='A') as egre on egre.IDENTIFICACION =p.identificacion
             and egre.ID_CARRERA_OFERTADA = rg.id_carrera_ofertada  and egre.indice=1
left join Bd_academico.dbo.EG_LISTADO_GRADUADOS as gra on gra.ID_EGRESADO= egre.ID_EGRESADO
         -- OUTER APPLY (
--     SELECT TOP 1 r.respuesta_detalle FROM bdupse.seb.enc_preguntas p
--       inner join bdupse.seb.encuestados_respuestas r on p.id=r.encuestas_preguntas_id
--       inner join Bd_Academico..vw_matriculas m on r.enc_personas_id=m.IDENTIFICACION
--     WHERE m.estado='A' and p.estado='AC' and p.descripcion like '%Ingreso económico mensual del grupo familiar con el que usted vive%' and m.IDENTIFICACION = niv.identificacion
--     order by r.fecha_ing
--      ) r
where rn.estado='A' --and rn.id_tipo_oferta = 1 and rg.id_record_oferta is not null
   and rn.periodo between '2012-2' and '2015-2'
         group by p.fecha_nace, pn.fecha_desde,rn.id_oferta_modalidad,rn.id_periodo_academico,rn.identificacion,rn.id_tipo_estado_estudiante,rg.id_tipo_estado_estudiante,
                  rg.id_record_oferta,roj.redisenios,bec.numero_becas,roj.cambios_carrera,p.identificacion,rn.id_periodo_academico_cg,doc.doc_hombres,doc.doc_mujeres,matri.matriculas_cursadas,
                  matri.matriculas_anuladas,asig.total_asignaturas_cursadas,asig.total_asignaturas_reprobadas,asig.total_asignaturas_aprobadas,asig.total_horas,asig.total_creditos,
                  rn.periodo, gra.FECHA_INGRESO_CARRERA, gra.FECHA_GRADUACION, egre.ID_EGRESADO, rg.promedio, rg.id_tipo_estudiante, rn.mantiene_gratuidad,rg.periodo,rg.id_periodo_academico_cg
) as d


-----------------Consultas BI DESERCION
    select * from aca.tipo_estado_estudiante
select * from aca.fn_get_all_offers('0923136881',null,null,null,null,null)


--solo sisweb
     select niv.id_record_oferta,p.identificacion,p.apellidos,p.nombres,case p.sexo when 'M' then 'MASCULINO' when 'F' then 'FEMENINO' else 'NO REGISTRA' end as sexo,niv.carrera as carrera_nivelacion,
            tie.descripcion as tipo_ingreso_carrera,niv.periodo as periodo_ingreso,
                     gra.id_record_oferta,iif(gra.id_record_oferta is not null and gra.id_tipo_oferta=2,gra.carrera,'NO INGRESO A CARRERA') as carrera_grado,
    isnull(auxgra.periodo,auxniv.periodo) as ultimo_periodo,iif(g.fecha_graduacion is null,'NO APLICA',cast(YEAR(g.fecha_graduacion) as varchar(5))) as anio,
                     iif(gra.id_record_oferta is not null,tee2.descripcion,tee.descripcion) as estado_academico,
    case when iif(gra.id_record_oferta is not null,tee2.codigo,tee.codigo) in ('GRA') then 'GRADUADO'
       when iif(gra.id_record_oferta is not null,tee2.codigo,tee.codigo) in ('EGR') or  isnull(auxgra.periodo,auxniv.periodo)='2025-2' then 'PERSISTENTE'
     else 'DESERTOR' end as estado_resumido,iif(gra.id_record_oferta is not null,gra.modalidad,niv.modalidad) as modalidad_estudio
    from mig.record_oferta niv
    inner join aca.tipo_estado_estudiante tee on niv.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
    inner join aca.tipo_ingreso_estudiante tie on niv.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
    inner join man.personas p on p.identificacion = niv.identificacion
    left join
        (select rm.periodo,rm.id_record_oferta, ROW_NUMBER() OVER (PARTITION BY RM.id_record_oferta  ORDER BY rm.periodo desc ) as fila
         from mig.record_matricula rm where rm.estado='A') as auxniv on auxniv.id_record_oferta = niv.id_record_oferta and auxniv.fila=1
    inner join mig.record_oferta_jerarquia roj on roj.id_record_origen = niv.id_record_oferta and roj.nodos_max>0
    left join mig.record_oferta gra on gra.id_record_oferta = roj.id_record_final
    left join aca.tipo_estado_estudiante tee2 on gra.id_tipo_estado_estudiante = tee2.id_tipo_estado_estudiante
    left join aca.tipo_ingreso_estudiante tie2 on gra.id_tipo_ingreso_estudiante = tie2.id_tipo_ingreso_estudiante
    left join
         (select rm.periodo,rm.id_record_oferta, ROW_NUMBER() OVER (PARTITION BY RM.id_record_oferta  ORDER BY rm.periodo desc ) as fila
          from mig.record_matricula rm where rm.estado='A') as auxgra on auxgra.id_record_oferta = gra.id_record_oferta and auxgra.fila=1
    left join (select o.ID_CARRERA_OFERTADA,d.ID_EGRESADO,d.ID_PERSONA,d.FECHA_INGRESO,d.FECHA_EGRESO,d.ESTADO,p.IDENTIFICACION,
                      ROW_NUMBER() OVER (PARTITION BY d.ID_EGRESADO  ORDER BY d.FECHA_INGRESO asc ) as indice from Bd_academico.dbo.EG_EGRESADOS as d
                   inner join Bd_Academico..PERSONAS p on d.ID_PERSONA = p.ID_PERSONA
                   inner join Bd_Academico.dbo.carreras_locales_modalidad_sistema o on o.ID_CARRERA_LOCAL= d.ID_CARRERA_LOCAL and o.CG_MODALIDAD = d.CG_MODALIDAD
        and o.CG_SISTEMA_ESTUDIO = d.CG_SISTEMA_ESTUDIO where d.ESTADO='A') as aux on aux.IDENTIFICACION =p.identificacion
        and aux.ID_CARRERA_OFERTADA = gra.id_carrera_ofertada  and aux.indice=1
    left join Bd_academico.dbo.EG_LISTADO_GRADUADOS as g on g.ID_EGRESADO= aux.ID_EGRESADO
     where niv.id_estudiante_oferta is null and niv.id_estudiante_oferta_destino is null and gra.id_estudiante_oferta is null and gra.id_estudiante_oferta_destino is null
    and niv.periodo>'2012-1'
 union all
--manes que aprobaron el pre een el sisweb y todo lo demas esta en el SGA
     select niv.id_record_oferta,p.identificacion,p.apellidos,p.nombres,case p.sexo when 'M' then 'MASCULINO' when 'F' then 'FEMENINO' else 'NO REGISTRA' end as sexo,niv.carrera as carrera_nivelacion,
            tie.descripcion as tipo_ingreso_carrera,niv.periodo as periodo_ingreso,
                     gra.id_estudiante_oferta,iif(gra.id_estudiante_oferta is not null and gra.id_tipo_oferta=2,gra.carrera,'NO INGRESO A CARRERA') as carrera_grado,
    isnull(gra.periodo,auxniv.periodo) as ultimo_periodo,iif(gra.fecha_graduacion is null,'NO APLICA',cast(YEAR(gra.fecha_graduacion) as varchar(5))) as anio,
                     iif(gra.id_estudiante_oferta is not null,gra.estado_carrera,tee.descripcion) as estado_academico,

     case when iif(gra.id_estudiante_oferta is not null,gra.codigo_estado_carrera,tee.codigo) in ('GRA') then 'GRADUADO'
       when iif(gra.id_estudiante_oferta is not null,gra.codigo_estado_carrera,tee.codigo) in ('EGR') or  isnull(gra.periodo,auxniv.periodo)='2025-2' then 'PERSISTENTE'
     else 'DESERTOR' end as estado_resumido,iif(gra.id_estudiante_oferta is not null,gra.modalidad,niv.modalidad) as modalidad_estudio
    from mig.record_oferta niv
    inner join aca.tipo_estado_estudiante tee on niv.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
    inner join aca.tipo_ingreso_estudiante tie on niv.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
    inner join man.personas p on p.identificacion = niv.identificacion
    left join mig.record_oferta_jerarquia roj on roj.id_record_origen = niv.id_record_oferta and roj.nodos_max>0
    left join
        (select rm.periodo,rm.id_record_oferta, ROW_NUMBER() OVER (PARTITION BY RM.id_record_oferta  ORDER BY rm.periodo desc ) as fila
         from mig.record_matricula rm where rm.estado='A') as auxniv on auxniv.id_record_oferta = niv.id_record_oferta and auxniv.fila=1
    left join mig.record_oferta grap on grap.id_record_oferta = roj.id_record_final
    inner join mig.estudiante_oferta_jerarquia eoj on eoj.id_estudiante_oferta_origen = niv.id_estudiante_oferta_destino
    inner join
         (select om.id_tipo_oferta,om.carrera,om.modalidad,eo.id_estudiante_oferta,g.FECHA_GRADUACION,tee2.descripcion as estado_carrera,per.periodo,tee2.codigo as codigo_estado_carrera
          from aca.estudiante_oferta eo
    inner join man.personas p on eo.id_persona = p.id
    left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
    inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
    inner join aca.tipo_estado_estudiante tee2 on eo.id_tipo_estado_estudiante = tee2.id_tipo_estado_estudiante
    inner join aca.tipo_ingreso_estudiante tie2 on eo.id_tipo_ingreso_estudiante = tie2.id_tipo_ingreso_estudiante
    left  join  (select pa.codigo as periodo,em1.id_estudiante_oferta,ROW_NUMBER() OVER (PARTITION BY em1.id_estudiante_oferta  ORDER BY pa.codigo desc ) as fila from aca.estudiante_matricula em1
                                            inner join aca.matricula_general mg on em1.id_matricula_general = mg.id_matricula_general
                                            inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
            where em1.estado='A') as per on per.id_estudiante_oferta = eo.id_estudiante_oferta and per.fila = 1
    left join migracion_sga..registros_migracion rm on rm.id_entidad_relacion = 2 and rm.id_destino = eo.id_oferta_modalidad
    left join (select o.ID_CARRERA_OFERTADA,d.ID_EGRESADO,d.ID_PERSONA,d.FECHA_INGRESO,d.FECHA_EGRESO,d.ESTADO,p.IDENTIFICACION,
               ROW_NUMBER() OVER (PARTITION BY d.ID_EGRESADO ORDER BY d.FECHA_INGRESO asc ) as indice from Bd_academico.dbo.EG_EGRESADOS as d
            inner join Bd_Academico..PERSONAS p on d.ID_PERSONA = p.ID_PERSONA
            inner join Bd_Academico.dbo.carreras_locales_modalidad_sistema o on o.ID_CARRERA_LOCAL= d.ID_CARRERA_LOCAL and o.CG_MODALIDAD = d.CG_MODALIDAD
            and o.CG_SISTEMA_ESTUDIO = d.CG_SISTEMA_ESTUDIO where d.ESTADO='A') as aux on aux.IDENTIFICACION =p.identificacion
                                                      and aux.ID_CARRERA_OFERTADA = rm.id_origen and aux.indice =1
    left join Bd_academico.dbo.EG_LISTADO_GRADUADOS as g on g.ID_EGRESADO= aux.ID_EGRESADO
    where eo.estado='A'
             ) as gra on gra.id_estudiante_oferta = eoj.id_estudiante_oferta_final
     where niv.id_estudiante_oferta_destino is not null   and grap.id_estudiante_oferta is null and grap.id_estudiante_oferta_destino is null
    and niv.periodo>'2012-1'
    group by niv.id_record_oferta, p.identificacion, p.apellidos, p.nombres, p.sexo, niv.carrera, tie.descripcion, niv.periodo, gra.id_estudiante_oferta, gra.id_tipo_oferta,
             gra.carrera, auxniv.periodo, gra.fecha_graduacion, tee.descripcion, gra.modalidad, niv.modalidad,gra.periodo,gra.estado_carrera,gra.codigo_estado_carrera,tee.codigo
union all
--sisweb con continuacion en sga
     select niv.id_record_oferta,p.identificacion,p.apellidos,p.nombres,case p.sexo when 'M' then 'MASCULINO' when 'F' then 'FEMENINO' else 'NO REGISTRA' end as sexo,niv.carrera as carrera_nivelacion,
            tie.descripcion as tipo_ingreso_carrera,niv.periodo as periodo_ingreso,
                     gra.id_estudiante_oferta,iif(gra.id_estudiante_oferta is not null and gra.id_tipo_oferta=2,gra.carrera,'NO INGRESO A CARRERA') as carrera_grado,
    isnull(gra.periodo,auxniv.periodo) as ultimo_periodo,iif(gra.fecha_graduacion is null,'NO APLICA',cast(YEAR(gra.fecha_graduacion) as varchar(5))) as anio,
                     iif(gra.id_estudiante_oferta is not null,gra.estado_carrera,tee.descripcion) as estado_academico,

                     case when iif(gra.id_estudiante_oferta is not null,gra.codigo_estado_carrera,tee.codigo) in ('GRA') then 'GRADUADO'
       when iif(gra.id_estudiante_oferta is not null,gra.codigo_estado_carrera,tee.codigo) in ('EGR') or  isnull(gra.periodo,auxniv.periodo)='2025-2' then 'PERSISTENTE'
     else 'DESERTOR' end as estado_resumido,iif(gra.id_estudiante_oferta is not null,gra.modalidad,niv.modalidad) as modalidad_estudio
    from mig.record_oferta niv
    inner join aca.tipo_estado_estudiante tee on niv.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
    inner join aca.tipo_ingreso_estudiante tie on niv.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
    inner join man.personas p on p.identificacion = niv.identificacion
    inner join mig.record_oferta_jerarquia roj on roj.id_record_origen = niv.id_record_oferta and roj.nodos_max>0
    left join
        (select rm.periodo,rm.id_record_oferta, ROW_NUMBER() OVER (PARTITION BY RM.id_record_oferta  ORDER BY rm.periodo desc ) as fila
         from mig.record_matricula rm where rm.estado='A') as auxniv on auxniv.id_record_oferta = niv.id_record_oferta and auxniv.fila=1
    left join mig.record_oferta grap on grap.id_record_oferta = roj.id_record_final
    inner join mig.estudiante_oferta_jerarquia eoj on eoj.id_estudiante_oferta_origen = grap.id_estudiante_oferta
    inner join
         (select om.id_tipo_oferta,om.carrera,om.modalidad,eo.id_estudiante_oferta,g.FECHA_GRADUACION,tee2.descripcion as estado_carrera,isnull(per.periodo,pa.codigo) as periodo,
                 tee2.codigo as codigo_estado_carrera
          from aca.estudiante_oferta eo
    inner join man.personas p on eo.id_persona = p.id
    left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
    inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
    inner join aca.tipo_estado_estudiante tee2 on eo.id_tipo_estado_estudiante = tee2.id_tipo_estado_estudiante
    inner join aca.tipo_ingreso_estudiante tie2 on eo.id_tipo_ingreso_estudiante = tie2.id_tipo_ingreso_estudiante
    left  join  (select pa.codigo as periodo,em1.id_estudiante_oferta,ROW_NUMBER() OVER (PARTITION BY em1.id_estudiante_oferta  ORDER BY pa.codigo desc ) as fila from aca.estudiante_matricula em1
                                            inner join aca.matricula_general mg on em1.id_matricula_general = mg.id_matricula_general
                                            inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
            where em1.estado='A') as per on per.id_estudiante_oferta = eo.id_estudiante_oferta and per.fila = 1
    left join migracion_sga..registros_migracion rm on rm.id_entidad_relacion = 2 and rm.id_destino = eo.id_oferta_modalidad
    left join (select o.ID_CARRERA_OFERTADA,d.ID_EGRESADO,d.ID_PERSONA,d.FECHA_INGRESO,d.FECHA_EGRESO,d.ESTADO,p.IDENTIFICACION,
               ROW_NUMBER() OVER (PARTITION BY d.ID_EGRESADO ORDER BY d.FECHA_INGRESO asc ) as indice from Bd_academico.dbo.EG_EGRESADOS as d
            inner join Bd_Academico..PERSONAS p on d.ID_PERSONA = p.ID_PERSONA
            inner join Bd_Academico.dbo.carreras_locales_modalidad_sistema o on o.ID_CARRERA_LOCAL= d.ID_CARRERA_LOCAL and o.CG_MODALIDAD = d.CG_MODALIDAD
            and o.CG_SISTEMA_ESTUDIO = d.CG_SISTEMA_ESTUDIO where d.ESTADO='A') as aux on aux.IDENTIFICACION =p.identificacion
                                                      and aux.ID_CARRERA_OFERTADA = rm.id_origen and aux.indice =1
    left join Bd_academico.dbo.EG_LISTADO_GRADUADOS as g on g.ID_EGRESADO= aux.ID_EGRESADO
    where eo.estado='A'
             ) as gra on gra.id_estudiante_oferta = eoj.id_estudiante_oferta_final
     where     niv.id_estudiante_oferta_destino is null and niv.id_estudiante_oferta is null
           and grap.id_estudiante_oferta is not null and grap.id_estudiante_oferta_destino is null --and p.identificacion='0928168632'
    and niv.periodo>'2012-1'
    group by niv.id_record_oferta, p.identificacion, p.apellidos, p.nombres, p.sexo, niv.carrera, tie.descripcion, niv.periodo, gra.id_estudiante_oferta, gra.id_tipo_oferta,
             gra.carrera, auxniv.periodo, gra.fecha_graduacion, tee.descripcion, gra.modalidad, niv.modalidad,gra.periodo,gra.estado_carrera,gra.codigo_estado_carrera,tee.codigo
union all
---todo esta en el SGA
     select niv.id_estudiante_oferta,p.identificacion,p.apellidos,p.nombres,case p.sexo when 'M' then 'MASCULINO' when 'F' then 'FEMENINO' else 'NO REGISTRA' end as sexo,niv.carrera as carrera_nivelacion,
            niv.tipo_ingreso as tipo_ingreso_carrera,niv.periodo as periodo_ingreso, gra.id_estudiante_oferta,iif(gra.id_estudiante_oferta is not null and gra.id_tipo_oferta=2,
                                                                                                                    gra.carrera,'NO INGRESO A CARRERA') as carrera_grado,
    isnull(gra.periodo,niv.periodo) as ultimo_periodo,iif(gra.fecha_graduacion is null,'NO APLICA',cast(YEAR(gra.fecha_graduacion) as varchar(5))) as anio,
                     iif(gra.id_estudiante_oferta is not null,gra.estado_carrera,niv.estado_carrera) as estado_academico,

      case when iif(gra.id_estudiante_oferta is not null,gra.codigo_estado_carrera,niv.codigo_estado_carrera) in ('GRA') then 'GRADUADO'
       when iif(gra.id_estudiante_oferta is not null,gra.codigo_estado_carrera,niv.codigo_estado_carrera) in ('EGR') or  isnull(gra.periodo,niv.periodo)='2025-2' then 'PERSISTENTE'
     else 'DESERTOR' end as estado_resumido,iif(gra.id_estudiante_oferta is not null,gra.modalidad,niv.modalidad) as modalidad_estudio
    from man.personas p
    inner join (select p.id as id_persona,om.id_tipo_oferta,om.carrera,om.modalidad,eo.id_estudiante_oferta,tee1.descripcion as estado_carrera,isnull(per.periodo,pa.codigo) as periodo,tie1.descripcion tipo_ingreso,
                          tee1.codigo as codigo_estado_carrera
          from aca.estudiante_oferta eo
    inner join man.personas p on eo.id_persona = p.id
    left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
    inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
    inner join aca.tipo_estado_estudiante tee1 on eo.id_tipo_estado_estudiante = tee1.id_tipo_estado_estudiante
    inner join aca.tipo_ingreso_estudiante tie1 on eo.id_tipo_ingreso_estudiante = tie1.id_tipo_ingreso_estudiante
    left  join  (select pa.codigo as periodo,em1.id_estudiante_oferta,ROW_NUMBER() OVER (PARTITION BY em1.id_estudiante_oferta  ORDER BY pa.codigo desc ) as fila from aca.estudiante_matricula em1
                                            inner join aca.matricula_general mg on em1.id_matricula_general = mg.id_matricula_general
                                            inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
            where em1.estado='A') as per on per.id_estudiante_oferta = eo.id_estudiante_oferta and per.fila = 1
    where eo.estado='A' and om.id_tipo_oferta in (1,2) and eo.id_estudiante_oferta_padre is null
             ) as niv on niv.id_persona = p.id
    left join mig.record_oferta ro on ro.id_estudiante_oferta = niv.id_estudiante_oferta  and ro.estado='A'
    left join mig.record_oferta ro1 on ro1.id_estudiante_oferta_destino=niv.id_estudiante_oferta and ro1.estado='A'
    inner join mig.estudiante_oferta_jerarquia eoj on eoj.id_estudiante_oferta_origen = niv.id_estudiante_oferta and eoj.nodos_max>0
    inner join
         (select om.id_tipo_oferta,om.carrera,om.modalidad,eo.id_estudiante_oferta,g.FECHA_GRADUACION,tee2.descripcion as estado_carrera,isnull(per.periodo,pa.codigo) as periodo,
                    tee2.codigo as codigo_estado_carrera
          from aca.estudiante_oferta eo
    inner join man.personas p on eo.id_persona = p.id
    left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
    inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
    inner join aca.tipo_estado_estudiante tee2 on eo.id_tipo_estado_estudiante = tee2.id_tipo_estado_estudiante
    inner join aca.tipo_ingreso_estudiante tie2 on eo.id_tipo_ingreso_estudiante = tie2.id_tipo_ingreso_estudiante
    left  join  (select pa.codigo as periodo,em1.id_estudiante_oferta,ROW_NUMBER() OVER (PARTITION BY em1.id_estudiante_oferta  ORDER BY pa.codigo desc ) as fila from aca.estudiante_matricula em1
                                            inner join aca.matricula_general mg on em1.id_matricula_general = mg.id_matricula_general
                                            inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
            where em1.estado='A') as per on per.id_estudiante_oferta = eo.id_estudiante_oferta and per.fila = 1
    left join migracion_sga..registros_migracion rm on rm.id_entidad_relacion = 2 and rm.id_destino = eo.id_oferta_modalidad
    left join (select o.ID_CARRERA_OFERTADA,d.ID_EGRESADO,d.ID_PERSONA,d.FECHA_INGRESO,d.FECHA_EGRESO,d.ESTADO,p.IDENTIFICACION,
               ROW_NUMBER() OVER (PARTITION BY d.ID_EGRESADO ORDER BY d.FECHA_INGRESO asc ) as indice from Bd_academico.dbo.EG_EGRESADOS as d
            inner join Bd_Academico..PERSONAS p on d.ID_PERSONA = p.ID_PERSONA
            inner join Bd_Academico.dbo.carreras_locales_modalidad_sistema o on o.ID_CARRERA_LOCAL= d.ID_CARRERA_LOCAL and o.CG_MODALIDAD = d.CG_MODALIDAD
            and o.CG_SISTEMA_ESTUDIO = d.CG_SISTEMA_ESTUDIO where d.ESTADO='A') as aux on aux.IDENTIFICACION =p.identificacion
                                                      and aux.ID_CARRERA_OFERTADA = rm.id_origen and aux.indice =1
    left join Bd_academico.dbo.EG_LISTADO_GRADUADOS as g on g.ID_EGRESADO= aux.ID_EGRESADO
    where eo.estado='A'
             ) as gra on gra.id_estudiante_oferta = eoj.id_estudiante_oferta_final
     where     p.estado='AC' and ro.id_record_oferta is null and ro1.id_record_oferta is null
    group by niv.id_estudiante_oferta, p.identificacion, p.apellidos, p.nombres, p.sexo, niv.carrera, niv.tipo_ingreso, niv.periodo, gra.id_estudiante_oferta, gra.id_tipo_oferta,
             gra.carrera, niv.periodo, gra.fecha_graduacion, niv.tipo_ingreso, gra.modalidad, niv.modalidad,gra.periodo,gra.estado_carrera,niv.estado_carrera,
             gra.codigo_estado_carrera,niv.codigo_estado_carrera

select * from mig.record_oferta_jerarquia_grado

select * from mig.estudiante_oferta_jerarquia_grado
--datos extras
SELECT p.id,p.descripcion
From bdupse.seb.enc_preguntas p
WHERE p.estado='AC'
--   and p.descripcion like '%Ingreso económico mensual del grupo familiar con el que usted vive%'
order by p.descripcion

--aulas adecuadas
SELECT m.IDENTIFICACION,m.NOMBRE, m.CARRERA, r.respuesta_detalle,p.descripcion
     ,CASE
          WHEN TRY_CAST(r.respuesta_detalle AS FLOAT) IS NULL THEN 'Sin ingresos'
          WHEN TRY_CAST(r.respuesta_detalle AS FLOAT) = 0 THEN 'Sin ingresos'
          WHEN TRY_CAST(r.respuesta_detalle AS FLOAT) BETWEEN 1 AND 100 THEN 'Entre 1 y 100'
          WHEN TRY_CAST(r.respuesta_detalle AS FLOAT) BETWEEN 101 AND 250 THEN 'Entre 101 y 250'
          WHEN TRY_CAST(r.respuesta_detalle AS FLOAT) BETWEEN 251 AND 500 THEN 'Entre 251 y 500'
          WHEN TRY_CAST(r.respuesta_detalle AS FLOAT) BETWEEN 501 AND 750 THEN 'Entre 501 y 750'
          WHEN TRY_CAST(r.respuesta_detalle AS FLOAT) BETWEEN 751 AND 1000 THEN 'Entre 751 y 1000'
          WHEN TRY_CAST(r.respuesta_detalle AS FLOAT) > 1000 THEN 'Más de 1000'
    END AS RangoIngresos,m.CG_PER_ACADEMICO
From bdupse.seb.enc_preguntas p inner join bdupse.seb.encuestados_respuestas r on p.id=r.encuestas_preguntas_id
                                inner join Bd_Academico..vw_matriculas m on r.enc_personas_id=m.IDENTIFICACION
WHERE m.estado='A' and p.estado='AC' and p.descripcion like '%Ingreso económico mensual del grupo familiar con el que usted vive%'
  and m.IDENTIFICACION ='2400254286'
order by NOMBRE,r.fecha_ing

select * from mig.record_oferta where identificacion='2400254286'

SELECT m.IDENTIFICACION,m.NOMBRE, m.CARRERA, r.respuesta_detalle,p.descripcion
From bdupse.seb.enc_preguntas p inner join bdupse.seb.encuestados_respuestas r on p.id=r.encuestas_preguntas_id
                                inner join Bd_Academico..vw_matriculas m on r.enc_personas_id=m.IDENTIFICACION
WHERE cg_per_academico =28471  and m.estado='A' and p.estado='AC' and m.CG_PER_ACADEMICO=28471
--   and p.descripcion like '%Ingreso económico mensual del grupo familiar con el que usted vive%'
order by NOMBRE
select * from bdupse.seb.encuesta



select o.ID_CARRERA_OFERTADA,d.ID_EGRESADO,d.ID_PERSONA,d.FECHA_INGRESO,d.FECHA_EGRESO,d.ESTADO,p.IDENTIFICACION,
       ROW_NUMBER() OVER (PARTITION BY d.ID_EGRESADO  ORDER BY d.FECHA_INGRESO asc ) as indice from Bd_academico.dbo.EG_EGRESADOS as d
                                                                                                        inner join Bd_Academico..PERSONAS p on d.ID_PERSONA = p.ID_PERSONA
                                                                                                        inner join Bd_Academico.dbo.carreras_locales_modalidad_sistema o on o.ID_CARRERA_LOCAL= d.ID_CARRERA_LOCAL and o.CG_MODALIDAD = d.CG_MODALIDAD
    and o.CG_SISTEMA_ESTUDIO = d.CG_SISTEMA_ESTUDIO where d.ESTADO='A' and p.IDENTIFICACION='0917005688'




--nivel socieconomico
select p.identificacion iden ,p.nombres+' '+p.apellidos nombres,p.email_personal,
       p.email_institucional,cfp.puntaje,   ( select t.grupo from (
                                                                      select
                                                                          case
                                                                              when  cfp.puntaje>=  gs.umbral_inferior and   cfp.puntaje<= gs.umbral_superior
                                                                                  then gs.descripcion+' '+gs.identificador
                                                                              end as grupo
                                                                      from dbu.grupo_socioeconomico gs where gs.estado='A') as  t where t.grupo is not null
       ) nivelSocieconomico,
       pa.descripcion  periodo,tf.descripcion
from man.personas p inner join  dbu.cab_ficha_persona cfp on p.id = cfp.id_persona
                    inner join dbu.ficha f on cfp.id_ficha = f.id_ficha
                    inner join dbu.tipo_ficha tf on f.id_tipo_ficha = tf.id_tipo_ficha
                    inner join aca.periodo_academico pa on f.id_periodo_academico = pa.id_periodo_academico
where cfp.estado='A' and f.estado='A' and tf.estado='A'   and  f.id_periodo_academico=35 and tf.codigo='FICHASOCIOECONOMICA'

--listar estado socioecomico de la familia
select p.identificacion ,p.nombres,p.apellidos ,f.descripcion as ficha   ,pf.descripcion as pregunta ,offp.descripcion as  respuesta ,dfp.valor_abierta respuestaAbierta
from dbu.pregunta_ficha pf inner join dbu.opcion_pregunta_ficha  opf on pf.id_pregunta_ficha = opf.id_pregunta_ficha
                           inner join dbu.opcion_ficha offp on opf.id_opcion_ficha = offp.id_opcion_ficha
                           inner join dbu.ficha_opcion_pregunta_ficha fopf on opf.id_opcion_pregunta_ficha = fopf.id_opcion_pregunta_ficha
                           inner join dbu.ficha f on fopf.id_ficha = f.id_ficha
                           inner join dbu.tipo_ficha tf on f.id_tipo_ficha = tf.id_tipo_ficha

                           inner join dbu.det_ficha_persona dfp on fopf.id_ficha_opcion_pregunta_ficha = dfp.id_ficha_opcion_pregunta_ficha

                           inner join dbu.cab_ficha_persona cfp on dfp.id_cab_ficha_persona = cfp.id_cab_ficha_persona
                           inner join man.personas p on cfp.id_persona = p.id

where fopf.estado='A' and opf.estado='A' and pf.estado='A' and f.estado='A'   and  f.id_periodo_academico=35   -- and tf.codigo='FICHASOCIOECONOMICA'
  and pf.descripcion like '%Ingreso económico mensual del grupo familiar con el que usted vive%'

--enfermedades
select p.identificacion ,p.nombres,p.apellidos ,f.descripcion as ficha   ,pf.descripcion as pregunta ,offp.descripcion as  respuesta ,dfp.valor_abierta respuestaAbierta
from dbu.pregunta_ficha pf inner join dbu.opcion_pregunta_ficha  opf on pf.id_pregunta_ficha = opf.id_pregunta_ficha
                           inner join dbu.opcion_ficha offp on opf.id_opcion_ficha = offp.id_opcion_ficha
                           inner join dbu.ficha_opcion_pregunta_ficha fopf on opf.id_opcion_pregunta_ficha = fopf.id_opcion_pregunta_ficha
                           inner join dbu.ficha f on fopf.id_ficha = f.id_ficha
                           inner join dbu.tipo_ficha tf on f.id_tipo_ficha = tf.id_tipo_ficha

                           inner join dbu.det_ficha_persona dfp on fopf.id_ficha_opcion_pregunta_ficha = dfp.id_ficha_opcion_pregunta_ficha

                           inner join dbu.cab_ficha_persona cfp on dfp.id_cab_ficha_persona = cfp.id_cab_ficha_persona
                           inner join man.personas p on cfp.id_persona = p.id

where fopf.estado='A' and opf.estado='A' and pf.estado='A' and f.estado='A'   and  f.id_periodo_academico=35
  and dfp.estado='A'
  -- and tf.codigo='FICHASOCIOECONOMICA'
  and pf.descripcion like '%Usted ha sido diagnosticado con enfermedades mentales cómo (puede marcar varias opciones)%'

/****************************/
/* pregunta de aspceto academico spcicologia  ************/

select p.identificacion ,p.nombres,p.apellidos ,f.descripcion as ficha   ,pf.descripcion as pregunta ,offp.descripcion as  respuesta ,dfp.valor_abierta respuestaAbierta
from dbu.pregunta_ficha pf inner join dbu.opcion_pregunta_ficha  opf on pf.id_pregunta_ficha = opf.id_pregunta_ficha
                           inner join dbu.opcion_ficha offp on opf.id_opcion_ficha = offp.id_opcion_ficha
                           inner join dbu.ficha_opcion_pregunta_ficha fopf on opf.id_opcion_pregunta_ficha = fopf.id_opcion_pregunta_ficha
                           inner join dbu.ficha f on fopf.id_ficha = f.id_ficha
                           inner join dbu.tipo_ficha tf on f.id_tipo_ficha = tf.id_tipo_ficha
                           inner join dbu.seccion se on pf.id_seccion = se.id_seccion

                           inner join dbu.det_ficha_persona dfp on fopf.id_ficha_opcion_pregunta_ficha = dfp.id_ficha_opcion_pregunta_ficha

                           inner join dbu.cab_ficha_persona cfp on dfp.id_cab_ficha_persona = cfp.id_cab_ficha_persona
                           inner join man.personas p on cfp.id_persona = p.id

where fopf.estado='A' and opf.estado='A' and pf.estado='A' and f.estado='A'   and  f.id_periodo_academico=35
  and dfp.estado='A'
  and se.codigo='ASPECTOACADÉMICO'


    /*********  por preguntas *********/


  and pf.descripcion like  '%Siente que el estudio le genera estrés%'
  and pf.descripcion like  '%Cuál de estas situaciones te genera mayor estrés (puede señalar varias alternativas)%'
  and pf.descripcion like    '%Cumple con su desenvolvimiento académico con responsabilidad (puede señalar varias alternativas)%'
  and pf.descripcion like   '%Utiliza técnicas de estudio en su proceso de aprendizaje%'
  and pf.descripcion like   '%Ha presentado pérdida de semestre%'
  and pf.descripcion like   '%Si la respuesta anterior es si, especifique la razón del retraso académico%'
  and pf.descripcion like  '%Necesidades Educativas Especiales (NEE) No Asociadas a Discapacidad: estas necesidades si bien no tienen relación con una discapacidad, son requerimientos que se presentan en los procesos de aprendizaje y vuelven vulnerables a los/las estudiantes que las poseen. Responde si tienes diagnóstico realizado por un profesional, en alguna de estas Dificultades Específicas de Aprendizaje%'
  and pf.descripcion like  '%Responde si tienes evaluación con diagnóstico de un profesional de%'
  and pf.descripcion like   '%La Carrera universitaria elegida es por vocación propia%'
  and pf.descripcion like   '%Si respondiste que tienes Altas Capacidades Intelectuales, añade el certificado del Ministerio de Salud Pública o del Profesional particular que confirme el diagnóstico%'
  and pf.descripcion like   '%Si respondiste a alguna de las NEE no asociadas a discapacidad, añade el certificado del Ministerio de Salud Pública o del Profesional particular que confirme el diagnóstico%'



select AAC.* from aca.acta_calificacion ac
                      inner join aca.acta_apertura aa on ac.id_acta_calificacion=aa.id_acta_calificacion
                      inner join aca.malla_asignatura ma on ac.id_malla_asignatura=ma.id_malla_asignatura
                      inner join aca.calificacion_general cg on ac.id_calificacion_general=cg.id_calificacion_general
                      INNER JOIN ACA.acta_apertura_componente AAC ON AA.id_acta_apertura=AAC.id_acta_apertura
where ac.estado in ('A', 'C') AND CG.id_periodo_academico=36 and ac.id_ciclo=2 and ma.UICII=1
  and aA.id_acta_apertura in (select max(aa1.id_acta_apertura) from aca.acta_calificacion ac1
                                                                        inner join aca.acta_apertura aa1 on ac1.id_acta_calificacion=aa1.id_acta_calificacion
                                                                        inner join aca.malla_asignatura ma1 on ac1.id_malla_asignatura=ma1.id_malla_asignatura
                                                                        inner join aca.calificacion_general cg1 on ac1.id_calificacion_general=cg1.id_calificacion_general
                              where ac1.estado in ('A', 'C') AND CG1.id_periodo_academico=36 and ac1.id_ciclo=2 and ma1.UICII=1 and aa1.estado='A'
                              group by cg1.id_calificacion_general, ac1.id_malla_asignatura, ac1.id_paralelo, ac1.id_ciclo)

SELECT m.IDENTIFICACION,m.NOMBRE, m.CARRERA, r.respuesta_detalle
From bdupse.seb.enc_preguntas p inner join bdupse.seb.encuestados_respuestas r on p.id=r.encuestas_preguntas_id
                                inner join Bd_Academico..vw_matriculas m on r.enc_personas_id=m.IDENTIFICACION
WHERE cg_per_academico =28471  and m.estado='A' and p.estado='AC' and m.CG_PER_ACADEMICO=28471
  and p.descripcion like '%Ingreso económico mensual del grupo familiar con el que usted vive%'
order by NOMBRE

--saber si tuvo beca
SELECT DISTINCT PERIODO_ACADEMICO = (SELECT VALOR_TEXTO FROM BD_aCADEMICO..TP_CODIGOS WHERE CORRELATIVO = MA.CG_PER_ACADEMICO AND ma.ESTADO = 'A'),
                CODIGO_IES = '1023',
                CODIGO_CARRERA = (select pe.codigo_carrera from Bd_Academico..VW_PLAN_ESTUDIOS as pe where pe.ESTADO = 'A' and ma.id_plan = pe.ID_PLAN),
                                    ca.CARRERA AS NOMBRE_CARRERA,
                CIUDAD_CARRERA = ltrim(rtrim(substring ( ca.LOCALIDAD, CHARINDEX('.-',  ca.LOCALIDAD)+2,len( ca.LOCALIDAD)))),
                TIPO_IDENTIFICACION = (SELECT valor_texto FROM bd_personal..tp_codigos WHERE correlativo = p.CG_TIPO_IDENTIFICACION AND estado = 'A'),
    p.IDENTIFICACION,
                PRIMER_APELLIDO = LTRIM(CASE WHEN LEN(substring(p.apellidos, 1, CHARINDEX(' ', p.apellidos))) >= 4 THEN
                                                 substring(p.apellidos, 1, CHARINDEX(' ', p.apellidos))
                                             WHEN LEN(substring(p.apellidos, 1, CHARINDEX(' ', p.apellidos))) = 3 AND p.apellidos NOT LIKE 'D%' THEN
                                                 substring(p.apellidos, 1, CHARINDEX(' ', p.apellidos))
                                             ELSE substring(p.apellidos, 1, CHARINDEX(' ', p.apellidos, 8))
                    END),
                SEGUNDO_APELLIDO = LTRIM(CASE WHEN LEN(substring(p.apellidos, 1, CHARINDEX(' ', p.apellidos))) >= 4 THEN
                                                  substring(p.apellidos, CHARINDEX(' ', p.apellidos) + 1, LEN(p.apellidos))
                                              WHEN LEN(substring(p.apellidos, 1, CHARINDEX(' ', p.apellidos))) = 3 AND p.apellidos NOT LIKE 'D%' THEN
                                                  substring(p.apellidos, 5, LEN(p.apellidos))
                                              ELSE substring(p.apellidos, CHARINDEX(' ', p.apellidos, 8) + 1, LEN(p.apellidos))
                    END),
    p.NOMBRES,
    ISNULL(BE.CODIGO,' ' ) AS CODIGO_BECA,
    ISNULL(BE.ANIO,' ' ) AS ANIO,
                --ISNULL(CONVERT(VARCHAR, BE.FECHA_INICIO_PERIODO, 103),' - ') AS FECHA_INICIO_PERIODO,
                --ISNULL(CONVERT(VARCHAR, BE.FECHA_FIN_PERIODO, 103),' - ') AS FECHA_FIN_PERIODO,
                FECHA_INICIO_PERIODO = (SELECT CONVERT(VARCHAR, inicio, 103) FROM Bd_Academico..periodos_academicos where cg_per_academico = MA.CG_PER_ACADEMICO and CG_MODALIDAD = 227 and CG_SISTEMA_ESTUDIO = 200),
                FECHA_FIN_PERIODO = (SELECT CONVERT(VARCHAR, culminacion, 103) FROM Bd_Academico..periodos_academicos where cg_per_academico = MA.CG_PER_ACADEMICO and CG_MODALIDAD = 227 and CG_SISTEMA_ESTUDIO = 200),
                TIPO_AYUDA = ISNULL((SELECT VALOR_TEXTO FROM Bd_Academico..TP_CODIGOS WHERE CORRELATIVO = BE.CG_TIPO_BECA),' - ' ),
                MOTIVO_BECA = ISNULL((SELECT VALOR_TEXTO FROM Bd_Academico..TP_CODIGOS WHERE CORRELATIVO = BE.CG_MOTIVO_BECA),' - ' ),
    ISNULL(BE.OTRO_MOTIVO,' ' ) AS OTRO_MOTIVO,
    ISNULL(BE.MONTO,0) AS MONTO_RECIBIDO,
    ISNULL(BE.PORCENTAJE_ARANCEL,0) AS PORCENTAJE_VALOR_ARANCEL,
    ISNULL(BE.PORCENTAJE_MANUTENCION,0) AS PORCENTAJE_VALOR_MANUTENCION,
                TIPO_FINANCIAMIENTO = ISNULL((SELECT VALOR_TEXTO FROM Bd_Academico..TP_CODIGOS WHERE CORRELATIVO = BE.CG_TIPO_FINANCIAMIENTO),' - ' )

FROM
    BD_aCADEMICO..BECAS_ESTUDIANTES AS BE
        RIGHT JOIN bd_academico..te_matriculas ma ON BE.id_matricula = ma.id_matricula and ma.estado = 'A'
        INNER JOIN bd_academico..personas p on p.ID_PERSONA = BE.ID_PERSONA
        inner JOIN bd_academico..VW_TE_CARRERAS_LOCALIDAD ca ON ma.id_carrera_local = ca.id_carrera_local
WHERE
    BE.ESTADO = 'A'
  and ma.id_matricula = (select max (id_matricula) from bd_academico..te_matriculas where id_persona = BE.id_persona and estado = 'A' and cg_per_Academico = ma.cg_per_academico)
--AND YEAR(ma.FECHA_MATRICULACION) >=
--and BE.ANIO = @anio
-- 	AND ma.cg_per_academico in (28151)
ORDER BY 4, 1, 7, 8,9

select * from aca.periodo_academico where id_tipo_oferta = 1

--ficha sis web
SELECT m.IDENTIFICACION,m.NOMBRE, m.CARRERA, r.respuesta_detalle
From bdupse.seb.enc_preguntas p inner join bdupse.seb.encuestados_respuestas r on p.id=r.encuestas_preguntas_id
                                inner join Bd_Academico..vw_matriculas m on r.enc_personas_id=m.IDENTIFICACION
WHERE cg_per_academico =28471  and m.estado='A' and p.estado='AC' and m.CG_PER_ACADEMICO=28471
  and p.descripcion like '%Ingreso económico mensual del grupo familiar con el que usted vive%'
order by NOMBRE
select * from bdupse.seb.encuesta


SELECT count(be.ID) as numero_becas

FROM BD_aCADEMICO..BECAS_ESTUDIANTES AS BE
         RIGHT JOIN bd_academico..te_matriculas ma ON BE.id_matricula = ma.id_matricula and ma.estado = 'A'
         INNER JOIN bd_academico..personas p on p.ID_PERSONA = BE.ID_PERSONA
         inner JOIN bd_academico..VW_TE_CARRERAS_LOCALIDAD ca ON ma.id_carrera_local = ca.id_carrera_local
WHERE BE.ESTADO = 'A'
  and p.IDENTIFICACION ='2400254286' and ma.CG_PER_ACADEMICO>6595


--migraciones varias para BI VICERRECTORADO
SELECT distinct m.IDENTIFICACION,m.NOMBRE, m.CARRERA, r.respuesta_detalle,p.descripcion
From bdupse.seb.enc_preguntas p inner join bdupse.seb.encuestados_respuestas r on p.id=r.encuestas_preguntas_id
                                inner join Bd_Academico..vw_matriculas m on r.enc_personas_id=m.IDENTIFICACION
WHERE m.estado='A' and p.estado='AC' and p.descripcion like '%Ingreso económico mensual del grupo familiar con el que usted vive%'
group by r.fecha_ing, m.IDENTIFICACION, m.NOMBRE, m.CARRERA, r.respuesta_detalle, p.descripcion

SELECT distinct r.respuesta_detalle,CASE
    -- RANGOS EN TEXTO (YA ESTÁN CATEGORIZADOS)
                                        WHEN r.respuesta_detalle IN (
                                                                     '$1 a $200', '$201 a $400', '$401 a $600', '$601 a $800',
                                                                     '$801 a $1000', '$1001 a $1200', '$1201 a $1400', '$1401 a $1600',
                                                                     '$1601 a $1800', '$1801 a $2000', '$2001 a $2200', '$2201 a $2400',
                                                                     '$2401 en adelante'
                                            ) THEN r.respuesta_detalle

    -- VALOR EXACTO EN TEXTO QUE ES UN NÚMERO
                                        WHEN TRY_CAST(REPLACE(REPLACE(r.respuesta_detalle, '$', ''), '.', '') AS FLOAT) BETWEEN 1 AND 200 THEN '$1 a $200'
                                        WHEN TRY_CAST(REPLACE(REPLACE(r.respuesta_detalle, '$', ''), '.', '') AS FLOAT) BETWEEN 201 AND 400 THEN '$201 a $400'
                                        WHEN TRY_CAST(REPLACE(REPLACE(r.respuesta_detalle, '$', ''), '.', '') AS FLOAT) BETWEEN 401 AND 600 THEN '$401 a $600'
                                        WHEN TRY_CAST(REPLACE(REPLACE(r.respuesta_detalle, '$', ''), '.', '') AS FLOAT) BETWEEN 601 AND 800 THEN '$601 a $800'
                                        WHEN TRY_CAST(REPLACE(REPLACE(r.respuesta_detalle, '$', ''), '.', '') AS FLOAT) BETWEEN 801 AND 1000 THEN '$801 a $1000'
                                        WHEN TRY_CAST(REPLACE(REPLACE(r.respuesta_detalle, '$', ''), '.', '') AS FLOAT) BETWEEN 1001 AND 1200 THEN '$1001 a $1200'
                                        WHEN TRY_CAST(REPLACE(REPLACE(r.respuesta_detalle, '$', ''), '.', '') AS FLOAT) BETWEEN 1201 AND 1400 THEN '$1201 a $1400'
                                        WHEN TRY_CAST(REPLACE(REPLACE(r.respuesta_detalle, '$', ''), '.', '') AS FLOAT) BETWEEN 1401 AND 1600 THEN '$1401 a $1600'
                                        WHEN TRY_CAST(REPLACE(REPLACE(r.respuesta_detalle, '$', ''), '.', '') AS FLOAT) BETWEEN 1601 AND 1800 THEN '$1601 a $1800'
                                        WHEN TRY_CAST(REPLACE(REPLACE(r.respuesta_detalle, '$', ''), '.', '') AS FLOAT) BETWEEN 1801 AND 2000 THEN '$1801 a $2000'
                                        WHEN TRY_CAST(REPLACE(REPLACE(r.respuesta_detalle, '$', ''), '.', '') AS FLOAT) BETWEEN 2001 AND 2200 THEN '$2001 a $2200'
                                        WHEN TRY_CAST(REPLACE(REPLACE(r.respuesta_detalle, '$', ''), '.', '') AS FLOAT) BETWEEN 2201 AND 2400 THEN '$2201 a $2400'
                                        WHEN TRY_CAST(REPLACE(REPLACE(r.respuesta_detalle, '$', ''), '.', '') AS FLOAT) > 2400 THEN '$2401 en adelante'

    -- CASOS INVÁLIDOS
                                        ELSE 'Sin ingresos'
    END AS RangoIngresos
From bdupse.seb.enc_preguntas p inner join bdupse.seb.encuestados_respuestas r on p.id=r.encuestas_preguntas_id
                                inner join Bd_Academico..vw_matriculas m on r.enc_personas_id=m.IDENTIFICACION
WHERE m.estado='A' and p.estado='AC' and p.descripcion like '%Ingreso económico mensual del grupo familiar con el que usted vive%'
group by r.fecha_ing, m.IDENTIFICACION, m.NOMBRE, m.CARRERA, r.respuesta_detalle, p.descripcion


-- cnosultar en matrices LEA

select USU_ID,CEDULA,CC_NUM,APELLIDOS,NOMBRES,CARRERA_ACEPTA_CUPO,PERIODO,NOTA_FINAL from tmp.NIVELACION_SEM_HIS where CEDULA in ('0961814357')

select id_estado_academico,apellidos,nombres,carrera_sga,id_estado_academico,periodo,id_estado_cauistica from mig.estado_academicos where identificacion in ('0961814357')

select id_estado_academico,apellidos,nombres,carrera_sga,id_estado_academico,periodo,id_casuistica from mig.estados_academicos_automatic where identificacion in ('0961814357')
select *   from mig.estados_academicos_automatic
select asp.identificacion,asp.nombres,asp.apellidos,asp.carrera,asp.campus,asp.fecha_ing,asp.fecha_mod from bdupse.snu.aspirante asp where asp.identificacion in ('0961814357')

exec aca.sp_rpt_distributivo_docente_depart 136,9,763,'P'

select * from tmp.VW_TABLA_HECHO_INDICADORES