use bd_sga_upse
--actualizar los manes que aprobaron el pre y no han utilizado su primer semestre
-- update eo set eo.id_tipo_estado_estudiante = 7,eo.fecha_hasta=getdate(),eo.usuario_mod='2400254286'
select distinct om.carrera,pa.codigo,em.id_estudiante_matricula,eo.id_estudiante_oferta,tee.id_tipo_estado_estudiante,tee.codigo,p.identificacion,
                p.nombres,p.apellidos,ea.id_paralelo,em.id_estudiante_matricula,em.fecha_ing,em.estado,ea.estado,eoh.id_tipo_estado_estudiante,eoh1.id_tipo_estado_estudiante,eoh2.id_tipo_estado_estudiante
from aca.estudiante_oferta eo
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join man.personas p on p.id = eo.id_persona
         inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
         inner join   aca.estudiante_oferta eoh on eoh.id_estudiante_oferta_padre = eo.id_estudiante_oferta
         left join   aca.estudiante_oferta eoh1 on eoh1.id_estudiante_oferta_padre = eoh.id_estudiante_oferta
         left join   aca.estudiante_oferta eoh2 on eoh2.id_estudiante_oferta_padre = eoh1.id_estudiante_oferta
         left join aca.estudiante_matricula em on em.id_estudiante_oferta = eoh.id_estudiante_oferta
         left join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
         left join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
where eo.id_periodo_academico = 126 and em.id_estudiante_matricula is null AND om.id_tipo_oferta = 1 and tee.codigo='APR'
  and eo.estado='A' and pa.estado='A'

select * from aca.tipo_estado_estudiante

select * from aca.estudiante_oferta where id_estudiante_oferta in (23527,
4616,
4616,
23859,
10208,
30769,
55163,
9989,
45360,
29658,
31133,
18421,
18421,
2316,
2316,
31134,
31115,
11637,
18422,
25612,
24383
)

select id_periodo_academico,codigo_tipo_periodo,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 1
--reporte ver posibles manes con pérdida de carrera.
--Establecer perdida de carrera
begin
    declare @pi_id_periodo_academico int = 96
--     update eo set eo.id_tipo_estado_estudiante = 18,eo.usuario_mod ='2400254286',eo.fecha_mod=getdate(),eo.fecha_hasta='2025-02-17'
    select distinct d.*
    from (select om.facultad,
                 om.id_oferta_modalidad,
                 om.carrera,
                 eo.id_estudiante_oferta,
                 per.identificacion,
                 concat(per.apellidos, ' ', per.nombres)                          as nombres,
                 per.celular,
                 tee.descripcion                                                  as estado_cupo,
                 ma.id_malla_asignatura,
                 n.orden                                                          as nivel,
                 a.descripcion                                                    as asignatura,
                 (select count(eas1.id_estudiante_asignatura)
                  from aca.matricula_general mg1
                           inner join aca.estudiante_matricula ema1
                                      on ema1.id_matricula_general = mg1.id_matricula_general
                           inner join aca.estudiante_asignatura eas1
                                      on eas1.id_estudiante_matricula = ema1.id_estudiante_matricula
                           inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = mg1.id_periodo_academico
                  where ema1.id_estudiante_oferta = eo.id_estudiante_oferta
                    and eas1.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                    and mg1.estado = 'A'
                    and ema1.estado = 'A'
                    and eas1.estado = 'A'
                    and pa1.id_tipo_oferta = 2)                                   as vecesMatriculado,
                 (select count(eas1.id_estudiante_asignatura)
                  from aca.matricula_general mg1
                           inner join aca.estudiante_matricula ema1
                                      on ema1.id_matricula_general = mg1.id_matricula_general
                           inner join aca.estudiante_asignatura eas1
                                      on eas1.id_estudiante_matricula = ema1.id_estudiante_matricula
                           inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = mg1.id_periodo_academico
                  where ema1.id_estudiante_oferta = eo.id_estudiante_oferta
                    and eas1.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                    and mg1.estado = 'A'
                    and ema1.estado = 'A'
                    and eas1.estado = 'A'
                    and pa1.id_tipo_oferta = 2
                    and pa1.codigo not in ('2022-1', '2022-2', '2022', '2023-1')) as vecesValidas,
                 (select count(eas1.id_estudiante_asignatura)
                  from aca.matricula_general mg1
                           inner join aca.estudiante_matricula ema1
                                      on ema1.id_matricula_general = mg1.id_matricula_general
                           inner join aca.estudiante_asignatura eas1
                                      on eas1.id_estudiante_matricula = ema1.id_estudiante_matricula
                           inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = mg1.id_periodo_academico
                  where ema1.id_estudiante_oferta = eo.id_estudiante_oferta
                    and eas1.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                    --esta linea permitia ve si habia alguien matriculado por tercera en le periodo actual sin considerar el periodo actual de matricula
--   and mg1.estado='A' and ema1.estado='A' and eas1.estado='A' and pa1.id_tipo_oferta = 2 and eas1.aprobado=0 and pa1.codigo not in('2022-1','2022-2','2022','2023-1','2025-1')) as vecesValidasReprobadas,
                    and mg1.estado = 'A'
                    and ema1.estado = 'A'
                    and eas1.estado = 'A'
                    and pa1.id_tipo_oferta = 2
                    and eas1.aprobado = 0
                    and pa1.codigo not in ('2022-1', '2022-2', '2022', '2023-1')) as vecesValidasReprobadas,
                 (select count(eas1.id_estudiante_asignatura)
                  from aca.matricula_general mg1
                           inner join aca.estudiante_matricula ema1
                                      on ema1.id_matricula_general = mg1.id_matricula_general
                           inner join aca.estudiante_asignatura eas1
                                      on eas1.id_estudiante_matricula = ema1.id_estudiante_matricula
                           inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = mg1.id_periodo_academico
                  where ema1.id_estudiante_oferta = eo.id_estudiante_oferta
                    and eas1.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                    and mg1.estado = 'A'
                    and ema1.estado = 'A'
                    and eas1.estado = 'A'
                    and pa1.id_tipo_oferta = 2
                    and eas1.aprobado = 1)                                        as aprobadas,
                 iif(isnull((select count(ema1.id_estudiante_matricula)
                             from aca.matricula_general mg1
                                      inner join aca.estudiante_matricula ema1
                                                 on ema1.id_matricula_general = mg1.id_matricula_general
                                      inner join aca.periodo_academico pa1
                                                 on pa1.id_periodo_academico = mg1.id_periodo_academico
                             where ema1.id_estudiante_oferta = eo.id_estudiante_oferta
                               and pa1.codigo in ('2025-1')
                               and mg1.estado = 'A'
                               and ema1.estado = 'A'
                               and pa1.id_tipo_oferta = 2), 0) > 0, 'SI', 'NO')   as matriculado_actualmente

          from aca.estudiante_oferta eo
                   inner join aca.tipo_estado_estudiante tee
                              on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
                   inner join man.personas per on per.id = eo.id_persona
                   inner join aca.malla mal on eo.id_malla = eo.id_malla
                   inner join aca.malla_asignatura ma on ma.id_malla = mal.id_malla
                   inner join aca.asignatura_aprendizaje aa on ma.id_malla_asignatura = aa.id_malla_asignatura
                   inner join aca.estudiante_matricula ema on eo.id_estudiante_oferta = ema.id_estudiante_oferta
              -- inner join aca.matricula_general mg on ema.id_matricula_general = mg.id_matricula_general
-- inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
                   inner join aca.estudiante_asignatura eas
                              on eas.id_estudiante_matricula = ema.id_estudiante_matricula and
                                 eas.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                   inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
                   inner join aca.ofertas_facultad om on om.id_oferta_modalidad = mal.id_oferta_modalidad
                   inner join aca.nivel n on n.id_nivel = ma.id_nivel
          where --mg.id_periodo_academico = @pi_id_periodo_academico and
              om.id_tipo_oferta = 2
            and eo.estado = 'A'
            and per.estado = 'AC'
            and ma.estado = 'A'
            and mal.estado IN ('A', 'P')
            and a.estado = 'A'
            and n.estado = 'A'
          group by per.identificacion, per.apellidos, per.nombres, ma.id_malla_asignatura, a.descripcion,
                   om.facultad, om.carrera, n.orden, n.descripcion, n.orden, n.id_nivel
                  , om.id_oferta_modalidad, eo.id_estudiante_oferta, tee.descripcion, aa.id_asignatura_aprendizaje,
                   per.celular) as d
             inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = d.id_estudiante_oferta
    where d.vecesMatriculado >= 3
      and d.vecesValidas >= 3
--       and d.vecesValidasReprobadas >=3
      and d.aprobadas = 0
    --   and d.matriculado_actualmente='SI'
      and d.estado_cupo='ACTIVO'
    order by d.facultad, d.carrera, d.nombres
end;


select * from aca.tipo_estado_estudiante

-- version directa sin contar las veces solo considerando si tiene una materia con codigo TER
begin
    declare @pi_id_periodo_academico int = 96
--     update eo set eo.id_tipo_estado_estudiante = 18,eo.usuario_mod ='2400254286',eo.fecha_mod=getdate(),eo.fecha_hasta='2025-02-17'
    select distinct d.*
    from (
             select om.facultad,om.id_oferta_modalidad,om.carrera,eo.id_estudiante_oferta,per.identificacion, concat(per.apellidos,' ',per.nombres) as nombres,per.celular,
                    tee.descripcion as estado_cupo,ma.id_malla_asignatura,n.orden as nivel, a.descripcion as asignatura,
                    (select count(eas1.id_estudiante_asignatura) from aca.matricula_general mg1
                                                                          inner join aca.estudiante_matricula ema1 on ema1.id_matricula_general = mg1.id_matricula_general
                                                                          inner join aca.estudiante_asignatura eas1 on eas1.id_estudiante_matricula = ema1.id_estudiante_matricula
                                                                          inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = mg1.id_periodo_academico
                     where ema1.id_estudiante_oferta=eo.id_estudiante_oferta and eas1.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                       and mg1.estado='A' and ema1.estado='A' and eas1.estado='A' and pa1.id_tipo_oferta = 2 and eas1.aprobado=1) as aprobadas,
                    iif(isnull((select count(ema1.id_estudiante_matricula) from aca.matricula_general mg1
                                                                                    inner join aca.estudiante_matricula ema1 on ema1.id_matricula_general = mg1.id_matricula_general
                                                                                    inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = mg1.id_periodo_academico
                                where ema1.id_estudiante_oferta=eo.id_estudiante_oferta and  pa1.codigo in ('2026-0')
                                  and mg1.estado='A' and ema1.estado='A'  and pa1.id_tipo_oferta = 2),0)>0 ,'SI','NO') as matriculado_actualmente

             from aca.estudiante_oferta eo
                      inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
                      inner join man.personas per on per.id = eo.id_persona
                      inner join aca.estudiante_matricula ema on eo.id_estudiante_oferta = ema.id_estudiante_oferta
                      inner join aca.estudiante_asignatura ea on ema.id_estudiante_matricula = ea.id_estudiante_matricula
                      inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                      inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
                      inner join aca.matricula_general mg on ema.id_matricula_general = mg.id_matricula_general
                      inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
--                       inner join aca.estudiante_asignatura eas on eas.id_estudiante_matricula = ema.id_estudiante_matricula and eas.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                      inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
                      inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
                      inner join aca.nivel n on n.id_nivel = ma.id_nivel
             where  --mg.id_periodo_academico = @pi_id_periodo_academico and
                 om.id_tipo_oferta = 2 and ea.codigo_estado_matricula='TER' and ea.aprobado=0 and ea.estado='A' and
                 eo.estado='A' and per.estado='AC' and ma.estado='A' and a.estado='A' and n.estado='A'
             group by per.identificacion, per.apellidos,per.nombres, ma.id_malla_asignatura, a.descripcion,
                      om.facultad,om.carrera,n.orden,n.descripcion,n.orden,n.id_nivel
                     ,om.id_oferta_modalidad,eo.id_estudiante_oferta, tee.descripcion,aa.id_asignatura_aprendizaje,per.celular
         ) as d
             inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = d.id_estudiante_oferta
--   and d.matriculado_actualmente='SI'
        and d.estado_cupo='ACTIVO'
--     order by d.facultad,d.carrera,d.nombres
end


select * from aca.tipo_estado_estudiante

--saber si un estudiante efectivizo su cupo de primer semestre en el periodo correcto grado
select
--     eop.*
eo.id_estudiante_oferta,p.identificacion,p.apellidos,p.nombres,om.facultad,om.carrera,eo.id_nivel_proyectado,eo.mantiene_gratuidad,tee.descripcion,tie.descripcion,eo.estado,
eop.id_estudiante_oferta,omp.facultad,omp.carrera,pa.codigo as periodo_nivelacion,aux.periodo as ultimo_periodo_nivelacion,pap.codigo as periodo_ingreso_grado,
auxp.periodo as primer_matricula_grado,(auxp.orden-pao.orden) as efectivizo_cupo,pa.id_tipo_oferta,
pap.id_tipo_oferta,teep.descripcion,tiep.descripcion,auxp.id_estudiante_matricula,auxp.estado,aux.rn,auxp.rn
from aca.estudiante_oferta eo
         left join aca.periodo_academico pao on pao.codigo = eo.ultimo_periodo and pao.id_tipo_oferta = 2
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
         inner join man.personas p on eo.id_persona = p.id
         inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
         inner join aca.estudiante_oferta eop on eop.id_estudiante_oferta_padre = eo.id_estudiante_oferta
         inner join aca.tipo_estado_estudiante teep on eop.id_tipo_estado_estudiante = teep.id_tipo_estado_estudiante
         inner join aca.tipo_ingreso_estudiante tiep on eop.id_tipo_ingreso_estudiante = tiep.id_tipo_ingreso_estudiante
         inner join aca.periodo_academico pap on pap.id_periodo_academico = eop.id_periodo_academico
         inner join aca.ofertas_facultad omp on eop.id_oferta_modalidad = omp.id_oferta_modalidad
         left join (
    select em.id_estudiante_oferta,em.id_estudiante_matricula,em.estado,pa.codigo as periodo,pa.orden,
           ROW_NUMBER() OVER (PARTITION BY em.id_estudiante_oferta ORDER BY pa.codigo ) AS rn
    from aca.estudiante_matricula em
             inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
             inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
             inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
    where em.estado not in ('I','E')
    group by em.id_estudiante_oferta,em.id_estudiante_matricula,em.estado,pa.codigo,pa.orden
) as auxp on auxp.id_estudiante_oferta = eop.id_estudiante_oferta
         left join (
    select em.id_estudiante_oferta,em.id_estudiante_matricula,em.estado,pa.codigo as periodo,pa.orden,
           ROW_NUMBER() OVER (PARTITION BY em.id_estudiante_oferta ORDER BY pa.codigo desc ) AS rn
    from aca.estudiante_matricula em
             inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
             inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
             inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
    where em.estado not in ('I','E')
    group by em.id_estudiante_oferta,em.id_estudiante_matricula,em.estado,pa.codigo,pa.orden
) as aux on aux.id_estudiante_oferta = eo.id_estudiante_oferta
where --eo.id_oferta_modalidad = 31 and eo.id_tipo_estado_estudiante = 1 and eo.id_nivel_proyectado in (5,6,7)
    om.id_tipo_oferta in (1) and omp.id_tipo_oferta =2 and
    (auxp.rn is null or auxp.rn=1) and  (aux.rn is null or aux.rn=1) and
    eo.estado='A' --and eo.id_tipo_estado_estudiante = 1 --and eo.ultimo_periodo<>aux.periodo
-- and pa.codigo ='2024-2' and aux.id_estudiante_matricula is null
-- and p.identificacion ='0929901890'
group by eo.id_estudiante_oferta,eo.id_periodo_academico,om.id_tipo_oferta,om.carrera,om.facultad,p.identificacion,p.apellidos,p.nombres,eo.id_nivel_proyectado,
         eo.mantiene_gratuidad,tee.descripcion,tie.descripcion,eo.estado,
         eop.id_estudiante_oferta,omp.carrera,omp.facultad,auxp.id_estudiante_matricula, auxp.estado,auxp.periodo,auxp.rn,pa.codigo,pap.codigo,teep.descripcion,
         tiep.descripcion, eo.ultimo_periodo,pa.id_tipo_oferta, pap.id_tipo_oferta, aux.periodo,aux.rn, auxp.orden,pao.orden
order by om.facultad,om.carrera,p.apellidos,p.nombres

---para hacer el seguimiento de las cupos que sufrieron redisenio
select
--     eop.*
eo.id_estudiante_oferta,p.identificacion,p.apellidos,p.nombres,om.facultad,om.carrera,eo.id_nivel_proyectado,eo.mantiene_gratuidad,tee.descripcion,tie.descripcion,eo.estado,
eop.id_estudiante_oferta,omp.facultad,omp.carrera,pa.codigo as periodo_nivelacion,aux.periodo as ultimo_periodo_nivelacion,pap.codigo as periodo_ingreso_grado,
auxp.periodo as primer_matricula_grado,--(auxp.orden-pao.orden) as efectivizo_cupo,pa.id_tipo_oferta,
pap.id_tipo_oferta,teep.descripcion,tiep.descripcion,auxp.id_estudiante_matricula,auxp.estado,aux.rn,auxp.rn
from aca.estudiante_oferta eo
--          inner join aca.periodo_academico pao on pao.codigo = eo.ultimo_periodo and pao.id_tipo_oferta = 2
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
         inner join man.personas p on eo.id_persona = p.id
         inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
         inner join aca.estudiante_oferta eop on eop.id_estudiante_oferta_padre = eo.id_estudiante_oferta
         inner join aca.tipo_estado_estudiante teep on eop.id_tipo_estado_estudiante = teep.id_tipo_estado_estudiante
         inner join aca.tipo_ingreso_estudiante tiep on eop.id_tipo_ingreso_estudiante = tiep.id_tipo_ingreso_estudiante
         inner join aca.periodo_academico pap on pap.id_periodo_academico = eop.id_periodo_academico
         inner join aca.ofertas_facultad omp on eop.id_oferta_modalidad = omp.id_oferta_modalidad
         left join (
    select em.id_estudiante_oferta,em.id_estudiante_matricula,em.estado,pa.codigo as periodo,pa.orden,
           ROW_NUMBER() OVER (PARTITION BY em.id_estudiante_oferta ORDER BY pa.codigo ) AS rn
    from aca.estudiante_matricula em
             inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
             inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
             inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
    where em.estado not in ('I','E')
    group by em.id_estudiante_oferta,em.id_estudiante_matricula,em.estado,pa.codigo,pa.orden
) as auxp on auxp.id_estudiante_oferta = eop.id_estudiante_oferta
         left join (
    select em.id_estudiante_oferta,em.id_estudiante_matricula,em.estado,pa.codigo as periodo,pa.orden,
           ROW_NUMBER() OVER (PARTITION BY em.id_estudiante_oferta ORDER BY pa.codigo desc ) AS rn
    from aca.estudiante_matricula em
             inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
             inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
             inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
    where em.estado not in ('I','E')
    group by em.id_estudiante_oferta,em.id_estudiante_matricula,em.estado,pa.codigo,pa.orden
) as aux on aux.id_estudiante_oferta = eo.id_estudiante_oferta
where --eo.id_oferta_modalidad = 31 and eo.id_tipo_estado_estudiante = 1 and eo.id_nivel_proyectado in (5,6,7)
--     om.id_tipo_oferta in (1) and omp.id_tipo_oferta =2 and
    (auxp.rn is null or auxp.rn=1) and  (aux.rn is null or aux.rn=1) and
    eo.estado='A' and eo.id_estudiante_oferta in (17197,17232,65101,65108,
17580,17648,17730,17714,44090,44089,18067,18013,18222,18230,67689,67727)
group by eo.id_estudiante_oferta,eo.id_periodo_academico,om.id_tipo_oferta,om.carrera,om.facultad,p.identificacion,p.apellidos,p.nombres,eo.id_nivel_proyectado,
         eo.mantiene_gratuidad,tee.descripcion,tie.descripcion,eo.estado,
         eop.id_estudiante_oferta,omp.carrera,omp.facultad,auxp.id_estudiante_matricula, auxp.estado,auxp.periodo,auxp.rn,pa.codigo,pap.codigo,teep.descripcion,
         tiep.descripcion, eo.ultimo_periodo,pa.id_tipo_oferta, pap.id_tipo_oferta, aux.periodo,aux.rn, auxp.orden--,pao.orden
order by om.facultad,om.carrera,p.apellidos,p.nombres

select * from aca.estudiante_oferta where id_estudiante_oferta in (64709,
    64659,64851,64812,64846,65166,65665,65713,65825,
65763,65885,66018,66351,66950,67245,67257,67382,
67308,67332,67621,77191    )
select id_periodo_academico,codigo,descripcion,orden from aca.periodo_academico where id_tipo_oferta = 1


---acuass
--2400301244 0929834737
select
--     eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.id_periodo_academico,p.identificacion,p.apellidos,p.nombres,pa.codigo,o.descripcion,te.descripcion,tee.descripcion,tie.descripcion,eo.mantiene_gratuidad,eo.id_malla,
--     eo.estado
eo.*
from aca.estudiante_oferta eo
         inner join man.personas p on eo.id_persona = p.id
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
         inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
         left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
where
--     eo.id_estudiante_oferta in (79400)
p.identificacion in ('2450466848')


select * from mig.record_oferta where identificacion='2400162166'
--     89216
select * from aca.estudiante_oferta where id_periodo_academico = 96 and id_oferta_modalidad = 85
select * from aca.malla where id_oferta_modalidad = 85
select * from aca.tipo_estado_estudiante

select * from aca.estudiante_matricula em

select * from mig.estudiante_oferta_jerarquia

select * from aca.fn_get_all_offers('2450203134',null,null,null,null,'ACT')

select * from aca.estudiante_matricula where id_estudiante_oferta = 53402

select * from aca.fn_get_all_offers('2400255440',null,null,null,null,null)

select * from aca.fn_get_all_offers('2400255440','PREGRADO',null,null,null,null)

