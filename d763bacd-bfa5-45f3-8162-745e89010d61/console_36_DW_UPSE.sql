use bd_sga_upse;

select rm.* from mig.record_matricula rm
inner join mig.record_oferta ro on rm.id_record_oferta = ro.id_record_oferta
where ro.identificacion ='0922076518'

--  DBCC CHECKIDENT ('aca.matricula_general', RESEED, 21);

---CONSULTAS FINALES

--OFERTA
select * from tmp.VW_TABLA_DIM_OFERTA
order by facultad,oferta

--NIVELES
select n.orden as id_nivel,n.descripcion_corta as nivel_corto,n.descripcion as nivel from aca.nivel n where n.id_tipo_oferta = 2 and n.estado='A'
-- union all
-- select 11 ,'MÓDULOS','MODULAR'

--paralelos
select p.id_paralelo,p.descripcion_corta as paralelo_corto,p.descripcion as paralelo
from aca.paralelo p where p.id_paralelo between 1 and 10 AND p.estado='A'


--TIPO INGRESO
select id_tipo_ingreso_estudiante as id_ingreso_estudiante,codigo as codigo_ingreso, descripcion as ingreso_estudiante from aca.tipo_ingreso_estudiante


-- ESTUDIANTES
select * from tmp.VW_TABLA_DIM_ESTUDIANTES
--          WHERE edad=0 AND LEN(identificacion)=10
order by nombres

--TIEMPO
SELECT * FROM tmp.VW_TABLA_DIM_PERIODO


-- ACTUALIZAR VISTA OFERTA
select * from tmp.VW_TABLA_DIM_OFERTA
-- Alter VIEW tmp.VW_TABLA_DIM_OFERTA as
    select distinct --o.id_oferta,
                    om.id_oferta_modalidad as id_oferta,concat(om.carrera,' - ',om.modalidad,' - ',om.sistema_estudio) as oferta,CAST(om.facultad AS VARCHAR(250)) AS facultad,
                    om.modalidad,c.descripcion_corta as campus,om.sistema_estudio,om.tipo_oferta,
--                     isnull((select TOP 1 d.TITULO from Bd_academico.dbo.EG_LISTADO_GRADUADOS as d  where d.CARRERA = LEFT(om.carrera, CHARINDEX('-', om.carrera + '-') - 1)),'NO DEFINIDO') as titulo,
        ISNULL(ta.descripcion,'NO DEFINIDO') AS titulo,
                    cast((o.duracion/2) as decimal (4,1)) as duracion_carrera ,o.duracion as duracion_periodos from aca.oferta o
                                                                                                                        inner join aca.ofertas_facultad om on o.id_oferta = om.id_oferta
                                                                                                                        inner join aca.campus c on o.id_campus = c.id_campus
    left join aca.titulos_academicos ta on ta.id_titulo_academico = o.id_titulo_academico
    where o.estado='A' and o.id_tipo_oferta = 2
    group by om.id_oferta_modalidad, om.carrera, om.modalidad, om.facultad,o.duracion, om.sistema_estudio, c.descripcion_corta, om.tipo_oferta, ta.descripcion

-- ACTUALIZAR VISTA TIEMPO
    alter VIEW tmp.VW_TABLA_DIM_PERIODO
    AS
        select d.id_periodo_academico as id_periodo,d.anio,d.codigo as codigo_periodo,d.periodo as periodo_academico,CAST(DENSE_RANK() OVER (ORDER BY d.codigo) AS INT) as orden from (
     select pa.id_periodo_academico,p.codigo as anio,pa.codigo,pa.descripcion as periodo
     from aca.periodo_academico pa
              inner join aca.periodo p on pa.id_periodo = p.id_periodo
     where pa.id_tipo_oferta =2 and pa.estado='A' and pa.codigo<='2025-2' and p.estado='A' and pa.codigo_tipo_periodo ='PAORD') as d

-- ACTUALIZAR VISTA ESTUDIANTES
-- ALTER VIEW tmp.VW_TABLA_DIM_ESTUDIANTES AS
select distinct d.id_persona as id_estudiante,d.identificacion, d.nombres, d.sexo,
                d.edad, d.estado_civil, d.discapacidad, d.porcentaje_discapacidad,
                d.pais, d.provincia, d.canton, d.parroquia, d.etnia, d.nacionalidad_indigena,fecha_nace from (
       select distinct p.id as id_persona,p.identificacion,concat(p.apellidos,' ',p.nombres) as nombres,
                      iif(p.sexo='M','MASCULINO','FEMENIMO') as sexo,cast(isnull(cast( (DATEDIFF(YEAR ,p.fecha_nace, getdate())) as decimal(10,0)),0) as int) as edad,
                      iif(p.id_estado_civil is null,'NO REGISTRA',ec.descripcion) as estado_civil,
                      iif(p.id_discapacidad is null,'NINGUNA',dis.descripcion) as discapacidad,
                      isnull(iif(p.id_discapacidad is null,'0',iif(p.porcentaje_dis ='','0',p.porcentaje_dis)),'0') as porcentaje_discapacidad,
                      iif(p.id_pais_nacionalidad is null,'NO REGISTRA',pais.descripcion) as pais,iif(p.id_provincia_nacionalidad is null,'NO REGISTRA',pro.descripcion) as provincia,
                      iif(p.id_canton_nacionalidad is null,'NO REGISTRA',can.descripcion) as canton,iif(p.id_parroquia_nacionalidad is null,'NO REGISTRA',par.descripcion) as parroquia,
                      iif(p.id_etnia is null,'NO REGISTRA',e.descripcion) as etnia,iif(p.id_nacionalidad_indigena is null,'NO REGISTRA',nai.descripcion) as nacionalidad_indigena,p.fecha_nace
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
                      iif(p.id_etnia is null,'NO REGISTRA',e.descripcion) as etnia,iif(p.id_nacionalidad_indigena is null,'NO REGISTRA',nai.descripcion) as nacionalidad_indigena,p.fecha_nace
       --     ,'SGA' as sistema
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
d.pais, d.provincia, d.canton, d.parroquia, d.etnia, d.nacionalidad_indigena,d.id_persona, fecha_nace--,d.sistema

select id,p.id_tipo_identificacion,p.identificacion,apellidos,nombres,sexo,id_estado_civil,fecha_nace,id_pais_nacionalidad,id_provincia_nacionalidad,id_canton_nacionalidad,id_parroquia_nacionalidad,
--        id_pais_residencia,id_provincia_residencia,id_canton_residencia,id_parroquia_residencia,
       defuncion,homonimo,direccion
-- update p set p.identificacion = pi.identificacion
from man.personas p
-- inner join man.persona_identificacion pi on p.id = pi.id_persona and pi.id_tipo_identificacion =6
where p.identificacion in ('gl281495','gl227930')
order by apellidos,nombres

select * from man.lugar where descripcion like '%colombia%' or id_lugar_padre in (162,1644,1664,1651)
select * from man.lugar where descripcion like '%brasil%' or id_lugar_padre in (161,1700,2001)
select * from man.lugar where descripcion like '%argentina%' or id_lugar_padre in (159,1610,1599)

select ro.identificacion,ro.apellidos,ro.nombres--,P.identificacion,P.apellidos,P.nombres
-- update ro set ro.identificacion = p.identificacion
from mig.record_oferta ro
inner join man.personas p on ro.id_persona = p.id
-- where ro.identificacion<>p.identificacion
    where ro.identificacion in ('0920428109', '0921989893','0925724676')

select * from man.personas where identificacion in ('gl227930')
select * from man.personas p where id in (58983,74450)
select * from man.persona_identificacion where id_persona in (60158,    60162,59033,69803,69674,58144,73468,77666,65398,
62475,58132,79786,58616,63320,58511,59011,68283,75761,64680,62762,58257,57398,73904)
select * from man.persona_identificacion where identificacion in ('0925724676','0985724676')
select * from man.tipo_identificacion
select * from man.estado_civil
select * from mig.record_oferta where id_persona = 35425

-- DBCC CHECKIDENT ('man.lugar', RESEED, 1710);


begin
    select
                 --     distinct  em.*
                 --       distinct  ea.*--,p.identificacion
        distinct eo.*
--             distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.id_malla,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,p.identificacion,p.apellidos,p.nombres,tee.descripcion,eo.mantiene_gratuidad,eo.estado
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
    where --eo.id_periodo_academico = @id_periodo_academico and
          p.identificacion in ('2450530437')
--         eo.id_estudiante_oferta in (6963,11579)
--     nombres like '%CARLOS%'

end

select * from aca.estudiante_oferta where id_estudiante_oferta = 56955
select * from aca.estudiante_oferta where id_oferta_modalidad = 85 and id_periodo_academico = 35
select distinct em.* from aca.estudiante_matricula em
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
where em.id_estudiante_oferta in (89149 )

select distinct em.* from aca.matricula_rubro em
where em.id_estudiante_matricula in (170757 )


select * from man.opciones

