use bd_sga_upse

---periodos

select id_periodo_academico,id_periodo_academico_anterior,id_periodo_academico_siguiente,codigo_tipo_periodo,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 2

select * from aca.periodo_academico where id_tipo_oferta = 2

--insert into aca.periodo_malla
select  --m.descripcion,m.id_oferta_modalidad,
        128, pm.id_malla, pm.estado, getdate(), 664, 0, getdate(), getdate(), '2400254286', '2400254286'
from aca.periodo_malla pm
inner join aca.malla m on pm.id_malla = m.id_malla
where pm.id_periodo_academico = 95 and pm.estado='A' --and m.id_oferta_modalidad in (56,58)
  and m.fecha_hasta is null
-- 93,97 56 y 58

select * from aca.periodo_malla where id_periodo_academico=126

--enlazar mallas al nuevo periodo
-- insert into  aca.periodo_academico_oferta
select 128, pao.id_oferta_modalidad, pao.id_reglamento, pao.habilitada_matricula,
       pao.codigo_cohorte, pao.num_cohorte, pao.cupo_nivelacion, pao.puntaje_minimo_admision, pao.maximo_creditos, pao.costo, pao.estado,
       pao.fecha_ingreso, pao.usuario_ingreso_id, pao.version, pao.fecha_ing, pao.fecha_mod, pao.usuario_ing, pao.usuario_mod from aca.periodo_academico_oferta pao
inner join aca.periodo_academico pa on pao.id_periodo_academico = pa.id_periodo_academico
inner join aca.oferta_modalidad om on pao.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
where pao.estado ='A' and pa.id_periodo_academico = 95

-- insert into aca.periodo_componente_aprendizaje
select distinct pao1.id_periodo_academico_oferta,pca.id_componente_aprendizaje, pca.valor, pca.estado, pca.version,getdate(),getdate(), pca.usuario_ing, pca.usuario_mod from aca.periodo_componente_aprendizaje pca
inner join aca.periodo_academico_oferta pao on pca.id_periodo_academico_oferta = pao.id_periodo_academico_oferta
inner join aca.periodo_academico pa on pao.id_periodo_academico = pa.id_periodo_academico
inner join aca.periodo_academico_oferta pao1 on pao1.id_periodo_academico = 139 and pao.id_oferta_modalidad = pao1.id_oferta_modalidad
inner join aca.ofertas_facultad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
where pao.estado='A' and pa.id_periodo_academico = 127

select distinct pca.* from aca.periodo_componente_aprendizaje pca
inner join aca.periodo_academico_oferta pao on pca.id_periodo_academico_oferta = pao.id_periodo_academico_oferta
inner join aca.periodo_academico pa on pao.id_periodo_academico = pa.id_periodo_academico
inner join aca.ofertas_facultad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
where pao.estado='A' and pa.id_periodo_academico = 127

select * from aca.componente_aprendizaje


-- DBCC CHECKIDENT ('aca.periodo_componente_aprendizaje', RESEED, 222);

---docentes ofertas
-- INSERT INTO aca.oferta_docente
select
    distinct  (select pao1.id_periodo_academico_oferta
         from aca.periodo_academico_oferta pao1
         where pao1.id_periodo_academico= 136
           and pao1.id_oferta_modalidad=pao.id_oferta_modalidad) ,d.id_docente, 'A', GETDATE(), 17041,0,getdate(),getdate(),'2400206005','2400206005',null
-- SELECT
--    distinct
--     dep.nombre AS departamento,
--     o.descripcion AS oferta,
--     p.identificacion AS identificacion,
--     CONCAT(p.apellidos,' ', p.nombres) AS docente, d.id_docente as idDocente
FROM aca.periodo_academico pa
    INNER JOIN aca.periodo_academico_oferta pao ON pa.id_periodo_academico = pao.id_periodo_academico
    INNER JOIN aca.oferta_docente od ON pao.id_periodo_academico_oferta = od.id_periodo_academico_oferta
    INNER JOIN aca.docente d ON od.id_docente = d.id_docente
    INNER JOIN man.personas p ON d.id_persona = p.id
    INNER JOIN aca.oferta_modalidad om ON pao.id_oferta_modalidad = om.id_oferta_modalidad
    INNER JOIN aca.oferta o ON om.id_oferta = o.id_oferta
    INNER JOIN aca.departamento_oferta dof ON dof.id_oferta = o.id_oferta
    INNER JOIN man.departamentos dep ON dof.id_departamento = dep.id
    inner join aca.docente_historial dh on d.id_docente = dh.id_docente
WHERE pa.estado = 'A'
  AND pao.estado = 'A'
  AND od.estado = 'A' and dh.observacion not in ('ART. 24')
  AND pa.id_periodo_academico in (96) and d.id_docente not in (
                      SELECT d.id_docente
                FROM aca.periodo_academico pa
                INNER JOIN aca.periodo_academico_oferta pao ON pa.id_periodo_academico = pao.id_periodo_academico
                INNER JOIN aca.oferta_docente od ON pao.id_periodo_academico_oferta = od.id_periodo_academico_oferta
                INNER JOIN aca.docente d ON od.id_docente = d.id_docente
                INNER JOIN man.personas p ON d.id_persona = p.id
                INNER JOIN aca.oferta_modalidad om ON pao.id_oferta_modalidad = om.id_oferta_modalidad
                INNER JOIN aca.oferta o ON om.id_oferta = o.id_oferta
                INNER JOIN aca.departamento_oferta dof ON dof.id_oferta = o.id_oferta
                INNER JOIN man.departamentos dep ON dof.id_departamento = dep.id
                WHERE pa.estado = 'A'  AND pao.estado = 'A'  AND od.estado = 'A'
                  AND pa.id_periodo_academico in (136)
    )


select * from aca.docente_historial

select * from aca.periodo_academico where codigo='2026-1'

select * from aca.oferta_docente

select * from aca.relacion_periodo_malla

select distinct pm.*,m.descripcion from aca.malla m
inner join aca.periodo_malla pm on m.id_malla = pm.id_malla
inner join aca.ofertas_facultad o on o.id_oferta_modalidad = m.id_oferta_modalidad
where o.id_tipo_oferta in (1,2) and m.fecha_hasta is null


-- poblacion activa grado
begin
    select
--     distinct  em.*
        --       distinct  ea.*--,p.identificacion
--     update eo set eo.id_nivel_proyectado =1
   distinct eo.*
--         distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo,eo.ultimo_periodo,ofa.facultad,ofa.carrera,p.identificacion,p.apellidos,p.nombres,tee.descripcion,tie.descripcion,eo.estado
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
    where --eo.id_periodo_academico = @id_periodo_academico and
         ofa.id_tipo_oferta=2 --and pa.codigo<'2022-1'
      and eo.id_tipo_estado_estudiante in (1) --and p.identificacion ='2400255440'
--     eo.id_tipo_estado_estudiante in (21,22)
end;




--crear periodo de matricula
select distinct mg.* from aca.matricula_general mg
left join aca.tipo_matricula_fecha mf on mg.id_matricula_general = mf.id_matricula_general
where mg.id_periodo_academico in (140,136,96)

select distinct mf.* from aca.matricula_general mg
inner join aca.tipo_matricula_fecha mf on mg.id_matricula_general = mf.id_matricula_general
where mg.id_periodo_academico in (141,136)
select * from aca.tipo_matricula_fecha

select uo.* from seg.usuario_opcion uo
inner join man.opciones o on uo.id_opcion = o.id
where uo.id_usuario in (14174,67222)

select * from seg.usuarios where usuario in ('2400255440','2450610940')

select d.* from aca.fn_listar_estudiantes_a_matricular (18,141) as d

select *from  [aca].[fn_listar_docentes_asignaturas_other_carreras](134,140) as d
---requisitos
select *from  [aca].[fn_listar_docentes_asignaturas](null,131,133) as d
select *from  [aca].[fn_listar_docentes_asignaturas](97521,null,136) as d


select * from aca.periodo_componente_aprendizaje pca
         inner join aca.periodo_academico_oferta pao on pca.id_periodo_academico_oferta = pao.id_periodo_academico_oferta
         where pao.id_periodo_academico in (127)
select * from aca.ofertas_facultad where id_tipo_oferta =3

select * from aca.periodo_academico_oferta where id_oferta_modalidad = 131


exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 78324,140,1,664
exec [aca].[pa_generar_asignaturas_a_matricular_sga] 26190,140,1,664
exec [aca].[pa_generar_asignaturas_a_matricular_sga] 81456,133,1,664
select *from  [aca].[fn_listar_docentes_asignaturas](78321,null,140) as d
select *from  [aca].[fn_listar_docentes_asignaturas_other_carreras](134,140) as d
---requisitos
select *from  [aca].[fn_listar_docentes_asignaturas](null,131,133) as d
select *from  [aca].[fn_listar_docentes_asignaturas](81456,null,133) as d


--relacionar mallas carreras
select ac.id_asignatura_compatibilidad,ac.tipo,m.id_malla,ma.id_malla_asignatura,ma.id_nivel,a.id_asignatura,a.descripcion as asignatura,m.descripcion,
       m1.id_malla,ma1.id_malla_asignatura,ma1.id_nivel,a1.id_asignatura,a1.descripcion as asignatura_compatible,m1.descripcion,ac.estado from aca.asignatura_compatibilidad ac
inner join aca.malla_asignatura ma on ac.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
inner join aca.malla_asignatura ma1 on ac.id_malla_asignatura_comp = ma1.id_malla_asignatura
inner join aca.malla m1 on ma1.id_malla = m1.id_malla
inner join aca.asignatura a1 on a1.id_asignatura = ma1.id_asignatura
where ma.estado='A' and a.estado='A' and m.estado in ('A','P') and ma1.estado='A' and a1.estado='A' and m1.estado in ('A','P')
  and ac.tipo in ('COMPATIBILIDAD ENTRE CARRERAS')

select * from aca.asignatura_compatibilidad where id_asignatura_compatibilidad in (235,236)

select m.id_malla,ma.id_malla_asignatura,ma.id_nivel,a.id_asignatura,a.descripcion as asignatura,m.descripcion from aca.malla_asignatura ma
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where m.id_oferta_modalidad in (90,38,134,29) and a.descripcion='FISICA I' and m.id_malla not in (41) or ma.id_malla_asignatura in (1144)

select m.id_malla,ma.id_malla_asignatura,ma.id_nivel,a.id_asignatura,a.descripcion as asignatura,m.descripcion from aca.malla_asignatura ma
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where m.id_oferta_modalidad in (90,38,134,29) and a.descripcion='SISTEMAS DE BASE DE DATOS I' or ma.id_malla_asignatura in (3258)

select m.id_malla,ma.id_malla_asignatura,ma.id_nivel,a.id_asignatura,a.descripcion as asignatura,m.descripcion from aca.malla_asignatura ma
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where m.id_oferta_modalidad in (83,33) and a.descripcion='FISICA II'

select * from aca.ofertas_facultad where id_tipo_oferta = 2 and id_departamento = 11



select * from par.discapacidad
select * from aca.asignatura_compatibilidad where id_malla_asignatura in (3298
    )
select * from [aca].[fn_Fechas_habilitas_matricula_cedula] ('2400208589')

select * from aca.fn_requisitos_matricula(54960,136)

select * from aca.estudiante_asignatura where id_numero_vez is null
select * from aca.numero_vez


select * from pro.proceso_requisito
select rne.* from aca.requisito_nivel_estudiante rne
inner join aca.matricula_general mg on rne.id_matricula_general = mg.id_matricula_general
where mg.id_periodo_academico = 136

select * from aca.matricula_fecha_nivel

select * from aca.tipo_matricula_fecha

select * from aca.fn_requisitos_matricula(45327,95)

select * from aca.fn_listar_docentes_asignaturas (45327,null,95)

select * from aca.tipo_matricula_fecha

select * from aca.requisito_nivel_estudiante where id_matricula_general =31

select * from pro.proceso_requisito where id_proceso_requisito = 6

--fechas por nivel
select distinct mfn.* from aca.matricula_fecha_nivel mfn
inner join aca.tipo_matricula_fecha tmf on mfn.id_tipo_matricula_fecha = tmf.id_tipo_matricula_fecha
inner join aca.matricula_general mg on mg.id_matricula_general = tmf.id_matricula_general
where mg.id_periodo_academico in (136)

select distinct tmf.* from aca.tipo_matricula_fecha tmf
inner join aca.matricula_general mg on mg.id_matricula_general = tmf.id_matricula_general
where mg.id_periodo_academico in (136)

select * from aca.moodle

select * from aca.periodo_academico where id_tipo_oferta = 4
select * from aca.nivel

-- DBCC CHECKIDENT ('aca.requisito_nivel_estudiante', RESEED, 517);
--requisitos de matricula
select distinct
    rn.*
--  rn.id_proceso_requisito,pr.descripcion,rn.id_nivel
from aca.requisito_nivel_estudiante rn
         inner join aca.matricula_general mg on rn.id_matricula_general = mg.id_matricula_general
         inner join pro.proceso_requisito pr on rn.id_proceso_requisito = pr.id_proceso_requisito
where mg.id_periodo_academico in (146) --rn.id_nivel = 1 and
--     pr.id_proceso_requisito = 6
--   and pr.id_proceso_requisito = 6
--     6	No tener deudas pendientes con la institución.
-- 7	No haber sido sancionado.
-- 24	El día actual corresponde a su día de matrícula según el calendario académico 2025 matrículas.
-- 25	No tener un proceso de movilidad cambio de carrera activo en el periodo actual.
-- 26	Haber completado en su totalidad la ficha socieconómica.
-- 27	Su carrera se encuentre habilitada para el proceso de matrícula 2025.
-- 153	"Tener el cupo de su carrera en estado ""Activo""."
-- 156	No debe tener matrícula  registrada en el periodo 2025-2.
--173 Ser estudiantes con asignaturas y/o créditos académicos pendientes por cursar, sea por reprobación o por no haberlas matriculado previamente.
--174 Examen Medico Subido por los estudiantes que van de nivelación a primer semestre

select * from aca.estudiante_oferta where id_estudiante_oferta=38386
select * from aca.tipo_matricula_fecha

select * from aca.malla where id_oferta_modalidad =20

select distinct pr.* from aca.requisito_nivel_estudiante r
inner join pro.proceso_requisito pr on r.id_proceso_requisito = pr.id_proceso_requisito
inner join aca.matricula_general mg on r.id_matricula_general = mg.id_matricula_general
where mg.id_periodo_academico = 96
--volver aqui
select * from aca.requisito_nivel_estudiante

select * from pro.proceso_requisito where id_proceso_requisito in (6,7,24,25,26,27,153,156,173,174)
-- 345 requisito-matricula	Matricula 2025
-- 75 matriculacion-estudiante	Matriculación de Asignaturas
--menus para la matricula de centro de idiomas
--417

select-- o.codigo,o.nombre,
      uo.* from seg.usuario_opcion uo
                    inner join man.opciones o on uo.id_opcion = o.id
where uo.id_usuario in (14174,60706)

select * from mig.record_oferta where identificacion='0927087247'
select * from man.opciones where id in (345,75)
select * from man.opciones where codigo='matricula-modulo-requisito'
select * from seg.usuarios where usuario='1203235518'

--HABILITAR CARRERAS
select pao.*--,ofa.carrera
from aca.periodo_academico_oferta pao
                      inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = pao.id_oferta_modalidad
where pao.id_periodo_academico = 136 and pao.estado='A' --and pao.id_oferta_modalidad  in( 86,99,100)
  and pao.id_oferta_modalidad  in( 21,103,104,134)

select * from aca.tipo_matricula_fecha

select * from aca.ofertas_facultad where id_tipo_oferta = 2

select * from aca.matricula_fecha_nivel
select * from aca.matricula_general
select * from aca.tipo_matricula_fecha

select * from aca.asignatura where descripcion='PLANIFICACIÓN DEL HORAS ENTRENAMIENTO DEPORTIVO'

select distinct tm.* from aca.tipo_movilidad tm
			inner join aca.subtipo_movilidad sm on sm.id_tipo_movilidad = tm.id_tipo_movilidad
			inner join aca.tipo_oferta_movilidad tom on tom.id_subtipo_movilidad= sm.id_subtipo_movilidad
			inner join aca.tipo_oferta tof on  tof.id_tipo_oferta =tom.id_tipo_oferta
                     where tof.id_tipo_oferta =(2)

select ppd.* from aca.planificacion_paralelo pp
         inner join aca.planificacion_paralelo_detalle ppd on pp.id_planificacion_paralelo = ppd.id_planificacion_paralelo
         where pp.id_periodo_academico =140

select * from aca.asignatura_compatibilidad

--set si tienen materias pendientes
begin
    declare @pi_id_periodo_academico int = 96
-- update eo set eo.vez_proyectada = iif(d.numeroMateriasMaximo = d.AprobadasTotalesNivel,0,1)
    select d.*,iif(d.numeroMateriasMaximo = d.AprobadasTotalesNivel,0,1) as boolProyec
    from (
            select eo.id_estudiante_oferta,eo.id_malla,om.facultad,om.carrera as oferta, om.modalidad, om.id_oferta_modalidad ,eo.vez_proyectada,
              eo.id_nivel_proyectado,   ( select count(ma1.id_malla_asignatura)
                                          from aca.malla m1
                                                   inner join aca.malla_asignatura ma1 on m1.id_malla=ma1.id_malla
                                                   inner join aca.nivel niv1 on ma1.id_nivel=niv1.id_nivel
                                          where  m1.id_malla = eo.id_malla and niv1.id_nivel = eo.id_nivel_proyectado
                                            and ma1.estado='A' and niv1.estado='A'
                                          group by ma1.id_malla) as numeroMateriasMaximo,
                (isnull(aux.AprobadasMaximo,0)+isnull(aux1.AprobadasMaximo,0)) as  AprobadasTotalesNivel,
                eo.numero_matricula,p.identificacion,p.apellidos,p.nombres,tee.descripcion as estado_carrera
            from aca.estudiante_oferta eo
            inner join aca.malla mal on mal.id_malla = eo.id_malla
            inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
            inner join aca.ofertas_facultad om on eo.id_oferta_modalidad=om.id_oferta_modalidad
            inner join man.personas p on eo.id_persona=p.id
            left join (select  eo1.id_estudiante_oferta,niv.id_nivel,count(ea.id_estudiante_asignatura) as AprobadasMaximo
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
             ) as aux on aux.id_estudiante_oferta = eo.id_estudiante_oferta and aux.id_nivel = eo.id_nivel_proyectado
              left join (select  eo1.id_estudiante_oferta,niv.id_nivel,count(dm.id_detalle_movilidad) as AprobadasMaximo
                                 from aca.movilidad m
                                  inner join aca.detalle_movilidad dm on  m.id_movilidad = dm.id_movilidad
                                  inner join aca.estudiante_oferta eo1 on m.id_estudiante_oferta = eo1.id_estudiante_oferta
                                  inner join aca.malla_asignatura ma on dm.id_malla_asignatura=ma.id_malla_asignatura
                                  inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
                                 where  eo1.estado='A' and dm.estado='A' and  m.estado='A'
                                   and ma.estado='A' and niv.estado='A' and dm.aprobado=1
                                 group by eo1.id_estudiante_oferta,niv.ORDEN,niv.id_nivel
             ) as aux1 on aux1.id_estudiante_oferta = eo.id_estudiante_oferta and aux1.id_nivel  = eo.id_nivel_proyectado
             where eo.estado='A'  AND tee.codigo='ACT' and om.id_tipo_oferta = 2
             group by p.identificacion,p.nombres,p.apellidos,
                      eo.numero_matricula,eo.id_malla,om.carrera ,om.modalidad , om.id_oferta_modalidad ,om.facultad,om.carrera,p.id ,eo.id_estudiante_oferta,
                      tee.descripcion,mal.id_nivel_max_aperturado,aux.AprobadasMaximo,aux1.AprobadasMaximo,eo.id_nivel_proyectado,eo.vez_proyectada
         ) as d
             inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = d.id_estudiante_oferta
-- inner join mig.record_oferta ro on ro.id_record_oferta = d.id_record_oferta
--     where
--              d.nivel = (select mm.id_nivel_max_aperturado from aca.malla mm where mm.id_malla = d.id_malla)
-- d.numeroMateriasMaximo = d.AprobadasTotalesNivel
    --            and  d.id_oferta_modalidad =91
-- order by d.facultad,d.oferta,d.apellidos,d.nombres
end
-- 2450493958
--set nivel proyectado
begin
declare @pi_id_periodo_academico int = 96
-- update eo set eo.id_nivel_proyectado = d.idNivelPro
select d.*
from (
select pa.codigo as periodo,eo.id_estudiante_oferta,eo.id_malla,om.facultad,om.carrera as oferta, om.modalidad, om.id_oferta_modalidad ,isnull(aux.id_nivel,0) as nivelMatr,isnull(aux1.id_nivel,0) as nivelMov,
       isnull(iif(aux1.id_nivel is null,aux.id_nivel,iif(isnull(aux1.id_nivel,0)>isnull(aux.id_nivel,0),aux1.id_nivel,aux.id_nivel)),1) as idNivelPro,eo.id_nivel_proyectado,
eo.numero_matricula,p.identificacion,p.apellidos,p.nombres,tee.descripcion as estado_carrera,ro.id_record_oferta
 from aca.estudiante_oferta eo
left join aca.periodo_academico pa on eo.id_periodo_academico = pa.id_periodo_academico
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
 inner join aca.ofertas_facultad om on eo.id_oferta_modalidad=om.id_oferta_modalidad
 inner join man.personas p on eo.id_persona=p.id
left join (select  eo1.id_estudiante_oferta,niv.id_nivel,count(ea.id_estudiante_asignatura) as AprobadasOctavo
                 , ROW_NUMBER() OVER (PARTITION BY eo1.id_estudiante_oferta ORDER BY  niv.orden DESC) AS rn
             from aca.matricula_general mg
             inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
             inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
             inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
             inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
             where  eo1.estado='A' and em1.estado='A' and ea.estado='A'  and mg.estado='A'
               and aa.estado='A'  and ma.estado='A' and niv.estado='A'
             group by eo1.id_estudiante_oferta,niv.ORDEN,niv.id_nivel
             ) as aux on aux.id_estudiante_oferta = eo.id_estudiante_oferta and aux.rn =1
     left join (select  eo1.id_estudiante_oferta,niv.id_nivel,count(dm.id_detalle_movilidad) as AprobadasOctavo
               , ROW_NUMBER() OVER (PARTITION BY eo1.id_estudiante_oferta ORDER BY  niv.orden DESC) AS rn
             from aca.movilidad m
            inner join aca.detalle_movilidad dm on  m.id_movilidad = dm.id_movilidad
             inner join aca.estudiante_oferta eo1 on m.id_estudiante_oferta = eo1.id_estudiante_oferta
             inner join aca.malla_asignatura ma on dm.id_malla_asignatura=ma.id_malla_asignatura
             inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
             where  eo1.estado='A' and dm.estado='A' and  m.estado='A'
            and ma.estado='A' and niv.estado='A' --and dm.aprobado=1
             group by eo1.id_estudiante_oferta,niv.ORDEN,niv.id_nivel
             ) as aux1 on aux1.id_estudiante_oferta = eo.id_estudiante_oferta  and aux1.rn =1
 left join mig.record_oferta ro on ro.id_estudiante_oferta = eo.id_estudiante_oferta

 where
    eo.estado='A'  AND tee.codigo='ACT' and om.id_tipo_oferta = 2
--and mg.estado='A' and p.identificacion='0924546625'
 group by p.identificacion,p.nombres,p.apellidos,
 eo.numero_matricula,eo.id_malla,om.carrera ,om.modalidad , om.id_oferta_modalidad ,om.facultad,om.carrera,p.id ,eo.id_estudiante_oferta,
tee.descripcion,ro.id_record_oferta,aux.AprobadasOctavo,aux1.AprobadasOctavo,aux.id_nivel,aux1.id_nivel,pa.codigo,eo.id_nivel_proyectado
) as d
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = d.id_estudiante_oferta
-- inner join mig.record_oferta ro on ro.id_record_oferta = d.id_record_oferta
         where d.idNivelPro<>d.id_nivel_proyectado
--            and  d.id_oferta_modalidad =91
-- order by d.facultad,d.oferta,d.apellidos,d.nombres
end

select * from aca.matricula_general
--set si tienen materias pendientes all record
begin
    declare @pi_id_periodo_academico int = 96
-- update eo set eo.vez_proyectada = iif(d.numeroMateriasMaximo = d.AprobadasTotalesNivel,0,1)
    select d.*,iif(d.numeroMateriasMaximo = d.AprobadasTotalesNivel,0,1) as boolProyec
    from (
             select pa.codigo,eo.id_estudiante_oferta,eo.id_malla,om.facultad,om.carrera as oferta, om.modalidad, om.id_oferta_modalidad ,eo.vez_proyectada,
                    eo.id_nivel_proyectado,   ( select count(ma1.id_malla_asignatura)
                                                from aca.malla m1
                                                         inner join aca.malla_asignatura ma1 on m1.id_malla=ma1.id_malla
                                                    inner join aca.nivel niv1 on ma1.id_nivel=niv1.id_nivel
                                                where  m1.id_malla = eo.id_malla and niv1.id_nivel <= eo.id_nivel_proyectado
                                                  and ma1.estado='A' and niv1.estado='A'
                                                group by ma1.id_malla) as numeroMateriasMaximo,
                    (isnull(aux.AprobadasMaximo,0)+isnull(aux1.AprobadasMaximo,0)) as  AprobadasTotalesNivel,--aux.AprobadasMaximo,aux1.AprobadasMaximo as aprobadasMovilidad,
                    eo.numero_matricula,p.identificacion,p.apellidos,p.nombres,tee.descripcion as estado_carrera,em.id_estudiante_matricula
             from aca.estudiante_oferta eo
                      left join aca.periodo_academico pa on eo.id_periodo_academico = pa.id_periodo_academico
                      inner join aca.malla mal on mal.id_malla = eo.id_malla
                      inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
                      inner join aca.ofertas_facultad om on eo.id_oferta_modalidad=om.id_oferta_modalidad
                      inner join man.personas p on eo.id_persona=p.id
                        left join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta and em.id_matricula_general = 41
                      left join (select  eo1.id_estudiante_oferta,count(distinct ma.id_malla_asignatura) as AprobadasMaximo
                                 from aca.matricula_general mg
                                          inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
                                          inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
                                          inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
                                          inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
                                          inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
                                          inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
                                 where  eo1.estado='A' and em1.estado='A' and ea.estado='A'  and mg.estado='A' and niv.id_nivel <= eo1.id_nivel_proyectado
                                   and aa.estado='A'  and ma.estado='A' and niv.estado='A' and ea.aprobado=1
                                 group by eo1.id_estudiante_oferta
             ) as aux on aux.id_estudiante_oferta = eo.id_estudiante_oferta
                      left join (select  eo1.id_estudiante_oferta,count(distinct ma.id_malla_asignatura) as AprobadasMaximo
                                 from aca.movilidad m
                                          inner join aca.detalle_movilidad dm on  m.id_movilidad = dm.id_movilidad
                                          inner join aca.estudiante_oferta eo1 on m.id_estudiante_oferta = eo1.id_estudiante_oferta
                                          inner join aca.malla_asignatura ma on dm.id_malla_asignatura=ma.id_malla_asignatura
                                          inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
                                 where  eo1.estado='A' and dm.estado='A' and  m.estado='A'
                                   and ma.estado='A' and niv.estado='A' and dm.aprobado=1 and niv.id_nivel <= eo1.id_nivel_proyectado
                                 group by eo1.id_estudiante_oferta
             ) as aux1 on aux1.id_estudiante_oferta = eo.id_estudiante_oferta
             where eo.estado='A'  AND tee.codigo='ACT' and om.id_tipo_oferta = 2 and p.identificacion not  in ('0925080053','2450354663' )
             group by p.identificacion,p.nombres,p.apellidos,
                      eo.numero_matricula,eo.id_malla,om.carrera ,om.modalidad , om.id_oferta_modalidad ,om.facultad,om.carrera,p.id ,eo.id_estudiante_oferta,pa.codigo,
                      tee.descripcion,mal.id_nivel_max_aperturado,aux.AprobadasMaximo,aux1.AprobadasMaximo,eo.id_nivel_proyectado,eo.vez_proyectada,em.id_estudiante_matricula
         ) as d
             inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = d.id_estudiante_oferta
    -- inner join mig.record_oferta ro on ro.id_record_oferta = d.id_record_oferta
-- order by d.facultad,d.oferta,d.apellidos,d.nombres
end

select * from aca.periodo_malla
-- insert into aca.periodo_malla
select  38,m.id_malla, 'A',getdate(), 664, 0,getdate(),getdate(),'2400254286','2400254286'
from aca.periodo_academico_oferta pao
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.malla m on om.id_oferta_modalidad = m.id_oferta_modalidad
-- inner join aca.periodo_academico_oferta pao2 on pao2.id_oferta_modalidad = om.id_oferta_modalidad and pao2.id_periodo_academico = 34 and pao2.estado='A'
where pao.id_periodo_academico = 32 and pao.estado='A' and o.estado='A' and m.fecha_hasta is null

begin
--     update eo set eo.id_nivel_proyectado = eo.id_nivel_proyectado+1
    select
--    distinct p.identificacion,ofa.carrera,pa.codigo,tee.descripcion,
--             eo.*
        distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,eo.id_malla,
                 p.identificacion,p.apellidos,p.nombres,tee.descripcion,tie.descripcion,eo.estado
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
    where  pa.id_periodo_academico = 136 --and eo.id_oferta_modalidad=21 --and eo.ultimo_periodo='MOVILIDAD INTERNA'
--       and ofa.id_tipo_oferta = 2 and eo.id_nivel_proyectado not in (8,9,10,11) and eo.id_tipo_estado_estudiante =1
end;


--manes de biologia que no se deben matricular porque hicieron movilidad ocn la malla vieja
select eo.* from aca.estudiante_oferta eo
         inner join man.personas p on p.id = eo.id_persona
         where eo.id_estudiante_oferta in ( 101766,101767,101768,101769,101770,101771,101772,101773,101774,101775,101776,101777,101778,101779,
101780,101781,101782,101783,101784,101785)

select * from  aca.fn_get_planificacion_paralelo_detalle (1135,184) as d

SELECT  e.*
			from  aca.Planificacion_Paralelo e
			inner join aca.Malla_Asignatura ma on e.id_malla_asignatura=ma.id_malla_asignatura
			inner join aca.Periodo_Malla pma on ma.id_Malla=pma.id_Malla
			inner join aca.Malla m on m.id_malla=pma.id_Malla
			inner join aca.Periodo_Academico_Oferta pao on  pao.id_Oferta_Modalidad=m.id_Oferta_Modalidad
			inner join aca.Periodo_Academico pa on pao.id_Periodo_Academico = pa.id_periodo_academico
			where pao.id_Periodo_Academico=pma.id_Periodo_Academico and e.id_Periodo_Academico=pma.id_Periodo_Academico and
			pao.estado='A' and pao.id_periodo_academico_oferta=1135 and m.id_malla=184 and pma.estado='A' and e.estado='A' and ma.estado='A' and m.estado='P'