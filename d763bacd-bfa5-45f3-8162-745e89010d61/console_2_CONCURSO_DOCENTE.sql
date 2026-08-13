use bd_sga_upse;
select * from mov.becario;

select 10 as idDocenteCatgeoria,v.id_docente_dedicacion,v.id_oferta,null as idTituloAcademicoTercerNivel,null as idTituloAcademicoCuartoNivel,
       v.codigo,v.funciones as descripcion,v.funciones as asignatura,v.funciones,v.titulo_tercer_nivel,v.titulo_cuarto_nivel,v.horas_clase,
       v.horas_actividades,v.campo_amplio_conocimiento,v.campo_amplio_conocimiento as campo_detallado_conocimiento,'A',0,v.fecha_ing,v.fecha_mod,v.usuario_ing,v.usuario_mod
from cmo.vacante v
where v.estado='A'

select * from pro.tipo_proceso

select * from pro.proceso

select pc.* from pro.proceso_calendario pc
inner join pro.proceso_general pg on pc.id_proceso_general = pg.id_proceso_general
where pg.id_proceso = 34

select tpp.id_tipo_proceso as idTipoProcesoPadre,tpp.codigo as codigoPadre,tp.id_tipo_proceso as idTipoProceso,tp.codigo as codigo,
       p.id_proceso,p.descripcion as proceso from pro.proceso p
                                                      inner join pro.tipo_proceso tp on p.id_tipo_proceso = tp.id_tipo_proceso
                                                      inner join pro.tipo_proceso tpp on tpp.id_tipo_proceso = tp.id_tipo_proceso_padre
where tpp.codigo ='CONCURSOS' and p.estado='A' and tp.estado='A' and tpp.estado='A'


select pg.id_proceso_general,p.descripcion,e.descripcion,pc.fecha_desde,pc.fecha_hasta from pro.proceso p
inner join pro.tipo_proceso tp on p.id_tipo_proceso = tp.id_tipo_proceso
inner join pro.proceso_general pg on p.id_proceso = pg.id_proceso
inner join pro.proceso_calendario pc on pg.id_proceso_general = pc.id_proceso_general
inner join pro.proceso_etapa pe on pc.id_proceso_etapa = pe.id_proceso_etapa and p.id_proceso=pe.id_proceso
inner join pro.etapa e on pe.id_etapa = e.id_etapa
where tp.codigo ='MERITOYOPOSICIONTUTILAR' and pg.id_proceso_general <90 order by pe.orden

select o.descripcion as carrera,p.identificacion,o.correo,concat(p.apellidos,' ',p.nombres) as nombres,'DIRECTOR' as Cargo,p.email_institucional,p.email_personal
from aca.oferta_modalidad om
         inner join aca.periodo_academico_oferta pao on om.id_oferta_modalidad = pao.id_oferta_modalidad and pao.id_periodo_academico=35
         inner join aca.oferta o on o.id_oferta = om.id_oferta
         inner join seg.roles_usuario_oferta ruo on  ruo.oferta_id = o.id_oferta
         inner join seg.roles_usuarios ru on ru.id = ruo.rol_usuario_id
         inner join seg.roles r on ru.rol_id = r.id
         inner join seg.usuarios u on u.id= ru.usuario_id
         inner join man.personas p on u.persona_id = p.id
where r.codigo='CORCOMVINCARR' and o.estado='A' and o.id_tipo_oferta = 2 and ruo.estado='AC' and pao.estado='A'
order by o.descripcion

select * from pro.tipo_proceso_estado
select * from man.opciones where id in (342,376,398,448)

SELECT *
FROM pro.fn_list_all_rubricas_evaluaciones_by_clasificacion(96, 63, 1,8170, 39, 'MERITOYOPOSICIONTUTILAR')

select dce.*
from [pro].[fn_list_all_rubricas_evaluaciones_procesos]
     (96, 'MERITOYOPOSICIONTUTILAR',63,null) as d
         inner join pro.evaluaciones_docente_categoria evdc on d.idEtapaEvaluacion = evdc.id_etapa_evaluacion
         inner join pro.etapa_docente_categoria edc on edc.id_proceso_calendario = d.idProcesoCalendario
         inner join aca.docente_categoria dc on dc.id_docente_categoria = edc.id_docente_categoria and evdc.id_docente_categoria = dc.id_docente_categoria
         inner join pro.docente_categoria_evaluacion dce on dce.id_evaluacion_requisito = d.idEvaluacionRequisito and dc.id_docente_categoria = dce.id_docente_categoria
         inner join pro.proceso_requisito pr on pr.id_proceso_requisito = d.idProcesoRequisito
         left join  aca.tipo_documento td on td.id_tipo_documento = pr.id_tipo_documento
         inner join aca.tipo_archivo ta on ta.id_tipo_archivo = pr.id_tipo_archivo
         inner join pro.proceso_usuario2 pu on pu.id_proceso_general = d.idProcesoGeneral
         inner join pro.postulacion_vacante pv on pv.id_proceso_usuario = pu.id_proceso_usuario
         inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario
         inner join pro.etapa_ejecucion_responsable2 ejr on ejr.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion
         left join pro.etapa_ejecucion_documento2 eed on eed.id_etapa_ejecucion_responsable = ejr.id_etapa_ejecucion_responsable
    and eed.id_docente_categoria_evaluacion =dce.id_docente_categoria_evaluacion  and eed.estado='A'
where dc.id_docente_categoria = 7 and pej.id_proceso_etapa = 39 and pu.id_proceso_usuario = 8170
  and edc.estado='A' and dc.estado='A' and evdc.estado='A' and dce.estado='A' and ejr.estado='A'
order by dce.orden

SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_to_evaluar2](96,63,1,
                                                                                     'REQUISITOS',8202,
                                                                                     39,'MERITOYOPOSICIONTUTILAR')

select * from aca.docente_categoria

select * from pro.docente_categoria_evaluacion dce

select * from pro.tipo_categorias_evaluacion

SELECT *
FROM pro.fn_list_all_rubricas_evaluaciones_by_clasificacion(96, 63, 1,8170, 39, 'MERITOYOPOSICIONTUTILAR')


select p.* from pro.proceso p
                    inner join pro.tipo_proceso tp on p.id_tipo_proceso = tp.id_tipo_proceso
where tp.codigo ='MERITOYOPOSICIONTUTILAR'

select * from aca.tipo_matricula_fecha


select m.descripcion,eo.* from aca.estudiante_oferta eo
                                   inner join aca.malla m on m.id_malla = eo.id_malla
where eo.estado='I'
order by eo.id_estudiante_oferta asc


select d.facultad,d.carrera,d.asignatura,count(d.identificacion) as numeroPostulantes from [pro].[fn_list_postulaciones_concursos_merito_upse](30,null,null,null,
                                                                                                                                               null,null,null,'CONCURSOMERITO') as d
group by d.facultad,d.carrera,d.asignatura
--NUMERO DE POSTULANTES POR CARRERA
select d.nombre as departamento ,o.descripcion as oferta,a.descripcion as asignatura, n.descripcion as nivel,prov.id_proceso_vacante,count(aux.identificacion) as postulantes
from pro.proceso_vacante prov
         inner join pro.vacante v on prov.id_vacante=v.id_vacante
         inner join pro.proceso_general pg on prov.id_proceso_general=pg.id_proceso_general
         inner join pro.proceso p on pg.id_proceso=p.id_proceso
         inner join pro.tipo_proceso tp on tp.id_tipo_proceso=p.id_tipo_proceso
         inner join aca.oferta o on v.id_oferta=o.id_oferta
         inner join aca.departamento_oferta dof on dof.id_oferta=o.id_oferta
         inner join man.departamentos d on dof.id_departamento=d.id
         inner join pro.vacante_asignatura va on v.id_vacante=va.id_vacante
         inner join aca.malla_asignatura  ma on va.id_malla_asignatura=ma.id_malla_asignatura
         inner join aca.modalidad_asignatura modA on modA.id_modalidad_asignatura=ma.id_modalidad_asignatura
         inner join aca.asignatura a on ma.id_asignatura=a.id_asignatura
         inner join aca.nivel n on ma.id_nivel=n.id_nivel
         inner join aca.docente_categoria dc on v.id_docente_categoria=dc.id_docente_categoria
         inner join aca.docente_dedicacion dd on v.id_docente_dedicacion=dd.id_docente_dedicacion
         left join (select pu2.id_proceso_usuario,pv.id_proceso_vacante,per.identificacion,per.nombres,per.apellidos from pro.proceso_usuario2 pu2
                                                                                                                              inner join pro.tipo_proceso_estado tpe on tpe.id_tipo_proceso_estado = pu2.id_tipo_proceso_estado
                                                                                                                              inner join pro.postulacion_vacante pv on pu2.id_proceso_usuario=pv.id_proceso_usuario
                                                                                                                              inner join pro.proceso_etapa_ejecucion2 pee2 on pu2.id_proceso_usuario = pee2.id_proceso_usuario
                                                                                                                              inner join man.personas per on pu2.id_persona=per.id
                                                                                                                              inner join seg.usuarios u on u.persona_id = per.id
                    where pu2.estado='A' and pv.estado='A' and per.estado='AC' and u.estado='AC' and pee2.id_proceso_etapa = 5) as aux on aux.id_proceso_vacante = prov.id_proceso_vacante
where pg.estado='A' and p.estado='A'  and prov.estado='A' and modA.estado='A'
  and v.estado ='A' and o.estado='A'  and prov.estado='A'
  and (tp.codigo='CONCURSOMERITO')
group by d.nombre,o.descripcion,a.descripcion, n.descripcion,prov.id_proceso_vacante

select d.facultad,d.carrera,d.asignatura,d.categoriaDocente,d.serie,d.identificacion,d.postulante,d.emailPersonal
from [pro].[fn_list_postulaciones_concursos_merito_upse](63,null,null,null,
                                                         null,null,null) as d

select  * from pro.proceso_general



select pu2.usuario_ing, count(pu2.id_proceso_usuario) from pro.proceso_usuario2 pu2
                                                               inner join pro.proceso_etapa_ejecucion2 pee2  on pu2.id_proceso_usuario = pee2.id_proceso_usuario
-- inner join pro.etapa_ejecucion_responsable2 eer2  on pee2.id_proceso_etapa_ejecucion = eer2.id_proceso_etapa_ejecucion
-- left join pro.etapa_ejecucion_documento2 eed2  on eer2.id_etapa_ejecucion_responsable = eed2.id_etapa_ejecucion_responsable
where pee2.id_proceso_etapa = 1 and pu2.estado='A'
group by  pu2.usuario_ing
having count(pu2.id_proceso_usuario)>1

select pu2.* from pro.proceso_usuario2 pu2
                      inner join pro.proceso_etapa_ejecucion2 pee2  on pu2.id_proceso_usuario = pee2.id_proceso_usuario
-- inner join pro.etapa_ejecucion_responsable2 eer2  on pee2.id_proceso_etapa_ejecucion = eer2.id_proceso_etapa_ejecucion
-- left join pro.etapa_ejecucion_documento2 eed2  on eer2.id_etapa_ejecucion_responsable = eed2.id_etapa_ejecucion_responsable
where pee2.id_proceso_etapa = 1 and pu2.usuario_ing in ('1312040395','1312308925','0922627468')



--reporte final con notas grabadas
-- update pee
--     set pee.calificacion = d.calificacionExposicionProyecto
select
--     pee.*
d.nombre,d.descripcion,d.asignatura,d.categoriaDocente,d.identificacion,d.id_proceso_usuario,d.postulante,d.email,d.calificacionMerito,
d.calificacionPruebaOral,d.calificacionPruebaEscrita,
cast(iif(d.id_docente_categoria=1, d.calificacionClaseDemostrativa*10/100,d.calificacionClaseDemostrativa*20/100) as numeric(7,2)) as calificacionClaseDemostrativaa,
d.calificacionExposicionProyecto as calificacionExposicionProyectoInvestigacion,
d.calificacionMerito+d.calificacionPruebaOral+d.calificacionPruebaEscrita+cast(iif(d.id_docente_categoria=1, d.calificacionClaseDemostrativa*10/100,d.calificacionClaseDemostrativa*20/100)as numeric(7,2))+
d.calificacionExposicionProyecto as totalConcurso
from (
         select d.nombre,o.descripcion,UPPER(v.asignatura)as  asignatura,dc.descripcion as categoriaDocente,p.id,p.identificacion,UPPER(concat(p.apellidos,' ',p.nombres)) as postulante,
                pu.id_proceso_usuario,iif(p.email_institucional is null or p.email_institucional='',email_personal,email_institucional) as email,v.id_docente_categoria,
                iif(isnull(pee2.calificacion,0)>=50,50,isnull(pee2.calificacion,0)) as calificacionMerito,
                isnull((select peep.calificacion from pro.proceso_etapa_ejecucion2 peep where peep.id_proceso_etapa =1 and peep.id_proceso_usuario=pu.id_proceso_usuario),0) as calificacionPruebaEscrita,
                isnull((select peep.calificacion from pro.proceso_etapa_ejecucion2 peep where peep.id_proceso_etapa =2 and peep.id_proceso_usuario=pu.id_proceso_usuario),0) as calificacionPruebaOral,
                isnull((select peep.calificacion from pro.proceso_etapa_ejecucion2 peep where peep.id_proceso_etapa =46 and peep.id_proceso_usuario=pu.id_proceso_usuario),0) as calificacionClaseDemostrativa,
                isnull((select peep.calificacion from pro.proceso_etapa_ejecucion2 peep where peep.id_proceso_etapa =47 and peep.id_proceso_usuario=pu.id_proceso_usuario),0) as calificacionExposicionProyecto
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
           and pee2.estado='A' and pee2.id_proceso_etapa = 2
           and pu.id_proceso_general = 105
         group by d.nombre,o.descripcion,v.asignatura,p.id,p.identificacion,p.apellidos,p.nombres,pu.id_proceso_usuario,v.id_docente_categoria,tpe.codigo,
                  pee2.id_proceso_etapa_ejecucion,p.email_institucional,email_personal,dc.descripcion,pee2.calificacion
-- order by d.nombre,o.descripcion,v.asignatura,p.apellidos,p.nombres
     ) as d
-- inner join pro.proceso_etapa_ejecucion2 pee on pee.id_proceso_usuario = d.id_proceso_usuario
-- where pee.id_proceso_etapa = 47
--     d.codigo <>d.merito
-- and
order by d.nombre,d.descripcion,d.asignatura,d.postulante

select * from pro.proceso_etapa_ejecucion2 where id_proceso_etapa = 1 and id_proceso_usuario in (5343,
6432,
6519,
6721

)

--actualizar la calificacion en las cabeceras de proceso etapa ejecucion
--     1724166689
-- 0908955826
--acuas setear notas de merito
select * from pro.tipo_proceso_estado
select * from pro.tipo_etapa_estado

select * from pro.tipo_proceso_estado

select * from man.personas

SELECT * FROM pro.fn_list_postulantes_to_notificate_CMO(70, 1, 80)

-- update pu2
-- set pu2.id_tipo_proceso_estado = case    when d.calificacionSumada =0 and d.estado_etapa<>'ACCEDE A FASE DE MÉRITOS' then 8
--                                          when d.calificacionSumada>=0  and  d.calificacionSumada<41.5 then 9
--                                          when d.calificacionSumada>=41.5 then 10 else 8 end
select * from pro.fn_acta_consolidada_concurso (70, null, null)
select * from seg.roles
--set estadp proceso_usuario_principal merito
begin
        declare @id_proceso_etapa int = 1,@id_proceso_etapa_cal int = 2
--                 update pee
--                 set pee.calificacion = d.calificacionSumada,pee.id_tipo_proceso_estado = case    when d.calificacionSumada =0 and d.estado_etapa<>'ACCEDE A FASE DE MÉRITOS' then 8
--                 when d.calificacionSumada>=0  and  d.calificacionSumada<42 then 9
--                 when d.calificacionSumada>=42 then 10 else 8 end
--             update pu2 set pu2.id_tipo_proceso_estado = case     when cast(d.calificacionSumada as decimal(10,2)) =0 then 8
--                             when cast(d.calificacionSumada as decimal(10,2))>0  and  cast(d.calificacionSumada as decimal(10,2))<42 then 9
--                 when cast(d.calificacionSumada as decimal(10,2))>=42 then 10 else 8 end
--         pee.*,
            select
d.id_proceso_usuario,d.nombre,d.descripcion,d.asignatura,d.categoriaDocente,d.identificacion,d.postulante,d.email,d.calificacionSumada,d.calificacion,d.calificacionRedondeada,d.estado_etapa
        ,case    when cast(d.calificacionSumada as decimal(10,2)) =0 then 8
                when cast(d.calificacionSumada as decimal(10,2))>0  and  cast(d.calificacionSumada as decimal(10,2))<42 then 9
                when cast(d.calificacionSumada as decimal(10,2))>=41.5 then 10 else 8 end as id_tipo_proceso_estado,d.estado_usuario

    from (
             select d.nombre,o.descripcion,UPPER(v.asignatura)as  asignatura,dc.descripcion as categoriaDocente,p.id,p.identificacion,UPPER(concat(p.apellidos,' ',p.nombres)) as postulante,
                    pu.id_proceso_usuario,iif(p.email_institucional is null or p.email_institucional='',email_personal,email_institucional) as email,v.id_docente_categoria,
                    isnull([pro].[fn_sca_get_calificacion_by_evaluacion](@id_proceso_etapa_cal,pu.id_proceso_usuario),0) as calificacionSumada,
                    round(isnull([pro].[fn_sca_get_calificacion_by_evaluacion](@id_proceso_etapa_cal,pu.id_proceso_usuario),0),0) as calificacionRedondeada,pej.calificacion,
                    (select tpe2.descripcion from pro.proceso_etapa_ejecucion2 pee22
                              inner join pro.tipo_proceso_estado tpe2 on pee22.id_tipo_proceso_estado = tpe2.id_tipo_proceso_estado
                              where pee22.estado='A' and tpe2.estado='A' and pee22.id_proceso_usuario=pu.id_proceso_usuario and pee22.id_proceso_etapa=@id_proceso_etapa) as estado_etapa,tpe.descripcion as estado_usuario

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
              inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario and pej.estado='A' and pej.id_proceso_etapa = @id_proceso_etapa
             where  pu.estado='A' and pv.estado='A' and prv.estado='A' and v.estado='A' and pu.id_proceso_general = 70 --AND P.identificacion ='0802990838'
--      and pej.calificacion<42
             group by d.nombre,o.descripcion,v.asignatura,p.id,p.identificacion,p.apellidos,p.nombres,pu.id_proceso_usuario,v.id_docente_categoria,tpe.codigo
                    ,pej.id_proceso_etapa_ejecucion,p.email_institucional,email_personal,dc.descripcion,pej.calificacion,tpe.descripcion
             -- order by d.nombre,o.descripcion,v.asignatura,p.apellidos,p.nombres
         ) as d
             inner join pro.proceso_etapa_ejecucion2 pee on pee.id_proceso_usuario = d.id_proceso_usuario
            inner join pro.proceso_usuario2 pu2  on pee.id_proceso_usuario = pu2.id_proceso_usuario
--     where pee.id_proceso_etapa = @id_proceso_etapa
and d.estado_usuario<>d.estado_etapa
--         and d.calificacionSumada>=42
--         and d.calificacion <>d.calificacionSumada
    -- and
--     order by d.nombre,d.descripcion,d.asignatura,d.postulante
end
-- 0926480153

--set calificaciones de merito

select * from pro.proceso_etapa_ejecucion2 where id_proceso_usuario in (5620,
    5438,
6962,
5378,
5716
    )


-- 0916681984	MORÁN RAMOS  ANA MERCEDES
-- 1750213942	PINCAY BERRÚ  ANTHONY JORDCKAEF
-- 0915982037	VERA OSORIO DIÓGENES FRANCISCO
-- 0928890722	HERRERA ZAMBRANO STALIN JOEL
-- 0201224284	ANALUISA AROCA IVÁN ALBERTO

begin
        declare @id_proceso_etapa int = 2
    update pee
    set pee.calificacion = d.calificacionSumada
      ,pee.id_tipo_proceso_estado = case    when d.calificacionSumada =0 and d.estado_etapa<>'ACCEDE A FASE DE MÉRITOS' then 8
                when d.calificacionSumada>=0  and  d.calificacionSumada<41.5 then 9
                when d.calificacionSumada>=41.5 then 10 else 8 end
--     select
-- --         pee.*
-- d.id_proceso_usuario,d.nombre,d.descripcion,d.asignatura,d.categoriaDocente,d.identificacion,d.postulante,d.email,d.calificacionSumada,d.calificacion,d.calificacionRedondeada,d.estado_etapa
--         ,case     when cast(d.calificacionSumada as decimal(10,2)) =0 then 8
--                          when cast(d.calificacionSumada as decimal(10,2))>0  and  cast(d.calificacionSumada as decimal(10,2))<41.5 then 9
--                          when cast(d.calificacionSumada as decimal(10,2))>=41.5 then 10 else 8 end as id_tipo_proceso_estado

    from (
             select d.nombre,o.descripcion,UPPER(v.asignatura)as  asignatura,dc.descripcion as categoriaDocente,p.id,p.identificacion,UPPER(concat(p.apellidos,' ',p.nombres)) as postulante,
                    pu.id_proceso_usuario,iif(p.email_institucional is null or p.email_institucional='',email_personal,email_institucional) as email,v.id_docente_categoria,
                    isnull([pro].[fn_sca_get_calificacion_by_evaluacion](@id_proceso_etapa,pu.id_proceso_usuario),0) as calificacionSumada,
                    round(isnull([pro].[fn_sca_get_calificacion_by_evaluacion](@id_proceso_etapa,pu.id_proceso_usuario),0),0) as calificacionRedondeada,pej.calificacion,
                    (select tpe2.descripcion from pro.proceso_etapa_ejecucion2 pee22
                              inner join pro.tipo_proceso_estado tpe2 on pee22.id_tipo_proceso_estado = tpe2.id_tipo_proceso_estado
                              where pee22.estado='A' and tpe2.estado='A' and pee22.id_proceso_usuario=pu.id_proceso_usuario and pee22.id_proceso_etapa=1) as estado_etapa

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
              inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario and pej.estado='A' and pej.id_proceso_etapa = @id_proceso_etapa
             where  pu.estado='A' and pv.estado='A' and prv.estado='A' and v.estado='A' and pu.id_proceso_general = 63 --AND P.identificacion ='0802990838'
--      and pej.calificacion<42
             group by d.nombre,o.descripcion,v.asignatura,p.id,p.identificacion,p.apellidos,p.nombres,pu.id_proceso_usuario,v.id_docente_categoria,tpe.codigo
                    ,pej.id_proceso_etapa_ejecucion,p.email_institucional,email_personal,dc.descripcion,pej.calificacion
             -- order by d.nombre,o.descripcion,v.asignatura,p.apellidos,p.nombres
         ) as d
             inner join pro.proceso_etapa_ejecucion2 pee on pee.id_proceso_usuario = d.id_proceso_usuario
    where pee.id_proceso_etapa = @id_proceso_etapa
--
--         and d.calificacionSumada>=42
--         and d.calificacion <>d.calificacionSumada
    -- and
--     order by d.nombre,d.descripcion,d.asignatura,d.postulante

end

select * from pro.proceso_etapa_ejecucion2 where id_proceso_usuario =6777


--actualizar tipo proceso estado
-- 55 pasana oposicion
-- 584 totales  439 no requsitos minimos
--145 oposicion + no cumple nota minima
begin
    --     update pu set pu.id_tipo_proceso_estado = pej.id_tipo_proceso_estado
--     select pej.*
         select distinct pu.id_proceso_usuario,5,1,
                   pv.fecha_ing,null,0,0,null,null,null,null,null,'A',0,
                   pv.fecha_ing,pv.fecha_ing,pu.usuario_ing,pu.usuario_mod,10
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
             left join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario and pej.estado='A' and pej.id_proceso_etapa = 2
    where  pu.estado='A' and pv.estado='A' and prv.estado='A' and v.estado='A' and pu.id_proceso_general = 49 --AND P.identificacion ='0802990838'
      and  pej.id_tipo_proceso_estado is not null
    --       and pej.calificacion>=42
--      and pej.id_proceso_etapa_ejecucion is  null
--      group by d.nombre,o.descripcion,v.asignatura,p.id,p.identificacion,p.apellidos,p.nombres,pu.id_proceso_usuario,v.id_docente_categoria,tpe.codigo
--             ,pej.id_proceso_etapa_ejecucion,p.email_institucional,email_personal,dc.descripcion,pej.calificacion, pv.fecha_ing, pu.usuario_ing, pu.usuario_mod
--     order by d.nombre,o.descripcion,v.asignatura,p.apellidos,p.nombres
end
select * from PRO.proceso_etapa_ejecucion2

select * from pro.tipo_proceso_estado
--insert personas a fase de oposicion
begin
    declare @id_proceso_etapa int = 2

    INSERT INTO PRO.proceso_etapa_ejecucion2
    select distinct pu.id_proceso_usuario,5,1,
                    pv.fecha_ing,null,0,0,null,null,null,null,null,'A',0,
                    getdate(),getdate(),pu.usuario_ing,pu.usuario_mod,30
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
             inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario and pej.estado='A'
                                                                and pej.id_proceso_etapa = @id_proceso_etapa
             left join pro.proceso_etapa_ejecucion2 pejM on pejM.id_proceso_usuario = pu.id_proceso_usuario and pejM.estado='A'
                    and pejM.id_proceso_etapa = 5
    --  and pejMerito.calificacion is not null
    where  pu.estado='A' and pv.estado='A' and prv.estado='A' and v.estado='A' and pu.id_proceso_general = 70 --AND P.identificacion ='0802990838'
      and pej.calificacion>=42 and pejM.id_proceso_etapa_ejecucion is null
    group by d.nombre,o.descripcion,v.asignatura,p.id,p.identificacion,p.apellidos,p.nombres,pu.id_proceso_usuario,v.id_docente_categoria,tpe.codigo
           ,pej.id_proceso_etapa_ejecucion,p.email_institucional,email_personal,dc.descripcion,pej.calificacion, pv.fecha_ing, pu.usuario_ing, pu.usuario_mod
--     order by d.nombre,o.descripcion,v.asignatura,p.apellidos,p.nombres
end


--insert RESPONSABLES A fase de oposicion
begin
    declare @id_proceso_etapa int = 2
--     SELECT top 10 * FROM pro.etapa_ejecucion_responsable2 order by id_etapa_ejecucion_responsable desc
--     INSERT INTO PRO.etapa_ejecucion_responsable2
        select distinct pejNext.id_proceso_etapa_ejecucion,eer.id_persona,null,
            0,0,0,'A',0, getdate(),getdate(),pu.usuario_ing,pu.usuario_ing,null,null
        from pro.proceso_usuario2 pu
        inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario and pej.estado='A'
        and pej.id_proceso_etapa = @id_proceso_etapa
        inner join pro.etapa_ejecucion_responsable2  eer on eer.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion
        inner join pro.proceso_etapa_ejecucion2 pejNext on pejNext.id_proceso_usuario = pu.id_proceso_usuario and pejNext.estado='A'
        and pejNext.id_proceso_etapa = 5 --and pejNext.id_proceso_etapa_ejecucion =8887
        left join pro.etapa_ejecucion_responsable2 eer2  on eer2.id_persona = eer.id_persona and eer2.id_proceso_etapa_ejecucion = pejNext.id_proceso_etapa_ejecucion
        where  pu.estado='A' and pu.id_proceso_general = 70 and eer2.id_etapa_ejecucion_responsable is null
--         and pejNext.id_proceso_etapa_ejecucion=11244
        group by eer.id_persona, pejNext.id_proceso_etapa_ejecucion, pu.usuario_ing
--     order by d.nombre,o.descripcion,v.asignatura,p.apellidos,p.nombres
end

    select distinct eer.*--,p.apellidos
    from pro.proceso_usuario2 pu
    inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario
    inner join pro.etapa_ejecucion_responsable2  eer on eer.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion
    inner join man.personas p on eer.id_persona = p.id
    where  pu.estado='A' and pu.id_proceso_general = 63 and pej.id_proceso_etapa_ejecucion=11244
    and pej.estado='A'     and pej.id_proceso_etapa = 5 and eer.id_etapa_ejecucion_responsable in (17829,17870)


select * from pro.proceso_etapa_ejecucion2 pejNext
    where pejNext.id_proceso_etapa = 5 and pejNext.usuario_ing= '1724166689'

select * from pro.proceso_calendario where id_proceso_general = 49


select d.nombre,o.descripcion,UPPER(v.asignatura)as  asignatura,dc.descripcion as categoriaDocente,p.id,p.identificacion,UPPER(concat(p.apellidos,' ',p.nombres)) as postulante,
       pu.id_proceso_usuario,iif(p.email_institucional is null or p.email_institucional='',email_personal,email_institucional) as email,v.id_docente_categoria,
       isnull([pro].[fn_sca_get_calificacion_by_evaluacion](2,pu.id_proceso_usuario),0) as calificacionMerito,pejMerito.calificacion
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
         inner join pro.proceso_etapa_ejecucion2 pejMerito on pejMerito.id_proceso_usuario = pu.id_proceso_usuario and pejMerito.estado='A' and pejMerito.id_proceso_etapa = 2
--  and pejMerito.calificacion is not null
where  pu.estado='A' and pv.estado='A' and prv.estado='A' and v.estado='A' and pu.id_proceso_general = 15
ORDER BY d.nombre,d.descripcion, v.asignatura, p.apellidos,p.nombres


select * from pro.etapa_ejecucion_responsable where id_etapa_ejecucion_responsable in (3410,
                                                                                       3417


    )

select * from pro.revision_asignaturas where id_revision_asignatura in (873,
                                                                        887,
                                                                        888

    )

select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Responsable]()

select id_etapa_ejecucion_responsable,id_malla_asignatura_origen,
       MIN   (id_revision_asignatura)
from pro.revision_asignaturas
WHERE ESTADO='A'
GROUP BY id_etapa_ejecucion_responsable,id_malla_asignatura_origen
HAVING  COUNT   (id_revision_asignatura) >1

select id_proceso_etapa_ejecucion,id_persona,count(id_etapa_ejecucion_responsable)
--     MIN   (id_etapa_ejecucion_responsable)
from pro.etapa_ejecucion_responsable
WHERE ESTADO='A'
GROUP BY id_proceso_etapa_ejecucion,id_persona
HAVING  COUNT   (id_etapa_ejecucion_responsable) >1

select * from pro.proceso_etapa_ejecucion2 pu where pu.id_proceso_usuario in (7393)
select * from pro.etapa_ejecucion_responsable2 where id_proceso_etapa_ejecucion = 12154

select * from pro.etapa_ejecucion_responsable where id_etapa_ejecucion_responsable in (3410,
                                                                                       3417


    )

select * from pro.revision_asignaturas where id_revision_asignatura in (873,887,888)

select *from seg.usuarios where usuario = '1205115437'
select *from man.personas where email_institucional ='psuarez@upse.edu.ec'

select * from pro.proceso_vacante where id_proceso_vacante = 70

select * from pro.vacante  where id_vacante = 70

select * from pro.proceso_calendario  where id_proceso_general = 15

select * from pro.proceso_general

select * from aca.distributivo_docente where id_distributivo_docente= 3354


select * from pro.postulacion_vacante where usuario_ing='1205115437'

SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_to_evaluar2](30,17,10,
                                                                                     'REQUISITOS',463,1,'CONCURSOMERITO')

SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_to_evaluar2](30,19,10,
                                                                                     'MERITOSsss',463,2,'CONCURSOMERITO')

select * from pro.proceso_etapa_ejecucion2 pee2
where pee2.id_proceso_usuario in (592,679,724) and pee2.id_proceso_etapa = 5

select --e.descripcion,pee2.id_proceso_etapa,
       eer2.* from pro.proceso_etapa_ejecucion2 pee2
                       inner join pro.proceso_etapa pee on pee2.id_proceso_etapa = pee.id_proceso_etapa
                       inner join pro.etapa_ejecucion_responsable2 eer2  on pee2.id_proceso_etapa_ejecucion = eer2.id_proceso_etapa_ejecucion
                       inner join pro.etapa e on e.id_etapa = pee.id_etapa
where pee2.id_proceso_usuario  in (592,679,724) and pee2.id_proceso_etapa = 2

select * FROM pro.tipo_proceso_estado


select * from aca.tipo_matricula_fecha


select * from [pro].[fn_acta_consolidada_concurso]( 15, 8, 85  )
select err.* from pro.evaluacion_rubrica er
                      inner join pro.evaluacion_requisito err on er.id_evaluacion_rubrica = err.id_evaluacion_rubrica
                      inner join pro.tipo_categorias_evaluacion tce on tce.id_tipo_categoria_evaluacion = err.id_tipo_categoria_evaluacion
                      inner join pro.proceso_requisito pr on pr.id_proceso_requisito = err.id_proceso_requisito
where er.id_evaluacion_rubrica = 10 and err.estado='A'



select * from [pro].[fn_rpt_acta_resultados_finales] ( 30 ,  10 ,  495, 2)
use bd_sga_upse;

select * from cmo.postulacion_vacante

select * from pro.proceso_usuario2

select * from pro.tipo_proceso_estado

select * from pro.tipo_categorias_evaluacion


select --pu.id_proceso_usuario,pu.estado,pu.id_persona,
       d.nombre as Facultad,o.descripcion as carrera,upper(v.asignatura),P.identificacion,upper(concat(p.apellidos,' ',p.nombres)) as postulante
from pro.vacante v
         inner join pro.proceso_vacante pv on v.id_vacante = pv.id_vacante
         inner join pro.proceso_general pg on pg.id_proceso_general = pv.id_proceso_general
         inner join pro.postulacion_vacante pva on pva.id_proceso_vacante = pv.id_proceso_vacante
         inner join pro.proceso_usuario2 pu on pva.id_proceso_usuario = pu.id_proceso_usuario
         inner join man.personas p on p.id = pu.id_persona
         inner join aca.oferta o on o.id_oferta = v.id_oferta
         inner join aca.departamento_oferta dof on dof.id_oferta = o.id_oferta
         inner join man.departamentos d on dof.id_departamento = d.id
where p.estado='AC' and pg.id_proceso_general = 9
order by d.nombre,o.descripcion,v.asignatura,p.apellidos,p.nombres

select v.id_vacante,d.nombre as Facultad,o.descripcion as carrera,v.asignatura,count(p.id) as postulantes
from pro.vacante v
         inner join pro.proceso_vacante pv on v.id_vacante = pv.id_vacante
         inner join pro.proceso_general pg on pg.id_proceso_general = pv.id_proceso_general
         inner join pro.postulacion_vacante pva on pva.id_proceso_vacante = pv.id_proceso_vacante
         inner join pro.proceso_usuario2 pu on pva.id_proceso_usuario = pu.id_proceso_usuario
         inner join man.personas p on p.id = pu.id_persona
         inner join aca.oferta o on o.id_oferta = v.id_oferta
         inner join aca.departamento_oferta dof on dof.id_oferta = o.id_oferta
         inner join man.departamentos d on dof.id_departamento = d.id
where p.estado='AC' and pg.id_proceso_general = 9
group by v.id_vacante,d.nombre,o.descripcion,v.asignatura
having count(p.id)=1
order by d.nombre,o.descripcion,v.asignatura,5



select * from pro.fn_list_postulaciones_concurso_merito_titular
              (27,null,null,37,null,NULL)

select u.id as idUsuario,pu.* from pro.proceso_usuario2 pu
                                       inner join seg.usuarios u on u.persona_id = pu.id_persona

select * from pro.proceso_etapa

-- 75 y 79
select * from seg.roles

--consultas de tablas nuevas
select * from pro.vacante

select * from pro.proceso_vacante

select * from pro.postulacion_vacante

select * from pro.proceso_usuario2

select * from pro.proceso_etapa_ejecucion2

select * from pro.etapa_ejecucion_responsable2

select * from pro.etapa_ejecucion_documento2

select * from pro.etapa_ejecucion_requisito2

select * from pro.etapa_requisito_detalle

select * from  pro.etapa_docente_categoria

select * from pro.tipo_evaluaciones

select * from  pro.etapa_evaluaciones

select * from pro.tipo_categorias_evaluacion

select * from pro.evaluacion_categoria

select * from pro.evaluacion_requisito

select * from pro.requisito_valor

select * from pro.etapa_requisito

select * from pro.proceso_usuario2

select * from pro.proceso_vacante

-- select * from pro.postulacion_vacante
-- 1802300564_27_31_TITULO_CUARTO_NIVEL.pdf
select file_name,count(id_etapa_ejecucion_documento) from pro.etapa_ejecucion_documento2
where estado='A'
group by file_name
having count(id_etapa_ejecucion_documento)>1

-- select * from pro.pro

SELECT * FROM pro.etapa_ejecucion_documento2 WHERE id_etapa_ejecucion_documento IN(

    select  --id_etapa_ejecucion_responsable,id_docente_categoria_evaluacion,
            max(id_etapa_ejecucion_documento)--, count(id_etapa_ejecucion_documento)
    from pro.etapa_ejecucion_documento2
    group by id_etapa_ejecucion_responsable,id_docente_categoria_evaluacion
    having count(id_etapa_ejecucion_documento)>1)



select * from pro.etapa_ejecucion_documento2
where usuario_ing='0927081612'
select  * from pro.tipo_categorias_evaluacion

select * from pro.evaluacion_requisito er where er.id_evaluacion_rubrica in (15,20)

select dce.* from pro.evaluacion_requisito er
         inner join pro.docente_categoria_evaluacion dce on er.id_evaluacion_requisito = dce.id_evaluacion_requisito
         where er.id_evaluacion_rubrica in (20)


select er.* from pro.evaluacion_requisito er
where er.id_evaluacion_rubrica in (20)

select * from pro.etapa_evaluaciones

select * from pro.proceso_requisito


select * from pro.etapa_ejecucion_documento2
where file_name in (select file_name from pro.etapa_ejecucion_documento2
                    where estado='A'
                    group by file_name
                    having count(id_etapa_ejecucion_documento)>1)
  and usuario_ing='0927081612' and id_etapa_ejecucion_responsable <> 708
order by file_name

--287 708
select * from pro.etapa_ejecucion_responsable2 where usuario_ing ='0927081612'

select ru.* from seg.roles_usuarios ru
                     inner join seg.usuarios u on u.id = ru.usuario_id
where u.persona_id = 1261


select * from pro.proceso_usuario2 where usuario_ing='0920071503'
select * from pro.postulacion_vacante where usuario_ing='0920071503'
--1314315068
--1802300564
select * from [pro].[fn_list_all_rubricas_evaluaciones_procesos](27,'MERITOYOPOSICIONTUTILAR',
                                                                 11,10)

select r.nivel as idRol,u.id as idUser,p.id as idPersona,concat(p.apellidos,' ',p.nombres,' - ',UPPER(r.nombre)) as miembroComision from pro.proceso_etapa_ejecucion2 pee
                                                                                                                                             inner join pro.etapa_ejecucion_responsable2 eer on eer.id_proceso_etapa_ejecucion = pee.id_proceso_etapa_ejecucion
                                                                                                                                             inner join man.personas p on p.id = eer.id_persona
                                                                                                                                             inner join seg.usuarios u on u.persona_id = p.id
                                                                                                                                             inner join seg.roles_usuarios ru on u.id = ru.usuario_id
                                                                                                                                             inner join seg.roles r on r.id = ru.rol_id
where u.estado='AC' and p.estado='AC' and ru.estado='AC' and r.estado='AC' and pee.id_proceso_etapa = 40
  and (pee.id_proceso_usuario = 198 or pee.id_proceso_usuario is null) and
    r.codigo in ('RECTOR','VICERRECTOR','SECRETARIO','PROFESOREVALUADOR1','PROFESOREVALUADOR2','DELEGADOUPSE','ADMINCMO')
group by  r.nivel,u.id,p.id,p.apellidos,p.nombres,r.nombre
order by r.nivel


exec [pro].[sp_generate_tracking_concurso_merito_oposicion] 27,null,null,null,null,
     null,null,'2400254286',40,0,null
--
-- exec [pro].[sp_generate_responsables_concurso_merito_oposicion] 27,null,null,null,
-- null,null,'2400254286',38,1,null
--
-- exec [pro].[sp_generate_responsables_concurso_merito_oposicion] 27,null,null,null,
-- null,null,'2400254286',39,1,null

select * from [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion](27,11,7,
                                                                         198,39)

select * from [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_to_evaluar](27,10,7,
                                                                                    'REQUISITOS',198,39)

select * from [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_evaluadores](27,11,7,
                                                                                     'REQUISITOSSS',332,40,14632)

select * from [pro].[fn_rpt_rubricas_evaluaciones_etapa] (27,11,1,
                                                          'REQUISITOS',2,40,'ACTANOCUMPLIMIENTO')

select * from [pro].[fn_rpt_rubricas_evaluaciones_etapa] (27,10,7,
                                                          'REQUISITOS',230,39,'ACTANOCUMPLIMIENTO')


select * from [pro].[fn_rpt_rubricas_evaluaciones_etapa] (27,11,7,
                                                          'REQUISITOSss',332,40,'ACTANOCUMPLIMIENTOss')


select * from pro.fn_list_postulaciones_concurso_merito_titular
              (27,null,null,null,null,NULL)

select  [pro].[fn_sca_get_date_revision] (39,132)

--listas la rubrica completa
select * from [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_to_evaluar](27,10,7,
                                                                                    null,198,39)

--4 RUBRICA DE CLASE DEMOSTRATIVA - PRESENCIAL

-- 16		PLANIFICACION	PLANIFICACIÓN
-- 17		EJECUCIONCLASE	EJECUCIÓN DE LA CLASE

SELECT * FROM pro.evaluacion_requisito
-- 51 CLASE DEMOSTRATIVA - SELECCIÓN ALEATORIA DE TEMA DE SILABO EN PRESENCIA DEL POSTULANTE
select * from [pro].[fn_list_evaluaciones_by_process](9,7,null)

select --r.id,u.id,p.id,p.nombres,p.apellidos,p.identificacion,
       r.* from man.personas p
                    inner join seg.usuarios u on u.persona_id = p.id
                    inner join seg.roles_usuarios ru on u.id = ru.usuario_id
                    inner join seg.roles r on r.id = ru.rol_id
where
    r.codigo in ('RECTOR','VICERRECTOR','SECRETARIO','PROFESOREVALUADOR1','PROFESOREVALUADOR2','DELEGADOUPSE','ADMINCMO')

select * from [pro].[fn_rpt_rubricas_evaluaciones_etapa] (27,11,7,
                                                          'REQUISITOSss',80,40,'ACTANOCUMPLIMIENTOss')


select * from [pro].[fn_rpt_rubricas_evaluaciones_etapa_notificar] (27,11,
                                                                    'REQUISITOSss',332,40)

select * from [pro].[fn_list_postulaciones_concurso_merito_titular](27,null,null,
                                                                    null,null,null,null) as d
where d.postulante like '%pincay%'

select * from [pro].[fn_list_postulaciones_concurso_merito_titular](96,null,null,
                                                                    null,null,null,null) as d



select * from [pro].[fn_list_all_rubricas_evaluaciones_procesos]
              (27,'MERITOYOPOSICIONTUTILAR',14,null) as d

select * from pro.fn_list_all_rubricas_evaluaciones_by_clasificacion_evaluadores(27,14,1,
                                                                                 null,187,46,2333)

select * from [pro].[fn_rpt_rubricas_evaluaciones_etapa_notificar] (27,10,
                                                                    'REQUISITOS',198,39)

select * from [pro].[fn_rpt_rubricas_evaluaciones_etapa] (27,11,1,
                                                          'REQUISITOS',2,40,'ACTANOCUMPLIMIENTO')

select * from [pro].[fn_rpt_rubricas_evaluaciones_etapa_oposicion](27,14,7,198,46)

select [pro].[fn_sca_get_date_revision](46,198)

select * from pro.fn_list_postulaciones_concurso_merito_titular (27,null,null,null,null,null,null)

select * from  [pro].[fn_list_all_rubricas_evaluaciones_procesos]
               (27,'MERITOYOPOSICIONTUTILAR',14,null) as d

SELECT * FROM [pro].[fn_rpt_rubricas_evaluaciones_by_parameter](27,12,1,2,44)

SELECT * FROM [pro].[fn_rpt_rubricas_evaluaciones_by_parameter](27,15,1,2,47)




select d.nombre,o.descripcion,prv.id_proceso_vacante,upper(v.asignatura) as asignatura from pro.proceso_vacante prv
                                                                                                inner join pro.vacante v on v.id_vacante = prv.id_vacante
                                                                                                inner join aca.oferta o on o.id_oferta = v.id_oferta
                                                                                                inner join aca.departamento_oferta dof on dof.id_oferta = o.id_oferta
                                                                                                inner join man.departamentos d on dof.id_departamento = d.id
where v.estado='A' --and v.id_docente_categoria = 1
order by  d.nombre,o.descripcion,v.asignatura


SELECT * FROM [pro].[fn_rpt_rubricas_evaluaciones_by_parameter](27,12, 7 , 332 ,44)
select d.idProcesoEtapa,d.idProcesoCalendario,d.idEtapaEvaluacion,d.tipoEvaluacion
from [pro].[fn_list_evaluaciones_by_process](9, 1, null) as d

SELECT * FROM [pro].[fn_rpt_rubricas_evaluaciones_by_parameter](27,12, 7, 332 ,44)

SELECT * FROM pro.fn_list_all_responsables_by_etapa_proceso_rpt_firmas( 44, 332) as d

select * from aca.tipo_estado_estudiante

select eer.* from pro.proceso_etapa_ejecucion2 pee
                      inner join pro.etapa_ejecucion_responsable2 eer on eer.id_proceso_etapa_ejecucion = pee.id_proceso_etapa_ejecucion
                      inner join pro.proceso_usuario2 pu on pu.id_proceso_usuario = pee.id_proceso_usuario
                      inner join pro.postulacion_vacante pv on pv.id_proceso_usuario = pu.id_proceso_usuario
                      inner join pro.proceso_vacante prv on prv.id_proceso_vacante = pv.id_proceso_vacante
where pee.id_proceso_etapa not in (40) and eer.id_persona in (
    292
    )
  and prv.id_proceso_vacante in (20,22,23,19,21)
-- and eer.rol is null

select p.id from man.personas p where p.id>= 35298 and p.id<=35308

select p.id from man.personas p where p.id>= 35309 and p.id<=35319
-- DELEGADO(A) VICERRECTOR

select eer.* from pro.proceso_etapa_ejecucion2 pee
                      inner join pro.etapa_ejecucion_responsable2 eer on eer.id_proceso_etapa_ejecucion = pee.id_proceso_etapa_ejecucion
                      inner join pro.proceso_usuario2 pu on pu.id_proceso_usuario = pee.id_proceso_usuario
                      inner join pro.postulacion_vacante pv on pv.id_proceso_usuario = pu.id_proceso_usuario
                      inner join pro.proceso_vacante prv on prv.id_proceso_vacante = pv.id_proceso_vacante
where pee.id_proceso_etapa not in (40) and eer.id_persona in (
    1108
    )
  and prv.id_proceso_vacante in (20,22,23,19,21)

-- 1135	0901836361	PANCHANA SUAREZ	NICOLASA GENOVEVA
-- 1159	0911289403	TAPIA BLACIO	ANA MARIA
-- 26	0918883950	CORONEL ORTIZ	VICTOR MANUEL
-- 35333	111111111112	PUGA BARZOLA	CARLOS
-- 35334	111111111113	GÓMEZ VILLALBA	DANIEL ALEJANDRO

select ru.* from  seg.usuarios u
                      inner join seg.roles_usuarios ru on ru.usuario_id = u.id
where u.persona_id = 26

select eer.* from pro.proceso_etapa_ejecucion2 pee
                      inner join pro.etapa_ejecucion_responsable2 eer on eer.id_proceso_etapa_ejecucion = pee.id_proceso_etapa_ejecucion
                      inner join pro.proceso_usuario2 pu on pu.id_proceso_usuario = pee.id_proceso_usuario
                      inner join pro.postulacion_vacante pv on pv.id_proceso_usuario = pu.id_proceso_usuario
                      inner join pro.proceso_vacante prv on prv.id_proceso_vacante = pv.id_proceso_vacante
where pee.id_proceso_etapa not in (38,39,40) and eer.id_persona in (35334)
  and prv.id_proceso_vacante in (24,25,26)

select id,identificacion,apellidos,nombres,titulo_prefijo,titulo_sufijo from man.personas where identificacion in ('111111111112','111111111113','0901836361','0918883950','0911289403')



--listar cronograma de clase demostrativa
select distinct d.descripcion,d.asignatura,d.identificacion,d.postulante,vce.lugar,pe.fecha_cronograma,pe.hora_inicio,pe.hora_fin from (
        select d.nombre,o.descripcion,UPPER(v.asignatura)as  asignatura,p.identificacion,UPPER(concat(p.apellidos,' ',p.nombres)) as postulante,
        isnull([pro].[fn_sca_get_calificacion_by_evaluacion](40,pu.id_proceso_usuario),0) as calificacion,pu.id_proceso_usuario,prv.id_proceso_vacante
        from pro.proceso_usuario2 pu
        inner join pro.tipo_proceso_estado tpe on pu.id_tipo_proceso_estado = tpe.id_tipo_proceso_estado
        inner join man.personas p on p.id = pu.id_persona
        inner join pro.postulacion_vacante pv on pv.id_proceso_usuario = pu.id_proceso_usuario
        inner join pro.proceso_vacante prv on prv.id_proceso_vacante = pv.id_proceso_vacante
        inner join pro.vacante v on v.id_vacante = prv.id_vacante
        inner join aca.oferta o on o.id_oferta = v.id_oferta
        inner join aca.departamento_oferta dof on dof.id_oferta = o.id_oferta
        inner join man.departamentos d on dof.id_departamento = d.id
        inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario and pej.id_proceso_etapa = 39
        inner join pro.proceso_etapa_ejecucion2 pejjj on pejjj.id_proceso_usuario = pu.id_proceso_usuario and pejjj.id_proceso_etapa = 40 and pejjj.calificacion is not null
        where  pu.estado='A' and pv.estado='A' and prv.estado='A' and v.estado='A' and pej.estado='A' --AND P.identificacion ='1756915615'
        group by d.nombre,o.descripcion,v.asignatura,p.identificacion,p.apellidos,p.nombres,pej.id_proceso_etapa_ejecucion,pu.id_proceso_usuario,v.id_docente_categoria
        ,prv.id_proceso_vacante
        -- order by d.nombre,o.descripcion,v.asignatura,p.apellidos,p.nombres
        ) as d
        inner join pro.proceso_etapa_ejecucion2 pe on pe.id_proceso_usuario = d.id_proceso_usuario
        inner join pro.vacante_cronograma_etapa vce on vce.id_proceso_etapa = pe.id_proceso_etapa and vce.id_proceso_vacante = d.id_proceso_vacante
        where pe.id_proceso_etapa = 46 and pe.fecha_cronograma = cast(getdate() as date)
order by pe.fecha_cronograma,pe.hora_inicio,pe.hora_fin


SELECT * FROM pro.fn_list_all_responsables_by_etapa_proceso_rpt_firmas( 46 , 53) as d

select * from [pro].[fn_rpt_rubricas_evaluaciones_etapa_oposicion] (
        27 , 14 ,  7 ,  53  , 46
              )


select * from pro.postulacion_vacante
where id_proceso_usuario = 283

select * from man.personas p
where p.identificacion='0962574562'

SELECT * FROM pro.fn_list_all_responsables_by_etapa_proceso(40,332)


-- select p.* from man.personas p
-- inner join seg.usuarios u on p.id = u.persona_id
-- where p.identificacion ='0802990838'
--reporte final con notas calculadas
select
--     pee.*
d.nombre,d.descripcion,d.asignatura,d.categoriaDocente,d.identificacion,d.postulante,d.email,d.calificacionMerito,
d.calificacionPruebaOral,d.calificacionPruebaEscrita,
cast(iif(d.id_docente_categoria=1, d.calificacionClaseDemostrativa*10/100,d.calificacionClaseDemostrativa*20/100) as numeric(7,2)) as calificacionClaseDemostrativaa,
d.calificacionExposicionProyecto as calificacionExposicionProyectoInvestigacion,
d.calificacionMerito+d.calificacionPruebaOral+d.calificacionPruebaEscrita+cast(iif(d.id_docente_categoria=1, d.calificacionClaseDemostrativa*10/100,d.calificacionClaseDemostrativa*20/100)as numeric(7,2))+
d.calificacionExposicionProyecto as totalConcurso
from (
         select d.nombre,o.descripcion,UPPER(v.asignatura)as  asignatura,dc.descripcion as categoriaDocente,p.id,p.identificacion,UPPER(concat(p.apellidos,' ',p.nombres)) as postulante,
                pu.id_proceso_usuario,iif(p.email_institucional is null or p.email_institucional='',email_personal,email_institucional) as email,v.id_docente_categoria,
                iif(isnull([pro].[fn_sca_get_calificacion_by_evaluacion](40,pu.id_proceso_usuario),0)>=50,50
                    ,isnull([pro].[fn_sca_get_calificacion_by_evaluacion](40,pu.id_proceso_usuario),0)) as calificacionMerito,
                isnull([pro].[fn_sca_get_calificacion_by_evaluacion](45,pu.id_proceso_usuario),0) as calificacionPruebaEscrita,
                isnull([pro].[fn_sca_get_calificacion_by_evaluacion](44,pu.id_proceso_usuario),0) as calificacionPruebaOral,
                isnull([pro].[fn_sca_get_calificacion_by_evaluacion](46,pu.id_proceso_usuario),0) as calificacionClaseDemostrativa,
                isnull([pro].[fn_sca_get_calificacion_by_evaluacion](47,pu.id_proceso_usuario),0) as calificacionExposicionProyecto
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
                  inner join pro.proceso_etapa_ejecucion2 pejMerito on pejMerito.id_proceso_usuario = pu.id_proceso_usuario and pejMerito.estado='A' and pejMerito.id_proceso_etapa = 40
             and pejMerito.calificacion is not null
         where  pu.estado='A' and pv.estado='A' and prv.estado='A' and v.estado='A'  --AND P.identificacion ='0802990838'
           and pejMerito.calificacion>=35
         group by d.nombre,o.descripcion,v.asignatura,p.id,p.identificacion,p.apellidos,p.nombres,pu.id_proceso_usuario,v.id_docente_categoria,tpe.codigo
                ,pejMerito.id_proceso_etapa_ejecucion,p.email_institucional,email_personal,dc.descripcion
-- order by d.nombre,o.descripcion,v.asignatura,p.apellidos,p.nombres
     ) as d
         inner join pro.proceso_etapa_ejecucion2 pee on pee.id_proceso_usuario = d.id_proceso_usuario
where pee.id_proceso_etapa = 45
-- d.calificacion>=35
--     d.codigo <>d.merito
-- and
order by d.nombre,d.descripcion,d.asignatura,d.postulante

select d.idEtapaEvaluacion,d.idProcesoEtapa,d.idProcesoCalendario,d.tipoEvaluacion
from [pro].[fn_list_evaluaciones_by_process](9,1,null) as d
--reporte final con notas grabadas
-- update pee
--     set pee.calificacion = d.calificacionExposicionProyecto
select
--     pee.*
d.nombre,d.descripcion,d.asignatura,d.categoriaDocente,d.identificacion,d.id_proceso_usuario,d.postulante,d.email,d.calificacionMerito,
d.calificacionPruebaOral,d.calificacionPruebaEscrita,
cast(iif(d.id_docente_categoria=1, d.calificacionClaseDemostrativa*10/100,d.calificacionClaseDemostrativa*20/100) as numeric(7,2)) as calificacionClaseDemostrativaa,
d.calificacionExposicionProyecto as calificacionExposicionProyectoInvestigacion,
d.calificacionMerito+d.calificacionPruebaOral+d.calificacionPruebaEscrita+cast(iif(d.id_docente_categoria=1, d.calificacionClaseDemostrativa*10/100,d.calificacionClaseDemostrativa*20/100)as numeric(7,2))+
d.calificacionExposicionProyecto as totalConcurso
from (
         select d.nombre,o.descripcion,UPPER(v.asignatura)as  asignatura,dc.descripcion as categoriaDocente,p.id,p.identificacion,UPPER(concat(p.apellidos,' ',p.nombres)) as postulante,
                pu.id_proceso_usuario,iif(p.email_institucional is null or p.email_institucional='',email_personal,email_institucional) as email,v.id_docente_categoria,
                iif(isnull(pee2.calificacion,0)>=50,50,isnull(pee2.calificacion,0)) as calificacionMerito,
                isnull((select peep.calificacion from pro.proceso_etapa_ejecucion2 peep where peep.id_proceso_etapa =1 and peep.id_proceso_usuario=pu.id_proceso_usuario),0) as calificacionPruebaEscrita,
                isnull((select peep.calificacion from pro.proceso_etapa_ejecucion2 peep where peep.id_proceso_etapa =2 and peep.id_proceso_usuario=pu.id_proceso_usuario),0) as calificacionPruebaOral,
                isnull((select peep.calificacion from pro.proceso_etapa_ejecucion2 peep where peep.id_proceso_etapa =46 and peep.id_proceso_usuario=pu.id_proceso_usuario),0) as calificacionClaseDemostrativa,
                isnull((select peep.calificacion from pro.proceso_etapa_ejecucion2 peep where peep.id_proceso_etapa =47 and peep.id_proceso_usuario=pu.id_proceso_usuario),0) as calificacionExposicionProyecto
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
         where  pu.estado='A' and pv.estado='A' and prv.estado='A' and v.estado='A'  --AND P.identificacion ='0802990838'
           and pee2.estado='A' and pee2.id_proceso_etapa = 2 --and pee2.calificacion is not null and pee2.calificacion>=35
           and pu.id_proceso_general = 15
         group by d.nombre,o.descripcion,v.asignatura,p.id,p.identificacion,p.apellidos,p.nombres,pu.id_proceso_usuario,v.id_docente_categoria,tpe.codigo,
                  pee2.id_proceso_etapa_ejecucion,p.email_institucional,email_personal,dc.descripcion,pee2.calificacion
-- order by d.nombre,o.descripcion,v.asignatura,p.apellidos,p.nombres
     ) as d
-- inner join pro.proceso_etapa_ejecucion2 pee on pee.id_proceso_usuario = d.id_proceso_usuario
-- where pee.id_proceso_etapa = 47
--     d.codigo <>d.merito
-- and
order by d.nombre,d.descripcion,d.asignatura,d.postulante




select * from pro.etapa_evaluaciones

select * from pro.evaluaciones_docente_categoria
--LISTADO FINAL DE POSTULANTES
select
    d.id_proceso_usuario,d.nombre,d.descripcion,d.asignatura,d.categoriaDocente,d.identificacion,d.postulante,d.email,d.celular,
    iif(d.calificacionInpugnacionMerito>0,d.calificacionInpugnacionMerito,d.calificacionMerito) as calificacionMerito,
    d.calificacionPruebaOral,d.calificacionPruebaEscrita,
    cast(iif(d.id_docente_categoria=1, d.calificacionClaseDemostrativa*10/100,d.calificacionClaseDemostrativa*20/100) as numeric(7,2)) as calificacionClaseDemostrativaa,
    d.calificacionExposicionProyecto as calificacionExposicionProyectoInvestigacion,
    d.calificacionPruebaOral+d.calificacionPruebaEscrita+cast(iif(d.id_docente_categoria=1, d.calificacionClaseDemostrativa*10/100,d.calificacionClaseDemostrativa*20/100)as numeric(7,2))+
    d.calificacionExposicionProyecto as totalOposicion,
    iif(d.calificacionInpugnacionMerito>0,d.calificacionInpugnacionMerito,d.calificacionMerito)+d.calificacionPruebaOral+d.calificacionPruebaEscrita+cast(iif(d.id_docente_categoria=1, d.calificacionClaseDemostrativa*10/100,d.calificacionClaseDemostrativa*20/100)as numeric(7,2))+
    d.calificacionExposicionProyecto as totalConcurso
from (
         select d.nombre,o.descripcion,UPPER(v.asignatura)as  asignatura,dc.descripcion as categoriaDocente,p.id,p.identificacion,UPPER(concat(p.apellidos,' ',p.nombres)) as postulante,
                pu.id_proceso_usuario,iif(p.email_institucional is null or p.email_institucional='',email_personal,email_institucional) as email,p.celular,v.id_docente_categoria,
                iif(isnull(pee2.calificacion,0)>=50,50,isnull(pee2.calificacion,0)) as calificacionMerito,
                isnull((select peep.calificacion from pro.proceso_etapa_ejecucion2 peep where peep.id_proceso_etapa =45 and peep.id_proceso_usuario=pu.id_proceso_usuario),0) as calificacionPruebaEscrita,
                isnull((select peep.calificacion from pro.proceso_etapa_ejecucion2 peep where peep.id_proceso_etapa =44 and peep.id_proceso_usuario=pu.id_proceso_usuario),0) as calificacionPruebaOral,
                isnull((select peep.calificacion from pro.proceso_etapa_ejecucion2 peep where peep.id_proceso_etapa =46 and peep.id_proceso_usuario=pu.id_proceso_usuario),0) as calificacionClaseDemostrativa,
                isnull((select peep.calificacion from pro.proceso_etapa_ejecucion2 peep where peep.id_proceso_etapa =47 and peep.id_proceso_usuario=pu.id_proceso_usuario),0) as calificacionExposicionProyecto,
                isnull((select peep.calificacion from pro.proceso_etapa_ejecucion2 peep where peep.id_proceso_etapa =42 and peep.id_proceso_usuario=pu.id_proceso_usuario),0) as calificacionInpugnacionMerito
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
         where  pu.estado='A' and pv.estado='A' and prv.estado='A' and v.estado='A'  --AND P.identificacion ='0802990838'
           and pee2.estado='A' and pee2.id_proceso_etapa = 40 and pee2.calificacion is not null and pee2.calificacion>=35
         group by d.nombre,o.descripcion,v.asignatura,p.id,p.identificacion,p.apellidos,p.nombres,pu.id_proceso_usuario,v.id_docente_categoria,tpe.codigo,
                  pee2.id_proceso_etapa_ejecucion,p.email_institucional,email_personal,dc.descripcion,pee2.calificacion,p.celular
-- order by d.nombre,o.descripcion,v.asignatura,p.apellidos,p.nombres
     ) as d
-- inner join pro.proceso_etapa_ejecucion2 pee on pee.id_proceso_usuario = d.id_proceso_usuario
-- where pee.id_proceso_etapa = 47
--     d.codigo <>d.merito
-- and
order by d.nombre,d.descripcion,d.asignatura,d.postulante

select * from pro.proceso_usuario2

select * from  pro.fn_list_evaluaciones_by_process(9,1,null) AS d

--listado de rubricas consolidado
select
--     pee.*
    d.nombre,d.descripcion,d.asignatura,d.categoriaDocente,d.identificacion,d.postulante,d.email,d.celular,d.calificacion as calificacionReal,
    iif(isnull(d.calificacion,0)>=d.puntaje_maximo,d.puntaje_maximo,isnull(d.calificacion,0)) as calificacionLimitada
        ,cast(iif(isnull(d.calificacion,0)>=d.puntaje_maximo,d.puntaje_maximo,isnull(d.calificacion,0))*d.ponderacion/d.puntaje_maximo as numeric(7,2)) as calificacionPonderada,d.tipoEvaluacion,d.ponderacion,d.puntaje_maximo
from (
         select d.nombre,o.descripcion,UPPER(v.asignatura)as  asignatura,dc.descripcion as categoriaDocente,p.id,p.identificacion,UPPER(concat(p.apellidos,' ',p.nombres)) as postulante,
                pu.id_proceso_usuario,iif(p.email_institucional is null or p.email_institucional='',email_personal,email_institucional) as email,p.celular,v.id_docente_categoria,
                isnull(pee2.calificacion,0) as calificacion,evdc.ponderacion,evdc.puntaje_maximo,te.descripcion as tipoEvaluacion
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
                  inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pee2.id_proceso_etapa and pc.id_proceso_general = pu.id_proceso_general
                  inner join pro.etapa_docente_categoria edc on edc.id_proceso_calendario = pc.id_proceso_calendario and dc.id_docente_categoria = edc.id_docente_categoria
                  inner join pro.etapa_evaluaciones ee on ee.id_proceso_calendario = pc.id_proceso_calendario
                  inner join pro.evaluaciones_docente_categoria evdc on evdc.id_docente_categoria = edc.id_docente_categoria and ee.id_etapa_evaluacion = evdc.id_etapa_evaluacion
                  inner join pro.evaluacion_rubrica eru on ee.id_evaluacion_rubrica = eru.id_evaluacion_rubrica
                  inner join pro.tipo_evaluaciones te on te.id_tipo_evaluacion = eru.id_tipo_evaluacion
         where  pu.estado='A' and pv.estado='A' and prv.estado='A' and v.estado='A'  --AND P.identificacion ='0802990838'
           and pee2.estado='A' --and pee2.id_proceso_etapa = 40 and pee2.calificacion is not null --and pee2.calificacion>=35
         group by d.nombre,o.descripcion,v.asignatura,p.id,p.identificacion,p.apellidos,p.nombres,pu.id_proceso_usuario,v.id_docente_categoria,tpe.codigo,
                  pee2.id_proceso_etapa_ejecucion,p.email_institucional,email_personal,dc.descripcion,pee2.calificacion,p.celular,evdc.ponderacion,evdc.puntaje_maximo,te.descripcion
-- order by d.nombre,o.descripcion,v.asignatura,p.apellidos,p.nombres
     ) as d
-- where d.id_proceso_usuario = 198
-- inner join pro.proceso_etapa_ejecucion2 pee on pee.id_proceso_usuario = d.id_proceso_usuario
-- where pee.id_proceso_etapa = 47
--     d.codigo <>d.merito
-- and
order by d.nombre,d.descripcion,d.asignatura,d.postulante



select * from pro.proceso_etapa_ejecucion2 where id_proceso_etapa = 46

select * from pro.vacante_cronograma_etapa where id_proceso_etapa = 46 and id_proceso_vacante = 37


select * from pro.proceso_usuario2 where id_proceso_usuario= 2

select d.id as idDepartamento,o.id_oferta as idOferta,v.id_docente_categoria as idCategoriaDocente,prv.id_proceso_vacante,v.asignatura from pro.proceso_etapa_ejecucion2 pee
inner join pro.etapa_ejecucion_responsable2 eer on eer.id_proceso_etapa_ejecucion = pee.id_proceso_etapa_ejecucion
inner join seg.usuarios u on u.persona_id = eer.id_persona
inner join pro.proceso_usuario2 pu on pu.id_proceso_usuario = pee.id_proceso_usuario
inner join pro.postulacion_vacante pv on pv.id_proceso_usuario = pu.id_proceso_usuario
inner join pro.proceso_vacante prv on prv.id_proceso_vacante = pv.id_proceso_vacante
inner join pro.vacante v on v.id_vacante = prv.id_vacante
inner join aca.oferta o on o.id_oferta = v.id_oferta
inner join aca.departamento_oferta do on do.id_oferta = v.id_oferta
inner join man.departamentos d on d.id = do.id_departamento
where pee.id_proceso_etapa = 2
group by d.id,o.id_oferta,v.id_docente_categoria,v.asignatura,prv.id_proceso_vacante


--se va a notofocar a 76  6 manes no tenian nada en oposicion
select * from  [pro].[fn_list_postulantes_to_notificate_CMO](9)

select p.descripcion,pe.id_proceso_etapa,e.descripcion from pro.proceso p
                                                                inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
                                                                inner join pro.etapa e on e.id_etapa = pe.id_etapa
where p.id_proceso =9


select d.*--d.idProcesoUsuario,d.id,d.postulante
from [pro].[fn_list_postulaciones_concurso_merito_titular](27,null,null,
                                                           null,null,null,null) as d
where d.idProcesoUsuario = 198
--     d.postulante in ('LOPEZ PUMALEMA JOSE ISRAEL','ENCALADA ENCARNACIÓN VICENTE RENÉ','CARMONA BANDERAS NORMA CARMEN','GARCÍA MORALES JAVIER ANTONIO','ECHEVERRÍA MAGGI DAVID XAVIER',
--                       'NAVAS MONTES YONAIKER DEL MAR','SANTOS HOLGUIN SONNIA APOLONIA')

select * from pro.proceso_etapa_ejecucion2 pee2
where pee2.id_proceso_etapa = 44 and notificado_correo = 1

select * from pro.proceso_general

--listar manes que pasaron a meritos
select
--     pee.*
d.nombre,d.descripcion,d.asignatura,d.categoriaDocente,d.identificacion,d.postulante,d.email,d.celular,d.calificacion as calificacionReal,
iif(isnull(d.calificacion,0)>=d.puntaje_maximo,d.puntaje_maximo,isnull(d.calificacion,0)) as calificacionLimitada
from (
         select d.nombre,o.descripcion,UPPER(v.asignatura)as  asignatura,dc.descripcion as categoriaDocente,p.id,p.identificacion,UPPER(concat(p.apellidos,' ',p.nombres)) as postulante,
                pu.id_proceso_usuario,iif(p.email_institucional is null or p.email_institucional='',email_personal,email_institucional) as email,p.celular,v.id_docente_categoria,
                isnull(pee2.calificacion,0) as calificacion,evdc.ponderacion,evdc.puntaje_maximo,te.descripcion as tipoEvaluacion
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
                  inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pee2.id_proceso_etapa and pc.id_proceso_general = pu.id_proceso_general
                  inner join pro.etapa_docente_categoria edc on edc.id_proceso_calendario = pc.id_proceso_calendario and dc.id_docente_categoria = edc.id_docente_categoria
                  inner join pro.etapa_evaluaciones ee on ee.id_proceso_calendario = pc.id_proceso_calendario
                  inner join pro.evaluaciones_docente_categoria evdc on evdc.id_docente_categoria = edc.id_docente_categoria and ee.id_etapa_evaluacion = evdc.id_etapa_evaluacion
                  inner join pro.evaluacion_rubrica eru on ee.id_evaluacion_rubrica = eru.id_evaluacion_rubrica
                  inner join pro.tipo_evaluaciones te on te.id_tipo_evaluacion = eru.id_tipo_evaluacion
         where  --pu.estado='A' and
             pv.estado='A' and prv.estado='A' and v.estado='A'  --AND P.identificacion ='0802990838'
           and pee2.estado='A' and pee2.id_proceso_etapa = 40 and pee2.calificacion is not null
           and pu.id_proceso_general = 15
         group by d.nombre,o.descripcion,v.asignatura,p.id,p.identificacion,p.apellidos,p.nombres,pu.id_proceso_usuario,v.id_docente_categoria,tpe.codigo,
                  pee2.id_proceso_etapa_ejecucion,p.email_institucional,email_personal,dc.descripcion,pee2.calificacion,p.celular,evdc.ponderacion,evdc.puntaje_maximo,te.descripcion
-- order by d.nombre,o.descripcion,v.asignatura,p.apellidos,p.nombres
     ) as d
-- where d.id_proceso_usuario = 198
-- inner join pro.proceso_etapa_ejecucion2 pee on pee.id_proceso_usuario = d.id_proceso_usuario
-- where pee.id_proceso_etapa = 47
--     d.codigo <>d.merito
-- and
order by d.nombre,d.descripcion,d.asignatura,d.postulante

select * from pro.tipo_proceso

select * from pro.proceso_calendario

select * from pro.proceso_etapa_ejecucion2 where id_proceso_etapa = 44

select * from [pro].[fn_rpt_rubricas_evaluaciones_etapa_oposicion] (27 ,13 , 7 ,  198,45)


select d.idProcesoCalendario,d.idEtapaEvaluacion,d.idProcesoEtapa,d.tipoEvaluacion
from  pro.fn_list_evaluaciones_by_process(9,1,null) AS d

select * from [pro].[fn_list_all_rubricas_evaluaciones_procesos]
              (27,'MERITOYOPOSICIONTUTILAR',13,null) as d

select * from pro.proceso_usuario2 where usuario_ing='0910314293'


select * from [pro].[fn_list_evaluaciones_by_process_and_proceso_usuario](198)

SELECT * FROM pro.fn_list_all_responsables_by_etapa_proceso_rpt_firmas( 40, 198) as d

-- update eer2 set eer2.orden=5, eer2.rol ='PROFESOR(A) EXTERNO 2' from pro.proceso_etapa_ejecucion2 pee2
-- inner join pro.etapa_ejecucion_responsable2 eer2 on pee2.id_proceso_etapa_ejecucion = eer2.id_proceso_etapa_ejecucion
-- where pee2.id_proceso_etapa = 40 and eer2.id_persona=35075

select eer2.* from pro.proceso_etapa_ejecucion2 pee2
                       inner join pro.etapa_ejecucion_responsable2 eer2 on pee2.id_proceso_etapa_ejecucion = eer2.id_proceso_etapa_ejecucion
where pee2.id_proceso_etapa = 40 and eer2.id_persona=35075

select * from [pro].[fn_rpt_rubricas_evaluaciones_etapa_prueba_escrita](27,13,7,198,45)


select * from [pro].[fn_get_all_calificaciones_by_etapa_evaluacion](27,398,null,7)
select * from [pro].[fn_get_all_calificaciones_by_etapa_evaluacion](96,8221,'FASEMERITOS',1)
select * from [pro].[fn_get_all_calificaciones_by_etapa_evaluacion](96,8221,'FASEOPOSICION',1)
select * from [pro].[fn_get_all_calificaciones_by_etapa_evaluacion](96,8221,null,7)
select * from [pro].[fn_rpt_acta_resultados_finales](27,7,8221)
select * from pro.proceso_etapa_ejecucion2 where id_proceso_usuario = 8221

 select [pro].[fn_sca_get_calificacion_by_evaluacion](40,8221)

select eer.*
from pro.etapa_ejecucion_responsable2 ejr
         inner join pro.etapa_ejecucion_requisito2 eer on eer.id_etapa_ejecucion_responsable = ejr.id_etapa_ejecucion_responsable
         inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_etapa_ejecucion = ejr.id_proceso_etapa_ejecucion and pej.id_proceso_etapa = 40
where pej.id_proceso_usuario = 8221 and ejr.estado='A' and eer.estado='A' and pej.estado='A'
-- group by eer.id_proceso_requisito,eer.id_docente_categoria_evaluacion, eer.calificacion

select * from pro.etapa_ejecucion_requisito2 where usuario_ing ='2400254286'


select * from     pro.fn_list_evaluaciones_by_process(87,1,null) AS d


            select d.idProcesoEtapa,d.idEtapaEvaluacion,d.tipoEvaluacion,iif(pu.id_persona in (33701,33920,34715,34478) and pee.id_proceso_etapa = 46
            ,'NO APLICA',cast(pee.fecha_cronograma as varchar(25))) as fecha,
            iif(pu.id_persona in (33701,33920,34715,34478) and pee.id_proceso_etapa = 46,'NO APLICA',cast(pee.hora_inicio as varchar(25))) as horaInicio,
            iif(pu.id_persona in (33701,33920,34715,34478) and pee.id_proceso_etapa = 46,'NO APLICA',cast(pee.hora_fin as varchar(25))) as horaFin,
            ISNULL(vc.lugar,iif(pu.id_persona in (33701,33920,34715,34478) and pee.id_proceso_etapa = 46,'NO APLICA',(select top 1 vv.lugar from pro.vacante_cronograma_etapa vv where vv.id_proceso_etapa = 46 and
            vv.id_proceso_vacante=pv.id_proceso_vacante))) as lugar,
            --               cast(iif(isnull(pee.calificacion,0)>=evdc.puntaje_maximo,evdc.puntaje_maximo,isnull(pee.calificacion,0))*evdc.ponderacion/evdc.puntaje_maximo as numeric(7,2)) as calificacion,
            cast(iif(isnull([pro].[fn_sca_get_calificacion_by_evaluacion](pe.id_proceso_etapa,8202), isnull(pee.calificacion, 0))>=evdc.puntaje_maximo,evdc.puntaje_maximo,
            isnull([pro].[fn_sca_get_calificacion_by_evaluacion](pe.id_proceso_etapa,8202), isnull(pee.calificacion, 0)))*evdc.ponderacion/evdc.puntaje_maximo as numeric(7,2)) as calificacion,
            evdc.ponderacion,evdc.puntaje_maximo,e.descripcion as etapa,ee.evaluable
            --               ,(select pe.calificacion from pro.proceso_etapa_ejecucion2 pe where pe.estado='A' and pe.id_proceso_etapa = 42 and pe.id_proceso_usuario=pu.id_proceso_usuario) as impugnacionMerito
            from pro.fn_list_evaluaciones_by_process(87,1,null) AS d
            inner join pro.proceso_etapa_ejecucion2 pee on pee.id_proceso_etapa = d.idProcesoEtapa
            inner join pro.proceso_etapa pe on pe.id_proceso_etapa = pee.id_proceso_etapa
            inner join pro.etapa e on e.id_etapa = pe.id_etapa_padre
            inner join pro.proceso_usuario2 pu on pu.id_proceso_usuario = pee.id_proceso_usuario
            inner join pro.postulacion_vacante pv on pv.id_proceso_usuario = pu.id_proceso_usuario
            inner join pro.proceso_vacante prv on prv.id_proceso_vacante = pv.id_proceso_vacante
            inner join pro.vacante v on v.id_vacante = prv.id_vacante
            left join pro.vacante_cronograma_etapa vc on vc.id_proceso_etapa = pee.id_proceso_etapa and  vc.id_proceso_vacante = pv.id_proceso_vacante
            inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pee.id_proceso_etapa and pc.id_proceso_general = pu.id_proceso_general
            inner join pro.etapa_docente_categoria edc on edc.id_proceso_calendario = pc.id_proceso_calendario and v.id_docente_categoria = edc.id_docente_categoria
            inner join pro.etapa_evaluaciones ee on ee.id_proceso_calendario = pc.id_proceso_calendario
            inner join pro.evaluaciones_docente_categoria evdc on evdc.id_docente_categoria = edc.id_docente_categoria and ee.id_etapa_evaluacion = evdc.id_etapa_evaluacion
            where pee.id_proceso_usuario = 8202 and (e.codigo =null or null is null)
and pee.estado='A' and pu.estado='A'



select d.*--d.idProcesoUsuario,d.id,d.postulante
from [pro].[fn_list_postulaciones_concurso_merito_titular](27,null,null,
                                                           null,null,null,null) as d
where
    d.postulante in ('LOPEZ PUMALEMA JOSE ISRAEL','ENCALADA ENCARNACIÓN VICENTE RENÉ','CARMONA BANDERAS NORMA CARMEN','GARCÍA MORALES JAVIER ANTONIO','ECHEVERRÍA MAGGI DAVID XAVIER',
                     'NAVAS MONTES YONAIKER DEL MAR','SANTOS HOLGUIN SONNIA APOLONIA')
   or d.idProcesoUsuario = 237

select * from aca.contenidos where id_silabo = 1752 and id_contenido_padre is null and estado='A'

update eer2 set eer2.rol='DELEGADO DE LA OCS - UPSE' FROM pro.proceso_etapa_ejecucion2 pee2
                                                              inner join pro.etapa_ejecucion_responsable2 eer2 on pee2.id_proceso_etapa_ejecucion = eer2.id_proceso_etapa_ejecucion
where pee2.id_proceso_etapa = 40 and eer2.id_persona= 1127


select 10 as idDocenteCatgeoria,v.id_docente_dedicacion,v.id_oferta,null as idTituloAcademicoTercerNivel,null as idTituloAcademicoCuartoNivel,
       v.codigo,v.funciones as descripcion,v.funciones as asignatura,v.funciones,v.titulo_tercer_nivel,v.titulo_cuarto_nivel,v.horas_clase,
       v.horas_actividades,v.campo_amplio_conocimiento,v.campo_amplio_conocimiento as campo_detallado_conocimiento,'A',0,v.fecha_ing,v.fecha_mod,v.usuario_ing,v.usuario_mod
from cmo.vacante v
where v.estado='A'





select a.* from aca.malla_asignatura ma
                    inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where ma.id_malla_asignatura in (670,1634)

select *  from [aca].[fn_lista_docente_asignatura_usu3](27,36742)
select *  from [aca].[fn_lista_docente_asignatura_usu2](27,36742)

select o.descripcion,pao.* from aca.periodo_academico_oferta pao
                                    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
                                    inner join aca.oferta o on o.id_oferta = om.id_oferta
where pao.id_periodo_academico = 27 and pao.maximo_creditos >15


exec  [aca].[pa_generar_asignaturas_a_tomar_siia_sisweb] 28433,27,1,664

exec  [aca].[pa_generar_asignaturas_a_tomar_siia_sisweb_pruebas] 29032,27,1,1

select max(ma2.id_nivel) from  aca.estudiante_matricula em2
                                   inner join aca.matricula_general mg2 on mg2.id_matricula_general = em2.id_matricula_general
                                   inner join aca.periodo_academico pa2 on pa2.id_periodo_academico = mg2.id_periodo_academico
                                   inner join aca.estudiante_asignatura ea2 on ea2.id_estudiante_matricula = em2.id_estudiante_matricula
                                   inner join aca.asignatura_aprendizaje aa2 on aa2.id_asignatura_aprendizaje = ea2.id_asignatura_aprendizaje
                                   inner join aca.malla_asignatura ma2 on ma2.id_malla_asignatura = aa2.id_malla_asignatura
where ea2.estado ='A' and em2.estado='A' and ma2.estado='A' and em2.id_estudiante_oferta = 11153
  and mg2.id_periodo_academico = 27






select * from pro.tipo_proceso

select * from seg.roles_usuarios where usuario_id = 1

select * from seg.roles

select * from tut.solicitud_titulacion_estudiante

select * from pro.solicitud_modalidad_titulacion


select * from seg.roles


select * from aca.periodo_academico

select * from aca.periodo

select * from pro.proceso_etapa

select * from pro.proceso_general

select * from [pro].[fn_list_proceso_solicitud_cambio_by_estudiante_resume](2,'SOLICITUDESCAMBIOCARRERA')

select * from pro.proceso_calendario

select * from aca.estudiante_oferta eo where eo.estado='I'
                                         and eo.id_estudiante_oferta between 21540 and 21560

select * from aca.malla




select * from aca.periodo_academico


select * from pro.proceso_usuario

select * from pro.solicitud_modalidad_titulacion

select * from tut.tutor_titulacion

select * from pro.proceso

select * from pro.proceso_general

select * from aca.periodo_academico

select * from [pro].[fn_list_all_categorias_docente_by_process_and_etapa](12,64)


select p.descripcion,pe.id_proceso_etapa,ep.id_etapa,ep.descripcion,e.id_etapa,e.descripcion from pro.proceso p
                                                                                                      inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
                                                                                                      inner join pro.etapa e on e.id_etapa = pe.id_etapa
                                                                                                      left join pro.etapa ep on ep.id_etapa = pe.id_etapa_padre
where p.id_proceso = 2

select * from pro.proceso


select * from pro.proceso_etapa

select * from pro.proceso_calendario where id_proceso_general = 105
select * from pro.proceso_general where id_proceso_general = 105

select * from pro.etapa

select * from pro.etapa_evaluaciones

select * from pro.evaluacion_rubrica
--  DBCC CHECKIDENT ('pro.vacante', RESEED, 114);
select * from pro.vacante

select * from pro.evaluaciones_docente_categoria


select * from pro.vacante_asignatura

select * from pro.proceso_vacante

select * from pro.etapa_docente_categoria


select * from pro.proceso_usuario2

select * from pro.postulacion_vacante

select * from man.personas where identificacion='2400254286'

SELECT * FROM aca.fn_postulacion_docente(31 ,323,'CONCURSOMERITOPOSTGRADO')

select * from [pro].[fn_list_postulaciones_concursos_merito_upse](87,null,null,null,null,null,
                                                                  null)
select * from seg.usuarios where usuario ='2450063298'

select * from seg.roles_usuarios where usuario_id = 8758

select * from seg.roles where id = 98


select * from pro.tipo_proceso


select pao.* from aca.periodo_academico_oferta pao
                      inner join aca.oferta_modalidad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
                      inner join aca.oferta o on o.id_oferta = om.id_oferta
where pao.id_periodo_academico = 30 and pao.estado='A'
order by  pao.id_periodo_academico_oferta

select * from aca.periodo_academico

select o.descripcion,pao.id_oferta_modalidad,pao.puntaje_minimo_admision from aca.periodo_academico_oferta pao
                                                                                  inner join aca.oferta_modalidad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
                                                                                  inner join aca.oferta o on o.id_oferta = om.id_oferta
where pao.id_periodo_academico = 30 and pao.estado='A'
order by  pao.id_periodo_academico_oferta


select * from pro.proceso_calendario where id_proceso_calendario in (99,104)


select * from pro.proceso_usuario


select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Oferta](null,30,null,null)

select * from pro.fn_list_documentos_to_validate_etapa  (2658,11)

select* from pro.etapa_requisito

select * from pro.proceso_calendario

SELECT * FROM PRO.proceso_etapa_ejecucion

select * from man.personas p where p.apellidos like '%Rodriguez Tigrero%'

select * from seg.usuarios where usuario = '1707326813'

SELECT * FROM  [pro].[fn_list_revision_asignatura_by_responsable] (3429)

select * from pro.revision_asignaturas ra
                  inner join pro.etapa_ejecucion_responsable ejr on ejr.id_etapa_ejecucion_responsable = ra.id_etapa_ejecucion_responsable
where id_persona =1088

select * from seg.roles_usuarios where rol_id = 49

select * from pro.proceso_general

select * from seg.roles where codigo ='InscripcionDocente'

select * from pro.vacante

select * from pro.proceso

select * from pro.proceso_vacante

select * from pro.proceso_general where id_proceso = 1

select * from aca.periodo_academico

select e.descripcion,pc.* from pro.proceso_calendario pc
                     inner join pro.proceso_general pg on pg.id_proceso_general = pc.id_proceso_general
                        inner join pro.proceso_etapa pe on pc.id_proceso_etapa = pe.id_proceso_etapa
            inner join pro.etapa e on pe.id_etapa = e.id_etapa
where pg.id_proceso = 1 and pg.id_periodo_academico = 96

select * from pro.proceso

--1 3 8

select * from pro.proceso where id_tipo_proceso = 2

select * from pro.tipo_proceso

select v.* from pro.vacante v
                    inner join pro.proceso_vacante pv on pv.id_vacante = v.id_vacante
where pv.id_proceso_general = 15
-- 3 32 12 10 19 4 14

select * from pro.etapa_docente_categoria




select * from seg.roles

select * from pro.proceso_etapa


select * from pro.proceso_etapa_rol

SELECT * FROM pro.proceso_usuario2

select * from [pro].[fn_list_postulaciones_concursos_merito_upse](27,null,null,null,
                                                                  null,null,null,'MERITOYOPOSICIONTUTILAR')


select * from [pro].[fn_list_postulaciones_concursos_merito_upse](30,null,null,null,
                                                                  null,null,null,'CONCURSOMERITO')

select * from [pro].[fn_list_postulaciones_concursos_merito_upse](31,null,null,null,
                                                                  null,null,null,'CONCURSOMERITOPOSTGRADO')

SELECT * FROM aca.fn_postulacion_docente(30,323,'CONCURSOMERITO')

select * from [pro].[fn_list_postulaciones_concursos_merito_upse](30,null,null,null,
                                                                  null,null,null,'CONCURSOMERITO') as d
where d.identificacion ='1103365548'

select d.facultad,d.carrera,d.asignatura,d.categoriaDocente,d.serie,d.identificacion,d.postulante,d.emailPersonal
from [pro].[fn_list_postulaciones_concursos_merito_upse](30,null,null,null,
                                                         null,null,null,'CONCURSOMERITO') as d
--1 14 33 74
select * from pro.etapa_evaluaciones

select * from pro.evaluacion_rubrica

select * from com.grupo
select * from com.grupo_departamento
where id_grupo =24
SELECT * FROM pro.fn_list_postulaciones_concurso_merito_titular(null,null,null,null,
                                                                null,null,449)

select  * from pro.fn_get_info_user_process(?,?,?,?)

SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion](30,20,10,
                                                                         463,5,'CONCURSOMERITO')

select * from   [pro].[fn_list_all_rubricas_evaluaciones_procesos]
                (30,'CONCURSOMERITO',17,null) as d

SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_evaluadores](30,21,10,
                                                                                     'MERITOSsss',463,5,1,'CONCURSOMERITO')

SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_evaluadores](30,20,10,
                                                                                     'MERITOSsss',482,5,14335,'CONCURSOMERITO')

select * from [pro].[fn_rpt_rubricas_evaluaciones_etapa_oposicion] (
        30, 20,10,463,5
              )

select * from [pro].[fn_rpt_acta_resultados_finales] ( 30,10,463,5 )

select * from pro.proceso_calendario

select * from pro.evaluaciones_docente_categoria

select * from pro.docente_categoria_evaluacion

select * from pro.etapa_ejecucion_requisito2

select * from pro.vacante_cronograma_etapa

select * from aca.modalidad

select * from pro.etapa_evaluaciones


select distinct pej.id_proceso_etapa,vce.* from pro.proceso_usuario2 pu
inner join pro.postulacion_vacante pv on pu.id_proceso_usuario = pv.id_proceso_usuario
inner join pro.proceso_vacante prov on prov.id_proceso_vacante = pv.id_proceso_vacante
inner join pro.proceso_general pg on pg.id_proceso_general = pu.id_proceso_general
inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario
inner join pro.vacante_cronograma_etapa vce on prov.id_proceso_vacante = vce.id_proceso_vacante and vce.id_proceso_etapa = pej.id_proceso_etapa
inner join pro.etapa_ejecucion_responsable2 ejr on ejr.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion
inner join man.personas p on p.id = ejr.id_persona
where pu.estado='A' and pej.estado='A' and ejr.estado='A'
  and pu.id_proceso_usuario = 8256
    and  pej.id_proceso_etapa = 45 --and p.identificacion='0704490531' and ejr.id_etapa_ejecucion_responsable in (19617,19777)

select * from man.personas where identificacion in ('0704286889','0704490531')

select e.descripcion,pe.* from pro.proceso p
                                   inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
                                   inner join pro.etapa e on e.id_etapa = pe.id_etapa
where p.id_proceso = 1

select o.descripcion,om.* from aca.oferta o
                                   inner join aca.oferta_modalidad om on o.id_oferta = om.id_oferta
where id_tipo_oferta =2
--25    59

select * from aca.periodo_academico where id_tipo_oferta = 1

--9 s 884 ms
select * from [pro].[fn_list_all_postulaciones_concursos_merito](105,5,null,10,
                                                                 null,null,null,null,1) as d
exec [pro].[sp_list_all_postulaciones_concursos_merito] ?,?,?,?,?,?,?,?,?
begin
    declare  @id_proceso_general integer= 105,
        @id_facultad integer= null,
        @id_oferta integer= null,
        @id_categoria_docente integer=10,
        @id_proceso_vacante integer=null,
        @id_user integer=null,
        @id_proceso_usuario integer=null,
        @codigoProceso varchar(60)=null,
        @id_proceso_etapa integer=1
    SELECT DISTINCT pu2.id_proceso_usuario, pv.id_postulacion_vacante, per.id, u.id, pu2.serie, per.identificacion,
                    UPPER(CONCAT(per.apellidos, ' ', per.nombres)) AS postulante,
                    IIF(per.email_institucional IS NULL OR per.email_institucional = '',
                        per.email_personal, per.email_institucional),
                    v.codigo, o.descripcion, d.id, d.nombre, a.descripcion, n.descripcion, prov.remuneracion,
                    v.campo_amplio_conocimiento, v.campo_detallado_conocimiento, v.campo_especifico_conocimiento,
                    ISNULL(v.titulo_tercer_nivel, ''), ISNULL(v.titulo_cuarto_nivel, ''),
                    dc.id_docente_categoria, dc.descripcion, dd.descripcion, tpe.descripcion, tpe.color,
                    ISNULL(
                            [pro].[fn_sca_get_calificacion_by_evaluacion]
                            (
                                    pee.id_proceso_etapa,
                                    pu2.id_proceso_usuario
                            ),
                            ISNULL(pee.calificacion, 0)
                    ) AS calificacion,
                    iif(cast(pee.fecha_ing as date)<>cast(pee.fecha_mod as date),1,0) as evaluado,
                    prov.id_proceso_vacante, prov.otro_idioma, ma.id_modalidad_asignatura,
                    modA.descripcion, modC.descripcion,
                    o.id_oferta, pu2.notificado, pu2.aprobado, pu2.observacion,
                    docs.totalDocumentos, docs.totalDocumentosSubidos
    FROM pro.proceso_usuario2 pu2
             INNER JOIN pro.proceso_etapa_ejecucion2 pee ON pee.id_proceso_usuario = pu2.id_proceso_usuario AND pee.id_proceso_etapa = @id_proceso_etapa
             INNER JOIN pro.tipo_proceso_estado tpe ON tpe.id_tipo_proceso_estado = pee.id_tipo_proceso_estado
             INNER JOIN pro.postulacion_vacante pv ON pu2.id_proceso_usuario = pv.id_proceso_usuario
             INNER JOIN pro.proceso_general pg ON pu2.id_proceso_general = pg.id_proceso_general
             INNER JOIN pro.proceso p ON pg.id_proceso = p.id_proceso
             INNER JOIN pro.tipo_proceso tp ON tp.id_tipo_proceso = p.id_tipo_proceso
             INNER JOIN man.personas per ON pu2.id_persona = per.id
             INNER JOIN seg.usuarios u ON u.persona_id = per.id
             INNER JOIN pro.proceso_vacante prov ON prov.id_proceso_vacante = pv.id_proceso_vacante
             INNER JOIN pro.vacante v ON prov.id_vacante = v.id_vacante
             INNER JOIN aca.oferta o ON v.id_oferta = o.id_oferta
             INNER JOIN aca.departamento_oferta dof ON dof.id_oferta = o.id_oferta
             INNER JOIN man.departamentos d ON dof.id_departamento = d.id
             INNER JOIN pro.vacante_asignatura va ON v.id_vacante = va.id_vacante
             INNER JOIN aca.malla_asignatura ma ON va.id_malla_asignatura = ma.id_malla_asignatura
             INNER JOIN aca.modalidad_asignatura modA ON modA.id_modalidad_asignatura = ma.id_modalidad_asignatura
             INNER JOIN aca.asignatura a ON ma.id_asignatura = a.id_asignatura
             INNER JOIN aca.nivel n ON ma.id_nivel = n.id_nivel
             INNER JOIN aca.docente_categoria dc ON v.id_docente_categoria = dc.id_docente_categoria
             INNER JOIN aca.docente_dedicacion dd ON v.id_docente_dedicacion = dd.id_docente_dedicacion
             INNER JOIN pro.proceso_calendario pc ON pc.id_proceso_general = pg.id_proceso_general AND pc.id_proceso_etapa = pee.id_proceso_etapa
             LEFT JOIN pro.vacante_cronograma_etapa vce ON prov.id_proceso_vacante = vce.id_proceso_vacante
        AND vce.id_proceso_etapa = pee.id_proceso_etapa
        AND vce.estado = 'A'
             LEFT JOIN aca.modalidad modC ON vce.id_modalidad = modC.id_modalidad AND vce.estado = 'A' AND modC.estado = 'A'
             OUTER APPLY
         (
             SELECT COUNT(DISTINCT doc.descripcionRequisito) AS totalDocumentos,
                    COUNT(doc.id_etapa_ejecucion_documento) AS totalDocumentosSubidos
             FROM pro.fn_list_documentos_postulante(pu2.id_proceso_usuario) doc
             WHERE pc.requiere_documento = 1
         ) docs
    WHERE pu2.estado = 'A' AND pv.estado = 'A' AND pg.estado = 'A'
      AND p.estado = 'A' AND per.estado = 'AC' AND prov.estado = 'A'
      AND modA.estado = 'A' AND o.estado = 'A' AND u.estado = 'AC'
      AND pee.estado = 'A' AND va.estado = 'A' AND va.principal = 1
      AND (tp.codigo = @codigoProceso OR @codigoProceso IS NULL)
      AND (pg.id_proceso_general = @id_proceso_general OR @id_proceso_general IS NULL)
      AND (d.id = @id_facultad OR @id_facultad IS NULL)
      AND (o.id_oferta = @id_oferta OR @id_oferta IS NULL)
      AND (dc.id_docente_categoria = @id_categoria_docente OR @id_categoria_docente IS NULL)
      AND (pv.id_proceso_vacante = @id_proceso_vacante OR @id_proceso_vacante IS NULL)
      AND (u.id = @id_user OR @id_user IS NULL)
      AND (pu2.id_proceso_usuario = @id_proceso_usuario OR @id_proceso_usuario IS NULL)
    ORDER BY d.nombre, o.descripcion, a.descripcion, postulante;
end

BEGIN
    DECLARE @id_proceso_general int = 105,
        @id_facultad int = NULL,
        @id_oferta int = NULL,
        @id_categoria_docente int = 10,
        @id_proceso_vacante int = NULL,
        @id_user int = NULL,
        @id_proceso_usuario int = NULL,
        @codigoProceso varchar(60) = NULL,
        @id_proceso_etapa int = 1;

    WITH postulantes AS
             (
                 SELECT DISTINCT pu2.id_proceso_usuario, o.id_oferta, o.descripcion AS carrera,
                                 ISNULL(docs.totalDocumentos, 0) AS totalDocumentos,
                                 ISNULL(docs.totalDocumentosSubidos, 0) AS totalDocumentosSubidos
                 FROM pro.proceso_usuario2 pu2
                          INNER JOIN pro.proceso_etapa_ejecucion2 pee ON pee.id_proceso_usuario = pu2.id_proceso_usuario AND pee.id_proceso_etapa = @id_proceso_etapa
                          INNER JOIN pro.postulacion_vacante pv ON pu2.id_proceso_usuario = pv.id_proceso_usuario
                          INNER JOIN pro.proceso_general pg ON pu2.id_proceso_general = pg.id_proceso_general
                          INNER JOIN pro.proceso p ON pg.id_proceso = p.id_proceso
                          INNER JOIN pro.tipo_proceso tp ON tp.id_tipo_proceso = p.id_tipo_proceso
                          INNER JOIN man.personas per ON pu2.id_persona = per.id
                          INNER JOIN seg.usuarios u ON u.persona_id = per.id
                          INNER JOIN pro.proceso_vacante prov ON prov.id_proceso_vacante = pv.id_proceso_vacante
                          INNER JOIN pro.vacante v ON prov.id_vacante = v.id_vacante
                          INNER JOIN aca.oferta o ON v.id_oferta = o.id_oferta
                          INNER JOIN aca.departamento_oferta dof ON dof.id_oferta = o.id_oferta
                          INNER JOIN man.departamentos d ON dof.id_departamento = d.id
                          INNER JOIN pro.vacante_asignatura va ON v.id_vacante = va.id_vacante
                          INNER JOIN aca.malla_asignatura ma ON va.id_malla_asignatura = ma.id_malla_asignatura
                          INNER JOIN aca.modalidad_asignatura modA ON modA.id_modalidad_asignatura = ma.id_modalidad_asignatura
                          INNER JOIN aca.docente_categoria dc ON v.id_docente_categoria = dc.id_docente_categoria
                          INNER JOIN pro.proceso_calendario pc ON pc.id_proceso_general = pg.id_proceso_general AND pc.id_proceso_etapa = pee.id_proceso_etapa
                          OUTER APPLY (
                     SELECT COUNT(DISTINCT doc.descripcionRequisito) AS totalDocumentos,
                            COUNT(doc.id_etapa_ejecucion_documento) AS totalDocumentosSubidos
                     FROM pro.fn_list_documentos_postulante(pu2.id_proceso_usuario) doc
                     WHERE pc.requiere_documento = 1
                 ) docs
                 WHERE pu2.estado = 'A' AND pv.estado = 'A' AND pg.estado = 'A' AND p.estado = 'A'
                   AND per.estado = 'AC' AND prov.estado = 'A' AND modA.estado = 'A' AND o.estado = 'A'
                   AND u.estado = 'AC' AND pee.estado = 'A' AND va.estado = 'A' AND va.principal = 1
                   AND (tp.codigo = @codigoProceso OR @codigoProceso IS NULL)
                   AND (pg.id_proceso_general = @id_proceso_general OR @id_proceso_general IS NULL)
                   AND (d.id = @id_facultad OR @id_facultad IS NULL)
                   AND (o.id_oferta = @id_oferta OR @id_oferta IS NULL)
                   AND (dc.id_docente_categoria = @id_categoria_docente OR @id_categoria_docente IS NULL)
                   AND (pv.id_proceso_vacante = @id_proceso_vacante OR @id_proceso_vacante IS NULL)
                   AND (u.id = @id_user OR @id_user IS NULL)
                   AND (pu2.id_proceso_usuario = @id_proceso_usuario OR @id_proceso_usuario IS NULL)
             )
    SELECT id_oferta, carrera,
           COUNT(*) AS totalPostulantes,
           SUM(IIF(totalDocumentos > 0 AND totalDocumentosSubidos >= totalDocumentos, 1, 0)) AS documentacionCompleta,
           SUM(IIF(totalDocumentosSubidos > 0 AND totalDocumentosSubidos < totalDocumentos, 1, 0)) AS documentacionParcial,
           SUM(IIF(totalDocumentosSubidos = 0, 1, 0)) AS sinDocumentacion
    FROM postulantes
    GROUP BY id_oferta, carrera
    ORDER BY carrera;
END;

select * from seg.usuario_opcion
select * from man.opciones where url like '%postulacion-vacante-concurso-merito%'

select * from seg.usuarios where usuario in ('1312849720','0917849069')

select * from pro.proceso_calendario where id_proceso_general = 105


-- where d.identificacion in ('2450847211')

select * from pro.vacante_asignatura where estado='A'

SELECT va.id_vacante_asignatura, va.id_vacante, va.id_malla_asignatura, va.principal, va.estado
FROM pro.vacante_asignatura va
WHERE va.estado = 'A'
  AND va.id_vacante IN (
    SELECT va2.id_vacante
    FROM pro.vacante_asignatura va2
    WHERE va2.estado = 'A'
    GROUP BY va2.id_vacante
    HAVING COUNT(*) = 1
);
--
-- UPDATE va
-- SET va.principal = 1
-- FROM pro.vacante_asignatura va
-- WHERE va.estado = 'A'
--   AND va.id_vacante IN (
--     SELECT va2.id_vacante
--     FROM pro.vacante_asignatura va2
--     WHERE va2.estado = 'A'
--     GROUP BY va2.id_vacante
--     HAVING COUNT(*) = 1
-- );


select p.descripcion,pu.* from pro.proceso_usuario2 pu
                                   inner join pro.proceso_general pg on pu.id_proceso_general = pg.id_proceso_general
                                   inner join pro.proceso p on pg.id_proceso = p.id_proceso
where pu.usuario_ing='0104166483'



-- insert into pro.etapa_ejecucion_responsable2
select (select pee.id_proceso_etapa_ejecucion from pro.proceso_etapa_ejecucion2 pee where pee.estado='A' and pee.id_proceso_etapa = 5 and pee.id_proceso_usuario=pee2.id_proceso_usuario),
       eer2.id_persona, eer2.observacion, eer2.culminado, eer2.principal, eer2.puede_calificar,
       eer2.estado, 0, getdate(), getdate(), eer2.usuario_ing, eer2.usuario_mod, eer2.rol, eer2.orden from pro.proceso_etapa_ejecucion2 pee2
                                                                                                               inner join pro.etapa_ejecucion_responsable2 eer2   on pee2.id_proceso_etapa_ejecucion = eer2.id_proceso_etapa_ejecucion
                                                                                                               inner join man.personas p2 on eer2.id_persona=p2.id
where eer2.estado='A' and p2.estado='AC' and pee2.id_proceso_usuario in (select pee.id_proceso_usuario from pro.proceso_etapa_ejecucion2 pee where pee.estado='A' and pee.id_proceso_etapa = 5) and
    pee2.id_proceso_etapa = 2

-- insert into  pro.etapa_ejecucion_responsable2
-- select pee2.id_proceso_etapa_ejecucion,1135, eer2.observacion, eer2.culminado, eer2.principal, eer2.puede_calificar,
--        eer2.estado, 0, getdate(), getdate(), eer2.usuario_ing, eer2.usuario_mod, 'PROFESOR(A)', eer2.orden from pro.proceso_etapa_ejecucion2 pee2
-- inner join pro.etapa_ejecucion_responsable2 eer2   on pee2.id_proceso_etapa_ejecucion = eer2.id_proceso_etapa_ejecucion
--  inner join man.personas p2 on eer2.id_persona=p2.id
-- inner join pro.proceso_usuario2 pu on pu.id_proceso_usuario = pee2.id_proceso_usuario
-- inner join pro.postulacion_vacante pv on pv.id_proceso_usuario = pu.id_proceso_usuario
-- inner join pro.proceso_vacante pva on pva.id_proceso_vacante = pv.id_proceso_vacante
-- inner join pro.vacante v on v.id_vacante = pva.id_vacante
-- where eer2.estado='A' and p2.estado='AC' and pee2.id_proceso_etapa = 5 and v.id_oferta = 59

SELECT * FROM pro.etapa_ejecucion_responsable2

-- 1150
--
-- 1135



select * from man.personas where apellidos like '%Salazar Arango%' AND nombres like '%Edwar%'

select * from pro.proceso_calendario

-- insert into pro.proceso_etapa_ejecucion2
-- select  pee2.id_proceso_usuario, 5, pee2.id_tipo_etapa_estado, pee2.fecha_hora_recepcion,
--        pee2.fecha_hora_despacho, pee2.tiempo_retraso, pee2.notificado_correo, pee2.calificacion, pee2.observacion, pee2.fecha_cronograma, pee2.hora_inicio,
--        pee2.hora_fin, pee2.estado, pee2.version, pee2.fecha_ing, pee2.fecha_mod, pee2.usuario_ing, pee2.usuario_mod, pee2.id_tipo_proceso_estado
-- from pro.proceso_usuario2 pu
-- inner join pro.proceso_etapa_ejecucion2 pee2 on pu.id_proceso_usuario = pee2.id_proceso_usuario
-- inner join pro.etapa_ejecucion_responsable2 eer2   on pee2.id_proceso_etapa_ejecucion = eer2.id_proceso_etapa_ejecucion
--  inner join man.personas p2 on eer2.id_persona=p2.id
-- where eer2.estado='A' and p2.estado='AC' and pee2.id_proceso_etapa = 1 and pu.usuario_ing ='1600457400'

-- insert into pro.etapa_ejecucion_responsable2
select pee2.id_proceso_etapa_ejecucion,pee2.id_proceso_usuario, pee2.id_proceso_etapa, pee2.id_tipo_etapa_estado, pee2.fecha_hora_recepcion,
       pee2.fecha_hora_despacho, pee2.tiempo_retraso, pee2.notificado_correo, pee2.calificacion, pee2.observacion, pee2.fecha_cronograma, pee2.hora_inicio,
       pee2.hora_fin, pee2.estado, pee2.version, pee2.fecha_ing, pee2.fecha_mod, pee2.usuario_ing, pee2.usuario_mod, pee2.id_tipo_proceso_estado
from pro.proceso_usuario2 pu
         inner join pro.proceso_etapa_ejecucion2 pee2 on pu.id_proceso_usuario = pee2.id_proceso_usuario
where  pu.id_proceso_usuario = 572

select * from pro.proceso_etapa_ejecucion2 pee where pee.estado='A' and pee.id_proceso_etapa = 5

insert into pro.etapa_ejecucion_responsable2
select pee2.id_proceso_etapa_ejecucion,1075,null,0,null,null,'A',0,getdate(),getdate(),pee2.usuario_ing,pee2.usuario_mod,null,null
from pro.proceso_usuario2 pu
         inner join pro.proceso_etapa_ejecucion2 pee2 on pu.id_proceso_usuario = pee2.id_proceso_usuario
where  pu.id_proceso_usuario = 572 and pee2.id_proceso_etapa = 5
-- r2/30/17/10/REQUISITOS/572/2/CONCURSOMERITO


SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_to_evaluar2](96,17,7,
                                                                                     'REQUISITOSsss',8221,5,'CONCURSOMERITO')


select * from pro.proceso_calendario

select * from pro.etapa_ejecucion_responsable2

select * from man.personas where apellidos like '%andrade y%'

select dce.* from pro.evaluacion_requisito er
                      inner join pro.proceso_requisito pr on pr.id_proceso_requisito = er.id_proceso_requisito
                      inner join pro.docente_categoria_evaluacion dce  on er.id_evaluacion_requisito = dce.id_evaluacion_requisito
where er.id_evaluacion_rubrica = 11
order by er.orden
select * from [pro].[fn_list_evaluaciones_by_process](15,10,5)

select e.descripcion,pc.id_proceso_general,pc.fecha_desde,pc.fecha_hasta from pro.proceso p
                                                                                  inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
                                                                                  inner join pro.etapa e on e.id_etapa = pe.id_etapa
                                                                                  inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
where p.id_proceso = 2 and pc.id_proceso_general = 11

select * from seg.roles

select * from pro.proceso_calendario
select * from pro.etapa_evaluaciones
select * from pro.evaluaciones_docente_categoria

select * from pro.etapa_docente_categoria
select * from pro.evaluacion_rubrica

select * from pro.evaluacion_requisito

select * from pro.requisito_valor

select * from pro.etapa_ejecucion_requisito2

select * from pro.etapa_requisito

select * from pro.tipo_categorias_evaluacion

select * from pro.tipo_proceso_estado

select * from pro.proceso

select * from pro.vacante WHERE estado='I'
-- DBCC CHECKIDENT ('pro.proceso_general', RESEED, 22);
select * from pro.proceso_general
--2  cc
-- beca s  6
select distinct edc.id_docente_categoria,evdc.id_docente_categoria,ev.* from pro.proceso p
                              inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
                              inner join pro.etapa e on e.id_etapa = pe.id_etapa
                              inner join pro.tipo_proceso tp on p.id_tipo_proceso = tp.id_tipo_proceso
                              inner join pro.proceso_general pg on p.id_proceso = pg.id_proceso
                              inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
                              inner join pro.etapa_docente_categoria edc on pc.id_proceso_calendario = edc.id_proceso_calendario
                              inner join pro.etapa_evaluaciones ev on ev.id_proceso_calendario = pc.id_proceso_calendario
                              inner join pro.evaluaciones_docente_categoria evdc on ev.id_etapa_evaluacion = evdc.id_etapa_evaluacion and edc.id_docente_categoria = evdc.id_docente_categoria
where  pg.id_proceso_general=87 and pe.id_proceso_etapa = 39

select * from pro.proceso_usuario2 where id_proceso_general = 9
--     2498 agregado
--     2501 auxiliar
--      2514 principal
select * from pro.postulacion_vacante where id_proceso_usuario = 8187


--16meritos
select
    distinct dce.*
from [pro].[fn_list_all_rubricas_evaluaciones_procesos]
     (96,'MERITOYOPOSICIONTUTILAR',63,null) as d
         inner join pro.evaluaciones_docente_categoria evdc on d.idEtapaEvaluacion = evdc.id_etapa_evaluacion
         inner join pro.etapa_docente_categoria edc on edc.id_proceso_calendario = d.idProcesoCalendario
         inner join aca.docente_categoria dc on dc.id_docente_categoria = edc.id_docente_categoria and evdc.id_docente_categoria = dc.id_docente_categoria
         inner join pro.docente_categoria_evaluacion dce on dce.id_evaluacion_requisito = d.idEvaluacionRequisito and dc.id_docente_categoria = dce.id_docente_categoria
         inner join pro.proceso_requisito pr on pr.id_proceso_requisito = d.idProcesoRequisito
         left join  aca.tipo_documento td on td.id_tipo_documento = pr.id_tipo_documento
         inner join aca.tipo_archivo ta on ta.id_tipo_archivo = pr.id_tipo_archivo
         inner join pro.proceso_usuario2 pu on pu.id_proceso_general = d.idProcesoGeneral
         inner join pro.postulacion_vacante pv on pv.id_proceso_usuario = pu.id_proceso_usuario
         inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario
         inner join pro.etapa_ejecucion_responsable2 ejr on ejr.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion
         left join pro.etapa_ejecucion_documento2 eed on eed.id_etapa_ejecucion_responsable = ejr.id_etapa_ejecucion_responsable
    and eed.id_docente_categoria_evaluacion =dce.id_docente_categoria_evaluacion  and eed.estado='A'
where dc.id_docente_categoria in (4) and pej.id_proceso_etapa = 39
  and edc.estado='A' and dc.estado='A' and evdc.estado='A' and dce.estado='A' and ejr.estado='A'
  and pu.id_proceso_usuario = 8172
-- order by dce.orden
select * from  pro.docente_categoria_evaluacion_relacion
select * from pro.etapa_evaluaciones
select * from pro.tipo_categorias_evaluacion
select * from pro.evaluaciones_docente_categoria
select * from pro.evaluacion_rubrica
select * from  pro.docente_categoria_evaluacion
select * from pro.etapa_ejecucion_documento2
select * from pro.etapa_ejecucion_requisito2
-- where id_etapa_ejecucion_responsable = 19097

select * from aca.periodo_academico where id_tipo_oferta = 1

select * from pro.etapa_evaluaciones


select * from pro.etapa

select ep.descripcion,e.descripcion as etapa,pe.* from pro.proceso_etapa pe
         inner join pro.etapa e on pe.id_etapa = e.id_etapa
         inner join pro.etapa ep on ep.id_etapa = pe.id_etapa_padre
         where id_proceso = 9

select * from  pro.proceso_general pg
                   inner join aca.periodo_academico pa on pg.id_periodo_academico = pa.id_periodo_academico
                   inner join pro.proceso p on pg.id_proceso = p.id_proceso
                   inner join pro.proceso_vacante prov on prov.id_proceso_general = pg.id_proceso_general
                   inner join pro.vacante v on prov.id_vacante = v.id_vacante
                   inner join aca.ofertas_facultad o on v.id_oferta = o.id_oferta
                   inner join pro.vacante_asignatura va on v.id_vacante = va.id_vacante
                   inner join aca.malla_asignatura ma on va.id_malla_asignatura = ma.id_malla_asignatura
                   inner join aca.modalidad_asignatura modA on modA.id_modalidad_asignatura = ma.id_modalidad_asignatura
                   inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
                   inner join aca.nivel n on ma.id_nivel = n.id_nivel
                   inner join aca.docente_categoria dc on v.id_docente_categoria = dc.id_docente_categoria
                   inner join aca.docente_dedicacion dd on v.id_docente_dedicacion = dd.id_docente_dedicacion

select * from  [pro].[fn_list_all_postulaciones_concursos_merito](87,12,null,null,
                                                                    null,null,null,'MERITOYOPOSICIONTUTILAR',39) as d


select * from  pro.proceso_general pg
    inner join aca.periodo_academico pa on pg.id_periodo_academico = pa.id_periodo_academico
    inner join pro.proceso p on pg.id_proceso = p.id_proceso
    inner join pro.proceso_vacante prov on prov.id_proceso_general = pg.id_proceso_general
    inner join pro.vacante v on prov.id_vacante = v.id_vacante
    inner join aca.ofertas_facultad o on v.id_oferta = o.id_oferta
    inner join aca.docente_categoria dc on v.id_docente_categoria = dc.id_docente_categoria
where pg.estado='A' and pa.estado='A' and p.estado='A' and prov.estado='A' and v.estado='A' and dc.estado='A'
and pg.id_periodo_academico = 96 and p.codigo='MERITOYOPOSICIONTUTILAR'
select * from pro.proceso
SELECT * FROM aca.[fun_moodle_course_categories_web](96,NULL,NULL,'A')
select * from aca.[fun_moodle_course_categories_web_concursos](87)
SELECT * FROM aca.[fun_moodle_course_asignatura_web](96,7,87,'87-7-96',null,'A')
select * from aca.[fun_moodle_course_vacantes_concursos_web](87,45)
select * from aca.[fun_moodle_course_estudiante_web] (96,null,null,'A','87-7-96-1-1540-1')
select * from aca.[fun_moodle_course_postulantes_web](87,null,null,45,'38-5-87-7-2497')
select * from aca.[fun_moodle_user] (96,12,null,'A')
select * from [aca].[fun_moodle_user_concursos](87,5,null,45)
select * from [aca].[fun_moodle_user_concursos](87,12,101,45)
select * from aca.[fun_moodle_user_course] (96,'2400255440','A') as d
select * from aca.fun_moodle_user_course_concursos(87,'0911164127',45)
select * from aca.fun_moodle_user_course_concursos(87,'1600494106',45)


select  LOWER(d.identificacion) as username,p.apellidos as lastname,p.nombres  as firstname, d.postulante ,
        LOWER(d.identificacion) as idnumber,d.emailPersonal	, 5 as rol_id, 'ESTUDIANTE' rol,d.idOferta,d.carrera
from  [pro].[fn_list_all_postulaciones_concursos_merito](87,12,null,null,
                                                         null,null,null,'MERITOYOPOSICIONTUTILAR',45) as d
          inner join man.personas p on p.identificacion = d.identificacion
order by  lastname,firstname
go



--listar postulante
select d.* from  [pro].[fn_list_all_postulaciones_concursos_merito](87,null,null,7,
                                                                      null,null,null,'MERITOYOPOSICIONTUTILAR',39) as d
                       inner join pro.proceso_etapa_ejecucion2 pee2 on pee2.id_proceso_etapa_ejecucion =d.idProcesoEtapaEjecucion
                       inner join pro.proceso_usuario2 pu2 on pee2.id_proceso_usuario = pu2.id_proceso_usuario
where-- d.totalDocumentosSubidos=0 and
     d.identificacion not in ('0703865139','0915478036',
                              '0913140216','0920608379','0914880414','0918968488','0910759851','0602992141','1715895213','0928816107',
                              '0960242659','0924204290','1757030174','0802495069','0908182280','0961027687','2400061632','1600494106',
                              '0913729257','0910555432','0910610682','0917655219','0918988312','0962574562','0703382150','0915924153',
                              '0915173892','0915924526','1204699738','0702761693','0914401948','1715793269','0911347094','0962069431',
                              '0923406987','1205907130','0705363869','1720726064','0923968283','0965336993')

select top 20 * from pro.etapa_ejecucion_requisito2 order by id_etapa_ejecucion_requisito desc

select pee2.* from pro.proceso_etapa_ejecucion2 pee2
inner join pro.proceso_usuario2 pu2 on pee2.id_proceso_usuario = pu2.id_proceso_usuario
where pee2.id_proceso_etapa_ejecucion in (12472,12571,12544,
12624,12585,12496,12611,12502,12554,12527,12639,12469,12591,12555,12620,12623,12466,12510,12603,
12564,12615,12621,12504,12612,12465,12500,12628,12638,12497,12559,12570,12511,12457,12541,12479,
12488,12593,12530,12622,12492,12481,12474,12633,12523,12589,12552)

select * from pro.tipo_proceso_estado

select distinct ER.*--,tce.descripcion,tce.orden,tce2.descripcion,tce2.orden
--      ,pr.descripcion
from pro.evaluacion_requisito er
         inner join pro.proceso_requisito pr on er.id_proceso_requisito = pr.id_proceso_requisito
         inner join pro.docente_categoria_evaluacion dce on er.id_evaluacion_requisito = dce.id_evaluacion_requisito
         inner join pro.tipo_categorias_evaluacion tce on er.id_tipo_categoria_evaluacion = tce.id_tipo_categoria_evaluacion
         left join pro.tipo_categorias_evaluacion tce2 on tce2.id_tipo_categoria_evaluacion = tce.id_tipo_categoria_evaluacion_padre
where er.id_evaluacion_rubrica in (25)
  and dce.estado='A' --and er.id_proceso_requisito in (49,48)
--   and dce.id_docente_categoria = 1
-- order by isnull(tce2.orden,10),dce.orden
select * from pro.evaluacion_requisito
select * from pro.proceso_requisito



select * from pro.tipo_evaluaciones
select * from [pro].[fn_list_postulaciones_concursos_merito_upse](87,null,null,1,null,null,
                                                                  null)

select  distinct * from [pro].[fn_list_all_rubricas_evaluaciones_procesos]
     (96,'MERITOYOPOSICIONTUTILAR',63,null) as d

SELECT *
FROM pro.fn_list_all_rubricas_evaluaciones_by_clasificacion(96, 63, 7,8170, 39, 'MERITOYOPOSICIONTUTILAR')

SELECT *
FROM pro.fn_list_all_rubricas_evaluaciones_by_clasificacion(96, 63, 1,8299, 39, 'MERITOYOPOSICIONTUTILAR') as d

SELECT *
FROM pro.etapa_evaluaciones

SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_to_evaluar2](96,63,4,
                                                                                     0,8221,
                                                                                     39,'MERITOYOPOSICIONTUTILAR')

select * from pro.etapa_ejecucion_requisito2 where id_etapa_ejecucion_requisito = 75038

select * from pro.proceso_etapa_ejecucion2 where id_proceso_usuario = 8221
begin
declare @id_categoria_docente int = 1, @codigoProceso varchar(50)='MERITOYOPOSICIONTUTILAR',@id_periodo_academico int =96,
    @id_codigo_categoria_evaluacion_padre varchar(20)=null,@id_etapa_evaluacion int=63,@id_proceso_etapa int = 39,@id_proceso_usuario int = 8202

select d.idProcesoCalendario,d.tipoEvaluacion, d.idEtapaEvaluacion, d.codigoCategoriaEvaluacionPadre, d.categoriaEvaluacionPadre, d.colorCategoriaEvaluacionPadre,
       d.idTipoCategoriaEvaluacion, d.categoriaEvaluacion, d.colorCategoriaEvaluacion,
       d.idEvaluacionRequisito,dc.descripcion     as categoria_docente,
       dce.descripcion_requisito,dce.descripcion_calificacion,dce.indicaciones_item,
       d.medioVerificacion,pr.id_proceso_requisito, TD.abreviatura,
       dce.id_docente_categoria_evaluacion,dce.valor_minimo,dce.valor_maximo,dce.escala,dce.excepcion,dce.intervalo_personalizado,
       ejr.id_etapa_ejecucion_responsable,
       eer.id_etapa_ejecucion_requisito,eer.observacion,eer.validado,eer.puede_editar,eer.calificacion,
       eed.id_etapa_ejecucion_documento,eed.file_name,eed.upload_url,
       pej.id_proceso_etapa_ejecucion,pej.observacion,dce.requisito_minimo,rel.id_docente_categoria_evaluacion_padre,( select count(*) from pro.docente_categoria_evaluacion_relacion rel
    where rel.id_docente_categoria_evaluacion_padre =  dce.id_docente_categoria_evaluacion AND rel.estado = 'A') AS tieneVarios,
       JSON_QUERY((
           select dce1.valor_minimo,dce1.valor_maximo,dce1.escala,dce1.excepcion,dce1.intervalo_personalizado from pro.docente_categoria_evaluacion dce1
                                         where dce1.id_docente_categoria_evaluacion= dce.id_docente_categoria_evaluacion
           FOR JSON PATH, INCLUDE_NULL_VALUES
       )) AS rubrica
from [pro].[fn_list_all_rubricas_evaluaciones_procesos]
     (@id_periodo_academico, @codigoProceso, @id_etapa_evaluacion, null) as d
         inner join pro.evaluaciones_docente_categoria evdc on d.idEtapaEvaluacion = evdc.id_etapa_evaluacion
         inner join pro.etapa_docente_categoria edc on edc.id_proceso_calendario = d.idProcesoCalendario
         inner join aca.docente_categoria dc on dc.id_docente_categoria = edc.id_docente_categoria and  evdc.id_docente_categoria = dc.id_docente_categoria
         inner join pro.docente_categoria_evaluacion dce on dce.id_evaluacion_requisito = d.idEvaluacionRequisito and dc.id_docente_categoria = dce.id_docente_categoria
         inner join pro.proceso_requisito pr on pr.id_proceso_requisito = d.idProcesoRequisito
         left join aca.tipo_documento td on td.id_tipo_documento = pr.id_tipo_documento
         inner join aca.tipo_archivo ta on ta.id_tipo_archivo = pr.id_tipo_archivo
         inner join pro.proceso_usuario2 pu on pu.id_proceso_general = d.idProcesoGeneral
         inner join pro.postulacion_vacante pv on pv.id_proceso_usuario = pu.id_proceso_usuario
         inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario and pej.id_proceso_etapa = d.idProcesoEtapa
         inner join pro.etapa_ejecucion_responsable2 ejr on ejr.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion
         LEFT JOIN pro.etapa_ejecucion_documento2 eed ON eed.id_docente_categoria_evaluacion = dce.id_docente_categoria_evaluacion
                       AND eed.id_etapa_ejecucion_responsable = ejr.id_etapa_ejecucion_responsable AND eed.estado = 'A'
         LEFT JOIN pro.docente_categoria_evaluacion_relacion rel  ON rel.id_docente_categoria_evaluacion =  dce.id_docente_categoria_evaluacion AND rel.estado = 'A'
         left join pro.etapa_ejecucion_requisito2 eer on eer.id_etapa_ejecucion_responsable = ejr.id_etapa_ejecucion_responsable
                                         and dce.id_docente_categoria_evaluacion = eer.id_docente_categoria_evaluacion and eer.estado = 'A'
where dc.id_docente_categoria = @id_categoria_docente
  and pej.id_proceso_etapa = @id_proceso_etapa
  and edc.estado = 'A' and dc.estado = 'A' and evdc.estado = 'A'
  and dce.estado = 'A' and ejr.estado = 'A'and pu.id_proceso_usuario = @id_proceso_usuario
  and (d.codigoCategoriaEvaluacionPadre = @id_codigo_categoria_evaluacion_padre or @id_codigo_categoria_evaluacion_padre is null)
order by d.idTipoCategoriaEvaluacion, dce.orden
end

select  distinct *
from [pro].[fn_list_all_rubricas_evaluaciones_procesos]
     (96,'MERITOYOPOSICIONTUTILAR',63,null) as d


select * from pro.etapa_evaluaciones ev
select * from pro.evaluaciones_docente_categoria edc
-- left join

select
--     er.*
    pe.id_proceso_etapa,e.descripcion,pg.id_proceso_general,pc.id_proceso_calendario,te.id_tipo_evaluacion,te.descripcion,ee.id_etapa_evaluacion,
       m.descripcion,iif(tce.id_tipo_categoria_evaluacion_padre is null,tce.codigo,tcp.codigo) as codigoCategoriaEvaluacionPadre,
       iif(tce.id_tipo_categoria_evaluacion_padre is null,tce.descripcion,tcp.descripcion) as categoriaEvaluacionPadre,
       iif(tce.id_tipo_categoria_evaluacion_padre is null,tce.color,tcp.color) as colorCategoriaEvaluacionPadre,
       tce.id_tipo_categoria_evaluacion,tce.descripcion as categoriaEvaluacion,tce.color as colorCategoriaEvaluacion,er.id_evaluacion_requisito,
       pr.abreviatura as abrevituraProcesoRequisito,
       pr.id_proceso_requisito,pr.descripcion as procesoRequisito,pr.indicaciones_item,pr.medio_verificacion,er.orden,
       isnull(tcp.orden,tce.orden),tce.orden
from pro.proceso p
         inner join pro.tipo_proceso tp on tp.id_tipo_proceso=p.id_tipo_proceso
         inner join pro.proceso_general pg on pg.id_proceso = p.id_proceso
         inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
         inner join pro.etapa e on e.id_etapa = pe.id_etapa
         inner join pro.proceso_calendario pc on  pc.id_proceso_etapa = pe.id_proceso_etapa and pc.id_proceso_general = pg.id_proceso_general
         inner join pro.etapa_evaluaciones ee on ee.id_proceso_calendario = pc.id_proceso_calendario
         inner join pro.evaluacion_rubrica eru on ee.id_evaluacion_rubrica = eru.id_evaluacion_rubrica
         inner join pro.tipo_evaluaciones te on te.id_tipo_evaluacion = eru.id_tipo_evaluacion
         inner join aca.modalidad m on m.id_modalidad = eru.id_modalidad
         inner join pro.evaluacion_requisito er on er.id_evaluacion_rubrica = eru.id_evaluacion_rubrica
         inner join pro.proceso_requisito pr on pr.id_proceso_requisito = er.id_proceso_requisito
         inner join pro.tipo_categorias_evaluacion tce on tce.id_tipo_categoria_evaluacion = er.id_tipo_categoria_evaluacion
         left join pro.tipo_categorias_evaluacion tcp on tcp.id_tipo_categoria_evaluacion = tce.id_tipo_categoria_evaluacion_padre and tcp.estado='A'
where  tp.codigo='MERITOYOPOSICIONTUTILAR' and pg.id_periodo_academico = 96  and ee.id_etapa_evaluacion = 63
--   and (tce.id_tipo_categoria_evaluacion = @id_tipo_categoria_evaluacion or @id_tipo_categoria_evaluacion is null)
  and p.estado='A' and tp.estado='A' and pg.estado='A' and pe.estado='A' and e.estado='A' and pc.estado='A' and ee.estado='A'
  and te.estado='A' and m.estado='A' and er.estado='A'
  and tce.estado='A' and pr.estado='A'
order by isnull(tcp.orden,tce.orden),tce.orden,er.orden

select distinct pg.id_periodo_academico,pe.id_proceso_etapa,ev.* from pro.proceso p
inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
inner join pro.etapa e on e.id_etapa = pe.id_etapa
inner join pro.tipo_proceso tp on p.id_tipo_proceso = tp.id_tipo_proceso
inner join pro.proceso_general pg on p.id_proceso = pg.id_proceso
inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa and pg.id_proceso_general =pc.id_proceso_general
inner join pro.etapa_evaluaciones ev on ev.id_proceso_calendario = pc.id_proceso_calendario
-- inner join pro.etapa_docente_categoria edc on pc.id_proceso_calendario = edc.id_proceso_calendario
-- inner join pro.evaluaciones_docente_categoria evdc on ev.id_etapa_evaluacion = evdc.id_etapa_evaluacion
where  p.id_proceso = 24


select * from aca.periodo_academico where id_tipo_oferta = 3
select * from [pro].[fn_list_all_categorias_docente_by_process_and_etapa](21,null)

select * from [pro].[fn_list_periodos_academicos_by_process](1,1)

select * from [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion](31,26,10,
                                                                         1928,108,'CONCURSOMERITOPOSTGRADO')

select *
from [pro].[fn_list_evaluaciones_by_process](20, 10, null);

select top 3 * from pro.etapa_ejecucion_documento2
order by fecha_ing desc



select * from pro.proceso_calendario where id_proceso_calendario in (98,99,103,104)

select *
from [pro].[fn_list_evaluaciones_by_process](21, 10, null)

SELECT * FROM pro.fn_list_postulaciones_concursos_merito_upse(21,null,null,null,
                                                              null,664,null)

select top 2 * from pro.proceso_usuario2
order by fecha_ing desc

select top 2 * from pro.postulacion_vacante
order by fecha_ing desc

SELECT * FROM pro.fn_list_postulaciones_concursos_merito_upse(null,null,null,null,
                                                              null,null,1913)

select 21, pv.id_vacante,pv.numero_plazas,pv.puntaje_minimo_final,pv.remuneracion,pv.codigo_evaluacion,'A',0,
       getdate(),getdate(),'2400254286','2400254286' from pro.proceso_vacante pv where pv.id_proceso_vacante in (
    select d.idProcesoVacante from [pro].[fn_list_all_vacantes_by_process](12,null,null) as d
    where d.idVacante not in (select dd.idVacante from [pro].[fn_list_all_vacantes_by_process](21,null,null) as dd))

-- 20  2023-1
-- 21  2023-2
-- 12  2023-2
-- 18  2023-1

--cambiar vacante concurso
select * from pro.proceso_general where id_proceso = 1
select d.* from [pro].[fn_list_all_vacantes_by_process](96,null,null) as d

select * from pro.proceso_general where id_proceso_general in (12,18)

select * from [pro].[fn_list_evaluaciones_by_process_and_proceso_usuario](18)


begin
declare @id_facultad int = null , @id_proceso_general int = 96
select
--     distinct v.*
   distinct pv.id_proceso_vacante,o.descripcion as oferta,o.id_oferta ,v.id_vacante,v.descripcion,v.campo_amplio_conocimiento,dd.id_docente_dedicacion,dd.descripcion as docenteDedicacion
                 ,dc.id_docente_categoria,dc.descripcion as docenteCategoria
                 ,iif(v.estado='A','Activo','Inactivo') as estado
from pro.vacante v
         inner join aca.oferta o on v.id_oferta=o.id_oferta
         inner join pro.proceso_vacante pv on pv.id_vacante=v.id_vacante
         inner join aca.docente_dedicacion dd on dd.id_docente_dedicacion=v.id_docente_dedicacion
         inner join aca.docente_categoria dc on dc.id_docente_categoria=v.id_docente_categoria
         inner join aca.departamento_oferta do on do.id_oferta=o.id_oferta
where o.estado='A' and dd.estado='A' and dc.estado='A' and do.estado='A' and pv.estado='A' and v.estado='A'
  and  pv.id_proceso_general=@id_proceso_general
  --and (do.id_oferta=@id_facultad or @id_facultad is null )
end

select * from pro.postulacion_vacante where usuario_ing='0909833238'

select * from pro.proceso_vacante

select pc.id_proceso_calendario,pe.id_proceso_etapa,e.descripcion,pc.fecha_desde,pc.fecha_hasta from pro.proceso p
                                                                                                         inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
                                                                                                         inner join pro.etapa e on e.id_etapa = pe.id_etapa
                                                                                                         inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
where p.id_proceso = 1 and pc.id_proceso_general = 15

select pe.id_proceso_etapa,e.descripcion,pc.fecha_desde,pc.fecha_hasta,ev.* from pro.proceso p
                                                                                     inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
                                                                                     inner join pro.etapa e on e.id_etapa = pe.id_etapa
                                                                                     inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
                                                                                     inner join pro.etapa_evaluaciones ev on ev.id_proceso_calendario = pc.id_proceso_calendario
where p.id_proceso = 1  and pc.id_proceso_general = 15

--
select ev.* from pro.proceso p
                     inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
                     inner join pro.etapa e on e.id_etapa = pe.id_etapa
                     inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
                     inner join pro.etapa_evaluaciones ev on ev.id_proceso_calendario = pc.id_proceso_calendario
where p.id_proceso = 1  and pc.id_proceso_general = 70




select * from aca.tipo_matricula_fecha
select p.identificacion,p.nombres,p.apellidos,p.fecha_nace,p.sexo from man.personas p
where p.sexo is null or p.sexo =''

exec  aca.[sp_rpt_cantidad_matriculados_por_oferta_nivel] 38,null,23,null

select d.id_asignatura,d.asignatura,d.semestre,d.orden,
       d.facultad,d.carrera,d.id_oferta_modalidad,paralelo,id_nivel,count(d.id_estudiante_matricula) as num
from  aca.fn_get_cantidad_matriculados_por_oferta (38,null,23) as d
group by d.id_asignatura,d.asignatura,d.semestre,d.orden,
         d.facultad,d.carrera,d.paralelo,id_nivel,d.id_oferta_modalidad
order by d.carrera, d.orden asc


select pv1.* from pro.postulacion_vacante pv1
                      inner join pro.proceso_usuario2 pu1 on pv1.id_proceso_usuario = pu1.id_proceso_usuario
                      inner join pro.proceso_etapa_ejecucion2 pee1 on pu1.id_proceso_usuario = pee1.id_proceso_usuario
                      inner join pro.etapa_ejecucion_responsable2 eer1 on pee1.id_proceso_etapa_ejecucion = eer1.id_proceso_etapa_ejecucion
-- inner join pro.etapa_ejecucion_documento2 eed1 on eer1.id_etapa_ejecucion_responsable = eed1.id_etapa_ejecucion_responsable
--              WHERE PU1.id_proceso_usuario in (2383,2382 )
where pv1.id_postulacion_vacante IN (
    select -- pu2.id_persona,pu2.id_proceso_general,pv.id_proceso_vacante,count(pv.id_proceso_vacante),
           min(pv.id_postulacion_vacante)
    from pro.proceso_usuario2 pu2
             inner join pro.postulacion_vacante pv  on pu2.id_proceso_usuario = pv.id_proceso_usuario
    where pu2.id_proceso_general in (20,21) and pv.estado='A'
    group by pu2.id_persona,pu2.id_proceso_general,pv.id_proceso_vacante
    having count(pv.id_proceso_vacante)>1
)

select *from man.personas p where p.apellidos like'%balmaseda%'

select * from pro.proceso_usuario2 where usuario_ing='0959256801'

select * from seg.usuarios where usuario='0959256801'

--{bcrypt}$2a$10$PwmRJZg.cRO7bOy0uv0hxuTL5bzCHj8CpnKxx9E0SPjZhbolOY9Yq
select *from seg.usuarios where usuario = '0922164421'
select * from man.personas where email_personal ='juansilvasanchez@gmail.com'
select * from aca.docente_historial

select * from pro.proceso_usuario2 where id_proceso_usuario = 592

SELECT * FROM [tmp].[fn_rpt_informe_tecnico_docente](50)

--  DBCC CHECKIDENT ('pro.etapa_ejecucion_documento2', RESEED, 18192);

select tp.codigo,ejr.id_etapa_ejecucion_responsable,null as parTipoDocumento,null as parIdDocenteCategoriaEvaluacion,null as urlUpload,
       null as filname,null as document_type, null as document_format, null as validado, null as observacion,'A',getdate(),getdate(),ejr.usuario_ing,ejr.usuario_ing,0
from pro.proceso_usuario2 pu
         inner join pro.proceso_general pg on pg.id_proceso_general = pu.id_proceso_general
         inner join pro.proceso p on pg.id_proceso = p.id_proceso
         inner join pro.tipo_proceso tp on p.id_tipo_proceso = tp.id_tipo_proceso
         inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario
         inner join pro.proceso_etapa pe on pej.id_proceso_etapa = pe.id_proceso_etapa
         inner join pro.etapa e on pe.id_etapa = e.id_etapa
         inner join pro.etapa_ejecucion_responsable2 ejr on ejr.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion
where pu.estado='A' and pej.estado='A' and ejr.estado='A'
  and pu.id_persona = 323 and e.codigo ='SUBIDADOCUMENTOENTREGA' and tp.codigo ='CONCURSOMERITOPOSTGRADO'
--         and ejr.id_etapa_ejecucion_responsable not in ()

select top 3 * from pro.etapa_ejecucion_documento2
order by fecha_ing desc

select top 3 * from pro.etapa_ejecucion_documento2
order by fecha_ing desc

select * from pro.proceso

SELECT * FROM pro.fn_list_postulaciones_concursos_merito(31,null,null,
                                                         null,null,14330,null,'CONCURSOMERITOPOSTGRADO')
select * from pro.docente_categoria_evaluacion where id_docente_categoria_evaluacion in (
    SELECT d.idDocenteCategoriaEvaluacion FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion](31,16,10,
                                                                                                          442,54,'CONCURSOMERITOPOSTGRADO') as d
    where d.codigoCategoriaEvaluacionPadre <>'REQUISITOS')


SELECT d.* FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion](31,16,10,
                                                                           442,54,'CONCURSOMERITOPOSTGRADO') as d

select u.* from man.personas p
                    inner join seg.usuarios u on p.id = u.persona_id
where p.apellidos like '%benavides rodríguez%'

select * from pro.proceso_usuario2 where usuario_ing ='2400254286'

SELECT * FROM PRO.proceso_calendario

select * from pro.postulacion_vacante where usuario_ing ='0908374416'
-- 26/10/1743/54
select * from [pro].[fn_get_all_calificaciones_by_etapa_evaluacion](26 ,1743,'FASEMERITOS',10)

select * from aca.tipo_matricula_fecha


select top 2 * from pro.proceso_usuario2
order by id_proceso_usuario desc
select * from pro.etapa e where e.codigo ='FASEMERITOS'

select pe.*
--     pc.id_proceso_calendario, pe.id_proceso_etapa,ep.id_etapa,ep.descripcion,e.descripcion,pc.fecha_desde,pc.fecha_hasta
from pro.proceso p
         inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
         inner join pro.etapa e on e.id_etapa = pe.id_etapa
         left join pro.etapa ep on ep.id_etapa = pe.id_etapa_padre
-- inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
where p.id_proceso = 10

select * from pro.proceso

select pc.id_proceso_calendario,pe.id_proceso_etapa,ep.id_etapa,ep.descripcion,e.descripcion,pc.fecha_desde,pc.fecha_hasta from pro.proceso p
                                                                                                                                    inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
                                                                                                                                    inner join pro.etapa e on e.id_etapa = pe.id_etapa
                                                                                                                                    inner join pro.etapa ep on ep.id_etapa = pe.id_etapa_padre
                                                                                                                                    inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
where p.id_proceso = 9

-- 0924470529 TALLER DE DISEÑO DE PROYECTO DE INVESTIGACION
--0802969105 AUDITORIA FINANCIERA PUCHA MEDINA PAOLA MARTINA



select p.id,p.apellidos,p.nombres,u.id as id_usuario, u.usuario from man.personas p
                                                                         inner join seg.usuarios u on p.id = u.persona_id
where p.identificacion in ('0924470529','0802969105')

select p.identificacion,p.apellidos,p.nombres from man.personas p where p.identificacion in ('0924470529','0802969105')

select v.*
--pg.id_proceso_general,pg.id_proceso,pu2.usuario_ing,o.descripcion,v.asignatura,p.nombres,p.apellidos,
--        pu2.estado,pej.id_proceso_etapa_ejecucion,pej.estado,e.descripcion,pv.estado,pva.estado,v.estado
from pro.proceso_usuario2 pu2
         inner join man.personas p on pu2.id_persona = p.id
         inner join pro.proceso_general pg on pu2.id_proceso_general = pg.id_proceso_general
         inner join pro.postulacion_vacante pv on pu2.id_proceso_usuario = pv.id_proceso_usuario
         inner join pro.proceso_vacante pva on pva.id_proceso_vacante= pv.id_proceso_vacante
         inner join pro.vacante v on pva.id_vacante = v.id_vacante
         inner join aca.oferta  o on v.id_oferta = o.id_oferta
         inner join pro.proceso_etapa_ejecucion2 pej on pu2.id_proceso_usuario = pej.id_proceso_usuario
         inner join pro.proceso_etapa pe on pej.id_proceso_etapa = pe.id_proceso_etapa
         inner join pro.etapa e on pe.id_etapa = e.id_etapa
where pu2.usuario_ing in ('0924470529','0802969105') and pg.id_proceso = 10



select p.id_proceso,p.descripcion,pu2.id_proceso_usuario,pu2.estado,pv.id_postulacion_vacante,pv.estado,pee2.id_proceso_etapa_ejecucion,pee2.estado,
       eer2.id_etapa_ejecucion_responsable,eer2.estado,v.id_vacante,pva.id_proceso_vacante,v.descripcion
from pro.proceso_usuario2 pu2
         inner join pro.postulacion_vacante pv on pu2.id_proceso_usuario = pv.id_proceso_usuario
         inner join pro.proceso_vacante pva on pva.id_proceso_vacante = pv.id_proceso_vacante
         inner join pro.vacante v on v.id_vacante = pva.id_vacante
         inner join pro.proceso_general pg on pu2.id_proceso_general = pg.id_proceso_general
         inner join pro.proceso p on pg.id_proceso = p.id_proceso
         inner join pro.proceso_etapa_ejecucion2 pee2 on pu2.id_proceso_usuario = pee2.id_proceso_usuario
         inner join pro.proceso_etapa pee on pee2.id_proceso_etapa = pee.id_proceso_etapa
         inner join pro.etapa_ejecucion_responsable2 eer2  on pee2.id_proceso_etapa_ejecucion = eer2.id_proceso_etapa_ejecucion
         inner join pro.etapa e on e.id_etapa = pee.id_etapa
where pu2.usuario_ing in ('0924470529') and p.id_proceso in (10,24)

SELECT * FROM pro.fn_list_postulaciones_concursos_merito(31,null,null,
                                                         null,null,null,null,'CONCURSOMERITOPOSTGRADO') as d
where d.idPersona in (539,798)



SELECT d.idProcesoUsuario,d.identificacion,d.postulante,d.carrera,d.asignatura FROM pro.fn_list_postulaciones_concursos_merito(31,null,null,
                                                                                                                               null,null,null,null,'CONCURSOMERITOPOSTGRADO') as d
where d.idPersona in (539,798)

select * from [pro].[fn_rpt_rubricas_evaluaciones_etapa_oposicion] (31, 18,  10 , 893 , 55)

SELECT * FROM pro.fn_list_all_responsables_by_etapa_proceso_rpt_firmas(55 , 893) as d

select * from pro.etapa_ejecucion_responsable2 where id_persona = 338

select id,identificacion,apellidos,nombres from man.personas where apellidos LIKE '%GARCIA MENDOZA%' AND id = 13188

select id,identificacion,apellidos,nombres from man.personas where apellidos LIKE '%santos reyes%'

select --p.descripcion,e.descripcion,pee2.id_proceso_etapa,
       eer2.*
-- UPDATE  eer2 set rol ='DIRECTOR DEL INSTITUTO DE POSTGRADO'
from pro.proceso_etapa_ejecucion2 pee2
         inner join pro.proceso_etapa pee on pee2.id_proceso_etapa = pee.id_proceso_etapa
         inner join pro.etapa_ejecucion_responsable2 eer2  on pee2.id_proceso_etapa_ejecucion = eer2.id_proceso_etapa_ejecucion
         inner join pro.etapa e on e.id_etapa = pee.id_etapa
         inner join pro.proceso p on p.id_proceso = pee.id_proceso
where eer2.id_persona = 1081 and
    pee.id_proceso_etapa = 55 AND pee2.estado='A'





select * from pro.proceso_general where id_proceso = 1

select * from [pro].[fn_list_all_rubricas_evaluaciones_procesos](31,'CONCURSOMERITOPOSTGRADO'
                  ,16,null) as d


-- volver aca
select * from pro.proceso_calendario where id_proceso_general = 49

select edc.* from pro.proceso_calendario pc
         left join pro.etapa_docente_categoria edc on pc.id_proceso_calendario = edc.id_proceso_calendario
         where id_proceso_general = 63


select * from pro.proceso_vacante where id_proceso_general = 63

select pv.id_proceso_vacante,v.*
--     UPDATE V SET v.codigo =upper(v.codigo),v.descripcion =Upper(v.descripcion),v.asignatura =upper(v.asignatura)
--              , v.funciones =upper(v.funciones),v.titulo_cuarto_nivel=upper(v.titulo_cuarto_nivel),v.titulo_tercer_nivel = UPPER(v.titulo_tercer_nivel)
from pro.proceso_vacante pv
         inner join pro.vacante v on pv.id_vacante = v.id_vacante
         where pv.id_proceso_general = 63

select * from pro.proceso


select --pc.id_proceso_calendario,e.descripcion,e.codigo,
       ev.* from pro.proceso p
 inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
 inner join pro.etapa e on e.id_etapa = pe.id_etapa
 inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
 inner join pro.etapa_evaluaciones ev on ev.id_proceso_calendario = pc.id_proceso_calendario
where pc.id_proceso_general = 63

select --pc.id_proceso_calendario,e.descripcion,e.codigo,
       edc.* from pro.proceso p
 inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
 inner join pro.etapa e on e.id_etapa = pe.id_etapa
 inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
 inner join pro.etapa_evaluaciones ev on ev.id_proceso_calendario = pc.id_proceso_calendario
inner join pro.evaluaciones_docente_categoria edc on ev.id_etapa_evaluacion = edc.id_etapa_evaluacion
where pc.id_proceso_general = 87

select --pc.id_proceso_calendario,e.descripcion,e.codigo,
       pc.*
       from pro.proceso p
                      inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
                      inner join pro.etapa e on e.id_etapa = pe.id_etapa
                      inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
where pc.id_proceso_general = 63

select * from pro.proceso_general


select eee.id_etapa_docente_categoria,e.descripcion,dc.descripcion,pc.id_proceso_calendario,ev.id_evaluacion_rubrica,edc.ponderacion,edc.puntaje_maximo,edc.es_ponderable,edc.estado,edc.version,
      edc.fecha_ing,edc.fecha_mod,edc.usuario_ing,edc.usuario_mod from pro.evaluaciones_docente_categoria edc
inner join pro.etapa_evaluaciones ev on edc.id_etapa_evaluacion = ev.id_etapa_evaluacion
inner join pro.proceso_calendario pc on ev.id_proceso_calendario = pc.id_proceso_calendario
inner join pro.proceso_etapa pe on pc.id_proceso_etapa = pe.id_proceso_etapa
inner join pro.etapa e on pe.id_etapa = e.id_etapa
inner join pro.etapa_docente_categoria eee on eee.id_proceso_calendario = pc.id_proceso_calendario and eee.id_docente_categoria=edc.id_docente_categoria
inner join aca.docente_categoria dc on edc.id_docente_categoria = dc.id_docente_categoria


select * from pro.etapa_evaluaciones ev
select * from pro.evaluaciones_docente_categoria edc
-- left join

select * from pro.proceso_usuario2 where usuario_ing='0925759367'

select * from pro.postulacion_vacante where id_proceso_usuario = 5317

select * from pro.proceso_etapa_ejecucion2 where id_proceso_usuario = 5314

insert into pro.etapa_ejecucion_responsable2 ( id_proceso_etapa_ejecucion, id_persona,
                                          observacion, culminado, principal, puede_calificar, estado, version,
                                          fecha_ing, fecha_mod, usuario_ing, usuario_mod, rol, orden)
            values( 8946, 323,     null, 0, null, null, 'A', 0,
                                          GETDATE() , GETDATE(), '2400254286', '2400254286', null, null);

select * from pro.postulacion_vacante where id_proceso_usuario = 5314

select * from [pro].[fn_list_postulaciones_concursos_merito_upse](63,null,null,null,
                                                                  null,664,null) as d

--no requisitos minimos
select * from [pro].[fn_list_evaluaciones_by_process_and_proceso_usuario](63,10,664)
--50226 no nota minima
select * from [pro].[fn_list_evaluaciones_by_process_and_proceso_usuario](63,10,50226)
--35238 pasa a oposicion
select * from [pro].[fn_list_evaluaciones_by_process_and_proceso_usuario](63,10,35238)


SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_to_evaluar2](95,49,10,
                                                                                     'REQUISITOS',5314,
                                                                                     1,'CONCURSOMERITO')

SELECT* FROM        [pro].[fn_list_all_rubricas_evaluaciones_procesos] (95,'CONCURSOMERITO',49,NULL)

SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion](95,49,10,
                                                                         5314,1,'CONCURSOMERITO')

select *
--     d.idEvaluacionRequisito, d.idTipoEvaluacion,d.tipoEvaluacion,d.idEtapaEvaluacion,d.modalidad,d.codigoCategoriaEvaluacionPadre,
--             d.categoriaEvaluacionPadre,d.colorCategoriaEvaluacionPadre,d.idTipoCategoriaEvaluacion,d.categoriaEvaluacion,d.colorCategoriaEvaluacion,
--             d.idEvaluacionRequisito,
--             dc.descripcion as categoria_docente,dce.descripcion_requisito,dce.indicaciones_item,
--             iif(dce.es_general is null,'NO APLICA',iif(dce.es_general=1,'GENERAL','ESPECÍFICO')) AS general ,
--             pr.id_proceso_requisito,td.id_tipo_documento,td.abreviatura,ta.descripcion,dce.id_docente_categoria_evaluacion,
--             ejr.id_etapa_ejecucion_responsable,eed.id_etapa_ejecucion_documento,eed.file_name,eed.upload_url, 0 as requisito_minimo
            from [pro].[fn_list_all_rubricas_evaluaciones_procesos]
                (95,'CONCURSOMERITO',49,null) as d
            inner join pro.evaluaciones_docente_categoria evdc on d.idEtapaEvaluacion = evdc.id_etapa_evaluacion
            inner join pro.etapa_docente_categoria edc on edc.id_proceso_calendario = d.idProcesoCalendario
            inner join aca.docente_categoria dc on dc.id_docente_categoria = edc.id_docente_categoria and evdc.id_docente_categoria = dc.id_docente_categoria
            inner join pro.docente_categoria_evaluacion dce on dce.id_evaluacion_requisito = d.idEvaluacionRequisito and dc.id_docente_categoria = dce.id_docente_categoria
            inner join pro.proceso_requisito pr on pr.id_proceso_requisito = d.idProcesoRequisito
            left join  aca.tipo_documento td on td.id_tipo_documento = pr.id_tipo_documento
            inner join aca.tipo_archivo ta on ta.id_tipo_archivo = pr.id_tipo_archivo
            inner join pro.proceso_usuario2 pu on pu.id_proceso_general = d.idProcesoGeneral
            inner join pro.postulacion_vacante pv on pv.id_proceso_usuario = pu.id_proceso_usuario
            inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario
            inner join pro.etapa_ejecucion_responsable2 ejr on ejr.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion
            left join pro.etapa_ejecucion_documento2 eed on eed.id_etapa_ejecucion_responsable = ejr.id_etapa_ejecucion_responsable
                                                                and eed.id_docente_categoria_evaluacion =dce.id_docente_categoria_evaluacion  and eed.estado='A'
            where dc.id_docente_categoria = 10 and pej.id_proceso_etapa = 1
            and edc.estado='A' and dc.estado='A' and evdc.estado='A' and dce.estado='A' and ejr.estado='A' and pu.id_proceso_usuario = 5314
            order by dce.orden



SELECT *  from seg.usuarios where usuario ='2400254286'


begin
select *
                    from pro.proceso_usuario2 pu2
                    inner join pro.proceso_etapa_ejecucion2 pee
                    on pee.id_proceso_usuario = pu2.id_proceso_usuario --and pee.id_proceso_etapa = 54
                    inner join pro.proceso_etapa pe on pee.id_proceso_etapa = pe.id_proceso_etapa
                    inner join pro.etapa e on pe.id_etapa = e.id_etapa
                    --             and pee.calificacion is not null
                    inner join pro.tipo_proceso_estado tpe
                    on tpe.id_tipo_proceso_estado = pu2.id_tipo_proceso_estado
                    inner join pro.postulacion_vacante pv on pu2.id_proceso_usuario = pv.id_proceso_usuario
                    inner join pro.proceso_general pg on pu2.id_proceso_general = pg.id_proceso_general
                    inner join pro.proceso p on pg.id_proceso = p.id_proceso
                    inner join pro.tipo_proceso tp on tp.id_tipo_proceso = p.id_tipo_proceso
                    inner join man.personas per on pu2.id_persona = per.id
                    inner join seg.usuarios u on u.persona_id = per.id
--                     inner join pro.proceso_vacante prov on prov.id_proceso_vacante = pv.id_proceso_vacante
--                     inner join pro.vacante v on prov.id_vacante = v.id_vacante
--                     inner join aca.oferta o on v.id_oferta = o.id_oferta
--                     inner join aca.departamento_oferta dof on dof.id_oferta = o.id_oferta
--                     inner join man.departamentos d on dof.id_departamento = d.id
--                     inner join pro.vacante_asignatura va on v.id_vacante = va.id_vacante
--                     inner join aca.malla_asignatura ma on va.id_malla_asignatura = ma.id_malla_asignatura
--                     inner join aca.modalidad_asignatura modA
--                     on modA.id_modalidad_asignatura = ma.id_modalidad_asignatura
--                     inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
--                     inner join aca.nivel n on ma.id_nivel = n.id_nivel
--                     inner join aca.docente_categoria dc on v.id_docente_categoria = dc.id_docente_categoria
--                     inner join aca.docente_dedicacion dd on v.id_docente_dedicacion = dd.id_docente_dedicacion
                    where pu2.estado = 'A' and pv.estado = 'A' and pg.estado = 'A'
--                       and p.estado = 'A'
--                       and per.estado = 'AC'
--                       and prov.estado = 'A'
-- --                       and modA.estado = 'A'
--                       and v.estado = 'A'
--                       and o.estado = 'A'
--                       and u.estado = 'AC'
--                       and prov.estado = 'A'
--                       and e.codigo in ('SUBIDADOCUMENTOENTREGA', 'POSTULACION')
--             and (tp.codigo=@codigoProceso or @codigoProceso is null)
--                       AND va.estado = 'A'
                      and (pg.id_proceso_general = 63 or 63 is null)
                      and (u.id = 664 or 664 is null)
--                     order by d.nombre, o.descripcion, v.descripcion, per.apellidos, per.nombres, pu2.fecha_ing
end

select pg.id_periodo_academico,pc.id_proceso_general,ev.id_etapa_evaluacion,pe.id_proceso_etapa,ev.id_evaluacion_rubrica,e.descripcion from pro.proceso p
inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
inner join pro.etapa e on e.id_etapa = pe.id_etapa
inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
inner join pro.proceso_general pg on p.id_proceso = pg.id_proceso and pg.id_proceso_general = pc.id_proceso_general
inner join pro.etapa_evaluaciones ev on ev.id_proceso_calendario = pc.id_proceso_calendario
where p.id_proceso = 10

select * from man.opciones where codigo ='REGISTRO-ASPIRANTE'

SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_to_evaluar2](31,16,10,
                                                                                     'REQUISITOS',1581,55,'CONCURSOMERITOPOSTGRADO')


select * from [pro].[fn_list_all_rubricas_evaluaciones_procesos]
              (31,'CONCURSOMERITOPOSTGRADO',16,null) as d

select --pu.id_proceso_usuario,
       ejr.*
from pro.proceso_usuario2 pu
         inner join pro.proceso_general pg on pg.id_proceso_general = pu.id_proceso_general
         inner join pro.proceso p on pg.id_proceso = p.id_proceso
         inner join pro.tipo_proceso tp on p.id_tipo_proceso = tp.id_tipo_proceso
         inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario
         inner join pro.proceso_etapa pe on pej.id_proceso_etapa = pe.id_proceso_etapa
         inner join pro.etapa e on pe.id_etapa = e.id_etapa
         inner join pro.etapa_ejecucion_responsable2 ejr on ejr.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion
where pu.estado='A' and pej.estado='A' and ejr.estado='A' --and ejr.id_persona= 1271
  and p.id_proceso = 10 and pu.id_proceso_usuario = 1460

select * from man.personas where apellidos like '%VELEZ GARCIA%'
-- 13188
select * from man.personas where apellidos like '%GARCIA MENDOZA%'

--listado de resultados finales de postgrados
select
--     pee.*
d.periodoAcademico,d.proceso,d.id_proceso_usuario,d.nombre,d.descripcion,d.asignatura,d.categoriaDocente,d.identificacion,d.postulante,d.email,d.calificacionMerito
from (
         select pa.codigo as periodoAcademico,pr.descripcion as proceso,d.nombre,o.descripcion,UPPER(v.asignatura)as  asignatura,dc.descripcion as categoriaDocente,p.id,p.identificacion,UPPER(concat(p.apellidos,' ',p.nombres)) as postulante,
                pu.id_proceso_usuario,iif(p.email_institucional is null or p.email_institucional='',email_personal,email_institucional) as email,v.id_docente_categoria,
                isnull([pro].[fn_sca_get_calificacion_by_evaluacion](pejMerito.id_proceso_etapa,pu.id_proceso_usuario),0) as calificacionMerito
         from pro.proceso_usuario2 pu
                  inner join pro.proceso_general  pg on pg.id_proceso_general =  pu.id_proceso_general
                  inner join aca.periodo_academico pa on pg.id_periodo_academico = pa.id_periodo_academico
                  inner join pro.proceso pr on pg.id_proceso = pr.id_proceso
                  inner join pro.tipo_proceso tp on pr.id_tipo_proceso = tp.id_tipo_proceso
                  inner join pro.tipo_proceso_estado tpe on pu.id_tipo_proceso_estado = tpe.id_tipo_proceso_estado
                  inner join man.personas p on p.id = pu.id_persona
                  inner join pro.postulacion_vacante pv on pv.id_proceso_usuario = pu.id_proceso_usuario
                  inner join pro.proceso_vacante prv on prv.id_proceso_vacante = pv.id_proceso_vacante
                  inner join pro.vacante v on v.id_vacante = prv.id_vacante
                  inner join aca.docente_categoria dc on dc.id_docente_categoria = v.id_docente_categoria
                  inner join aca.oferta o on o.id_oferta = v.id_oferta
                  inner join aca.departamento_oferta dof on dof.id_oferta = o.id_oferta
                  inner join man.departamentos d on dof.id_departamento = d.id
                  inner join pro.proceso_etapa_ejecucion2 pejMerito on pejMerito.id_proceso_usuario = pu.id_proceso_usuario and pejMerito.estado='A' and pejMerito.id_proceso_etapa  in (55,109)
         where  pu.estado='A' and pv.estado='A' and prv.estado='A' and v.estado='A' and tp.codigo ='CONCURSOMERITOPOSTGRADO'
         group by pa.codigo,d.nombre,o.descripcion,v.asignatura,p.id,p.identificacion,p.apellidos,p.nombres,pu.id_proceso_usuario,v.id_docente_categoria,tpe.codigo
                ,pejMerito.id_proceso_etapa_ejecucion,p.email_institucional,email_personal,dc.descripcion,pejMerito.calificacion,pejMerito.id_proceso_etapa,pr.descripcion
-- order by d.nombre,o.descripcion,v.asignatura,p.apellidos,p.nombres
     ) as d
         inner join pro.proceso_etapa_ejecucion2 pee on pee.id_proceso_usuario = d.id_proceso_usuario
where pee.id_proceso_etapa in (55,109)
-- d.calificacion>=35
--     and d.calificacion <>d.calificacionMerito
-- and
order by d.proceso,d.periodoAcademico,d.nombre,d.descripcion,d.asignatura,d.postulante

select * from pro.tipo_proceso


select  --p.id_proceso,p.codigo,p.descripcion,pe.id_proceso_etapa,e.descripcion
        pc.*
from pro.proceso p
         inner join pro.tipo_proceso tp on p.id_tipo_proceso = tp.id_tipo_proceso
         inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
         inner join pro.etapa e on pe.id_etapa = e.id_etapa
         INNER join pro.proceso_calendario pc on pe.id_proceso_etapa = pc.id_proceso_etapa
where p.estado='A'
  and p.id_proceso in (10,24) and pe.id_proceso_etapa in (54,108)

select top 20 * from pro.etapa_ejecucion_documento2
order by id_etapa_ejecucion_documento desc

-- UPDATE pro.proceso_general SET id_periodo_academico = 42 WHERE id_proceso_general = 23




select * from  [pro].[fn_list_all_postulaciones_concursos_merito](35,null,null,null,
                                                                  null,null,null,'SELCOORDINADORPOSTGRADOS',null)

select * from  [pro].fn_list_all_rubricas_evaluaciones_by_clasificacion_to_evaluar2(35,28,null,
                                                                                    'REQUISITOS',2471,116,'SELCOORDINADORPOSTGRADOS')

SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_evaluadores](35,29,null,
                                                                                     'MERITOSsss',2471,116,14403,
                                                                                     'SELCOORDINADORPOSTGRADOS')

SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_evaluadores](35,29,null,
                                                                                     'MERITOSsss',2489,116,14403,'SELCOORDINADORPOSTGRADOS')

select * from pro.requisito_valor
select * from [pro].[fn_rpt_acta_resultados_finales] ( 27, 7, 332 , 39 )
SELECT * FROM [pro].[fn_list_all_responsables_by_etapa_proceso_rpt_firmas](40, 332) as d


select * from 	 pro.fn_list_all_postulaciones_concursos_merito (9,null,null,null,
                                                        null,null,332,'MERITOYOPOSICIONTUTILAR',40) as d

select * from [pro].[fn_rpt_rubricas_evaluaciones_etapa] (27 , 11 ,  7,
                                                          'MERITOSsss' ,  341  , 40 ,'ACTAMERITOS')

select * from  pro.docente_categoria_evaluacion_relacion


select * from pro.etapa_evaluaciones



select pee.* from pro.etapa_ejecucion_requisito2 eer2
                      inner join pro.etapa_ejecucion_responsable2 eer on eer.id_etapa_ejecucion_responsable = eer2.id_etapa_ejecucion_responsable
                      inner join pro.proceso_etapa_ejecucion2 pee on eer.id_proceso_etapa_ejecucion = pee.id_proceso_etapa_ejecucion
where eer2.id_etapa_ejecucion_responsable = 8845

select * from pro.etapa_ejecucion_documento2 where id_etapa_ejecucion_responsable = 8874

select top 2* from pro.etapa_ejecucion_requisito2
order by id_etapa_ejecucion_requisito desc

--listado de resultados finales de postgrados
-- update pee
--     set pee.calificacion = d.calificacionMerito
select
--     pee.*
d.periodoAcademico,d.proceso,d.id_proceso_usuario,d.nombre,d.asignatura,d.identificacion,d.postulante,d.email,d.calificacionMerito
from (
         select pa.codigo as periodoAcademico,pr.descripcion as proceso,d.nombre,UPPER(v.asignatura)as  asignatura,p.id,p.identificacion,UPPER(concat(p.apellidos,' ',p.nombres)) as postulante,
                pu.id_proceso_usuario,iif(p.email_institucional is null or p.email_institucional='',email_personal,email_institucional) as email,v.id_docente_categoria,
                isnull([pro].[fn_sca_get_calificacion_by_evaluacion](2,pu.id_proceso_usuario),0) as calificacionMerito
         from pro.proceso_usuario2 pu
                  inner join pro.proceso_general  pg on pg.id_proceso_general =  pu.id_proceso_general
                  inner join aca.periodo_academico pa on pg.id_periodo_academico = pa.id_periodo_academico
                  inner join pro.proceso pr on pg.id_proceso = pr.id_proceso
                  inner join pro.tipo_proceso tp on pr.id_tipo_proceso = tp.id_tipo_proceso
-- inner join pro.tipo_proceso_estado tpe on pu.id_tipo_proceso_estado = tpe.id_tipo_proceso_estado
                  inner join man.personas p on p.id = pu.id_persona
                  inner join pro.postulacion_vacante pv on pv.id_proceso_usuario = pu.id_proceso_usuario
                  inner join pro.proceso_vacante prv on prv.id_proceso_vacante = pv.id_proceso_vacante
                  inner join pro.vacante v on v.id_vacante = prv.id_vacante
                  inner join man.departamentos d on v.id_facultad = d.id
                  inner join pro.proceso_etapa_ejecucion2 pejMerito on pejMerito.id_proceso_usuario = pu.id_proceso_usuario
         where  pu.estado='A' and pv.estado='A' and prv.estado='A' and v.estado='A' and pg.id_proceso_general = 25
           and pejMerito.estado='A' and pejMerito.id_proceso_etapa  in (2)
         group by pa.codigo,d.nombre,v.asignatura,p.id,p.identificacion,p.apellidos,p.nombres,pu.id_proceso_usuario,v.id_docente_categoria--,tpe.codigo
                ,pejMerito.id_proceso_etapa_ejecucion,p.email_institucional,email_personal,pejMerito.calificacion,pejMerito.id_proceso_etapa,pr.descripcion
-- order by d.nombre,o.descripcion,v.asignatura,p.apellidos,p.nombres
     ) as d
-- inner join pro.proceso_etapa_ejecucion2 pee on pee.id_proceso_usuario = d.id_proceso_usuario
-- where
order by d.proceso,d.periodoAcademico,d.nombre,d.asignatura,d.postulante

-- --listado de resultados finales de pregrado
declare @id_proceso_etapa int = 1
-- update pee
--     set pee.calificacion = 0 --round(d.calificacionMerito,0)
update pu2
set pu2.id_tipo_proceso_estado = 8--iif(d.calificacion>=42,10,9)
-- select
-- d.periodoAcademico,d.proceso,d.id_proceso_usuario,d.nombre,d.asignatura,d.identificacion,d.postulante,d.email,d.calificacionMerito,d.calificacion
from (
         select pa.codigo as periodoAcademico,pr.descripcion as proceso,d.nombre,UPPER(v.asignatura)as  asignatura,p.id,p.identificacion,UPPER(concat(p.apellidos,' ',p.nombres)) as postulante,
                pu.id_proceso_usuario,iif(p.email_institucional is null or p.email_institucional='',email_personal,email_institucional) as email,v.id_docente_categoria,
                isnull([pro].[fn_sca_get_calificacion_by_evaluacion](@id_proceso_etapa,pu.id_proceso_usuario),0) as calificacionMerito,pej.calificacion
         from pro.proceso_usuario2 pu
                  inner join pro.proceso_general  pg on pg.id_proceso_general =  pu.id_proceso_general
                  inner join aca.periodo_academico pa on pg.id_periodo_academico = pa.id_periodo_academico
                  inner join pro.proceso pr on pg.id_proceso = pr.id_proceso
                  inner join pro.tipo_proceso tp on pr.id_tipo_proceso = tp.id_tipo_proceso
                  inner join pro.tipo_proceso_estado tpe on pu.id_tipo_proceso_estado = tpe.id_tipo_proceso_estado
                  inner join man.personas p on p.id = pu.id_persona
                  inner join pro.postulacion_vacante pv on pv.id_proceso_usuario = pu.id_proceso_usuario
                  inner join pro.proceso_vacante prv on prv.id_proceso_vacante = pv.id_proceso_vacante
                  inner join pro.vacante v on v.id_vacante = prv.id_vacante
                  inner join aca.docente_categoria dd on dd.id_docente_categoria = v.id_docente_categoria
                  inner join aca.oferta o on o.id_oferta = v.id_oferta
                  inner join aca.departamento_oferta dof on dof.id_oferta = o.id_oferta
                  inner join man.departamentos d on dof.id_departamento = d.id
                  inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario
         where  pu.estado='A' and pv.estado='A' and prv.estado='A' and v.estado='A' and pg.id_proceso_general = 25
           and pej.estado='A' and pej.id_proceso_etapa  in (@id_proceso_etapa) and pej.id_proceso_usuario not in (select pu3.id_proceso_usuario from pro.proceso_usuario2 pu3
                                                                                                                                                         inner join pro.proceso_etapa_ejecucion2 pee3 on pu3.id_proceso_usuario = pee3.id_proceso_usuario
                                                                                                                  where pu3.estado='A' and pee3.estado='A' and pee3.id_proceso_etapa = 2 and pu3.id_proceso_general = 25)
         group by pa.codigo,d.nombre,v.asignatura,p.id,p.identificacion,p.apellidos,p.nombres,pu.id_proceso_usuario,v.id_docente_categoria,tpe.codigo
                ,pej.id_proceso_etapa_ejecucion,p.email_institucional,email_personal,pej.calificacion,pej.id_proceso_etapa,pr.descripcion
-- order by d.nombre,o.descripcion,v.asignatura,p.apellidos,p.nombres
     ) as d
         inner join pro.proceso_etapa_ejecucion2 pee on pee.id_proceso_usuario = d.id_proceso_usuario  and pee.id_proceso_etapa  in (@id_proceso_etapa)
         inner join pro.proceso_usuario2 pu2  on pee.id_proceso_usuario = pu2.id_proceso_usuario
-- where
-- order by d.proceso,d.periodoAcademico,d.nombre,d.asignatura,d.postulante

SELECT * FROM pro.fn_list_all_postulaciones_concursos_merito(96,null,null,10,
                                                             null,null,null,'CONCURSOMERITO',1) as d
-- where d.identificacion ='1754116802'


select * from pro.tipo_proceso_estado
select * from pro.proceso_general where id_proceso = 1
select * from  [pro].[fn_list_postulantes_to_notificate_CMO](15,1,29)
select* from aca.ofertas_facultad where id_tipo_oferta =2
select *  from pro.proceso_calendario where id_proceso_calendario in (129)

 select *   from aca.fn_recuperar_datos_estudiante_logeado (664)

select * from seg.usuarios where usuario='0912350485'
select * from [pro].[fn_list_postulaciones_concursos_merito_upse](25,null,null,null,
                                                                  null,865,null) as d

select * from [pro].[fn_list_evaluaciones_by_process](25,10,2)

select * from pro.proceso_calendario where id_proceso_general = 25 and id_proceso_etapa =2


select d.*  from [aca].[fn_silabo](678,35)  as d


select * from aca.silabo where id_silabo = 4029

select top 10 * from aca.silabo
order by id_silabo desc

select * from aca.periodo_componente_aprendizaje

select * from aca.periodo_academico_oferta pao
where pao.id_periodo_academico =37 and estado='A'

select * from aca.periodo_academico

select * from [pro].[fn_rpt_acta_resultados_finales] (35,  10, 2938 , 5)

select * from [pro].[fn_list_all_postulaciones_concursos_merito](95,9,105,10,
null,null,null,'CONCURSOMERITO',1) as d

select * from [pro].[fn_list_all_postulaciones_concursos_merito](35,8,20,10,
                                                                 null,null,null,'CONCURSOMERITO',5) as d

SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_evaluadores](35,33,10,
                                                                                     'MERITOSss',2778,1,
                                                                                     14399,'CONCURSOMERITO')
--1076
select res.*
--     p.id,p.identificacion,p.apellidos,p.nombres
from pro.etapa_ejecucion_responsable2  res
         inner join pro.proceso_etapa_ejecucion2 pee on res.id_proceso_etapa_ejecucion = pee.id_proceso_etapa_ejecucion
         inner join man.personas p on res.id_persona = p.id
where res.id_persona = 1076
  and pee.id_proceso_usuario in (2646,2778,3045,2895,2614,2717,2834,3032,2698,2777,2629,2973,2703,2840,2507,2940,3031,2977,2687,2677

    )

select * from man.personas where identificacion ='0915460240'


select * from [pro].[fn_acta_consolidada_concurso] (25,9,105)

select decano from [cat].[fn_obtener_director_y_decano_por_id_oferta](105)
select * from [aca].[fn_obtener_autoridades_by_id_oferta](105)



select * from tmp.persona_proyectos

select * from pro.postulacion_vacante where usuario_ing='1754116802'

select * from seg.usuarios where usuario ='0922018726'
--    {bcrypt}$2a$10$VmnHef7shjzizQ/dEfYF0ueKmjE/KjIeMxUMRtkyEW8q3aM4jYrGS

select  concat('{MD5}',Bd_Academico.[dbo].[fn_Md5]('0922018726'))

select * from pro.proceso_general

SELECT * FROM [tmp].[fn_rpt_informe_tecnico_docente](33713)

exec [aca].[sp_list_all_carreras_records]  '2400247876' ,null, null , null, null

exec [aca].[sp_list_all_asignaturas_detalle_record] 51214,null,null,
     null,null,null,null

select * from pro.etapa_ejecucion_horario

select * from pro.proceso_etapa_ejecucion

select * from pro.vacante_cronograma_etapa

select * from pro.proceso_etapa where es_precencial is not null

select * from pro.proceso where id_proceso = 11

select * from pro.evaluacion_rubrica

select * from man.persona_identificacion


select pv.id_proceso_vacante,v.* from pro.proceso_vacante pv
inner join pro.vacante v on pv.id_vacante = v.id_vacante
where id_proceso_general = 70


select distinct ru.* from man.personas p
         inner join seg.usuarios  u on p.id = u.persona_id
         inner join seg.roles_usuarios ru on u.id = ru.usuario_id
--                      inner join seg.roles_usuario_oferta rou on ru.id = rou.rol_usuario_id
         where p.identificacion in ('0962537130','135684807','1356848')


select * from man.personas where apellidos like '%llerena guevara%'

select * from man.persona_identificacion

select * from pro.proceso

select * from pro.proceso_general where id_proceso in (1)

select * from pro.proceso_calendario where id_proceso_general = 25

select * from pro.proceso_calendario where id_proceso_general = 49

select * from pro.tipo_evaluaciones

select * from pro.evaluacion_rubrica where id_evaluacion_rubrica in (11,13,15)


select * from aca.tipo_estado_estudiante

select * from aca.periodo_academico where id_tipo_oferta = 2

select * from pro.tipo_proceso

select * from pro.proceso p
                  inner join pro.tipo_proceso tp on p.id_tipo_proceso = tp.id_tipo_proceso
                  inner join pro.proceso_general pg on p.id_proceso = pg.id_proceso
where pg.id_proceso_general in (48) and tp.codigo='CONCURSOMERITO'


select * from [pro].[fn_list_evaluaciones_by_process](49,10,5)

select * from pro.proceso_usuario2 where id_proceso_general = 25 and usuario_ing='2400254286'

select * from pro.proceso_usuario2 where id_proceso_general = 49 and usuario_ing='2400254286'

-- select * from pro.postulacion_vacante pv where id_proceso_usuario = 4554

select * from pro.proceso_etapa_ejecucion2 where id_proceso_usuario in ( 2495,4554)

select eer2.* from pro.proceso_etapa_ejecucion2 pee2
                       inner join pro.etapa_ejecucion_responsable2 eer2 on eer2.id_proceso_etapa_ejecucion = pee2.id_proceso_etapa_ejecucion
where id_proceso_usuario in (2496, 4554)

select * from man.personas where id = 5416




select * from pro.proceso

select * from [pro].[fn_list_all_facultades_by_process_and_periodo_academico](49,10)

SELECT * FROM pro.fn_list_postulaciones_concursos_merito(26,null,null,null,
                                                         null,664,null,'CONCURSOMERITO')


SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_to_evaluar2](36,45,10,
                                                                                     'REQUISITOS',4554,1,'CONCURSOMERITO')

SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion](36,45,10,
                                                                         4554,1,'CONCURSOMERITO')

select * from [pro].[fn_list_all_rubricas_evaluaciones_procesos]
              (36,'CONCURSOMERITO',45,null) as d
--176
select distinct pe.identificacion,pe.apellidos, pe.nombres, dc1.codigo, isnull(dc.observacion,'S/N') as observacion, dc.fecha_desde,
                (select count(*) from tmp.consolidado_concurso_docente c where c.id_persona = pe.id) as numero_participaciones_concurso,
                (select top 1 c.periodo_academico from tmp.consolidado_concurso_docente c where c.id_persona = pe.id order by c.periodo_academico desc)   as periodo_concurso,
                (select top 1 c.calificacion from tmp.consolidado_concurso_docente c where c.id_persona = pe.id order by c.periodo_academico desc)   as nota_final,
                (select top 1 c.estado from tmp.consolidado_concurso_docente c where c.id_persona = pe.id order by c.periodo_academico desc)   as detalle_concurso
from aca.periodo_academico pa
         inner join aca.periodo_academico_oferta pao on pa.id_periodo_academico=pao.id_periodo_academico
         inner join aca.distributivo_oferta dof on pao.id_periodo_academico_oferta=dof.id_periodo_academico_oferta
         inner join aca.distributivo_docente do on dof.id_distributivo_oferta=do.id_distributivo_oferta
         inner join aca.docente d on do.id_docente=d.id_docente
         inner join man.personas pe on d.id_persona=pe.id
         inner join aca.docente_historial dc on d.id_docente=dc.id_docente
         inner join aca.docente_categoria dc1 on dc.id_docente_categoria=dc1.id_docente_categoria
where pa.estado='A' and pao.estado='A' and dof.estado in ('A','D','V') and do.estado='A'
  and d.estado='A' and dc.estado='A' and pe.estado='AC'
  and dc.id_docente_historial in(select max(dh.id_docente_historial) from aca.docente_historial dh
                                                                              inner join aca.docente_categoria dca on dh.id_docente_categoria=dca.id_docente_categoria
                                 where dc.id_docente=dh.id_docente and dca.codigo not in ('INVITADO')
)
  AND pa.id_periodo_academico=35 AND dc1.codigo in('CONTRATADO1','CONADMINISTRATIVO','TITADMINISTRATIVO')
order by pe.apellidos, pe.nombres

select * from aca.docente_categoria

select * from pro.proceso_general where id_proceso = 1

begin
    declare @id_proceso_general int = 25,@var_subida_documentacion int = 2,@var_clase_demostrativa int = 5,@var_notificacion int = 5
-- insert into tmp.consolidado_concurso_docente
    select pa.codigo as periodo,pv.id_postulacion_vacante,d.nombre as departamento ,o.descripcion as oferta,UPPER(v.asignatura)as  asignatura,
           dc.descripcion as categoriaDocente,p.id as id_persona,p.identificacion,UPPER(concat(p.apellidos,' ',p.nombres)) as postulante,
           pu.id_proceso_usuario,iif(p.email_institucional is null or p.email_institucional='',email_personal,email_institucional) as email,v.id_docente_categoria,
           isnull([pro].[fn_sca_get_calificacion_by_evaluacion](@var_subida_documentacion,pu.id_proceso_usuario),0) as calificacionMerito,
           isnull([pro].[fn_sca_get_calificacion_by_evaluacion](@var_clase_demostrativa,pu.id_proceso_usuario),0) as calificacionClaseDemostrativa,
           isnull([pro].[fn_sca_get_calificacion_by_evaluacion](@var_subida_documentacion,pu.id_proceso_usuario),0) +
           isnull([pro].[fn_sca_get_calificacion_by_evaluacion](@var_clase_demostrativa,pu.id_proceso_usuario),0) as calificacion,
           case when   (isnull([pro].[fn_sca_get_calificacion_by_evaluacion](@var_subida_documentacion,pu.id_proceso_usuario),0) +
                        isnull([pro].[fn_sca_get_calificacion_by_evaluacion](@var_clase_demostrativa,pu.id_proceso_usuario),0))=0
                    then 'No Cumplió requisitos'
                when (isnull([pro].[fn_sca_get_calificacion_by_evaluacion](@var_subida_documentacion,pu.id_proceso_usuario),0) +
                      isnull([pro].[fn_sca_get_calificacion_by_evaluacion](@var_clase_demostrativa,pu.id_proceso_usuario),0))>=70 then  'Elegible '
                    +CAST (  ROW_NUMBER() OVER (PARTITION BY UPPER(v.asignatura) ORDER BY
                        (isnull([pro].[fn_sca_get_calificacion_by_evaluacion](@var_subida_documentacion,pu.id_proceso_usuario),0) +
                         isnull([pro].[fn_sca_get_calificacion_by_evaluacion](@var_clase_demostrativa,pu.id_proceso_usuario),0)) desc) AS VARCHAR(100))
                else
                    'No cumple puntaje mínimo'
               end  as estado, o.id_oferta
    from pro.proceso_usuario2 pu
             inner join pro.proceso_general pg on pu.id_proceso_general = pg.id_proceso_general
             inner join aca.periodo_academico pa on pg.id_periodo_academico = pa.id_periodo_academico
             inner join pro.tipo_proceso_estado tpe on pu.id_tipo_proceso_estado = tpe.id_tipo_proceso_estado
             inner join man.personas p on p.id = pu.id_persona
             inner join pro.postulacion_vacante pv on pv.id_proceso_usuario = pu.id_proceso_usuario
             inner join pro.proceso_vacante prv on prv.id_proceso_vacante = pv.id_proceso_vacante
             inner join pro.vacante v on v.id_vacante = prv.id_vacante
             inner join aca.docente_categoria dc on dc.id_docente_categoria = v.id_docente_categoria
             inner join aca.oferta o on o.id_oferta = v.id_oferta
             inner join aca.departamento_oferta dof on dof.id_oferta = o.id_oferta
             inner join man.departamentos d on dof.id_departamento = d.id
             inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario
    where  pu.estado='A' and pv.estado='A' and prv.estado='A' and v.estado='A'  and pej.estado='A' and pej.id_proceso_etapa = @var_notificacion--AND P.identificacion ='1756915615'
      and
        pu.id_proceso_general = @id_proceso_general
    group by d.nombre,o.descripcion,v.asignatura,p.id,p.identificacion,p.apellidos,p.nombres,pu.id_proceso_usuario,v.id_docente_categoria,tpe.codigo
           ,pej.id_proceso_etapa_ejecucion,p.email_institucional,email_personal,dc.descripcion, o.id_oferta,pv.id_postulacion_vacante,pa.codigo
    order by d.nombre,o.descripcion,v.asignatura,calificacion desc

end

select * from pro.proceso_vacante where id_proceso_general in (select proceso_general.id_proceso_general from pro.proceso_general where id_proceso = 1)


select * from tmp.consolidado_concurso_docente where identificacion ='0924412232'


select * from pro.proceso where id_tipo_proceso = 2

--  DBCC CHECKIDENT ('tmp.consolidado_concurso_docente', RESEED, 179);

-- insert into tmp.consolidado_concurso_docente
select '2022-1' as periodo,d.idPostulacionVacante,dep.nombre,O.descripcion,v.descripcion,'OCASIONAL (CONTRATADO)',
       d.id_persona,d.identificacion,d.nombres,null as id_proceso_usuario,
       d.emailPersonal,10 as id_categoria_docente,d.ponderadoDocs as merito,d.ponderadoClaseDemostrativa as clase_demostrativa,d.notaFinal,
       iif(d.notaFinal>=d.puntajeMinimoFinal and d.posicion<=d.minElegible,concat('ELEGIBLE ',d.posicion),
           iif(d.notaFinal>=d.puntajeMinimoFinal and d.posicion>d.minElegible,'NO ELEJIBLE','No cumple puntaje mínimo')) as estado, o.id_oferta
from cmo.[fn_get_listar_resultados] (1,null) as d
         inner join cmo.vacante v on d.id_vacante =v.id_vacante
         inner join aca.oferta o on v.id_oferta = o.id_oferta
         inner join aca.departamento_oferta do on o.id_oferta = do.id_oferta
         inner join man.departamentos dep on do.id_departamento = dep.id
where o.estado='A'

--consulta final
SELECT DISTINCT
    pe.identificacion,
    pe.apellidos,
    pe.nombres,
    dc1.codigo,
    ISNULL(dc.observacion, 'S/N') AS observacion,
    dc.fecha_desde,
    (SELECT COUNT(*)
     FROM tmp.consolidado_concurso_docente c
     WHERE c.id_persona = pe.id) AS numero_participaciones_concurso,
    isnull((SELECT STUFF((SELECT ', ' + c.periodo_academico
                          FROM tmp.consolidado_concurso_docente c
                          WHERE c.id_persona = pe.id
                          FOR XML PATH('')), 1, 2, '') AS periodo_concurso),'NO PARTICIPADO NUNCA') AS periodo_concurso,
    isnull((SELECT STUFF((SELECT ', ' + CONVERT(VARCHAR, c.calificacion)
                          FROM tmp.consolidado_concurso_docente c
                          WHERE c.id_persona = pe.id
                          FOR XML PATH('')), 1, 2, '') AS nota_final),'NO PARTICIPADO NUNCA') AS nota_final,
    isnull((SELECT STUFF((SELECT ', ' + c.estado
                          FROM tmp.consolidado_concurso_docente c
                          WHERE c.id_persona = pe.id
                          FOR XML PATH('')), 1, 2, '') AS detalle_concurso),'NO PARTICIPADO NUNCA') AS detalle_concurso
FROM aca.periodo_academico pa
         INNER JOIN aca.periodo_academico_oferta pao ON pa.id_periodo_academico = pao.id_periodo_academico
         INNER JOIN aca.distributivo_oferta dof ON pao.id_periodo_academico_oferta = dof.id_periodo_academico_oferta
         INNER JOIN aca.distributivo_docente do ON dof.id_distributivo_oferta = do.id_distributivo_oferta
         INNER JOIN aca.docente d ON do.id_docente = d.id_docente
         INNER JOIN man.personas pe ON d.id_persona = pe.id
         INNER JOIN aca.docente_historial dc ON d.id_docente = dc.id_docente
         INNER JOIN aca.docente_categoria dc1 ON dc.id_docente_categoria = dc1.id_docente_categoria
WHERE pa.estado = 'A'
  AND pao.estado = 'A'
  AND dof.estado IN ('A', 'D', 'V')
  AND do.estado = 'A'
  AND d.estado = 'A'
  AND dc.estado = 'A'
  AND pe.estado = 'AC'
  AND dc.id_docente_historial IN (
    SELECT MAX(dh.id_docente_historial)
    FROM aca.docente_historial dh
             INNER JOIN aca.docente_categoria dca ON dh.id_docente_categoria = dca.id_docente_categoria
    WHERE dc.id_docente = dh.id_docente
      AND dca.codigo NOT IN ('INVITADO')
)
  AND pa.id_periodo_academico = 35
  AND dc1.codigo IN ('CONTRATADO1', 'CONADMINISTRATIVO', 'TITADMINISTRATIVO')
ORDER BY pe.apellidos, pe.nombres;


select * from [pro].[fn_list_periodos_academicos_by_process](9,-1)


-- update    pro.vacante_cronograma_etapa
-- set especialista_1=UPPER(especialista_1),especialista_2=UPPER(especialista_2),asignatura_evaluar=upper(asignatura_evaluar),
--    lugar= upper(lugar)
-- --
select * from pro.vacante_cronograma_etapa where id_proceso_etapa = 5

select * from aca.modalidad

select * from aca.estudiante_asignatura

select * from pro.evaluacion_rubrica
--aqui se guarda los campos que necesita master gina en la ficha tecnica
select * from pro.postulacion_vacante
select * from pro.proceso_etapa_ejecucion2
--no requisitos minimos
select * from [pro].[fn_list_evaluaciones_by_process_and_proceso_usuario](49,10,802)
--50226 no nota minima
select * from [pro].[fn_list_evaluaciones_by_process_and_proceso_usuario](49,10,50226)
--35238 pasa a oposicion
select * from [pro].[fn_list_evaluaciones_by_process_and_proceso_usuario](49,10,35238)


select * from [pro].[fn_list_evaluaciones_by_process](49,10,2)

select * from [pro].[fn_list_evaluaciones_by_process](49,10,null)

select d.*from [pro].[fn_list_all_vacantes_by_process](49,null,null) as d

select * from pro.tipo_proceso_estado

-- https://sga.upse.edu.ec/restsiia/api/reports/getReportNotificacionPostulanteCmo/36/45/REQUISITOS/5096/1
-- https://sga.upse.edu.ec/restsiia/api/reports/getReportNotificacionPostulanteCmo/36/46/MERITOSsss/5109/2

select * from [pro].[fn_rpt_rubricas_evaluaciones_etapa_oposicion] (36,48,10,5037,5)


select distinct u.id,u.usuario,tpe.descripcion,pej.id_proceso_etapa_ejecucion,eer.id_persona,null,
                0,0,0,'A',0, getdate(),getdate(),pu.usuario_ing,pu.usuario_ing,null,null
from pro.proceso_usuario2 pu
         inner join pro.tipo_proceso_estado tpe on pu.id_tipo_proceso_estado = tpe.id_tipo_proceso_estado
         inner join seg.usuarios u on u.persona_id = pu.id_persona
         inner join pro.proceso_etapa_ejecucion2 pej on pej.id_proceso_usuario = pu.id_proceso_usuario and pej.estado='A'
    and pej.id_proceso_etapa = 1
         inner join pro.etapa_ejecucion_responsable2  eer on eer.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion

--  and pejMerito.calificacion is not null
where  pu.estado='A' and pu.id_proceso_general = 49
--       and pej.calificacion>=42
group by eer.id_persona, pej.id_proceso_etapa_ejecucion, pu.usuario_ing, u.id, tpe.descripcion, u.usuario



select hora_inicio,hora_fin,dateadd(HH ,1,hora_inicio) from pro.vacante_cronograma_etapa where id_proceso_etapa = 2
                                                                                           and id_proceso_vacante = 2022

--  update    pro.vacante_cronograma_etapa set hora_fin = dateadd(HH ,1,hora_inicio) where id_proceso_etapa = 2
--                                     and hora_fin is null


select pc.* from pro.etapa_evaluaciones ev
                                            inner join pro.proceso_calendario pc on ev.id_proceso_calendario = pc.id_proceso_calendario
where pc.id_proceso_general = 70

select * from pro.proceso_general

select edc.* from pro.etapa_evaluaciones ev
                      inner join pro.proceso_calendario pc on ev.id_proceso_calendario = pc.id_proceso_calendario
                      inner join pro.evaluaciones_docente_categoria edc on ev.id_etapa_evaluacion = edc.id_etapa_evaluacion
where pc.id_proceso_general = 25

select ev.* from pro.etapa_evaluaciones ev
                     inner join pro.proceso_calendario pc on ev.id_proceso_calendario = pc.id_proceso_calendario
where pc.id_proceso_general = 49

select pc.* from pro.etapa_docente_categoria ev
                     inner join pro.proceso_calendario pc on ev.id_proceso_calendario = pc.id_proceso_calendario
where pc.id_proceso_general = 49

select ev.* from pro.etapa_docente_categoria ev
                     inner join pro.proceso_calendario pc on ev.id_proceso_calendario = pc.id_proceso_calendario
where pc.id_proceso_general = 25


--notificar postulantes

SELECT * FROM pro.fn_list_postulantes_to_notificate_CMO(49, 1)
select * from pro.fn_list_all_rubricas_evaluaciones_by_clasificacion_evaluadores(36,48,10,
         'MERITOSsss',4654,1,2095,'CONCURSOMERITO')

select * from pro.etapa_ejecucion_responsable2 where id_etapa_ejecucion_responsable in (
    14024
    )

select * from pro.etapa_ejecucion_requisito2 where id_etapa_ejecucion_responsable = 14024

select top 10 * from pro.etapa_ejecucion_responsable2 order by id_etapa_ejecucion_responsable desc
select ld.* from tmp.LISTADO_DOCENTE_CONTRATADIOS_2025 ld

select p.identificacion,ld.* from tmp.LISTADO_DOCENTE_CONTRATADIOS_2025 ld
left join man.personas p on  concat(p.apellidos,' ',p.nombres)=ld.nombres and p.estado='AC'
--     0911365930 0923003065 1305699736

select p.* from man.personas p
where P.estado='AC'

select * from [pro].[fn_list_all_postulaciones_concursos_merito](95,null,null,10,
                                                                 null,null,null,'CONCURSOMERITO',1) as d
---
select pe2.id_proceso_etapa_ejecucion,    ROW_NUMBER() OVER (
    PARTITION BY pu2.usuario_ing
    ORDER BY pu2.fecha_ing ASC
    ) AS number,pu2.*,( select count(eed2.id_etapa_ejecucion_documento) from  pro.proceso_etapa_ejecucion2 pe2
    inner join pro.etapa_ejecucion_responsable2 eer2 on pe2.id_proceso_etapa_ejecucion = eer2.id_proceso_etapa_ejecucion
    inner join pro.etapa_ejecucion_documento2 eed2 on eer2.id_etapa_ejecucion_responsable = eed2.id_etapa_ejecucion_responsable
    where pe2.id_proceso_usuario = pu2.id_proceso_usuario) from pro.proceso_usuario2 pu2
    inner join pro.proceso_general pg on pu2.id_proceso_general = pg.id_proceso_general
    inner join pro.proceso p on pg.id_proceso = p.id_proceso
    left join pro.proceso_etapa_ejecucion2 pe2 on pu2.id_proceso_usuario = pe2.id_proceso_usuario
where pg.id_periodo_academico = 95 and p.id_proceso = 1 and pu2.estado='A'


begin
    declare @id_proceso_usuario int =9409,@estado as varchar(2)='I'

    update pro.proceso_usuario2 set estado=@estado where id_proceso_usuario = @id_proceso_usuario
--     select pu2.*
    update pe2 set pe2.estado=@estado
    from pro.proceso_usuario2 pu2
    inner join pro.proceso_etapa_ejecucion2 pe2 on pu2.id_proceso_usuario = pe2.id_proceso_usuario
    where pu2.id_proceso_usuario = @id_proceso_usuario

--     select pv.*
    update pv set estado=@estado
    from pro.proceso_usuario2 pu2
    inner join pro.postulacion_vacante pv on pu2.id_proceso_usuario = pv.id_proceso_usuario
    where pu2.id_proceso_usuario = @id_proceso_usuario

--     select eer2.*
        update eer2 set estado=@estado
    from pro.proceso_usuario2 pu2
    inner join pro.proceso_etapa_ejecucion2 pe2 on pu2.id_proceso_usuario = pe2.id_proceso_usuario
    inner join pro.etapa_ejecucion_responsable2 eer2 on pe2.id_proceso_etapa_ejecucion = eer2.id_proceso_etapa_ejecucion
    where pu2.id_proceso_usuario = @id_proceso_usuario

--     select eed2.*
    update eed2 set estado=@estado
    from pro.proceso_usuario2 pu2
    inner join pro.proceso_etapa_ejecucion2 pe2 on pu2.id_proceso_usuario = pe2.id_proceso_usuario
    inner join pro.etapa_ejecucion_responsable2 eer2 on pe2.id_proceso_etapa_ejecucion = eer2.id_proceso_etapa_ejecucion
    inner join pro.etapa_ejecucion_documento2 eed2 on eer2.id_etapa_ejecucion_responsable = eed2.id_etapa_ejecucion_responsable
    where pu2.id_proceso_usuario = @id_proceso_usuario

--     select eer22.*
    update eer22 set estado=@estado
    from pro.proceso_usuario2 pu2
    inner join pro.proceso_etapa_ejecucion2 pe2 on pu2.id_proceso_usuario = pe2.id_proceso_usuario
    inner join pro.etapa_ejecucion_responsable2 eer2 on pe2.id_proceso_etapa_ejecucion = eer2.id_proceso_etapa_ejecucion
    inner join pro.etapa_ejecucion_requisito2 eer22 on eer2.id_etapa_ejecucion_responsable = eer22.id_etapa_ejecucion_responsable
    where pu2.id_proceso_usuario = @id_proceso_usuario
end

SELECT * FROM pro.fn_list_all_postulaciones_concursos_merito(95,9,59,10,null,null,
                                                             null,'CONCURSOMERITO',1) as d
-- where d.identificacion in ('0913695599')

select * from pro.proceso_usuario2

         where id_proceso_usuario in (6519,5343,6721)

select * from pro.postulacion_vacante pv where usuario_ing='0926612748'

select * from  pro.proceso_usuario2 where usuario_ing ='1314956846'

select * from pro.postulacion_vacante where id_proceso_usuario = 7324

select * from pro.proceso_etapa_ejecucion2 where id_proceso_etapa_ejecucion in (9789)
select * from pro.tipo_proceso_estado

select * from pro.proceso_calendario

select * from pro.postulacion_vacante pv where usuario_ing='0926612748'

select * from  pro.proceso_usuario2 where usuario_ing ='0926612748'

select * from pro.postulacion_vacante where id_proceso_usuario = 7324



select * from [pro].[fn_rpt_rubricas_evaluaciones_etapa_oposicion] (
        95,50,10,5876,2)

SELECT * FROM pro.fn_list_all_responsables_by_etapa_proceso_rpt_firmas( 2 , 5876) as d

select * from [pro].[fn_acta_consolidada_concurso]( 63,12,60  )


select * from [pro].[fn_list_revision_asignatura_by_responsable_reporte] ( 26422 )

select * from [pro].[fn_acta_consolidada_concurso_postgrado]
(67,7,6)
WHERE calificacionMerito >= 0
ORDER BY calificacionMerito DESC, asignatura

select * from [pro].[fn_acta_consolidada_concurso_fase_meritos](63,9,100)

    select director from [cat].[fn_obtener_director_y_decano_por_id_oferta](100)

select * from seg.usuario_opcion
where estado='A'
--     398
-- 339
-- 356
select * from seg.usuarios where usuario='0920617545'

select * from man.opciones


select distinct pc.*
    --pe.id_proceso_etapa,e.descripcion,pee2.*,tpe.descripcion
from pro.proceso p
inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
inner join pro.etapa e on e.id_etapa = pe.id_etapa
inner join pro.tipo_proceso tp on p.id_tipo_proceso = tp.id_tipo_proceso
inner join pro.proceso_general pg on p.id_proceso = pg.id_proceso
inner join pro.proceso_usuario2 pu2 on pg.id_proceso_general = pu2.id_proceso_general
inner join pro.proceso_etapa_ejecucion2 pee2  on pe.id_proceso_etapa = pee2.id_proceso_etapa
inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
inner join pro.tipo_proceso_estado tpe  on pee2.id_tipo_proceso_estado = tpe.id_tipo_proceso_estado
where  p.id_proceso = 1 and pc.id_proceso_general = 63 and pe.id_proceso_etapa = 1

select * from [pro].[fn_list_evaluaciones_by_process_and_proceso_usuario](63,10,50580)

 SELECT * FROM pro.fn_list_postulantes_to_notificate_CMO(63, 1)

select * from pro.tipo_proceso_estado

select pa.codigo,
       ofe.descripcion oferta ,om.id_oferta_modalidad, a.descripcion as asignatura,
       CASE WHEN  per.apellidos IS NOT NULL THEN concat(per.apellidos,' ',per.nombres) ELSE 'NO DEFINIDO'END  as docente,
       concat (n.descripcion_corta,'/', p.descripcion_corta) as nivel
--daa.*
from aca.periodo_academico pa
         inner join
     aca.periodo_academico_oferta pao on pa.id_periodo_academico=pao.id_periodo_academico
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
         inner join aca.departamento_oferta dof on ofe.id_oferta=dof.id_oferta
         inner join man.departamentos de on de.id=dof.id_departamento

where pao.estado='A' and do.estado='A' and dd.estado='A' and daa.estado='A'  --and pao.id_periodo_academico=35
  and aa.estado='A' and  ma.id_nivel=11 and d.estado in ('A','V') and pER.estado='AC'

select * from man.informacion_academica_persona

SELECT hd.*, pa.fecha_desde AS fecha_inicio_correcta, pa.fecha_hasta AS fecha_fin_correcta
FROM mig.historial_docente hd
         INNER JOIN aca.periodo_academico pa ON hd.periodo = pa.codigo
WHERE hd.fecha_inicio > hd.fecha_fin;

SELECT * FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_evaluadores](96,57,10,
                                                                                     'MERITOSsss',7664,1,14415,
                                                                                     'CONCURSOMERITO')

select ev.* from pro.proceso p
                     inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
                     inner join pro.etapa e on e.id_etapa = pe.id_etapa
                     inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
                     inner join pro.etapa_evaluaciones ev on ev.id_proceso_calendario = pc.id_proceso_calendario
where p.id_proceso = 1  and pc.id_proceso_general = 70

select * from pro.tipo_categorias_evaluacion

select ere.* from pro.evaluacion_rubrica er
inner join pro.evaluacion_requisito ere on ere.id_evaluacion_rubrica = er.id_evaluacion_rubrica
left join pro.docente_categoria_evaluacion dce on ere.id_evaluacion_requisito = dce.id_evaluacion_requisito and dce.estado='A'
where ere.id_evaluacion_rubrica in (22) and er.estado='A'
-- select * from aca.modalidad
select distinct ere.* from pro.evaluacion_rubrica er
inner join pro.evaluacion_requisito ere on ere.id_evaluacion_rubrica = er.id_evaluacion_rubrica
inner join pro.docente_categoria_evaluacion dce on ere.id_evaluacion_requisito = dce.id_evaluacion_requisito
where ere.id_evaluacion_rubrica in (22) and er.estado='A'

--listar postulantes
select * from [pro].[fn_list_postulaciones_concursos_merito_upse](87,null,null,null,null,null, null)

--replicar rubrica
select er2.id_evaluacion_requisito,
       dce.*--,tce.descripcion,tce.orden,tce2.descripcion,tce2.orden
--      ,pr.descripcion
from pro.evaluacion_requisito er
         inner join pro.evaluacion_requisito er2 on er2.id_proceso_requisito = er.id_proceso_requisito and er2.id_tipo_categoria_evaluacion = er.id_tipo_categoria_evaluacion and er2.id_evaluacion_rubrica = 25
         inner join pro.proceso_requisito pr on er.id_proceso_requisito = pr.id_proceso_requisito
         inner join pro.docente_categoria_evaluacion dce on er.id_evaluacion_requisito = dce.id_evaluacion_requisito
         inner join pro.tipo_categorias_evaluacion tce on er.id_tipo_categoria_evaluacion = tce.id_tipo_categoria_evaluacion
         left join pro.tipo_categorias_evaluacion tce2 on tce2.id_tipo_categoria_evaluacion = tce.id_tipo_categoria_evaluacion_padre
where er.id_evaluacion_rubrica in (1)
  and dce.estado='A'
  and dce.id_docente_categoria = 4
order by isnull(tce2.orden,10),dce.orden


SELECT * FROM pro.vacante_actividad_docente

select * from seg.roles where descripcion like '%IDIOMAS%'

select * from pro.proceso_general where id_proceso_general = 105


--POSTULANTES CON UN PERIODO
SELECT d.nombre, o.descripcion, UPPER(v.asignatura) AS asignatura, dc.descripcion AS categoriaDocente,
       p.id, p.identificacion, UPPER(CONCAT(p.apellidos, ' ', p.nombres)) AS postulante,
       pu.id_proceso_usuario,
       IIF(p.email_institucional IS NULL OR p.email_institucional = '', email_personal, email_institucional) AS email,
       hd.periodo
FROM pro.proceso_usuario2 pu
         INNER JOIN pro.tipo_proceso_estado tpe ON pu.id_tipo_proceso_estado = tpe.id_tipo_proceso_estado
         INNER JOIN man.personas p ON p.id = pu.id_persona
         INNER JOIN mig.historial_docente hd ON hd.identificacion = p.identificacion
         INNER JOIN pro.postulacion_vacante pv ON pv.id_proceso_usuario = pu.id_proceso_usuario
         INNER JOIN pro.proceso_vacante prv ON prv.id_proceso_vacante = pv.id_proceso_vacante
         INNER JOIN pro.vacante v ON v.id_vacante = prv.id_vacante
         INNER JOIN aca.docente_categoria dc ON dc.id_docente_categoria = v.id_docente_categoria
         INNER JOIN aca.oferta o ON o.id_oferta = v.id_oferta
         INNER JOIN aca.departamento_oferta dof ON dof.id_oferta = o.id_oferta
         INNER JOIN man.departamentos d ON dof.id_departamento = d.id
         INNER JOIN pro.proceso_etapa_ejecucion2 pee2 ON pee2.id_proceso_usuario = pu.id_proceso_usuario
WHERE pu.estado = 'A'
  AND pv.estado = 'A'
  AND prv.estado = 'A'
  AND v.estado = 'A'
  AND pee2.estado = 'A'
  AND pee2.id_proceso_etapa = 2
  AND pu.id_proceso_general = 105
  AND p.identificacion IN
      (
          SELECT h.identificacion
          FROM mig.historial_docente h
          WHERE h.estado = 'A'
          GROUP BY h.identificacion
          HAVING COUNT(DISTINCT h.periodo) = 1
      )
GROUP BY d.nombre, o.descripcion, v.asignatura, p.id, p.identificacion, p.apellidos, p.nombres,
         pu.id_proceso_usuario, v.id_docente_categoria, tpe.codigo, pee2.id_proceso_etapa_ejecucion,
         p.email_institucional, email_personal, dc.descripcion, pee2.calificacion, hd.periodo;


SELECT d.nombre, o.descripcion, UPPER(v.asignatura) AS asignatura, dc.descripcion AS categoriaDocente,
       p.id, p.identificacion, UPPER(CONCAT(p.apellidos, ' ', p.nombres)) AS postulante,
       pu.id_proceso_usuario,
       IIF(p.email_institucional IS NULL OR p.email_institucional = '',
           p.email_personal, p.email_institucional) AS email,

    /*==============================================================*/
    /* Tiene familiares registrados                                 */
    /*==============================================================*/
       IIF(
               EXISTS
                   (
                       SELECT 1
                       FROM pro.persona_parentesco pp
                       WHERE pp.id_persona = p.id
                         AND pp.estado = 'A'
                   )
                   OR EXISTS
                   (
                       SELECT 1
                       FROM man.parentesco_externo pe
                       WHERE pe.id_persona = p.id
                         AND pe.estado = 'A'
                   ),
               1, 0
       ) AS tieneFamiliares,

    /*==============================================================*/
    /* Tiene familiares que trabajan en la institución              */
    /*==============================================================*/
       IIF(
               EXISTS
                   (
                       SELECT 1
                       FROM pro.persona_parentesco pp
                                INNER JOIN man.personas pr ON pr.id = pp.id_persona_relacionada
                       WHERE pp.id_persona = p.id
                         AND pp.estado = 'A'
                         AND
                           (
                               EXISTS
                                   (
                                       SELECT 1
                                       FROM uath.persona_puesto_asignacion ppa
                                                INNER JOIN uath.jerarquia_puesto_trabajo j ON j.id_puesto = ppa.id_puesto
                                       WHERE ppa.id_persona = pp.id_persona_relacionada
                                         AND ppa.estado = 'A'
                                         AND ppa.es_actual = 1
                                         AND j.estado = 'A'
                                   )
                                   OR EXISTS
                                   (
                                       SELECT 1
                                       FROM uath.trabajador_ipg tipg
                                       WHERE tipg.id_persona = pp.id_persona_relacionada
                                   )
                                   OR EXISTS
                                   (
                                       SELECT 1
                                       FROM uath.contratos_migracion_06_02_2024 cm
                                       WHERE cm.identificacion = pr.identificacion
                                         AND cm.EstadoContrato IN ('A', 'AC')
                                   )
                               )
                   )
                   OR EXISTS
                   (
                       SELECT 1
                       FROM man.parentesco_externo pe
                                LEFT JOIN man.personas pr ON pr.identificacion = pe.identificacion
                       WHERE pe.id_persona = p.id
                         AND pe.estado = 'A'
                         AND
                           (
                               EXISTS
                                   (
                                       SELECT 1
                                       FROM uath.persona_puesto_asignacion ppa
                                                INNER JOIN uath.jerarquia_puesto_trabajo j ON j.id_puesto = ppa.id_puesto
                                       WHERE ppa.id_persona = pr.id
                                         AND ppa.estado = 'A'
                                         AND ppa.es_actual = 1
                                         AND j.estado = 'A'
                                   )
                                   OR EXISTS
                                   (
                                       SELECT 1
                                       FROM uath.trabajador_ipg tipg
                                       WHERE tipg.id_persona = pr.id
                                   )
                                   OR EXISTS
                                   (
                                       SELECT 1
                                       FROM uath.contratos_migracion_06_02_2024 cm
                                       WHERE cm.identificacion = pe.identificacion
                                         AND cm.EstadoContrato IN ('A', 'AC')
                                   )
                               )
                   ),
               1, 0
       ) AS tieneFamiliaresTrabajan,docs.totalDocumentos, docs.totalDocumentosSubidos

FROM pro.proceso_usuario2 pu
         INNER JOIN pro.tipo_proceso_estado tpe ON pu.id_tipo_proceso_estado = tpe.id_tipo_proceso_estado
         INNER JOIN man.personas p ON p.id = pu.id_persona
         INNER JOIN pro.postulacion_vacante pv ON pv.id_proceso_usuario = pu.id_proceso_usuario
         INNER JOIN pro.proceso_vacante prv ON prv.id_proceso_vacante = pv.id_proceso_vacante
         INNER JOIN pro.vacante v ON v.id_vacante = prv.id_vacante
         INNER JOIN aca.docente_categoria dc ON dc.id_docente_categoria = v.id_docente_categoria
         INNER JOIN aca.oferta o ON o.id_oferta = v.id_oferta
         INNER JOIN aca.departamento_oferta dof ON dof.id_oferta = o.id_oferta
         INNER JOIN man.departamentos d ON dof.id_departamento = d.id
         INNER JOIN pro.proceso_etapa_ejecucion2 pee2 ON pee2.id_proceso_usuario = pu.id_proceso_usuario
         iNNER JOIN pro.proceso_general pg ON pu.id_proceso_general = pg.id_proceso_general
         INNER JOIN pro.proceso_calendario pc ON pc.id_proceso_general = pg.id_proceso_general AND pc.id_proceso_etapa = pee2.id_proceso_etapa
         OUTER APPLY
     (
         SELECT COUNT(DISTINCT doc.descripcionRequisito) AS totalDocumentos,
                COUNT(doc.id_etapa_ejecucion_documento) AS totalDocumentosSubidos
         FROM pro.fn_list_documentos_postulante(pu.id_proceso_usuario) doc
         WHERE pc.requiere_documento = 1
     ) docs
WHERE pu.estado = 'A'
  AND pv.estado = 'A'
  AND prv.estado = 'A'
  AND v.estado = 'A'
  AND pee2.estado = 'A'
  AND pee2.id_proceso_etapa = 1
  AND pu.id_proceso_general = 105
GROUP BY d.nombre, o.descripcion, v.asignatura, p.id, p.identificacion, p.apellidos, p.nombres,
         pu.id_proceso_usuario, v.id_docente_categoria, tpe.codigo, pee2.id_proceso_etapa_ejecucion,
         p.email_institucional, p.email_personal, dc.descripcion, pee2.calificacion,docs.totalDocumentos, docs.totalDocumentosSubidos;

select * from pro.fn_list_vacantes_by_proceso_general_and_user(105,2339)

SELECT distinct RUO.oferta_id,r.descripcion
FROM seg.roles_usuario_oferta RUO
         INNER JOIN seg.roles_usuarios RU ON RUO.rol_usuario_id = RU.id
inner join seg.roles r on RU.rol_id = r.id
WHERE RU.usuario_id = 2339 and
  RU.rol_id IN (27, 28, 124,23)
  AND RUO.estado = 'AC'
  AND RU.estado = 'AC'

select * from seg.roles