use bd_sga_upse;


select
   distinct ma.id_nivel,a.descripcion as asignatura, ma.id_malla_asignatura, ma.id_malla,ma2.id_malla_asignatura
from aca.malla_asignatura ma
         inner join aca.malla m on ma.id_malla = m.id_malla
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
         left join aca.asignatura a2 on a2.descripcion = a.descripcion
         left join aca.malla_asignatura ma2 on ma2.id_asignatura = a2.id_asignatura and ma2.id_malla = 172
where ma.estado='A' and m.id_malla = 23
order by ma.id_nivel

select
    distinct ma.id_nivel,a.descripcion as asignatura, ma.id_malla_asignatura, ma.id_malla
    from aca.malla_asignatura ma
    inner join aca.malla m on ma.id_malla = m.id_malla
    inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
    inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where ma.estado='A' and m.id_malla = 172
order by ma.id_nivel

-- exec [aca].[sp_generate_migrate_transicion_malla_curricular] 136
exec [aca].[pa_generar_asignaturas_a_matricular_sga] 102387,136,1,1
exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 102387,136,1,1

select * from aca.fn_listar_docentes_asignaturas (102387,null,136)

--editar estudiante_oferta rediseño
begin
    select
    distinct  ea.*
        --       distinct  ea.*--,p.identificacion
--         distinct eo.*
--         distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,p.identificacion,p.apellidos,p.nombres,
--         tee.descripcion,tie.descripcion,eo.estado,eo.ultimo_periodo,eo.id_malla,ofa1.carrera,em.id_estudiante_matricula,eoh.id_estudiante_oferta,eoh.id_malla
    --         ,a.descripcion as asignatura,ma.id_malla_asignatura
--          ,ac.id_malla_asignatura_comp,aa.id_asignatura_aprendizaje,aa1.id_asignatura_aprendizaje,a2.descripcion
--     update ea set ea.id_asignatura_aprendizaje = aa1.id_asignatura_aprendizaje
--     update em set em.id_estudiante_oferta = eoh.id_estudiante_oferta
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
--              inner join aca.estudiante_oferta eoh on eoh.id_estudiante_oferta_padre = eo.id_estudiante_oferta and eoh.id_malla = 172
--              inner join aca.ofertas_facultad ofa1 on ofa1.id_oferta_modalidad = eoh.id_oferta_modalidad
             inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
             inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
             inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
             inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = mg.id_periodo_academico
             inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
             inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
    where
        eo.id_oferta_modalidad = 21  --and eo.id_malla = 23
      and mg.id_periodo_academico = 136
      and p.identificacion ='2450853755'
end;

select * from aca.asignatura_compatibilidad ac

select * from aca.malla where id_oferta_modalidad = 21

select * from aca.oferta_resultado_aprendizaje where id_malla = 181

-- insert into aca.oferta_resultado_aprendizaje
SELECT mh.id_malla
        , ora.id_tipo_resultado_aprendizaje, ora.descripcion, ora.estado,
       ora.version, ora.fecha_ing, ora.fecha_mod, ora.usuario_ing, ora.usuario_mod
FROM aca.malla m
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
         inner join aca.ofertas_facultad oh on oh.id_oferta = ofa.id_oferta and oh.id_modalidad = 4
         inner join aca.malla mh on mh.id_oferta_modalidad = oh.id_oferta_modalidad
         left join aca.oferta_resultado_aprendizaje orh on mh.id_malla = orh.id_malla and orh.estado='A'
--         inner join aca.ofer
         inner JOIN aca.oferta_resultado_aprendizaje ora   ON m.id_malla = ora.id_malla
WHERE orh.id_oferta_resultado_aprendizaje is null
--       and  mh.id_oferta_modalidad in (97,89)
order by  m.id_malla
--         m.id_oferta_modalidad in (89,97)
select * from aca.modalidad

select * from aca.oferta_competencia where id_malla = 181

-- insert into aca.oferta_competencia
SELECT mh.id_malla
        , ora.id_tipo_competencia, ora.descripcion, ora.estado,
       ora.version, ora.fecha_ing, ora.fecha_mod, ora.usuario_ing, ora.usuario_mod
FROM aca.malla m
         inner JOIN aca.oferta_competencia ora   ON m.id_malla = ora.id_malla
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
         inner join aca.ofertas_facultad oh on oh.id_oferta = ofa.id_oferta and oh.id_modalidad = 4
         inner join aca.malla mh on mh.id_oferta_modalidad = oh.id_oferta_modalidad
         left join aca.oferta_competencia orh on mh.id_malla = orh.id_malla and orh.estado='A'
WHERE orh.id_oferta_competencia is null
--       and  mh.id_oferta_modalidad in (97,89)
order by  m.id_malla


select ara.* from aca.asignatura_resultado_aprendizaje ara
inner join aca.malla_asignatura ma on ara.id_malla_asignatura = ma.id_malla_asignatura
where ma.id_malla = 181

--  insert into aca.asignatura_resultado_aprendizaje
SELECT --concat(ofa.carrera,' - ',ofa.modalidad) as  carrera,concat(oh.carrera,' - ',oh.modalidad) as  carrera_mod2,a.descripcion,ara.id_malla_asignatura,
       mah.id_malla_asignatura, ara.descripcion, ara.estado,
       ara.version, ara.fecha_ing, ara.fecha_mod, ara.usuario_ing, ara.usuario_mod
FROM aca.malla m
         inner join aca.malla_asignatura ma on m.id_malla = ma.id_malla
         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
         inner join aca.asignatura_resultado_aprendizaje ara on ara.id_malla_asignatura = ma.id_malla_asignatura
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
         inner join aca.ofertas_facultad oh on oh.id_oferta = ofa.id_oferta and oh.id_modalidad = 4
         inner join aca.malla mh on mh.id_oferta_modalidad = oh.id_oferta_modalidad
         inner join aca.malla_asignatura mah on mh.id_malla = mah.id_malla
         inner join aca.asignatura ah on mah.id_asignatura = ah.id_asignatura
         left join aca.asignatura_resultado_aprendizaje arah on  arah.id_malla_asignatura = mah.id_malla_asignatura and arah.estado='A'
--       and  mh.id_oferta_modalidad in (97,89)
where ofa.id_tipo_oferta = 2 and arah.id_asignatura_resultado_aprendizaje is null and ofa.id_modalidad = 1 and ara.estado='A'
  and a.descripcion=ah.descripcion
order by  m.id_malla



select * from aca.oferta_competencia_resultados

select * from aca.oferta_asignatura_resultados

select * from aca.oferta_competencia_resultados ocr
inner join aca.oferta_competencia oc on ocr.id_oferta_competencia = oc.id_oferta_competencia
where oc.id_malla = 181

-- insert into aca.oferta_competencia_resultados
select
--     ofa.id_oferta_modalidad,concat(ofa.carrera,' - ',ofa.modalidad) as  carrera,concat(ofa1.carrera,' - ',ofa1.modalidad) as  carrera_mod2,
oc1.id_oferta_competencia,ora1.id_oferta_resultado_aprendizaje, ocr.estado, ocr.version, ocr.fecha_ing, ocr.fecha_mod, ocr.usuario_ing, ocr.usuario_mod
from aca.oferta_competencia_resultados ocr
         inner join aca.oferta_competencia oc on ocr.id_oferta_competencia = oc.id_oferta_competencia
         inner join aca.malla m on oc.id_malla = m.id_malla
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
         inner join aca.ofertas_facultad ofa1 on ofa1.id_oferta = ofa.id_oferta and ofa1.id_modalidad = 4
         inner join aca.malla m1 on m1.id_oferta_modalidad = ofa1.id_oferta_modalidad
         inner join aca.oferta_competencia oc1 on oc1.id_malla = m1.id_malla
         left join aca.oferta_competencia_resultados ocr1 on ocr1.id_oferta_competencia = oc1.id_oferta_competencia
         inner join aca.oferta_resultado_aprendizaje ora on ocr.id_oferta_resultado_aprendizaje = ora.id_oferta_resultado_aprendizaje
         inner join aca.oferta_resultado_aprendizaje ora1 on ora1.id_malla = m1.id_malla
where ofa.id_tipo_oferta = 2 and ocr1.id_oferta_competencia_resultado is null
  and oc.descripcion = oc1.descripcion and ocr.estado='A' and ora.descripcion = ora1.descripcion
  and ofa.id_modalidad = 1

-- insert into aca.oferta_competencia_resultados
select
--     ofa.id_oferta_modalidad,concat(ofa.carrera,' - ',ofa.modalidad) as  carrera,concat(ofa1.carrera,' - ',ofa1.modalidad) as  carrera_mod2,
oc1.id_oferta_competencia,ora1.id_oferta_resultado_aprendizaje, ocr.estado, ocr.version, getdate(), getdate(), '2400254286', '2400254286'
from aca.oferta_competencia_resultados ocr
         inner join aca.oferta_competencia oc on ocr.id_oferta_competencia = oc.id_oferta_competencia
         inner join aca.malla m on oc.id_malla = m.id_malla
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
         inner join aca.ofertas_facultad ofa1 on ofa1.id_oferta = ofa.id_oferta
         inner join aca.malla m1 on m1.id_oferta_modalidad = ofa1.id_oferta_modalidad
         inner join aca.oferta_competencia oc1 on oc1.id_malla = m1.id_malla
         left join aca.oferta_competencia_resultados ocr1 on ocr1.id_oferta_competencia = oc1.id_oferta_competencia
         inner join aca.oferta_resultado_aprendizaje ora on ocr.id_oferta_resultado_aprendizaje = ora.id_oferta_resultado_aprendizaje
         inner join aca.oferta_resultado_aprendizaje ora1 on ora1.id_malla = m1.id_malla
where m.id_malla = 77 and ocr1.id_oferta_competencia_resultado is null
  and oc.descripcion = oc1.descripcion and ocr.estado='A' and ora.descripcion = ora1.descripcion
    and m1.id_malla = 181

select oar.* from aca.oferta_asignatura_resultados oar
inner join aca.oferta_resultado_aprendizaje ora on oar.id_oferta_resultado_aprendizaje = ora.id_oferta_resultado_aprendizaje
where ora.id_malla = 77

-- insert into aca.oferta_asignatura_resultados
select
--     ofa.id_oferta_modalidad,concat(ofa.carrera,' - ',ofa.modalidad) as  carrera,concat(oh.carrera,' - ',oh.modalidad) as  carrera_mod2,
orah.id_oferta_resultado_aprendizaje,arah.id_asignatura_resultado_aprendizaje,--oar.id_asignatura_resultado_aprendizaje,oar.id_oferta_resultado_aprendizaje,
oar.estado,oar.version, getdate(), getdate(), '2400254286', '2400254286'
from aca.oferta_asignatura_resultados oar
         inner join aca.asignatura_resultado_aprendizaje ara on oar.id_asignatura_resultado_aprendizaje = ara.id_asignatura_resultado_aprendizaje
         inner join aca.malla_asignatura ma on ara.id_malla_asignatura = ma.id_malla_asignatura
         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
         inner join aca.malla m on ma.id_malla = m.id_malla
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
         inner join aca.ofertas_facultad oh on oh.id_oferta = ofa.id_oferta
         inner join aca.malla mh on mh.id_oferta_modalidad = oh.id_oferta_modalidad
         inner join aca.malla_asignatura mah on mh.id_malla = mah.id_malla
         inner join aca.asignatura ah on mah.id_asignatura = ah.id_asignatura
         inner join aca.asignatura_resultado_aprendizaje arah on arah.id_malla_asignatura = mah.id_malla_asignatura
         left join aca.oferta_asignatura_resultados ocrh on ocrh.id_asignatura_resultado_aprendizaje = arah.id_asignatura_resultado_aprendizaje
         inner join aca.oferta_resultado_aprendizaje ora on oar.id_oferta_resultado_aprendizaje = ora.id_oferta_resultado_aprendizaje
         inner join aca.oferta_resultado_aprendizaje orah on orah.id_malla = mh.id_malla
where m.id_malla = 77 and ocrh.id_oferta_asignatura_resultado is null
  and a.descripcion=ah.descripcion and oar.estado='A' and ora.descripcion = orah.descripcion and arah.descripcion=ara.descripcion
  and mh.id_malla = 181
order by ofa.id_oferta_modalidad


--tablas involucradas en la replica del silabos
---complementarias
select * from aca.oferta_silabo_item

--------
-- insert into aca.silabo
select s1.*
--     s.id_silabo,s1.id_silabo,
--        ma1.id_malla_asignatura, concat('PLAN ANALÍTICO ',a.descripcion)as descrpcion, getdate() as fechaDesde, null as fechaHasta, null as resultado_aprendizaje, 'A', 0,
--        getdate() as fecha_ingreso, s.usuario_ingreso_id, getdate() as fecha_ing,  getdate() as fecha_mod, s.usuario_ing, s.usuario_mod
       from aca.silabo s
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = s.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
inner join aca.silabo_periodo_academico spa on s.id_silabo = spa.id_silabo
inner join  aca.asignatura_compatibilidad ac on ma.id_malla_asignatura = ac.id_malla_asignatura and ac.tipo='REDISEÑO_MALLA' and ac.estado='A'
inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = ac.id_malla_asignatura_comp
inner join aca.asignatura a1 on ma1.id_asignatura = a1.id_asignatura
left join aca.silabo s1 on s1.id_malla_asignatura = ma1.id_malla_asignatura
where  s.estado in ('A','P') and ma.id_malla = 77 and spa.id_periodo_academico = 96
and ma.id_malla_asignatura not in (2641,2643) --and s1.id_silabo is null

-- insert into aca.silabo_periodo_academico
select --spa.*,
--     spa1.id_silabo_periodo_academico,s1.descripcion,spa.*
    s1.id_silabo,136,36,getdate() as fecha_ingreso, 'A', 0, getdate() as fecha_ing,  getdate() as fecha_mod, s.usuario_ing, s.usuario_mod
from aca.silabo s
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = s.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
inner join aca.silabo_periodo_academico spa on s.id_silabo = spa.id_silabo
inner join  aca.asignatura_compatibilidad ac on ma.id_malla_asignatura = ac.id_malla_asignatura and ac.tipo='REDISEÑO_MALLA' and ac.estado='A'
inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = ac.id_malla_asignatura_comp
inner join aca.asignatura a1 on ma1.id_asignatura = a1.id_asignatura
inner join aca.silabo s1 on s1.id_malla_asignatura = ma1.id_malla_asignatura
left join aca.silabo_periodo_academico spa1 on s1.id_silabo = spa1.id_silabo
where  s.estado in ('A','P') and ma.id_malla = 77 and spa.id_periodo_academico = 96
  and spa1.id_periodo_academico is null
and ma.id_malla_asignatura not in (2641,2643)


-- update ma2 set ma2.descripcion = ma.descripcion
-- insert into aca.asignatura_resultado_aprendizaje
select
--     ma.*
ma2.id_malla_asignatura, ara.descripcion, ara.estado, 0, getdate(), getdate(), ara.usuario_ing, ara.usuario_mod
--    distinct a.descripcion as asignatura, ma.id_malla_asignatura, m2.id_malla, ma2.id_malla_asignatura,ma2.descripcion, ma2.descripcion, ma.descripcion
--             ma.id_nivel, ma.id_malla,ma.contribucion,ma.objetivo,ma.resultado_aprendizaje,ma.sistema_contenido,ma.descripcion,ara.descripcion
from aca.malla_asignatura ma
         inner join aca.asignatura_resultado_aprendizaje ara on ma.id_malla_asignatura = ara.id_malla_asignatura
         inner join aca.malla m on ma.id_malla = m.id_malla
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
         inner join aca.asignatura a2 on a2.descripcion = a.descripcion
         inner join aca.malla_asignatura ma2 on ma2.id_asignatura = a2.id_asignatura
         inner join aca.malla m2 on m2.id_malla = ma2.id_malla and m2.id_malla = 183
where ma.estado='A' and m.id_malla = 133 and ara.estado='A'
-- order by ma.id_nivel

select a.descripcion as asignatura, ma.id_malla_asignatura,ma.id_nivel from aca.malla_asignatura ma
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where ma.estado='A' and m.id_malla = 77
order by ma.id_nivel

select * from rel.malla_relacion
select * from aca.asignatura_compatibilidad
select * from aca.malla where id_oferta_modalidad = 115


select * from aca.silabo_funciones_sustantivas --no
select * from aca.silabo_malla_asignatura --no
select * from aca.silabo_bibliografia
select * from aca.silabo_bibliografia_no_catalogada
select * from aca.silabo_item_relacion
select * from aca.silabo_componente_item_actividad--



select c.id_contenidos, c.id_silabo, c.id_contenido_padre, c.orden, c.horas_sincronica, c.horas_doc, c.horas_aea, c.horas_ta, c.horas_nad, c.resultado_aprendizaje, c.descripcion, c.estado, c.version, c.fecha_ing, c.fecha_mod, c.usuario_ing, c.usuario_mod
from aca.silabo s
         inner join aca.malla_asignatura ma on ma.id_malla_asignatura = s.id_malla_asignatura
         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
         inner join aca.silabo_periodo_academico spa on s.id_silabo = spa.id_silabo
        inner join aca.contenidos c on s.id_silabo = c.id_silabo
         inner join  aca.asignatura_compatibilidad ac on ma.id_malla_asignatura = ac.id_malla_asignatura and ac.tipo='REDISEÑO_MALLA' and ac.estado='A'
         inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = ac.id_malla_asignatura_comp
         inner join aca.asignatura a1 on ma1.id_asignatura = a1.id_asignatura
         inner join aca.silabo s1 on s1.id_malla_asignatura = ma1.id_malla_asignatura
         inner join aca.silabo_periodo_academico spa1 on s1.id_silabo = spa1.id_silabo
where  s.estado in ('A','P') and ma.id_malla = 77 and spa.id_periodo_academico = 96 and spa1.id_periodo_academico = 136 and c.estado='A'
  and ma.id_malla_asignatura not in (2641,2643)


select * from aca.silabo
select * from aca.silabo_periodo_academico where id_silabo in (9661,9660)
select * from aca.contenidos
select * from aca.silabo_bibliografia
select * from aca.silabo_bibliografia_no_catalogada where  id_silabo in (9661,9660)
--  DBCC CHECKIDENT ('aca.contenido_resultado_aprendizaje', RESEED, 7585);
select * from aca.contenido_resultado_aprendizaje
select * from aca.contenido_componente_aprendizaje
--  DBCC CHECKIDENT ('aca.resultado_aprendizaje_inteligencia_artificial', RESEED, 3782);
select * from aca.resultado_aprendizaje_inteligencia_artificial
select * from aca.resultado_aprendizaje_item_relacion
select * from aca.silabo_item_relacion

SELECT id_asignatura,codigo,tipo_asignatura,
    descripcion
--     ,CASE WHEN descripcion LIKE '%' + CHAR(13) + '%' THEN 1 ELSE 0 END AS tiene_CR,
--     CASE WHEN descripcion LIKE '%' + CHAR(10) + '%' THEN 1 ELSE 0 END AS tiene_LF,
--     CASE WHEN descripcion LIKE '%' + CHAR(9)  + '%' THEN 1 ELSE 0 END AS tiene_TAB,
--     CASE WHEN descripcion LIKE '%  %' THEN 1 ELSE 0 END AS tiene_espacios_dobles
FROM aca.asignatura
