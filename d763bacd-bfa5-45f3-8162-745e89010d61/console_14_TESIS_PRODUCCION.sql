use bd_sga_upse;

--  DBCC CHECKIDENT ('aca.matricula_general', RESEED, 21);

---CONSULTAS FINALES
--paralelos
select p.id_paralelo,p.descripcion_corta as paralelo_corto,p.descripcion as paralelo
from aca.paralelo p where p.id_paralelo between 1 and 10 AND p.estado='A'

--TIEMPO
SELECT * FROM tmp.VW_TABLA_DIM_TIEMPO

--OFERTA
select * from tmp.VW_TABLA_DIM_OFERTA
order by facultad,oferta

--NIVELES
select n.orden as id_nivel,n.descripcion_corta,n.descripcion from aca.nivel n where n.id_tipo_oferta = 2 and n.estado='A'
-- union all
-- select 11 ,'MÓDULOS','MODULAR'

select ra.*
-- update ra set ra.id_nivel = 17
from mig.record_oferta ro
inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
where ro.id_tipo_oferta = 2 and
      ra.estado='A' and ra.id_nivel is null and ra.asignatura not in (select ra.asignatura from mig.record_oferta ro
                                                                   inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
                                                                   inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
                                                                  where ro.id_tipo_oferta = 2 and ra.estado='A' and ra.id_nivel in (1,2,3,4,5,6,7,8,9,10,32,33,34,35,36))
--   and ra.id_nivel in (17,118,19,20,21)

select* from Bd_Academico..NIVELES where ID_NIVEL = 51
select * from aca.nivel n
--FORMULAS
select * from tmp.VW_TABLA_DIM_FORMULAS

--METODOS DE TITULACION
 SELECT * FROM tmp.VW_TABLA_DIM_METODO_TITULACION

-- ESTUDIANTES
select * from tmp.VW_TABLA_DIM_ESTUDIANTES
select * from tmp.VW_TABLA_DIM_ESTUDIANTES
order by nombres


--hechos indicadores
select * from tmp.VW_TABLA_HECHO_INDICADORES
SELECT * from tmp.hecho_indicadores_auxiliar

ALTER VIEW tmp.VW_TABLA_HECHO_INDICADORES as
    select * from  tmp.hecho_indicadores_auxiliar

select * from  tmp.hecho_indicadores_auxiliar where id_estudiante not in (select v.id_estudiante from tmp.VW_TABLA_DIM_ESTUDIANTES v)

---ACTUALIZAR VISTAS
select* from Bd_Personal..TP_CODIGOS where CORRELATIVO = 327
SELECT * FROM tmp.VW_TABLA_DIM_TIEMPO

-- ACTUALIZAR VISTA TIEMPO
    alter VIEW tmp.VW_TABLA_DIM_TIEMPO
    AS
        select CAST(DENSE_RANK() OVER (ORDER BY d.codigo) AS INT) as id_periodo_academico,d.codigo,d.anio,d.periodo,CAST(DENSE_RANK() OVER (ORDER BY d.codigo) AS INT) as orden from (
    select p.codigo as anio,pa.codigo,pa.descripcion as periodo
    from aca.periodo_academico pa
    inner join aca.periodo p on pa.id_periodo = p.id_periodo
    where pa.id_tipo_oferta =2 and pa.estado='A' and p.estado='A' and pa.codigo_tipo_periodo ='PAORD') as d

select distinct ID_DETALLE_PERIODO from Bd_Academico..materias_tomadas mt where mt.ESTADO='A'
select distinct CG_PER_ACADEMICO from Bd_Academico..TE_MATRICULAS mt where mt.ESTADO='A' and CG_PER_ACADEMICO=344

select pa.id_periodo_academico,pa.codigo,pa.descripcion as periodo,pa.fecha_desde,pa.fecha_hasta
from aca.periodo_academico pa
where pa.id_tipo_oferta =2

select * from mig.record_oferta where periodo='2007-2'


-- ACTUALIZAR VISTA OFERTA
select * from tmp.VW_TABLA_DIM_OFERTA
Alter VIEW tmp.VW_TABLA_DIM_OFERTA as
    select distinct --o.id_oferta,
    om.id_oferta_modalidad as id_oferta,concat(om.carrera,' - ',om.modalidad,' - ',om.sistema_estudio) as oferta,CAST(om.facultad AS VARCHAR(250)) AS facultad,
    om.modalidad,c.descripcion_corta as campus,om.sistema_estudio,
    isnull((select TOP 1 d.TITULO from Bd_academico.dbo.EG_LISTADO_GRADUADOS as d
    where d.CARRERA = LEFT(om.carrera, CHARINDEX('-', om.carrera + '-') - 1)),'NO DEFINIDO') as titulo,--ta.descripcion,
    cast((o.duracion/2) as decimal (4,1)) as duracion_carrera ,o.duracion as duracion_periodos from aca.oferta o
    inner join aca.ofertas_facultad om on o.id_oferta = om.id_oferta
    inner join aca.campus c on o.id_campus = c.id_campus
--     left join aca.titulos_academicos ta on ta.id_titulo_academico = o.id_titulo_academico
    where o.estado='A' and o.id_tipo_oferta = 2
    group by om.id_oferta_modalidad, om.carrera, om.modalidad, om.facultad,o.duracion, om.sistema_estudio, c.descripcion_corta


--ACTUALIZAR VISTA FORMULAS
    ALTER VIEW tmp.VW_TABLA_DIM_FORMULAS
    AS
        select cast (1 as int) as id,cast('Indicador 19: Tasa de deserción institucional de segundo año – Oferta académica de grado - CACES'
            as varchar(255)) as indicador,
               3 as anio,6 as periodos,2 as anios_posteriores,4 as periodos_posteriores,0 as anio_adicional,0 periodo_adicional,0 as anio_extendido,0 as periodo_extendido,14 as porcentaje_maximo
        union
        select cast (2 as int) as id,cast('Indicador 21: Tasa de Titulación Institucional - Oferta académica de grado - CACES'
            as varchar(255)) as indicador,0 as anios_posteriores,0 as periodos_posteriores,0 as anio,0 as periodos,
               1 as anio_adicional,2 periodo_adicional,0 as anio_extendido,0 as periodo_extendido,50 as porcentaje_maximo

select * from tmp.VW_TABLA_DIM_FORMULAS


--ACTUALIZAR VISTA METODO DE TITULACION
select * from tmp.VW_TABLA_DIM_METODO_TITULACION
Alter VIEW tmp.VW_TABLA_DIM_METODO_TITULACION
    AS
        select CAST(mt.ID_METODO_TITULACION AS INT) AS id_metodo_titulacion,mt.CODIGO as codigo_metodo,mt.DESCRIPCION as metodo_titulacion
        from Bd_Academico.dbo.EG_METODOS_TITULACION mt where mt.ESTADO='A'
        union all
        select  12 AS ID,CAST('NO-APLI' AS VARCHAR(255)),CAST('NO APLICA' AS VARCHAR(500))

select * from Bd_Academico.dbo.EG_METODOS_TITULACION mt
--paralelos
select* from Bd_Personal..TP_CODIGOS where CORRELATIVO = 93
select* from Bd_Personal..TP_CODIGOS where ID_CLASIFICACION = 31

--titulos
select* from Bd_Personal..TP_CODIGOS where CORRELATIVO = 229
select* from Bd_Personal..TP_CODIGOS pa where pa.ID_CLASIFICACION = 12
select descripcion,descripcion_corta,duracion,id_titulo_academico from aca.oferta where id_tipo_oferta = 2
select * from aca.titulos_academicos
--27724

select * from tmp.VW_TABLA_DIM_ESTUDIANTES




--46146 sisweb
    --49642 sga
ALTER VIEW tmp.VW_TABLA_DIM_ESTUDIANTES AS
select distinct d.id_persona as id_estudiante,d.identificacion, d.nombres, d.sexo,
                d.edad, d.estado_civil, d.discapacidad, d.porcentaje_discapacidad,
                d.pais, d.provincia, d.canton, d.parroquia, d.etnia, d.nacionalidad_indigena from (
       select distinct p.id as id_persona,p.identificacion,concat(p.apellidos,' ',p.nombres) as nombres,
                      iif(p.sexo='M','MASCULINO','FEMENIMO') as sexo,cast(isnull(cast( (DATEDIFF(YEAR ,p.fecha_nace, getdate())) as decimal(10,0)),0) as int) as edad,
                      iif(p.id_estado_civil is null,'NO REGISTRA',ec.descripcion) as estado_civil,
                      iif(p.id_discapacidad is null,'NINGUNA',dis.descripcion) as discapacidad,
                      isnull(iif(p.id_discapacidad is null,'0',iif(p.porcentaje_dis ='','0',p.porcentaje_dis)),'0') as porcentaje_discapacidad,
                      iif(p.id_pais_nacionalidad is null,'NO REGISTRA',pais.descripcion) as pais,iif(p.id_provincia_nacionalidad is null,'NO REGISTRA',pro.descripcion) as provincia,
                      iif(p.id_canton_nacionalidad is null,'NO REGISTRA',can.descripcion) as canton,iif(p.id_parroquia_nacionalidad is null,'NO REGISTRA',par.descripcion) as parroquia,
                      iif(p.id_etnia is null,'NO REGISTRA',e.descripcion) as etnia,iif(p.id_nacionalidad_indigena is null,'NO REGISTRA',nai.descripcion) as nacionalidad_indigena
--     ,'SGA' as sistema
      from man.personas p
               inner join mig.record_oferta ro on ro.id_persona = p.id
                inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
               inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = ro.id_tipo_estado_estudiante
               inner join aca.periodo_academico pa on pa.id_periodo_academico = ro.id_periodo_academico
               inner join aca.oferta_modalidad om on om.id_oferta_modalidad = ro.id_oferta_modalidad
               inner join aca.oferta o on o.id_oferta = om.id_oferta
               left join man.lugar pais on pais.id_lugar = p.id_pais_nacionalidad and pais.estado='A'
               left join man.lugar pro on pro.id_lugar = p.id_provincia_nacionalidad and pro.estado='A'
               left join man.lugar can on can.id_lugar = p.id_canton_nacionalidad and can.estado='A'
               left join man.lugar par on par.id_lugar = p.id_parroquia_nacionalidad and par.estado='A'
               left join man.discapacidad dis on dis.id_discapacidad = p.id_discapacidad and dis.estado='A'
               left join man.etnia e on e.id_etnia = p.id_etnia and e.estado='A'
               left join man.estado_civil ec on p.id_estado_civil = ec.id_estado_civil and ec.estado='A'
               left join man.nacionalidad_indigena nai on nai.id_nacionalidad_indigena = p.id_nacionalidad_indigena and nai.estado='A'
      where p.estado='AC' and ro.estado='A' and om.estado='A' and rm.estado='A' and o.id_tipo_oferta = 2
      union all
      select distinct p.id as id_persona,p.identificacion,concat(p.apellidos,' ',p.nombres) as nombres,
                      iif(p.sexo='M','MASCULINO','FEMENIMO') as sexo,cast(isnull(cast( (DATEDIFF(YEAR ,p.fecha_nace, getdate())) as decimal(10,0)),0)as int) as edad,
                      iif(p.id_estado_civil is null,'NO REGISTRA',ec.descripcion) as estado_civil,
                      iif(p.id_discapacidad is null,'NINGUNA',dis.descripcion) as discapacidad,
                      isnull(iif(p.id_discapacidad is null,'0',iif(p.porcentaje_dis ='','0',p.porcentaje_dis)),'0') as porcentaje_discapacidad,
                      iif(p.id_pais_nacionalidad is null,'NO REGISTRA',pais.descripcion) as pais,iif(p.id_provincia_nacionalidad is null,'NO REGISTRA',pro.descripcion) as provincia,
                      iif(p.id_canton_nacionalidad is null,'NO REGISTRA',can.descripcion) as canton,iif(p.id_parroquia_nacionalidad is null,'NO REGISTRA',par.descripcion) as parroquia,
                      iif(p.id_etnia is null,'NO REGISTRA',e.descripcion) as etnia,iif(p.id_nacionalidad_indigena is null,'NO REGISTRA',nai.descripcion) as nacionalidad_indigena
--     ,'SGA' as sistema
      from man.personas p
               inner join aca.estudiante_oferta eo on eo.id_persona = p.id
               inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
               inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
               inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
               inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
               inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
               inner join aca.oferta o on o.id_oferta = om.id_oferta
               left join man.lugar pais on pais.id_lugar = p.id_pais_nacionalidad and pais.estado='A'
               left join man.lugar pro on pro.id_lugar = p.id_provincia_nacionalidad and pro.estado='A'
               left join man.lugar can on can.id_lugar = p.id_canton_nacionalidad and can.estado='A'
               left join man.lugar par on par.id_lugar = p.id_parroquia_nacionalidad and par.estado='A'
               left join man.discapacidad dis on dis.id_discapacidad = p.id_discapacidad and dis.estado='A'
               left join man.etnia e on e.id_etnia = p.id_etnia and e.estado='A'
               left join man.estado_civil ec on p.id_estado_civil = ec.id_estado_civil and ec.estado='A'
               left join man.nacionalidad_indigena nai on nai.id_nacionalidad_indigena = p.id_nacionalidad_indigena and nai.estado='A'
      where p.estado='AC' and eo.estado='A' and om.estado='A' and em.estado = 'A' and o.id_tipo_oferta = 2 --and p.fecha_nace is null
      ) as d
group by d.nombres,d.identificacion, d.sexo, d.edad, d.estado_civil, d.discapacidad, d.porcentaje_discapacidad,
d.pais, d.provincia, d.canton, d.parroquia, d.etnia, d.nacionalidad_indigena,d.id_persona--,d.sistema


--SETEAR EL CAMPO REGULAR Y HOMOLOGA
--         update d set d.regular = iif(total_asignaturas_cursadas=total_asignaturas_nivel,'SI','NO')
select d.id_oferta, d.id_estudiante, id_tiempo, d.id_nivel, id_paralelo, id_metodo_titulacion, id_formula,
       iif(total_asignaturas_cursadas=total_asignaturas_nivel,'SI','NO') as regular,curso,
       d.homologa as homologa,
       total_asignaturas_cursadas, total_asignaturas_nivel, total_asignaturas_aprobadas,
       total_asignaturas_reprobadas, total_creditos, total_horas, promedio, fecha_ingreso_carrera, fecha_egreso,
       fecha_graduacion, duracion_estudios, tiempo_titulacion
from  tmp.hecho_indicadores_auxiliar as d

update d set d.regular = iif(total_asignaturas_cursadas=total_asignaturas_nivel,'SI','NO')
from  tmp.hecho_indicadores_auxiliar as d

select * from  tmp.hecho_indicadores_auxiliar as d

select distinct ra.* from mig.record_asignaturas ra
inner join mig.record_matricula rm on ra.id_record_matricula = rm.id_record_matricula
inner join mig.record_oferta ro on ra.id_record_oferta = ro.id_record_oferta
where ro.id_tipo_oferta =2 and ra.id_nivel_cg=11
select * from aca.tipo_ingreso_estudiante
select * from aca.tipo_estado_estudiante
select distinct  id_paralelo from mig.record_asignaturas
select * from mig.record_asignaturas where id_nivel_cg =0
select id_record_oferta,id_periodo_academico,id_periodo_academico_cg,periodo from mig.record_oferta where id_periodo_academico is null
select distinct estado,estado_aprobacion,estado_tomada,table_name,table_name_old from mig.record_asignaturas where id_periodo_academico is not null
select * from mig.record_oferta where id_persona is null
select distinct id_periodo_academico,id_periodo_academico_cg,periodo from mig.record_oferta where id_tipo_oferta =1
select *  from mig.record_oferta where id_tipo_oferta =2 and periodo in ('2017-1','2016-2')
select id_periodo_academico,codigo,descripcion,fecha_desde,fecha_hasta from aca.periodo_academico where id_tipo_oferta = 2 and codigo>='2022-1'
select * from mig.listar_carreras_sga where identificacion='0928419902'
select * from mig.listar_carreras_sisweb where identificacion='0928381599'
select pa.CORRELATIVO,pa.VALOR_TEXTO_SIS as anio,pa.VALOR_TEXTO as codigo,
       concat(pa.VALOR_TEXTO,' ','PREGRADO ORDINARIO') as periodo
from Bd_Personal..TP_CODIGOS pa where pa.ID_CLASIFICACION = 33
                                  and NOT ( pa.VALOR_TEXTO LIKE '%-PRE%' OR pa.VALOR_TEXTO LIKE '%PAE%' OR pa.VALOR_TEXTO LIKE '%-3%')
--                                   and pa.CORRELATIVO >= 28152

--190863 sisweb
--actual solo sisweb 94306 actualizado 96622
-- insert into tmp.hecho_indicadores_auxiliar
select * from aca.tipo_ingreso_estudiante
select * from  tmp.hecho_indicadores_auxiliar
select * from aca.nivel
select* from Bd_Academico..NIVELES
select * from tmp.VW_TABLA_DIM_TIEMPO
select distinct ro.* from mig.record_asignaturas ra
                              inner join mig.record_matricula rm on ra.id_record_matricula = rm.id_record_matricula
                              inner join mig.record_oferta ro on ra.id_record_oferta = ro.id_record_oferta
where ro.id_persona =1477 and ro.id_oferta_modalidad=25

select * from mig.listar_carreras_sisweb where identificacion='0915832356'


select * from aca.estudiante_asignatura where usuario_mod is null

update aca.estudiante_asignatura set fecha_mod=fecha_ing where fecha_mod is null

begin
    --145194
--     insert into tmp.hecho_indicadores_auxiliar
    select
    rof.id_oferta_modalidad as id_oferta_modalidad,--tie.descripcion as ingreso,
    ro.id_persona as id_persona,
    vt.id_periodo_academico  as id_tiempo,--rm.id_nivel,rm.id_nivel_cg,
        isnull(n.orden,11) as id_nivel,
        rm.id_paralelo, 11 as id_metodo_titulacion,1 as id_formula,'SI' as regular,
    concat(isnull(n.orden,11),'/',rm.id_paralelo) AS curso, iif(tie.codigo in ('MOV','MOV-EXT'),'SI','NO') as homologa,count(ra.id_materia_plan) as materias,isnull(aux.materiasNivel,0) as materiasNivel,
    count(CASE WHEN Isnull(ra.aprobado,0) = 1 THEN 1 END) AS materias_aprobadas,
    count(CASE WHEN Isnull(ra.aprobado,0) = 0 THEN 1 END) AS materias_reprobadas,
    isnull(sum(ra.creditos),0) as creditos,isnull(sum(ra.horas),0) as horas,avg(isnull(ra.promedio,0)) AS promedio,
    'NO APLICA' as fecha_ingreso_carrera, 'NO APLICA' as fecha_egreso,'NO APLICA' as fecha_graduacion,0 as duracion_estudios,
    'NO APLICA' as tiempo_titulacion
    from man.personas p
    inner join mig.record_oferta ro on p.id = ro.id_persona
    inner join mig.record_oferta_modalidad rom on ro.id_record_oferta = rom.id_record_oferta
    inner join mig.record_oferta rof on rof.id_record_oferta = rom.id_record_oferta_origen
    inner join aca.tipo_ingreso_estudiante tie on rof.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
    inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
    inner join tmp.VW_TABLA_DIM_TIEMPO vt on vt.codigo = rm.periodo
    left JOIN mig.record_asignaturas  ra  ON rm.id_record_matricula = ra.id_record_matricula and ra.estado='A'
        and ((ra.table_name in ('Bd_Academico..MATERIAS_TOMADAS') and ra.estado_tomada not in ('HOMOLOGA','CONVALIDA')) or
             (ra.table_name='sis..notas' and ra.estado_tomada not in ('HOMOLOGAR','CONVALIDA','CONVALIDAR','MODULO')))
    left join aca.nivel n on rm.id_nivel = n.id_nivel
    left join (select mp.ID_PLAN, mp.ID_NIVEL,count(mp.ID_MATERIA_PLAN) as materiasNivel
    from Bd_Academico..MATERIAS_PLAN mp
    where  mp.ESTADO='A'
    group by mp.ID_PLAN,mp.ID_NIVEL) as aux on aux.ID_PLAN = ra.ID_PLAN and aux.ID_NIVEL = rm.id_nivel_cg
    WHERE  ro.ESTADO = 'A' and rm.estado='A' AND p.ESTADO = 'AC' and ro.id_tipo_oferta =2 and  ra.nivel<>'MODULOS'
    and ra.id_nivel_cg not in (11,38,47,48,49,50,51) and rm.id_nivel_cg not in (11,38,47,48,49,50,51)
    group by  p.IDENTIFICACION, vt.id_periodo_academico, aux.materiasNivel, vt.codigo, rm.id_paralelo, ro.id_persona, rm.id_nivel_cg, rm.ID_NIVEL
        ,rof.id_oferta_modalidad, n.orden, tie.descripcion, tie.codigo
union all
--51341
    --98086
        select dd.id_oferta_modalidad,dd.id_persona,dd.id_tiempo,--dd.id_nivel,dd.id_paralelo,
       LEFT(dd.curso,CHARINDEX('/', dd.curso) - 1) as id_nivel,
       RIGHT(dd.curso,LEN(dd.curso) - CHARINDEX('/', dd.curso))  as id_paralelo,dd.id_metodo_titulacion,dd.id_formula,
       dd.regular,dd.curso,dd.homologa,dd.materiasCursadas,isnull(aux.materiasNivel,0) as materiasNivel,dd.materias_aprobadas,dd.materias_reprobadas,
       dd.creditos,dd.horas,dd.promedio,
       dd.fecha_ingreso_carrera,dd.fecha_egreso,dd.fecha_graduacion,
       dd.duracion_estudios,dd.tiempo_titulacion
        from (
        select eof.id_oferta_modalidad,  p.id as id_persona,  vt.id_periodo_academico  as id_tiempo,eo.id_malla,
        11 as id_metodo_titulacion,1 as id_formula,'SI' as regular,
        [aca].[fn_semestre_activo_estudiante] (eo.id_estudiante_oferta,pa.id_periodo_academico) as curso,
        iif(tie.codigo in ('MOV','MOV-EXT'),'SI','NO') as homologa,count(ea.id_estudiante_asignatura) as materiasCursadas,
        count(CASE WHEN Isnull(ea.aprobado,0) = 1 THEN 1 END) AS materias_aprobadas,
        count(CASE WHEN Isnull(ea.aprobado,0) = 0 THEN 1 END) AS materias_reprobadas,
        sum(ma.num_creditos) as creditos,sum(ma.num_horas) as horas,avg(ea.promedio) as promedio,
        'NO APLICA' as fecha_ingreso_carrera, 'NO APLICA' as fecha_egreso,'NO APLICA' as fecha_graduacion,0 as duracion_estudios,
        'NO APLICA' as tiempo_titulacion
        from aca.estudiante_oferta eo
        inner join man.personas p on eo.id_persona = p.id
        inner join mig.estudiante_oferta_modalidad eom on eo.id_estudiante_oferta = eom.id_estudiante_oferta
        inner join aca.estudiante_oferta eof on eof.id_estudiante_oferta = eom.id_estudiante_oferta_origen
        inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
        inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
        inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
        inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
        inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
        inner join aca.paralelo par on ea.id_paralelo = par.id_paralelo
        inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
        inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
        inner join tmp.VW_TABLA_DIM_TIEMPO vt on vt.codigo=pa.codigo
        inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
        inner join aca.oferta o on om.id_oferta = o.id_oferta
        where eo.estado='A' and p.estado='AC' and em.estado='A' and ea.estado='A' and aa.estado='A' and ma.estado='A' and par.estado='A'
        and mg.estado='A' and pa.estado='A' and o.id_tipo_oferta = 2 AND pa.id_tipo_oferta = 2 and pa.codigo_tipo_periodo ='PAORD'
        group by o.id_oferta, eof.id_oferta_modalidad, o.descripcion, p.id, p.identificacion,pa.id_periodo_academico,
        eo.id_estudiante_oferta,p.id,om.id_oferta, vt.id_periodo_academico,tie.codigo,eo.id_malla) as dd
        left join (select ma11.id_malla,ma11.id_nivel,count(ma11.id_malla_asignatura) as materiasNivel
        from aca.malla_asignatura ma11
        where  ma11.ESTADO='A'
        group by ma11.id_malla,ma11.id_nivel) as aux on aux.id_malla = dd.id_malla
        and aux.id_nivel = LEFT(dd.curso,CHARINDEX('/', dd.curso) - 1)
union all
--union datos titulacion
    select d.id_oferta_modalidad, d.id_persona,d.id_tiempo, d.id_nivel, d.id_paralelo,d.id_metodo_titulacion, d.id_formula, d.regular,
           d.curso, d.homologa, d.materiasCursadas, d.materiasNivel, d.materiasAprobadas, d.materiasReprobadas, d.total_creditos, d.total_horas,
           d.promedio,cast(d.fecha_ingreso_carrera as varchar(15)) as fecha_ingreso_carrera,cast(d.fecha_egreso as varchar(15))  as fecha_egreso,
           cast(d.fecha_graduacion as varchar(15))as fecha_graduacion,d.duracion_estudios,
           IIF(
               d.duracion_estudios <= d.duracionCarrera + 0.25, 'TIEMPO REGLAMENTARIO',
               IIF(
                   d.duracion_estudios <= d.duracionCarrera + 0.50, '1 SEMESTRE ADICIONAL',
                   IIF(
                       d.duracion_estudios <= d.duracionCarrera + 1.00, '1 AÑO ADICIONAL',
                       'FUERA TIEMPO'
                   )
               )
           )
       as tiempo_titulacion
        from (
            select d.id_oferta_modalidad,per.id as id_persona,
            vt.id_periodo_academico as id_tiempo,d.id_periodo_academico,pa.codigo,
--             d.id_nivel_max_cg as id_nivel,
            case when d.id_nivel_max_cg in (13) then 1
                when d.id_nivel_max_cg in (14) then 2
                when d.id_nivel_max_cg in (15) then 3
                when d.id_nivel_max_cg in (21) then 4
                when d.id_nivel_max_cg in (22) then 5
                when d.id_nivel_max_cg in (38) then 10 else d.id_nivel_max_cg end as id_nivel,
            1 as id_paralelo,d.ID_METODO_TITULACION,2 as id_formula,'SI' as regular,concat(cast(isnull(aux.ID_NIVEL,10) as varchar(25)),'/1') as curso,
            iif(d.movilidad =1,'SI','NO') as homologa,isnull(aux.materias,5) as materiasCursadas,isnull(aux.materias,5) as materiasNivel,
            isnull(aux.materias,0) as materiasAprobadas,0 as materiasReprobadas,isnull(aux.creditos,0) as total_creditos,
            isnull(aux.horas,0) as total_horas,isNULL(d.NOTA_SUSTENTACION_EXAMEN,70) as promedio,
            d.fecha_ingreso_carrera as fecha_ingreso_carrera, cast(d.fecha_egreso as date) AS fecha_egreso, Cast(d.FECHA_GRADUACION as date)as fecha_graduacion,d.duracion_estudios as duracion_estudios,
            cast(d.duracion_carrera as decimal(4,1)) as duracionCarrera
            from  mig.graduados as d
            inner join aca.periodo_academico pa on d.id_periodo_academico = pa.id_periodo_academico
            inner join man.personas per on per.id = d.id_persona
            inner join tmp.VW_TABLA_DIM_TIEMPO vt on vt.codigo=pa.codigo
            left join (select mpx.ID_CARRERA_LOCAL,max(mpx.ID_NIVEL) as ID_NIVEL,count(mpx.ID_MATERIA_PLAN) as materias,isnull(sum(MPx.CREDITOS),0) as creditos,
            isnull(sum(mpx.HORAS_SISTEMA),0) as horas
            from Bd_Academico..MATERIAS_PLAN mpx
            where  mpx.ID_NIVEL between 1 and 10 --and mp.ID_CARRERA_LOCAL = 2
            group by mpx.ID_NIVEL,mpx.ID_CARRERA_LOCAL
            ) as aux on aux.ID_CARRERA_LOCAL = d.ID_CARRERA_LOCAL and aux.ID_NIVEL = d.id_nivel_max_cg
            where per.ESTADO='AC' and d.id_graduado not in (210)
        ) as d
end

select * from mig.estudiante_oferta_modalidad
select * from tmp.VW_TABLA_DIM_TIEMPO vt
select * from Bd_academico.dbo.EG_LISTADO_GRADUADOS as d
select * from mig.record_matricula where id_record_oferta in (37580,37581)
select * from mig.record_oferta where identificacion='0921242533'
select * from mig.record_asignaturas where id_record_oferta in (37580,37581)



begin
    select
--     distinct  em.*
        --       distinct  ea.*--,p.identificacion
        distinct eo.*
--         distinct pa.codigo,ofa.facultad,ofa.carrera,p.identificacion,p.apellidos,p.nombres
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
    where --eo.id_periodo_academico = @id_periodo_academico and
          p.identificacion in ('2400108797')

end;

-- 14759
--15069
select * from  tmp.hecho_indicadores_auxiliar where id_formula = 2

--PERIODOS ACADEMICOS SISWEB
SELECT distinct pd.cg_modalidad,pd.CG_SISTEMA_ESTUDIO,pd.CG_PER_ACADEMICO,pa.VALOR_TEXTO as codigo,pd.INICIO,pd.CULMINACION
FROM  Bd_Academico.dbo.PERIODOS_ACADEMICOS pd
          inner join Bd_Personal..TP_CODIGOS pa on pa.CORRELATIVO = pd.CG_PER_ACADEMICO
          inner join Bd_Academico.dbo.PERIODOS_ACADEMICOS paa on paa.CG_PER_ACADEMICO = pd.CG_PER_ACADEMICO_ANT
    and NOT ( pa.VALOR_TEXTO LIKE '%-PRE%' OR pa.VALOR_TEXTO LIKE '%PAE%' OR pa.VALOR_TEXTO LIKE '%-3%')
where pd.cg_modalidad = 227 and pd.CG_SISTEMA_ESTUDIO = 200 and paa.CULMINACION<>pd.INICIO

select* from Bd_Personal..TP_CODIGOS where CORRELATIVO  in (200,227)

select* from Bd_Personal..TP_CODIGOS where ID_CLASIFICACION  in (19,20)

select* from Bd_Personal..CLASIFICACIONES_GENERALES where ID_CLASIFICACION  in (19,20)


select pa.CORRELATIVO,pa.VALOR_TEXTO_SIS as anio,pa.VALOR_TEXTO as codigo,concat(pa.VALOR_TEXTO,' ','PREGRADO ORDINARIO') as periodo,ESTADO
from Bd_Personal..TP_CODIGOS pa where pa.ID_CLASIFICACION = 33 and NOT ( pa.VALOR_TEXTO LIKE '%-PRE%' OR pa.VALOR_TEXTO LIKE '%PAE%' OR pa.VALOR_TEXTO LIKE '%-3%')

select distinct id_periodo_academico,periodo,id_periodo_academico_cg from mig.record_oferta
where id_tipo_oferta = 2

select * from aca.periodo_academico where id_tipo_oferta = 2

select * from Bd_academico.dbo.EG_LISTADO_GRADUADOS as d
where cast(d.FECHA_GRADUACION as date)>'2023-12-23'

-- SABER EL NIVEL MAXIMO DE LAS MALLAS DEL SISWEB V2
select top 1 * from (select mpx.ID_CARRERA_LOCAL,max(mpx.ID_NIVEL) as ID_NIVEL,count(mpx.ID_MATERIA_PLAN) as materias,isnull(sum(MPx.CREDITOS),0) as creditos,
                            isnull(sum(mpx.HORAS_SISTEMA),0) as horas
                     from Bd_Academico..MATERIAS_PLAN mpx
                     where  mpx.ID_NIVEL between 1 and 10 --and mp.ID_CARRERA_LOCAL = 2
                     group by mpx.ID_NIVEL,mpx.ID_CARRERA_LOCAL
                    ) as aux --where aux.ID_CARRERA_LOCAL = 2
order by aux.ID_NIVEL desc

SELECT pd.*
FROM  Bd_Academico.dbo.PERIODOS_ACADEMICOS pd
          inner join Bd_Personal..TP_CODIGOS pa on pa.CORRELATIVO = pd.CG_PER_ACADEMICO
          inner join Bd_Academico.dbo.PERIODOS_ACADEMICOS paa on paa.CG_PER_ACADEMICO = pd.CG_PER_ACADEMICO_ANT
    and NOT ( pa.VALOR_TEXTO LIKE '%-PRE%' OR pa.VALOR_TEXTO LIKE '%PAE%' OR pa.VALOR_TEXTO LIKE '%-3%')
where pd.cg_modalidad = 227 and pd.CG_SISTEMA_ESTUDIO = 200

--SABER EL NIVEL MAXIMO DE LAS MALLAS DEL SISWEB
select top 1  mp.ID_PLAN, mp.ID_NIVEL,mp.ID_CARRERA_LOCAL,count(mp.ID_MATERIA_PLAN) as materias,isnull(sum(MP.CREDITOS),0) as creditos,isnull(sum(mp.HORAS_SISTEMA),0) as horas
from Bd_Academico..MATERIAS_PLAN mp
where  mp.ID_NIVEL between 1 and 10 and mp.ID_CARRERA_LOCAL = 2
group by mp.ID_PLAN,mp.ID_NIVEL,mp.ID_CARRERA_LOCAL
order by ID_PLAN desc,ID_NIVEL desc












--ver en el sisweb los manes que han convalidado materias esto es par al atasa de titulacion
select top 100 clms.ID_CARRERA_OFERTADA,clms.NOMBRE_CARRERA,clms.NOMBRE,dm.id_movilidad,p.IDENTIFICACION,mo.fecha_ingreso from  Bd_Academico.mov.detalle_movilidad dm
INNER JOIN Bd_Academico.mov.movilidad mo ON mo.id = dm.id_movilidad
inner join Bd_Academico..PERSONAS p on p.ID_PERSONA = mo.id_persona
inner join Bd_Academico..MATERIAS_PLAN mp on mp.ID_MATERIA_PLAN = dm.id_materia_plan
inner join Bd_Academico..CARRERAS_LOCALES_MODALIDAD_SISTEMA clms on clms.ID_CARRERA_LOCAL = mp.ID_CARRERA_LOCAL
where  p.IDENTIFICACION in ('0917513863')



select* from Bd_Personal..TP_CODIGOS where ID_CLASIFICACION  in (94,29,28,27,2)
                                       and  VALOR_TEXTO like '%mangl%'

select* from Bd_Personal..CLASIFICACIONES_GENERALES where ID_CLASIFICACION  in (94,29,28,27,2)

select codigo,descripcion,fecha_desde,fecha_hasta from aca.periodo_academico where id_tipo_oferta = 2

