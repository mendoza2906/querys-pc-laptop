use bd_sga_upse;


select d.*
from [aca].[fn_get_list_estudiantes_asignatura_paralelo](245,1,23) as d

select * from man.personas_documentos


select * from [aca].[fn_get_info_estudiante_by_periodo](NULL,17433,23)

select * from aca.oferta_modalidad


select * from man.personas_documentos

select * from aca.clase

--migrar records de los manes de entrenamiento deportivo
begin
    select
--     distinct  em.*
        --       distinct  ea.*--,p.identificacion
--         distinct eo.*
        distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,p.identificacion,p.apellidos,p.nombres,tee.descripcion,tie.descripcion,eo.estado,eo.ultimo_periodo
--     ,(select count (*) from aca.estudiante_matricula em where em.id_estudiante_oferta = eo.id_estudiante_oferta) as matriculas
--     ,a.descripcion as asignatura,ma.id_malla_asignatura,ac.id_malla_asignatura_comp,aa.id_asignatura_aprendizaje,aa1.id_asignatura_aprendizaje
--     update ea set ea.id_asignatura_aprendizaje = aa1.id_asignatura_aprendizaje
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
    where p.identificacion='0927283804'
--         eo.id_periodo_academico in (95,96)
--     and
--         eo.id_oferta_modalidad = 82 and eo.id_tipo_estado_estudiante = 1 and eo.id_malla= 77
end;

select * from aca.estudiante_malla
select * from mig.periodo_academico_ponderacion


begin
    select
--     distinct  em.*
         --       distinct  ea.*--,p.identificacion
--         distinct eo.*
        distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,p.identificacion,p.apellidos,p.nombres,
                 tee.descripcion,tie.descripcion,eo.estado,eo.ultimo_periodo
--            ,eo.id_malla,eoh.id_estudiante_oferta,eoh.id_malla,ofa1.carrera
--         ,a.descripcion as asignatura,ma.id_malla_asignatura
--          ,ac.id_malla_asignatura_comp,aa.id_asignatura_aprendizaje,aa1.id_asignatura_aprendizaje,a2.descripcion
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
--             inner join aca.estudiante_oferta eoh on eoh.id_estudiante_oferta_padre = eo.id_estudiante_oferta
--              inner join aca.ofertas_facultad ofa1 on ofa1.id_oferta_modalidad = eoh.id_oferta_modalidad
             left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
--                 inner join aca.estudiante_matricula em on eoh.id_estudiante_oferta = em.id_estudiante_oferta
--             inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
--              inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = mg.id_periodo_academico
--             inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
--             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
--             inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
--             inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
--             inner join aca.asignatura_compatibilidad ac on ma.id_malla_asignatura = ac.id_malla_asignatura and ac.tipo='REDISEÑO_MALLA'
--             inner join aca.asignatura_aprendizaje aa1 on aa1.id_malla_asignatura = ac.id_malla_asignatura_comp and aa1.id_componente_aprendizaje = aa.id_componente_aprendizaje
--              inner join aca.malla_asignatura ma2 on ma2.id_malla_asignatura = ac.id_malla_asignatura_comp
--              inner join aca.asignatura a2 on ma2.id_asignatura = a2.id_asignatura
    where --eo.id_periodo_academico in (95,96)
--       and
        eo.id_oferta_modalidad = 21  and eo.id_malla = 172
    --no estaban matriculados y estan en la lista
    and p.identificacion in ('2400417917','2450216730','2450481649','0942956046','2450707779','0963197884','2400199507','2450935016','2400332223','2450169160')
--       and mg.id_periodo_academico=136
end;


--personas de biología que han perdido materias de primero
begin
    select
--     distinct  em.*
        --       distinct  ea.*--,p.identificacion
--         distinct eo.*
        distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,p.identificacion,p.apellidos,p.nombres,
        tee.descripcion,tie.descripcion,eo.estado,eo.ultimo_periodo,eo.id_malla,aux.primero,aux1.primeroMov,aux2.primeroSis,
        (isnull(aux.primero,0)+isnull(aux1.primeroMov,0)+isnull(aux2.primeroSis,0)) as AprobadasPrimero,auxAll.materias
--             ,eoh.id_estudiante_oferta,eoh.id_malla,ofa1.carrera
    --         ,a.descripcion as asignatura,ma.id_malla_asignatura
--          ,ac.id_malla_asignatura_comp,aa.id_asignatura_aprendizaje,aa1.id_asignatura_aprendizaje,a2.descripcion
--     update ea set ea.id_asignatura_aprendizaje = aa1.id_asignatura_aprendizaje
--     update em set em.id_estudiante_oferta = eed.id_estudiante_oferta
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
--              inner join aca.estudiante_oferta eoh on eoh.id_estudiante_oferta_padre = eo.id_estudiante_oferta and eoh.id_malla = 172
--              inner join aca.ofertas_facultad ofa1 on ofa1.id_oferta_modalidad = eoh.id_oferta_modalidad
             inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
             left join (select  eo1.id_estudiante_oferta,niv.id_nivel,count(ea.id_estudiante_asignatura) as primero
--                  , ROW_NUMBER() OVER (PARTITION BY eo1.id_estudiante_oferta ORDER BY  niv.orden DESC) AS rn
                         from aca.matricula_general mg
                                  inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
                                  inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
                                  inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
                                  inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
                                  inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
                                  inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
                         where  eo1.estado='A' and em1.estado='A' and ea.estado='A'  and mg.estado='A'
                           and aa.estado='A'  and ma.estado='A' and niv.estado='A' and ea.aprobado=1 and niv.id_nivel= 1
                         group by eo1.id_estudiante_oferta,niv.ORDEN,niv.id_nivel
            ) as aux on aux.id_estudiante_oferta = eo.id_estudiante_oferta
             left join (select  eo1.id_estudiante_oferta,count(ea.id_estudiante_asignatura) as materias
                        from aca.matricula_general mg
                                 inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
                                 inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
                                 inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
                                 inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
                                 inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
                                 inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
                        where  eo1.estado='A' and em1.estado='A' and ea.estado='A'  and mg.estado='A'
                          and aa.estado='A'  and ma.estado='A' and niv.estado='A' --and ea.aprobado=1
                        group by eo1.id_estudiante_oferta
        ) as auxAll on auxAll.id_estudiante_oferta = eo.id_estudiante_oferta
             left join (select  eo1.id_estudiante_oferta,niv.id_nivel,count(distinct dm.id_malla_asignatura) as primeroMov
        --                  , ROW_NUMBER() OVER (PARTITION BY eo1.id_estudiante_oferta ORDER BY  niv.orden DESC) AS rn
                                from aca.movilidad m
                                         inner join aca.detalle_movilidad dm on  m.id_movilidad = dm.id_movilidad
                                         inner join aca.estudiante_oferta eo1 on m.id_estudiante_oferta = eo1.id_estudiante_oferta
                                         inner join aca.malla_asignatura ma on dm.id_malla_asignatura=ma.id_malla_asignatura
                                         inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
                                where  eo1.estado='A' and dm.estado='A' and  m.estado='A'
                                  and ma.estado='A' and niv.estado='A' and dm.aprobado=1 and niv.id_nivel = 1
                                group by eo1.id_estudiante_oferta,niv.ORDEN,niv.id_nivel
            ) as aux1 on aux1.id_estudiante_oferta = eo.id_estudiante_oferta
            left join (select  ro.id_estudiante_oferta,ra.id_nivel,count(ra.id_record_asignatura) as primeroSis
                    --                  , ROW_NUMBER() OVER (PARTITION BY eo1.id_estudiante_oferta ORDER BY  niv.orden DESC) AS rn
                    from mig.record_oferta ro
                    inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
                    where  ro.estado='A' and ra.estado='A' and ra.aprobado=1 and ra.id_nivel = 1
                    group by ro.id_estudiante_oferta,ra.id_nivel
            ) as aux2 on aux2.id_estudiante_oferta = eo.id_estudiante_oferta
    where
        eo.id_oferta_modalidad = 21  and eo.id_malla = 23 and
        eo.id_tipo_estado_estudiante = 1 and eo.estado='A' --and eo.ultimo_periodo = '2026-1'
--       and mg.id_periodo_academico = 136
        and (isnull(aux.primero,0)+isnull(aux1.primeroMov,0)+isnull(aux2.primeroSis,0))<5
--       and pa.codigo in ('2023-2','2024-1','2024-2','2025-1','2025-2')
--         and p.identificacion in ('2450318452',	'2450563735',	'2450382359',	'0932056302',	'2450924028',	'0942970278',	'2450924499',	'2450945940',
--                                  '2400199507',	'2450382193',	'2450935016',	'0942956046',	'0927963322',	'2450216730',	'2400332223',	'2450430760',
--                                  '2450853755',	'0928014653',	'2400396020',	'2450053620',	'2450882341',	'0956664007',	'2450191412',	'2450937111',
--                                  '2450169160',	'2400171357',	'2450136326',	'2400417917',	'2450616988',	'2400061251',	'0927967299',	'2450481649',
--                                  '2150345581',	'2450592031',	'2400257958',	'2451546168',	'2450315938',	'2400275810',	'2450205105',	'2450861527',
--                                  '2450506551',	'2400363707',	'2450251877',	'2400436438',	'2400253072',	'2450054115',	'2450707779',	'2400229726',
--                                  '2450499104',	'1250808134',	'0928558063',	'0953862224',	'2450649872',	'2450933573',	'2400239378',	'0963197884',
--                                  '2450330747',	'2450736216',	'2400229460',	'2450325697',	'2450781915',	'2400289209' )
    --no estaban matriculados y estan en la lista
--     and p.identificacion in ('2400417917','2450216730','2450481649','0942956046','2450707779','0963197884','2400199507','2450945940','2450935016','2400332223','2450169160','2400257958')
    --deberian tener rediseño por 3ra vez
--       and p.identificacion in ('1721989497','0942945981')
end;

--set matriculas al nuevo record
begin
    select
    distinct  ea.*
-- --         distinct eo.*
--         distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,p.identificacion,p.apellidos,p.nombres,
--         tee.descripcion,tie.descripcion,eo.estado,eo.ultimo_periodo,eo.id_malla,em.id_estudiante_matricula,eo.id_estudiante_oferta,eoh.id_estudiante_oferta
--     update ea set ea.id_asignatura_aprendizaje = aa1.id_asignatura_aprendizaje
--     update em set em.id_estudiante_oferta = eoh.id_estudiante_oferta
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.estudiante_oferta eoh on eoh.id_estudiante_oferta_padre = eo.id_estudiante_oferta and eoh.id_malla = 172
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
        eo.id_oferta_modalidad = 21  and eo.estado='A' and eo.id_malla = 23  -- and eo.ultimo_periodo = '2026-1'
      and mg.id_periodo_academico = 136
      and p.identificacion in ('2450424383')
end;

--set asignaturas de matriculas en el nuevo record
begin
--     update ea set ea.id_asignatura_aprendizaje = d.id_asignatura_aprendizaje_rep,ea.valor_asignatura = d.valor
    select distinct ea.*
--     select distinct mr.id_matricula_rubro,ea.*
--         ea.*,d.valor,d.id_asignatura_aprendizaje_rep
    from (
    select
--     distinct  ea.*
-- --         distinct eo.*
        distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,p.identificacion,p.apellidos,p.nombres,
        tee.descripcion as tipo_estado,tie.descripcion as tipo_ingreso,eo.estado,eo.ultimo_periodo,eo.id_malla,aux.primero,aux1.primeroMov
        ,ROW_NUMBER() OVER (PARTITION BY em.id_estudiante_matricula ORDER BY  ea.id_estudiante_asignatura ) AS rn
           ,em.id_estudiante_matricula,ea.id_estudiante_asignatura,ea.id_asignatura_aprendizaje,a.descripcion as asignatura,
            daa.id_asignatura_aprendizaje as id_asignatura_aprendizaje_rep,ea.estado as estado_asi
    ,dma.num_creditos*8 as valor
    --     update ea set ea.id_asignatura_aprendizaje = aa1.id_asignatura_aprendizaje
--     update em set em.id_estudiante_oferta = eoh.id_estudiante_oferta
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
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
            inner join aca.movilidad m on eo.id_estudiante_oferta = m.id_estudiante_oferta
            inner join aca.detalle_movilidad dm on m.id_movilidad = dm.id_movilidad and dm.aprobado=0 and dm.estado='A'
            inner join aca.malla_asignatura dma on dma.id_malla_asignatura = dm.id_malla_asignatura
            inner join aca.asignatura_aprendizaje daa on daa.id_malla_asignatura = dm.id_malla_asignatura and daa.id_componente_aprendizaje = aa.id_componente_aprendizaje
             left join (select  eo1.id_estudiante_oferta,count(ea.id_estudiante_asignatura) as primero
                                    from aca.matricula_general mg
                                             inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
                                             inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
                                             inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
                                             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
                                             inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
                                             inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
                                    where  eo1.estado='A' and em1.estado='A' and ea.estado='A'  and mg.estado='A'
                                      and aa.estado='A'  and ma.estado='A' and niv.estado='A' and (ea.aprobado=0 or ea.aprobado is null)
                                    group by eo1.id_estudiante_oferta
                ) as aux on aux.id_estudiante_oferta = eo.id_estudiante_oferta
             left join (select  eo1.id_estudiante_oferta,niv.id_nivel,count(distinct dm.id_malla_asignatura) as primeroMov
                                    --                  , ROW_NUMBER() OVER (PARTITION BY eo1.id_estudiante_oferta ORDER BY  niv.orden DESC) AS rn
                                    from aca.movilidad m
                                             inner join aca.detalle_movilidad dm on  m.id_movilidad = dm.id_movilidad
                                             inner join aca.estudiante_oferta eo1 on m.id_estudiante_oferta = eo1.id_estudiante_oferta
                                             inner join aca.malla_asignatura ma on dm.id_malla_asignatura=ma.id_malla_asignatura
                                             inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
                                    where  eo1.estado='A' and dm.estado='A' and  m.estado='A'
                                      and ma.estado='A' and niv.estado='A' and dm.aprobado=0
                                    group by eo1.id_estudiante_oferta,niv.ORDEN,niv.id_nivel
                ) as aux1 on aux1.id_estudiante_oferta = eo.id_estudiante_oferta
    where
        eo.id_oferta_modalidad = 21  and eo.estado='A' and eo.id_malla = 172
      and mg.id_periodo_academico = 136
      and p.identificacion in ('2450424383')
--     and aux1.primeroMov= 3
    ) as d
    inner join aca.estudiante_asignatura ea on ea.id_estudiante_asignatura = d.id_estudiante_asignatura
--     inner join aca.estudiante_matricula em on ea.id_estudiante_matricula = em.id_estudiante_matricula
--     left join aca.matricula_rubro mr on em.id_estudiante_matricula = mr.id_estudiante_matricula
--     where --d.rn in (2,3)   and
--     where ea.id_estudiante_asignatura  in (739022,739023,739024,795658,795659,795660,737280,737281,737282,739551,739552,739553           )
end;

select * from aca.estudiante_asignatura where id_estudiante_asignatura = 728875
select * from aca.matricula_rubro where estado='I' and id_rubro = 9

select * from aca.malla where id_oferta_modalidad = 21

select  ra.*
from mig.record_oferta ro
         inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
where  ro.estado='A' and ra.estado='A' and ro.id_estudiante_oferta = 4898


select  ro.id_estudiante_oferta,ra.id_nivel,count(ra.id_record_asignatura) as primeroSis
--                  , ROW_NUMBER() OVER (PARTITION BY eo1.id_estudiante_oferta ORDER BY  niv.orden DESC) AS rn
from mig.record_oferta ro
         inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
where  ro.estado='A' and ra.estado='A' and ra.aprobado=1 and ro.id_estudiante_oferta = 4898

group by ro.id_estudiante_oferta,ra.id_nivel

select d.*
from [aca].[fn_get_all_records_by_offer](4898,null,null,null,null) as d

select d.*
from [aca].[fn_get_all_records_by_offer](4898,null,null,null,null) as d
         inner join aca.asignatura_compatibilidad ac on ac.id_malla_asignatura = d.idMallaAsigntura
         inner join aca.malla_asignatura ma on ma.id_malla_asignatura = ac.id_malla_asignatura_comp
         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where ac.estado='A' and ac.tipo='REDISEÑO_MALLA' and d.idPeriodoAcademico not in (@id_periodo_academico) and d.estado='A'

exec [aca].[sp_generate_migrate_transicion_malla_curricular] 136,'0928381037'

select *
from [aca].[fn_get_all_records_by_offer](66500,null,null,null,null) as d
where d.estado='A'

-- '2450382193','2400225807'

select * from aca.ofertas_facultad where id_tipo_oferta = 2 and id_departamento =12
SELECT * FROM ACA.subtipo_movilidad
select * from aca.malla where id_oferta_modalidad = 82
select *  from aca.detalle_movilidad where usuario_mod is null
-- update aca.detalle_movilidad  set fecha_mod=fecha_ing where fecha_mod is null



-- select u.usuario,dm.*
update dm set dm.usuario_mod = dm.usuario_ing
from aca.detalle_movilidad dm
inner join seg.usuarios u on u.id = dm.usuario_ingreso_id
where dm.usuario_mod is null

select * from dbo.persona_nivelacion pn
where pn.identificacion ='2400255440'

select * from man.personas where identificacion='2400255440'

select * from man.personas where identificacion ='2400254286'

select * from aca.jornada_laboral

select * from man.personas_documentos

select * from aca.tipo_horario_jornada_lab

select od.id_oferta_docente,d.id_docente,p.id,o.id_oferta,o.descripcion,p.apellidos,p.nombres from aca.oferta_docente od
inner join aca.docente d on d.id_docente = od.id_docente
inner join man.personas p on p.id = d.id_persona
    inner join aca.periodo_academico_oferta pao on pao.id_periodo_academico_oferta = od.id_periodo_academico_oferta
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
         inner join aca.oferta o on o.id_oferta = om.id_oferta
where pao.id_periodo_academico = 23 and o.id_oferta = 40

select od.* from aca.oferta_docente od
inner join aca.docente d on d.id_docente = od.id_docente
inner join man.personas p on p.id = d.id_persona
    inner join aca.periodo_academico_oferta pao on pao.id_periodo_academico_oferta = od.id_periodo_academico_oferta
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
         inner join aca.oferta o on o.id_oferta = om.id_oferta
where pao.id_periodo_academico = 23 and o.id_oferta = 19
-- 337
select da.* from aca.distributivo_docente dd
inner join aca.docente_actividad da on da.id_distributivo_docente = dd.id_distributivo_docente
where dd.id_docente = 46

select * from dbo.cargo

select * from aca.docente_dedicacion

select * from aca.tipo_jornada_laboral

SELECT * FROM dbo.persona_nivelacion where identificacion='2400460511'


select * from aca.campus

SELECT * FROM seg.roles_usuarios

select * from aca.tipo_documento

select *,o.descripcion from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.oferta o on o.id_oferta = om.id_oferta
         where p.nombres like '%narcisa%' and o.id_oferta in (25,59)




select *,o.descripcion from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.oferta o on o.id_oferta = om.id_oferta
         where p.nombres like '%renata priscila%' or p.nombres like '%Keny Valeria%'
or p.nombres like '%Edison Vinicio%'


select p.* from man.personas p
--          inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = p.id
--          inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
--          inner join aca.oferta o on o.id_oferta = om.id_oferta
         where p.apellidos like '%morales ruiz%' or p.apellidos like '%perero cevallos%'

select * from aca.docente_categoria

select * from dbo.cargo

select * from aca.tipo_jornada_laboral

select Bd_Academico.dbo.[fn_Md5]('2400254286')

select * from seg.roles

select per.identificacion,per.apellidos,per.nombres from bd_sga_upse.man.personas per where per.estado='AC'

and identificacion='0928340488'


exec [migracion_sga].dbo.[SPMigracionPersonalAdministrativoSoloDatosPersonales]}



select p.IDENTIFICACION,p.NOMBRES,p.APELLIDOS from bd_recursos_humanos.dbo.bd_Contratos c
inner join  Bd_Personal.dbo.PF_PERSONAS p on p.ID_PERSONA = c.id_persona
where YEAR(c.Fecha_Contrato) ='2023' and c.EstadoContrato ='A' and p.IDENTIFICACION
 --in(select per.IDENTIFICACION from bd_sga_upse.man.personas per where per.estado='AC')
 not in ( select p.identificacion from bd_sga_upse.seg.usuarios u
inner join man.personas p on p.id = u.persona_id
where u.estado='AC' and p.estado ='AC')

 select p.id from bd_sga_upse.seg.usuarios u
inner join man.personas p on p.id = u.persona_id
where u.estado='AC' and p.estado ='AC'


select u.id from bd_sga_upse.seg.usuarios u
inner join man.personas p on p.id = u.persona_id
where u.usuario in ('0906670831')

select * from bd_sga_upse.seg.usuarios u
where u.id > 34096




 select per.id,per.IDENTIFICACION,per.fecha_ing from bd_sga_upse.man.personas per where per.estado='AC'
 and per.identificacion in (select p.IDENTIFICACION from bd_recursos_humanos.dbo.bd_Contratos c
inner join  Bd_Personal.dbo.PF_PERSONAS p on p.ID_PERSONA = c.id_persona
where YEAR(c.Fecha_Contrato) ='2023' and c.EstadoContrato ='A')-- and cast(per.fecha_ing as date)= cast(GETDATE() as date)
order by id

-- select p.id,p.identificacion,p.nombres,p.estado,u.id,u.estado from bd_sga_upse.seg.usuarios u
-- inner join man.personas p on p.id = u.persona_id
-- where u.usuario in ('0914252614')

select p.id,p.identificacion,p.nombres,p.estado,u.id,u.estado from bd_sga_upse.seg.usuarios u
inner join man.personas p on p.id = u.persona_id
where u.usuario in ('0914252614')

select u.* from bd_sga_upse.seg.usuarios u
inner join man.personas p on p.id = u.persona_id
where u.usuario in ('0914252614')


select * from [aca].[fn_listar_estudiantes_a_matricular_modular](5,null,23,null)

	select o.descripcion as carrera,eo.id_estudiante_oferta,
    eo.id_oferta_modalidad,p.identificacion,p.apellidos+ ' '+ p.nombres as nombres
    from man.personas p
    inner join aca.estudiante_oferta eo on p.id = eo.id_persona
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.oferta o on o.id_oferta = om.id_oferta
    inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    where eo.estado='A' and o.id_tipo_oferta = 2 and tee.codigo='ACT'
    order by carrera, nombres asc

select * from (
select distinct ro.id_record_oferta,ro.id_oferta_modalidad,ro.id_estudiante_oferta,rd.id_nivel from aca.record_oferta ro
inner join aca.record_detalle rd on rd.id_record_oferta = ro.id_record_oferta
where rd.estado='A' and rd.id_nivel_sw in (47,48,49,50,51)
--   and ro.id_record_oferta = 110
  and ro.id_oferta_modalidad is not null
and rd.id_nivel = (select max(rdd.id_nivel) from aca.record_detalle rdd where rdd.estado ='A' and rdd.id_record_oferta = rd.id_record_oferta
                                                                        and rdd.promedio>=70)
) as d



select * from aca.nivel

select * from aca.periodo_academico where id_tipo_oferta = 4

select * from aca.record_detalle


select * from aca.modalidad

select d.nombre,o.descripcion,p.identificacion,p.apellidos,p.nombres,pa.codigo, count(bc.id_becario),sum(bc.total_consumido) from mov.becario_consumo bc
inner join mov.becario b on b.id_becario = bc.id_becario
inner join aca.periodo_academico pa on pa.id_periodo_academico = b.id_periodo_academico
inner join man.personas p on p.id = b.id_persona
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
inner join man.departamentos d on d.id = do.id_departamento
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
where eo.estado='A' and o.id_tipo_oferta = 2 and tee.codigo='ACT' and eo.estado='A' and
--       cast(bc.fecha_ing as date) <='2023-01-31' --and b.id_periodo_academico = 23
    cast(bc.fecha_ing as date) between '2023-01-25' and '2023-03-15'
group by  d.nombre,o.descripcion,p.identificacion,p.apellidos,p.nombres,bc.id_becario,pa.codigo
order by d.nombre,o.descripcion,p.apellidos,p.nombres asc

select d.nombre,o.descripcion,p.identificacion,p.apellidos,p.nombres,bc.id_becario,pa.codigo,cast(bc.fecha_ing as date) from mov.becario_consumo bc
inner join mov.becario b on b.id_becario = bc.id_becario
inner join aca.periodo_academico pa on pa.id_periodo_academico = b.id_periodo_academico
inner join man.personas p on p.id = b.id_persona
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
inner join man.departamentos d on d.id = do.id_departamento
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
where eo.estado='A' and o.id_tipo_oferta = 2 and tee.codigo='ACT' and eo.estado='A' and cast(bc.fecha_ing as date) <='2023-01-31' --and b.id_periodo_academico = 23
order by bc.fecha_ing

select * from aca.oferta_modalidad where id_oferta = 10

select * from aca.modalidad

SELECT * FROM ACA.periodo_academico

select * from aca.oferta

select * from aca.modalidad_asignatura

select * from aca.oferta_asignatura

select * from aca.malla_asignatura

SELECT * FROM ACA.reglamento

SELECT r.id_reglamento as id,r.id_Tipo_Reglamento as idtipoteglamento, tr.codigo as codigoTipo, r.nombre as nombre ,
			rv.codigo as codigoValidacion,rv.descripcion as descripcionValidacion,rv.valor as valorValidacion
			FROM aca.Reglamento r INNER JOIN aca.Tipo_Reglamento tr on r.id_Tipo_Reglamento=tr.id_tipo_reglamento
			INNER JOIN aca.Reglamento_Validacion rv on r.id_reglamento=rv.id_Reglamento
			where  r.estado = 'A' and tr.estado='A' and rv.estado='A' and r.fecha_Hasta>=GETDATE() and r.id_Tipo_Oferta = (?1)


exec [aca].[replicate_plan_clases_to_other_docente] 823,2,1,494,23,23,
    '2022-12-24','0913932968',0


SELECT * FROM seg.usuarios where usuario ='0913932968'


select * from aca.oferta_modalidad



select * from aca.malla

select  top 30
    * from aca.malla_asignatura
order by fecha_ing desc


-- DBCC CHECKIDENT ('aca.oferta_modalidad', RESEED, 80)

select * from aca.asignatura a where a.descripcion like '%COMUNICACION TECNICA%'

SELECT r.id_reglamento as id,r.id_Tipo_Reglamento as idtipoteglamento, tr.codigo as codigoTipo, r.nombre as nombre ,
			rv.codigo as codigoValidacion,rv.descripcion as descripcionValidacion,rv.valor as valorValidacion
			FROM aca.Reglamento r INNER JOIN aca.Tipo_Reglamento tr on r.id_Tipo_Reglamento=tr.id_tipo_reglamento
			INNER JOIN aca.Reglamento_Validacion rv on r.id_reglamento=rv.id_Reglamento
			where  r.estado = 'A' and tr.estado='A' and rv.estado='A' and r.id_reglamento = 1



select  top 30
    * from aca.malla_asignatura
order by fecha_ing desc
select * from aca.periodo_academico
select * from aca.modalidad_asignatura

select * from aca.oferta
select * from aca.oferta_modalidad

select * from niv.cursos_nivelacion

select * from aca.moodle

-- DBCC CHECKIDENT ('aca.oferta', RESEED, 86)

select * from aca.componente_aprendizaje


select o.id_oferta,o.estado,O.descripcion,m.id_oferta_modalidad,m.descripcion,m.estado,aa.* from aca.asignatura_aprendizaje aa
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
inner join aca.malla m on m.id_malla = ma.id_malla
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = m.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
-- inner join aca.docente_asignatura_aprend daa on daa.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
where aa.id_componente_aprendizaje in (4)
and aa.estado='A' and aa.valor=0

--1496 regiustros com componentes VIRTUAL
-- update aca.asignatura_aprendizaje set estado='I'
-- where id_asignatura_aprendizaje in (select aa.id_asignatura_aprendizaje from aca.asignatura_aprendizaje aa
-- inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
-- inner join aca.malla m on m.id_malla = ma.id_malla
-- inner join aca.oferta_modalidad om on om.id_oferta_modalidad = m.id_oferta_modalidad
-- inner join aca.oferta o on o.id_oferta = om.id_oferta
-- where aa.id_componente_aprendizaje in (5))

--1494 regiustros com componentes PRESENCIAL A DOCENTE
-- update aca.asignatura_aprendizaje set id_componente_aprendizaje = 2
-- where id_asignatura_aprendizaje in (select aa.id_asignatura_aprendizaje from aca.asignatura_aprendizaje aa
-- inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
-- inner join aca.malla m on m.id_malla = ma.id_malla
-- inner join aca.oferta_modalidad om on om.id_oferta_modalidad = m.id_oferta_modalidad
-- inner join aca.oferta o on o.id_oferta = om.id_oferta
-- where aa.id_componente_aprendizaje in (4) and aa.estado='A')

select * from man.departamentos

select * from aca.oferta
select * from aca.oferta_modalidad

select * from aca.departamento_oferta where id_oferta =67

select * from aca.estudiante_oferta eo
--          inner join aca.estudiante_matricula
where eo.id_estudiante_oferta = 2691

exec [aca].[sp_rpt_comprobante_matricula_estudiante] 6251,0


-- EXEC aca.[sp_generar_detalle_distributivo_oferta_docente_asignatura] 89,1169,32
select * from man.departamentos

select a.descripcion,ma.* from aca.malla_asignatura ma
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where ma.id_malla = 78


select ro.carrera,rd.* from aca.record_detalle rd
inner join aca.record_oferta ro on ro.id_record_oferta = rd.id_record_oferta
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = ro.id_oferta_modalidad
where rd.nivel ='MODULOS'
order by carrera

select distinct ro.id_oferta_modalidad,ro.carrera,rd.asignatura from aca.record_detalle rd
inner join aca.record_oferta ro on ro.id_record_oferta = rd.id_record_oferta
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = ro.id_oferta_modalidad
where rd.nivel ='MODULOS' --and ro.id_oferta_modalidad = 32
order by carrera,rd.asignatura

select * from aca.asignatura_aprendizaje
select * from aca.asignatura_organizacion

select * from aca.malla_asignatura

select * from aca.tipo_malla


    select * from bd_sga_upse.aca.movilidad m
    where m.id_estudiante_oferta = 18550 and m.id_subtipo_movilidad = 2 and m.estado='A'

exec [aca].[sp_migrate_notas_examen_ubicacion] 23


-- DBCC CHECKIDENT ('pro.etapa_ejecucion_requisito', RESEED, 1);

select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Oferta](23,14,0,0)
select * from [pro].[fn_list_periodos_academicos_by_process](2,-1)

select * from aca.fn_get_all_offers('2450685272',null,null,null,null,null)

--70  200
select --o.codigo,o.nombre,
       uo.* from seg.usuario_opcion uo
                     inner join man.opciones o on uo.id_opcion = o.id
where uo.estado='A'

select * from man.opciones where id in (70,200)

select * from aca.ofertas_facultad where id_tipo_oferta = 2

select pao.* from aca.periodo_academico_oferta pao
inner join aca.oferta_modalidad om on pao.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
where pao.estado='A' and pao.id_periodo_academico = 96
order by o.descripcion

select * from man.departamentos where tipo ='FAC'


select * from man.opciones where nombre like '%Movilidad%' or nombre like '%cambio%'
--14174
select * from seg.usuarios where usuario ='2400255440'

select * from aca.periodo_academico where id_tipo_oferta = 2
--acuas
    select  distinct pc.* from  pro.proceso pro
    inner join pro.tipo_proceso tp on tp.id_tipo_proceso=pro.id_tipo_proceso
    inner join pro.proceso_general pg on pg.id_proceso = pro.id_proceso
    inner join aca.periodo_academico pa on pa.id_periodo_academico = pg.id_periodo_academico
    inner join pro.proceso_calendario pc on pg.id_proceso_general = pc.id_proceso_general
    where pro.estado='A' and tp.estado='A' and pg.estado='A' and pa.estado='A' and tp.codigo='SOLICITUDESCAMBIOCARRERA'
    and pa.id_periodo_academico in (136)


select * from pro.proceso_calendario


select * from aca.modalidad_asignatura

select * from aca.periodo_academico_oferta

-- DBCC CHECKIDENT ('pro.proceso_calendario', RESEED, 328);

select ma.* from aca.malla_asignatura ma
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where id_malla = 92 and ma.id_malla_asignatura = 1960

select * from aca.asignatura where asignatura.descripcion like '%FINANZAS I%'
-- update aca.asignatura_aprendizaje set id_componente_aprendizaje = 19 where id_asignatura_aprendizaje in (
-- select aa.id_asignatura_aprendizaje
 select aa.*
from aca.asignatura_aprendizaje aa
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
where ma.id_malla = 85 and aa.id_componente_aprendizaje = 7
-- )

select ofa.carrera,pao.* from aca.periodo_academico_oferta pao
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = pao.id_oferta_modalidad
where pao.estado='A' and pao.id_periodo_academico in (136) and ofa.id_oferta_modalidad not in (125)
order by ofa.carrera

select * from aca.modalidad
select * from aca.oferta_modalidad

select * from pro.proceso_usuario where usuario_ing='2400255440'

select * from aca.planificacion_paralelo
update aca.planificacion_paralelo set unico_docente=0 where unico_docente is null

select * from aca.periodo

select * from [pro].[fn_list_documentos_to_validate_etapa](42060,9)

select * from [pro].[fn_list_documentos_to_validate_etapa](5324,9)

select er.* from pro.etapa_requisito er
                     inner join pro.proceso_calendario pc on er.id_proceso_calendario = pc.id_proceso_calendario
                     inner join pro.proceso_general pg on pc.id_proceso_general = pg.id_proceso_general
where pg.id_periodo_academico = 36

select
--     pc.id_proceso_calendario,e.id_etapa,e.descripcion,pr.id_proceso_requisito,pr.descripcion,pr.estado
   distinct pr.*
from pro.etapa_requisito er
inner join pro.proceso_calendario pc on er.id_proceso_calendario = pc.id_proceso_calendario
inner join pro.proceso_general pg on pc.id_proceso_general = pg.id_proceso_general
inner join pro.proceso_etapa pe on pc.id_proceso_etapa = pe.id_proceso_etapa
inner join pro.etapa e on pe.id_etapa = e.id_etapa
inner join pro.proceso_requisito pr on er.id_proceso_requisito = pr.id_proceso_requisito
where er.estado='A' and pc.estado='A' and pe.estado='A' and e.estado='A' and pe.id_proceso = 2 and pg.id_periodo_academico in (96,136)

select * from pro.proceso_calendario where id_proceso_etapa = 9

select* from aca.oferta_modalidad where id_oferta = 20

select * from man.personas p where p.identificacion ='2400054892'

select * from seg.roles

select * from aca.matricula_general

select * from aca.tipo_matricula_fecha

select * from aca.componente_aprendizaje

select * from aca.periodo_academico


select ca.codigo,aa.* from aca.malla_asignatura ma
inner join aca.asignatura_aprendizaje aa on aa.id_malla_asignatura =ma.id_malla_asignatura
inner join aca.componente_aprendizaje ca on ca.id_componente_aprendizaje = aa.id_componente_aprendizaje
where ma.id_malla = 20 --and ca.id_componente_aprendizaje = 2

select * from aca.fn_listar_componentes_aprendizajes_reglamento(2) as d
where d.codigoPadre in ('DOCENCIA')

select  ro.id_record_oferta,ro.id_oferta_modalidad,ro.id_estudiante_oferta,rd.* from aca.record_oferta ro
inner join aca.record_detalle rd on rd.id_record_oferta = ro.id_record_oferta
where ro.identificacion ='2400214892'


select * from card.membresia_persona
where id_persona = 323


 select pg.id_proceso_general as idProcesoGeneral,pa.id_periodo_academico as idPeriodoAcademico,pa.codigo as codigo, pa.descripcion as descripcion,tof.codigo as tipoOferta,
        case when cast(CURRENT_TIMESTAMP as date) >= pg.fecha_inicio and cast(CURRENT_TIMESTAMP as date)<= pg.fecha_fin then 1 else 0 end as vigente
        from  pro.proceso pro
        inner join pro.tipo_proceso tp on tp.id_tipo_proceso=pro.id_tipo_proceso
        inner join pro.proceso_general pg on pg.id_proceso = pro.id_proceso
        inner join aca.periodo_academico pa on pa.id_periodo_academico = pg.id_periodo_academico
        inner join aca.tipo_oferta tof on tof.id_tipo_oferta = pa.id_tipo_oferta
        where pro.estado='A' and tp.estado='A' and pg.estado='A' and pa.estado='A' and tp.codigo='SOLICITUDESCAMBIOCARRERA'
--         and (case when cast(CURRENT_TIMESTAMP as date) >= pg.fecha_inicio and cast(CURRENT_TIMESTAMP as date)<= pg.fecha_fin then 1 else 0 end = 1 or 1 is null)
        order by pa.fecha_desde desc






select * from aca.titulos_academicos where descripcion like '%MAGISTER EN GEST%'

select * from aca.nivel_formacion
--                   FORINI	FOR	INSTRUCCION INICIAL
select * from aca.institucion_nivel_formacion where id_nivel_formacion = 6
select * from aca.formacion_academica_personas where id_nivel_formacion = 6




select --mg.id_periodo_academico,
       u.id,p.identificacion,p.apellidos,p.nombres,o.descripcion
from man.personas p
inner join seg.usuarios u on u.persona_id = p.id
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
where  om.id_oferta_modalidad = 20 and tee.codigo='ACT'


select * from pro.fn_get_info_basica_estudiante (2674)

select  u.id as id_usuario,p.id,eo.id_estudiante_oferta,om.id_oferta_modalidad,do.id_departamento_oferta,
		p.identificacion,p.apellidos+ ' '+ p.nombres as nombres,eo.id_malla, m.estado,o.descripcion as carrera,o.id_tipo_oferta,tof.codigo as codigoTipoOferta,
		tee.codigo,p.estado,tee.estado,eo.estado
		from man.personas p
		inner join seg.usuarios u on u.persona_id = p.id
		inner join aca.estudiante_oferta eo on p.id = eo.id_persona
		inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
		left join aca.malla m on m.id_malla = eo.id_malla
		inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
	    inner join aca.oferta o on o.id_oferta = om.id_oferta
		inner join aca.tipo_oferta tof on tof.id_tipo_oferta = o.id_tipo_oferta
		inner join aca.departamento_oferta do on do.id_oferta= om.id_oferta
		inner join aca.tipo_ingreso_estudiante tie on tie.id_tipo_ingreso_estudiante = eo.id_tipo_ingreso_estudiante
		where  --tee.codigo='ACT' and p.estado ='AC' and  tee.estado ='A' and eo.estado ='A' and
		       u.id = 2674
		order by tof.codigo asc, nombres asc





select * from pro.tipo_proceso_estado
select * from pro.solicitud_cambio_carrera where id_proceso_usuario in (1079)

exec pro.pro_guardar_proceso_usuario_cambio_carrera 13008, 12516,11275,320,
    91,1,'SOLICITUDESCAMBIOCARRERA',27,'S/N'


select * from man.personas where id =5221
select pej.id_proceso_usuario,ejd.* from pro.proceso_etapa_ejecucion pej
inner join pro.etapa_ejecucion_responsable ejr on ejr.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion
inner join pro.etapa_ejecucion_documento ejd on ejd.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion
where pej.id_proceso_usuario = 1079

select * from pro.etapa_ejecucion_documento where id_etapa_ejecucion_documento in (1989,2029)


select * from [pro].[fn_list_documentos_to_validate_etapa](1010,9)

select om.id_oferta_modalidad,o.* from aca.oferta o inner join aca.oferta_modalidad om on om.id_oferta = o.id_oferta
where o.id_tipo_oferta = 2 --and om.id_oferta_modalidad = 108
and o.id_oferta in (96,97)
order by  om.id_oferta

select * from aca.malla where id_oferta_modalidad = 88

select * from pro.fn_get_info_basica_estudiante (34933)


select * from seg.roles_usuarios where usuario_id = 34933

select top 1 * from aca.estudiante_oferta where id_estudiante_oferta = 23334
select * from aca.tipo_estado_estudiante

select * from  pro.fn_get_info_user_process(34933,'ESTUDIANTE','SOLICITUDESCAMBIOCARRERA',27)

select u.id,p.id,p.identificacion,o.descripcion,eo.id_estudiante_oferta
-- eo.*
from  man.personas p
inner join seg.usuarios u on u.persona_id = p.id
left join aca.estudiante_oferta eo on eo.id_persona = p.id
left join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
left join aca.oferta o on o.id_oferta = om.id_oferta
left join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
where p.estado ='AC' and eo.estado='A' and eo.id_estudiante_oferta = 24824

select * from man.personas where identificacion='0929017085'

select * from aca.tipo_estudiante



select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta =2
--id user : 34933,id persona: 33614,0929011252
select u.id,p.id,p.identificacion,o.descripcion,eo.id_estudiante_oferta from  man.personas p
inner join seg.usuarios u on u.persona_id = p.id
left join aca.estudiante_oferta eo on eo.id_persona = p.id
left join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
left join aca.oferta o on o.id_oferta = om.id_oferta
left join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
where p.estado ='AC' --eo.estado ='A' and  and o.id_tipo_oferta = 2 and tee.id_tipo_estado_estudiante = 1
and  p.identificacion='2450111220'

exec aca.Sp_Record_Registro_Estudiantes 1 ,'0929011252'

select --o.descripcion,
       pao.* from aca.oferta o
inner join aca.oferta_modalidad om on o.id_oferta = om.id_oferta
inner join aca.periodo_academico_oferta pao on pao.id_oferta_modalidad = om.id_oferta_modalidad
where o.estado='A' and om.estado='A' and pao.estado='A' and pao.id_periodo_academico = 35
order by o.descripcion


select * from aca.oferta




exec [aca].[sp_rpt_estudiante_credito_primer_semestre] '2400054892'

exec aca.Sp_Record_Registro_Estudiantes 1 ,'2400054892'

select * from aca.periodo_academico_oferta where id_periodo_academico = 36
select * from aca.periodo_academico_oferta where id_periodo_academico = 95
select * from aca.periodo_academico_oferta where id_periodo_academico = 36 and id_oferta_modalidad not in (
    select id_oferta_modalidad from aca.periodo_academico_oferta where id_periodo_academico = 95
    )


-- where identificacion ='2300860547'


-- select * from pro.etapa_ejecucion_documento where file_name ='0928072750_27_36_SOLICITUD_CAMBIO_CARRERA.pdf'

select * from pro.etapa_ejecucion_documento where id_etapa_ejecucion_documento = 125
select * from [pro].[fn_list_documentos_to_validate_etapa](176,9)

select * from [pro].[fn_list_documentos_to_validate_etapa](1098,9)


select * from pro.tipo_proceso

select * from pro.etapa_ejecucion_requisito where id_etapa_ejecucion_requisito = 2289


-- DBCC CHECKIDENT ('pro.etapa_ejecucion_requisito', RESEED, 1);


select * from pro.proceso
select * from pro.proceso_usuario
select * from pro.etapa
select * from pro.proceso_requisito
select * from pro.etapa_requisito
select * from pro.proceso_etapa

select * from pro.proceso_general
select * from seg.roles
select * from pro.proceso_calendario
select * from aca.periodo_academico
select * from pro.proceso_etapa_rol

select * from pro.tipo_etapa_estado
select * from pro.tipo_proceso_estado

select * from pro.etapa_ejecucion_documento
select * from pro.etapa_ejecucion_requisito
select * from pro.proceso_general_documento

select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Oferta](31,23,null,null)

select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Oferta](59,23,null,null)

select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Oferta](89,27,null,null)


-- DBCC CHECKIDENT ('pro.etapa_ejecucion_requisito', RESEED, 1596);
select * from pro.etapa_ejecucion_requisito
select * from [pro].[fn_list_documentos_to_validate_etapa](1126,9)

select * from [pro].[fn_list_documentos_to_validate_etapa](176,9)

select * from pro.etapa_ejecucion_requisito where id_etapa_ejecucion_requisito in (1671,1672)

select ma.* from aca.malla_asignatura ma
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where ma.id_malla = 92 and ma.id_malla_asignatura = 2035
order by ma.codigo_malla


select * from niv.horarios_examen

select * from man.personas where identificacion ='2400115875'
-- DBCC CHECKIDENT ('niv.cursos_virtuales_estudiantes', RESEED, 1);
--
-- DBCC CHECKIDENT ('niv.horarios_examen', RESEED, 1);

select * from man.personas where nombres like '%IVANNA PRISCILLA%'

select * from cmo.postulacion_vacante where id_persona = 323

select * from seg.usuarios where usuario ='2400115875'

select * from seg.roles_usuarios where usuario_id in (19559,
35021,
35024,
35028
)

select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Oferta](null,36,null,null) as d
where d.identificacion='2450236431'


select p.celular,d.* from [pro].[fn_list_All_Estudiantes_Postulantes_By_Oferta](null,27,null,null) as d
inner join man.personas p on p.id = d.idPersona
         where d.uploadUrl is null


-- 0928198191

select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Oferta](null,27,null,null) as d
where d.identificacion in ('1105503591 ')

select * from aca.malla

select * from Bd_Academico.dbo.PERSONAS where IDENTIFICACION='2400057176'

select * from pro.proceso_usuario where id_proceso_usuario in (1140,1244,1240,1165,1076)

select * from man.personas where id = 32056

select * from seg.usuarios where usuario ='0913031423'

select * from man.personas where apellidos like '%rodriguez suarez%' and nombres like '%dennis%'

select * from pro.etapa_ejecucion_documento where file_name like '%2450401134_30_37_SOLICITUD_CAMBIO_CARRERA.pdf%'

--1105503591




select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Oferta]
    (null,27,114,null) as d

select eo.* from aca.record_oferta ro
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_estudiante_oferta
where numero_matricula_sisweb ='2450070319'


select * from aca.estudiante_oferta where numero_matricula ='2022233300659'

select rd.id_nivel,rd.nivel,rd.id_malla_asignatura,rd.asignatura,rd.id_materia_tomada,rd.valor_malla,rd.promedio,rd.asistencia,rd.estado_tomada,rd.tipo,rd.id_periodo_academico_sw,rd.periodo from aca.record_oferta ro
inner join aca.record_detalle rd on rd.id_record_oferta = ro.id_record_oferta
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_record_oferta
where ro.id_estudiante_oferta = 10628






-- exec [aca].[sp_rpt_record_academico_detalle_estudiante_sga_complete] 10628,1126
exec [aca].[sp_rpt_record_academico_detalle_estudiante_sga_complete] 9092,1265

select rd.id_nivel,rd.id_nivel_sw,rd.nivel,rd.id_materia_tomada,null,rd.id_malla_asignatura,rd.id_materia_plan,rd.id_malla,rd.id_plan,rd.asignatura,rd.valor_malla,
        rd.promedio,rd.asistencia,rd.estado_tomada,rd.tipo,rd.aprobado,rd.observacion,rd.periodo,rd.id_periodo_academico,rd.id_periodo_academico_sw,rd.orden from aca.record_oferta ro
        inner join aca.record_detalle rd on rd.id_record_oferta = ro.id_record_oferta
        inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_record_oferta
        where ro.id_estudiante_oferta = 9092 and rd.estado='A' and rd.id_periodo_academico_sw <= 28152




exec [aca].[sp_rpt_record_academico_detalle_estudiante_sga_complete] 7770,188

select * from [aca].[fn_get_record_estudiante_movilidad_interna](11320,195,14)

select * from [aca].[fn_get_record_estudiante_movilidad_interna](10250,1085,23)

exec [aca].[sp_rpt_record_academico_detalle_estudiante_sga_complete] 10250,1085

select * from [aca].[fn_record_academico_sga_definitivo](10250, null, null, null)

select rd.id_nivel,rd.id_nivel_sw,rd.nivel,rd.id_materia_tomada,null,rd.id_malla_asignatura,rd.id_materia_plan,rd.id_malla,rd.id_plan,rd.asignatura,rd.valor_malla,
        rd.promedio,rd.asistencia,rd.estado_tomada,rd.tipo,rd.aprobado,rd.observacion,rd.periodo,rd.id_periodo_academico,rd.id_periodo_academico_sw,rd.orden from aca.record_oferta ro
        inner join aca.record_detalle rd on rd.id_record_oferta = ro.id_record_oferta
        inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_record_oferta
        where ro.id_estudiante_oferta = 10250 and rd.estado='A' and rd.id_periodo_academico_sw <= 28152



select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Oferta]
    (null,23,null,null) as d

select * from [pro].fn_list_revision_asignatura_by_persona_responsable (1491,null)

select * from pro.etapa_ejecucion_documento

select ma.*,aa.id_asignatura_aprendizaje from aca.malla m
         inner join aca.malla_asignatura ma on ma.id_malla = m.id_malla
            inner join aca.asignatura_aprendizaje aa on aa.id_malla_asignatura = ma.id_malla_asignatura
         where m.id_malla = 20 and aa.id_componente_aprendizaje = 2

select* from tes.rubro


select top 1 * from aca.estudiante_matricula
order by fecha_ing desc

-- exec [aca].[sp_generate_datamart_sisweb] 1,1



select * from [pro].[fn_list_revision_asignatura_by_responsable_reporte](502)



--         {MD5}ffd72e7770d0f47a28694a01d3604edc
-- {bcrypt}$2a$10$175o.8dwnb1Wyz6pkhzc8unB5ENECLjU8zbmf..pmaq8qabaByRF.
select * from seg.usuarios where usuario='0301308755'

select Bd_Academico.dbo.fn_Md5('0301308755')

select * from aca.malla

select * from aca.oferta


SELECT * FROM ACA.campus
exec [aca].[solicitudCambioCarrera] 8735,20

exec [aca].[pro_guardar_excel_de_estudiantes_en_dbo.estudiantes_matriz_excel]

select * from aca.estudiante_matricula
--2984
--56
--4
select * from dbo.estudiantes_matriz_excel em1 where em1.nota =0


--docentes que tiene reegistros como si fuesen estudiantes
select * from dbo.estudiantes_matriz_excel em1 where em1.cedula not in (
    select em.cedula from dbo.estudiantes_matriz_excel em
    inner join man.personas p on p.identificacion = em.cedula
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    where tee.codigo in ('ACT','EGR','GRA')
)

--docentes que tiene reegistros como si fuesen estudiantes
select eo.id_estudiante_oferta,em.id, cedula, em.apellidos, em.nombre, em.asignatura, em.periodoAcademico, em.nota from dbo.estudiantes_matriz_excel em
inner join man.personas p on p.identificacion = em.cedula
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
where tee.codigo in ('ACT','EGR','GRA') and em.nota>0


--los 56 registros de las personas que tiene repetidos
select eo.id_estudiante_oferta,tee.codigo,tee.descripcion,o.descripcion,em.id, cedula, em.apellidos, em.nombre, em.asignatura, em.periodoAcademico, em.nota
from dbo.estudiantes_matriz_excel em
inner join man.personas p on p.identificacion = em.cedula
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
where p.estado='AC' and em.nota>0 and p.identificacion  in (

select em.cedula
     --,count(eo.id_estudiante_oferta) as cantidad
from dbo.estudiantes_matriz_excel em
inner join man.personas p on p.identificacion = em.cedula
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
where tee.codigo in ('ACT','EGR','GRA') and o.id_tipo_oferta = 2 and eo.estado='A' and p.estado='AC'
and em.nota >0
group by em.cedula
having count(eo.id_estudiante_oferta) >1)
order by p.identificacion


--los docentes que si estan en el sistema
select p.identificacion,p.nombres,p.apellidos,eo.* from man.personas p
left join aca.estudiante_oferta eo on eo.id_persona = p.id
where p.identificacion in (select em1.cedula from dbo.estudiantes_matriz_excel em1 where em1.cedula not in (
    select em.cedula from dbo.estudiantes_matriz_excel em
    inner join man.personas p on p.identificacion = em.cedula
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    where tee.codigo in ('ACT','EGR','GRA')
)
)

select * from [aca].[fn_record_academico_sga_definitivo](23338,null,null,null)



exec bd_sga_upse.aca.[sp_recordweb_materias] 41,'12017310351','2450111220'

exec [bd_sga_upse].[aca].[Sp_Record_Registro_Estudiantes] 1, '2450111220'

exec bd_sga_upse.aca.[sp_recordweb_materias] 53,'12016420399','0929011252'

exec [bd_sga_upse].[aca].[Sp_Record_Registro_Estudiantes] 1, '0929011252'

select om.id_oferta_modalidad,o.descripcion from aca.oferta_modalidad om
inner join aca.oferta o on o.id_oferta = om.id_oferta
order by om.id_oferta_modalidad,o.descripcion
 select * from  migracion_sga.[dbo].[registros_migracion] rm
 where id_entidad_relacion = 4

select * from man.personas where apellidos like '%Matute Portilla%'

select * from cmo.postulacion_vacante where id_persona = 33911


select * from cmo.vacante where id_vacante = 92


select o.descripcion,eo.*,p.apellidos,p.nombres from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
            inner join aca.oferta o on o.id_oferta = om.id_oferta
where p.identificacion ='2450111220'

select * from [pro].[fn_proceso_postulante](8)

select * from pro.etapa_requisito


select * from [aca].[fn_record_academico_sga_definitivo](9632,null,null,null)

select dc.descripcion,dh.* from aca.docente_historial dh
inner join aca.docente_categoria dc on dc.id_docente_categoria = dh.id_docente_categoria
where dh.estado='A' and dc.id_docente_categoria in (9)

select * from aca.docente_categoria

select * from aca.dedicacion_horas_clase

select dc.descripcion,dh.* from aca.dedicacion_horas_clase dh
inner join aca.docente_categoria dc on dc.id_docente_categoria = dh.id_docente_categoria
where dh.estado='A' and dc.id_docente_categoria in (9)

---consultas para docente titular
select distinct pg.*
from  pro.proceso pro
inner join pro.proceso_general pg on pg.id_proceso = pro.id_proceso
inner join pro.proceso_usuario pu on pu.id_proceso_general=pg.id_proceso_general
inner join pro.tipo_proceso_estado ep on ep.id_tipo_proceso_estado = pu.id_tipo_proceso_estado
inner join pro.proceso_etapa pe on pe.id_proceso = pro.id_proceso
inner join pro.tipo_proceso tp on (tp.id_tipo_proceso=pro.id_tipo_proceso)
where pu.estado = 'A' and tp.codigo='SOLICITUDESCAMBIOCARRERA'
-- order by pu.id_proceso_usuario

--     62
select * from pro.solicitud_cambio_carrera where id_proceso_usuario = 1010
select * from pro.fn_list_proceso_solicitud_cambio_by_estudiante_resume(30048,'SOLICITUDESCAMBIOCARRERA')
select * from pro.solicitud_cambio_carrera scc

select p.id_proceso as id from pro.Proceso p
INNER JOIN pro.Proceso_Etapa pe on pe.id_Proceso=p.id_proceso
INNER JOIN pro.Etapa e on e.id_etapa=pe.id_etapa
inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
inner join pro.proceso_general pg on pg.id_proceso_general = pc.id_proceso_general and pg.id_proceso=p.id_proceso
INNER JOIN cmo.Vacante v on v.id_concurso=p.id_proceso
where p.id_proceso = 8 and e.codigo = 'REVISION' and cast(GETDATE() as date) BETWEEN pc.fecha_desde and pc.fecha_hasta


select distinct pe.id_proceso_etapa,er.*
from  pro.proceso pro
          inner join pro.proceso_general pg on pg.id_proceso = pro.id_proceso
          inner join pro.proceso_usuario pu on pu.id_proceso_general=pg.id_proceso_general
          inner join pro.tipo_proceso_estado ep on ep.id_tipo_proceso_estado = pu.id_tipo_proceso_estado
          inner join pro.proceso_etapa pe on pe.id_proceso = pro.id_proceso
          inner join pro.tipo_proceso tp on (tp.id_tipo_proceso=pro.id_tipo_proceso)
        inner join pro.proceso_calendario pc on pe.id_proceso_etapa = pc.id_proceso_etapa and pc.id_proceso_general = pg.id_proceso_general
inner join pro.etapa_requisito er on pc.id_proceso_calendario = er.id_proceso_calendario
where pu.estado = 'A' and tp.codigo='SOLICITUDESCAMBIOCARRERA' and pe.id_proceso_etapa = 9 and pg.id_proceso_general =62
-- order by pu.id_proceso_usuario

select distinct er.*
from  pro.proceso pro
          inner join pro.proceso_general pg on pg.id_proceso = pro.id_proceso
          inner join pro.proceso_usuario pu on pu.id_proceso_general=pg.id_proceso_general
          inner join pro.tipo_proceso_estado ep on ep.id_tipo_proceso_estado = pu.id_tipo_proceso_estado
          inner join pro.proceso_etapa pe on pe.id_proceso = pro.id_proceso
          inner join pro.tipo_proceso tp on (tp.id_tipo_proceso=pro.id_tipo_proceso)
          inner join pro.proceso_calendario pc on pe.id_proceso_etapa = pc.id_proceso_etapa and pc.id_proceso_general = pg.id_proceso_general
          inner join pro.etapa_requisito er on pc.id_proceso_calendario = er.id_proceso_calendario
where pu.estado = 'A' and tp.codigo='SOLICITUDESCAMBIOCARRERA' and pe.id_proceso_etapa = 9 and pg.id_proceso_general =62

select distinct pe.id_proceso_etapa,pc.*
from  pro.proceso pro
          inner join pro.proceso_general pg on pg.id_proceso = pro.id_proceso
          inner join pro.proceso_usuario pu on pu.id_proceso_general=pg.id_proceso_general
          inner join pro.tipo_proceso_estado ep on ep.id_tipo_proceso_estado = pu.id_tipo_proceso_estado
          inner join pro.proceso_etapa pe on pe.id_proceso = pro.id_proceso
          inner join pro.tipo_proceso tp on (tp.id_tipo_proceso=pro.id_tipo_proceso)
          inner join pro.proceso_calendario pc on pe.id_proceso_etapa = pc.id_proceso_etapa and pc.id_proceso_general = pg.id_proceso_general
where pu.estado = 'A' and tp.codigo='SOLICITUDESCAMBIOCARRERA' and pe.id_proceso_etapa = 9 and pg.id_proceso_general =75

select pe.id_proceso_etapa from pro.proceso_etapa pe
                                    inner join pro.proceso p on pe.id_proceso = p.id_proceso
                                    inner join pro.proceso_general pg on p.id_proceso = pg.id_proceso
where pe.orden =2 and pg.id_proceso_general=75

select * from pro.fn_list_documentos_to_validate_etapa  (30048,8)

select * from pro.proceso_calendario

select * from pro.tipo_proceso

-- DBCC CHECKIDENT ('pro.etapa', RESEED, 19);
select * from pro.proceso

select * from man.personas

select * from pro.proceso_usuario2

select * from pro.postulacion_vacante

select * from pro.proceso_vacante

select * from pro.etapa

select p.id_proceso,p.descripcion,e.codigo,e.descripcion as id from pro.Proceso p
INNER JOIN pro.Proceso_Etapa pe on pe.id_Proceso=p.id_proceso
INNER JOIN pro.Etapa e on e.id_etapa=pe.id_etapa

select * from pro.proceso_requisito
select * from pro.etapa_requisito

select* from pro.unidad_tiempo
select * from pro.proceso_etapa
WHERE id_proceso = 9
--1 2 8   1 3 8
select * from pro.proceso_general

select * from seg.roles

select * from aca.periodo_academico
select * from pro.proceso_etapa_rol

select * from pro.tipo_etapa_estado

select * from pro.tipo_proceso_estado

select * from pro.etapa_ejecucion_documento
select * from pro.etapa_ejecucion_requisito
select * from pro.proceso_general_documento



-- DBCC CHECKIDENT ('pro.proceso_calendario', RESEED, 42);
select * from pro.proceso_calendario
where id_proceso_general = 9

-- DBCC CHECKIDENT ('pro.proceso_etapa', RESEED, 37);
select * from pro.proceso_etapa

-- DBCC CHECKIDENT ('pro.etapa', RESEED, 19);
select * from pro.etapa

select e.descripcion,pe.* from pro.proceso_etapa pe
inner join pro.etapa e on e.id_etapa = pe.id_etapa
where id_proceso_etapa in (2,5,15,18,29,32)


--aqui se listra las diferentes cosas que se evaluan de maner general
select * from cmo.evaluacion_postulacion

--tabal que guarad los item que se califican en las diferentes etapas en este caso merito y clase demostrativa
select * from cmo.item_evaluacion

select * from cmo.documentos_postulacion_vacante


select td.descripcion,di.* from cmo.documento_item di
inner join aca.documento_requisito_matricula drm on drm.id_documento_requisito_matricula = di.id_documento_requisito_matricula
inner join aca.documentacion_requisito dr on dr.id_documentacion_requisito = drm.id_documentacion_requisito
inner join aca.tipo_documento td on td.id_tipo_documento = drm.id_tipo_documento

select * from cmo.categoria_evaluacion_postulacion

select * from aca.modalidad_asignatura

select * from aca.modalidad


select * from pro.etapa_ejecucion_documento

select * from pro.proceso_requisito

select * from pro.proceso_etapa_ejecucion

select * from pro.proceso_etapa

select * from sgai.requisito
--guarda los diferentes valores que puede tomar los items de evaluacion
select * from cmo.item_valor

select * from cmo.calificacion

select epo.id_evaluacion_postulacion,epo.descripcion,ce.descripcion,ie.id_item_evaluacion,ie.descripcion,cep.* from cmo.categoria_evaluacion ce
    inner join cmo.categoria_evaluacion_postulacion cep on cep.id_categoria_evaluacion = ce.id_categoria_evaluacion
inner join cmo.item_categoria_evaluacion_postulacion ice on ice.id_categoria_evaluacion_postulacion = cep.id_categoria_evaluacion_postulacion
inner join cmo.item_evaluacion ie on ie.id_item_evaluacion = ice.id_item_evaluacion
inner join cmo.evaluacion_postulacion epo on epo.id_evaluacion_postulacion = cep.id_evaluacion_postulacion
-- where ce.id_categoria_evaluacion = 6

order by ce.descripcion,ie.descripcion

select * from cmo.vacante v
where v.codigo ='DER-1'


select --pro.id_proceso,pro.descripcion,tp.descripcion,pg.id_proceso_general,pg.id_periodo_academico,
        distinct pc.id_proceso_calendario,PE.id_proceso_etapa,e.descripcion,pc.fecha_desde,pc.fecha_hasta from  pro.proceso pro
inner join pro.proceso_etapa pe on pe.id_proceso=pro.id_proceso
inner join pro.proceso_general pg on pro.id_proceso=pg.id_proceso
inner join pro.proceso_calendario pc on pg.id_proceso_general=pc.id_proceso_general and pe.id_proceso_etapa=pc.id_proceso_etapa
inner join pro.etapa e on e.id_etapa = pe.id_etapa
inner join pro.tipo_proceso tp on tp.id_tipo_proceso = pro.id_tipo_proceso
where pg.id_periodo_academico = 95 and pro.id_proceso = 2
select * from pro.proceso_general where id_proceso_general = 37
-- DBCC CHECKIDENT ('pro.tipo_categorias_evaluacion', RESEED, 7);
select * from pro.tipo_categorias_evaluacion

select * from pro.proceso_calendario WHERE id_proceso_general = 37


select * from pro.evaluacion_categoria

select * from aca.docente_categoria

select * from pro.evaluaciones_docente_categoria

select * from pro.proceso_calendario





--
--clasifica los requisitos que se evaluan ya sea documenbtacion o clase demostrativa.
select * from cmo.categoria_evaluacion



select * from pro.evaluacion_requisito

select * from pro.requisito_valor

select * from man.personas where apellidos like '%Vera Vera%' and nombres like '%Veronica%'

select om.id_oferta,a.descripcion,ma.* from aca.malla_asignatura ma
inner join aca.malla m on m.id_malla = ma.id_malla
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = m.id_oferta_modalidad
where om.id_oferta in (38,40) and ma.id_malla_asignatura in (1036,1446,2065)


select * from pro.vacante_asignatura

select * from aca.oferta

select * from pro.proceso_vacante

select * from pro.vacante

select * from [pro].[fn_list_all_facultades_by_process_and_periodo_academico](9,7)

select * from [pro].[fn_list_all_ofertas_by_facultad_and_process](9,7,5)

select * from [pro].[fn_list_all_categorias_docente_by_process_and_etapa](9,null)

declare @pi_id_proceso_general int = 9,@pi_id_oferta int = null,@pi_id_categoria_docente int=7
select v.id_vacante,v.codigo,v.descripcion,v.asignatura,tat.descripcion as titulotercerNivel,tac.descripcion,
v.campo_amplio_conocimiento,v.campo_detallado_conocimiento,v.campo_especifico_conocimiento,v.horas_actividades,v.horas_actividades,
dd.descripcion,pv.remuneracion,pv.numero_plazas, pv.codigo_evaluacion
FROM pro.vacante v
inner join pro.vacante_asignatura va on va.id_vacante = v.id_vacante
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = va.id_malla_asignatura
inner join pro.proceso_vacante pv on pv.id_vacante = v.id_vacante
inner join pro.proceso_general pg on pg.id_proceso_general = pv.id_proceso_general
inner join aca.docente_dedicacion dd on dd.id_docente_dedicacion = v.id_docente_dedicacion
left join aca.titulos_academicos tat on tat.id_titulo_academico = v.id_titulo_academico_tercer
left join aca.titulos_academicos tac on tac.id_titulo_academico = v.id_titulo_academico_cuarto
WHERE  v.estado='A' and va.estado='A' and ma.estado='A' and pv.estado='A' and pg.estado='A' and dd.estado='A' and
 pg.id_proceso_general = @pi_id_proceso_general and (v.id_oferta = @pi_id_oferta or @pi_id_oferta is null)
        and (v.id_docente_categoria = @pi_id_categoria_docente or @pi_id_categoria_docente is null)

select * from [pro].[fn_list_all_vacantes_by_process](9,36,1)

select * from seg.usuarios

select * from aca.matricula_general

select * from aca.tipo_matricula

select * from aca.tipo_matricula_fecha

select ddd.* from aca.distributivo_docente dd
left join aca.distributivo_dedicacion ddd on ddd.id_distributivo_docente = dd.id_distributivo_docente
left join aca.docente_actividad da on da.id_distributivo_docente = dd.id_distributivo_docente
where dd.id_distributivo_docente in (2017,2282)

select o.id_oferta,o.estado,O.descripcion,m.descripcion,om.* from aca.oferta_modalidad om
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.modalidad m on m.id_modalidad = om.id_modalidad
where o.id_tipo_oferta <> 3
order by o.descripcion
-- inner join aca.docente_asignatura_aprend daa on daa.id_as


select * from aca.aspirantes_pregrado
where id_periodo_academico = 23







select * from aca.[fn_listar_docentes_asignaturas](null,91,27)

select * from aca.docente_asignatura_aprend where id_docente_asignatura_aprend = 5583


select * from aca.malla where id_malla = 33


-- 2450036005
-- 5597

select * from man.departamentos

SELECT mma.idNivel, mma.nivel, mma.asignatura, mma.promedio, mma.aprobado, mma.periodo, mma.idMallaAsignatura
FROM [aca].[fn_record_academico_sga_definitivo](1521,null,null,null) as mma

SELECT *
FROM [aca].[fn_record_academico_sga_definitivo](1521,null,null,null) as mma

select m.* from aca.malla_asignatura ma
inner join aca.malla m on m.id_malla = ma.id_malla
where ma.id_malla_asignatura in (1100,
659
)


select * from [pro].[fn_list_documents_consolidado_by_parameters](9,null,27,10)

select count(*) from  [pro].[fn_list_All_Estudiantes_Postulantes_By_Facultad] (null,103,27)

select count(d.idPersona) from  [pro].[fn_list_All_Estudiantes_Postulantes_By_Facultad] (null,103,27) as d




SELECT [aca].[fn_semestre_activo_estudiante] (1521,23)


select * from  [pro].[fn_list_All_Estudiantes_Postulantes_By_Facultad] (5,null,27)

-- sp_cambio_carrera_enviar_consejo_notificar_estudiante

select * from pro.proceso_usuario
select * from [pro].[fn_rpt_list_estudiantes_revision_comision] (31,23)


select * from [pro].[fn_list_documents_consolidado_by_parameters](0,95,27,10)

select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Responsable](11,null,27,96)


select o.id_oferta,o.estado,O.descripcion,m.descripcion,om.* from aca.oferta_modalidad om
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.modalidad m on m.id_modalidad = om.id_modalidad
where o.id_tipo_oferta <> 3
order by o.descripcion

-- DBCC CHECKIDENT ('pro.tipo_categorias_evaluacion', RESEED, 7);
select p.nombres,p.apellidos,d.* from pro.etapa_ejecucion_documento d
inner join man.personas p on p.id = d.id_persona
where d.file_name like 'ACTA_CONSOLIDADA%'
order by d.fecha_ing

select * from [pro].[fn_list_documents_consolidado_by_parameters](null,96,23,10)

select * from pro.proceso_general_documento

select * from aca.tipo_documento

select * from pro.etapa_ejecucion_documento

select * from pro.tipo_proceso_estado

select p.id_proceso,p.descripcion,pe.id_proceso_etapa,e.id_etapa,e.descripcion,pc.id_proceso_calendario,pg.id_proceso_general as id from pro.Proceso p
INNER JOIN pro.Proceso_Etapa pe on pe.id_Proceso=p.id_proceso
INNER JOIN pro.Etapa e on e.id_etapa=pe.id_etapa
inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
inner join pro.proceso_general pg on pg.id_proceso_general = pc.id_proceso_general and pg.id_proceso=p.id_proceso
where p.id_proceso =2 and  e.id_etapa = 10

select * from pro.proceso_requisito

select * from pro.proceso_general

select * from pro.proceso_calendario

select * from aca.malla





select * from aca.malla_asignatura where id_malla_asignatura = 1664

select * from aca.oferta

select * from aca.oferta_modalidad where id_oferta = 28

--por cuestiones operativas las asignaturas con id 79 METODOLOGIA DE INVESTIGACION pasaran a ser 104 METODOLOGÍA DE LA INVESTIGACIÓN


select * from aca.asignatura where descripcion like '%POLÍTICA%'

select * from aca.malla_asignatura where id_asignatura = 104
select * from aca.malla_asignatura where id_asignatura = 79

select * from pro.proceso_requisito


select * from aca.compatibilidad_asignatura
select * from aca.malla_asignatura where id_malla_asignatura = 884
--
select  * from [aca].[fn_get_record_estudiante_movilidad_interna] (23335,1147,23)

select distinct idPlan from [aca].[fn_record_academico_sga_definitivo](23335, null, null, 1) as d






exec aca.sp_rpt_malla_por_carrera_requisito 41

select * from seg.roles


exec  [aca].[sp_generate_migracion_malla_presencial_to_hibrida] 36,6
--     select * from aca.estudiante_oferta eo
--     inner join @ids_malla im on eo.id_oferta_modalidad=im.id_oferta_modalidad and eo.id_malla=im.id_malla
--     inner join [aca].[fn_record_academico_sga_definitivo](eo.id_estudiante_oferta,null,null,1) frasd
--         on frasd.idNivel = im.num_niveles and frasd.idMalla=im.id_malla

-- select * from @ids_malla

select * from [aca].[fn_list__all_ofertas_activas_estudiante](22189)

select --o.descripcion,tee.descripcion,mf.fecha_desde,mf.fecha_hasta,getdate(),
       u.id,eo.*from aca.estudiante_oferta eo
         inner join  man.personas p on p.id = eo.id_persona
         inner join seg.usuarios u on u.persona_id = p.id
        inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
        inner join aca.oferta o on o.id_oferta = om.id_oferta
        inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
        inner join aca.matricula_fecha_nivel mf on mf.id_nivel = eo.id_nivel_proyectado and mf.id_periodo_academico =27
        where  eo.estado='A'  and tee.codigo ='ACT' and o.id_tipo_oferta in (1,2)
and eo.id_oferta_modalidad = 89
and eo.id_persona = 18092


select --pr.id_proceso_requisito,pr.descripcion,
       r.* from aca.requisito_nivel_estudiante r
inner join pro.proceso_requisito pr on pr.id_proceso_requisito = r.id_proceso_requisito
where r.id_nivel = 1 and pr.id_proceso_requisito = 26

select * from aca.fn_requisitos_matricula(24346)

select o.descripcion,pao.* from aca.estudiante_oferta eo
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad=eo.id_oferta_modalidad
    inner join aca.oferta o on o.id_oferta = om.id_oferta
    inner join aca.periodo_academico_oferta pao on pao.id_oferta_modalidad=om.id_oferta_modalidad
    where eo.id_estudiante_oferta= 24346  and pao.estado='A' and om.estado='A' and eo.estado='A' and pao.id_periodo_academico=27

select * from [aca].[fn_recuperar_datos_estudiante_logeado](22189)

select * from [aca].[fn_recuperar_datos_estudiante_matricular](24346)

select * from [aca].[fn_listar_docentes_asignaturas](24346,null,27)


exec aca.pro_cambio_masivo_de_presencial_a_hibrido

select * from aca.fn_record_academico_sga_definitivo (24410,null,null,1)



--4274 ultimo id de detalle movilidad
select top 1 * from aca.detalle_movilidad
order by fecha_ing desc

-- DBCC CHECKIDENT ('aca.detalle_movilidad', RESEED, 4274);

--24396 ultimo id de estudiante_oferta

select top 1 * from aca.estudiante_oferta
order by fecha_ing desc

-- DBCC CHECKIDENT ('aca.estudiante_oferta', RESEED, 24396);

-- delete from aca.estudiante_oferta where id_estudiante_oferta>24396
-- select  id_estudiante_oferta from aca.estudiante_oferta

-- exec [aca].[sp_generate_migracion_malla_presencial_to_hibrida] 1,1

select * from man.personas p where p.identificacion ='2450131848'


select * from man.personas p where --{p.nombres like '%ELVIS OSWALDO%'
p.nombres like '%MENDOZA%'


exec [aca].[sp_rpt_comprobante_matricula_estudiante] null,23501

select * from aca.malla
select * from aca.subtipo_movilidad


--1040 ultimo id de movilidad
select top 3 * from aca.movilidad
order by fecha_ing desc

-- DBCC CHECKIDENT ('aca.movilidad', RESEED, 7838);

select o.descripcion,om.id_modalidad,pao.* from aca.periodo_academico_oferta pao
inner join aca.periodo_academico pa on pa.id_periodo_academico = pao.id_periodo_academico
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
where pa.id_periodo_academico = 27 and pao.estado='A'

select * from [aca].[fn_record_academico_sga_definitivo](17847,NULL,27,NULL)


EXEC   [aca].[pa_generar_asignaturas_a_tomar_siia_sisweb] 8376,27,2,664

EXEC   [aca].[pa_generar_asignaturas_a_tomar_siia_sisweb_PRUEBAS] 8376,27,2,664

select * from aca.estudiante_oferta  where id_estudiante_oferta = 11003


select * from man.personas p where p.identificacion='2400451221'

select * from man.personas p where p.apellidos like '%bravo cunninghan%'

select * from seg.usuarios where persona_id = 467

select ea.* from aca.estudiante_matricula em
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where em.id_estudiante_oferta= 18601 and mg.id_periodo_academico = 27

select * from aca.estudiante_oferta where id_estudiante_oferta = 18601

select * from pro.proceso_usuario2

select
--    o.descripcion,om.id_modalidad,p.apellidos,p.nombres ,
       eo.*
from aca.estudiante_oferta eo
inner join man.personas p on p.id = eo.id_persona
inner join aca.oferta_modalidad om on om.id_oferta_modalidad=eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
-- inner join aca.periodo_academico_oferta pao on pao.id_oferta_modalidad=om.id_oferta_modalidad
where om.estado='A' and eo.estado='A' --and pao.id_periodo_academico=27
and p.identificacion ='2450289653'

SELECT * FROM pro.proceso_requisito
select * from aca.periodo_academico where id_tipo_oferta = 1

select * from mig.record_oferta where identificacion='0929011252'

select * from mig.record_asignaturas where id_record_oferta = 39529

select * from [pro].[fn_list_revision_asignatura_by_responsable_reporte] (22791 )

select * from aca.matricula_rubro where id_estudiante_matricula in (3944,18207,34169)

select * from pro.fn_list_documentos_to_validate_etapa  (?,?)

-- exec aca.sp_generate_datamart_sisweb 20,20
   exec bd_sga_upse.[aca].[Sp_Record_Registro_Estudiantes_complete] 1,'0929011252'

   exec pro.[sp_materias_silabo] '13763'

declare @tempMatriculasEstudiante table (codigo varchar(50),modalidad varchar(100),sistema varchar(50),carrera varchar(500),idCarreraOfertada int,
                                         identificacion varchar(25),estudiante varchar(500),matricula varchar(50))
-- delete from @tempMatriculasEstudiante
INSERT INTO @tempMatriculasEstudiante exec [bd_sga_upse].[aca].[Sp_Record_Registro_Estudiantes_complete] 1,'0929011252'



exec bd_sga_upse.[aca].[sp_recordweb_materias_colum_aprob] 53,'12016420399','0929011252'

select * from aca.record_oferta where identificacion ='0929011252'

select * from aca.record_detalle where id_record_oferta = 12728

select * from aca.malla

       exec  pro.sp_recordweb_materias_silabo 53,'12016420399','0929011252'




-- exec [aca].[sp_generate_datamart_sisweb] 10,10


select om.id_oferta_modalidad,o.* from aca.oferta o
inner join aca.oferta_modalidad om on o.id_oferta = om.id_oferta
where o.estado ='A'

-- exec migracion_sga.[dbo].[SPMigracionMalla]


SELECT * FROM migracion_sga.dbo.entidades_migracion WHERE tabla_destino ='aca.malla'
select * from aca.malla where id_oferta_modalidad = 114

select mp.ID_NIVEL,mp.ID_MATERIA_PLAN,m.NOMBRE,pl.ID_PLAN,pl.ID_CARRERA_OFERTADA from  Bd_Academico..MATERIAS_PLAN mp
inner join Bd_Academico.dbo.PLAN_ESTUDIOS pl on pl.ID_PLAN=mp.ID_PLAN
inner join Bd_Academico.dbo.CARRERAS_LOCALES_MODALIDAD_SISTEMA c on pl.ID_CARRERA_OFERTADA=c.ID_CARRERA_OFERTADA
inner join Bd_Academico..MATERIAS m on m.id_materia = mp.ID_MATERIA
inner join bd_academico..NIVELES n on n.id_nivel = mp.id_nivel
where pl.ID_PLAN=406

select top 5 * from aca.estudiante_matricula
order by fecha_ing desc

--ver manes que hicieron cambio de carrera este semestre y ponerles como retirados
select distinct
    eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.id_periodo_academico,p.identificacion,p.apellidos,p.nombres,o.descripcion,te.descripcion,tee.descripcion,tie.descripcion,eo.mantiene_gratuidad,eo.id_malla
,eos.carrera as carrera_padre,eos.tipo_ingreso_estudiante,eos.estado_carrera,tpe.descripcion,pu.id_proceso_usuario,scc.id_oferta_modalidad_nueva,ofa.carrera
-- --     eo2.*,eo.fecha_desde
--     update eo2 set eo2.id_tipo_estado_estudiante = 2,eo2.fecha_hasta = eo.fecha_desde,eo2.usuario_mod='2400254286',eo2.fecha_mod=eo.fecha_ing
from aca.estudiante_oferta eo
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
inner join pro.solicitud_cambio_carrera scc on eo.id_estudiante_oferta_padre = scc.id_estudiante_oferta
inner join pro.proceso_usuario pu on scc.id_proceso_usuario = pu.id_proceso_usuario
inner join pro.tipo_proceso_estado tpe on pu.id_tipo_proceso_estado = tpe.id_tipo_proceso_estado
inner join pro.proceso_general pg on pu.id_proceso_general = pg.id_proceso_general
inner join aca.estudiantes_ofertas eos on eos.id_estudiante_oferta = eo.id_estudiante_oferta_padre
inner join aca.estudiante_oferta eo2  on eo2.id_estudiante_oferta =  eo.id_estudiante_oferta_padre
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = scc.id_oferta_modalidad_nueva
where
eo.id_periodo_academico = 95 and pg.id_periodo_academico = 95 and eo.estado='A' and pu.estado='A' and pu.id_tipo_proceso_estado = 1
-- and eo2.id_tipo_estado_estudiante = 7

select * from aca.tipo_estado_estudiante

select * from pro.proceso_usuario where id_proceso_usuario=21321

select dm.* from aca.movilidad m
inner join aca.detalle_movilidad dm on dm.id_movilidad = m.id_movilidad
where m.id_estudiante_oferta = 89174
order by dm.id_malla_asignatura

select * from aca.periodo_academico where id_tipo_oferta = 2

exec bd_sga_upse.[aca].[sp_recordweb_materias] 33,'12019151018','2400032849'


SELECT top 1  p.id,p.identificacion,concat(p.apellidos,' ',p.nombres) as nombres,'ESTUDIANTE' as rol,ro.carrera as departamento,
              ro.id_record_oferta  as idNumber , 'aca.estudiante_oferta' as tableName,
              51 as idEvento,null as idIdentificador, 1 as idTipoEstadoAsistencia,null as motivo,null as observacion,1 as validado,iif(id_evento_asistencia is null,'NO INGRESADO','YA INGRESO')
from mig.record_oferta ro
         inner join man.personas p on p.identificacion = ro.identificacion
         left join even.evento_asistencia a on a.id_persona = p.id and a.estado='A' and id_evento=51
where ro.identificacion in ('2400418931') and ro.id_tipo_oferta = 2


 select *from   even.fn_pa_obtener_informacion_de_asistencia_Json('2400418931')

-- 			     as d where identificacion in ('2450084740')

select * from seg.usuarios where usuario='2450932385'
select * from [aca].[fn_listar_docentes_asignaturas](null,20,27) as d
where d.idDocente = 83



select * from aca.componente_aprendizaje
select pc.id_proceso_etapa,pc.id_proceso_calendario,er.* from pro.proceso_calendario pc
inner join pro.proceso_etapa pe on pc.id_proceso_etapa = pe.id_proceso_etapa
left join pro.etapa_requisito er on pc.id_proceso_calendario = er.id_proceso_calendario
where pc.id_proceso_general = 37

select * from pro.etapa_requisito

select * from pro.proceso_general where id_proceso = 2

select daa.* from aca.docente_asignatura_aprend daa
         inner join aca.distributivo_docente dd on dd.id_distributivo_docente = daa.id_distributivo_docente
         where dd.id_docente =83 and daa.estado='I'

select * from aca.distributivo_docente where id_distributivo_docente = 2503

select * from aca.tipo_ingreso_estudiante

select * from aca.tipo_estado_estudiante

select * from aca.estudiante_oferta eo  where eo.id_estudiante_oferta =23338


select * from tes.rubro
--37244

select * from aca.subtipo_movilidad

select d.idProcesoUsuario,d.facultadDestino,d.carreraDestino,d.idEstudianteOfertaAnterior,d.idPersona,
       d.identificacion,d.estudiante,d.idOfertaModalidadNueva
from pro.fn_list_All_Estudiantes_Postulantes_By_Facultad(null,null,36) as d
where identificacion in ('2450258880')

exec [aca].[sp_generate_datamart_sisweb]  1,1

exec [aca].[sp_generate_migracion_malla_presencial_to_hibrida_denifitiva] 95,89,20

select * from aca.ofertas_facultad where id_tipo_oferta = 2

select * from aca.tipo_ingreso_estudiante
--                   TECNOLOGÍAS DE LA INFORMACIÓN - MATRIZ	2400025520	GONZALEZ GONZALEZ ERICK ANDRES
-- TECNOLOGÍAS DE LA INFORMACIÓN - MATRIZ	0927365916	PULLUPAXI MALAVE ALONSO RENE
-- SOFTWARE - MATRIZ	2450003864	COCHEA GONZABAY ANTHONY GERMAN
-- SOFTWARE - MATRIZ	0941260085	GONZALEZ GUIN WILLIAN ALEXANDER
-- SOFTWARE - MATRIZ	2450823097	LAINEZ DOMINGUEZ DIEGO ISAIAS

begin
    declare @id_periodo_academico int = 95
select eo.id_persona, eo.id_estudiante_oferta,om.carrera,p.identificacion,concat(p.apellidos,' ',p.nombres) AS estudiante,om.id_oferta_modalidad,omn.id_oferta_modalidad as id_oferta_modalidad_nueva,
       eo.id_malla,m.id_malla as id_malla_nueva,eo.id_nivel_proyectado
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join rel.malla_relacion mr on mr.id_malla_principal = eo.id_malla and mr.tipo ='REDISEÑOS_2025'
         inner join aca.malla m on m.id_malla = mr.id_malla_secundaria
         inner join aca.ofertas_facultad omn on omn.id_oferta_modalidad = m.id_oferta_modalidad

where eo.estado = 'A' and tee.estado = 'A' AND tee.codigo='ACT' and p.estado = 'AC' and mr.id_periodo_academico = @id_periodo_academico
  and om.tipo_oferta = 'PREGRADO' and eo.id_nivel_proyectado not in (8)
--   and om.id_oferta_modalidad = 80
  and eo.id_estudiante_oferta not in (select d.idEstudianteOferta
--                                              ,d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen,d.identificacion,d.estudiante,d.estadoProceso
                                      from pro.fn_list_All_Estudiantes_Postulantes_By_Oferta(null,@id_periodo_academico,null,null) as d
                                      where d.idOfertaModalidad in (20,97,80,89) and d.estadoProceso not in ('DENEGADO')
                                      group by d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen,d.identificacion,d.estudiante,d.estadoProceso,d.idEstudianteOferta)
group by eo.ID_PERSONA, eo.id_estudiante_oferta,om.carrera, p.identificacion, p.apellidos, p.nombres,
         om.id_oferta_modalidad,omn.id_oferta_modalidad, m.id_malla, eo.id_malla, eo.id_nivel_proyectado
end

exec  [aca].[sp_generate_migracion_malla_presencial_to_hibrida] 36,6

select rd.* from aca.record_detalle rd
inner join aca.record_oferta ro on rd.id_record_oferta = ro.id_record_oferta
where ro.id_estudiante_oferta = 70802

select a.descripcion,ma.* from aca.malla m
         inner join aca.malla_asignatura ma on m.id_malla = ma.id_malla
         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
         where m.id_malla = 21
order by ma.id_nivel

select m.* from aca.malla m
where m.descripcion like '%petroleos%'


select * from dbu.cab_ficha_persona


select m.id_malla,m.tipo_plan,rm.id_origen,rm.id_destino from migracion_sga..registros_migracion rm
                                                                  inner join aca.malla m on m.id_malla = rm.id_destino
where rm.id_entidad_relacion in (4) and rm.id_origen =10515

exec [aca].[sp_generate_datamart_sisweb] 36,1

select * from aca.record_oferta where identificacion ='2400083016'

select * from aca.record_detalle where id_record_oferta = 12731

select * from mig.record_oferta where identificacion ='2400083016'

select * from mig.record_asignaturas where id_record_oferta =56159

select distinct m.* from aca.malla m
inner join aca.malla_asignatura ma  on m.id_malla = ma.id_malla
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where ma.id_malla_asignatura = 364

select distinct a.descripcion,ma.* from aca.malla m
                             inner join aca.malla_asignatura ma  on m.id_malla = ma.id_malla
                             inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where ma.id_malla = 24

select * from [aca].[fn_get_record_estudiante_movilidad_interna](53099,42225,96)

select null,xd.id_malla_asignatura,(SELECT top 1 d.promedio
                                                     FROM aca.fn_record_academico_sga_definitivo(70802, null, null, 1) as d
                                                     where d.idMallaAsignatura = ma.id_malla_asignatura) as promedio
from aca.malla m
         inner join aca.malla_asignatura ma on ma.id_malla =m.id_malla
         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
         left join aca.asignatura_compatibilidad ac on ac.id_malla_asignatura = ma.id_malla_asignatura and ac.tipo='M' and ac.estado='A'
         left join(
    select m1.id_malla,ma1.id_malla_asignatura,a1.id_asignatura,ca.id_asignatura_comp,ca.id_asignatura as id_asig_comp,ma1.id_nivel,a1.descripcion from aca.malla m1
    inner join aca.malla_asignatura ma1 on ma1.id_malla = m1.id_malla
    inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
    left join aca.compatibilidad_asignatura ca on ( ca.id_asignatura_comp = a1.id_asignatura or ca.id_asignatura = a1.id_asignatura ) and ca.estado='A'
    where ma1.estado='A' and a1.estado='A' and m1.estado in ('A','P') and m1.id_malla = 92
) as xd on  (a.id_asignatura = xd.id_asignatura or a.id_asignatura = xd.id_asignatura_comp or a.id_asignatura = xd.id_asig_comp or ac.id_malla_asignatura_comp=xd.id_malla_asignatura)
where m.estado in ('A','P') and ma.estado='A' and a.estado='A' and m.id_malla = 21
  AND xd.id_malla_asignatura is not null
--   and  xd.id_malla_asignatura not in (select dm1.id_malla_asignatura from aca.detalle_movilidad dm1 where dm1.id_movilidad = @id_movilidad_hibrido and dm1.estado='A')
  --esta condicion hace quen no se vuelvan a insertar los mismos registros
  and (SELECT top 1 d.promedio
       FROM aca.fn_record_academico_sga_definitivo(70802, null, null, 1) as d
       where d.idMallaAsignatura = ma.id_malla_asignatura) is not null
order by ma.codigo_malla,ma.id_nivel




select * from aca.detalle_movilidad

select * from aca.movilidad

select d.idProcesoUsuario,d.facultadDestino,d.carreraDestino,d.idEstudianteOfertaAnterior,d.idPersona,
			d.identificacion,d.estudiante,d.idOfertaModalidadNueva
			 from pro.fn_list_All_Estudiantes_Postulantes_By_Facultad(null,95,27)
			     as d where identificacion in ('0928010859','2450319625')

select * from aca.tipo_ingreso_estudiante
exec  [aca].[pa_generar_asignaturas_a_tomar_siia_sisweb] 17784,27,1,664

exec  [aca].[pa_generar_asignaturas_a_tomar_siia_sisweb_pruebas] 17784,27,1,664

select * from [aca].[fn_listar_docentes_asignaturas]( 26314,null,27) as d
where d.orden = 2 and d.idParalelo = 1


select * from aca.estudiante_matricula where id_estudiante_oferta = 17784

select * from aca.estudiante_asignatura where id_estudiante_matricula = 29417 and estado='A'


select * from [aca].[fn_record_academico_sga_definitivo](11836,NULL,null,NULL) as d

select * from [aca].[fn_record_academico_sga_definitivo](31324,NULL,null,NULL)

exec bd_sga_upse.aca.[sp_recordweb_materias] 106,'12021081276','2101016810'

select * from [aca].[fn_record_academico_sga_definitivo](11836,NULL,null,NULL)

exec [bd_sga_upse].[aca].[Sp_Record_Registro_Estudiantes] 1, '2450181637'

exec bd_sga_upse.[aca].[sp_recordweb_materias_colum_aprob] 40,'20221251','2450181637'

exec bd_sga_upse.[aca].[sp_recordweb_materias_colum_aprob] 40,'2022125300824','2450181637'

exec bd_sga_upse.[aca].[sp_recordweb_materias_colum_aprob] 105,'12021060222','2450181637'

exec bd_sga_upse.[aca].[sp_recordweb_materias] 33,'12019151018','2400032849'

exec Bd_Academico.dbo.[sp_recordweb_materias] 33,'12019150924','2450537051'




select * from aca.estudiante_oferta where id_estudiante_oferta = 5065

select * from aca.estudiante_matricula where id_estudiante_oferta = 30019

select * from aca.estudiante_asignatura where id_estudiante_matricula = 33603

select * from aca.matricula_rubro where id_estudiante_matricula = 33603


select * from aca.tipo_estado_estudiante

select * from man.tipo_identificacion

select d.idProcesoUsuario,d.facultadDestino,d.carreraDestino,d.idEstudianteOfertaAnterior,d.idPersona,
			d.identificacion,d.estudiante,d.idOfertaModalidadNueva
			 from pro.fn_list_All_Estudiantes_Postulantes_By_Facultad(null,87,27) as d

select * from pro.proceso_usuario where id_proceso_usuario = 1085

exec  [aca].[pa_generar_asignaturas_a_tomar_siia_sisweb] 18442,27,1,664

exec  [aca].[pa_generar_asignaturas_a_tomar_siia_sisweb_pruebas] 18430,27,1,664




select o.id_oferta,om.id_oferta_modalidad,o.descripcion,om.id_modalidad from aca.oferta_modalidad om
inner join aca.oferta o on o.id_oferta = om.id_oferta
where om.estado='A' and o.estado='A'
  and o.id_tipo_oferta = 2
-- and  om.id_oferta_modalidad = 52
order by o.descripcion


select * from aca.estudiante_oferta where id_estudiante_oferta =24923



select * from aca.movilidad m
where m.id_estudiante_oferta = 24670

select  top 10 * from aca.detalle_movilidad
order by fecha_ing desc


select  top 4 * from pro.etapa_ejecucion_responsable
order by fecha_ing desc


select * from aca.asignatura_compatibilidad

select * from seg.usuarios where persona_id = 1222

select p.identificacion,p.nombres,p.apellidos,d.* from aca.docente d
inner join man.personas p on p.id = d.id_persona
where d.id_docente = 243

select * from [aca].[fn_list_Asignaturas_horarios](27,5,89,
    1,1,null,null)

select * from aca.fn_horario_asignatura (27,1,null,1,null)

select * from aca.matricula_general where id_matricula_general = 9

select * from aca.estudiante_matricula where id_estudiante_oferta = 26657 and id_matricula_general = 9

select * from aca.estudiante_asignatura ea where ea.id_estudiante_matricula = 34618

exec  [aca].[pa_generar_asignaturas_a_tomar_siia_sisweb] 26657,27,1,664

exec  [aca].[pa_generar_asignaturas_a_tomar_siia_sisweb_pruebas] 26657,27,1,664


select * from tes.rubro

select * from aca.estudiante_asignatura where id_estudiante_matricula = 32059

select * from aca.matricula_rubro where id_estudiante_matricula = 34618

select * from [aca].[fn_record_academico_sga_definitivo](5300,NULL,null,NULL)

select * from [aca].[fn_record_academico_sga_definitivo](28148,NULL,null,NULL)


-- exec aca.sp_generate_migracion_malla_presencial_to_hibrida_denifitiva 1,1


select ma.* from aca.malla_asignatura ma
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where ma.id_malla = 92 and ma.id_malla_asignatura = 1960
order by ma.id_nivel

exec aca.sp_distributivo_validacion_docente 225,178

select --m.id_malla,
       ma.id_malla_asignatura,a.id_asignatura,concat(ma.id_nivel,' - ',a.descripcion) as asignaturaPresencial,
      -- xd.id_malla,
       xd.id_malla_asignatura as id_malla_asignatura_hibrida
       ,xd.id_asignatura as id_asignatura_hibrida,
       concat(xd.id_nivel,' - ',xd.descripcion) as asignaturaHibrida
from aca.malla m
inner join aca.malla_asignatura ma on ma.id_malla =m.id_malla
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
-- inner join aca.asignatura_aprendizaje aa on aa.id_malla_asignatura  = ma.id_malla_asignatura
-- inner join aca.estudiante_asignatura ea on ea.id_asignatura_aprendizaje =aa.id_asignatura_aprendizaje
-- inner join aca.estudiante_matricula em on em.id_estudiante_matricula =ea.id_estudiante_matricula
left join aca.asignatura_compatibilidad ac on ac.id_malla_asignatura = ma.id_malla_asignatura and ac.tipo='M' and ac.estado='A'
left join(
    select m1.id_malla,ma1.id_malla_asignatura,a1.id_asignatura,ca.id_asignatura as id_asig_comp,ma1.id_nivel,a1.descripcion from aca.malla m1
    inner join aca.malla_asignatura ma1 on ma1.id_malla = m1.id_malla
    inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
    left join aca.compatibilidad_asignatura ca on ca.id_asignatura_comp = a1.id_asignatura and ca.estado='A'
    where ma1.estado='A' and a1.estado='A' and m1.estado in ('A','P') and m1.id_malla = 92
) as xd on  (a.id_asignatura = xd.id_asignatura or a.id_asignatura = xd.id_asig_comp or ac.id_malla_asignatura_comp=xd.id_malla_asignatura)

where m.estado in ('A','P') and ma.estado='A' and a.estado='A' and m.id_malla = 21
order by ma.codigo_malla,ma.id_nivel

select * from aca.asignatura_compatibilidad


select  --m.id_malla,
       ma1.id_malla_asignatura as id_malla_asignatura_hibrida,a1.id_asignatura as id_asignatura_hibrida,
       concat(ma1.id_nivel,' - ',a1.descripcion) as asignaturaHibrida,ca.id_asignatura,ca.id_asignatura_comp
      -- xd.id_malla,
       ,xd.id_malla_asignatura as id_malla_asignatura_presencial ,xd.id_asignatura as id_asignatura_presencial,
       concat(xd.id_nivel,' - ',xd.descripcion) as asignaturaPresencial
    from aca.malla m1
    inner join aca.malla_asignatura ma1 on ma1.id_malla = m1.id_malla
    inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
    left join aca.compatibilidad_asignatura ca on ca.id_asignatura_comp = a1.id_asignatura and ca.estado='A'
    left join (
         select ma.id_malla_asignatura,ma.id_asignatura,a.descripcion,ma.id_nivel,ac.id_malla_asignatura_comp as id_malla_comp
        from aca.malla m
        inner join aca.malla_asignatura ma on ma.id_malla =m.id_malla
        inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
        left join aca.asignatura_compatibilidad ac on ac.id_malla_asignatura = ma.id_malla_asignatura and ac.tipo='M' and ac.estado='A'
         where m.estado in ('A','P') and ma.estado='A' and a.estado='A' and m.id_malla = 43
    ) as xd on  (xd.id_asignatura = ca.id_asignatura or xd.id_asignatura = a1.id_asignatura   or xd.id_malla_comp=ma1.id_malla_asignatura)
    where ma1.estado='A' and a1.estado='A' and m1.estado in ('A','P') and m1.id_malla = 89
order by ma1.codigo_malla,ma1.id_nivel


select --descripcion,
       v.* from pro.vacante v
inner join aca.oferta o on o.id_oferta = v.id_oferta
           inner join pro.vacante_asignatura va on va.id_vacante = v.id_vacante
where v.id_oferta = 32


select * from pro.vacante_asignatura

select o.descripcion,om.* from aca.oferta o
inner join aca.oferta_modalidad om on om.id_oferta = o.id_oferta
         where id_tipo_oferta = 2

select * from [pro].[fn_list_all_facultades_by_process](27,8)

select * from [pro].[fn_list_all_ofertas_by_facultades_and_process](9,8)

--  DBCC CHECKIDENT ('pro.proceso_usuario2', RESEED, 0);




select * from pro.docente_categoria_evaluacion
select * from man.departamentos



select * from pro.proceso_calendario

select * from pro.proceso_general

select * from pro.proceso

select * from man.informacion_academica_persona where id_persona = 1259

select d.idProcesoUsuario,d.facultadDestino,d.carreraDestino,d.idEstudianteOfertaAnterior,d.idPersona,
			d.identificacion,d.estudiante,d.idOfertaModalidadNueva
			 from pro.fn_list_All_Estudiantes_Postulantes_By_Facultad(null,103,27) as d
		                where d.identificacion	not in   ('0927960120','2450911264','0921224739','2450582206')

select * from aca.requisito_nivel_estudiante

select * from pro.proceso_requisito

select ma.id_malla_asignatura,concat(ma.id_nivel,' - ',a.descripcion) as asig,ar.id_malla_asignatura_relacion,aa.descripcion,
       ar.fecha_ingreso,p.nombres,p.apellidos from aca.malla_asignatura ma
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
inner join aca.asignatura_relacion ar on ar.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.malla_asignatura mar on mar.id_malla_asignatura = ar.id_malla_asignatura_relacion
inner join aca.asignatura aa on aa.id_asignatura = mar.id_asignatura
inner join seg.usuarios u on u.id = ar.usuario_ingreso_id
inner join man.personas p on p.id = u.persona_id
where ma.id_malla = 31 and ma.id_nivel = 5

exec  [aca].[pa_generar_asignaturas_a_tomar_siia_sisweb] 26657,27,1,664

exec  [aca].[pa_generar_asignaturas_a_tomar_siia_sisweb_pruebas] 6869,27,1,664

select * from aca.estudiante_asignatura where id_estudiante_matricula = 8441

--2400459158
--ENFERMERIA - MATRIZ
--BIOLOGIA MARINA - MATRIZ
--ELECTRONICA Y TELECOMUNICACIONES - MATRIZ
--LICENCIATURA EN GESTION Y DESARROLLO TURISTICO - MATRIZ
--ADMINISTRACION DE EMPRESAS - MATRIZ 91
--DERECHO - MATRIZ 103  DERECHO - PLAYAS  104
select o.descripcion,
       pao.* from aca.periodo_academico_oferta pao
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
where pao.id_periodo_academico = 27 and pao.estado='A'
-- and pao.id_oferta_modalidad not in (31,22,30,35)
order by o.descripcion

select * from [aca].[fn_horario_espacio_disp](27,30,3,
    null,1750,1,265)

exec aca.sp_rpt_estudiantes_matriculados_por_asignatura 1970, 27,  1



select eo.id_estudiante_oferta,eo.id_oferta_modalidad,em.id_estudiante_matricula,mg.id_matricula_general,d.nombre,o.descripcion,a.descripcion,p.identificacion,p.apellidos,p.nombres,eo.numero_matricula,
       em.fecha_ing,ea.fecha_ing,ea.fecha_mod,p1.nombres,p1.apellidos,p2.nombres,p2.apellidos
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
inner join man.personas p1 on p1.identificacion = ea.usuario_ing
    inner join man.personas p2 on p2.identificacion = ea.usuario_mod
inner join aca.componente_aprendizaje ca on ca.id_componente_aprendizaje =aa.id_componente_aprendizaje
inner join aca.componente_aprendizaje cap on cap.id_componente_aprendizaje= ca.id_componente_aprendizaje_padre
where  em.estado='A' and ma.estado='A' and o.id_tipo_oferta = 2 and eo.estado ='A' and ea.estado ='A'
and p.identificacion='0923409122' and mg.id_periodo_academico = 27



select * from aca.[fn_listar_docentes_asignaturas](null,89,27) as d

exec aca.sp_rpt_total_matriculados_por_facultades 23

select * from aca.tipo_movilidad




select top 10 * from aca.plan_clase

select top 10 * from aca.contenidos

select top 10 * from aca.asignatura_aprendizaje

select * from aca.contenido_componente_aprendizaje





select ru.* from seg.usuarios u
inner join seg.roles_usuarios ru on ru.usuario_id = u.id
inner join seg.roles_usuario_oferta ro on ro.rol_usuario_id = ru.id
where u.usuario = '0916480932'

select ro.* from seg.usuarios u
inner join seg.roles_usuarios ru on ru.usuario_id = u.id
inner join seg.roles_usuario_oferta ro on ro.rol_usuario_id = ru.id
where u.usuario = '0916480932'



select * from pro.proceso_usuario2

select * from aca.espacio_fisico
where id_tipo_espacio_fisico = 4

      select * from aca.tipo_espacio_fisico

select * from aca.tipo_matricula_fecha

select * from pro.proceso_usuario2 where usuario_ing ='1713145538'


select * from pro.proceso_calendario


select * from seg.roles

select d.nombre,concat(o.descripcion,' - ',mo.descripcion) as carrera,concat(ma.id_nivel,' - ',a.descripcion) as asig,ar.id_malla_asignatura_relacion,concat(mar.id_nivel,' - ',aa.descripcion)  as secuencia
--        ,ar.fecha_ingreso,p.nombres,p.apellidos
from aca.malla_asignatura ma
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
inner join aca.asignatura_relacion ar on ar.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.malla_asignatura mar on mar.id_malla_asignatura = ar.id_malla_asignatura_relacion
inner join aca.malla m on m.id_malla = ma.id_malla
inner join aca.oferta_modalidad om on om.id_oferta_modalidad =m.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.modalidad mo on mo.id_modalidad = om.id_modalidad
inner join aca.asignatura aa on aa.id_asignatura = mar.id_asignatura
inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
inner join man.departamentos d on d.id = do.id_departamento
inner join aca.periodo_academico_oferta pao on pao.id_oferta_modalidad = om.id_oferta_modalidad
-- inner join seg.usuarios u on u.id = ar.usuario_ingreso_id
-- inner join man.personas p on p.id = u.persona_id
where ar.estado='A' and ma.estado='A' and a.estado='A' and mar.estado='A' and aa.estado='A' and o.id_tipo_oferta =2
and pao.id_periodo_academico = 27 and pao.estado='A'
order by d.nombre,o.descripcion,ma.id_nivel


select distinct --o.descripcion,eo.id_estudiante_oferta,eo.id_oferta_modalidad,em.id_estudiante_matricula,
                d.nombre,o.descripcion,p.identificacion,p.apellidos,p.nombres,
                eo.numero_matricula,a.descripcion as asignatura,ea.promedio
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
inner join aca.periodo_academico_oferta pao on pao.id_oferta_modalidad = om.id_oferta_modalidad and mg.id_periodo_academico = pao.id_periodo_academico
where ea.estado ='A' and em.estado='A' and ma.estado='A' and eo.estado ='A' and pao.estado='A' and mg.id_periodo_academico = 23
and ea.promedio<70
order by d.nombre,o.descripcion,p.apellidos,p.nombres

select  d.nombre,o.descripcion,p.identificacion,p.apellidos,p.nombres,eo.numero_matricula,aux.nombreAsignatura
from TEMP_asignaturas_en_matricula_no_licita_2 aux
inner join man.personas p on p.id = aux.idPersona
inner join aca.estudiante_oferta eo on eo.id_persona = p.id and eo.id_estudiante_oferta = aux.idEstudianteOferta
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
inner join man.departamentos d on d.id= do.id_departamento
where aux.estadoEstAsig ='A'


select pe.identificacion,pe.apellidos,pe.nombres from pro.proceso_usuario2 p
       inner join man.personas pe on pe.identificacion = p.usuario_ing
         where id_proceso_usuario in (150,291,353,288,414,323)

select * from pro.proceso_usuario where usuario_ing='2450700980'

select * from pro.tipo_proceso_estado



select --a.descripcion,ma.id_malla_asignatura,
       ec.* from aca.acta_calificacion ac
inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = ac.id_malla_asignatura
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where ec.id_estudiante_oferta =8263 and ma.id_malla_asignatura = 305

select * from aca.componente_aprendizaje


select * from dbo.persona_nivelacion
--------------------------------------------

select * from pro.tipo_proceso_estado


select distinct pu.* from pro.proceso_usuario pu
left join pro.proceso_etapa_ejecucion pej on pu.id_proceso_usuario = pej.id_proceso_usuario
left join pro.etapa_ejecucion_responsable eer on pej.id_proceso_etapa_ejecucion = eer.id_proceso_etapa_ejecucion
left join pro.etapa_ejecucion_documento ejd on pej.id_proceso_etapa_ejecucion = ejd.id_proceso_etapa_ejecucion
where pu.usuario_ing='2400255440' and
    pu.estado='A' and pej.estado='A' and eer.estado='A'

select * from [aca].[fn_get_record_estudiante_movilidad_interna](45259,5381,30)
--elimiar solicitudes repetidas
select eer.id_proceso_etapa_ejecucion,id_persona,count(eer.id_etapa_ejecucion_responsable) from pro.etapa_ejecucion_responsable eer
where eer.estado='A'
group by eer.id_proceso_etapa_ejecucion, id_persona
having count(eer.id_etapa_ejecucion_responsable)>1

select * from pro.solicitud_cambio_carrera sc
where id_proceso_usuario  in (30048,30049,30050)

select * from pro.proceso_etapa_ejecucion sc
where id_proceso_usuario  in (30048,30049,30050)

select eer.* from pro.proceso_etapa_ejecucion sc
inner join pro.etapa_ejecucion_responsable eer on sc.id_proceso_etapa_ejecucion = eer.id_proceso_etapa_ejecucion
where sc.id_proceso_usuario  in (30048,30049,30050)

select ejd.* from pro.proceso_etapa_ejecucion sc
                      inner join pro.etapa_ejecucion_responsable eer on sc.id_proceso_etapa_ejecucion = eer.id_proceso_etapa_ejecucion
             inner join pro.etapa_ejecucion_documento ejd on sc.id_proceso_etapa_ejecucion = ejd.id_proceso_etapa_ejecucion
where sc.id_proceso_usuario  in (30048,30049,30050)

select eer2.* from pro.proceso_etapa_ejecucion sc
                      inner join pro.etapa_ejecucion_responsable eer on sc.id_proceso_etapa_ejecucion = eer.id_proceso_etapa_ejecucion
                      inner join pro.etapa_ejecucion_requisito eer2 on eer2.id_proceso_etapa_ejecucion = eer.id_proceso_etapa_ejecucion
where sc.id_proceso_usuario  in (30048,30049,30050)



select * from pro.etapa_ejecucion_responsable where id_etapa_ejecucion_responsable in (6380,6381,6382,6383)

select * from pro.revision_asignaturas where id_revision_asignatura in (2096,2100,2098,2102)

select * from pro.revision_asignaturas where id_etapa_ejecucion_responsable in (6377)

select * from aca.malla

exec [aca].[sp_list_all_carreras_records]  '0928278654' ,null, null, null, null
exec [aca].[sp_list_all_carreras_records]  '0928278654' ,null, null, null, null

select * from [aca].[fn_get_record_estudiante_movilidad_interna](64529,5381,30)

select * from aca.subtipo_movilidad

select * from aca.tipo_movilidad

select d.idProcesoUsuario,d.facultadDestino,d.carreraDestino,d.idEstudianteOfertaAnterior,d.idPersona,
       d.identificacion,d.estudiante,d.idOfertaModalidadNueva
from pro.fn_list_All_Estudiantes_Postulantes_By_Facultad(null,null,96) as d
-- where identificacion in ('0926675505')

select *from aca.subtipo_movilidad


select distinct --o.descripcion,p.apellidos,p.nombres,ma.id_malla_asignatura,a.descripcion,dm.calificacion,dm.estado,
    p.* from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.movilidad m on m.id_estudiante_oferta = eo.id_estudiante_oferta
inner join aca.detalle_movilidad dm on m.id_movilidad = dm.id_movilidad
inner join aca.malla_asignatura ma on dm.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where --eo.id_estudiante_oferta = 78917}
p.identificacion in ('0928092444')

select * from aca.tipo_estado_estudiante


select  distinct dm.* from aca.detalle_movilidad dm
inner join aca.movilidad m on dm.id_movilidad = m.id_movilidad
where m.id_estudiante_oferta = 11763 and dm.estado='A'

select * from aca.periodo_academico where id_tipo_oferta = 4
begin
    declare @id_periodo_academico int=30
    select --ea.id_estudiante_asignatura,ea.id_asignatura_aprendizaje,ea.id_paralelo,ea.estado
--         a.descripcion,ma.id_malla_asignatura,
        ea.*
    --     distinct d.nombre,o.descripcion,p.identificacion,p.apellidos,p.nombres,eo.numero_matricula,ma.id_malla_asignatura,ea.id_estudiante_asignatura,a.descripcion,
-- case when ea.estado  is null then 'NO MATRICULADO' when ea.estado='X' then 'ANULADA' when ea.estado='A' then 'ACTIVA' else ea.estado  end as estadoMat,
-- em.fecha_ing as fechaMatricula,em.fecha_mod as fechaModMatricula,
-- concat(pu.nombres,' ',pu.apellidos) as usuarioCreaMatricula,
-- concat(pu2.nombres,' ',pu2.apellidos) as usuarioModificomatricula
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
             inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
             inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
             inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
             inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
             inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
             inner join aca.oferta o on o.id_oferta = om.id_oferta
             inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
             inner join man.departamentos d on d.id= do.id_departamento
             left join seg.usuarios u on u.usuario = ea.usuario_ing
             left join man.personas pu on pu.id = u.persona_id
             left join seg.usuarios u2 on u2.usuario = ea.usuario_mod
             left join man.personas pu2 on pu2.id = u2.persona_id
    where
        o.id_tipo_oferta = 2 and mg.id_periodo_academico = @id_periodo_academico and
--         p.identificacion ='0926675505' and
        eo.id_estudiante_oferta= 27759 and ma.id_malla_asignatura= 2073
--    and ma.id_malla_asignatura= 953
--    and em.estado = 'A'
--       and em.estado='A'
    order by d.nombre,p.apellidos
end


select d.identificacion, count(d.idSolicitudCambioCarrera)
from pro.fn_list_All_Estudiantes_Postulantes_By_Oferta (null,96,null,null) as d
group by d.identificacion
-- having count(d.idSolicitudCambioCarrera)>1

select d.*
from pro.fn_list_All_Estudiantes_Postulantes_By_Oferta (null,136,null,null) as d
--     inner join pro.solicitud_cambio_carrera scc on scc.id_solicitud_cambio_carrera = d.idSolicitudCambioCarrera
-- where d.identificacion in ('2450914649')
select * from seg.usuarios where usuario='0913042339'

select * from pro.proceso_usuario where id_proceso_usuario = 1235

select * from pro.tipo_proceso_estado

select * from aca.periodo_academico

select d.*
from pro.fn_list_All_Estudiantes_Postulantes_By_Oferta (null,95,null,null) as d


select * from pro.solicitud_cambio_carrera
 where id_solicitud_cambio_carrera = 1518

exec [aca].[sp_list_all_carreras_records]  '2450417924' ,null, null, null, null

select * from aca.estudiante_oferta where id_estudiante_oferta = 67815
select * from pro.solicitud_cambio_carrera where id_proceso_usuario in (21163)


select * from pro.proceso_usuario where id_proceso_usuario in (11760)

select pee.* from pro.proceso_usuario pu
inner join pro.proceso_etapa_ejecucion pee on pu.id_proceso_usuario = pee.id_proceso_usuario
where pu.id_proceso_usuario in (21163)

-- select eer.* from pro.proceso_usuario pu
--                       inner join pro.proceso_etapa_ejecucion pee on pu.id_proceso_usuario = pee.id_proceso_usuario
--                       inner join pro.etapa_ejecucion_responsable eer on pee.id_proceso_etapa_ejecucion = eer.id_proceso_etapa_ejecucion
-- where pee.id_proceso_etapa_ejecucion in (21163)

select eer.* from pro.proceso_usuario pu
inner join pro.proceso_etapa_ejecucion pee on pu.id_proceso_usuario = pee.id_proceso_usuario
inner join pro.etapa_ejecucion_responsable eer on pee.id_proceso_etapa_ejecucion = eer.id_proceso_etapa_ejecucion
where pu.id_proceso_usuario in (21163)

select eer.* from pro.proceso_usuario pu
inner join pro.proceso_etapa_ejecucion pee on pu.id_proceso_usuario = pee.id_proceso_usuario
inner join pro.etapa_ejecucion_responsable eer on pee.id_proceso_etapa_ejecucion = eer.id_proceso_etapa_ejecucion
where pu.id_proceso_usuario in (21163)

select * from pro.revision_asignaturas where id_etapa_ejecucion_responsable = 13155

select eer.* from pro.proceso_usuario pu
inner join pro.proceso_etapa_ejecucion pee on pu.id_proceso_usuario = pee.id_proceso_usuario
inner join pro.etapa_ejecucion_requisito eer on pee.id_proceso_etapa_ejecucion = eer.id_proceso_etapa_ejecucion
where pu.id_proceso_usuario in (21163)

select eed.* from pro.proceso_usuario pu
inner join pro.proceso_etapa_ejecucion pee on pu.id_proceso_usuario = pee.id_proceso_usuario
inner join pro.etapa_ejecucion_documento eed on pee.id_proceso_etapa_ejecucion = eed.id_proceso_etapa_ejecucion
where pu.id_proceso_usuario in (21163)

select * from aca.estudiante_oferta where id_malla is null

select o.descripcion,om.* from aca.oferta_modalidad om
inner join aca.oferta o on om.id_oferta = o.id_oferta
where o.id_tipo_oferta =2-- om.id_oferta_modalidad = 114

SELECT rm.* FROM bd_sga_upse.aca.oferta_modalidad om
                                       inner join migracion_sga.dbo.registros_migracion rm on rm.id_destino = om.id_oferta_modalidad
                                       inner join migracion_sga.dbo.entidades_migracion em on em.id = rm.id_entidad_relacion
where em.tabla_destino = 'aca.oferta_modalidad' and rm.id_origen = 54

select * from [aca].[fn_record_academico_sga_definitivo](64530, null, null, null)

exec [aca].[sp_list_all_carreras_records]  '2450717943' ,null, null , null, null

exec [bd_sga_upse].[aca].[Sp_Record_Registro_Estudiantes] 1, '0953390366'

exec bd_sga_upse.aca.[sp_recordweb_materias] 53,'12016420399','0929011252'

EXECUTE Bd_Academico..sp_record_notas_estudiantes_historico 114, '12019050728'

select * from pro.fn_list_All_Estudiantes_Postulantes_By_Facultad(5,null,36) as d

select * from pro.fn_list_proceso_solicitud_cambio_by_estudiante_resume(11664,'SOLICITUDESCAMBIOCARRERA')

select * from [aca].[fn_get_record_estudiante_movilidad_interna](24467,11685,35)

select * from [aca].[fn_get_record_estudiante_movilidad_interna](64529,11763,35)

select * from  [aca].[fn_record_academico_sga_definitivo](64529, null, null, 1) as d

 exec   BD_ACADEMICO.dbo.sp_materias_silabo 27699

exec [pro].[sp_materias_silabo] 27704
exec [pro].[sp_materias_silabo] 27708

select top 1 * from pro.proceso_usuario

select * from pro.tipo_proceso_estado

select * from pro.proceso_etapa_estado

select * from cat.fn_obtener_estados_por_usuario_y_proceso_usuario (?,?,?)

-- DBCC CHECKIDENT ('aca.malla', RESEED, 147);
select * from pro.revision_asignaturas
select * from aca.malla where descripcion like '%petroleo%'

select * from aca.estudiante_oferta where id_estudiante_oferta = 64529

select * from aca.asignatura where descripcion like '%METODOLOGÍA DE LA INVESTIGACIÓN I%'
--     690	MET-INV-I	ASI	METODOLOGÍA DE LA INVESTIGACIÓN I
-- 691	MET-II	ASI	METODOLOGÍA DE LA INVESTIGACIÓN II
--     1490	MET	ASI	METODOLOGIA DE LA INVESTIGACION I
-- 1491	MET	ASI	METODOLOGIA DE LA INVESTIGACION II

-- select --ma.id_malla_asignatura,m.descripcion,a.*
-- ma.* from aca.asignatura a
--          inner join aca.malla_asignatura ma on a.id_asignatura = ma.id_asignatura
--         inner join aca.malla m on ma.id_malla = m.id_malla
-- --          where a.descripcion in ('INGLES V','TRABAJO DE TITULACIÓN I','TRABAJO DE TITULACIÓN II')
--              where a.descripcion in ('INGLES V')
--
-- select a.* from aca.asignatura a
--          where a.descripcion in ('INGLES V','TRABAJO DE TITULACIÓN I','TRABAJO DE TITULACIÓN II')

select * from aca.periodo_malla where id_malla = 148

select * from aca.malla_asignatura ma where ma.id_malla = 148



select * from migracion_sga..registros_migracion rm where rm.id_entidad_relacion = 4


--  planes viejos de petroleos   10530 10787
--  64529 11569
select 64529,rd.id_nivel,rd.id_nivel_sw,rd.nivel,null,rd.id_materia_tomada,rd.id_malla_asignatura,rd.id_materia_plan,rd.id_malla,rd.id_plan,rd.asignatura,rd.valor_malla,
       rd.promedio,rd.asistencia,rd.estado_tomada,rd.tipo,rd.observacion,rd.aprobado,rd.periodo,rd.id_periodo_academico,rd.id_periodo_academico_sw,ma1.codigo_malla,'SISWEB' as origen
from aca.record_oferta ro
inner join aca.record_detalle rd on rd.id_record_oferta = ro.id_record_oferta
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_record_oferta
inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = rd.id_malla_asignatura and ma1.id_malla = rd.id_malla
where ro.id_estudiante_oferta = 64529 and rd.estado='A' --and rd.id_periodo_academico_sw <= 28152
--   and (rd.aprobado = @pi_aprobado or @pi_aprobado is null)
--   and (rd.id_nivel = @pi_id_nivel or @pi_id_nivel is null)
--   and (rd.periodo = @pi_periodo or @pi_periodo is null)
  and rd.id_malla_asignatura not in (select ma.id_malla_asignatura
                                     from aca.estudiante_oferta eo
                                              inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
                                              inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula =  em.id_estudiante_matricula
                                              inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
                                              inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
                                     where em.id_estudiante_oferta in (64529) and eo.estado='A'
                                       and ea.estado='A' and em.estado='A' and ma.estado='A'
-- 		and (ea.aprobado = @pi_aprobado or @pi_aprobado is null)
                                     group by ea.id_estudiante_asignatura,ma.id_malla_asignatura,ea.aprobado,ma.num_horas , ma.num_creditos,ma.codigo_malla,ea.promedio)

select top 5 * from pro.proceso_etapa_ejecucion order by id_proceso_etapa_ejecucion desc

select * from pro.proceso_etapa_ejecucion where id_proceso_etapa_ejecucion in (21390,21391,21717,21842,21843)

select * from pro.revision_asignaturas where id_etapa_ejecucion_responsable in (13355,13357,13356,13358)

select * from pro.revision_asignaturas where revision_asignaturas.id_revision_asignatura in (2595,2597)

select * from pro.proceso_general where id_proceso = 2

--actualizar fecha despacho
-- UPDATE pej1 SET
--     pej1.fecha_hora_despacho =  aux.fechaRevisionDespacho,pej1.id_tipo_etapa_estado= 1
-- FROM bd_sga_upse.pro.proceso_etapa_ejecucion pej1
-- inner join (select  pu.id_proceso_usuario,pe.id_proceso_etapa,pej.id_proceso_etapa_ejecucion,pej.fecha_hora_recepcion,pej.fecha_hora_despacho,
-- max(ra.fecha_mod) as fechaRevisionDespacho
-- from  pro.proceso pro
-- inner join pro.proceso_general pg on pg.id_proceso = pro.id_proceso
-- inner join pro.proceso_usuario pu on pu.id_proceso_general=pg.id_proceso_general
-- inner join pro.proceso_etapa pe on pe.id_proceso = pro.id_proceso
-- inner join pro.etapa e on e.id_etapa = pe.id_etapa
-- inner join pro.tipo_proceso tp on (tp.id_tipo_proceso=pro.id_tipo_proceso)
-- inner join pro.proceso_etapa_ejecucion pej on pej.id_proceso_etapa = pe.id_proceso_etapa and pej.id_proceso_usuario= pu.id_proceso_usuario
-- inner join pro.etapa_ejecucion_responsable eer on eer.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion
-- inner join pro.revision_asignaturas ra on ra.id_etapa_ejecucion_responsable = eer.id_etapa_ejecucion_responsable
-- where tp.codigo='SOLICITUDESCAMBIOCARRERA' and pej.estado='A' and eer.estado='A' and ra.estado='A' and pu.estado='A'
-- and e.codigo='ANALISIS-SILABOS-COMISION'  and pg.id_proceso_general =37 and pu.id_proceso_usuario
-- in (select d.idProcesoUsuario from [pro].[fn_list_All_Estudiantes_Postulantes_By_Facultad](null,null,36) as d)
-- group by pu.id_proceso_usuario,pe.id_proceso_etapa,pej.id_proceso_etapa_ejecucion,
-- pej.fecha_hora_recepcion,pej.fecha_hora_despacho) as aux on aux.id_proceso_etapa_ejecucion = pej1.id_proceso_etapa_ejecucion

select * from pro.etapa_ejecucion_responsable where id_etapa_ejecucion_responsable in (13355,13357,13356,13358)

SELECT OBJECT_NAME(parent_id) as Parent_Object_Name, *
FROM sys.triggers
GO

select * from aca.documentos_cambio_carrera

select * from pro.solicitud_cambio_carrera

select  d.identificacion as identificacion,d.id_persona as idPersona, d.id_user as idUser, d.correo as correo, d.director as cargo
			from pro.fn_director_oferta (38, 'DECANO') as d

-- DBCC CHECKIDENT ('aca.area_conocimiento', RESEED, 41);
GO
select * from pro.proceso_general_documento

-- select * from [pro].[fn_list_documents_consolidado_by_parameters](?,?,?,?)

select * from [pro].[fn_list_documents_consolidado_by_parameters](9,null,36,10)

select * from [pro].[fn_list_documents_consolidado_by_parameters](5,null,36,10) as xd

select * from  [pro].[fn_list_All_Estudiantes_Postulantes_By_Facultad] (5,null,36)

select * from [pro].[fn_list_documents_consolidado_by_parameters](5,null,36,13) as xd

select * from pro.proceso_usuario where id_tipo_proceso_estado is null
select * from pro.proceso_usuario where proceso_usuario.usuario_ing ='0928864826'

select * from aca.area_conocimiento
-- DBCC CHECKIDENT ('pro.proceso_general_documento', RESEED, 79);
select * from pro.proceso_general_documento

select * from pro.proceso_calendario where id_proceso_general =75
select * from pro.proceso_general pg where id_proceso_general =75


select * from aca.tipo_documento

select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 2

select * from aca.asignatura_requisito


select * from aca.relacion_oferta


select * from aca.record_oferta

select * from aca.record_detalle

select * from aca.oferta_modalidad

select * from aca.estudiante_oferta where id_malla is null

select pa.id_periodo_academico,pa.codigo,pa.descripcion from aca.periodo_academico pa where pa.id_tipo_oferta = 4

select  * from pro.fn_get_info_user_process(2337,'DECANO','SOLICITUDESCAMBIOCARRERA',36) as d

select * from seg.usuarios where usuario = '0928864826'

-- exec [pro].[sp_administrar_traking_procesos] 36,5,29,1163,'SOLICITUDESCAMBIOCARRERA','DECANO'

select * from aca.acta_calificacion where id_acta_calificacion = 19384

select * from aca.acta_apertura
select * from aca.componente_aprendizaje
select* from aca.acta_apertura_componente where id_acta_apertura = 2063 and estado='I'

select e.* from pro.proceso_etapa pe
         inner join pro.etapa e on pe.id_etapa = e.id_etapa where id_proceso =2

select * from pro.proceso_general where id_proceso_general = 44

select * from pro.proceso where id_proceso = 23

select pe.id_proceso,e.descripcion,pee.* from pro.proceso_etapa_ejecucion pee
inner join  pro.proceso_etapa pe on pe.id_proceso_etapa =pee.id_proceso_etapa
inner join pro.etapa e on pe.id_etapa = e.id_etapa where id_proceso_usuario is null

select * from pro.proceso_calendario

select * from seg.roles where descripcion like '%SECRETARÍA GENERAL%'
-- http://192.168.40.161
select * from aca.moodle

select * from pro.tipo_proceso_estado

select * from pro.proceso_usuario where usuario_ing='0928864826'

-- update pro.tipo_proceso_estado set descripcion = UPPER(descripcion)

-- https://ava.upse.edu.ec
-- https://eva.upse.edu.ec

--actualizar estados de cada etapa

--actualizar el id_tipo_proceso_estado
-- UPDATE pej1 SET
--     pej1.fecha_hora_despacho =  aux.fechaRevisionDespacho,pej1.id_tipo_etapa_estado= 1
    select pg.id_periodo_academico,pu.id_proceso_usuario,tpeg.id_tipo_proceso_estado,tpeg.codigo,tpeg.descripcion,pe.id_proceso,pe.id_proceso_etapa,pej.id_tipo_proceso_estado,tpe.codigo,tpe.descripcion
FROM  pro.proceso pro
inner join pro.proceso_general pg on pg.id_proceso = pro.id_proceso
inner join pro.proceso_usuario pu on pu.id_proceso_general=pg.id_proceso_general
inner join pro.proceso_etapa pe on pe.id_proceso = pro.id_proceso
inner join pro.etapa e on e.id_etapa = pe.id_etapa
inner join pro.tipo_proceso tp on (tp.id_tipo_proceso=pro.id_tipo_proceso)
inner join pro.proceso_etapa_ejecucion pej on pej.id_proceso_etapa = pe.id_proceso_etapa and pej.id_proceso_usuario= pu.id_proceso_usuario
left join pro.tipo_proceso_estado tpe on tpe.id_tipo_proceso_estado = pej.id_tipo_proceso_estado
left join pro.tipo_proceso_estado tpeg on tpeg.id_tipo_proceso_estado = pu.id_tipo_proceso_estado
where tp.codigo='SOLICITUDESCAMBIOCARRERA' and pej.estado='A' and pu.estado='A' and pe.id_proceso_etapa = 11

select * from pro.fn_list_proceso_solicitud_cambio_by_estudiante_resume(11664,'SOLICITUDESCAMBIOCARRERA')

select * from [aca].[fn_get_record_estudiante_movilidad_interna](24467,11685,35)



select * from [pro].[fn_acta_consolidada_concurso]( 25,null,null ) as d
where d.identificacion =''


select * from pro.proceso_etapa

select * from pro.vacante where estado='I'

select * from pro.proceso

select * from pro.tipo_proceso

select * from pro.proceso_general where proceso_general.id_proceso in (2)

select * from pro.proceso_calendario where id_proceso_general = 91



-- update aca.subtipo_movilidad set descripcion = UPPER(descripcion)

-- DBCC CHECKIDENT ('aca.subtipo_movilidad ', RESEED, 7)

select * from aca.tipo_oferta_movilidad

select * from aca.tipo_ingreso_estudiante



select * from aca.tipo_oferta_ingreso_estudiante

select * from aca.tipo_estado_estudiante

select * from aca.tipo_oferta_estado_estudiante

select * from aca.tipo_oferta


select * from aca.tipo_estudiante

SELECT * FROM aca.tipo_oferta_estudiante

select * from mov.becario


select eo.id_estudiante_oferta,p.identificacion,count(m.id_movilidad) as cantidad from aca.movilidad m
inner join aca.estudiante_oferta eo on m.id_estudiante_oferta = eo.id_estudiante_oferta
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
-- inner join aca.detalle_movilidad dm on m.id_movilidad = dm.id_movilidad
inner join aca.periodo_academico pa on pa.id_periodo_academico = m.id_periodo_academico
where pa.estado='A' and m.estado='A' and o.estado='A' and om.estado='A' and m.estado='A'
and o.id_tipo_oferta = 4 --and dm.estado='A'
group by eo.id_estudiante_oferta, p.identificacion


select distinct eo.id_tipo_estudiante from aca.estudiante_oferta eo
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
where o.estado='A' and om.estado='A' AND
o.id_tipo_oferta = 3

select eo.id_tipo_estudiante,count(eo.id_estudiante_oferta) as cantidad from aca.estudiante_oferta eo
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
where o.id_tipo_oferta = 1 --and dm.estado='A'
group by eo.id_tipo_estudiante

--     update eo set eo.id_tipo_estudiante = 8
select eo.*
from aca.estudiante_oferta eo
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
where o.estado='A' and om.estado='A' AND
o.id_tipo_oferta = 5 and eo.id_tipo_estudiante in (1)

select * from aca.tipo_oferta

select * from man.nacionalidad where id_nacionalidad = 5

-- alter table aca.subtipo_movilidad add   fecha_ing            datetime2(7)         null default current_timestamp,
--                                       fecha_mod            datetime2(7)         null default current_timestamp,
--                                       usuario_ing          varchar(255)         null,
--                                       usuario_mod          varchar(255)         null
-- alter table aca.movilidad add
--     upload_url           varchar(1000),
--     file_name            varchar(255),
--     document_type        varchar(150),
--     document_format      varchar(150)

select * from aca.archivo_categoria

select * from aca.tipo_movilidad


SELECT * FROM ACA.tipo_documento WHERE descripcion like '%Reso%'


select eer.* from pro.proceso_usuario pu
                      inner join pro.proceso_etapa_ejecucion pee on pu.id_proceso_usuario = pee.id_proceso_usuario
                      inner join pro.etapa_ejecucion_responsable eer on pee.id_proceso_etapa_ejecucion = eer.id_proceso_etapa_ejecucion
where pu.id_proceso_usuario in (11681,11659,11782) and eer.id_persona=1166

select * from pro.revision_asignaturas where id_etapa_ejecucion_responsable = 13155

select * from [aca].[fn_get_record_estudiante_movilidad_interna](17791,11660,3535)

select * from pro.revision_asignaturas ra where id_malla_asignatura_origen in (1393,1394,1395,1396, 1397)

select * from pro.revision_asignaturas ra where id_etapa_ejecucion_responsable = 13461

select * from man.opciones where padre_id is null

select * from man.opciones where padre_id = 70

select * from man.personas where apellidos like '%ramos%' and nombres like '%isabel%'

select * from aca.periodo_academico where id_tipo_oferta = 4

-- DBCC CHECKIDENT ('aca.detalle_movilidad ', RESEED, 107404)
select * from aca.movilidad where id_movilidad = 7472

select * from aca.acta_apertura



select top 3 * from aca.detalle_movilidad order by id_detalle_movilidad desc

select * from aca.silabo_malla_asignatura

select * from aca.movilidad

select * from aca.tipo_movilidad

select * from aca.subtipo_movilidad

select
--     o.*
    ofa.facultad,o.descripcion as carrera,p.identificacion,concat(p.apellidos,' ',p.nombres) as nombres,'DIRECTOR' as Cargo,p.email_institucional,p.email_personal, o.correo
from aca.oferta_modalidad om
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad =om.id_oferta_modalidad
inner join aca.periodo_academico_oferta pao on om.id_oferta_modalidad = pao.id_oferta_modalidad and pao.id_periodo_academico=136
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join seg.roles_usuario_oferta ruo on  ruo.oferta_id = o.id_oferta
inner join seg.roles_usuarios ru on ru.id = ruo.rol_usuario_id
inner join seg.roles r on ru.rol_id = r.id
inner join seg.usuarios u on u.id= ru.usuario_id
inner join man.personas p on u.persona_id = p.id
where r.codigo='DIRECTOR' and o.estado='A' and o.id_tipo_oferta = 2 and ruo.estado='AC' and pao.estado='A'
order by ofa.facultad,o.descripcion

select distinct d.nombre as facultad,p.identificacion,concat(p.apellidos,' ',p.nombres) as nombres,'DECANO' as Cargo,p.email_institucional,p.email_personal
from aca.oferta_modalidad om
         inner join aca.periodo_academico_oferta pao on om.id_oferta_modalidad = pao.id_oferta_modalidad and pao.id_periodo_academico=136
         inner join aca.oferta o on o.id_oferta = om.id_oferta
         inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
        inner join man.departamentos d on do.id_departamento = d.id
         inner join seg.roles_usuario_oferta ruo on  ruo.oferta_id = o.id_oferta
         inner join seg.roles_usuarios ru on ru.id = ruo.rol_usuario_id
         inner join seg.roles r on ru.rol_id = r.id
         inner join seg.usuarios u on u.id= ru.usuario_id
         inner join man.personas p on u.persona_id = p.id
where r.codigo='DECANO' and o.estado='A' and o.id_tipo_oferta = 2 and ruo.estado='AC' and pao.estado='A'
order by d.nombre

select * from aca.asignatura_compatibilidad where tipo='REDISEÑO_MALLA'

select * from man.documentos_ubicacion

select * from aca.tipo_movilidad

select * from man.documentos_archivos where id_documento_ubicacion in (14,15,16)

select top 3 * from man.documentos_archivos
order by id_documento_archivo desc

select * from seg.usuarios where usuario='2450697590'


-- DBCC CHECKIDENT ('aca.movilidad', RESEED, 7742)

select * from aca.movilidad where id_periodo_academico is null


select * from aca.detalle_movilidad dm where id_movilidad >= 7741

select * from aca.subtipo_movilidad


select * from aca.acta_apertura

select aac.* from aca.acta_apertura_componente aac
inner join aca.acta_apertura ac on aac.id_acta_apertura = ac.id_acta_apertura
where ac.id_acta_calificacion = 19422



select id_persona, id_estudiante_oferta, carrera, identificacion, estudiante, id_oferta_modalidad,
       id_oferta_modalidad_hibrida, id_malla, id_malla_hibrida from dbo.TEMP_LIST_ESTUDIANTES_OFERTAS
where identificacion='2450432808'

select * from aca.malla where descripcion like '%MALLA DE PEDAGOGIA DE LOS IDIOMAS NACIONALES%'

-- DBCC CHECKIDENT ('pro.proceso_etapa_ejecucion', RESEED, 34595)
select * from pro.proceso_etapa_ejecucion

select * from pro.etapa_ejecucion_responsable where id_etapa_ejecucion_responsable = 13264

select * from aca.asignatura_compatibilidad ac

select * from pro.etapa_ejecucion_responsable where id_etapa_ejecucion_responsable in (20948)

select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta =2

select '2024-2' as periodo,d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen,count(d.identificacion) as postulantes
from pro.fn_list_All_Estudiantes_Postulantes_By_Oferta(null,95,null,null) as d
group by d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen
union all
select '2024-1' as periodo,d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen,count(d.identificacion) as postulantes
from pro.fn_list_All_Estudiantes_Postulantes_By_Oferta(null,35,null,null) as d
group by d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen
union all
select '2023-2' as periodo,d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen,count(d.identificacion) as postulantes
from pro.fn_list_All_Estudiantes_Postulantes_By_Oferta(null,30,null,null) as d
group by d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen
union all
select '2023-1' as periodo,d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen,count(d.identificacion) as postulantes
from pro.fn_list_All_Estudiantes_Postulantes_By_Oferta(null,27,null,null) as d
group by d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen
union all
select '2022-2' as periodo,d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen,count(d.identificacion) as postulantes
from pro.fn_list_All_Estudiantes_Postulantes_By_Oferta(null,23,null,null) as d
group by d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen
union all
select '2022-1' as periodo,d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen,count(d.identificacion) as postulantes
from pro.fn_list_All_Estudiantes_Postulantes_By_Oferta(null,14,null,null) as d
group by d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen

--     0929017085
--     24824
--     HUEBLA TASAMBAY ABRAHAM MISAEL
-- HUEBLA TASAMBAY ABRAHAM MISAEL
-- YAUCAN MOROCHO JESSICA MARIBEL
-- YAUCAN MOROCHO JESSICA MARIBEL

select d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen,d.identificacion,d.estudiante,d.estadoProceso
from pro.fn_list_All_Estudiantes_Postulantes_By_Oferta(null,95,null,null) as d
where d.idOfertaModalidad in (20,97,80,89) and d.estadoProceso not in ('DENEGADO')
group by d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen,d.identificacion,d.estudiante,d.estadoProceso

select * from aca.malla where id_malla in(40,128)

select * from pro.fn_list_All_Estudiantes_Postulantes_By_Oferta(null,136,null,null) as d
-- where d.identificacion in ('0928502301')
-- where d.estudiante like '%WONG%'
-- where  d.identificacion='2450539727'

select  * from pro.proceso_usuario where usuario_ing = '0928502301'

select * from pro.proceso_etapa_ejecucion where id_proceso_usuario = 21222

select * from pro.tipo_proceso_estado

select d.*
from pro.fn_list_All_Estudiantes_Postulantes_By_Oferta (null,136,null,null) as d
where d.identificacion in ('0951889385',
'2450116682',
'1314250083',
'2450241258'
)
--eliminar todo

select * from aca.malla where id_oferta_modalidad = 20

select scc.* from pro.solicitud_cambio_carrera scc
         inner join pro.proceso_usuario pu on scc.id_proceso_usuario = pu.id_proceso_usuario
         Where scc.id_proceso_usuario  in (42525) and pu.usuario_ing='2400398026'

begin
    declare @id_proceso_usuario int = 42190,@estado varchar(1)='I',@usuario_ing varchar(15)='2450927278'
-- select * from pro.solicitud_cambio_carrera Where solicitud_cambio_carrera.id_proceso_usuario in (21355)
update scc set scc.estado=@estado from pro.solicitud_cambio_carrera scc
         inner join pro.proceso_usuario pu on scc.id_proceso_usuario = pu.id_proceso_usuario
         Where scc.id_proceso_usuario not in (@id_proceso_usuario) and pu.usuario_ing=@usuario_ing

-- select * from pro.proceso_usuario where id_proceso_usuario  in (21355)
update  pro.proceso_usuario set estado=@estado where id_proceso_usuario not in (@id_proceso_usuario) and usuario_ing=@usuario_ing

-- select distinct pee.*
update pee set pee.estado=@estado
from pro.etapa_ejecucion_responsable err
         inner join pro.proceso_etapa_ejecucion pee on err.id_proceso_etapa_ejecucion = pee.id_proceso_etapa_ejecucion
         inner join pro.proceso_usuario pu on pee.id_proceso_usuario = pu.id_proceso_usuario
where pee.id_proceso_usuario not in (@id_proceso_usuario) and pu.usuario_ing=@usuario_ing

-- select distinct err.*
update err set err.estado=@estado
from pro.etapa_ejecucion_responsable err
         inner join pro.proceso_etapa_ejecucion pee on err.id_proceso_etapa_ejecucion = pee.id_proceso_etapa_ejecucion
         inner join pro.proceso_usuario pu on pee.id_proceso_usuario = pu.id_proceso_usuario
where pee.id_proceso_usuario not in (@id_proceso_usuario) and pu.usuario_ing=@usuario_ing

-- select distinct ed.*
update ed set ed.estado=@estado
from pro.etapa_ejecucion_responsable err
         inner join pro.proceso_etapa_ejecucion pee on err.id_proceso_etapa_ejecucion = pee.id_proceso_etapa_ejecucion
             inner join pro.proceso_usuario pu on pee.id_proceso_usuario = pu.id_proceso_usuario
inner join pro.etapa_ejecucion_documento ed on pee.id_proceso_etapa_ejecucion = ed.id_proceso_etapa_ejecucion
where pee.id_proceso_usuario  not in (@id_proceso_usuario) and pu.usuario_ing=@usuario_ing

--     select distinct eer.*
    update eer set eer.estado=@estado
    from pro.proceso_etapa_ejecucion pee
                 inner join pro.proceso_usuario pu on pee.id_proceso_usuario = pu.id_proceso_usuario
    inner join pro.etapa_ejecucion_requisito eer on pee.id_proceso_etapa_ejecucion = eer.id_proceso_etapa_ejecucion
    where pee.id_proceso_usuario not in (@id_proceso_usuario) and pu.usuario_ing=@usuario_ing

end


--0929011252
--volver acuas
select * from pro.fn_list_All_Estudiantes_Postulantes_By_Responsable(null,null,95,92) as d
where d.identificacion='0931144596'

select pu.id_proceso_usuario,pe.id_proceso_etapa,pej.id_proceso_etapa_ejecucion as id_proceso_etapa_ejecucion,
       ejr.id_etapa_ejecucion_responsable,isnull(ejr.culminado,0) as culminado,ejr.id_persona as id_persona, ofa.facultad as facultadOrigen, ofa.carrera as carreraOrigen,
       ofad.facultad as facultadDestino,ofad.carrera as carreraDestino,ofa.id_oferta_modalidad,sc.id_oferta_modalidad_nueva,m.id_malla as idMallaDestino,
       p.identificacion,eo.numero_matricula,(p.apellidos+' '+p.nombres) as estudiante, sc.id_solicitud_cambio_carrera, ejd.id_etapa_ejecucion_documento,
       ejd.upload_url,ejd.file_name,pr.identificacion,(pr.apellidos+' '+pr.nombres) as docente,ejr.estado,ra.estado
from  pro.proceso pro
          inner join pro.proceso_general pg on pg.id_proceso = pro.id_proceso
          inner join pro.proceso_usuario pu on pu.id_proceso_general=pg.id_proceso_general
          inner join pro.tipo_proceso_estado ep on ep.id_tipo_proceso_estado = pu.id_tipo_proceso_estado
          inner join pro.proceso_etapa pe on pe.id_proceso = pro.id_proceso
          inner join pro.tipo_proceso tp on tp.id_tipo_proceso=pro.id_tipo_proceso
          inner join man.personas p on p.id=pu.id_persona
          inner join pro.solicitud_cambio_carrera sc on sc.id_proceso_usuario = pu.id_proceso_usuario
          inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta=sc.id_estudiante_oferta
          inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
          inner join aca.malla m on m.id_oferta_modalidad=sc.id_oferta_modalidad_nueva and m.id_malla <>33 and m.fecha_hasta is null
          inner join aca.ofertas_facultad ofad on ofad.id_oferta_modalidad = eo.id_oferta_modalidad
          inner join pro.proceso_etapa_ejecucion pej on pej.id_proceso_etapa = pe.id_proceso_etapa and pu.id_proceso_usuario = pej.id_proceso_usuario
          inner join pro.etapa_ejecucion_responsable ejr on ejr.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion
        inner join pro.revision_asignaturas ra on ejr.id_etapa_ejecucion_responsable = ra.id_etapa_ejecucion_responsable
          inner join man.personas pr on pr.id=ejr.id_persona
          left join pro.etapa_ejecucion_documento ejd on ejd.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion and ejd.id_tipo_documento  is null and ejd.estado='A'
    and ejd.id_persona = ejr.id_persona
where pro.estado='A' and pe.estado='A' and ep.codigo ='A' and tp.estado='A' --and r.estado='AC'
  and pej.estado='A' and ejr.estado='A' and pu.estado='A' and p.estado='AC'
  and sc.estado='A'   and tp.estado='A'and m.estado in ('A','P') and
    tp.codigo='SOLICITUDESCAMBIOCARRERA'
  and pej.id_proceso_etapa=11 and pg.id_periodo_academico = 95 and sc.id_oferta_modalidad_nueva=92 and p.identificacion='0931144596'
group by pu.id_proceso_usuario, pe.id_proceso_etapa, pej.id_proceso_etapa_ejecucion, ejr.id_etapa_ejecucion_responsable, ejr.culminado, ejr.id_persona, ofa.facultad, ofa.carrera,
         ofad.carrera,ofad.facultad, ofa.id_oferta_modalidad, sc.id_oferta_modalidad_nueva, m.id_malla, p.identificacion, eo.numero_matricula, p.apellidos, p.nombres, sc.id_solicitud_cambio_carrera,
         ejd.id_etapa_ejecucion_documento, ejd.upload_url, ejd.file_name,pr.identificacion,pr.apellidos,pr.nombres, ejr.estado, ra.estado
order by ofa.facultad,ofa.carrera

select * from pro.revision_asignaturas where id_revision_asignatura in (6563,6564)

select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Responsable](11,1179,95,null)
select * from [pro].[fn_rpt_list_estudiantes_revision_comision] (103,95)


select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Responsable](null,null,95,33) as d
where d.identificacion='0928141852'

select pu.id_proceso_usuario,pe.id_proceso_etapa,pej.id_proceso_etapa_ejecucion as id_proceso_etapa_ejecucion,
       ejr.id_etapa_ejecucion_responsable,isnull(ejr.culminado,0) as culminado,ejr.id_persona as id_persona, om.facultad as facultadOrigen, om.carrera as carreraOrigen,
       omn.facultad as facultadDestino,omn.carrera as carreraDestino,om.id_oferta_modalidad,sc.id_oferta_modalidad_nueva,m.id_malla as idMallaDestino,
       p.identificacion,eo.numero_matricula,(p.apellidos+' '+p.nombres) as estudiante, sc.id_solicitud_cambio_carrera, ejd.id_etapa_ejecucion_documento,
       ejd.upload_url,ejd.file_name,pr.identificacion,(pr.apellidos+' '+pr.nombres) as docente,ejr.estado,pej.estado,ra.estado
from  pro.proceso pro
          inner join pro.proceso_general pg on pg.id_proceso = pro.id_proceso
          inner join pro.proceso_usuario pu on pu.id_proceso_general=pg.id_proceso_general
          inner join pro.tipo_proceso_estado ep on ep.id_tipo_proceso_estado = pu.id_tipo_proceso_estado
          inner join pro.proceso_etapa pe on pe.id_proceso = pro.id_proceso
          inner join pro.tipo_proceso tp on tp.id_tipo_proceso=pro.id_tipo_proceso
          inner join pro.proceso_etapa_rol per on per.id_proceso_etapa = pe.id_proceso_etapa
          inner join seg.roles r on r.id = per.id_rol
          inner join man.personas p on p.id=pu.id_persona
          inner join pro.solicitud_cambio_carrera sc on sc.id_proceso_usuario = pu.id_proceso_usuario
          inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta=sc.id_estudiante_oferta
          inner join aca.ofertas_facultad om on om.id_oferta_modalidad=eo.id_oferta_modalidad
          inner join aca.malla m on m.id_oferta_modalidad=sc.id_oferta_modalidad_nueva and m.id_malla not in (33,161,162,163,164) and m.fecha_hasta is null
          inner join aca.ofertas_facultad omn on omn.id_oferta_modalidad=sc.id_oferta_modalidad_nueva
          inner join pro.proceso_etapa_ejecucion pej on pej.id_proceso_etapa = pe.id_proceso_etapa and pu.id_proceso_usuario = pej.id_proceso_usuario
          inner join pro.etapa_ejecucion_responsable ejr on ejr.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion
            inner join pro.revision_asignaturas ra on ejr.id_etapa_ejecucion_responsable = ra.id_etapa_ejecucion_responsable
          inner join man.personas pr on pr.id=ejr.id_persona
          left join pro.etapa_ejecucion_documento ejd on ejd.id_proceso_etapa_ejecucion = pej.id_proceso_etapa_ejecucion and ejd.id_tipo_documento  is null and ejd.estado='A'
    and ejd.id_persona = ejr.id_persona
where pro.estado='A' and pe.estado='A' and ep.codigo ='A' and tp.estado='A' and r.estado='AC'
  and pej.estado='A' and ejr.estado='A' and pu.estado='A' and p.estado='AC'
  and sc.estado='A' and tp.estado='A'and m.estado in ('A','P') and --ra.estado='A' and
    tp.codigo='SOLICITUDESCAMBIOCARRERA'
  and pe.id_proceso_etapa=11 and pg.id_periodo_academico = 95
  and (sc.id_oferta_modalidad_nueva=33 or 33 is null)
group by pu.id_proceso_usuario, pe.id_proceso_etapa,
    pej.id_proceso_etapa_ejecucion, ejr.id_etapa_ejecucion_responsable, ejr.culminado,
         ejr.id_persona, om.id_oferta_modalidad, sc.id_oferta_modalidad_nueva, m.id_malla,
         p.identificacion, eo.numero_matricula, p.apellidos, p.nombres, sc.id_solicitud_cambio_carrera,omn.facultad,omn.carrera,
         ejd.id_etapa_ejecucion_documento, ejd.upload_url, ejd.file_name,pr.identificacion,pr.apellidos,pr.nombres, om.facultad, om.carrera, ejr.estado, pej.estado, pej.id_proceso_etapa_ejecucion, ra.estado
order by om.facultad,om.carrera

select distinct eer.*
--               ,(select count(*) from pro.revision_asignaturas rv where rv.estado='I' and rv.id_etapa_ejecucion_responsable=eer.id_etapa_ejecucion_responsable) as eliminadas
--         ,(select count(*) from pro.revision_asignaturas rv where rv.id_etapa_ejecucion_responsable=eer.id_etapa_ejecucion_responsable) as eliminadas
        from pro.etapa_ejecucion_responsable eer
inner join pro.revision_asignaturas ra on eer.id_etapa_ejecucion_responsable = ra.id_etapa_ejecucion_responsable
where eer.estado='A' and ra.estado='I'
    and (select count(*) from pro.revision_asignaturas rv where rv.estado='I' and rv.id_etapa_ejecucion_responsable=eer.id_etapa_ejecucion_responsable)=
        (select count(*) from pro.revision_asignaturas rv where rv.id_etapa_ejecucion_responsable=eer.id_etapa_ejecucion_responsable)


select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Responsable](null,null,95,null) as d

select * from [pro].[fn_list_revision_asignatura_by_responsable_reporte] (22791 )
select * from  pro.revision_asignaturas where id_revision_asignatura = 4427

exec [pro].[sp_migrate_estudiantes_movilidad_to_new_carrera] 136 ,5 ,    '0928502301',null

select * from aca.subtipo_movilidad

select * from aca.tipo_movilidad

select * from pro.tipo_proceso_estado

select * from aca.periodo_academico where id_tipo_oferta = 2 order by codigo desc

-- NO POSEE DENTRO DE SU RECORD ACADEMICO UNA ASIGNATURA QUE SEA OBJETO DE RECONOCIMIENTO DE HORAS Y/ O CRÉDICTOS EN LA CARRERA DE DESTINO.
--manes que si les aprobaron el cambio de carerra unos pocos se matricualron en su carrera original, parece ser que se vana quedar ahi
--208
select em.id_estudiante_matricula,d.* from  [pro].[fn_list_All_Estudiantes_Postulantes_By_Facultad] (null,null,95) as d
inner join pro.proceso_usuario pu on pu.id_proceso_usuario = d.idProcesoUsuario
left join aca.estudiante_matricula em on em.id_estudiante_oferta = d.idEstudianteOfertaAnterior and em.estado='A' and em.id_matricula_general = 31
-- left join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general and mg.id_periodo_academico = 95
where d.labelAprobado='SI'


--manes que se les aprobo haber si ya se les matriculo en la carrera nueva
select em.id_estudiante_matricula,d.* from  [pro].[fn_list_All_Estudiantes_Postulantes_By_Facultad] (null,null,95) as d
inner join pro.proceso_usuario pu on pu.id_proceso_usuario = d.idProcesoUsuario
inner join aca.estudiante_oferta eoh on eoh.id_estudiante_oferta_padre = d.idEstudianteOfertaAnterior
left join aca.estudiante_matricula em on em.id_estudiante_oferta = eoh.id_estudiante_oferta and em.estado='A' and em.id_matricula_general = 31
-- left join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general and mg.id_periodo_academico = 95
where d.labelAprobado='SI'


select * from pro.proceso_usuario where id_proceso_usuario = 21221
select * from aca.matricula_general

select * from pro.tipo_proceso_estado
SELECT * from aca.tipo_matricula_fecha

select eer.* from [pro].[fn_list_All_Estudiantes_Postulantes_By_Responsable](11,null,95,91) as d
inner join pro.etapa_ejecucion_responsable eer on eer.id_etapa_ejecucion_responsable = d.idEtapaEjecucionResponsable


select distinct pu.id_proceso_usuario,pg.id_periodo_academico,tp.descripcion,ep.descripcion
from  pro.proceso pro
          inner join pro.proceso_general pg on pg.id_proceso = pro.id_proceso
          inner join pro.proceso_usuario pu on pu.id_proceso_general=pg.id_proceso_general
          inner join pro.tipo_proceso_estado ep on ep.id_tipo_proceso_estado = pu.id_tipo_proceso_estado
          inner join pro.proceso_etapa pe on pe.id_proceso = pro.id_proceso
          inner join pro.tipo_proceso tp on (tp.id_tipo_proceso=pro.id_tipo_proceso)
where pu.estado = 'A' and tp.codigo='SOLICITUDESCAMBIOCARRERA'
  and pu.usuario_ing ='0927834143'
order by pu.id_proceso_usuario

exec [aca].[sp_list_all_carreras_records]  '0927946855' ,null, null, null, null

SELECT * FROM tmp.matricula_proyeccion WITH (NOLOCK)

exec aca.solicitudCambioCarrera 10971,91,96

select dep.nombre as facultad, o.descripcion as carrera,om.id_oferta_modalidad,asi.id_asignatura,m.id_malla, ma.id_malla_asignatura,ni.id_nivel as semestre, asi.descripcion as asignatura
from aca.malla m
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = m.id_oferta_modalidad
         inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
         inner join man.departamentos dep on dep.id = do.id_departamento
         inner join aca.oferta o on o.id_oferta = do.id_oferta
         inner join aca.malla_asignatura ma on ma.id_malla = m.id_malla
         inner join aca.asignatura asi on ma.id_asignatura = asi.id_asignatura
         inner join aca.nivel ni on ni.id_nivel = ma.id_nivel
         inner join aca.periodo_academico_oferta pao on om.id_oferta_modalidad = pao.id_oferta_modalidad
         left join tmp.matricula_proyeccion mp WITH (NOLOCK) on mp.id_malla_asignatura = ma.id_malla_asignatura and mp.id_periodo_academico = pao.id_periodo_academico
where pao.id_periodo_academico = 95 and m.vigente = 1 --and mp.id is null
--           and om.id_oferta_modalidad = 80
  and ma.id_nivel <= m.id_nivel_max_aperturado
--   and (om.id_oferta_modalidad = @id_oferta_modalidad or @id_oferta_modalidad is null)
--   and (dep.id =@id_facultad or @id_facultad is null)
--   and (ma.id_nivel = @id_nivel or @id_nivel is null)
  and ma.estado in ('A', 'P') and om.estado = 'A' and do.estado = 'A' and o.estado = 'A' and ma.estado = 'A' and asi.estado = 'A' and ni.estado = 'A'
group by asi.id_asignatura, asi.descripcion, ni.descripcion, ni.orden, dep.nombre, o.descripcion,ma.id_malla_asignatura, om.id_oferta_modalidad, ni.id_nivel, m.id_malla
order by dep.nombre, o.descripcion, ni.orden, asi.descripcion

select * from rlx.convocatoria_movilidad
select * from rlx.convocatoria_movilidad_oferta
select * from pro.solicitud_movilidad_externa


select * from pro.proceso_calendario

--new

select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Oferta] (null,23,null,null) as d

select * from [pro].fn_list_revision_asignatura_by_persona_responsable (216,null)

select d.* from [pro].[fn_list_All_Estudiantes_Postulantes_By_Responsable](11,1491,136,null) as d

select pee.id_proceso_etapa_ejecucion,eed.id_persona,count(eed.id_etapa_ejecucion_documento)  as documentos from pro.proceso_etapa_ejecucion pee
inner join pro.proceso_usuario pu on pee.id_proceso_usuario = pu.id_proceso_usuario
inner join pro.proceso_general pg on pu.id_proceso_general = pg.id_proceso_general
inner join pro.etapa_ejecucion_documento eed on pee.id_proceso_etapa_ejecucion = eed.id_proceso_etapa_ejecucion
where eed.id_persona is not null and pg.id_proceso = 2
group by pee.id_proceso_etapa_ejecucion, eed.id_persona
having count(eed.id_etapa_ejecucion_documento)>1


select * from pro.etapa_ejecucion_documento where id_proceso_etapa_ejecucion in (39364,55948,58148,78280,60990,78139,57586,77745,77747,77753,78075,555,557,60399,60474,58104,58132)
and id_persona in (53,461,584,806,1242,1256,1284,1491,1491,1491,1491,9073,11274,18574,33761,56559,56559)
and estado='A'

select * from aca.tipo_documento

select * from [pro].[fn_rpt_list_estudiantes_revision_comision] ( 124,136 )

select eed.* from pro.proceso_etapa_ejecucion pee
inner join pro.etapa_ejecucion_documento eed on pee.id_proceso_etapa_ejecucion = eed.id_proceso_etapa_ejecucion
where pee.id_proceso_etapa_ejecucion = 78075
select * from [pro].[fn_list_revision_asignatura_by_responsable_reporte](46075)

select * from [aca].[fn_get_record_estudiante_movilidad_interna](76831,42069,96)


select  d.*,pee.id_proceso_etapa_ejecucion,pee.id_proceso_usuario from [aca].[fn_get_record_estudiante_movilidad_interna] (67179,42546,96) as d
                                                                           inner join pro.etapa_ejecucion_responsable err on d.idEtapaEjecucionResponsable = err.id_etapa_ejecucion_responsable
                                                                           inner join pro.proceso_etapa_ejecucion pee on err.id_proceso_etapa_ejecucion = pee.id_proceso_etapa_ejecucion
order by d.idEtapaEjecucionResponsable,d.idNivel

select  d.*,pee.id_proceso_etapa_ejecucion,pee.id_proceso_usuario
from [aca].[fn_get_record_estudiante_movilidad_interna] (4616,42142,96) as d
inner join pro.etapa_ejecucion_responsable err on d.idEtapaEjecucionResponsable = err.id_etapa_ejecucion_responsable
inner join pro.proceso_etapa_ejecucion pee on err.id_proceso_etapa_ejecucion = pee.id_proceso_etapa_ejecucion
order by d.idEtapaEjecucionResponsable,d.idNivel

select * from pro.proceso_etapa_ejecucion where id_proceso_usuario = 30417

select * from pro.etapa_ejecucion_responsable

select * from pro.revision_asignaturas where id_revision_asignatura = 8115
Begin
    declare @id_proceso_etapa_ejecucion int =78579,@id_proceso_usuario int = 42374,@estado varchar(5)='I'

    -- declare @id_proceso_etapa_ejecucion int =38705,@id_proceso_usuario int = 21076
    --eliminar responsables
-- select distinct err.*
    update err set err.estado=@estado
    from pro.revision_asignaturas ra
             inner join pro.etapa_ejecucion_responsable err on ra.id_etapa_ejecucion_responsable = err.id_etapa_ejecucion_responsable
             inner join pro.proceso_etapa_ejecucion pee on err.id_proceso_etapa_ejecucion = pee.id_proceso_etapa_ejecucion
    where err.id_proceso_etapa_ejecucion not in (@id_proceso_etapa_ejecucion) and pee.id_proceso_usuario =@id_proceso_usuario --and pee.id_proceso_etapa =

-- select distinct ra.*
    update ra set ra.estado=@estado
    from pro.revision_asignaturas ra
             inner join pro.etapa_ejecucion_responsable err on ra.id_etapa_ejecucion_responsable = err.id_etapa_ejecucion_responsable
             inner join pro.proceso_etapa_ejecucion pee on err.id_proceso_etapa_ejecucion = pee.id_proceso_etapa_ejecucion
    where err.id_proceso_etapa_ejecucion not in (@id_proceso_etapa_ejecucion) and pee.id_proceso_usuario =@id_proceso_usuario --and pee.id_proceso_etapa =

-- select  distinct pee.*
    update pee set pee.estado=@estado
    from pro.revision_asignaturas ra
             inner join pro.etapa_ejecucion_responsable err on ra.id_etapa_ejecucion_responsable = err.id_etapa_ejecucion_responsable
             inner join pro.proceso_etapa_ejecucion pee on err.id_proceso_etapa_ejecucion = pee.id_proceso_etapa_ejecucion
    where err.id_proceso_etapa_ejecucion not in (@id_proceso_etapa_ejecucion) and pee.id_proceso_usuario =@id_proceso_usuario

end

select * from [pro].[fn_rpt_list_estudiantes_revision_comision] (103,95)
SELECT DISTINCT
    pe.CG_PERIODO, pl.VALOR_TEXTO AS PERIODO,
    ma.NOMBRE AS MATERIA,
    si.*,pe.*
FROM bdupse.pdc.anexo_silab si
         INNER JOIN Bd_Academico..MATERIAS_PLAN mp ON si.ID_PLAN = mp.id_MATERIA_plan
         INNER JOIN Bd_Academico..PLAN_ESTUDIOS pe ON mp.ID_PLAN = pe.ID_PLAN
         INNER JOIN Bd_Academico..MATERIAS ma ON ma.ID_MATERIA = mp.ID_MATERIA
         INNER JOIN Bd_Personal..TP_CODIGOS pl ON pe.CG_PERIODO = pl.CORRELATIVO
WHERE mp.ID_CARRERA_LOCAL = pe.ID_CARRERA_LOCAL
  AND mp.ID_MATERIA_PLAN = 35865
exec   BD_ACADEMICO.dbo.sp_materias_silabo 27699
  exec  [pro].[sp_recordweb_materias_silabo] 108, '12019550841', '0927084640'

select distinct ro.* from mig.record_oferta ro
inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
where identificacion='2450070319'

--ver si hay mallas asignaturas dobles en movilidad
select p.identificacion,pu.id_proceso_usuario,scc.id_estudiante_oferta,p.apellidos,p.nombres,of1.carrera,of2.carrera,a.descripcion,a1.descripcion,a2.descripcion,ra.* from pro.revision_asignaturas ra
inner join pro.etapa_ejecucion_responsable eer on ra.id_etapa_ejecucion_responsable = eer.id_etapa_ejecucion_responsable
inner join pro.proceso_etapa_ejecucion pee on eer.id_proceso_etapa_ejecucion = pee.id_proceso_etapa_ejecucion
inner join pro.proceso_usuario pu on pee.id_proceso_usuario = pu.id_proceso_usuario
inner join pro.solicitud_cambio_carrera scc on pu.id_proceso_usuario =scc.id_proceso_usuario
inner join man.personas p on p.id = pu.id_persona
inner join pro.proceso_general pg on pu.id_proceso_general = pg.id_proceso_general
inner join aca.malla_asignatura ma on ra.id_malla_asignatura_origen= ma.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
inner join aca.malla_asignatura ma1 on ra.id_malla_asignatura_valida = ma1.id_malla_asignatura
inner join aca.asignatura a1 on ma1.id_asignatura = a1.id_asignatura
inner join aca.malla_asignatura ma2 on ra.id_malla_asignatura_valida2 = ma2.id_malla_asignatura
inner join aca.asignatura a2 on ma2.id_asignatura = a2.id_asignatura
inner join aca.malla m1 on ma.id_malla = m1.id_malla
inner join aca.malla m2 on ma2.id_malla = m2.id_malla
inner join aca.ofertas_facultad of1 on of1.id_oferta_modalidad = m1.id_oferta_modalidad
inner join aca.ofertas_facultad of2 on of2.id_oferta_modalidad = m2.id_oferta_modalidad
where pg.id_periodo_academico = 136
--ra.fecha_ing >='2026-01-16 12:28:26.1220000'
  and ra.id_malla_asignatura_valida2 is not null and eer.estado='A' and pu.estado='A'
and ra.porcentaje_similitud>=80 and ra.estado='A'
-- and m.id_oferta_modalidad = 31

select * from aca.periodo_academico where id_tipo_oferta = 2 order by codigo desc


select d.* from  [pro].[fn_list_All_Estudiantes_Postulantes_By_Facultad] (null,21,136) as d

select
--     distinct  em.*
    --       distinct  ea.*--,p.identificacion
--     distinct eo.*
        distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,
                 eo.ultimo_periodo,p.identificacion,p.apellidos,p.nombres,tee.descripcion,tie.descripcion,eo.estado
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
where eo.id_estudiante_oferta in (101766,    101767,101768,101769,101770,101772,101773,101774,101775,101776,101777,101778,101779,101780,101781,
101782,101783,101784,101785    )
  and ofa.id_tipo_oferta = 2 and eo.estado='A'--and p.identificacion in ('0927969964')

select distinct dm.*
from aca.movilidad m
         inner join aca.detalle_movilidad dm on  m.id_movilidad = dm.id_movilidad
         inner join aca.estudiante_oferta eo1 on m.id_estudiante_oferta = eo1.id_estudiante_oferta
         inner join aca.malla_asignatura ma on dm.id_malla_asignatura=ma.id_malla_asignatura
        inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
        left join aca.asignatura a1 on a.descripcion = a1.descripcion
        left join aca.malla_asignatura ma1 on ma1.id_asignatura = a1.id_asignatura and ma1.id_malla = 172
         inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
where dm.estado='A' and  m.estado='A'
  and ma.estado='A' and niv.estado='A'
--   and eo1.id_estudiante_oferta in (101766,101767,101768,101769,101770,101772,101773,101774,101775,101776,101777,101778,101779,101780,101781, 101782,101783,101784,101785)
and eo1.id_estudiante_oferta in (79140)

select * from aca.estudiante_oferta where  id_estudiante_oferta in (101766,101767,101768,101769,101770,101772,101773,101774,101775,101776,101777,101778,101779,101780,101781, 101782,101783,101784,101785)
select * from aca.malla_asignatura
where id_malla =147 ;
select distinct eo1.id_estudiante_oferta,a.descripcion,dm.*
from aca.movilidad m
         inner join aca.detalle_movilidad dm on  m.id_movilidad = dm.id_movilidad
         inner join aca.estudiante_oferta eo1 on m.id_estudiante_oferta = eo1.id_estudiante_oferta
         inner join aca.malla_asignatura ma on dm.id_malla_asignatura=ma.id_malla_asignatura
         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
         inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
where dm.estado='A' and  m.estado='A'
  and ma.estado='A' and niv.estado='A' and eo1.id_estudiante_oferta in (101766,101767,101768,101769,101770,101772,101773,101774,101775,101776,101777,101778,101779,101780,101781, 101782,101783,101784,101785)

select * from aca.malla where id_oferta_modalidad=82
select * from aca.ofertas_facultad where id_tipo_oferta = 2
select distinct a.descripcion,ofa.carrera,ma.* from  aca.malla_asignatura ma
                                                         inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
                                                         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
                                                         inner join aca.malla m on ma.id_malla = m.id_malla
                                                         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
where ma.estado='A' and niv.estado='A' and m.id_malla in (172,23)


select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Oferta](21,136,null,null)

--   atendidos
--   and p.identificacion not in ('2400102287','2450073081','2450025339','0931419972','0927969964')
select  * from [aca].[fn_get_record_estudiante_movilidad_interna] (66637,42074,96) as d



--ver profesionales que no se puedan matricular
select
--     distinct  em.*
    --       distinct  ea.*--,p.identificacion
    distinct eo.*
--     distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,
--     eo.ultimo_periodo,p.identificacion,p.apellidos,p.nombres,tee.descripcion,tie.descripcion,eo.estado
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
where ofa.id_tipo_oferta = 2 and eo.id_tipo_estudiante = 4 and eo.mantiene_gratuidad = 1


select * from aca.periodo_academico where id_tipo_oferta = 2


select * from pro.tipo_proceso_estado
select * from (
  select   distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo as periodo,ofa.facultad,ofa.carrera,ofa1.carrera as nuevacarrera,p.identificacion,
                    p.apellidos,p.nombres,tee.descripcion as tipo_estado,tie.descripcion as tipo_ingreso,eo.estado,
                    ( select count(ma1.id_malla_asignatura)
                      from aca.malla m1
                               inner join aca.malla_asignatura ma1 on m1.id_malla=ma1.id_malla
                               inner join aca.nivel niv1 on ma1.id_nivel=niv1.id_nivel
                      where  m1.id_malla = eo.id_malla and niv1.id_nivel = 1
                        and ma1.estado='A' and niv1.estado='A'
                      group by ma1.id_malla) as numeroMateriasPrimero,
                    (aux.AprobadasPrimero+isnull(aux1.AprobadasPrimero,0)) as  AprobadasPrimero
from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join pro.solicitud_cambio_carrera scc on eo.id_estudiante_oferta = scc.id_estudiante_oferta
    inner join aca.ofertas_facultad ofa1 on ofa1.id_oferta_modalidad = scc.id_oferta_modalidad_nueva
    inner join pro.proceso_usuario pu on pu.id_proceso_usuario = scc.id_proceso_usuario
    inner join pro.proceso_general pg on pu.id_proceso_general = pg.id_proceso_general
    left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
    inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
    left join (select  eo1.id_estudiante_oferta,niv.id_nivel,count(ea.id_estudiante_asignatura) as AprobadasPrimero
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
) as aux on aux.id_estudiante_oferta = eo.id_estudiante_oferta and aux.id_nivel = 1
    left join (select  eo1.id_estudiante_oferta,niv.id_nivel,count(dm.id_detalle_movilidad) as AprobadasPrimero
--                  , ROW_NUMBER() OVER (PARTITION BY eo1.id_estudiante_oferta ORDER BY  niv.orden DESC) AS rn
               from aca.movilidad m
                        inner join aca.detalle_movilidad dm on  m.id_movilidad = dm.id_movilidad
                        inner join aca.estudiante_oferta eo1 on m.id_estudiante_oferta = eo1.id_estudiante_oferta
                        inner join aca.malla_asignatura ma on dm.id_malla_asignatura=ma.id_malla_asignatura
                        inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
               where  eo1.estado='A' and dm.estado='A' and  m.estado='A'
                 and ma.estado='A' and niv.estado='A' and dm.aprobado=1
               group by eo1.id_estudiante_oferta,niv.ORDEN,niv.id_nivel
) as aux1 on aux1.id_estudiante_oferta = eo.id_estudiante_oferta and aux1.id_nivel =1
--     left join mig.record_oferta ro on ro.id_estudiante_oferta = eo.id_estudiante_oferta
where eo.id_estudiante_oferta in (29887,	23662,	78166,	76257,	65311,	66260,	44877,	54215,	18422,	87977,	76388,	65047,	65049,	42995,	53851,
                                  88925,	78640,	88691,	10425,	65812,	79018,	66176,	86999,	23823,	88891,	87177,	87096,	44807,	56189,	87311,
                                  64839,	54999,	88819,	77711,	67252,	76793,	30769,	87050,	86747,	87153,	45252,	67146,	66808,	77008,	66011,
                                  67161,	76837,	76853,	76822,	23824,	56780,	43931,	23859,	87448,	76998,	76299,	86515,	76831,	31036,	54653,
                                  42794,	88924,	54703,	87043,	55017,	55053,	44035,	66095,	66175,	64951,	25602,	66404,	42727,	17914,	30891,
                                  9568,	10208,	86202,	88784,	9989,	31133,	11637,	66225,	45066,	66363,	66567,	64916,	66555,	86571,	78180,	87870,
                                  4616,	86552,	101700,	88194,	65297,	101701,	66546,	66575,	87709,	55416,	75830,	86607,	66552,	18464,	79004,	44928,
                                  29658,	65206,	86182,	55019,	77169,	86910,	23527,	65017,	66111,	44655,	44699,	88736,	29282,	56034,	55718,
                                  66925,	77955,	77678,	77650,	88150,	77906,	76353,	18421,	77565,	23395,	86506,	88636,	26253,	27993,	54754,
                                  87907,	86508,	88045,	77431,	88494,	66653,	87916,	78434,	88601,	86520,	86505,	56012,	67797,	88926,	67578,
                                  78148,	88557,	67421,	88841,	45360,	44349,	87884,	66597,	44919,	65174,	67179,	66610,	66585,	76414,	65937,
                                  65126,	87336,	87489,	87411,	65505,	88447,	54038,	55429,	26296,	76612,	66606,	66178,	10475,	77899,	88378,
                                  55163,	55192,	66553,	88886,	43197,	78691,	18463,	2316,	31134,	31115,	25612,	24383 )
    and pg.id_periodo_academico = 136 and pu.estado='A'
) as d
where d.numeroMateriasPrimero<>d.AprobadasPrimero

select *from pro.tipo_proceso_estado

select distinct
    pu.id_proceso_usuario,aux.id_proceso_etapa_ejecucion,pe.id_proceso_etapa,--aux.id_solicitud_cambio_carrera,
                pe.requiere_documento,pe.unico_archivo,r.nombre as rol,p.descripcion as proceso,e.descripcion as etapa,
                pc.fecha_desde,pc.fecha_hasta,cast(aux.fecha_hora_recepcion as date) as fecha_hora_recepcion,cast(aux.fecha_hora_despacho as date) as fecha_hora_despacho,
                case when aux.fecha_hora_recepcion is not null and aux.fecha_hora_despacho is not null then 'COMPLETO'
                     when aux.fecha_hora_recepcion is not null and aux.fecha_hora_despacho is null then 'EN PROCESO' else 'PENDIENTE' end as estado_ejecucion,
                isnull (aux.tiempo_retraso,'0')
from pro.proceso p
         inner join pro.proceso_general pg on pg.id_proceso = p.id_proceso
         inner join pro.proceso_usuario pu on pu.id_proceso_general = pg.id_proceso_general
         inner join pro.tipo_proceso tp on tp.id_tipo_proceso = p.id_tipo_proceso
         inner join pro.proceso_etapa pe on pe.id_proceso =p.id_proceso
         inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa and pc.id_proceso_general = pg.id_proceso_general
         inner join pro.proceso_etapa_rol per on per.id_proceso_etapa = pe.id_proceso_etapa
         inner join seg.roles r on r.id = per.id_rol
         inner join pro.etapa e on e.id_etapa = pe.id_etapa
         inner join
     (select pej.id_proceso_usuario,pej.id_proceso_etapa_ejecucion,pej.id_proceso_etapa,pej.fecha_hora_recepcion,
             pej.fecha_hora_despacho,pej.tiempo_retraso from pro.proceso_etapa_ejecucion pej
      where pej.estado='A'
     ) as aux on aux.id_proceso_usuario = pu.id_proceso_usuario and aux.id_proceso_etapa = pe.id_proceso_etapa
where  pg.id_proceso = 2 and pg.id_periodo_academico = 136 and pe.id_proceso_etapa = 12
  and p.estado='A' and pg.estado='A' and pe.estado='A' and pc.estado='A' and per.estado='A' and e.estado='A' and r.codigo not in ('COMISIONACADEMICA')
order by pe.id_proceso_etapa

select distinct pej.*
--     pu.id_proceso_usuario,aux.id_proceso_etapa_ejecucion,pe.id_proceso_etapa,--aux.id_solicitud_cambio_carrera,
--                 pe.requiere_documento,pe.unico_archivo,r.nombre as rol,p.descripcion as proceso,e.descripcion as etapa,
--                 pc.fecha_desde,pc.fecha_hasta,cast(aux.fecha_hora_recepcion as date) as fecha_hora_recepcion,cast(aux.fecha_hora_despacho as date) as fecha_hora_despacho,
--                 case when aux.fecha_hora_recepcion is not null and aux.fecha_hora_despacho is not null then 'COMPLETO'
--                      when aux.fecha_hora_recepcion is not null and aux.fecha_hora_despacho is null then 'EN PROCESO' else 'PENDIENTE' end as estado_ejecucion,
--                 isnull (aux.tiempo_retraso,'0')
from pro.proceso p
         inner join pro.proceso_general pg on pg.id_proceso = p.id_proceso
         inner join pro.proceso_usuario pu on pu.id_proceso_general = pg.id_proceso_general
         inner join pro.tipo_proceso tp on tp.id_tipo_proceso = p.id_tipo_proceso
         inner join pro.proceso_etapa pe on pe.id_proceso =p.id_proceso
         inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa and pc.id_proceso_general = pg.id_proceso_general
         inner join pro.proceso_etapa_rol per on per.id_proceso_etapa = pe.id_proceso_etapa
         inner join seg.roles r on r.id = per.id_rol
         inner join pro.etapa e on e.id_etapa = pe.id_etapa
         inner join pro.proceso_etapa_ejecucion pej on pej.id_proceso_usuario = pu.id_proceso_usuario and pej.id_proceso_etapa = pe.id_proceso_etapa
where  pg.id_proceso = 2 and pg.id_periodo_academico = 136 and pe.id_proceso_etapa = 13
  and p.estado='A' and pg.estado='A' and pe.estado='A' and pc.estado='A' and per.estado='A' and e.estado='A' and r.codigo not in ('COMISIONACADEMICA')

----------------------homologacion
 select * from aca.tipo_equivalencia




select * from aca.movilidad
-- DBCC CHECKIDENT ('aca.movilidad', RESEED, 11011);
-- update aca.movilidad set fecha_ing= fecha_ingreso  where fecha_ing is null
-- update aca.movilidad set fecha_mod= fecha_ing where fecha_mod is null

-- update m set m.usuario_ing = u.usuario
-- select u.usuario,m.*
-- from aca.movilidad m
--          inner join seg.usuarios u on u.id = m.usuario_ingreso_id
--          where m.usuario_ing is null
-- update m set m.usuario_mod = '2400254286'
select m.*
from aca.detalle_movilidad m
         inner join seg.usuarios u on u.id = m.usuario_ingreso_id
--          where u.usuario<>m.usuario_ing
-- DBCC CHECKIDENT ('aca.detalle_movilidad', RESEED, 146550);
select * from aca.detalle_movilidad



select * from sag.institucion
select * from aca.institucion where estado='A'
-- update aca.institucion set descripcion=UPPER(descripcion) where estado='A'

select * from aca.nivel_formacion
SELECT * from aca.tipo_institucion

select sm.* from aca.subtipo_movilidad sm
inner join aca.tipo_oferta_movilidad tm on sm.id_subtipo_movilidad = tm.id_subtipo_movilidad
where tm.id_tipo_oferta =2 and sm.id_tipo_movilidad = 1


select m.id_movilidad,dm.id_detalle_movilidad,sm.codigo from aca.subtipo_movilidad sm
inner join aca.movilidad m on sm.id_subtipo_movilidad = m.id_subtipo_movilidad
inner join aca.detalle_movilidad dm on m.id_movilidad = dm.id_movilidad
where dm.id_estudiante_asignatura=679459

select * from aca.tipo_movilidad

select  top 100 * from aca.estudiante_asignatura

select * from [aca].[fn_get_all_malla_curricular_movilidades] (28226)
--                   ANALISIS-COMP-CONT CUR-ASIG-CURR

select * from aca.fn_get_all_records_by_offer(28226,null,null,null,null) as d


SELECT * FROM [aca].[fn_cargar_malla](28226)

CREATE TRIGGER trg_detalle_movilidad_insert
    ON aca.detalle_movilidad
    AFTER INSERT
    AS
BEGIN
    SET NOCOUNT ON;

    UPDATE ea
    SET
        ea.fecha_mod = GETDATE(),ea.aprobado = iif(dm.calificacion>=70,1,0),ea.promedio=dm.calificacion
    FROM aca.estudiante_asignatura ea
             INNER JOIN inserted dm
                        ON ea.id_estudiante_asignatura = dm.id_estudiante_asignatura
             INNER JOIN aca.movilidad m
                        ON dm.id_movilidad = m.id_movilidad
             INNER JOIN aca.subtipo_movilidad sm
                        ON m.id_subtipo_movilidad = sm.id_subtipo_movilidad
    WHERE
        dm.id_estudiante_asignatura IS NOT NULL
      AND sm.codigo = 'CUR-ASIG-CURR';
END;
GO
