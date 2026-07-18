USE bd_sga_upse;

exec [aca].[sp_rpt_silabo_avance] 24, 8, 43
exec [aca].[sp_rpt_silabo_avance] 23, 8, 20


select *
from aca.relacion_oferta
select cp.id_componente_aprendizaje                                                 as idCompAprendizajePadre,
       cp.abreviatura                                                               as abreviaturaPadre,
       cp.codigo                                                                    as codigoPadre,
       cp.descripcion                                                               as componentePadre,
       case
           when ch.id_componente_aprendizaje is null then cp.id_componente_aprendizaje
           else ch.id_componente_aprendizaje end                                    as idCompAprendizajeHijo,
       case when ch.abreviatura is null then cp.abreviatura else ch.abreviatura end as abreviaturaHijo,
       case when ch.codigo is null then cp.codigo else ch.codigo end                as codigoHijo,
       case when ch.descripcion is null then cp.descripcion else ch.descripcion end as componenteHijo,
       ch.estado,
       cp.estado,
       r.id_reglamento_comp_aprendizaje,
       r.estado
from aca.componente_aprendizaje cp
         left join aca.componente_aprendizaje ch on cp.id_componente_aprendizaje = ch.id_componente_aprendizaje_padre
         inner join aca.reglamento_comp_aprendizaje r
                    on r.id_comp_aprendizaje in (ch.id_componente_aprendizaje, cp.id_componente_aprendizaje)
         inner join aca.malla m on (m.id_reglamento = r.id_reglamento)
where cp.estado = 'A'
  and cp.estado = 'A'
  and r.estado = 'A'
  and cp.id_componente_aprendizaje_padre in
      (select ca.id_componente_aprendizaje
       from aca.componente_aprendizaje ca
       where ca.estado = 'A'
         and ca.codigo = 'FORMATIVA'
         and ca.estado = 'A')
  and (ch.estado is null or ch.estado = 'A')
  and m.id_malla = 26
order by cp.orden asc, ch.orden asc


select cap.id_componente_aprendizaje as idCompAprendizajePadre,
       cap.abreviatura               as abreviaturaPadre,
       cap.codigo                    as codigoPadre,
       cap.descripcion               as componentePadre,
       ca.id_componente_aprendizaje  as idCompAprendizajeHijo,
       ca.abreviatura                as abreviaturaHijo,
       ca.codigo                     as codigoHijo,
       ca.descripcion                as componenteHijo,
       ca.estado,
       rc.id_reglamento_comp_aprendizaje,
       rc.estado

from aca.malla m
         inner join aca.reglamento_comp_aprendizaje rc on rc.id_reglamento = m.id_reglamento
         inner join aca.componente_aprendizaje ca on (ca.id_componente_aprendizaje = rc.id_comp_aprendizaje)
         inner join aca.componente_aprendizaje cap on cap.id_componente_aprendizaje = (case
                                                                                           when
                                                                                               ca.id_componente_aprendizaje_padre =
                                                                                               (select ca.id_componente_aprendizaje
                                                                                                from aca.componente_aprendizaje ca
                                                                                                where ca.estado = 'A'
                                                                                                  and ca.codigo = 'FORMATIVA'
                                                                                                  and ca.estado = 'A')
                                                                                               then
                                                                                               ca.id_componente_aprendizaje
                                                                                           else ca.id_componente_aprendizaje_padre end)
where ca.estado = 'A'
  and ca.estado = 'A'
  and rc.estado = 'A'
  and m.id_malla = 26
order by cap.orden asc, ca.orden asc

select cap.id_componente_aprendizaje
from aca.componente_aprendizaje ca
         inner join aca.componente_aprendizaje cap on cap.id_componente_aprendizaje_padre = ca.id_componente_aprendizaje
where ca.estado = 'A'
  and ca.codigo = 'FORMATIVA'
  and ca.estado = 'A'

select ca.id_componente_aprendizaje
from aca.componente_aprendizaje ca
where ca.estado = 'A'
  and ca.codigo = 'FORMATIVA'
  and ca.estado = 'A'


select c.*
from aca.silabo s
         inner join aca.contenidos c on c.id_silabo = s.id_silabo
where s.id_silabo = 6464
  and c.id_contenido_padre is not null


select * from [aca].[fn_rpt_silabo_contenido_detalle](23, null, 1282)


select d.* from [aca].[fn_get_silabos_by_malla](71, 23) as d
-- inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = d.idMallaAsignaturaPresencial
--71 y 85

select d.* from [aca].[fn_get_silabos_by_malla](85, 23) as d
select om.id_oferta, m.*
from aca.malla m
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = m.id_oferta_modalidad
where m.id_malla = 92

Exec Bd_Academico.dbo.sp_materias_silabo '13705'

exec [pro].[sp_materias_silabo] '13705'


select cap.id_componente_aprendizaje as idCompAprendizajePadre,
       cap.abreviatura               as abreviaturaPadre,
       cap.codigo                    as codigoPadre,
       cap.descripcion               as componentePadre,
       ca.id_componente_aprendizaje  as idCompAprendizajeHijo,
       ca.abreviatura                as abreviaturaHijo,
       ca.codigo                     as codigoHijo,
       ca.descripcion                as componenteHijo
from aca.reglamento r
         inner join aca.reglamento_comp_aprendizaje rc on rc.id_reglamento = r.id_reglamento
         inner join aca.componente_aprendizaje ca on (ca.id_componente_aprendizaje = rc.id_comp_aprendizaje)
         inner join aca.componente_aprendizaje cap on cap.id_componente_aprendizaje = (case
                                                                                           when
                                                                                               ca.id_componente_aprendizaje_padre =
                                                                                               (select ca.id_componente_aprendizaje
                                                                                                from aca.componente_aprendizaje ca
                                                                                                where ca.estado = 'A'
                                                                                                  and ca.codigo = 'FORMATIVA'
                                                                                                  and ca.estado = 'A')
                                                                                               then
                                                                                               ca.id_componente_aprendizaje
                                                                                           else ca.id_componente_aprendizaje_padre end)
where ca.estado = 'A'
  and cap.estado = 'A'
  and rc.estado = 'A'
  and r.estado = 'A'
  and r.id_reglamento = 35
--            and ca.id_componente_aprendizaje in (select d.idComponenteAprendizaje from [aca].[fn_silabo](?2,?3) as d)
order by cap.orden asc, ca.orden asc

select cca.id_contenido_componente_aprendizaje,
       cap.id_componente_aprendizaje as idCompAprendizajePadre,
       cap.abreviatura               as abreviaturaPadre,
       cap.codigo                    as codigoPadre,
       cap.descripcion               as componentePadre,
       ca.id_componente_aprendizaje  as idCompAprendizajeHijo,
       ca.abreviatura                as abreviaturaHijo,
       ca.codigo                     as codigoHijo,
       ca.descripcion                as componenteHijo,
       cca.horas
from aca.silabo s
         inner join aca.contenidos c on c.id_silabo = s.id_silabo
         inner join aca.contenido_componente_aprendizaje cca on cca.id_contenidos = c.id_contenidos
         inner join aca.silabo_periodo_academico spa on spa.id_silabo = s.id_silabo
         inner join aca.silabo_malla_asignatura sma on sma.id_silabo = s.id_silabo
         inner join aca.reglamento_comp_aprendizaje rc
                    on rc.id_reglamento = spa.id_reglamento and rc.id_comp_aprendizaje = cca.id_componente_aprendizaje
         inner join aca.componente_aprendizaje ca on (ca.id_componente_aprendizaje = rc.id_comp_aprendizaje)
         inner join aca.componente_aprendizaje cap on cap.id_componente_aprendizaje = (case
                                                                                           when
                                                                                               ca.id_componente_aprendizaje_padre =
                                                                                               (select ca.id_componente_aprendizaje
                                                                                                from aca.componente_aprendizaje ca
                                                                                                where ca.estado = 'A'
                                                                                                  and ca.codigo = 'FORMATIVA'
                                                                                                  and ca.estado = 'A')
                                                                                               then
                                                                                               ca.id_componente_aprendizaje
                                                                                           else ca.id_componente_aprendizaje_padre end)
where ca.estado = 'A'
  and cap.estado = 'A'
  and rc.estado = 'A'
  and s.estado in ('A', 'P')
  and c.estado = 'A'
  and spa.estado = 'A'
  and c.id_contenidos = (23899)
  and sma.id_malla_asignatura = (1119)
-- and cca.id_componente_aprendizaje in (select d.idComponenteAprendizaje from [aca].[fn_silabo](sma.id_malla_asignatura,23) as d)
order by cap.orden asc, ca.orden asc

select *
from aca.reglamento


select cca.id_contenido_componente_aprendizaje,
       cap.id_componente_aprendizaje as idCompAprendizajePadre,
       cap.abreviatura               as abreviaturaPadre,
       cap.codigo                    as codigoPadre,
       cap.descripcion               as componentePadre,
       ca.id_componente_aprendizaje  as idCompAprendizajeHijo,
       ca.abreviatura                as abreviaturaHijo,
       ca.codigo                     as codigoHijo,
       ca.descripcion                as componenteHijo,
       cca.horas                     as horasTotales,
       coalesce(sum(pca.horas), 0)   as horasDisponibles
from aca.silabo s
         inner join aca.contenidos c on c.id_silabo = s.id_silabo
         inner join aca.contenido_componente_aprendizaje cca on cca.id_contenidos = c.id_contenidos
         inner join aca.silabo_periodo_academico spa on spa.id_silabo = s.id_silabo
         inner join aca.silabo_malla_asignatura sma on sma.id_silabo = s.id_silabo
         inner join aca.componente_aprendizaje ca on (ca.id_componente_aprendizaje = cca.id_componente_aprendizaje)
         inner join aca.componente_aprendizaje cap on cap.id_componente_aprendizaje = (case
                                                                                           when
                                                                                               ca.id_componente_aprendizaje_padre =
                                                                                               (select ca.id_componente_aprendizaje
                                                                                                from aca.componente_aprendizaje ca
                                                                                                where ca.estado = 'A'
                                                                                                  and ca.codigo = 'FORMATIVA'
                                                                                                  and ca.estado = 'A')
                                                                                               then
                                                                                               ca.id_componente_aprendizaje
                                                                                           else ca.id_componente_aprendizaje_padre end)
         left JOIN aca.plan_clase pc
                   on c.id_contenidos = pc.id_contenidos and pc.estado = 'A' and pc.id_periodo_academico = (23) and
                      pc.id_paralelo = (1)
                       and pc.id_plan_clase not in (42862)
         left join aca.plan_componente_aprendizaje pca on pca.id_plan_clase = pc.id_plan_clase and
                                                          pca.id_componente_aprendizaje =
                                                          ca.id_componente_aprendizaje and pc.estado = 'A'
where ca.estado = 'A'
  and cap.estado = 'A'
  and s.estado in ('A', 'P')
  and c.estado = 'A'
  and spa.estado = 'A'
  and c.id_contenidos = (24193)
  and sma.id_malla_asignatura = (1109)
group by cca.id_contenido_componente_aprendizaje, cap.id_componente_aprendizaje, cap.abreviatura, cap.codigo,
         cap.descripcion,
         ca.id_componente_aprendizaje, ca.abreviatura, ca.codigo, ca.descripcion, cca.horas, cap.orden, ca.orden
order by cap.orden asc, ca.orden asc

select *
from aca.[fn_list_componentes_plan_clases](23, 24193, 1109, 42862, 1)


SELECT con.id_contenidos,
       con.horas_doc                  as horasDoc,
       con.horas_aea                  as horasPrac,
       con.horas_nad                  as horasNad,
       con.horas_ta                   as horasTa,
       con.descripcion                as descripcion,
       con.resultado_aprendizaje      as resultadoAprendizaje,
       coalesce(sum(pc.horas_doc), 0) as horasDocT,
       coalesce(sum(pc.horas_aea), 0) as horasPracT,
       coalesce(sum(pc.horas_nad), 0) as horasNadT,
       coalesce(sum(pc.horas_ta), 0)  as horasTaT
FROM aca.Contenidos con
         left JOIN aca.plan_clase pc
                   on con.id_contenidos = pc.id_contenidos and pc.estado = 'A' and pc.id_periodo_academico = (23)
                       and pc.id_paralelo = (1)
WHERE con.id_contenidos = (24193)
  and con.estado = 'A'
GROUP BY con.id_contenidos, con.horas_doc, con.horas_aea, con.horas_nad, con.horas_ta, con.descripcion,
         con.resultado_aprendizaje

select *
from aca.reglamento

select top 10 *
from aca.plan_clase
where id_plan_clase = 54555

select top 10 pca.*
from aca.plan_clase pc
         inner join aca.plan_componente_aprendizaje pca on pc.id_plan_clase = pca.id_plan_clase
where pc.id_contenidos = 24193
  and pc.id_paralelo = 1
order by pca.id_componente_aprendizaje


select spa.*
from aca.silabo_malla_asignatura sma
         inner join aca.silabo s on s.id_silabo = sma.id_silabo
         inner join aca.silabo_periodo_academico spa on spa.id_silabo = s.id_silabo
where sma.id_malla_asignatura = 1751

SELECT *
from aca.periodo_academico
where id_tipo_oferta = 4

-- 'edit-plan-analitico/:idMallaAsignatura/:idSilabo/:idPeriodoAcademico',
-- edit-plan-analitico/1751/2666/27 GESTION CONTABLE DE LA EMPRESA TURISTICA de TURISMO PLAYAS
-- edit-plan-analitico/1711/2032/27 GESTION CONTABLE DE LA EMPRESA TURISTICA de TURISMO MATRIZ

-- edit-plan-analitico/2197/2670/28 MATEMATICAS CONTABILIDAD Y AUDITORIA
-- edit-plan-analitico/1276/1480/24 MATEMATICA CONTABILIDAD Y AUDITORIA

select m.id_malla, ma.id_malla_asignatura, ma.id_nivel, a.id_asignatura, a.descripcion as asignatura, m.descripcion
--        m1.id_malla,ma1.id_malla_asignatura,ma1.id_nivel,a1.id_asignatura,a1.descripcion as asignatura_compatible,m1.descripcion
from aca.malla_asignatura ma
         inner join aca.malla m on ma.id_malla = m.id_malla
         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where ma.estado = 'A'
  and a.estado = 'A'
  and m.estado in ('A', 'P')
  and m.id_oferta_modalidad in (89, 134)

select *
from aca.ofertas_facultad ofa
where id_tipo_oferta = 2

exec [aca].[replicate_enlazar_silabos_from_other_malla_asignatura] 230, 3025, 0,
     42, 92, '2400254286', 664

exec [aca].[replicate_enlazar_silabos] 1544, 0, 95, 96, 1, 664
select m.descripcion, a.descripcion, ma.*
from aca.malla_asignatura ma
         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
         inner join aca.malla m on ma.id_malla = m.id_malla
where ma.id_malla_asignatura = 1513

--modelo de silabos

-- alter table aca.metodologia_ensenanza add
--     fecha_ing            datetime2(7)         null default current_timestamp,
--     fecha_mod            datetime2(7)         null default current_timestamp,
--     usuario_ing          varchar(255)         null,
--     usuario_mod          varchar(255)         null

select *
from aca.silabo

-- update aca.silabo set usuario_ing ='2400254286' where usuario_ing is null
-- update aca.silabo set usuario_mod ='2400254286' where usuario_mod is null
-- update aca.silabo set fecha_ing = fecha_ingreso where fecha_ingreso is not null and fecha_ing is null
-- select s.*
--     update s set s.usuario_ing = u.usuario
-- --     , s.usuario_mod = u.usuario
-- from aca.silabo s
-- inner join seg.usuarios u on u.id = s.usuario_ingreso_id
-- where s.usuario_ing ='2400254286' --and s.usuario_mod='2400254286'
--   and s.usuario_ingreso_id not in (664,1)

select *
from aca.contenidos

select *
from aca.tipo_bibliografia
select *
from aca.silabo_bibliografia
select *
from aca.silabo_bibliografia_no_catalogada
SELECT *
FROM ACA.silabo_periodo_academico
select *
from aca.periodo_academico
select *
from aca.silabo_malla_asignatura
select *
from aca.recurso_academico
select *
from aca.recursos_didacticos
select *
from aca.plan_recurso_didactico
select *
from aca.estrategia_evaluacion
select *
from aca.metodologia_ensenanza
select *
from aca.tipo_estudiante
select *
from aca.sistema_estudio

select *
from aca.ofertas_facultad
where id_tipo_oferta = 3
-- update aca.silabo_malla_asignatura set usuario_ing ='2400254286' where usuario_ing is null
-- update aca.silabo_malla_asignatura set usuario_mod ='2400254286' where usuario_mod is null
-- update aca.silabo_malla_asignatura set fecha_ing = fecha_ingreso where fecha_ingreso is not null and fecha_ing is null
-- update aca.silabo_malla_asignatura set fecha_mod =fecha_ing where fecha_ing is not null

-- select s.*
--     update s set s.usuario_ing = u.usuario
-- --     , s.usuario_mod = u.usuario
-- from aca.silabo_malla_asignatura s
-- inner join seg.usuarios u on u.id = s.usuario_ingreso_id
-- where s.usuario_ing ='2400254286' --and s.usuario_mod='2400254286'
--   and s.usuario_ingreso_id not in (664,1)

select * from aca.tipo_categoria_inteligencia_artificial
SELECT * from aca.inteligencia_artificial
select *
from aca.resultado_aprendizaje_inteligencia_artificial

select *
from aca.contenido_resultado_aprendizaje

select *
from aca.tipo_tecnologia_aprendizaje
select * from aca.tecnologia_aprendizaje
--eliminar
select *
from aca.silabo_componente_item_actividad


select *
from aca.estrategia_evaluacion
select *
from aca.metodologia_ensenanza
select *
from aca.recursos_didacticos

-- DBCC CHECKIDENT ('aca.tipo_tecnologia_aprendizaje', RESEED, 14);
--TABLAS NUEVAS

select *
from aca.silabo_categoria_componente
select *
from aca.silabo_componente
select *
from aca.silabo_componente_item
select *
from aca.oferta_silabo_item
select *
from aca.contenido_resultado_aprendizaje
select *
from aca.resultado_aprendizaje_item_relacion
select *
from aca.silabo_item_relacion
select *
from aca.resultado_aprendizaje_inteligencia_artificial
select *
from aca.silabo_funciones_sustantivas

select *
from aca.malla_asignatura

select a.descripcion, s.*
from aca.asignatura_resultado_aprendizaje s
         inner join aca.malla_asignatura ma on s.id_malla_asignatura = ma.id_malla_asignatura
         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where ma.id_malla_asignatura = 1645

--tablas vinculacion
select *
from aca.requisito

select *
from aca.oferta_docente

select *
from vcc.proyecto

select *
from vcc.oferta_proyecto

select *
from vcc.cronograma

select*
from vcc.docente_proyecto

select *
from vcc.estudiante_proyecto

select *
from vcc.beneficiario

select *
from vin.proyecto

select *
from aca.requisito

select *
from aca.malla_asignatura

select *
from aca.asignatura_resultado_aprendizaje

select *
from aca.silabo_malla_asignatura
where id_malla_asignatura = 1513

select *
from aca.silabo_malla_asignatura
where id_malla_asignatura = 3029

select *
from aca.silabo_periodo_academico
where id_silabo = 6053

select *
from aca.silabo_periodo_academico
where id_silabo = 6125

select *
from aca.contenidos
where id_silabo = 6053

select *
from aca.silabo_bibliografia
where id_silabo = 6053

select *
from aca.silabo_bibliografia_no_catalogada
where id_silabo = 6053


select *
from aca.silabo_periodo_academico

select top 1 *
from aca.silabo_malla_asignatura

-- exec [aca].[replicate_enlazar_silabos_from_other_malla_asignatura] 1276,2197,0,
-- --     24,28,'2400254286',664

select top 3 *
from aca.silabo
order by fecha_ing desc
--  DBCC CHECKIDENT ('aca.silabo', RESEED, 1670);

select top 1 *
from aca.silabo_periodo_academico
order by fecha_ing desc
--  DBCC CHECKIDENT ('aca.silabo_periodo_academico', RESEED, 1885);

select top 1 *
from aca.silabo_malla_asignatura
order by fecha_ing desc
--  DBCC CHECKIDENT ('aca.silabo_malla_asignatura', RESEED, 1421);

select top 1 *
from aca.silabo_bibliografia
order by fecha_ing desc
--  DBCC CHECKIDENT ('aca.silabo_bibliografia', RESEED, 4006);

select top 1 *
from aca.silabo_bibliografia_no_catalogada
order by fecha_ing desc
--  DBCC CHECKIDENT ('aca.silabo_bibliografia_no_catalogada', RESEED, 4418);

select top 1 *
from aca.contenidos
order by fecha_ing desc
--  DBCC CHECKIDENT ('aca.contenidos', RESEED, 36303);


select *
from aca.fn_get_dias_horas_by_horario_asignatura
     (942, 1, 30) as d
DECLARE @pi_id_malla_asignatura INT = 942,@pi_id_paralelo int = 1, @pi_id_periodo_academico int = 30
select sum(d.total) as horas, d.dia, d.numberDay
from (select (DATEDIFF(minute, h1.hora_inicio, h1.hora_fin)) as horas,
             isnull(h1.tiempo_receso, 0)                     as tiempo_receso,
             isnull(h1.tiempo_receso, 0) * 60                as receso,
             dia1.descripcion                                as dia,
             dia1.orden                                      as numberDay,
             cast(((DATEDIFF(minute, h1.hora_inicio, h1.hora_fin)) - isnull(h1.tiempo_receso, 0) * 60) /
                  60.00 as decimal(9, 1))                    as total
      from aca.horario_academico h1
               inner join aca.dia dia1 on dia1.id_dia = h1.id_dia
      where h1.estado = 'A'
        and dia1.estado = 'A'
        AND h1.id_malla_asignatura = @pi_id_malla_asignatura
        and h1.id_paralelo = @pi_id_paralelo
        and h1.id_periodo_academico = @pi_id_periodo_academico
      group by h1.hora_inicio, h1.hora_fin, dia1.descripcion, dia1.orden, h1.tiempo_receso
      -- order by numberDay asc
      union
      select (DATEDIFF(minute, h1.hora_inicio, h1.hora_fin)) as horas,
             isnull(h1.tiempo_receso, 0)                     as tiempo_receso,
             isnull(h1.tiempo_receso, 0) * 60                as receso,
             dia1.descripcion                                as dia,
             dia1.orden                                      as numberDay,
             cast(((DATEDIFF(minute, h1.hora_inicio, h1.hora_fin)) - isnull(h1.tiempo_receso, 0) * 60) /
                  60.00 as decimal(9, 1))                    as total
      from aca.malla_asignatura_fusion maf
               inner join aca.malla_asignatura_fusion_detalle mafd
                          on maf.id_malla_asignatura_fusion = mafd.id_malla_asignatura_fusion
               inner join aca.malla_asignatura ma on maf.id_malla_asignatura = ma.id_malla_asignatura
               inner join aca.horario_academico h1 on ma.id_malla_asignatura = h1.id_malla_asignatura
               inner join aca.dia dia1 on dia1.id_dia = h1.id_dia
      where maf.estado = 'A'
        and mafd.estado = 'A'
        AND mafd.id_malla_asignatura = @pi_id_malla_asignatura
        and mafd.id_paralelo = @pi_id_paralelo
        and maf.id_periodo_academico = @pi_id_periodo_academico
      group by h1.hora_inicio, h1.hora_fin, dia1.descripcion, dia1.orden, h1.tiempo_receso
         --     order by numberDay asc
     ) as d
group by d.dia, d.numberDay
order by d.numberDay asc

select d.*
from [aca].[fn_silabo](836, 96) as d

begin
    declare @pi_id_periodo_academico int= 96,@id_malla_asignatura int = 836
    select distinct a.codigo,a.id_asignatura as idAsignatura,a.descripcion as nombreAsignatura, ma.num_horas as numHoras, ma.num_creditos as creditos,
                    n.descripcion as descripcionNivel,n.orden as ordenNivel,ma.id_malla_asignatura as idMallaAsignatura,
                    co.descripcion as componenteOrganizacion,ca.id_componente_aprendizaje idComponenteAprendizaje, --rv.valor
                    ca.codigo  ,ca.descripcion as componenteAprendizaje,ca.abreviatura,
                    coalesce((coalesce(aa.valor, 0)+ case when ca.abreviatura='APD' THEN (SELECT isnull(a1.valor,0) FROM aca.asignatura_aprendizaje a1
                                                                    inner join aca.componente_aprendizaje ca on ca.id_componente_aprendizaje =a1.id_componente_aprendizaje
                                                                    where a1.id_malla_asignatura=aa.id_malla_asignatura and ca.abreviatura ='NAD') ELSE 0 END)  * pa.numero_semanas,0) as valor ,
                    coalesce((select sum(cca1.horas) f
                              from aca.silabo s1

                                       inner join aca.silabo_periodo_academico spa on spa.id_silabo = s1.id_silabo
                                       inner join aca.contenidos c1 on s1.id_silabo=c1.id_silabo
                                       inner join aca.contenido_componente_aprendizaje cca1 on c1.id_contenidos=cca1.id_contenidos
                              where s1.estado in ('A','P') and c1.estado='A' and c1.id_contenido_padre is not null
                                and s1.id_malla_asignatura=ma.id_malla_asignatura and cca1.estado='A'  and spa.estado='A'
                                and cca1.id_componente_aprendizaje= ca.id_componente_aprendizaje and spa.id_periodo_academico= @pi_id_periodo_academico), 0) as horasAsignadas,
                    ( (select aca.fn_silabo_componente_horas_sincrona (@pi_id_periodo_academico, m.id_reglamento, ma.id_malla_asignatura))*pa.numero_semanas) horasSincrona
            ,(
                        SELECT ar.*, r.descripcion
                        FROM aca.asignatura_requisito ar
                        inner join aca.requisito r on ar.id_requisito=r.id_requisito
                        WHERE ar.estado='A' and  ar.id_malla_asignatura=ma.id_malla_asignatura
                        FOR JSON PATH
            ) AS asignaturaRequisito, id_oferta_modalidad
    from aca.asignatura a
    JOIN aca.malla_asignatura ma on ma.id_asignatura=a.id_asignatura
    inner join aca.malla m on ma.id_malla=m.id_malla
    LEFT join  aca.asignatura_organizacion ao on ao.id_malla_asignatura = ma.id_malla_asignatura
    LEFT join aca.componente_organizacion co on ao.id_comp_organizacion = co.id_componente_organizacion
    LEFT join aca.tipo_comp_organizacion tco on co.id_tipo_comp_organizacion = tco.id_tipo_comp_organizacion and tco.abreviatura='UOC'
    JOIN aca.nivel n on ma.id_nivel = n.id_nivel
    JOIN aca.reglamento r on m.id_reglamento=r.id_reglamento
    JOIN aca.periodo_malla pm on pm.id_malla = m.id_malla
    JOIN aca.periodo_academico pa on pm.id_periodo_academico = pa.id_periodo_academico
    join aca.asignatura_aprendizaje aa on ma.id_malla_asignatura=aa.id_malla_asignatura
    join aca.componente_aprendizaje ca on aa.id_componente_aprendizaje=ca.id_componente_aprendizaje
    WHERE ma.id_malla_asignatura = @id_malla_asignatura and pa.id_periodo_academico=@pi_id_periodo_academico and aa.estado='A' and aa.valor>0 and ca.abreviatura not in ('NAD')
end

select * from aca.asignatura where codigo in ('ENF-CLI-QUI','ENF-PED','ENF-SAL-SEX-REP','ENF-SP')

select ma.id_malla_asignatura,ma.id_malla,ma.id_nivel,a.codigo,a.descripcion from aca.asignatura a
inner JOIN aca.malla_asignatura ma on ma.id_asignatura=a.id_asignatura
inner join aca.malla m on ma.id_malla = m.id_malla
where m.id_oferta_modalidad = 31 and ma.id_nivel in (8,9) and ma.id_malla = 34


select cast(sum(cast(aa.valor as decimal(10, 2))) as decimal(10, 2)) - ISNULL(pcc.valor, 0)--- coalesce(ISNULL(pcc.valor,0) * pa.numero_semanas,0)

from aca.asignatura a
         inner JOIN aca.malla_asignatura ma on ma.id_asignatura = a.id_asignatura
         inner JOIN aca.malla m on ma.id_malla = m.id_malla
         inner JOIN aca.periodo_malla pm on pm.id_malla = m.id_malla
         inner JOIN aca.periodo_academico pa on pm.id_periodo_academico = pa.id_periodo_academico
         inner join aca.asignatura_aprendizaje aa on ma.id_malla_asignatura = aa.id_malla_asignatura
         inner join aca.componente_aprendizaje ca on aa.id_componente_aprendizaje = ca.id_componente_aprendizaje
         inner join aca.periodo_academico_oferta pao on pao.id_periodo_academico = pm.id_periodo_academico and
                                                        pao.id_oferta_modalidad = m.id_oferta_modalidad
         left join aca.periodo_componente_aprendizaje pcc
                   on pcc.id_periodo_academico_oferta = pao.id_periodo_academico_oferta and
                      pcc.id_componente_aprendizaje = ca.id_componente_aprendizaje and pcc.estado = 'A'
WHERE pa.id_periodo_academico = 127
  and ma.id_malla_asignatura = 2205
  and pao.estado = 'A'
  and pm.estado = 'A'
  and aa.estado = 'A'
  and aa.valor > 0
  and ca.codigo in ('DOCENCIA', 'SINCRONICO', 'SINCRONICOP', 'ASISTIDODOCENTE')
group by pcc.valor, pa.numero_semanas

-- 2218/2416/28
--  path: 'edit-plan-analitico-docente/:idMallaAsignatura/:idSilabo/:idPeriodoAcademico',

-- idMallaAsignatura 2725
-- idOfertaModalidad 120
-- idReglamento 35
exec aca.sp_rpt_total_matriculados_por_facultades 33


select d.*
from [aca].[fn_listar_detalle_silabos_by_oferta_and_periodo](109, 12, 127) as d
select d.*
from [aca].[fn_listar_detalle_silabos_by_oferta_and_periodo](101, 12, 96) as d

select * from aca.silabo_periodo_academico where id_silabo in (8813)

select * from aca.silabo where id_silabo in (8813)

select distinct ppd.* from aca.planificacion_paralelo pp
inner join aca.planificacion_paralelo_detalle ppd on pp.id_planificacion_paralelo = ppd.id_planificacion_paralelo
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = pp.id_malla_asignatura
where  ma.id_malla in (110) and pp.id_periodo_academico=96



select rod.* from aca.periodo_malla pm
inner join aca.relacion_oferta_detalle rod on pm.id_periodo_malla = rod.id_periodo_malla
where pm.id_malla in (108,110) and pm.id_periodo_academico = 127

select * from  aca.tipo_bibliografia tb

begin
    declare @pi_id_oferta_modalidad int = 101,@pi_id_departamento int = 12, @pi_id_periodo_academico int =96,@periodoAnterior int = 95
    select aux.id_silabo               as idSilabo,
           om.id_oferta                   idOferta,
           ma.id_malla_asignatura      as idMallaAsignatura,
           a.descripcion               as asignatura,
           n.descripcion_corta         as nivel,
           aux.estado                  as estadoSilabo,
           om.carrera                  as Oferta,
           om.facultad                 as Facultad,
           case   when aux.estado is null then 'NO CREADO' when aux.estado = 'P' then 'PUBLICADO'    ELSE 'NO PUBLICADO' end as estadoCreacionSilabo,
           case when np.num_sil = 1 then 'REPLICA' when np.num_sil > 1 then 'VINCULADO' else 'NO EXISTE' end as estadoReplica,
           case
               when (cs.horas_contenidos = (coalesce(ha.horas_malla, 0) * rv.valor)) then 'SÍ' ELSE 'NO' end as completaHoras, 'SI' as tieneDoc,
--            case
--                when (select count(ds.id_documento_silabo)
--                      from aca.documento_silabo ds
--                      where aux.id_silabo = aux.id_silabo
--                        and ds.estado = 'A') = 0 then 'NO'
--                ELSE 'SÍ' end                                       as tieneDoc,
           case  when (sba.contador_bas + sbna.contador_bas) = 0 then 'NO' ELSE 'SÍ' end as tieneBibliografiaBasica,
           case  when (sba.contador_comp + sbna.contador_comp) = 0 then 'NO' ELSE 'SÍ' end as tieneBibliografiaComplementaria,
           om.id_oferta_modalidad,
           case when om.codigo_modalidad = 'PRESENCIAL' then 35 else 36 end as idReglamento,
           om.codigo_modalidad,
           IIF(sa.id_silabo is not null, 1,  0) AS silabosAnterior
    from aca.asignatura a
    inner JOIN aca.malla_asignatura ma on ma.id_asignatura = a.id_asignatura
    inner JOIN aca.Malla m on m.id_malla = ma.id_malla
    inner join aca.periodo_malla pm on pm.id_malla = m.id_malla
    inner JOIN aca.Reglamento r on m.id_reglamento = r.id_reglamento
    inner JOIN aca.reglamento_validacion rv on r.id_reglamento = rv.id_reglamento
    inner JOIN aca.Validacion v on v.id_validacion = rv.id_validacion
    inner JOIN aca.Nivel n on n.id_nivel = ma.id_nivel
    inner JOIN aca.ofertas_facultad om on om.id_oferta_modalidad = m.id_oferta_modalidad
    inner join aca.planificacion_paralelo pp on pp.id_malla_asignatura = ma.id_malla_asignatura
    inner join (select sum(aap.valor) as horas_malla,aap.id_malla_asignatura
               from aca.asignatura_aprendizaje aap
               where aap.estado = 'A' group by aap.id_malla_asignatura) as ha on ha.id_malla_asignatura = ma.id_malla_asignatura
    left join (select s.id_malla_asignatura, s.id_silabo, s.estado
        from aca.silabo s
        inner join aca.silabo_periodo_academico spa on spa.id_silabo = s.id_silabo and spa.id_periodo_academico = @pi_id_periodo_academico
        where s.estado in ('A', 'P') and spa.estado = 'A')  as aux on aux.id_malla_asignatura = ma.id_malla_asignatura
    left join (select s.id_malla_asignatura, s.id_silabo, s.estado
        from aca.silabo s
        inner join aca.silabo_periodo_academico spa on spa.id_silabo = s.id_silabo and spa.id_periodo_academico = @periodoAnterior
        where s.estado in ('A', 'P') and spa.estado = 'A')  as sa on sa.id_malla_asignatura = ma.id_malla_asignatura
    left join (select coalesce(sum(cca.horas), 0) as horas_contenidos,c.id_silabo from aca.contenidos c
                inner join aca.contenido_componente_aprendizaje cca on c.id_contenidos = cca.id_contenidos
               where c.id_contenido_padre is not null and c.estado = 'A' and cca.estado = 'A' group by c.id_silabo) as cs on cs.id_silabo = aux.id_silabo
    left join (select sb.id_silabo, count(case when tb.codigo= 'COM' then 1 end) as contador_comp, count(case when tb.codigo= 'BAS' then 1 end) as contador_bas
               from aca.silabo_bibliografia sb
                inner join aca.tipo_bibliografia tb on tb.id_tipo_bibliografia = sb.id_tipo_bibliografia --and    (tb.codigo = 'COM' or tb.descripcion = 'Complementaria')
               where sb.estado='A' and tb.estado='A' group by sb.id_silabo) as sba on sba.id_silabo = aux.id_silabo
    left join (select sbnc.id_silabo, count(case when tb.codigo= 'COM' then 1 end) as contador_comp, count(case when tb.codigo= 'BAS' then 1 end) as contador_bas
                    from aca.silabo_bibliografia_no_catalogada sbnc
                     inner join aca.tipo_bibliografia tb on tb.id_tipo_bibliografia = sbnc.id_tipo_bibliografia --and  (tb.codigo = 'COM' or tb.descripcion = 'Complementaria')
                    where sbnc.estado='A' and tb.estado='A' group by sbnc.id_silabo) as sbna on sbna.id_silabo = aux.id_silabo
    left join (select count(distinct spa.id_periodo_academico) as num_sil,spa.id_silabo
                     from aca.silabo_periodo_academico spa
                     where spa.estado = 'A' group by spa.id_silabo) as np on np.id_silabo = aux.id_silabo
    WHERE (om.id_oferta_modalidad = @pi_id_oferta_modalidad or @pi_id_oferta_modalidad is null)
      and (om.id_departamento = @pi_id_departamento or @pi_id_departamento is null)
      and pm.id_periodo_academico = @pi_id_periodo_academico
      and pp.id_periodo_academico = pm.id_periodo_academico and pp.num_paralelos>0 and pp.ofertada = 1 and pp.estado='A'
      and a.estado = 'A' and ma.estado = 'A'
      and m.estado in ('P', 'A') and n.estado = 'A' and r.estado = 'A'  and rv.estado = 'A' and v.estado = 'A'
      and v.codigo = 'NUMSEMANASPAO' and pm.estado = 'A' --and m.id_malla not in (33)
    order by n.orden
end

---ahora solo mateticas
select *
from aca.silabo_malla_asignatura
where id_malla_asignatura in (2174)

-- Materias Orígenes para replicar a las demás carreras de la facultad:
-- Introducción a la Ingeniería de la carrera de Tecnologías de la Información.
-- Física y Matemáticas de la carrera de Software

select *
from aca.silabo
where id_silabo in (3561)
select *
from aca.contenidos
where id_silabo = 3561
select *
from aca.silabo_malla_asignatura
where id_silabo = 3561
select *
from aca.silabo_periodo_academico spa
where spa.id_silabo = 3561
select *
from aca.silabo_bibliografia
where id_silabo = 3561
select *
from aca.silabo_bibliografia_no_catalogada
where id_silabo = 3561


select *
from aca.silabo
where id_silabo in (3566)
select *
from aca.contenidos
where id_silabo = 3566
select *
from aca.silabo_malla_asignatura
where id_malla_asignatura = 2185
select *
from aca.silabo_periodo_academico spa
where spa.id_silabo = 3566
select *
from aca.silabo_bibliografia
where id_silabo = 3566
select *
from aca.silabo_bibliografia_no_catalogada
where id_silabo = 3566

select s.id_silabo, sp.id_silabo_periodo_academico, sma.id_silabo_malla_asignatura
from bd_sga_upse.aca.silabo s
         inner join aca.silabo_malla_asignatura sma on sma.id_silabo = s.id_silabo
         inner join aca.silabo_periodo_academico sp
                    on sp.id_silabo = s.id_silabo and sp.id_periodo_academico = 32 and sp.estado = 'A'
where sma.id_malla_asignatura = 2171
  and s.estado in ('A', 'P')
  and sma.estado = 'A'
-- 3566
select *
from aca.silabo_periodo_academico spa
where spa.id_silabo = 1883

select *
from aca.contenidos
where id_silabo = 3552
  and cast(fecha_ing as date) = cast(getdate() as date)

select *
from aca.contenidos
where id_silabo = 3619
  and cast(fecha_ing as date) = cast(getdate() as date)

select *
from aca.silabo_bibliografia
where id_silabo = 1883
  and cast(fecha_ing as date) = cast(getdate() as date)

select *
from aca.silabo_bibliografia_no_catalogada
where id_silabo = 1883
  and cast(fecha_ing as date) = cast(getdate() as date)

select d.*
from [aca].[fn_listar_detalle_silabos_by_oferta_and_periodo](null, 5, 36) as d
where d.nivel = 3

select d.*
from [aca].[fn_listar_detalle_silabos_by_oferta_and_periodo](null, 9, 35) as d
where d.nivel = 4

select d.*
from rel.fn_relaciones_ofertas_nivelacion_grado(38) as d
select *
from man.departamentos

select *
from aca.silabo_malla_asignatura
where id_silabo = 5483

select *
from aca.documento_silabo

exec [aca].[replicate_silabos_from_other_silabos] 3969, 1838, 5186, 1838,
     35, 36, '2400254286', 0

exec [aca].[replicate_silabos_from_other_silabos] 1840, 1634, 5814, 2495,
     36, 36, '2400254286', 0

--replicar silabos de fisicaII facistel
exec [aca].[replicate_silabos_from_other_silabos] 4898, 1629, 4508, 2491,
     36, 36, '2400254286', 0

--replicar silabos de mateticas facsistel
exec [aca].[replicate_silabos_from_other_silabos] 3539, 2184, 3624, 2169,
     32, 32, '2400254286', 0
exec [aca].[replicate_silabos_from_other_silabos] 3539, 2184, 3625, 2166,
     32, 32, '2400254286', 0
exec [aca].[replicate_silabos_from_other_silabos] 3539, 2184, 3626, 2172,
     32, 32, '2400254286', 0
--replicar silabos de fisica facsistel
exec [aca].[replicate_silabos_from_other_silabos] 3561, 2185, 3627, 2170,
     32, 32, '2400254286', 0
exec [aca].[replicate_silabos_from_other_silabos] 3561, 2185, 3628, 2167,
     32, 32, '2400254286', 0
exec [aca].[replicate_silabos_from_other_silabos] 7527, 3261, 8876, 3299,
     96, 96, '2400254286', 0

select * from aca.ofertas_facultad where id_tipo_oferta = 2

select d.*  from [aca].[fn_listar_detalle_silabos_by_oferta_and_periodo](38,5,96)  as d
select d.*  from [aca].[fn_listar_detalle_silabos_by_oferta_and_periodo](134,5,96)  as d
--  DBCC CHECKIDENT ('aca.silabo', RESEED, 1670);

select top 3 *
from aca.silabo_periodo_academico
order by fecha_ing desc
--  DBCC CHECKIDENT ('aca.silabo_periodo_academico', RESEED, 1885);

select top 1 *
from aca.silabo_malla_asignatura
order by fecha_ing desc
--  DBCC CHECKIDENT ('aca.silabo_malla_asignatura', RESEED, 1421);


--listas las carreras de nivelacion
select pao.id_periodo_academico_oferta,
       pa.id_periodo_academico,
       m.descripcion,
       pa.codigo,
       d.id,
       d.nombre,
       om.id_oferta_modalidad,
       o.descripcion
from aca.periodo_academico_oferta pao
         inner join aca.periodo_academico pa on pao.id_periodo_academico = pa.id_periodo_academico
         inner join aca.oferta_modalidad om on pao.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.modalidad m on m.id_modalidad = om.id_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.departamento_oferta do on o.id_oferta = do.id_oferta
         inner join man.departamentos d on do.id_departamento = d.id
where pao.estado = 'A'
  and pa.estado = 'A'
  and om.estado = 'A'
  and o.estado = 'A'
  and do.estado = 'A'
  and d.estado = 'AC'
  and o.id_tipo_oferta = 1
  and pa.id_periodo_academico = 32
  and (d.id in (12, 8, 9))
order by d.nombre, o.descripcion

select pao.id_periodo_academico_oferta,
       2,
       5,
       'A',
       0,
       getdate(),
       getdate(),
       '2400254286',
       '2400254286'
from aca.periodo_academico_oferta pao
         inner join aca.periodo_academico pa on pao.id_periodo_academico = pa.id_periodo_academico
         inner join aca.oferta_modalidad om on pao.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.departamento_oferta do on o.id_oferta = do.id_oferta
         inner join man.departamentos d on do.id_departamento = d.id
where pao.estado = 'A'
  and pa.estado = 'A'
  and om.estado = 'A'
  and o.estado = 'A'
  and do.estado = 'A'
  and d.estado = 'AC'
  and o.id_tipo_oferta = 1
  and pa.id_periodo_academico = 32
  and (d.id in (12, 8, 9))
order by d.nombre, o.descripcion

select *
from aca.componente_aprendizaje

select *
from aca.periodo_componente_aprendizaje

select d.*
from [aca].[fn_silabo](303, 140) as d

begin
declare @pi_id_periodo_academico int =140,@pi_id_malla_asignatura int =804
select distinct a.id_asignatura as idAsignatura,a.descripcion as nombreAsignatura,
                ma.num_horas as numHoras, ma.num_creditos as creditos,
                n.descripcion as descripcionNivel,n.orden as ordenNivel,ma.id_malla_asignatura as idMallaAsignatura,
                co.descripcion as componenteOrganizacion,ca.id_componente_aprendizaje idComponenteAprendizaje, --rv.valor
                ca.codigo  ,ca.descripcion as componenteAprendizaje,ca.abreviatura,
                coalesce((coalesce(aa.valor, 0)+
                          case when ca.abreviatura='APD' THEN (SELECT isnull(a1.valor,0) FROM aca.asignatura_aprendizaje a1
                                                                inner join aca.componente_aprendizaje ca on ca.id_componente_aprendizaje =a1.id_componente_aprendizaje
                                                              where a1.id_malla_asignatura=aa.id_malla_asignatura and ca.abreviatura ='NAD') ELSE 0 END)  * iif(pa.codigo_tipo_periodo='PAEXT',16,pa.numero_semanas),0) as valor ,
                coalesce((select sum(cca1.horas) f
                          from aca.silabo s1
                                   inner join aca.silabo_periodo_academico spa on spa.id_silabo = s1.id_silabo
                                   inner join aca.contenidos c1 on s1.id_silabo=c1.id_silabo
                                   inner join aca.contenido_componente_aprendizaje cca1 on c1.id_contenidos=cca1.id_contenidos
                          where s1.estado in ('A','P') and c1.estado='A' and c1.id_contenido_padre is not null
                            and s1.id_malla_asignatura=ma.id_malla_asignatura and cca1.estado='A'  and spa.estado='A'
                            and cca1.id_componente_aprendizaje= ca.id_componente_aprendizaje and spa.id_periodo_academico= @pi_id_periodo_academico), 0) as horasAsignadas,
                ( (select aca.fn_silabo_componente_horas_sincrona (@pi_id_periodo_academico, m.id_reglamento, ma.id_malla_asignatura))
                      *iif(pa.codigo_tipo_periodo='PAEXT',16,pa.numero_semanas)) horasSincrona
        ,(SELECT
              ar.*, r.descripcion
          FROM aca.asignatura_requisito ar
                   inner join aca.requisito r on ar.id_requisito=r.id_requisito
          WHERE ar.estado='A' and  ar.id_malla_asignatura=ma.id_malla_asignatura
          FOR JSON PATH
                ) AS asignaturaRequisito, id_oferta_modalidad
from aca.asignatura a
         JOIN aca.malla_asignatura ma on ma.id_asignatura=a.id_asignatura
         inner join aca.malla m on ma.id_malla=m.id_malla
         LEFT join  aca.asignatura_organizacion ao on ao.id_malla_asignatura = ma.id_malla_asignatura
         LEFT join aca.componente_organizacion co on ao.id_comp_organizacion = co.id_componente_organizacion
         LEFT join aca.tipo_comp_organizacion tco on co.id_tipo_comp_organizacion = tco.id_tipo_comp_organizacion and tco.abreviatura='UOC'
         JOIN aca.nivel n on ma.id_nivel = n.id_nivel
         JOIN aca.reglamento r on m.id_reglamento=r.id_reglamento
         JOIN aca.periodo_malla pm on pm.id_malla = m.id_malla
         JOIN aca.periodo_academico pa on pm.id_periodo_academico = pa.id_periodo_academico
         join aca.asignatura_aprendizaje aa on ma.id_malla_asignatura=aa.id_malla_asignatura
         join aca.componente_aprendizaje ca on aa.id_componente_aprendizaje=ca.id_componente_aprendizaje
WHERE ma.id_malla_asignatura = @pi_id_malla_asignatura
  and pa.id_periodo_academico=@pi_id_periodo_academico and aa.estado='A' and aa.valor>0
  and ca.abreviatura not in ('NAD')

end

select d.*
from [aca].[fn_silabo](287, 35) as d

select spa.id_periodo_academico, cca1.*
from aca.silabo s1
         inner join aca.silabo_malla_asignatura sma on s1.id_silabo = sma.id_silabo
         inner join aca.silabo_periodo_academico spa on spa.id_silabo = s1.id_silabo
         inner join aca.contenidos c1 on s1.id_silabo = c1.id_silabo
         left join aca.contenido_componente_aprendizaje cca1 on c1.id_contenidos = cca1.id_contenidos
where                             --s1.estado in ('A','P') and c1.estado='A' and c1.id_contenido_padre is not null
    sma.id_malla_asignatura = 287 -- and cca1.estado='A' and sma.estado='A' and spa.estado='A'
  and cca1.id_componente_aprendizaje in (2, 6, 7, 8)
  and spa.id_periodo_academico = 35

select *
from aca.tipo_oferta
select *
from aca.plan_clase

select *
from aca.horario_academico

select *
from man.horario_comun

select *
from aca.tipo_horario_jornada_lab


select *
from aca.tipo_horario

select *
from aca.tipo_jornada_laboral


select *
from aca.documentos_plan_clase

select *
from aca.componente_aprendizaje
where id_componente_aprendizaje_padre = 3

select mo.codigo, tof.codigo, o.descripcion_corta
from aca.modalidad mo
         inner join aca.oferta_modalidad om on mo.id_modalidad = om.id_modalidad
         inner join aca.malla m on om.id_oferta_modalidad = m.id_oferta_modalidad
         inner join aca.malla_asignatura ma on m.id_malla = ma.id_malla
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.tipo_oferta tof on tof.id_tipo_oferta = o.id_tipo_oferta
where om.estado = 'A'
  and om.estado = 'A'
  and m.estado in ('A', 'P')
  and ma.estado = 'A'
  and ma.id_malla_asignatura = 2377

select *
from man.personas
where identificacion = 'F711437'

select *
from seg.usuarios
where usuario = 'F711437'

select *
from [aca].[fn_lista_silabo_asignatura_cab](3568, 32, 2)
ORDER BY orden

select *
from aca.plan_clase

SELECT con.id_silabo                                                                                            as idSilabo,
       con.id_contenido_padre                                                                                   as idContenidoPadre,
       con.id_contenidos                                                                                        as idContenido,
       con.descripcion                                                                                          as contenido,
       con.resultado_aprendizaje                                                                                as resultadoAprendizaje,
       sum(caa.horas)                                                                                           as horas,
       con.orden                                                                                                as orden,
       ISNULL((select sum(isnull(pca.horas, 0))
               from aca.plan_clase pc
                        inner join aca.plan_componente_aprendizaje pca on pc.id_plan_clase = pca.id_plan_clase
                        inner join aca.contenidos c1 on pc.id_contenidos = c1.id_contenidos
               where pc.estado = 'A'
                 and pc.id_periodo_academico = 32
                 and pc.id_paralelo = 2
                 and pca.estado = 'A'
                 and c1.id_contenido_padre = con.id_contenidos) * 100 / sum(ISNULL(caa.horas, 0)),
              0)                                                                                                as quantity,
       ISNULL((select sum(isnull(pca.horas, 0))
               from aca.plan_clase pc
                        inner join aca.plan_componente_aprendizaje pca on pc.id_plan_clase = pca.id_plan_clase
                        inner join aca.contenidos c1 on pc.id_contenidos = c1.id_contenidos
               where pc.estado = 'A'
                 and pc.id_periodo_academico = 32
                 and pc.id_paralelo = 2
                 and pca.estado = 'A'
                 and c1.id_contenido_padre = con.id_contenidos) * 100 / sum(ISNULL(pca.valor, aa.valor), 0),
              0)                                                                                                as quantity
FROM aca.contenidos con
         inner join aca.contenidos ch on con.id_contenidos = ch.id_contenido_padre
         inner join aca.contenido_componente_aprendizaje caa on ch.id_contenidos = caa.id_contenidos
         inner join aca.componente_aprendizaje ca on ca.id_componente_aprendizaje = caa.id_componente_aprendizaje
         inner join aca.silabo s on con.id_silabo = s.id_silabo
         inner join aca.silabo_malla_asignatura sma on s.id_silabo = sma.id_silabo
         inner join aca.malla_asignatura ma on sma.id_malla_asignatura = ma.id_malla_asignatura
         inner join aca.malla m on ma.id_malla = m.id_malla
         inner join aca.periodo_academico_oferta pao on pao.id_oferta_modalidad = m.id_oferta_modalidad
         left join aca.periodo_componente_aprendizaje pca
                   on pca.id_periodo_academico_oferta = pao.id_periodo_academico_oferta
                       and pca.id_componente_aprendizaje = ca.id_componente_aprendizaje
WHERE con.id_silabo = 3568
  and con.estado = 'A'
  and ch.estado = 'A'
  and con.id_contenido_padre is null
  and pao.id_periodo_academico = 32
GROUP BY con.id_silabo, con.id_contenidos, con.id_contenido_padre, con.descripcion, con.resultado_aprendizaje, con.orden

select sma.id_silabo, count(sma.id_malla_asignatura)
from aca.silabo_malla_asignatura sma
where sma.estado = 'A'
group by sma.id_silabo
having count(sma.id_malla_asignatura) > 1

select sma.id_silabo_malla_asignatura, pc.*
from aca.plan_clase pc
         inner join aca.contenidos ch on pc.id_contenidos = ch.id_contenidos
         inner join aca.contenidos cp on cp.id_contenidos = ch.id_contenido_padre
         inner join aca.silabo s on cp.id_silabo = s.id_silabo
         inner join aca.silabo_malla_asignatura sma on s.id_silabo = sma.id_silabo
         inner join aca.silabo_periodo_academico spa on s.id_silabo = spa.id_silabo
where pc.estado = 'A'
  and spa.estado = 'A'
  and sma.estado = 'A'
  and spa.id_periodo_academico = pc.id_periodo_academico
--134627 todos
--132.327 activos
--volveer aqui
select p.id_periodo_academico,
       p.id_contenidos,
       97,
       2,
       p.id_silabo_malla_asignatura,
       p.horas_doc,
       p.horas_aea,
       p.horas_nad,
       p.horas_ta,
       p.fecha_clase,
       p.contenido,
       p.resultado_aprendizaje,
       p.recursos_didacticos,
       p.estado,
       p.fecha_ingreso,
       p.usuario_ingreso_id,
       p.version,
       p.fecha_ing,
       p.fecha_mod,
       '0910649185',
       '0910649185'
from aca.plan_clase p
         inner join aca.docente d on p.id_docente = d.id_docente
         inner join man.personas per on d.id_persona = per.id
         inner join aca.contenidos c on p.id_contenidos = c.id_contenidos
         inner join aca.silabo s on c.id_silabo = s.id_silabo
         inner join aca.silabo_malla_asignatura sma on s.id_silabo = sma.id_silabo
         inner join aca.malla_asignatura ma on sma.id_malla_asignatura = ma.id_malla_asignatura
         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where --per.identificacion='1757030174' and
    p.id_periodo_academico = 36
  and ma.id_malla_asignatura = 1945

exec [aca].replicate_plan_clases_to_other_docente 1945, 1, 2, 97, 36, 36, null, '1757030174', 1

select d.*
from [aca].[fn_listar_detalle_silabos_by_oferta_and_periodo](null, null, 30) as d
where d.idSilabo is null
  and (d.idOfertaModalidad in (104) or d.nivel = 1)
order by d.Oferta, d.nivel

--{bcrypt}$2a$10$J0QtsunQxwH4DjwGVuqN/.CXHu3ztgqqU6QWLV1tpFoMdG7FzmOWm
select p.id, p.identificacion, p.apellidos, p.nombres, u.id, u.usuario, u.clave
from man.personas p
         inner join seg.usuarios u on p.id = u.persona_id
where p.identificacion = '2400254286'

--{MD5}674273b898c8d3a040b74709df563761
select --p.id,p.identificacion,p.apellidos,p.nombres,u.id, u.usuario,u.clave
       u.*
from man.personas p
         inner join seg.usuarios u on p.id = u.persona_id
where p.apellidos like '%PROCEL CONTRERAS%'
  and p.nombres like '%DANIEL ALEJANDRO%'


SELECT *
FROM aca.fn_rpt_silabo_contenido_padre(35, 1672, 4161)

SELECT c1.descripcion as contenidoPadre,
       c1.orden       as ordenPadre,
       ca.abreviatura,
       ca.descripcion as componente,
       sum(caa.horas) as horas,
       c1.resultado_aprendizaje
FROM ACA.silabo s
         inner join aca.contenidos c on s.id_silabo = c.id_silabo
         inner join aca.contenidos c1 on c.id_contenido_padre = c1.id_contenidos
         inner join aca.contenido_componente_aprendizaje caa on c.id_contenidos = caa.id_contenidos
         inner join aca.componente_aprendizaje ca on ca.id_componente_aprendizaje = caa.id_componente_aprendizaje
         inner join aca.silabo_malla_asignatura sma on s.id_silabo = sma.id_silabo
         inner join aca.silabo_periodo_academico spa on s.id_silabo = spa.id_silabo
where s.id_silabo = 4161
  and sma.id_malla_asignatura = 1672
  and spa.id_periodo_academico = 35
  and c1.id_contenido_padre is null
  and caa.estado = 'A'
  and s.estado in ('A', 'P')
  and c.estado = 'A'
  and c1.estado = 'A'
group by c1.descripcion, c1.orden, ca.abreviatura, ca.descripcion, c1.resultado_aprendizaje
order by c1.orden, c1.descripcion

select *
from aca.tipo_matricula_fecha


--0942079666

--ver la cabecera del silabos

select *
from [aca].[fn_lista_silabo_asignatura_cab](4065, 35, 1)


select *
from [aca].[fn_lista_silabo_asignatura_cab](1095, 35, 1)

select *
from aca.contenidos
where id_contenidos = 86892

select *
from aca.contenidos
where id_silabo = 4065
  and id_contenido_padre is null

select *
from aca.plan_clase
where id_plan_clase = 159949

select *
from [aca].[fn_lista_docente_asignatura_usu3](36, 13740)

select *
from aca.tipo_estudiante
SELECT STUFF('cadena_original', 1, 1, '') AS resultado;


SELECT *
FROM aca.fn_get_estudiantes_matriculados_direccion(36, null, null, null,
                                                   null, null, null)


select identificacion, direccion
from man.personas
WHERE direccion is not null
  and CHARINDEX('BARRION :', direccion) > 0
  and CHARINDEX('CALLE PRICIPAL :', direccion) > 0
  and CHARINDEX('CALLE SECUNDARIA :', direccion) > 0

SELECT SUBSTRING(direccion, CHARINDEX('BARRION :', direccion) + LEN('BARRION :'),
                 CHARINDEX('CALLE PRICIPAL :', direccion) -
                 (CHARINDEX('BARRION :', direccion) + LEN('BARRION :'))) AS BARRION,

       SUBSTRING(direccion,
                 CHARINDEX('CALLE PRICIPAL :', direccion) + LEN('CALLE PRICIPAL :'),
                 CHARINDEX('CALLE SECUNDARIA :', direccion) -
                 (CHARINDEX('CALLE PRICIPAL :', direccion) + LEN('CALLE PRICIPAL :'))
       )                                                                 AS CALLE_PRINCIPAL,

       SUBSTRING(direccion,
                 CHARINDEX('CALLE SECUNDARIA :', direccion) + LEN('CALLE SECUNDARIA :'),
                 LEN(direccion) - (CHARINDEX('CALLE SECUNDARIA :', direccion) + LEN('CALLE SECUNDARIA :')) + 1
       )                                                                 AS CALLE_SECUNDARIA
FROM man.personas
WHERE direccion is not null
  and CHARINDEX('BARRION :', direccion) > 0
  and CHARINDEX('CALLE PRICIPAL :', direccion) > 0
  and CHARINDEX('CALLE SECUNDARIA :', direccion) > 0

select identificacion, direccion
from man.personas
WHERE CHARINDEX('SOLAR', direccion) > 0
   or CHARINDEX('CASA', direccion) > 0

SELECT direccion, -- Campo original para referencia
       CASE
           WHEN CHARINDEX('SOLAR NUMERO ', direccion) > 0 THEN
               LTRIM(
                       SUBSTRING(
                               direccion,
                               CHARINDEX('SOLAR NUMERO ', direccion) + LEN('SOLAR NUMERO '), LEN('SOLAR NUMERO ')
                       )
               )
           WHEN CHARINDEX('SOLAR.', direccion) > 0 THEN
               LTRIM(
                       SUBSTRING(
                               direccion,
                               CHARINDEX('SOLAR.', direccion) + LEN('SOLAR.'), LEN('SOLAR.')
                       )
               )
           WHEN CHARINDEX('SOLAR:', direccion) > 0 THEN
               LTRIM(
                       SUBSTRING(
                               direccion,
                               CHARINDEX('SOLAR:', direccion) + LEN('SOLAR:'), LEN('SOLAR:')
                       )
               )
           WHEN CHARINDEX('SOLAR', direccion) > 0 THEN
               LTRIM(
                       SUBSTRING(
                               direccion,
                               CHARINDEX('SOLAR', direccion) + LEN('SOLAR'), LEN('SOLAR')
                       )
               )
           WHEN CHARINDEX('CASA', direccion) > 0 THEN
               LTRIM(SUBSTRING(
                       direccion,
                       CHARINDEX('CASA', direccion) + LEN('CASA'),
                       CHARINDEX(' ', direccion + ' ', CHARINDEX('CASA', direccion) + LEN('CASA')) -
                       (CHARINDEX('CASA', direccion) + LEN('CASA'))
                     ))
           ELSE NULL
           END AS NUMERO_DOMICILIO
FROM man.personas
WHERE CHARINDEX('SOLAR', direccion) > 0
   or CHARINDEX('CASA', direccion) > 0

-- update man.personas set
--     numero_domicilio=
--         CASE
--             WHEN CHARINDEX('SOLAR NUMERO ', direccion) > 0 THEN
--                 LTRIM(
--                         SUBSTRING(
--                                 direccion,
--                                 CHARINDEX('SOLAR NUMERO ', direccion) + LEN('SOLAR NUMERO '),LEN('SOLAR NUMERO ')
--                         )
--                 )
--             WHEN CHARINDEX('SOLAR.', direccion) > 0 THEN
--                 LTRIM(
--                         SUBSTRING(
--                                 direccion,
--                                 CHARINDEX('SOLAR.', direccion) + LEN('SOLAR.'),LEN('SOLAR.')
--                         )
--                 )
--             WHEN CHARINDEX('SOLAR:', direccion) > 0 THEN
--                 LTRIM(
--                         SUBSTRING(
--                                 direccion,
--                                 CHARINDEX('SOLAR:', direccion) + LEN('SOLAR:'),LEN('SOLAR:')
--                         )
--                 )
--             WHEN CHARINDEX('SOLAR', direccion) > 0 THEN
--                 LTRIM(
--                         SUBSTRING(
--                                 direccion,
--                                 CHARINDEX('SOLAR', direccion) + LEN('SOLAR'),LEN('SOLAR')
--                         )
--                 )
--             WHEN CHARINDEX('CASA', direccion) > 0 THEN
--                 LTRIM(SUBSTRING(
--                         direccion,
--                         CHARINDEX('CASA', direccion) + LEN('CASA'),
--                         CHARINDEX(' ', direccion + ' ', CHARINDEX('CASA', direccion) + LEN('CASA')) - (CHARINDEX('CASA', direccion) + LEN('CASA'))
--                       ))
--             ELSE NULL
--             END
--  WHERE  CHARINDEX('SOLAR', direccion) >  0 or  CHARINDEX('CASA', direccion) >  0

select identificacion, direccion, numero_domicilio
from man.personas
WHERE CHARINDEX('SOLAR', direccion) > 0
   or CHARINDEX('CASA', direccion) > 0
    AND numero_domicilio <> '' and numero_domicilio is not null


select p.identificacion,
       p.apellidos,
       p.nombres,
       p.id_canton_residencia,
       c.id_lugar,
       CG_CANTON_RESIDE,
       CG_PARROQUIA_RESIDE
-- update p set p.id_canton_residencia = c.id_lugar
from man.personas p
         inner join Bd_Academico..PERSONAS pp on pp.IDENTIFICACION = p.identificacion
         inner join Bd_Personal..TP_CODIGOS cc on cc.CORRELATIVO = pp.CG_CANTON_RESIDE and cc.ID_CLASIFICACION in (28)
         inner join man.lugar c on c.descripcion = cc.VALOR_TEXTO and c.sub_tipo = 2
where p.id_canton_residencia is null
  and pp.CG_CANTON_RESIDE is not null
group by p.identificacion, p.apellidos, p.nombres, p.id_canton_residencia, c.id_lugar, CG_CANTON_RESIDE,
         CG_PARROQUIA_RESIDE

select *
from man.personas

select*
from Bd_Personal..TP_CODIGOS
where ID_CLASIFICACION in (94)
  and CORRELATIVO in (3853)

select *
from man.lugar
where sub_tipo = 3

select*
from Bd_Personal..CLASIFICACIONES_GENERALES
where ID_CLASIFICACION in (94, 28)

select*
from Bd_Personal..CLASIFICACIONES_GENERALES
where DESCRIPCION like '%CANTO%'

select p.identificacion,
       p.apellidos,
       p.nombres,
       p.id_parroquia_residencia,
       par.id_lugar,
       par.descripcion as parroquia,
       can.id_lugar,
       can.descripcion as canton,
       pp.CG_CANTON_RESIDE,
       pp.CG_PARROQUIA_RESIDE,
       parr.VALOR_TEXTO
-- update p set p.id_parroquia_residencia = par.id_lugar
from man.personas p
         inner join Bd_Academico..PERSONAS pp on pp.IDENTIFICACION = p.identificacion
         inner join Bd_Personal..TP_CODIGOS parr
                    on parr.CORRELATIVO = pp.CG_PARROQUIA_RESIDE and parr.ID_CLASIFICACION in (94)
         inner join Bd_Personal..TP_CODIGOS cann
                    on cann.CORRELATIVO = pp.CG_CANTON_RESIDE and cann.ID_CLASIFICACION in (28)
         inner join man.lugar par on par.descripcion = parr.VALOR_TEXTO and par.sub_tipo = 3
         inner join man.lugar can
                    on can.id_lugar = par.id_lugar_padre and can.sub_tipo = 2 and can.descripcion = cann.VALOR_TEXTO
where p.id_parroquia_residencia is null
  and pp.CG_PARROQUIA_RESIDE is not null
group by p.identificacion, p.apellidos, p.nombres, p.id_parroquia_residencia, par.id_lugar, par.descripcion,
         can.id_lugar, can.descripcion,
         pp.CG_CANTON_RESIDE, pp.CG_PARROQUIA_RESIDE, parr.VALOR_TEXTO

select *
from man.PERSONAs
where APELLIDOS like '%ALVAREZ%'
  and NOMBRES like '%PETER JOHANY%'

select id,
       identificacion,
       apellidos,
       nombres,
       barrio,
       ciudad,
       direccion,
       id_canton_residencia,
       id_canton_nacionalidad,
       id_parroquia_residencia,
       id_parroquia_nacionalidad
from man.personas
where identificacion in ('1850496462')


select c.*
from man.lugar c
         inner join man.lugar p on p.id_lugar = c.id_lugar_padre
where c.id_lugar_padre = 270
   or (c.descripcion like '%playas%' and c.sub_tipo = 2)
   or (c.descripcion like '%Puerto Lopez%' and c.sub_tipo = 2)
   or (c.descripcion like '%La concordia%' and c.sub_tipo = 2)

select p.identificacion, p.apellidos, p.nombres, p.telefono, pp.TELEFONO
-- update p set p.telefono = concat('0',pp.TELEFONO)
from man.personas p
         inner join Bd_Academico..PERSONAS pp on pp.IDENTIFICACION = p.identificacion
where p.telefono is null --and len(pp.TELEFONO)=8 --and pp.TELEFONO like '4%'
group by p.identificacion, p.apellidos, p.nombres, p.telefono, pp.TELEFONO

select u.*
from man.personas p
         inner join seg.usuarios u on p.id = u.persona_id
where p.apellidos like '%MORA SOLORZANO%'
  and p.nombres like '%SHIRLEY JANETH%'

select ru.*
from man.personas p
         inner join seg.usuarios u on p.id = u.persona_id
         inner join seg.roles_usuarios ru on u.id = ru.usuario_id
where p.identificacion = '0911015899'

--  DBCC CHECKIDENT ('aca.silabo_bibliografia', RESEED, 14105);
select *
from aca.documento_silabo


select *
from aca.silabo_bibliografia_no_catalogada
where tipo = 'Otros'

select a.descripcion, ma.id_nivel
from aca.silabo_malla_asignatura sma
         inner join aca.malla_asignatura ma on sma.id_malla_asignatura = ma.id_malla_asignatura
         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where sma.id_silabo = 5821

BEGIN
    SELECT *
    FROM aca.silabo_bibliografia_no_catalogada
    WHERE tipo <> 'Otros'
END

SELECT *
FROM aca.silabo_bibliografia_no_catalogada
WHERE tipo = 'Otros'

BEGIN
    SELECT *
    FROM aca.silabo_bibliografia_no_catalogada
END

SELECT *
FROM aca.silabo_bibliografia_no_catalogada
WHERE tipo = ''

select *
from aca.periodo_academico
where id_tipo_oferta = 1

-- insert into aca.periodo_componente_aprendizaje
select pao2.id_periodo_academico_oferta,
       pca.id_componente_aprendizaje,
       pca.valor,
       pca.estado,
       0,
       getdate(),
       getdate(),
       pca.usuario_ing,
       pca.usuario_mod
from aca.periodo_componente_aprendizaje pca
         inner join aca.periodo_academico_oferta pao
                    on pao.id_periodo_academico_oferta = pca.id_periodo_academico_oferta
         left join aca.periodo_academico_oferta pao2
                   on pao2.id_oferta_modalidad = pao.id_oferta_modalidad and pao2.id_periodo_academico = 138
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
where pao.id_periodo_academico = 139 and pca.estado='A' and pao2.id_periodo_academico_oferta is not null

select *
from aca.periodo_academico_oferta pao2
where pao2.id_periodo_academico = 126


select *
from aca.silabo_bibliografia
where id_silabo = 5815

--  DBCC CHECKIDENT ('aca.silabo_bibliografia_no_catalogada', RESEED, 17780);
select *
from aca.silabo_bibliografia_no_catalogada
where id_silabo = 5732

select *
from aca.documento_silabo
where id_silabo = 5821

select *
from aca.tipo_documento

select *
from aca.silabo_estrategia

select *
from aca.recursos_didacticos

select distinct recursos_didacticos, count(id_plan_clase) as usos
from aca.plan_clase
group by recursos_didacticos

select distinct recursos_didacticos, count(id_plan_clase) as usos
from aca.plan_clase
where recursos_didacticos like '%cam%'
group by recursos_didacticos

select *
from aca.silabo
where id_silabo = 5483

select *
from aca.silabo_malla_asignatura
where id_silabo = 5483

select *
from aca.contenidos
where id_silabo = 5483

select d.*
from [aca].[fn_silabo](537, 31) as d

select *
from [aca].[fn_lista_silabo_asignatura_cab](4653, 31, 1)
ORDER BY orden

select *
from aca.[fn_list_componentes_plan_clases](36, 113105, 2045, 227623, 2)


begin
    declare @pi_id_plan_clase int = 227623,@pi_id_paralelo int = 2,@pi_id_contenido int = 113105,@pi_id_silabos_malla_asignatura int = 2045,@pi_id_periodo_academico int = 36
    select cca.horas,
           aux.horas,
           cca.id_contenido_componente_aprendizaje,
           cap.id_componente_aprendizaje                         as idCompAprendizajePadre,
           cap.abreviatura                                       as abreviaturaPadre,
           cap.codigo                                            as codigoPadre,
           cap.descripcion                                       as componentePadre,
           ca.id_componente_aprendizaje                          as idCompAprendizajeHijo,
           ca.abreviatura                                        as abreviaturaHijo,
           ca.codigo                                             as codigoHijo,
           ca.descripcion                                        as componenteHijo,
           isnull(cca.horas, 0)                                  as horasTotales,
           (isnull(cca.horas, 0) - isnull(aux.horas, 0))         as horasDisponibles,
           isnull((select pc1.horas
                   from aca.plan_componente_aprendizaje pc1
                            inner join aca.plan_clase p1 on p1.id_plan_clase = pc1.id_plan_clase
                   where pc1.id_plan_clase = @pi_id_plan_clase
                     and pc1.estado = 'A'
                     and pc1.id_componente_aprendizaje = ca.id_componente_aprendizaje
                     and p1.id_paralelo = (@pi_id_paralelo)), 0) as horas,
           (select pc1.id_plan_componente_aprendizaje
            from aca.plan_componente_aprendizaje pc1
                     inner join aca.plan_clase p1 on p1.id_plan_clase = pc1.id_plan_clase
            where pc1.id_plan_clase = @pi_id_plan_clase
              and pc1.estado = 'A'
              and pc1.id_componente_aprendizaje = ca.id_componente_aprendizaje
              and p1.id_paralelo = (@pi_id_paralelo))            as idPlanComponenteAprendizaje
    from aca.silabo s
             inner join aca.contenidos c on c.id_silabo = s.id_silabo
             inner join aca.contenido_componente_aprendizaje cca on cca.id_contenidos = c.id_contenidos
             inner join aca.silabo_periodo_academico spa on spa.id_silabo = s.id_silabo
             inner join aca.silabo_malla_asignatura sma on sma.id_silabo = s.id_silabo
             inner join aca.componente_aprendizaje ca on (ca.id_componente_aprendizaje = cca.id_componente_aprendizaje)
             inner join aca.componente_aprendizaje cap on cap.id_componente_aprendizaje = (case
                                                                                               when
                                                                                                   ca.id_componente_aprendizaje_padre =
                                                                                                   (select ca.id_componente_aprendizaje
                                                                                                    from aca.componente_aprendizaje ca
                                                                                                    where ca.estado = 'A'
                                                                                                      and ca.codigo = 'FORMATIVA'
                                                                                                      and ca.estado = 'A')
                                                                                                   then
                                                                                                   ca.id_componente_aprendizaje
                                                                                               else ca.id_componente_aprendizaje_padre end)
             left join (select pc.id_contenidos, pca.id_componente_aprendizaje, pc.id_paralelo, sum(pca.horas) as horas
                        from aca.plan_clase pc
                                 inner join aca.plan_componente_aprendizaje pca on pca.id_plan_clase = pc.id_plan_clase
                        where pc.estado = 'A'
                          and pc.id_periodo_academico = (@pi_id_periodo_academico)
                          and pc.id_paralelo = (@pi_id_paralelo)
                          and pc.id_plan_clase not in (@pi_id_plan_clase)
                          and pca.estado = 'A'
                        group by pc.id_contenidos, pca.id_componente_aprendizaje, pc.id_paralelo) as aux
                       on aux.id_contenidos = c.id_contenidos
                           and aux.id_componente_aprendizaje = ca.id_componente_aprendizaje

    where ca.estado = 'A'
      and cap.estado = 'A'
      and s.estado in ('A', 'P')
      and c.estado = 'A'
      and spa.estado = 'A'
      and c.id_contenidos = (@pi_id_contenido)
      and sma.id_malla_asignatura = (@pi_id_silabos_malla_asignatura)
    group by cca.id_contenido_componente_aprendizaje, cap.id_componente_aprendizaje, cap.abreviatura, cap.codigo,
             cap.descripcion,
             ca.id_componente_aprendizaje, ca.abreviatura, ca.codigo, ca.descripcion, cca.horas, cap.orden, ca.orden,
             aux.horas --, pca.id_componente_aprendizaje--, pc.id_plan_clase
    order by cap.orden asc, ca.orden asc
end

SELECT c1.descripcion as contenidoPadre,
       c1.orden       as ordenPadre,
       ca.abreviatura,
       ca.descripcion as componente,
       sum(caa.horas) as horas,
       c1.resultado_aprendizaje
FROM ACA.silabo s
         inner join aca.contenidos c on s.id_silabo = c.id_silabo
         inner join aca.contenidos c1 on c.id_contenido_padre = c1.id_contenidos
         inner join aca.contenido_componente_aprendizaje caa on c.id_contenidos = caa.id_contenidos
         inner join aca.componente_aprendizaje ca on ca.id_componente_aprendizaje = caa.id_componente_aprendizaje
         inner join aca.silabo_malla_asignatura sma on s.id_silabo = sma.id_silabo
         inner join aca.silabo_periodo_academico spa on s.id_silabo = spa.id_silabo
where s.id_silabo = 4161
  and sma.id_malla_asignatura = 1672
  and spa.id_periodo_academico = 35
  and c1.id_contenido_padre is null
  and caa.estado = 'A'
  and s.estado in ('A', 'P')
  and c.estado = 'A'
  and c1.estado = 'A'
group by c1.descripcion, c1.orden, ca.abreviatura, ca.descripcion, c1.resultado_aprendizaje
order by c1.orden, c1.descripcion

select *
from aca.[fn_list_componentes_plan_clases](36, 115461, 1754, 223647, 1)
begin
    declare @pi_id_plan_clase int = 223647,@pi_id_paralelo int = 1,@pi_id_contenido int = 115461,@pi_id_silabos_malla_asignatura int = 1754,@pi_id_periodo_academico int = 36
    select pca.*--pc.id_contenidos,pca.id_componente_aprendizaje,pc.id_paralelo,sum(pca.horas)as horas
    from aca.plan_clase pc
             inner join aca.plan_componente_aprendizaje pca on pca.id_plan_clase = pc.id_plan_clase
    where pc.estado = 'A'
      and pca.estado = 'A'
      and pc.id_periodo_academico = (@pi_id_periodo_academico)
      and pc.id_paralelo = (@pi_id_paralelo)
      and pc.id_plan_clase not in (@pi_id_plan_clase)
      and pc.id_contenidos = @pi_id_contenido
      and pca.id_componente_aprendizaje = 2

    select *
    from aca.plan_componente_aprendizaje pc
             inner join (select pca.id_componente_aprendizaje,
                                pca.id_plan_clase,
                                pca.horas,
                                pca.estado,
                                count(pca.id_plan_componente_aprendizaje) as repetidos
                         from aca.plan_clase pc
                                  inner join aca.plan_componente_aprendizaje pca on pca.id_plan_clase = pc.id_plan_clase
                         group by pca.id_componente_aprendizaje, pca.id_plan_clase, pca.estado, pca.horas
                         having count(pca.id_plan_componente_aprendizaje) > 1) as aux
                        on aux.id_plan_clase = pc.id_plan_clase and
                           aux.id_componente_aprendizaje = pc.id_componente_aprendizaje

---ver todos menos los minimos
    select pc1.*
    from aca.plan_componente_aprendizaje pc1
             inner join (select pca.id_componente_aprendizaje,
                                pca.id_plan_clase,
                                pca.horas,
                                pca.estado,
                                count(pca.id_plan_componente_aprendizaje) as repetidos
                         from aca.plan_clase pc
                                  inner join aca.plan_componente_aprendizaje pca on pca.id_plan_clase = pc.id_plan_clase
                         group by pca.id_componente_aprendizaje, pca.id_plan_clase, pca.estado, pca.horas
                         having count(pca.id_plan_componente_aprendizaje) > 1) as aux
                        on aux.id_plan_clase = pc1.id_plan_clase and
                           aux.id_componente_aprendizaje = pc1.id_componente_aprendizaje
    where pc1.id_plan_componente_aprendizaje not in (select d.id_plan_componente_aprendizaje_min
                                                     from (select pc.id_componente_aprendizaje,
                                                                  pc.id_plan_clase,
                                                                  pc.horas,
                                                                  pc.estado,
                                                                  min(pc.id_plan_componente_aprendizaje) as id_plan_componente_aprendizaje_min
                                                           from aca.plan_componente_aprendizaje pc
                                                                    inner join (select pca.id_componente_aprendizaje,
                                                                                       pca.id_plan_clase,
                                                                                       pca.horas,
                                                                                       pca.estado,
                                                                                       count(pca.id_plan_componente_aprendizaje) as repetidos
                                                                                from aca.plan_clase pc
                                                                                         inner join aca.plan_componente_aprendizaje pca
                                                                                                    on pca.id_plan_clase = pc.id_plan_clase

                                                                                group by pca.id_componente_aprendizaje,
                                                                                         pca.id_plan_clase, pca.estado,
                                                                                         pca.horas
                                                                                having count(pca.id_plan_componente_aprendizaje) > 1) as aux
                                                                               on aux.id_plan_clase =
                                                                                  pc.id_plan_clase and
                                                                                  aux.id_componente_aprendizaje =
                                                                                  pc.id_componente_aprendizaje
                                                           group by pc.id_componente_aprendizaje, pc.id_plan_clase,
                                                                    pc.horas, pc.estado) as d)

    ---ver los minimos
    select pc.id_componente_aprendizaje,
           pc.id_plan_clase,
           pc.horas,
           pc.estado,
           min(pc.id_plan_componente_aprendizaje)
    from aca.plan_componente_aprendizaje pc
             inner join (select pca.id_componente_aprendizaje,
                                pca.id_plan_clase,
                                pca.horas,
                                pca.estado,
                                count(pca.id_plan_componente_aprendizaje) as repetidos
                         from aca.plan_clase pc
                                  inner join aca.plan_componente_aprendizaje pca on pca.id_plan_clase = pc.id_plan_clase

                         group by pca.id_componente_aprendizaje, pca.id_plan_clase, pca.estado, pca.horas
                         having count(pca.id_plan_componente_aprendizaje) > 1) as aux
                        on aux.id_plan_clase = pc.id_plan_clase and
                           aux.id_componente_aprendizaje = pc.id_componente_aprendizaje
    group by pc.id_componente_aprendizaje, pc.id_plan_clase, pc.horas, pc.estado

    select * from aca.plan_componente_aprendizaje where id_plan_clase = 223937

    --ver los repetidos
    select pca.id_componente_aprendizaje,
           pca.id_plan_clase,
           pca.horas,
           pca.estado,
           count(pca.id_plan_componente_aprendizaje)
    from aca.plan_clase pc
             inner join aca.plan_componente_aprendizaje pca on pca.id_plan_clase = pc.id_plan_clase
    group by pca.id_componente_aprendizaje, pca.id_plan_clase, pca.estado, pca.horas
    having count(pca.id_plan_componente_aprendizaje) > 1

    --     group by pc.id_contenidos,pca.id_componente_aprendizaje,pc.id_paralelo
--
    select d.* from [aca].[fn_silabo](2487, 30) as d

    select c.id_contenidos,
           ca.id_componente_aprendizaje,
           cca.horas,
           aux.horas,
           cca.id_contenido_componente_aprendizaje,
           cap.id_componente_aprendizaje                         as idCompAprendizajePadre,
           cap.abreviatura                                       as abreviaturaPadre,
           cap.codigo                                            as codigoPadre,
           cap.descripcion                                       as componentePadre,
           ca.id_componente_aprendizaje                          as idCompAprendizajeHijo,
           ca.abreviatura                                        as abreviaturaHijo,
           ca.codigo                                             as codigoHijo,
           ca.descripcion                                        as componenteHijo,
           isnull(cca.horas, 0)                                  as horasTotales,
           (isnull(cca.horas, 0) - isnull(aux.horas, 0))         as horasDisponibles,
           isnull((select pc1.horas
                   from aca.plan_componente_aprendizaje pc1
                            inner join aca.plan_clase p1 on p1.id_plan_clase = pc1.id_plan_clase
                   where pc1.id_plan_clase = @pi_id_plan_clase
                     and pc1.estado = 'A'
                     and pc1.id_componente_aprendizaje = ca.id_componente_aprendizaje
                     and p1.id_paralelo = (@pi_id_paralelo)), 0) as horas,
           (select pc1.id_plan_componente_aprendizaje
            from aca.plan_componente_aprendizaje pc1
                     inner join aca.plan_clase p1 on p1.id_plan_clase = pc1.id_plan_clase
            where pc1.id_plan_clase = @pi_id_plan_clase
              and pc1.estado = 'A'
e              and pc1.id_componente_aprendizaje = ca.id_componente_aprendizaje
              and p1.id_paralelo = (@pi_id_paralelo))            as idPlanComponenteAprendizaje
    from aca.silabo s
             inner join aca.contenidos c on c.id_silabo = s.id_silabo
             inner join aca.contenido_componente_aprendizaje cca on cca.id_contenidos = c.id_contenidos
             inner join aca.silabo_periodo_academico spa on spa.id_silabo = s.id_silabo
             inner join aca.silabo_malla_asignatura sma on sma.id_silabo = s.id_silabo
             inner join aca.componente_aprendizaje ca on (ca.id_componente_aprendizaje = cca.id_componente_aprendizaje)
             inner join aca.componente_aprendizaje cap on cap.id_componente_aprendizaje = (case
                                                                                               when
                                                                                                   ca.id_componente_aprendizaje_padre =
                                                                                                   (select ca.id_componente_aprendizaje
                                                                                                    from aca.componente_aprendizaje ca
                                                                                                    where ca.estado = 'A'
                                                                                                      and ca.codigo = 'FORMATIVA'
                                                                                                      and ca.estado = 'A')
                                                                                                   then
                                                                                                   ca.id_componente_aprendizaje
                                                                                               else ca.id_componente_aprendizaje_padre end)
             left join (select pc.id_contenidos, pca.id_componente_aprendizaje, pc.id_paralelo, sum(pca.horas) as horas
                        from aca.plan_clase pc
                                 inner join aca.plan_componente_aprendizaje pca on pca.id_plan_clase = pc.id_plan_clase
                        where pc.estado = 'A'
                          and pca.estado = 'A'
                          and pc.id_periodo_academico = (@pi_id_periodo_academico)
                          and pc.id_paralelo = (@pi_id_paralelo)
                          and pc.id_plan_clase not in (@pi_id_plan_clase)

                        group by pc.id_contenidos, pca.id_componente_aprendizaje, pc.id_paralelo) as aux
                       on aux.id_contenidos = c.id_contenidos
                           and aux.id_componente_aprendizaje = ca.id_componente_aprendizaje

    where ca.estado = 'A'
      and cap.estado = 'A'
      and s.estado in ('A', 'P')
      and c.estado = 'A'
      and spa.estado = 'A'
      and c.id_contenidos = (@pi_id_contenido)
      and sma.id_malla_asignatura = (@pi_id_silabos_malla_asignatura)
    group by cca.id_contenido_componente_aprendizaje, cap.id_componente_aprendizaje, cap.abreviatura, cap.codigo,
             cap.descripcion,
             ca.id_componente_aprendizaje, ca.abreviatura, ca.codigo, ca.descripcion, cca.horas, cap.orden, ca.orden,
             aux.horas, c.id_contenidos --, pca.id_componente_aprendizaje--, pc.id_plan_clase
    order by cap.orden asc, ca.orden asc
end


---ver todos menos los minimos de bibliografia
select pc1.*
from aca.plan_bibliografia pc1
         inner join (select pca.id_silabo_bibliografia,
                            pca.id_plan_clase,
                            pca.pag_desde,
                            pca.pag_hasta,
                            pca.estado,
                            count(pca.id_plan_bibliografia) as repetidos
                     from aca.plan_clase pc
                              inner join aca.plan_bibliografia pca on pca.id_plan_clase = pc.id_plan_clase
                     where pca.estado = 'A'
                     group by pca.id_silabo_bibliografia, pca.id_plan_clase, pca.estado, pca.pag_desde, pca.pag_hasta
                     having count(pca.id_plan_bibliografia) > 1) as aux
                    on aux.id_plan_clase = pc1.id_plan_clase and aux.id_silabo_bibliografia = pc1.id_silabo_bibliografia
where pc1.id_plan_bibliografia not in (select d.id_plan_bibliografia_min
                                       from (select pc.id_silabo_bibliografia,
                                                    pc.id_plan_clase,
                                                    pc.pag_desde,
                                                    pc.pag_hasta,
                                                    pc.estado,
                                                    min(pc.id_plan_bibliografia) as id_plan_bibliografia_min
                                             from aca.plan_bibliografia pc
                                                      inner join (select pca.id_silabo_bibliografia,
                                                                         pca.id_plan_clase,
                                                                         pca.pag_desde,
                                                                         pca.pag_hasta,
                                                                         pca.estado,
                                                                         count(pca.id_plan_bibliografia) as repetidos
                                                                  from aca.plan_clase pc
                                                                           inner join aca.plan_bibliografia pca on pca.id_plan_clase = pc.id_plan_clase
                                                                  where pca.estado = 'A'
                                                                  group by pca.id_silabo_bibliografia,
                                                                           pca.id_plan_clase, pca.estado, pca.pag_desde,
                                                                           pca.pag_hasta
                                                                  having count(pca.id_plan_bibliografia) > 1) as aux
                                                                 on aux.id_plan_clase = pc.id_plan_clase and
                                                                    aux.id_silabo_bibliografia =
                                                                    pc.id_silabo_bibliografia
                                             group by pc.id_silabo_bibliografia, pc.id_plan_clase, pc.estado,
                                                      pc.pag_desde, pc.pag_hasta) as d)

select pca.id_silabo_bibliografia,
       pca.id_plan_clase,
       pca.pag_desde,
       pca.pag_hasta,
       pca.estado,
       count(pca.id_plan_bibliografia) as repetidos
from aca.plan_clase pc
         inner join aca.plan_bibliografia pca on pca.id_plan_clase = pc.id_plan_clase
where pca.estado = 'A'
group by pca.id_silabo_bibliografia, pca.id_plan_clase, pca.estado, pca.pag_desde, pca.pag_hasta
having count(pca.id_plan_bibliografia) > 1

--     221498
select pc.id_silabo_bibliografia,
       pc.id_plan_clase,
       pc.pag_desde,
       pc.pag_hasta,
       pc.estado,
       min(pc.id_plan_bibliografia) as id_plan_bibliografia_min
from aca.plan_bibliografia pc
         inner join (select pca.id_silabo_bibliografia,
                            pca.id_plan_clase,
                            pca.pag_desde,
                            pca.pag_hasta,
                            pca.estado,
                            count(pca.id_plan_bibliografia) as repetidos
                     from aca.plan_clase pc
                              inner join aca.plan_bibliografia pca on pca.id_plan_clase = pc.id_plan_clase
                     where pca.estado = 'A'
                     group by pca.id_silabo_bibliografia, pca.id_plan_clase, pca.estado, pca.pag_desde, pca.pag_hasta
                     having count(pca.id_plan_bibliografia) > 1) as aux
                    on aux.id_plan_clase = pc.id_plan_clase and aux.id_silabo_bibliografia = pc.id_silabo_bibliografia
group by pc.id_silabo_bibliografia, pc.id_plan_clase, pc.estado, pc.pag_desde, pc.pag_hasta

select *
from aca.plan_bibliografia
where id_plan_clase = 2651

---ver todos menos los minimos de bibliografia no catalogada
select pc1.*
from aca.plan_bibliografia_no_catalogada pc1
         inner join (select pca.id_silabo_bibliografia_no_catalogada,
                            pca.id_plan_clase,
                            pca.pag_desde,
                            pca.pag_hasta,
                            pca.estado,
                            count(pca.id_plan_bibliografia_no_catalogada) as repetidos
                     from aca.plan_clase pc
                              inner join aca.plan_bibliografia_no_catalogada pca on pca.id_plan_clase = pc.id_plan_clase
                     where pca.estado = 'A'
                     group by pca.id_silabo_bibliografia_no_catalogada, pca.id_plan_clase, pca.estado, pca.pag_desde,
                              pca.pag_hasta
                     having count(pca.id_plan_bibliografia_no_catalogada) > 1) as aux
                    on aux.id_plan_clase = pc1.id_plan_clase and
                       aux.id_silabo_bibliografia_no_catalogada = pc1.id_silabo_bibliografia_no_catalogada
where pc1.id_plan_bibliografia_no_catalogada not in (select d.id_plan_bibliografia_no_cata_min
                                                     from (select pc.id_silabo_bibliografia_no_catalogada,
                                                                  pc.id_plan_clase,
                                                                  pc.pag_desde,
                                                                  pc.pag_hasta,
                                                                  pc.estado,
                                                                  min(pc.id_plan_bibliografia_no_catalogada) as id_plan_bibliografia_no_cata_min
                                                           from aca.plan_bibliografia_no_catalogada pc
                                                                    inner join (select pca.id_silabo_bibliografia_no_catalogada,
                                                                                       pca.id_plan_clase,
                                                                                       pca.pag_desde,
                                                                                       pca.pag_hasta,
                                                                                       pca.estado,
                                                                                       count(pca.id_plan_bibliografia_no_catalogada) as repetidos
                                                                                from aca.plan_clase pc
                                                                                         inner join aca.plan_bibliografia_no_catalogada pca
                                                                                                    on pca.id_plan_clase = pc.id_plan_clase
                                                                                where pca.estado = 'A'
                                                                                group by pca.id_silabo_bibliografia_no_catalogada,
                                                                                         pca.id_plan_clase, pca.estado,
                                                                                         pca.pag_desde, pca.pag_hasta
                                                                                having count(pca.id_plan_bibliografia_no_catalogada) > 1) as aux
                                                                               on aux.id_plan_clase =
                                                                                  pc.id_plan_clase and
                                                                                  aux.id_silabo_bibliografia_no_catalogada =
                                                                                  pc.id_silabo_bibliografia_no_catalogada
                                                           group by pc.id_silabo_bibliografia_no_catalogada,
                                                                    pc.id_plan_clase, pc.estado, pc.pag_desde,
                                                                    pc.pag_hasta) as d)

select pca.id_silabo_bibliografia_no_catalogada,
       pca.id_plan_clase,
       pca.pag_desde,
       pca.pag_hasta,
       pca.estado,
       count(pca.id_plan_bibliografia_no_catalogada) as repetidos
from aca.plan_clase pc
         inner join aca.plan_bibliografia_no_catalogada pca on pca.id_plan_clase = pc.id_plan_clase
where pca.estado = 'A'
group by pca.id_silabo_bibliografia_no_catalogada, pca.id_plan_clase, pca.estado, pca.pag_desde, pca.pag_hasta
having count(pca.id_plan_bibliografia_no_catalogada) > 1


select pca.id_recurso_didactico, pca.id_plan_clase, pca.estado, count(pca.id_plan_recurso_didactico) as repetidos
from aca.plan_clase pc
         inner join aca.plan_recurso_didactico pca on pca.id_plan_clase = pc.id_plan_clase
where pca.estado = 'A'
group by pca.id_recurso_didactico, pca.id_plan_clase, pca.estado
having count(pca.id_plan_recurso_didactico) > 1

select pca.id_estrategia_evaluacion, pca.id_plan_clase, pca.estado, count(pca.id_plan_estrategia) as repetidos
from aca.plan_clase pc
         inner join aca.plan_estrategia pca on pca.id_plan_clase = pc.id_plan_clase
where pca.estado = 'A'
group by pca.id_estrategia_evaluacion, pca.id_plan_clase, pca.estado
having count(pca.id_plan_estrategia) > 1

select pca.id_metodologia_ensenanza, pca.id_plan_clase, pca.estado, count(pca.id_plan_metodologia) as repetidos
from aca.plan_clase pc
         inner join aca.plan_metodologia pca on pca.id_plan_clase = pc.id_plan_clase
where pca.estado = 'A'
group by pca.id_metodologia_ensenanza, pca.id_plan_clase, pca.estado
having count(pca.id_plan_metodologia) > 1
select *
from aca.plan_componente_aprendizaje
where id_plan_componente_aprendizaje = 622390

SELECT *
FROM [aca].[fn_get_info_silabo_ingles](1095, 36, null)


--quitar horas extras nivelacion silabos
select d.id,
       d.nombre,
       o.descripcion,
       om.id_oferta_modalidad,
       pac.*
from aca.periodo_componente_aprendizaje pac
         inner join aca.periodo_academico_oferta pao
                    on pac.id_periodo_academico_oferta = pao.id_periodo_academico_oferta
         inner join aca.oferta_modalidad om on pao.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.departamento_oferta do on o.id_oferta = do.id_oferta
         inner join man.departamentos d on do.id_departamento = d.id
where pac.estado = 'A'
  and pao.estado = 'A'
  and pao.id_periodo_academico = 37
  and d.id not in (5, 11, 10)

select *
from [aca].[fn_get_proyectos_por_periodo_oferta](36, 31, null)

exec aca.replica_silabo_masivo_2025_2

select om.id_oferta_modalidad,om.carrera,s.id_silabo,s.descripcion as silabo,concat(ma.id_nivel,' - ',a.descripcion) as silabos,ara.descripcion as resultado_aprendizaje,
       sc.componente_padre as categoria_componente,sc.nombre as componente_silabo,sci.nombre items,isnull(ia.nombre,'NO USO IA') as IA
from aca.silabo s
inner join aca.silabo_periodo_academico spa on spa.id_silabo = s.id_silabo
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = s.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.ofertas_facultad om on om.id_oferta_modalidad = m.id_oferta_modalidad
inner join aca.asignatura_resultado_aprendizaje ara on ma.id_malla_asignatura = ara.id_malla_asignatura
inner join aca.resultado_aprendizaje_item_relacion rair on ara.id_asignatura_resultado_aprendizaje = rair.id_asignatura_resultado_aprendizaje and s.id_silabo = rair.id_silabo
inner join aca.silabo_componente_item sci on rair.id_silabo_componente_item = sci.id_silabo_componente_item
inner join aca.silabo_componente sc on sci.id_silabo_componente = sc.id_silabo_componente
left join aca.resultado_aprendizaje_inteligencia_artificial raia on ara.id_asignatura_resultado_aprendizaje = raia.id_asignatura_resultado_aprendizaje and s.id_silabo = raia.id_silabo
left join aca.inteligencia_artificial ia on raia.id_inteligencia_artificial = ia.id_inteligencia_artificial
where s.estado in ('A', 'P')
  and spa.estado = 'A' and spa.id_periodo_academico = 96 and om.id_oferta_modalidad in (134,38)
order by om.carrera,ma.id_nivel,a.descripcion

select * from aca.silabo_categoria_componente
select * from aca.silabo_componente

select * from aca.silabo_funciones_sustantivas

--bibliografias
select om.id_oferta_modalidad,om.carrera,s.id_silabo,s.descripcion as silabo,concat(ma.id_nivel,' - ',a.descripcion) as silabos,
    isnull(rb.titulo,'NO REGISTRA') as bibliografia_catalogada, isnull(cast(rb.anio_edicion as varchar(15)),'NO REGISTRA') as anio_bibliografia_catalogada,isnull(sbnc.descripcion,'NO REGISTRA') as bibliografia_no_catalogada,
    isnull(cast(sbnc.anio as varchar(15)),'NO REGISTRA') anio_bibliografia_no_catalogada

from aca.silabo s
         inner join aca.silabo_periodo_academico spa on spa.id_silabo = s.id_silabo
         inner join aca.malla_asignatura ma on ma.id_malla_asignatura = s.id_malla_asignatura
         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
         inner join aca.malla m on ma.id_malla = m.id_malla
         inner join aca.ofertas_facultad om on om.id_oferta_modalidad = m.id_oferta_modalidad
left join aca.silabo_bibliografia sb on s.id_silabo = sb.id_silabo
left join aca.recurso_bibliografico rb on sb.id_recurso_bibliografico = rb.id_recurso_bibliografico
left join aca.silabo_bibliografia_no_catalogada sbnc  on s.id_silabo = sbnc.id_silabo
where s.estado in ('A', 'P')
  and spa.estado = 'A' and spa.id_periodo_academico = 96 and om.id_oferta_modalidad in (134,38)
order by om.carrera,ma.id_nivel,a.descripcion


select DISTINCT  a.id_asignatura as idAsignatura,a.descripcion as nombreAsignatura,ma.num_horas as numHoras, ma.num_creditos as creditos,
                 n.descripcion as descripcionNivel,n.orden as ordenNivel,ma.id_malla_asignatura as idMallaAsignatura,
                 co.descripcion as componenteOrganizacion,ca.id_componente_aprendizaje idComponenteAprendizaje, ca.codigo  ,ca.descripcion as componenteAprendizaje,ca.abreviatura,
                 coalesce(aa.valor * iif(pa.codigo_tipo_periodo='PAEXT',16,pa.numero_semanas),0)- coalesce(ISNULL(pca.valor,0) * pa.numero_semanas,0) as valor,
                 coalesce((select sum(cca1.horas) f
                           from aca.silabo s1

                                    inner join aca.silabo_periodo_academico spa on spa.id_silabo = s1.id_silabo
                                    inner join aca.contenidos c1 on s1.id_silabo=c1.id_silabo
                                    inner join aca.contenido_componente_aprendizaje cca1 on c1.id_contenidos=cca1.id_contenidos
                           where s1.estado in ('A','P') and c1.estado='A' and c1.id_contenido_padre is not null
                             and s1.id_malla_asignatura=ma.id_malla_asignatura and cca1.estado='A'  and spa.estado='A'
                             and cca1.id_componente_aprendizaje= ca.id_componente_aprendizaje and spa.id_periodo_academico = 136), 0) as horasAsignadas,
                 ( (select aca.fn_silabo_componente_horas_sincrona (136, m.id_reglamento, ma.id_malla_asignatura))
                     *iif(pa.codigo_tipo_periodo='PAEXT',16,pa.numero_semanas)) horasSincrona
        , (  SELECT
                 ar.*, r.descripcion
             FROM aca.asignatura_requisito ar
                      inner join aca.requisito r on ar.id_requisito=r.id_requisito
             WHERE ar.estado='A' and  ar.id_malla_asignatura=ma.id_malla_asignatura
             FOR JSON PATH
                 ) AS asignaturaRequisito, m.id_oferta_modalidad
from aca.asignatura a
         inner JOIN aca.malla_asignatura ma on ma.id_asignatura=a.id_asignatura
         LEFT join  aca.asignatura_organizacion ao on ao.id_malla_asignatura = ma.id_malla_asignatura
         LEFT join aca.componente_organizacion co on ao.id_comp_organizacion = co.id_componente_organizacion
         LEFT join aca.tipo_comp_organizacion tco on co.id_tipo_comp_organizacion = tco.id_tipo_comp_organizacion and tco.abreviatura='UOC'
         inner JOIN aca.nivel n on ma.id_nivel = n.id_nivel
         inner JOIN aca.malla m on ma.id_malla = m.id_malla
         inner JOIN aca.reglamento r on m.id_reglamento=r.id_reglamento
         inner JOIN aca.periodo_malla pm on pm.id_malla = m.id_malla
         inner JOIN aca.periodo_academico pa on pm.id_periodo_academico = pa.id_periodo_academico
         inner join aca.asignatura_aprendizaje aa on ma.id_malla_asignatura=aa.id_malla_asignatura
         inner join aca.componente_aprendizaje ca on aa.id_componente_aprendizaje=ca.id_componente_aprendizaje
         inner join aca.periodo_academico_oferta pao on pa.id_periodo_academico = pao.id_periodo_academico and pao.id_oferta_modalidad = m.id_oferta_modalidad
         left join aca.periodo_componente_aprendizaje pca on pca.id_periodo_academico_oferta = pao.id_periodo_academico_oferta
    and pca.id_componente_aprendizaje = ca.id_componente_aprendizaje and pca.estado='A'
WHERE ma.id_malla_asignatura = 2789
  and pa.id_periodo_academico=136 and aa.estado='A' and aa.valor>0


select distinct c1.*
from aca.silabo s1
         inner join aca.silabo_periodo_academico spa1 on spa1.id_silabo = s1.id_silabo
         inner join aca.contenidos c1 on s1.id_silabo=c1.id_silabo
         inner join aca.contenido_componente_aprendizaje cca1 on c1.id_contenidos=cca1.id_contenidos
where s1.estado in ('A','P') --and c1.id_contenido_padre is not null
  and s1.id_malla_asignatura=2806   and spa1.estado='A' --and cca1.estado='A'
--    and cca1.id_componente_aprendizaje= 2
  and spa1.id_periodo_academico = 136
-- and c1.id_contenidos in (172981,    172982,172983,172984,172985,172986,172987,172988,172989,172990,172991,172992    )
-- group by cca1.id_componente_aprendizaje, c1.descripcion


select distinct ca.*
from aca.silabo s
         inner join aca.silabo_periodo_academico spa on spa.id_silabo = s.id_silabo
         inner join aca.contenidos c on s.id_silabo=c.id_silabo
         inner join aca.contenido_componente_aprendizaje ca on c.id_contenidos=ca.id_contenidos
where s.estado in ('A','P')  and c.id_contenido_padre is not null
  and s.id_malla_asignatura=2806 --and spa.estado='A'-- and cca1.estado='A'  and c1.estado='A'
  and spa.id_periodo_academico = 136 and s.id_silabo = 9417
and c.id_contenidos not in (173097,    173098,173099,173100,173101,173102,173103,173104,173105,173106,173107,173108,173109,173110,173111,173112    )

SELECT * FROM aca.contenidos where id_contenido_padre = 162307

select * from aca.contenidos where id_contenidos = 162307
select * from aca.contenidos where id_silabo = 9657
select * from aca.silabo where id_malla_asignatura= 3210

select * from aca.silabo_periodo_academico where id_silabo = 9415
select * from [aca].[fn_silabo] ( 3210,136)

select s1.id_silabo,cca1.id_componente_aprendizaje,sum(cca1.horas) f
from aca.silabo s1
inner join aca.silabo_periodo_academico spa on spa.id_silabo = s1.id_silabo
inner join aca.contenidos c1 on s1.id_silabo=c1.id_silabo
inner join aca.contenido_componente_aprendizaje cca1 on c1.id_contenidos=cca1.id_contenidos
where s1.estado in ('A','P') and c1.estado='A' and c1.id_contenido_padre is not null
and s1.id_malla_asignatura=3210 and cca1.estado='A'  and spa.estado='A' and spa.id_periodo_academico = 136
group by cca1.id_componente_aprendizaje, s1.id_silabo

select --ofa.carrera,ofa.id_departamento,ofa.id_oferta_modalidad,
       pca.* from aca.periodo_componente_aprendizaje pca
 inner join aca.periodo_academico_oferta pao on pca.id_periodo_academico_oferta = pao.id_periodo_academico_oferta
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = pao.id_oferta_modalidad
where pao.id_periodo_academico = 138 and ofa.id_departamento = 9 and ofa.id_oferta_modalidad = 112

select * from aca.contenidos where descripcion ='FUNDAMENTOS DE LA CRISIS Y EL TRAUMA'

select distinct cca1.*
from aca.silabo s1
         inner join aca.silabo_periodo_academico spa1 on spa1.id_silabo = s1.id_silabo
         inner join aca.contenidos c1 on s1.id_silabo=c1.id_silabo
         inner join aca.contenido_componente_aprendizaje cca1 on c1.id_contenidos=cca1.id_contenidos
where s1.estado in ('A','P') and c1.estado='I' --and c1.id_contenido_padre is not null
  and s1.id_silabo=9416

SELECT distinct ca.id_componente_aprendizaje_padre as idCompAprendizajePadre,ca.abreviatura as abreviaturaPadre,ca.codigo as codigoPadre,ca.descripcion as componentePadre,
   case when ca1.id_componente_aprendizaje is null then ca.id_componente_aprendizaje else ca1.id_componente_aprendizaje end as idCompAprendizajeHijo,
   case when ca1.abreviatura IS null then ca.abreviatura else ca1.abreviatura  end as abreviaturaHijo,
   case when ca1.codigo is null then ca.codigo else ca1.codigo  end as codigoHijo,
   case when ca1.descripcion is null then ca.descripcion else ca1.descripcion  end  as componenteHijo
   FROM aca.Componente_Aprendizaje ca
   LEFT JOIN aca.Componente_Aprendizaje ca1 on ca.id_componente_aprendizaje=ca1.id_componente_aprendizaje_padre
   inner join aca.reglamento_comp_aprendizaje rca on rca.id_comp_aprendizaje in (ca.id_componente_aprendizaje,ca1.id_componente_aprendizaje)
   inner join aca.Malla m on m.id_reglamento = rca.id_reglamento
   inner join aca.Malla_Asignatura ma on m.id_malla = ma.id_malla
   WHERE ca.estado='A' and ca.id_componente_aprendizaje_padre in
                           (select ca1.id_componente_aprendizaje from aca.componente_aprendizaje ca1 where ca1.codigo='FORMATIVA' and ca1.estado='A')
   and (ca1.estado is null or ca1.estado ='A') and ma.id_malla_asignatura = (2806)
   order by ca.orden ,ca1.orden

begin
    DECLARE @data TABLE(id_silabo INT, id_malla_asignatura INT);
    INSERT INTO @data VALUES
    (8797,3572)
--     (8795,3591),(8796,3593),(8797,3592)
    -- (8325,3531),(8326,3545),(8327,3544),(8328,3543),
    -- (8329,3542),(8330,3541),(8331,3550),(8332,3549),
        DECLARE @id_silabo INT, @id_malla_asignatura INT;

        DECLARE cur CURSOR FOR
        SELECT id_silabo, id_malla_asignatura FROM @data;

        OPEN cur;
        FETCH NEXT FROM cur INTO @id_silabo, @id_malla_asignatura;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC aca.sp_clonar_silabo_complete @id_silabo, 127,@id_malla_asignatura, 138, '2400254286';
            FETCH NEXT FROM cur INTO @id_silabo, @id_malla_asignatura;
        END

        CLOSE cur;
        DEALLOCATE cur;

end
select * from aca.silabo where id_malla_asignatura = 2183
select * from aca.silabo_periodo_academico spa where spa.id_silabo in (8795,8796)
select * from aca.ofertas_facultad where id_tipo_oferta = 1

select c.* from aca.contenidos c
         inner join aca.silabo s on c.id_silabo = s.id_silabo
         where s.id_malla_asignatura = 3210

select * from aca.asignatura
select d.*  from [aca].[fn_listar_detalle_silabos_by_oferta_and_periodo](112,9,127)  as d
select d.*  from [aca].[fn_listar_detalle_silabos_by_oferta_and_periodo](112,9,138)  as d

select d.*  from [aca].[fn_listar_detalle_silabos_by_oferta_and_periodo](106,7,127)  as d
select d.*  from [aca].[fn_listar_detalle_silabos_by_oferta_and_periodo](106,7,138)  as d
select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 1

select sb1.* from (
select sb.*
     , ROW_NUMBER() OVER (PARTITION BY sb.id_silabo,sb.id_recurso_bibliografico,sb.id_tipo_bibliografia ORDER BY id_silabo_bibliografia ) as rn
from aca.silabo_bibliografia sb
    inner join (SELECT
                    id_silabo,
                    id_recurso_bibliografico,
                    id_tipo_bibliografia,
                    COUNT(*) AS cantidad
                FROM aca.silabo_bibliografia
                WHERE estado = 'A'
                GROUP BY
                    id_silabo,
                    id_recurso_bibliografico,
                    id_tipo_bibliografia
                HAVING COUNT(*) > 1) as x on x.id_silabo=sb.id_silabo and x.id_recurso_bibliografico = sb.id_recurso_bibliografico
         and x.id_tipo_bibliografia = sb.id_tipo_bibliografia
where sb.estado='A'
-- and sb.id_silabo in (8250,2056)
    )as d
inner join aca.silabo_bibliografia sb1 on sb1.id_silabo_bibliografia = d.id_silabo_bibliografia
           where d.rn = 2
ORDER BY sb1.id_silabo_bibliografia,sb1.id_silabo,sb1.id_recurso_bibliografico,sb1.id_tipo_bibliografia

--eliminar bibliografia repetida
select sb1.* from (
select sb.*
     , ROW_NUMBER() OVER (PARTITION BY sb.id_silabo,sb.id_recurso_bibliografico,sb.id_tipo_bibliografia ORDER BY id_silabo_bibliografia ) as rn
from aca.silabo_bibliografia sb
    inner join (SELECT
                    id_silabo,
                    id_recurso_bibliografico,
                    id_tipo_bibliografia,
                    COUNT(*) AS cantidad
                FROM aca.silabo_bibliografia
                WHERE estado = 'A'
                GROUP BY
                    id_silabo,
                    id_recurso_bibliografico,
                    id_tipo_bibliografia
                HAVING COUNT(*) > 1) as x on x.id_silabo=sb.id_silabo and x.id_recurso_bibliografico = sb.id_recurso_bibliografico
         and x.id_tipo_bibliografia = sb.id_tipo_bibliografia
where sb.estado='A'
-- and sb.id_silabo in (8250,2056)
    )as d
inner join aca.silabo_bibliografia sb1 on sb1.id_silabo_bibliografia = d.id_silabo_bibliografia
           where d.rn = 2
ORDER BY sb1.id_silabo_bibliografia,sb1.id_silabo,sb1.id_recurso_bibliografico,sb1.id_tipo_bibliografia

--eliminar bibliografia no catalogada repetida
select sb1.* from (
select s.descripcion as silabos,m.descripcion as malla,m.id_malla,m.id_oferta_modalidad,sb.*
     , ROW_NUMBER() OVER (PARTITION BY sb.id_silabo,sb.id_malla_asignatura,sb.id_tipo_bibliografia,sb.descripcion,sb.autores,sb.editorial--,sb.edicion
         ORDER BY id_silabo_bibliografia_no_catalogada ) as rn
from aca.silabo_bibliografia_no_catalogada sb
    inner join aca.silabo s on s.id_silabo = sb.id_silabo
    inner join aca.malla_asignatura ma on sb.id_malla_asignatura = ma.id_malla_asignatura
    inner join aca.malla m on ma.id_malla = m.id_malla
    inner join (SELECT
                    id_silabo,id_malla_asignatura,
                    id_tipo_bibliografia,descripcion,autores,editorial,--edicion,
                    COUNT(*) AS cantidad
                FROM aca.silabo_bibliografia_no_catalogada
                WHERE estado = 'A'
                GROUP BY
                    id_silabo,
                    id_tipo_bibliografia, descripcion, autores, editorial, id_malla_asignatura--, edicion
                HAVING COUNT(*) > 1) as x on x.id_silabo=sb.id_silabo and x.descripcion = sb.descripcion and x.autores=sb.autores
                                                  and x.id_malla_asignatura=sb.id_malla_asignatura and x.editorial=sb.editorial --and x.edicion = sb.edicion
         and x.id_tipo_bibliografia = sb.id_tipo_bibliografia
where sb.estado='A'
-- and s.id_silabo in (1190,2056,4213,4505,5267)
-- ORDER BY sb.id_silabo,sb.id_tipo_bibliografia,sb.descripcion,sb.autores,sb.editorial,sb.edicion
    )as d
inner join aca.silabo_bibliografia_no_catalogada sb1 on sb1.id_silabo_bibliografia_no_catalogada = d.id_silabo_bibliografia_no_catalogada
--            where d.rn = 2
ORDER BY sb1.id_silabo,sb1.id_malla_asignatura,sb1.id_tipo_bibliografia,sb1.descripcion,sb1.autores,sb1.editorial,sb1.edicion



--eliminar los silabos items repetidos
SELECT sir1.*
FROM (
         SELECT sir.*, ROW_NUMBER() OVER (
             PARTITION BY
             sir.id_silabo,
             sir.id_silabo_componente_item
             ORDER BY sir.id_silabo_item_relacion
             ) AS rn
         FROM aca.silabo_item_relacion sir
        INNER JOIN (
             SELECT
                 id_silabo,
                 id_silabo_componente_item,
                 COUNT(*) AS cantidad
             FROM aca.silabo_item_relacion
             WHERE estado = 'A'
             GROUP BY
                 id_silabo,
                 id_silabo_componente_item
             HAVING COUNT(*) > 1
         ) x ON x.id_silabo = sir.id_silabo AND x.id_silabo_componente_item = sir.id_silabo_componente_item
         WHERE sir.estado = 'A'
         -- AND sir.id_silabo IN (XXXX) -- opcional para filtrar
     ) d
    INNER JOIN aca.silabo_item_relacion sir1 ON sir1.id_silabo_item_relacion = d.id_silabo_item_relacion

WHERE d.rn >= 2  -- 🔥 puedes cambiar a =2 o >=2
ORDER BY
    sir1.id_silabo,
    sir1.id_silabo_componente_item,
    sir1.id_silabo_item_relacion;

--eliminar resultado_aprendizaje_item_relacion repetidos
SELECT  --s.descripcion,m.id_oferta_modalidad,ara.descripcion,sci.descripcion,
        rai1.*
FROM (
         SELECT rai.*
              , ROW_NUMBER() OVER (
             PARTITION BY
             rai.id_silabo,
             rai.id_asignatura_resultado_aprendizaje,
             rai.id_silabo_componente_item
             ORDER BY rai.id_resultado_aprendizaje_item_relacion
             ) AS rn
         FROM aca.resultado_aprendizaje_item_relacion rai

                  INNER JOIN (
             SELECT
                 id_silabo,
                 id_asignatura_resultado_aprendizaje,
                 id_silabo_componente_item,
                 COUNT(*) AS cantidad
             FROM aca.resultado_aprendizaje_item_relacion
             WHERE estado = 'A'
             GROUP BY
                 id_silabo,
                 id_asignatura_resultado_aprendizaje,
                 id_silabo_componente_item
             HAVING COUNT(*) > 1
         ) x
                             ON x.id_silabo = rai.id_silabo
                                 AND x.id_asignatura_resultado_aprendizaje = rai.id_asignatura_resultado_aprendizaje
                                 AND x.id_silabo_componente_item = rai.id_silabo_componente_item

         WHERE rai.estado = 'A'
         -- AND rai.id_silabo IN (XXXX) -- opcional
     ) d

    INNER JOIN aca.resultado_aprendizaje_item_relacion rai1 ON rai1.id_resultado_aprendizaje_item_relacion = d.id_resultado_aprendizaje_item_relacion
--     inner join aca.silabo s on rai1.id_silabo = s.id_silabo
--     inner join aca.malla_asignatura ma on ma.id_malla_asignatura = s.id_malla_asignatura
--     inner join aca.malla m on ma.id_malla = m.id_malla
--     inner join aca.asignatura_resultado_aprendizaje ara on ma.id_malla_asignatura = ara.id_malla_asignatura
--     inner join aca.silabo_componente_item sci on rai1.id_silabo_componente_item = sci.id_silabo_componente_item
WHERE d.rn >= 2  -- 🔥 aquí están los duplicados
ORDER BY
    rai1.id_silabo,
    rai1.id_asignatura_resultado_aprendizaje,
    rai1.id_silabo_componente_item,
    rai1.id_resultado_aprendizaje_item_relacion;

select * from aca.resultado_aprendizaje_item_relacion where id_resultado_aprendizaje_item_relacion in (39533,39539,39502,39508)

SELECT cca1.*
FROM (
         SELECT cca.*
              , ROW_NUMBER() OVER (
             PARTITION BY
             cca.id_contenidos,
             cca.id_componente_aprendizaje
             ORDER BY cca.id_contenido_componente_aprendizaje
             ) AS rn
         FROM aca.contenido_componente_aprendizaje cca

                  INNER JOIN (
             SELECT
                 id_contenidos,
                 id_componente_aprendizaje,
                 COUNT(*) AS cantidad
             FROM aca.contenido_componente_aprendizaje
             WHERE estado = 'A'
             GROUP BY
                 id_contenidos,
                 id_componente_aprendizaje
             HAVING COUNT(*) > 1
         ) x
                             ON x.id_contenidos = cca.id_contenidos
                                 AND x.id_componente_aprendizaje = cca.id_componente_aprendizaje

         WHERE cca.estado = 'A'
     ) d

         INNER JOIN aca.contenido_componente_aprendizaje cca1
                    ON cca1.id_contenido_componente_aprendizaje = d.id_contenido_componente_aprendizaje

WHERE d.rn >= 2
ORDER BY
    cca1.id_contenidos,
    cca1.id_componente_aprendizaje,
    cca1.id_contenido_componente_aprendizaje;