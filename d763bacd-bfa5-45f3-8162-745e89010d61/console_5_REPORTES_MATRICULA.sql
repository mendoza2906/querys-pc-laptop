use bd_sga_upse
--01-06-2022 31/12/2023
--2023-1 y 2023-2 de grado


select * from man.personas where identificacion ='1105909186'

select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 1
--NUMERO DE APRPBADOS Y REPROBADOS POR PERIODO Y ASIGNATURA
declare @pi_id_perido_academico int = 32 , @departamento int = null
select departamento, oferta,   asignatura,docente ,paralelo,ISNULL(MAX([true]),0) AS APROBADO,ISNULL(MAX([false]),0) AS REPROBADO,ISNULL(MAX([true]),0)+ISNULL(MAX([false]),0) AS MATRICULADOS
from
(
--declare @pi_id_perido_academico int = 27
select d.nombre as departamento,
                      o.descripcion as oferta ,a.descripcion as asignatura,
                      concat(n.descripcion_corta,'/',par.descripcion_corta) as paralelo, ea.aprobado
                      , cast (avg( ea.promedio) as decimal(10,2)) as promedio
                        , count( ea.promedio) as cantidad,
                    (select top 1 concat(pd.apellidos,' ',pd.nombres) as docente from  aca.distributivo_oferta do
                    inner join aca.distributivo_docente dd on do.id_distributivo_oferta=dd.id_distributivo_oferta
                    inner join aca.docente doc on dd.id_docente = doc.id_docente
                    inner join man.personas pd on pd.id = doc.id_persona
                    inner join aca.docente_asignatura_aprend daa on dd.id_distributivo_docente=daa.id_distributivo_docente
                    inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje=daa.id_asignatura_aprendizaje
                    inner join aca.componente_aprendizaje capr on capr.id_componente_aprendizaje=aa1.id_componente_aprendizaje
                    inner join aca.malla_asignatura ma1 on aa1.id_malla_asignatura=ma1.id_malla_asignatura
                    where   dd.estado='A' and daa.estado='A' and capr.estado='A' and aa1.estado='A'
                   and ma1.estado='A'
                    and ma1.id_malla_asignatura=ma.id_malla_asignatura and daa.id_paralelo=ea.id_paralelo and ca.id_componente_aprendizaje=capr.id_componente_aprendizaje
                    and do.id_distributivo_oferta in
                        (select max(dof.id_distributivo_oferta) from aca.periodo_academico_oferta pao
                    inner join aca.distributivo_oferta dof on dof.id_periodo_academico_oferta=pao.id_periodo_academico_oferta
                    where (pao.id_periodo_academico=@pi_id_perido_academico or pao.id_periodo_academico in (select pm.id_periodo_academico from aca.periodo_malla pm
                    inner join  aca.relacion_oferta ro on pm.id_periodo_malla=ro.id_periodo_malla
                    inner join aca.relacion_oferta_detalle rod on ro.id_relacion_oferta=rod.id_relacion_oferta
                    inner join aca.periodo_malla pm1 on rod.id_periodo_malla=pm1.id_periodo_malla
                    where pm1.id_periodo_academico=@pi_id_perido_academico and pm.estado='A' AND pm1.estado='A' and ro.estado='A' and rod.estado='A'
                    ))
                        and dof.estado in ('A','D','V')group by pao.id_periodo_academico_oferta) group by pd.apellidos,pd.nombres) as docente

               from man.personas p
                        inner join aca.estudiante_oferta eo on eo.id_persona = p.id
                        inner join aca.tipo_estado_estudiante tee
                                   on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
                        inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
                        inner join aca.estudiante_asignatura ea
                                   on ea.id_estudiante_matricula = em.id_estudiante_matricula
                        inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
                        inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
                        inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
                        inner join aca.oferta o on o.id_oferta = om.id_oferta
                        inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
                        inner join man.departamentos d on d.id = do.id_departamento
                        inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje=ea.id_asignatura_aprendizaje
                        inner join aca.componente_aprendizaje ca on aa.id_componente_aprendizaje = ca.id_componente_aprendizaje and ca.estado='A'
                        inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
                        inner join aca.asignatura a on ma.id_asignatura=a.id_asignatura
                        inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
                        inner join aca.nivel n on ma.id_nivel=n.id_nivel
               where em.estado = 'A'
                 and pa.id_periodo_academico = @pi_id_perido_academico --and --tee.codigo ='ACT' and
                 and (d.id = @departamento or @departamento is null )
                 --and ap.id_oferta_modalidad_pregrado is null
-- 			and p.apellidos like '%ORDOÑEZ%'
                 AND eo.estado = 'A'
                 and ea.estado = 'A'
                 and aa.estado = 'A'
                                               and ma.estado = 'A'   --and p.identificacion='0958799066'

               group by d.nombre, o.descripcion,  eo.id_oferta_modalidad,a.descripcion, par.descripcion_corta, n.descripcion_corta, ea.aprobado,ma.id_malla_asignatura,ea.id_paralelo,
                        ca.id_componente_aprendizaje

   )as aux2 PIVOT (MIN(cantidad ) FOR aprobado IN ([true], [false])) AS PivotTable
 group by departamento, oferta,   asignatura, PARALELO,docente-- TRUE,FALSE
 order by departamento, oferta,paralelo,asignatura
select * from aca.periodo_academico

--                   RODRÍGUEZ SINCHE DIEGO EFRAÍN	0928014124
--          MORENO RAMIREZ JOUSTIN ARLAHEM 	2450024910


select * from man.personas where identificacion='GL227930'
select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 2
select * from aca.tipo_estado_estudiante
select * from man.departamentos


select * from aca.tipo_matricula_fecha

select * from aca.asignatura_compatibilidad
select * from man.departamentos
--VER USUARIO GRABO_MATRICULA
begin
    declare @id_periodo_academico int=138
    select       --ea.id_estudiante_asignatura,ea.id_asignatura_aprendizaje,ea.id_paralelo,ea.estado
--   distinct  eo.*
--     distinct   a.descripcion,ma.id_malla_asignatura,ea.*
--         distinct mr.*
        distinct ea.*
--             distinct   em.*
--         distinct em.id_estudiante_matricula,pa.codigo,om.carrera,p.id,p.identificacion,p.apellidos,p.nombres,
--                  eo.numero_matricula,ma.id_nivel, ma.id_malla_asignatura,ea.id_paralelo,ea.id_estudiante_asignatura,a.descripcion as asignatura,ea.codigo_estado_matricula,ea.promedio,
--                  case when ea.estado is null then 'NO MATRICULADO' when ea.estado = 'X' then 'ANULADA'
--                      when ea.estado = 'A' then 'ACTIVA'    when ea.estado = 'I' then 'INACTIVA' else ea.estado end as estado_Matricula,
--         em.estado,em.fecha_ing as fechaMatricula,em.fecha_mod as fechaModMatricula
--                  ,concat(pu.nombres, ' ', pu.apellidos)   as usuarioCreaMatricula
--                  ,concat(pu2.nombres, ' ', pu2.apellidos) as usuarioModificomatricula
        from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
             inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
             inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
             inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
            left join aca.matricula_rubro mr on em.id_estudiante_matricula = mr.id_estudiante_matricula
--         inner join aca.detalle_estudiante_asignatura dea on ea.id_estudiante_asignatura = dea.id_estudiante_asignatura
             inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
             inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
             inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
             left join seg.usuarios u on u.usuario = ea.usuario_ing
             left join man.personas pu on pu.id = u.persona_id
             left join seg.usuarios u2 on u2.usuario = ea.usuario_mod
             left join man.personas pu2 on pu2.id = u2.persona_id
    where
--         eo.id_estudiante_oferta = 66068
-- and em.id_matricula_general = 19
        mg.id_periodo_academico = @id_periodo_academico -- ea.estado='A' and
--     and cast(em.fecha_ing as date)='2024-07-29' --and cast(em.fecha_ing as time(0))='10:04:20'
       and p.identificacion in ('1313727560',
           '2450616327',
'2450153776',
'0954763074',
'2450103136',
'2450293101',
'2450056094',
'2450489352',
'2450056367',
'2450913732',
'0923408439'
           ) --and ma.id_nivel  = 5
--       and om.id_tipo_oferta = 4 or ea.id_estudiante_asignat0927363069','0957134703','0919659318','2400356040','2450537713','0928018811','2450742883','0928022870','0940825656','2450110024',
--                             '0922585146','0924982846','0929016574','2450773995','0928191139','2400456782','2450637695','0927833400','0928270818','2450265083ura=711534
--     and ma.id_malla_asignatura = 3244
--      p.identificacion in ('0944200351')
--         ea.id_estudiante_asignatura in (802589,802107)
--     order by em.fecha_ing asc;
end

select getdate()

select *
from [aca].[fn_listar_docentes_asignaturas](10518,null,136) as d
-- where d.orden = 1

select * from aca.estudiante_asignatura where id_estudiante_asignatura>734420 and estado='I'

exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 26911,136,1,664
exec [aca].[pa_generar_asignaturas_a_matricular_sga] 26911,136,1,664

begin
    select distinct ea.id_docente,ea.id_paralelo,ea.id_estudiante_asignatura, ea.estado,ma.id_malla_asignatura,
           n.id_nivel,
           case when ea.matricula_excepcional =1 then concat(CONVERT(varchar(10),n.orden),' - ',a.descripcion, ' - Matrícula Excepcional') else
               concat(CONVERT(varchar(10),n.orden),' - ',a.descripcion)  end as nombreAsignatura,nv.descripcion as numVez,ea.fecha_ing,ea.fecha_mod, ma.num_creditos,ma.num_horas,ea.valor_asignatura,ea.id_numero_vez
    from aca.estudiante_matricula em
             inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = em.id_estudiante_oferta
             inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
             inner join aca.malla m on eo.id_malla = m.id_malla
             inner join aca.malla_asignatura ma on ma.id_malla = m.id_malla and ma.id_nivel=8
             inner join aca.nivel n on ma.id_nivel = n.id_nivel
             inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
             inner join aca.asignatura_aprendizaje aa on ma.id_malla_asignatura = aa.id_malla_asignatura
             inner join aca.componente_aprendizaje as cap on aa.id_componente_aprendizaje=cap.id_componente_aprendizaje
             left join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula and aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje AND ea.estado in ('A','R','X','P')
             left join aca.numero_vez nv on nv.id_numero_vez = ea.id_numero_vez
    where em.id_estudiante_oferta = 26911 and cap.codigo in ('DOCENCIA','PRESENCIAL','SINCRONICO')
      and mg.id_periodo_academico = 136
    order by ma.id_malla_asignatura
end

select d.periodo_academico,d.nivel,d.concepto,d.valor,d.abono,d.deuda from  aca.fn_record_rubros ('0928225804') d
where d.abono <d.valor and d.concepto is not null
select * from aca.matricula_rubro where estado='I' and id_rubro = 9
begin
    declare @id_periodo_academico int=136
    select
        distinct p.identificacion,em.*
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
             inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
             inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
             inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
             left join aca.matricula_rubro mr on em.id_estudiante_matricula = mr.id_estudiante_matricula
             inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
             inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
             inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    where
        mg.id_periodo_academico = @id_periodo_academico and em.estado='A'
    and p.identificacion in ('2450895194','2450745563')
end

-- select * from aca.estudiante_matricula where id_estudiante_matricula in (196382,209054)
--ver posibles terceras veces
select

    distinct
--     mr.id_matricula_rubro,mr.id_estudiante_matricula,mr.id_rubro,mr.valor,
--     p.identificacion,eo.id_estudiante_oferta,eo.ultimo_periodo,
--     ea.id_estudiante_asignatura,ea.id_numero_vez,ea.codigo_estado_matricula,
    ea.* from aca.estudiante_oferta eo
    inner join man.personas p on p.id = eo.id_persona
    inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
    inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
    inner join aca.estudiante_asignatura ea1 on ea1.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
    inner join aca.estudiante_matricula em1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula and em1.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join aca.matricula_general mg1 on mg1.id_matricula_general = em1.id_matricula_general and mg1.id_periodo_academico = 136
    left join aca.matricula_rubro mr on em1.id_estudiante_matricula = mr.id_estudiante_matricula and mr.estado='A'
    where ea.aprobado is null and mg.id_periodo_academico = 140 and ea.estado='A' --and ea.id_numero_vez = 1
--       and mg1.id_periodo_academico = 136-- and ea.id_estudiante_asignatura in (706703,	707438,	707912,	706904,	707174,	707585,	707785,	707830,	708313,	706817,	707177,	708130,	707641,	707984,	708088,	706606,	707204,
--                                     707215,	707535,	708123,	708231,	708270,	708271,	708272,	708286,	707144,	707330,	707508,	707940,	708173,	706960,	707259,	707718,	708502,	707443,	708452)
--               --primera vez
-- and ea.id_estudiante_asignatura in (706606,707144,707438,707535,707585,707718,707785,707830,708088,708130,708173,708286,708502)
-- and p.identificacion not in ('0928237783')
-- and eo.ultimo_periodo ='2026-0'
select * from aca.periodo_academico where id_periodo_academico = 140

select * from aca.matricula_rubro where id_estudiante_matricula = 205365

select
    distinct
--     mr.id_matricula_rubro,mr.id_estudiante_matricula,mr.id_rubro,mr.valor,
p.identificacion,eo.id_estudiante_oferta,eo.ultimo_periodo,a.descripcion as asigntura,
ea.id_estudiante_asignatura,ea.id_numero_vez,ea.codigo_estado_matricula,aux.id_estudiante_asignatura,aux.id_estudiante_matricula,
aux.id_numero_vez,aux.codigo_estado_matricula,aux.id_matricula_rubro from   aca.estudiante_oferta eo
inner join man.personas p on p.id = eo.id_persona
inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
left join (
        select em1.id_estudiante_oferta,ea1.*,mr.id_matricula_rubro from aca.estudiante_asignatura ea1
        inner join aca.estudiante_matricula em1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
        inner join aca.matricula_general mg1 on mg1.id_matricula_general = em1.id_matricula_general
        left join aca.matricula_rubro mr on em1.id_estudiante_matricula = mr.id_estudiante_matricula and mr.id_rubro = 9 and mr.estado='A'
                                              where mg1.id_periodo_academico = 136 and ea1.estado='A' and em1.estado='A' and mg1.estado='A'
                                      ) as aux on  aux.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje   and aux.id_estudiante_oferta = eo.id_estudiante_oferta
where ea.aprobado is null and mg.id_periodo_academico = 140 and ea.estado='A'




select * from aca.estudiante_oferta where id_estudiante_oferta in (67284,    79391,
76159,30656,64737,64625,43413,76076,55237,67831,67831,67831,29457,88991,25930,77674,53982,23367,
56461,64842,89199,88864,42914,23595,55450,86320,77857,76347,54261,24210,54539,54018,64722,86582,77584,88862)

select * from aca.estudiante_asignatura where aprobado is null and cast(fecha_ing as date)<'2025-02-23'

select * from aca.estudiante_asignatura where id_estudiante_asignatura in(707508)

select * from aca.matricula_rubro where  estado='I'
-- 13837
select * from man.documentos_archivos where id_documento_archivo = 31196
select * from man.documentos_archivos where id_number = 170290

exec [aca].[sp_list_all_carreras_records] '1250913488',null,null,null,null

exec [aca].[sp_list_all_matriculas_carreras] '2400254286',null

exec [aca].[sp_list_all_asignaturas_detalle_record] 66421,113,'2024237300611',
     '1250913488',null,null,null


select * from mig.periodo_academico_ponderacion

select dm.* from aca.movilidad mov1
    inner join aca.detalle_movilidad dm on mov1.id_movilidad = dm.id_movilidad
inner join aca.periodo_academico pa on mov1.id_periodo_academico = pa.id_periodo_academico
inner join aca.estudiante_oferta eo1 on mov1.id_estudiante_oferta = eo1.id_estudiante_oferta
inner join man.personas p on p.id = eo1.id_persona
where mov1.estado='A'  and p.identificacion in ('2450893447')

select *from  [aca].[fn_listar_docentes_asignaturas](54960,null,136) as d
where orden = 5
select * from aca.asignatura_compatibilidad

select * from tes.rubro

select * from aca.matricula_rubro where id_rubro = 9 and estado='I'

select * from man.documentos_archivos where id_number in (546148,546149,137808)

select * from aca.estudiante_matricula where id_estudiante_matricula = 137808
select * from aca.estudiante_asignatura where id_estudiante_matricula = 137808

select * from man.documentos_archivos where table_name = 'aca_estudiante_matricula'


select * from aca.tipo_estado_estudiante
-- 70805
-- 2400078149
-- 2450697087

select *from  [aca].[fn_listar_docentes_asignaturas](null,105,127) as d
-- where d.idMallaAsignatura in (1444) and d.idParalelo = 2
select *from  [aca].[fn_listar_docentes_asignaturas](27826,null,140) as d
--     7 - GESTIóN DE EMPRESAS DE INTERMEDIACIóN TURíSTICA Y OCIO

-- DBCC CHECKIDENT ('aca.estudiante_asignatura', RESEED, 577417);
select * from aca.ofertas_facultad ofa where ofa.id_tipo_oferta = 1

select *from aca.estudiante_matricula where id_estudiante_oferta = 45505

select * from aca.matricula_rubro where estado='I' and id_rubro =9

select * from aca.matricula_rubro where id_matricula_rubro = 10190

select * from aca.estudiante_asignatura where id_estudiante_asignatura = 261752

select * from aca.horario_academico


select * from mig.record_asignaturas where periodo <'2000-1'

select * from aca.estudiante_oferta where id_estudiante_oferta = 39307
select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 1

select * from aca.estudiante_matricula where id_estudiante_matricula =8767
select * from aca.estudiante_matricula where id_estudiante_matricula =8768

select distinct em.*

from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.tipo_estado_estudiante tee
                    on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
         inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
         inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
         inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
         inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
         inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
         inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
where mg.id_periodo_academico = 138
  and em.estado = 'A'
  and ea.estado = 'A' and cast(em.fecha_ing as date)= cast(getdate() as date)


-- personas que ven mas materias que las de 3ra vez
begin
    declare @id_periodo_academico int=136
    select *
    from (select eo.id_estudiante_oferta , em.id_estudiante_matricula , pa.codigo , d.nombre as facultad, o.descripcion as carrera, p.identificacion,
                 p.apellidos, p.nombres , eo.numero_matricula
               , (select count(ea2.id_estudiante_asignatura)
                  from aca.estudiante_asignatura ea2
                  where ea2.estado = 'A'
                    and ea2.id_numero_vez < 3
                    and ea2.id_estudiante_matricula = em.id_estudiante_matricula) as asignaturasAdiconales,
                 (select count(ea2.id_estudiante_asignatura)
                  from aca.estudiante_asignatura ea2
                  where ea2.estado = 'A'
                    and ea2.id_numero_vez = 3
                    and ea2.id_estudiante_matricula = em.id_estudiante_matricula) as tercerasVeces,
                               concat(pu.nombres, ' ', pu.apellidos)   as usuarioCreaMatricula,
                 concat(pu2.nombres, ' ', pu2.apellidos) as usuarioModificomatricula
          from man.personas p
                   inner join aca.estudiante_oferta eo on eo.id_persona = p.id
                   inner join aca.tipo_estado_estudiante tee
                              on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
                   inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
                   inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
                   inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
                   inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
                   left join aca.matricula_rubro mr on em.id_estudiante_matricula = mr.id_estudiante_matricula
                   left join tes.cobro_matricula cm on cm.id_matricula_rubro = mr.id_matricula_rubro
                   inner join aca.asignatura_aprendizaje aa
                              on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
                   inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
                   inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
                   inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
                   inner join aca.oferta o on o.id_oferta = om.id_oferta
                   inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
                   inner join man.departamentos d on d.id = do.id_departamento
                       left join seg.usuarios u on u.usuario = ea.usuario_ing
             left join man.personas pu on pu.id = u.persona_id
             left join seg.usuarios u2 on u2.usuario = ea.usuario_mod
             left join man.personas pu2 on pu2.id = u2.persona_id
          where mg.id_periodo_academico = @id_periodo_academico
            and em.estado = 'A'
            and ea.estado = 'A'
            and ea.id_numero_vez = 3 --and do.id_departamento = 7
--           and p.identificacion=em.usuario_ing
          group by eo.id_estudiante_oferta, em.id_estudiante_matricula, pa.codigo, d.nombre, o.descripcion,
                   p.identificacion, p.apellidos, p.nombres, eo.numero_matricula
          ,pu.nombres,pu.apellidos,pu2.nombres,pu2.apellidos
--            , ma.id_nivel, ma.id_malla_asignatura,ea.id_paralelo,ea.id_estudiante_asignatura,a.descripcion
         ) as d
    where
--         d.tercerasVeces > 2
        d.asignaturasAdiconales > 0
    order by d.facultad,d.carrera
end;

select * from aca.asignatura_resultado_aprendizaje

select * from aca.planificacion_paralelo

select * from aca.matricula_rubro where estado='I'

-- listar records
begin
    select
--     distinct  em.*
    --       distinct  ea.*--,p.identificacion
--    distinct eo.*
        distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,p.identificacion,p.apellidos,p.nombres,tee.descripcion,tie.descripcion
    from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
        inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
    inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
    where --eo.id_periodo_academico = @id_periodo_academico and
        p.identificacion in ('2450822446')
--     eo.id_estudiante_oferta=30179


end;
select * from mig.record_oferta where identificacion='2450133919'
select * from aca.tipo_estado_estudiante
select * from aca.tipo_ingreso_estudiante
select * from pro.proceso_usuario where usuario_ing='2450297821'
select * from pro.tipo_proceso_estado
select * from aca.periodo_academico where id_tipo_oferta = 1
select * from man.personas p where identificacion='0962428074'

--ver los manes que ya aprobaron modulos y se matricularon ahi mismo
begin
    declare @id_periodo_academico int=124
    select       --ea.id_estudiante_asignatura,ea.id_asignatura_aprendizaje,ea.id_paralelo,ea.estado
--     distinct  ea.*
--         distinct   mr.*
--       distinct  ea.*
--    distinct em.*
        distinct pa.codigo,p.identificacion,p.apellidos,p.nombres,aa.id_asignatura_aprendizaje,aas.id_asignatura_aprendizaje,
                 eo.numero_matricula, ma.id_nivel, ma.id_malla_asignatura,ea.id_paralelo,ea.id_estudiante_asignatura,a.descripcion,
                 aux.asignatura,aux.orden
--                  case
--                      when ea.estado is null then 'NO MATRICULADO'
--                      when ea.estado = 'X' then 'ANULADA'
--                      when ea.estado = 'A' then 'ACTIVA'
--                      else ea.estado end as estadoMat,em.fecha_ing as fechaMatricula,em.fecha_mod as fechaModMatricula,
--                  concat(pu.nombres, ' ', pu.apellidos)   as usuarioCreaMatricula,
--                  concat(pu2.nombres, ' ', pu2.apellidos) as usuarioModificomatricula--,dea.*
--     update ea set ea.id_asignatura_aprendizaje = aas.id_asignatura_aprendizaje,ea.codigo_estado_matricula='PRI',ea.id_rubro= 2,ea.valor_asignatura=0,ea.fecha_mod=getdate(),ea.usuario_mod='2400254286'
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
             inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
             inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
             inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
             left join aca.matricula_rubro mr on em.id_estudiante_matricula = mr.id_estudiante_matricula
             inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
             inner join aca.malla_asignatura mas on mas.id_malla = 20 and mas.id_nivel = (ma.id_nivel+1)
             inner join aca.asignatura_aprendizaje aas on aas.id_malla_asignatura = mas.id_malla_asignatura and aas.id_componente_aprendizaje =2
             inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
            left join (select a1.descripcion as asignatura,em1.id_estudiante_matricula,aa1.id_asignatura_aprendizaje,ma1.id_malla_asignatura,em1.id_estudiante_oferta, ma1.id_nivel,
                              ROW_NUMBER() OVER (PARTITION BY em1.id_estudiante_oferta ORDER BY  ma1.id_nivel desc) as orden
                       from aca.estudiante_matricula em1
                       inner join aca.matricula_general mg1 on mg1.id_matricula_general = em1.id_matricula_general
                       inner join aca.periodo_academico pa1 on mg1.id_periodo_academico = pa1.id_periodo_academico
                       inner join aca.estudiante_asignatura ea1 on ea1.id_estudiante_matricula = em1.id_estudiante_matricula
                       left join aca.matricula_rubro mr1 on em1.id_estudiante_matricula = mr1.id_estudiante_matricula
                       inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                       inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = aa1.id_malla_asignatura
                       inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
                      where ea1.estado='A' and ea1.aprobado=1 ) as aux on aux.id_estudiante_oferta = eo.id_estudiante_oferta
    where --eo.id_estudiante_oferta = 11006
        mg.id_periodo_academico = @id_periodo_academico --and
--     and em.fecha_ing <cast('2024-10-24 08:50:00.000' as datetime2) and
       and aux.orden= 1
    and ea.usuario_mod='2400254286'
--     and a.descripcion = aux.asignatura  and ma.id_nivel <>20
--     and p.identificacion in ('0926674458','0924484926','0928072974')
    --and cast(em.fecha_ing as time(0))='10:04:20'
--       and  p.identificacion in ('0917656936') --and o.id_tipo_oferta = 1
    --    and ma.id_malla_asignatura= 1656
--    and em.estado = 'A'
--   and em.estado = 'A'
--     order by d.nombre, p.apellidos;
end;
EXECUTE Bd_Academico..sp_record_modulos_estudiantes_historico 113, '12019812200'

select top 10 * from aca.estudiante_asignatura order by id_estudiante_asignatura desc

select aa.id_asignatura_aprendizaje,ma.*--,aa.*
from aca.malla_asignatura ma
inner join aca.asignatura_aprendizaje aa on ma.id_malla_asignatura = aa.id_malla_asignatura
where ma.id_malla = 20 and aa.id_componente_aprendizaje = 2



select * from aca.componente_aprendizaje

select  top 10 * from aca.estudiante_matricula


select
    pao.*
from aca.periodo_academico_oferta pao
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
         inner join aca.oferta o on o.id_oferta = om.id_oferta
         inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
         inner join man.departamentos d on d.id = do.id_departamento
where o.id_tipo_oferta = 4


select * from aca.fn_listar_docentes_asignaturas (null,103,36) as d
where d.orden = 7 and d.idParalelo = 2

select * from rel.fn_relaciones_ofertas_nivelacion_grado(38)
select * from aca.periodo_academico where id_tipo_oferta = 3
SELECT eo.* , (
    SELECT top 1 (pa.id_periodo_academico) FROM aca.estudiante_matricula as em
                                                    inner join aca.matricula_general as mg ON em.id_matricula_general = mg.id_matricula_general
                                                    INNER JOIN aca.periodo_academico as pa ON mg.id_periodo_academico = pa.id_periodo_academico
    WHERE pa.estado = 'A' AND mg.estado = 'A' and pa.id_tipo_oferta = 3
    order by pa.fecha_hasta
)
FROM aca.estudiante_oferta as eo
         INNER JOIN aca.oferta_modalidad as om ON eo.id_oferta_modalidad = om.id_oferta_modalidad
         INNER JOIN aca.oferta as o ON om.id_oferta = o.id_oferta
WHERE o.id_tipo_oferta = 3 AND eo.id_periodo_academico is null
  and eo.estado = 'A' AND om.estado = 'A' AND o.estado = 'A'-- AND em.estado = ''

select * from aca.periodo_academico where id_tipo_oferta = 2

select * from [aca].[fn_listar_docentes_asignaturas](null,89,35) as d
where d.idMallaAsignatura in (1656,1651)

select * from aca.nivel

select * from man.personas where identificacion='0928215706'

select * from tes.rubro

select * from aca.horario_academico where usuario_ing='1309743274' and id_periodo_academico = 136



select * from aca.periodo_academico_oferta

select pa1.codigo,o.descripcion,em1.observacion,em1.estado as estadoMatricula,em1.id_tipo_matricula,ea1.id_estudiante_asignatura,ea1.estado from aca.estudiante_matricula em1
    inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = em1.id_estudiante_oferta
     inner join man.personas p on p.id = eo.id_persona
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
                    inner join aca.oferta o on om.id_oferta = o.id_oferta
                    inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                    inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
                    inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = mg1.id_periodo_academico
                    where  --em1.estado='A'  and ea1.estado='A' and
--                           o.id_tipo_oferta = 2 and
                           mg1.estado='A' and pa1.estado='A' and p.identificacion ='0919962597'



exec bd_sga_upse.[aca].[sp_recordweb_materias_colum_aprob] 102,'12018490151','0927088187'
declare @recordSisWeb table (idNivel numeric(9,0), nivel varchar(150), materia varchar(350), idMateriaTomada int,idMateriaPlan int,idPlan numeric,
                             creditosHora numeric(5,2),promedio numeric(5,2),asistencia numeric(5,2),estado varchar(25),tipo varchar(350),
                             aprobado varchar(150),periodo varchar(50),idPeriodo int, orden varchar(10))
insert into @recordSisWeb exec bd_sga_upse.[aca].[sp_recordweb_materias_colum_aprob] 102,'12018490151','0927088187'
select ra.idNivel,niv.id_nivel,--niv.nivel
       case when ra.NIVEL in('GENERAL','V','I','II','III','IV','VI','VII','MODULOS') then 'MÓDULOS'
            when niv.nivel is  null then ra.NIVEL else niv.nivel end as nivel,
       null as idEstudianteAsignatura,ra.idMateriaTomada,maa.id_malla_asignatura,ra.idMateriaPlan,
       mal.id_malla,ra.idPlan,ra.materia,ra.creditosHora,ra.promedio,ra.asistencia,ra.estado,ra.tipo,ra.aprobado,
       case ra.aprobado when 'APROBADO' then 1 else 0 end aprobado,ra.periodo,null as idPeriodo,idPeriodo as idPeriodoAcademicoSw,maa.codigo_malla,'SISWEB' as origen,
       0 as promedio_final
from @recordSisWeb ra
         left join
     (select ma.id_malla_asignatura,rma.id_origen,rma.id_destino,ma.codigo_malla from migracion_sga..registros_migracion rma
                                                                                          inner join aca.malla_asignatura ma on ma.id_malla_asignatura = rma.id_destino

      where rma.id_entidad_relacion in (5,29)
        --agregue esta linea 06/2/2024 eliminar si afecta a los demas
        --se incluyo porque obtenia id de otras mallas y generaba duplicidad

     ) as maa on maa.id_origen = ra.idMateriaPlan or maa.id_destino in (36622,36623,36624,36625)

         left join
                (select n.id_nivel,rn.id_origen,rn.id_destino,n.descripcion as nivel from migracion_sga..registros_migracion rn
            left join aca.nivel n on n.id_nivel = rn.id_destino
            where rn.id_entidad_relacion in (6) ) as niv on niv.id_origen = ra.idNivel
            left join
                (select m.id_malla,m.tipo_plan,rm.id_origen,rm.id_destino from migracion_sga..registros_migracion rm
            inner join aca.malla m on m.id_malla = rm.id_destino
            where rm.id_entidad_relacion in (4) ) as mal on mal.id_origen = ra.idPlan


select * from aca.aspirantes_pregrado ap
where ap.id_periodo_academico = 23


select * from aca.oferta where id_tipo_oferta = 2
select * from [niv].[consultar_lista_inscritos_oferta_interes](138);

--estudiantes que pasan más de 15 creditos
begin
declare @idPeriodoAcademico int = 140
select distinct eo.id_estudiante_oferta,eo.id_oferta_modalidad,em.id_estudiante_matricula,d.nombre,o.descripcion,
                p.identificacion,p.apellidos,p.nombres,eo.numero_matricula,iif(m.tipo_plan='HORAS', sum(ma.num_horas), sum(ma.num_creditos)) as suma,pao.maximo_creditos
 from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
inner join man.departamentos d on d.id= do.id_departamento
inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
inner join aca.malla m on m.id_malla = ma.id_malla
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
inner join aca.componente_aprendizaje ca on ca.id_componente_aprendizaje =aa.id_componente_aprendizaje
inner join aca.componente_aprendizaje cap on cap.id_componente_aprendizaje= ca.id_componente_aprendizaje_padre
inner join aca.periodo_academico_oferta pao on pao.id_oferta_modalidad = om.id_oferta_modalidad and pao.id_periodo_academico = @idPeriodoAcademico
where ea.estado ='A' and em.estado='A' and ma.estado='A' and o.id_tipo_oferta = 2 and eo.estado ='A'
and cap.codigo='DOCENCIA'
--   and p.identificacion ='2400263915'
  and mg.id_periodo_academico = @idPeriodoAcademico
group by eo.id_estudiante_oferta,eo.id_oferta_modalidad,em.id_estudiante_matricula,d.nombre,o.descripcion,
                p.identificacion,p.apellidos,p.nombres,eo.numero_matricula,pao.maximo_creditos, m.tipo_plan
having iif(m.tipo_plan='HORAS', sum(ma.num_horas), sum(ma.num_creditos))>pao.maximo_creditos

-- order by sum(ma.num_creditos)
order by o.descripcion
end

--ESTUDIANTES MATRICULADOS EN D0S CARRERAS LA NUEVA Y LA VIEJA (PROCESO DE MOVILIDAD INTERNA)
select z.identificacion,z.estudiante,z.carreraDestino,z.carreraOrigen,z.nueva,z.horaNueva,z.VIEJA,z.horaVieja from (
select  iif(aux.id_estudiante_matricula is not null,'MATRICULADO EN CARRERA NUEVA','NO') AS nueva,
        iif(aux2.id_estudiante_matricula is not null,'MATRICULADO EN CARRERA VIEJA','NO') AS VIEJA,aux.fecha_ing horaNueva,aux2.fecha_ing as horaVieja,d.*
from [pro].[fn_list_All_Estudiantes_Postulantes_By_Oferta](null,30,null,null) as d
    left join ( select eo.id_persona,eo.id_oferta_modalidad,em.id_estudiante_matricula,em.fecha_ing from  aca.estudiante_oferta eo
                          inner join aca.estudiante_matricula em  on  eo.id_estudiante_oferta=em.id_estudiante_oferta
                          inner join aca.matricula_general mg  on mg.id_matricula_general=em.id_matricula_general
                                                            where em.estado='A' and mg.id_periodo_academico = 30
    ) as aux on aux.id_persona = d.idPersona and d.idOfertaModalidadNueva = aux.id_oferta_modalidad
    left join( select em.id_estudiante_matricula,em.id_estudiante_oferta,em.fecha_ing from  aca.estudiante_matricula em
                          inner join aca.matricula_general mg  on mg.id_matricula_general=em.id_matricula_general
                                                            where em.estado='A' and mg.id_periodo_academico = 30
    )as aux2 on aux2.id_estudiante_oferta = d.idEstudianteOferta
--   where d.codigoEstadoProceso ='A'
) as z
where z.nueva<>'NO' and z.vieja <>'NO'


--REPORTE DE ESTUDIANTES QUE TOMARON ASIGNATURAS QUE NO DEBIAN
select distinct om.id_oferta_modalidad,
d.nombre, o.descripcion,
                p.identificacion,p.apellidos,p.nombres,taemnl.nombreAsignatura,'NO CUMPLÍA LOS PRERREQUISITOS PARA VER LA ASIGNATURA'
from dbo.TEMP_asignaturas_en_matricula_no_licita_2 taemnl
inner join man.personas p on taemnl.idPersona=p.id
inner join aca.estudiante_oferta eo on taemnl.idEstudianteOferta=eo.id_estudiante_oferta
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.departamento_oferta do on o.id_oferta = do.id_oferta
inner join man.departamentos d on do.id_departamento = d.id
where om.id_oferta_modalidad not in  (91,92)
group by om.id_oferta_modalidad,d.nombre, o.descripcion, p.identificacion, p.apellidos, p.nombres,taemnl.nombreAsignatura
order by d.nombre,o.descripcion,taemnl.nombreAsignatura,p.apellidos,p.nombres

--MATRZI MATRICULA PERIODO
select distinct pa.codigo,1023 as codigo_institucion,o.codigo_ces as codigoCarrera,o.descripcion as carrera,c.descripcion as localidad,te.descripcion as tipoIdentificacion,
    p.identificacion,p.apellidos,p.apellidos,p.nombres,sum(ma.num_creditos) as totalCreditosAprobados,sum(ma.num_creditos)  as creditosAprobados,tm.descripcion,ea.id_paralelo,
    pa.codigo,12 as numeroSemanas,
    iif(ea.codigo_estado_matricula ='SEG','SI','NO') as repitiomateria,iif(ea.codigo_estado_matricula ='SEG',count(ea.id_estudiante_asignatura),0) as numeroRepetidas,
    0 as numeroRepetidasTercera,iif(eo.mantiene_gratuidad=1,'NO','SI') as perdidaGratuidad,'NO APLICA' AS PENSIONdiF,'NO APLICA' as planContingencia,0 as ingresoHogar,
    'NO REGISTRA' as origen,'SI' terminoPeriodo,sum(ma.num_horas) as totalHorasAprobadas,sum(ma.num_horas) as horasAprobadas,0 as ayudaEcono,0 as montoAcreditado,tee.descripcion

from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.malla m on m.id_malla = eo.id_malla
inner join man.tipo_identificacion te on te.id_tipo_identificacion = p.id_tipo_identificacion
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.tipo_matricula tm on tm.id_tipo_matricula = em.id_tipo_matricula
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
inner join man.departamentos d on d.id= do.id_departamento
inner join aca.campus c on c.id_campus = o.id_campus
 where p.estado='AC' and eo.estado='A' and om.estado='A' and em.estado = 'A' and tee.codigo in ('ACT','OFR','APR')
 and  mg.id_periodo_academico = 15 and eo.id_estudiante_oferta in (
         select eo.id_estudiante_oferta
    from aca.matricula_general mg
    inner join aca.estudiante_matricula em on em.id_matricula_general = mg.id_matricula_general
      inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
    inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    where mg.id_periodo_academico = 15
    and eo.estado='A' and em.estado='A'
    and mg.estado='A' and om.estado='A' and do.estado='A' and pa.estado='A' and ea.estado='A'
    group by pa.codigo,do.id_departamento_oferta,em.id_estudiante_matricula,eo.id_estudiante_oferta

     )
 --and em.estado='A'
group by pa.codigo,o.descripcion,o.codigo_ces,o.descripcion,c.descripcion,te.descripcion,p.identificacion,p.apellidos,p.nombres,tm.descripcion,
         ea.codigo_estado_matricula,eo.mantiene_gratuidad,ea.id_paralelo,tee.descripcion
 order by o.descripcion,p.apellidos,p.nombres

 select *  from aca.estudiante_calificacion

-- update man.personas set apellidos=UPPER(apellidos),nombres=upper(nombres)
select * from man.personas where apellidos like '%RAMIREZ ENDARA%'
select identificacion,nombres,apellidos,fecha_nace,id_estado_civil,id_pais_nacionalidad,id_provincia_nacionalidad,id_canton_nacionalidad,id_parroquia_residencia,celular
from man.personas where identificacion in ('1720147527')

select dd.*
--     update p set apellido_paterno = UPPER(dd.apellido_paterno), apellido_materno = UPPER(dd.apellido_materno)
from (
select
    d.identificacion,d.apellidos,d.nombres,d.cantidad_espacios,d.espacios_nombres,d.fecha_ing,d.fecha_mod,
case when d.apellido_paterno = d.apellidos then
    case
        when d.cantidad_espacios=2 then
            UPPER(SUBSTRING(d.apellidos,0, CHARINDEX(' ', d.apellidos, CHARINDEX(' ', d.apellidos) + 1)))
        when d.cantidad_espacios in (3,5) then
            UPPER(SUBSTRING(d.apellidos,0 ,CHARINDEX(' ', d.apellidos,CHARINDEX(' ', d.apellidos, CHARINDEX(' ', d.apellidos) + 1) + 1)))
    else UPPER(d.apellido_paterno)
end
else UPPER(d.apellido_paterno)
end as apellido_paterno,
case when d.apellido_materno = '' or d.apellido_materno = d.apellidos then
        case
            when d.cantidad_espacios=2 then
                UPPER(SUBSTRING(d.apellidos, CHARINDEX(' ', d.apellidos, CHARINDEX(' ', d.apellidos) + 1) + 1, LEN(d.apellidos)))
            when d.cantidad_espacios in (3,5)  then
                      UPPER(SUBSTRING(d.apellidos, CHARINDEX(' ', d.apellidos,CHARINDEX(' ', d.apellidos, CHARINDEX(' ', d.apellidos) + 1) + 1) + 1, LEN(d.apellidos)))
            else UPPER(d.apellido_materno)
            end
    else UPPER(d.apellido_materno)
end as apellido_materno--,d.apellido_materno as ap_mat2
from (
SELECT identificacion,apellidos,nombres,LEN(apellidos) - LEN(REPLACE(apellidos, ' ', '')) AS cantidad_espacios,fecha_ing,fecha_mod,
       LEN(nombres) - LEN(REPLACE(nombres, ' ', '')) as espacios_nombres,
    CASE
        when LEN(apellidos) - LEN(REPLACE(apellidos, ' ', ''))=1 then
            SUBSTRING(apellidos, 1, CHARINDEX(' ', apellidos) - 1)
        WHEN CHARINDEX(' ', apellidos) > 0 THEN
            CASE
                WHEN apellidos LIKE '% DE LA %' THEN SUBSTRING(apellidos, 1, CHARINDEX(' DE LA ', apellidos) - 1)
                WHEN apellidos LIKE '% DE LA ' THEN SUBSTRING(apellidos, 1, CHARINDEX(' DE LA ', apellidos) - 1)
                WHEN apellidos LIKE '% DEL %' THEN SUBSTRING(apellidos, 1, CHARINDEX(' DEL ', apellidos) - 1)
                WHEN apellidos LIKE '% DEL ' THEN SUBSTRING(apellidos, 1, CHARINDEX(' DEL ', apellidos) - 1)
                WHEN apellidos LIKE '% DE %' THEN SUBSTRING(apellidos, 1, CHARINDEX(' DE ', apellidos) - 1)
                WHEN apellidos LIKE '% DE ' THEN SUBSTRING(apellidos, 1, CHARINDEX(' DE ', apellidos) - 1)
                WHEN apellidos LIKE '% SAN %' THEN SUBSTRING(apellidos, 1, CHARINDEX(' SAN ', apellidos) - 1)
                WHEN apellidos LIKE '% SAN ' THEN SUBSTRING(apellidos, 1, CHARINDEX(' SAN ', apellidos) - 1)
                WHEN apellidos LIKE '% DE LOS %' THEN SUBSTRING(apellidos, 1, CHARINDEX(' DE LOS ', apellidos) - 1)
                WHEN apellidos LIKE '% DE LOS ' THEN SUBSTRING(apellidos, 1, CHARINDEX(' DE LOS ', apellidos) - 1)
                WHEN apellidos LIKE '% DI %' THEN SUBSTRING(apellidos, 1, CHARINDEX(' DI ', apellidos) - 1)
                WHEN apellidos LIKE '% DI ' THEN SUBSTRING(apellidos, 1, CHARINDEX(' DI ', apellidos) - 1)
                ELSE apellidos
                END
        ELSE apellidos
    END AS apellido_paterno,
    CASE
        when LEN(apellidos) - LEN(REPLACE(apellidos, ' ', ''))=1 then
            SUBSTRING(apellidos, CHARINDEX(' ', apellidos) + 1, LEN(apellidos) - CHARINDEX(' ', apellidos))
        WHEN CHARINDEX(' ', apellidos) > 0 THEN
            CASE
                WHEN apellidos LIKE '% DE LA %' THEN SUBSTRING(apellidos, CHARINDEX('DE LA ', apellidos), LEN(apellidos) - CHARINDEX('DE LA ', apellidos) + 1)
                WHEN apellidos LIKE '% DE LA ' THEN SUBSTRING(apellidos, CHARINDEX('DE LA ', apellidos) , LEN(apellidos) - CHARINDEX('DE LA ', apellidos) + 1)
                WHEN apellidos LIKE '% DEL %' THEN SUBSTRING(apellidos, CHARINDEX('DEL ', apellidos), LEN(apellidos) - CHARINDEX('DEL ', apellidos) + 1)
                WHEN apellidos LIKE '% DEL ' THEN SUBSTRING(apellidos, CHARINDEX('DEL ', apellidos) , LEN(apellidos) - CHARINDEX('DEL ', apellidos) + 1)
                WHEN apellidos LIKE '% DE %' THEN SUBSTRING(apellidos, CHARINDEX('DE ', apellidos), LEN(apellidos) - CHARINDEX('DE ', apellidos) + 1)
                WHEN apellidos LIKE '% DE ' THEN SUBSTRING(apellidos, CHARINDEX('DE ', apellidos) , LEN(apellidos) - CHARINDEX('DE ', apellidos) + 1)
                WHEN apellidos LIKE '% SAN %' THEN SUBSTRING(apellidos, CHARINDEX('SAN ', apellidos), LEN(apellidos) - CHARINDEX('SAN ', apellidos) + 1)
                WHEN apellidos LIKE '% SAN ' THEN SUBSTRING(apellidos, CHARINDEX('SAN ', apellidos) , LEN(apellidos) - CHARINDEX('SAN ', apellidos) + 1)
                WHEN apellidos LIKE '% DE LOS %' THEN SUBSTRING(apellidos, CHARINDEX('DE LOS ', apellidos), LEN(apellidos) - CHARINDEX('DE LOS ', apellidos) + 1)
                WHEN apellidos LIKE '% DE LOS ' THEN SUBSTRING(apellidos, CHARINDEX('DE LOS ', apellidos) , LEN(apellidos) - CHARINDEX('DE LOS ', apellidos) + 1)
                WHEN apellidos LIKE '% DI %' THEN SUBSTRING(apellidos, CHARINDEX('DI ', apellidos), LEN(apellidos) - CHARINDEX('DI ', apellidos) + 1)
                WHEN apellidos LIKE '% DI ' THEN SUBSTRING(apellidos, CHARINDEX('DI ', apellidos) , LEN(apellidos) - CHARINDEX('DI ', apellidos) + 1)
                ELSE ''
            END
    ELSE ''
    END AS apellido_materno
FROM man.personas-- where LEN(apellidos) - LEN(REPLACE(apellidos, ' ', ''))>1
    ) as d
-- order by d.apellidos,d.nombres
) as dd
inner join man.personas p on p.identificacion = dd.identificacion
where p.apellido_paterno is null and p.apellido_materno is null
--
--   and  dd.espacios_nombres>2
--    and dd.cantidad_espacios>2 --and
--   (cast(dd.fecha_ing as date)>='2024-06-18' or cast(dd.fecha_mod as date)>='2024-06-18' )
    --  --and p.identificacion in ('0930823073','0930824073')
--     and p.identificacion in ('2400208613','2450303389')
--   and   p.apellidos like '%castro gonz%'


select id_periodo_academico,codigo,descripcion,fecha_ing from aca.periodo_academico where id_tipo_oferta= 2


select * from man.lugar where sub_tipo = 3

select * from man.personas where identificacion in ('0913401014','0912926342')
select * from aca.campus
select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 1

exec [aca].[sp_rpt_comprobante_matricula_estudiante] 136735 , null

exec [aca].[sp_rpt_comprobante_matricula_estudiante] 152416,null

select * from  [aca].[fn_record_academico_sga_definitivo](65131,null,null,1) as d


select * from man.personas where identificacion in ('45137761',
'33494348',
'40919386',
'31426677',
'47194606')
--SABER EL NIVEL DE FORMACION DE LAS PERSONAS
select  TOP 1 tte.descripcion from man.personas p
inner join man.informacion_academica_persona iap on iap.id_persona =p.id
inner join aca.institucion ins on ins.id_institucion = iap.id_institucion
inner join aca.tipo_institucion tte on tte.id_tipo_institucion = ins.id_tipo_institucion
where iap.id_nivel_formacion =2 and iap.estado='A' and p.identificacion in ('0928125723','2450507849')
group by p.identificacion, p.apellidos, p.nombres, ins.descripcion, tte.descripcion




--matriculas retiradas con cabecera activa
select distinct d.* from (
select p1.identificacion,om1.carrera,pa.codigo,eo1.id_estudiante_oferta,ea1.id_estudiante_matricula,em1.estado,	sum(CASE WHEN ea1.estado = 'R' THEN 1 ELSE 0 END) AS total_retirados,
       sum(CASE WHEN ea1.estado = 'P' THEN 1 ELSE 0 END) AS total_anulados,sum(CASE WHEN ea1.estado = 'T' THEN 1 ELSE 0 END) AS total_retirados_total,
       sum(CASE WHEN ea1.estado = 'X' THEN 1 ELSE 0 END) AS total_anulados_total,count(ea1.id_estudiante_asignatura) as total from aca.estudiante_matricula em1
inner join aca.matricula_general mg on em1.id_matricula_general = mg.id_matricula_general
inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
inner join man.personas p1 on p1.id = eo1.id_persona
inner join aca.ofertas_facultad om1 on eo1.id_oferta_modalidad = om1.id_oferta_modalidad
inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma1 on aa1.id_malla_asignatura = ma1.id_malla_asignatura
where em1.estado<>'I' and om1.id_tipo_oferta =2
group by eo1.id_estudiante_oferta,ea1.id_estudiante_matricula, em1.estado,p1.identificacion,pa.codigo,om1.carrera
) as d
inner join aca.estudiante_matricula em on em.id_estudiante_matricula = d.id_estudiante_matricula
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
-- where d.estado in ('R')
--     and d.total_anulados>0 and d.total_anulados_total=d.total
--   and d.total_retirados>0 and d.total_retirados=d.total
--     and d.total_retirados_total>0 --and em.estado='A'
and em.id_estudiante_matricula in (207737,206579,209384,204469,209156)
--   and ma1.id_nivel = 1


select ea.id_estudiante_matricula,da.*--,row_number() over (PARTITION BY ea.id_estudiante_matricula order by da.fecha_ing) as indice
from man.documentos_archivos da
         inner join aca.estudiante_asignatura ea on ea.id_estudiante_asignatura = da.id_number
         where table_name in ('aca_estudiante_matricula')
--            and ea.id_estudiante_matricula in (171533,
--              158053,170991,155752,156605,170345,171514,170701,155824,170347,170614,158693,169206,157696,137912,
-- 136509,171467,159125,161242,164585,170777,167795,169235,179515,163866,159368,156995,159650,168571,165628,163054,
-- 168927,168737,170964,170454,179544,165259,170430,171469,169429)
and da.id_documento_archivo in (13722,13742,19908,20615,19850,21925,20080,
19930,20635,21904,21847,21862,21570,21857,21832,21521,19995,21837,21688,21918,19999,21842,19232,
21913,19705,19843,20620,20094,19992,20640,20610,21526,19991,19860,20081,20092,20625,19911,21852,19989)

select * from aca.estudiante_matricula em where em.id_estudiante_matricula in (136509,    137912,155752,155824,
156605,156995,157696,158053,158693,159125,159368,159650,161242,163054,163866,164585,165259,165628,167795,168571,
168737,168927,169206,169235,169429,170345,170347,170430,170454,170614,170701,170777,170964,170991,171467,171469,
171514,171533,179515,179544 )

select * from aca.estudiante_asignatura em where em.id_estudiante_matricula in (136509,    137912,155752,155824,
                                                                               156605,156995,157696,158053,158693,159125,159368,159650,161242,163054,163866,164585,165259,165628,167795,168571,
                                                                               168737,168927,169206,169235,169429,170345,170347,170430,170454,170614,170701,170777,170964,170991,171467,171469,
                                                                               171514,171533,179515,179544 )



select top 1 * from man.documentos_archivos da where table_name in ('aca_estudiante_matricula')


select p.identificacion , p.nombres, p.apellidos,ac.codigo_acciones_afirmativas,i.id_periodo_academico
from niv.inscripcion_nivelacion i
inner join niv.inscripcion_acciones_afirmativas iaff on iaff.id_inscripcion=i.id_inscripcion_nivelacion and iaff.estado='A'
inner join niv.acciones_afirmativa ac on ac.id_acciones_afirmativas=iaff.id_acciones_afirmativas and ac.estado='A'
inner join man.personas p on p.id=i.id_persona
where i.estado='A' and p.estado='AC' and id_periodo_academico=28

select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta in (1,2)
and codigo in ('2023-1','2023-2')

--LISTADO DE ESTUDIANTES POR NIVEL
begin
declare @id_periodo_academicon int = 30
select row_number() over (order by d.estudiante) as indice,d.* from (
    select concat(p.apellidos,' ',p.nombres) as estudiante,p.identificacion, eo.numero_matricula,
           d.nombre as facultad,o.descripcion as carrera,
           [aca].[fn_semestre_activo_estudiante] (eo.id_estudiante_oferta,@id_periodo_academicon) as curso,
           (select top (1) niv.orden as semestre
             from aca.matricula_general mg
             inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
             inner join aca.estudiante_oferta eo on em1.id_estudiante_oferta = eo.id_estudiante_oferta
             inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
             inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
             inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
             where   mg.id_periodo_academico = @id_periodo_academicon and eo.id_estudiante_oferta = em.id_estudiante_oferta
             and eo.estado='A' and em1.estado='A' and ea.estado='A'
             and mg.estado='A'   and aa.estado='A'
             and ma.estado='A' and niv.estado='A'
             group by em1.id_estudiante_matricula,niv.descripcion_corta ,niv.ORDEN,par.descripcion_corta,par.orden
             order by  count (ea.id_asignatura_aprendizaje) desc,count (par.descripcion_corta) desc) as nivel
    from aca.matricula_general mg
    inner join aca.estudiante_matricula em on em.id_matricula_general = mg.id_matricula_general
    inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
    inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join man.personas p on p.id = eo.id_persona
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.oferta o on o.id_oferta = om.id_oferta
    inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
    inner join man.departamentos d on do.id_departamento = d.id
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    where mg.id_periodo_academico = @id_periodo_academicon
    and eo.estado='A' and em.estado='A'
    and mg.estado='A' and om.estado='A' and do.estado='A' and pa.estado='A' and ea.estado='A'
    group by p.identificacion, p.apellidos, p.nombres, eo.numero_matricula, d.nombre, o.descripcion, eo.id_estudiante_oferta, em.id_estudiante_oferta
--     order by p.apellidos, p.nombres
    ) as d
--          where d.nivel>=3
order by d.estudiante
end


--MATRICULADOS EN PRIMER SEMESTRE
declare @pi_id_periodo_academico int = 30
select * from (
select dep.nombre as facultad,
o.descripcion as oferta, m.descripcion as modalidad, omo.id_oferta_modalidad ,
p.identificacion,p.nombres,p.apellidos,isnull(p.email_institucional,'') as email_institucional,
isnull(p.email_personal,'') as email_personal,p.fecha_nace,isnull(p.sexo,'') as sexo,
isnull(ec.descripcion ,'')as estado_civil,isnull(n.descripcion ,'')as nacionalidad,
isnull(provNac.descripcion,'') as prov_nac,isnull(cantNac.descripcion,'') as canton_nac,
isnull (parrNac.descripcion,'') as parr_nac,isnull(paisNac.descripcion,'') as pais_origen,
isnull(provRes.descripcion,'') as prov_reside,isnull(cantRes.descripcion,'') as canton_reside,
isnull(parrRes.descripcion,'') as parr_reside,isnull(p.barrio,'') as barrio,isnull(p.direccion,'') as direccion,
isnull(p.telefono,'')as telefono,isnull(p.celular,'') as celular,
isnull(p.email_institucional,'') as email_inst,eo.numero_matricula,
em.fecha_ingreso as fecha_matricula,
(select [aca].[fn_semestre_activo_estudiante](eo.id_estudiante_oferta,mg.id_periodo_academico)) as denominacion,
(select top (1) niv.orden as semestre
             from aca.matricula_general mg
             inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
             inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
             inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
             inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
             inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
             where   mg.id_periodo_academico = @pi_id_periodo_academico and eo1.id_estudiante_oferta = eo.id_estudiante_oferta
             and eo1.estado='A' and em1.estado='A' and ea.estado='A'
             and mg.estado='A'   and aa.estado='A'
             and ma.estado='A' and niv.estado='A'
             group by em1.id_estudiante_matricula,niv.descripcion_corta ,niv.ORDEN,par.descripcion_corta,par.orden
             order by  count (ea.id_asignatura_aprendizaje) desc,count (par.descripcion_corta) desc) as nivel
,null as fecha_graduacion,0 as calificacion,

isnull((STUFF((select char(10)+ isNULL(ta.descripcion,iap.otro_titulo)
	from man.informacion_academica_persona iap
 left join aca.institucion ins on ins.id_institucion=iap.id_institucion and ins.estado='A'
 left join aca.titulos_academicos ta on ta.id_titulo_academico=iap.id_titulo_academico and ta.estado='A'
 left join aca.nivel_formacion nf on ta.id_nivel_formacion=nf.id_nivel_formacion and nf.estado='A'
	where   iap.id_persona=p.id and iap.estado='A'

 	 for xml path ('')),1,1,'')),'NO REGISTRA') as titulo_academico ,
	isNULL( (STUFF((select char(10)+ isnull(ins.descripcion,iap.otra_institucion)
	from man.informacion_academica_persona iap
 left join aca.institucion ins on ins.id_institucion=iap.id_institucion and ins.estado='A'
 left join aca.titulos_academicos ta on ta.id_titulo_academico=iap.id_titulo_academico and ta.estado='A'
 left join aca.nivel_formacion nf on ta.id_nivel_formacion=nf.id_nivel_formacion and nf.estado='A'
	where   iap.id_persona=p.id and iap.estado='A'

 	 for xml path ('')),1,1,'')),'NO REGISTRA') as NOMBRE ,
 --case when ta.descripcion is null or ta.descripcion='' then  'NO REGISTRADO' else ta.descripcion end as titulo_academico,
--case when ins.descripcion is null or ins.descripcion='' then  'NO REGISTRADO' else ins.descripcion end as NOMBRE,
-- 0 as id_titulo_academico,
ISNULL(et.descripcion,'') as etnia,
--case  when dis.descripcion is not null then concat(isnull(dis.descripcion, ''), ' ',cast(isnull(p.porcentaje_dis, 0) as varchar(20)))
--               else cast (p.id_discapacidad as varchar(250) ) end
isnull(p.porcentaje_dis, 0)as discapacidad
,
case  when p.num_carnet_conadis is not null then concat(isnull(dis.descripcion, ''), ' ',cast(isnull(p.num_carnet_conadis,'') as varchar(20)))
              else isnull(p.num_carnet_conadis,'') end
as num_carnet_conadis,tm.descripcion as tipo_matricula, tm.codigo as codigo_tipo_matricula,
case when (select MIN(ea.codigo_estado_matricula) from  aca.estudiante_asignatura ea
where ea.id_estudiante_matricula=em.id_estudiante_matricula and ea.estado='A')='PRI' THEN '1 VEZ'
WHEN (select MIN(ea.codigo_estado_matricula) from  aca.estudiante_asignatura ea
where ea.id_estudiante_matricula=em.id_estudiante_matricula and ea.estado='A')='SEG' THEN '2 VEZ' ELSE '' END numVez
 from aca.matricula_general mg
 inner join aca.estudiante_matricula em on em.id_matricula_general = mg.id_matricula_general
 inner join aca.tipo_matricula tm on em.id_tipo_matricula=tm.id_tipo_matricula
 inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
 inner join aca.oferta_modalidad omo on eo.id_oferta_modalidad=omo.id_oferta_modalidad
 inner join aca.modalidad m on omo.id_modalidad=m.id_modalidad
 inner join aca.oferta o on omo.id_oferta=o.id_oferta
 inner join aca.departamento_oferta dof on dof.id_oferta=o.id_oferta
 inner join man.departamentos dep on  dof.id_departamento=dep.id
 inner join man.personas p on eo.id_persona=p.id
 left join man.estado_civil ec on p.id_estado_civil=ec.id_estado_civil  and ec.estado='A'
 left join man.nacionalidad n on p.id_nacionalidad =n.id_nacionalidad and n.estado='A'
 left join man.lugar provRes on  p.id_provincia_residencia=provRes.id_lugar and provRes.estado='A'
 left join man.lugar cantRes on  p.id_canton_residencia=cantRes.id_lugar and cantRes.estado='A'
 left join man.lugar parrRes on p.id_parroquia_residencia=parrRes.id_lugar  and parrRes.estado='A'
 left join man.lugar provNac on  p.id_provincia_nacionalidad=provNac.id_lugar  and provNac.estado='A'
 left join man.lugar cantNac on  p.id_canton_nacionalidad=cantNac.id_lugar and cantNac.estado='A'
 left join man.lugar parrNac on p.id_parroquia_nacionalidad=parrNac.id_lugar  and parrNac.estado='A'
 left join man.lugar paisNac on p.id_pais_nacionalidad=paisNac.id_lugar    and paisNac.estado='A'
  LEFT join man.discapacidad dis on p.id_discapacidad=dis.id_discapacidad -- and dis.estado='A'

 left join man.etnia et on et.id_etnia=p.id_etnia and et.estado='A'
 inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
 inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
 inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
 inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
 inner join aca.nivel niv on ma.id_nivel=niv.id_nivel

 inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
 where mg.id_periodo_academico =@pi_id_periodo_academico
 and eo.estado='A' and em.estado='A' and ea.estado='A' --and niv.id_nivel>1
 and mg.estado='A' and omo.estado='A' 	and pa.estado='A'   and par.estado='A' and aa.estado='A'
 and ma.estado='A' and niv.estado='A'  and tm.estado='A' -- AND tm.codigo not in ('ESP')
 group by p.identificacion,p.nombres,p.apellidos,p.email_institucional,p.email_personal,p.fecha_nace,p.sexo,
ec.descripcion ,n.descripcion ,
provNac.descripcion ,cantNac.descripcion ,parrNac.descripcion ,paisNac.descripcion ,
provRes.descripcion ,cantRes.descripcion ,parrRes.descripcion
,p.barrio,p.direccion,p.telefono,p.celular,p.email_institucional,
 eo.numero_matricula,em.fecha_ingreso  ,--par.descripcion_corta,niv.descripcion_corta,niv.id_nivel,
--ins.descripcion  ,ta.id_titulo_academico  ,iap.fecha_graduacion,iap.calificacion,
et.descripcion  ,p.porcentaje_dis  ,p.num_carnet_conadis,dis.descripcion,p.id_discapacidad,
o.descripcion , m.descripcion , omo.id_oferta_modalidad ,dep.nombre,tm.descripcion , tm.codigo --,aux.denominacion,aux.orden
,em.id_estudiante_matricula,p.id ,eo.id_estudiante_oferta,mg.id_periodo_academico,eo.vez_proyectada--,iap.id_informacion_academica_persona
-- order by dep.nombre,o.descripcion,P.apellidos
) as d
         where d.nivel = 1
order by d.facultad,d.oferta,d.apellidos,d.nombres



--MATRICULADOS EN 2023-1 QUE EGRESARON (COMPLETARON LA MALLA)  1005 totales   604 egresados -1 -49
begin
declare @pi_id_periodo_academico int = 27
select * from (
select eo.id_estudiante_oferta,eo.id_malla,dep.nombre as facultad,
o.descripcion as oferta, m.descripcion as modalidad, omo.id_oferta_modalidad ,
p.identificacion,p.nombres,p.apellidos,isnull(p.email_institucional,'') as email_institucional,
isnull(p.email_personal,'') as email_personal,p.fecha_nace,isnull(p.sexo,'') as sexo,
isnull(ec.descripcion ,'')as estado_civil,isnull(n.descripcion ,'')as nacionalidad,
isnull(provNac.descripcion,'') as prov_nac,isnull(cantNac.descripcion,'') as canton_nac,
isnull (parrNac.descripcion,'') as parr_nac,isnull(paisNac.descripcion,'') as pais_origen,
isnull(provRes.descripcion,'') as prov_reside,isnull(cantRes.descripcion,'') as canton_reside,
isnull(parrRes.descripcion,'') as parr_reside,isnull(p.barrio,'') as barrio,isnull(p.direccion,'') as direccion,
isnull(p.telefono,'')as telefono,isnull(p.celular,'') as celular,
isnull(p.email_institucional,'') as email_inst,eo.numero_matricula,
em.fecha_ingreso as fecha_matricula,
(select [aca].[fn_semestre_activo_estudiante](eo.id_estudiante_oferta,mg.id_periodo_academico)) as denominacion,
(select top (1) niv.orden as semestre
             from aca.matricula_general mg
             inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
             inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
             inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
             inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
             inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
             where   mg.id_periodo_academico = @pi_id_periodo_academico and eo1.id_estudiante_oferta = eo.id_estudiante_oferta
             and eo1.estado='A' and em1.estado='A' and ea.estado='A'
             and mg.estado='A'   and aa.estado='A'
             and ma.estado='A' and niv.estado='A'
             group by em1.id_estudiante_matricula,niv.descripcion_corta ,niv.ORDEN,par.descripcion_corta,par.orden
             order by  count (ea.id_asignatura_aprendizaje) desc,count (par.descripcion_corta) desc) as nivel,
   ( select count(ma1.id_malla_asignatura)
             from aca.estudiante_oferta eo1
             inner join aca.malla m1 on m1.id_malla=eo1.id_malla
             inner join aca.malla_asignatura ma1 on m1.id_malla=ma1.id_malla
             inner join aca.nivel niv1 on ma1.id_nivel=niv1.id_nivel
             where  eo1.id_estudiante_oferta = eo.id_estudiante_oferta and niv1.id_nivel = (select mm1.id_nivel_max_aperturado from aca.malla mm1 where mm1.id_malla = eo.id_malla)
             and eo1.estado='A' and ma1.estado='A' and niv1.estado='A'
             group by ma1.id_malla) as numeroMateriasOctavo
,
(select count(*) from [aca].[fn_record_academico_sga_definitivo](eo.id_estudiante_oferta,8,null,1)) as AprobadasOctavo,
null as fecha_graduacion,0 as calificacion,

isnull((STUFF((select char(10)+ isNULL(ta.descripcion,iap.otro_titulo)
	from man.informacion_academica_persona iap
 left join aca.institucion ins on ins.id_institucion=iap.id_institucion and ins.estado='A'
 left join aca.titulos_academicos ta on ta.id_titulo_academico=iap.id_titulo_academico and ta.estado='A'
 left join aca.nivel_formacion nf on ta.id_nivel_formacion=nf.id_nivel_formacion and nf.estado='A'
	where   iap.id_persona=p.id and iap.estado='A'

 	 for xml path ('')),1,1,'')),'NO REGISTRA') as titulo_academico ,
	isNULL( (STUFF((select char(10)+ isnull(ins.descripcion,iap.otra_institucion)
	from man.informacion_academica_persona iap
 left join aca.institucion ins on ins.id_institucion=iap.id_institucion and ins.estado='A'
 left join aca.titulos_academicos ta on ta.id_titulo_academico=iap.id_titulo_academico and ta.estado='A'
 left join aca.nivel_formacion nf on ta.id_nivel_formacion=nf.id_nivel_formacion and nf.estado='A'
	where   iap.id_persona=p.id and iap.estado='A'

 	 for xml path ('')),1,1,'')),'NO REGISTRA') as NOMBRE ,
ISNULL(et.descripcion,'') as etnia,
isnull(p.porcentaje_dis, 0)as discapacidad,
case  when p.num_carnet_conadis is not null then concat(isnull(dis.descripcion, ''), ' ',cast(isnull(p.num_carnet_conadis,'') as varchar(20)))
              else isnull(p.num_carnet_conadis,'') end
as num_carnet_conadis,tm.descripcion as tipo_matricula, tm.codigo as codigo_tipo_matricula,
case when (select MIN(ea.codigo_estado_matricula) from  aca.estudiante_asignatura ea
where ea.id_estudiante_matricula=em.id_estudiante_matricula and ea.estado='A')='PRI' THEN '1 VEZ'
WHEN (select MIN(ea.codigo_estado_matricula) from  aca.estudiante_asignatura ea
where ea.id_estudiante_matricula=em.id_estudiante_matricula and ea.estado='A')='SEG' THEN '2 VEZ' ELSE '' END numVez
 from aca.matricula_general mg
 inner join aca.estudiante_matricula em on em.id_matricula_general = mg.id_matricula_general
 inner join aca.tipo_matricula tm on em.id_tipo_matricula=tm.id_tipo_matricula
 inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
 inner join aca.oferta_modalidad omo on eo.id_oferta_modalidad=omo.id_oferta_modalidad
 inner join aca.modalidad m on omo.id_modalidad=m.id_modalidad
 inner join aca.oferta o on omo.id_oferta=o.id_oferta
 inner join aca.departamento_oferta dof on dof.id_oferta=o.id_oferta
 inner join man.departamentos dep on  dof.id_departamento=dep.id
 inner join man.personas p on eo.id_persona=p.id
 left join man.estado_civil ec on p.id_estado_civil=ec.id_estado_civil  and ec.estado='A'
 left join man.nacionalidad n on p.id_nacionalidad =n.id_nacionalidad and n.estado='A'
 left join man.lugar provRes on  p.id_provincia_residencia=provRes.id_lugar and provRes.estado='A'
 left join man.lugar cantRes on  p.id_canton_residencia=cantRes.id_lugar and cantRes.estado='A'
 left join man.lugar parrRes on p.id_parroquia_residencia=parrRes.id_lugar  and parrRes.estado='A'
 left join man.lugar provNac on  p.id_provincia_nacionalidad=provNac.id_lugar  and provNac.estado='A'
 left join man.lugar cantNac on  p.id_canton_nacionalidad=cantNac.id_lugar and cantNac.estado='A'
 left join man.lugar parrNac on p.id_parroquia_nacionalidad=parrNac.id_lugar  and parrNac.estado='A'
 left join man.lugar paisNac on p.id_pais_nacionalidad=paisNac.id_lugar    and paisNac.estado='A'
 LEFT join man.discapacidad dis on p.id_discapacidad=dis.id_discapacidad -- and dis.estado='A'
 left join man.etnia et on et.id_etnia=p.id_etnia and et.estado='A'
 inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
 inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
 inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
 inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
 inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
 inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
 where mg.id_periodo_academico =@pi_id_periodo_academico
 and eo.estado='A' and em.estado='A' and ea.estado='A' --and niv.id_nivel>1
 and mg.estado='A' and omo.estado='A' 	and pa.estado='A'   and par.estado='A' and aa.estado='A'
 and ma.estado='A' and niv.estado='A'  and tm.estado='A' -- AND tm.codigo not in ('ESP')
 group by p.identificacion,p.nombres,p.apellidos,p.email_institucional,p.email_personal,p.fecha_nace,p.sexo,
ec.descripcion ,n.descripcion ,
provNac.descripcion ,cantNac.descripcion ,parrNac.descripcion ,paisNac.descripcion ,
provRes.descripcion ,cantRes.descripcion ,parrRes.descripcion
,p.barrio,p.direccion,p.telefono,p.celular,p.email_institucional,
 eo.numero_matricula,em.fecha_ingreso,
et.descripcion  ,p.porcentaje_dis  ,p.num_carnet_conadis,dis.descripcion,p.id_discapacidad,eo.id_malla,
o.descripcion , m.descripcion , omo.id_oferta_modalidad ,dep.nombre,tm.descripcion , tm.codigo --,aux.denominacion,aux.orden
,em.id_estudiante_matricula,p.id ,eo.id_estudiante_oferta,mg.id_periodo_academico,eo.vez_proyectada--,iap.id_informacion_academica_persona
-- order by dep.nombre,o.descripcion,P.apellidos
) as d
         where d.nivel = (select mm.id_nivel_max_aperturado from aca.malla mm where mm.id_malla = d.id_malla)
         and d.numeroMateriasOctavo = d.AprobadasOctavo
         and d.identificacion not in (
select p.identificacion
             from aca.matricula_general mg
             inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
             inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
            inner join man.personas p on p.id = eo1.id_persona
             inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
             inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
             inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
             where   mg.id_periodo_academico = 30
             and eo1.estado='A' and em1.estado='A' and ea.estado='A'
             and mg.estado='A'   and aa.estado='A'
             and ma.estado='A' and niv.estado='A'
            group by p.identificacion,p.apellidos,p.nombres)
order by d.facultad,d.oferta,d.apellidos,d.nombres
end
-- 2400017535
--ASIGNATURAS DE LAS MALLA DE NIVELACION
select o.descripcion as Carrera,mo.descripcion as Modalidad,a.descripcion as asignatura,ma.num_creditos,ma.num_horas from aca.malla m
inner join aca.malla_asignatura ma on ma.id_malla = m.id_malla
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = m.id_oferta_modalidad
inner join aca.modalidad mo on om.id_modalidad = mo.id_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.periodo_academico_oferta pao on pao.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.planificacion_paralelo pp on pp.id_malla_asignatura = ma.id_malla_asignatura and pp.id_periodo_academico = pao.id_periodo_academico
where m.estado in ('A','P') and ma.estado='A' and pao.id_periodo_academico = 32 and pao.estado='A' AND pp.estado='A'
group by o.descripcion,a.descripcion, mo.descripcion, ma.num_creditos, ma.num_horas
order by o.descripcion,a.descripcion



--NUMERO DE APRPBADOS Y REPROBADOS POR PERIODO Y ASIGNATURA 38
begin
declare @pi_id_perido_academico int = 35 , @departamento int = null,@id_oferta_modalidad int = null
select departamento, oferta,id_malla_asignatura, asignatura ,nivel,id_paralelo,paralelo,MAX([true])+ISNULL(MAX([false]),0) AS MATRICULADOS,
       MAX([true]) AS APROBADO,ISNULL(MAX([false]),0) AS REPROBADO,
       (select count(eas.id_estudiante_asignatura)
	from aca.asignatura_aprendizaje aap
	inner join aca.estudiante_asignatura eas on eas.id_asignatura_aprendizaje = aap.id_asignatura_aprendizaje
	inner join aca.paralelo p on eas.id_paralelo=p.id_paralelo
	inner join aca.estudiante_matricula ema on ema.id_estudiante_matricula = eas.id_estudiante_matricula
	inner join aca.matricula_general mg on mg.id_matricula_general = ema.id_matricula_general
	inner join aca.estudiante_oferta eo on ema.id_estudiante_oferta=eo.id_estudiante_oferta
	where mg.id_periodo_academico = @pi_id_perido_academico  and aap.id_malla_asignatura = PivotTable.id_malla_asignatura
	  and eas.id_paralelo = PivotTable.id_paralelo
	and aap.estado='A' AND eas.estado in ('R') and p.estado='A' and ema.estado='A' and mg.estado='A')AS RETIRADOS,
           (select count(eas.id_estudiante_asignatura)
	from aca.asignatura_aprendizaje aap
	inner join aca.estudiante_asignatura eas on eas.id_asignatura_aprendizaje = aap.id_asignatura_aprendizaje
	inner join aca.paralelo p on eas.id_paralelo=p.id_paralelo
	inner join aca.estudiante_matricula ema on ema.id_estudiante_matricula = eas.id_estudiante_matricula
	inner join aca.matricula_general mg on mg.id_matricula_general = ema.id_matricula_general
	inner join aca.estudiante_oferta eo on ema.id_estudiante_oferta=eo.id_estudiante_oferta
	where mg.id_periodo_academico = @pi_id_perido_academico  and aap.id_malla_asignatura = PivotTable.id_malla_asignatura
	  and eas.id_paralelo = PivotTable.id_paralelo
	and aap.estado='A' AND eas.estado in ('X') and p.estado='A' and ema.estado='X' and mg.estado='A')AS ANULADOS
from
(
select d.nombre as departamento,
                      o.descripcion as oferta, ma.id_malla_asignatura,a.descripcion as asignatura,n.descripcion_corta as nivel,
                      concat(n.descripcion_corta,'/',par.descripcion_corta) as paralelo,par.id_paralelo, ea.aprobado
                      , cast (avg( ea.promedio) as decimal(10,2)) as promedio
                        , count( ea.id_estudiante_asignatura) as cantidad

            from man.personas p
            inner join aca.estudiante_oferta eo on eo.id_persona = p.id
            inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
            inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
            inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
            inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
            inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
            inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
            inner join aca.oferta o on o.id_oferta = om.id_oferta
            inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
            inner join man.departamentos d on d.id = do.id_departamento
            inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje=ea.id_asignatura_aprendizaje
            inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
            inner join aca.asignatura a on ma.id_asignatura=a.id_asignatura
            inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
            inner join aca.nivel n on ma.id_nivel=n.id_nivel
            where em.estado = 'A'
            and pa.id_periodo_academico = @pi_id_perido_academico
            and (d.id = @departamento or @departamento is null)
            and (om.id_oferta_modalidad = @id_oferta_modalidad or @id_oferta_modalidad is null)
            --and ap.id_oferta_modalidad_pregrado is null
            -- 			and p.apellidos like '%ORDOÑEZ%'
            AND eo.estado = 'A'
            and ea.estado = 'A'
            and aa.estado = 'A'
            and ma.estado = 'A'   --and p.identificacion='0958799066'

            group by
            d.nombre, o.descripcion,  eo.id_oferta_modalidad,
            -- ea.id_paralelo,
            a.descripcion, par.descripcion_corta, n.descripcion_corta, ea.aprobado,ma.id_malla_asignatura,par.id_paralelo


   )as aux2
 PIVOT (
    MIN(cantidad ) FOR aprobado IN ([true], [false])
    -- count(id_malla_asignatura) FOR ciclo_count  IN ([CIC1_count], [CIC2_count], [RECU_count])
) AS PivotTable
 group by departamento, oferta,   asignatura, PARALELO,id_malla_asignatura,nivel, id_paralelo -- TRUE,FALSE
 order by departamento, oferta,paralelo, asignatura

end


declare @id_periodo_academico int= 30
--LISTADO DE ESTUDIANTES POR NIVEL, paralelo y carrera
select row_number() over (order by d.facultad) as indice,d.facultad,d.id_oferta_modalidad,d.carrera,d.nivel,d.paralelo,
       count(d.identificacion) as estudiantes, COUNT(CASE WHEN d.est is null THEN 1 END) AS total_primer_semestre_nivelacion,
       COUNT(CASE WHEN d.est is not null THEN 1 END) AS total_repetidores_primer_semestre from (
    select concat(p.apellidos,' ',p.nombres) as estudiante,p.identificacion, eo.numero_matricula,
           d.nombre as facultad,om.id_oferta_modalidad,o.descripcion as carrera,aux.id_estudiante_oferta as est,
           [aca].[fn_semestre_activo_estudiante] (eo.id_estudiante_oferta,27) as curso,
           (select top (1) niv.orden as semestre
             from aca.matricula_general mg
             inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
             inner join aca.estudiante_oferta eo on em1.id_estudiante_oferta = eo.id_estudiante_oferta
             inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
             inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
             inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
             where   mg.id_periodo_academico = @id_periodo_academico and eo.id_estudiante_oferta = em.id_estudiante_oferta
             and eo.estado='A' and em1.estado='A' and ea.estado='A'
             and mg.estado='A'   and aa.estado='A'
             and ma.estado='A' and niv.estado='A'
             group by em1.id_estudiante_matricula,niv.descripcion_corta ,niv.ORDEN,par.descripcion_corta,par.orden
             order by  count (ea.id_asignatura_aprendizaje) desc,count (par.descripcion_corta) desc) as nivel,
         (select top (1) par.orden as paralelo
             from aca.matricula_general mg
             inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
             inner join aca.estudiante_oferta eo on em1.id_estudiante_oferta = eo.id_estudiante_oferta
             inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
             inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
             inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
             where   mg.id_periodo_academico = @id_periodo_academico and eo.id_estudiante_oferta = em.id_estudiante_oferta
             and eo.estado='A' and em1.estado='A' and ea.estado='A'
             and mg.estado='A'   and aa.estado='A'
             and ma.estado='A' and niv.estado='A'
             group by em1.id_estudiante_matricula,niv.descripcion_corta ,niv.ORDEN,par.descripcion_corta,par.orden
             order by  count (ea.id_asignatura_aprendizaje) desc,count (par.descripcion_corta) desc) as paralelo
    from aca.matricula_general mg
    inner join aca.estudiante_matricula em on em.id_matricula_general = mg.id_matricula_general
    inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
    inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join man.personas p on p.id = eo.id_persona
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.oferta o on o.id_oferta = om.id_oferta
    inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
    inner join man.departamentos d on do.id_departamento = d.id
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    left join (
        select
               eo.id_estudiante_oferta
        from man.personas p
                 inner join aca.estudiante_oferta eo on eo.id_persona = p.id
                 inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
                 inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
                 inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
                 inner join aca.periodo_academico pa on pa.id_periodo_academico =  mg.id_periodo_academico
                 inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
                 inner join aca.oferta o on o.id_oferta = om.id_oferta
                 inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
                 inner join man.departamentos d on d.id= do.id_departamento
                 inner join seg.usuarios u on u.persona_id = p.id
        where  em.estado ='A' and pa.estado='A' and tee.codigo='APR' and eo.estado='A' and pa.id_periodo_academico = 32
          and u.estado='AC'
        group by eo.id_estudiante_oferta,u.id,p.id,p.identificacion,p.nombres,p.apellidos,
                 em.id_estudiante_matricula, d.nombre,o.descripcion,eo.mantiene_gratuidad,u.usuario,eo.id_oferta_modalidad
        having (
                   select count(ea1.promedio) from aca.estudiante_asignatura ea1
                                                       inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                                                       inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = aa1.id_malla_asignatura
                                                       inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
                   where ea1.id_estudiante_matricula = em.id_estudiante_matricula and ea1.estado ='A'
               ) =
               (
                   select count(ea1.promedio) from aca.estudiante_asignatura ea1
                                                       inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
                                                       inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = aa1.id_malla_asignatura
                                                       inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
                   where ea1.id_estudiante_matricula = em.id_estudiante_matricula and ea1.estado ='A' and ea1.aprobado = 1
               )
    ) as aux on aux.id_estudiante_oferta = eo.id_estudiante_oferta
    where mg.id_periodo_academico = @id_periodo_academico --and om.id_oferta_modalidad in (92,93,81)
    and eo.estado='A' and em.estado='A'
    and mg.estado='A' and om.estado='A' and do.estado='A' and pa.estado='A' and ea.estado='A'
    group by p.identificacion, p.apellidos, p.nombres, eo.numero_matricula, d.nombre, o.descripcion, eo.id_estudiante_oferta, em.id_estudiante_oferta,
             om.id_oferta_modalidad,aux.id_estudiante_oferta
    --     order by p.apellidos, p.nombres
    ) as d
         where d.nivel=1
         group by  d.facultad,d.id_oferta_modalidad,d.carrera,d.nivel,d.paralelo
order by d.facultad,d.carrera,d.nivel





--estudiantes que estan matriculados en 3 niveles
select row_number() over (order by d.estudiante) as indice,d.* from (
    select d.nombre as facultad,o.descripcion as carrera,eo.id_estudiante_oferta,p.identificacion,concat(p.apellidos,' ',p.nombres) as estudiante,
            eo.numero_matricula,(select  count( distinct niv.id_nivel) as niveles
             from aca.matricula_general mg
             inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
             inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
             inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
             inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
             inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
             where   mg.id_periodo_academico = 30 and eo1.id_estudiante_oferta = eo.id_estudiante_oferta
             and eo1.estado='A' and em1.estado='A' and ea.estado='A'
             and mg.estado='A'   and aa.estado='A'
             and ma.estado='A' and niv.estado='A'
             group by em1.id_estudiante_matricula
             ) as niveles
    from aca.matricula_general mg
    inner join aca.estudiante_matricula em on em.id_matricula_general = mg.id_matricula_general
    inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
    inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join man.personas p on p.id = eo.id_persona
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.oferta o on o.id_oferta = om.id_oferta
    inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
    inner join man.departamentos d on do.id_departamento = d.id
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    where mg.id_periodo_academico = 30 and d.id = 5
    and eo.estado='A' and em.estado='A'
    and mg.estado='A' and om.estado='A' and do.estado='A' and pa.estado='A' and ea.estado='A'
    group by p.identificacion, p.apellidos, p.nombres, eo.numero_matricula, d.nombre, o.descripcion, eo.id_estudiante_oferta
--     order by p.apellidos, p.nombres
    ) as d
         where d.niveles>=3
order by d.carrera,d.estudiante


exec aca.sp_rpt_total_matriculados_por_facultades 30


--LISTADO DE ESTUDIANTES POR NIVEL Y CARRERA
begin
    declare @id_periodo_academico int = 36

    select row_number() over (order by d.facultad) as indice,d.facultad,d.id_oferta_modalidad,d.carrera,d.nivel,count(d.identificacion) as estudiantes from (
    select concat(p.apellidos,' ',p.nombres) as estudiante,p.identificacion, eo.numero_matricula,
    d.nombre as facultad,om.id_oferta_modalidad,o.descripcion as carrera, [aca].[fn_semestre_activo_estudiante] (eo.id_estudiante_oferta,27) as curso,
    (select top (1) niv.orden as semestre
    from aca.matricula_general mg
    inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
    inner join aca.estudiante_oferta eo on em1.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
    inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
    inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
    inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
    inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
    where   mg.id_periodo_academico = 30 and eo.id_estudiante_oferta = em.id_estudiante_oferta
    and eo.estado='A' and em1.estado='A' and ea.estado='A'
    and mg.estado='A'   and aa.estado='A'
    and ma.estado='A' and niv.estado='A'
    group by em1.id_estudiante_matricula,niv.descripcion_corta ,niv.ORDEN,par.descripcion_corta,par.orden
    order by  count (ea.id_asignatura_aprendizaje) desc,count (par.descripcion_corta) desc) as nivel
    from aca.matricula_general mg
    inner join aca.estudiante_matricula em on em.id_matricula_general = mg.id_matricula_general
    inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
    inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join man.personas p on p.id = eo.id_persona
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.oferta o on o.id_oferta = om.id_oferta
    inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
    inner join man.departamentos d on do.id_departamento = d.id
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    where mg.id_periodo_academico = 30 --and om.id_oferta_modalidad in (92,93,81)
    and eo.estado='A' and em.estado='A'
    and mg.estado='A' and om.estado='A' and do.estado='A' and pa.estado='A' and ea.estado='A'
    group by p.identificacion, p.apellidos, p.nombres, eo.numero_matricula, d.nombre, o.descripcion, eo.id_estudiante_oferta, em.id_estudiante_oferta,
    om.id_oferta_modalidad
    --     order by p.apellidos, p.nombres
    ) as d
    where d.nivel in (1,2,3)
    group by  d.facultad,d.id_oferta_modalidad,d.carrera,d.nivel
    order by d.facultad,d.carrera,d.nivel
end

--estudiantes que llenaron la ficha
select  cfp.id_ficha,f.descripcion,count(*) as estudiantes from dbu.cab_ficha_persona cfp
inner join dbu.ficha f on cfp.id_ficha = f.id_ficha
inner join man.personas p on cfp.id_persona = p.id
inner join aca.estudiante_oferta eo on p.id = eo.id_persona
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
where cfp.estado='A' and cfp.id_ficha in (1,2,3) and o.id_tipo_oferta = 2 and eo.estado='A' and eo.id_tipo_estado_estudiante = 1
and mg.id_periodo_academico = 30 and em.estado='A'
and em.id_estudiante_matricula in (select distinct ea.id_estudiante_matricula from aca.estudiante_asignatura ea where ea.estado='A')
group by  cfp.id_ficha, f.descripcion


select * from [aca].[fn_record_academico_sga_definitivo](23360,null,
    null,null)

select
       d.facultad,d.carrera,d.id_asignatura,d.asignatura,d.semestre,d.orden,d.id_oferta_modalidad,paralelo,id_nivel,count(d.id_estudiante_matricula) as num
from  aca.fn_get_cantidad_matriculados_por_oferta_aux (null,null,35) as d
-- where d.id_nivel =@pi_id_nivel or @pi_id_nivel is null
group by d.id_asignatura,d.asignatura,d.semestre,d.orden,
         d.facultad,d.carrera,d.paralelo,id_nivel,d.id_oferta_modalidad
order by d.carrera, d.orden asc

select aux1.*,aux2.num as num_real from (
select d.facultad,d.carrera,d.id_malla_asignatura,d.id_asignatura,d.asignatura,d.semestre,d.orden,d.id_oferta_modalidad,paralelo,id_nivel,count(d.id_estudiante_matricula) as num
from  aca.fn_get_cantidad_matriculados_por_oferta_def (null,null,35) as d
-- where d.id_nivel =@pi_id_nivel or @pi_id_nivel is null
group by d.id_asignatura,d.id_malla_asignatura,d.asignatura,d.semestre,d.orden,
d.facultad,d.carrera,d.paralelo,id_nivel,d.id_oferta_modalidad) as aux1
left join (select
d.facultad,d.carrera,d.id_malla_asignatura,d.id_asignatura,d.asignatura,d.semestre,d.orden,d.id_oferta_modalidad,paralelo,id_nivel,count(d.id_estudiante_matricula) as num
from  aca.fn_get_cantidad_matriculados_por_oferta_aux (null,null,35) as d
-- where d.id_nivel =@pi_id_nivel or @pi_id_nivel is null
group by d.id_asignatura,d.id_malla_asignatura,d.asignatura,d.semestre,d.orden,
d.facultad,d.carrera,d.paralelo,id_nivel,d.id_oferta_modalidad
-- order by d.carrera, d.orden asc
)       as aux2 on aux1.id_malla_asignatura = aux2.id_malla_asignatura
    and aux1.id_oferta_modalidad = aux2.id_oferta_modalidad
    and aux1.id_nivel = aux2.id_nivel
    and aux1.orden = aux2.orden
    and aux1.paralelo = aux2.paralelo

-- where aux1.carrera='COMUNICACIÓN - MATRIZ'
order by carrera, orden asc

select
    d.facultad,d.carrera,d.id_malla_asignatura,d.id_asignatura,d.asignatura,d.semestre,d.orden,d.id_oferta_modalidad,paralelo,id_nivel,count(d.id_estudiante_matricula) as num
from  aca.fn_get_cantidad_matriculados_por_oferta (null,null,35) as d
-- where d.id_nivel =@pi_id_nivel or @pi_id_nivel is null
group by d.id_asignatura,d.id_malla_asignatura,d.asignatura,d.semestre,d.orden,
         d.facultad,d.carrera,d.paralelo,id_nivel,d.id_oferta_modalidad
order by d.carrera, d.orden asc

select * from aca.fn_get_cantidad_matriculados_por_oferta(null,null,35) as d

select o.descripcion,ma.id_nivel,a.descripcion,c.* from aud.cupos_2 c
                                                            inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = c.id_asignatura_aprendizaje
                                                            inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
                                                            inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
                                                            inner join aca.malla m on ma.id_malla = m.id_malla
                                                            inner join aca.oferta_modalidad om on om.id_oferta_modalidad = m.id_oferta_modalidad
                                                            inner join aca.oferta o on om.id_oferta = o.id_oferta
where o.estado='A' and ma.estado='A' and a.estado='A' and ma.estado in ('A','P')
  and o.estado='A' and aa.estado='A'
  and o.descripcion='COMUNICACIÓN - MATRIZ' --and ma.id_nivel = 1
order by o.descripcion,ma.id_nivel,a.descripcion

select cp.departamento,cp.oferta,cp.id_nivel,cp.asignatura,cpd.* from aud.cursos_proyectados_detalle cpd
                                                                          inner join aud.cursos_proyectados_2 cp on cpd.id_cursos_proyectados = cp.id

where cp.oferta like '%EDUCACION INICIAL - MATRIZ%' and cp.id_nivel = 1
order by cp.departamento,cp.oferta,cp.id_nivel

select * from aud.cupos_3

--1946
 SELECT COUNT(o.descripcion) AS modificaciones, o.descripcion,em.id_estudiante_matricula
FROM aca.estudiante_matricula em
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
INNER JOIN aca.estudiante_oferta eo ON em.id_estudiante_oferta = eo.id_estudiante_oferta
INNER JOIN aca.oferta_modalidad om ON eo.id_oferta_modalidad = om.id_oferta_modalidad
INNER JOIN aca.oferta o ON om.id_oferta = o.id_oferta
WHERE ea.fecha_mod >= '2024-03-20 12:30:00'
AND eo.estado = 'A'
AND om.estado = 'A'
AND o.estado = 'A'
GROUP BY o.descripcion, em.id_estudiante_matricula;


-----listado estudiantes
select aux.carrera,aux.identificacion,aux.nombres,aux.id_paralelo,aux2.id_paralelo from (
select o.descripcion as carrera,per.identificacion,concat(per.apellidos,' ',per.nombres) as nombres,
       aap.id_malla_asignatura,a.descripcion as asignatura,eas.id_estudiante_asignatura,  ema.id_estudiante_matricula ,eas.id_paralelo
from aca.asignatura_aprendizaje aap
         inner join aca.estudiante_asignatura eas on eas.id_asignatura_aprendizaje = aap.id_asignatura_aprendizaje
        inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = eas.id_asignatura_aprendizaje
        inner join aca.malla_asignatura ma on aap.id_malla_asignatura = ma.id_malla_asignatura
        inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
         inner join aca.paralelo p on eas.id_paralelo=p.id_paralelo
         inner join aca.estudiante_matricula ema on ema.id_estudiante_matricula = eas.id_estudiante_matricula
         inner join aca.matricula_general mg on mg.id_matricula_general = ema.id_matricula_general
         inner join aca.estudiante_oferta eo on ema.id_estudiante_oferta=eo.id_estudiante_oferta
        inner join man.personas per on eo.id_persona = per.id
         INNER JOIN aca.oferta_modalidad om ON eo.id_oferta_modalidad = om.id_oferta_modalidad
         INNER JOIN aca.oferta o ON om.id_oferta = o.id_oferta
where mg.id_periodo_academico = 35 and  ema.fecha_mod >= '2024-03-20 12:30:00'
  and aap.estado='A' AND eas.estado='A' and p.estado='A' and ema.estado='A' and mg.estado='A' and eo.estado='A' and ma.estado='A' and a.estado='A'
group by o.descripcion,aap.id_malla_asignatura, ema.id_estudiante_matricula ,eas.id_paralelo,p.descripcion, p.descripcion_corta, eas.id_estudiante_asignatura,
         per.apellidos,per.nombres,a.descripcion,per.identificacion
)as aux
inner join (select aap.id_malla_asignatura,eas.id_estudiante_asignatura,  ema.id_estudiante_matricula ,eas.id_paralelo,p.descripcion, p.descripcion_corta
            from aca.asignatura_aprendizaje aap
                     inner join aud.estudiante_asignatura_temporal222 eas on eas.id_asignatura_aprendizaje = aap.id_asignatura_aprendizaje
                     inner join aca.paralelo p on eas.id_paralelo=p.id_paralelo
                     inner join aca.estudiante_matricula ema on ema.id_estudiante_matricula = eas.id_estudiante_matricula
                     inner join aca.matricula_general mg on mg.id_matricula_general = ema.id_matricula_general
                     inner join aca.estudiante_oferta eo on ema.id_estudiante_oferta=eo.id_estudiante_oferta
            where mg.id_periodo_academico = 35
              and aap.estado='A' AND eas.estado='A' and p.estado='A' and ema.estado='A' and mg.estado='A'
            group by aap.id_malla_asignatura, ema.id_estudiante_matricula ,eas.id_paralelo,p.descripcion, p.descripcion_corta, eas.id_estudiante_asignatura)
as aux2 on aux2.id_estudiante_asignatura=aux.id_estudiante_asignatura
and  aux2.id_malla_asignatura = aux.id_malla_asignatura and aux2.id_estudiante_matricula = aux.id_estudiante_matricula
and aux2.id_paralelo <> aux.id_paralelo
group by aux.carrera,aux.identificacion,aux.nombres,aux.id_paralelo,aux2.id_paralelo

-----listado estudiantes por carrera

select d.carrera,count(d.nombres) as estudiantes from(
select aux.carrera,aux.nombres,aux.id_paralelo,aux2.id_paralelo as id_paralelo_nuevo from (
     select o.descripcion as carrera,concat(per.apellidos,' ',per.nombres) as nombres,
            aap.id_malla_asignatura,a.descripcion as asignatura,eas.id_estudiante_asignatura,  ema.id_estudiante_matricula ,eas.id_paralelo
     from aca.asignatura_aprendizaje aap
              inner join aca.estudiante_asignatura eas on eas.id_asignatura_aprendizaje = aap.id_asignatura_aprendizaje
              inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = eas.id_asignatura_aprendizaje
              inner join aca.malla_asignatura ma on aap.id_malla_asignatura = ma.id_malla_asignatura
              inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
              inner join aca.paralelo p on eas.id_paralelo=p.id_paralelo
              inner join aca.estudiante_matricula ema on ema.id_estudiante_matricula = eas.id_estudiante_matricula
              inner join aca.matricula_general mg on mg.id_matricula_general = ema.id_matricula_general
              inner join aca.estudiante_oferta eo on ema.id_estudiante_oferta=eo.id_estudiante_oferta
              inner join man.personas per on eo.id_persona = per.id
              INNER JOIN aca.oferta_modalidad om ON eo.id_oferta_modalidad = om.id_oferta_modalidad
              INNER JOIN aca.oferta o ON om.id_oferta = o.id_oferta
     where mg.id_periodo_academico = 35 and  ema.fecha_mod >= '2024-03-20 12:30:00'
       and aap.estado='A' AND eas.estado='A' and p.estado='A' and ema.estado='A' and mg.estado='A' and eo.estado='A' and ma.estado='A' and a.estado='A'
     group by o.descripcion,aap.id_malla_asignatura, ema.id_estudiante_matricula ,eas.id_paralelo,p.descripcion, p.descripcion_corta, eas.id_estudiante_asignatura,
              per.apellidos,per.nombres,a.descripcion
 )as aux
     inner join (select aap.id_malla_asignatura,eas.id_estudiante_asignatura,  ema.id_estudiante_matricula ,eas.id_paralelo,p.descripcion, p.descripcion_corta
                 from aca.asignatura_aprendizaje aap
                          inner join aud.estudiante_asignatura_temporal222 eas on eas.id_asignatura_aprendizaje = aap.id_asignatura_aprendizaje
                          inner join aca.paralelo p on eas.id_paralelo=p.id_paralelo
                          inner join aca.estudiante_matricula ema on ema.id_estudiante_matricula = eas.id_estudiante_matricula
                          inner join aca.matricula_general mg on mg.id_matricula_general = ema.id_matricula_general
                          inner join aca.estudiante_oferta eo on ema.id_estudiante_oferta=eo.id_estudiante_oferta
                 where mg.id_periodo_academico = 35
                   and aap.estado='A' AND eas.estado='A' and p.estado='A' and ema.estado='A' and mg.estado='A'
                 group by aap.id_malla_asignatura, ema.id_estudiante_matricula ,eas.id_paralelo,p.descripcion, p.descripcion_corta, eas.id_estudiante_asignatura)
as aux2 on aux2.id_estudiante_asignatura=aux.id_estudiante_asignatura
    and  aux2.id_malla_asignatura = aux.id_malla_asignatura and aux2.id_estudiante_matricula = aux.id_estudiante_matricula
    and aux2.id_paralelo <> aux.id_paralelo
group by aux.carrera,aux.nombres,aux.id_paralelo,aux2.id_paralelo) as d
group by d.carrera

--685
select aux.id_estudiante_asignatura,aux.carrera,aux.identificacion,aux.nombres,aux.asignatura,aux.id_nivel,aux.id_paralelo_actual,aux2.id_paralelo_nuevo from (
select o.descripcion as carrera,per.identificacion,concat(per.apellidos,' ',per.nombres) as nombres,ma.id_nivel,
aap.id_malla_asignatura,a.descripcion as asignatura,eas.id_estudiante_asignatura,  ema.id_estudiante_matricula ,eas.id_paralelo as id_paralelo_actual
from aca.asignatura_aprendizaje aap
inner join aca.estudiante_asignatura eas on eas.id_asignatura_aprendizaje = aap.id_asignatura_aprendizaje
inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = eas.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on aap.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
inner join aca.paralelo p on eas.id_paralelo=p.id_paralelo
inner join aca.estudiante_matricula ema on ema.id_estudiante_matricula = eas.id_estudiante_matricula
inner join aca.matricula_general mg on mg.id_matricula_general = ema.id_matricula_general
inner join aca.estudiante_oferta eo on ema.id_estudiante_oferta=eo.id_estudiante_oferta
inner join man.personas per on eo.id_persona = per.id
INNER JOIN aca.oferta_modalidad om ON eo.id_oferta_modalidad = om.id_oferta_modalidad
INNER JOIN aca.oferta o ON om.id_oferta = o.id_oferta
where mg.id_periodo_academico = 35 and  ema.fecha_mod >= '2024-03-20 12:30:00'
and aap.estado='A' AND eas.estado='A' and p.estado='A' and ema.estado='A' and mg.estado='A' and eo.estado='A' and ma.estado='A' and a.estado='A'
group by o.descripcion,aap.id_malla_asignatura, ema.id_estudiante_matricula ,eas.id_paralelo,p.descripcion, p.descripcion_corta, eas.id_estudiante_asignatura,
per.apellidos,per.nombres,a.descripcion,ma.id_nivel,per.identificacion
)as aux
inner join (select aap.id_malla_asignatura,eas.id_estudiante_asignatura,  ema.id_estudiante_matricula ,eas.id_paralelo as id_paralelo_nuevo
from aca.asignatura_aprendizaje aap
inner join aud.estudiante_asignatura_temporal222 eas on eas.id_asignatura_aprendizaje = aap.id_asignatura_aprendizaje
inner join aca.paralelo p on eas.id_paralelo=p.id_paralelo
inner join aca.estudiante_matricula ema on ema.id_estudiante_matricula = eas.id_estudiante_matricula
inner join aca.matricula_general mg on mg.id_matricula_general = ema.id_matricula_general
inner join aca.estudiante_oferta eo on ema.id_estudiante_oferta=eo.id_estudiante_oferta
where mg.id_periodo_academico = 35
and aap.estado='A' AND eas.estado='A' and p.estado='A' and ema.estado='A' and mg.estado='A'
group by aap.id_malla_asignatura, ema.id_estudiante_matricula ,eas.id_paralelo,p.descripcion, eas.id_estudiante_asignatura)
    as aux2 on aux2.id_estudiante_asignatura=aux.id_estudiante_asignatura
    and  aux2.id_malla_asignatura = aux.id_malla_asignatura and aux2.id_estudiante_matricula = aux.id_estudiante_matricula
    and aux2.id_paralelo_nuevo <> aux.id_paralelo_actual
-- inner join (select ea.id_estudiante_asignatura from aca.estudiante_asignatura ea
--                                  left join aud.estudiante_asignatura_BACK_DEF df on df.id_estudiante_asignatura = ea.id_estudiante_asignatura
--             where df.id_estudiante_asignatura is null) as temp on temp.id_estudiante_asignatura = aux.id_estudiante_asignatura

---update
-- update ea set ea.id_paralelo = aux2.id_paralelo_nuevo
-- -- select aux.id_estudiante_asignatura,aux.carrera,aux.asignatura,aux.id_nivel,aux.id_paralelo_actual,aux2.id_paralelo_nuevo
-- from (
-- select o.descripcion as carrera,concat(per.apellidos,' ',per.nombres) as nombres,ma.id_nivel,
-- aap.id_malla_asignatura,a.descripcion as asignatura,eas.id_estudiante_asignatura,  ema.id_estudiante_matricula ,eas.id_paralelo as id_paralelo_actual
-- from aca.asignatura_aprendizaje aap
-- inner join aca.estudiante_asignatura eas on eas.id_asignatura_aprendizaje = aap.id_asignatura_aprendizaje
-- inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = eas.id_asignatura_aprendizaje
-- inner join aca.malla_asignatura ma on aap.id_malla_asignatura = ma.id_malla_asignatura
-- inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
-- inner join aca.paralelo p on eas.id_paralelo=p.id_paralelo
-- inner join aca.estudiante_matricula ema on ema.id_estudiante_matricula = eas.id_estudiante_matricula
-- inner join aca.matricula_general mg on mg.id_matricula_general = ema.id_matricula_general
-- inner join aca.estudiante_oferta eo on ema.id_estudiante_oferta=eo.id_estudiante_oferta
-- inner join man.personas per on eo.id_persona = per.id
-- INNER JOIN aca.oferta_modalidad om ON eo.id_oferta_modalidad = om.id_oferta_modalidad
-- INNER JOIN aca.oferta o ON om.id_oferta = o.id_oferta
-- where mg.id_periodo_academico = 35 and  ema.fecha_mod >= '2024-03-20 12:30:00'
-- and aap.estado='A' AND eas.estado='A' and p.estado='A' and ema.estado='A' and mg.estado='A' and eo.estado='A' and ma.estado='A' and a.estado='A'
-- group by o.descripcion,aap.id_malla_asignatura, ema.id_estudiante_matricula ,eas.id_paralelo,p.descripcion, p.descripcion_corta, eas.id_estudiante_asignatura,
-- per.apellidos,per.nombres,a.descripcion,ma.id_nivel
-- )as aux
-- inner join (select aap.id_malla_asignatura,eas.id_estudiante_asignatura,  ema.id_estudiante_matricula ,eas.id_paralelo as id_paralelo_nuevo
-- from aca.asignatura_aprendizaje aap
-- inner join aud.estudiante_asignatura_temporal222 eas on eas.id_asignatura_aprendizaje = aap.id_asignatura_aprendizaje
-- inner join aca.paralelo p on eas.id_paralelo=p.id_paralelo
-- inner join aca.estudiante_matricula ema on ema.id_estudiante_matricula = eas.id_estudiante_matricula
-- inner join aca.matricula_general mg on mg.id_matricula_general = ema.id_matricula_general
-- inner join aca.estudiante_oferta eo on ema.id_estudiante_oferta=eo.id_estudiante_oferta
-- where mg.id_periodo_academico = 35
-- and aap.estado='A' AND eas.estado='A' and p.estado='A' and ema.estado='A' and mg.estado='A'
-- group by aap.id_malla_asignatura, ema.id_estudiante_matricula ,eas.id_paralelo,p.descripcion, eas.id_estudiante_asignatura)
-- as aux2 on aux2.id_estudiante_asignatura=aux.id_estudiante_asignatura
-- and  aux2.id_malla_asignatura = aux.id_malla_asignatura and aux2.id_estudiante_matricula = aux.id_estudiante_matricula
-- and aux2.id_paralelo_nuevo <> aux.id_paralelo_actual
-- inner join aca.estudiante_asignatura ea on ea.id_estudiante_asignatura = aux.id_estudiante_asignatura


begin
declare @id_periodo_academico int= 96
--LISTADO DE ESTUDIANTES POR NIVEL, paralelo y carrera
    select
           om.facultad as facultad,om.id_oferta_modalidad,om.carrera as carrera,p.identificacion,p.apellidos,p.nombres,p.email_institucional
    from aca.matricula_general mg
    inner join aca.estudiante_matricula em on em.id_matricula_general = mg.id_matricula_general
    inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
    inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join man.personas p on p.id = eo.id_persona
    inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    where mg.id_periodo_academico = @id_periodo_academico --and om.id_oferta_modalidad in (92,93,81)
    and eo.estado='A' and em.estado='A'
    and mg.estado='A'  and pa.estado='A' and ea.estado='A'
    group by p.identificacion, p.apellidos, p.nombres, eo.numero_matricula,eo.id_estudiante_oferta, em.id_estudiante_oferta,
             om.id_oferta_modalidad, om.carrera, om.facultad, p.email_institucional
    --     order by p.apellidos, p.nombres
order by om.facultad,om.carrera,p.apellidos,p.nombres
end


-- UPDATE aca.estudiante_asignatura
-- set estado = 'A', usuario_mod = 'TICS_MIGRATE_ACTIVATE'
-- WHERE id_estudiante_asignatura in (
--     SELECT distinct ea.id_estudiante_asignatura FROM aud.estan_aun_jodidos_2 as per
--     inner join aca.estudiante_asignatura as ea on per.id_estudiante_matricula = ea.id_estudiante_matricula
--     where ea.estado = 'T'
--     group by ea.id_estudiante_asignatura
-- )

    SELECT o.descripcion as carrera,per.identificacion,concat(per.apellidos,' ',per.nombres) as nombres,ma.id_nivel,
           aa.id_malla_asignatura,a.descripcion as asignatura,ea.id_paralelo
    FROM aud.estan_aun_jodidos_2 as ej
    inner join aca.estudiante_asignatura as ea on ej.id_estudiante_matricula = ea.id_estudiante_matricula
    inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
    inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
    inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
    inner join aca.paralelo p on ea.id_paralelo=p.id_paralelo
    inner join aca.estudiante_matricula ema on ema.id_estudiante_matricula = ea.id_estudiante_matricula
    inner join aca.matricula_general mg on mg.id_matricula_general = ema.id_matricula_general
    inner join aca.estudiante_oferta eo on ema.id_estudiante_oferta=eo.id_estudiante_oferta
    inner join man.personas per on eo.id_persona = per.id
    INNER JOIN aca.oferta_modalidad om ON eo.id_oferta_modalidad = om.id_oferta_modalidad
    INNER JOIN aca.oferta o ON om.id_oferta = o.id_oferta
    where mg.id_periodo_academico = 35
      and aa.estado='A' AND ea.estado='A' and p.estado='A' and ema.estado='A' and mg.estado='A' and om.estado='A'  and ma.estado='A'
     group by ea.id_estudiante_asignatura, per.identificacion, o.descripcion, per.apellidos, per.nombres, ma.id_nivel, aa.id_malla_asignatura,
              a.descripcion, ema.id_estudiante_matricula, ea.id_paralelo

select *from aud.estan_aun_jodidos_2

select d.carrera,d.asignatura,d.id_nivel,d.id_paralelo,count(d.identificacion) as estudiantes from (
SELECT o.descripcion as carrera,per.identificacion,concat(per.apellidos,' ',per.nombres) as nombres,ma.id_nivel,
       aa.id_malla_asignatura,a.descripcion as asignatura,ea.id_paralelo
FROM aud.estan_aun_jodidos_2 as ej
         inner join aca.estudiante_asignatura as ea on ej.id_estudiante_matricula = ea.id_estudiante_matricula
         inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
         inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
         inner join aca.paralelo p on ea.id_paralelo=p.id_paralelo
         inner join aca.estudiante_matricula ema on ema.id_estudiante_matricula = ea.id_estudiante_matricula
         inner join aca.matricula_general mg on mg.id_matricula_general = ema.id_matricula_general
         inner join aca.estudiante_oferta eo on ema.id_estudiante_oferta=eo.id_estudiante_oferta
         inner join man.personas per on eo.id_persona = per.id
         INNER JOIN aca.oferta_modalidad om ON eo.id_oferta_modalidad = om.id_oferta_modalidad
         INNER JOIN aca.oferta o ON om.id_oferta = o.id_oferta
where mg.id_periodo_academico = 35
  and aa.estado='A' AND ea.estado='A' and p.estado='A' and ema.estado='A' and mg.estado='A' and om.estado='A'  and ma.estado='A'
group by ea.id_estudiante_asignatura, per.identificacion, o.descripcion, per.apellidos, per.nombres, ma.id_nivel, aa.id_malla_asignatura,
         a.descripcion, ema.id_estudiante_matricula, ea.id_paralelo
) as d
group by d.carrera,d.asignatura,d.id_nivel,d.id_paralelo
order by d.carrera,d.id_nivel,d.asignatura

select dep.nombre as Facultad, o.descripcion as carrera,
       per.identificacion,concat(per.apellidos,' ',per.nombres) as nombres,
       a.descripcion as asignatura, p.descripcion as paraleloDeseado--, ea.id_paralelo_deseado
from aud.estan_aun_jodidos_2 ea
         inner join aca.estudiante_matricula ema on ema.id_estudiante_matricula = ea.id_estudiante_matricula
         inner join aca.estudiante_asignatura df on df.id_estudiante_asignatura = ea.id_estudiante_matricula
         inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = df.id_asignatura_aprendizaje
         inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
         inner join aca.paralelo p on ea.id_paralelo_deseado=p.id_paralelo
-- inner join aca.estudiante_matricula ema on ema.id_estudiante_matricula = ea.id_estudiante_matricula
         inner join aca.matricula_general mg on mg.id_matricula_general = ema.id_matricula_general
         inner join aca.estudiante_oferta eo on ema.id_estudiante_oferta=eo.id_estudiante_oferta
         inner join man.personas per on eo.id_persona = per.id
         INNER JOIN aca.oferta_modalidad om ON eo.id_oferta_modalidad = om.id_oferta_modalidad
         INNER JOIN aca.oferta o ON om.id_oferta = o.id_oferta
         inner join aca.departamento_oferta as do on o.id_oferta = do.id_oferta
         inner join man.departamentos as dep on do.id_departamento = dep.id
-- INNER JOIN aca.nivel as niv on eo.id_nivel_proyectado = niv.id_nivel
-- inner join aca.paralelo as p on p.id_paralelo = ea.id_paralelo_deseado
where mg.id_periodo_academico = 35
group by dep.nombre, o.descripcion, per.identificacion, per.apellidos, per.nombres, a.descripcion, p.descripcion
order by dep.nombre, o.descripcion, per.identificacion, a.descripcion, p.descripcion

select * from aca.estudiante_matricula where id_estudiante_matricula= 77366


--estudiantes con doble carrera en pregrado
begin
declare @idPeriodoAcademico int = 96
select distinct  eo.id_estudiante_oferta,eo.id_oferta_modalidad,eo.mantiene_gratuidad,eo.id_periodo_academico,p.identificacion,p.apellidos,p.nombres,eo.numero_matricula,d.nombre,o.descripcion,tee.descripcion
from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
inner join man.departamentos d on d.id= do.id_departamento
-- inner join aca.periodo_academico_oferta pao on pao.id_oferta_modalidad = om.id_oferta_modalidad and pao.id_periodo_academico = @idPeriodoAcademico
where o.id_tipo_oferta = 2 and eo.estado ='A'  and tee.codigo ='ACT' and mg.id_periodo_academico = @idPeriodoAcademico
and p.identificacion in (select distinct d.identificacion from (select p.identificacion,count(eo.id_oferta_modalidad) as num_carreras
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
         inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
        inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.oferta o on o.id_oferta = om.id_oferta
         inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
         inner join man.departamentos d on d.id= do.id_departamento
where o.id_tipo_oferta = 2 and eo.estado ='A' and tee.codigo ='ACT' and mg.id_periodo_academico = @idPeriodoAcademico
--   and p.identificacion ='2400263915'
group by p.identificacion
having count(eo.id_oferta_modalidad)>1) as d)
--   and p.identificacion ='2400263915'
group by p.identificacion,p.apellidos,p.nombres,eo.numero_matricula,eo.id_estudiante_oferta,eo.id_oferta_modalidad,d.nombre,o.descripcion, eo.mantiene_gratuidad, eo.id_periodo_academico, tee.descripcion
order by p.identificacion,p.apellidos,p.nombres,o.descripcion
end


--ESTUDIANTES CON DOBLE CARRERA SIMULTANEA
begin
declare @idPeriodoAcademico int = 95
select distinct  eo.id_estudiante_oferta,eo.id_persona,eo.id_oferta_modalidad,eo.mantiene_gratuidad,isnull(eo.id_periodo_academico,0)as id_periodo_academico,p.identificacion,
                 p.apellidos,p.nombres,eo.numero_matricula,d.nombre,o.descripcion,iif(em.id_estudiante_matricula is null,'NO MATRICULADO','MATRICULADO') as matriculado,tee.descripcion as estado
from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
left join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta and em.estado='A'
left join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general and mg.id_periodo_academico = @idPeriodoAcademico
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
inner join man.departamentos d on d.id= do.id_departamento
-- inner join aca.periodo_academico_oferta pao on pao.id_oferta_modalidad = om.id_oferta_modalidad and pao.id_periodo_academico = @idPeriodoAcademico
where o.id_tipo_oferta = 2 and eo.estado ='A'  and tee.codigo in ('ACT')
and p.identificacion in (select distinct d.identificacion from (select p.identificacion,count(eo.id_oferta_modalidad) as num_carreras
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
         inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
        inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.oferta o on o.id_oferta = om.id_oferta
         inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
         inner join man.departamentos d on d.id= do.id_departamento
where o.id_tipo_oferta = 2 and eo.estado ='A' and tee.codigo in ('ACT')
and mg.id_periodo_academico = @idPeriodoAcademico
--   and p.identificacion ='2400263915'
group by p.identificacion
having count(eo.id_oferta_modalidad)>1) as d)
--   and p.identificacion ='2400263915'
group by p.identificacion,p.apellidos,p.nombres,eo.numero_matricula,eo.id_estudiante_oferta,eo.id_oferta_modalidad,d.nombre,o.descripcion, eo.mantiene_gratuidad, eo.id_periodo_academico, em.id_estudiante_matricula, tee.descripcion, eo.id_persona
order by p.apellidos,p.nombres,id_periodo_academico
end

select p.identificacion,count(eo.id_oferta_modalidad) as num_carreras
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
        inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.oferta o on o.id_oferta = om.id_oferta
         inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
         inner join man.departamentos d on d.id= do.id_departamento
where o.id_tipo_oferta = 2 and eo.estado ='A' and tee.codigo ='ACT'
--   and p.identificacion ='2400263915'
group by p.identificacion
having count(eo.id_oferta_modalidad)>1




---aprobados reprobados general por periodos
begin
select p.codigo,isnull(per.identificacion, '') as identificacion,
        case when dd.id_docente is null then 'POR DEFINIR' else concat (upper (per.apellidos),' ',upper(per.nombres)) end as apellidos_nombres,
--         isnull (per.sexo, '') as genero , 	ISNULL(per.email_personal,'') email_personal,ISNULL(per.email_institucional,'')email_institucional,
--         carrera_docente,facultad_docente,--ISNULL (auxDed.id_docente_dedicacion,'')AS id_docente_dedicacion,
--         ISNULL (auxDed.dedicacion,'')	AS dedicacion,
        isnull (aux.categoria,'' ) as categoria,isnull (aux.tipo_relacion_laboral,'' ) as tipo_relacion_laboral,
        dd.id_distributivo_docente,
        isnull(auxAsig.carrera_asignatura,'') as carrera_actividad,
        isnull(auxAsig.facultad_asignatura,'')as facultad_actividad,ISNULL(auxAsig.nivel,'') as nivel,ISNULL(upper(auxAsig.asignatura),'') as asigantura,
        ISNULL(auxAsig.paralelo,'') as paralelo, 	--auxAsig.id_malla_asignatura, auxAsig.id_paralelo as id_paralelo,
        ISNULL(auxAsig.num_estudiante_aproximado,0)as num_estudiante_aproximado ,
        isnull(auxAsig.num_est_Matriculados,0) as num_est_Matriculados,
       isnull(auxAsig.num_est_aprobados,0) as num_est_aprobados,
       isnull(auxAsig.num_est_reprobados,0) as num_est_reprobados,
        ISNULL( auxAsig.horas_asignatura,0)as horas

from aca.periodo_academico p
inner join aca.periodo_academico_oferta pao on p.id_periodo_academico=pao.id_periodo_academico
inner join aca.distributivo_oferta do on pao.id_periodo_academico_oferta=do.id_periodo_academico_oferta
inner join aca.distributivo_docente dd on do.id_distributivo_oferta=dd.id_distributivo_oferta
left join aca.distributivo_dedicacion dde on dd.id_distributivo_docente=dde.id_distributivo_docente and dde.estado='A'
left join aca.docente d  on d.id_docente=dd.id_docente and d.estado='A'
left join man.personas per on d.id_persona=per.id and per.estado='AC'
        --ASIGNATURA
             LEFT join (select dd.id_docente, dd.id_distributivo_docente,  o.descripcion_corta as codigo_carrera_asignatura,o.descripcion as carrera_asignatura,
                               omo.id_oferta_modalidad,d.id as id_departamento,
                               d.nombre as facultad_asignatura,niv.descripcion as nivel,
                               case when niv.descripcion_corta is null then null else concat (niv.descripcion_corta,'/', par.descripcion_corta) end as paralelo,
                               ma.id_malla_asignatura,par.id_paralelo ,	avg(daa.num_estudiantes) as num_estudiante_aproximado,
                               isnull([aca].[fn_esc_get_numero_estudiantes_matriculados_by_asignatura_paralelo_estado]
                                      (ma.id_malla_asignatura,par.id_paralelo,
                                      iif(niv.descripcion='NIVELACION',[aca].[fn_esc_get_periodo_by_relacion_mallas]
                                      (ma.id_malla,p.id_periodo_academico),p.id_periodo_academico),null),0) as num_est_Matriculados,
                               isnull([aca].[fn_esc_get_numero_estudiantes_matriculados_by_asignatura_paralelo_estado]
                                      (ma.id_malla_asignatura,par.id_paralelo,
                                       iif(niv.descripcion='NIVELACION',[aca].[fn_esc_get_periodo_by_relacion_mallas]
                                    (ma.id_malla,p.id_periodo_academico),p.id_periodo_academico),1),0)as num_est_aprobados,
                               isnull([aca].[fn_esc_get_numero_estudiantes_matriculados_by_asignatura_paralelo_estado]
                                      (ma.id_malla_asignatura,par.id_paralelo,
                                       iif(niv.descripcion='NIVELACION',[aca].[fn_esc_get_periodo_by_relacion_mallas]
                                    (ma.id_malla,p.id_periodo_academico),p.id_periodo_academico),0),0) as num_est_reprobados,
                            a.descripcion as asignatura,
                               sum ( daa.total ) as horas_asignatura,
                               [aca].[fn_get_fusion_malla_asignatura] (p.id_periodo_academico,ma.id_malla_asignatura,par.id_paralelo ) as fusion
                        from aca.periodo_academico p
                         inner join aca.periodo_academico_oferta pao on p.id_periodo_academico=pao.id_periodo_academico
                         inner join aca.distributivo_oferta do on pao.id_periodo_academico_oferta=do.id_periodo_academico_oferta
                         inner join aca.distributivo_docente dd on do.id_distributivo_oferta=dd.id_distributivo_oferta

                         inner join aca.docente_asignatura_aprend daa on  dd.id_distributivo_docente=daa.id_distributivo_docente
                         inner join aca.paralelo par on daa.id_paralelo=par.id_paralelo
                         inner join aca.asignatura_aprendizaje aa on daa.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
                         inner join aca.componente_aprendizaje ca on aa.id_componente_aprendizaje=ca.id_componente_aprendizaje
                         inner join aca.reglamento_comp_aprendizaje rca on ca.id_componente_aprendizaje=rca.id_comp_aprendizaje
                         inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
                         inner join aca.nivel as niv on ma.id_nivel=niv.id_nivel
                         inner join aca.asignatura a on ma.id_asignatura=a.id_asignatura
                         inner join aca.malla m on ma.id_malla=m.id_malla
                         inner join aca.oferta_modalidad omo on m.id_oferta_modalidad=omo.id_oferta_modalidad
                         inner join aca.oferta o on omo.id_oferta=o.id_oferta
                         inner join aca.departamento_oferta dof on o.id_oferta=dof.id_oferta and dof.estado='A'
                         inner join man.departamentos d on dof.id_departamento=d.id and d.estado='AC'
                        WHERE dd.id_distributivo_oferta in (select  id_distributivo_oferta
                                                            from [aca].[fn_distributivo_oferta_max](p.id_periodo_academico,'A'))
                          and  o.estado='A' and a.estado='A' and niv.estado='A' and ma.estado='A'  and pao.id_reglamento=rca.id_reglamento
                          and rca.estado='A' and aa.estado='A' and par.estado='A' and daa.estado='A' and dd.estado='A' and m.estado ='P' and omo.estado='A'
                          and ((do.estado='A' ) or 	( do.estado in ('A' , 'D', 'V'))) and dd.estado='A'
                        and d.id = 11
                        group by p.id_periodo_academico ,dd.id_docente,dd.id_distributivo_docente,do.fecha_desde ,do.fecha_hasta, ma.id_malla_asignatura,p.descripcion,dd.oferta_principal,
                                 do.id_distributivo_oferta, a.descripcion, o.descripcion_corta,niv.descripcion_corta, par.id_paralelo, par.descripcion_corta, ma.id_malla_asignatura,
                                 d.nombre,o.descripcion,dd.id_docente,niv.descripcion,omo.id_oferta_modalidad,d.id,ma.id_malla
    ) as auxAsig on auxAsig.id_distributivo_docente=dd.id_distributivo_docente
--         --DEDICACION
--              left join ( select dd1.id_distributivo_docente, dd1.id_docente ,dde.id_docente_dedicacion,ddd.descripcion as dedicacion ,
--                                 o.descripcion as carrera_docente,om.id_oferta_modalidad, dep.nombre as facultad_docente,dep.id as id_departamento
--                          from aca.periodo_academico_oferta pao
--                                   inner join aca.distributivo_oferta do1 on pao.id_periodo_academico_oferta=do1.id_periodo_academico_oferta
--                                   inner join aca.distributivo_docente dd1 on do1.id_distributivo_oferta=dd1.id_distributivo_oferta
--                                   inner join aca.distributivo_dedicacion as dde on dd1.id_distributivo_docente=dde.id_distributivo_docente
--                                   inner join aca.docente_dedicacion as ddd on dde.id_docente_dedicacion=ddd.id_docente_dedicacion
--                                   inner join aca.oferta_modalidad om on pao.id_oferta_modalidad=om.id_oferta_modalidad
--                                   inner join aca.oferta o on om.id_oferta=o.id_oferta
--                                   inner join aca.departamento_oferta dof on dof.id_oferta=o.id_oferta
--                                   inner join man.departamentos dep on dof.id_departamento=dep.id
--                          where  dde.estado='A' and ddd.estado='A' and dd1.estado='A' and dep.estado='AC' and om.estado='A'
--                            and ((do1.estado='A')	 or 	(do1.estado in ('A' , 'D', 'V')))
--                            and o.estado='A' and dof.estado='A' and pao.estado='A'
--                            and do1.id_distributivo_oferta in (select  id_distributivo_oferta
--                                                               from [aca].[fn_distributivo_oferta_max](pao.id_periodo_academico,'A'))
--
--     ) auxDed on dd.id_docente=auxDed.id_docente
             left join (select d.id_docente,hdo.fecha_desde,hdo.fecha_hasta,
                               dca.id_docente_categoria,dca.descripcion as categoria,dca.tipo_relacion_laboral
                        from  aca.docente d
                                  inner join aca.docente_historial as hdo ON hdo.id_docente=d.id_docente
                                  inner join aca.docente_categoria as dca on hdo.id_docente_categoria=dca.id_docente_categoria
                        where    d.estado='A'  and hdo.estado='A' and dca.estado='A' )
        as aux on dd.id_docente=aux.id_docente  and ( do.fecha_desde between aux.fecha_desde  and  isnull(aux.fecha_hasta,do.fecha_hasta)
        or do.fecha_hasta between aux.fecha_desde  and  isnull(aux.fecha_hasta,do.fecha_hasta))

    where ((do.estado='A' ) or 	(do.estado in ('A' , 'D', 'V')))
      and do.id_distributivo_oferta in (	select  id_distributivo_oferta
                                            from [aca].[fn_distributivo_oferta_max](p.id_periodo_academico,'A'))
      AND dd.estado='A'
    and auxAsig.carrera_asignatura is not null and p.id_periodo_academico not in (35)
    and p.id_tipo_oferta =2
    group by p.id_periodo_academico ,dd.id_distributivo_docente,	do.fecha_desde ,do.fecha_hasta,
             auxAsig.id_malla_asignatura,p.descripcion,dd.oferta_principal,	do.id_distributivo_oferta,
             auxAsig.fusion,auxAsig.asignatura, auxAsig.paralelo,auxAsig.id_paralelo,auxAsig.num_estudiante_aproximado,auxAsig.num_est_Matriculados,
             auxAsig.num_est_aprobados,auxAsig.num_est_reprobados,
             auxAsig.carrera_asignatura,auxAsig.nivel, auxAsig.codigo_carrera_asignatura, auxAsig.facultad_asignatura,auxAsig.horas_asignatura,
             auxAsig.facultad_asignatura,dd.id_docente,per.id,
             p.fecha_desde,p.fecha_hasta,aux.id_docente_categoria,aux.categoria,aux.tipo_relacion_laboral,
             per.email_personal,per.email_institucional,per.sexo,per.identificacion,dd.id_docente,per.apellidos ,per.nombres , p.codigo
--     carrera_docente,facultad_docente,auxDed.id_docente_dedicacion, auxDed.dedicacion,
    order by per.apellidos,per.nombres,p.codigo,carrera_actividad,asignatura
end

select d.periodo_academico,d.nivel,d.concepto,d.valor,d.abono,d.deuda,iif(d.abono>=d.deuda,'PAGADO','ADEUDA') as estado from  aca.fn_record_rubros ('2400118093') d
order by d.periodo_academico

select * from aca.institucion

select * from aca.documentos_matricula where usuario_ing='2450409681'

select * from aca.estudiante_matricula where usuario_ing='2450409681'

select * from aca.tipo_institucion

select * from par.tipo_institucion


select d.facultad,d.carrera,d.semestre,d.id_nivel,d.id_oferta_modalidad,count(d.id_estudiante_matricula)
from aca.fn_get_cantidad_matriculados_por_oferta (null,null,95) as d
-- where d.orden in (1,2,3)
group by d.facultad,d.carrera,d.semestre,d.id_nivel,d.id_oferta_modalidad--,d.id_estudiante_matricula


select distinct '2024-2' as periodo,d.facultad,d.id_oferta_modalidad,d.carrera,mo.descripcion as modalidad,
                d.semestre,d.orden,paralelo,
                count(d.id_estudiante_matricula) as numero_estudiantes
from   aca.oferta_modalidad om
           inner join aca.modalidad mo on mo.id_modalidad=om.id_modalidad
           inner join aca.fn_get_cantidad_matriculados_por_oferta (null,null,95) as d on d.id_oferta_modalidad= om.id_oferta_modalidad
-- where d.id_nivel in (1,2,3) AND d.id_oferta_modalidad in (96,97)
group by d.facultad,d.carrera,d.semestre,d.orden,d.paralelo,d.id_oferta_modalidad, mo.descripcion

select * from aca.periodo_academico where id_tipo_oferta =1

--numero de matriculados por nivel
select --aux.id_asignatura,aux.asignatura,
       --aux.semestre
       --   ,
       aux.facultad,aux.carrera,aux.id_oferta_modalidad,aux.id_nivel,count(aux.id_estudiante_matricula) as num from (
            select
                d.facultad,d.carrera,d.id_oferta_modalidad,d.id_estudiante_matricula,d.id_nivel
            from  aca.fn_get_cantidad_matriculados_por_oferta (null,null,95) as d
--             where d.id_nivel in (8,9)
            group by
                d.facultad,d.carrera,d.id_oferta_modalidad,d.id_estudiante_matricula,d.id_nivel) as aux
group by
    aux.facultad,aux.carrera,aux.id_oferta_modalidad,aux.id_nivel
order by aux.facultad,aux.carrera asc

select
aux.facultad,aux.carrera,aux.id_oferta_modalidad,count(aux.id_estudiante_matricula) as num from (
    select
        d.facultad,d.carrera,d.id_oferta_modalidad,d.id_estudiante_matricula
    from  aca.fn_get_cantidad_matriculados_por_oferta (null,null,95) as d
--     where d.id_nivel in (8,9)
    group by
        d.facultad,d.carrera,d.id_oferta_modalidad,d.id_estudiante_matricula,d.id_nivel) as aux
group by
    aux.facultad,aux.carrera,aux.id_oferta_modalidad
order by aux.facultad,aux.carrera asc

---listado de estudiabtes por carrera y paralelo
select '2024-2' as periodo,
    aux.facultad,aux.carrera,aux.id_oferta_modalidad,aux.paralelo,
--     count(aux.id_estudiante_matricula) as num_estudiantes,
    count(CASE WHEN aux.estado ='A' THEN 1 END) AS estudiantes_matriculados,
    count(CASE WHEN aux.notas=0 THEN 1 END) AS estudiantes_ya_no_asisten,
    count(CASE WHEN aux.estado ='A' THEN 1 END)-count(CASE WHEN aux.notas=0 THEN 1 END) AS estudiantes_asisten_actualmente
    from (
select
d.facultad,d.carrera,d.id_oferta_modalidad,d.paralelo,d.id_estudiante_matricula,d.estado,avg(d.promedio) as notas
from  (select asi.id_asignatura,mas.id_malla_asignatura,asi.descripcion as asignatura,ni.descripcion as semestre,ni.orden,ni.id_nivel,
	dep.nombre as facultad,o.descripcion as carrera,om.id_oferta_modalidad,cont.id_estudiante_matricula,cont.id_paralelo,--count(cont.id_estudiante_matricula) as num
	concat (ni.descripcion_corta,'/',cont.descripcion_corta) as paralelo,cont.estado,cont.promedio
	from aca.malla ma
	inner join aca.oferta_modalidad om on om.id_oferta_modalidad = ma.id_oferta_modalidad
	inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
	inner join man.departamentos dep on dep.id = do.id_departamento
	inner join aca.oferta o on o.id_oferta = do.id_oferta
	inner join aca.malla_asignatura mas on ma.id_malla = mas.id_malla
	inner join aca.asignatura asi on mas.id_asignatura = asi.id_asignatura
	inner join aca.nivel ni  on ni.id_nivel = mas.id_nivel
	inner join aca.planificacion_paralelo pp on pp.id_periodo_academico=38 and pp.id_malla_asignatura=mas.id_malla_asignatura
	and pp.ofertada=1 and pp.estado='A'
	left join
	(
	select aap.id_malla_asignatura,  ema.id_estudiante_matricula ,eas.id_paralelo,p.descripcion, p.descripcion_corta,ema.estado,eas.promedio
	from aca.asignatura_aprendizaje aap
	inner join aca.estudiante_asignatura eas on eas.id_asignatura_aprendizaje = aap.id_asignatura_aprendizaje
	inner join aca.paralelo p on eas.id_paralelo=p.id_paralelo
	inner join aca.estudiante_matricula ema on ema.id_estudiante_matricula = eas.id_estudiante_matricula
	inner join aca.matricula_general mg on mg.id_matricula_general = ema.id_matricula_general
	inner join aca.estudiante_oferta eo on ema.id_estudiante_oferta=eo.id_estudiante_oferta
	where mg.id_periodo_academico = 38
	and aap.estado='A'  and p.estado='A'  and mg.estado='A' and ema.estado not in ('I') AND eas.estado not in ('I')
	group by aap.id_malla_asignatura, ema.id_estudiante_matricula ,eas.id_paralelo,p.descripcion, p.descripcion_corta,ema.estado,eas.promedio
	) as cont on cont.id_malla_asignatura=mas.id_malla_asignatura

	where ma.estado in ('A','P') and om.estado='A' and do.estado='A'-- and dep.estado='AC'
	and o.estado='A' and mas.estado='A' and asi.estado='A' and ni.estado='A'
	group by asi.id_asignatura,asi.descripcion,ni.descripcion,ni.orden,dep.nombre,o.descripcion,cont.id_estudiante_matricula
	,cont.id_paralelo,cont.descripcion,cont.descripcion_corta,ni.descripcion_corta,ni.id_nivel,om.id_oferta_modalidad,mas.id_malla_asignatura,cont.estado,cont.promedio
-- 	order by ni.orden asc
	) as d
--     where d.id_nivel in (8,9)
group by
d.facultad,d.carrera,d.id_oferta_modalidad,d.id_estudiante_matricula,d.id_nivel,d.paralelo,d.estado) as aux
group by
    aux.facultad,aux.carrera,aux.id_oferta_modalidad,aux.paralelo
order by aux.facultad,aux.carrera asc

--NUMERO_ESTUDIANTES_POR_CARRERA_SEMESTRE_PARALELO_ASIGNATURA
select d.facultad,d.carrera,d.id_oferta_modalidad,d.semestre,d.orden,
       d.paralelo as paralelo,id_nivel,d.id_asignatura as id_asignatura,d.asignatura as asignatura,count(d.id_estudiante_matricula) as num
from  aca.fn_get_cantidad_matriculados_por_oferta (null,null,35) as d
-- where d.id_nivel =@pi_id_nivel or @pi_id_nivel is null
group by d.semestre,d.orden,
         d.facultad,d.carrera,id_nivel,d.id_oferta_modalidad,d.id_asignatura,d.asignatura,d.paralelo
order by d.carrera, d.orden asc


--MATRIZ ESTUDIANTES PARA BIBLIOTECA_ACT
select distinct pa.codigo as PERIODO_ACADEMICO,
                c.descripcion as SEDE,d.nombre as facultad, o.descripcion as CARRERA, [aca].[fn_semestre_activo_estudiante]
                (eo.id_estudiante_oferta,pa.id_periodo_academico) as curso,
    p.identificacion AS IDENTIFICACION,p.apellidos as APELLIDOS, p.nombres as NOMBRES,iif(p.email_institucional is null,'NO REGISTRA',p.email_institucional) as EMAIL_INSTITUCIONAL,
                iif(p.email_personal is null,'NO REGISTRA',p.email_personal) as EMAIL_PERSONAL,p.direccion AS DIRECCION,
                iif(p.ciudad is null,'NO REGISTRA',p.ciudad) as CIUDAD,
                iif(p.id_provincia_nacionalidad is null,'NO APLICA',pror.descripcion) as PROVINCIA_RESIDENCIA,
                iif(p.id_canton_nacionalidad is null,'NO APLICA',cr.descripcion) as CANTON_RESIDENCIA,
                iif(p.celular is null,'NO REGISTRA',p.celular) as NUMERO_CELULAR,
                iif(p.telefono is null,'NO REGISTRA',p.telefono) as NUMERO_TELEFONO_CONVENCIONAL,
                iif(p.sexo='M','HOMBRE','MUJER') as GENERO, isnull(CONVERT(VARCHAR(15),p.fecha_nace, 103),'NO REGISTRA') as FECHA_NACIMIENTO
from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.malla m on m.id_malla = eo.id_malla
inner join man.tipo_identificacion te on te.id_tipo_identificacion = p.id_tipo_identificacion
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
inner join man.departamentos d on d.id= do.id_departamento
inner join aca.campus c on c.id_campus = o.id_campus
left join man.lugar pror on pror.id_lugar = p.id_provincia_residencia
left join man.lugar cr on cr.id_lugar = p.id_canton_residencia
where p.estado='AC' and eo.estado='A' and om.estado='A' and em.estado = 'A' and tee.codigo in ('ACT','OFR','APR')
--   and  mg.id_periodo_academico in (35)
-- and  mg.id_periodo_academico in (26,31,42)
  and  mg.id_periodo_academico in (36)
order by pa.codigo,c.descripcion, d.nombre,o.descripcion,p.apellidos,p.nombres

--MATRIZ ESTUDIANTES PARA BIBLIOTECA NO MATRICULADOS PERIODO ACTUAL
select distinct o.descripcion as CARRERA, [aca].[fn_semestre_activo_estudiante]
                (eo.id_estudiante_oferta,pa.id_periodo_academico) as curso,
    p.apellidos as APELLIDOS, p.nombres as NOMBRES,p.identificacion AS IDENTIFICACION,iif(p.email_institucional is null,'NO REGISTRA',p.email_institucional) as EMAIL_INSTITUCIONAL
--                 ,iif(p.email_personal is null,'NO REGISTRA',p.email_personal) as EMAIL_PERSONAL
from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.malla m on m.id_malla = eo.id_malla
inner join man.tipo_identificacion te on te.id_tipo_identificacion = p.id_tipo_identificacion
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
inner join man.departamentos d on d.id= do.id_departamento
inner join aca.campus c on c.id_campus = o.id_campus
left join man.lugar pror on pror.id_lugar = p.id_provincia_residencia
left join man.lugar cr on cr.id_lugar = p.id_canton_residencia
where p.estado='AC' and eo.estado='A' and om.estado='A' and em.estado = 'A' and tee.codigo in ('ACT')
  and  mg.id_periodo_academico in (35) AND eo.id_estudiante_oferta not in (
      select distinct em1.id_estudiante_oferta from aca.estudiante_matricula em1 inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
               where em1.estado='A' and mg1.id_periodo_academico = 36
    )
order by o.descripcion,p.apellidos,p.nombres

select * from aca.malla

select * from aca.malla_requisito

select * from aca.requisito

select id_periodo_academico,codigo,descripcion from aca.periodo_academico where estado='A' AND id_tipo_oferta = 2

select d.idEstudianteOferta,sum(ma1.num_creditos) as creditos,sum(ma1.num_horas) as horas
from [aca].[fn_record_academico_sga_definitivo](30057,null,null,1) as d
inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = d.idMallaAsignatura
where ma1.estado='A' and d.periodo not in ('2023-2','2024','2024-1')
group by d.idEstudianteOferta


select * from mig.graduados where identificacion='0928019074'

--funciones a eliminar
--     fn_semestre_activo_estudiante
--- estudiantes regulares
--16647
--reporte de estudiantes regulares
select * from [aca].[fn_list_student_by_level_offer](96,null,null,3,1)

select * from aca.fn_get_semestre_activo_regular(54960,96)
select * from tes.rubro

select * from aca.estudiante_oferta where id_estudiante_oferta in (77427,53502,67328,67327,76447,65205,29569,78036,78027)


--set campos nuevos de aca.estudiante_matricula
begin
    declare @id_periodo_academico int = 138, @estado_matricula char(1)='A', @estado_asignatura char(1)='A'
    select d.*
-- update em set em.id_nivel = d.id_nivel,em.id_paralelo = d.id_paralelo, em.valor_total = d.materias+d.rubros,em.promedio=d.promedioRed
--     update em set em.valor_total = d.materias+d.rubros,em.promedio=d.promedioRed
--         update em set em.id_tipo_jornada_laboral= d.id_tipo_jornada_laboral
    from (
   select om.carrera, om.facultad, p.identificacion, p.nombres, p.apellidos,tee.descripcion as tipo_ingreso,eo.id_estudiante_oferta,om.id_oferta_modalidad,
--           em.id_nivel,em.id_paralelo,
          em.promedio,em.valor_total,pa.codigo,em.id_estudiante_matricula,em.observacion
          ,case when om.id_tipo_oferta = 4 then 4
                else isnull(aux1.id_tipo_jornada_laboral,1) end as id_tipo_jornada_laboral,em.id_tipo_jornada_laboral as id_tipo_jornada_laboral_actual
--        ,plao.id_tipo_jornada_laboral as id_tipo_jornada_laboral
                 ,avg(isnull(cast(ea.promedio as decimal(10,4)),0)) as promedioReal,
          round(avg(isnull(cast(ea.promedio as decimal(10,4)),0)),2) as promedioRed,
          isnull((select sum(isnull(mr.valor,0)) from aca.matricula_rubro mr where em.id_estudiante_matricula = mr.id_estudiante_matricula and mr.estado='A'),0) as rubros,
          sum(isnull(ea.valor_asignatura,0)) as materias
          ,aux.curso as curso,aux.id_nivel,aux.id_paralelo
          from aca.estudiante_oferta eo
              inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
                   inner join man.personas p on eo.id_persona = p.id
                   inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
                   inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
                   inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                   inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
                   inner join aca.paralelo par on ea.id_paralelo = par.id_paralelo
                   inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
                   inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
                   inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
                    inner join aca.periodo_academico_oferta pao on pa.id_periodo_academico = pao.id_periodo_academico and eo.id_oferta_modalidad = pao.id_oferta_modalidad
--     *******************
--                     inner join aca.planificacion_oferta plao on par.id_paralelo = plao.id_paralelo and plao.id_periodo_academico_oferta=pao.id_periodo_academico_oferta and plao.estado='A'
                    left join (select em1.id_estudiante_matricula,--ma.id_malla_asignatura,
                                      ppd.id_tipo_jornada_laboral
                                    ,ROW_NUMBER() OVER (
                                      PARTITION BY em1.id_estudiante_matricula
                                      ORDER BY
                                          count(ea.id_estudiante_asignatura) desc,  -- materias
                                          isnull(sum( DATEDIFF(hour, ha.hora_inicio, ha.hora_fin)),0) desc,
                                          ppd.id_tipo_jornada_laboral                               -- jornada más horas si sigue empate
                                      ) AS rn
                               from aca.matricula_general mg
                                        inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
                                        inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
                                        inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
                                        inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
                                        inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
                                        inner join aca.planificacion_paralelo pp on pp.id_malla_asignatura = ma.id_malla_asignatura and pp.id_periodo_academico = mg.id_periodo_academico
                                        inner join aca.planificacion_paralelo_detalle ppd on ea.id_paralelo = ppd.id_paralelo and ppd.id_planificacion_paralelo = pp.id_planificacion_paralelo
                                        left join aca.horario_academico ha on ha.id_malla_asignatura = ma.id_malla_asignatura and ea.id_paralelo = ha.id_paralelo and ha.id_periodo_academico = mg.id_periodo_academico
                               where
                                   eo1.estado='A' and pp.estado='A' and ppd.estado='A'
                                  and em1.estado=@estado_matricula and ea.estado=@estado_asignatura and mg.estado='A'
                                 and aa.estado='A' and ma.estado='A'
                               group by eo1.id_estudiante_oferta,em1.id_estudiante_matricula,ppd.id_tipo_jornada_laboral--, ma.id_malla_asignatura
                               )
                    as aux1 on aux1.id_estudiante_matricula = em.id_estudiante_matricula and aux1.rn = 1
                    inner join (select niv.id_nivel,par.id_paralelo,eo1.id_estudiante_oferta,em1.id_estudiante_matricula,
                                       concat(niv.descripcion_corta,'/',par.descripcion_corta) as curso,--count (ea.id_estudiante_asignatura), count(par.orden),
                                       ROW_NUMBER() OVER (
                                           PARTITION BY em1.id_estudiante_matricula
                                           ORDER BY
                                               count(ea.id_estudiante_asignatura) desc,  -- materias
                                               sum(ma.num_creditos) desc,                -- créditos
                                               niv.orden,                                -- nivel más avanzado si sigue empate
                                               par.orden                                 -- paralelo
                                           ) AS rn
                                from aca.matricula_general mg
                                         inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
                                         inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
                                         inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
                                         inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
                                         inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
                                         inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
                                         inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
                                where  em1.estado=@estado_matricula and ea.estado=@estado_asignatura and mg.estado='A'
                                  and aa.estado='A' and ma.estado='A' and niv.estado='A'
                                group by eo1.id_estudiante_oferta,em1.id_estudiante_matricula, niv.descripcion_corta, niv.orden,par.descripcion_corta, par.orden,
                                         niv.id_nivel,par.id_paralelo
                                ) as aux on aux.id_estudiante_matricula = em.id_estudiante_matricula and aux.rn = 1
          where
          p.estado='AC'  and aa.estado='A' and ma.estado='A' and par.estado='A'  and mg.estado='A' and pa.estado='A'
            and em.estado=@estado_matricula and ea.estado=@estado_asignatura
--         and em.id_tipo_jornada_laboral is not null
--         and em.promedio is null and em.valor_total is null
--         and em.id_estudiante_oferta in (11773)
--         and em.id_nivel is null  and em.id_paralelo is null
--         em.id_estudiante_matricula in (9004,9006)
--           and pa.id_tipo_oferta  in (2)  --and pa.codigo_tipo_periodo ='PAORD'
          and pa.id_periodo_academico = @id_periodo_academico
          group by om.id_oferta, om.id_oferta_modalidad,om.carrera,om.facultad, p.identificacion,pa.id_periodo_academico, p.nombres, p.apellidos,
                   eo.id_estudiante_oferta,p.id,om.id_oferta,eo.id_malla,tee.descripcion ,em.id_estudiante_matricula,pa.codigo,
                  em.observacion,em.promedio,em.valor_total,em.id_nivel,em.id_paralelo,om.id_tipo_oferta
                   ,aux1.id_tipo_jornada_laboral,em.id_tipo_jornada_laboral
--                    ,plao.id_tipo_jornada_laboral
          , aux.curso,aux.id_paralelo,aux.id_nivel
    ) as d
    inner join aca.estudiante_matricula em on em.id_estudiante_matricula = d.id_estudiante_matricula
--     where d.promedioRed<>d.promedio
end


select distinct em.*
    from aca.estudiante_matricula em where id_tipo_jornada_laboral is null


--posibles cambios de carrera con doble matricula en la carrera nueva y en la vieja
--     0450111646 --nueva carrera
--     2400071706 tercera vez
--     0927960096 --nueva carrera
--     2400473159 --nueva carrera
--     2450315045 --nueva carrera
--     2450335175 --nueva carrera
--     2450519109 --nueva carrera
--     2450807082 --nueva carrera
--     3050641152 --nueva carrera

select m.* from aca.malla m
inner join aca.ofertas_facultad om on om.id_oferta_modalidad = m.id_oferta_modalidad
where om.id_tipo_oferta = 3

select * from aca.nivel
select * from aca.paralelo
select em.*, u.usuario,u.persona_id
--     update   em set usuario_mod = usuario_ing
 from aca.estudiante_matricula em
inner join seg.usuarios u on u.id = em.usuario_ingreso_id
where u.usuario<>em.usuario_ing and u.usuario<>em.usuario_mod
and em.usuario_ing not in ('vmalave','oorralapalacios')
-- where em.usuario_mod is null

select * from man.persona_identificacion where identificacion in ('AQ491050','1759090192')

select p.* from man.personas p
inner join seg.usuarios u on p.id = u.persona_id
where u.id = 662

select * from seg.usuarios where usuario ='1207028109'
select top 10 * from aca.estudiante_asignatura
select top 10 * from aca.estudiante_matricula
select top 10 * from aca.matricula_rubro
select * from mig.record_matricula
select * from aca.tipo_jornada_laboral
select * from aca.planificacion_oferta
select * from aca.planificacion_paralelo
select * from aca.malla
-- exec aca.matricula_posgrado 11094,44248,'1207028109',1


--reporte de numero de estudiantes por modalidad corte 10:43
select d.facultad,d.carrera,d.id_oferta_modalidad,d.semestre,d.orden,d.paralelo as paralelo,d.id_nivel,d.id_asignatura as id_asignatura,
       iif(mo.id_modalidad_asignatura=2,3,mo.id_modalidad_asignatura) as id_modalidad_asignatura,
       iif(mo.id_modalidad_asignatura=2,'VIRTUAL',mo.descripcion) as modalidad,
       d.asignatura as asignatura,count(d.id_estudiante_matricula) as estudiantes
from  aca.fn_get_cantidad_matriculados_por_oferta (null,null,95) as d
          inner join aca.malla_asignatura ma on ma.id_malla_asignatura = d.id_malla_asignatura
          inner join aca.planificacion_paralelo pp on pp.id_malla_asignatura = ma.id_malla_asignatura and pp.id_periodo_academico = 95
          inner join aca.modalidad_asignatura mo on mo.id_modalidad_asignatura=pp.id_modalidad_asignatura
-- where d.id_nivel =@pi_id_nivel or @pi_id_nivel is null
group by d.semestre,d.orden,
         d.facultad,d.carrera,d.id_nivel,d.id_oferta_modalidad,d.id_asignatura,d.asignatura,d.paralelo, mo.id_modalidad_asignatura, mo.descripcion
order by d.carrera, d.orden asc

select distinct '2024-2' as periodo,d.facultad,d.id_oferta_modalidad,d.carrera,mo.descripcion as modalidad,
    d.semestre,d.id_malla_asignatura,d.asignatura,d.orden,paralelo,
                count(d.id_estudiante_matricula) as numero_estudiantes
from   aca.oferta_modalidad om
    inner join aca.fn_get_cantidad_matriculados_por_oferta (null,null,36) as d on d.id_oferta_modalidad= om.id_oferta_modalidad
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = d.id_malla_asignatura
inner join aca.planificacion_paralelo pp on pp.id_malla_asignatura = ma.id_malla_asignatura and pp.id_periodo_academico = 36
    inner join aca.modalidad mo on mo.id_modalidad=om.id_modalidad
-- where d.id_nivel in (8,9)
group by d.facultad,d.carrera,d.semestre,d.orden,d.paralelo,d.id_oferta_modalidad, mo.descripcion,d.id_estudiante_matricula,d.id_malla_asignatura,d.asignatura
order by d.facultad,d.carrera, d.paralelo asc
-- ESTUDIANTES POR PARALELO
select distinct '2025-1' as periodo,d.facultad,d.id_oferta_modalidad,d.carrera,mo.descripcion as modalidad,
                d.semestre,d.orden,paralelo,
                count( distinct d.id_estudiante_oferta) as numero_estudiantes
from   aca.oferta_modalidad om
           inner join aca.fn_get_cantidad_matriculados_por_oferta (null,null,95) as d on d.id_oferta_modalidad= om.id_oferta_modalidad
           inner join aca.malla_asignatura ma on ma.id_malla_asignatura = d.id_malla_asignatura
           inner join aca.planificacion_paralelo pp on pp.id_malla_asignatura = ma.id_malla_asignatura and pp.id_periodo_academico = 95
           inner join aca.modalidad mo on mo.id_modalidad=om.id_modalidad
-- where d.id_nivel in (8,9)
group by d.facultad,d.carrera,d.semestre,d.orden,d.paralelo,d.id_oferta_modalidad, mo.descripcion
order by d.facultad,d.carrera, d.paralelo asc

--Reporte numero de estudiantes por modalidad
select d.facultad,d.carrera,c.descripcion as sede,d.id_oferta_modalidad,d.semestre,d.orden,
       d.paralelo as paralelo,d.id_nivel,d.id_asignatura as id_asignatura,
       iif(mo.id_modalidad_asignatura in (2,4),3,mo.id_modalidad_asignatura) as id_modalidad_asignatura,
       iif(mo.id_modalidad_asignatura in (2,4),'VIRTUAL',mo.descripcion) as modalidad,
       d.asignatura as asignatura,count(d.id_estudiante_matricula) as estudiantes
from  aca.fn_get_cantidad_matriculados_por_oferta (null,null,95) as d
          inner join aca.malla_asignatura ma on ma.id_malla_asignatura = d.id_malla_asignatura
          inner join aca.planificacion_paralelo pp on pp.id_malla_asignatura = ma.id_malla_asignatura and pp.id_periodo_academico = 95
          inner join aca.modalidad_asignatura mo on mo.id_modalidad_asignatura=pp.id_modalidad_asignatura
        inner join aca.oferta_modalidad om on om.id_oferta_modalidad = d.id_oferta_modalidad
        inner join aca.oferta o on om.id_oferta = o.id_oferta
        inner join aca.campus c on o.id_campus = c.id_campus
-- where d.id_nivel =@pi_id_nivel or @pi_id_nivel is null
group by d.semestre,d.orden,
         d.facultad,d.carrera,d.id_nivel,d.id_oferta_modalidad,d.id_asignatura,d.asignatura,d.paralelo, mo.id_modalidad_asignatura, mo.descripcion, c.descripcion
order by d.carrera, d.orden asc

select * from aca.modalidad_asignatura

--NUEMRO DE ESTUDIANTES QUE TIENEN MENOS DE 70 EN EL PRIMER CICLO
select d.facultad,d.id_oferta_modalidad,d.carrera,d.id_nivel as semestre,d.id_paralelo as paralelo,d.asignatura,d.docente,count(d.id_estudiante_asignatura) as num_estudiantes from (
select d.nombre as facultad,d.id as id_departamento,omo.id_oferta_modalidad,o.descripcion as carrera,ma.id_nivel,ma.id_malla_asignatura,ea.id_paralelo,
       a.descripcion as asignatura,aux.suma,aux.docente,
case when ma.UICII=0 then   cast (isnull(sum ( cast (aux.suma as decimal(10,2))),0)/2 as decimal(10,2)) else max(aux.suma)end as promedio_real,
round(case when ma.UICII=0 then   cast (isnull(sum ( cast (aux.suma as decimal(10,2))),0)/2 as decimal(10,2)) else max(aux.suma)end,0) as promedio_redondeado,
case when (round(case when ma.UICII=0 then   cast (isnull(sum ( cast (aux.suma as decimal(10,2))),0)/2 as decimal(10,2)) else max(aux.suma)end,0))<70 then 0
when (round(case when ma.UICII=0 then   cast (isnull(sum ( cast (aux.suma as decimal(10,2))),0)/2 as decimal(10,2)) else max(aux.suma)end,0)) is null then 0
else
1 end as aprobado,
		--aux.periodo_academico,aux.id_periodo_academico,ma.codigo_malla,
		ea.id_estudiante_asignatura,p.identificacion
		from aca.estudiante_oferta eo
		inner join man.personas p on p.id = eo.id_persona
		inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
		inner join aca.matricula_general mg on em.id_matricula_general=mg.id_matricula_general
		inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula =  em.id_estudiante_matricula
		inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
		inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
		inner join aca.malla m on m.id_malla = ma.id_malla
		inner join aca.oferta_modalidad omo on omo.id_oferta_modalidad=m.id_oferta_modalidad
		inner join aca.oferta o on omo.id_oferta = o.id_oferta
		inner join aca.departamento_oferta do on do.id_oferta=omo.id_oferta
		inner join man.departamentos d on do.id_departamento = d.id
		inner join aca.nivel n on n.id_nivel = ma.id_nivel
		inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
		left join ( select   ac.id_malla_asignatura,ec.id_estudiante_oferta,pa.codigo as periodo_academico,
		pa.id_periodo_academico,c.id_ciclo,ec.id_estudiante_calificacion,concat(per.apellidos,' ',per.nombres) as docente
		 ,isnull(ec.calificacion,0) as suma from aca.acta_calificacion ac
		inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
		inner join aca.docente d on ec.id_docente = d.id_docente
        inner join man.personas per on per.id = d.id_persona
		inner join aca.componente_aprendizaje ca on ca.id_componente_aprendizaje = ec.id_componente_aprendizaje
		inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
		inner join aca.periodo_academico pa on pa.id_periodo_academico = cg.id_periodo_academico
		inner join aca.ciclo c on c.id_ciclo=ac.id_ciclo
		where ((ca.codigo ='SUMA'  and c.codigo in ('CIC1')) --or (ca.codigo ='SUMATIVA'  and c.codigo in ('RECU') )
		    )
		and ac.estado in ('A','C') and  ec.estado in ('A','C')
		group by ac.id_malla_asignatura,ec.id_estudiante_oferta,pa.codigo,pa.id_periodo_academico,
		c.id_ciclo,ec.calificacion,ec.id_estudiante_calificacion,per.apellidos,per.nombres
		) as aux on aux.id_estudiante_oferta = em.id_estudiante_oferta
		 and aux.id_malla_asignatura = ma.id_malla_asignatura
		 and aux.id_periodo_academico=mg.id_periodo_academico
		where mg.id_periodo_academico in (35)
		and ea.estado ='A' and em.estado ='A' and eo.estado ='A' and mg.estado='A' and m.estado in ('A','P')
--           and eo.id_oferta_modalidad in ( 95,119)
		--eo.id_estudiante_oferta=3378

		group by a.descripcion,ma.UICII,aux.id_periodo_academico, aux.periodo_academico,ma.codigo_malla,ma.id_nivel,omo.id_oferta_modalidad,
		         ma.id_malla_asignatura, p.identificacion, ea.id_estudiante_asignatura, d.nombre, o.descripcion,aux.suma,d.id,ea.id_paralelo,aux.docente
) as d
where d.suma<70 and
      d.id_oferta_modalidad in ( 95,119)
-- d.id_departamento = 5
group by d.facultad,d.carrera,d.id_nivel,d.asignatura, d.id_oferta_modalidad,d.id_paralelo,d.docente
order by d.facultad,d.carrera,d.id_nivel,d.asignatura,d.id_paralelo


--NUMERO DE ESTUDIANTES QUE NO HAN RENDIDO NINGUN EXAMEN
select d.facultad,d.id_oferta_modalidad,d.carrera,d.id_nivel as semestre,d.id_paralelo as paralelo,d.asignatura,d.docente
     ,count(d.id_estudiante_asignatura) as num_estudiantes
from (
select d.nombre as facultad,d.id as id_departamento,omo.id_oferta_modalidad,o.descripcion as carrera,ma.id_nivel,ma.id_malla_asignatura,ea.id_paralelo,
       a.descripcion as asignatura,aux.suma,aux.docente,aux2.suma as notaCiclo2,isnull(aux.numCiclos,0) as ciclo1,isnull(aux2.numCiclos,0) as ciclo2,ea.id_estudiante_asignatura,p.identificacion
		from aca.estudiante_oferta eo
		inner join man.personas p on p.id = eo.id_persona
		inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
		inner join aca.matricula_general mg on em.id_matricula_general=mg.id_matricula_general
		inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula =  em.id_estudiante_matricula
		inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
		inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
		inner join aca.malla m on m.id_malla = ma.id_malla
		inner join aca.oferta_modalidad omo on omo.id_oferta_modalidad=m.id_oferta_modalidad
		inner join aca.oferta o on omo.id_oferta = o.id_oferta
		inner join aca.departamento_oferta do on do.id_oferta=omo.id_oferta
		inner join man.departamentos d on do.id_departamento = d.id
		inner join aca.nivel n on n.id_nivel = ma.id_nivel
		inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
		left join (select ac.id_malla_asignatura,ec.id_estudiante_oferta,pa.codigo as periodo_academico,
		pa.id_periodo_academico,c.id_ciclo,ec.id_estudiante_calificacion,concat(per.apellidos,' ',per.nombres) as docente,ac.id_paralelo
		 ,isnull(ec.calificacion,0) as suma,count(ac.id_ciclo) as numCiclos from aca.acta_calificacion ac
		inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
		inner join aca.docente d on ec.id_docente = d.id_docente
        inner join man.personas per on per.id = d.id_persona
		inner join aca.componente_aprendizaje ca on ca.id_componente_aprendizaje = ec.id_componente_aprendizaje
		inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
		inner join aca.periodo_academico pa on pa.id_periodo_academico = cg.id_periodo_academico
		inner join aca.ciclo c on c.id_ciclo=ac.id_ciclo
		where ((ca.codigo ='SUMATIVA'  and c.codigo in ('CIC1')) --or (ca.codigo ='SUMATIVA'  and c.codigo in ('RECU') )
		    )
        and isnull(ec.calificacion,0)=0
		and ac.estado in ('A','C') and  ec.estado in ('A','C')
		group by ac.id_malla_asignatura,ec.id_estudiante_oferta,pa.codigo,pa.id_periodo_academico,
		c.id_ciclo,ec.calificacion,ec.id_estudiante_calificacion,per.apellidos,per.nombres,ac.id_paralelo
		) as aux on aux.id_estudiante_oferta = em.id_estudiante_oferta and aux.id_malla_asignatura = ma.id_malla_asignatura
            and aux.id_paralelo = ea.id_paralelo and aux.id_periodo_academico=mg.id_periodo_academico
		left join (select ac.id_malla_asignatura,ec.id_estudiante_oferta,pa.codigo as periodo_academico,
		pa.id_periodo_academico,c.id_ciclo,ec.id_estudiante_calificacion,concat(per.apellidos,' ',per.nombres) as docente,ac.id_paralelo
		 ,isnull(ec.calificacion,0) as suma,count(ac.id_ciclo) as numCiclos from aca.acta_calificacion ac
		inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
		inner join aca.docente d on ec.id_docente = d.id_docente
        inner join man.personas per on per.id = d.id_persona
		inner join aca.componente_aprendizaje ca on ca.id_componente_aprendizaje = ec.id_componente_aprendizaje
		inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
		inner join aca.periodo_academico pa on pa.id_periodo_academico = cg.id_periodo_academico
		inner join aca.ciclo c on c.id_ciclo=ac.id_ciclo
		where ((ca.codigo ='SUMATIVA'  and c.codigo in ('CIC2')) --or (ca.codigo ='SUMATIVA'  and c.codigo in ('RECU') )
		    )
        and isnull(ec.calificacion,0)=0
		and ac.estado in ('A','C') and  ec.estado in ('A','C')
		group by ac.id_malla_asignatura,ec.id_estudiante_oferta,pa.codigo,pa.id_periodo_academico,
		c.id_ciclo,ec.calificacion,ec.id_estudiante_calificacion,per.apellidos,per.nombres,ac.id_paralelo
		) as aux2 on aux2.id_estudiante_oferta = em.id_estudiante_oferta and aux2.id_malla_asignatura = ma.id_malla_asignatura
            and aux2.id_paralelo = ea.id_paralelo and aux2.id_periodo_academico=mg.id_periodo_academico
		where mg.id_periodo_academico in (35)
		and ea.estado ='A' and em.estado ='A' and eo.estado ='A' and mg.estado='A' and m.estado in ('A','P')
--         and d.id = 5

		group by a.descripcion,ma.UICII,aux.id_periodo_academico, aux.periodo_academico,ma.codigo_malla,ma.id_nivel,omo.id_oferta_modalidad,
		         ma.id_malla_asignatura, p.identificacion, ea.id_estudiante_asignatura, d.nombre, o.descripcion,d.id,ea.id_paralelo
		         ,aux.docente,aux.id_ciclo,aux.suma,aux.numCiclos,aux2.suma,aux2.numCiclos
) as d
where d.suma=0 and d.id_departamento = 5
  and d.ciclo1 = 1 and d.ciclo2 = 1
group by d.facultad,d.carrera,d.id_nivel,d.asignatura, d.id_oferta_modalidad,d.id_paralelo,d.docente
order by d.facultad,d.carrera,d.id_nivel,d.asignatura,d.id_paralelo


select * from seg.roles_usuarios where usuario_id = 1

select * from aca.fn_get_estudiantes_matriculados_direccion_inline(136,null,null,null,1,null,null) as d
order by d.FACULTAD,d.CARRERA,d.[APELLIDOS Y NOMBRES]

select *from man.personas where direccion like '%BARRION :%'
select * from uath.fn_pa_obtener_personas_con_contratos()

select * from [rep].[fn_matriz_trabajadores_cne](136,null,null)

exec aca.sp_rpt_total_matriculados_por_ofertas 36,null



select * from man.codigo_postal
select * from tmp.codigo_postal


--numero de estudiantes, por numero de vez y paralelo
begin
    declare @id_periodo_academico int=95
    select
            distinct pa.codigo,ofa.facultad,ofa.carrera, ma.id_nivel,ea.id_paralelo,concat(ma.id_nivel,'/',ea.id_paralelo) as curso,
                     a.descripcion as asignatura,ea.codigo_estado_matricula as vez,ma.id_malla_asignatura,count(ea.id_estudiante_asignatura) as matriculados
    from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
    inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
    left join aca.matricula_rubro mr on em.id_estudiante_matricula = mr.id_estudiante_matricula
    --         inner join aca.detalle_estudiante_asignatura dea on ea.id_estudiante_asignatura = dea.id_estudiante_asignatura
    inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
    inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
    inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
    inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
    where ea.estado='A' and em.estado='A' and eo.id_oferta_modalidad in (134,38)
        and mg.id_periodo_academico =@id_periodo_academico
    group by pa.codigo, ofa.facultad, ofa.carrera, ma.id_nivel, a.descripcion, ea.codigo_estado_matricula, ma.id_malla_asignatura, ea.id_paralelo
    order by ofa.facultad,ofa.carrera,ma.id_nivel,a.descripcion,ea.id_paralelo,ea.codigo_estado_matricula
    --    and ma.id_malla_asignatura= 1656
--    and em.estado = 'A'
--   and em.estado = 'A'
--     order by d.nombre, p.apellidos;
end;

--listado de estudiates de octavo semestre
--2407
begin
    declare @id_periodo_academico int=95
    select distinct pa.codigo,om.facultad,om.carrera,p.identificacion,p.apellidos,p.nombres,email_personal,p.email_institucional
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
             inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
             inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
             inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    where --eo.id_estudiante_oferta = 11006
        mg.id_periodo_academico = @id_periodo_academico and om.id_tipo_oferta = 2 and eo.id_nivel_proyectado = 1
    and em.id_estudiante_matricula in (select em1.id_estudiante_matricula from aca.estudiante_asignatura ea
                inner join aca.estudiante_matricula em1 on ea.id_estudiante_matricula = em1.id_estudiante_matricula
                  inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                  inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
                  where ea.estado='A' and aa.estado='A' and ma.estado='A' and em1.estado='A' and ma.id_nivel = 1)
end;

--reporte becas senescyt
begin
    declare @id_periodo_academico int=95
    select p.identificacion,concat(p.apellidos,' ',p.nombres)as nombres_estudiante,om.carrera as nombre_carrera,'TERCER NIVEL' as nivel_academico,pa.codigo as periodo_actual_matriculado,
    pa.fecha_desde as fecha_inicio, pa.fecha_hasta as fecha_fin_periodo_estudios,'GRADO' as nivel_formacion,'NINGUNA' as becas_ortorgadas_institucion
    from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
    inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    where --eo.id_estudiante_oferta = 11006
        mg.id_periodo_academico = @id_periodo_academico and om.id_tipo_oferta = 2
    and em.estado='A'
    order by om.carrera,p.apellidos,p.nombres
end
-- select * from aca.periodo_academico where id_tipo_oferta =2

--separar por nombres

select p.id,p.apellidos,p.nombres,p.primer_nombre,p.segundo_nombre,p.apellido_paterno,p.apellido_materno,fecha_nace from man.personas p where identificacion in ('0914380696')
select identificacion,nombres,apellidos,fecha_nace,id_estado_civil,id_pais_nacionalidad,id_provincia_nacionalidad,id_canton_nacionalidad,id_parroquia_nacionalidad,
       id_pais_residencia,id_provincia_residencia,id_canton_residencia,id_parroquia_residencia
from man.personas where identificacion in ('3050346430')

select * from man.lugar where descripcion='ESPañA'
select * from mig.countries

select dd.*
--     update p set p.primer_nombre = UPPER(dd.primer_nombree), p.segundo_nombre = UPPER(dd.segundo_nombree)
from (
         select
             d.identificacion,d.apellidos,d.nombres,d.cantidad_espacios,d.fecha_ing,d.fecha_mod,
             case when d.primer_nombre = d.nombres then
                      case
                          when d.cantidad_espacios=2 then
                              UPPER(SUBSTRING(d.nombres,0, CHARINDEX(' ', d.nombres, CHARINDEX(' ', d.nombres) + 1)))
                          when d.cantidad_espacios in (3,5) then
                              UPPER(SUBSTRING(d.nombres,0 ,CHARINDEX(' ', d.nombres,CHARINDEX(' ', d.nombres, CHARINDEX(' ', d.nombres) + 1) + 1)))
                          else UPPER(d.primer_nombre)
                          end
                  else UPPER(d.primer_nombre)
                 end as primer_nombree,
             case when d.segundo_nombre = '' or d.segundo_nombre = d.apellidos then
                      case
                          when d.cantidad_espacios=2 then
                              UPPER(SUBSTRING(d.apellidos, CHARINDEX(' ', d.apellidos, CHARINDEX(' ', d.apellidos) + 1) + 1, LEN(d.apellidos)))
                          when d.cantidad_espacios in (3,5)  then
                              UPPER(SUBSTRING(d.apellidos, CHARINDEX(' ', d.apellidos,CHARINDEX(' ', d.apellidos, CHARINDEX(' ', d.apellidos) + 1) + 1) + 1, LEN(d.apellidos)))
                          else UPPER(d.segundo_nombre)
                          end
                  else UPPER(d.segundo_nombre)
                 end as segundo_nombree
         from (
                  SELECT identificacion,apellidos,nombres,LEN(nombres) - LEN(REPLACE(nombres, ' ', '')) AS cantidad_espacios,fecha_ing,fecha_mod,
                         CASE
                             when LEN(nombres) - LEN(REPLACE(nombres, ' ', ''))=1 then
                                 SUBSTRING(nombres, 1, CHARINDEX(' ', nombres) - 1)
                             WHEN CHARINDEX(' ', nombres) > 0 THEN
                                 CASE
                                     WHEN nombres LIKE '% DE LA %' THEN SUBSTRING(nombres, 1, CHARINDEX(' DE LA ', nombres) - 1)
                                     WHEN nombres LIKE '% DE LA ' THEN SUBSTRING(nombres, 1, CHARINDEX(' DE LA ', nombres) - 1)
                                     WHEN nombres LIKE '% DEL %' THEN SUBSTRING(nombres, 1, CHARINDEX(' DEL ', nombres) - 1)
                                     WHEN nombres LIKE '% DEL ' THEN SUBSTRING(nombres, 1, CHARINDEX(' DEL ', nombres) - 1)
                                     WHEN nombres LIKE '% DE %' THEN SUBSTRING(nombres, 1, CHARINDEX(' DE ', nombres) - 1)
                                     WHEN nombres LIKE '% DE ' THEN SUBSTRING(nombres, 1, CHARINDEX(' DE ', nombres) - 1)
                                     WHEN nombres LIKE '% SAN %' THEN SUBSTRING(nombres, 1, CHARINDEX(' SAN ', nombres) - 1)
                                     WHEN nombres LIKE '% SAN ' THEN SUBSTRING(nombres, 1, CHARINDEX(' SAN ', nombres) - 1)
                                     WHEN nombres LIKE '% DE LOS %' THEN SUBSTRING(nombres, 1, CHARINDEX(' DE LOS ', nombres) - 1)
                                     WHEN nombres LIKE '% DE LOS ' THEN SUBSTRING(nombres, 1, CHARINDEX(' DE LOS ', nombres) - 1)
                                     WHEN nombres LIKE '% DI %' THEN SUBSTRING(nombres, 1, CHARINDEX(' DI ', nombres) - 1)
                                     WHEN nombres LIKE '% DI ' THEN SUBSTRING(nombres, 1, CHARINDEX(' DI ', nombres) - 1)
                                     WHEN nombres LIKE '% DE LAS ' THEN SUBSTRING(nombres, 1, CHARINDEX(' DE LAS ', nombres) - 1)
                                     ELSE nombres
                                     END
                             ELSE nombres
                             END AS primer_nombre,
                         CASE
                             when LEN(nombres) - LEN(REPLACE(nombres, ' ', ''))=1 then
                                 SUBSTRING(nombres, CHARINDEX(' ', nombres) + 1, LEN(nombres) - CHARINDEX(' ', nombres))
                             WHEN CHARINDEX(' ', nombres) > 0 THEN
                                 CASE
                                     WHEN nombres LIKE '% MARIA DE LAS %' THEN SUBSTRING(nombres, CHARINDEX('DE LAS ', nombres), LEN(nombres) - CHARINDEX('DE LAS ', nombres) + 1)
                                     WHEN nombres LIKE '% MARIA DE LAS ' THEN SUBSTRING(nombres, CHARINDEX('DE LAS ', nombres) , LEN(nombres) - CHARINDEX('DE LAS ', nombres) + 1)
                                     WHEN nombres LIKE '% DE LA %' THEN SUBSTRING(nombres, CHARINDEX('DE LA ', nombres), LEN(nombres) - CHARINDEX('DE LA ', nombres) + 1)
                                     WHEN nombres LIKE '% DE LA ' THEN SUBSTRING(nombres, CHARINDEX('DE LA ', nombres) , LEN(nombres) - CHARINDEX('DE LA ', nombres) + 1)
                                     WHEN nombres LIKE '% DE LAS %' THEN SUBSTRING(nombres, CHARINDEX('DE LAS ', nombres), LEN(nombres) - CHARINDEX('DE LAS ', nombres) + 1)
                                     WHEN nombres LIKE '% DE LAS ' THEN SUBSTRING(nombres, CHARINDEX('DE LAS ', nombres) , LEN(nombres) - CHARINDEX('DE LAS ', nombres) + 1)
                                     WHEN nombres LIKE '% DEL %' THEN SUBSTRING(nombres, CHARINDEX('DEL ', nombres), LEN(nombres) - CHARINDEX('DEL ', nombres) + 1)
                                     WHEN nombres LIKE '% DEL ' THEN SUBSTRING(nombres, CHARINDEX('DEL ', nombres) , LEN(nombres) - CHARINDEX('DEL ', nombres) + 1)
                                     WHEN nombres LIKE '% DE %' THEN SUBSTRING(nombres, CHARINDEX('DE ', nombres), LEN(nombres) - CHARINDEX('DE ', nombres) + 1)
                                     WHEN nombres LIKE '% DE ' THEN SUBSTRING(nombres, CHARINDEX('DE ', nombres) , LEN(nombres) - CHARINDEX('DE ', nombres) + 1)
                                     WHEN nombres LIKE '% SAN %' THEN SUBSTRING(nombres, CHARINDEX('SAN ', nombres), LEN(nombres) - CHARINDEX('SAN ', nombres) + 1)
                                     WHEN nombres LIKE '% SAN ' THEN SUBSTRING(nombres, CHARINDEX('SAN ', nombres) , LEN(nombres) - CHARINDEX('SAN ', nombres) + 1)
                                     WHEN nombres LIKE '% DE LOS %' THEN SUBSTRING(nombres, CHARINDEX('DE LOS ', nombres), LEN(nombres) - CHARINDEX('DE LOS ', nombres) + 1)
                                     WHEN nombres LIKE '% DE LOS ' THEN SUBSTRING(nombres, CHARINDEX('DE LOS ', nombres) , LEN(nombres) - CHARINDEX('DE LOS ', nombres) + 1)
                                     WHEN nombres LIKE '% DI %' THEN SUBSTRING(nombres, CHARINDEX('DI ', nombres), LEN(nombres) - CHARINDEX('DI ', nombres) + 1)
                                     WHEN nombres LIKE '% DI ' THEN SUBSTRING(nombres, CHARINDEX('DI ', nombres) , LEN(nombres) - CHARINDEX('DI ', nombres) + 1)
                                     ELSE ''
                                     END
                             ELSE ''
                             END AS segundo_nombre
                  FROM man.personas-- where LEN(apellidos) - LEN(REPLACE(apellidos, ' ', ''))>1
              ) as d
-- order by d.apellidos,d.nombres
     ) as dd
         inner join man.personas p on p.identificacion = dd.identificacion
where p.primer_nombre is null and p.segundo_nombre is null

-- select * from aca.asignatura where descripcion ='ANTROMETRÍA Y BIOMECÁNICA'

--reportes carga semanal de los estudiantes
begin
    declare @id_periodo int=5
    select d.codigo,count(distinct d.id_persona) as estudiantes,avg(d.horas)as horas_semanales from (
    select distinct per.codigo,eo.id_persona,(
        select sum(aa.valor) from aca.estudiante_asignatura ea
        inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
        inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
        inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
        where ea.id_estudiante_matricula = em.id_estudiante_matricula
        and ea.estado='A'
        ) as horas--cast(avg(aa.valor) as decimal(3,2)) as horas
    from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
    inner join aca.periodo per on pa.id_periodo = per.id_periodo
    inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    where em.estado='A'  and pa.id_tipo_oferta = 2 and per.id_periodo = @id_periodo
--     and pa.id_periodo_academico in (35,36)
    group by per.codigo, eo.id_persona,em.id_estudiante_matricula) as d
    group by d.codigo
end

--numero docentes
select per.codigo,dc.tipo_relacion_laboral,count(distinct hd.identificacion) as docentes,cast(avg(dhc.horas_maximo) as decimal(4,2)) as horas
from mig.historial_docente hd
inner join aca.periodo_academico pa on hd.periodo = pa.codigo
inner join aca.periodo per on pa.id_periodo = per.id_periodo
inner join man.personas p on p.identificacion = hd.identificacion
inner join aca.docente d on p.id = d.id_persona
inner join aca.docente_historial dh on d.id_docente = dh.id_docente
inner join aca.docente_categoria dc on dh.id_docente_categoria = dc.id_docente_categoria
inner join aca.dedicacion_horas_clase dhc on dc.id_docente_categoria = dhc.id_docente_categoria
where hd.periodo in ('2024','2024-1','2024-2')  and dh.estado='A' and dc.id_docente_categoria not in (12)
and hd.tipo_oferta not in ('DOCTORADO','CENTRO DE IDIOMAS','POSTGRADO') and dc.descripcion not in ('ADMINISTRATIVO') and hd.curso not in ('NIV/1','NIV/2','NIV/3','CARGA COMPLEMENTARIA')
group by per.codigo,dc.tipo_relacion_laboral
--and curso <>'CARGA COMPLEMENTARIA'

select * from mig.historial_docente hd

select * from aca.ofertas_facultad where id_tipo_oferta = 2
select * from aca.estudiante_oferta eo where eo.id_estudiante_oferta = 78884

select * from aca.malla where id_oferta_modalidad = 37

select * from aca.tipo_ingreso_estudiante
--     78884

select * from seg.usuarios where usuario='2450295148'

--reporte deudas de manes de agropecuaria y veterinaria
begin
    declare @id_periodo_academico int=95
    select eo.id_oferta_modalidad,eo.id_estudiante_oferta,p.identificacion,concat(p.apellidos,' ',p.nombres)as nombres_estudiante,om.carrera as nombre_carrera,tee.descripcion,
           isnull((select d.periodoAcademico from [rel].[fn_get_detalle_matricula_by_estudiante_oferta]
                                                  (eo.id_estudiante_oferta,null,1) as d),'NO REGISTRA'),
           (select count(*) from  aca.fn_record_rubros (p.identificacion) d) as numero_deudas,
           (select sum(d.valor) from  aca.fn_record_rubros (p.identificacion) d) as valor_total_pagar,
           (select sum(d.abono) from  aca.fn_record_rubros (p.identificacion) d) as abonos_realizados,
           (select sum(d.deuda) from  aca.fn_record_rubros (p.identificacion) d) as deuda_pendiente
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    where
        om.id_tipo_oferta = 2 and om.id_oferta_modalidad in (20,85)
      and tee.codigo='ACT' and eo.estado='A'
    order by om.carrera,p.apellidos,p.nombres
end
select * from aca.fn_listar_docentes_asignaturas(null,38,95)

-- reporte por numero de vez
select id_periodo_academico,periodoAcademico,facultad ,carrera,d.id_estudiante_matricula,identificacion,nombres,nivel,d.id_malla_asignatura,asignatura,
       case when ea.codigo_estado_matricula='PRI' then '1 VEZ' when ea.codigo_estado_matricula='SEG' then '2 VEZ' else '3 VEZ' end as vez,	paralelo,
       (select dd.nombreDocente from aca.fn_listar_docentes_asignaturas(null,d.id_oferta_modalidad,95) as dd
                 where dd.idAsignaturaAprendizaje = aa.id_asignatura_aprendizaje and dd.idParalelo=d.id_paralelo)
from [aca].[fn_get_estudiantes_matriculados](null ,null,	null ,null,
		5,	95) as d
         inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = d.id_estudiante_matricula
         inner join aca.asignatura_aprendizaje aa on aa.id_malla_asignatura = d.id_malla_asignatura and ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
where ea.codigo_estado_matricula in ('SEG','TER')
  and ea.estado ='A' and aa.estado ='A'
group by  id_periodo_academico ,d.id_estudiante_matricula ,identificacion ,nombres,d.id_malla_asignatura ,asignatura
        ,ea.codigo_estado_matricula,
    facultad ,carrera ,periodoAcademico ,paralelo,nivel,id_nivel,d.id_oferta_modalidad,aa.id_asignatura_aprendizaje,d.id_paralelo
order by facultad,carrera,id_nivel,asignatura,vez,nombres

select * from aca.oferta
select * from aca.tipo_estado_estudiante
select * from aca.periodo_academico where id_tipo_oferta = 2

select * from aca.estudiante_oferta where id_estudiante_oferta in (10951,9169)
--33
begin
select distinct pa.codigo,p.identificacion,eo.id_estudiante_oferta,p.apellidos,p.nombres,tee.codigo,
                (select count(*) from aca.estudiante_asignatura ea where ea.aprobado = 1 and ea.codigo_estado_matricula='TER' and ea.estado='A' and ea.id_estudiante_matricula= em.id_estudiante_matricula) as aprobadas,
                (select count(*) from aca.estudiante_asignatura ea where ea.codigo_estado_matricula='TER' and ea.estado='A' and ea.id_estudiante_matricula= em.id_estudiante_matricula) as totales
        from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
-- inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
-- inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
-- inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
-- inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where  tee.codigo='PERDIDACARRERA' and
--    ea.estado='A' and ea.codigo_estado_matricula ='TER' and
    eo.id_estudiante_oferta in (44211)
select * from man.documentos_archivos



select * from (
select  p.id,u.id as idUser,p.identificacion,p.apellidos,p.nombres,
        ru.fecha_ing,iif(ru.estado='AC',null,u.fecha_mod) as fecha_mod,case  ru.estado when 'AC' then 'ACTIVO' when 'IN' then 'INACTIVO'  when 'EL' then 'INACTIVO' end as estado,
        ROW_NUMBER() OVER (PARTITION BY u.id,ru.rol_id ORDER BY ru.estado,ru.fecha_ing DESC) AS rn,r.descripcion as rol
from aca.estudiante_oferta eo
inner join man.personas p on eo.id_persona = p.id
inner join seg.usuarios u on p.id = u.persona_id
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
inner join seg.roles_usuarios ru on u.id = ru.usuario_id
inner join seg.roles r on ru.rol_id = r.id
where p.estado='AC' and eo.estado='A' and r.codigo in ('ESTUDIANTE','ESTUDIANTEPOSTGRADO')
group by p.identificacion,p.apellidos,p.nombres,u.fecha_ing,u.fecha_mod, p.id, u.id, u.estado, ru.estado, ru.fecha_ing,ru.rol_id,r.descripcion
) as d
         where d.rn in (1,2)
order by d.apellidos,d.nombres


select p.id,u.id,p.identificacion,p.apellidos,p.nombres,
       ru.fecha_ing,iif(ru.estado='AC',null,u.fecha_mod) as fecha_mod,ru.estado,case  ru.estado when 'AC' then 'ACTIVO' when 'IN' then 'INACTIVO'  when 'EL' then 'INACTIVO' end as estado
from aca.docente d
         inner join man.personas p on d.id_persona = p.id
         inner join seg.usuarios u on p.id = u.persona_id
        inner join seg.roles_usuarios ru on u.id = ru.usuario_id
        inner join seg.roles r on ru.rol_id = r.id
--          inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
where p.estado='AC' and r.codigo='DOCENTE'
group by p.identificacion,p.apellidos,p.nombres,ru.fecha_ing,u.fecha_mod, p.id, u.id, ru.estado
order by p.apellidos,p.nombres



--reportes asignaturas a ser dictadas en ingles

SELECT ofa.facultad,ofa.carrera,concat(n.descripcion_corta,'/',pl.descripcion_corta) as curso,ma.id_malla_asignatura,asig.descripcion,ppd.cobertura_idioma,
       i.descripcion,
--        ,ppd.num_estudiantes, ISNULL(aux.prerrequisitos, 0) AS prerrequisitos,
--        iif((SELECT STUFF((
--                              SELECT ', ' + CONCAT(dd.id_malla_asignatura_pre, ' - ', dd.id_nivel_pre, ' - ', dd.prerrequisito)
--                              FROM tmp.fn_get_names_prerrequisitos_by_malla_asignatura(NULL, ma.id_malla_asignatura) AS dd
--                              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
--            )=' -  - ','SIN PRERREQUISITOS',(SELECT STUFF((
--                                                              SELECT ', ' + CONCAT(dd.id_malla_asignatura_pre, ' - ', dd.id_nivel_pre, ' - ', dd.prerrequisito)
--                                                              FROM tmp.fn_get_names_prerrequisitos_by_malla_asignatura(NULL, ma.id_malla_asignatura) AS dd
--                                                              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '')
--            )) AS concatenated_prerrequisitos,
           (select dd.nombreDocente from aca.fn_listar_docentes_asignaturas(null,ofa.id_oferta_modalidad,96) as dd
                                                       where dd.idMallaAsignatura=ma.id_malla_asignatura and dd.idParalelo = pl.id_paralelo) as docente,
        isnull((select top 1 aca.fn_esc_get_horario_by_asignatura_paralelo_periodo_academico(ma.id_malla_asignatura,ppd.id_paralelo,
                                                                                            pp.id_periodo_academico)),'NO REGISTRA') as horario,mas.descripcion as modalidad,
        iif ( aula.aula is not null,aula.aula,iif(mas.descripcion='PRESENCIAL','NO ASIGNADA','NO APLICA')) AS aula
FROM aca.planificacion_paralelo pp
    inner join aca.planificacion_paralelo_detalle ppd on pp.id_planificacion_paralelo = ppd.id_planificacion_paralelo
        inner join aca.modalidad_asignatura mas on mas.id_modalidad_asignatura = ppd.id_modalidad_asignatura
         INNER JOIN aca.malla_asignatura ma ON ma.id_malla_asignatura = pp.id_malla_asignatura
         INNER JOIN aca.malla m ON ma.id_malla = m.id_malla
         INNER JOIN aca.ofertas_facultad ofa ON ofa.id_oferta_modalidad = m.id_oferta_modalidad
         INNER JOIN aca.asignatura asig ON asig.id_asignatura = ma.id_asignatura
         INNER JOIN aca.nivel n ON ma.id_nivel = n.id_nivel
         INNER JOIN aca.paralelo pl ON ppd.id_paralelo = pl.id_paralelo
        inner join man.idioma i on ppd.id_idioma = i.id_idioma

    left join (select h.id_malla_asignatura,h.id_paralelo,h.id_periodo_academico,ef.descripcion as aula,
                      ROW_NUMBER() OVER (PARTITION BY h.id_malla_asignatura,h.id_paralelo ORDER BY h.fecha_ing DESC) AS rn from aca.horario_academico h
		inner join aca.espacio_fisico ef on ef.id_espacio_fisico = h.id_espacio_fisico and ef.estado = 'A' and h.estado='A') as aula on aula.id_malla_asignatura=ma.id_malla_asignatura
    and aula.id_paralelo = ppd.id_paralelo and aula.id_periodo_academico =pp.id_periodo_academico and aula.rn =1
        left join (
    select ma1.id_malla_asignatura,a1.descripcion as asignatura,count(a1.id_asignatura) as prerrequisitos from   aca.malla_asignatura ma1
    inner join aca.asignatura_relacion ar on ma1.id_malla_asignatura = ar.id_malla_asignatura
    inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
    inner join aca.malla_asignatura ma2 on ma2.id_malla_asignatura = ar.id_malla_asignatura_relacion
    inner join aca.asignatura a2 on a2.id_asignatura = ma2.id_asignatura
    where ar.estado='A' and a1.estado='A' and a2.estado='A' and ar.tipo_relacion='PRE' --and ma1.id_malla_asignatura= ma.id_malla_asignatura
    group by ma1.id_malla_asignatura,a1.descripcion
) as aux on aux.id_malla_asignatura = ma.id_malla_asignatura
where pp.estado='A' and pp.ofertada=1 and ppd.estado='A' and ma.estado='A' and asig.estado='A' and n.estado ='A' and pl.estado='A' and pp.id_periodo_academico = 96
and ppd.cobertura_idioma<>'NOAPLICA'
order by ofa.facultad,ofa.carrera,ma.id_nivel,asig.descripcion;

select * from pro.tipo_proceso_estado

                  select * from [aca].[fn_record_academico_sga_definitivo](5913,NULL,null,NULL)

exec [rep].[rpt_generate_nomina_estudiantes_planificados_ingles] 96,null,null,null
select * from aca.malla

select * from aca.campus

select * from aca.fn_get_info_estudiante_by_periodo(14,14,14)

--para generar carnets ajá
select * from [tmp].[fn_get_info_users_auxiliar]('0918171646')

--posibles manes que no se matricularon
--716 manes egeresado
select d.* from (
select
eo.id_estudiante_oferta,eo.id_periodo_academico,om.facultad,om.carrera,eo.ultimo_periodo,p.identificacion,p.apellidos,p.nombres,p.email_personal,p.celular,eo.id_nivel_proyectado,
(select count(*) from aca.malla_asignatura ma  where ma.estado='A' and ma.id_malla=m.id_malla and ma.id_nivel =m.id_nivel_max_aperturado) as materias_ultimo_semestre,
(select count(*) FROM aca.fn_record_academico_sga_definitivo(eo.id_estudiante_oferta, m.id_nivel_max_aperturado, null, 1) as d) as materias_ultimo_semestre_aprobadas
--     eo.*
     from aca.estudiante_oferta eo
inner join aca.malla m on eo.id_malla = m.id_malla
inner join man.personas p on eo.id_persona = p.id
inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
where
  om.id_tipo_oferta = 2 and eo.estado='A' and eo.id_tipo_estado_estudiante = 1 and eo.ultimo_periodo='2025-1'
) as d
where d.materias_ultimo_semestre_aprobadas<d.materias_ultimo_semestre



--terceras matriculas
begin
    declare @id_periodo_academico int=96
    select
        distinct ea.id_estudiante_asignatura,om.id_oferta_modalidad,pa.codigo,om.carrera,p.identificacion,p.apellidos,p.nombres,
                 eo.numero_matricula, ma.id_nivel, ma.id_malla_asignatura,ea.id_paralelo,ea.id_estudiante_asignatura,a.descripcion as asignatura,
                 case when ea.estado is null then 'NO MATRICULADO' when ea.estado = 'X' then 'ANULADA'
                     when ea.estado = 'A' then 'ACTIVA'    when ea.estado = 'I' then 'INACTIVA'
                     else ea.estado end as estado_Matricula,em.fecha_ing as fechaMatricula,em.fecha_mod as fechaModMatricula,
                 concat(pu.nombres, ' ', pu.apellidos)   as usuarioCreaMatricula,
                 concat(pu2.nombres, ' ', pu2.apellidos) as usuarioModificomatricula,ea.codigo_estado_matricula,ea.promedio
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
             inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
             inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
             inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
             left join aca.matricula_rubro mr on em.id_estudiante_matricula = mr.id_estudiante_matricula
--         inner join aca.detalle_estudiante_asignatura dea on ea.id_estudiante_asignatura = dea.id_estudiante_asignatura
             inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
             inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
             inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
             left join seg.usuarios u on u.usuario = ea.usuario_ing
             left join man.personas pu on pu.id = u.persona_id
             left join seg.usuarios u2 on u2.usuario = ea.usuario_mod
             left join man.personas pu2 on pu2.id = u2.persona_id
    where --eo.id_estudiante_oferta = 11006
        mg.id_periodo_academico = @id_periodo_academico and ea.codigo_estado_matricula ='TER' and
        om.id_tipo_oferta = 2 and om.id_oferta_modalidad = 85
end;

exec aca.sp_rpt_total_matriculados_por_ofertas 96  , null

begin
    declare @id_periodo_academico int = 96
select    ROW_NUMBER() OVER (ORDER BY om.carrera) AS rn,om.id_oferta_modalidad,om.facultad, om.carrera, o.descripcion_corta,
          count(num.id_estudiante_matricula) as numeroEst,
          om.modalidad,om.sistema_estudio,pa.codigo as periodo
from aca.ofertas_facultad om
         inner join aca.oferta o on o.id_oferta= om.id_oferta
         inner join aca.periodo_academico_oferta pao on pao.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.periodo_academico pa on pao.id_periodo_academico = pa.id_periodo_academico
         left join(select pa1.codigo, do.id_departamento_oferta, em.id_estudiante_matricula,pa1.id_periodo_academico
                   from aca.matricula_general mg
                            inner join aca.estudiante_matricula em   on em.id_matricula_general = mg.id_matricula_general
                            inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
                            inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
                            inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
                            inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
                            inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = mg.id_periodo_academico
                   where  eo.estado = 'A' and em.estado = 'A'
                     and mg.estado = 'A' and om.estado = 'A'
                     and do.estado = 'A' and pa1.estado = 'A' and ea.estado='A' and ea.aprobado= 1
                   group by pa1.codigo, do.id_departamento_oferta, em.id_estudiante_matricula,pa1.id_periodo_academico) as num on om.id_departamento_oferta = num.id_departamento_oferta
and num.id_periodo_academico = pa.id_periodo_academico
where o.estado = 'A' and pao.estado = 'A' and pao.id_periodo_academico< @id_periodo_academico and pa.codigo_tipo_periodo='PAORD'
and om.id_oferta_modalidad in (84,82)
group by om.facultad, om.carrera, o.descripcion_corta, om.modalidad, om.sistema_estudio, pa.codigo,om.id_oferta_modalidad,om.id_departamento_oferta
order by om.carrera
end


--reportes de porcentajes de aprobados
begin
    declare @pi_id_facultad int =null,@pi_id_oferta_modalidad int= null,@pi_id_periodo_academico int =95
        select pa.codigo as periodo,ofa.facultad,ofa.carrera,per.identificacion,per.apellidos,per.nombres,concat(n.descripcion_corta,'/',ea.id_paralelo)as curso,--n.descripcion_corta as nivel,ea.id_paralelo as paralelo,
               a.descripcion as asignatura
        ,ofa.id_oferta_modalidad,ea.promedio,ea.estado,case when ea.estado='A' then 'ACTIVO' when ea.estado in ('N') then 'ANULADO'
                                                            when ea.estado in ('R','T','X','P') then 'RETIRADO' else '' end as estado

        from aca.estudiante_oferta eo
         inner join man.personas per on per.id = eo.id_persona
        inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
        inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
        inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
        inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
        inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
        inner join aca.nivel n on n.id_nivel = ma.id_nivel
        inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
        inner join aca.paralelo p on ea.id_paralelo=p.id_paralelo
        inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
        inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
        where  (eo.id_oferta_modalidad =@pi_id_oferta_modalidad or @pi_id_oferta_modalidad is null)
        and ea.estado not in ('E','Q','I','N') and p.estado='A' and em.estado not in ('E','Q','I','N') and mg.estado='A' and ofa.id_tipo_oferta = 2
          --and eo.id_oferta_modalidad in (84,82) and mg.id_periodo_academico<96
        group by mg.id_periodo_academico,ea.id_paralelo,p.descripcion, p.descripcion_corta,
        ea.promedio,ea.id_estudiante_asignatura,ea.aprobado,per.sexo, pa.codigo, a.descripcion, n.descripcion_corta, ofa.facultad, ofa.carrera, ofa.id_oferta_modalidad, per.identificacion, per.apellidos, per.nombres, ea.estado
    order by ofa.facultad,ofa.carrera,per.apellidos,per.nombres
end

--estudiantes que consiguieron movilidad interna
begin
    select
        distinct pa.codigo,ofa.facultad,ofa.carrera as carrera_actual,tee.descripcion,tie.descripcion,eop.id_oferta_modalidad,ofap.carrera as carrera_anterior,deop.tipo_ingreso_estudiante,deop.estado_carrera
                          ,p.identificacion,p.apellidos,p.nombres
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.estudiante_oferta eop on eop.id_estudiante_oferta = eo.id_estudiante_oferta_padre
            inner join aca.estudiantes_ofertas deop on deop.id_estudiante_oferta = eop.id_estudiante_oferta
             left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_ingreso_estudiante tie on tie.id_tipo_ingreso_estudiante = eo.id_tipo_ingreso_estudiante
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
             inner join aca.ofertas_facultad ofap on ofap.id_oferta_modalidad = eop.id_oferta_modalidad
    where eo.estado='A' and eop.estado='A' and ofap.id_tipo_oferta = 2 and ofa.id_tipo_oferta =2 and eop.id_oferta_modalidad =20
    and eo.id_oferta_modalidad <>20
    order by pa.codigo
end;

--mejores promedios acumulativos
begin
    select top 10 * from (
    select distinct --pa.codigo as PERIODO_ACADEMICO,
        om.facultad,om.carrera,te.descripcion as tipo_identificacion,p.identificacion AS IDENTIFICACION,p.apellidos,
        p.nombres as NOMBRES,( select sum(ma1.num_creditos) as creditos
                               from [aca].[fn_record_academico_sga_definitivo](eo.id_estudiante_oferta,null,null,1) as d
                                        inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = d.idMallaAsignatura
                               where ma1.estado='A') as TOTAL_CREDITOS_APROBADOS,
                    ( select avg(d.promedio) as creditos
                      from [aca].[fn_record_academico_sga_definitivo](eo.id_estudiante_oferta,null,null,1) as d) as promedio,
        (select top (1) niv.orden as semestre
         from aca.matricula_general mg
                  inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
                  inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
                  inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
                  inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
                  inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
                  inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
                  inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
         where  eo1.id_estudiante_oferta = eo.id_estudiante_oferta and mg.id_periodo_academico = 96
           and eo1.estado='A' and em1.estado='A' and ea.estado='A'
           and mg.estado='A'   and aa.estado='A'
           and ma.estado='A' and niv.estado='A'
         group by em1.id_estudiante_matricula,niv.descripcion_corta ,niv.ORDEN,par.descripcion_corta,par.orden
         order by  count (ea.id_asignatura_aprendizaje) desc,count (par.descripcion_corta) desc) as semestre_actual,
        iif(eo.mantiene_gratuidad=0,'SI','NO') as PERDIDA_GRATUIDAD
    from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.malla m on m.id_malla = eo.id_malla
    inner join man.tipo_identificacion te on te.id_tipo_identificacion = p.id_tipo_identificacion
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
    inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
    inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
    inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    where p.estado='AC' and eo.estado='A' and em.estado = 'A' and ea.estado='A' and tee.codigo in ('ACT')
    and  om.id_oferta_modalidad = 87 and ma.id_nivel = 8 and mg.id_periodo_academico = 96
    group by pa.codigo,te.descripcion,p.id,p.identificacion,p.apellidos,p.nombres, p.apellido_paterno,
    p.apellido_materno,eo.mantiene_gratuidad,eo.id_estudiante_oferta, om.facultad, om.carrera
    ) as d
    order by d.carrera,d.promedio desc
end;

select * from aca.ofertas_facultad where id_tipo_oferta = 2
select * from man.personas where identificacion='0928359595';

select * from aca.tipo_estado_estudiante
--56 993
--set egresados
begin
declare @pi_id_periodo_academico int = 96
-- update eo set eo.id_tipo_estado_estudiante = 4 ,eo.usuario_mod='2400254286',eo.fecha_mod=getdate()
select d.*
from (
select eo.id_estudiante_oferta,eo.id_malla,om.facultad,om.carrera as oferta, om.modalidad, om.id_oferta_modalidad ,--aux.semestre as nivel,
   ( select count(ma1.id_malla_asignatura)
             from aca.malla m1
             inner join aca.malla_asignatura ma1 on m1.id_malla=ma1.id_malla
             inner join aca.nivel niv1 on ma1.id_nivel=niv1.id_nivel
             where  m1.id_malla = eo.id_malla and niv1.id_nivel = mal.id_nivel_max_aperturado
             and ma1.estado='A' and niv1.estado='A'
             group by ma1.id_malla) as numeroMateriasOctavo
,
-- (select count(*) from [aca].[fn_record_academico_sga_definitivo](eo.id_estudiante_oferta,mal.id_nivel_max_aperturado,null,1)) as AprobadasOctavo,
    (aux.AprobadasOctavo+isnull(aux1.AprobadasOctavo,0)) as  AprobadasOctavo,
eo.numero_matricula,p.identificacion,p.apellidos,p.nombres,tee.descripcion as estado_carrera,ro.id_record_oferta
 from aca.estudiante_oferta eo
inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
inner join aca.malla mal on mal.id_malla = eo.id_malla
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
 inner join aca.ofertas_facultad om on eo.id_oferta_modalidad=om.id_oferta_modalidad
 inner join man.personas p on eo.id_persona=p.id
inner join (select  eo1.id_estudiante_oferta,niv.id_nivel,count(ea.id_estudiante_asignatura) as AprobadasOctavo
--                  , ROW_NUMBER() OVER (PARTITION BY eo1.id_estudiante_oferta ORDER BY  niv.orden DESC) AS rn
             from aca.matricula_general mg
             inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
             inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
             inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
             inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
             where  eo1.estado='A' and em1.estado='A' and ea.estado='A'  and mg.estado='A'
               and aa.estado='A'  and ma.estado='A' and niv.estado='A' and ea.aprobado=1
             group by eo1.id_estudiante_oferta,niv.ORDEN,niv.id_nivel
             ) as aux on aux.id_estudiante_oferta = eo.id_estudiante_oferta and aux.id_nivel = mal.id_nivel_max_aperturado
     left join (select  eo1.id_estudiante_oferta,niv.id_nivel,count(dm.id_detalle_movilidad) as AprobadasOctavo
--                  , ROW_NUMBER() OVER (PARTITION BY eo1.id_estudiante_oferta ORDER BY  niv.orden DESC) AS rn
             from aca.movilidad m
            inner join aca.detalle_movilidad dm on  m.id_movilidad = dm.id_movilidad
             inner join aca.estudiante_oferta eo1 on m.id_estudiante_oferta = eo1.id_estudiante_oferta
             inner join aca.malla_asignatura ma on dm.id_malla_asignatura=ma.id_malla_asignatura
             inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
             where  eo1.estado='A' and dm.estado='A' and  m.estado='A'
            and ma.estado='A' and niv.estado='A' and dm.aprobado=1
             group by eo1.id_estudiante_oferta,niv.ORDEN,niv.id_nivel
             ) as aux1 on aux1.id_estudiante_oferta = eo.id_estudiante_oferta and aux1.id_nivel = mal.id_nivel_max_aperturado
 left join mig.record_oferta ro on ro.id_estudiante_oferta = eo.id_estudiante_oferta

 where mg.id_periodo_academico not in (@pi_id_periodo_academico) and
    eo.estado='A'  AND tee.codigo='ACT' and om.id_tipo_oferta = 2
 and em.estado='A' --and mg.estado='A' and p.identificacion='0924546625'
 group by p.identificacion,p.nombres,p.apellidos,
 eo.numero_matricula,eo.id_malla,om.carrera ,om.modalidad , om.id_oferta_modalidad ,om.facultad,om.carrera,p.id ,eo.id_estudiante_oferta,
tee.descripcion,mal.id_nivel_max_aperturado,ro.id_record_oferta,aux.AprobadasOctavo,aux1.AprobadasOctavo
) as d
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = d.id_estudiante_oferta
-- inner join mig.record_oferta ro on ro.id_record_oferta = d.id_record_oferta
         where
--              d.nivel = (select mm.id_nivel_max_aperturado from aca.malla mm where mm.id_malla = d.id_malla)
d.numeroMateriasOctavo = d.AprobadasOctavo
--            and  d.id_oferta_modalidad =91
-- order by d.facultad,d.oferta,d.apellidos,d.nombres
end

select count(*) from aca.fn_record_academico_sga_definitivo(27223,3,null,1)
select count(ma.id_malla_asignatura) from aca.malla m
inner join aca.malla_asignatura ma on m.id_malla = ma.id_malla
inner join aca.estudiante_oferta eo on m.id_malla = eo.id_malla
where eo.estado='A' and m.estado in ('A','P') and eo.id_estudiante_oferta=27223 and ma.id_nivel = 3

select *from aca.fn_record_academico_sga_definitivo(27223,3,null,1)


--reporte de asistencia de estudiantes
SELECT oferta, identificacion, estudiante , count(asignatura) as cantidad_asignatura FROM [aca].[fn_rpt_asistencias_clase_porcentaje_sin_docente] (96,NULL,NULL)
                                                                                     WHERE FALTA>15.00
group by oferta,identificacion, estudiante

--reporte de asistencia de estudiantes detallado
SELECT * FROM [aca].[fn_rpt_asistencias_clase_porcentaje_sin_docente] (96,NULL,NULL) as d;
--determinar si la vez tercera esta correcta
begin
    declare @id_periodo_academico int = null,@vez varchar(5)='SEG'
select *
--     distinct d.identificacion
from (
select distinct ofa.facultad,ofa.carrera,eo.id_oferta_modalidad,pa.codigo as periodo,p.identificacion,eo.id_estudiante_oferta,p.apellidos,p.nombres,tee.codigo as tipo_estado,ma.id_nivel,a.descripcion as asignatura,
                ea.promedio,ma.id_malla_asignatura,ea.id_paralelo,(select count(*) from aca.estudiante_asignatura ea1
                                 inner join aca.estudiante_matricula em1 on ea1.id_estudiante_matricula = em1.id_estudiante_matricula
                                inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
                                inner join aca.periodo_academico pa1 on mg1.id_periodo_academico = pa1.id_periodo_academico
                                 where ea1.aprobado = 0 and ea1.codigo_estado_matricula=@vez and ea1.estado='A' and em1.estado='A' and em1.id_estudiante_oferta= em.id_estudiante_oferta
                                   and pa1.codigo not in ('2022','2022-1','2022-2','2023-1') and pa1.codigo<=pa.codigo
                                 and ea1.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje and em1.id_estudiante_matricula<>em.id_estudiante_matricula) as reprobadasSegundo,
                (select top 1 CONCAT(p.apellidos,' ',p.nombres) as docente from aca.acta_calificacion ac
                                                                                    inner join aca.ciclo c on ac.id_ciclo = c.id_ciclo
                                                                                    inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
                                                                                    inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
                                                                                    inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                                                                                    inner join aca.docente dd on dd.id_docente = ec.id_docente
                                                                                    inner join man.personas p on p.id = dd.id_persona
                 where ac.id_malla_asignatura=ma.id_malla_asignatura and cg.id_periodo_academico =96 and ac.id_paralelo = ea.id_paralelo
                   and  (ca.codigo ='SUMATIVA'  and c.codigo in ('CIC2'))) as docente,p.celular,p.telefono
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
        inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
         inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
         inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
        inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
        inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
        inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
        inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
-- inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
-- inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
-- inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
-- inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where  tee.codigo='ACT' and (mg.id_periodo_academico = @id_periodo_academico or @id_periodo_academico is null) and ea.estado='A' and em.estado='A' and ea.codigo_estado_matricula=@vez
-- and ea.aprobado = 1
) as d
    where d.reprobadasSegundo>0
    order by d.carrera,d.asignatura
end;

select * from man.personas where email_personal ='quirumbaynixon380@gmail.com' or email_institucional='quirumbaynixon380@gmail.com';
select * from aca.componente_aprendizaje

select * from aca.ciclo
--reporte de estudiantes que reprueban por faltas pero aprueban por nota
begin
    declare @id_periodo_academico int = 96
    select d.facultad, carrera, id_estudiante_oferta, numero_matricula, periodo, identificacion, apellidos, nombres, asignatura,d.C1,d.C2,iif(d.REC=0,null,d.REC) as REC, d.promedio, asistencia,d.docente,
           iif(d.REC=0 or d.REC is null,'APRUEBA SIN RECUPERACION','APRUEBA EN RECUPERACION')  as tipo from(
    select
        distinct ofa.facultad,ofa.carrera,eo.id_estudiante_oferta,eo.numero_matricula,pa.codigo as periodo,p.identificacion,p.apellidos,p.nombres,concat(ma.id_nivel,' - ',a.descripcion) as asignatura,
                 (select ec.calificacion from aca.estudiante_calificacion ec
                                                                                    inner join aca.acta_calificacion ac1 on ec.id_acta_calificacion = ac1.id_acta_calificacion
                                                                                    inner join aca.ciclo c1 on ac1.id_ciclo = c1.id_ciclo
                                                                                    inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                  where ec.estado='A' and ac1.estado in ('A','C') and ec.id_estudiante_oferta = eo.id_estudiante_oferta and ac1.id_calificacion_general = cg.id_calificacion_general
                    and  ac1.id_malla_asignatura=ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo
                    and  (ca.codigo ='SUMA'  and c1.codigo in ('CIC1'))) as C1,
                 (select ec.calificacion from aca.estudiante_calificacion ec
                                                        inner join aca.acta_calificacion ac1 on ec.id_acta_calificacion = ac1.id_acta_calificacion
                                                        inner join aca.ciclo c1 on ac1.id_ciclo = c1.id_ciclo
                                                        inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                  where ec.estado='A' and ac1.estado in ('A','C') and ec.id_estudiante_oferta = eo.id_estudiante_oferta and ac1.id_calificacion_general = cg.id_calificacion_general
                    and  ac1.id_malla_asignatura=ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo
                    and  (ca.codigo ='SUMA'  and c1.codigo in ('CIC2'))) as C2,
                 (select ec.calificacion from aca.estudiante_calificacion ec
                                                        inner join aca.acta_calificacion ac1 on ec.id_acta_calificacion = ac1.id_acta_calificacion
                                                        inner join aca.ciclo c1 on ac1.id_ciclo = c1.id_ciclo
                                                        inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                  where ec.estado='A' and ac1.estado in ('A','C') and ec.id_estudiante_oferta = eo.id_estudiante_oferta and ac1.id_calificacion_general = cg.id_calificacion_general
                    and  ac1.id_malla_asignatura=ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo
                    and  (ca.codigo ='SUMATIVA'  and c1.codigo in ('RECU'))) as REC,
                 ea.promedio,ea.asistencia,
                 (select top 1 CONCAT(p.apellidos,' ',p.nombres) as docente from aca.acta_calificacion ac
                                                                                     inner join aca.ciclo c on ac.id_ciclo = c.id_ciclo
                                                                                     inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
                                                                                     inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
                                                                                     inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                                                                                     inner join aca.docente dd on dd.id_docente = ec.id_docente
                                                                                     inner join man.personas p on p.id = dd.id_persona
                  where ac.id_malla_asignatura=ma.id_malla_asignatura and cg.id_periodo_academico =@id_periodo_academico and ac.id_paralelo = ea.id_paralelo
                    and  (ca.codigo ='SUMATIVA'  and c.codigo in ('CIC2'))) as docente
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
            inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
            inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
            inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
            inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
            inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
            inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
            inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
            inner join aca.calificacion_general cg on pa.id_periodo_academico = cg.id_periodo_academico
    where mg.id_periodo_academico = @id_periodo_academico and em.estado='A' and ea.estado='A' and ea.aprobado=1 and ea.asistencia<85
    ) as d
    order by d.facultad,d.carrera,d.apellidos,d.nombres
end

--reporte de estudiantes que no les dejaron rendir examen de segundo ciclo
begin
    declare @id_periodo_academico int = 96
    select d.facultad, carrera, id_estudiante_oferta, numero_matricula, periodo, identificacion, apellidos, nombres, asignatura,d.ExamenC1,d.C1,d.ExamenC2,d.C2,iif(d.REC=0,null,d.REC) as REC,
           d.promedio, asistencia,d.docente,iif(d.REC=0 or d.REC is null,'NO RINDIÓ RECUPERACION','RINDIÓ RECUPERACION')  as tipo from(
    select
        distinct ofa.facultad,ofa.carrera,eo.id_estudiante_oferta,eo.numero_matricula,pa.codigo as periodo,p.identificacion,p.apellidos,p.nombres,concat(ma.id_nivel,' - ',a.descripcion) as asignatura,
                 (select ec.calificacion from aca.estudiante_calificacion ec
                                                                                    inner join aca.acta_calificacion ac1 on ec.id_acta_calificacion = ac1.id_acta_calificacion
                                                                                    inner join aca.ciclo c1 on ac1.id_ciclo = c1.id_ciclo
                                                                                    inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                  where ec.estado='A' and ac1.estado in ('A','C') and ec.id_estudiante_oferta = eo.id_estudiante_oferta and ac1.id_calificacion_general = cg.id_calificacion_general
                    and  ac1.id_malla_asignatura=ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo
                    and  (ca.codigo ='SUMATIVA'  and c1.codigo in ('CIC1'))) as ExamenC1,
                 (select ec.calificacion from aca.estudiante_calificacion ec
                                                  inner join aca.acta_calificacion ac1 on ec.id_acta_calificacion = ac1.id_acta_calificacion
                                                  inner join aca.ciclo c1 on ac1.id_ciclo = c1.id_ciclo
                                                  inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                  where ec.estado='A' and ac1.estado in ('A','C') and ec.id_estudiante_oferta = eo.id_estudiante_oferta and ac1.id_calificacion_general = cg.id_calificacion_general
                    and  ac1.id_malla_asignatura=ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo
                    and  (ca.codigo ='SUMA'  and c1.codigo in ('CIC1'))) as C1,
                 (select ec.calificacion from aca.estudiante_calificacion ec
                                                  inner join aca.acta_calificacion ac1 on ec.id_acta_calificacion = ac1.id_acta_calificacion
                                                  inner join aca.ciclo c1 on ac1.id_ciclo = c1.id_ciclo
                                                  inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                  where ec.estado='A' and ac1.estado in ('A','C') and ec.id_estudiante_oferta = eo.id_estudiante_oferta and ac1.id_calificacion_general = cg.id_calificacion_general
                    and  ac1.id_malla_asignatura=ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo
                    and  (ca.codigo ='SUMATIVA'  and c1.codigo in ('CIC2'))) as ExamenC2,
                 (select ec.calificacion from aca.estudiante_calificacion ec
                                                        inner join aca.acta_calificacion ac1 on ec.id_acta_calificacion = ac1.id_acta_calificacion
                                                        inner join aca.ciclo c1 on ac1.id_ciclo = c1.id_ciclo
                                                        inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                  where ec.estado='A' and ac1.estado in ('A','C') and ec.id_estudiante_oferta = eo.id_estudiante_oferta and ac1.id_calificacion_general = cg.id_calificacion_general
                    and  ac1.id_malla_asignatura=ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo
                    and  (ca.codigo ='SUMA'  and c1.codigo in ('CIC2'))) as C2,
                 (select ec.calificacion from aca.estudiante_calificacion ec
                                                        inner join aca.acta_calificacion ac1 on ec.id_acta_calificacion = ac1.id_acta_calificacion
                                                        inner join aca.ciclo c1 on ac1.id_ciclo = c1.id_ciclo
                                                        inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                  where ec.estado='A' and ac1.estado in ('A','C') and ec.id_estudiante_oferta = eo.id_estudiante_oferta and ac1.id_calificacion_general = cg.id_calificacion_general
                    and  ac1.id_malla_asignatura=ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo
                    and  (ca.codigo ='SUMATIVA'  and c1.codigo in ('RECU'))) as REC,
                 ea.promedio,ea.asistencia,
                 (select top 1 CONCAT(p.apellidos,' ',p.nombres) as docente from aca.acta_calificacion ac
                                                                                     inner join aca.ciclo c on ac.id_ciclo = c.id_ciclo
                                                                                     inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
                                                                                     inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
                                                                                     inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                                                                                     inner join aca.docente dd on dd.id_docente = ec.id_docente
                                                                                     inner join man.personas p on p.id = dd.id_persona
                  where ac.id_malla_asignatura=ma.id_malla_asignatura and cg.id_periodo_academico =@id_periodo_academico and ac.id_paralelo = ea.id_paralelo
                    and  (ca.codigo ='SUMATIVA'  and c.codigo in ('CIC2'))) as docente
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
            inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
            inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
            inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
            inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
            inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
            inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
            inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
            inner join aca.calificacion_general cg on pa.id_periodo_academico = cg.id_periodo_academico
    where mg.id_periodo_academico = @id_periodo_academico and em.estado='A' and ea.estado='A' and ea.aprobado=0
    ) as d
       where d.ExamenC1>0 and d.ExamenC2=0
    order by d.facultad,d.carrera,d.apellidos,d.nombres
end


--materias dictadas en ingles
SELECT pa.codigo as periodo, ofa.facultad,ofa.carrera,ma.id_malla_asignatura,concat(ma.id_nivel, ' - ', asig.descripcion) as asignatura,
       isnull(ppd.cobertura_idioma,'NO REGISTRA') as cobertura_idioma, i.descripcion, ppd.num_estudiantes,ISNULL(aux.prerrequisitos, 0) AS prerrequisitos,
       iif((SELECT STUFF((SELECT ', ' + CONCAT(dd.id_malla_asignatura_pre, ' - ', dd.id_nivel_pre, ' - ', dd.prerrequisito)
          FROM tmp.fn_get_names_prerrequisitos_by_malla_asignatura(NULL, ma.id_malla_asignatura) AS dd
          FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '')) = ' -  - ', 'SIN PRERREQUISITOS', (SELECT STUFF((SELECT ', ' + CONCAT(dd.id_malla_asignatura_pre, ' - ', dd.id_nivel_pre,
                                                                     ' - ', dd.prerrequisito)
            FROM tmp.fn_get_names_prerrequisitos_by_malla_asignatura(NULL, ma.id_malla_asignatura) AS dd
            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2,''))) AS concatenated_prerrequisitos,
       ofa.id_oferta_modalidad,
       ma.id_nivel                                                                                                 as id_nivel,
       UPPER(concat(P.apellidos, ' ', P.nombres)) AS docente, p.email_institucional, p.identificacion
FROM aca.planificacion_paralelo pp
         inner join aca.periodo_academico pa on pa.id_periodo_academico = pp.id_periodo_academico
         INNER JOIN aca.planificacion_paralelo_detalle ppd
                    ON pp.id_planificacion_paralelo = ppd.id_planificacion_paralelo
         INNER JOIN aca.malla_asignatura ma ON ma.id_malla_asignatura = pp.id_malla_asignatura
         INNER JOIN aca.asignatura_aprendizaje AA ON AA.id_malla_asignatura = MA.id_malla_asignatura AND AA.estado = 'A'
         INNER JOIN aca.docente_asignatura_aprend DAA ON AA.id_asignatura_aprendizaje = DAA.id_asignatura_aprendizaje and ppd.id_paralelo = daa.id_paralelo AND DAA.estado = 'A'
         INNER JOIN aca.distributivo_docente DD ON DAA.id_distributivo_docente = DD.id_distributivo_docente AND DD.estado = 'A'
         INNER JOIN aca.distributivo_oferta DOF ON DD.id_distributivo_oferta = DOF.id_distributivo_oferta AND DD.estado = 'A'
         INNER JOIN aca.periodo_academico_oferta PAO ON DOF.id_periodo_academico_oferta = PAO.id_periodo_academico_oferta AND PA.id_periodo_academico = PAO.id_periodo_academico
         INNER JOIN aca.docente D ON D.id_docente = DD.id_docente
         INNER JOIN man.personas P ON P.id = D.id_persona
         INNER JOIN aca.malla m ON ma.id_malla = m.id_malla
         INNER JOIN aca.ofertas_facultad ofa ON ofa.id_oferta_modalidad = m.id_oferta_modalidad
         INNER JOIN aca.asignatura asig ON asig.id_asignatura = ma.id_asignatura
         INNER JOIN aca.nivel n ON ma.id_nivel = n.id_nivel
         INNER JOIN aca.paralelo pl ON ppd.id_paralelo = pl.id_paralelo
         INNER JOIN man.idioma i ON ppd.id_idioma = i.id_idioma
         LEFT JOIN (SELECT ma1.id_malla_asignatura,
                           COUNT(a1.id_asignatura) AS prerrequisitos
                    FROM aca.malla_asignatura ma1
                             INNER JOIN aca.asignatura_relacion ar ON ma1.id_malla_asignatura = ar.id_malla_asignatura
                             INNER JOIN aca.asignatura a1 ON a1.id_asignatura = ma1.id_asignatura
                             INNER JOIN aca.malla_asignatura ma2
                                        ON ma2.id_malla_asignatura = ar.id_malla_asignatura_relacion
                             INNER JOIN aca.asignatura a2 ON a2.id_asignatura = ma2.id_asignatura
                    WHERE ar.estado = 'A'
                      AND a1.estado = 'A'
                      AND a2.estado = 'A'
                      AND ar.tipo_relacion = 'PRE'
                    GROUP BY ma1.id_malla_asignatura) AS aux ON aux.id_malla_asignatura = ma.id_malla_asignatura
WHERE pp.estado = 'A'
  AND pp.ofertada = 1
  AND ppd.estado = 'A'
  AND ma.estado = 'A'
  AND asig.estado = 'A'
  AND n.estado = 'A'
  AND pl.estado = 'A'
--           AND pp.id_periodo_academico = 96
--           and ma.id_malla_asignatura in ( 309,316)
  AND pp.id_periodo_academico in (136, 137) --and (ma.id_malla_asignatura =  @id_malla_asignatura_par or @id_malla_asignatura_par is null)
--   AND ppd.cobertura_idioma <> 'NOAPLICA'
  and i.descripcion = 'Inglés'
group by ofa.facultad, ofa.carrera, ma.id_malla_asignatura, ma.id_nivel, asig.descripcion, ppd.cobertura_idioma,
         i.descripcion, ppd.num_estudiantes, ofa.id_oferta_modalidad,
         aux.prerrequisitos, pa.codigo, P.apellidos, P.nombres, p.email_institucional, p.identificacion
ORDER BY ofa.facultad, ofa.carrera, ma.id_nivel, asig.descripcion;



--listado de estudiantes de bukingjan
select
    concat('BUCK-M',n.orden,'P01','-2026-0'),ROW_NUMBER() OVER (PARTITION BY n.orden ORDER BY n.orden,p.apellidos,p.nombres desc ) AS rn,p.identificacion as cedula, p.apellidos,p.nombres,
    isnull(p.email_institucional,p.email_personal) as correo_electronico,
isnull(d.descripcion,'NINGUNA') as discapacidad,iif(p.porcentaje_dis is null or p.porcentaje_dis='','0',p.porcentaje_dis) as porcentaje_discapacidad,p.email_institucional,p.email_personal,n.orden
--            p.identificacion, p.apellidos,p.nombres,p.email_institucional,p.email_personal
from aca.estudiante_oferta eo
    inner join man.personas p on p.id = eo.id_persona
    left join man.discapacidad d on p.id_discapacidad = d.id_discapacidad
         inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
         inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
         inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
         inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula =  em.id_estudiante_matricula
         inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
         inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
         inner join aca.malla m on m.id_malla = ma.id_malla
         inner join aca.nivel n on n.id_nivel = ma.id_nivel
         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where eo.estado='A' and em.estado='A' and pa.id_periodo_academico = 146 and p.estado='AC'
group by n.orden, p.identificacion, p.apellidos, p.nombres, p.email_institucional, p.email_personal, d.descripcion, p.porcentaje_dis
order by n.orden,p.apellidos,p.nombres;

select * from man.personas where identificacion in ('0107386344',    '2450086018','2450753971'    )

WITH Base AS (
    SELECT
        n.orden,
        p.identificacion AS cedula,
        p.apellidos,
        p.nombres,
        ISNULL(p.email_institucional, p.email_personal) AS correo_electronico,
        ISNULL(d.descripcion, 'NINGUNA') AS discapacidad,
        ISNULL(NULLIF(p.porcentaje_dis, ''), '0') AS porcentaje_discapacidad,
        p.email_institucional,
        p.email_personal,
        ROW_NUMBER() OVER (
            PARTITION BY n.orden
            ORDER BY p.apellidos, p.nombres
            ) AS rn
    FROM aca.estudiante_oferta eo
             INNER JOIN man.personas p ON p.id = eo.id_persona
             LEFT JOIN man.discapacidad d ON p.id_discapacidad = d.id_discapacidad
             INNER JOIN aca.estudiante_matricula em ON em.id_estudiante_oferta = eo.id_estudiante_oferta
             INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = em.id_matricula_general
             INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = mg.id_periodo_academico
             INNER JOIN aca.estudiante_asignatura ea ON ea.id_estudiante_matricula = em.id_estudiante_matricula
             INNER JOIN aca.asignatura_aprendizaje aa ON aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
             INNER JOIN aca.malla_asignatura ma ON ma.id_malla_asignatura = aa.id_malla_asignatura
             INNER JOIN aca.malla m ON m.id_malla = ma.id_malla
             INNER JOIN aca.nivel n ON n.id_nivel = ma.id_nivel
             INNER JOIN aca.asignatura a ON a.id_asignatura = ma.id_asignatura
    WHERE eo.estado = 'A'
      AND em.estado = 'A'
      AND pa.id_periodo_academico = 141 and n.orden in (1,2)
      AND p.estado = 'AC'
    GROUP BY
        n.orden, p.identificacion, p.apellidos, p.nombres,
        p.email_institucional, p.email_personal,
        d.descripcion, p.porcentaje_dis
)

SELECT
    CONCAT(
            'BUCK-M',
            orden,
            '-P',
            RIGHT('0' + CAST(((rn - 1) / 200 + 1) AS VARCHAR(2)), 2),
            '-2026-0'
    ) AS codigo,
    orden as modulo,
    cedula,
    apellidos,
    nombres,
    correo_electronico,
    discapacidad,
    porcentaje_discapacidad
FROM Base
ORDER BY orden, apellidos, nombres;

select * from aca.[fn_resultado_aprendizaje_oferta_asignatura](2,96,7,87) as d ;

--competenciaas de la carrera
select c.id_oferta_competencia,ofa.carrera,ofa.modalidad,tc.descripcion as tipo_competencia,c.descripcion as competencia from aca.oferta_competencia c
inner join aca.malla m on c.id_malla = m.id_malla
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
inner join aca.tipo_competencia tc on c.id_tipo_competencia = tc.id_tipo_competencia
where m.estado in ('A','P') and ofa.id_departamento = 5 and ofa.id_tipo_oferta = 2
order by ofa.carrera,tc.descripcion,c.descripcion


--resultado de aprendizaje de la carrera
select c.id_oferta_resultado_aprendizaje,ofa.carrera,ofa.modalidad,tc.descripcion as tipo_resultado_aprendizaje,c.descripcion as resultado_aprendizaje
from aca.oferta_resultado_aprendizaje c
inner join aca.malla m on c.id_malla = m.id_malla
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
inner join aca.tipo_resultado_aprendizaje tc on c.id_tipo_resultado_aprendizaje = tc.id_tipo_resultado_aprendizaje
where m.estado in ('A','P') and ofa.id_departamento = 5 and ofa.id_tipo_oferta = 2
order by ofa.carrera,tc.descripcion

--resultado de aprendizaje de la as asignaturas
select c.id_asignatura_resultado_aprendizaje,ofa.carrera,ofa.modalidad,ma.id_nivel as nivel,a.descripcion as asignatura,c.descripcion as resultado_aprendizaje
from aca.asignatura_resultado_aprendizaje c
        inner join aca.malla_asignatura ma on c.id_malla_asignatura = ma.id_malla_asignatura
        inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
         inner join aca.malla m on ma.id_malla = m.id_malla
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
where m.estado in ('A','P') and ofa.id_departamento = 5 and ofa.id_tipo_oferta = 2
order by ofa.carrera,ma.id_nivel,a.descripcion

select ofa.id_tipo_oferta,pao.id_periodo_academico,ofa.id_departamento,pao.id_oferta_modalidad,ofa.facultad,ofa.carrera,pa.codigo as periodo from aca.periodo_academico_oferta pao
    inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = pao.id_oferta_modalidad
    inner join aca.periodo_academico pa on pao.id_periodo_academico = pa.id_periodo_academico
    where pao.estado='A' and ofa.id_tipo_oferta = 2 and pa.id_periodo_academico in (27,30,35,36,95,96)
and ofa.id_oferta_modalidad not in (22,35,30,125)

EXEC aca.sp_resultado_aprendizaje_reporte 95,NULL,NULL,null
select * from  aca.fn_get_cantidad_matriculados_por_oferta (null,null,96) as d

select * from [rep].[fn_get_cantidad_matriculados_porcentajes](96, null, null, null) as d
where d.numero_matriculados<20

--matriculados en ambos records en el 2026-1
select
    distinct em.*
--     mr.id_matricula_rubro,mr.id_estudiante_matricula,mr.id_rubro,mr.valor,
-- p.identificacion,eo.id_estudiante_oferta,eo.ultimo_periodo,p.apellidos,p.nombres,em.id_estudiante_matricula,ea.id_estudiante_asignatura
    from   aca.estudiante_oferta eo
    inner join man.personas p on p.id = eo.id_persona
    inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
    inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
    inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
    inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
    inner join aca.malla m on ma.id_malla = m.id_malla
    inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where mg.id_periodo_academico = 136 and ea.estado='A' and  p.identificacion in ('0706187606','2400234387')
--  in ('0706187606','0928872795','0940540685','2400222564','2400347007','2450268244','2450821752')

exec [aca].[pa_generar_asignaturas_a_matricular_sga] 101776,136,1,1
exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 101776,136,1,1

--listado de estudiantes biblioteca 2026-1
select p.identificacion as cedula, concat(p.nombres,' ',p.apellidos) as nombres,
    isnull(p.email_institucional,p.email_personal) as correo_instucional,ofa.facultad,ofa.carrera,em.id_nivel as semestre
from aca.estudiante_oferta eo
         inner join man.personas p on p.id = eo.id_persona
         inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
         inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
         inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
         inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula =  em.id_estudiante_matricula
        inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
where eo.estado='A' and em.estado='A' and pa.id_periodo_academico = 136 and p.estado='AC'
group by p.identificacion, p.apellidos, p.nombres, p.email_institucional, p.email_personal,ofa.facultad,ofa.carrera, em.id_nivel
order by ofa.facultad,ofa.carrera,p.apellidos,p.nombres;

--listado graduados
select ofa.facultad,ofa.carrera,iif(p.sexo='F','FEMENINO','MASCULINO') as genero,count(p.identificacion) as estudiantes
from aca.estudiante_oferta eo
         inner join man.personas p on p.id = eo.id_persona
         inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
         inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
         inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
         inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula =  em.id_estudiante_matricula
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
        inner join mig.graduados g on p.id = g.id_persona
where eo.estado='A' and em.estado='A' and p.estado='AC' and eo.id_tipo_estado_estudiante = 5
    and YEAR(g.fecha_graduacion)= '2025'
group by ofa.facultad,ofa.carrera, p.sexo
order by ofa.facultad,ofa.carrera;


select pa.codigo as periodo,ofa.facultad,ofa.carrera,iif(p.sexo='F','FEMENINO','MASCULINO') as genero,count(p.identificacion) as estudiantes
from mig.graduados g
         inner join man.personas p on p.id = g.id_persona
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = g.id_oferta_modalidad
        inner join aca.periodo_academico pa on g.id_periodo_academico = pa.id_periodo_academico
where p.estado='AC' --and YEAR(g.fecha_graduacion)= '2025'
and pa.id_periodo_academico in (95,96)
group by pa.codigo,ofa.facultad,ofa.carrera, p.sexo
order by pa.codigo,ofa.facultad,ofa.carrera;

--listado de estudiantes de agropecuaria para resolucion
select
-- eo.*
ofa.facultad,ofa.carrera,eo.id_periodo_academico,p.identificacion,p.apellidos,p.nombres,
eo.estado,tie.descripcion as estado
from aca.estudiante_oferta eo
         inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
         inner join aca.estudiante_oferta eop on eop.id_estudiante_oferta = eo.id_estudiante_oferta_padre and eop.id_oferta_modalidad= 20 and eop.estado='A'
         inner join man.personas p on p.id = eo.id_persona
         left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.movilidad m on eo.id_estudiante_oferta = m.id_estudiante_oferta
where eo.estado='A' and p.estado='AC' and m.estado='A' and eo.id_oferta_modalidad=20 and m.id_periodo_academico=136
-- order by ofa.facultad,ofa.carrera;
union
select distinct
-- eo.*
ofa.facultad,ofa.carrera,eo.id_periodo_academico,p.identificacion,p.apellidos,p.nombres,
eo.estado,'TERCERA MATRICULA' as estado
from aca.estudiante_oferta eo
         inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
         inner join man.personas p on p.id = eo.id_persona
         left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
         inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
--          inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
         inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula =  em.id_estudiante_matricula
where eo.estado='A' and p.estado='AC' and ea.estado='A' and ea.id_numero_vez = 3 and eo.id_oferta_modalidad = 20 and mg.id_periodo_academico=136
order by ofa.facultad,ofa.carrera,tie.descripcion;

--listado de estudiantes curso 5/2 entrenamiento deportivo
select ofa.facultad,ofa.carrera,p.identificacion as cedula, concat(p.apellidos,' ',p.nombres) as nombres,em.id_nivel as semestre,a.descripcion
from aca.estudiante_oferta eo
 inner join man.personas p on p.id = eo.id_persona
 inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
 inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
 inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
 inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula =  em.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
    inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
 inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
where eo.estado='A' and em.estado='A' and pa.id_periodo_academico = 136 and p.estado='AC' and eo.id_oferta_modalidad = 82
and ma.id_nivel = 5 and ea.id_paralelo = 2 and ma.id_malla_asignatura = 3551
group by p.identificacion, p.apellidos, p.nombres, p.email_institucional, p.email_personal,ofa.facultad,ofa.carrera, em.id_nivel,a.descripcion, ma.id_malla_asignatura
order by ofa.facultad,ofa.carrera,p.apellidos,p.nombres;


select p.identificacion,p.apellidos,p.nombres,cg_Cargo_txt as cargo,cgTipoTrabajador_txt as tipo,p.email_institucional,p.email_personal,c.Fecha_Inicio,c.Fecha_Final from uath.contratos_migracion_06_02_2024 c
inner join man.personas p on p.identificacion = c.identificacion
where EstadoContrato='A' and cgTipoTrabajador_txt<>'OPERATIVO' and cast(c.Fecha_Final as date) ='2026-12-31'
order by tipo,apellidos,nombres

select * from aca.ofertas_facultad where id_tipo_oferta = 2
select * from aca.tipo_ingreso_estudiante

-- update eo set eo.id_tipo_ingreso_estudiante=2
select
-- eo.*
ofa.facultad,ofa.carrera,ofa.modalidad,ofa.sede,ofa.id_oferta_modalidad,ofa1.facultad as facultadNew,ofa1.carrera as carreraNew,ofa1.modalidad as modalidadNew,ofa1.id_oferta_modalidad,pa.codigo,
p.identificacion,p.apellidos,p.nombres,tie.descripcion as tipo_ingreso,tie.codigo
from aca.estudiante_oferta eo
         inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
         inner join aca.estudiante_oferta eop on eop.id_estudiante_oferta = eo.id_estudiante_oferta_padre
         inner join man.personas p on p.id = eo.id_persona
         left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.ofertas_facultad ofa1 on ofa1.id_oferta_modalidad = eop.id_oferta_modalidad
where eo.estado='A' and p.estado='AC' and eop.estado ='A' and ofa1.id_tipo_oferta = 1  and ofa.id_tipo_oferta = 2 and tie.codigo ='PAAU'

  --verificacion cambio de modalidad
-- and ofa.modalidad ='PRESENCIAL' and ofa1.modalidad='HIBRIDA' and ofa.id_oferta = ofa1.id_oferta
    ---verificacion cambio de sede
--       and ( ((ofa.id_oferta_modalidad = 104 and ofa1.id_oferta_modalidad = 103) or (ofa.id_oferta_modalidad = 103 and ofa1.id_oferta_modalidad = 104))
--   or ((ofa.id_oferta_modalidad = 100 and ofa1.id_oferta_modalidad = 99) or (ofa.id_oferta_modalidad = 99 and ofa1.id_oferta_modalidad = 100))
--   or ((ofa.id_oferta_modalidad = 135 and ofa1.id_oferta_modalidad = 96) or (ofa.id_oferta_modalidad = 96 and ofa1.id_oferta_modalidad = 135))
--   or ((ofa.id_oferta_modalidad = 93 and ofa1.id_oferta_modalidad = 92) or (ofa.id_oferta_modalidad = 92 and ofa1.id_oferta_modalidad = 93)))
--     order by ofa.facultad,ofa.carrera
--and eo.id_oferta_modalidad=20 and m.id_periodo_academico=136
exec [aca].[sp_rpt_certificado_B1] 9722,null

select distinct om.facultad,om.carrera,ma.id_nivel as semestre,ea.id_paralelo as paralelo,mas.descripcion as modalidad,
                a.id_asignatura,a.descripcion as asignatura,isnull((select top 1 aca.fn_esc_get_horario_by_asignatura_paralelo_periodo_academico(
                                                                                         ma.id_malla_asignatura, ea.id_paralelo,
                                                                                         mg.id_periodo_academico)),'NO REGISTRA') as horario_clase
from aca.periodo_academico pa
         inner join aca.matricula_general mg on pa.id_periodo_academico = mg.id_periodo_academico
         inner join aca.estudiante_matricula em on em.id_matricula_general = mg.id_matricula_general
         inner join aca.tipo_matricula tm on em.id_tipo_matricula = tm.id_tipo_matricula
         inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = em.id_estudiante_oferta
         inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
         inner join tes.rubro r on ea.id_rubro = r.id_rubro
         inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
         inner join aca.componente_aprendizaje as cap
                    on aa.id_componente_aprendizaje = cap.id_componente_aprendizaje
         inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
         INNER JOIN aca.malla as mal ON mal.id_malla = ma.id_malla
         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
         inner join aca.nivel n on ma.id_nivel = n.id_nivel
         inner join aca.paralelo pl on pl.id_paralelo = ea.id_paralelo
         inner join man.personas per on per.id = eo.id_persona
         inner join aca.planificacion_paralelo pap on pap.id_malla_asignatura = ma.id_malla_asignatura and
                                                      pap.id_periodo_academico = mg.id_periodo_academico and pap.ofertada = 1
         inner join aca.modalidad_asignatura mas on mas.id_modalidad_asignatura = pap.id_modalidad_asignatura

where mg.id_periodo_academico = 136 and ma.id_nivel in (7,8,9)
  and pa.estado = 'A'
  and mg.estado = 'A'
  and tm.estado = 'A'
  and em.estado = 'A'
  and eo.estado = 'A'
  and ea.estado in ('A')
  and pap.estado = 'A'
  and aa.estado = 'A'
  and a.estado = 'A'
  and n.estado = 'A'
  and pl.estado = 'A'
  and per.estado = 'AC'
order by om.facultad,om.carrera,ma.id_nivel,ea.id_paralelo,a.descripcion


--MATRIZ ESTUDIANTES que viven
select distinct o.descripcion as CARRERA,eo.id_oferta_modalidad,p.identificacion AS IDENTIFICACION, p.apellidos as APELLIDOS, p.nombres as NOMBRES,
                iif(p.email_institucional is null,'NO REGISTRA',p.email_institucional) as EMAIL_INSTITUCIONAL,
                pror.descripcion as provincia,cr.id_lugar, cr.descripcion as canton
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.malla m on m.id_malla = eo.id_malla
         inner join man.tipo_identificacion te on te.id_tipo_identificacion = p.id_tipo_identificacion
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
         inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
         inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.oferta o on o.id_oferta = om.id_oferta
         inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
         inner join man.departamentos d on d.id= do.id_departamento
         inner join aca.campus c on c.id_campus = o.id_campus
         left join man.lugar pror on pror.id_lugar = p.id_provincia_nacionalidad
         left join man.lugar cr on cr.id_lugar = p.id_canton_nacionalidad
where p.estado='AC' and eo.estado='A' and om.estado='A' and em.estado = 'A'
  and  mg.id_periodo_academico in (136) and eo.id_oferta_modalidad in (103,104) and cr.id_lugar = 491
order by o.descripcion,p.apellidos,p.nombres;


--listado de estudiantes curso 5/2 entrenamiento deportivo
-- Listado de mejores estudiantes por facultad
WITH promedios AS
(
    SELECT om.facultad, om.carrera, p.identificacion, p.apellidos, p.nombres, ca.id_componente_aprendizaje,
           ca.codigo, AVG(CAST(ec.calificacion AS DECIMAL(10, 2))) AS promedio_ciclo1
    FROM man.personas p
    INNER JOIN aca.estudiante_oferta eo ON eo.id_persona = p.id
    INNER JOIN aca.estudiante_oferta eop ON eop.id_estudiante_oferta_padre = eo.id_estudiante_oferta
    INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = eo.id_periodo_academico
    INNER JOIN aca.tipo_estado_estudiante tee ON tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    INNER JOIN aca.ofertas_facultad om ON om.id_oferta_modalidad = eo.id_oferta_modalidad
    INNER JOIN aca.estudiante_calificacion ec ON ec.id_estudiante_oferta = eo.id_estudiante_oferta
    INNER JOIN aca.acta_calificacion ac ON ac.id_acta_calificacion = ec.id_acta_calificacion
    INNER JOIN aca.calificacion_general cg ON cg.id_calificacion_general = ac.id_calificacion_general
    INNER JOIN aca.componente_aprendizaje ca ON ca.id_componente_aprendizaje = ec.id_componente_aprendizaje
    WHERE cg.id_periodo_academico = 136 AND ec.estado = 'A'
    GROUP BY om.facultad, om.carrera, p.identificacion, p.apellidos, p.nombres, ca.id_componente_aprendizaje,
             ca.codigo
),
ranking AS
(
    SELECT facultad, carrera, identificacion, apellidos, nombres, id_componente_aprendizaje,
           codigo, promedio_ciclo1,
           ROW_NUMBER() OVER (PARTITION BY facultad ORDER BY promedio_ciclo1 DESC) AS puesto
    FROM promedios
)
SELECT facultad, carrera, identificacion, apellidos, nombres, id_componente_aprendizaje,
       codigo, promedio_ciclo1, puesto
FROM ranking
WHERE puesto = 1
ORDER BY facultad;

 SELECT om.facultad, om.carrera, p.identificacion, p.apellidos, p.nombres, AVG(CAST(EA.promedio AS DECIMAL(10, 2))) AS promedio
    FROM man.personas p
    INNER JOIN aca.estudiante_oferta eo ON eo.id_persona = p.id
    INNER JOIN aca.estudiante_oferta eop ON eop.id_estudiante_oferta_padre = eo.id_estudiante_oferta
    INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = eo.id_periodo_academico
    INNER JOIN aca.tipo_estado_estudiante tee ON tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    INNER JOIN aca.ofertas_facultad om ON om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    INNER JOIN aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
    inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
    inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
    inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
    WHERE mg.id_periodo_academico in (95,96) AND em.estado='A' and ea.estado='A'
    GROUP BY om.facultad, om.carrera, p.identificacion, p.apellidos, p.nombres

 SELECT om.facultad, om.carrera, p.identificacion, p.apellidos, p.nombres,a.descripcion as asignatura
    FROM man.personas p
    INNER JOIN aca.estudiante_oferta eo ON eo.id_persona = p.id
    INNER JOIN aca.estudiante_oferta eop ON eop.id_estudiante_oferta_padre = eo.id_estudiante_oferta
    INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = eo.id_periodo_academico
    INNER JOIN aca.tipo_estado_estudiante tee ON tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    INNER JOIN aca.ofertas_facultad om ON om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    INNER JOIN aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
    inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
    inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
    inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
    WHERE em.estado='A' and ea.estado='A' and ea.codigo_estado_matricula in ('TER','SEG')
    GROUP BY om.facultad, om.carrera, p.identificacion, p.apellidos, p.nombres, a.descripcion

--sin restriccion por segunda o tercera
BEGIN
    DECLARE @id_periodo_actual INT = 136;

    WITH Matriculados AS
    (
        SELECT em.id_estudiante_matricula, em.estado,
               SUM(IIF(m.tipo_plan = 'CREDITOS', ma.num_creditos, ma.num_horas)) AS valorMatriculados
        FROM aca.estudiante_matricula em
        INNER JOIN aca.estudiante_oferta eo ON eo.id_estudiante_oferta = em.id_estudiante_oferta
        INNER JOIN aca.malla m ON m.id_malla = eo.id_malla
        INNER JOIN aca.estudiante_asignatura ea ON ea.id_estudiante_matricula = em.id_estudiante_matricula
        INNER JOIN aca.asignatura_aprendizaje aa ON aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
        INNER JOIN aca.malla_asignatura ma ON ma.id_malla_asignatura = aa.id_malla_asignatura
        WHERE em.estado = 'A' AND ea.estado = 'A'
        GROUP BY em.id_estudiante_matricula, em.estado
    ),
    MallaNivel AS
    (
        SELECT m.id_malla, ma.id_nivel,
               SUM(IIF(m.tipo_plan = 'CREDITOS', ma.num_creditos, ma.num_horas)) AS valorMalla,
               SUM(IIF(m.tipo_plan = 'CREDITOS', ma.num_creditos, ma.num_horas) * 0.6) AS valorSesenta
        FROM aca.malla_asignatura ma
        INNER JOIN aca.malla m ON m.id_malla = ma.id_malla
        WHERE ma.estado = 'A'
        GROUP BY m.id_malla, ma.id_nivel
    ),
    PromedioAnual AS
    (
        SELECT eo.id_persona, eo.id_oferta_modalidad,
               AVG(CAST(ea.promedio AS DECIMAL(10, 2))) AS promedioAnual
        FROM aca.estudiante_oferta eo
        INNER JOIN aca.estudiante_matricula em ON em.id_estudiante_oferta = eo.id_estudiante_oferta
        INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = em.id_matricula_general
        INNER JOIN aca.estudiante_asignatura ea ON ea.id_estudiante_matricula = em.id_estudiante_matricula
        INNER JOIN aca.asignatura_aprendizaje aa ON aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
        INNER JOIN aca.malla_asignatura ma ON ma.id_malla_asignatura = aa.id_malla_asignatura
        INNER JOIN aca.asignatura a ON a.id_asignatura = ma.id_asignatura
        WHERE mg.id_periodo_academico IN (95, 96) AND eo.estado = 'A' AND em.estado = 'A'
              AND ea.estado = 'A'
        GROUP BY eo.id_persona, eo.id_oferta_modalidad
        HAVING COUNT(DISTINCT mg.id_periodo_academico) = 2
    ),
    EstudiantesActuales AS
    (
        SELECT DISTINCT eo.id_persona, eo.id_oferta_modalidad, p.identificacion, p.apellidos, p.nombres,
               eo.numero_matricula, om.facultad, om.carrera, om.sedeCorta, te.descripcion AS tipoEstudiante,
               tie.descripcion AS tipoIngreso, em.id_nivel AS semestre, mtr.valorMatriculados,
               mn.valorMalla, mn.valorSesenta
        FROM man.personas p
        INNER JOIN aca.estudiante_oferta eo ON eo.id_persona = p.id
        INNER JOIN aca.tipo_ingreso_estudiante tie ON tie.id_tipo_ingreso_estudiante = eo.id_tipo_ingreso_estudiante
        INNER JOIN aca.tipo_estudiante te ON te.id_tipo_estudiante = eo.id_tipo_estudiante
        INNER JOIN aca.estudiante_matricula em ON em.id_estudiante_oferta = eo.id_estudiante_oferta
        INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = em.id_matricula_general
        INNER JOIN aca.ofertas_facultad om ON om.id_oferta_modalidad = eo.id_oferta_modalidad
        LEFT JOIN Matriculados mtr ON mtr.id_estudiante_matricula = em.id_estudiante_matricula
        LEFT JOIN MallaNivel mn ON mn.id_malla = eo.id_malla AND mn.id_nivel = em.id_nivel
        WHERE p.estado = 'AC' AND eo.estado = 'A' AND em.estado = 'A'
              AND mg.id_periodo_academico = @id_periodo_actual
              AND mtr.valorMatriculados >= mn.valorSesenta
    ),
    Ranking AS
    (
        SELECT ea.id_persona, ea.facultad, ea.carrera, ea.identificacion, ea.apellidos, ea.nombres,
               ea.numero_matricula, ea.tipoEstudiante, ea.tipoIngreso, ea.semestre, ea.sedeCorta,
               ea.valorMatriculados, ea.valorMalla, ea.valorSesenta, pa.promedioAnual,
               DENSE_RANK() OVER
               (
                   PARTITION BY ea.id_oferta_modalidad
                   ORDER BY pa.promedioAnual DESC
               ) AS puesto
        FROM EstudiantesActuales ea
        INNER JOIN PromedioAnual pa ON pa.id_persona = ea.id_persona
                                   AND pa.id_oferta_modalidad = ea.id_oferta_modalidad
    )
    SELECT id_persona, facultad, carrera, identificacion, CONCAT(apellidos, ' ', nombres) AS nombresApellidos,
           numero_matricula, tipoEstudiante, tipoIngreso, semestre, sedeCorta, valorMatriculados,
           valorMalla, valorSesenta, promedioAnual, puesto
    FROM Ranking
    WHERE puesto = 1
    ORDER BY facultad, carrera, nombresApellidos;
END;

BEGIN
    DECLARE @id_periodo_actual INT = 136;

    WITH Matriculados AS
    (
        SELECT em.id_estudiante_matricula, em.estado,
               SUM(IIF(m.tipo_plan = 'CREDITOS', ma.num_creditos, ma.num_horas)) AS valorMatriculados
        FROM aca.estudiante_matricula em
        INNER JOIN aca.estudiante_oferta eo ON eo.id_estudiante_oferta = em.id_estudiante_oferta
        INNER JOIN aca.malla m ON m.id_malla = eo.id_malla
        INNER JOIN aca.estudiante_asignatura ea ON ea.id_estudiante_matricula = em.id_estudiante_matricula
        INNER JOIN aca.asignatura_aprendizaje aa ON aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
        INNER JOIN aca.malla_asignatura ma ON ma.id_malla_asignatura = aa.id_malla_asignatura
        WHERE em.estado = 'A' AND ea.estado = 'A'
        GROUP BY em.id_estudiante_matricula, em.estado
    ),
    MallaNivel AS
    (
        SELECT m.id_malla, ma.id_nivel,
               SUM(IIF(m.tipo_plan = 'CREDITOS', ma.num_creditos, ma.num_horas)) AS valorMalla,
               SUM(IIF(m.tipo_plan = 'CREDITOS', ma.num_creditos, ma.num_horas) * 0.6) AS valorSesenta
        FROM aca.malla_asignatura ma
        INNER JOIN aca.malla m ON m.id_malla = ma.id_malla
        WHERE ma.estado = 'A'
        GROUP BY m.id_malla, ma.id_nivel
    ),
    PromedioAnual AS
    (
        SELECT eo.id_persona, eo.id_oferta_modalidad,
               AVG(CAST(ea.promedio AS DECIMAL(10, 2))) AS promedioAnual
        FROM aca.estudiante_oferta eo
        INNER JOIN aca.estudiante_matricula em ON em.id_estudiante_oferta = eo.id_estudiante_oferta
        INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = em.id_matricula_general
        INNER JOIN aca.estudiante_asignatura ea ON ea.id_estudiante_matricula = em.id_estudiante_matricula
        INNER JOIN aca.asignatura_aprendizaje aa ON aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
        INNER JOIN aca.malla_asignatura ma ON ma.id_malla_asignatura = aa.id_malla_asignatura
        INNER JOIN aca.asignatura a ON a.id_asignatura = ma.id_asignatura
        WHERE mg.id_periodo_academico IN (95, 96) AND eo.estado = 'A' AND em.estado = 'A'
              AND ea.estado = 'A'
        GROUP BY eo.id_persona, eo.id_oferta_modalidad
        HAVING COUNT(DISTINCT mg.id_periodo_academico) = 2
    ),
    EstudiantesActuales AS
    (
        SELECT DISTINCT eo.id_persona, eo.id_oferta_modalidad, p.identificacion, p.apellidos, p.nombres,
               eo.numero_matricula, om.facultad, om.carrera, om.sedeCorta, te.descripcion AS tipoEstudiante,
               tie.descripcion AS tipoIngreso, em.id_nivel AS semestre, mtr.valorMatriculados,
               mn.valorMalla, mn.valorSesenta
        FROM man.personas p
        INNER JOIN aca.estudiante_oferta eo ON eo.id_persona = p.id
        INNER JOIN aca.tipo_ingreso_estudiante tie ON tie.id_tipo_ingreso_estudiante = eo.id_tipo_ingreso_estudiante
        INNER JOIN aca.tipo_estudiante te ON te.id_tipo_estudiante = eo.id_tipo_estudiante
        INNER JOIN aca.estudiante_matricula em ON em.id_estudiante_oferta = eo.id_estudiante_oferta
        INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = em.id_matricula_general
        INNER JOIN aca.ofertas_facultad om ON om.id_oferta_modalidad = eo.id_oferta_modalidad
        LEFT JOIN Matriculados mtr ON mtr.id_estudiante_matricula = em.id_estudiante_matricula
        LEFT JOIN MallaNivel mn ON mn.id_malla = eo.id_malla AND mn.id_nivel = em.id_nivel
        WHERE p.estado = 'AC' AND eo.estado = 'A' AND em.estado = 'A'
              AND mg.id_periodo_academico = @id_periodo_actual
              AND mtr.valorMatriculados >= mn.valorSesenta
              AND NOT EXISTS
                  (
                      SELECT 1
                      FROM aca.estudiante_oferta eoRep
                      INNER JOIN aca.estudiante_matricula emRep ON emRep.id_estudiante_oferta = eoRep.id_estudiante_oferta
                      INNER JOIN aca.estudiante_asignatura eaRep ON eaRep.id_estudiante_matricula = emRep.id_estudiante_matricula
                      WHERE eoRep.id_persona = eo.id_persona AND eoRep.id_oferta_modalidad = eo.id_oferta_modalidad
                            AND emRep.estado = 'A' AND eaRep.estado = 'A'
                            AND eaRep.codigo_estado_matricula IN ('SEG', 'TER')
                  )
    ),
    Ranking AS
    (
        SELECT ea.id_persona, ea.id_oferta_modalidad, ea.facultad, ea.carrera, ea.identificacion, ea.apellidos,
               ea.nombres, ea.numero_matricula, ea.tipoEstudiante, ea.tipoIngreso, ea.semestre, ea.sedeCorta,
               ea.valorMatriculados, ea.valorMalla, ea.valorSesenta, pa.promedioAnual,
               DENSE_RANK() OVER (PARTITION BY ea.id_oferta_modalidad ORDER BY pa.promedioAnual DESC) AS puesto
        FROM EstudiantesActuales ea
        INNER JOIN PromedioAnual pa ON pa.id_persona = ea.id_persona
                                   AND pa.id_oferta_modalidad = ea.id_oferta_modalidad
    )
    SELECT id_persona, facultad, carrera, identificacion, CONCAT(apellidos, ' ', nombres) AS nombresApellidos,
           numero_matricula, tipoEstudiante, tipoIngreso, semestre, sedeCorta, valorMatriculados,
           valorMalla, valorSesenta, promedioAnual, puesto
    FROM Ranking
    WHERE puesto< = 2
    ORDER BY facultad, carrera, nombresApellidos;
END;