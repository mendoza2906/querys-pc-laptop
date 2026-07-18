use bd_sga_upse
select mp.ID_MATERIA_PLAN,m.id_malla,mat.NOMBRE,--ni.ID_NIVEL as iis,aux.descripcion,
       case when ni.CODIGO='1RO' then (select n.id_nivel from bd_sga_upse.aca.nivel n where n.codigo='I')
            when ni.CODIGO='2DO' then (select n.id_nivel from bd_sga_upse.aca.nivel n where n.codigo='II')
            when ni.CODIGO='3RO' then (select n.id_nivel from bd_sga_upse.aca.nivel n where n.codigo='III')
            when ni.CODIGO='4TO' then (select n.id_nivel from bd_sga_upse.aca.nivel n where n.codigo='IV')
            when ni.CODIGO='5TO' then (select n.id_nivel from bd_sga_upse.aca.nivel n where n.codigo='V')
            when ni.CODIGO='6TO' then (select n.id_nivel from bd_sga_upse.aca.nivel n where n.codigo='VI')
            when ni.CODIGO='7MO' then (select n.id_nivel from bd_sga_upse.aca.nivel n where n.codigo='VII')
            when ni.CODIGO='8VO' then (select n.id_nivel from bd_sga_upse.aca.nivel n where n.codigo='VIII')
            when ni.CODIGO='9NO' then (select n.id_nivel from bd_sga_upse.aca.nivel n where n.codigo='IX')
            when ni.CODIGO='10MO' then (select n.id_nivel from bd_sga_upse.aca.nivel n where n.codigo='X')
            when ni.CODIGO='I' and (ni.ID_NIVEL>=53 and ni.ID_NIVEL<=57) then (select n.id_nivel from bd_sga_upse.aca.nivel n where n.codigo='POST 1')
            when ni.CODIGO='II' and (ni.ID_NIVEL>=53 and ni.ID_NIVEL<=57)  then (select n.id_nivel from bd_sga_upse.aca.nivel n where n.codigo='POST 2')
            when ni.CODIGO='III' and (ni.ID_NIVEL>=53 and ni.ID_NIVEL<=57)  then (select n.id_nivel from bd_sga_upse.aca.nivel n where n.codigo='POST 3')
            when ni.CODIGO='IV' and (ni.ID_NIVEL>=53 and ni.ID_NIVEL<=57)  then (select n.id_nivel from bd_sga_upse.aca.nivel n where n.codigo='POST 4')
            when ni.CODIGO='V' and (ni.ID_NIVEL>=53 and ni.ID_NIVEL<=57 ) then (select n.id_nivel from bd_sga_upse.aca.nivel n where n.codigo='POST 5')
            when ni.CODIGO='PU-SEM' then (select n.id_nivel from bd_sga_upse.aca.nivel n where n.codigo='NIV')
           --else ni.ID_NIVEL
           end as id_nivel,
       case when aux.id_asignatura IS null then (select aa.id_asignatura from bd_sga_upse.aca.asignatura aa where aa.descripcion = mat.NOMBRE)
            else aux.id_asignatura  end as id_asignatura,
       --aux.descripcion,
       case when mp.TOTAL_HORAS IS null then mp.CREDITOS*48 else mp.TOTAL_HORAS end as nom_horas,
       mp.CREDITOS as num_creditos , 1 as usuario_ingreso_id
from  Bd_Academico.dbo.MATERIAS_PLAN mp
          inner join Bd_Academico.dbo.MATERIAS mat on mat.ID_MATERIA = mp.ID_MATERIA
          inner join Bd_Academico.dbo.NIVELES ni on ni.ID_NIVEL = mp.ID_NIVEL
          inner join  migracion_sga.[dbo].[registros_migracion] rm  on rm.id_origen = mp.ID_PLAN
          inner join [bd_sga_upse].aca.malla m on rm.id_destino= m.id_malla
          left join (select rm1.id_destino,rm1.id_origen,asi.id_asignatura,asi.descripcion from migracion_sga.[dbo].[registros_migracion] rm1
                                                                                                    inner join bd_sga_upse.aca.asignatura asi on asi.id_asignatura = rm1.id_destino where rm1.id_entidad_relacion = 3)as aux on aux.descripcion = mat.NOMBRE
where rm.id_entidad_relacion = 4 and ni.ID_NIVEL <>11 and ni.ID_NIVEL not in (40,47,48,49,50,51) and mp.ESTADO='A' and mp.ID_MATERIA_PLAN not in (14818
    )
  and mp.ID_PLAN in(406) AND MP.ESTADO='A' and mat.ESTADO='A' --and aux.id_asignatura is null
--los id 39 y 40 de la tabla nivel de bd academico son de nivelacion tambein
--mallas de biologia y electronica
--and m.id_malla  in (40,49)
--and m.id_malla = 50
order by m.id_malla,id_nivel

--habilitar matricula
select --om.carrera,
       pao.* from aca.periodo_academico_oferta pao
inner join aca.ofertas_facultad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
where pao.estado='A' and om.id_tipo_oferta = 2 and pao.id_periodo_academico = 95 and om.id_oferta_modalidad in (21)

select * from aca.tipo_matricula_fecha
select * from aca.matricula_general



select * from aca.estudiante_matricula where estado='X'
select * from man.documentos_archivos where id_number = 143975


select * from  man.personas where identificacion='0928275338'
select * from aca.periodo_malla where id_malla in (160,161,41)

-- exec  [dbo].[SPMigracionMallaAsignatura]
-- exec [dbo].[SP_Update_fields_Malla_Asignatura]
-- exec [dbo].[SP_Update_fields_Malla]

select * from aca.asignatura_compatibilidad

select * from aca.compatibilidad_asignatura

select * from aca.oferta

select * from aca.modalidad
-- DBCC CHECKIDENT ('aca.oferta_modalidad', RESEED, 133);

select * from aca.oferta_modalidad where id_oferta = 80

select m1.id_malla,ma1.id_malla_asignatura,a1.id_asignatura,ca.id_asignatura as id_asig_comp,ma1.id_nivel,a1.descripcion from aca.malla m1
inner join aca.malla_asignatura ma1 on ma1.id_malla = m1.id_malla
inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
left join aca.compatibilidad_asignatura ca on ca.id_asignatura_comp = a1.id_asignatura and ca.estado='A'
where ma1.estado='A' and a1.estado='A' and m1.estado in ('A','P')

--acuas
select ac.*
--     ac.tipo,m.id_malla,ma.id_malla_asignatura,ma.id_nivel,a.id_asignatura,a.descripcion as asignatura,m.descripcion,
--        m1.id_malla,ma1.id_malla_asignatura,ma1.id_nivel,a1.id_asignatura,a1.descripcion as asignatura_compatible,m1.descripcion
       from aca.asignatura_compatibilidad ac
inner join aca.malla_asignatura ma on ac.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
inner join aca.malla_asignatura ma1 on ac.id_malla_asignatura_comp = ma1.id_malla_asignatura
inner join aca.malla m1 on ma1.id_malla = m1.id_malla
inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
where ma.estado='A' and a.estado='A' and m.estado in ('A','P') and ma1.estado='A' and a1.estado='A' and m1.estado in ('A','P') and ac.tipo in ('REDISEÑO_MALLA','NUEVA_MALLA')
and m.id_malla =22 --and a.descripcion<>a1.descripcion

SELECT * FROM aca.tipo_matricula_fecha

select m.id_malla,pm.id_periodo_malla,m.id_oferta_modalidad,ma.id_malla_asignatura,aa.id_asignatura_aprendizaje,aa.id_componente_aprendizaje,ma.id_nivel,a.id_asignatura,a.descripcion as asignatura,m.descripcion
--        m1.id_malla,ma1.id_malla_asignatura,ma1.id_nivel,a1.id_asignatura,a1.descripcion as asignatura_compatible,m1.descripcion
from aca.malla_asignatura ma
inner join aca.asignatura_aprendizaje aa on ma.id_malla_asignatura = aa.id_malla_asignatura
         inner join aca.malla m on ma.id_malla = m.id_malla
         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
        inner join aca.periodo_malla pm on m.id_malla = pm.id_malla and pm.id_periodo_academico=127
where ma.estado='A' and a.estado='A' and m.estado in ('A','P')
  and m.id_oferta_modalidad in (109,107) and aa.id_componente_aprendizaje in (2)
  and m.id_malla in (108,110,168,169) --and ma.id_malla_asignatura in (3371,3374)

select * from aca.fn_listar_docentes_asignaturas(null,109,127)

select * from aca.docente_asignatura_aprend where id_docente_asignatura_aprend in (49627,49619,49621,49658,49620,49622)

select ppd.* from aca.planificacion_paralelo pp
inner join aca.planificacion_paralelo_detalle ppd on pp.id_planificacion_paralelo = ppd.id_planificacion_paralelo
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = pp.id_malla_asignatura
where ma.id_malla in (108,110) and pp.id_periodo_academico = 127

select distinct ea.*
--     pa.codigo,om.facultad,om.carrera, eo.id_estudiante_oferta,p.id as id_persona,p.identificacion,
--        p.nombres,p.apellidos,eo.id_oferta_modalidad, eo.mantiene_gratuidad as mantiene_gratuidad,
--        aux.id_estudiante_matricula,pg.identificacion,pg.carrera
--     aux.id_estudiante_matricula,6,200,'S/N','A',0,getdate(),getdate(),p.identificacion,p.identificacion
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.periodo_academico pa on pa.id_periodo_academico =  eo.id_periodo_academico
         inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
            inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
            inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
         inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
--          left join ( select em.id_estudiante_matricula,em.id_estudiante_oferta,ea.id_paralelo from aca.estudiante_matricula em
--                     inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
--                     inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
--                      where em.estado='A' and ea.estado='A' and mg.id_periodo_academico= 127
--                      group by em.id_estudiante_matricula,em.id_estudiante_oferta,ea.id_paralelo) as aux on aux.id_estudiante_oferta = eo.id_estudiante_oferta

where  --p.identificacion in ('0927943738') --and em.estado ='A' and pa.estado='A'
    eo.estado='A' and tee.codigo='ACT' and om.id_tipo_oferta = 1  and eo.id_oferta_modalidad in (107) --and pa.codigo<>'2025-2'
-- and mg.id_periodo_academico = 127

select ha.* from aca.horario_academico ha
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = ha.id_malla_asignatura
where ha.estado='A' and ha.id_periodo_academico=127 and ma.id_malla in (108)

select c.* from aca.clase c
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = c.id_malla_asignatura
where c.estado='A' and c.id_periodo_academico=127 and ma.id_malla in (169)

select * from aca.asignatura_resultado_aprendizaje where id_malla_asignatura in (2370,2375)

select * from aca.malla_asignatura where id_malla_asignatura in (3374,2375)

select *from man.personas where identificacion='1714536818'
select * from aca.asignatura_compatibilidad ac
--          where tipo is null

select * from rel.malla_relacion
--83 162
select m.id_malla,ma.id_malla_asignatura,m.id_oferta_modalidad,ma.id_nivel,a.id_asignatura,ma.codigo_malla,a.descripcion as asignatura,m.descripcion from aca.malla_asignatura ma
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where ma.estado='A' and a.estado='A' and m.estado in ('A','P') and ma.id_malla in (75,163)
order by ma.id_malla,ma.id_nivel,ma.codigo_malla
--se suman 5 mas
--3557 manes recien graduados
begin
    --626 manes a crear
    declare @id_periodo_academico int=95
    select eo.id_persona, eo.id_estudiante_oferta,om.carrera,p.identificacion,concat(p.apellidos,'',p.nombres) AS estudiante,om.id_oferta_modalidad,omn.id_oferta_modalidad as id_oferta_modalidad_nueva,
           eo.id_malla,m.id_malla as id_malla_nueva
    from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join rel.malla_relacion mr on mr.id_malla_principal = eo.id_malla and mr.tipo ='REDISEÑOS_2025'
    inner join aca.malla m on m.id_malla = mr.id_malla_secundaria
    inner join aca.ofertas_facultad omn on omn.id_oferta_modalidad = m.id_oferta_modalidad

    where eo.estado = 'A' and tee.estado = 'A' AND tee.codigo='ACT' and p.estado = 'AC' and mr.id_periodo_academico = @id_periodo_academico
    and om.tipo_oferta = 'PREGRADO' --and om.id_oferta_modalidad =80
    and eo.id_estudiante_oferta not in (select d.idEstudianteOferta
--                                              ,d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen,d.identificacion,d.estudiante,d.estadoProceso
    from pro.fn_list_All_Estudiantes_Postulantes_By_Oferta(null,@id_periodo_academico,null,null) as d
    where d.idOfertaModalidad in (20,97,80,89) and d.estadoProceso not in ('DENEGADO')
    group by d.facultadDestino,d.carreraDestino,d.facultadOrigen,d.carreraOrigen,d.identificacion,d.estudiante,d.estadoProceso,d.idEstudianteOferta)
    group by eo.ID_PERSONA, eo.id_estudiante_oferta,om.carrera, p.identificacion, p.apellidos, p.nombres,
             om.id_oferta_modalidad,omn.id_oferta_modalidad, m.id_malla, eo.id_malla

end
-- 0928628841	VELEZ VERA	ROBERTO CARLOS
-- 2450137241	ROCA GONZALEZ	ERICK MICHAEL
-- 2400134181	BERNABE VILLON	ITALO DANILO
-- 2450101197	REYES RODRIGUEZ	EVELYN TATIANA
-- 2450876558	VILLON ORRALA	GENESIS YAMILE
-- 0928078575	PANCHANA DE LA CRUZ	LUIS ANGEL
-- 0925912842	CRUZ QUIMI	KELVIN FABRICIO

select * from rel.malla_relacion
select * from aca.matricula_fecha_nivel
select * from aca.tipo_ingreso_estudiante
select * from aca.tipo_estado_estudiante
select * from aca.subtipo_movilidad


exec [aca].[sp_list_all_carreras_records]  '0928029727' ,null, null , null, null

exec [aca].[sp_list_all_asignaturas_detalle_record] 75506,108,'12017550705','2400011413',null,null,1

select * FROM aca.fn_record_academico_sga_definitivo(1727, null, null, 1) as d
select * FROM aca.fn_record_academico_sga_definitivo(75506, null, null, 1) as d
select top 3 * from aca.estudiante_oferta where estado='A'
order by id_estudiante_oferta desc

select * from [mig].[fn_list_record_for_migration](135,85,164,55060,null)

select d.id_movilidad_carrera_nueva,d.id_malla_asignatura_compatible,d.promedio--, @estado,@fecha,@id_usuario_insert,@versionNum,@fecha,@fecha, @usuario,@usuario
                    from [mig].[fn_list_record_for_migration](20,22,161,1727,null) AS d

--migrar a los manes de agropecuaria
exec aca.sp_generate_migracion_malla_presencial_to_hibrida_denifitiva 95,20,20

select pm.* from aca.malla m
inner join aca.periodo_malla pm on m.id_malla = pm.id_malla
where m.id_oferta_modalidad = 20


--0963242292	GUARECUCO ANDRADESLAICER STELL NICATOR caso de prueba de

select *from aca.tipo_ingreso_estudiante


select * from rel.oferta_relaciones

select * from aca.periodo_academico where id_tipo_oferta= 1

select top 1 * from aca.estudiante_oferta eo where eo.estado='A'

select eo.id_estudiante_oferta,eo.id_persona,eo.id_nivel_proyectado,eo.vez_proyectada from aca.estudiante_oferta eo where eo.id_estudiante_oferta = 8294

select m.id_malla,ma.id_malla_asignatura,ma.id_nivel,a.id_asignatura,ma.codigo_malla,a.descripcion as asignatura,m.descripcion from aca.malla_asignatura ma
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where ma.estado='A' and a.estado='A' and m.estado in ('A','P') and m.id_oferta_modalidad  in (38,89,80,134,20,97,135)
--   and ma.id_malla in (38,89)
order by ma.id_malla,ma.id_nivel,ma.codigo_malla

select m.id_malla,id_oferta_modalidad,m.descripcion from aca.malla m
where  m.estado in ('A','P') and m.id_oferta_modalidad  in (38,89,80,134,20,97,135)
--   and ma.id_malla in (38,89)
order by m.id_malla

select * from aca.ofertas_facultad

select * from aca.oferta_modalidad where id_oferta = 60

select * from aca.modalidad

select  distinct m.* from aca.malla_asignatura ma
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where ma.estado='A' and a.estado='A' and m.estado in ('A','P') and m.id_oferta_modalidad  in (97,135)
-- order by ma.id_malla,ma.id_nivel,ma.codigo_malla

select * from aca.malla m where m.id_oferta_modalidad  in (97,135)

select * from aca.malla_asignatura where id_malla = 164

select * from aca.modalidad_asignatura

--80,134
select * from aca.periodo_malla where id_malla = 75
--replicar malla desde otra malla
begin
    --ti presencial
--     declare @id_malla_nueva int = 162,@id_malla_vieja int = 41
    --software
--     declare @id_malla_nueva int = 163,@id_malla_vieja int = 75
    --pine playas
    declare @id_malla_nueva int = 164,@id_malla_vieja int = 85
--INSERT
    insert into aca.malla_asignatura
select @id_malla_nueva, id_nivel, ma.id_asignatura, id_modalidad_asignatura, 1, num_horas, ma.num_creditos, codigo_malla,
       UICII, 'A',  getdate(), 664, 0, getdate(), getdate(), '2400254286', '2400254286', objetivo,ma.descripcion, resultado_aprendizaje, sistema_contenido

from aca.malla_asignatura ma
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where ma.estado='A' and a.estado='A' and m.estado in ('A','P') and m.id_malla = @id_malla_vieja

    declare @id_malla_nueva int = 164,@id_malla_vieja int = 85
    insert into aca.asignatura_organizacion
    select ma1.id_malla_asignatura, ao.id_comp_organizacion,
           'A',  getdate(), 664, 0, getdate(), getdate(), '2400254286', '2400254286'

    from aca.malla_asignatura ma
             inner join aca.malla m on ma.id_malla = m.id_malla
             inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
            inner join aca.asignatura_organizacion ao on ma.id_malla_asignatura = ao.id_malla_asignatura
            inner join aca.malla_asignatura ma1 on ma1.id_asignatura = ma.id_asignatura and ma1.id_malla = @id_malla_nueva
    where ma.estado='A' and a.estado='A' and m.estado in ('A','P') and m.id_malla = @id_malla_vieja

    declare @id_malla_nueva int = 164,@id_malla_vieja int = 85
    insert into aca.asignatura_aprendizaje
    select  ma1.id_malla_asignatura, aa.id_componente_aprendizaje, aa.valor, aa.multidocente,
           'A',  getdate(), 664, 0, getdate(), getdate(), '2400254286', '2400254286'

    from aca.malla_asignatura ma
             inner join aca.malla m on ma.id_malla = m.id_malla
             inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
             inner join aca.asignatura_aprendizaje aa on ma.id_malla_asignatura = aa.id_malla_asignatura
             inner join aca.malla_asignatura ma1 on ma1.id_asignatura = ma.id_asignatura and ma1.id_malla = @id_malla_nueva
    where ma.estado='A' and a.estado='A' and aa.estado='A' and m.estado in ('A','P') and m.id_malla = @id_malla_vieja

    declare @id_malla_nueva int = 164,@id_malla_vieja int = 85
--     insert into aca.asignatura_relacion
    select   aa.tipo_relacion,ma1.id_malla_asignatura,ma2.id_malla_asignatura, aa.estado,getdate(), 664, 0

    from aca.malla_asignatura ma
             inner join aca.malla m on ma.id_malla = m.id_malla
             inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
             inner join aca.asignatura_relacion aa on ma.id_malla_asignatura = aa.id_malla_asignatura
             inner join aca.malla_asignatura maux on maux.id_malla_asignatura = aa.id_malla_asignatura_relacion
             inner join aca.malla_asignatura ma1 on ma1.id_asignatura = ma.id_asignatura and ma1.id_malla = @id_malla_nueva
             inner join aca.malla_asignatura ma2 on ma2.id_asignatura = maux.id_asignatura and ma2.id_malla = @id_malla_nueva
    where ma.estado='A' and a.estado='A' and aa.estado='A' and m.estado in ('A','P') and m.id_malla = @id_malla_vieja

end




select * from aca.tipo_asignatura

select * from aca.asignatura

select * from aca.tipo_estado_estudiante

select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 2

select * from aca.matricula_general

select * from aca.matricula_fecha_nivel

select * from aca.tipo_ingreso_estudiante
select * from aca.estudiante_oferta where id_estudiante_oferta = 24396

select * from mig.record_oferta  ro where  estado='A' and ro.identificacion ='0705099547'



select * from mig.record_matricula where id_record_oferta = 61998

select * from mig.record_asignaturas where id_record_oferta = 61998

select ro.id_oferta_modalidad,ro.identificacion,ro.nombres,ro.carrera,count( distinct ra.id_plan) as mallas,
       count(ro.periodo = ('2019-2')) AS si_redisenio
from mig.record_oferta  ro
inner join mig.record_matricula  rm on ro.id_record_oferta = rm.id_record_oferta
inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
where  ro.estado='A' and ro.id_tipo_oferta = 2-- and ra.periodo < ('2019-2')--and ro.identificacion ='2400061665'
group by ro.id_oferta_modalidad, ro.identificacion, ro.carrera, ro.nombres

select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta =2

select distinct o.ID_CARRERA_OFERTADA,o.NOMBRE_CARRERA,ofa.carrera,d.ID_EGRESADO,d.ID_PERSONA,p.APELLIDOS,p.NOMBRES,d.FECHA_INGRESO,d.FECHA_EGRESO,d.ESTADO,g.ID_GRADUADO,g.FECHA_GRADUACION from Bd_academico.dbo.EG_EGRESADOS as d
inner join Bd_Academico..PERSONAS p on d.ID_PERSONA = p.ID_PERSONA
inner join Bd_Academico.dbo.carreras_locales_modalidad_sistema o on o.ID_CARRERA_LOCAL= d.ID_CARRERA_LOCAL and o.CG_MODALIDAD = d.CG_MODALIDAD
inner join [migracion_sga].[dbo].[registros_migracion] rmo on  rmo.id_origen  = o.ID_CARRERA_OFERTADA and rmo.id_entidad_relacion = 2 and o.CG_SISTEMA_ESTUDIO = d.CG_SISTEMA_ESTUDIO
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = rmo.id_destino
left join Bd_academico.dbo.EG_LISTADO_GRADUADOS as g on g.ID_EGRESADO = d.ID_EGRESADO
where d.ESTADO='A' and p.ESTADO='A' --and p.IDENTIFICACION='0705446011'

select * from Bd_academico.dbo.EG_LISTADO_GRADUADOS as d

select * from Bd_academico.dbo.EG_EGRESADOS as d

select * from aca.periodo_academico_oferta pao where pao.id_oferta_modalidad in (38,89,80,134,20,97,135) and pao.id_periodo_academico = 95
--   and ma.id_malla in (38,89)


select * from mig.oferta_conexion

SELECT * FROM tmp.matricula_proyeccion where id_periodo_academico = 95
                                         and id between 3305 and 4288

select * from aca.tipo_ingreso_estudiante

----ver como estan los manes de agropecuaria
--591 movilidades a eliminar

select * from (
select
--     distinct m.*
    eo.id_estudiante_oferta,eo.id_periodo_academico,eo.ultimo_periodo,p.identificacion,p.apellidos,p.nombres,o.descripcion as carrera,eo.vez_proyectada,tie.descripcion as tipo_ingreso,
    tee.descripcion as estado_cupo,ofa.carrera as carrera_origen,
       CASE  WHEN eo.vez_proyectada % 15 = 0 THEN 'Regular'      ELSE 'No regular' END AS resultado,eo.id_nivel_proyectado,eo.id_malla,eo.fecha_ing
--        eo.*,
       ,(select sum (ma.num_creditos) as creditos  from aca.estudiante_matricula em
                                        inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
                                       inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
                                        inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                                        inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
                                       where ea.estado='A' and em.estado='A' and em.id_estudiante_oferta = eo.id_estudiante_oferta and mg.id_periodo_academico = 95 ) as creditos_actuales,
    m.id_movilidad,m.estado as estado_movilidad
from aca.estudiante_oferta eo
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
inner join aca.movilidad m on eo.id_estudiante_oferta = m.id_estudiante_oferta and m.estado='E'
left join aca.estudiante_oferta eop on eop.id_estudiante_oferta = eo.id_estudiante_oferta_padre
left join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eop.id_oferta_modalidad
where eo.estado='A' and o.id_tipo_oferta = 2 and om.id_oferta_modalidad = 20 and eo.id_tipo_estado_estudiante = 1
and eo.id_tipo_ingreso_estudiante not in (11,2,7) and eo.id_nivel_proyectado not in (1)
and eo.id_estudiante_oferta not in (select eo1.id_estudiante_oferta from aca.estudiante_oferta eo1
                                                                       inner join man.personas p1 on eo1.id_persona = p1.id
                                                                       inner join aca.oferta_modalidad om1 on eo1.id_oferta_modalidad = om1.id_oferta_modalidad
                                                                       inner join aca.estudiante_oferta eop1 on eop1.id_estudiante_oferta = eo1.id_estudiante_oferta_padre
                                                                       inner join aca.ofertas_facultad ofa1 on ofa1.id_oferta_modalidad = eop1.id_oferta_modalidad
                                    where eo1.id_oferta_modalidad = 20 and eop1.id_oferta_modalidad = 43 and eo1.id_periodo_academico = 95)
) as d

select distinct dm.*
-- update dm set dm.estado='E'
from aca.detalle_movilidad dm
inner join aca.movilidad m on dm.id_movilidad = m.id_movilidad
where m.estado='E' and cast(m.fecha_mod as date)= cast(getdate() as date) and dm.estado='E'


select eo1.*,ofa1.carrera from aca.estudiante_oferta eo1
inner join man.personas p1 on eo1.id_persona = p1.id
inner join aca.oferta_modalidad om1 on eo1.id_oferta_modalidad = om1.id_oferta_modalidad
inner join aca.estudiante_oferta eop1 on eop1.id_estudiante_oferta = eo1.id_estudiante_oferta_padre
inner join aca.ofertas_facultad ofa1 on ofa1.id_oferta_modalidad = eop1.id_oferta_modalidad
where eo1.id_oferta_modalidad = 20 and eop1.id_oferta_modalidad = 43 and eo1.id_periodo_academico = 95

select * from aca.ofertas_facultad where id_tipo_oferta = 1

select * from aca.tipo_estado_estudiante
--591
select
-- --     distinct m.*
--     distinct  eop.*
-- update ea set ea.estado='E', ea.fecha_mod=getdate(),ea.usuario_mod='2400254286'
    distinct eo.id_estudiante_oferta,eo.id_periodo_academico,eo.ultimo_periodo,p.identificacion,p.apellidos,p.nombres,o.descripcion as carrera,eo.vez_proyectada,tie.descripcion as tipo_ingreso,
    tee.descripcion as estado_cupo,em.id_estudiante_matricula,ofa.carrera as carrera_origen,eop.id_estudiante_oferta,em1.id_estudiante_matricula,
       CASE  WHEN eo.vez_proyectada % 15 = 0 THEN 'Regular'      ELSE 'No regular' END AS resultado,eo.id_nivel_proyectado,eo.id_malla,eo.fecha_ing
--        eo.*,
       ,(select sum (ma.num_creditos) as creditos  from aca.estudiante_matricula em
                                        inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
                                       inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
                                        inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                                        inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
                                       where ea.estado='E' and em.estado='E' and em.id_estudiante_oferta = eo.id_estudiante_oferta and mg.id_periodo_academico = 95 ) as creditos_actuales
        ,(select top 1 ea2.id_paralelo from aca.estudiante_asignatura ea2
            inner join aca.estudiante_matricula em2 on ea2.id_estudiante_matricula = em2.id_estudiante_matricula
            inner join aca.matricula_general mg2 on em2.id_matricula_general = mg2.id_matricula_general
          where ea2.estado='A'  and em2.id_estudiante_oferta = eop.id_estudiante_oferta and mg2.id_periodo_academico = 36
          group by  ea2.id_paralelo
          order by count(ea2.id_paralelo) desc) as paralelo_anterior,
    m.id_movilidad,m.estado as estado_movilidad
from aca.estudiante_oferta eo
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
inner join aca.movilidad m on eo.id_estudiante_oferta = m.id_estudiante_oferta and m.estado='E'
left join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta and em.estado='E'
left join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general and mg.id_periodo_academico = 95
    -- inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
-- inner join aca.matricula_rubro mr on em.id_estudiante_matricula = mr.id_estudiante_matricula
left join aca.estudiante_oferta eop on eop.id_estudiante_oferta = eo.id_estudiante_oferta_padre
left join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eop.id_oferta_modalidad
left join aca.estudiante_matricula em1 on eop.id_estudiante_oferta = em1.id_estudiante_oferta and em1.estado='A' and em1.id_matricula_general = 31
where eo.estado='E' and o.id_tipo_oferta = 2 and om.id_oferta_modalidad = 20 and eo.id_tipo_estado_estudiante = 1
and eo.id_tipo_ingreso_estudiante not in (11,2,7) and eo.id_nivel_proyectado not in (1)
--and ea.estado='A'
and eo.id_estudiante_oferta not in (select eo1.id_estudiante_oferta from aca.estudiante_oferta eo1
                                                                       inner join man.personas p1 on eo1.id_persona = p1.id
                                                                       inner join aca.oferta_modalidad om1 on eo1.id_oferta_modalidad = om1.id_oferta_modalidad
                                                                       inner join aca.estudiante_oferta eop1 on eop1.id_estudiante_oferta = eo1.id_estudiante_oferta_padre
                                                                       inner join aca.ofertas_facultad ofa1 on ofa1.id_oferta_modalidad = eop1.id_oferta_modalidad
                                    where eo1.id_oferta_modalidad = 20 and eop1.id_oferta_modalidad = 43 and eo1.id_periodo_academico = 95)
and em.id_estudiante_matricula is not null and em1.id_estudiante_matricula is null

select * from aca.tipo_matricula_fecha


select * from aca.matricula_general where id_periodo_academico = 95

exec aca.sp_rpt_malla_por_carrera_requisito 71

--acuas
select ac.tipo,m.id_malla,ma.id_malla_asignatura,ma.id_nivel,a.id_asignatura,a.descripcion as asignatura,m.descripcion,
       m1.id_malla,ma1.id_malla_asignatura,ma1.id_nivel,a1.id_asignatura,a1.descripcion as asignatura_compatible,m1.descripcion from aca.asignatura_compatibilidad ac
inner join aca.malla_asignatura ma on ac.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
inner join aca.malla_asignatura ma1 on ac.id_malla_asignatura_comp = ma1.id_malla_asignatura
inner join aca.malla m1 on ma1.id_malla = m1.id_malla
inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
where ma.estado='A' and a.estado='A' and m.estado in ('A','P') and ma1.estado='A' and a1.estado='A' and m1.estado in ('A','P') and ac.tipo='REDISEÑO_MALLA'  and m.id_oferta_modalidad = 20


-- and m.id_malla =83 and a.descripcion<>a1.descripcion
--reportes de aulas necesarias por carrera
begin



    declare @tem_table table (id_malla_asignatura int , codigo_periodo varchar(250), facultad varchar(250) ,
                              carrera  varchar(250) , nivel varchar(250), asignatura varchar(250), detalle_prerequisito varchar(250), observacion varchar(250), modalidad varchar(250), horas int , pronostico int,
                              cantidad_estudiante_paralelo decimal(10,2),  numero_paralelos int,paralelo_proyectados int,cantidad_estudiante_paralelo_distributivo decimal(10,2))
    insert @tem_table
    SELECT
        id_malla_asignatura,codigo_periodo,facultad,carrera,nivel,asignatura,detalle_prerrequisitos,observacion,
        modalidad,horas,pronostico
            ,
        case when  isnull(pronostico,0)>0 then    (isnull(pronostico,0)/(CASE WHEN modalidad = 'ONLINE' THEN
                                                                                  CASE WHEN isnull(pronostico,0) <= 77 THEN 1 ELSE CEILING(isnull(pronostico,0) / 70.0) END
                                                                              ELSE CEILING(isnull(pronostico,0) / 45.0) END))else 0 end  as
                   cantidad_estudiante_paralelo ,
        CASE WHEN modalidad = 'ONLINE' THEN
                 CASE WHEN isnull(pronostico,0) <= 77 THEN 1 ELSE CEILING(isnull(pronostico,0) / 70.0)  END
             ELSE CEILING(isnull(pronostico,0) / 45.0)
            END AS numero_paralelos,paralelo_proyectados,cast(((pronostico*1.0)/(paralelo_proyectados *1.0)) as decimal(10,2)) cantidad_estudiante_paralelo_distributivo

    FROM ( SELECT
               pm.id_malla_asignatura, pm.codigo_periodo,pm.facultad,pm.carrera,pm.id_nivel as nivel,pm.asignatura,pm.detalle_prerrequisitos, pm.observacion,
               ma2.codigo AS modalidad,(select sum(aa.valor) from aca.asignatura_aprendizaje aa
                                                                      inner join aca.componente_aprendizaje ca on aa.id_componente_aprendizaje = ca.id_componente_aprendizaje
                                        where aa.id_malla_asignatura= pm.id_malla_asignatura and aa.estado='A'
                                          and ca.codigo in ('DOCENCIA','PRACTICA','ASISTIDODOCENTE','SINCRONICO','SINCRONICOP')) as horas,
               pm.pronostico_1_aprobados_menos_reprobados AS pronostico,paralelo_proyectados ---, estudiante_proyectados
           FROM tmp.matricula_proyeccion pm
                    INNER JOIN aca.malla_asignatura ma ON pm.id_malla_asignatura = ma.id_malla_asignatura
                    INNER JOIN aca.modalidad_asignatura ma2 ON ma.id_modalidad_asignatura = ma2.id_modalidad_asignatura
                    inner join      (select aa.id_malla_asignatura,max(daa.id_paralelo) paralelo_proyectados-- , max(daa.num_estudiantes) estudiante_proyectados
                                     from  aca.periodo_academico_oferta pao
                                               inner join aca.distributivo_oferta do on pao.id_periodo_academico_oferta=do.id_periodo_academico_oferta
                                               inner join aca.distributivo_docente dd on do.id_distributivo_oferta=dd.id_distributivo_oferta
                                               inner join aca.docente_asignatura_aprend daa on dd.id_distributivo_docente=daa.id_distributivo_docente
                                               inner join aca.asignatura_aprendizaje aa on daa.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
                                     where pao.estado='A' and do.estado='A' and pao.id_periodo_academico=95 and dd.estado='A' and daa.estado='A' and aa.estado='A'
                                     group by aa.id_malla_asignatura
           ) as aux on pm.id_malla_asignatura=aux.id_malla_asignatura
           where pm.id_periodo_academico = 95 and pm.id >3306
         ) a

    select codigo_periodo, facultad, carrera, nivel, modalidad, max(paralelo_proyectados) paralelo_proyectados,
           case when modalidad ='PRESENCIAL' then case when max(cantidad_estudiante_paralelo_distributivo)<=35 then 'MENOR IGUAL 35'
                                                       WHEN max(cantidad_estudiante_paralelo_distributivo)>35 and  max (cantidad_estudiante_paralelo_distributivo)<=45 then 'ENTRE 35 HASTA 45' else  'MAYOR A 45' END
                else
                    case when max(cantidad_estudiante_paralelo_distributivo)<=70 then 'MENOR 70' else  'MAYOR 70'END
               end
               as rango
    from @tem_table
    group by codigo_periodo, facultad, carrera, nivel, modalidad--, paralelo_proyectados

    SELECT codigo_periodo, facultad, carrera, nivel,modalidad, isnull([MENOR 35],0) as MENOR_35, isnull([ENTRE 35 HASTA 45],0) as [ENTRE 35 HASTA 45], isnull([MAYOR A 45],0) as [MAYOR A 45],isnull([MENOR 70] ,0) as [MENOR 70], isnull ([MAYOR 70],0)as [MAYOR 70]
    FROM (
             select codigo_periodo, facultad, carrera, nivel, modalidad, max(paralelo_proyectados) paralelo_proyectados,
                    case when modalidad ='PRESENCIAL' then case when max(cantidad_estudiante_paralelo_distributivo)<=35 then 'MENOR IGUAL 35'
                                                                WHEN max(cantidad_estudiante_paralelo_distributivo)>35 and  max (cantidad_estudiante_paralelo_distributivo)<=45 then 'ENTRE 35 HASTA 45' else  'MAYOR A 45' END
                         else
                             case when max(cantidad_estudiante_paralelo_distributivo)<=70 then 'MENOR 70' else  'MAYOR 70'END
                        end
                        as rango
             from @tem_table
             group by codigo_periodo, facultad, carrera, nivel, modalidad--, paralelo_proyectados

         ) AS SourceTable
             PIVOT (
             max(paralelo_proyectados)  FOR rango IN ([MENOR 35], [ENTRE 35 HASTA 45], [MAYOR A 45],[MENOR 70] , [MAYOR 70])
             ) AS PivotTable
    order by  codigo_periodo, facultad, carrera, nivel


end
select * from aca.asignatura_compatibilidad
--
EXEC aca.sp_rpt_cantidad_matriculados_por_oferta 20   , 95

select aa.id_asignatura_aprendizaje,ea.id_docente,ea.id_paralelo,ea.id_estudiante_asignatura, ea.estado,p.identificacion,p.apellidos,p.nombres,
       ma.id_malla,eo.id_malla,eo.id_estudiante_oferta,ma.id_malla_asignatura,
       iif(ma.id_malla=eo.id_malla,ma.id_malla_asignatura,isnull(ac.id_malla_asignatura,ma.id_malla_asignatura)) as id_malla_asignaturasss,
       n.orden,
       case when ea.matricula_excepcional =1 then concat(CONVERT(varchar(10),n.orden),' - ',a.descripcion, ' - Matrícula Excepcional') else
           concat(CONVERT(varchar(10),n.orden),' - ',a.descripcion)  end as nombreAsignatura, sum (aa.valor) AS totalHorasA,
       (select a.total_horas_doc from [aca].[fn_asignatura_creditos] (ma.id_malla_asignatura) as a) as  totalHorasD,
       case when ea.codigo_estado_matricula='PRI' THEN '1 VEZ'
            ELSE case when ea.codigo_estado_matricula='SEG' THEN '2 VEZ'
                      ELSE '3 VEZ'  END
           END,
       ma.num_creditos,ma.num_horas,ea.id_rubro,r.valor, ea.valor_asignatura,ea.codigo_estado_matricula,ea.matricula_excepcional,
       ma.UICII
from aca.estudiante_matricula em
         inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = em.id_estudiante_oferta
        inner join man.personas p on eo.id_persona = p.id
         inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
         inner join tes.rubro r on r.id_rubro = ea.id_rubro
         inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
         inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
         inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
         inner join aca.nivel n on ma.id_nivel = n.id_nivel
         inner join aca.componente_aprendizaje as cap on aa.id_componente_aprendizaje=cap.id_componente_aprendizaje
         inner join aca.componente_aprendizaje capP on capP.id_componente_aprendizaje=cap.id_componente_aprendizaje_padre
    --actualizacion 02-03-2025 Carlos Mendoza para materias de rediseño de malla o entre careras
         left join aca.asignatura_compatibilidad ac on ma.id_malla_asignatura = ac.id_malla_asignatura_comp and ac.estado='A' and ac.tipo in ('REDISEÑO_MALLA','COMPATIBILIDAD ENTRE CARRERAS')
where mg.id_periodo_academico = 95
  and ma.id_malla<>eo.id_malla
  AND ea.estado in ('A','R','X') and cap.codigo in ('DOCENCIA','PRESENCIAL','SINCRONICO')
group by aa.id_asignatura_aprendizaje,ea.id_docente,ea.id_paralelo,ea.id_estudiante_asignatura,ea.estado,ma.id_malla_asignatura,
         n.orden,a.descripcion, a.id_asignatura,eo.id_estudiante_oferta,ma.num_creditos,ma.num_horas ,ea.id_rubro,r.valor ,ea.valor_asignatura,ea.matricula_excepcional,
         codigo_estado_matricula,--,aux.id_asignatura_aprendizaje,aux.id_docente,aux.id_paralelo, aux.id_estudiante_asignatura,
         eo.id_oferta_modalidad,ma.UICII
        ,ac.id_malla_asignatura,ma.id_malla, eo.id_malla, p.identificacion, p.apellidos, p.nombres--ac.id_malla_asignatura,ac.id_malla_asignatura_comp
order by ma.id_malla_asignatura asc

select * from man.tipo_identificacion

select * from aca.oferta
select * from aca.oferta_modalidad

select * from aca.sistema_estudio

select * from man.lugar where id_lugar_padre is null

--ver quien movio los componentes de la malla
select m1.id_malla,ma1.id_malla_asignatura,a1.id_asignatura,ma1.id_nivel,a1.descripcion,concat(p.apellidos,' ',p.nombres) as persona_creo,aa.fecha_ing,
       concat(pm.apellidos,' ',pm.nombres) as persona_modifico,aa.fecha_mod from aca.malla m1
inner join aca.malla_asignatura ma1 on ma1.id_malla = m1.id_malla
inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
inner join aca.asignatura_aprendizaje aa on ma1.id_malla_asignatura = aa.id_malla_asignatura
inner join seg.usuarios u on u.usuario = aa.usuario_ing
inner join man.personas p on u.persona_id = p.id
inner join seg.usuarios um on um.usuario = aa.usuario_mod
inner join man.personas pm on um.persona_id = pm.id
where ma1.estado='A' and a1.estado='A' and m1.estado in ('A','P')
and ma1.id_malla = 145


select * from pro.tipo_proceso_estado

select ar.* from aca.asignatura_requisito ar
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = ar.id_malla_asignatura
where ma.id_malla = 34

select mr.* from aca.malla m
inner join aca.malla_requisito mr  on m.id_malla = mr.id_malla
where m.id_malla = 34


---migrar ofertas historicas del sisweb
select distinct --om.id_oferta_modalidad,
                o.* from aca.oferta o
--                              inner join uath.cargos_departamentos u on o.id_oferta = u.id_oferta
                             left join aca.oferta_modalidad om on o.id_oferta = om.id_oferta
where o.prefijo ='SISWEB'


select * from aca.estudiante_oferta eo where eo.estado='I'



--     EDUCACION FISICA Y DEPORTE FORMATIVO - MATRIZ
-- GASTRONOMIA - MATRIZ
-- INGENIERIA EN GESTION Y DESARROLLO TURISTICO - PLAYAS
-- VETERINARIA - MATRIZ

 select * from  [bd_academico].[dbo].TE_CARRERAS_LOCALIDAD
select * from aca.oferta

select * from man.tipo_departamento

select  distinct ro.*
--     CAST(iif
from mig.record_oferta ro
         left join mig.record_matricula rma on ro.id_record_oferta = rma.id_record_oferta
         inner join Bd_Academico..VW_CARRERAS_OFERTADAS fac on fac.ID_CARRERA_OFERTADA = ro.ID_CARRERA_OFERTADA
         left join migracion_sga..registros_migracion rm on rm.id_origen = fac.ID_CARRERA_LOCAL and rm.id_entidad_relacion=1
WHERE ro.estado='A' and rm.id_destino is null

select * from migracion_sga..registros_migracion where id_entidad_relacion = 27

select * from aca.oferta_modalidad


--
SELECT
    fk.name AS ForeignKeyName,
    SCHEMA_NAME(o1.schema_id) AS EsquemaOrigen,
    OBJECT_NAME(fk.parent_object_id) AS TablaOrigen,
    c1.name AS ColumnaOrigen,
    SCHEMA_NAME(o2.schema_id) AS EsquemaDestino,
    OBJECT_NAME(fk.referenced_object_id) AS TablaDestino,
    c2.name AS ColumnaDestino

-- concat('select * from ' ,SCHEMA_NAME(o1.schema_id),'.',OBJECT_NAME(fk.parent_object_id),' where ',c1.name,' in (110,126,127)')
FROM sys.foreign_keys fk
         INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
         INNER JOIN sys.columns c1 ON fkc.parent_object_id = c1.object_id AND fkc.parent_column_id = c1.column_id
         INNER JOIN sys.columns c2 ON fkc.referenced_object_id = c2.object_id AND fkc.referenced_column_id = c2.column_id
         INNER JOIN sys.objects o1 ON o1.object_id = fk.parent_object_id
         INNER JOIN sys.objects o2 ON o2.object_id = fk.referenced_object_id
WHERE OBJECT_NAME(fk.referenced_object_id) = 'oferta';

/*select * from uath.cargos_departamentos where id_oferta in (110,126,127)
select * from aca.oferta_asignatura where id_oferta in (110,108,127)
--select * from vcc.programa where id_oferta in (110,126,127)
select * from seg.roles_usuario_oferta where oferta_id in (110,126,127)
--select * from dbo.persona_cargo where id_oferta in (110,126,127)
--select * from aca.docente_postgrado where id_oferta in (110,126,127)
--select * from vcc.oferta_proyecto where id_oferta in (110,126,127)
--select * from cat.solicitud_investigacion where id_oferta in (110,126,127)
--select * from ppp.solicitud_practicas_preprolab where id_oferta in (110,126,127)
--select * from ppp.itinerario_inscripcion where id_oferta in (110,126,127)
--select * from ppp.configuracion_documentos_requisitos where id_oferta in (110,126,127)
--select * from ppp.configuracion_repositorio_actividades where id_oferta in (110,126,127)
--select * from mev.modelo_grupo_departamento where id_oferta in (110,126,127)
--select * from ipg.rubro_oferta where id_oferta in (110,126,127)
--select * from sgai.proyecto_persona where id_carrera in (110,126,127)
--select * from sgai.centro_investigacion_oferta where id_oferta in (110,126,127)
--select * from card.cupo_rutina_horario where id_oferta in (110,126,127)
--select * from sgai.grupo_oferta where id_oferta in (110,126,127)
select * from pro.vacante where id_oferta in (110,126,127)
--select * from rlx.convenio_departamento where id_oferta in (110,126,127)
--select * from sgai.linea_investigacion_oferta where id_oferta in (110,126,127)
--select * from sgai.tarea_investigador where id_carrera in (110,126,127)
--select * from cmo.vacante where id_oferta in (110,126,127)
select * from aca.departamento_oferta where id_oferta in (110,126,127)
--select * from aca.relacion_oferta where id_oferta_hijo in (110,126,127)
--select * from rel.oferta_relaciones where id_oferta in (110,126,127)
--select * from aca.relacion_oferta where id_oferta_padre in (110,126,127)
select * from uath.reforma where id_oferta in (110,126,127)
--select * from rel.oferta_relaciones where id_oferta_relacion in (110,126,127)
--select * from eva.evaluador_docente_instrumento where id_oferta in (110,126,127)
--select * from pro.vacante_oferta where id_oferta in (110,126,127)
select * from com.grupo_departamento where id_oferta in (110,126,127)
--select * from ppp.solicitud_registro_institucion where id_oferta in (110,126,127)
select * from aca.oferta_modalidad where id_oferta in (110,126,127)
--select * from ipg.contact_form where id_oferta in (110,126,127)*/

--migrar titulos de carreras viejas
-- insert into aca.titulos_academicos
-- select d.id_nivel_formacion, codigo,titulo, descripcion_corta, estado, fecha_ingreso, usuario_ingreso_id, version
-- from (select  3 id_nivel_formacion,SUBSTRING((select top 1 eg.TITULO from Bd_academico.dbo.EG_LISTADO_GRADUADOS eg where eg.ID_CARRERA_LOCAL =vis.ID_CARRERA_LOCAL), 1, 5) as codigo,
--                        (select top 1 eg.TITULO from Bd_academico.dbo.EG_LISTADO_GRADUADOS eg where eg.ID_CARRERA_LOCAL =vis.ID_CARRERA_LOCAL) as titulo,
--                        SUBSTRING((select top 1 eg.TITULO from Bd_academico.dbo.EG_LISTADO_GRADUADOS eg where eg.ID_CARRERA_LOCAL =vis.ID_CARRERA_LOCAL), 1, 10) as descripcion_corta, 'A' as estado,
--                        getdate() as fecha_ingreso, '664' as usuario_ingreso_id,0 as version, ROW_NUMBER() OVER (PARTITION BY vis.ID_CARRERA_LOCAL  ORDER BY o.FECHA_APR_CONSEJO,o.FECHA_CREACION desc ) as indice
--                from mig.record_oferta ro
--                         left join mig.record_matricula rma on ro.id_record_oferta = rma.id_record_oferta
--                         inner join [bd_academico].[dbo].CARRERAS_LOCALES_MODALIDAD_SISTEMA o on o.ID_CARRERA_OFERTADA = ro.ID_CARRERA_OFERTADA
--                         inner join [bd_academico].[dbo].VW_TE_CARRERAS_LOCALIDAD vis on vis.ID_CARRERA_LOCAL = o.ID_CARRERA_LOCAL
--                         left join migracion_sga..registros_migracion rm on rm.id_origen = vis.ID_CARRERA_LOCAL and rm.id_entidad_relacion=1
--                WHERE ro.estado='A' and rm.id_destino is null and ro.id_tipo_oferta = 2
--                group by vis.ID_CARRERA_LOCAL,vis.CARRERA,vis.INSTITUCION,o.CG_TIPO_OFERTA,o.FECHA_APR_CONSEJO,o.FECHA_CREACION, vis.ESTADO_CARRERA, ro.carrera,
--                         vis.DURACION, ro.id_tipo_oferta,o.EMAIL_CONTACTO,o.EMAIL_CLAVE) as d
-- where d.indice = 1 and titulo is not null
-- order by d.titulo

select m.descripcion,
       ma.id_malla_asignatura,a.id_asignatura,concat(ma.id_nivel,' - ',a.descripcion) as asignatura,m2.descripcion,concat(ma2.id_nivel,' - ',a2.descripcion) as asignaturaRelacion
from aca.malla m
inner join aca.malla_asignatura ma on ma.id_malla =m.id_malla
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
inner join aca.asignatura_compatibilidad ac on ac.id_malla_asignatura = ma.id_malla_asignatura and ac.estado='A'
left join aca.malla_asignatura ma2 on ma2.id_malla_asignatura = ac.id_malla_asignatura_comp and ac.estado='A' and a.estado='A' and ac.tipo='COMPATIBILIDAD ENTRE CARRERAS'
left join aca.malla m2 on m2.id_malla = ma2.id_malla
left join aca.asignatura a2 on a2.id_asignatura = ma2.id_asignatura
where m.estado in ('A','P') and ma.estado='A'

select * from aca.asignatura_compatibilidad where tipo='COMPATIBILIDAD ENTRE CARRERAS'


select m.descripcion,
       ma.id_malla_asignatura,a.id_asignatura,concat(ma.id_nivel,' - ',a.descripcion) as asignatura
from aca.malla m
         inner join aca.malla_asignatura ma on ma.id_malla =m.id_malla
         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where m.estado in ('A','P')

SELECT distinct aa.id_malla_asignatura, ma.id_malla,eo.id_malla,m.descripcion, a.descripcion,ma2.id_malla_asignatura,a2.descripcion,m2.descripcion
FROM aca.periodo_academico pa
         inner join ACA.matricula_general mg on pa.id_periodo_academico=mg.id_periodo_academico
         inner join aca.estudiante_matricula em on mg.id_matricula_general=em.id_matricula_general
         inner join aca.estudiante_oferta eo on em.id_estudiante_oferta=eo.id_estudiante_oferta
         inner join man.personas p on eo.id_persona=p.id
         inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
         inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
         inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
         inner join aca.malla m on ma.id_malla = m.id_malla
    inner join aca.malla m2 on eo.id_malla = m2.id_malla
        inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
inner join aca.malla_asignatura ma2 on ma2.id_malla = eo.id_malla
inner join aca.asignatura a2 on ma2.id_asignatura = a2.id_asignatura and a2.descripcion =a.descripcion
where mg.estado='A' and em.estado in('A')
  and p.estado='AC' AND MG.id_periodo_academico=95
  and ea.id_asignatura_aprendizaje not in (select aa1.id_asignatura_aprendizaje from aca.malla_asignatura ma1
                                                                                         inner join aca.asignatura_aprendizaje aa1 on ma1.id_malla_asignatura=aa1.id_malla_asignatura
                                           where ma1.id_malla=eo.id_malla)

select * from aca.asignatura_compatibilidad ac1 where tipo='COMPATIBILIDAD ENTRE CARRERAS' and estado='A'


select n.id_nivel,null,n.descripcion,ea.id_estudiante_asignatura,null,iif(eo.id_malla<>ma.id_malla,ac.id_malla_asignatura,ma.id_malla_asignatura) as id_malla_asignatura,
--        ma.id_malla_asignatura,ac.id_malla_asignatura,
       null,m.id_malla,null,a.descripcion as asignatura,
       case when m.tipo_plan ='HORAS' then ma.num_horas else ma.num_creditos end as creditosHoras,
       ea.promedio,0,'NORMAL','ASIGNATURA',case when ea.aprobado = 1 then 'APROBADO' else 'REPROBADO' end as estadoAprobado,ea.aprobado,
       pa.codigo,mg.id_periodo_academico,null,ma.codigo_malla,'SGA' as origen,0 as promedio_final,ea.matricula_excepcional,ea.estado
from aca.estudiante_oferta eo
         inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
         inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
         inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
         inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula =  em.id_estudiante_matricula
         inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
         inner join aca.componente_aprendizaje ca on ca.id_componente_aprendizaje = aa.id_componente_aprendizaje
         inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
         inner join aca.malla m on m.id_malla = ma.id_malla
         inner join aca.nivel n on n.id_nivel = ma.id_nivel
         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
         LEFT join aca.asignatura_compatibilidad ac on ma.id_malla_asignatura=ac.id_malla_asignatura_comp AND ac.estado='A'
where em.id_estudiante_oferta in (77295) and eo.estado='A'
  and ea.estado='A'
  and em.estado='A' and ma.estado='A' and m.estado in ('A','P') and n.estado='A'
  and a.estado='A'
  and (pa.id_periodo_academico not in(96) or pa.id_periodo_academico is null )

select * from aca.malla where id_oferta_modalidad =21

select * from aca.oferta where id_tipo_oferta = 1

select * from aca.oferta_asignatura where id_oferta in (52,    61,62,88,157)
se