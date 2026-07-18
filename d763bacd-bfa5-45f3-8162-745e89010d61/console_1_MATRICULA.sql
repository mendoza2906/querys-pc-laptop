use bd_sga_upse
--     use Bd_Academico
--     Bd_Academico..fn_Md5(@identificacion)
-- select  Bd_Academico..fn_Md5('dfdsfds')
select * from aca.fn_Fechas_habilitas_matricula_cedula('0958406746')

select  concat('{MD5}',fn_Md5(p.identificacion)) as i, u.* from man.personas p
inner join seg.usuarios u on p.id=u.persona_id
where  p.apellidos like '%HAZ LOPEZ%'

--2025-1
exec [aca].[sp_list_all_carreras_records]  '0927947507' ,null, null, null, null

exec [aca].[sp_list_all_carreras_records]  '2450254418' ,null, null , null, null

exec [aca].[sp_list_all_asignaturas_detalle_record] 25780,null,null,
    null,null,null,null

--consulta de matriculas extraordinarias
select distinct em.id_estudiante_matricula,d.nombre,o.descripcion,p.identificacion,p.apellidos,p.nombres,eo.numero_matricula,a.descripcion,ea.id_paralelo,
case when em.estado  is null then 'NO MATRICULADO' when em.estado='X' then 'ANULADA' when em.estado='A' then 'ACTIVA' else em.estado  end as estadoMat,
em.fecha_ing as fechaMatricula,em.fecha_mod as fechaModMatricula,
concat(pu.nombres,' ',pu.apellidos) as usuarioCreaMatricula,
concat(pu2.nombres,' ',pu2.apellidos) as usuarioModificomatricula
from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
inner join man.departamentos d on d.id= do.id_departamento
left join seg.usuarios u on u.usuario = em.usuario_ing
left join man.personas pu on pu.id = u.persona_id
left join seg.usuarios u2 on u2.usuario = em.usuario_mod
left join man.personas pu2 on pu2.id = u2.persona_id
 where
 o.id_tipo_oferta = 2 and mg.id_periodo_academico = 30
 and p.identificacion='2450260936'
and em.estado = 'A'
 --and em.estado='A'
 order by d.nombre,p.apellidos


select distinct em.*
--      em.id_estudiante_matricula,d.nombre,o.descripcion,p.identificacion,p.apellidos,p.nombres,eo.numero_matricula,a.descripcion,ea.id_paralelo,
-- case when em.estado  is null then 'NO MATRICULADO' when em.estado='X' then 'ANULADA' when em.estado='A' then 'ACTIVA' else em.estado  end as estadoMat,
-- em.fecha_ing as fechaMatricula,em.fecha_mod as fechaModMatricula,
-- concat(pu.nombres,' ',pu.apellidos) as usuarioCreaMatricula,
-- concat(pu2.nombres,' ',pu2.apellidos) as usuarioModificomatricula
from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
inner join man.departamentos d on d.id= do.id_departamento
left join seg.usuarios u on u.usuario = em.usuario_ing
left join man.personas pu on pu.id = u.persona_id
left join seg.usuarios u2 on u2.usuario = em.usuario_mod
left join man.personas pu2 on pu2.id = u2.persona_id
 where
 o.id_tipo_oferta = 2 and mg.id_periodo_academico = 30
and em.estado = 'A' and cast(em.fecha_ing as date) <='02-09-2023' and em.id_tipo_matricula = 2 and p.identificacion ='2400009524'
 --and em.estado='A'
 order by d.nombre,p.apellidos

select* from aca.matricula_rubro where id_estudiante_matricula = 31722
  exec [aca].[sp_migrate_estudiantes_nivelacion_to_pregrado] 28,30



select * from man.personas p where p.apellidos like '%mederos machado%' and p.nombres like '%mar%'


select  * from [aca].[fn_get_record_estudiante_movilidad_interna] (30988,2907,30) as d

select  * from [aca].[fn_get_record_estudiante_movilidad_interna] (27063,2706,27) as d


---probar que funcionan bien los records
exec [aca].[sp_list_all_carreras_records] '0302657689',null,null,null,null

begin
-- 	declare @id_estudiante_oferta int = null, @matricula varchar(50)='12018521652',@id_carrera_ofertada int =105, @identificacion_persona_origen varchar(25)='2400460941'
    declare @id_estudiante_oferta int = null, @matricula varchar(50)='12014560695',@id_carrera_ofertada int =43, @identificacion_persona_origen varchar(25)='0302657689'
--       exec  bd_sga_upse.[aca].[sp_recordweb_materias_colum_aprob] @id_carrera_ofertada,@matricula,@identificacion_persona_origen
    declare @tempRecordAsignaturas table (
        idNivel  NUMERIC(18,0),idNivelSw  NUMERIC(18,0),nivel  VARCHAR(20),
        idEstudianteAsignatura numeric(18,0),idMateriaTomada  NUMERIC(18,0),idMallaAsignatura  NUMERIC(18,0),idMateriaPlan  NUMERIC(18,0),
        idMalla  NUMERIC(18,0),idPlan  NUMERIC(18,0),asignatura  VARCHAR(500),valorMalla NUMERIC(18,0),promedio NUMERIC(18,0),
        asistencia  NUMERIC(18,4),estadoAsignatura VARCHAR(50),tipo  VARCHAR(100),estadoAprobado varchar(150),aprobado bit,periodo  VARCHAR(20),
        idPeriodoAcademico int,idPeriodoAcademicoSw int,orden int,origen varchar(50),promedio_final NUMERIC(18,0)
    )

	declare @recordSisWeb table (idNivel numeric(9,0), nivel varchar(150), materia varchar(350), idMateriaTomada int,idMateriaPlan int,idPlan numeric,
                                                    creditosHora numeric(5,2),promedio numeric(5,2),asistencia numeric(5,2),estado varchar(25),tipo varchar(350),
                                                    aprobado varchar(150),periodo varchar(50),idPeriodo int, orden varchar(10))

      insert @tempRecordAsignaturas
        select n.id_nivel,null,n.descripcion,ea.id_estudiante_asignatura,null,ma.id_malla_asignatura,null,m.id_malla,null,a.descripcion as asignatura,
		case when m.tipo_plan ='HORAS' then ma.num_horas else ma.num_creditos end as creditosHoras,
		ea.promedio,0,'NORMAL','ASIGNATURA',case when ea.aprobado = 1 then 'APROBADO' else 'REPROBADO' end as estadoAprobado,ea.aprobado,
		pa.codigo,mg.id_periodo_academico,null,ma.codigo_malla,'SGA' as origen,0 as promedio_final
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
		where em.id_estudiante_oferta in (@id_estudiante_oferta) and eo.estado='A'
		and ea.estado='A' and em.estado='A' and ma.estado='A' and m.estado in ('A','P') and n.estado='A'
		and a.estado='A'
		and ca.codigo in (select d.codigoHijo from aca.fn_listar_componentes_aprendizajes_reglamento(mg.id_reglamento) as d
        )
		group by n.id_nivel,n.descripcion,a.descripcion,ea.id_estudiante_asignatura,ma.id_malla_asignatura,ea.aprobado,
		m.id_malla, m.tipo_plan , ma.num_horas , ma.num_creditos, mg.id_periodo_academico,ma.codigo_malla,ea.promedio,pa.codigo
		union
   		select n.id_nivel,null,n.descripcion,dm.id_detalle_movilidad,null,ma.id_malla_asignatura,null,m.id_malla,null,
   		       a.descripcion as asignatura,case when m.tipo_plan ='HORAS' then ma.num_horas else ma.num_creditos end as creditosHoras,
		isnull(dm.calificacion,0),0,'NORMAL',UPPER(sm.descripcion),case when dm.aprobado = 1 then 'APROBADO' else 'REPROBADO' end as estadoAprobado,dm.aprobado as aprobado,pa.codigo,pa.id_periodo_academico,null,ma.codigo_malla,'MOVILIDAD-SGA' as origen,
		0 as promedio_final
			from aca.movilidad mo
		inner join aca.detalle_movilidad dm on mo.id_movilidad = dm.id_movilidad
		inner join aca.malla_asignatura ma on ma.id_malla_asignatura = dm.id_malla_asignatura
		inner join aca.malla m on m.id_malla = ma.id_malla
		inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
		inner join aca.nivel n on n.id_nivel = ma.id_nivel
		inner join aca.subtipo_movilidad sm on sm.id_subtipo_movilidad = mo.id_subtipo_movilidad
		inner join aca.periodo_academico pa on pa.id_periodo_academico = mo.id_periodo_academico
		where mo.id_estudiante_oferta = @id_estudiante_oferta
-- 		and (n.id_nivel = @idNivel or @idNivel is null)
--         and (pa.codigo = @periodo or @periodo is null)
--         and (1 = @aprobado or @aprobado is null)
		and dm.estado='A' and ma.estado='A' and m.estado in ('A','P') and n.estado='A' and a.estado='A'
        order by id_nivel,codigo_malla,promedio
        if @id_carrera_ofertada is not null
        begin
            insert into @recordSisWeb exec bd_sga_upse.[aca].[sp_recordweb_materias_colum_aprob] @id_carrera_ofertada,@matricula,@identificacion_persona_origen
            insert @tempRecordAsignaturas

            select ra.idNivel,niv.id_nivel,--niv.nivel
                   case when ra.NIVEL in('GENERAL','V','I','II','III','IV','VI','VII','MODULOS') then 'MÓDULOS'
                       when niv.nivel is  null then ra.NIVEL else niv.nivel end as nivel,
                   null as idEstudianteAsignatura,ra.idMateriaTomada,isnull(maa.id_malla_asignatura,0),ra.idMateriaPlan,
            mal.id_malla,ra.idPlan,ra.materia,ra.creditosHora,ra.promedio,ra.asistencia,ra.estado,ra.tipo,ra.aprobado,
            case ra.aprobado when 'APROBADO' then 1 else 0 end aprobado,ra.periodo,null as idPeriodo,ra.idPeriodo as idPeriodoAcademicoSw,maa.codigo_malla,'SISWEB' as origen,
            0 as promedio_final
            from @recordSisWeb ra
            left join
                (select ma.id_malla_asignatura,rma.id_origen,rma.id_destino,ma.codigo_malla from migracion_sga..registros_migracion rma
                inner join aca.malla_asignatura ma on ma.id_malla_asignatura = rma.id_destino

                where rma.id_entidad_relacion in (5,29)
                        --agregue esta linea 06/2/2024 eliminar si afecta a los demas
                        --se incluyo porque obtenia id de otras mallas y generaba duplicidad
                            and
            -- 				(
                                (ma.id_malla in (select estudiante_oferta.id_malla
                                                  from aca.estudiante_oferta
                                                  where id_estudiante_oferta = @id_estudiante_oferta))
                            --eliminar solo es para los records de estudiantes de LICENCIATURA EN GESTION Y DESARROLLO TURISTICO - MATRIZ - PRESENCIAL
            -- 				        or ma.id_malla = 20
            -- 				    )
			    ) as maa on maa.id_origen = ra.idMateriaPlan

            left join
                (select n.id_nivel,rn.id_origen,rn.id_destino,n.descripcion as nivel from migracion_sga..registros_migracion rn
            left join aca.nivel n on n.id_nivel = rn.id_destino
            where rn.id_entidad_relacion in (6) ) as niv on niv.id_origen = ra.idNivel
            left join
                (select m.id_malla,m.tipo_plan,rm.id_origen,rm.id_destino from migracion_sga..registros_migracion rm
            inner join aca.malla m on m.id_malla = rm.id_destino
            where rm.id_entidad_relacion in (4) ) as mal on mal.id_origen = ra.idPlan
            where isnull(maa.id_malla_asignatura,0) not in (select d.idMallaAsignatura from @tempRecordAsignaturas as d)
              --quitar si se daña para no mostrar doble record en los casos de doble record en la misma carrera pr cambio de malla  17-02-2025
              and (mal.id_malla is null
                       or  mal.id_malla in (select estudiante_oferta.id_malla from aca.estudiante_oferta where id_estudiante_oferta = @id_estudiante_oferta)
                       --Agregar condicion de mallas antiguas de 10 semestres en sga (E y T)
--                   or mal.id_malla in (32)
                  or (mal.id_malla is not null and @id_estudiante_oferta is null)
                  )
              --------
                and ((isnull(ra.idPeriodo,0)  <28470) or (isnull(ra.idPeriodo,0)= 28470 and ra.tipo<>'ASIGNATURA' ))
        end

    select t.idNivel, idNivelSw, nivel,
--             case --when t.nivel in ('PRIMER AÑO','SEGUNDO AÑO','TERCER AÑO','CUARTO AÑO','QUINTO AÑO') then t.nivel
--                 when t.nivel in('GENERAL','V','I','II','III','IV','VI','VII','MODULOS')  or t.nivel is null
--                     then 'MÓDULOS' else t.nivel end as nivel,
            idEstudianteAsignatura, idMateriaTomada, idMallaAsignatura, idMateriaPlan, idMalla,
            idPlan, asignatura, valorMalla, promedio, asistencia, estadoAsignatura, tipo, estadoAprobado, aprobado, periodo,
            idPeriodoAcademico, idPeriodoAcademicoSw,isnull(n.orden,11) as orden, origen,(select avg(tt.promedio) from @tempRecordAsignaturas as tt
                                                                                                   ) as promedio_final from @tempRecordAsignaturas t
    left join aca.nivel n on n.id_nivel = t.idNivel
    where t.tipo<>'MODULAR'
    ORDER BY t.idNivel,t.orden

end

select * from Bd_Academico..PLAN_ESTUDIOS where ID_PLAN =10621

select * from migracion_sga..entidades_migracion

select * from aca.malla where id_malla = 39


select * from aca.estudiante_matricula where id_estudiante_oferta = 24164
select * from aca.matricula_rubro where id_estudiante_matricula = 53710
select * from aca.estudiante_asignatura where id_estudiante_matricula = 53710
select * from aca.estudiante_asignatura where id_estudiante_asignatura = 262482
select * from man.personas where identificacion='1600494106'
-- select * from man.personas where apellidos like '%LOOR PINARGOTE%' and
--                                  nombres like '%YAZKHIN%'
select * from man.personas where apellidos like '%Reyes Reyes%' and
                                 nombres like '%Genesis Nayeli%'




select * from aca.tipo_estado_estudiante

exec [aca].[sp_list_all_asignaturas_detalle_record]   54390 ,  173 , '2024199300910'   ,'2450268996',  null  ,  '2024-1'  , null


exec [aca].[sp_list_all_asignaturas_detalle_record] 3205,null,null,
    null,null,null,null

exec [aca].[sp_list_all_asignaturas_detalle_record] null,50,'12018590624',
    '2400448524',null,null,null

select * from aca.malla where id_malla in (33,34)

exec [aca].[sp_list_all_asignaturas_detalle_record] 3205,50,'12018590624',
    '2400448524',null,null,null


select * from man.personas

select *from aca.estudiante_oferta eo where eo.id_estudiante_oferta = 45361

select * from aca.estudiante_oferta where id_estudiante_oferta in (45376)

select *from pro.postulacion_vacante where id_postulacion_vacante = 650

select *from aca.tipo_estado_estudiante

select * from aca.ofertas_facultad


select * from aca.periodo_academico

select *from  [aca].[fn_listar_docentes_asignaturas](null,104,95) as d
where d.idMallaAsignatura in (1911,1920,1934) and d.idParalelo = 2

select *from  [aca].[fn_listar_docentes_asignaturas](25236,null,30) as d
where d.idMallaAsignatura in (1444) and d.idParalelo = 2

select *from aca.estudiante_matricula where id_estudiante_oferta = 45505

select * from aca.matricula_rubro where id_estudiante_matricula = 53730

select * from aca.estudiante_asignatura where id_estudiante_asignatura = 261752

select *from aca.estudiante_asignatura where id_estudiante_matricula = 53730

select * from man.personas where identificacion ='1712263100'

select * from aca.tipo_matricula_fecha


select * from aca.malla_asignatura ma where ma.id_malla_asignatura = 803


exec [aca].[sp_list_all_carreras_records]  '2400011413' ,null,null,  null,null
 exec  [aca].[sp_list_all_asignaturas_detalle_record]    4910, 110  , '12019571664'  , '2450308172'
  ,  7 , null ,null

exec [aca].[pa_generar_asignaturas_a_matricular_sga] 3824,30,2,1
exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 3824,30,2,1

exec [aca].[sp_list_all_carreras_records] '2400460941',null,null,null,null
exec bd_sga_upse.[aca].[sp_recordweb_materias_colum_aprob] 105,'12018521652','2400460941'
exec [aca].[sp_list_all_asignaturas_detalle_record] 28705,null,
    null,null,null,null,null
exec [aca].[pa_generar_asignaturas_a_matricular_sga] 28705,30,2,1
exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 28705,30,2,1

select * from aca.estudiante_asignatura where id_estudiante_asignatura= 244634

select * from aca.matricula_rubro where id_estudiante_matricula = 53237

select em.* from aca.estudiante_matricula em
 inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
 where id_estudiante_oferta = 24164 and mg.id_periodo_academico = 30

select * from aca.malla

select *from man.personas where identificacion='0928212950'


select * from aca.matricula_rubro where id_estudiante_matricula = 53695
exec [aca].[sp_list_all_asignaturas_detalle_record] null,29,
    '2005410151','0923561120',null,null,null

   declare  @id_estudiante_oferta int =  NULL, @id_carrera_ofertada int = 29, @matricula varchar(50)='2005410151',
        @identificacion_persona_origen as varchar(50)='0923561120', @id_periodo_academico int = 30

exec bd_sga_upse.[aca].[sp_recordweb_materias_colum_aprob] @id_carrera_ofertada,@matricula,@identificacion_persona_origen
    declare @tempRecordAsignaturasTemporal table (idTemp int IDENTITY(1,1),
        idNivel  NUMERIC(18,0),idNivelSw  NUMERIC(18,0),nivel  VARCHAR(20),
        idEstudianteAsignatura numeric(18,0),idMateriaTomada  NUMERIC(18,0),idMallaAsignatura  NUMERIC(18,0),idMateriaPlan  NUMERIC(18,0),
        idMalla  NUMERIC(18,0),idPlan  NUMERIC(18,0),asignatura  VARCHAR(500),valorMalla NUMERIC(18,0),promedio NUMERIC(18,0),
        asistencia  NUMERIC(18,4),estadoAsignatura VARCHAR(50),tipo  VARCHAR(100),estadoAprobado varchar(150),aprobado bit,periodo  VARCHAR(20),
        idPeriodoAcademico int,idPeriodoAcademicoSw int,orden int,origen varchar(50),promedio_final NUMERIC(18,0),esExcepcional bit,estado varchar(1)
    )

	declare @tempRecordAsignaturas table (id int IDENTITY(1,1),
        idNivel  NUMERIC(18,0),idNivelSw  NUMERIC(18,0),nivel  VARCHAR(20),
        idEstudianteAsignatura numeric(18,0),idMateriaTomada  NUMERIC(18,0),idMallaAsignatura  NUMERIC(18,0),idMateriaPlan  NUMERIC(18,0),
        idMalla  NUMERIC(18,0),idPlan  NUMERIC(18,0),asignatura  VARCHAR(500),valorMalla NUMERIC(18,0),promedio NUMERIC(18,0),
        asistencia  NUMERIC(18,4),estadoAsignatura VARCHAR(50),tipo  VARCHAR(100),estadoAprobado varchar(150),aprobado bit,periodo  VARCHAR(20),
        idPeriodoAcademico int,idPeriodoAcademicoSw int,orden int,origen varchar(50),promedio_final NUMERIC(18,0),esExcepcional bit,estado varchar(1)
    )

	declare @recordSisWeb table (idNivel numeric(9,0), nivel varchar(150), materia varchar(350), idMateriaTomada int,idMateriaPlan int,idPlan numeric,
                                                    creditosHora numeric(5,2),promedio numeric(5,2),asistencia numeric(5,2),estado varchar(25),tipo varchar(350),
                                                    aprobado varchar(150),periodo varchar(50),idPeriodo int, orden varchar(10))


      insert @tempRecordAsignaturasTemporal
        select n.id_nivel,null,n.descripcion,ea.id_estudiante_asignatura,null,ma.id_malla_asignatura,null,m.id_malla,null,a.descripcion as asignatura,
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
		where em.id_estudiante_oferta in (@id_estudiante_oferta) and eo.estado='A'
		and ea.estado='A'
		 and em.estado='A' and ma.estado='A' and m.estado in ('A','P') and n.estado='A'
		and a.estado='A'
		and (pa.id_periodo_academico not in(@id_periodo_academico) or pa.id_periodo_academico is null )
-- 		and (ea.aprobado = @aprobado or @aprobado is null)
-- 		and (n.id_nivel = @idNivel or @idNivel is null)
--         and (pa.codigo = @periodo or @periodo is null)
		and ca.codigo in (select d.codigoHijo from aca.fn_listar_componentes_aprendizajes_reglamento(mg.id_reglamento) as d
        )
		group by n.id_nivel,n.descripcion,a.descripcion,ea.id_estudiante_asignatura,ma.id_malla_asignatura,ea.aprobado,
		m.id_malla, m.tipo_plan , ma.num_horas , ma.num_creditos, mg.id_periodo_academico,ma.codigo_malla,ea.promedio,pa.codigo,ea.matricula_excepcional,ea.estado
		union
   		select n.id_nivel,null,n.descripcion,dm.id_detalle_movilidad,null,ma.id_malla_asignatura,null,m.id_malla,null,
   		       a.descripcion as asignatura,case when m.tipo_plan ='HORAS' then ma.num_horas else ma.num_creditos end as creditosHoras,
		isnull(dm.calificacion,0),0,'NORMAL',UPPER(sm.descripcion),'APROBADO',1 as aprobado,pa.codigo,pa.id_periodo_academico,null,ma.codigo_malla,'MOVILIDAD-SGA' as origen,
		0 as promedio_final,0 as matricula_excepcional,dm.estado
			from aca.movilidad mo
		inner join aca.detalle_movilidad dm on mo.id_movilidad = dm.id_movilidad
		inner join aca.malla_asignatura ma on ma.id_malla_asignatura = dm.id_malla_asignatura
		inner join aca.malla m on m.id_malla = ma.id_malla
		inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
		inner join aca.nivel n on n.id_nivel = ma.id_nivel
		inner join aca.subtipo_movilidad sm on sm.id_subtipo_movilidad = mo.id_subtipo_movilidad
		inner join aca.periodo_academico pa on pa.id_periodo_academico = mo.id_periodo_academico
		where mo.id_estudiante_oferta = @id_estudiante_oferta
-- 		and (n.id_nivel = @idNivel or @idNivel is null)
--         and (pa.codigo = @periodo or @periodo is null)
--         and (1 = @aprobado or @aprobado is null)
		and dm.estado='A' and ma.estado='A' and m.estado in ('A','P') and n.estado='A' and a.estado='A'
        order by id_nivel,codigo_malla,promedio
        if @id_estudiante_oferta is not null and @matricula is not null
        begin
			--'2022-2','2023-1'
            insert into @recordSisWeb exec bd_sga_upse.[aca].[sp_recordweb_materias_colum_aprob] @id_carrera_ofertada,@matricula,@identificacion_persona_origen
            insert @tempRecordAsignaturasTemporal
            select ra.idNivel,niv.id_nivel, --niv.nivel,
                   case when niv.nivel in('GENERAL','V','I','II','III','IV','VI','VII')  or niv.nivel is null then 'MÓDULOS' else niv.nivel end as nivel,
           null as idEstudianteAsignatura,ra.idMateriaTomada,isnull(maa.id_malla_asignatura,0) as id_malla_asignatura,ra.idMateriaPlan,
            isnull(mal.id_malla,0) as id_malla,ra.idPlan,ra.materia,ra.creditosHora,ra.promedio,ra.asistencia,ra.estado,ra.tipo,ra.aprobado,
            case ra.aprobado when 'APROBADO' then 1 else 0 end aprobado,ra.periodo,null as idPeriodo,idPeriodo as idPeriodoAcademicoSw,maa.codigo_malla,
			'SISWEB' as origen,
            0 as promedio_final,case when ra.periodo in ('2020-1','2020-2','2021-1','2021-2','2022','2022-1') then 1 else 0 end as  matricula_excepcional,'A' as estado
            from @recordSisWeb ra
            left join
                (select ma.id_malla_asignatura,rma.id_origen,rma.id_destino,ma.codigo_malla from migracion_sga..registros_migracion rma
            inner join aca.malla_asignatura ma on ma.id_malla_asignatura = rma.id_destino
            where rma.id_entidad_relacion in (5,29) ) as maa on maa.id_origen = ra.idMateriaPlan
            left join
                (select n.id_nivel,rn.id_origen,rn.id_destino,n.descripcion as nivel from migracion_sga..registros_migracion rn
            left join aca.nivel n on n.id_nivel = rn.id_destino
            where rn.id_entidad_relacion in (6) ) as niv on niv.id_origen = ra.idNivel
            left join
                (select m.id_malla,m.tipo_plan,rm.id_origen,rm.id_destino from migracion_sga..registros_migracion rm
            inner join aca.malla m on m.id_malla = rm.id_destino
            where rm.id_entidad_relacion in (4) ) as mal on mal.id_origen = ra.idPlan
			---++++++++++++++++++++++++++ condicion anterior descomentar en caso de fallas 13/09/2023
            --where maa.id_malla_asignatura not in (select d.idMallaAsignatura from @tempRecordAsignaturasTemporal as d)
			  where (mal.id_malla is null or mal.id_malla in (select d.idMalla from @tempRecordAsignaturasTemporal as d))
			----+++++++++++++++++++
			and ra.periodo not in ('2022-2','2023-1','2023-2')
        end

		insert @tempRecordAsignaturas
		select t.idNivel, idNivelSw, t.nivel,
-- 		case when t.nivel in('GENERAL','V','I','II','III','IV','VI','VII')  or t.nivel is null then 'MÓDULOS' else t.nivel end as nivel,
		idEstudianteAsignatura, idMateriaTomada, idMallaAsignatura, idMateriaPlan, idMalla,
		idPlan, asignatura, valorMalla, promedio, asistencia, estadoAsignatura, tipo, estadoAprobado, aprobado, periodo,
		idPeriodoAcademico, idPeriodoAcademicoSw,isnull(n.orden,11) orden, origen,0 as promedio_final,t.esExcepcional,t.estado from @tempRecordAsignaturasTemporal t
		left join aca.nivel n on n.id_nivel = t.idNivel
		where t.estado ='A'
		--and (t.idPeriodoAcademico not in(@id_periodo_academico) or t.idPeriodoAcademico is null )
		---***************************************** condicion anterior comentar en caso de fallas 13/09/2023
-- 		and t.idTemp not in (select aux.idTemp from @tempRecordAsignaturasTemporal aux where aux.periodo='2022-1' and aux.tipo='ASIGNATURA' and aux.origen='SISWEB' )
-- 		and t.nivel <>'MÓDULOS'
		------**************************************
		ORDER BY t.idNivel,t.orden

SELECT * from @tempRecordAsignaturas





select mp.id_malla,
               mh.id_malla    as idmallaHibrida,27,'1.- Presencial - 2.Hibrida', o.descripcion as carrera,'GUARDA LA RELACIÓN ENTRE LAS MALLAS PRESENCIALES E HÍBRIDAS',
               'A',0,getdate(),getdate(),'2400254286','2400254286'
    from aca.oferta_modalidad om
    inner join aca.malla mp on mp.id_oferta_modalidad = om.id_oferta_modalidad
    inner join aca.oferta o on o.id_oferta = om.id_oferta
    inner join aca.tipo_oferta tof on tof.id_tipo_oferta = o.id_tipo_oferta
    inner join aca.oferta_modalidad omh on omh.id_oferta = o.id_oferta and omh.id_modalidad = 4
    inner join aca.malla mh on mh.id_oferta_modalidad = omh.id_oferta_modalidad
    where om.id_modalidad = 1 and tof.codigo = 'PREGRADO'
        order by o.descripcion

--relaciones entre mallas_asignaturas
select * from aca.asignatura_compatibilidad
--relaciones entre asignaturas
select * from aca.compatibilidad_asignatura
select * from aca.estudiante_oferta where id_estudiante_oferta = 9979

select * from aca.tipo_estudiante

exec bd_sga_upse.[aca].[sp_recordweb_materias_colum_aprob] 108,'2022120100','2400400202'
exec aca.sp_recordweb_materias 108,'2022120100','2400400202'
select * from [aca].[fn_record_academico_sga_definitivo](10118,NULL,null,NULL)
exec  [aca].[pa_generar_asignaturas_a_tomar_siia_sisweb] 28705,30,1,664
exec  [aca].[pa_generar_asignaturas_a_tomar_siia_sisweb_pruebas] 28705,30,1,1
exec [aca].[pa_generar_asignaturas_a_matricular_sga] 28705,30,2,1
exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 28705,30,2,1


select identificacion,nombres,apellidos,celular from man.personas where apellidos like '%rosales pozo%' and nombres like '%luis javier%'
exec [aca].[sp_list_all_matriculas_carreras] '0953986510',null

exec [aca].[sp_list_all_carreras_records] '0928125814',null,null,null,null

exec [aca].[sp_list_all_asignaturas_detalle_record] 8400,108,
    '12021232376','0928125814',null,null,null

exec [aca].[sp_list_all_asignaturas_detalle_record] null,16,
    '12009522849','0910581636',null,null,null


SELECT * FROM Aca.estudiante_matricula where id_estudiante_oferta = 45332

select * from aca.estudiante_oferta where id_estudiante_oferta in (12608,13274,12913,13061)


select distinct em.*
from aca.estudiante_matricula em
-- inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
where em.id_estudiante_oferta = 24164 and mg.id_periodo_academico= 30

select * from aca.estudiante_matricula where id_estudiante_matricula = 45159

select * from [aca].[fn_listar_estudiantes_a_matricular](31,30) as d
where d.identificacion ='2450821745'
select * from aca.tipo_matricula_fecha

select * from aca.periodo_academico where id_tipo_oferta= 4
select * from aca.matricula_general

select * from aca.tipo_matricula_fecha


SELECT * FROM aca.malla where id_malla = 141

select * from aca.periodo_malla
where --id_periodo_malla in (336) or
    id_malla in (139,143)

select * from aca.relacion_oferta

select * from aca.relacion_oferta_detalle

select * from man.personas where apellidos like '%ORTIZ SAFADI%'

exec aca.sp_rpt_estudiantes_matriculados_por_asignatura 1469 , 27 ,  1

select dm.*
--     ma.id_malla_asignatura,a.descripcion,dm.calificacion,d.id_periodo_academico ,d.id_estudiante_oferta,d.identificacion ,d.nombres ,
-- 		d.id_malla_asignatura ,d.asignatura ,d.facultad ,d.carrera ,d.periodoAcademico ,d.paralelo
        from [aca].[fn_get_estudiantes_matriculados](null,1,1469 ,null ,null,27) as d
		inner join aca.movilidad mo on mo.id_estudiante_oferta = d.id_estudiante_oferta
		inner join aca.detalle_movilidad dm on mo.id_movilidad = dm.id_movilidad
	    inner join aca.malla_asignatura ma on ma.id_malla_asignatura = dm.id_malla_asignatura
		inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
        where ma.id_malla_asignatura = 1467
        and d.identificacion not in ('1726453564','0912777083','2450236035','0919790139','2400051674','2450098047','0928271568','2450303322','2400118457')
    order by d.nombres


select * from aca.fn_recuperar_datos_estudiante_logeado(7036)

select * from aca.fn_recuperar_datos_estudiante_matricular(8759)



 select --pa.id_periodo_academico,
        ea.*
    from aca.matricula_general mg
    inner join aca.estudiante_matricula em on em.id_matricula_general = mg.id_matricula_general
    inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
    inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join man.personas p on p.id = eo.id_persona
--     inner join aca.matricula_rubro mr on mr.id_estudiante_matricula = em.id_estudiante_matricula
--     inner join tes.rubro r on r.id_rubro = mr.id_rubro
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    where mg.id_periodo_academico = 34
    and eo.estado='A' and em.estado='A'
    and mg.estado='A' and om.estado='A' and do.estado='A' and pa.estado='A' and p.identificacion='2450781600'
--     group by pa.codigo,do.id_departamento_oferta,em.id_estudiante_matricula,eo.id_estudiante_oferta,MR.id_matricula_rubro,mr.observacion,mr.valor,r.codigo,r.descripcion

exec [aca].[sp_list_all_carreras_records]  '0925782468' ,null, null , null, null

 select --pa.codigo,
        mr.*
    from aca.matricula_general mg
    inner join aca.estudiante_matricula em on em.id_matricula_general = mg.id_matricula_general
    inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
    inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join man.personas p on p.id = eo.id_persona
    inner join aca.matricula_rubro mr on mr.id_estudiante_matricula = em.id_estudiante_matricula
--     inner join tes.rubro r on r.id_rubro = mr.id_rubro
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.departamento_oferta do on do.id_oferta = om.id_oferta
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    where --mg.id_periodo_academico = 27
     eo.estado='A' and em.estado='A' and p.identificacion='2450477407'
    and mg.estado='A' and om.estado='A' and do.estado='A' and pa.estado='A' and mr.estado='A'--and eo.id_estudiante_oferta = 23792


select * from tes.rubro


select * from aca.tipo_matricula_fecha


select pg.* from pro.proceso p
inner join pro.proceso_general pg on p.id_proceso = pg.id_proceso
where p.id_proceso = 2

select* from man.personas where celular ='0963909612' or telefono='0963909612'

select* from Bd_Academico..personas where celular ='0963909612' or telefono='0963909612'

select* from bdupse.aca.personas where celular ='0963909612' or telefono='0963909612'

select * from man.personas where apellidos like '%Sanchez mite%'


--eliminar materias repetidas de los records de adminstracion de empresas
 select pa.codigo,om.id_oferta_modalidad,o.descripcion,p.identificacion,p.apellidos,p.nombres,ma.id_nivel,ma.id_malla_asignatura,a.descripcion,ea.promedio
    from aca.matricula_general mg
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    inner join aca.estudiante_matricula em on em.id_matricula_general = mg.id_matricula_general
    inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
    inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
    inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
    inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
    inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join man.personas p on p.id = eo.id_persona
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.oferta o on om.id_oferta = o.id_oferta
    where eo.estado='A' and em.estado='A' and mg.estado='A' and om.estado='A' and pa.estado='A' and ea.estado='A'
    and pa.id_periodo_academico = 27 and om.id_oferta_modalidad = 91 and ma.id_nivel = 7 and ma.id_malla_asignatura = 1973 and ea.aprobado = 1
and eo.id_estudiante_oferta in (select m.id_estudiante_oferta from aca.movilidad m
inner join aca.detalle_movilidad dm on m.id_movilidad = dm.id_movilidad
where dm.estado='A' and m.estado='A' and dm.id_malla_asignatura = 1973 and m.id_periodo_academico = 27 and cast(dm.fecha_mod as date)=cast(getdate() as date))
order by p.apellidos,p.nombres


select dm.*  from aca.movilidad m
inner join aca.detalle_movilidad dm on m.id_movilidad = dm.id_movilidad
where dm.id_malla_asignatura = 1973 and m.id_periodo_academico = 27 and m.estado='A' and dm.estado='A'
and m.id_estudiante_oferta in ( select eo.id_estudiante_oferta
    from aca.matricula_general mg
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    inner join aca.estudiante_matricula em on em.id_matricula_general = mg.id_matricula_general
    inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
    inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
    inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
    inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
    inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join man.personas p on p.id = eo.id_persona
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.oferta o on om.id_oferta = o.id_oferta
    where eo.estado='A' and em.estado='A' and mg.estado='A' and om.estado='A' and pa.estado='A' and ea.estado='A'
    and pa.id_periodo_academico = 27 and om.id_oferta_modalidad = 91 and ma.id_nivel = 7 and ma.id_malla_asignatura = 1973 and ea.aprobado = 1)


select * from aca.matricula_general

select * from aca.periodo_academico

select * from aca.tipo_matricula_fecha


select p.id,p.identificacion,p.nombres,p.apellidos,u.id from man.personas p
inner join seg.usuarios u on p.id = u.persona_id
where p.identificacion ='2400255440'

select * from aca.matricula_fecha_nivel

-- SELECT DISTINCT p.IDENTIFICACION, p.APELLIDOS,P.NOMBRES,(SELECT -- cls.CODIGO as combo_codigo, cls.DESCRIPCION as combo_descripcion, cmb.CORRELATIVO, cmb.CODIGO,
--        cmb.VALOR_TEXTO
-- FROM dbo.TP_CODIGOS as cmb
-- inner join dbo.CLASIFICACIONES_GENERALES as cls on cmb.ID_CLASIFICACION = cls.ID_CLASIFICACION
-- where cmb.CORRELATIVO in (SELECT C.CG_Cargo FROM dbo.bd_Contratos)) as cargo,
--                 C.*
-- FROM dbo.bd_Contratos c
-- inner join BD_PERSONAL.dbo.PF_PERSONAS p on c.id_persona=p.ID_PERSONA WHERE c.EstadoContrato='A' and c.CG_Tipo_Trabajador not in (2969)
--                                                                       ORDER BY P.APELLIDOS

select pa.id_periodo_academico,pa.codigo,pa.descripcion from aca.periodo_academico pa
where pa.id_tipo_oferta = 2

select * from aca.matricula_fecha_nivel where id_tipo_matricula_fecha = 34

select * from aca.tipo_matricula_fecha


select * from pro.proceso_usuario where usuario_ing='2450118589'


select o.descripcion,p.identificacion,p.apellidos,p.nombres,eo.id_nivel_proyectado,tee.codigo,tee.observacion
from aca.estudiante_oferta eo
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
where --o.id_tipo_oferta = 2 and
      p.identificacion ='917511602' --and eo.id_tipo_estado_estudiante =1
--   and eo.id_tipo_estado_estudiante = 1 and eo.id_nivel_proyectado = 3

exec [aca].[sp_list_all_carreras_records] '0928144633',null,null,null,null

exec [aca].[sp_migrate_estudiantes_movilidad_to_new_carrera] 35,5,'0928144633'


--eliminar movilidad
select * from aca.movilidad where id_estudiante_oferta = 56459

select dm.* from aca.detalle_movilidad  dm
inner join aca.movilidad m on dm.id_movilidad = m.id_movilidad
where m.id_estudiante_oferta = 30357

EXEC   [aca].[sp_rpt_total_matriculados_por_ofertas] 35,null

select * from pro.etapa_evaluaciones

select * from pro.proceso_calendario

exec [aca].[sp_list_all_asignaturas_detalle_record] 45214,176,
     '2023290300285','0928271634',null,null,null







select tmf.* from aca.tipo_matricula_fecha tmf
inner join aca.matricula_general mg on tmf.id_matricula_general = mg.id_matricula_general
where mg.id_periodo_academico = 96
select * from aca.matricula_general


exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 9905,96,1,59263
exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 54960,140,1,664
exec [aca].[pa_generar_asignaturas_a_matricular_sga] 54960,140,1,664
exec [aca].[pa_generar_asignaturas_a_matricular_sga] 54960,140,1,664
select * from aca.periodo_academico_oferta where id_periodo_academico = 92

select dm.* from aca.detalle_movilidad dm
inner join aca.movilidad m on dm.id_movilidad = m.id_movilidad
where m.id_estudiante_oferta = 92749

exec [aca].[sp_list_all_carreras_records] '2450188731',null,null,null, null


select * from aca.fn_get_all_offers('2450618208',null,null,null,null,null)

select * from mig.record_oferta where identificacion='2400039232'
select * from mig.record_oferta_jerarquia where id_record_origen = 15439

exec [aca].[sp_list_all_asignaturas_detalle_record]  26471 , 177 , '12020151952'   , '2450921479'
    ,  null ,  null , null

select * from pro.proceso_usuario where usuario_ing='2400240624'

select * from aca.tipo_ingreso_estudiante

select * from aca.matricula_rubro where id_rubro = 9 and estado='I'

select * from pro.tipo_proceso_estado

select
eo.id_estudiante_oferta,eo.id_periodo_academico,om.carrera,om.facultad,p.identificacion,p.apellidos,p.nombres,eo.id_nivel_proyectado,eo.mantiene_gratuidad,tee.descripcion,tie.descripcion,eo.estado
--     eo.*
     from aca.estudiante_oferta eo
--     inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
--     inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
--     inner join aca.matricula_rubro mr on em.id_estudiante_matricula = mr.id_estudiante_matricula
--     inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
inner join man.personas p on eo.id_persona = p.id
inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
where --eo.id_oferta_modalidad = 31 and eo.id_tipo_estado_estudiante = 1 and eo.id_nivel_proyectado in (5,6,7)
  om.id_tipo_oferta = 1 and--and eo.id_tipo_estado_estudiante = 1 and eo.id_nivel_proyectado is null
p.identificacion in ('0804067148'
)
order by eo.id_persona,eo.fecha_ingreso
--and mg.id_periodo_academico = 35

select * from aca.clase

select * from aca.clases_asistencia


select * from aca.silabo_componente

select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 1

select * from aca.tipo_estado_estudiante

select top 2832 * from aca.estudiante_oferta
order by id_estudiante_oferta desc

update aca.estudiante_oferta set id_nivel_proyectado = 1 where id_estudiante_oferta between 86141 and 88971

--2831 nuevos estudiantes a 1er semestre
exec [aca].[sp_migrate_estudiantes_nivelacion_to_pregrado] 126

select * from man.personas where identificacion ='43.596.636'
select * from man.tipo_identificacion
select * from man.lugar where descripcion like '%ARGENTINA%'

select * from aca.ofertas_facultad where id_oferta_modalidad in (97,80,89)

select * from aca.malla where id_malla=22

select d.nombre,o.descripcion,
			eo.id_estudiante_oferta,u.id as id_usuario,p.id as id_persona,p.identificacion,
			p.nombres,p.apellidos,eo.id_oferta_modalidad,
			ore.idOfertaModalidadPregrado, m.id_malla, eo.mantiene_gratuidad as mantiene_gratuidad
			from man.personas p
			inner join aca.estudiante_oferta eo on eo.id_persona = p.id
			inner join rel.fn_relaciones_ofertas_nivelacion_grado(126) ore on ore.idOfertaModalidadNivelacion = eo.id_oferta_modalidad
			left join aca.estudiante_oferta eopre on eopre.id_oferta_modalidad = ore.idOfertaModalidadPregrado and eopre.id_persona = p.id
            inner join aca.malla m  on m.id_oferta_modalidad = ore.idOfertaModalidadPregrado and m.fecha_hasta is null
			inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
			inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
			inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
			inner join aca.periodo_academico pa on pa.id_periodo_academico =  mg.id_periodo_academico
			inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
			inner join aca.oferta o on o.id_oferta = om.id_oferta
			inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
			inner join man.departamentos d on d.id= do.id_departamento
			inner join seg.usuarios u on u.persona_id = p.id
			where  em.estado ='A' and pa.estado='A' and tee.codigo='ACT' and eo.estado='A' and pa.id_periodo_academico = 126
			and u.estado='AC' and eopre.id_estudiante_oferta is null
			--condicion nueva temporal hast que se borre las ofertas no vigentes
            and ore.idOfertaModalidadPregrado not in (97,80,89) and m.id_malla not in (22)
-- 			and p.identificacion ='2450754144'
			group by eo.id_estudiante_oferta,u.id,p.id,p.identificacion,p.nombres,p.apellidos,ore.idOfertaModalidadPregrado,
			em.id_estudiante_matricula, d.nombre,o.descripcion,eo.mantiene_gratuidad,u.usuario,eo.id_oferta_modalidad
			,ore.idOfertaModalidadPregrado,m.id_malla
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
			order by d.nombre,o.descripcion


select * from [tes].[fun_pagos_sgt] ('01/09/2020',GETDATE())
select * from mig.record_oferta where identificacion ='2450120098'

select * from pro.proceso_usuario where serie in ('PMI-CC00657','PMI-CC00896')

select  distinct dm.* from aca.movilidad m
         left join aca.detalle_movilidad dm on m.id_movilidad = dm.id_movilidad
         where m.id_estudiante_oferta=56471


select * from tes.rubro
select* from mig.record_oferta where identificacion='2400418931'

select * from aca.periodo_academico where id_periodo_academico = 127

select * from aca.matricula_rubro where id_estudiante_matricula = 69901
select * from aca.fn_buscar_nivel_proyectado(29633)
select * from aca.fn_buscar_nivel_proyectado_mov (29633)

select * from mig.record_oferta

select * from seg.boton

select * from seg.componente_botones_roles

select * from seg.componente_angular



select * from aca.estudiante_oferta where id_estudiante_oferta= 6818

select* from mig.record_oferta ro where ro.identificacion in ('2400418931') and ro.id_tipo_oferta = 2



select * from [pro].[fn_rpt_list_estudiantes_revision_comision] ( 124,35 )


select d.idProcesoUsuario,d.facultadDestino,d.carreraDestino,d.idEstudianteOfertaAnterior,d.idPersona,
       d.identificacion,d.estudiante,d.idOfertaModalidadNueva
from pro.fn_list_All_Estudiantes_Postulantes_By_Facultad(null,null,35) as d
where identificacion in ('0928025204')

select *
from pro.fn_list_all_responsables_by_periodo_departamento_ofera_rpt_firmas_posgrado(42, 10, 73)

select * from seg.usuarios where usuario='0913113189'


select * from aca.oferta

select *from aca.periodo_academico where id_tipo_oferta = 2

exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 9734,30,2,1

exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 30886,36,2,1

exec [aca].[pa_generar_asignaturas_a_matricular_sga] 30886,36,2,1



select * from aca.estudiante_asignatura where id_estudiante_asignatura in (378655,378656,370346)

select * from aca.matricula_rubro where id_estudiante_matricula = 73500

exec [aca].[sp_list_all_carreras_records] '2400393365',null,null,null, null

exec [aca].[sp_list_all_asignaturas_detalle_record]  1625 , 105 , '12017521229'   , '2450001199'
    ,  null ,  null , null

EXECUTE Bd_Academico..sp_record_notas_estudiantes_historico 105, '12017521229'




select * from Bd_Academico..VW_RECORD_ACADEMICO_TODO_MOVILIDAD rm where rm.matricula = '12017521229'

select  count (ra.idMallaAsignatura) from @tempRecordAsignaturas ra
where ra.idMallaAsignatura = 893  and ra.aprobado = 0
  and (ra.esExcepcional is  null or ra.esExcepcional = 0)


select * from aca.solicitud_cambio_paralelo;

WITH resumen_solicitudes AS (
    SELECT
        depa.nombre as facultad, offer.descripcion as oferta, niv.descripcion as nivel, niv.orden as ordenNivel,
        per.identificacion, concat(per.nombres, ' ', per.apellidos) as alumno,
        a.descripcion as asignatura,
        iif(scp.id_solicitud_cambio_paralelo_compatible is null, 1, 0) as pendientes,
        iif(scp.id_solicitud_cambio_paralelo_compatible is not null, 1, 0) as aprobado,
        scp.id_paralelo_origen as idOrigen, scp.id_paralelo_destino as idDestino
    FROM aca.solicitud_cambio_paralelo as scp
    INNER JOIN aca.estudiante_asignatura as ea on scp.id_estudiante_asignatura = ea.id_estudiante_asignatura AND ea.estado = 'A'
    INNER JOIN aca.asignatura_aprendizaje as aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje AND aa.estado = 'A'
    INNER JOIN aca.malla_asignatura as ma on aa.id_malla_asignatura = ma.id_malla_asignatura  AND ma.estado = 'A'
    INNER JOIN aca.asignatura as a on ma.id_asignatura = a.id_asignatura AND a.estado = 'A'
    inner join aca.nivel as niv on ma.id_nivel = niv.id_nivel AND niv.estado = 'A'
    inner join aca.planificacion_paralelo as pp on ma.id_malla_asignatura = pp.id_malla_asignatura AND pp.id_periodo_academico = 35 AND pp.estado = 'A'
    inner join aca.modalidad_asignatura as moda on ma.id_modalidad_asignatura = moda.id_modalidad_asignatura  AND moda.estado = 'A'
    INNER JOIN aca.malla as m on ma.id_malla = m.id_malla and m.estado in ('A', 'P')
    INNER JOIN aca.estudiante_matricula as em on ea.id_estudiante_matricula = em.id_estudiante_matricula AND em.estado = 'A'
    INNER JOIN aca.estudiante_oferta as eo on em.id_estudiante_oferta = eo.id_estudiante_oferta AND eo.estado = 'A'
    INNER JOIN aca.oferta_modalidad as om on eo.id_oferta_modalidad = om.id_oferta_modalidad AND om.estado = 'A'
    INNER JOIN aca.oferta as offer on om.id_oferta = offer.id_oferta AND offer.estado = 'A'
    INNER JOIN aca.departamento_oferta as do on offer.id_oferta = do.id_oferta AND do.estado = 'A'
    INNER JOIN man.departamentos as depa on do.id_departamento = depa.id AND depa.estado = 'AC'
    INNER JOIN man.personas as per on eo.id_persona = per.id AND per.estado = 'AC'

    where scp.estado = 'A'
)

SELECT facultad as Facultad, oferta as Oferta, nivel as Nivel,-- asignatura as Asignatura,
       identificacion as Identificacion, alumno as Estudiante,
       count(*) as TotalSolicitudes, sum(aprobado) as SolicitudesAprobadas, sum(pendientes) as SolicitudesPendientes
FROM resumen_solicitudes
WHERE --oferta LIKE 'GESTI%N SOCI%'
identificacion like '2400302770'
group by facultad, oferta, nivel, ordenNivel, --asignatura,
         identificacion, alumno
order by facultad, oferta, ordenNivel--, asignatura--, alumno




exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 9734,30,2,1

exec [aca].[pa_generar_asignaturas_a_matricular_sga] 8291,35,2,1
exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 8291,35,2,1

exec [aca].[sp_list_all_carreras_records] '2450836180',null,null,null,null

select rm.* from migracion_sga..entidades_migracion em
inner join migracion_sga..registros_migracion rm on rm.id_entidad_relacion = em.id
where em.id = 2


select --o.descripcion,p.identificacion,p.apellidos,p.nombres,eo.id_nivel_proyectado,
       ea.* from aca.estudiante_oferta eo
inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
inner join aca.matricula_rubro mr on em.id_estudiante_matricula = mr.id_estudiante_matricula
inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
inner join man.personas p on eo.id_persona = p.id
--                      inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
--                      inner join aca.oferta o on om.id_oferta = o.id_oferta
where  EO.id_estudiante_oferta= 8268
and mg.id_periodo_academico = 35
-- and em.id_estudiante_matricula = 53732
--   and aa.id_malla_asignatura = 663



select * from aca.nivel

select id_periodo_academico ,d.id_estudiante_oferta,d.id_estudiante_matricula ,identificacion ,	nombres ,d.id_malla_asignatura ,		asignatura
        ,nivel,
       case when ea.codigo_estado_matricula='PRI' then '1 VEZ' when ea.codigo_estado_matricula='SEG' then '2 VEZ' else '3 VEZ' end as vez,
       facultad ,carrera ,		periodoAcademico ,		paralelo
from [aca].[fn_get_estudiantes_matriculados](null ,null ,	null ,null,
		null,	35) as d
         inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = d.id_estudiante_matricula
         inner join aca.asignatura_aprendizaje aa on aa.id_malla_asignatura = d.id_malla_asignatura and ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
where ea.codigo_estado_matricula=  'TER'
--and
--d.identificacion='0928213388'
  and ea.estado ='A' and aa.estado ='A'
group by  id_periodo_academico ,d.id_estudiante_matricula ,identificacion ,nombres,d.id_malla_asignatura ,asignatura
        ,ea.codigo_estado_matricula,
    facultad ,carrera ,periodoAcademico ,paralelo,nivel,id_nivel,d.id_estudiante_oferta
order by facultad,carrera,id_nivel,paralelo,nombres

select *
--     d.id_estudiante_oferta as idEstudianteOferta, d.id_estudiante_matricula as idEstudianteMatricula,
--     d.id_oferta_modalidad as idOfertaModalidad,d.id_user as idUser, d.identificacion as identificacion, d.nombres as nombres,
--    d.codigo as ultimoPeriodo,d.estado_matricula as estadoMatricula, d.estadoMalla as estadoMalla
     from aca.fn_listar_estudiantes_a_matricular (80,35) as d

select  distinct c.CARRERA ,c.MODALIDAD
from niv.consultar_lista_Usuarios_cupos (37,1,null,
                                         null,null,null
         ,null,null,null) c

exec [aca].[sp_list_all_matriculas_carreras] '2450836180',null


exec [aca].[sp_list_all_carreras_records] '2400254286',null,null ,null, null

exec [aca].[sp_list_all_asignaturas_detalle_record]  1625 , 105 , '12017521229'   , '2450001199'
  ,  null ,  null , null

EXECUTE Bd_Academico..sp_record_notas_estudiantes_historico 105, '12017521229'


select * from (
                  select distinct p.identificacion, concat(p.apellidos,' ',p.nombres) estudiante,
                                  (select count(distinct ea2.id_asignatura_aprendizaje) from man.personas p2
                                                                                                 inner join aca.estudiante_oferta eo2 on p2.id = eo2.id_persona
                                                                                                 inner join aca.estudiante_matricula em2 on eo2.id_estudiante_oferta = em2.id_estudiante_oferta
                                                                                                 inner join aca.matricula_general mg2 on em2.id_matricula_general = mg2.id_matricula_general
                                                                                                 inner join aca.periodo_academico pa2 on mg2.id_periodo_academico = pa2.id_periodo_academico
                                                                                                 inner join aca.estudiante_asignatura ea2 on em2.id_estudiante_matricula = ea2.id_estudiante_matricula
                                   where pa2.id_periodo_academico=35 and p2.estado='AC' and eo2.estado='A' and em2.estado='A' and ea2.estado='A' and p.id=p2.id) materias_A
                          ,(
                                      select count(distinct ea3.id_asignatura_aprendizaje) from man.personas p3
                                                                                                    inner join aca.estudiante_oferta eo3 on p3.id = eo3.id_persona
                                                                                                    inner join aca.estudiante_matricula em3 on eo3.id_estudiante_oferta = em3.id_estudiante_oferta
                                                                                                    inner join aca.matricula_general mg3 on em3.id_matricula_general = mg3.id_matricula_general
                                                                                                    inner join aca.periodo_academico pa3 on mg3.id_periodo_academico = pa3.id_periodo_academico
                                                                                                    inner join aca.estudiante_asignatura ea3 on em3.id_estudiante_matricula = ea3.id_estudiante_matricula
                                      where pa3.id_periodo_academico=35 and p3.estado='AC' and eo3.estado='A' and em3.estado='A' and ea3.estado='T' and p3.id=p.id
                                  ) materias_T from man.personas p
                                                        inner join aca.estudiante_oferta eo on p.id = eo.id_persona
                                                        inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
                                                        inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
                                                        inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
                  where pa.id_periodo_academico=35 and p.estado='AC' and eo.estado='A' and em.estado='A') sub where sub.materias_A <> sub.materias_T and sub.materias_T >0


select ea2.id_asignatura_aprendizaje, ea2.estado,ea2.id_paralelo,ea2.id_estudiante_asignatura,p2.id,a2.descripcion from man.personas p2
inner join aca.estudiante_oferta eo2 on p2.id = eo2.id_persona
inner join aca.estudiante_matricula em2 on eo2.id_estudiante_oferta = em2.id_estudiante_oferta
inner join aca.matricula_general mg2 on em2.id_matricula_general = mg2.id_matricula_general
inner join aca.periodo_academico pa2 on mg2.id_periodo_academico = pa2.id_periodo_academico
inner join aca.estudiante_asignatura ea2 on em2.id_estudiante_matricula = ea2.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa2 on ea2.id_asignatura_aprendizaje = aa2.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma2 on aa2.id_malla_asignatura = ma2.id_malla_asignatura
inner join aca.asignatura a2 on ma2.id_asignatura = a2.id_asignatura
where pa2.id_periodo_academico=35 and p2.estado='AC' and eo2.estado='A' and em2.estado='A' and ea2.estado='A' and p2.identificacion='2450395880'


select ea3.id_asignatura_aprendizaje, ea3.estado,ea3.id_paralelo,ea3.id_estudiante_asignatura,p3.id,a3.descripcion from man.personas p3
inner join aca.estudiante_oferta eo3 on p3.id = eo3.id_persona
inner join aca.estudiante_matricula em3 on eo3.id_estudiante_oferta = em3.id_estudiante_oferta
inner join aca.matricula_general mg3 on em3.id_matricula_general = mg3.id_matricula_general
inner join aca.periodo_academico pa3 on mg3.id_periodo_academico = pa3.id_periodo_academico
inner join aca.estudiante_asignatura ea3 on em3.id_estudiante_matricula = ea3.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa3 on ea3.id_asignatura_aprendizaje = aa3.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma3 on aa3.id_malla_asignatura = ma3.id_malla_asignatura
inner join aca.asignatura a3 on ma3.id_asignatura = a3.id_asignatura
where pa3.id_periodo_academico=35 and p3.estado='AC' and eo3.estado='A' and em3.estado='A' and ea3.estado='T' and p3.identificacion='2450395880'

exec [aca].[sp_list_all_carreras_records] '2450001199',null,'12017521229' ,105, 1625

exec [aca].[sp_list_all_asignaturas_detalle_record]  11006 , 105 , '12017521229'   , '2450001199'
    ,  null ,  null , null





select id_periodo_academico ,d.id_estudiante_matricula ,identificacion ,	nombres ,d.id_malla_asignatura ,		asignatura
        ,nivel,
       case when ea.codigo_estado_matricula='PRI' then '1 VEZ' when ea.codigo_estado_matricula='SEG' then '2 VEZ' else '3 VEZ' end as vez,
       facultad ,carrera ,		periodoAcademico ,		paralelo
from [aca].[fn_get_estudiantes_matriculados](8,1 ,	695 ,29,
		5,		35) as d
         inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = d.id_estudiante_matricula
         inner join aca.asignatura_aprendizaje aa on aa.id_malla_asignatura = d.id_malla_asignatura and ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
where ea.codigo_estado_matricula= 'SEG'
--and
--d.identificacion='0928213388'
  and ea.estado ='A' and aa.estado ='A'
group by  id_periodo_academico ,d.id_estudiante_matricula ,identificacion ,nombres,d.id_malla_asignatura ,asignatura
        ,ea.codigo_estado_matricula,
    facultad ,carrera ,periodoAcademico ,paralelo,nivel,id_nivel
order by facultad,carrera,id_nivel,paralelo,nombres

select --pao.id_periodo_academico,om.id_oferta_modalidad,o.descripcion
--        o.descripcion,
       pao.*
from aca.periodo_academico_oferta pao
         inner join aca.oferta_modalidad om on pao.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
where pao.id_periodo_academico = 36 and pao.estado='A' --and pao.id_oferta_modalidad in (84,96,97)
order by o.descripcion

select --pao.id_periodo_academico,om.id_oferta_modalidad,o.descripcion
--        o.descripcion,
       pao.*
from aca.periodo_academico_oferta pao
         inner join aca.oferta_modalidad om on pao.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
where o.id_tipo_oferta = 4
order by o.descripcion

select * from aca.periodo_academico where id_tipo_oferta =2
-- DBCC CHECKIDENT ('man.documentos_ubicacion', RESEED, 11);
GO
select * from man.documentos_ubicacion

exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 61902,38,2,1
exec [aca].[pa_generar_rubros_a_cobrar_siia_sisweb] 71874,38,2


select p.identificacion,p.apellidos,p.nombres,o.descripcion,eo.id_periodo_academico
--         eo.id_malla,ma.id_malla,
--         dm.*
from aca.estudiante_oferta eo
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante --and tee.id_tipo_estado_estudiante= 1
--             inner join aca.movilidad m on eo.id_estudiante_oferta = m.id_estudiante_oferta
--             inner join aca.detalle_movilidad dm on m.id_movilidad = dm.id_movilidad
--             inner join aca.malla_asignatura ma on dm.id_malla_asignatura = ma.id_malla_asignatura
where o.id_tipo_oferta = 1 and
    p.identificacion='0928121987'

select ma.id_malla,ma.id_malla_asignatura,a.descripcion from aca.malla_asignatura ma
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura where ma.id_malla = 145

select ma.id_malla,ma.id_malla_asignatura,a.descripcion from aca.malla_asignatura ma
 inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura where ma.id_malla = 78
and ma.id_malla_asignatura in (1580,1581,1582,1584,1585,1588 )


select * from aca.movilidad where id_movilidad = 7401

select * from aca.detalle_movilidad dm where id_movilidad = 7401

select * from aca.subtipo_movilidad


select * from aca.tipo_matricula_fecha



--5981
-- update aca.estudiante_asignatura set estado='P' where estado='T'

select * from aca.estudiante_asignatura where estado='T'


select * from aca.periodo_academico where id_tipo_oferta = 2

select p.identificacion,p.apellidos,p.nombres,o.descripcion,
       eo.* from aca.estudiante_oferta eo
                     inner join man.personas p on eo.id_persona = p.id
                     inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
                     inner join aca.oferta o on om.id_oferta = o.id_oferta
                     inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
where o.id_tipo_oferta = 2 and tee.id_tipo_estado_estudiante =1 and eo.id_nivel_proyectado is null and eo.estado='A'

--id_tipo_estado_estudiante = 7 and o.id_tipo_oferta not in (1)


select * from aca.tipo_estado_estudiante

select pao.*--,o.descripcion,m.descripcion
from aca.periodo_academico_oferta pao
                      inner join aca.oferta_modalidad om on pao.id_oferta_modalidad = om.id_oferta_modalidad
                      inner join aca.oferta o on om.id_oferta = o.id_oferta
                        inner join aca.modalidad m on om.id_modalidad = m.id_modalidad
where pao.estado='A' and pao.id_periodo_academico =95 and pao.id_oferta_modalidad  in (20)

select * from man.personas where apellidos like '%ROVIRA JURADO%'

select * from aca.tipo_matricula_fecha

select * from aca.estudiante_oferta where cast(fecha_ing as date)='29-07-2024'

-- exec [aca].[sp_migrate_estudiantes_nivelacion_to_pregrado] 37




select p.identificacion,eo.* from aca.estudiante_oferta eo
inner join man.personas p on eo.id_persona = p.id
where cast(eo.fecha_ing as date)= cast(getdate() as date)

select distinct top 20  em.* from aca.estudiante_matricula em
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
where  em.estado='A'
order by em.id_estudiante_matricula desc

select distinct  em.* from aca.estudiante_matricula em
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
where mg.id_periodo_academico = 36 and ea.codigo_estado_matricula='TER'


select * from [aca].[fn_listar_docentes_asignaturas](67243,null,36)

select * from aca.acta_apertura_componente

select * from aca.acta_apertura

select aa.* from aca.docente_asignatura_aprend  daa
inner join aca.asignatura_aprendizaje aa on daa.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
where daa.id_docente_asignatura_aprend in (31702,31708)

select * from seg.roles where descripcion like '%CENTRO%'
--     {bcrypt}$2a$10$ZCc5q2mXhaRy33PM.sqw0.5VW27X/8.BKPEUA5f2Klo2PB8LMgjc.
select concat('{MD5}',Bd_Academico.[dbo].[fn_Md5] ('0914252614'))
select * from seg.usuarios where usuario='0914252614'

--     DBCC CHECKIDENT ('aca.acta_apertura_componente', RESEED, 802);
--
--     select top 50 *from aca.estudiante_matricula order by id_estudiante_matricula desc
----GUARDAR RESOLCIONES POR RETIRO PARCIAL O DEFINITIVO


select * from man.documentos_archivos da where id_documento_ubicacion>15

select top 3 * from man.documentos_archivos da order by da.id_documento_archivo desc


select * from man.documentos_ubicacion

SELECT * FROM aca.tipo_matricula

select pa.id_periodo_academico,tmf.* from aca.tipo_matricula_fecha tmf
inner join aca.matricula_general mg on tmf.id_matricula_general = mg.id_matricula_general
inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
where pa.id_tipo_oferta = 4

select * from man.documentos_archivos da where id_documento_ubicacion=18

select d.*  from aca.fn_datos_estudiante_matricula(36,10504) as d



--ofertas de estudiantes

-- select * from aca.tipo_estado_estudiante
--esta es la matriz para ver los manes en que periodo obtuvieron el cupo
select --eo.id_estudiante_oferta,p.identificacion,p.apellidos,p.nombres,o.descripcion,tee.descripcion,te.descripcion,tie.descripcion,eo.mantiene_gratuidad
eo.*
 from aca.estudiante_oferta eo
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante --and tee.id_tipo_estado_estudiante= 1
     inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
      inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
where --o.id_tipo_oferta = 2 and
      p.identificacion='0929013662'

select ro.descripcion,o.id_oferta,o.descripcion,p.identificacion,p.apellidos,p.nombres,ru.* from seg.usuarios u
inner join man.personas p on u.persona_id = p.id
inner join seg.roles_usuarios ru on u.id = ru.usuario_id
inner join seg.roles ro on ru.rol_id = ro.id
inner join seg.roles_usuario_oferta ruo on ru.id = ruo.rol_usuario_id
inner join aca.oferta o on ruo.oferta_id = o.id_oferta
where --ru.estado='AC' --and u.usuario='0918883950'
--  ru.rol_id = 27 and
      o.id_oferta in (25,59,48,49)



select * from aca.tipo_matricula_fecha

select * from aca.matricula_fecha_nivel

select * from rel.malla_relacion
select * from rel.fn_relaciones_ofertas_nivelacion_grado(24)

select * from aca.tipo_estudiante
select * from aca.tipo_ingreso_estudiante
select * from aca.tipo_estado_estudiante

select * from man.personas where identificacion in ('0924929466')

select * from man.personas where apellidos like '%NOROÑA%'


--DEJAR JOYA LAS MATRICULAS ANTERIORES
select d.* from (
select
    eo.id_estudiante_oferta,eo.id_periodo_academico,p.identificacion,p.apellidos,p.nombres,pa.codigo,o.descripcion,
    eo.mantiene_gratuidad,eo.id_malla,em.estado,--ea.estado,mr.estado,
    count( CASE WHEN ea.estado='R' THEN 1 END) AS materias_R,
    count(CASE WHEN ea.estado='N' THEN 1 END) AS materias_N,
    count(CASE WHEN ea.estado='X' THEN 1 END) AS materias_X,
    count(CASE WHEN ea.estado='Q' THEN 1 END) AS materias_Q,
    count(CASE WHEN ea.estado='P' THEN 1 END) AS materias_P,
    count(CASE WHEN ea.estado='E' THEN 1 END) AS materias_E,
    count(CASE WHEN ea.estado not in ('I','N','Q') THEN 1 END) AS materias
--     eo.*
from aca.estudiante_oferta eo
         inner join man.personas p on eo.id_persona = p.id
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
         inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
        inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
        inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
         inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
        inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
        left join aca.matricula_rubro mr on em.id_estudiante_matricula = mr.id_estudiante_matricula
where em.estado='A' and ea.estado not in ('I','N','Q')
--     eo.id_estudiante_oferta in (28356,31313)
-- and p.identificacion in ('2450765603',    '2450589078','0803792019','2450850918','0927960922','0928074277','2400343469','2450563487','0944328137','0927946244',
--                      '0928078567','2400034415','2400082497','2400105827','2450530411','0928238054'    )
and mg.id_periodo_academico = 95
group by eo.id_estudiante_oferta, eo.id_estudiante_oferta_padre, eo.id_periodo_academico, p.identificacion, p.apellidos, p.nombres, pa.codigo, o.descripcion,
         te.descripcion, tee.descripcion, tie.descripcion, eo.mantiene_gratuidad, eo.id_malla, em.estado--, ea.estado, mr.estado
) as d
where d.materias= d.materias_R


--Inactivar las matriculas
select distinct ea.* from aca.estudiante_matricula em
inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
-- inner join aca.matricula_rubro mr on em.id_estudiante_matricula = mr.id_estudiante_matricula
where em.id_estudiante_oferta in (31298
    ) and mg.id_periodo_academico = 95
and ea.estado not in ('I','Q')
select * from aca.tipo_ingreso_estudiante

select * from even.eventos

exec [aca].[pa_generar_asignaturas_a_matricular_sga] 45327,96,1,1
exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 45327,96,1,1

SELECT *
FROM aca.fn_record_academico_sga_definitivo(17285, NULL, '2025-1', NULL)
WHERE idMallaAsignatura = 309
SELECT *
FROM aca.fn_record_academico_sga_definitivo(17285, NULL, NULL, 0)
WHERE idMallaAsignatura = 309

SELECT *
FROM aca.fn_record_academico_sga_definitivo(17285, NULL, NULL, 0)
WHERE idMallaAsignatura = 309 and aprobado = 0

SELECT
    eo.id_estudiante_oferta,
    eo.numero_matricula,
    eo.id_nivel_proyectado,
    tee.descripcion AS estado_estudiante,
    p.identificacion,
    p.apellidos,
    p.nombres,
    CASE
        WHEN ra.total > 0 AND ra.aprobado = 0 THEN
            CONCAT('REPETIDOR (', ra.total + 1, 'ra vez)')
        ELSE
            'PRIMERA VEZ'
        END AS estado_asignatura
FROM man.personas p
         INNER JOIN aca.estudiante_oferta eo ON eo.id_persona = p.id
         INNER JOIN aca.tipo_estado_estudiante tee ON tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         INNER JOIN aca.ofertas_facultad om ON om.id_oferta_modalidad = eo.id_oferta_modalidad
-- Se omiten inner joins con asignatura para evitar duplicidad innecesaria
         LEFT JOIN (
    SELECT
        ra.idEstudianteOferta,
        COUNT(*) AS total,
        MAX(CAST(ra.aprobado AS INT)) AS aprobado
    FROM aca.fn_record_academico_sga_definitivo(eo.id_estudiante_oferta, NULL, NULL, NULL) ra
    WHERE ra.idMallaAsignatura = 316
    GROUP BY ra.idEstudianteOferta
) ra ON ra.idEstudianteOferta = eo.id_estudiante_oferta
WHERE eo.estado = 'A'
  AND eo.id_tipo_estado_estudiante = 1
  AND om.id_tipo_oferta = 2
  AND om.id_oferta_modalidad = 20
  AND (eo.id_nivel_proyectado + 1) = 7
GROUP BY
    eo.id_estudiante_oferta, eo.numero_matricula, eo.id_nivel_proyectado,
    tee.descripcion, p.apellidos, p.nombres, p.identificacion,
    ra.total, ra.aprobado;


select * from mig.listar_carreras_sisweb where identificacion ='1206892216'

select * from aca.estudiante_oferta where id_estudiante_oferta=65640

select * from aca.estudiante_matricula where id_estudiante_oferta = 65640

select * from aca.estudiante_oferta where id_estudiante_oferta in (45391,45392,45497,45498,45504,56796    )

select * from man.personas where identificacion='2400249450'

select * from aca.ofertas_facultad where id_tipo_oferta = 2

select * from man.departamentos where id>141

select * from mig.departamentos_migracion


select * from aca.periodo_academico

select * from aca.tipo_ingreso_estudiante
select * from aca.tipo_estado_estudiante
select id_periodo_academico,codigo,descripcion,id_periodo_academico_siguiente from aca.periodo_academico where id_tipo_oferta =2


select * from pro.proceso_etapa_ejecucion where id_proceso_usuario in (241,    1037    )
select * from aca.estudiante_oferta where id_estudiante_oferta = 1453
--     o.id_tipo_oferta = 1 and eo.id_periodo_academico = 126
--     eo.id_estudiante_oferta in (11206)
-- select distinct top 50  ofa.carrera,sm.descripcion,tm.descripcion,m.id_periodo_academico,m.id_estudiante_oferta,m.numero_documento,a.descripcion,ma.id_malla_asignatura,dm.fecha_ing
select distinct dm.*
from aca.movilidad m
inner join aca.subtipo_movilidad sm on m.id_subtipo_movilidad = sm.id_subtipo_movilidad
inner join aca.tipo_movilidad tm on sm.id_tipo_movilidad = tm.id_tipo_movilidad
         left join aca.detalle_movilidad dm on dm.id_movilidad = m.id_movilidad
         left join aca.malla_asignatura ma on dm.id_malla_asignatura = ma.id_malla_asignatura
         left join aca.asignatura a on ma.id_asignatura = a.id_asignatura
inner join aca.estudiante_oferta eo on m.id_estudiante_oferta = eo.id_estudiante_oferta
inner join man.personas p on eo.id_persona = p.id
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
where p.identificacion ='0916063233' and ofa.id_tipo_oferta=4
-- group by ofa.carrera, sm.descripcion, tm.descripcion, m.id_periodo_academico, m.id_estudiante_oferta, a.descripcion, ma.id_malla_asignatura, m.numero_documento, dm.fecha_ing

    select * from aca.subtipo_movilidad
--     58391
select * from seg.usuarios where id = 3892



select a.descripcion,ma.* from aca.malla_asignatura ma
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where ma.id_malla_asignatura in (1982) or (ma.id_malla = 29 and a.id_asignatura = 245)

select pg.id_periodo_academico,pa.codigo,scc.id_estudiante_oferta,scc.id_oferta_modalidad_nueva,ofa.carrera,ofa.modalidad,pu.* from pro.proceso_usuario pu
         inner join pro.proceso_general pg on pu.id_proceso_general = pg.id_proceso_general
        inner join pro.solicitud_cambio_carrera scc on scc.id_proceso_usuario = pu.id_proceso_usuario
    inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = scc.id_oferta_modalidad_nueva
                                    inner join aca.periodo_academico pa on pg.id_periodo_academico = pa.id_periodo_academico
         where pu.usuario_ing ='1311403123'





select o.ID_CARRERA_OFERTADA,d.ID_EGRESADO,d.ID_PERSONA,d.FECHA_INGRESO,d.FECHA_EGRESO,d.ESTADO,p.IDENTIFICACION,
       ROW_NUMBER() OVER (PARTITION BY d.ID_EGRESADO  ORDER BY d.FECHA_INGRESO asc ) as indice from Bd_academico.dbo.EG_EGRESADOS as d
inner join Bd_Academico..PERSONAS p on d.ID_PERSONA = p.ID_PERSONA
inner join Bd_Academico.dbo.carreras_locales_modalidad_sistema o on o.ID_CARRERA_LOCAL= d.ID_CARRERA_LOCAL and o.CG_MODALIDAD = d.CG_MODALIDAD
    and o.CG_SISTEMA_ESTUDIO = d.CG_SISTEMA_ESTUDIO where d.ESTADO='A' and p.IDENTIFICACION='2450801358'

select * from Bd_academico.dbo.EG_LISTADO_GRADUADOS as g where g.IDENTIFICACION='2450801358' or ID_EGRESADO = 5564

select * from Bd_Academico..PERSONAS p where IDENTIFICACION in ('FB612715','1006515715')
select * from man.PERSONAS p where IDENTIFICACION in ('FB612715','1006515715')
select * from man.persona_identificacion

select * from aca.estudiante_matricula where id_estudiante_oferta in (45672,
    45673
    )

select * from aca.estudiante_oferta where id_estudiante_oferta =9468

select * from aca.tipo_ingreso_estudiante

select * from aca.periodo_academico where id_tipo_oferta = 1

select * from man.personas where apellidos ='VALAREZO LUISA'

exec [aca].[sp_list_all_carreras_records]  '0302657689' ,null, null , null, null

exec [aca].[sp_list_all_asignaturas_detalle_record] null,43,'12014560695',
     '0302657689',null,null,null


select distinct mg.id_periodo_academico,em.* from aca.estudiante_matricula em
inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
where id_estudiante_oferta = 18420 --and em.id_matricula_general = 31

select * from aca.estudiante_oferta where id_oferta_modalidad =96 and id_periodo_academico = 95

select * from man.personas where direccion='Argentina'

select * from man.tipo_identificacion

select distinct top 15  dm.*
--     a.descripcion,p.apellidos,p.nombres
from aca.movilidad m
inner join aca.detalle_movilidad dm on dm.id_movilidad = m.id_movilidad
inner join aca.malla_asignatura ma on dm.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
-- inner join man.personas p on p.identificacion = dm.usuario_ing
where m.id_estudiante_oferta = 1134
order by dm.id_movilidad desc

--     18429
-- 40903

select * from aca.matricula_general
select * from aca.tipo_matricula_fecha

select * from aca.periodo_academico where id_tipo_oferta = 4

select * from aca.asignatura_compatibilidad ac

select * from aca.estudiante_oferta where id_estudiante_oferta = 29166
select * from aca.tipo_estado_estudiante
select * from aca.tipo_estudiante
exec [aca].[pa_generar_asignaturas_a_matricular_sga] 56516,136,1,1
exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 56516,136,1,1

exec [aca].[pa_generar_asignaturas_a_matricular_sga] 78712,136,1,1
exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 78712,78712,1,1

select d.idDocAsigAprend,d.idAsignaturaAprendizaje,d.idParalelo,d.idDocente,ac.id_malla_asignatura,d.asignatura,
        d.orden,concat(d.nombreDocente,' - ',o.descripcion) as docente,d.numEstudiantes,d.numMatriculados,d.codigoComponente,d.idDistributivoDocente
        from  [aca].[fn_listar_docentes_asignaturas_respaldo] (65058,null,95) as d
        left join aca.asignatura_compatibilidad ac on ac.id_malla_asignatura_comp= d.idMallaAsignatura
        inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = d.idAsignaturaAprendizaje
        inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
        inner join aca.malla m on m.id_malla = ma.id_malla
        inner join aca.oferta_modalidad om on om.id_oferta_modalidad= m.id_oferta_modalidad
        inner join aca.oferta o on o.id_oferta = om.id_oferta
        where ac.estado='A' and aa.estado='A' and ma.estado='A' and m.estado in ('A','P') and om.estado='A' and o.estado='A'
		order by d.orden,d.asignatura,d.idParalelo,ma.id_malla_asignatura



select top 5 * from aca.estudiante_asignatura where id_estudiante_matricula = 131314 order by id_estudiante_asignatura desc

select * from aca.estudiante_matricula where id_estudiante_matricula = 131314

select * from aca.matricula_rubro where id_estudiante_matricula = 131314

select * from  [aca].[fn_listar_docentes_asignaturas_other_carreras] (65055,95) as d
--     13837	1	859	2863	FISICA II	2	2/1  QUINTERO CUERO GUSTAVO RICARDO
select * from aca.fn_listar_docentes_asignaturas(44003,null,95) as d
select * from aca.fn_listar_docentes_asignaturas(null,34,95) as d

--estudiantes de las carreras
-- 34	34	INGENIERÍA INDUSTRIAL - MATRIZ
-- 37	37	PETRÓLEOS - MATRIZ
-- 83	83	SEGURIDAD INDUSTRIAL - MATRIZ

select * from aca.ofertas_facultad where id_tipo_oferta = 2 and id_departamento = 11

select * from aca.tipo_matricula_fecha


select * from pro.proceso_usuario2

select * from pro.proceso_general

select * from aca.asignatura_compatibilidad
select * from aca.fn_listar_docentes_asignaturas(null,96,95) as d
where d.orden =5
begin
    declare @id_asignatura_aprendizaje int = 7100,@id_oferta_modalidad int =96
    select ea.* from aca.estudiante_asignatura ea
    inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
    inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
    where ea.id_estudiante_matricula in (
    select top 4 aux.id_estudiante_matricula from (
                                                    select  mg.id_matricula_general,o.descripcion, om.id_oferta_modalidad, em.id_estudiante_oferta,-- ea.id_asignatura_aprendizaje,
                                                    em.id_estudiante_matricula,ea.id_paralelo, id_nivel,
                                                    count(ea.id_estudiante_asignatura) as cantidad
                                                    from aca.matricula_general mg
                                                    inner join aca.estudiante_matricula em on mg.id_matricula_general=em.id_matricula_general
                                                    inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
                                                    inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
                                                    inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
                                                    inner join aca.estudiante_oferta eo on em.id_estudiante_oferta=eo.id_estudiante_oferta
                                                    inner join aca.oferta_modalidad om on eo.id_oferta_modalidad=om.id_oferta_modalidad
                                                    inner join aca.oferta o on om.id_oferta=o.id_oferta
                                                    where mg.estado='A' and em.estado='A' and ea.estado='A' and eo.id_oferta_modalidad=@id_oferta_modalidad
                                                    and mg.id_periodo_academico=95
                                                    -- and ma.id_malla_asignatura in (2837,
                                                    -- 2838,
                                                    -- 2839,
                                                    -- 2861
                                                    -- )
                                                     AND ea.id_asignatura_aprendizaje   IN (@id_asignatura_aprendizaje
                                                   ) --and ea.codigo_estado_matricula IN ('SEG', 'TER')
                                                    and ma.id_nivel=5
                                                    and ea.id_paralelo=2
                                                    group by mg.id_matricula_general, o.descripcion ,om.id_oferta_modalidad, em.id_estudiante_oferta, em.id_estudiante_matricula, ma.id_nivel,ea.id_paralelo -- ea.id_asignatura_aprendizaje
                                                    ) as aux
        group by aux.id_matricula_general, aux.descripcion ,aux.id_oferta_modalidad, aux.id_estudiante_oferta, aux.id_estudiante_matricula
        order by aux.id_estudiante_matricula desc
        -- order by aux.id_estudiante_matricula desc
    ) AND ea.id_asignatura_aprendizaje   IN (@id_asignatura_aprendizaje
)
    -- and id_malla_asignatura in (2837,
-- 2838,
-- 2839,
-- 2861
-- )

end
-- select mg.id_reglamento from aca.matricula_general mg where mg.id_periodo_academico = 95
---------codigo inicio
begin
declare @pi_id_periodo_academico int = 95
select distinct  daa.id_docente_asignatura_aprend,aa.id_asignatura_aprendizaje,pl.id_paralelo,aux.id_docente,ac.id_malla_asignatura,ac.id_malla_asignatura_comp,asig.descripcion,n.orden,
-- 		concat(n.descripcion_corta ,'/', pl.descripcion_corta,' DOCENTE ASIGNADO') as docente ,
                 concat(n.descripcion_corta ,'/', pl.descripcion_corta,'  ' ,aux.nombres,' - ',ofas.carrera) as docente ,ofas.id_oferta_modalidad,ofa.id_oferta_modalidad,
                 daa.num_estudiantes,
                 isnull([aca].[fn_esc_get_numero_estudiantes_matriculados_by_asignatura_paralelo](ma.id_malla_asignatura,
                  pl.id_paralelo,@pi_id_periodo_academico,null),0) as nuMatriculados,
                 co.codigo as cod,aux.id_distributivo_docente
from aca.malla m
left join aca.ofertas_facultad ofas on ofas.id_oferta_modalidad = m.id_oferta_modalidad
inner join aca.malla_asignatura ma on m.id_malla= ma.id_malla
inner join aca.asignatura asig on asig.id_asignatura = ma.id_asignatura
inner join aca.nivel n on ma.id_nivel = n.id_nivel
left join aca.asignatura_compatibilidad ac on ac.id_malla_asignatura_comp= ma.id_malla_asignatura and ac.estado='A'
Left join aca.malla_asignatura mac on mac.id_malla_asignatura = ac.id_malla_asignatura
left join aca.malla macc on macc.id_malla = mac.id_malla
left join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = macc.id_oferta_modalidad
inner join aca.asignatura_aprendizaje aa on aa.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.componente_aprendizaje co on  co.id_componente_aprendizaje = aa.id_componente_aprendizaje
inner join aca.docente_asignatura_aprend daa on daa.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje and daa.estado='A'
inner join aca.paralelo pl on daa.id_paralelo = pl.id_paralelo  and pl.estado='A'
inner join
     (
         select case when aux.id_docente is null THEN 'DOCENTE AÚN POR DEFINIR' ELSE concat(aux.apellidos,' ',aux.nombres) END as nombres,
                ddo.id_distributivo_docente,ddo.id_distributivo_oferta,aux.id_docente,pao.id_reglamento
         from aca.distributivo_oferta dio
                  inner join aca.periodo_academico_oferta pao on pao.id_periodo_academico_oferta = dio.id_periodo_academico_oferta
                  inner join aca.distributivo_docente ddo on ddo.id_distributivo_oferta = dio.id_distributivo_oferta
                  left join
              (
                  select d.id_docente,p.nombres,p.apellidos from aca.docente d
                                                                     inner join man.personas p on p.id = d.id_persona
                  where d.estado='A' and p.estado='AC'
              ) as aux on ddo.id_docente = aux.id_docente

         where  ddo.id_distributivo_oferta in ( select d.id_distributivo_oferta from [aca].[fn_distributivo_oferta_max]
                                             (95,'A'  ) as d) and pao.estado='A'
         --condicion para que agregue las asignaturas de las otras carreras
         group by aux.apellidos,aux.nombres, ddo.id_distributivo_docente,ddo.id_distributivo_oferta,aux.id_docente,pao.id_reglamento
     )
         as aux on aux.id_distributivo_docente =  daa.id_distributivo_docente
         left join
     (
         select daa.id_distributivo_docente, ma.id_malla_asignatura ,pl.id_paralelo,count (co.codigo) as cantidad
         from aca.malla_asignatura ma
                  inner join aca.malla mal on mal.id_malla = ma.id_malla
                  inner join aca.nivel n on ma.id_nivel = n.id_nivel
                  inner join aca.asignatura_aprendizaje aa on aa.id_malla_asignatura = ma.id_malla_asignatura
                  inner join aca.docente_asignatura_aprend daa on daa.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                  inner join aca.paralelo pl on daa.id_paralelo = pl.id_paralelo
                  inner join aca.componente_aprendizaje co on  co.id_componente_aprendizaje = aa.id_componente_aprendizaje
         where  co.codigo in (select d.codigoHijo from aca.fn_listar_componentes_aprendizajes_reglamento(2) as d)
           and (daa.id_tipo_docente is null or daa.id_tipo_docente = 1)
           and daa.estado='A' and ma.estado='A' and aa.estado='A' and pl.estado='A' and co.estado='A'
         group by daa.id_distributivo_docente, ma.id_malla_asignatura  ,pl.id_paralelo
     )
         as auxx on auxx.id_distributivo_docente = daa.id_distributivo_docente and auxx.id_malla_asignatura=ma.id_malla_asignatura and auxx.id_paralelo=pl.id_paralelo
         LEFT JOIN aca.tipo_oferta as tof on n.id_tipo_oferta = tof.id_tipo_oferta
where
  --cambiar esta condicion en caso de postgrados si falla
    (
        (auxx.cantidad = 2 and co.codigo in
                               (select d.codigoHijo from aca.fn_listar_componentes_aprendizajes_reglamento(2) as d
                                where d.codigoPadre in ('DOCENCIA')
                               )) OR
        (auxx.cantidad = 1 and  co.codigo in (select d.codigoHijo from aca.fn_listar_componentes_aprendizajes_reglamento(2) as d))
            OR (tof.codigo = 'POSGRADO' and co.codigo in
                                            (select d.codigoHijo
                                             from aca.fn_listar_componentes_aprendizajes_reglamento(2) as d)
            )
        )
  AND  ma.estado='A' and aa.estado='A' and co.estado='A' and asig.estado='A' and n.estado='A'
  and ofa.id_oferta_modalidad in
      (--34
          37
--           ,83
      ) and ac.id_malla_asignatura is not null and ac.tipo in ('NUEVA_MALLA','COMPATIBILIDAD ENTRE CARRERAS')

end



select * from aca.tipo_matricula_fecha where id_matricula_general = 20

select * from aca.periodo_academico_oferta where id_oferta_modalidad = 1 and id_periodo_academico = 42

select * from aca.periodo_academico where id_tipo_oferta =3
select dm.* from aca.movilidad m
inner join aca.detalle_movilidad dm on m.id_movilidad = dm.id_movilidad
where m.id_estudiante_oferta = 79366
--       p.identificacion in ('1315340792','0929018406','2450226077')
--     9  XD
select * from aca.matricula_general

select * from aca.malla where id_oferta_modalidad = 20

select * from aca.tipo_matricula_fecha

select * from aca.matricula_fecha_nivel

select * from aca.estudiante_matricula where id_estudiante_oferta = 71676

select * from aca.matricula_rubro where estado='I'

SELECT pa.id_periodo_academico as idPeriodoActual, pa.descripcion as descripcion,mg.id_matricula_general as idMatriculaGeneral, pa.codigo as codigo,mg.matricula_nivel as matriculaNivel,
     tmf.fecha_desde,tmf.fecha_hasta as fechaHasta,tm.descripcion as descripcionTipoMatricula,tm.id_tipo_matricula as idTipoMatricula, tm.codigo as codigoTipoMat,tof.codigo as codigoTipoOferta,cast( CURRENT_TIMESTAMP as date)
     FROM aca.Periodo_Academico pa INNER JOIN aca.Matricula_General mg on mg.id_periodo_academico = pa.id_periodo_academico
     INNER JOIN aca.Tipo_Matricula_Fecha tmf on tmf.id_matricula_general = mg.id_matricula_general
    INNER JOIN aca.Tipo_Matricula tm on tmf.id_tipo_matricula = tm.id_tipo_matricula
    inner join aca.Tipo_Oferta tof on tof.id_tipo_oferta = pa.id_tipo_oferta
     WHERE pa.id_periodo_academico = 95 and  tmf.fecha_Hasta >= cast( CURRENT_TIMESTAMP as date)
    and tmf.fecha_Desde <= cast( CURRENT_TIMESTAMP as date)

select --p.identificacion,p.apellidos,p.nombres,o.descripcion,te.descripcion,tee.descripcion,tie.descripcion,eo.mantiene_gratuidad
       eo.*
from aca.estudiante_oferta eo
         inner join man.personas p on eo.id_persona = p.id
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
         inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
where o.id_tipo_oferta = 2 and eo.id_tipo_estudiante = 4 and eo.mantiene_gratuidad = 1

select em.*,p.identificacion from aca.estudiante_oferta eo
inner join man.personas p on eo.id_persona = p.id
inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
         where eo.id_estudiante_oferta in (71443,71680,71971)
select * from tes.rubro
select * from aca.ofertas_facultad where id_tipo_oferta =2

select * from man.personas where identificacion ='2450583782'

 SELECT * FROM pro.fn_list_postulantes_to_notificate_CMO(63, 1)

select * from  aca.estudiante_matricula where id_estudiante_oferta = 17742

select * from aca.malla where id_malla = 92

-- exec [aca].[sp_generate_datamart_sisweb] 1,1
select * from [aca].[fn_record_academico_sga_definitivo](38942,NULL,null,NULL)

exec aca.sp_generate_migracion_malla_presencial_to_hibrida_denifitiva 36,1


exec [aca].[pa_generar_asignaturas_a_matricular_sga] 75225,133,1,1
exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 75225,133,1,1

select * from aca.fn_listar_docentes_asignaturas (88895,null,136)

select * from aca.fn_listar_docentes_asignaturas (null,34,136)

select * from aca.tipo_matricula_fecha

select * from aca.tipo_estado_estudiante

select * from  [aca].[fun_record_ingles_estudiante]('0942079666')


-- DBCC CHECKIDENT ('aca.movilidad', RESEED, 7852);
-- DBCC CHECKIDENT ('aca.detalle_movilidad', RESEED, 107889);


select * from aca.movilidad

select * from aca.detalle_movilidad

select * from aca.tipo_oferta

select * from  man.documentos_archivos where serie='RESOL_TER_MATRICULA_0928274331_28174_TECNOLOGIAS DE LA INFORMACION - MATRIZ_2024-2'

select d.*  from aca.fn_datos_estudiante_matricula(36,10504) as d


--ver los manes que no tiene el estrado correcto al pasar a hibrido
select--eo.*
      eo.id_persona, eo.id_estudiante_oferta,eo.id_tipo_estado_estudiante,o.descripcion as carrera,p.identificacion,concat(p.apellidos,'',p.nombres),om.id_oferta_modalidad,omh.id_oferta_modalidad,
      eo.id_malla,m.id_malla    as idmallaHibrida,eoh.id_estudiante_oferta,eoh.id_tipo_estado_estudiante
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.oferta o on o.id_oferta = om.id_oferta
         inner join aca.tipo_oferta tof on tof.id_tipo_oferta = o.id_tipo_oferta
         inner join aca.oferta_modalidad omh on omh.id_oferta = o.id_oferta and omh.id_modalidad = 4
         inner join aca.estudiante_oferta eoh on eoh.id_persona = eo.id_persona and eoh.id_oferta_modalidad = omh.id_oferta_modalidad
         inner join aca.malla m on m.id_oferta_modalidad = omh.id_oferta_modalidad
         inner join aca.tipo_estado_estudiante tee
                    on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
where eo.estado = 'A'
  and om.estado = 'A'
  and tee.estado = 'A' --AND tee.codigo='ACT'
  and o.estado = 'A'
  and p.estado = 'AC'
  and om.id_modalidad = 1 and o.id_tipo_oferta = 2

---CAMBIAR DE PARALELOS
--repetidores de software en calculo de una variable
select distinct  ea.*
    --p.id, p.identificacion,p.apellidos,p.nombres,ma.id_malla_asignatura,a.descripcion as asignatura,ea.id_paralelo
from aca.estudiante_matricula em
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = em.id_estudiante_oferta
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.tipo_oferta tof on tof.id_tipo_oferta = o.id_tipo_oferta
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where mg.id_periodo_academico = 36 and ea.codigo_estado_matricula='SEG' and ea.estado='A' and em.estado='A'
and om.id_oferta_modalidad = 80 and ma.id_malla_asignatura = 2485

--     9405
--totales matriculados en software en calculo de una variable
select d.* from(
select distinct top 14   p.id, p.identificacion,p.apellidos,p.nombres,ma.id_malla_asignatura,a.descripcion as asignatura,ea.id_estudiante_asignatura,ea.id_paralelo,em.fecha_ing from aca.estudiante_matricula em
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = em.id_estudiante_oferta
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.tipo_oferta tof on tof.id_tipo_oferta = o.id_tipo_oferta
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where mg.id_periodo_academico = 36 and ea.codigo_estado_matricula='PRI' and ea.estado='A' and em.estado='A'
and om.id_oferta_modalidad = 80 and ma.id_malla_asignatura = 2485
order by em.fecha_ing desc) as d
inner join aca.estudiante_asignatura ea on ea.id_estudiante_asignatura = d.id_estudiante_asignatura


select top 5 * from aca.estudiante_asignatura where codigo_estado_matricula='SEG'

--actualizar repetidores de asignaturas mediante las mallas viejas

select  * from aca.matricula_rubro where id_matricula_rubro = 9 and usuario_ing ='2400254286' and cast(fecha_mod as date) = cast(getdate() as date)
-- DBCC CHECKIDENT ('aca.matricula_rubro', RESEED, 10181);

    select * from aca.matricula_rubro where estado='I' and id_rubro = 9
--acuassss
--4956 total sin filtros
--3013 filtrando las materias
--3003 filtrando rediseños
--333 filtrando solo materias repetidas en ambos records mallas viejas y nuevas
select distinct om.facultad,om.id_oferta_modalidad,om.carrera,om.modalidad,eo.id_estudiante_oferta,ea.id_estudiante_asignatura,ea.id_paralelo,ea.codigo_estado_matricula as vez,
                ma.id_malla_asignatura,a.descripcion as asignatura,--ac.id_malla_asignatura,
                p.identificacion,p.apellidos,p.nombres,eop.id_estudiante_oferta,concat(aux.carrera,' - ',aux.modalidad) as carrera_anterior,aux.asignatura,aux.vez,aux.aprobado,
                case aux.vez when 'PRI' then 'SEG' when 'SEG' then 'TER' end as newVez,ma.num_creditos*8

-- update ea set ea.codigo_estado_matricula =case aux.vez when 'PRI' then 'SEG' when 'SEG' then 'TER' end,
--               ea.usuario_mod ='2400254286', ea.fecha_mod = getdate(),ea.id_rubro=10,ea.valor_asignatura=ma.num_creditos*8
-- insert into aca.matricula_rubro
--     select distinct em.id_estudiante_matricula,9,10,'POR MATRICULA POR SEGUNDA VEZ EN UNA ASIGNATURA','A',0,getdate(),getdate(),'2400254286','2400254286'
from aca.estudiante_matricula em
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = em.id_estudiante_oferta
inner join man.personas p on eo.id_persona = p.id
inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
inner join aca.asignatura_compatibilidad ac on ac.id_malla_asignatura_comp = ma.id_malla_asignatura
inner join aca.estudiante_oferta eop on eop.id_estudiante_oferta = eo.id_estudiante_oferta_padre
inner join (select distinct om.facultad,om.id_oferta_modalidad,om.carrera,om.modalidad,eo.id_estudiante_oferta,ea.id_estudiante_asignatura,ea.id_paralelo,ea.codigo_estado_matricula as vez,
                ma.id_malla_asignatura,a.descripcion as asignatura,ea.aprobado,
                p.identificacion,p.apellidos,p.nombres
from aca.estudiante_matricula em
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = em.id_estudiante_oferta
inner join man.personas p on eo.id_persona = p.id
inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where mg.id_periodo_academico = 36 and ea.estado='A' and em.estado='A'
and om.id_oferta_modalidad in  (89,80,20,97)) as aux on aux.id_estudiante_oferta = eop.id_estudiante_oferta
and aux.id_malla_asignatura = ac.id_malla_asignatura
where mg.id_periodo_academico = 95 and ea.estado='A' and em.estado='A'
and om.id_oferta_modalidad in  (38,134,20,135)
-- order by om.facultad,om.carrera
-- --and ac.id_malla_asignatura is null

-- in (38,89,80,134,20,97,135)

--totales matriculados en software en calculo de una variable
select distinct o.descripcion as carrera,ma.id_nivel,ea.id_paralelo,
             concat(pu2.nombres, ' ', pu2.apellidos) as usuarioModificomatricula,count(ea.id_estudiante_asignatura) as numero_modificaciones
--     p.id, p.identificacion,p.apellidos,p.nombres,ma.id_malla_asignatura,a.descripcion as asignatura,ea.id_asignatura_aprendizaje,
--                 ea.id_docente,ea.id_paralelo,em.fecha_ing
from aca.estudiante_matricula em
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = em.id_estudiante_oferta
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.tipo_oferta tof on tof.id_tipo_oferta = o.id_tipo_oferta
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
left join seg.usuarios u on u.usuario = ea.usuario_ing
left join man.personas pu on pu.id = u.persona_id
left join seg.usuarios u2 on u2.usuario = ea.usuario_mod
left join man.personas pu2 on pu2.id = u2.persona_id
where mg.id_periodo_academico = 36 and ea.estado='A' and em.estado='A' and om.id_oferta_modalidad = 124
and cast(ea.fecha_ing as time(0))<>cast(ea.fecha_mod as time(0))
--and ma.id_nivel in (5,6,7,8)
  and ea.usuario_ing <>ea.usuario_mod
group by ma.id_nivel, ea.id_paralelo, pu2.nombres, pu2.apellidos, o.descripcion
-- order by em.fecha_ing desc

select cast('2024-07-30 08:15:58.6390000' as time(0))


select * from rel.fn_relaciones_ofertas_nivelacion_grado(37)

select distinct --om.id_oferta_modalidad,a.descripcion,
                ea.*
--     p.id, p.identificacion,p.apellidos,p.nombres,ma.id_malla_asignatura,a.descripcion as asignatura,ea.id_asignatura_aprendizaje,
-- ea.id_docente,ea.id_paralelo,em.fecha_ing
from aca.estudiante_matricula em
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = em.id_estudiante_oferta
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.tipo_oferta tof on tof.id_tipo_oferta = o.id_tipo_oferta
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where mg.id_periodo_academico = 36 and ea.estado='A' and em.estado='A'
and p.identificacion in ('45143587','44404915')
--2     159     1796



select * from seg.usuarios where usuario='1309091740'

select * from seg.roles_usuarios where usuario_id = 1615



select * from man.personas where identificacion='42361252'

--     0917668436
--     {bcrypt}$2a$10$q4sOFvPWcoKoYvNeSXGIXOSNp1S6llkoa87uwvMz5skMWP0G.YhRS
-- {MD5}83cb2441de8e0aeb455a4e38070a1912
select * from seg.usuarios where usuario='0917668436'
select concat('{MD5}',Bd_Academico.[dbo].[fn_Md5]('0917668436'))

select d.*  from aca.fn_datos_estudiante_matricula(38,34588) as d

select eo.id_estudiante_oferta,em.fecha_ing from aca.estudiante_matricula em
                                                     inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
where em.estado='A' and eo.estado='A'
  and em.id_estudiante_matricula in (select max(em1.id_estudiante_matricula) from aca.estudiante_matricula em1
                                                                                      inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
                                     where eo1.estado='A' and em1.estado='A' and eo1.id_estudiante_oferta = eo.id_estudiante_oferta)

select mr.*
--     eo.id_estudiante_oferta,mg.id_periodo_academico,eo.mantiene_gratuidad,p.identificacion,p.apellidos,p.nombres,o.descripcion, pa.descripcion as periodo,
--        r.descripcion,mr.valor,mr.estado
       from bd_sga_upse.aca.matricula_rubro mr
inner join bd_sga_upse.aca.estudiante_matricula em on mr.id_estudiante_matricula=em.id_estudiante_matricula
inner join bd_sga_upse.aca.matricula_general mg on mg.id_matricula_general=em.id_matricula_general
inner join bd_sga_upse.aca.estudiante_oferta eo on em.id_estudiante_oferta=eo.id_estudiante_oferta
inner join man.personas p on p.id= eo.id_persona
inner join bd_sga_upse.aca.oferta_modalidad om on om.id_oferta_modalidad=eo.id_oferta_modalidad
inner join bd_sga_upse.aca.oferta o on o.id_oferta=om.id_oferta
inner join bd_sga_upse.aca.periodo_academico pa on pa.id_periodo_academico=mg.id_periodo_academico
inner join bd_sga_upse.tes.rubro r on r.id_rubro=mr.id_rubro
where p.identificacion ='2450360942' and pa.id_periodo_academico =35
select * from man.departamentos
select * from pro.fn_consultar_deudas_estudiantes ('2450916529')
select d.periodo_academico,d.nivel,d.concepto,d.valor,d.abono,d.deuda from  aca.fn_record_rubros ('2450916529') d

select * from [tes].[fun_lista_matricula_cobros_tasas]('2450916529') t

select * from  aca.fn_record_rubros ('2400230369') d
select * from [tes].[fun_lista_matricula_cobros_tasas] ('0957073448')

select * from aca.silabo_bibliografia_no_catalogada where id_silabo_bibliografia_no_catalogada = 20996

select * from aca.periodo_malla
-- DBCC CHECKIDENT ('aca.periodo_malla', RESEED, 1016);
select * from aca.periodo_academico where id_tipo_oferta = 2

select * from aca.tipo_oferta

select * from [tes].[fun_lista_matricula_cobros_aranceles]('2450504911') a

select distinct --om.id_oferta_modalidad,a.descripcion,
                ea.*
--     p.id, p.identificacion,p.apellidos,p.nombres,ma.id_malla_asignatura,a.descripcion as asignatura,ea.id_asignatura_aprendizaje,
-- ea.id_docente,ea.id_paralelo,em.fecha_ing
from aca.estudiante_matricula em
         inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = em.id_estudiante_oferta
         inner join man.personas p on eo.id_persona = p.id
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join aca.oferta o on o.id_oferta = om.id_oferta
         inner join aca.tipo_oferta tof on tof.id_tipo_oferta = o.id_tipo_oferta
         inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
         inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
         inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
         inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
where mg.id_periodo_academico = 33 and ea.estado='A' and em.estado='A'
  and p.identificacion in ('0963242292')

select * from aca.periodo_academico where id_tipo_oferta = 4

select d.* from aca.fn_listar_estudiantes_a_matricular (20,95) as d

select * from aca.tipo_ingreso_estudiante

--habilitar matricula
select
--     pao.id_periodo_academico,om.id_oferta_modalidad,o.descripcion,pao.habilitada_matricula,pao.maximo_creditos
       pao.*
from aca.periodo_academico_oferta pao
         inner join aca.oferta_modalidad om on pao.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
where pao.id_periodo_academico = 92 and pao.estado='A' and om.id_oferta_modalidad  in (15)

select * from aca.matricula_general

select * from aca.malla where id_oferta_modalidad = 15


exec [aca].[pa_generar_asignaturas_a_matricular_sga] 88895,136,1,664
exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 88895,136,1,664

exec aca.sp_rpt_estudiantes_matriculados_por_asignatura  95,null,5

exec aca.[sp_rpt_cantidad_matriculados_por_oferta_nivel] null,5,95,null

exec [aca].[sp_list_all_carreras_records]  '2450254418' ,null, null , null, null


--VER USUARIO GRABO_MATRICULA
begin
    declare @id_periodo_academico int=127
    select
        distinct ea.id_estudiante_asignatura,pa.codigo,om.carrera,p.identificacion,p.apellidos,p.nombres,
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
             inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
             inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
             inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
             left join seg.usuarios u on u.usuario = ea.usuario_ing
             left join man.personas pu on pu.id = u.persona_id
             left join seg.usuarios u2 on u2.usuario = ea.usuario_mod
             left join man.personas pu2 on pu2.id = u2.persona_id
    where --eo.id_estudiante_oferta = 11006
        mg.id_periodo_academico = @id_periodo_academico and
--     and cast(em.fecha_ing as date)='2024-07-29' --and cast(em.fecha_ing as time(0))='10:04:20'
        p.identificacion in ('1750062349')
      and   om.id_tipo_oferta = 2
    --        and ea.id_estudiante_asignatura in (545740,558792,570035,551506)
--    and em.estado = 'A'/
--   and em.estado = 'A'
--     order by d.nombre, p.apellidos;
end;



begin
    declare @id_periodo_academico int = 36
    select  d.PERIODO_ACADEMICO,d.CODIGO_IES,d.id_estudiante_oferta, CODIGO_CARRERA, NOMBRE_CARRERA, CIUDAD_CARRERA, TIPO_IDENTIFICACION, IDENTIFICACION,NOMBRES_APELLIDOS,
            TOTAL_CREDITOS_APROBADOS,CREDITOS_APROBADOS,TIPO_MATRICULA,PARALELO, NIVEL_ACADEMICO, NUM_MATERIAS_SEGUNDA_MATRICULA, NUM_MATERIAS_TERCERA_MATRICULA, PERDIDA_GRATUIDAD,
           TOTAL_HORAS_APROBADAS, HORAS_APROBADAS_PERIODO, MONTO_AYUDA_ECONOMICA, MONTO_CREDITO_EDUCATIVO, ESTADO from (
    select pa.codigo as PERIODO_ACADEMICO,eo.id_estudiante_oferta,
        1023 as CODIGO_IES,o.codigo_ces as CODIGO_CARRERA,o.descripcion as NOMBRE_CARRERA,c.descripcion as CIUDAD_CARRERA,
        te.descripcion as TIPO_IDENTIFICACION,p.identificacion AS IDENTIFICACION,concat(p.apellidos,' ',p.nombres) as NOMBRES_APELLIDOS,isnull(( select sum(ma1.num_creditos) as creditos
                               from [aca].[fn_record_academico_sga_definitivo](eo.id_estudiante_oferta,null,null,1) as d
                                        inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = d.idMallaAsignatura
                               where ma1.estado='A' and (d.periodo not in ('2025-1') --and ( d.idPeriodoAcademico = @id_periodo_academico and d.origen<>'SGA' )
                                   ) ),0) as TOTAL_CREDITOS_APROBADOS,
        mat.creditos_aprobados as CREDITOS_APROBADOS,tm.descripcion TIPO_MATRICULA,
         (select top (1) par.orden as paralelo
         from aca.matricula_general mg
                  inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
                  inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
                  inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
                  inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
                  inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
                  inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
                  inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
         where   mg.id_periodo_academico = @id_periodo_academico and eo1.id_estudiante_oferta = eo.id_estudiante_oferta
           and eo1.estado='A' and em1.estado='A' and ea.estado='A'
           and mg.estado='A'   and aa.estado='A'
           and ma.estado='A' and niv.estado='A'
         group by em1.id_estudiante_matricula,niv.descripcion_corta ,niv.ORDEN,par.descripcion_corta,par.orden
         order by  count (ea.id_asignatura_aprendizaje) desc,count (par.descripcion_corta) desc) as PARALELO,
        (select top (1) niv.orden as semestre
         from aca.matricula_general mg
                  inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
                  inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
                  inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
                  inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
                  inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
                  inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
                  inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
         where   mg.id_periodo_academico = @id_periodo_academico and eo1.id_estudiante_oferta = eo.id_estudiante_oferta
           and eo1.estado='A' and em1.estado='A' and ea.estado='A'
           and mg.estado='A'   and aa.estado='A'
           and ma.estado='A' and niv.estado='A'
         group by em1.id_estudiante_matricula,niv.descripcion_corta ,niv.ORDEN,par.descripcion_corta,par.orden
         order by  count (ea.id_asignatura_aprendizaje) desc,count (par.descripcion_corta) desc) as NIVEL_ACADEMICO, mat.segundas_matriculas as NUM_MATERIAS_SEGUNDA_MATRICULA,
         mat.terceras_matriculas NUM_MATERIAS_TERCERA_MATRICULA,
        iif(eo.mantiene_gratuidad=0,'SI','NO') as PERDIDA_GRATUIDAD,
        isnull(( select sum(ma1.num_horas) as horas
            from [aca].[fn_record_academico_sga_definitivo](eo.id_estudiante_oferta,null,null,1) as d
            inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = d.idMallaAsignatura
            where ma1.estado='A' and (d.periodo not in ('2025-1')
--                                           and ( d.idPeriodoAcademico = @id_periodo_academico and d.origen<>'SGA' )
                ) ),0) as TOTAL_HORAS_APROBADAS,
        mat.horas_aprobadas as HORAS_APROBADAS_PERIODO,0 as MONTO_AYUDA_ECONOMICA,
        0 as MONTO_CREDITO_EDUCATIVO,'NO APLICA' as ESTADO
    from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.malla m on m.id_malla = eo.id_malla
    inner join man.tipo_identificacion te on te.id_tipo_identificacion = p.id_tipo_identificacion
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
    inner join aca.tipo_matricula tm on em.id_tipo_matricula = tm.id_tipo_matricula
    inner join (select em1.id_estudiante_oferta,ea1.id_estudiante_matricula,
                       em1.estado,
                       count(case WHEN ea1.codigo_estado_matricula = 'SEG' THEN 1 END) AS segundas_matriculas,
                       count(CASE WHEN ea1.codigo_estado_matricula = 'TER' THEN 1 END) AS terceras_matriculas,
                       count(ea1.id_estudiante_asignatura) as total,sum(CASE WHEN ISNULL(ea1.aprobado, 0) = 1 THEN ma1.num_creditos ELSE 0 END) as creditos_aprobados,
                       sum(CASE WHEN ISNULL(ea1.aprobado, 0) = 1 THEN ma1.num_horas ELSE 0 END) as horas_aprobadas,
                       sum (ma1.num_creditos) as creditos, sum(ma1.num_horas) as horas from aca.estudiante_matricula em1
             inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
             inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma1 on aa1.id_malla_asignatura = ma1.id_malla_asignatura
            inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
                where em1.estado='A' and ea1.estado='A' and aa1.estado='A' and ma1.estado='A' and mg1.estado='A' and mg1.id_periodo_academico = @id_periodo_academico
                group by em1.id_estudiante_oferta,ea1.id_estudiante_matricula, em1.estado ) as mat on mat.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.oferta o on o.id_oferta = om.id_oferta
    inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
    inner join man.departamentos d on d.id= do.id_departamento
    inner join aca.campus c on c.id_campus = o.id_campus
    where p.estado='AC' and eo.estado='A' and om.estado='A' and em.estado = 'A' --and tee.codigo in ('ACT','OFR','APR')
    and  mg.id_periodo_academico in (@id_periodo_academico)
    group by pa.codigo,o.descripcion,o.codigo_ces,o.descripcion,c.descripcion,te.descripcion,p.id,p.identificacion,p.apellidos,p.nombres, p.apellido_paterno,
    p.apellido_materno,eo.mantiene_gratuidad,eo.id_estudiante_oferta,mat.creditos,mat.horas,mat.terceras_matriculas,mat.segundas_matriculas,tm.descripcion
    ,mat.creditos_aprobados,mat.horas_aprobadas
    ) as d
--     where d.CREDITOS_APROBADOS<>TOTAL_CREDITOS_APROBADOS
    order by d.NOMBRE_CARRERA,d.NOMBRES_APELLIDOS
end

--ver reprobados en otras carreras
begin
    declare @id_periodo_academico int= 96
    select d.codigo, facultad, carrera, id_estudiante_oferta, identificacion, apellidos, nombres,id_estudiante_asignatura ,id_malla_asignatura, orden, nombreAsignatura, vez,
           id_rubro, valor, valor_asignatura, codigo_estado_matricula, matricula_excepcional,vecesNormales,vecesOtrasCarreras,vecesNormales + vecesOtrasCarreras as totalVeces,
           id_estudiante_matricula,fecha_ing from (
    select pa.codigo,om.facultad,om.carrera,eo.id_estudiante_oferta,p.identificacion,p.apellidos,p.nombres,ea.id_estudiante_asignatura,
           iif(ma.id_malla=eo.id_malla,ma.id_malla_asignatura,isnull(ac.id_malla_asignatura,ma.id_malla_asignatura)) as id_malla_asignatura,
           n.orden,
           case when ea.matricula_excepcional =1 then concat(CONVERT(varchar(10),n.orden),' - ',a.descripcion, ' - Matrícula Excepcional') else
               concat(CONVERT(varchar(10),n.orden),' - ',a.descripcion)  end as nombreAsignatura,
           case when ea.codigo_estado_matricula='PRI' THEN '1 VEZ'
                ELSE case when ea.codigo_estado_matricula='SEG' THEN '2 VEZ'
                          ELSE '3 VEZ'  END
               END as vez,ea.id_rubro,r.valor, ea.valor_asignatura,ea.codigo_estado_matricula,ea.matricula_excepcional,
           (select count(*) from aca.estudiante_matricula em1
            inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
            inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
            inner join aca.asignatura_aprendizaje aa1 on ea1.id_asignatura_aprendizaje = aa1.id_asignatura_aprendizaje
            where em1.estado='A' and ea1.estado='A' and aa1.estado='A' and em1.id_estudiante_oferta= eo.id_estudiante_oferta
              and aa1.id_malla_asignatura = ac.id_malla_asignatura_comp and ea1.aprobado=0 and mg1.id_periodo_academico not in (@id_periodo_academico)) as vecesNormales,
           (select count(*) from aca.estudiante_matricula em1
                                     inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
                                     inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                                     inner join aca.asignatura_aprendizaje aa1 on ea1.id_asignatura_aprendizaje = aa1.id_asignatura_aprendizaje
            where em1.estado='A' and ea1.estado='A' and aa1.estado='A' and em1.id_estudiante_oferta= eo.id_estudiante_oferta
              and aa1.id_malla_asignatura = ac.id_malla_asignatura and ea1.aprobado=0 and  mg1.id_periodo_academico not in (@id_periodo_academico)) as vecesOtrasCarreras,
        em.id_estudiante_matricula,em.fecha_ing
    from aca.estudiante_matricula em
    inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = em.id_estudiante_oferta
    inner join man.personas p on eo.id_persona = p.id
    inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
    inner join tes.rubro r on r.id_rubro = ea.id_rubro
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
    inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
    inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
    inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
    inner join aca.nivel n on ma.id_nivel = n.id_nivel
    inner join aca.componente_aprendizaje as cap on aa.id_componente_aprendizaje=cap.id_componente_aprendizaje
    inner join aca.componente_aprendizaje capP on capP.id_componente_aprendizaje=cap.id_componente_aprendizaje_padre
    inner join aca.asignatura_compatibilidad ac on ma.id_malla_asignatura = ac.id_malla_asignatura_comp and ac.estado='A' and ac.tipo in ('NUEVA_MALLA','COMPATIBILIDAD ENTRE CARRERAS')
    where
        --em.id_estudiante_oferta = @id_estudiante_oferta and
         ( mg.id_periodo_academico = @id_periodo_academico or @id_periodo_academico is null)
      AND ea.estado in ('A') and cap.codigo in ('DOCENCIA','PRESENCIAL','SINCRONICO') and ea.codigo_estado_matricula='TER'
    group by aa.id_asignatura_aprendizaje,ea.id_docente,ea.id_paralelo,ea.id_estudiante_asignatura,ea.estado,ma.id_malla_asignatura,
             n.orden,a.descripcion, a.id_asignatura,eo.id_estudiante_oferta,ma.num_creditos,ma.num_horas ,ea.id_rubro,r.valor ,ea.valor_asignatura,ea.matricula_excepcional,
             codigo_estado_matricula,eo.id_oferta_modalidad,ma.UICII,ac.id_malla_asignatura,ma.id_malla, eo.id_malla,pa.codigo,om.facultad,om.carrera,ac.id_malla_asignatura,
             ac.id_malla_asignatura_comp,p.identificacion,p.apellidos,p.nombres,em.id_estudiante_matricula,em.fecha_ing) as d
end

select * from aca.estudiante_asignatura where id_estudiante_asignatura in (668939)

select * from aca.matricula_rubro where id_rubro = 9 and estado='I'

select id_periodo_academico,codigo,descripcion,aplica_historico,permite_excepcional,estado from aca.periodo_academico where id_tipo_oferta =2
