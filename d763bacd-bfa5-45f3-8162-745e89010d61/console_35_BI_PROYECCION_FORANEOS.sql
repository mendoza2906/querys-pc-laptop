use bd_sga_upse;

--  DBCC CHECKIDENT ('aca.matricula_general', RESEED, 21);

---CONSULTAS FINALES
--paralelos
select p.id_paralelo,p.descripcion_corta as paralelo_corto,p.descripcion as paralelo
from aca.paralelo p where p.id_paralelo between 1 and 10 AND p.estado='A'

--TIEMPO
SELECT * FROM mig.vw_dim_tiempo
-- create view  mig.vw_dim_tiempo as
select d.id_periodo_academico,d.codigo,d.anio,d.periodo,CAST(DENSE_RANK() OVER (ORDER BY d.codigo) AS INT) as orden from (
    select p.codigo as anio,pa.codigo,pa.descripcion as periodo,pa.id_periodo_academico
    from aca.periodo_academico pa
    inner join aca.periodo p on pa.id_periodo = p.id_periodo
    where pa.id_tipo_oferta =2 and pa.estado='A' and pa.codigo between '2016-1' and '2025-2' and p.estado='A' and pa.codigo_tipo_periodo ='PAORD') as d
-- order by CAST(DENSE_RANK() OVER (ORDER BY d.codigo) AS INT)

--OFERTA
select * from mig.vw_dim_ofertas
order by facultad,oferta

-- create view mig.vw_dim_ofertas as
    select distinct --o.id_oferta,
    om.id_oferta_modalidad as id_oferta,concat(om.carrera,' - ',om.modalidad,' - ',om.sistema_estudio) as oferta,CAST(om.facultad AS VARCHAR(250)) AS facultad,
    om.modalidad,c.descripcion_corta as campus,om.sistema_estudio,o.duracion as duracion_periodos from aca.oferta o
    inner join aca.ofertas_facultad om on o.id_oferta = om.id_oferta
    inner join aca.campus c on o.id_campus = c.id_campus
    inner join mig.auxiliar_hechos_graduados h on h.id_oferta_modalidad = om.id_oferta_modalidad
--     left join aca.titulos_academicos ta on ta.id_titulo_academico = o.id_titulo_academico
    where o.estado='A' --and o.id_tipo_oferta = 2
    group by om.id_oferta_modalidad, om.carrera, om.modalidad, om.facultad,o.duracion, om.sistema_estudio, c.descripcion_corta
-- order by concat(om.carrera,' - ',om.modalidad,' - ',om.sistema_estudio)

--NIVELES
select n.orden as id_nivel,n.descripcion_corta,n.descripcion from aca.nivel n where n.id_tipo_oferta = 2 and n.estado='A'
-- union all
-- select 11 ,'MÓDULOS','MODULAR'


--METODOS DE TITULACION
 SELECT distinct t.* FROM tmp.VW_TABLA_DIM_METODO_TITULACION t
inner join mig.auxiliar_hechos_graduados h on h.id_metodo_titulacion = t.id_metodo_titulacion

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


select * from tmp.VW_TABLA_DIM_ESTUDIANTES

--46146 sisweb
    --49642 sga

    select * from mig.vw_dim_estudiantes
-- alter VIEW mig.vw_dim_estudiantes AS
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
--                 inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
               inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = ro.id_tipo_estado_estudiante
               inner join aca.periodo_academico pa on pa.id_periodo_academico = ro.id_periodo_academico
               inner join aca.oferta_modalidad om on om.id_oferta_modalidad = ro.id_oferta_modalidad
               inner join aca.oferta o on o.id_oferta = om.id_oferta
                inner join mig.auxiliar_hechos_graduados h on h.id_estudiante = p.id
               left join man.lugar pais on pais.id_lugar = p.id_pais_nacionalidad and pais.estado='A'
               left join man.lugar pro on pro.id_lugar = p.id_provincia_nacionalidad and pro.estado='A'
               left join man.lugar can on can.id_lugar = p.id_canton_nacionalidad and can.estado='A'
               left join man.lugar par on par.id_lugar = p.id_parroquia_nacionalidad and par.estado='A'
               left join man.discapacidad dis on dis.id_discapacidad = p.id_discapacidad and dis.estado='A'
               left join man.etnia e on e.id_etnia = p.id_etnia and e.estado='A'
               left join man.estado_civil ec on p.id_estado_civil = ec.id_estado_civil and ec.estado='A'
               left join man.nacionalidad_indigena nai on nai.id_nacionalidad_indigena = p.id_nacionalidad_indigena and nai.estado='A'
      where p.estado='AC' and ro.estado='A' and om.estado='A' and o.id_tipo_oferta = 2 --and rm.periodo>='2016-1'
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
               inner join mig.auxiliar_hechos_graduados h on h.id_estudiante = p.id
--                inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
--                inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
               inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
--                inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
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
      where p.estado='AC' and eo.estado='A' and om.estado='A' and o.id_tipo_oferta = 2 --and p.fecha_nace is null
      ) as d
group by d.nombres,d.identificacion, d.sexo, d.edad, d.estado_civil, d.discapacidad, d.porcentaje_discapacidad,
d.pais, d.provincia, d.canton, d.parroquia, d.etnia, d.nacionalidad_indigena,d.id_persona--,d.sistema



--260301
select * from  tmp.hecho_indicadores_auxiliar as d

select * from aca.tipo_ingreso_estudiante
select * from aca.tipo_estado_estudiante

--190863 sisweb
--actual solo sisweb 94306 actualizado 96622


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
          p.identificacion in ('0920886496')

end;

select * from mig.graduados where identificacion='2400292922'
--solo sisweb
--147

select d.id_oferta_modalidad as id_oferta, d.id_estudiante, d.id_periodo_academico, iif(id_nivel>10,8,id_nivel) as id_nivel, d.id_paralelo, d.id_metodo_titulacion,
       tipo_ingreso_carrera, estado_academico, resumen_ingreso, resumen_estado, d.fecha_ingreso, fecha_egreso, fecha_graduacion,
       duracion_estudios, tiempo_titulacion, isnull(periodo_final,'NO APLICA') as periodo_final,
       iif((anio is null or anio ='NO APLICA') and periodo_final is not null,substring(periodo_final,1,4),anio) as anio_final, carrera_final
--         , e.identificacion,o.oferta,pa.codigo
from (
select h.*, ROW_NUMBER() OVER (PARTITION BY h.id_periodo_academico,h.id_oferta_modalidad,h.id_estudiante  ORDER BY h.fecha_ingreso,h.periodo_final asc ) as fila
from mig.auxiliar_hechos_graduados h) as d
inner join mig.vw_dim_estudiantes e on e.id_estudiante = d.id_estudiante
inner join mig.vw_dim_ofertas o on o.id_oferta = d.id_oferta_modalidad
inner join aca.periodo_academico pa on pa.id_periodo_academico = d.id_periodo_academico
 where d.fila = 1 and pa.codigo>='2016-1'


select identificacion,nombres,apellidos,fecha_nace,id_estado_civil,id_pais_nacionalidad,id_provincia_nacionalidad,id_canton_nacionalidad,id_parroquia_residencia
from man.personas where identificacion in ('0104666532','0104666540',
'2450084583','0927662510','2200596027','0954383436',
'2200101026','1724481849','0927445197','2200393821',
'2400293532','1205900499','2450324732','0929460962',
'1718574484','2400108516','0951873108','0942623513')
select * from man.lugar where descripcion='ARGENTINA'

begin
    --34670

     select niv.id_oferta_modalidad,p.id as id_estudiante,niv.id_periodo_academico as id_periodo_academico, isnull(isnull(auxgra.id_nivel,auxniv.id_nivel),1) as id_nivel,
            isnull(auxgra.id_paralelo,auxniv.id_paralelo) as id_paralelo, isnull(g.id_metodo_titulacion,12) as id_metodo_titulacion,
--             p.identificacion,niv.id_record_oferta,p.apellidos,p.nombres,case p.sexo when 'M' then 'MASCULINO' when 'F' then 'FEMENINO' else 'NO REGISTRA' end as sexo,niv.carrera as carrera_inicio,
            tie.descripcion as tipo_ingreso_carrera,iif(gra.id_record_oferta is not null,tee2.descripcion,tee.descripcion) as estado_academico,
--             niv.periodo as periodo_ingreso,
            case when tie.codigo in ('TRANSFORMAR','NIV','EXO') then 'NIVELACION'
                 when tie.codigo in ('MOV','MOV-EXT','MOV-INTER') then 'MOVILIDAD'
                 else 'REDISEÑO' end as resumen_ingreso,
            case when iif(gra.id_record_oferta is not null,tee2.codigo,tee.codigo) in ('GRA') then 'GRADUADO'
                 when iif(gra.id_record_oferta is not null,tee2.codigo,tee.codigo) in ('EGR') then 'EGRESADO'
                 when isnull(auxgra.periodo,auxniv.periodo)='2025-2' then 'ACTIVO'
                 else 'DESERTOR' end as resumen_estado,
            ISNULL(CONVERT(varchar(10), cast(auxniv.fecha_matricula as date), 23), 'NO REGISTRA') as fecha_ingreso,
            ISNULL(CONVERT(varchar(10), g.fecha_egreso, 23), 'NO APLICA') AS fecha_egreso,
            ISNULL(CONVERT(varchar(10), g.fecha_graduacion, 23), 'NO APLICA') AS fecha_graduacion,
            ISNULL(CAST(g.duracion_estudios AS varchar(25)), 'NO APLICA') AS duracion_estudios,
            iif(g.id_graduado is not null,IIF(g.duracion_estudios <= g.duracion_carrera + 0.25, 'TIEMPO REGLAMENTARIO',
                IIF(g.duracion_estudios <= g.duracion_carrera + 0.50, '1 SEMESTRE ADICIONAL',
                    IIF(g.duracion_estudios <= g.duracion_carrera + 1.00, '1 AÑO ADICIONAL', 'FUERA TIEMPO')
                )
            ),'NO APLICA')as tiempo_titulacion,
--                      gra.id_record_oferta,
    iif(pg.codigo is null,isnull(auxgra.periodo,auxniv.periodo),pg.codigo ) as periodo_final,
--     g.id_periodo_academico,
    iif(g.fecha_graduacion is null, 'NO APLICA',cast(YEAR(g.fecha_graduacion) as varchar(5))) as anio,
         iif(gra.id_record_oferta is not null and gra.id_tipo_oferta=2,gra.carrera,'NO INGRESO A CARRERA') as carrera_final
    from mig.record_oferta roo
    inner join mig.record_oferta_jerarquia_grado rooj on rooj.id_record_original=roo.id_record_oferta
    inner join mig.record_oferta niv on niv.id_record_oferta=rooj.id_record_origen
    inner join aca.tipo_estado_estudiante tee on niv.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
    inner join aca.tipo_ingreso_estudiante tie on niv.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
    inner join man.personas p on p.identificacion = niv.identificacion
    left join
        (select rm.periodo,rm.id_record_oferta,rm.id_nivel,rm.id_paralelo,pa.fecha_desde as fecha_matricula, ROW_NUMBER() OVER (PARTITION BY RM.id_record_oferta  ORDER BY rm.periodo desc ) as fila
         from mig.record_matricula rm
         inner join aca.periodo_academico pa on rm.id_periodo_academico = pa.id_periodo_academico
         where rm.estado='A') as auxniv on auxniv.id_record_oferta = niv.id_record_oferta and auxniv.fila=1
    left join mig.record_oferta gra on gra.id_record_oferta = rooj.id_record_final
    left join aca.tipo_estado_estudiante tee2 on gra.id_tipo_estado_estudiante = tee2.id_tipo_estado_estudiante
    left join aca.tipo_ingreso_estudiante tie2 on gra.id_tipo_ingreso_estudiante = tie2.id_tipo_ingreso_estudiante
    left join
         (select rm.periodo,rm.id_record_oferta,rm.id_nivel,rm.id_paralelo, ROW_NUMBER() OVER (PARTITION BY RM.id_record_oferta  ORDER BY rm.periodo desc ) as fila
          from mig.record_matricula rm where rm.estado='A') as auxgra on auxgra.id_record_oferta = gra.id_record_oferta and auxgra.fila=1
    left join mig.graduados as g on g.id_persona_cg= gra.id_persona_cg and g.id_carrera_ofertada = gra.id_carrera_ofertada
    left join aca.periodo_academico pg on g.id_periodo_academico = pg.id_periodo_academico
     where niv.id_estudiante_oferta is null and niv.id_estudiante_oferta_destino is null and gra.id_estudiante_oferta is null and gra.id_estudiante_oferta_destino is null
    and niv.periodo>='2016-1' and niv.estado='A'
 union all
--manes que aprobaron el pre een el sisweb y todo lo demas esta en el SGA 1370
    select niv.id_oferta_modalidad,p.id as id_estudiante,niv.id_periodo_academico, isnull(isnull(gra.id_nivel,auxniv.id_nivel),1) as id_nivel,
       isnull(isnull(gra.id_paralelo,auxniv.id_paralelo),1) as id_paralelo,
       isnull(g.id_metodo_titulacion,12) as id_metodo_titulacion,
--             p.identificacion,p.apellidos,p.nombres,case p.sexo when 'M' then 'MASCULINO' when 'F' then 'FEMENINO' else 'NO REGISTRA' end as sexo,niv.carrera as carrera_inicio,
       tie.descripcion as tipo_ingreso_carrera,iif(gra.id_estudiante_oferta is not null,gra.estado_carrera,tee.descripcion) as estado_academico,
--             niv.periodo as periodo_ingreso,
       case when tie.codigo in ('TRANSFORMAR','NIV','EXO') then 'NIVELACION'
            when tie.codigo in ('MOV','MOV-EXT','MOV-INTER') then 'MOVILIDAD'
            else 'REDISEÑO' end as resumen_ingreso,
       case when gra.codigo_estado_carrera in ('GRA') then 'GRADUADO'
            when  gra.codigo_estado_carrera in ('EGR') then 'EGRESADO'
            when isnull(gra.periodo,auxniv.periodo)='2025-2' then 'ACTIVO'
            else 'DESERTOR' end as resumen_estado,
       ISNULL(CONVERT(varchar(10), cast(auxniv.fecha_matricula as date), 23), 'NO REGISTRA') as fecha_ingreso,
       ISNULL(CONVERT(varchar(10), g.fecha_egreso, 23), 'NO APLICA') AS fecha_egreso,
       ISNULL(CONVERT(varchar(10), g.fecha_graduacion, 23), 'NO APLICA') AS fecha_graduacion,
       ISNULL(CAST(g.duracion_estudios AS varchar(25)), 'NO APLICA') AS duracion_estudios,
       iif(g.id_graduado is not null,IIF(g.duracion_estudios <= g.duracion_carrera + 0.25, 'TIEMPO REGLAMENTARIO',
                                         IIF(g.duracion_estudios <= g.duracion_carrera + 0.50, '1 SEMESTRE ADICIONAL',
                                             IIF(g.duracion_estudios <= g.duracion_carrera + 1.00, '1 AÑO ADICIONAL', 'FUERA TIEMPO')
                                         )
                                     ),'NO APLICA')as tiempo_titulacion,
--                      gra.id_record_oferta,
       iif(pg.codigo is null,isnull(gra.periodo,auxniv.periodo),pg.codigo ) as periodo_final,
--     g.id_periodo_academico,
       iif(g.fecha_graduacion is null, 'NO APLICA',cast(YEAR(g.fecha_graduacion) as varchar(5))) as anio,
       iif(gra.id_estudiante_oferta is not null and gra.id_tipo_oferta=2,gra.carrera,'NO INGRESO A CARRERA') as carrera_final
from mig.record_oferta eos
         inner join aca.estudiante_oferta niv on niv.id_estudiante_oferta = eos.id_estudiante_oferta_destino
         inner join aca.ofertas_facultad ov on ov.id_oferta_modalidad = niv.id_oferta_modalidad
         inner join aca.tipo_estado_estudiante tee on niv.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.tipo_ingreso_estudiante tie on niv.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
         inner join man.personas p on p.id = niv.id_persona
         left join aca.periodo_academico pa2 on pa2.id_periodo_academico = niv.id_periodo_academico
         left join (select pa.codigo as periodo,em1.id_estudiante_oferta,ma.id_nivel,ea1.id_paralelo,pa.fecha_desde as fecha_matricula,ROW_NUMBER() OVER (PARTITION BY em1.id_estudiante_oferta  ORDER BY pa.codigo asc ) as fila
                    from aca.estudiante_matricula em1
                             inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                             inner join aca.asignatura_aprendizaje aa on ea1.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                             inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
                             inner join aca.matricula_general mg on em1.id_matricula_general = mg.id_matricula_general
                             inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
                    where em1.estado='A') as auxniv on auxniv.id_estudiante_oferta = niv.id_estudiante_oferta and auxniv.fila=1
         inner join mig.estudiante_oferta_jerarquia eoj on eoj.id_estudiante_oferta_origen = niv.id_estudiante_oferta
         inner join
     (select om.id_tipo_oferta,om.carrera,om.modalidad,eo.id_estudiante_oferta,eo.id_oferta_modalidad,eo.id_persona,tee2.descripcion as estado_carrera,per.periodo,
             tee2.codigo as codigo_estado_carrera,per.id_paralelo,per.id_nivel
      from aca.estudiante_oferta eo
               inner join man.personas p on eo.id_persona = p.id
               left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
               inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
               inner join aca.tipo_estado_estudiante tee2 on eo.id_tipo_estado_estudiante = tee2.id_tipo_estado_estudiante
               inner join aca.tipo_ingreso_estudiante tie2 on eo.id_tipo_ingreso_estudiante = tie2.id_tipo_ingreso_estudiante
               left  join  (select pa.codigo as periodo,em1.id_estudiante_oferta,ma.id_nivel,ea1.id_paralelo,pa.fecha_desde as fecha_matricula,ROW_NUMBER() OVER (PARTITION BY em1.id_estudiante_oferta  ORDER BY pa.codigo desc ) as fila
                            from aca.estudiante_matricula em1
                                     inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                                     inner join aca.asignatura_aprendizaje aa on ea1.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                                     inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
                                     inner join aca.matricula_general mg on em1.id_matricula_general = mg.id_matricula_general
                                     inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
                            where em1.estado='A') as per on per.id_estudiante_oferta = eo.id_estudiante_oferta and per.fila = 1
--     inner join migracion_sga..registros_migracion rm on rm.id_entidad_relacion = 2 and rm.id_destino = eo.id_oferta_modalidad
      where eo.estado='A' ) as gra on gra.id_estudiante_oferta = eoj.id_estudiante_oferta_final
         left join mig.graduados as g on g.id_persona_cg= gra.id_persona and g.id_oferta_modalidad = gra.id_oferta_modalidad
         left join aca.periodo_academico pg on g.id_periodo_academico = pg.id_periodo_academico
where eos.id_estudiante_oferta_destino is not null --and grap.id_estudiante_oferta is null and grap.id_estudiante_oferta_destino is null
  and pa2.codigo>='2016-1'
group by niv.id_estudiante_oferta, p.identificacion, p.apellidos, p.nombres, p.sexo, ov.carrera, tie.descripcion, pa2.codigo, gra.id_estudiante_oferta, gra.id_tipo_oferta,
         gra.carrera, auxniv.periodo, tee.descripcion, gra.modalidad,gra.periodo,gra.estado_carrera,gra.codigo_estado_carrera,tee.codigo, pa2.codigo,
         p.id, g.duracion_estudios, g.fecha_egreso, g.duracion_carrera, g.id_graduado, g.fecha_graduacion, g.id_metodo_titulacion, niv.id_oferta_modalidad, niv.id_periodo_academico,
         auxniv.id_nivel, auxniv.id_paralelo,gra.id_nivel,gra.id_paralelo,tie.codigo,auxniv.fecha_matricula,pg.codigo
union all
--sisweb con continuacion en sga
    select niv.id_oferta_modalidad,p.id as id_estudiante,niv.id_periodo_academico, isnull(isnull(gra.id_nivel,auxniv.id_nivel),1) as id_nivel,
           isnull(isnull(gra.id_paralelo,auxniv.id_paralelo),1) as id_paralelo,
           isnull(g.id_metodo_titulacion,12) as id_metodo_titulacion,
           --             p.identificacion,p.apellidos,p.nombres,case p.sexo when 'M' then 'MASCULINO' when 'F' then 'FEMENINO' else 'NO REGISTRA' end as sexo,niv.carrera as carrera_inicio,
           tie.descripcion as tipo_ingreso_carrera,gra.estado_carrera as estado_academico,
           --             niv.periodo as periodo_ingreso,
           case when tie.codigo in ('TRANSFORMAR','NIV','EXO') then 'NIVELACION'
                when tie.codigo in ('MOV','MOV-EXT','MOV-INTER') then 'MOVILIDAD'
                else 'REDISEÑO' end as resumen_ingreso,
           case when gra.codigo_estado_carrera in ('GRA') then 'GRADUADO'
                when  gra.codigo_estado_carrera in ('EGR') then 'EGRESADO'
                when isnull(gra.periodo,auxniv.periodo)='2025-2' then 'ACTIVO'
                else 'DESERTOR' end as resumen_estado,
           ISNULL(CONVERT(varchar(10), cast(auxniv.fecha_matricula as date), 23), 'NO REGISTRA') as fecha_ingreso,
           ISNULL(CONVERT(varchar(10), g.fecha_egreso, 23), 'NO APLICA') AS fecha_egreso,
           ISNULL(CONVERT(varchar(10), g.fecha_graduacion, 23), 'NO APLICA') AS fecha_graduacion,
           ISNULL(CAST(g.duracion_estudios AS varchar(25)), 'NO APLICA') AS duracion_estudios,
           iif(g.id_graduado is not null,IIF(g.duracion_estudios <= g.duracion_carrera + 0.25, 'TIEMPO REGLAMENTARIO',
                                             IIF(g.duracion_estudios <= g.duracion_carrera + 0.50, '1 SEMESTRE ADICIONAL',
                                                 IIF(g.duracion_estudios <= g.duracion_carrera + 1.00, '1 AÑO ADICIONAL', 'FUERA TIEMPO')
                                             )
                                         ),'NO APLICA')as tiempo_titulacion,
           --                      gra.id_record_oferta,
           iif(pg.codigo is null,isnull(gra.periodo,auxniv.periodo),pg.codigo ) as periodo_final,
           --     g.id_periodo_academico,
           iif(g.fecha_graduacion is null, 'NO APLICA',cast(YEAR(g.fecha_graduacion) as varchar(5))) as anio,
           iif(gra.id_estudiante_oferta is not null and gra.id_tipo_oferta=2,gra.carrera,'NO INGRESO A CARRERA') as carrera_final
    from mig.record_oferta roo
             inner join mig.record_oferta_jerarquia_grado rooj on rooj.id_record_original=roo.id_record_oferta
             inner join mig.record_oferta niv on niv.id_record_oferta=rooj.id_record_origen
             inner join aca.tipo_estado_estudiante tee on niv.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
             inner join aca.tipo_ingreso_estudiante tie on niv.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
             inner join man.personas p on p.identificacion = niv.identificacion
             left join
         (select rm.periodo,rm.id_record_oferta,rm.id_nivel,rm.id_paralelo,pa.fecha_desde as fecha_matricula, ROW_NUMBER() OVER (PARTITION BY RM.id_record_oferta  ORDER BY rm.periodo desc ) as fila
          from mig.record_matricula rm
          inner join aca.periodo_academico pa on rm.id_periodo_academico = pa.id_periodo_academico
          where rm.estado='A') as auxniv on auxniv.id_record_oferta = niv.id_record_oferta and auxniv.fila=1
             left join mig.record_oferta grap on grap.id_record_oferta = rooj.id_record_final
             inner join mig.estudiante_oferta_jerarquia eoj on eoj.id_estudiante_oferta_origen = grap.id_estudiante_oferta
             inner join
         (select om.id_tipo_oferta,om.carrera,om.modalidad,eo.id_estudiante_oferta,eo.id_oferta_modalidad,eo.id_persona,tee2.descripcion as estado_carrera,isnull(per.periodo,pa.codigo) as periodo,
                 tee2.codigo as codigo_estado_carrera,per.id_paralelo,per.id_nivel
          from aca.estudiante_oferta eo
                   inner join man.personas p on eo.id_persona = p.id
                   left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
                   inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
                   inner join aca.tipo_estado_estudiante tee2 on eo.id_tipo_estado_estudiante = tee2.id_tipo_estado_estudiante
                   inner join aca.tipo_ingreso_estudiante tie2 on eo.id_tipo_ingreso_estudiante = tie2.id_tipo_ingreso_estudiante
                   left  join  (select pa.codigo as periodo,em1.id_estudiante_oferta,ma.id_nivel,ea1.id_paralelo,pa.fecha_desde as fecha_matricula,ROW_NUMBER() OVER (PARTITION BY em1.id_estudiante_oferta  ORDER BY pa.codigo desc ) as fila from aca.estudiante_matricula em1
                    inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                    inner join aca.asignatura_aprendizaje aa on ea1.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                    inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
                    inner join aca.matricula_general mg on em1.id_matricula_general = mg.id_matricula_general
                    inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
                                where em1.estado='A') as per on per.id_estudiante_oferta = eo.id_estudiante_oferta and per.fila = 1
                   inner join migracion_sga..registros_migracion rm on rm.id_entidad_relacion = 2 and rm.id_destino = eo.id_oferta_modalidad and rm.id_origen not in (38)
          where eo.estado='A'
         ) as gra on gra.id_estudiante_oferta = eoj.id_estudiante_oferta_final
             left join mig.graduados as g on g.id_persona= gra.id_persona and g.id_oferta_modalidad= gra.id_oferta_modalidad
             left join aca.periodo_academico pg on g.id_periodo_academico = pg.id_periodo_academico
    where
        niv.periodo>='2016-1'
    group by niv.id_record_oferta, p.identificacion, p.apellidos, p.nombres, p.sexo, niv.carrera, tie.descripcion, niv.periodo, gra.id_estudiante_oferta, gra.id_tipo_oferta,
             gra.carrera, auxniv.periodo, tee.descripcion, gra.modalidad, niv.modalidad,gra.periodo,gra.estado_carrera,gra.codigo_estado_carrera,tee.codigo, p.id, g.fecha_graduacion,
             niv.id_oferta_modalidad, niv.id_periodo_academico, g.id_metodo_titulacion, auxniv.fecha_matricula, g.fecha_egreso, g.duracion_estudios, g.id_graduado, g.duracion_carrera,
             pg.codigo, gra.id_paralelo, gra.id_nivel, auxniv.id_paralelo, auxniv.id_nivel,tie.codigo
union all
---todo esta en el SGA
     select niv.id_oferta_modalidad,p.id as id_estudiante,niv.id_periodo_academico, isnull(isnull(gra.id_nivel,niv.id_nivel),1) as id_nivel,
            isnull(isnull(gra.id_paralelo,niv.id_paralelo),1) as id_paralelo,
            isnull(g.id_metodo_titulacion,12) as id_metodo_titulacion,
            --             p.identificacion,p.apellidos,p.nombres,case p.sexo when 'M' then 'MASCULINO' when 'F' then 'FEMENINO' else 'NO REGISTRA' end as sexo,niv.carrera as carrera_inicio,
            niv.tipo_ingreso as tipo_ingreso_carrera,gra.estado_carrera as estado_academico,
            --             niv.periodo as periodo_ingreso,
            case when niv.codigo_ingreso in ('TRANSFORMAR','NIV','EXO') then 'NIVELACION'
                 when niv.codigo_ingreso in ('MOV','MOV-EXT','MOV-INTER') then 'MOVILIDAD'
                 else 'REDISEÑO' end as resumen_ingreso,
            case when gra.codigo_estado_carrera in ('GRA') then 'GRADUADO'
                 when  gra.codigo_estado_carrera in ('EGR') then 'EGRESADO'
                 when isnull(gra.periodo,niv.periodo)='2025-2' then 'ACTIVO'
                 else 'DESERTOR' end as resumen_estado,
            ISNULL(CONVERT(varchar(10), cast(niv.fecha_matricula as date), 23), 'NO REGISTRA') as fecha_ingreso,
            ISNULL(CONVERT(varchar(10), g.fecha_egreso, 23), 'NO APLICA') AS fecha_egreso,
            ISNULL(CONVERT(varchar(10), g.fecha_graduacion, 23), 'NO APLICA') AS fecha_graduacion,
            ISNULL(CAST(g.duracion_estudios AS varchar(25)), 'NO APLICA') AS duracion_estudios,
            iif(g.id_graduado is not null,IIF(g.duracion_estudios <= g.duracion_carrera + 0.25, 'TIEMPO REGLAMENTARIO',
                                              IIF(g.duracion_estudios <= g.duracion_carrera + 0.50, '1 SEMESTRE ADICIONAL',
                                                  IIF(g.duracion_estudios <= g.duracion_carrera + 1.00, '1 AÑO ADICIONAL', 'FUERA TIEMPO')
                                              )
                                          ),'NO APLICA')as tiempo_titulacion,
            --                      gra.id_record_oferta,
            iif(pg.codigo is null,isnull(gra.periodo,niv.periodo),pg.codigo ) as periodo_final,
            --     g.id_periodo_academico,
            iif(g.fecha_graduacion is null, 'NO APLICA',cast(YEAR(g.fecha_graduacion) as varchar(5))) as anio,
            iif(gra.id_estudiante_oferta is not null and gra.id_tipo_oferta=2,gra.carrera,'NO INGRESO A CARRERA') as carrera_final
    from man.personas p
    inner join (
        select p.id as id_persona,om.id_tipo_oferta,om.carrera,eo.id_periodo_academico,om.modalidad,eo.id_oferta_modalidad,eo.id_estudiante_oferta,tee1.descripcion as estado_carrera,isnull(per.periodo,pa.codigo) as periodo,
               tie1.codigo as codigo_ingreso,tie1.descripcion tipo_ingreso, tee1.codigo as codigo_estado_carrera,eojg.id_estudiante_oferta_final,per.id_paralelo,per.id_nivel,per.fecha_matricula
        from aca.estudiante_oferta roo
        inner join mig.estudiante_oferta_jerarquia_grado eojg  on eojg.id_estudiante_oferta_original=roo.id_estudiante_oferta
        inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta=eojg.id_estudiante_oferta_origen
        inner join man.personas p on eo.id_persona = p.id
        left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
        inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
        inner join aca.tipo_estado_estudiante tee1 on eo.id_tipo_estado_estudiante = tee1.id_tipo_estado_estudiante
        inner join aca.tipo_ingreso_estudiante tie1 on eo.id_tipo_ingreso_estudiante = tie1.id_tipo_ingreso_estudiante
        left  join  (
                    select pa.codigo as periodo,em1.id_estudiante_oferta,ma.id_nivel,ea1.id_paralelo,pa.fecha_desde as fecha_matricula,
                           ROW_NUMBER() OVER (PARTITION BY em1.id_estudiante_oferta  ORDER BY pa.codigo desc ) as fila
                    from aca.estudiante_matricula em1
                    inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                    inner join aca.asignatura_aprendizaje aa on ea1.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                    inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
                    inner join aca.matricula_general mg on em1.id_matricula_general = mg.id_matricula_general
                    inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
                    where em1.estado='A'
                ) as per on per.id_estudiante_oferta = eo.id_estudiante_oferta and per.fila = 1
                where eo.estado='A' and om.id_tipo_oferta in (1,2)
    ) as niv on niv.id_persona = p.id
    inner join
         (select om.id_tipo_oferta,om.carrera,om.modalidad,eo.id_estudiante_oferta,eo.id_oferta_modalidad,eo.id_persona,tee2.descripcion as estado_carrera,
                 isnull(per.periodo,pa.codigo) as periodo,tee2.codigo as codigo_estado_carrera,per.id_paralelo,per.id_nivel
                  from aca.estudiante_oferta eo
            inner join man.personas p on eo.id_persona = p.id
            left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
            inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
            inner join aca.tipo_estado_estudiante tee2 on eo.id_tipo_estado_estudiante = tee2.id_tipo_estado_estudiante
            inner join aca.tipo_ingreso_estudiante tie2 on eo.id_tipo_ingreso_estudiante = tie2.id_tipo_ingreso_estudiante
            left  join  (select pa.codigo as periodo,em1.id_estudiante_oferta,ma.id_nivel,ea1.id_paralelo,pa.fecha_desde as fecha_matricula,ROW_NUMBER() OVER (PARTITION BY em1.id_estudiante_oferta  ORDER BY pa.codigo desc ) as fila from aca.estudiante_matricula em1
                                                    inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
                                                    inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                                                    inner join aca.asignatura_aprendizaje aa on ea1.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                                                    inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
                                                    inner join aca.matricula_general mg on em1.id_matricula_general = mg.id_matricula_general
                                                    inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
                    where em1.estado='A') as per on per.id_estudiante_oferta = eo.id_estudiante_oferta and per.fila = 1
            where eo.estado='A'
    ) as gra on gra.id_estudiante_oferta = niv.id_estudiante_oferta_final
    left join mig.graduados as g on g.id_persona= gra.id_persona and g.id_oferta_modalidad= gra.id_oferta_modalidad
    left join aca.periodo_academico pg on g.id_periodo_academico = pg.id_periodo_academico
     where     p.estado='AC' --and ro.id_record_oferta is null and ro1.id_record_oferta is null
       and niv.periodo >='2016-1'
    group by niv.id_estudiante_oferta, p.identificacion, p.apellidos, p.nombres, p.sexo, niv.carrera, niv.tipo_ingreso, niv.periodo, gra.id_estudiante_oferta, gra.id_tipo_oferta,
             gra.carrera, niv.periodo, g.fecha_graduacion, niv.tipo_ingreso, gra.modalidad, niv.modalidad,gra.periodo,gra.estado_carrera,niv.estado_carrera,
             gra.codigo_estado_carrera,niv.codigo_estado_carrera, p.id, pg.codigo, g.duracion_estudios, g.duracion_carrera, g.fecha_egreso, g.id_graduado, gra.id_paralelo,
             g.id_metodo_titulacion, niv.id_oferta_modalidad, niv.id_periodo_academico, gra.id_nivel,niv.id_nivel,niv.id_paralelo,niv.codigo_ingreso,niv.fecha_matricula
end

--insertar las relaciones de grado
select roj.id_estudiante_oferta_jerarquia,roj.id_persona,roj.identificacion,iif(ofa.id_tipo_oferta=1,eo1.id_estudiante_oferta,eo.id_estudiante_oferta) as id_estudiante_oferta_origen,
       iif(ofa.id_tipo_oferta=1,ofa1.carrera,ofa.carrera) as carrera_origen,
              roj.id_estudiante_oferta_origen as id_estudiante_oferta_original,roj.carrera_origen as carrera_original,roj.id_estudiante_oferta_final,roj.carrera_final,roj.nodos_max,roj.redisenios,roj.cambios_carrera,roj.fecha_actualizacion
       from mig.estudiante_oferta_jerarquia roj
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta =roj.id_estudiante_oferta_origen
inner join aca.ofertas_facultad  ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
inner join  aca.estudiante_oferta eo1 on eo1.id_estudiante_oferta_padre =eo.id_estudiante_oferta
inner join aca.ofertas_facultad  ofa1 on ofa1.id_oferta_modalidad = eo1.id_oferta_modalidad
where ofa1.id_tipo_oferta not in (1)

select * from mig.estudiante_oferta_jerarquia_grado
select * from man.personas where identificacion in (
    '0706801891'
    )

select * from man.estado_civil

---reporte de estudiantes foraneos matriculados 1-8
      select p.id as id_persona,p.identificacion,concat(p.apellidos,' ',p.nombres) as nombres,
                      iif(p.sexo='M','MASCULINO','FEMENIMO') as sexo,cast(isnull(cast( (DATEDIFF(YEAR ,p.fecha_nace, getdate())) as decimal(10,0)),0)as int) as edad,
                      iif(p.id_estado_civil is null,'NO REGISTRA',ec.descripcion) as estado_civil,
                      iif(p.id_discapacidad is null,'NINGUNA',dis.descripcion) as discapacidad,
                      isnull(iif(p.id_discapacidad is null,'0',iif(p.porcentaje_dis ='','0',p.porcentaje_dis)),'0') as porcentaje_discapacidad,
                      iif(p.id_pais_nacionalidad is null,'NO REGISTRA',pais.descripcion) as pais,iif(p.id_provincia_nacionalidad is null,'NO REGISTRA',pro.descripcion) as provincia,
                      iif(p.id_canton_nacionalidad is null,'NO REGISTRA',can.descripcion) as canton,iif(p.id_parroquia_nacionalidad is null,'NO REGISTRA',par.descripcion) as parroquia,
                      iif(p.id_etnia is null,'NO REGISTRA',e.descripcion) as etnia,iif(p.id_nacionalidad_indigena is null,'NO REGISTRA',nai.descripcion) as nacionalidad_indigena,
                      om.facultad,om.carrera,tee.codigo as codigo_estado_carrera,tee.descripcion as estado_carrera,tie.descripcion as tipo_ingreso,
                      isnull(pa.codigo,per.periodo) as periodo,iif(per.id_paralelo is null,'NO MATRICULADO',cast(per.id_paralelo as varchar(15))) as paralelo,
                      iif(per.id_nivel is null,'NO MATRICULADO',cast(per.id_nivel as varchar(15))) as nivel,
                     isnull(cfp.puntaje,0) as  PUNTAJE,
                isnull(( SELECT TOP (1) CONCAT(gs.identificador, '(', gs.descripcion, ')') FROM dbu.grupo_socioeconomico gs
                 WHERE cfp.puntaje BETWEEN gs.umbral_inferior AND gs.umbral_superior
                 ORDER BY gs.umbral_inferior DESC),'NO REGISTRA') AS GRUPO_SOCIOECONÓMICO
      from man.personas p

               left JOIN dbu.cab_ficha_persona cfp
                          ON cfp.id_persona = p.id and  cfp.id_ficha = 26  AND cfp.estado = 'A' AND cfp.porcentaje_completado >= 95
                            --  AND f.id_periodo_academico = 96
                           --   and lg.descripcion<>'SANTA ELENA'  AND puntaje<=536

               inner join aca.estudiante_oferta eo on eo.id_persona = p.id
                inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
                inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
                inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
               inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
               inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
               left join aca.periodo_academico pa on eo.id_periodo_academico = pa.id_periodo_academico
               left join man.lugar pais on pais.id_lugar = p.id_pais_nacionalidad and pais.estado='A'
               left join man.lugar pro on pro.id_lugar = p.id_provincia_nacionalidad and pro.estado='A'
               left join man.lugar can on can.id_lugar = p.id_canton_nacionalidad and can.estado='A'
               left join man.lugar par on par.id_lugar = p.id_parroquia_nacionalidad and par.estado='A'
               left join man.discapacidad dis on dis.id_discapacidad = p.id_discapacidad and dis.estado='A'
               left join man.etnia e on e.id_etnia = p.id_etnia and e.estado='A'
               left join man.estado_civil ec on p.id_estado_civil = ec.id_estado_civil and ec.estado='A'
               left join man.nacionalidad_indigena nai on nai.id_nacionalidad_indigena = p.id_nacionalidad_indigena and nai.estado='A'
               left  join  (
          select pa.codigo as periodo,em1.id_estudiante_oferta,ma.id_nivel,ea1.id_paralelo,pa.fecha_desde as fecha_matricula,
                 ROW_NUMBER() OVER (PARTITION BY em1.id_estudiante_oferta  ORDER BY pa.codigo desc ) as fila
          from aca.estudiante_matricula em1
                   inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                   inner join aca.asignatura_aprendizaje aa on ea1.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                   inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
                   inner join aca.matricula_general mg on em1.id_matricula_general = mg.id_matricula_general
                   inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
          where em1.estado='A'
      ) as per on per.id_estudiante_oferta = eo.id_estudiante_oferta and per.fila = 1
      where p.estado='AC' and eo.estado='A' and om.id_tipo_oferta = 2 and tee.codigo='ACT' and (p.id_provincia_nacionalidad is null or p.id_provincia_nacionalidad <>270)
      and mg.id_periodo_academico in (95,96)
group by p.nombres,p.identificacion, p.sexo, p.fecha_nace, p.id, p.apellidos, p.id_estado_civil, ec.descripcion, p.id_discapacidad, dis.descripcion, p.porcentaje_dis,
         p.id_pais_nacionalidad, pais.descripcion, p.id_provincia_nacionalidad, p.id_canton_nacionalidad, p.id_parroquia_nacionalidad, p.id_etnia, e.descripcion,
         p.id_nacionalidad_indigena, nai.descripcion, om.facultad, om.carrera, tee.codigo, tee.descripcion, tie.descripcion, pa.codigo, per.id_paralelo, per.id_nivel,
         pais.descripcion,pro.descripcion,can.descripcion,par.descripcion,per.periodo, cfp.puntaje
        order by p.apellidos,p.nombres

---reporte de estudiantes 1 semestre
select p.id as id_persona,p.identificacion,concat(p.apellidos,' ',p.nombres) as nombres,
       iif(p.sexo='M','MASCULINO','FEMENIMO') as sexo,cast(isnull(cast( (DATEDIFF(YEAR ,p.fecha_nace, getdate())) as decimal(10,0)),0)as int) as edad,
       iif(p.id_estado_civil is null,'NO REGISTRA',ec.descripcion) as estado_civil,
       iif(p.id_discapacidad is null,'NINGUNA',dis.descripcion) as discapacidad,
       isnull(iif(p.id_discapacidad is null,'0',iif(p.porcentaje_dis ='','0',p.porcentaje_dis)),'0') as porcentaje_discapacidad,
       iif(p.id_pais_nacionalidad is null,'NO REGISTRA',pais.descripcion) as pais,iif(p.id_provincia_nacionalidad is null,'NO REGISTRA',pro.descripcion) as provincia,
       iif(p.id_canton_nacionalidad is null,'NO REGISTRA',can.descripcion) as canton,iif(p.id_parroquia_nacionalidad is null,'NO REGISTRA',par.descripcion) as parroquia,
       iif(p.id_etnia is null,'NO REGISTRA',e.descripcion) as etnia,iif(p.id_nacionalidad_indigena is null,'NO REGISTRA',nai.descripcion) as nacionalidad_indigena,
       om.facultad,om.carrera,tee.codigo as codigo_estado_carrera,tee.descripcion as estado_carrera,tie.descripcion as tipo_ingreso,
       isnull(pa.codigo,per.periodo) as periodo,iif(per.id_paralelo is null,'NO MATRICULADO',cast(per.id_paralelo as varchar(15))) as paralelo,
       iif(per.id_nivel is null,'NO MATRICULADO',cast(per.id_nivel as varchar(15))) as nivel,
       cfp.puntaje as  PUNTAJE,
       (
           SELECT TOP (1)
               CONCAT(gs.identificador, '(', gs.descripcion, ')')
           FROM dbu.grupo_socioeconomico gs
           WHERE cfp.puntaje BETWEEN gs.umbral_inferior AND gs.umbral_superior
           ORDER BY gs.umbral_inferior DESC
       ) AS GRUPO_SOCIOECONÓMICO
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         left join aca.periodo_academico pa on eo.id_periodo_academico = pa.id_periodo_academico
         left join man.lugar pais on pais.id_lugar = p.id_pais_nacionalidad and pais.estado='A'
         left join man.lugar pro on pro.id_lugar = p.id_provincia_nacionalidad and pro.estado='A'
         left join man.lugar can on can.id_lugar = p.id_canton_nacionalidad and can.estado='A'
         left join man.lugar par on par.id_lugar = p.id_parroquia_nacionalidad and par.estado='A'
         left join man.discapacidad dis on dis.id_discapacidad = p.id_discapacidad and dis.estado='A'
         left join man.etnia e on e.id_etnia = p.id_etnia and e.estado='A'
         left join man.estado_civil ec on p.id_estado_civil = ec.id_estado_civil and ec.estado='A'
         left join man.nacionalidad_indigena nai on nai.id_nacionalidad_indigena = p.id_nacionalidad_indigena and nai.estado='A'
         left JOIN dbu.cab_ficha_persona cfp ON cfp.id_persona = p.id and  cfp.id_ficha = 26  AND cfp.estado = 'A' AND cfp.porcentaje_completado >= 95
         left  join  (
    select pa.codigo as periodo,em1.id_estudiante_oferta,ma.id_nivel,ea1.id_paralelo,pa.fecha_desde as fecha_matricula,
           ROW_NUMBER() OVER (PARTITION BY em1.id_estudiante_oferta  ORDER BY pa.codigo desc ) as fila
    from aca.estudiante_matricula em1
             inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
             inner join aca.asignatura_aprendizaje aa on ea1.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
             inner join aca.matricula_general mg on em1.id_matricula_general = mg.id_matricula_general
             inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
    where em1.estado='A'
) as per on per.id_estudiante_oferta = eo.id_estudiante_oferta and per.fila = 1
where p.estado='AC' and eo.estado='A' and om.id_tipo_oferta = 2 and tee.codigo='ACT'-- and (p.id_provincia_nacionalidad is null or p.id_provincia_nacionalidad <>270)
  and eo.id_periodo_academico in (95,96,136,137)
group by p.nombres,p.identificacion, p.sexo, p.fecha_nace, p.id, p.apellidos, p.id_estado_civil, ec.descripcion, p.id_discapacidad, dis.descripcion, p.porcentaje_dis,
         p.id_pais_nacionalidad, pais.descripcion, p.id_provincia_nacionalidad, p.id_canton_nacionalidad, p.id_parroquia_nacionalidad, p.id_etnia, e.descripcion,
         p.id_nacionalidad_indigena, nai.descripcion, om.facultad, om.carrera, tee.codigo, tee.descripcion, tie.descripcion, pa.codigo, per.id_paralelo, per.id_nivel,
         pais.descripcion,pro.descripcion,can.descripcion,par.descripcion,per.periodo, cfp.puntaje
order by p.apellidos,p.nombres