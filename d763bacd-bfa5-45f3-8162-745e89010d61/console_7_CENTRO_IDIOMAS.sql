
use bd_sga_upse;
--SABER LOS ESTUDIANTES OFERTAS DE CENTRO DE IDIOMAS
select p.identificacion,p.apellidos,p.nombres,
    eo.*
-- update eo set eo.id_nivel_proyectado = 17
from aca.estudiante_oferta eo
inner join man.personas p on p.id = eo.id_persona
inner join aca.oferta_modalidad om on om.id_oferta_modalidad=eo.id_oferta_modalidad
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
inner join aca.oferta o on o.id_oferta = om.id_oferta
where om.estado='A' and eo.estado='A' and tee.codigo ='ACT' and o.id_tipo_oferta =4 and p.estado='AC'
and eo.id_nivel_proyectado is null

-- and p.identificacion not in (select d.identificacion from dbo.aspirantes_segunda_matricula as d
--     )


--319  913  1232 3638  4870 -22 = 4848


select * from aca.equivalencia_examen_ubicacion

select * from tmp.EXAMEN_UBICACION eu
where eu.NOTA between 41 and 50
order by CARRERA

select eu.FACULTAD,eu.CARRERA,eu.APELLIDOS,eu.NOMBRES,eu.CEDULA from tmp.EXAMEN_UBICACION eu
group by eu.FACULTAD,eu.CARRERA,eu.APELLIDOS,eu.NOMBRES,eu.CEDULA
having count(eu.CEDULA)>1
select * from tmp.EXAMEN_UBICACION eu
where eu.NOTA>70

select * from aca.equivalencia_examen_ubicacion
--desde ahora los modulos aprobados por examen de suficiencia  y demas que se interno se debe registrar como reconocimiento de horas y creditos.
exec [aca].[sp_migrate_notas_examen_ubicacion] 23

select top 1 * from aca.movilidad

select * from aca.movilidad where id_periodo_academico is null

select m.id_estudiante_oferta,m.id_subtipo_movilidad,count(m.id_movilidad) as suma from aca.movilidad m
where m.estado='A'
group by m.id_estudiante_oferta, m.id_subtipo_movilidad
having count(m.id_movilidad)>1


select m.id_estudiante_oferta,m.id_subtipo_movilidad,count(m.id_movilidad) as suma from aca.movilidad m
where m.estado='A'
group by m.id_estudiante_oferta, m.id_subtipo_movilidad
having count(m.id_movilidad)>1

select om.id_oferta_modalidad,
                d.nombre, o.descripcion,
                p.identificacion,p.apellidos
from man.personas p
         inner join aca.estudiante_oferta eo on p.id = eo.id_estudiante_oferta
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.departamento_oferta do on o.id_oferta = do.id_oferta
         inner join man.departamentos d on do.id_departamento = d.id
where eo.id_estudiante_oferta =31180
group by om.id_oferta_modalidad,d.nombre, o.descripcion, p.identificacion, p.apellidos, p.nombres
order by d.nombre,o.descripcion,p.apellidos,p.nombres


-- exec [aca].[calificacion_suma] 35,null,'PREGRADO'
select * from aca.periodo_academico where id_tipo_oferta = 2

select top 1 * from aca.detalle_movilidad

select eo.* from aca.estudiante_oferta eo
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
where  o.id_tipo_oferta = 4

select pa.id_periodo_academico,pa.codigo,pa.descripcion from aca.periodo_academico pa
where  pa.id_tipo_oferta = 4



select p.id,p.identificacion,p.apellidos,p.nombres from man.personas p where p.apellidos like '%vera yagual%' and p.nombres like '%carlos%'

exec [aca].[sp_migrate_notas_examen_ubicacion] null,'0926365362'

SELECT top 5 * FROM  tmp.EXAMEN_UBICACION eu
where eu.CEDULA in ('0926365362', '0953240751', '0704424985', '0958895856')

select ee.num_niveles,ee.nota_homologar from aca.equivalencia_examen_ubicacion ee
where 86 between ee.puntaje_inicial and ee.puntaje_final and ee.codigo='EXAMEN DE SUFICIENCIA'


select * from aca.equivalencia_examen_ubicacion

select * from dbo.estudiantes_matriz_excel ex

exec [aca].[sp_list_all_carreras_records]  '2400190779' ,null, null , null, null



select top 5 * from aca.detalle_movilidad dm
order by id_detalle_movilidad desc

select *from dbo.estudiantes_matriz_excel ex
where ex.cedula in ('2300474216')
--crea las notas de una matriz de excel
exec [aca].[sp_migrate_notas_ingles_to_estudiante_matricula_by_estudiante] '2300474216'

select * from aca.tipo_matricula_fecha

select d.periodo_academico,d.nivel,d.concepto,d.valor,d.abono,d.deuda from  aca.fn_record_rubros ('2450345265') d
	where d.abono <d.valor

exec [aca].[sp_list_all_carreras_records]  '2300474216' ,null, null , null, null

select * from man.personas p
inner join seg.usuarios u on p.id = u.persona_id
where p.identificacion in ('2300474216')

select distinct eu.CARRERA,o.descripcion from tmp.EXAMEN_UBICACION eu
inner join man.personas p on p.identificacion = eu.CEDULA
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
where eo.estado ='A' and p.estado ='AC' and o.id_tipo_oferta = 2 and tee.id_tipo_estado_estudiante = 1 --and p.identificacion='2450338930'
and eu.CEDULA not in (select eu.CEDULA from tmp.EXAMEN_UBICACION eu
group by eu.APELLIDOS,eu.NOMBRES,eu.CEDULA
having count(eu.CEDULA)>1)
--                 and eu.CEDULA in ('2400308926', '0928141712', '0922862131', '2400194888' ,'0927949768', '2450338930')
order by o.descripcion

    select --eo.id_estudiante_oferta,eo.estado,
           e.* from tmp.EXAMEN_UBICACION e
--     inner join man.personas p on p.identificacion = e.CEDULA
--     inner join aca.estudiante_oferta eo on eo.id_persona = p.id
--     inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
--     inner join aca.oferta o on o.id_oferta = om.id_oferta
    where e.CEDULA not in (
        select eu.CEDULA from tmp.EXAMEN_UBICACION eu
        inner join man.personas p on p.identificacion = eu.CEDULA
        inner join aca.estudiante_oferta eo on eo.id_persona = p.id
        inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
        inner join aca.oferta o on o.id_oferta = om.id_oferta
        inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
        where eo.estado ='A' and p.estado ='AC' and o.id_tipo_oferta = 2 and tee.id_tipo_estado_estudiante = 1 --and p.identificacion='2450338930'
        and eu.CEDULA not in (select eu.CEDULA from tmp.EXAMEN_UBICACION eu
        group by eu.APELLIDOS,eu.NOMBRES,eu.CEDULA
        having count(eu.CEDULA)>1)
--                 and eu.CEDULA in ('0922862131' ,'0928141712')
)
and e.CEDULA  in (select eu.CEDULA from tmp.EXAMEN_UBICACION eu
        group by eu.APELLIDOS,eu.NOMBRES,eu.CEDULA
        having count(eu.CEDULA)>1)
    order by e.APELLIDOS,e.NOMBRES

-- exec [aca].[sp_matricular_estudiantes_centro_idiomas_from_moodle] 45
--
-- exec [aca].[sp_matricular_estudiantes_centro_idiomas_from_moodle]

--     p.identificacion ='1105397390'


select count(eo.id_estudiante_oferta),p.identificacion,p.apellidos,p.nombres from tmp.EXAMEN_UBICACION eu
inner join man.personas p on p.identificacion = eu.CEDULA
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
where eo.estado ='A' and p.estado ='AC' and o.id_tipo_oferta = 2 and tee.id_tipo_estado_estudiante = 1 --and p.identificacion='2450338930'
and eu.CEDULA not in (select eu.CEDULA from tmp.EXAMEN_UBICACION eu
group by eu.APELLIDOS,eu.NOMBRES,eu.CEDULA
having count(eu.CEDULA)>1)
--and eu.CEDULA in ('0922862131' ,'0928141712')
group by  p.identificacion,p.apellidos,p.nombres
having count(eo.id_estudiante_oferta)>1
order by p.apellidos,p.nombres

--7637
--1483 esos son registros que se van a reutilizar
--6153 registros nuevos
select  distinct  o.descripcion,p.id, p.identificacion,p.apellidos,p.nombres,eo.id_oferta_modalidad
from man.personas p
-- inner join seg.usuarios u on p.id = u.persona_id
inner join aca.estudiante_oferta eo on p.id = eo.id_persona
inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.departamento_oferta do on o.id_oferta = do.id_oferta
inner join man.departamentos d on do.id_departamento = d.id
where mg.id_periodo_academico=35 and tee.codigo='ACT' and p.estado='AC' and eo.estado='A' and o.id_oferta not in (40,41,25,59,60,36)
and eo.id_persona not in (select eo.id_persona from aca.estudiante_oferta eo
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
where  o.id_tipo_oferta = 4 and eo.estado='A' and om.id_oferta_modalidad = 18
)
order by o.descripcion,p.apellidos,p.nombres

select * from aca.componente_organizacion
select * from aca.tipo_comp_organizacion

-- DBCC CHECKIDENT ('aca.componente_organizacion', RESEED, 11);
select * from aca.periodo_academico where id_tipo_oferta = 2

select eo.* from aca.estudiante_oferta eo
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
where  o.id_tipo_oferta = 4 and eo.estado='A'

select * from seg.roles where descripcion like '%nivelac%'

select * from aca.periodo_academico where id_tipo_oferta = 4

select * from aca.estudiante_oferta
where id_oferta_modalidad = 18
order by id_estudiante_oferta desc

select * from aca.tipo_estado_estudiante

select * from aca.tipo_ingreso_estudiante

select * from aca.tipo_estudiante

SELECT * FROM MAN.personas WHERE apellidos LIKE '%RAMiREZ AVELINO%'
--sse inserto 2758 manes para que puedan ver centro de idiomas
select * from mig.record_oferta where identificacion ='2400470338'
--14
begin
    declare @codigoPeriodo varchar(6),@numero_matricula varchar(20),@codigo_periodo_concat varchar(20),@id_periodo_academico int = 150

    select @codigo_periodo_concat=pa.codigo from aca.periodo_academico pa
    where pa.id_periodo_academico = @id_periodo_academico and pa.id_tipo_oferta = 4 and pa.estado='A'
    select @codigoPeriodo=CONCAT(SUBSTRING(@codigo_periodo_concat, 1, 4),SUBSTRING(@codigo_periodo_concat, 6, 2))
--     insert into aca.estudiante_oferta
    select
--         eo.id_estudiante_oferta,om.facultad,om.carrera,eo.numero_matricula,p.identificacion,p.apellidos,p.nombres,tie.descripcion,te.codigo,te.descripcion,tee.descripcion,
            eo.id_estudiante_oferta,@id_periodo_academico as id_periodo_academico,p.id  as idPersona,20 as id_malla,18 as id_oferta_modalidad,	8 as tipo_estudiante,
            8 as id_tipo_ingreso_estudiante, 1 as id_tipo_estado_estudiante,17 as id_nivel_proyectado,null as vez_proyectada,null as ultimo_periodo,
            CONCAT(@codigoPeriodo,'018','08' ,RIGHT('00000' + Ltrim(Rtrim(Rtrim((0)+
            (select count(p.identificacion) from aca.estudiante_oferta eo
                                                     inner join man.personas p on p.id = eo.id_persona
             where eo.id_oferta_modalidad = 18 and p.estado='AC' and eo.estado='A' and eo.id_periodo_academico = @id_periodo_academico)+
                                                                                ( ROW_NUMBER() OVER (ORDER BY om.carrera,p.apellidos,p.nombres))))),5) )as numero_matricula,
--             @numero_matricula as numero_matricula,
            1 as mantiene_gratuidad,getdate(),	null,	'A', getdate(),664,0,
            getdate(),getdate(),'2400254286','2400254286',null
--             ,     pa.codigo,om.carrera,tie.id_tipo_ingreso_estudiante,tie.descripcion,p.identificacion,eo.id_oferta_modalidad,om.id_oferta
    from man.personas p
    inner join seg.usuarios u on p.id = u.persona_id
    inner join aca.estudiante_oferta eo on p.id = eo.id_persona
    --              inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
    --              inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
    inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
    inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
    inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
    inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
    left join aca.periodo_academico pa on eo.id_periodo_academico = pa.id_periodo_academico
    where --mg.id_periodo_academico=95 and em.estado='A' and
           tee.codigo='ACT' and p.estado='AC'  and u.estado='AC' and eo.estado='A' and om.id_oferta  not in (40,41,25,59,60,36,107,35,97,81)
      and te.codigo not in ('PRE-EST-INTERCAMBIO') and om.id_tipo_oferta = 2 and pa.codigo>'2023-1'
      and eo.id_persona not in (select eo.id_persona from aca.estudiante_oferta eo
                                                              inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
                                                              inner join aca.oferta o on om.id_oferta = o.id_oferta
                                where  o.id_tipo_oferta = 4 and eo.estado='A' and om.id_oferta_modalidad = 18
    )
    order by om.carrera,p.apellidos,p.nombres
end

select * from aca.fn_listar_docentes_asignaturas(null,18,132)
select * from aca.matricula_general
select * from aca.tipo_matricula_fecha

select * from aca.periodo_academico_oferta where id_periodo_academico = 132

--cuando no son matriculados en grado solo faktan modulos
-- insert into aca.estudiante_oferta
select  eo.id_estudiante_oferta,141,p.id  as idPersona,20,18,	8,	8,	1,17,null,null,'NO APLICA',	1,getdate(),	null,	'A',
        getdate(),664,0,getdate(),getdate(),'2400254286','2400254286'
  ,     pa.codigo,o.descripcion,tie.id_tipo_ingreso_estudiante,tie.descripcion,p.identificacion,eo.id_oferta_modalidad,o.id_oferta
from man.personas p
         left join seg.usuarios u on p.id = u.persona_id
         inner join aca.estudiante_oferta eo on p.id = eo.id_persona
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.departamento_oferta do on o.id_oferta = do.id_oferta
         inner join man.departamentos d on do.id_departamento = d.id
            left join aca.periodo_academico pa on eo.id_periodo_academico = pa.id_periodo_academico
where tee.codigo='ACT' and p.estado='AC'  and u.estado='AC' and eo.estado='A' and o.id_oferta not in (40,41,25,59,60,36,107,35,97) and o.id_tipo_oferta = 2
    and eo.id_tipo_ingreso_estudiante not in (13)
--   and p.identificacion='0915444400'
  and eo.id_persona not in (select eo.id_persona from aca.estudiante_oferta eo
                                                          inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
                                                          inner join aca.oferta o on om.id_oferta = o.id_oferta
                            where  o.id_tipo_oferta = 4 and eo.estado='A' and om.id_oferta_modalidad = 18
)
order by o.descripcion,p.apellidos,p.nombres


--solo faltan modulos
begin
    declare @codigoPeriodo varchar(6),@numero_matricula varchar(20),@codigo_periodo_concat varchar(20),@id_periodo_academico int = 146

    select @codigo_periodo_concat=pa.codigo from aca.periodo_academico pa
    where pa.id_periodo_academico = @id_periodo_academico and pa.id_tipo_oferta = 4 and pa.estado='A'
    select @codigoPeriodo=CONCAT(SUBSTRING(@codigo_periodo_concat, 1, 4),SUBSTRING(@codigo_periodo_concat, 6, 1))
insert into aca.estudiante_oferta
select  null,@id_periodo_academico as id_periodo_academico,p.id  as idPersona,20 as id_malla,18 as id_oferta_modalidad,	8 as tipo_estudiante,
        8 as id_tipo_ingreso_estudiante, 1 as id_tipo_estado_estudiante,17 as id_nivel_proyectado,null as vez_proyectada,null as ultimo_periodo,
        CONCAT(@codigoPeriodo,'018','08' ,RIGHT('00000' + Ltrim(Rtrim(Rtrim((0)+
                                                                            (select count(p.identificacion) from aca.estudiante_oferta eo
                                                                                                                     inner join man.personas p on p.id = eo.id_persona
                                                                             where eo.id_oferta_modalidad = 18 and p.estado='AC' and eo.estado='A' and eo.id_periodo_academico = @id_periodo_academico)+
                                                                            ( ROW_NUMBER() OVER (ORDER BY p.apellidos,p.nombres))))),5) )as numero_matricula,
        1 as mantiene_gratuidad,getdate(),	null,	'A', getdate(),664,0,
        getdate(),getdate(),'2400254286','2400254286'
from man.personas p
--          left join seg.usuarios u on p.id = u.persona_id
where p.estado='AC' -- and u.estado='AC'
and p.identificacion='0915444400'

end

select * from aca.fun_record_ingles_estudiante ('0915444400')
select * from aca.periodo_academico where id_tipo_oferta = 4
select top 1 * from aca.estudiante_oferta
select * from aca.tipo_estado_estudiante
select * from aca.tipo_estudiante
select * from aca.tipo_ingreso_estudiante

--ver los manes de hospitalidad que no deberian tomar modulos
select ing.*
--     p.id  as idPersona,p.identificacion,p.apellidos,p.nombres,om.facultad,om.id_oferta_modalidad,om.carrera,em.id_estudiante_matricula,em.estado,em.observacion,ea.id_estudiante_asignatura
from man.personas p
         inner join seg.usuarios u on p.id = u.persona_id
         inner join aca.estudiante_oferta eo on p.id = eo.id_persona
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
        inner join aca.estudiante_oferta ing on ing.id_persona = eo.id_persona and ing.id_oferta_modalidad = 18 and ing.estado='A'
        left join aca.estudiante_matricula em on ing.id_estudiante_oferta = em.id_estudiante_oferta and em.estado='A'
        left join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula and ea.estado='A'
where tee.codigo='ACT' and p.estado='AC'  and u.estado='AC' and eo.estado='A' and om.id_tipo_oferta = 2 and om.id_oferta_modalidad = 81
and em.id_estudiante_matricula is not null
--   and p.identificacion='0928076553'
--   and eo.id_persona in (select eo.id_persona from aca.estudiante_oferta eo
--                                                           inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
--                                                           inner join aca.oferta o on om.id_oferta = o.id_oferta
--                             where  o.id_tipo_oferta = 4 and eo.estado='A' and om.id_oferta_modalidad = 18
-- )
-- group by p.id,p.identificacion,p.apellidos,p.nombres,om.facultad,om.id_oferta_modalidad,om.carrera,em.id_estudiante_matricula,ea.id_estudiante_asignatura
order by om.facultad,om.carrera,p.apellidos,p.nombres


--ver los manes de centro de idiomas
select
    eo.*
--     p.id  as idPersona,p.identificacion,p.apellidos,p.nombres,om.facultad,om.id_oferta_modalidad,om.carrera
from man.personas p
inner join seg.usuarios u on p.id = u.persona_id
inner join aca.estudiante_oferta eo on p.id = eo.id_persona
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
where tee.codigo='ACT' and p.estado='AC'  and u.estado='AC' and eo.estado='A' and om.id_tipo_oferta = 4 --and eo.id_nivel_proyectado =11
and p.identificacion in ('2400111031')
order by om.facultad,om.carrera,p.apellidos,p.nombres



select * from aca.fun_record_ingles_estudiante('0922694161')

exec aca.pa_generar_asignaturas_a_matricular_sga 41353,93,2,664
exec aca.pa_generar_asignaturas_a_matricular_sga_pruebas 41353,93,2,664


select * from aca.tipo_ingreso_estudiante
---fajardo marca nelly michelle 0105805188 contabilidad y auditoria  6/1  2022-1  2019-2

--LISTAR ESTUDIANTES OFERTAS DE CENTRO DE IDIOMAS
select  distinct  o.descripcion,p.id, p.identificacion,p.apellidos,p.nombres,eo.id_oferta_modalidad
from man.personas p
inner join seg.usuarios u on p.id = u.persona_id
inner join aca.estudiante_oferta eo on p.id = eo.id_persona
-- inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
-- inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.departamento_oferta do on o.id_oferta = do.id_oferta
inner join man.departamentos d on do.id_departamento = d.id
where
--     mg.id_periodo_academico=27 and
--       tee.codigo='ACT' and o.id_tipo_oferta = 2 and p.estado='AC' and eo.estado='A' and o.id_oferta not in (40,41,25,59,60,36) and
--    p.identificacion='2450686312'
 eo.id_persona not in (select eo.id_persona from aca.estudiante_oferta eo
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
where  o.id_tipo_oferta = 4 and eo.estado='A')
order by o.descripcion,p.apellidos,p.nombres
--actualiza las matriculas a un estudiante oferta de centro e idiomas
select p.identificacion,p.nombres,p.apellidos,eomo.id_estudiante_oferta,em.*
-- update em
-- set em.id_estudiante_oferta = eomo.id_estudiante_oferta
from aca.estudiante_matricula em
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
inner join man.personas p on eo.id_persona = p.id
inner join aca.estudiante_oferta eomo on eomo.id_persona = eo.id_persona and eomo.id_oferta_modalidad = 18 and eomo.id_malla = 20
where pa.id_tipo_oferta = 4
and eomo.id_estudiante_oferta <> em.id_estudiante_oferta

--mover los modulos de ingles que estaban homologados en grado a id_estudiante_oferta de centro de idiomas
select p.identificacion,p.nombres,p.apellidos,eo.id_estudiante_oferta,eomo.id_estudiante_oferta,om1.id_tipo_oferta,om.id_tipo_oferta,m.id_oferta_modalidad,m.id_malla,a.descripcion,dm.*
-- update mov set mov.id_estudiante_oferta = eomo.id_estudiante_oferta,mov.fecha_mod = getdate(),mov.usuario_mod='2400254286'
--     em
-- set em.id_estudiante_oferta = eomo.id_estudiante_oferta
from aca.detalle_movilidad dm
    inner join aca.movilidad mov on mov.id_movilidad = dm.id_movilidad
    inner join aca.malla_asignatura ma on dm.id_malla_asignatura = ma.id_malla_asignatura
    inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
    inner join aca.malla m on m.id_malla = ma.id_malla
    --          inner join aca.periodo_academico pa on mov.id_periodo_academico = pa.id_periodo_academico
    inner join aca.estudiante_oferta eo on mov.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join aca.ofertas_facultad om on om.id_oferta_modalidad = m.id_oferta_modalidad
    inner join aca.ofertas_facultad om1 on om1.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join man.personas p on eo.id_persona = p.id
    inner join aca.estudiante_oferta eomo on eomo.id_persona = eo.id_persona and eomo.id_oferta_modalidad = 18 and eomo.id_malla = 20
where --om.id_tipo_oferta = 4
    --p.identificacion='2400223877'
   om.id_tipo_oferta=4 and om1.id_tipo_oferta= 2
--       eomo.id_estudiante_oferta <> em.id_estudiante_oferta

select * from [aca].[fn_listar_docentes_asignaturas](21540,null,29)

select * from aca.tipo_matricula_fecha

exec aca.pa_generar_asignaturas_a_matricular_sga 21540,29,1,664

select * from [aca].[fn_listar_docentes_asignaturas](21540,null,33)

select * from tmp.modulos_ingles_matrices

select *from aca.matricula_general
select * from aca.periodo_academico where id_tipo_oferta = 4

select p.identificacion,p.nombres,p.apellidos,eo.* from aca.estudiante_oferta eo
inner join man.personas p on eo.id_persona = p.id
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
where  o.id_tipo_oferta = 4 and eo.id_persona in (select eo.id_persona from aca.estudiante_matricula em
inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
where pa.id_tipo_oferta = 4) and eo.id_persona = 9221

-- update aca.estudiante_oferta set id_tipo_estado_estudiante = 1 where id_estudiante_oferta in
-- (select eo.id_estudiante_oferta from aca.estudiante_oferta eo
-- inner join man.personas p on eo.id_persona = p.id
-- inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
-- inner join aca.oferta o on om.id_oferta = o.id_oferta
-- where  o.id_tipo_oferta = 4)

select a.* from aca.malla_asignatura ma
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura where ma.id_malla_asignatura=2950

select * from aca.fun_record_ingles_estudiante('0928025204')


exec [aca].[sp_list_all_matriculas_carreras] '0928025204',null
EXECUTE Bd_Academico..sp_record_modulos_estudiantes_historico 113, '0928025204'

exec aca.pa_generar_asignaturas_a_matricular_sga 59444,124,1,664

exec aca.pa_generar_asignaturas_a_matricular_sga_pruebas 59444,124,1,664


select * from aca.malla_asignatura where id_malla = 20

select * from aca.tipo_oferta


select * from migracion_sga.dbo.registros_migracion where id_destino = 1394 and id_entidad_relacion = 5
select * from migracion_sga.dbo.registros_migracion where id_origen = 36622 and id_entidad_relacion = 5

select * from migracion_sga.dbo.entidades_migracion

select * from man.personas where apellidos like '%MONTENEGRO DE LA CRUZ%'

select * from aca.tipo_oferta
----probando
exec [aca].[sp_list_all_carreras_records] '2450686312','CENTROIDIOMAS',null,null,null

exec [aca].[sp_list_all_carreras_records] '0915444400',null,null,null,null

exec [aca].[sp_list_all_carreras_records] '2450686312','PREGRADO',null,null,null

exec [aca].[sp_list_all_asignaturas_detalle_record] 11798,108,
    '2022120100','2400400202',null,null,null

exec [aca].[sp_list_all_asignaturas_detalle_record] 17940,null,
     null,null,null,null,null

exec [aca].[pa_generar_asignaturas_a_matricular_sga] 17940,36,1,664

exec [aca].[pa_generar_asignaturas_a_matricular_sga] 58826,134,1,664

exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 58826,134,1,664

select * from aca.fn_get_all_offers('0928012129',null,null,null,null,null)

select * from  [aca].[fn_listar_docentes_asignaturas](null,18,134)

select * from aca.docente_asignatura_aprend where id_docente_asignatura_aprend in (50465,50466,50467,50468,50472,50469,50470,50473,50474,50471 ,50493   )

select * from aca.matricula_general where id_periodo_academico = 93

select * from aca.periodo_academico_oferta where id_periodo_academico = 150 and id_oferta_modalidad in (18)
select * from aca.ofertas_facultad where id_tipo_oferta = 2

select * from aca.tipo_matricula_fecha where id_matricula_general = 38

select --p.identificacion,p.apellidos,p.nombres,o.descripcion,
       eo.* from aca.estudiante_oferta eo
                     inner join man.personas p on eo.id_persona = p.id
                     inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
                     inner join aca.oferta o on om.id_oferta = o.id_oferta
                     inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
where o.id_tipo_oferta = 4 and
    p.identificacion='2400394595'

--requisitos de matricula
select distinct  rn.* --,rn.id_proceso_requisito,pr.descripcion
from aca.requisito_nivel_estudiante rn
inner join aca.matricula_general mg on rn.id_matricula_general = mg.id_matricula_general
inner join pro.proceso_requisito pr on rn.id_proceso_requisito = pr.id_proceso_requisito
where mg.id_periodo_academico in (134,150) --and --rn.id_nivel = 1 and
--       pr.id_proceso_requisito = 6
--   and pr.id_proceso_requisito = 6


select distinct mfn.* from aca.matricula_fecha_nivel mfn
    inner join aca.tipo_matricula_fecha tmf on mfn.id_tipo_matricula_fecha = tmf.id_tipo_matricula_fecha
         inner join aca.matricula_general mg on mg.id_matricula_general = tmf.id_matricula_general
         where mg.id_periodo_academico = 150

select --o.codigo,o.nombre,o.descripcion,
       uo.* from seg.usuario_opcion uo
                     inner join man.opciones o on uo.id_opcion = o.id
where  id_usuario in (40071, 18422
    )

-- matricula-modulo-requisito	Matrícula Módulos Inglés    417
-- matriculacion-estudiante	Matriculación de Asignaturas    75
--     matriculacion-estudiante-centro-idiomas	Matriculación de Asignaturas CDI 418


select * from man.opciones where opciones.codigo like '%matricula-modulo-requisito%'
select * from man.opciones where opciones.descripcion like '%Matriculación de Asignaturas CDI%'

select * from seg.usuarios where usuario='2400238024'

select * from man.personas where identificacion='42361252'

select * from man.nacionalidad --3 159

select * from man.lugar where id_lugar_padre is null




select * from aca.fun_record_ingles_estudiante('2450686312')
select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 4
select *from aca.periodo_academico where id_tipo_oferta = 4
--  29
select * from aca.estudiante_oferta

select * from aca.tipo_matricula_fecha


select --top 10
    * from tmp.modulos_ingles_matrices
where estado='A'


select * from aca.fun_record_ingles_estudiante('2450652512')


SELECT * from aca.tipo_matricula_fecha


select * from tmp.modulos_ingles_matrices where (id_curso_moodle=11155 and identificacion in ('f711437','0915573539',
                                                                                             '0913241279','0301308755',
                                                                                             '0916783913','2450171950','2450277146',
                                                                                            '0914252614')) or
 (id_curso_moodle=11483 and identificacion in ('2450236035','0301308755',
                                                                                             '1310659360','0941518607',
                                                                                            '0914252614')) or
(id_curso_moodle=11156 and identificacion in ('0915573539','2450236035',
                                                                                             '0301308755','1310659360',
                                                                                             '2400092553','0941518607',
                                                                                            '0914252614')) or
 (id_curso_moodle=11484 and identificacion in ('1316851250','0914252614',
                                                                                             '0924088461','0301308755',
                                                                                             '0105193676')) or
(id_curso_moodle=11157 and identificacion in ('0915573539','1316851250',
                                                                                             '0924088461','0301308755',
                                                                                             '0105193676'))
--LISTADO DE ESTUDIANTES HABILITADOS PARA TOMAR EL MODULO DE INGLES
select  distinct mg.id_periodo_academico,ma.id_malla_asignatura,a.descripcion,ea.*
--     eo.id_estudiante_oferta,p.id as id_persona,u.id as id_usuario, p.identificacion,p.apellidos,p.nombres,eo.id_oferta_modalidad
from man.personas p
inner join seg.usuarios u on p.id = u.persona_id
inner join aca.estudiante_oferta eo on p.id = eo.id_persona
inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
inner join aca.malla_asignatura  ma on aa.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.departamento_oferta do on o.id_oferta = do.id_oferta
inner join man.departamentos d on do.id_departamento = d.id
where tee.codigo='ACT' and p.estado='AC' and eo.estado='A' --and eo.id_nivel_proyectado  in (20)
AND o.id_tipo_oferta = 4 AND P.identificacion = '0915444400'
-- order by p.apellidos,p.nombres

select eo.* from aca.estudiante_oferta eo
inner join man.personas p on p.id = eo.id_persona
-- inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
-- inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
-- inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
-- inner join aca.matricula_rubro mr on em.id_estudiante_matricula = mr.id_estudiante_matricula
where  p.identificacion='2450624933'

select * from aca.oferta_modalidad where id_oferta_modalidad = 18
select * from aca.modalidad

select * from aca.tipo_oferta

exec [aca].[sp_list_all_matriculas_carreras] '2450810540',null

exec [aca].[sp_list_all_carreras_records] '2450128257',null,null,null,null

exec [aca].[sp_list_all_asignaturas_detalle_record] 12762,null,
    null,null,null,null,null

SELECT * FROM ACA.componente_aprendizaje

SELECT * FROM ACA.malla_asignatura WHERE id_malla = 20

SELECT PPD.id_number_moodle FROM ACA.planificacion_paralelo PP
         INNER JOIN ACA.planificacion_paralelo_detalle PPD ON PP.id_planificacion_paralelo=PPD.id_planificacion_paralelo WHERE id_periodo_academico=141



select rne.* from aca.requisito_nivel_estudiante rne
        INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = rne.id_matricula_general
        INNER JOIN pro.proceso_requisito pr ON pr.id_proceso_requisito= rne.id_proceso_requisito
where rne.id_nivel = 21 and pr.codigo ='NODEUDAS'


select * from aca.estudiante_oferta where id_estudiante_oferta = 42060
--  DBCC CHECKIDENT ('aca.periodo_academico', RESEED, 32);
select * from aca.periodo_academico where id_tipo_oferta= 4

select * from aca.matricula_general where id_periodo_academico= 124

select * from aca.tipo_matricula_fecha where id_matricula_general = 29

select pr.codigo,pr.descripcion,rne.id_proceso_requisito from aca.requisito_nivel_estudiante rne
INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = rne.id_matricula_general
INNER JOIN pro.proceso_requisito pr ON pr.id_proceso_requisito= rne.id_proceso_requisito
where rne.id_nivel in (11) and rne.estado='A'

select * from aca.nivel

select --pr.codigo,pr.descripcion,
       rne.* from aca.requisito_nivel_estudiante rne
        INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = rne.id_matricula_general
        INNER JOIN pro.proceso_requisito pr ON pr.id_proceso_requisito= rne.id_proceso_requisito

where mg.id_periodo_academico =33

select * from aca.requisito_nivel_estudiante
-- 511
select * from aca.periodo_academico_oferta where id_periodo_academico_oferta = 511

--339
select * from aca.periodo_malla where id_periodo_malla = 339


exec [aca].[pa_generar_asignaturas_a_matricular_sga] 21540,33,1,664

exec [aca].[pa_generar_asignaturas_a_matricular_sga] 21540,33,1,664

exec [aca].[pa_generar_asignaturas_a_matricular_sga] 21549,33,1,664

exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 52672,33,1,664

exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 42412,33,1,664

select identificacion,nombres,apellidos from man.personas where apellidos like '%ORTIZ REMACHE%' and nombres like '%MARCO ANDRES%'


select * from [aca].[fn_listar_docentes_asignaturas](39837,null,33)



select * from aca.malla_asignatura where id_malla = 20

select * from aca.tipo_estado_estudiante

select * from aca.malla where id_malla = 20


select pao.* from aca.periodo_academico_oferta pao
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
where pao.estado='A' and om.estado='A' and pao.id_periodo_academico = 124 and om.id_oferta_modalidad = 18
exec [aca].[sp_list_all_carreras_records]  '0925080053' ,null, null , null, null

select em.* from aca.estudiante_matricula em
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
where em.id_estudiante_oferta = 40358

select sysdatetime()

-- DBCC CHECKIDENT ('aca.detalle_movilidad', RESEED, 106051);

select top 10 * from aca.detalle_movilidad dm
order by dm.id_detalle_movilidad desc

select  pa.* from aca.tipo_matricula_fecha tmf
inner join aca.matricula_general mg on tmf.id_matricula_general = mg.id_matricula_general
inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
where pa.id_tipo_oferta = 4 and mg.id_matricula_general = 14


--registrar notas de modulos pasados
exec [aca].[sp_migrate_notas_examen_ubicacion] 33,'2450128257'

exec [aca].[sp_migrate_notas_ingles_to_estudiante_matricula_by_estudiante] null,3042
exec [aca].[sp_migrate_notas_ingles_to_estudiante_matricula_by_estudiante] '0202057774',null

select top 3 * from dbo.estudiantes_matriz_excel ex
where ex.cedula='2450128257'

select * from aca.equivalencia_examen_ubicacion eeu

select  distinct eu.TIPO_HOMOLOGACION from tmp.EXAMEN_UBICACION eu


select  * from tmp.EXAMEN_UBICACION eu where --eu.TIPO_HOMOLOGACION ='CERTIFICADO CAMBRIDGE ASSESSMENT' and
                                           eu.cedula='2450128257'

select id_movilidad from bd_sga_upse.aca.movilidad m
where m.id_estudiante_oferta = 40906 and m.id_subtipo_movilidad = 2 and m.estado='A'

select * from aca.detalle_movilidad dm where dm.id_movilidad = 7719 and dm.estado='A'

select * from aca.fun_record_ingles_estudiante('0922694161') as d
-- where d.aprobado = 1

select * from aca.fun_asignaturas_ingles_vistas() as d where d.identificacion='0922694161'

select ro.carrera,ra.* from mig.record_oferta ro
inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
where identificacion='0922694161'

select p.identificacion,m.matricula,p.APELLIDOS as apellidos, p.NOMBRES as nombres,
--mt.ID_NIVEL,
tipo=CASE
         WHEN mt.ID_NIVEL IN (11,30)  THEN 'EXTRACURRICULAR'
         WHEN mt.ID_NIVEL IN (1,2,3,4,5,6,7,8,9,10) THEN 'CURRICULAR'
         WHEN mt.ID_NIVEL IN (13,14,15,21,22) THEN 'CURRICULAR'
         WHEN mt.ID_NIVEL IN (38,47,48,49,50,51) THEN 'EXTRACURRICULAR'
         ELSE 'OTROS'
           END,
       mt.id_nivel as idNivel,
periodo = (select valor_texto from Bd_Academico.dbo.TP_CODIGOS where CORRELATIVO=pad.CG_PER_ACADEMICO),
-- rm.id_destino as idMallaAsignatura,
--modulos aprobados en carrera quitar si se daña
    iif(mt.ID_NIVEL IN (1,2,3,4,5,6,7,8,9,10,13,14,15,21,22) and a.NOMBRE='INGLES I',1393,rm.id_destino) as idMallaAsignatura,
    'sistema 2007-2021' as sistema,
    a.NOMBRE as asignatura,
    c.NOMBRE as oferta,
    mt.PROMEDIO AS nota,
    mt.APROBADO AS aprobado,
    iif(mp.HORAS_SISTEMA is null, 0,  mp.HORAS_SISTEMA) as horas,
    iif( mp.CREDITOS is null, 0,   mp.CREDITOS) as creditos,
    mt.estado,pad.CG_PER_ACADEMICO
from Bd_Academico.dbo.MATERIAS_TOMADAS mt
         inner join Bd_Academico.dbo.periodos_academicos pad on pad.ID_DETALLE=mt.id_detalle_periodo
         inner join Bd_Academico.dbo.TE_MATRICULAS m on mt.ID_MATRICULA=m.ID_MATRICULA
         inner join Bd_Academico.dbo.PERSONAS p on m.ID_PERSONA=p.ID_PERSONA
--inner join Bd_Academico.dbo.VW_MATERIAS_PLAN mp on mp.ID_MATERIA_PLAN=mt.ID_MATERIA_PLAN
         left join Bd_Academico.dbo.MATERIAS_PLAN mp on mp.ID_MATERIA_PLAN=mt.ID_MATERIA_PLAN
         left join migracion_sga.dbo.registros_migracion rm on  rm.id_origen = mp.ID_MATERIA_PLAN and id_entidad_relacion = 5
         inner join Bd_Academico.dbo.MATERIAS a on mp.ID_MATERIA=a.ID_MATERIA
         inner join Bd_Academico.dbo.PLAN_ESTUDIOS pl on pl.ID_PLAN=mp.ID_PLAN
         inner join  Bd_Academico.dbo.CARRERAS_LOCALES_MODALIDAD_SISTEMA c on pl.ID_CARRERA_OFERTADA=c.ID_CARRERA_OFERTADA
--inner join Bd_Academico.dbo.NIVELES n on n.ID_NIVEL=mp.ID_NIVEL
where (a.NOMBRE like '%INGLES%' or a.NOMBRE like '%ENGLISH%')
--   and mt.VER_EN_RECORD =1
    and p.IDENTIFICACION ='0922694161'
  and mt.estado='A'-- and pad.CG_PER_ACADEMICO<28570 and mt.ID_MATERIA_TOMADA not in (813864)

select ee.* from aca.equivalencia_examen_ubicacion ee
where --80 between ee.puntaje_inicial and ee.puntaje_final and
      ee.codigo='EXAMEN DE UBICACIÓN'

--  DBCC CHECKIDENT ('aca.estudiante_asignatura', RESEED, 286859);
select * from aca.fun_record_ingles_estudiante('0928274364')


---tickets de módulos de ingles
select * from aca.fn_consulta_modulos_aprobados('2450807702')

select * from aca.fun_record_ingles_estudiante('0928357185')

exec [aca].[sp_list_all_carreras_records] '2450807702',null,null,null,null

exec [aca].[sp_list_all_asignaturas_detalle_record] 22406,null,
    null,null,null,null,null

select * from aca.fn_consulta_modulos_aprobados('2450807702')

select * from aca.fun_record_ingles_estudiante('0915912380')
select * from aca.fun_record_ingles_estudiante_new('0915912380')

select * from aca.documentos_matricula where usuario_ing ='2450466848'

select * from aca.fun_asignaturas_ingles_vistas() where identificacion='0915912380'
and periodo not like '%PAE%'
SELECT [aca].[fn_nivel_ingles_descripcion]('INGLES I')

declare @asignatura varchar(150)='INGLES I'
select  ISNULL(
        (
            SELECT [aca].[fn_nivel_ingles_descripcion](
                           CASE
                               WHEN CHARINDEX('(', @asignatura) > 0
                                   THEN RTRIM(LEFT(@asignatura, CHARINDEX('(', @asignatura) - 1))
                               ELSE @asignatura
                               END
                   )
        ),
        (
            SELECT [aca].[fn_nivel_ingles_descripcion](@asignatura)
        )
              )

declare @asignatura varchar(150)='INGLES I'
   select          ISNULL( null, (
                    SELECT ma.id_malla_asignatura FROM bd_sga_upse.aca.malla_asignatura ma
                    WHERE ma.estado = 'A' AND ma.id_malla = 20 AND ma.id_nivel = (
                            ISNULL(
                                (
                                    SELECT [aca].[fn_nivel_ingles_descripcion](
                                        CASE
                                            WHEN CHARINDEX('(', @asignatura) > 0
                                            THEN RTRIM(LEFT(@asignatura, CHARINDEX('(', @asignatura) - 1))
                                            ELSE @asignatura
                                        END
                                    )
                                ),
                                (
                                    SELECT [aca].[fn_nivel_ingles_descripcion](@asignatura)
                                )
                            )
                        )
                )
            )


select * from Bd_Academico.dbo.MATERIAS_TOMADAS mt where mt.ID_MATERIA_TOMADA = 888531

select ma.id_malla_asignatura,ma.id_nivel,
       ea.* from aca.estudiante_matricula em
left join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
left join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
left join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
where em.id_estudiante_oferta = 36741

--  DBCC CHECKIDENT ('aca.estudiante_matricula', RESEED, 68290);

exec [aca].[sp_list_all_carreras_records] '2450824152',null,null,null,null

exec [aca].[sp_list_all_asignaturas_detalle_record] 37594,null,
    null,null,null,null,null
select * from aca.oferta where id_oferta = 18

select top 10 * from aca.estudiante_asignatura
order by id_estudiante_asignatura desc

select top 3 * from aca.estudiante_matricula
order by fecha_ing desc

select * from aca.malla_asignatura ma where ma.estado ='A' and ma.id_malla = 20

select * from dbo.estudiantes_matriz_excel ex
where fecha_ingeso is not null

select * from dbo.estudiantes_matriz_excel ex
where cedula ='2450128257'

select ex.cedula,ex.asignatura,count(ex.nota) from dbo.estudiantes_matriz_excel ex
group by ex.cedula, ex.asignatura
having count(ex.nota)>2

select ex.* from dbo.estudiantes_matriz_excel ex
where ex.cedula in (select d.cedula from (
select ex1.cedula,ex1.asignatura,count(ex1.nota)as contador from dbo.estudiantes_matriz_excel ex1 where ex1.estado='A'
group by ex1.cedula, ex1.asignatura
having count(ex1.nota)>1) as d)
and ex.asignatura in (select d.asignatura from (
select ex1.cedula,ex1.asignatura,count(ex1.nota)as contador from dbo.estudiantes_matriz_excel ex1 where ex1.estado='A'
group by ex1.cedula, ex1.asignatura
having count(ex1.nota)>1) as d)
order by ex.apellidos,ex.nombre

select * from tmp.EXAMEN_UBICACION eu where eu.CEDULA='2450128257'

 EXEC [aca].[sp_migrate_notas_ingles_to_estudiante_matricula_by_estudiante] '2450128257',null

select eo.id_estudiante_oferta,om.id_oferta_modalidad,o.descripcion,p.identificacion,concat(p.apellidos,' ',p.nombres) as nombres,
                   ex.asignatura,ex.nota,
                   (select d.id_nivel from  [aca].[fn_get_info_asignatura_ingles](ex.asignatura) as d) as id_nivel_nuevo,
                   (select dd.nivel_ingles from  [aca].[fn_get_info_asignatura_ingles](ex.asignatura) as dd) as nivel_nuevo,
                   (select ddd.id_malla_asignatura from  [aca].[fn_get_info_asignatura_ingles](ex.asignatura) as ddd) as id_malla_asignatura,
                   ex.periodoAcademico
            from dbo.estudiantes_matriz_excel ex
            inner join man.personas p on p.identificacion = ex.cedula
            inner join aca.estudiante_oferta eo on eo.id_persona = p.id
            inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
            inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
            inner join aca.oferta o on om.id_oferta = o.id_oferta
            where tee.codigo in ('ACT') and o.id_tipo_oferta = 4
            and ex.fecha_ingeso is not null and p.identificacion in ('2450206004')
            order by o.descripcion,p.apellidos,p.nombres


 select ea.*
--    pa.codigo,om.id_oferta_modalidad,o.descripcion,p.identificacion,p.apellidos,p.nombres,ma.id_nivel,ma.id_malla_asignatura,a.descripcion,ea.promedio,ea.estado,em.estado,ea.fecha_ing,ea.fecha_mod,ea.usuario_ing,
--    per.apellidos,per.nombres
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
    inner join man.personas per on per.identificacion = ea.usuario_mod
    where eo.estado='A' and em.estado='A' and mg.estado='A' and om.estado='A' and pa.estado='A'  and o.id_tipo_oferta = 4 --and ea.estado='A'
--     and pa.id_periodo_academico = 27 and om.id_oferta_modalidad = 91 and ma.id_nivel = 7 and ma.id_malla_asignatura = 1973 and ea.aprobado = 1
    and p.identificacion in ('2450836180')

order by p.apellidos,p.nombres


select top 10 * from aca.detalle_movilidad
order by id_detalle_movilidad desc


select --p.identificacion,p.apellidos,p.nombres,a.descripcion,
dm.* from aca.detalle_movilidad dm
inner join aca.movilidad m on dm.id_movilidad = m.id_movilidad
inner join aca.malla_asignatura ma on dm.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
inner join aca.estudiante_oferta eo on m.id_estudiante_oferta = eo.id_estudiante_oferta
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join man.personas p on p.id = eo.id_persona
where P.identificacion='2450128257' and o.id_tipo_oferta =4

select * from aca.periodo_academico where id_tipo_oferta = 4

select top 10 eo.*
 from aca.estudiante_oferta eo
                     inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
                     inner join aca.oferta o on om.id_oferta = o.id_oferta
                     inner join man.personas p on p.id = eo.id_persona
where o.id_tipo_oferta =4 and eo.estado='A'
order by id_estudiante_oferta desc

select tmf.* from aca.matricula_general mg
                     inner join aca.tipo_matricula_fecha tmf on mg.id_matricula_general = tmf.id_matricula_general
where mg.id_periodo_academico =25

select * from aca.periodo_academico where id_periodo_academico = 134

select * from pro.proceso_etapa_ejecucion

select ea.* from aca.estudiante_oferta eo
                     inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
                     inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
where eo.id_estudiante_oferta = 38909

select ec.* from aca.acta_calificacion ac
                                   inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
                                   inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
                                   inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ec.id_estudiante_oferta
where eo.id_estudiante_oferta = 38909 and cg.id_periodo_academico =43

select top 1 * from aca.estudiante_oferta
select * from aca.tipo_estudiante
select * from aca.tipo_ingreso_estudiante
select * from aca.tipo_estado_estudiante

select * from aca.ofertas_facultad where id_oferta in (40,41,25,59,60,36)


select   distinct  pa.codigo,d.nombre,o.descripcion,p.identificacion,p.apellidos,p.nombres,
                 eo.numero_matricula,(select top 1 n.orden from  [aca].[fun_record_ingles_estudiante](p.identificacion)  as d
                                          inner join aca.nivel  n on n.id_nivel = d.id_nivel order by d.id_nivel desc),o2.descripcion as carrera_grado
from man.personas p
         inner join aca.estudiante_oferta eo on p.id = eo.id_persona
        inner join aca.estudiante_oferta eo2 on eo2.id_persona = eo.id_persona
        inner join aca.oferta_modalidad om2 on eo2.id_oferta_modalidad = om2.id_oferta_modalidad
        inner join aca.oferta o2 on om2.id_oferta = o2.id_oferta
         INNER join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
         inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
         inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
         left join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.departamento_oferta do on o.id_oferta = do.id_oferta
         inner join man.departamentos d on do.id_departamento = d.id
where o.id_tipo_oferta = 4 and eo.estado='A' and eo2.estado='A' and o2.id_tipo_oferta = 2 --pa.id_tipo_oferta = 4 and


    select * from mig.record_asignaturas where periodo <'2000-1'

--requisitos ingles
select ar.* from aca.malla m
                     inner join aca.malla_asignatura ma on m.id_malla = ma.id_malla
                     inner join aca.asignatura_relacion ar on ma.id_malla_asignatura = ar.id_malla_asignatura
where m.id_malla = 20



select * from aca.tipo_matricula_fecha

select p.identificacion,m.matricula,p.APELLIDOS as apellidos, p.NOMBRES as nombres,
--mt.ID_NIVEL,
tipo=CASE
         WHEN mt.ID_NIVEL IN (11,30)  THEN 'EXTRACURRICULAR'
         WHEN mt.ID_NIVEL IN (1,2,3,4,5,6,7,8,9,10) THEN 'CURRICULAR'
         WHEN mt.ID_NIVEL IN (13,14,15,21,22) THEN 'CURRICULAR'
         WHEN mt.ID_NIVEL IN (38,47,48,49,50,51) THEN 'EXTRACURRICULAR'
         ELSE 'OTROS'
           END,
       mt.id_nivel as idNivel,
periodo = (select valor_texto from Bd_Academico.dbo.TP_CODIGOS where CORRELATIVO=pad.CG_PER_ACADEMICO),
-- rm.id_destino as idMallaAsignatura,
--modulos aprobados en carrera quitar si se daña
    iif(mt.ID_NIVEL IN (1,2,3,4,5,6,7,8,9,10,13,14,15,21,22) and a.NOMBRE='INGLES I',1393,rm.id_destino) as idMallaAsignatura,
    'sistema 2007-2021' as sistema,
    a.NOMBRE as asignatura,
    c.NOMBRE as oferta,
    mt.PROMEDIO AS nota,
    mt.APROBADO AS aprobado,
    iif(mp.HORAS_SISTEMA is null, 0,  mp.HORAS_SISTEMA) as horas,
    iif( mp.CREDITOS is null, 0,   mp.CREDITOS) as creditos,
    mt.estado,pad.CG_PER_ACADEMICO
from Bd_Academico.dbo.MATERIAS_TOMADAS mt
         inner join Bd_Academico.dbo.periodos_academicos pad on pad.ID_DETALLE=mt.id_detalle_periodo
         inner join Bd_Academico.dbo.TE_MATRICULAS m on mt.ID_MATRICULA=m.ID_MATRICULA
         inner join Bd_Academico.dbo.PERSONAS p on m.ID_PERSONA=p.ID_PERSONA
--inner join Bd_Academico.dbo.VW_MATERIAS_PLAN mp on mp.ID_MATERIA_PLAN=mt.ID_MATERIA_PLAN
         left join Bd_Academico.dbo.MATERIAS_PLAN mp on mp.ID_MATERIA_PLAN=mt.ID_MATERIA_PLAN
         left join migracion_sga.dbo.registros_migracion rm on  rm.id_origen = mp.ID_MATERIA_PLAN and id_entidad_relacion = 5
         inner join Bd_Academico.dbo.MATERIAS a on mp.ID_MATERIA=a.ID_MATERIA
         inner join Bd_Academico.dbo.PLAN_ESTUDIOS pl on pl.ID_PLAN=mp.ID_PLAN
         inner join  Bd_Academico.dbo.CARRERAS_LOCALES_MODALIDAD_SISTEMA c on pl.ID_CARRERA_OFERTADA=c.ID_CARRERA_OFERTADA
--inner join Bd_Academico.dbo.NIVELES n on n.ID_NIVEL=mp.ID_NIVEL
where (a.NOMBRE like '%INGLES%' or a.NOMBRE like '%ENGLISH%')
  and mt.VER_EN_RECORD =1 and p.IDENTIFICACION ='2450072471'
  and mt.estado='A' and pad.CG_PER_ACADEMICO<28570

select * from tmp.modulos_ingles_matrices where identificacion='0915444400'


select * from tmp.EXAMEN_UBICACION
where CEDULA='2450746488'

select * from MOODLE_INGLES_INTENSIVO

select * from aca.matricula_general

select * from aca.tipo_matricula_fecha

select * from aca.periodo_academico where id_tipo_oferta = 4

select --o.codigo,o.nombre,
       uo.* from seg.usuario_opcion uo
                     inner join man.opciones o on uo.id_opcion = o.id
where uo.id_usuario = 10922-- and uo.estado='A'

select * from man.opciones where opciones.codigo like '%matricula-modulo-requisito%'

select * from seg.usuarios where usuario='2450603846'

select * from aca.acta_calificacion

select * from aca.acta_apertura_componente

select * from pro.proceso_requisito

select * from aca.fn_requisitos_matricula(57527,129)

select * from aca.periodo_academico_oferta where id_periodo_academico = 129

select * from man.personas p where p.apellidos like '%gutierrez%' and p.nombres like '%Mi%'

select eo.* from aca.estudiante_oferta eo
                     INNER JOIN man.personas p ON p.id= eo.id_persona
                     INNER JOIN aca.requisito_nivel_estudiante rne ON rne.id_nivel= eo.id_nivel_proyectado
                     INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = rne.id_matricula_general
                     INNER JOIN pro.proceso_requisito pr ON pr.id_proceso_requisito= rne.id_proceso_requisito
where eo.id_estudiante_oferta = 37665

select distinct rne.* from aca.estudiante_oferta eo
                     INNER JOIN man.personas p ON p.id= eo.id_persona
                     INNER JOIN aca.requisito_nivel_estudiante rne ON rne.id_nivel= eo.id_nivel_proyectado
                     INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = rne.id_matricula_general
                     INNER JOIN pro.proceso_requisito pr ON pr.id_proceso_requisito= rne.id_proceso_requisito
where mg.id_periodo_academico  = 129


select pr.descripcion,rne.* from aca.requisito_nivel_estudiante rne
                     INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = rne.id_matricula_general
                     INNER JOIN pro.proceso_requisito pr ON pr.id_proceso_requisito= rne.id_proceso_requisito
                    inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
where pa.id_tipo_oferta = 4

select distinct pr.* from aca.requisito_nivel_estudiante rne
                                     INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = rne.id_matricula_general
                                     INNER JOIN pro.proceso_requisito pr ON pr.id_proceso_requisito= rne.id_proceso_requisito
where mg.id_periodo_academico = 129

select * from aca.nivel where id_tipo_oferta = 4

select eo.* from aca.estudiante_oferta eo
inner join man.personas p on eo.id_persona = p.id
where identificacion='2450314477'
select *
    FROM
        aca.estudiante_oferta eo
        INNER JOIN man.personas p ON p.id= eo.id_persona
    INNER JOIN aca.requisito_nivel_estudiante rne ON rne.id_nivel= eo.id_nivel_proyectado
    INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = rne.id_matricula_general
    INNER JOIN pro.proceso_requisito pr ON pr.id_proceso_requisito= rne.id_proceso_requisito
WHERE
    mg.id_periodo_academico= 129
    --mg.id_periodo_academico= 30
  AND pr.estado= 'A'
  AND mg.estado= 'A'
  AND rne.estado= 'A'
  AND eo.id_estudiante_oferta= 38386

select * from aca.matricula_fecha_nivel

select * from aca.tipo_matricula_fecha

select rv.*
			 from aca.Reglamento_Validacion rv
			 inner join aca.Reglamento r on r.id_reglamento = rv.id_reglamento
			 inner join aca.Matricula_General mg on mg.id_reglamento = r.id_reglamento
			 inner join aca.validacion va on rv.id_validacion = va.id_validacion
			 where mg.id_periodo_academico = 129

select o.descripcion,om.id_oferta_modalidad,pao.puntaje_minimo_admision
-- pao.*
from aca.periodo_academico_oferta pao
inner join aca.oferta_modalidad om on pao.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         where pao.id_periodo_academico =95 and pao.estado='A'

select * from mig.record_oferta where apellidos like 'PECAS'

select * from [pro].[fn_list_All_Estudiantes_Postulantes_By_Oferta](null,35,null,null)
where identificacion ='2450248683'

select id_periodo_academico,codigo,descripcion,fecha_desde,fecha_hasta from aca.periodo_academico where id_tipo_oferta = 4

select top 10 eo.*
from aca.estudiante_oferta eo
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join man.personas p on p.id = eo.id_persona
where o.id_tipo_oferta =4 and eo.estado='A'
order by id_estudiante_oferta desc
--     35188
select top 98 --eo.id_estudiante_oferta,em.id_estudiante_matricula,em.estado,p.identificacion,p.apellidos,p.nombres,o.descripcion,te.descripcion,tee.descripcion,tie.descripcion,eo.mantiene_gratuidad,eo.id_malla
       eo.*
from aca.estudiante_oferta eo
         inner join man.personas p on eo.id_persona = p.id
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
         inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
        left join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
where  --eo.estado='I' and eo.fecha_desde ='2023-06-01'
       eo.id_estudiante_oferta = 35262
---estudiantes que tienen modulos de ingles en su oferta de grado
begin
    declare @id_periodo_academico int=95
    select distinct eo.id_estudiante_oferta,em.id_estudiante_matricula,ea.id_estudiante_asignatura,eo.id_persona,pa.codigo,om.facultad,om.carrera,p.identificacion,p.apellidos,p.nombres,
                    a.descripcion as modulo,ea.promedio,ea.aprobado,eoc.id_estudiante_oferta,tee.descripcion,te.descripcion,tie.descripcion,eo.mantiene_gratuidad
--         update em set em.id_estudiante_oferta = eoc.id_estudiante_oferta,em.usuario_mod ='2400254286',em.fecha_mod= getdate()
    from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
    inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
    inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
    inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
    inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
    inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
    inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    left join aca.estudiante_oferta eoc on eoc.id_persona = eo.id_persona and eoc.id_oferta_modalidad = 18 and eoc.estado='A'
    left join aca.estudiante_oferta eoh on eoh.id_estudiante_oferta_padre = EO.id_estudiante_oferta and eoh.id_oferta_modalidad <>18
    where --eo.id_estudiante_oferta = 11006
--         mg.id_periodo_academico = @id_periodo_academico and
        om.id_tipo_oferta = 2 and eoc.id_estudiante_oferta is not null --and a.descripcion='INGLES IV'
       and ea.estado='A' and aa.estado='A' and ma.estado='A' and em.estado='A' and ma.id_malla_asignatura in (1393,1394,1395,1396,1416)
--     order by om.carrera,p.apellidos,p.nombres
end;

select * from aca.titulos_academicos
select * from aca.fn_listar_docentes_asignaturas(null,18,132) as d

select * from man.lugar where id_lugar_padre = 270

--personas que tienen su movilidad de ingles en la carrera de grado y no en la de centro de idiomas
--     2450518572
BEGIN
    DECLARE @pi_id_periodo_academico INT = 96,
            @pi_id_malla_asignatura INT = 1571,
            @pi_id_paralelo INT = 1,
            @pi_id_clase INT = 8557;

    ;
WITH DatosBase AS (
        SELECT
            cc.id_clase, ch.id_contenidos AS idContenido, CONCAT(c.orden, '.', ch.orden) AS tema, c.descripcion AS unidad,  ch.descripcion,ch.horas_sincronica as horasSincronica ,
            ISNULL((
                    SELECT SUM(clc.horas)
                    FROM aca.clase cl
                    INNER JOIN aca.clase_contenido clc ON cl.id_clase = clc.id_clase
                    WHERE cl.estado = 'A'
                      AND clc.estado = 'A'
                      AND cl.id_periodo_academico = @pi_id_periodo_academico
                      AND cl.id_malla_asignatura = @pi_id_malla_asignatura
                      AND cl.id_paralelo = @pi_id_paralelo
                      AND clc.id_contenido = ch.id_contenidos
                      AND (@pi_id_clase IS NULL OR clc.id_clase <> @pi_id_clase)
                ), 0) AS horasYaIngresadas,
            cc.id_clase_contenido AS id, ISNULL(cc.horas,0) AS horas_asignadas_actuales,cl.duracion as horas_disponibles
        FROM aca.silabo s
        INNER JOIN aca.silabo_periodo_academico spa ON s.id_silabo = spa.id_silabo
        INNER JOIN aca.malla_asignatura ma ON s.id_malla_asignatura = ma.id_malla_asignatura
        INNER JOIN aca.contenidos c ON s.id_silabo = c.id_silabo
        INNER JOIN aca.contenidos ch ON c.id_contenidos = ch.id_contenido_padre
        LEFT JOIN aca.clase cl ON cl.id_malla_asignatura = ma.id_malla_asignatura AND spa.id_periodo_academico = cl.id_periodo_academico AND cl.id_clase = @pi_id_clase  AND cl.estado = 'A'
        LEFT JOIN aca.clase_contenido cc ON cc.id_clase = cl.id_clase AND cc.id_contenido = ch.id_contenidos  AND cc.estado = 'A'
        WHERE s.estado IN ('A', 'P') AND c.estado = 'A' AND ch.estado = 'A' AND spa.estado = 'A' AND spa.id_periodo_academico = @pi_id_periodo_academico AND ma.id_malla_asignatura = @pi_id_malla_asignatura
    ),
    DatosConAcumulado AS (
        SELECT *,
               SUM(iif(horasSincronica<0,0,horasSincronica)) OVER (ORDER BY tema ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS horasAcumuladas
        FROM DatosBase
    ),
    ConSeleccion AS (
        SELECT *,
            LAG(horasAcumuladas, 1, 0) OVER (ORDER BY tema ASC) AS horasAntes
        FROM DatosConAcumulado
    )
    SELECT
        id_clase,
        idContenido,
        tema,
        unidad,
        descripcion,
        -- Mostrar solo el tiempo que se puede dictar en esta clase
        CASE
            WHEN horasAcumuladas <= horas_disponibles THEN horasSincronica
            WHEN horasAntes < horas_disponibles THEN horas_disponibles - horasAntes
            ELSE 0
        END AS horasSincronica,horasYaIngresadas,horasAntes,horasAcumuladas,
        id,
        horas_disponibles,
        -- Mostrar cuánto falta para completar
        CASE
            WHEN horasAcumuladas <= horas_disponibles THEN 0
            WHEN horasAntes < horas_disponibles THEN horasSincronica - (horas_disponibles - horasAntes)
            ELSE horasSincronica
        END AS horasRestantesPorDictar
    FROM ConSeleccion
    where horasYaIngresadas<horasSincronica
--     WHERE horasAntes < horas --and  horasSincronica>0
    ORDER BY tema ASC
end

-- update ec set ec.calificacion = round(FORMATIVA_1,0)
-- update ec set ec.calificacion = round(SUMATIVA_1,0)
-- update ec set ec.calificacion = round(FORMATIVA_1,0)+round(SUMATIVA_1,0)
select
    distinct ac.id_ciclo,c.descripcion,ma.id_malla_asignatura,a.descripcion,ec.id_estudiante_oferta,ec.id_componente_aprendizaje,
             ac.id_paralelo,ca.descripcion,round(SUMATIVA_1,0) as nota,ec.calificacion,p.apellidos,p.nombres,p.identificacion
--        ec.*
    from aca.acta_calificacion ac
    inner join aca.ciclo c on ac.id_ciclo = c.id_ciclo
    inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
    inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
    inner join aca.estudiante_oferta eo on ec.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join man.personas p on p.id = eo.id_persona
    inner join tmp.modulos_ingles_buckin b on b.useridnumber = p.identificacion and b.id_malla_asignatura =ac.id_malla_asignatura
    inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
    inner join aca.malla_asignatura ma on ma.id_malla_asignatura = ac.id_malla_asignatura
    inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where cg.id_periodo_academico =141 and ma.id_malla_asignatura  in (1393,1394) and ca.id_componente_aprendizaje =9 and c.id_ciclo = 1


select * from aca.periodo_academico where id_tipo_oferta = 4

select * from aca.componente_aprendizaje where id_componente_aprendizaje in (1,9,10)

select * from tmp.modulos_ingles_buckin

SELECT * FROM aca.fn_generar_codigos_buck(150) ORDER BY modulo,jornada desc, apellidos, nombres
SELECT * FROM aca.fn_generar_codigos_buck_v2(150) ORDER BY modulo, apellidos, nombres
select  * from aca.oferta  where id_tipo_oferta = 1
begin
    declare @id_periodo_academico int = 150;
WITH Base AS (
    SELECT
        n.orden,
        p.identificacion AS cedula,
        p.apellidos,
        p.nombres,
        ISNULL(p.email_institucional, p.email_personal) AS correo_electronico,
        ISNULL(d.descripcion, 'NINGUNA') AS discapacidad,
        ISNULL(NULLIF(p.porcentaje_dis, ''), '0') AS porcentaje_discapacidad,iif(tjl.codigo='NOCTURNA','SÁBADOS',tjl.descripcion) as jornada,em.fecha_ing,em.fecha_mod,
        -- El ROW_NUMBER se calcula sobre los resultados ya agrupados
        ROW_NUMBER() OVER (
            PARTITION BY n.orden
            ORDER BY p.apellidos, p.nombres
            ) AS rn
    FROM aca.estudiante_oferta eo
             INNER JOIN man.personas p ON p.id = eo.id_persona
             LEFT JOIN man.discapacidad d ON p.id_discapacidad = d.id_discapacidad
             INNER JOIN aca.estudiante_matricula em ON em.id_estudiante_oferta = eo.id_estudiante_oferta
             inner join aca.tipo_jornada_laboral tjl  on em.id_tipo_jornada_laboral = tjl.id_tipo_jornada_laboral
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
      AND pa.id_periodo_academico = @id_periodo_academico -- Parámetro dinámico
--           AND n.orden IN (1, 2)  2026-0
--           AND n.orden IN (2,3)
      AND p.estado = 'AC'
    GROUP BY
        n.orden, p.identificacion, p.apellidos, p.nombres,
        p.email_institucional, p.email_personal,
        d.descripcion, p.porcentaje_dis, tjl.codigo, tjl.descripcion, em.fecha_ing, em.fecha_mod
)
SELECT
    CONCAT(
            'BUCK-M',
            orden,
            '-P',
            RIGHT('0' + CAST(((rn - 1) / 200 + 1) AS VARCHAR(2)), 2),
            '-2026-1' -- Nota: Este sufijo está "quemado", considera tomarlo de la tabla periodo si cambia
    ) AS codigo,
    orden AS modulo,
    cedula,
    apellidos,
    nombres,
    correo_electronico,
    discapacidad,
    porcentaje_discapacidad,jornada,
    iif(cast(fecha_ing as date)<> cast(fecha_mod as date) or cast(fecha_ing as date)>='2026-06-08','RESPETAR JORNADA','ALEATORIO') as respetarJornada
FROM Base
ORDER BY modulo,respetarJornada desc
end

select d.descripcion as dia,r.*,ef.descripcion as aula from aca.horario_relex r
inner join aca.dia d on r.id_dia = d.id_dia
inner join aca.espacio_fisico ef on r.id_espacio_fisico = ef.id_espacio_fisico

select distinct eo.id_estudiante_oferta,eop.id_estudiante_oferta,eo.id_estudiante_oferta_padre,ofa1.carrera,ofa.carrera,p.identificacion,p.apellidos,p.nombres
--     update eo set eo.id_estudiante_oferta_padre=eop.id_estudiante_oferta
from  aca.estudiante_oferta eo
     INNER JOIN man.personas p ON p.id = eo.id_persona
    inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
     inner join aca.estudiante_oferta eop on eop.id_persona = eo.id_persona
     inner join aca.ofertas_facultad ofa1 on ofa1.id_oferta_modalidad = eop.id_oferta_modalidad and ofa1.id_tipo_oferta = 2 and eop.id_tipo_estado_estudiante =1
WHERE eo.estado = 'A' and eop.estado='A' and ofa.id_tipo_oferta in (4) and eo.id_tipo_estado_estudiante = 1 and eo.id_estudiante_oferta_padre is null

select * from aca.fun_record_ingles_estudiante('2450878158')
select * from aca.fun_record_ingles_estudiante('2450134586')

exec [aca].[sp_list_all_carreras_records] '2450134586',null,null,null,null

alter FUNCTION [aca].[fun_record_ingles_estudiante](@identificacion varchar(10))
    RETURNS TABLE
        AS
        RETURN
        (
        WITH CTE AS (
            SELECT
                hi.identificacion, hi.matricula,hi.apellidos,hi.nombres,hi.tipo,hi.id_nivel,
                ISNULL(
                        (
                            SELECT [aca].[fn_nivel_ingles_descripcion](
                                           CASE
                                               WHEN CHARINDEX('(', hi.asignatura) > 0
                                                   THEN RTRIM(LEFT(hi.asignatura, CHARINDEX('(', hi.asignatura) - 1))
                                               ELSE hi.asignatura
                                               END
                                   )
                        ),
                        (
                            SELECT [aca].[fn_nivel_ingles_descripcion](hi.asignatura)
                        )
                ) AS nivelNuevoSistema, hi.periodo, ISNULL( iif(hi.idMallaAsignatura=2950,1394,hi.idMallaAsignatura), (
                SELECT ma.id_malla_asignatura FROM bd_sga_upse.aca.malla_asignatura ma
                WHERE ma.estado = 'A' AND ma.id_malla = 20 AND ma.id_nivel = (
                    ISNULL(
                            (
                                SELECT [aca].[fn_nivel_ingles_descripcion](
                                               CASE
                                                   WHEN CHARINDEX('(', hi.asignatura) > 0
                                                       THEN RTRIM(LEFT(hi.asignatura, CHARINDEX('(', hi.asignatura) - 1))
                                                   ELSE hi.asignatura
                                                   END
                                       )
                            ),
                            (
                                SELECT [aca].[fn_nivel_ingles_descripcion](hi.asignatura)
                            )
                    )
                    )
            )
                                                    ) AS idMallaAsignatura,hi.sistema,hi.asignatura,hi.oferta,hi.nota, hi.aprobado,hi.horas,hi.creditos,hi.estado,hi.idPeriodoAcademico,
                ROW_NUMBER() OVER (PARTITION BY hi.periodo, hi.asignatura ORDER BY CASE WHEN hi.aprobado = 1 THEN 0 ELSE 1 END) AS rn
            FROM aca.fun_asignaturas_ingles_vistas() hi
            WHERE hi.identificacion IN (
                SELECT TOP 1 identificacion FROM bd_sga_upse.aca.estudiante_oferta eo
                                                     INNER JOIN man.personas p ON eo.id_persona = p.id AND p.identificacion IN (@identificacion)
            )
              AND hi.tipo in ('EXTRACURRICULAR','CURRICULAR')
--         AND (
--             NOT EXISTS (
--                 SELECT 1 FROM aca.fun_asignaturas_ingles_vistas() hi2 WHERE hi2.identificacion = hi.identificacion
--                 AND hi2.asignatura = hi.asignatura
-- --                 AND hi2.aprobado = 1
--                 AND hi.sistema != hi2.sistema
--             ) OR hi.aprobado = 1
--         )
        )
        SELECT identificacion, matricula, apellidos, nombres, tipo, id_nivel,  nivelNuevoSistema, periodo, idMallaAsignatura,  sistema,
               asignatura, oferta, nota, aprobado, horas, creditos, estado, idPeriodoAcademico FROM CTE
        WHERE rn = 1 and  periodo not like '%PAE%'     --dobles matriculas
          AND (  identificacion <> '2450878158' OR sistema = 'sistema 2022-actualidad')
        )
go

---set estudiante oferta padre en centro de idiomas
begin
    declare @id_periodo_academico int=95
    select distinct eo.id_estudiante_oferta,eoa.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.id_persona,
                    pa.codigo as periodo,om.facultad,om.carrera,tee.descripcion,te.descripcion,tie.descripcion,omp.facultad as facultadGrado,omp.carrera as carreraGrado,
                    eo2.tipo_ingreso_estudiante,eo2.tipo_estudiante,eo2.estado_carrera,
                    p.identificacion,p.apellidos,p.nombres,eo.mantiene_gratuidad
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
             inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
--              inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta

             inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
             inner join aca.estudiante_oferta eoa on eoa.id_persona = eo.id_persona and eoa.id_oferta_modalidad <> 18 and eoa.id_tipo_estado_estudiante in (1) -- in (1,4,5,17)
--              left join aca.estudiante_oferta eop on eop.id_estudiante_oferta = eo.id_estudiante_oferta_padre
             inner join aca.ofertas_facultad omp on omp.id_oferta_modalidad = eoa.id_oferta_modalidad
             inner join aca.estudiantes_ofertas eo2 on eo2.id_estudiante_oferta = eoa.id_estudiante_oferta
             inner join aca.periodo_academico pa on pa.id_periodo_academico = eoa.id_periodo_academico
    where  om.id_tipo_oferta = 4 and eo.estado='I' and eo.id_estudiante_oferta_padre is null and omp.id_tipo_oferta = 2 --and omp.id_oferta not in (40,41,25,59,60,36,107,35,97)
--       and em.estado='A'
    order by  p.identificacion,pa.codigo
end;

begin
;WITH datos AS
          (
              SELECT DISTINCT
                  eo.id_estudiante_oferta,
                  eoa.id_estudiante_oferta AS id_estudiante_oferta_grado,
                  eo.id_estudiante_oferta_padre,
                  eo.id_persona,
                  pa.codigo AS periodo,
                  om.facultad,
                  om.carrera,
                  tee.descripcion,
                  te.descripcion as tipoEstudianteCI,
                  tie.descripcion as ingresoCI,
                  omp.facultad AS facultadGrado,
                  omp.carrera AS carreraGrado,
                  eo2.tipo_ingreso_estudiante,
                  eo2.tipo_estudiante,
                  eo2.estado_carrera,
                  p.identificacion,
                  p.apellidos,
                  p.nombres,
                  eo.mantiene_gratuidad
              FROM man.personas p
                       INNER JOIN aca.estudiante_oferta eo ON eo.id_persona = p.id
                       INNER JOIN aca.tipo_estado_estudiante tee ON tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
                       INNER JOIN aca.tipo_estudiante te ON eo.id_tipo_estudiante = te.id_tipo_estudiante
                       INNER JOIN aca.tipo_ingreso_estudiante tie ON eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
--                        INNER JOIN aca.estudiante_matricula em ON em.id_estudiante_oferta = eo.id_estudiante_oferta
                       INNER JOIN aca.ofertas_facultad om ON om.id_oferta_modalidad = eo.id_oferta_modalidad
                       INNER JOIN aca.estudiante_oferta eoa ON eoa.id_persona = eo.id_persona
                  AND eoa.id_oferta_modalidad <> 18
                  AND eoa.id_tipo_estado_estudiante IN (1)
                       INNER JOIN aca.ofertas_facultad omp ON omp.id_oferta_modalidad = eoa.id_oferta_modalidad
                       INNER JOIN aca.estudiantes_ofertas eo2 ON eo2.id_estudiante_oferta = eoa.id_estudiante_oferta
                       INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = eoa.id_periodo_academico
              WHERE om.id_tipo_oferta = 4 and eo.estado='A'
                AND eo.id_estudiante_oferta_padre IS NULL
--                 AND em.estado = 'A'
                   and omp.id_oferta not in (40,41,25,59,60,36,107,35,97)
                AND omp.id_tipo_oferta = 2
          ),
      carreras AS
          (
              SELECT identificacion,
                     COUNT(*) AS totalCarreras
              FROM
                  (
                      SELECT DISTINCT identificacion, carreraGrado
                      FROM datos
                  ) t
              GROUP BY identificacion
          )

 SELECT d.*
--  update eo set eo.id_estudiante_oferta_padre = d.id_estudiante_oferta_grado,eo.usuario_mod ='2400254286',eo.fecha_mod=getdate()
FROM datos d
  INNER JOIN carreras c ON c.identificacion = d.identificacion
  inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta =  d.id_estudiante_oferta
 WHERE c.totalCarreras = 1
-- order by d.periodo,d.identificacion;
end

BEGIN
    ;WITH datos AS
              (
                  SELECT DISTINCT
                      eo.id_estudiante_oferta, eoa.id_estudiante_oferta AS id_estudiante_oferta_grado,
                      eo.id_estudiante_oferta_padre, eo.id_persona, pa.codigo AS periodo,
                      om.facultad, om.carrera, tee.descripcion,
                      te.descripcion AS tipoEstudianteCI, tie.descripcion AS ingresoCI,
                      omp.facultad AS facultadGrado, omp.carrera AS carreraGrado,
                      eo2.tipo_ingreso_estudiante, eo2.tipo_estudiante, eo2.estado_carrera,
                      p.identificacion, p.apellidos, p.nombres, eo.mantiene_gratuidad
                  FROM man.personas p
                           INNER JOIN aca.estudiante_oferta eo ON eo.id_persona = p.id
                           INNER JOIN aca.tipo_estado_estudiante tee ON tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
                           INNER JOIN aca.tipo_estudiante te ON te.id_tipo_estudiante = eo.id_tipo_estudiante
                           INNER JOIN aca.tipo_ingreso_estudiante tie ON tie.id_tipo_ingreso_estudiante = eo.id_tipo_ingreso_estudiante
--                            INNER JOIN aca.estudiante_matricula em ON em.id_estudiante_oferta = eo.id_estudiante_oferta
                           INNER JOIN aca.ofertas_facultad om ON om.id_oferta_modalidad = eo.id_oferta_modalidad
                           INNER JOIN aca.estudiante_oferta eoa ON eoa.id_persona = eo.id_persona AND eoa.id_oferta_modalidad <> 18 AND eoa.id_tipo_estado_estudiante IN (1)
                           INNER JOIN aca.ofertas_facultad omp ON omp.id_oferta_modalidad = eoa.id_oferta_modalidad
                           INNER JOIN aca.estudiantes_ofertas eo2 ON eo2.id_estudiante_oferta = eoa.id_estudiante_oferta
                           INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = eoa.id_periodo_academico
                  WHERE om.id_tipo_oferta = 4 AND eo.id_estudiante_oferta_padre IS NULL
--                     AND em.estado = 'A'
                    AND omp.id_oferta NOT IN (40, 41, 25, 59, 60, 36, 107, 35, 97)
                    AND omp.id_tipo_oferta = 2
              ),
          carrerasOrdenadas AS
              (
                  SELECT d.*,
                         ROW_NUMBER() OVER
                             (
                             PARTITION BY d.id_persona
                             ORDER BY d.periodo DESC,
                                 d.id_estudiante_oferta_grado DESC
                             ) AS rn
                  FROM datos d
              )
     SELECT co.*
--     UPDATE eo SET eo.id_estudiante_oferta_padre = co.id_estudiante_oferta_grado,  eo.usuario_mod = '2400254286', eo.fecha_mod = GETDATE()
    FROM aca.estudiante_oferta eo
             INNER JOIN carrerasOrdenadas co ON co.id_estudiante_oferta = eo.id_estudiante_oferta
    WHERE co.rn = 1;
END;