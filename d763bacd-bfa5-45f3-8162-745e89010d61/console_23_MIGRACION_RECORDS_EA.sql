use bd_sga_upse

select * from aca.tipo_estado_estudiante


select distinct eo2.id_estudiante_oferta from aca.estudiante_oferta eo2
inner join man.personas p on eo2.id_persona = p.id
inner join aca.oferta_modalidad om on eo2.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
where eo2.id_estudiante_oferta_padre is not null and eo2.estado='A'


---setear estudiante padre de los manes de nivelacion del 2022-1
begin

    declare @id_periodo_academico  int = 15
--     update eo set eo.vez_proyectada= iif(dd.id_periodo_aprobado= 24, 28,dd.id_periodo_aprobado)
--                 ,eo.id_periodo_academico = 30,eo.fecha_mod=getdate(),eo.usuario_mod='2400254286'
--     update eo set eo.id_estudiante_oferta_padre= dd.id_estudiante_oferta,eo.id_periodo_academico = pag.id_periodo_academico_siguiente,
--                   eo.fecha_mod=getdate(),eo.usuario_mod='2400254286'
    select dd.*
--          ,iif(dd.id_periodo_aprobado= 24, 28,dd.id_periodo_aprobado) as id_periodo_nuevo
    from (
    select --eo.*
    distinct eo.id_periodo_academico,eo.id_persona,eo.id_oferta_modalidad,p.identificacion,p.apellidos,p.nombres,o.descripcion,eo.id_tipo_estado_estudiante,tee.descripcion as estado_cupo_nivelacion,
             eo.id_estudiante_oferta,eo.vez_proyectada,--,em.id_estudiante_matricula,em.estado,
    eogh.id_estudiante_oferta as id_estudiante_oferta_grado,eogh.id_tipo_estado_estudiante as id_tipo_estado_estudiante_gra,oh.descripcion as carera,
    eogh.id_periodo_academico as id_periodo_academico_gra,eogh.id_estudiante_oferta_padre,eogh.fecha_ingreso,--aux.id_periodo_aprobado
    (select max(mg.id_periodo_academico) from aca.estudiante_matricula em
          inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
            inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
          where em.id_estudiante_oferta = eo.id_estudiante_oferta and em.estado='A'
          group by em.id_estudiante_matricula
            having (
            select count(ea1.promedio) from aca.estudiante_asignatura ea1
                        inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
            where ea1.id_estudiante_matricula = em.id_estudiante_matricula and ea1.estado ='A'
            ) = (
            select count(ea1.promedio) from aca.estudiante_asignatura ea1
                        inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
            where ea1.id_estudiante_matricula = em.id_estudiante_matricula and ea1.estado ='A' and ea1.aprobado = 1
            )) as id_periodo_aprobado
    from man.personas p
     inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
--     inner join rel.fn_relaciones_ofertas_nivelacion_grado(eo.vez_proyectada) oreh on oreh.idOfertaModalidadNivelacion = eo.id_oferta_modalidad
--      left join aca.estudiante_oferta eogh on eogh.id_persona = p.id and eogh.id_oferta_modalidad = oreh.idOfertaModalidadPregrado
        inner join ( select pao.id_periodo_academico,pa.codigo,pao.id_oferta_modalidad as id_oferta_modalidad_niv,o.descripcion as nivelacion,
                            paop.id_oferta_modalidad as id_oferta_modalidad_grado, op.descripcion as grado from rel.oferta_relaciones ore
                         inner join aca.oferta o on ore.id_oferta =o.id_oferta
                         inner join aca.oferta_modalidad om on o.id_oferta = om.id_oferta
                         inner join aca.oferta op on ore.id_oferta_relacion  = op.id_oferta
                         inner join aca.oferta_modalidad omp on op.id_oferta = omp.id_oferta
                         inner join aca.periodo_academico_oferta pao on om.id_oferta_modalidad = pao.id_oferta_modalidad
                         inner join aca.periodo_academico pa on pao.id_periodo_academico = pa.id_periodo_academico
                         inner join aca.periodo_academico_oferta paop on omp.id_oferta_modalidad = paop.id_oferta_modalidad
                         inner join aca.periodo_academico pap on pap.id_periodo_academico = paop.id_periodo_academico
                     where pao.estado='A' and paop.estado='A' and pa.estado='A' and pap.estado='A' and pap.codigo = pa.codigo) as aux on aux.id_oferta_modalidad_niv = eo.id_oferta_modalidad
        and aux.id_periodo_academico = eo.vez_proyectada
    left join aca.estudiante_oferta eogh on eogh.id_persona = p.id and eogh.id_oferta_modalidad = aux.id_oferta_modalidad_grado
    --                                                 and eogh.fecha_ingreso<=cast('2023-08-17 01:18:15.223' as datetime2)  and eogh.fecha_ingreso>=cast('2023-03-31 15:42:36.163' as datetime2)--24
    --
     left join aca.oferta_modalidad omh on omh.id_oferta_modalidad = eogh.id_oferta_modalidad
     left join aca.oferta oh on oh.id_oferta = omh.id_oferta
     inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
     inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
     inner join aca.oferta o on o.id_oferta = om.id_oferta
     inner join aca.tipo_oferta tof on o.id_tipo_oferta = tof.id_tipo_oferta
     inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
     inner join man.departamentos d on d.id= do.id_departamento
     inner join seg.usuarios u on u.persona_id = p.id
    where  eo.id_periodo_academico = @id_periodo_academico  --and tee.codigo = 'ACT'
    and o.id_tipo_oferta = 1 --and (em.id_estudiante_matricula is null or em.estado<>'A')
    and tof.codigo='NIVELACION'
    ) as dd
    inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = dd.id_estudiante_oferta_grado
    left join aca.periodo_academico pa on pa.id_periodo_academico = dd.id_periodo_aprobado
    left join aca.periodo_academico pag on pag.codigo = pa.codigo and pag.id_tipo_oferta =2
end

select eo.* from aca.estudiante_oferta eo
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
where o.id_tipo_oferta = 1 and eo.id_periodo_academico>40
---setear estudiante padre de los manes de nivelacion que vinieron del sisweb pero que si tiene estudiante oferta en el sga por su segunda vez
begin

    declare @id_periodo_academico  int = 123
--     update eo set eo.id_estudiante_oferta_padre= dd.id_estudiante_oferta,eo.id_periodo_academico = pag.id_periodo_academico_siguiente,
--                   eo.fecha_mod=getdate(),eo.usuario_mod='2400254286'
    select dd.*
--          ,iif(dd.id_periodo_aprobado= 24, 28,dd.id_periodo_aprobado) as id_periodo_nuevo
    from (
    select --eo.*
    distinct eo.id_periodo_academico,eo.id_persona,eo.id_oferta_modalidad,p.identificacion,p.apellidos,p.nombres,o.descripcion,eo.id_tipo_estado_estudiante,tee.descripcion as estado_cupo_nivelacion,
             eo.id_estudiante_oferta,eo.vez_proyectada,--,em.id_estudiante_matricula,em.estado,
    eogh.id_estudiante_oferta as id_estudiante_oferta_grado,eogh.id_tipo_estado_estudiante as id_tipo_estado_estudiante_gra,oh.descripcion as carera,
    eogh.id_periodo_academico as id_periodo_academico_gra,eogh.id_estudiante_oferta_padre,eogh.fecha_ingreso,--aux.id_periodo_aprobado
    (select max(mg.id_periodo_academico) from aca.estudiante_matricula em
          inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
            inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
          where em.id_estudiante_oferta = eo.id_estudiante_oferta and em.estado='A'
          group by em.id_estudiante_matricula
            having (
            select count(ea1.promedio) from aca.estudiante_asignatura ea1
                        inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
            where ea1.id_estudiante_matricula = em.id_estudiante_matricula and ea1.estado ='A'
            ) = (
            select count(ea1.promedio) from aca.estudiante_asignatura ea1
                        inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
            where ea1.id_estudiante_matricula = em.id_estudiante_matricula and ea1.estado ='A' and ea1.aprobado = 1
            )) as id_periodo_aprobado
    from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
    inner join rel.fn_relaciones_ofertas_nivelacion_grado(15) oreh on oreh.idOfertaModalidadNivelacion = eo.id_oferta_modalidad
    left join aca.estudiante_oferta eogh on eogh.id_persona = p.id and eogh.id_oferta_modalidad = oreh.idOfertaModalidadPregrado and eo.estado='A'
--          and eogh.id_estudiante_oferta not in (64612)
        and eogh.id_estudiante_oferta not in (select distinct eo2.id_estudiante_oferta from aca.estudiante_oferta eo2
                                                                                                inner join man.personas p on eo2.id_persona = p.id
                                                                                                inner join aca.oferta_modalidad om on eo2.id_oferta_modalidad = om.id_oferta_modalidad
                                                                                                inner join aca.oferta o on om.id_oferta = o.id_oferta
                                              where o.id_tipo_oferta = 2 and eo2.id_estudiante_oferta_padre is not null and eo2.estado='A')
     left join aca.oferta_modalidad omh on omh.id_oferta_modalidad = eogh.id_oferta_modalidad
     left join aca.oferta oh on oh.id_oferta = omh.id_oferta
     inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
     inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
     inner join aca.oferta o on o.id_oferta = om.id_oferta
     inner join aca.tipo_oferta tof on o.id_tipo_oferta = tof.id_tipo_oferta
     inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
     inner join man.departamentos d on d.id= do.id_departamento
     inner join seg.usuarios u on u.persona_id = p.id
    where  eo.id_periodo_academico = @id_periodo_academico  --and tee.codigo = 'ACT'
    and o.id_tipo_oferta = 1 --and (em.id_estudiante_matricula is null or em.estado<>'A')
    and tof.codigo='NIVELACION'
    ) as dd
    inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = dd.id_estudiante_oferta_grado
    left join aca.periodo_academico pa on pa.id_periodo_academico = dd.id_periodo_aprobado
    left join aca.periodo_academico pag on pag.codigo = pa.codigo and pag.id_tipo_oferta =2
end

select * from aca.estudiante_oferta where id_estudiante_oferta = 18593


select * from pro.proceso_usuario where usuario_ing='2400099723'

select * from mig.record_oferta where identificacion='2400099723'
select * from mig.record_oferta where identificacion='0707030995'

select te.* from Bd_Academico..vw_MATRICULAS te where te.MATRICULA='12019561721'



select * from aca.tipo_estado_estudiante
select * from aca.tipo_ingreso_estudiante where id_tipo_ingreso_estudiante = 24

---setear estudiante padre de los manes de nivelacion a partir del 2022-2 en adelante
begin

    declare @id_periodo_academico  int = 38
--         update eo1 set eo1.id_tipo_estado_estudiante=9,
--                   eo1.fecha_mod=getdate(),eo1.usuario_mod='2400254286'
--     update eo set eo.id_estudiante_oferta_padre= dd.id_estudiante_oferta,eo.id_periodo_academico = pag.id_periodo_academico_siguiente,
--                   eo.fecha_mod=getdate(),eo.usuario_mod='2400254286'
    select dd.*
    from (
    select --eo.*
    distinct eo.id_periodo_academico,eo.id_persona,eo.id_oferta_modalidad,p.identificacion,p.apellidos,p.nombres,o.descripcion,eo.id_tipo_estado_estudiante,
             tee.descripcion as estado_cupo_nivelacion,
             eo.id_estudiante_oferta,eo.vez_proyectada,
             (select count(em.id_estudiante_matricula) from aca.estudiante_matricula em where em.id_estudiante_oferta = eo.id_estudiante_oferta
                                                                                        and em.estado='A') as num_matriculas_niv,
    eogh.id_estudiante_oferta as id_estudiante_oferta_grado,eogh.id_tipo_estado_estudiante as id_tipo_estado_estudiante_gra,oh.descripcion as carerra_grado,
    eogh.id_periodo_academico as id_periodo_academico_gra,eogh.id_estudiante_oferta_padre as id_estudiante_oferta_padre_gra,
    eogh.fecha_ingreso as fecha_ingreso_gra,--aux.id_periodo_aprobado
    (select max(mg.id_periodo_academico) from aca.estudiante_matricula em
          inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
            inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
          where em.id_estudiante_oferta = eo.id_estudiante_oferta and em.estado='A'
          group by em.id_estudiante_matricula
            having (
            select count(ea1.promedio) from aca.estudiante_asignatura ea1
                        inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
            where ea1.id_estudiante_matricula = em.id_estudiante_matricula and ea1.estado ='A'
            ) = (
            select count(ea1.promedio) from aca.estudiante_asignatura ea1
                        inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
            where ea1.id_estudiante_matricula = em.id_estudiante_matricula and ea1.estado ='A' and ea1.aprobado = 1
            )) as id_periodo_aprobado
    from man.personas p
     inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
    inner join rel.fn_relaciones_ofertas_nivelacion_grado(@id_periodo_academico) oreh on oreh.idOfertaModalidadNivelacion = eo.id_oferta_modalidad
     left join aca.estudiante_oferta eogh on eogh.id_persona = p.id and eogh.id_oferta_modalidad = oreh.idOfertaModalidadPregrado and eo.estado='A'
--          and eogh.id_estudiante_oferta not in (64612)
        and eogh.id_estudiante_oferta not in (select distinct eo2.id_estudiante_oferta from aca.estudiante_oferta eo2
         inner join man.personas p on eo2.id_persona = p.id
         inner join aca.oferta_modalidad om on eo2.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
        where o.id_tipo_oferta = 2 and eo2.id_estudiante_oferta_padre is not null and eo2.estado='A')

     left join aca.oferta_modalidad omh on omh.id_oferta_modalidad = eogh.id_oferta_modalidad
     left join aca.oferta oh on oh.id_oferta = omh.id_oferta
     inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
     inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
     inner join aca.oferta o on o.id_oferta = om.id_oferta
     inner join aca.tipo_oferta tof on o.id_tipo_oferta = tof.id_tipo_oferta
     inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
     inner join man.departamentos d on d.id= do.id_departamento
     inner join seg.usuarios u on u.persona_id = p.id
    where  eo.id_periodo_academico = @id_periodo_academico  --and tee.codigo = 'ACT'
      and eo.estado='A' and o.id_tipo_oferta = 1 --and (em.id_estudiante_matricula is null or em.estado<>'A')
    and tof.codigo='NIVELACION'
    ) as dd
--     inner join aca.estudiante_oferta eo1 on eo1.id_estudiante_oferta = dd.id_estudiante_oferta
--     and dd.num_matriculas_niv = 1 and dd.estado_cupo_nivelacion='ACTIVO'
--     inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = dd.id_estudiante_oferta_grado and dd.id_periodo_aprobado is not null
--     left join aca.periodo_academico pa on pa.id_periodo_academico = dd.id_periodo_aprobado
--     left join aca.periodo_academico pag on pag.codigo = pa.codigo and pag.id_tipo_oferta =2
end

select * from rel.fn_relaciones_ofertas_nivelacion_grado(15)
select * from aca.modalidad

select * from aca.tipo_estado_estudiante
--actualizar a los manes de transicion de malla de presencial a hibrido
select distinct p.identificacion,o.descripcion as carrera,p.apellidos,p.nombres,eo.id_estudiante_oferta as id_estudiante_oferta_presencial,
                eo.id_estudiante_oferta_padre as id_estudiante_oferta_padre_presencial,tee.descripcion as estado_presencial,tie.descripcion as ingreso_presencial,
                eo1.id_estudiante_oferta as id_estudiante_oferta_hibrido,
                eo1.id_estudiante_oferta_padre as id_estudiante_oferta_padre_hibrido,tee2.descripcion as estado_hibrido,tie1.descripcion as ingreso_hibrido
-- update eo1 set eo1.id_estudiante_oferta_padre = eo.id_estudiante_oferta
--     update eo1 set eo1.id_tipo_ingreso_estudiante = 6
from aca.estudiante_oferta eo
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.oferta_modalidad om2 on om2.id_oferta = o.id_oferta
inner join aca.estudiante_oferta eo1 on eo1.id_persona = eo.id_persona and eo1.id_oferta_modalidad = om2.id_oferta_modalidad
inner join aca.tipo_estado_estudiante tee2 on tee2.id_tipo_estado_estudiante = eo1.id_tipo_estado_estudiante
inner join aca.tipo_ingreso_estudiante tie1 on eo1.id_tipo_ingreso_estudiante = tie1.id_tipo_ingreso_estudiante
where om.id_modalidad = 1 and om2.id_modalidad = 4 and o.id_tipo_oferta = 2
--    and eo.estado='A' and eo1.estado='A' --and eo2.id_estudiante_oferta_padre is not null

--setear a los manes del propedeutico

select distinct p.identificacion,o.descripcion as carrera,p.apellidos,p.nombres,eo.id_estudiante_oferta as id_estudiante_oferta_pro,
                eo.id_estudiante_oferta_padre as id_estudiante_oferta_padre_pro,tee.descripcion as estado_pro,
                eo1.id_estudiante_oferta as id_estudiante_oferta_doc,
                eo1.id_estudiante_oferta_padre as id_estudiante_oferta_padre_doc,tee1.descripcion as estado_doc
-- update eo1 set eo1.id_estudiante_oferta_padre = eo.id_estudiante_oferta
from aca.estudiante_oferta eo
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.estudiante_oferta eo1 on eo1.id_persona = eo.id_persona
inner join aca.oferta_modalidad om1 on eo1.id_oferta_modalidad = om1.id_oferta_modalidad
inner join aca.oferta o1 on om1.id_oferta = o1.id_oferta
inner join aca.tipo_estado_estudiante tee1 on tee1.id_tipo_estado_estudiante = eo1.id_tipo_estado_estudiante
where om.id_oferta_modalidad = 128 and eo1.id_oferta_modalidad = 127

select tof.id_tipo_oferta,tof.descripcion,om.id_oferta_modalidad,o.descripcion from aca.tipo_oferta tof
inner join aca.oferta o on tof.id_tipo_oferta = o.id_tipo_oferta
inner join aca.oferta_modalidad om  on o.id_oferta = om.id_oferta
where o.estado='A' and om.estado='A' and o.id_tipo_oferta = 5

select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 2



--actualizar a los manes que tienen cambio de carrera en el SGA
--     update eo set eo.id_estudiante_oferta_padre= d.id_estudiante_oferta,eo.id_periodo_academico = d.id_periodo_obtuvo,
--                   eo.fecha_mod=getdate(),eo.usuario_mod='2400254286'
select d.*
    from (
select distinct
        d.idProcesoUsuario,d.idEstudianteOferta as id_estudiante_oferta,eo.id_estudiante_oferta_padre as id_estudiante_oferta_padre_origen,
        tee.descripcion estado_cupo_origen,d.identificacion,d.estudiante,d.carreraOrigen,d.carreraDestino,d.estadoProceso,eo1.id_estudiante_oferta as id_estudiante_oferta_cambio,
        eo1.id_estudiante_oferta_padre as id_estudiante_oferta_padre_destino,eo1.id_periodo_academico as id_periodo_academico_destino, tee.descripcion estado_cupo_destino
        ,(select top 1 m.id_periodo_academico from aca.movilidad m where m.id_estudiante_oferta = eo1.id_estudiante_oferta
                                                                     and m.estado='A' order by m.id_movilidad asc ) as id_periodo_obtuvo,eo1.estado as estado_destino,
                                                                                                 tie.descripcion as tipo_ingreso_estudiante_destino
        from [pro].[fn_list_All_Estudiantes_Postulantes_By_Oferta](null,36,null,null) as d
        inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = d.idEstudianteOferta
        inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
        inner join aca.estudiante_oferta eo1 on eo1.id_persona = d.idPersona and eo1.id_oferta_modalidad = d.idOfertaModalidadNueva --and eo1.estado='A'
        inner join aca.tipo_estado_estudiante tee1 on tee1.id_tipo_estado_estudiante = eo1.id_tipo_estado_estudiante
                                    and (eo.id_estudiante_oferta = eo1.id_estudiante_oferta_padre or eo1.id_estudiante_oferta_padre is null )
        inner join aca.tipo_ingreso_estudiante tie on eo1.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
--                                                    and eo.id_estudiante_oferta_padre is null
        where eo.estado='A'
        ) as d
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta=d.id_estudiante_oferta_cambio
-- and d.id_periodo_obtuvo is not null

select dm.* from aca.movilidad m
         inner join aca.detalle_movilidad dm on m.id_movilidad = dm.id_movilidad
         where m.id_estudiante_oferta = 56829

select * from aca.movilidad where estado='I'

select * from aca.malla where id_malla in (40,148,33,78)

select * from aca.subtipo_movilidad

SELECT * FROM BD_ACADEMICO..VW_RECORD_ACADEMICO_TODO_MOVILIDAD
WHERE-- estado like 'CONVALIDA%'
      identificacion='1718439563'

select * from pro.tipo_proceso_estado

select * from aca.tipo_ingreso_estudiante

select * from aca.tipo_estado_estudiante

select * from mig.causistica

select * from mig.record_oferta where identificacion='2400048720'

select * from mig.record_matricula where id_record_oferta = 67688
select * from mig.record_oferta where id_tipo_oferta = 2 and id_estudiante_oferta is not null and periodo<'2018-1'

select ro.id_record_oferta,ro.id_persona_cg,ro.id_record_oferta_padre,ro.id_oferta_modalidad,ro.id_carrera_ofertada,ro.identificacion,ro.apellidos,ro.nombres,ro.carrera,ro.periodo,ro.id_tipo_estado_estudiante,ro.id_estudiante_oferta,RO.id_estudiante_oferta_destino,ro.estado
from mig.record_oferta ro where  ro.identificacion ='2400218877'

select * from aca.estudiante_oferta where id_estudiante_oferta in (56465)

-- update ro set ro.id_record_oferta_padre = d.id_record_oferta_real,ro.fecha_mod=getdate(),ro.usuario_mod='2400254286'
select d.*
from (
select ro.id_record_oferta,ro.id_persona_cg,ro.id_record_oferta_padre,ro.id_oferta_modalidad,ro.id_carrera_ofertada,
       ro.identificacion,ro.apellidos,ro.nombres,ro.carrera as carrera_base,(pa.orden-pa1.orden) as desfase,ro.periodo as periodo_base,ro1.periodo as periodo_real,ro2.periodo as periodo_falso,
       ro1.carrera as carrera_real,ro2.carrera as carrera_falsa,ro.id_tipo_estado_estudiante,ro.id_estudiante_oferta,
       RO.id_estudiante_oferta_destino,ro.estado,ro1.id_record_oferta as id_record_oferta_real,
        (select top 1 rm.estado_matricula from mig.record_matricula rm where rm.id_record_oferta = ro1.id_record_oferta order by rm.id_number desc) as estado_matricula_niv,ro.estado as estado_niv
from mig.record_oferta ro
inner join aca.periodo_academico pa on ro.periodo = pa.codigo and pa.id_tipo_oferta = 2
inner join mig.record_oferta ro1 on ro1.identificacion = ro.identificacion and ro1.id_carrera_ofertada = ro.id_carrera_ofertada and ro1.id_tipo_oferta=1
inner join aca.periodo_academico pa1 on ro1.periodo = pa1.codigo and pa1.id_tipo_oferta = 2
inner join mig.record_oferta ro2 on ro2.id_record_oferta = ro.id_record_oferta_padre
where ro.id_tipo_oferta= 2  and ro.id_record_oferta_padre is not null and ro.id_record_oferta_padre<>ro1.id_record_oferta
and ro1.carrera<>ro2.carrera) as d
inner join mig.record_oferta ro on ro.id_record_oferta= d.id_record_oferta
where d.estado_matricula_niv='APROBADO' and d.desfase in (0,1)
-- and ro.identificacion ='0926672429'


select --eo.*
       eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,p.identificacion,p.apellidos,p.nombres,o.descripcion as carrera,eo.numero_matricula,eo.id_periodo_academico,
       eo.fecha_ingreso,tee.descripcion as tipo,tee.observacion,eo.estado,
       (select min(ea1.codigo_estado_matricula) from aca.estudiante_matricula em1
                                                         inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
        where em1.estado='A'and ea1.estado='A' and em1.id_estudiante_oferta=eo.id_estudiante_oferta) as vez
from aca.estudiante_oferta eo
         inner join man.personas p on eo.id_persona = p.id
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
where p.identificacion='2400286437'
    --and eo.fecha_ingreso <cast('2021-10-12 00:00:00.000' as datetime2)
--     o.id_tipo_oferta in (2)  --and eo.id_estudiante_oferta_padre is not null and
--     and eo.id_tipo_ingreso_estudiante = 6

select * from Bd_Academico..te_INSCRIPCIONES where ID_PERSONA = 27464
-- 0919472647
-- 0920070976
-- 0923408926
-- 0923568588
-- 0952288744
-- 0925088429
select * from mig.record_oferta where id_number in (17016,18597)

select * from mig.record_matricula where id_record_oferta =34032

select te.* from Bd_Academico..vw_MATRICULAS te where te.IDENTIFICACION='0915832356'

select * from Bd_Academico..te_INSCRIPCIONES where ID_PERSONA = 28236


select * from mig.record_matricula where id_number = 119177

select te.* from Bd_Academico..TE_MATRICULAS te where te.ID_PERSONA= 14819

select  * from mig.record_matricula where id_record_oferta = 59172

select top 10 * from Bd_Academico..MATERIAS_TOMADAS mt

select * from mig.record_oferta where identificacion='FB583163'

select * from Bd_Academico..EG_EGRESADOS

select * from aca.tipo_ingreso_estudiante

    select --eo.*
    eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,p.identificacion,p.apellidos,p.nombres,o.descripcion as carrera,eo.numero_matricula,eo.id_periodo_academico,
    eo.fecha_ingreso,tee.descripcion as tipo,tee.observacion,eo.estado,
    (select min(ea1.codigo_estado_matricula) from aca.estudiante_matricula em1
                                                 inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
    where em1.estado='A'and ea1.estado='A' and em1.id_estudiante_oferta=eo.id_estudiante_oferta) as vez
    from aca.estudiante_oferta eo
    inner join man.personas p on eo.id_persona = p.id
    inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
    inner join aca.oferta o on om.id_oferta = o.id_oferta
    inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
    where o.id_tipo_oferta = 5  and eo.id_estudiante_oferta_padre is null
--and eo.id_tipo_ingreso_estudiante= 14
--     and p.identificacion in ('0929927093','0926693318')
--volver pa ca
select *
-- update ea set ea.id_estado_cauistica =1
from mig.estado_academicos ea where ea.identificacion not in (select p.identificacion from man.personas p)
                                and ea.identificacion not in (select p.identificacion from Bd_Academico..PERSONAS p)
--      and ea.identificacion not in (select p.identificacion from bdupse.snu.aspirante p)
--cupos que no estan migrados en el sisweb
select *
-- update ea set ea.id_estado_cauistica =1
from mig.estado_academicos ea where ea.identificacion not in (select p.identificacion from man.personas p where p.estado='AC')
                                and ea.identificacion not in (select p.identificacion from Bd_Academico..PERSONAS p where p.ESTADO='A')
     and ea.identificacion in (select p.identificacion from bdupse.snu.aspirante p)

select *
-- update ea set ea.id_estado_cauistica =1
from bdupse.snu.aspirante ea where ea.identificacion not in (select p.identificacion from man.personas p where p.estado='AC'
                                                                                                         )
                                and ea.identificacion not in (select p.identificacion from Bd_Academico..PERSONAS p where p.ESTADO='A'
                                                                                                                    )
    and concat(ea.apellidos, ' ',ea.nombres) in ((select concat(p.apellidos, ' ',p.nombres) from Bd_Academico..PERSONAS p))
                               and concat(ea.apellidos, ' ',ea.nombres)  in ((select concat(p.apellidos, ' ',p.nombres) from man.personas p))

select * from Bd_Academico..PERSONAS p where p.identificacion in ('AQ491050','1759090192')

select * from man.PERSONAS p where p.identificacion in ('AQ491050','1759090192')

select * from man.persona_identificacion

select * from mig.record_oferta where identificacion in ('AQ491050','1759090192')

select * from mig.record_oferta where identificacion in ('0928140284')

select *
-- update ea set ea.id_estado_cauistica =1
from bdupse.snu.aspirante ea where  ea.identificacion not in (select p.identificacion from man.personas p where p.estado='AC')
                               and ea.identificacion not in (select p.identificacion from Bd_Academico..PERSONAS p where p.ESTADO='A') and
                                concat(ea.apellidos, ' ',ea.nombres) in ((select concat(p.apellidos, ' ',p.nombres) from Bd_Academico..PERSONAS p))
                               and concat(ea.apellidos, ' ',ea.nombres) in ((select concat(p.apellidos, ' ',p.nombres) from man.personas p))

select * from mig.causistica

select * from mig.estado_academicos ea where ea.id_estado_cauistica= 1
and ea.identificacion not in (select p.identificacion from bdupse.snu.aspirante p)

select * from mig.estado_academicos where identificacion in ('AQ491050','1759090192')

select p.* from bdupse.snu.aspirante p
--21713 no estan con cedulas
--21658 no estan con nombres y sin considerar estados
select p.ID_PERSONA,p.identificacion,p.APELLIDOS,p.NOMBRES,p.ESTADO
-- p.*
from Bd_Academico..PERSONAS p
where p.IDENTIFICACION not in (select p.identificacion from man.personas p)
and concat(p.apellidos, ' ',p.nombres) not in ((select concat(p.apellidos, ' ',p.nombres) from man.personas p))
--0920044468 CRUZ CHALEN	MONICA OLIVIA
--0922211784 CRUZ GURUMENDI	MANUEL ANGEL
--     0919128017	FLORES CARVAJAL	EUFEMIA EMPERATRIZ
--     0926319443	EGAS GARCIA	TAMARA JOHANNA





select * from man.personas where identificacion='0920044468'

select * from mig.record_oferta ro where identificacion='0926678871'

select p.ID_PERSONA,p.identificacion,p.APELLIDOS,p.NOMBRES,ps.id,ps.identificacion,ps.APELLIDOS,ps.NOMBRES from Bd_Academico..PERSONAS p
left join man.personas ps on concat(ps.apellidos, ' ',ps.nombres)=concat(p.apellidos, ' ',p.nombres)
where p.IDENTIFICACION not in (select p.identificacion from man.personas p)
  and concat(p.apellidos, ' ',p.nombres) in ((select concat(p.apellidos, ' ',p.nombres) from man.personas p))
  and p.ID_PERSONA not in (1491,19360,19014,19680,18447,755,18544,21640,46432,26730,21914,21457,2750,2859,3271,3354,3478,12060,3837,3953,21930,19542,4465,4752,4977,7191,5503,5575,
                           5649,5733,5881,6018,6075,18592,12675,6510,6734,6769,6836,4156,3533,6639,583,4760,3075,417,5263,6570,20808,1441,322,6544,3650,5604,2633,107,21221,19060,21322,
                           814,1768,9986,22544,16723,2894,3107,3493,3885,4595,4950,18048,12709,5229,5406,17398,5729,5775,6694,21611,22543,6928,2772)


select * from man.tipo_identificacion

select * from man.persona_identificacion



--considerando estados
select distinct p.ID_PERSONA,p.identificacion,p.APELLIDOS,p.NOMBRES,concat(p.APELLIDOS, ' ',p.NOMBRES) as persona from Bd_Academico..PERSONAS p
where p.IDENTIFICACION not in (select p.identificacion from man.personas p where p.estado='AC')
and concat(p.apellidos, ' ',p.nombres) not in ((select concat(p.apellidos, ' ',p.nombres) from man.personas p where p.estado='AC'))
and p.ESTADO='A' and p.IDENTIFICACION not in ('0000000000','0000000016','0000000028','0000000012','0000000019','0000000018','0000000020','0000000027')
and p.ESTADO_ is null and p.ID_PERSONA not in (19033,20176,20159,20178,20179,85)
--excluye a los manes que estan repetidos y con otras cedulas
  and p.ID_PERSONA not in (1491,19360,19014,19680,18447,755,18544,21640,46432,26730,21914,21457,2750,2859,3271,3354,3478,12060,3837,3953,21930,19542,4465,4752,4977,7191,5503,5575,
                           5649,5733,5881,6018,6075,18592,12675,6510,6734,6769,6836,4156,3533,6639,583,4760,3075,417,5263,6570,20808,1441,322,6544,3650,5604,2633,107,21221,19060,21322,
                           814,1768,9986,22544,16723,2894,3107,3493,3885,4595,4950,18048,12709,5229,5406,17398,5729,5775,6694,21611,22543,6928,2772)
--excluye los manes que estan repetidos y tiene el mismo
and p.ID_PERSONA not in (select d.ID_PERSONA from (
select  ROW_NUMBER() OVER (PARTITION BY p.APELLIDOS,NOMBRES ORDER BY p.ID_PERSONA asc) as orden,p.* from Bd_Academico..PERSONAS p where concat(p.apellidos, ' ',p.nombres) in
(select d.nombress from (select concat(p.APELLIDOS, ' ',p.NOMBRES) as nombress,p.IDENTIFICACION,count(p.ID_PERSONA) repetidas from Bd_Academico..PERSONAS p
    where p.IDENTIFICACION not in (select p.identificacion from man.personas p where p.estado='AC')
    and concat(p.apellidos, ' ',p.nombres) not in ((select concat(p.apellidos, ' ',p.nombres) from man.personas p where p.estado='AC'))
    and p.ESTADO='A' and p.ESTADO_ is null
    group by p.APELLIDOS, p.NOMBRES,p.IDENTIFICACION
    having    count(p.IDENTIFICACION)>1)as d)
and p.ESTADO='A') as d
where d.orden = 1 and d.IDENTIFICACION not in ('0922588942','0925279424')) and len(p.IDENTIFICACION)>5


select p.* from Bd_Academico..PERSONAS p
where p.IDENTIFICACION = '0919477620'

select concat(p.APELLIDOS, ' ',p.NOMBRES),count(p.IDENTIFICACION) repetidas from Bd_Academico..PERSONAS p
where p.IDENTIFICACION not in (select p.identificacion from man.personas p where p.estado='AC')
  and concat(p.apellidos, ' ',p.nombres) not in ((select concat(p.apellidos, ' ',p.nombres) from man.personas p where p.estado='AC'))
  and p.ESTADO='A' and p.ESTADO_ is null
group by p.APELLIDOS, p.NOMBRES
having    count(p.IDENTIFICACION)>1

select p.ID_PERSONA,p.identificacion,p.apellidos,p.nombres from Bd_Academico..personas p
where concat(p.apellidos, ' ',p.nombres) ='ZAMBRANO BAREN BENILDA FATIMA'

select * from man.email_institucional
select  top 4 * from man.personas order by id desc
-- DBCC CHECKIDENT ('man.personas', RESEED, 80479);

select  * from man.personas where id_tipo_identificacion Is null
--
select  top 4 * from man.personas where identificacion='0921240909'
-- insert into bd_sga_upse.man.personas(id_tipo_identificacion,id_estado_civil, id_tipo_sangre, id_discapacidad, id_nacionalidad, id_pais_nacionalidad, id_provincia_nacionalidad, id_canton_nacionalidad,
--                                      id_parroquia_nacionalidad, id_etnia, id_nacionalidad_indigena, id_pais_residencia, id_provincia_residencia, id_canton_residencia, id_parroquia_residencia, num_carnet_conadis, porcentaje_dis,
--                                      identificacion, nombres, apellidos, sexo, fecha_nace, ciudad, barrio, direccion, telefono, celular, email_personal, email_institucional, estado, fecha_ingreso,
--                                      usuario_ing,usuario_mod,fecha_ing,fecha_mod)
select top 5000 (SELECT ti.id_tipo_identificacion FROM bd_sga_upse.man.tipo_identificacion ti
                                                        inner join migracion_sga.dbo.registros_migracion rm on rm.id_destino = ti.id_tipo_identificacion
                                                        inner join migracion_sga.dbo.entidades_migracion em on em.id = rm.id_entidad_relacion
              where em.tabla_destino = 'tipo_identificacion' and rm.id_origen = p.CG_TIPO_IDENTIFICACION) as id_tipo_identificacion,
             (SELECT ec.id_estado_civil FROM bd_sga_upse.man.estado_civil ec
                                                 inner join migracion_sga.dbo.registros_migracion rm on rm.id_destino = ec.id_estado_civil
                                                 inner join migracion_sga.dbo.entidades_migracion em on em.id = rm.id_entidad_relacion
              where em.tabla_destino = 'estado_civil' and rm.id_origen = p.CG_ESTADO_CIVIL) as id_estado_civil,
             (SELECT ts.id_tipo_sangre FROM bd_sga_upse.man.tipo_sangre ts
                                                inner join migracion_sga.dbo.registros_migracion rm on rm.id_destino = ts.id_tipo_sangre
                                                inner join migracion_sga.dbo.entidades_migracion em on em.id = rm.id_entidad_relacion
              where em.tabla_destino = 'tipo_sangre' and rm.id_origen = p.CG_TIPO_SANGRE) as id_tipo_sangre,
             (SELECT d.id_discapacidad FROM bd_sga_upse.man.discapacidad d
                                                inner join migracion_sga.dbo.registros_migracion rm on rm.id_destino = d.id_discapacidad
                                                inner join migracion_sga.dbo.entidades_migracion em on em.id = rm.id_entidad_relacion
              where em.tabla_destino = 'discapacidad' and rm.id_origen = p.CG_DISCAPACIDAD) as id_discapacidad,
             (SELECT n.id_nacionalidad FROM bd_sga_upse.man.nacionalidad n
                                                inner join migracion_sga.dbo.registros_migracion rm on rm.id_destino = n.id_nacionalidad
                                                inner join migracion_sga.dbo.entidades_migracion em on em.id = rm.id_entidad_relacion
              where em.tabla_destino = 'nacionalidad' and rm.id_origen = p.CG_NACIONALIDAD) as id_nacionalidad,

             (select id_lugar
              from bd_sga_upse.man.lugar
              where id_lugar_padre is null and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PAIS_ORIGEN)) as id_pais_nacionalidad,

             (select id_lugar
              from bd_sga_upse.man.lugar
              where id_lugar_padre = ((select id_lugar
                                       from bd_sga_upse.man.lugar
                                       where id_lugar_padre is null and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = cg_pais_origen)))
                and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PROVINCIA_NACE)) as id_provincia_nacionalidad,

             (select id_lugar
              from bd_sga_upse.man.lugar
              where id_lugar_padre = (select id_lugar
                                      from bd_sga_upse.man.lugar
                                      where id_lugar_padre = ((select id_lugar
                                                               from bd_sga_upse.man.lugar
                                                               where id_lugar_padre is null and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = cg_pais_origen)))
                                        and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PROVINCIA_NACE))
                and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_CANTON_NACE)) as id_canton_nacionalidad,

             (select id_lugar
              from bd_sga_upse.man.lugar
              where id_lugar_padre = (select id_lugar
                                      from bd_sga_upse.man.lugar
                                      where id_lugar_padre = (select id_lugar
                                                              from bd_sga_upse.man.lugar
                                                              where id_lugar_padre = ((select id_lugar
                                                                                       from bd_sga_upse.man.lugar
                                                                                       where id_lugar_padre is null and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = cg_pais_origen)))
                                                                and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PROVINCIA_NACE))
                                        and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_CANTON_NACE))
                and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PARROQUIA_NACE)) as id_parroquia_nacionalidad,

             (SELECT e.id_etnia FROM bd_sga_upse.man.etnia e
                                         inner join migracion_sga.dbo.registros_migracion rm on rm.id_destino = e.id_etnia
                                         inner join migracion_sga.dbo.entidades_migracion em on em.id = rm.id_entidad_relacion
              where em.tabla_destino = 'etnia' and rm.id_origen = p.CG_ETNIA) as id_etnia,
             (SELECT ni.id_nacionalidad_indigena FROM bd_sga_upse.man.nacionalidad_indigena ni
                                                          inner join migracion_sga.dbo.registros_migracion rm on rm.id_destino = ni.id_nacionalidad_indigena
                                                          inner join migracion_sga.dbo.entidades_migracion em on em.id = rm.id_entidad_relacion
              where em.tabla_destino = 'nacionalidad_indigena' and rm.id_origen = p.CG_NAC_INDIGENA) as id_nacionalidad_indigena,

             (select id_lugar
              from bd_sga_upse.man.lugar
              where id_lugar_padre is null and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PAIS_RESIDE)) as id_pais_residencia,

             (select id_lugar
              from bd_sga_upse.man.lugar
              where id_lugar_padre = ((select id_lugar
                                       from bd_sga_upse.man.lugar
                                       where id_lugar_padre is null and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PAIS_RESIDE)))
                and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PROVINCIA_RESIDE)) as id_provincia_residencia,

             (select id_lugar
              from bd_sga_upse.man.lugar
              where id_lugar_padre = (select id_lugar
                                      from bd_sga_upse.man.lugar
                                      where id_lugar_padre = ((select id_lugar
                                                               from bd_sga_upse.man.lugar
                                                               where id_lugar_padre is null and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PAIS_RESIDE)))
                                        and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PROVINCIA_RESIDE))
                and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_CANTON_RESIDE)) as id_canton_residencia,

             (select id_lugar
              from bd_sga_upse.man.lugar
              where id_lugar_padre = (select id_lugar
                                      from bd_sga_upse.man.lugar
                                      where id_lugar_padre = (select id_lugar
                                                              from bd_sga_upse.man.lugar
                                                              where id_lugar_padre = ((select id_lugar
                                                                                       from bd_sga_upse.man.lugar
                                                                                       where id_lugar_padre is null and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PAIS_RESIDE)))
                                                                and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PROVINCIA_RESIDE))
                                        and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_CANTON_RESIDE))
                and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PARROQUIA_RESIDE)) as id_parroquia_residencia,

             case
                 when p.NUMERO_CONADIS is null
                     then ''
                 when p.NUMERO_CONADIS = '0'
                     then ''
                 else p.NUMERO_CONADIS
                 end as NUMERO_CONADIS,

             case
                 when p.PORC_DISCAPACIDAD is null
                     then 0
                 else p.PORC_DISCAPACIDAD
                 end as PORC_DISCAPACIDAD,

             p.IDENTIFICACION, p.NOMBRES, p.APELLIDOS,

             isnull(SUBSTRING((select descripcion from Bd_Academico.dbo.fun_info_sexo(p.ID_PERSONA)), 1, 1),'M') as sexo,
             p.FEC_NACIMIENTO,
             (select VALOR_TEXTO from [Bd_Personal].[dbo].[TP_CODIGOS] tc where tc.CORRELATIVO = p.CG_CIUDAD_RESIDE) as ciudad,
             p.BARRIO_RESIDE,
             p.DIRECCION, p.TELEFONO, p.CELULAR, p.EMAIL, iif(p.EMAIL_INST='-',null,p.EMAIL_INST)as correo_institucional, 'AC' as estado, p.FECHA_INGRESO, '2400254286' as usuario_ing,'2400254286' as usuario_mod,
        p.FECHA_INGRESO as fecha_ing,getdate() as fecha_mod


from Bd_Academico.dbo.PERSONAS p
where p.IDENTIFICACION not in (select p.identificacion from man.personas p where p.estado='AC')
and concat(p.apellidos, ' ',p.nombres) not in ((select concat(p.apellidos, ' ',p.nombres) from man.personas p where p.estado='AC'))
-- and p.ESTADO='A'
  and p.IDENTIFICACION not in ('0000000000','0000000016','0000000028','0000000012','0000000019','0000000018','0000000020','0000000027')
and p.ESTADO_ is null and p.ID_PERSONA not in (19033,20176,20159,20178,20179,85)
--excluye a los manes que estan repetidos y con otras cedulas
  and p.ID_PERSONA not in (1491,19360,19014,19680,18447,755,18544,21640,46432,26730,21914,21457,2750,2859,3271,3354,3478,12060,3837,3953,21930,19542,4465,4752,4977,7191,5503,5575,
                           5649,5733,5881,6018,6075,18592,12675,6510,6734,6769,6836,4156,3533,6639,583,4760,3075,417,5263,6570,20808,1441,322,6544,3650,5604,2633,107,21221,19060,21322,
                           814,1768,9986,22544,16723,2894,3107,3493,3885,4595,4950,18048,12709,5229,5406,17398,5729,5775,6694,21611,22543,6928,2772)
--excluye los manes que estan repetidos y tiene el mismo
and p.ID_PERSONA not in (select d.ID_PERSONA from (
select  ROW_NUMBER() OVER (PARTITION BY p.APELLIDOS,NOMBRES ORDER BY p.ID_PERSONA asc) as orden,p.* from Bd_Academico..PERSONAS p where concat(p.apellidos, ' ',p.nombres) in
(select d.nombress from (select concat(p.APELLIDOS, ' ',p.NOMBRES) as nombress,p.IDENTIFICACION,count(p.ID_PERSONA) repetidas from Bd_Academico..PERSONAS p
    where p.IDENTIFICACION not in (select p.identificacion from man.personas p where p.estado='AC')
    and concat(p.apellidos, ' ',p.nombres) not in ((select concat(p.apellidos, ' ',p.nombres) from man.personas p where p.estado='AC'))
    and p.ESTADO='A' and p.ESTADO_ is null
    group by p.APELLIDOS, p.NOMBRES,p.IDENTIFICACION
    having    count(p.IDENTIFICACION)>1)as d)
and p.ESTADO='A') as d
where d.orden = 1 and d.IDENTIFICACION not in ('0922588942','0925279424')) and len(p.IDENTIFICACION)>5
and p.IDENTIFICACION='0926678871'

-- DBCC CHECKIDENT ('mig.record_asignaturas', RESEED, 940955);

select top 10 * from mig.record_asignaturas order by id_record_asignatura desc

--128 730
--161 659
--117 323
--     insert into mig.record_asignaturas
 select distinct d.id_record_oferta, d.id_record_matricula, d.id_periodo_academico, d.id_periodo_academico_cg, d.id_malla_asignatura, d.id_materia_plan,
                   d.id_malla, d.ID_PLAN,
                   iif(d.id_paralelo in ('A','B','D','C','EX','MULTICARRERA'),1,iif(d.id_paralelo in ('10'),10,convert(int,substring(d.id_paralelo,1,1)))) as id_paralelo
                   , d.id_nivel, d.id_nivel_cg, d.nivel, d.tipo_malla, d.asignatura, d.vez, d.creditos, d.horas, d.promedio, d.asistencia,
                   d.estado_tomada, d.valor, d.tipo, d.aprobado, d.estado_aprobacion, d.periodo, d.identificacion_docente, d.docente,d.orden, d.fecha_registro,
                   d.id_number,d.table_name, d.estado, d.version, d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod from (
            SELECT  ro.id_record_oferta,null as id_record_matricula,pa.id_periodo_academico,dm.cg_periodo as id_periodo_academico_cg,
            maa.id_malla_asignatura,dm.ID_MATERIA_PLAN as id_materia_plan,mal.id_malla,mo.ID_PLAN,
            isnull(replace(iif(LEN(aula.CG_PARALELO)>=3,RIGHT(aula.PARALELO, LEN(aula.PARALELO) - CHARINDEX('/', aula.PARALELO)),aula.PARALELO),'.', ''),'1') as id_paralelo,
            niv.id_nivel as id_nivel,mp.id_nivel as id_nivel_cg,Isnull(n.DESCRIPCION,'NO DEFINIDO') AS nivel,isnull(tm.VALOR_TEXTO,'NO CLASIFICADO') as tipo_malla,
            isnull(m.NOMBRE,'S/N') as asignatura,
            '1 VEZ' as vez,isnull(mp.CREDITOS,0) as creditos,isnull(mp.TOTAL_HORAS,0) as horas,
            isnull(CASE WHEN dm.cg_periodo > 27734 and pe.ID_CARRERA_OFERTADA in (108,43,102)  THEN 0 ELSE dm.calificacion END,0) as promedio,100 as asistencia,
--             isnull(tipoMov.VALOR_TEXTO,'S/N') as estado_tomada,
--                     isnull((CASE WHEN dm.cg_periodo >= 27627 THEN tipoMov.VALOR_TEXTO ELSE 'NORMAL' END),'S/N') as estado_tomada,
                    isnull((CASE WHEN dm.cg_periodo >= 27627 and pe.ID_CARRERA_OFERTADA in (108,43,102) THEN 'RECONOCIMIENTO CAMBIO N° SEMESTRES' ELSE 'NORMAL' END),'S/N') as estado_tomada,
            0 as valor,CASE WHEN  mo.cg_proceso = 27828 THEN 'REDISEÑO DE CARRERA'  ELSE  tipoMov.VALOR_TEXTO+' - '+t.codigo + ' ' + st.codigo END  as tipo,
            (CASE WHEN (dm.calificacion >= 70) THEN 1 ELSE 0 END) as aprobado, (CASE WHEN (dm.calificacion >= 70) THEN 'APROBADO' ELSE 'REPROBADO' END) as estado_aprobacion,
            per.VALOR_TEXTO as periodo, 'NO APLICA' as identificacion_docente,'NO APLICA' as docente,ROW_NUMBER() OVER (PARTITION BY ro.id_record_oferta,n.ID_NIVEL ORDER BY isnull(m.NOMBRE,'S/N')) as orden,
            isnull(dm.fecha_ingreso,isnull(dm.fecha_modifica,getdate()))as fecha_registro,dm.id as id_number,'Bd_Academico.mov.detalle_movilidad' as table_name,dm.ESTADO as estado,
            0 as version,getdate() as fecha_ing,getdate() as fecha_mod, '2400254286' as usuario_ing, '2400254286' as usuario_mod
            FROM   Bd_Academico.mov.movilidad mo
            INNER JOIN Bd_Academico.mov.detalle_movilidad dm ON dm.id_movilidad = mo.id
            INNER JOIN Bd_Academico..PERSONAS p ON mo.ID_PERSONA = p.ID_PERSONA
            left join Bd_Academico.mov.subtipo_movilidad st on st.id=mo.id_subtipo_movilidad
            left join Bd_Academico.mov.tipo_movilidad t on st.id_tipo_movilidad=t.id
            left join Bd_Academico..MATERIAS_PLAN mp on mp.ID_MATERIA_PLAN=dm.ID_MATERIA_PLAN AND mp.ESTADO = 'A'
            left join bd_academico..NIVELES n on n.id_nivel = mp.id_nivel  AND n.ESTADO = 'A'
            LEFT JOIN Bd_Academico..VW_ASIG_AULAS  as aula ON mo.ID_REGISTRO_AULA = aula.ID_REGISTRO
            left join Bd_Academico..MATERIAS m on m.id_materia = mp.ID_MATERIA  AND m.estado = 'A'
            LEFT JOIN Bd_Academico..TP_CODIGOS AS per ON per.CORRELATIVO = dm.cg_periodo
            LEFT JOIN Bd_Academico..PLAN_ESTUDIOS  pe ON  pe.ID_PLAN = mo.id_plan
            left join Bd_Personal..TP_CODIGOS tm on tm.CORRELATIVO= pe.CG_TIPO_PLAN
            left join Bd_Personal..TP_CODIGOS tipoMov on tipoMov.CORRELATIVO= mo.CG_PROCESO
            left join aca.periodo_academico pa on pa.codigo = per.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 2
            left join
               (select ma.id_malla_asignatura,rma.id_origen,rma.id_destino from migracion_sga..registros_migracion rma
                inner join aca.malla_asignatura ma on ma.id_malla_asignatura = rma.id_destino
                where rma.id_entidad_relacion in (5,29) and ma.estado='A' ) as maa on maa.id_origen = dm.ID_MATERIA_PLAN
            left join
                (select m.id_malla,m.tipo_plan,rm.id_origen,rm.id_destino from migracion_sga..registros_migracion rm
                inner join aca.malla m on m.id_malla = rm.id_destino
                where rm.id_entidad_relacion in (4) and m.estado in ('A','P')  ) as mal on mal.id_origen = mp.ID_PLAN
            left join
               (select n.id_nivel,rn.id_origen,rn.id_destino,n.descripcion as nivel from migracion_sga..registros_migracion rn
                left join aca.nivel n on n.id_nivel = rn.id_destino and n.estado in ('A')
                where rn.id_entidad_relacion in (6) ) as niv on niv.id_origen = mp.ID_NIVEL
            inner join mig.record_oferta ro on ro.table_name='bd_academico..te_matriculas.ID_CARRERA_OFERTADA' and ro.id_persona_cg = mo.id_persona and ro.id_carrera_ofertada = pe.ID_CARRERA_OFERTADA
                and ro.id_record_oferta not in(48014,59172) and ro.estado<>'I'
            left join mig.record_asignaturas ra on ra.id_number = dm.id and ra.table_name ='Bd_Academico.mov.detalle_movilidad'
            WHERE mo.ESTADO = 'A' and dm.estado='A' and p.estado='A'  AND dm.ver_record = 1  -- and p.IDENTIFICACION ='2400340648'
--             and mp.id_nivel in (select id_nivel from Bd_Academico.dbo.niveles where interfaz=3)
            and ra.id_record_asignatura is null ) as d
            order by d.id_record_oferta,d.id_nivel_cg,d.asignatura

select * from Bd_Academico..PERSONAS p where ID_PERSONA in (43717,20173)

select * from mig.record_oferta rm where id_tipo_oferta = 2 and identificacion in ('0927265702','0915832356','0919790139','FB562302')

select * from mig.record_oferta rm where id_tipo_oferta = 2 and identificacion in ('0927836031')

select  * from mig.record_asignaturas where id_record_oferta =59875

exec [aca].[sp_list_all_asignaturas_detalle_record]  null , 44 , '12010531222'   , '0927265702'
    ,  null ,  null , null

select * from migracion_sga..registros_migracion rn where id_entidad_relacion = 6

select * from bd_academico..NIVELES n

select ea.*,ca.casuistica_resumida from mig.estado_academicos ea
                                            inner join mig.causistica ca on ca.id_caso = ea.id_estado_cauistica
-- where identificacion='2450562968'

select * from  Bd_Academico.mov.detalle_movilidad dm where estado='A' and dm.id = 193280

select * from  Bd_Academico.mov.movilidad mo where id  = 7306

select p.IDENTIFICACION,m.id_plan,pe.ID_CARRERA_OFERTADA,cl.CARRERA,m.id_persona,dm.* from  Bd_Academico.mov.detalle_movilidad dm
inner join Bd_Academico.mov.movilidad m on m.id = dm.id_movilidad
INNER JOIN Bd_Academico..PERSONAS p ON m.ID_PERSONA = p.ID_PERSONA
LEFT JOIN Bd_Academico..PLAN_ESTUDIOS  pe ON  pe.ID_PLAN = m.id_plan
inner join Bd_Academico..CARRERAS_LOCALES_MODALIDAD_SISTEMA clms on clms.ID_CARRERA_OFERTADA = pe.ID_CARRERA_OFERTADA
inner join Bd_Academico.dbo.VW_TE_CARRERAS_LOCALIDAD cl on cl.ID_CARRERA_LOCAL= clms.id_carrera_local
where dm.estado='A' and p.IDENTIFICACION='0927836031'

select * from  Bd_Academico.. PLAN_ESTUDIOS

select * from Bd_Academico..TP_CODIGOS where CORRELATIVO=26858

select * from Bd_Academico..TP_CODIGOS where ID_CLASIFICACION=175

select * from Bd_Academico..TP_CODIGOS where ID_CLASIFICACION=19

select * from Bd_Academico..CLASIFICACIONES_GENERALES where ID_CLASIFICACION = 175

select * from sis..notas mt

select pa.CORRELATIVO,pa.VALOR_TEXTO_SIS as anio,pa.VALOR_TEXTO as codigo,
       concat(pa.VALOR_TEXTO,' ','PREGRADO ORDINARIO') as periodo
from Bd_Personal..TP_CODIGOS pa where pa.ID_CLASIFICACION = 33
                                  and NOT ( pa.VALOR_TEXTO LIKE '%-PRE%' OR pa.VALOR_TEXTO LIKE '%PAE%' OR pa.VALOR_TEXTO LIKE '%-3%')

select * from mig.record_oferta where identificacion='0923311625'

select cl.ID_CARRERA_LOCAL,clms.ID_CARRERA_LOCAL,clms.ID_CARRERA_OFERTADA,clms.NOMBRE,clms.NOMBRE_CARRERA,clms.CG_MODALIDAD,clms.CG_SISTEMA_ESTUDIO,co.VALOR_TEXTO as mod_est from Bd_Academico.dbo.vw_te_carreras_localidad cl
inner join Bd_Academico..CARRERAS_LOCALES_MODALIDAD_SISTEMA clms on clms.ID_CARRERA_LOCAL = cl.ID_CARRERA_LOCAL
inner join Bd_Personal..TP_CODIGOS co on co.correlativo = clms.CG_SISTEMA_ESTUDIO AND co.estado = 'A'
where clms.ESTADO='A' and clms.ID_CARRERA_OFERTADA in (36,34)



select rm.* from mig.record_oferta ro
inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
where ro.identificacion='0923561492'

select * from  mig.record_matricula rm where rm.id_record_oferta in(35186)

select * from  mig.record_asignaturas rm where rm.id_record_matricula in(35186)

select * from Bd_Academico..TE_MATRICULAS where ID_MATRICULA in (11020,11019)

select * from mig.record_matricula ra where ra.id_record_matricula =37473

select * from Bd_Academico..NIVELES

select * from aca.periodo

select * from aca.periodo_academico where id_tipo_oferta =2


select ra.id_record_matricula,ra.id_paralelo from mig.record_asignaturas ra
where ra.id_record_matricula=3600
group by ra.id_record_matricula, ra.id_paralelo
order by count(ra.id_paralelo) desc

-- DBCC CHECKIDENT ('mig.record_matricula', RESEED, 187879)
select * from mig.record_matricula where table_name='sis..MATRICULAS'

--     update rmo set rmo.id_number_old =  ma.ID_REGISTRO, rmo.table_name_old = 'sis..MATRICULAS'
    --se insertaran 1120 matriculas nuevas que no estaban en el sisweb
    --sin repetidos 1089
--     insert into mig.record_matricula
  SELECT distinct -- p.IDENTIFICACION,p.APELLIDOS,p.NOMBRES,ma.ID_CARRERA_OFERTADA,ma.id_carrera_local,ma.ID_PERSONA,cl.CARRERA,ma.MATRICULA,rmo.id_record_matricula,rmo.id_number_old,rmo.table_name_old,ro.estado,
                  ro.id_record_oferta as id_record_oferta,pa.id_periodo_academico as id_periodo_academico,
        ma.CG_PER_ACADEMICO as id_periodo_academico_cg,case   when ma.PERIODO_MATRICULA in ('ORDNARIA','ORDINARIO','ORDINARIAS','ORDINARIA') then 1
                    when ma.PERIODO_MATRICULA in ('EXTRAORDINARIO','EXTRAORDINARIA') THEN 2
                 when ma.PERIODO_MATRICULA in ('EXCEPCIONAL','ESPECIAL') then 3 else 1 end  as id_tipo_matricula,
       case when ma.JORNADA in ('NOCTURNA','NOCTURNO') then 3 when ma.JORNADA in ('VESPERTINO') THEN 2 WHEN ma.JORNADA in ('DIURNA','DIURNO') then 1 else 1 end as id_tipo_jornada_laboral,
                    isnull(ma.PARALELO,1) as id_paralelo,
                   mig.id_destino as id_nivel,niv.ID_NIVEL as id_nivel_cg, niv.DESCRIPCION AS nivel,'NO DEFINIDA' as aula, isnull(ma.CURSO,'NO DEFINIDO') as curso,
                '1 VEZ' as vez,0 as promedio,0 as valor,null as observacion,
             'POR DEFINIR' as estado_matricula,--ma.FECHA_MATRICULA,REPLACE(ma.FECHA_MATRICULA, '|', '/'),CONCAT(REPLACE(ma.FECHA_MATRICULA, '|', '/'), ' 00:00:00'),
                   CASE  when ma.FECHA_MATRICULA = 'Abril 29/2' then cast('2005-04-29 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '0917280883' then cast('1999-01-01 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '11//04/200' then cast('2006-04-11 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '122/10/199' then cast('1999-10-12 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '2704/2005' then cast('2005-04-27 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '1105/2005' then cast('2005-05-11 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA in ('29/02/1999','29|02|1999') then cast('1999-02-28 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA in ('30/02/2000') then cast('2000-02-28 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA in ('31/11/2002') then cast('2002-11-30 00:00:00' as datetime2)
                         WHEN ma.FECHA_MATRICULA IS NOT NULL AND LEN(ma.FECHA_MATRICULA) < 10 THEN
                             TRY_CONVERT(DATETIME,CONCAT(LEFT(ma.FECHA_MATRICULA, LEN(ma.FECHA_MATRICULA) - 3), SUBSTRING(per.VALOR_TEXTO, 1, 4)),103)
                         when TRY_CONVERT(DATETIME, REPLACE(ma.FECHA_MATRICULA, '|', '/'), 103) IS NOT NULL then TRY_CONVERT(DATETIME, REPLACE(ma.FECHA_MATRICULA, '|', '/'), 103)
                       WHEN ma.FECHA_MATRICULA IS NOT NULL and TRY_CONVERT(DATETIME, REPLACE(ma.FECHA_MATRICULA, '|', '/'), 103) IS not NULL
                                and len(ma.FECHA_MATRICULA)=10 THEN CONVERT(DATETIME, REPLACE(per.VALOR_TEXTO, '|', '/'), 103)
                        WHEN ma.FECHA_MATRICULA IS NULL and per.VALOR_TEXTO LIKE '%-1' THEN cast(CONCAT(SUBSTRING(per.VALOR_TEXTO, 1, 4), '-01-01 00:00:00') as datetime2)
                       WHEN ma.FECHA_MATRICULA IS NULL and per.VALOR_TEXTO LIKE '%-2' THEN cast(CONCAT(SUBSTRING(per.VALOR_TEXTO, 1, 4), '-07-01 00:00:00') as datetime2)
                         WHEN ma.FECHA_MATRICULA IS NULL and per.VALOR_TEXTO LIKE '%-3' THEN cast(CONCAT(SUBSTRING(per.VALOR_TEXTO, 1, 4), '-09-01 00:00:00') as datetime2)
                       ELSE NULL END AS fecha_matricula,
             per.VALOR_TEXTO as periodo,
            ma.ID_REGISTRO as id_number,'sis..MATRICULAS' as table_name, null as id_number_old,null as table_name_old,ma.ESTADO as estado,
               0 as version,getdate() as fecha_ing,getdate() as fecha_mod,
               '2400254286' as usuario_ing, '2400254286' as usuario_mod
            FROM   sis..MATRICULAS as ma
            INNER JOIN Bd_Academico..PERSONAS p ON ma.ID_PERSONA = p.ID_PERSONA
            inner join Bd_Academico.dbo.vw_te_carreras_localidad cl on cl.id_carrera_local= ma.id_carrera_local
            left JOIN sis..NIVELES niv ON ma.ID_NIVEL = niv.ID_NIVEL
            LEFT JOIN Bd_Academico..VW_CARRERAS_OFERTADAS AS cof ON ma.ID_CARRERA_OFERTADA = cof.ID_CARRERA_OFERTADA
            LEFT jOIN Bd_Academico..TP_CODIGOS AS per ON ma.CG_PER_ACADEMICO = per.CORRELATIVO
            left join aca.periodo_academico pa on pa.codigo = per.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 2
            left join (select n.id_nivel,rn.id_origen,rn.id_destino,n.descripcion as nivel from migracion_sga..registros_migracion rn
                     left join aca.nivel n on n.id_nivel = rn.id_destino and n.estado in ('A')
                    where rn.id_entidad_relacion in (6) ) as mig on mig.id_origen = niv.ID_NIVEL
            left join mig.record_oferta ro on ro.id_carrera_ofertada = ma.ID_CARRERA_OFERTADA and ro.id_tipo_oferta = 2
            and ro.identificacion= p.identificacion  and  ro.estado not in ('I') and ro.id_record_oferta not in (42892,45202,49730,50457,58805,62858,63114,66708,50286)
            left join mig.record_matricula rmo on rmo.table_name='Bd_Academico.dbo.TE_MATRICULAS' and rmo.periodo = per.VALOR_TEXTO and rmo.id_nivel_cg = niv.ID_NIVEL and rmo.id_record_oferta = ro.id_record_oferta
            left join mig.record_matricula rm on rm.id_number = ma.ID_REGISTRO and rm.table_name='sis..MATRICULAS'
            WHERE (ma.ESTADO IN ('A')) and p.estado='A' -- and p.IDENTIFICACION='0923311625'
              and rmo.id_record_matricula is null and ro.id_record_oferta is not  null and rm.id_record_matricula is null

select* from aca.periodo_academico where id_tipo_oferta = 2 and codigo ='2002-2'

select * from mig.record_oferta where id_record_oferta in (50286,50287)

select * from mig.record_matricula where id_record_oferta in (66707,66708)
--insert materias de matriculas recien ingresadas y que no estaban en el sisweb
    --se inserto 1750 materias
-- insert into mig.record_asignaturas
select distinct d.id_record_oferta, d.id_record_matricula, d.id_periodo_academico, d.id_periodo_academico_cg, d.id_malla_asignatura, d.id_materia_plan,
                   d.id_malla, d.ID_PLAN,d.id_paralelo
                   , d.id_nivel, d.id_nivel_cg, d.nivel, d.tipo_malla, d.asignatura, d.vez, d.creditos, d.horas, d.promedio, d.asistencia,
                   d.estado_tomada, d.valor, d.tipo, d.aprobado, d.estado_aprobacion, d.periodo, d.identificacion_docente, d.docente,d.orden, d.fecha_registro,
                   d.id_number,d.table_name, d.estado, d.version, d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod from (
            SELECT  ro.id_record_oferta,rm.id_record_matricula as id_record_matricula,pa.id_periodo_academico,dm.CG_PER_ACADEMICO as id_periodo_academico_cg,
           null aS id_malla_asignatura,0 as id_materia_plan,null as id_malla,null as id_plan,
                    case when dm.PARALELO in ('1/','3/1 N') then 1 when dm.PARALELO in ('2*','3/2 N') then 2 else dm.PARALELO end as id_paralelo,
            niv.id_nivel as id_nivel,niv.id_nivel as id_nivel_cg,Isnull(n.DESCRIPCION,'NO DEFINIDO') AS nivel,'NO CLASIFICADO' as tipo_malla,
            isnull(dm.NOMBREMATERIA,'S/N') as asignatura,
                    case when dm.PARALELO in ('',' ','0','+') or dm.VEZTOMADA is null then '1 VEZ' else concat(cast(dm.VEZTOMADA as varchar(20)),' VEZ') end as vez,isnull(dm.CREDITOS,0) as creditos,isnull(dm.HORAS,0) as horas,
            isnull((CASE dm.notamaxima WHEN 10 THEN (10 * dm.final) ELSE dm.final END),0) as promedio,100 as asistencia,
                    isnull(dm.ESTADO,'S/N') as estado_tomada,
            0 as valor,(CASE dm.nivel WHEN 'EX' THEN 'MODULAR' ELSE 'PLAN' END) as tipo,dm.APROBAR as aprobado,
            (CASE dm.APROBAR WHEN 1 THEN 'APROBADO' WHEN 0 THEN 'REPROBADO' ELSE 'REPROBADO' END) as estado_aprobacion,
            per.VALOR_TEXTO as periodo, 'NO APLICA' as identificacion_docente,'NO APLICA' as docente,ROW_NUMBER() OVER (PARTITION BY ro.id_record_oferta,n.ID_NIVEL ORDER BY isnull(dm.NOMBREMATERIA,'S/N')) as orden,
            isnull(dm.FECHA_CAMBIO,getdate())as fecha_registro,dm.ID_NOTA as id_number,'sis..notas' as table_name,'A' as estado,
            0 as version,getdate() as fecha_ing,getdate() as fecha_mod, '2400254286' as usuario_ing, '2400254286' as usuario_mod
            FROM   sis..MATRICULAS ma
            INNER JOIN sis..notas dm ON dm.ID_REGISTRO = ma.ID_REGISTRO
            INNER JOIN Bd_Academico..PERSONAS p ON ma.ID_PERSONA = p.ID_PERSONA
            left join bd_academico..NIVELES n on n.id_nivel = dm.id_nivel  AND n.ESTADO = 'A'
            LEFT JOIN Bd_Academico..TP_CODIGOS AS per ON per.CORRELATIVO = dm.CG_PER_ACADEMICO
            left join aca.periodo_academico pa on pa.codigo = per.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 2
            left join
               (select n.id_nivel,rn.id_origen,rn.id_destino,n.descripcion as nivel from migracion_sga..registros_migracion rn
                left join aca.nivel n on n.id_nivel = rn.id_destino and n.estado in ('A')
                where rn.id_entidad_relacion in (6) ) as niv on niv.id_origen = n.ID_NIVEL
            left join mig.record_oferta ro on ro.id_carrera_ofertada = ma.ID_CARRERA_OFERTADA and ro.id_tipo_oferta = 2
                and ro.identificacion= p.identificacion  and  ro.estado not in ('I') --and ro.numero_matricula_cg = ma.MATRICULA and
            left join mig.record_matricula rm on rm.table_name='sis..MATRICULAS' and rm.id_number = ma.ID_REGISTRO and ro.id_record_oferta=rm.id_record_oferta
            left join mig.record_asignaturas ra on ra.id_number = dm.ID_NOTA and ra.table_name ='sis..notas'
            WHERE ma.ESTADO = 'A' and p.estado='A'  AND dm.VER_EN_RECORD = 1  AND dm.ID_MATERIA_UNICO IS NOT NULL
--             and ra.id_record_asignatura is null and ro.id_record_oferta is not null  and     rm.id_record_matricula is not null
            and p.IDENTIFICACION ='0922860408'
            ) as d

            order by d.id_record_oferta,d.id_nivel_cg,d.asignatura

select * from mig.record_matricula where id_record_matricula in (36032,36039)
select * from mig.record_asignaturas where id_record_matricula in (36032,36039)
select * from mig.record_asignaturas where record_asignaturas.id_record_asignatura in (285544,285545,288837,302672,288846,302652,302650,288844,
                                                                                       288841,302647,302649,288843,288845,302651)

select * from mig.record_asignaturas where id_number_old is not null
--     288846,288844,288841,285545,288845,288837,288843
   --asignaturas de las matriculas que ya existian en el sisweb que no estan actualizados y que si estan en la base SIS
    ---ESTAS asignaturas se deben actualizar en el sisweb a traves de las bases del siss
--15637 registros a actualizar
select distinct d.IDENTIFICACION,d.id_record_asignatura,
    d.id_record_oferta, d.id_record_matricula, d.id_periodo_academico, d.id_periodo_academico_cg, d.id_malla_asignatura, d.id_materia_plan,
                   d.id_malla, d.ID_PLAN,d.id_paralelo
                   , d.id_nivel, d.id_nivel_cg, d.nivel, d.tipo_malla, d.asignatura, d.vez, d.creditos, d.horas, d.promedio, d.asistencia,
                   d.estado_tomada, d.valor, d.tipo, d.aprobado, d.estado_aprobacion, d.periodo, d.identificacion_docente, d.docente,d.orden, d.fecha_registro,
                   d.id_number,d.table_name, d.estado, d.version, d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod from (
            SELECT  p.IDENTIFICACION,p.APELLIDOS,p.NOMBRES,ma.ID_CARRERA_OFERTADA,ma.id_carrera_local,ma.ID_PERSONA,ra.id_record_asignatura,
                   ro.id_record_oferta,rm.id_record_matricula as id_record_matricula,pa.id_periodo_academico,dm.CG_PER_ACADEMICO as id_periodo_academico_cg,
           null aS id_malla_asignatura,0 as id_materia_plan,null as id_malla,null as id_plan,
                    case when dm.PARALELO in ('1/','3/1 N') then 1 when dm.PARALELO in ('2*','3/2 N') then 2 else dm.PARALELO end as id_paralelo,
            niv.id_nivel as id_nivel,niv.id_nivel as id_nivel_cg,Isnull(n.DESCRIPCION,'NO DEFINIDO') AS nivel,'NO CLASIFICADO' as tipo_malla,
            isnull(dm.NOMBREMATERIA,'S/N') as asignatura,
                    case when dm.PARALELO in ('',' ','0','+') or dm.VEZTOMADA is null then '1 VEZ' else concat(cast(dm.VEZTOMADA as varchar(20)),' VEZ') end as vez,isnull(dm.CREDITOS,0) as creditos,isnull(dm.HORAS,0) as horas,
            isnull((CASE dm.notamaxima WHEN 10 THEN (10 * dm.final) ELSE dm.final END),0) as promedio,100 as asistencia,
                    isnull(dm.ESTADO,'S/N') as estado_tomada,
            0 as valor,(CASE dm.nivel WHEN 'EX' THEN 'MODULAR' ELSE 'PLAN' END) as tipo,dm.APROBAR as aprobado,
            (CASE dm.APROBAR WHEN 1 THEN 'APROBADO' WHEN 0 THEN 'REPROBADO' ELSE 'REPROBADO' END) as estado_aprobacion,
            per.VALOR_TEXTO as periodo, 'NO REGISTRA' as identificacion_docente,'NO REGISTRA' as docente,ROW_NUMBER() OVER (PARTITION BY ro.id_record_oferta,n.ID_NIVEL ORDER BY isnull(dm.NOMBREMATERIA,'S/N')) as orden,
            isnull(dm.FECHA_CAMBIO,getdate())as fecha_registro,dm.ID_NOTA as id_number,'sis..notas' as table_name,'A' as estado,
            0 as version,getdate() as fecha_ing,getdate() as fecha_mod, '2400254286' as usuario_ing, '2400254286' as usuario_mod
-- update ra set ra.id_number_old =  dm.ID_NOTA, ra.table_name_old = 'sis..notas'
            FROM   sis..MATRICULAS ma
            INNER JOIN sis..notas dm ON dm.ID_REGISTRO = ma.ID_REGISTRO
            INNER JOIN Bd_Academico..PERSONAS p ON ma.ID_PERSONA = p.ID_PERSONA
            left join bd_academico..NIVELES n on n.id_nivel = dm.id_nivel  AND n.ESTADO = 'A'
            LEFT JOIN Bd_Academico..TP_CODIGOS AS per ON per.CORRELATIVO = dm.CG_PER_ACADEMICO
            left join aca.periodo_academico pa on pa.codigo = per.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 2
            left join
               (select n.id_nivel,rn.id_origen,rn.id_destino,n.descripcion as nivel from migracion_sga..registros_migracion rn
                left join aca.nivel n on n.id_nivel = rn.id_destino and n.estado in ('A')
                where rn.id_entidad_relacion in (6) ) as niv on niv.id_origen = n.ID_NIVEL
            left join mig.record_oferta ro on ro.id_carrera_ofertada = ma.ID_CARRERA_OFERTADA and ro.id_tipo_oferta = 2
                and ro.identificacion= p.identificacion  and  ro.estado not in ('I') --and ro.numero_matricula_cg = ma.MATRICULA and
            left join mig.record_matricula rm on rm.table_name_old='sis..MATRICULAS' and rm.id_number_old = ma.ID_REGISTRO and ro.id_record_oferta=rm.id_record_oferta
            left join mig.record_asignaturas ra on ra.id_record_matricula=rm.id_record_matricula and ra.table_name ='Bd_Academico..MATERIAS_TOMADAS' and ra.asignatura = dm.NOMBREMATERIA and ra.periodo=per.VALOR_TEXTO
                                                       and ra.estado_tomada= dm.ESTADO and ra.id_record_asignatura not in (288846,288844,288841,285545,288845,288837,288843)
            WHERE ma.ESTADO = 'A' and p.estado='A'  AND dm.VER_EN_RECORD = 1  AND dm.ID_MATERIA_UNICO IS NOT NULL --and p.IDENTIFICACION='0923311625'
              and ra.id_record_asignatura is not null and ro.id_record_oferta is not null and rm.id_record_matricula is not null
            ) as d
            order by d.id_record_oferta,d.id_nivel_cg,d.asignatura

select * from mig.record_asignaturas where record_asignaturas.id_record_matricula in (92619,92620)
select * from mig.record_matricula where record_matricula.id_record_matricula in (92620,92621)
select * from mig.record_matricula where record_matricula.id_record_oferta in (47163)
select * from mig.record_oferta where id_record_oferta in (37394)

select per.VALOR_TEXTO,ma.* from sis..MATRICULAS ma
                  INNER JOIN Bd_Academico..PERSONAS p ON ma.ID_PERSONA = p.ID_PERSONA
                  LEFT JOIN Bd_Academico..TP_CODIGOS AS per ON per.CORRELATIVO = ma.CG_PER_ACADEMICO
where p.IDENTIFICACION='0916597966'



select * from mig.record_matricula where record_matricula.id_record_oferta in (52472)

select * from mig.record_matricula where record_matricula.id_record_matricula in (123679,123680)
select * from mig.record_oferta where id_record_oferta=52471
select * from mig.record_oferta where identificacion='0917515025'

-- select top 10 * from mig.record_matricula order by id_record_matricula desc

select * from mig.record_matricula where id_record_oferta in (52471,52472)

select ra.* from mig.record_asignaturas ra
inner join mig.record_matricula rm on ra.id_record_matricula = rm.id_record_matricula
inner join mig.record_oferta ro on rm.id_record_oferta = ro.id_record_oferta
 where ro.id_record_oferta in (52471,52472)
--975 repetidos
select ro.identificacion,rm.id_record_oferta, rm.id_periodo_academico, rm.id_periodo_academico_cg, rm.id_tipo_matricula, rm.id_tipo_jornada_laboral, rm.id_paralelo,
       rm.id_nivel, rm.id_nivel_cg, rm.nivel, rm.aula, rm.curso, rm.vez, rm.promedio, rm.valor_total, rm.estado_matricula, rm.periodo, rm.table_name,count(rm.id_record_matricula) as cantidad_matriculas
       --, id_number_old, table_name_old
       from mig.record_matricula rm
       inner join mig.record_oferta ro on rm.id_record_oferta = ro.id_record_oferta
       where rm.estado<>'I'
group by rm.id_record_oferta, rm.id_periodo_academico, rm.id_periodo_academico_cg, rm.id_tipo_matricula, rm.id_tipo_jornada_laboral, rm.id_paralelo,
         rm.id_nivel, rm.id_nivel_cg, rm.nivel, rm.aula, rm.curso, rm.vez, rm.promedio, rm.valor_total, rm.estado_matricula, rm.periodo, rm.table_name, ro.identificacion
having count(rm.id_record_matricula)>1

--eliminar relaciones repetidas con las base SIS y sisweb
select rm.* from (
select ro.identificacion,ROW_NUMBER() OVER (PARTITION BY rm1.id_record_oferta, rm1.id_periodo_academico, rm1.id_periodo_academico_cg, rm1.id_tipo_matricula, rm1.id_tipo_jornada_laboral, rm1.id_paralelo,
    rm1.id_nivel, rm1.id_nivel_cg, rm1.nivel, rm1.vez, rm1.promedio, rm1.valor_total, rm1.estado_matricula, rm1.periodo, rm1.table_name,rm1.id_number_old
    ORDER BY rm1.estado,rm1.fecha_matricula ) as numero_registro, rm1.* from mig.record_matricula  rm1
inner join mig.record_oferta ro on rm1.id_record_oferta = ro.id_record_oferta
where rm1.id_number_old in (
select d.id_number_old from(
select rm.id_number_old,count(rm.id_number) as matriculasrepetidas
from mig.record_matricula  rm where rm.id_number_old is  not null
group by rm.id_number_old
having count(rm.id_number)>1)as d)
) as dd
inner join mig.record_matricula rm on rm.id_record_matricula = dd.id_record_matricula
-- where dd.numero_registro = 2
order by rm.id_number_old,rm.estado


select * from mig.record_oferta ro where ro.id_record_oferta in (47163)
-- materias de las matriculas que ya existian en el sisweb pero no que tenian estas  materias
    --antes 139451
    --133539
    --133363
    --solo toca insertar
-- insert into mig.record_asignaturas
select distinct --d.IDENTIFICACION,d.id_record_asignatura,d.nivel_matricula,d.periodo_matricula,d.estado_registro_matricula,numero_registro,
    d.id_record_oferta, d.id_record_matricula, d.id_periodo_academico, d.id_periodo_academico_cg, d.id_malla_asignatura, d.id_materia_plan,
                   d.id_malla, d.ID_PLAN,d.id_paralelo
                   , d.id_nivel, d.id_nivel_cg, d.nivel, d.tipo_malla, d.asignatura, d.vez, d.creditos, d.horas, d.promedio, d.asistencia,
                   d.estado_tomada, d.valor, d.tipo, d.aprobado, d.estado_aprobacion, d.periodo, d.identificacion_docente, d.docente,d.orden, d.fecha_registro,
                   d.id_number,d.table_name,d.id_number_old,d.table_name_old, d.estado, d.version, d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod from (
            SELECT  p.IDENTIFICACION,p.APELLIDOS,p.NOMBRES,ma.ID_CARRERA_OFERTADA,ma.id_carrera_local,ma.ID_PERSONA,
                    ra.id_record_asignatura,rm.nivel as nivel_matricula,rm.periodo as periodo_matricula,rm.estado AS estado_registro_matricula,
                    ROW_NUMBER() OVER (PARTITION BY rm.id_record_oferta, rm.id_periodo_academico, rm.id_periodo_academico_cg, rm.id_tipo_matricula, rm.id_tipo_jornada_laboral, rm.id_paralelo,
                        rm.id_nivel, rm.id_nivel_cg, rm.nivel, rm.vez, rm.promedio, rm.valor_total, rm.estado_matricula, rm.periodo, rm.table_name,rm.id_number_old,dm.NOMBREMATERIA
                        ORDER BY rm.estado,rm.fecha_matricula ) as numero_registro,
                   ro.id_record_oferta,rm.id_record_matricula as id_record_matricula,pa.id_periodo_academico,dm.CG_PER_ACADEMICO as id_periodo_academico_cg,
           null aS id_malla_asignatura,0 as id_materia_plan,null as id_malla,null as id_plan,
                    case when dm.PARALELO in ('1/','3/1 N') then 1 when dm.PARALELO in ('2*','3/2 N') then 2 else dm.PARALELO end as id_paralelo,
            niv.id_nivel as id_nivel,n.id_nivel as id_nivel_cg,Isnull(n.DESCRIPCION,'NO DEFINIDO') AS nivel,'NO CLASIFICADO' as tipo_malla,
            isnull(dm.NOMBREMATERIA,'S/N') as asignatura,
                    case when dm.PARALELO in ('',' ','0','+') or dm.VEZTOMADA is null then '1 VEZ' else concat(cast(dm.VEZTOMADA as varchar(20)),' VEZ') end as vez,isnull(dm.CREDITOS,0) as creditos,isnull(dm.HORAS,0) as horas,
            isnull((CASE dm.notamaxima WHEN 10 THEN (10 * dm.final) ELSE dm.final END),0) as promedio,100 as asistencia,
                    isnull(dm.ESTADO,'S/N') as estado_tomada,
            0 as valor,(CASE dm.nivel WHEN 'EX' THEN 'MODULAR' ELSE 'PLAN' END) as tipo,dm.APROBAR as aprobado,
            (CASE dm.APROBAR WHEN 1 THEN 'APROBADO' WHEN 0 THEN 'REPROBADO' ELSE 'REPROBADO' END) as estado_aprobacion,
            per.VALOR_TEXTO as periodo, 'NO REGISTRA' as identificacion_docente,'NO REGISTRA' as docente,
            ROW_NUMBER() OVER (PARTITION BY ro.id_record_oferta,n.ID_NIVEL ORDER BY isnull(dm.NOMBREMATERIA,'S/N')) as orden,
            isnull(dm.FECHA_CAMBIO,getdate())as fecha_registro,dm.ID_NOTA as id_number,'sis..notas' as table_name,null as id_number_old,null as table_name_old,'A' as estado,
            0 as version,getdate() as fecha_ing,getdate() as fecha_mod, '2400254286' as usuario_ing, '2400254286' as usuario_mod
            FROM   sis..MATRICULAS ma
            INNER JOIN sis..notas dm ON dm.ID_REGISTRO = ma.ID_REGISTRO
            INNER JOIN Bd_Academico..PERSONAS p ON ma.ID_PERSONA = p.ID_PERSONA
            left join bd_academico..NIVELES n on n.id_nivel = dm.id_nivel  AND n.ESTADO = 'A'
            LEFT JOIN Bd_Academico..TP_CODIGOS AS per ON per.CORRELATIVO = dm.CG_PER_ACADEMICO
            left join aca.periodo_academico pa on pa.codigo = per.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 2
            left join
               (select n.id_nivel,rn.id_origen,rn.id_destino,n.descripcion as nivel from migracion_sga..registros_migracion rn
                left join aca.nivel n on n.id_nivel = rn.id_destino --and n.estado in ('A')
                where rn.id_entidad_relacion in (6) ) as niv on niv.id_origen = n.ID_NIVEL
            left join mig.record_oferta ro on ro.id_carrera_ofertada = ma.ID_CARRERA_OFERTADA and ro.id_tipo_oferta = 2
                and ro.identificacion= p.identificacion  and  ro.estado not in ('I') --and ro.numero_matricula_cg = ma.MATRICULA and
            left join mig.record_matricula rm on rm.table_name_old='sis..MATRICULAS' and rm.id_number_old = ma.ID_REGISTRO and ro.id_record_oferta=rm.id_record_oferta and rm.estado<>'I'
            left join mig.record_asignaturas ra on ra.id_number = dm.ID_NOTA and ra.table_name ='sis..notas' and ra.asignatura = dm.NOMBREMATERIA and ra.periodo=per.VALOR_TEXTO
                                                       and ra.estado_tomada= dm.ESTADO
            WHERE ma.ESTADO = 'A' and p.estado='A'  AND dm.VER_EN_RECORD = 1  AND dm.ID_MATERIA_UNICO IS NOT NULL
              and ra.id_record_asignatura is null and ro.id_record_oferta is not null and rm.id_record_matricula is not null
            ) as d
--             where  d.numero_registro = 1
            order by d.id_record_oferta,d.id_record_matricula,d.id_nivel_cg,d.asignatura

select * from bd_academico..NIVELES n



--matriculas y records que no estan en el sisweb
--se van a insertar 153 registros de estudiantes en carreras que no estaban en el sisweb
-- insert into mig.record_oferta
    select distinct d.id_record_oferta_padre, d.id_periodo_academico, d.id_periodo_academico_cg, d.id_tipo_jornada_laboral, d.tipo_estudiante, d.id_tipo_ingreso_estudiante,
           d.id_tipo_estado_estudiante, d.id_persona_cg, d.id_carrera_ofertada, d.id_area,d.id_tipo_oferta,d.id_sistema_estudio,d.id_sistema_estudio_cg, d.id_oferta_modalidad,
           d.id_estudiante_oferta,null as id_estudiante_oferta_destino, d.id_modalidad_cg,
           d.modalidad, d.periodo, d.sistema_estudio, d.facultad,d.carrera, d.carrera, d.escuela, d.area, d.numero_matricula, d.numero_matricula_cg, d.mantiene_gratuidad, d.promedio,
           d.identificacion, d.nombres, d.apellidos, d.fecha_ingreso, d.id_number, d.table_name, d.estado, d.version, d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod from (
    select distinct null as id_record_oferta_padre,pa.id_periodo_academico as id_periodo_academico,ma.CG_PER_ACADEMICO as id_periodo_academico_cg,
                    case when ma.JORNADA in ('NOCTURNA','NOCTURNO') then 3 when ma.JORNADA in ('VESPERTINO') THEN 2 WHEN ma.JORNADA in ('DIURNA','DIURNO') then 1 else 1 end as id_tipo_jornada_laboral,
           3 as tipo_estudiante,2 as id_tipo_ingreso_estudiante,1 as id_tipo_estado_estudiante,p.ID_PERSONA as id_persona_cg,
           isnull(ma.ID_CARRERA_OFERTADA,ma.ID_CARRERA_LOCAL) as id_carrera_ofertada,
    null as id_area,2 as id_tipo_oferta,mig.id_sistema_estudio,ma.CG_SISTEMA_ESTUDIO as id_sistema_estudio_cg,
    aux.id_oferta_modalidad as id_oferta_modalidad,aux.id_estudiante_oferta  as id_estudiante_oferta,ma.cg_modalidad as id_modalidad_cg, mo.valor_texto as modalidad, per.VALOR_TEXTO as periodo,
    isnull(sis.VALOR_TEXTO,'SEMESTRAL') as sistema_estudio,cl.FACULTAD as facultad,
    iif(aux.id_estudiante_oferta is not null,aux.oferta,cl.CARRERA) as carrera, -- cl.CARRERA as carrera,
    cl.ESCUELA as escuela,null as area, aux.numero_matricula as numero_matricula, ma.MATRICULA as numero_matricula_cg,1 as mantiene_gratuidad,0 as promedio,
    p.IDENTIFICACION as identificacion,p.nombres as nombres,p.apellidos as apellidos,
     CASE  when ma.FECHA_MATRICULA = 'Abril 29/2' then cast('2005-04-29 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '0917280883' then cast('1999-01-01 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '11//04/200' then cast('2006-04-11 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '122/10/199' then cast('1999-10-12 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '2704/2005' then cast('2005-04-27 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '1105/2005' then cast('2005-05-11 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA in ('29/02/1999','29|02|1999') then cast('1999-02-28 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA in ('30/02/2000') then cast('2000-02-28 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA in ('31/11/2002') then cast('2002-11-30 00:00:00' as datetime2)
                         WHEN ma.FECHA_MATRICULA IS NOT NULL AND LEN(ma.FECHA_MATRICULA) < 10 THEN
                             TRY_CONVERT(DATETIME,CONCAT(LEFT(ma.FECHA_MATRICULA, LEN(ma.FECHA_MATRICULA) - 3), SUBSTRING(per.VALOR_TEXTO, 1, 4)),103)
                         when TRY_CONVERT(DATETIME, REPLACE(ma.FECHA_MATRICULA, '|', '/'), 103) IS NOT NULL then TRY_CONVERT(DATETIME, REPLACE(ma.FECHA_MATRICULA, '|', '/'), 103)
                       WHEN ma.FECHA_MATRICULA IS NOT NULL and TRY_CONVERT(DATETIME, REPLACE(ma.FECHA_MATRICULA, '|', '/'), 103) IS not NULL
                                and len(ma.FECHA_MATRICULA)=10 THEN CONVERT(DATETIME, REPLACE(per.VALOR_TEXTO, '|', '/'), 103)
                        WHEN ma.FECHA_MATRICULA IS NULL and per.VALOR_TEXTO LIKE '%-1' THEN cast(CONCAT(SUBSTRING(per.VALOR_TEXTO, 1, 4), '-01-01 00:00:00') as datetime2)
                       WHEN ma.FECHA_MATRICULA IS NULL and per.VALOR_TEXTO LIKE '%-2' THEN cast(CONCAT(SUBSTRING(per.VALOR_TEXTO, 1, 4), '-07-01 00:00:00') as datetime2)
                         WHEN ma.FECHA_MATRICULA IS NULL and per.VALOR_TEXTO LIKE '%-3' THEN cast(CONCAT(SUBSTRING(per.VALOR_TEXTO, 1, 4), '-09-01 00:00:00') as datetime2)
                       ELSE NULL END  as fecha_ingreso,
--             isnull(m.ID_CARRERA_OFERTADA,m.id_carrera_local) as id_number,
    ma.ID_REGISTRO as id_number,
    'sis..MATRICULAS' as table_name,
    ma.estado as estado,0 as version,getdate() as fecha_ing,getdate() as fecha_mod,
    '2400254286' as usuario_ing, '2400254286' as usuario_mod,
                    ROW_NUMBER() OVER (PARTITION BY ma.ID_PERSONA,ma.ID_CARRERA_OFERTADA,ma.CG_SISTEMA_ESTUDIO,ma.MATRICULA
                        ORDER BY CASE  when ma.FECHA_MATRICULA = 'Abril 29/2' then cast('2005-04-29 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '0917280883' then cast('1999-01-01 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '11//04/200' then cast('2006-04-11 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '122/10/199' then cast('1999-10-12 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '2704/2005' then cast('2005-04-27 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '1105/2005' then cast('2005-05-11 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA in ('29/02/1999','29|02|1999') then cast('1999-02-28 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA in ('30/02/2000') then cast('2000-02-28 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA in ('31/11/2002') then cast('2002-11-30 00:00:00' as datetime2)
                         WHEN ma.FECHA_MATRICULA IS NOT NULL AND LEN(ma.FECHA_MATRICULA) < 10 THEN
                             TRY_CONVERT(DATETIME,CONCAT(LEFT(ma.FECHA_MATRICULA, LEN(ma.FECHA_MATRICULA) - 3), SUBSTRING(per.VALOR_TEXTO, 1, 4)),103)
                         when TRY_CONVERT(DATETIME, REPLACE(ma.FECHA_MATRICULA, '|', '/'), 103) IS NOT NULL then TRY_CONVERT(DATETIME, REPLACE(ma.FECHA_MATRICULA, '|', '/'), 103)
                       WHEN ma.FECHA_MATRICULA IS NOT NULL and TRY_CONVERT(DATETIME, REPLACE(ma.FECHA_MATRICULA, '|', '/'), 103) IS not NULL
                                and len(ma.FECHA_MATRICULA)=10 THEN CONVERT(DATETIME, REPLACE(per.VALOR_TEXTO, '|', '/'), 103)
                        WHEN ma.FECHA_MATRICULA IS NULL and per.VALOR_TEXTO LIKE '%-1' THEN cast(CONCAT(SUBSTRING(per.VALOR_TEXTO, 1, 4), '-01-01 00:00:00') as datetime2)
                       WHEN ma.FECHA_MATRICULA IS NULL and per.VALOR_TEXTO LIKE '%-2' THEN cast(CONCAT(SUBSTRING(per.VALOR_TEXTO, 1, 4), '-07-01 00:00:00') as datetime2)
                         WHEN ma.FECHA_MATRICULA IS NULL and per.VALOR_TEXTO LIKE '%-3' THEN cast(CONCAT(SUBSTRING(per.VALOR_TEXTO, 1, 4), '-09-01 00:00:00') as datetime2)
                       ELSE NULL END ) as orden
    from bd_academico..personas p
    inner join sis..MATRICULAS ma on p.id_persona=ma.id_persona
    inner join Bd_Academico.dbo.vw_te_carreras_localidad cl on cl.id_carrera_local= ma.id_carrera_local
    LEFT jOIN Bd_Academico..TP_CODIGOS AS per ON ma.CG_PER_ACADEMICO = per.CORRELATIVO
    left join aca.periodo_academico pa on pa.codigo = per.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 2
    left join Bd_Academico.dbo.tp_codigos mo on mo.correlativo=ma.cg_modalidad
    left join Bd_Academico.dbo.tp_codigos sis on  sis.correlativo=ma.cg_sistema_estudio
    left join [migracion_sga].[dbo].[registros_migracion] rmo on  rmo.id_origen  = ma.ID_CARRERA_OFERTADA and rmo.id_entidad_relacion = 2
    left join (select p.id as idPersona,p.identificacion,eo.id_estudiante_oferta,om.id_oferta_modalidad,eo.numero_matricula,o.descripcion as oferta from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.oferta o on o.id_oferta = om.id_oferta
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    where eo.estado ='A') as aux on aux.id_oferta_modalidad = rmo.id_destino and aux.identificacion = p.identificacion
    left join (select s.id_sistema_estudio,rn.id_origen,rn.id_destino,s.descripcion as sistema_estudio from migracion_sga..registros_migracion rn
                        left join aca.sistema_estudio s on s.id_sistema_estudio = rn.id_destino and s.estado in ('A')
               where rn.id_entidad_relacion in (40) ) as mig on mig.id_origen = ma.CG_SISTEMA_ESTUDIO
    where ma.estado not in ('E','X') and p.estado='A' --and p.identificacion='2400254286'
    and ma.id_nivel in (select id_nivel from Bd_Academico.dbo.niveles where interfaz=3)
      and ma.CG_PER_ACADEMICO <28470
    and cl.CARRERA<>'CENTRO DE IDIOMAS'
    and (aux.id_oferta_modalidad is null or aux.id_oferta_modalidad not in (select d.idOfertaModalidadPregrado from [rel].[fn_relaciones_ofertas_nivelacion_grado] (32) as d
    where d.idOfertaModalidadNivelacion not in (select dd.idOfertaModalidadNivelacion from [rel].[fn_relaciones_ofertas_nivelacion_grado] (15)as dd)))
    ) as d
    left join mig.record_oferta ro on ro.id_tipo_oferta = 2 and ro.identificacion= d.identificacion
                                          and ro.id_carrera_ofertada = d.id_carrera_ofertada and d.id_sistema_estudio_cg=ro.id_sistema_estudio_cg
--     and ro.numero_matricula_cg = d.numero_matricula_cg
    where ro.id_record_oferta is null and d.id_persona_cg  not in(5995) and d.orden=1
    order by d.apellidos,d.nombres,d.carrera,d.fecha_ingreso,d.estado

select * from mig.record_oferta where table_name ='sis..MATRICULAS'

-- insertar 192 matriculas nuevas activas, y 13 anuladas de los 153 records que no estaban en el sisweb
-- insert into mig.record_matricula
  SELECT distinct  --p.IDENTIFICACION,p.APELLIDOS,p.NOMBRES,ma.ID_CARRERA_OFERTADA,ma.id_carrera_local,ma.ID_PERSONA,cl.CARRERA,ma.MATRICULA,
                  ro.id_record_oferta as id_record_oferta,pa.id_periodo_academico as id_periodo_academico,
        ma.CG_PER_ACADEMICO as id_periodo_academico_cg,case   when ma.PERIODO_MATRICULA in ('ORDNARIA','ORDINARIO','ORDINARIAS','ORDINARIA') then 1
                    when ma.PERIODO_MATRICULA in ('EXTRAORDINARIO','EXTRAORDINARIA') THEN 2
                 when ma.PERIODO_MATRICULA in ('EXCEPCIONAL','ESPECIAL') then 3 else 1 end  as id_tipo_matricula,
       case when ma.JORNADA in ('NOCTURNA','NOCTURNO') then 3 when ma.JORNADA in ('VESPERTINO') THEN 2 WHEN ma.JORNADA in ('DIURNA','DIURNO') then 1 else 1 end as id_tipo_jornada_laboral,
                    isnull(ma.PARALELO,1) as id_paralelo,
                   mig.id_destino as id_nivel,niv.ID_NIVEL as id_nivel_cg, niv.DESCRIPCION AS nivel,'NO DEFINIDA' as aula, isnull(ma.CURSO,'NO DEFINIDO') as curso,
                '1 VEZ' as vez,0 as promedio,0 as valor,null as observacion,
             'POR DEFINIR' as estado_matricula,--ma.FECHA_MATRICULA,REPLACE(ma.FECHA_MATRICULA, '|', '/'),CONCAT(REPLACE(ma.FECHA_MATRICULA, '|', '/'), ' 00:00:00'),
                   CASE  when ma.FECHA_MATRICULA = 'Abril 29/2' then cast('2005-04-29 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '0917280883' then cast('1999-01-01 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '11//04/200' then cast('2006-04-11 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '122/10/199' then cast('1999-10-12 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '2704/2005' then cast('2005-04-27 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA = '1105/2005' then cast('2005-05-11 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA in ('29/02/1999','29|02|1999') then cast('1999-02-28 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA in ('30/02/2000') then cast('2000-02-28 00:00:00' as datetime2)
                         when ma.FECHA_MATRICULA in ('31/11/2002') then cast('2002-11-30 00:00:00' as datetime2)
                         WHEN ma.FECHA_MATRICULA IS NOT NULL AND LEN(ma.FECHA_MATRICULA) < 10 THEN
                             TRY_CONVERT(DATETIME,CONCAT(LEFT(ma.FECHA_MATRICULA, LEN(ma.FECHA_MATRICULA) - 3), SUBSTRING(per.VALOR_TEXTO, 1, 4)),103)
                         when TRY_CONVERT(DATETIME, REPLACE(ma.FECHA_MATRICULA, '|', '/'), 103) IS NOT NULL then TRY_CONVERT(DATETIME, REPLACE(ma.FECHA_MATRICULA, '|', '/'), 103)
                       WHEN ma.FECHA_MATRICULA IS NOT NULL and TRY_CONVERT(DATETIME, REPLACE(ma.FECHA_MATRICULA, '|', '/'), 103) IS not NULL
                                and len(ma.FECHA_MATRICULA)=10 THEN CONVERT(DATETIME, REPLACE(per.VALOR_TEXTO, '|', '/'), 103)
                        WHEN ma.FECHA_MATRICULA IS NULL and per.VALOR_TEXTO LIKE '%-1' THEN cast(CONCAT(SUBSTRING(per.VALOR_TEXTO, 1, 4), '-01-01 00:00:00') as datetime2)
                       WHEN ma.FECHA_MATRICULA IS NULL and per.VALOR_TEXTO LIKE '%-2' THEN cast(CONCAT(SUBSTRING(per.VALOR_TEXTO, 1, 4), '-07-01 00:00:00') as datetime2)
                         WHEN ma.FECHA_MATRICULA IS NULL and per.VALOR_TEXTO LIKE '%-3' THEN cast(CONCAT(SUBSTRING(per.VALOR_TEXTO, 1, 4), '-09-01 00:00:00') as datetime2)
                       ELSE NULL END AS fecha_matricula,
             per.VALOR_TEXTO as periodo,
            ma.ID_REGISTRO as id_number,'sis..MATRICULAS' as table_name, null as id_number_old,null as table_name_old,ma.ESTADO as estado,
               0 as version,getdate() as fecha_ing,getdate() as fecha_mod,
               '2400254286' as usuario_ing, '2400254286' as usuario_mod
            FROM   sis..MATRICULAS as ma
            INNER JOIN Bd_Academico..PERSONAS p ON ma.ID_PERSONA = p.ID_PERSONA
            inner join Bd_Academico.dbo.vw_te_carreras_localidad cl on cl.id_carrera_local= ma.id_carrera_local
            left JOIN sis..NIVELES niv ON ma.ID_NIVEL = niv.ID_NIVEL
            LEFT JOIN Bd_Academico..VW_CARRERAS_OFERTADAS AS cof ON ma.ID_CARRERA_OFERTADA = cof.ID_CARRERA_OFERTADA
            LEFT jOIN Bd_Academico..TP_CODIGOS AS per ON ma.CG_PER_ACADEMICO = per.CORRELATIVO
            left join aca.periodo_academico pa on pa.codigo = per.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 2
            left join (select n.id_nivel,rn.id_origen,rn.id_destino,n.descripcion as nivel from migracion_sga..registros_migracion rn
                     left join aca.nivel n on n.id_nivel = rn.id_destino and n.estado in ('A')
                    where rn.id_entidad_relacion in (6) ) as mig on mig.id_origen = niv.ID_NIVEL
            left join mig.record_oferta ro on ro.id_carrera_ofertada = ma.ID_CARRERA_OFERTADA and ro.id_tipo_oferta = 2
      and ro.identificacion= p.identificacion  and  ro.estado not in ('I') and ro.table_name='sis..MATRICULAS'
            left join mig.record_matricula rm on rm.id_number = ma.ID_REGISTRO and rm.table_name='sis..MATRICULAS'
            WHERE  p.estado='A' and (ma.ESTADO not IN ('I')) -- and p.IDENTIFICACION='0923311625'
            and ro.id_record_oferta is not null and rm.id_record_matricula is null

--insertar asignaturas de los records y matriculas faltantes
--se insertaran 1114 asignaturas
-- insert into mig.record_asignaturas
select distinct --d.IDENTIFICACION,d.id_record_asignatura,d.nivel_matricula,d.periodo_matricula,d.estado_registro_matricula,numero_registro,
    d.id_record_oferta, d.id_record_matricula, d.id_periodo_academico, d.id_periodo_academico_cg, d.id_malla_asignatura, d.id_materia_plan,
                   d.id_malla, d.ID_PLAN,d.id_paralelo
                   , d.id_nivel, d.id_nivel_cg, d.nivel, d.tipo_malla, d.asignatura, d.vez, d.creditos, d.horas, d.promedio, d.asistencia,
                   d.estado_tomada, d.valor, d.tipo, d.aprobado, d.estado_aprobacion, d.periodo, d.identificacion_docente, d.docente,d.orden, d.fecha_registro,
                   d.id_number,d.table_name,d.id_number_old,d.table_name_old, d.estado, d.version, d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod from (
            SELECT  p.IDENTIFICACION,p.APELLIDOS,p.NOMBRES,ma.ID_CARRERA_OFERTADA,ma.id_carrera_local,ma.ID_PERSONA,
                    ra.id_record_asignatura,rm.nivel as nivel_matricula,rm.periodo as periodo_matricula,rm.estado AS estado_registro_matricula,
                    ROW_NUMBER() OVER (PARTITION BY rm.id_record_oferta, rm.id_periodo_academico, rm.id_periodo_academico_cg, rm.id_tipo_matricula, rm.id_tipo_jornada_laboral, rm.id_paralelo,
                        rm.id_nivel, rm.id_nivel_cg, rm.nivel, rm.vez, rm.promedio, rm.valor_total, rm.estado_matricula, rm.periodo, rm.table_name,rm.id_number_old,dm.NOMBREMATERIA
                        ORDER BY rm.estado,rm.fecha_matricula ) as numero_registro,
                   ro.id_record_oferta,rm.id_record_matricula as id_record_matricula,pa.id_periodo_academico,dm.CG_PER_ACADEMICO as id_periodo_academico_cg,
           null aS id_malla_asignatura,0 as id_materia_plan,null as id_malla,null as id_plan,
                    case when dm.PARALELO in ('1/','3/1 N') then 1 when dm.PARALELO in ('2*','3/2 N') then 2 else dm.PARALELO end as id_paralelo,
            niv.id_nivel as id_nivel,n.id_nivel as id_nivel_cg,Isnull(n.DESCRIPCION,'NO DEFINIDO') AS nivel,'NO CLASIFICADO' as tipo_malla,
            isnull(dm.NOMBREMATERIA,'S/N') as asignatura,
                    case when dm.PARALELO in ('',' ','0','+') or dm.VEZTOMADA is null then '1 VEZ' else concat(cast(dm.VEZTOMADA as varchar(20)),' VEZ') end as vez,isnull(dm.CREDITOS,0) as creditos,isnull(dm.HORAS,0) as horas,
            isnull((CASE dm.notamaxima WHEN 10 THEN (10 * dm.final) ELSE dm.final END),0) as promedio,100 as asistencia,
                    isnull(dm.ESTADO,'S/N') as estado_tomada,
            0 as valor,(CASE dm.nivel WHEN 'EX' THEN 'MODULAR' ELSE 'PLAN' END) as tipo,dm.APROBAR as aprobado,
            (CASE dm.APROBAR WHEN 1 THEN 'APROBADO' WHEN 0 THEN 'REPROBADO' ELSE 'REPROBADO' END) as estado_aprobacion,
            per.VALOR_TEXTO as periodo, 'NO REGISTRA' as identificacion_docente,'NO REGISTRA' as docente,
            ROW_NUMBER() OVER (PARTITION BY ro.id_record_oferta,n.ID_NIVEL ORDER BY isnull(dm.NOMBREMATERIA,'S/N')) as orden,
            isnull(dm.FECHA_CAMBIO,getdate())as fecha_registro,dm.ID_NOTA as id_number,'sis..notas' as table_name,null as id_number_old,null as table_name_old,'A' as estado,
            0 as version,getdate() as fecha_ing,getdate() as fecha_mod, '2400254286' as usuario_ing, '2400254286' as usuario_mod
            FROM   sis..MATRICULAS ma
            INNER JOIN sis..notas dm ON dm.ID_REGISTRO = ma.ID_REGISTRO
            INNER JOIN Bd_Academico..PERSONAS p ON ma.ID_PERSONA = p.ID_PERSONA
            left join bd_academico..NIVELES n on n.id_nivel = dm.id_nivel  AND n.ESTADO = 'A'
            LEFT JOIN Bd_Academico..TP_CODIGOS AS per ON per.CORRELATIVO = dm.CG_PER_ACADEMICO
            left join aca.periodo_academico pa on pa.codigo = per.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 2
            left join
               (select n.id_nivel,rn.id_origen,rn.id_destino,n.descripcion as nivel from migracion_sga..registros_migracion rn
                left join aca.nivel n on n.id_nivel = rn.id_destino --and n.estado in ('A')
                where rn.id_entidad_relacion in (6) ) as niv on niv.id_origen = n.ID_NIVEL
            left join mig.record_oferta ro on ro.id_carrera_ofertada = ma.ID_CARRERA_OFERTADA and ro.id_tipo_oferta = 2
                and ro.identificacion= p.identificacion  and  ro.estado not in ('I') and ro.table_name='sis..MATRICULAS'
            left join mig.record_matricula rm on rm.table_name='sis..MATRICULAS' and rm.id_number = ma.ID_REGISTRO and rm.estado<>'I'
            left join mig.record_asignaturas ra on ra.id_number = dm.ID_NOTA and ra.table_name ='sis..notas'
            WHERE ma.ESTADO not in ('I') and p.estado='A'  AND dm.VER_EN_RECORD = 1  AND dm.ID_MATERIA_UNICO IS NOT NULL
              and ra.id_record_asignatura is null and ro.id_record_oferta is not null and rm.id_record_matricula is not null
            ) as d
--             where  d.numero_registro = 1
            order by d.id_record_oferta,d.id_record_matricula,d.id_nivel_cg,d.asignatura,d.fecha_registro

--ACTUALIZAR RECORD ASIGNATURA EL CAMPO RECORD OFERTA:
select  rm.id_record_oferta,ra.*
-- update ra set ra.id_record_oferta = rm.id_record_oferta
from mig.record_asignaturas ra
inner join mig.record_matricula rm on ra.id_record_matricula = rm.id_record_matricula
where rm.id_record_oferta<>ra.id_record_oferta

select * from even.eventos

select * from aca.periodo_academico where id_tipo_oferta = 1

select * from pro.proceso where id_tipo_proceso = 7

select * from [mig].[sp_listar_personas_by_filter]('2400','identificacion')

SELECT p.id, p.identificacion,p.apellidos,p.nombres,p.email_personal,p.email_institucional,p.fecha_nace,p.celular,p.telefono,p.estado
FROM man.personas p WHERE p.fecha_nace LIKE '%[A-Za-z]%';

select * from Bd_Academico..PERSONAS where APELLIDOS like '%FIGUEROA SUAREZ%'

select * from man.PERSONAS where APELLIDOS like '%SAENZ BARRERA%'

select p.id, p.identificacion,p.apellidos,p.nombres,p.email_personal,p.email_institucional,p.fecha_nace,p.celular,n.descripcion as nacionalidad,p.direccion from man.personas p
left join man.lugar n on n.id_lugar = p.id_pais_nacionalidad
where  p.identificacion like concat('%','2400','%') and p.estado='AC'

select * from [mig].[sp_listar_personas_by_filter]('c_me','email')

select * from [mig].[sp_listar_personas_by_filter]('eduarda','nombres')

select c.country_name,l.*
--     update l set l.codigo=LOWER(c.country_short_name)
from man.lugar l
         left join mig.countries c on c.country_name=l.descripcion
         where l.id_lugar_padre is null and c.id is not null

select p.id, p.identificacion,p.apellidos,p.nombres,p.email_personal,p.email_institucional,p.fecha_nace,p.celular,n.descripcion as nacionalidad,p.direccion from man.personas p
left join man.lugar n on n.id_lugar = p.id_pais_nacionalidad
where  p.email_personal like concat('mend','%')
--    or p.email_institucional like concat('%','c_men','%')
          and p.estado='AC'

select * from man.personas
where estado='AC'


select * from mig.estado_academicos where identificacion='0927942342'
select * from man.tipo_sangre

select * from man.personas where identificacion in ('0928020676','2450882945')


--persona que tomo primera vez en sisweb y segunda vez en el sga
select d.id_record_oferta,d.id_record_oferta_padre,d.id_estudiante_oferta, d.id_estudiante_oferta_padre, d.id_estudiante_oferta_destino, d.identificacion,
       d.apellidos, d.nombres, d.id_oferta_modalidad, d.id_carrera_ofertada,d.facultad, d.carrera,d.area,d.numero_matricula, d.codigo_estado_carrera, d.estado_carrera, d.codigo_ingreso, d.tipo_ingreso,
       d.periodo_primer, d.periodo_ultimo, (d.numero_matriculas_sis+ d.numero_matriculas_sga) as numero_matriculas, d.estado_registro, d.origen, d.id_tipo_oferta,
       d.periodo_cupo from (
select * from mig.listar_carreras_sisweb sis
union all
select * from mig.listar_carreras_sga as sga
)as d
where d.id_tipo_oferta=1 and d.identificacion='2450813577'

select * from mig.listar_carreras_sisweb sis where sis.identificacion='2450813577'
select * from mig.listar_carreras_sga sis where sis.identificacion='2450813577'


--volver aquiii
select d.*
--     om.id_oferta,omp.id_oferta,eop.*
--     update eo set eo.numero_matricula = d.numero_matricula_cg,eo.fecha_mod=getdate(),eo.usuario_mod='2400254286'
-- update eop set eop.numero_matricula = eo.numero_matricula,eop.fecha_mod=getdate(),eop.usuario_mod='2400254286'
-- update ro set ro.numero_matricula=ro.numero_matricula_cg,ro.usuario_mod='2400254286',ro.fecha_mod=getdate(),ro.estado='A'
from (
select ro.id_persona_cg,eg.MATRICULA,o.NOMBRE,p.identificacion,p.apellidos,p.nombres,ro.carrera,ro.estado as estado_migracion,eo.id_estudiante_oferta,eo.estado,
       count(em.id_estudiante_matricula) as matriculas,ro.id_record_oferta,ro.numero_matricula_cg,ro.numero_matricula
from mig.record_oferta ro
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_estudiante_oferta
inner join man.personas p on eo.id_persona = p.id
left join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
left join Bd_Academico..PERSONAS pp on ro.id_persona_cg = pp.ID_PERSONA
left join Bd_academico.dbo.EG_EGRESADOS eg on eg.ID_PERSONA = pp.ID_PERSONA
left join Bd_Academico.dbo.carreras_locales_modalidad_sistema o on o.ID_CARRERA_LOCAL= eg.ID_CARRERA_LOCAL and o.CG_MODALIDAD = eg.CG_MODALIDAD
where
--     ro.numero_matricula<>ro.numero_matricula_cg --and
concat(ro.numero_matricula_cg,'-RED')<>ro.numero_matricula

and ro.numero_matricula is not null and eg.ID_EGRESADO is null
   and ro.estado not in ('I')
group by ro.id_persona_cg,eo.estado, ro.id_record_oferta,eo.id_estudiante_oferta, ro.numero_matricula_cg, ro.numero_matricula, p.identificacion, p.apellidos, p.nombres, ro.carrera, eg.MATRICULA, o.NOMBRE,ro.estado
having count(em.id_estudiante_matricula)>0
-- order by p.apellidos,p.nombres
    ) as d
inner join aca.estudiante_oferta eo on d.id_estudiante_oferta = eo.id_estudiante_oferta
-- inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
-- left join aca.estudiante_oferta eop on eop.id_estudiante_oferta_padre = eo.id_estudiante_oferta
-- left join aca.oferta_modalidad omp on omp.id_oferta_modalidad = eop.id_oferta_modalidad
inner join mig.record_oferta ro on ro.id_record_oferta = d.id_record_oferta
-- where eop.id_estudiante_oferta is not null and om.id_oferta = omp.id_oferta
--and ro.identificacion='0750152183'

select * from mig.record_matricula where id_record_oferta = 36113


select * from man.personas where identificacion ='2450670829'
select * from man.personas where apellidos like '%ARANGO QUINTERO%' and nombres like '%PAOLA ANDREA%'
select * from man.personas where apellidos like '%PARRALES CALDERON%' and nombres like '%MARCOS JUNIOR%'

select * from mig.estado_academicos where identificacion='0927369314'

update ea set ea.id_estado_cauistica = 13,observacion='SI HABIA EFECTIVIZADO CUPO EN OTRO SISTEMA',fecha_mod=getdate() from mig.estado_academicos ea  where ea.identificacion='0927369314'

--   12016591353	12016591353-RED

select * from Bd_Academico..TE_MATRICULAS te where te.ID_PERSONA = 25964 and MATRICULA='12020050516'
--     {bcrypt}$2a$10$yruKS4CIRg9OoVciQLfPJ.DbzhVFKd7Q.pG3bRKMbLlgPek8LWICu
select * from seg.usuarios where persona_id = 323

select * from mig.record_oferta where identificacion='2450018078'
-- select * from mig.record_oferta where identificacion='2450409418'

--     2022233300656	12019601019

select * from mig.record_matricula where id_record_oferta in (56206,56206)



select * from mig.record_asignaturas where id_record_oferta in (56206,56206)

--ver si existen personas con records cruzados por el numero de matricula
 select top 100  ro.carrera,eo.numero_matricula,ro.numero_matricula_cg,ro.identificacion,ro.apellidos,ro.nombres,p.identificacion,p.apellidos,p.nombres from mig.record_oferta ro
inner join aca.estudiante_oferta eo on eo.numero_matricula = ro.numero_matricula_cg
inner join man.personas p on eo.id_persona = p.id
-- inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
-- inner join aca.oferta o on om.id_oferta = o.id_oferta
where p.identificacion <>ro.identificacion and ro.id_tipo_oferta >1
--   and ro.numero_matricula_cg<>'POR DEFINIR'

select eg.MATRICULA,o.NOMBRE,p.identificacion,p.apellidos,p.nombres,ro.carrera,ro.estado as estado_migracion,eo.id_estudiante_oferta,eo.estado,
       count(em.id_estudiante_matricula) as matriculas,ro.id_record_oferta,ro.numero_matricula,ro.numero_matricula_cg
from mig.record_oferta ro
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_estudiante_oferta
inner join man.personas p on eo.id_persona = p.id
left join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
left join Bd_Academico..PERSONAS pp on ro.id_persona_cg = pp.ID_PERSONA
left join Bd_academico.dbo.EG_EGRESADOS eg on eg.ID_PERSONA = pp.ID_PERSONA
left join Bd_Academico.dbo.carreras_locales_modalidad_sistema o on o.ID_CARRERA_LOCAL= eg.ID_CARRERA_LOCAL and o.CG_MODALIDAD = eg.CG_MODALIDAD
where ro.numero_matricula<>ro.numero_matricula_cg
and ro.numero_matricula is not null and eg.ID_EGRESADO is null and
    ro.estado not in ('I')
group by eo.estado, ro.id_record_oferta,eo.id_estudiante_oferta, ro.numero_matricula_cg, ro.numero_matricula, p.identificacion, p.apellidos, p.nombres, ro.carrera, eg.MATRICULA, o.NOMBRE, ro.estado
having count(em.id_estudiante_matricula)=0
order by p.apellidos,p.nombres
-- 2400161465
-- 0931026652
-- 0750152183
select * from mig.record_oferta where identificacion  in ('2400099723','2400304966')
select * from aca.tipo_estado_estudiante
select * from mig.record_oferta where id_oferta_modalidad = 32
--     20220590004

select * from aca.estudiante_oferta where id_estudiante_oferta = 11470


select * from Bd_Academico.dbo.carreras_locales_modalidad_sistema
select * from mig.estado_academicos where identificacion in ('FB612715','1006515715')
select * from mig.estado_academicos where identificacion in ('2400099723','2400304966')
select * from man.personas where identificacion in ('0750989030')

select * from mig.causistica
select * from aca.estudiante_oferta where id_estudiante_oferta_padre = 11575
--     2022125301308
-- DBCC CHECKIDENT ('aca.tipo_ingreso_estudiante', RESEED, 23)
select * from aca.tipo_ingreso_estudiante
select * from Bd_Academico..TE_MATRICULAS where MATRICULA='12021171635' and
                                                ID_PERSONA = 12750
select * from aca.estudiante_oferta where numero_matricula='202210590004'
--                                               ID_MATRICULA=236036
select * from Bd_Academico..TE_MATRICULAS where MATRICULA='12019561721'
select * from mig.record_oferta where identificacion = '2400099723'

select * from mig.record_oferta where numero_matricula_cg='12019561721'


select p.* from bdupse.snu.aspirante p where identificacion='2400099723'

select * from Bd_Academico..PERSONAS where ID_PERSONA=45021



select m.* from aca.movilidad m
left join aca.detalle_movilidad dm on m.id_movilidad = dm.id_movilidad
         where m.id_estudiante_oferta = 45499
select * from aca.malla_asignatura where id_malla_asignatura =883
--caso de una persona que tiene una matricula anulada en el sisweb y una valida en el sga
--     0705423457
select * from Bd_academico.dbo.EG_EGRESADOS

select  * from mig.record_oferta ro
where ro.numero_matricula=ro.numero_matricula_cg
--   and ro.numero_matricula is null
  and ro.estado<>'I' and ro.identificacion='0750152183'

select * from aca.estudiante_oferta where numero_matricula='2022237300409'

select * from aca.estudiante_historial




select * from mig.estado_academicos where identificacion='0750152183'
select p.identificacion,tee1.descripcion,tee2.descripcion,eo.*
--     update eo set eo.id_tipo_ingreso_estudiante = ro.id_tipo_ingreso_estudiante
--     update ro set ro.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante,ro.fecha_mod= getdate(),ro.usuario_mod='2400254286'
from aca.estudiante_oferta eo
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join mig.record_oferta ro on ro.id_estudiante_oferta = eo.id_estudiante_oferta
inner join aca.tipo_estado_estudiante tee1 on eo.id_tipo_estado_estudiante = tee1.id_tipo_estado_estudiante
inner join aca.tipo_estado_estudiante tee2 on ro.id_tipo_estado_estudiante = tee2.id_tipo_estado_estudiante
where o.id_tipo_oferta = 1 and ro.id_tipo_oferta = 1
    and cast(ro.fecha_mod as date )= cast(getdate() as date)
--   and p.identificacion='0927942342'
--   and eo.id_tipo_estado_estudiante <>ro.id_tipo_estado_estudiante

select * from mig.record_oferta where identificacion='0927942342'

select * from mig.record_oferta where identificacion='2450310533'


select p.*
--     p.id,p.identificacion,p.apellidos,p.nombres,p.id_pais_nacionalidad,p.id_provincia_residencia,p.ciudad,p.direccion,p.id_nacionalidad,p.id_pais_residencia
--        ,p.id_provincia_residencia,p.id_canton_residencia,p.id_parroquia_residencia,p.estado
--        ,l.descripcion,lp.descripcion,n.descripcion
-- update p set p.id_provincia_residencia = l.id_lugar_padre,p.id_pais_residencia=lp.id_lugar_padre,p.id_pais_nacionalidad=lp.id_lugar_padre
-- update p set p.id_pais_residencia = 164, p.id_pais_nacionalidad = 164
-- update p set p.direccion = p.barrio
from man.personas p
left join man.lugar l on p.id_canton_residencia = l.id_lugar
left join man.lugar lp on lp.id_lugar = l.id_lugar_padre
left join man.nacionalidad n on n.id_nacionalidad = p.id_nacionalidad
where p.direccion is null and p.barrio is not null
-- where  p.id_pais_nacionalidad is null --and p.id_nacionalidad = 5--and p.id_canton_residencia is not null
--     id_pais_nacionalidad is null and direccion is not null

-- update man.personas set id_pais_nacionalidad = id_pais_residencia
-- where id_pais_nacionalidad is null and id_pais_residencia is not null

select * from man.lugar where descripcion like '%españa%'

select ra.* from mig.record_oferta ro
inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
where ro.estado<>'I' and ro.identificacion='0923311625'

select ro.identificacion,ro.apellidos,ro.nombres,ra.* from mig.record_oferta ro
                     inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
where ra.id_record_matricula is null

select * from man.opciones
select --niv.id_nivel,
       ra.*
-- update ra set ra.id_nivel =niv.id_nivel
from mig.record_oferta ra

select * from bd_academico..NIVELES n


select * from Sis..NOTAS where ID_REGISTRO in (5)

--21658 no estan con nombres y sin considerar estados
select p.ID_PERSONA,p.identificacion,p.APELLIDOS,p.NOMBRES from sis..PERSONAS p
where p.IDENTIFICACION not in (select p.identificacion from man.personas p)
  and concat(p.apellidos, ' ',p.nombres) not in ((select concat(p.apellidos, ' ',p.nombres) from man.personas p))


select * from sis..MATERIAS

select * from sis..PERSONAS
select * from sis..VWMATERIAS

select * from sis..ASIGNATURAS

select * from sis..NIVELES

select * from Bd_Academico..NIVELES

select * from Sis..NOTAS where ID_REGISTRO = 21

select * from aca.nivel

select * from sis..MATRICULAS
where MATRICULA='2004130584'

select distinct JORNADA from sis..MATRICULAS
select * from sis..DETALLEMATERIASMALLA

select * from aca.periodo_academico where id_tipo_oferta = 1

--REPORTE MINI LEA

select top 10 * from mig.estado_academicos
select * from aca.estudiante_oferta where id_periodo_academico = 37
--crear un solo paralelo en la cabecera de la matricula
begin
    declare @pi_id_perido_academico int = 37
--         select distinct eo.* from (
    select distinct xd.* from (
        select
          'UNIVERSIDAD ESTATAL PENINSULA DE SANTA ELENA' as IES,--'2024-1' as periodo_matricula_nivelacion,
          pa.codigo AS periodo_cupo,eo.id_estudiante_oferta,om.id_oferta_modalidad,d.nombre as facultad,o.descripcion as carrera,--o1.descripcion,
          p.id as id_persona,p.identificacion,p.apellidos,p.nombres,

--             round(cast (avg(car.promedio) as decimal(10,2)),0) as promedioRedondeado, cast (avg(car.promedio) as decimal(10,2)) as promedioReal,
            car.id_paralelo as paralelo,--car.fecha_mod as fecha_matricula,
          case when car.codigo_estado_matricula ='SEG' then 'Segunda Matrícula' when car.codigo_estado_matricula ='PRI' then 'Primera Matrícula'
               when car.id_estudiante_matricula is null then 'No matriculado' else 'YOLO' end as estado_matricula,
            tee.descripcion as estado_cupo,
             case when ( select count(ea1.promedio) from aca.estudiante_asignatura ea1
                        inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                        inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = aa1.id_malla_asignatura
                        inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
                        where ea1.id_estudiante_matricula = car.id_estudiante_matricula and ea1.estado <>'I') =
                    (
                        select count(ea1.promedio) from aca.estudiante_asignatura ea1
                        inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                        inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = aa1.id_malla_asignatura
                        inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
                        where ea1.id_estudiante_matricula = car.id_estudiante_matricula and ea1.estado <>'I' and ea1.aprobado = 1
                    ) and car.id_estudiante_matricula is not null then 'Aprobado'
                 when tee.codigo = 'INACD' then 'Retiro Definitivo' when car.id_estudiante_matricula is null then '-'
                 else 'Reprobado' end as estado_fin_curso,
          case when tee.codigo='NO-USO-CUPO' or car.id_estudiante_matricula is null then  '1. No efectivizó el cupo'
               when (tee.codigo='ACT' or tee.codigo ='CUPOINACREUBICA') and pa.codigo<'2024-2' and pa.codigo>='2024-1' then
                   '2. Se matriculó y posterior se retiró, anuló, desertó, dejó de asistir o perdió la primera matrícula del curso de nivelación de carrera. (La institución si puede recibirlo).'
               when tee.codigo='INACSM' then '3. Reprobó la nivelación en segunda matricula.'
              when tee.codigo='APR'  and iif((select d.idEstudianteMatricula from [rel].[fn_get_detalle_matricula_by_estudiante_oferta]
                                                            (eog.id_estudiante_oferta,null,0) as d) is null or tee.codigo in ('CUPOINACREUBICA'),'NO','SI')='NO' then
                   '4. Aprobó la nivelación de carrera, no se matriculó en primer semestre. La institución puede recibirlos.'
               when iif((select d.idEstudianteMatricula from [rel].[fn_get_detalle_matricula_by_estudiante_oferta]
                                                             (eog.id_estudiante_oferta,null,0) as d) is null or tee.codigo in ('CUPOINACREUBICA'),'NO','SI')='SI' then
              '5. El estudiante registra matrícula en carrera.' when tee.codigo='INACD' then  '6. Retiro definitivo '
             end as estado_academico,
            'NO' as reubicados_primer_nivel,'1P-2024' as periodo_retiro

          ,iif((select d.idEstudianteMatricula from [rel].[fn_get_detalle_matricula_by_estudiante_oferta]
                                                   (eog.id_estudiante_oferta,null,0) as d) is null,'NO','SI') as matricula_primer_semestre
--           iif((select d.idEstudianteMatricula from [rel].[fn_get_detalle_matricula_by_estudiante_oferta]
--                                                    (eog.id_estudiante_oferta,null,0) as d) is null,'NO APLICA',
--               (select d.periodoAcademico from [rel].[fn_get_detalle_matricula_by_estudiante_oferta](eog.id_estudiante_oferta,null,0) as d)
--           ) as periodo_primer_semestre,
--           isnull(eog.id_estudiante_oferta,0) as idEstudianteOferta1Semestre,
--           isnull((select d.estadoMatricula from [rel].[fn_get_detalle_matricula_by_estudiante_oferta]
--                                                 (eog.id_estudiante_oferta,null,1) as d),'NO REGISTRA') as estadoMatricula1Semestre
        from man.personas p
        inner join aca.estudiante_oferta eo on eo.id_persona = p.id
        inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
        left join aca.estudiante_oferta eog on eog.id_estudiante_oferta_padre = eo.id_estudiante_oferta
        inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
        left join ( select em.id_estudiante_matricula,ea.codigo_estado_matricula,em.id_estudiante_oferta,
                           case when em.id_estudiante_oferta in (63737,63742) then 2
                                else ea.id_paralelo end as id_paralelo
                           ,ea.promedio,em.fecha_mod from aca.estudiante_matricula em
                inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
                inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
                inner join aca.periodo_academico pam on pam.id_periodo_academico = mg.id_periodo_academico
                where  ea.estado <> 'I'  and em.estado <> 'I' and  pam.id_periodo_academico = @pi_id_perido_academico
                group by em.id_estudiante_matricula,em.id_estudiante_oferta, ea.id_paralelo,ea.promedio,em.fecha_mod,ea.codigo_estado_matricula
            ) as car on car.id_estudiante_oferta = eo.id_estudiante_oferta
        inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
        inner join aca.oferta o on o.id_oferta = om.id_oferta
        left join aca.oferta_modalidad om1 on om1.id_oferta_modalidad = eog.id_oferta_modalidad
        left join aca.oferta o1 on o1.id_oferta = om1.id_oferta
        inner join aca.tipo_oferta tof on o.id_tipo_oferta = tof.id_tipo_oferta
        inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
        inner join man.departamentos d on d.id= do.id_departamento
        inner join seg.usuarios u on u.persona_id = p.id
        where  (eo.id_periodo_academico = @pi_id_perido_academico or car.id_estudiante_matricula is not null)
        and tof.codigo='NIVELACION' and eo.id_estudiante_oferta_padre is null
        AND eo.estado='A' and u.estado='AC' and tof.estado='A' --and p.identificacion='0958799066'
        --         AND tee.codigo ='APR'
        --         and tee.id_tipo_estado_estudiante = 11
        group by eo.id_estudiante_oferta,om.id_oferta_modalidad,u.id,p.id,p.identificacion,p.nombres,p.apellidos,--o1.descripcion,
               car.id_estudiante_matricula, d.nombre,o.descripcion,u.usuario,eo.id_oferta_modalidad,car.id_paralelo,pa.codigo,tee.descripcion,
               p.porcentaje_dis,p.celular,p.email_personal,car.fecha_mod,p.direccion,eo.id_estudiante_oferta,eog.id_estudiante_oferta,car.codigo_estado_matricula,tee.codigo
        --         ,eogh.id_estudiante_oferta
        -- 			         , ina.CARRERA, ina.CEDULA,
        -- 			ina.USU_NOMBRES,ina.USU_APELLIDOS,INA.PERIODO_ASIGNACION_CUPO,pa.codigo
        -- 			order by d.nombre,o.descripcion,p.apellidos,p.nombres
        ) as xd
        --         inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = xd.idEstudianteOferta1Semestre
        --         where xd.aprobado ='APROBADO' and xd.matricula_primer_semestre = 'SI'
        --            and xd.matricula_primer_semestre='NO'
        --             and xd.matricula_primer_semestre_hi='NO'
        --         and xd.matricula_primer_semestre='SI'

        --           and xd.estadoMatricula1Semestre<>'A'
        --           and xd.idEstudianteOferta1Semestre <>xd.idEstudianteOferta1Semestre_hi
        --         and xd.identificacion not in ('2450221425','0931086060')
        --           --condicion periodo 2022-1 15
        --         and (  xd.matricula_primer_semestre = 'SI' and xd.periodo_primer_semestre in ('2023-2','2024-1','2024-2'))
        --condicion periodo 2022-2 24
        --         and (  xd.matricula_primer_semestre = 'SI' and xd.periodo_primer_semestre in ('2024-1','2024-2'))
        --condicion periodo 2023-1 28
        --         and (  xd.matricula_primer_semestre = 'SI' and xd.periodo_primer_semestre in ('2024-2'))
        --         and xd.identificacion='1729799195'
    order by xd.facultad,xd.carrera,xd.apellidos,xd.nombres
end
--insertar personas homonimas en el sga
-- insert into bd_sga_upse.man.personas(id_tipo_identificacion,id_estado_civil, id_tipo_sangre, id_discapacidad, id_nacionalidad, id_pais_nacionalidad, id_provincia_nacionalidad, id_canton_nacionalidad,
--                                      id_parroquia_nacionalidad, id_etnia, id_nacionalidad_indigena, id_pais_residencia, id_provincia_residencia, id_canton_residencia, id_parroquia_residencia, num_carnet_conadis, porcentaje_dis,
--                                      identificacion, nombres, apellidos, sexo, fecha_nace, ciudad, barrio, direccion, telefono, celular, email_personal, email_institucional, estado, fecha_ingreso,
--                                      usuario_ing,usuario_mod,fecha_ing,fecha_mod)
select top 5000 (SELECT ti.id_tipo_identificacion FROM bd_sga_upse.man.tipo_identificacion ti
                                                        inner join migracion_sga.dbo.registros_migracion rm on rm.id_destino = ti.id_tipo_identificacion
                                                        inner join migracion_sga.dbo.entidades_migracion em on em.id = rm.id_entidad_relacion
              where em.tabla_destino = 'tipo_identificacion' and rm.id_origen = p.CG_TIPO_IDENTIFICACION) as id_tipo_identificacion,
             (SELECT ec.id_estado_civil FROM bd_sga_upse.man.estado_civil ec
                                                 inner join migracion_sga.dbo.registros_migracion rm on rm.id_destino = ec.id_estado_civil
                                                 inner join migracion_sga.dbo.entidades_migracion em on em.id = rm.id_entidad_relacion
              where em.tabla_destino = 'estado_civil' and rm.id_origen = p.CG_ESTADO_CIVIL) as id_estado_civil,
             (SELECT ts.id_tipo_sangre FROM bd_sga_upse.man.tipo_sangre ts
                                                inner join migracion_sga.dbo.registros_migracion rm on rm.id_destino = ts.id_tipo_sangre
                                                inner join migracion_sga.dbo.entidades_migracion em on em.id = rm.id_entidad_relacion
              where em.tabla_destino = 'tipo_sangre' and rm.id_origen = p.CG_TIPO_SANGRE) as id_tipo_sangre,
             (SELECT d.id_discapacidad FROM bd_sga_upse.man.discapacidad d
                                                inner join migracion_sga.dbo.registros_migracion rm on rm.id_destino = d.id_discapacidad
                                                inner join migracion_sga.dbo.entidades_migracion em on em.id = rm.id_entidad_relacion
              where em.tabla_destino = 'discapacidad' and rm.id_origen = p.CG_DISCAPACIDAD) as id_discapacidad,
             isnull((SELECT n.id_nacionalidad FROM bd_sga_upse.man.nacionalidad n
                                                inner join migracion_sga.dbo.registros_migracion rm on rm.id_destino = n.id_nacionalidad
                                                inner join migracion_sga.dbo.entidades_migracion em on em.id = rm.id_entidad_relacion
              where em.tabla_destino = 'nacionalidad' and rm.id_origen = p.CG_NACIONALIDAD),5) as id_nacionalidad,

             isnull((select id_lugar
              from bd_sga_upse.man.lugar
              where id_lugar_padre is null and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PAIS_ORIGEN)),164) as id_pais_nacionalidad,

             (select id_lugar
              from bd_sga_upse.man.lugar
              where id_lugar_padre = ((select id_lugar
                                       from bd_sga_upse.man.lugar
                                       where id_lugar_padre is null and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = cg_pais_origen)))
                and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PROVINCIA_NACE)) as id_provincia_nacionalidad,

             (select id_lugar
              from bd_sga_upse.man.lugar
              where id_lugar_padre = (select id_lugar
                                      from bd_sga_upse.man.lugar
                                      where id_lugar_padre = ((select id_lugar
                                                               from bd_sga_upse.man.lugar
                                                               where id_lugar_padre is null and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = cg_pais_origen)))
                                        and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PROVINCIA_NACE))
                and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_CANTON_NACE)) as id_canton_nacionalidad,

             (select id_lugar
              from bd_sga_upse.man.lugar
              where id_lugar_padre = (select id_lugar
                                      from bd_sga_upse.man.lugar
                                      where id_lugar_padre = (select id_lugar
                                                              from bd_sga_upse.man.lugar
                                                              where id_lugar_padre = ((select id_lugar
                                                                                       from bd_sga_upse.man.lugar
                                                                                       where id_lugar_padre is null and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = cg_pais_origen)))
                                                                and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PROVINCIA_NACE))
                                        and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_CANTON_NACE))
                and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PARROQUIA_NACE)) as id_parroquia_nacionalidad,

             (SELECT e.id_etnia FROM bd_sga_upse.man.etnia e
                                         inner join migracion_sga.dbo.registros_migracion rm on rm.id_destino = e.id_etnia
                                         inner join migracion_sga.dbo.entidades_migracion em on em.id = rm.id_entidad_relacion
              where em.tabla_destino = 'etnia' and rm.id_origen = p.CG_ETNIA) as id_etnia,
             (SELECT ni.id_nacionalidad_indigena FROM bd_sga_upse.man.nacionalidad_indigena ni
                                                          inner join migracion_sga.dbo.registros_migracion rm on rm.id_destino = ni.id_nacionalidad_indigena
                                                          inner join migracion_sga.dbo.entidades_migracion em on em.id = rm.id_entidad_relacion
              where em.tabla_destino = 'nacionalidad_indigena' and rm.id_origen = p.CG_NAC_INDIGENA) as id_nacionalidad_indigena,

             (select id_lugar
              from bd_sga_upse.man.lugar
              where id_lugar_padre is null and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PAIS_RESIDE)) as id_pais_residencia,

             (select id_lugar
              from bd_sga_upse.man.lugar
              where id_lugar_padre = ((select id_lugar
                                       from bd_sga_upse.man.lugar
                                       where id_lugar_padre is null and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PAIS_RESIDE)))
                and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PROVINCIA_RESIDE)) as id_provincia_residencia,

             (select id_lugar
              from bd_sga_upse.man.lugar
              where id_lugar_padre = (select id_lugar
                                      from bd_sga_upse.man.lugar
                                      where id_lugar_padre = ((select id_lugar
                                                               from bd_sga_upse.man.lugar
                                                               where id_lugar_padre is null and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PAIS_RESIDE)))
                                        and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PROVINCIA_RESIDE))
                and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_CANTON_RESIDE)) as id_canton_residencia,

             (select id_lugar
              from bd_sga_upse.man.lugar
              where id_lugar_padre = (select id_lugar
                                      from bd_sga_upse.man.lugar
                                      where id_lugar_padre = (select id_lugar
                                                              from bd_sga_upse.man.lugar
                                                              where id_lugar_padre = ((select id_lugar
                                                                                       from bd_sga_upse.man.lugar
                                                                                       where id_lugar_padre is null and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PAIS_RESIDE)))
                                                                and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PROVINCIA_RESIDE))
                                        and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_CANTON_RESIDE))
                and replace(descripcion, ' ','') = (select replace(VALOR_TEXTO, ' ','') from Bd_Personal.dbo.TP_CODIGOS where CORRELATIVO = CG_PARROQUIA_RESIDE)) as id_parroquia_residencia,

             case
                 when p.NUMERO_CONADIS is null
                     then ''
                 when p.NUMERO_CONADIS = '0'
                     then ''
                 else p.NUMERO_CONADIS
                 end as NUMERO_CONADIS,

             case
                 when p.PORC_DISCAPACIDAD is null
                     then 0
                 else p.PORC_DISCAPACIDAD
                 end as PORC_DISCAPACIDAD,

             p.IDENTIFICACION, p.NOMBRES, p.APELLIDOS,

             isnull(SUBSTRING((select descripcion from Bd_Academico.dbo.fun_info_sexo(p.ID_PERSONA)), 1, 1),'M') as sexo,
             p.FEC_NACIMIENTO,
             (select VALOR_TEXTO from [Bd_Personal].[dbo].[TP_CODIGOS] tc where tc.CORRELATIVO = p.CG_CIUDAD_RESIDE) as ciudad,
             p.BARRIO_RESIDE,
             p.DIRECCION, p.TELEFONO, p.CELULAR, p.EMAIL, iif(p.EMAIL_INST='-',null,p.EMAIL_INST)as correo_institucional, 'AC' as estado, p.FECHA_INGRESO, '2400254286' as usuario_ing,'2400254286' as usuario_mod,
        p.FECHA_INGRESO as fecha_ing,getdate() as fecha_mod


from Bd_Academico.dbo.PERSONAS p
where p.IDENTIFICACION not in (select p.identificacion from man.personas p where p.estado='AC')
and concat(p.apellidos, ' ',p.nombres) in (select concat(d.apellidos, ' ',d.nombres) from (select ro.apellidos,ro.nombres,count(distinct ro.identificacion) as repetidos from  mig.record_oferta ro
                                            group by ro.apellidos, ro.nombres
                                            having count(distinct ro.identificacion)>1) as d)


--insertar docentes que no estan en bdAcademico ni en sga
-- insert into bd_sga_upse.man.personas(id_tipo_identificacion,id_estado_civil, id_tipo_sangre, id_discapacidad, id_nacionalidad, id_pais_nacionalidad, id_provincia_nacionalidad, id_canton_nacionalidad,
--                                      id_parroquia_nacionalidad, id_etnia, id_nacionalidad_indigena, id_pais_residencia, id_provincia_residencia, id_canton_residencia, id_parroquia_residencia, num_carnet_conadis, porcentaje_dis,
--                                      identificacion, nombres, apellidos, sexo, fecha_nace, ciudad, barrio, direccion, telefono, celular, email_personal, email_institucional, estado, fecha_ingreso,
--                                      usuario_ing,usuario_mod,fecha_ing,fecha_mod)
select top 5000 1 as id_tipo_identificacion,
             4 as id_estado_civil,  null as id_tipo_sangre,null as id_discapacidad,5 as id_nacionalidad, 164 as id_pais_nacionalidad,null as id_provincia_nacionalidad,null as id_canton_nacionalidad,
              null  as id_parroquia_nacionalidad,null as id_etnia,null as id_nacionalidad_indigena,164 as id_pais_residencia,null as id_provincia_residencia,null as id_canton_residencia,
              null as id_parroquia_residencia,null as NUMERO_CONADIS,0 PORC_DISCAPACIDAD,p.IDENTIFICACION, p.NOMBRES, p.APELLIDOS,'M' as sexo,
             p.fecha_nace,null as ciudad,null as BARRIO_RESIDE, null as DIRECCION, null as TELEFONO, p.CELULAR, p.email_personal, p.email_institucional as correo_institucional, 'AC' as estado, getdate(),
             '2400254286' as usuario_ing,'2400254286' as usuario_mod,
                getdate() as fecha_ing,getdate() as fecha_mod


from bdupse.seg.personas p where identificacion in (select identificacion from seg.usuarios u inner join bdupse.seg.usuarios_roles ur on u.id=ur.usuarios_id
                                                           where roles_id in (151,187))
and identificacion not in  (select pp.identificacion from man.personas pp where pp.estado='AC') and len(p.identificacion)=10


