use bd_sga_upse

select --ac.id_malla_asignatura,
 distinct a.descripcion,ec.id_estudiante_oferta,ec.id_componente_aprendizaje,ac.id_paralelo,ca.descripcion,ec.*
--        ec.*
from aca.acta_calificacion ac
inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = ac.id_malla_asignatura
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where cg.id_periodo_academico =96 and ec.id_estudiante_oferta in (89149,53502) and ec.id_componente_aprendizaje = 9

    select * from aca.estudiante_calificacion where id_acta_calificacion = 12583

select daa.* from aca.docente_asignatura_aprend daa
         inner join aca.distributivo_docente do on daa.id_distributivo_docente = do.id_distributivo_docente
         inner join aca.distributivo_oferta doo on do.id_distributivo_oferta = doo.id_distributivo_oferta
         inner join aca.periodo_academico_oferta pao on doo.id_periodo_academico_oferta = pao.id_periodo_academico_oferta
         where daa.id_asignatura_aprendizaje = 1666 and pao.id_periodo_academico =27

--     ec.id_estudiante_oferta = 11370 and cg.id_periodo_academico = 23 --and ma.id_malla_asignatura = 1056
-- and ac.id_acta_calificacion = 9850

select len(numero_matricula) from aca.estudiante_oferta
group by numero_matricula

select * from aca.estudiante_oferta
where len(numero_matricula)=14

select * from aca.acta_apertura
order by id_acta_apertura desc

select * from aca.acta_apertura_componente


select ea.id_asignatura_aprendizaje, aa2.id_asignatura_aprendizaje
--update ea set ea.id_asignatura_aprendizaje = aa2.id_asignatura_aprendizaje
from aca.estudiante_oferta eo
         inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
         inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
         inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
         inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
         inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
         inner join aca.malla m on m.id_malla = ma.id_malla
         inner join aca.asignatura a2 on a2.descripcion = a.descripcion
         inner join aca.malla_asignatura ma2 on ma2.id_asignatura = a2.id_asignatura
         inner join aca.asignatura_aprendizaje aa2 on aa2.id_malla_asignatura = ma2.id_malla_asignatura
         inner join aca.malla m2 on m2.id_malla = ma2.id_malla
where eo.id_estudiante_oferta in (11370,11762) and m2.id_malla = 62 and aa2.id_componente_aprendizaje = 2 and mg.id_periodo_academico = 14
order by ma.id_nivel



select --a.descripcion,eo.id_estudiante_oferta,ma.id_malla,ma.id_malla_asignatura,
       ea.* from aca.estudiante_asignatura ea
inner join aca.estudiante_matricula em on ea.id_estudiante_matricula = em.id_estudiante_matricula
inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where eo.id_estudiante_oferta = 18704 and ea.id_estudiante_asignatura = 124900

select id_componente_aprendizaje,codigo,descripcion from aca.componente_aprendizaje where id_componente_aprendizaje in (1,9,10)

select * from aca.calificacion_ciclo


select a.descripcion,aa.* from aca.acta_calificacion ac
inner join aca.acta_apertura aa on ac.id_acta_calificacion = aa.id_acta_calificacion
inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ec.id_estudiante_oferta
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = ac.id_malla_asignatura
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
inner join man.personas p on p.id = eo.id_persona
where cg.id_periodo_academico = 19 --and ac.id_malla_asignatura = 1067 ---and ec.id_estudiante_oferta = 11229
-- and ac.id_paralelo = 1 and ac.id_ciclo = 1
  and p.identificacion ='2450587288'

select p.identificacion,p.apellidos,p.nombres,eo.id_estudiante_oferta,o.descripcion from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
where p.identificacion in ('2450481854') and eo.estado='A' and o.id_tipo_oferta = 4

select tmf.*
    --mg.id_matricula_general,pa.id_periodo_academico,pa.codigo,pa.descripcion
from aca.periodo_academico pa
inner join aca.matricula_general mg on pa.id_periodo_academico = mg.id_periodo_academico
inner join aca.tipo_matricula_fecha tmf on mg.id_matricula_general = tmf.id_matricula_general
where pa.id_tipo_oferta = 2 and pa.id_periodo_academico = 25

select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 3

select * from aca.periodo_academico_oferta where id_periodo_academico = 25


select ma.id_malla_asignatura,aa.id_asignatura_aprendizaje,ma.id_nivel,n.descripcion from aca.malla m
inner join aca.malla_asignatura ma on ma.id_malla = m.id_malla
inner join aca.asignatura_aprendizaje aa on aa.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
inner join aca.nivel n on n.id_nivel = ma.id_nivel
where m.id_malla = 20 and aa.id_componente_aprendizaje = 2

select m.* from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.movilidad m on eo.id_estudiante_oferta = m.id_estudiante_oferta
-- inner join aca.detalle_movilidad dm on m.id_movilidad = dm.id_movilidad
-- inner join aca.subtipo_movilidad sm on m.id_subtipo_movilidad = sm.id_subtipo_movilidad
where p.identificacion in ('0928166503') and eo.estado='A'

select --pa.codigo,pa.descripcion,ea.*
ea.*
from aca.estudiante_asignatura ea
inner join aca.estudiante_matricula em on ea.id_estudiante_matricula = em.id_estudiante_matricula
inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
where em.id_estudiante_oferta = 51214
--   and  ea.estado='A' and em.estado='A'


select * from [aca].[fun_record_ingles_estudiante]('2450417627')

select * from aca.fn_consulta_modulos_aprobados('2450562240')

select p.id, p.identificacion,p.apellidos,p.nombres from man.personas p where p.apellidos like '%CACAO MAGALLAN%' and p.nombres like '%EDISON DARWIN%'
select p.id, p.identificacion,p.apellidos,p.nombres from man.personas p where p.apellidos like '%CISNEROS MATIAS%' and p.nombres like '%DERECK ISAAC%'
select p.id, p.identificacion,p.apellidos,p.nombres from man.personas p where p.apellidos like '%RODRIGUEZ LAINEZ%' and p.nombres like '%PETER PAULINO%'
select p.id, p.identificacion,p.apellidos,p.nombres from man.personas p where p.apellidos like '%ROSALES CAICHE%' and p.nombres like '%STEVEN ARIEL%'
select p.id, p.identificacion,p.apellidos,p.nombres from man.personas p where p.apellidos like '%TORRES LARA%' and p.nombres like '%MAYERLI JOHANNA%'


select * from [aca].[fun_asignaturas_ingles_vistas]() as d
where d.identificacion='2450562240'

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
periodo = (select valor_texto from Bd_Academico.dbo.TP_CODIGOS where CORRELATIVO=pad.CG_PER_ACADEMICO), rm.id_destino as idMallaAsignatura,
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
  and mt.VER_EN_RECORD =1 --and n.INTERFAZ=3
  and mt.estado='A' and p.IDENTIFICACION ='2450562240 '


select * from aca.nivel

select * from aca.asignatura

select descripcion,count(id_asignatura) from aca.asignatura
--                                         where estado='A'
group by descripcion
having  count(id_asignatura)>1

select * from aca.asignatura where descripcion ='NUTRICION ANIMAL'


select * from aca.componente_aprendizaje
--     {bcrypt}$2a$10$dzo7xUGn3uu4kov75rVTuebK8q0EFwrAQenglir3hfjLwiRe0HpWG
select * from seg.usuarios where usuario ='2400200867'

select concat('{MD5}',Bd_Academico.dbo.fn_Md5('2400200867'))


exec [aca].[calificacion_suma] 35,null,'PREGRADO'

select * from man.personas where identificacion='2400254286'
-- DBCC CHECKIDENT ('aca.acta_apertura_componente', RESEED, 593)

select * from aca.acta_apertura where id_acta_apertura = 2615

select * from aca.acta_apertura_componente where id_acta_apertura = 2615

select  eop.id_estudiante_oferta,ec.*
    eop.id_estudiante_oferta,eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.id_periodo_academico,m.id_periodo_academico,m.estado,pa.codigo,p.id as id_persona,eo.ultimo_periodo,
    eo.mantiene_gratuidad,p.identificacion,p.apellidos,p.nombres,o.descripcion as carrera,eo.numero_matricula,eo.id_periodo_academico,eo.fecha_ingreso,tee.descripcion as tipo,tee.observacion
-- eop.id_estudiante_oferta,em.*
--     update m set m.id_estudiante_oferta = eop.id_estudiante_oferta
--     update ec set ec.id_estudiante_oferta = eop.id_estudiante_oferta
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.estudiante_oferta eop on eop.id_estudiante_oferta_padre = eo.id_estudiante_oferta
         inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
        inner join aca.estudiante_calificacion ec on eo.id_estudiante_oferta = ec.id_estudiante_oferta
        inner join aca.acta_calificacion ac on ec.id_acta_calificacion = ac.id_acta_calificacion
        inner join aca.calificacion_general cg on ac.id_calificacion_general = cg.id_calificacion_general
where  eo.id_oferta_modalidad in (83) and eo.id_periodo_academico =30 and cg.id_periodo_academico = 35


select --ac.id_malla_asignatura,
--a.descripcion,ec.id_componente_aprendizaje,ca.descripcion,
      distinct ac.* from aca.acta_calificacion ac
                     inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
                     inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
                     inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
                     inner join aca.malla_asignatura ma on ma.id_malla_asignatura = ac.id_malla_asignatura
                     inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where ac.id_calificacion_general = 36 and ma.id_malla_asignatura = 888 and ac.id_paralelo = 2
select * from mig.record_oferta where identificacion ='2400255440'

select * from aca.estudiante_calificacion where id_acta_calificacion = 34523

select * from aca.acta_calificacion where id_acta_calificacion = 34523
--     ec.id_estudiante_oferta = 11370 and cg.id_periodo_academico = 23

select pa.codigo as periodo,d.nombre as facultad,o.descripcion as carrera,concat(p.apellidos,' ',p.nombres)as docente,
       iif((select count(ca1.id_componente_aprendizaje) from aca.acta_apertura_componente ac1
        inner join aca.componente_aprendizaje ca1 on ac1.id_componente_aprendizaje = ca1.id_componente_aprendizaje
        where  ac1.id_acta_apertura = ap.id_acta_apertura      and ac1.estado='A'                               )<=2,'SUMATIVA','FORMATIVA') as componente,
       c.descripcion as ciclo,a.descripcion as asignatura,concat(n.descripcion_corta,'/',ac.id_paralelo) as curso, ap.fecha_Desde as fecha_apertura,ap.observacion as motivo
from aca.acta_calificacion ac
inner join aca.ciclo c on c.id_ciclo= ac.id_ciclo
inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
inner join aca.periodo_academico pa on cg.id_periodo_academico = pa.id_periodo_academico
inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
inner join aca.docente doc on ec.id_docente = doc.id_docente
inner join man.personas p on doc.id_persona = p.id
inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = ac.id_malla_asignatura
inner join aca.nivel n on ma.id_nivel = n.id_nivel
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
inner join aca.oferta_modalidad om on m.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.departamento_oferta do on o.id_oferta = do.id_oferta
inner join man.departamentos d on do.id_departamento = d.id
inner join aca.acta_apertura ap on ac.id_acta_calificacion = ap.id_acta_calificacion
where ac.estado='A' and c.estado='A' and pa.id_periodo_academico=36
group by pa.codigo,ap.id_acta_apertura, d.nombre, o.descripcion, c.descripcion, a.descripcion, n.descripcion_corta, ac.id_paralelo, ap.fecha_Desde, p.apellidos, p.nombres, ap.observacion
order by d.nombre, o.descripcion,c.descripcion,a.descripcion

    select distinct--ac.id_malla_asignatura,
--a.descripcion,ec.id_componente_aprendizaje,ca.descripcion,
           ac.* from aca.acta_calificacion ac
                         inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
                         inner join aca.malla_asignatura ma on ma.id_malla_asignatura = ac.id_malla_asignatura
                         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
    where cg.id_periodo_academico = 95 and ma.id_malla_asignatura = 2100 and ac.id_paralelo = 2

select distinct ec.* from aca.acta_calificacion ac
inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
where ac.id_acta_calificacion in (41892)
--eliminar 33096

select * from aca.ciclo
select * from aca.componente_aprendizaje


select * from aca.fn_calificacion_estudiantes (96,799,3,427)

select *
from [aca].[fn_lista_calificacion_asignatura_doc_detalle_cal] ( 92, null ,null )
         as d order by  d.departamento, d.oferta, d.asignatura, d.paralelo,d. ciclo

--276
begin
    declare @pi_id_periodo_academico int = 42,
        @pi_id_departamento int=null,
        @pi_id_oferta_modalidad int=null
    select periodoAcademico, departamento, oferta,   asignatura ,paralelo,isnull(docente,doc) as docente,ciclo,avg(calificacion) as calificacion ,
           count(calificacion) as estudiante, id_malla_asignatura, id_paralelo, ISNULL(avg (promedio),0) as promedio,fecha_desde,fecha_hasta
    from (
             select pa.codigo  as periodoAcademico, dep.nombre as departamento ,o.descripcion as oferta, a.descripcion as asignatura,
                    concat( n.descripcion_corta,'/', par.descripcion_corta) as paralelo, c.descripcion as ciclo ,
                    isnull(eca.calificacion, 0) as calificacion   ,  isnull((select concat ( per1.apellidos,' ', per1.nombres) from man.personas per1
                                                                                                                                        inner join aca.docente d on per1.id=d.id_persona where d.id_docente=eca.id_docente and per1.estado='AC' and d.estado='A' ),
                                                                            (select TOP (1)  concat(per1.apellidos, ' ', per1.nombres) from aca.acta_calificacion ac1
                                                                                                                                                inner join aca.estudiante_calificacion ec1 on ac1.id_acta_calificacion=ec1.id_acta_calificacion
                                                                                                                                                INNER JOIN aca.docente d1 on ec1.id_docente=d1.id_docente
                                                                                                                                                inner join man.personas per1 on d1.id_persona=per1.id
                                                                             where ac1.id_acta_calificacion=ac.id_acta_calificacion AND ac1.estado in ('A','C') and per1.estado='AC' and d1.estado='A' AND ec1.ESTADO='A' )) as docente,
                    ma.id_malla_asignatura,par.id_paralelo
                     ,ea.promedio, n.orden,concat(p1.apellidos, ' ', p1.nombres) as doc,daa.fecha_hasta,daa.fecha_desde
             from aca.periodo_academico pa
                      inner join aca.matricula_general mg on pa.id_periodo_academico=mg.id_periodo_academico
                      inner join aca.estudiante_matricula em on mg.id_matricula_general=em.id_matricula_general
                      inner join aca.estudiante_oferta eo on em.id_estudiante_oferta=eo.id_estudiante_oferta --and pao.id_oferta_modalidad=eo.id_oferta_modalidad
                      inner join man.personas p on eo.id_persona=p.id
                      inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula=ea.id_estudiante_matricula
                      inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
                      inner join aca.malla_asignatura ma on ma.id_malla_asignatura=aa.id_malla_asignatura
                      inner join aca.nivel n on ma.id_nivel=n.id_nivel
                      inner join aca.asignatura a on ma.id_asignatura=a.id_asignatura
                      inner join aca.malla m on m.id_malla=ma.id_malla
                      inner join aca.oferta_modalidad om on m.id_oferta_modalidad=om.id_oferta_modalidad
                      inner join aca.oferta o on  om.id_oferta=o.id_oferta
                      inner join aca.departamento_oferta dof on o.id_oferta=dof.id_oferta
                      inner join man.departamentos dep on dof.id_departamento=dep.id
                      inner join aca.paralelo par on par.id_paralelo=ea.id_paralelo
                      inner join aca.calificacion_general cg on cg.id_periodo_academico=pa.id_periodo_academico
                      inner join aca.calificacion_ciclo cc on cg.id_calificacion_general=cc.id_calificacion_general
                      inner join aca.reglamento_ciclo rc on cc.id_reglamento_ciclo=rc.id_reglamento_ciclo and cg.id_reglamento=rc.id_reglamento
                      inner join aca.ciclo c on rc.id_ciclo=c.id_ciclo
                      inner join aca.ciclo_aprendizaje ca on rc.id_reglamento_ciclo=ca.id_reglamento_ciclo
                      inner join aca.reglamento_comp_aprendizaje rca on ca.id_reglamento_comp_aprendizaje=rca.id_reglamento_comp_aprendizaje
                      inner join aca.componente_aprendizaje cap on cap.id_componente_aprendizaje=rca.id_comp_aprendizaje
                        inner join aca.periodo_academico_oferta pao on pa.id_periodo_academico = pao.id_periodo_academico
                        inner join aca.distributivo_oferta dio on pao.id_periodo_academico_oferta = dio.id_periodo_academico_oferta
                      inner join aca.distributivo_docente ddo on ddo.id_distributivo_oferta = dio.id_distributivo_oferta
                      inner join aca.docente_asignatura_aprend daa on daa.id_distributivo_docente = ddo.id_distributivo_docente
                    INNER JOIN aca.docente d on ddo.id_docente = d.id_docente
                    inner join man.personas p1 on d.id_persona = p1.id
                 and daa.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje and daa.id_paralelo =par.id_paralelo
                      left  join aca.acta_calificacion ac on cg.id_calificacion_general=ac.id_calificacion_general
                 and ac.id_ciclo=c.id_ciclo  and ac.id_malla_asignatura=ma.id_malla_asignatura
                 and ac.id_paralelo=ea.id_paralelo and ac.estado in ('A' ,'C')
                      left  join aca.estudiante_calificacion as eca on ac.id_acta_calificacion=eca.id_acta_calificacion
                 and cap.id_componente_aprendizaje=eca.id_componente_aprendizaje
                 and eo.id_estudiante_oferta= eca.id_estudiante_oferta  and eca.estado='A'
             where mg.estado='A' and em.estado='A' and eo.estado='A' and ea.estado='A'
               and aa.estado='A' and ma.estado='A' and a.estado='A' and m.estado in ('A','P') and p.estado='AC'   and par.estado='A'
               and cg.estado='A' and cc.estado='A' and rc.estado='A' and c.estado='A' and ca.estado='A' and rca.estado='A' and cap.estado='A'
              and   ddo.estado='A' and daa.estado='A' and aa.estado='A' and dio.estado in ('A','V','D') and pao.estado='A'
               --and pao.estado='A'
               --and eo.id_oferta_modalidad=@id_oferta_modalidad
               and mg.id_periodo_academico=@pi_id_periodo_academico
               and (dep.id=@pi_id_departamento or @pi_id_departamento is null)
               and (om.id_oferta_modalidad=@pi_id_oferta_modalidad or @pi_id_oferta_modalidad is null)
               and ((cap.codigo='SUMA' AND c.codigo IN ('CIC1','CIC2') and ma.UICII=0) OR (cap.codigo='SUMATIVA' AND c.codigo='RECU' AND eca.calificacion>0)
                 or (cap.codigo='SUMA' AND c.codigo IN ('CIC2') and ma.UICII=1) )
             GROUP BY  eo.id_estudiante_oferta , p.identificacion  ,p.apellidos,p.nombres , pa.id_periodo_academico ,
                       pa.codigo  , ma.id_malla_asignatura  , a.id_asignatura , a.descripcion  , par.id_paralelo  ,
                       par.descripcion ,  c.id_ciclo , c.descripcion  ,    cap.id_componente_aprendizaje    , cap.abreviatura   ,
                       ca.ponderacion_calificacion  ,a.codigo,ma.UICII,
                       ac.id_acta_calificacion ,eca.id_estudiante_calificacion , eca.calificacion  ,cap.orden,eca.id_docente,o.descripcion,
                       c.orden,cc.fecha_cierre_actas ,cap.codigo,eca.id_docente ,cap.codigo,ca.orden,n.descripcion_corta
                     ,cg.id_calificacion_general,par.descripcion_corta, par.orden,n.orden,ea.promedio, dep.nombre, pa.descripcion
             ,p1.nombres,p1.apellidos
             ,daa.fecha_desde,daa.fecha_hasta
         ) as aux
    where fecha_desde<=cast(getdate() as date)
    group by periodoAcademico,departamento, oferta, ciclo, orden, asignatura, PARALELO, DOCENTE, id_malla_asignatura, id_paralelo,doc,fecha_hasta,fecha_desde
end


select  ac1.id_acta_calificacion,c1.id_ciclo as idCiclo
from aca.calificacion_ciclo cc1
         inner join aca.calificacion_general cg on cc1.id_calificacion_general=cg.id_calificacion_general
         inner join aca.periodo_academico pa1 on cg.id_periodo_academico=pa1.id_periodo_academico
         inner join aca.reglamento_ciclo rc on cc1.id_reglamento_ciclo=rc.id_reglamento_ciclo and cg.id_reglamento=rc.id_reglamento
         inner join aca.ciclo c1 on c1.id_ciclo = rc.id_ciclo
         left join aca.acta_calificacion ac1 on cg.id_calificacion_general=ac1.id_calificacion_general
    and ac1.id_ciclo=2 and
                                                ac1.id_malla_asignatura=1978
    and ac1.id_paralelo=2 and ac1.estado in('A')
         left join aca.acta_apertura aa1 on ac1.id_acta_calificacion=aa1.id_acta_calificacion and aa1.estado='A'
    and  aa1.id_acta_apertura in (select max(id_acta_apertura) from aca.acta_apertura aa2 where aa1.id_acta_calificacion=aa2.id_acta_calificacion and aa2.estado='A' )
where cg.id_periodo_academico= 96 and c1.id_ciclo=2
  and cc1.estado='A' and cg.estado='A'
  and pa1.estado='A'
  and rc.estado='A' and c1.estado='A'

select * from aca.estudiante_calificacion where id_acta_calificacion in (39400,39402)
select * from aca.acta_calificacion where id_acta_calificacion in (39400,39402)
begin
    declare @pi_id_periodo_academico int = 96, @pi_id_malla_asignatura int=1978,@pi_id_paralelo int=2, @pi_id_docente int=30
    select   coa.abreviatura   as text, CONCAT(CAST(c.id_ciclo as varchar(250)),'-',CAST(coa.id_componente_aprendizaje as varchar(250)))  as datafield,--,'-',coa.codigo
        c.id_ciclo  as columngroup ,c.descripcion as ciclo
         ,case when ( select case when  COUNT (coa1.id_componente_aprendizaje)>0   then  0 else 1 end
                      from  aca.calificacion_ciclo cc2
                                inner join aca.reglamento_ciclo rc2 on cc2.id_reglamento_ciclo=rc2.id_reglamento_ciclo
                                inner join aca.ciclo_aprendizaje as ca2 on rc2.id_reglamento_ciclo=ca2.id_reglamento_ciclo
                                inner join aca.reglamento_comp_aprendizaje rca2 on rca2.id_reglamento_comp_aprendizaje=ca2.id_reglamento_comp_aprendizaje
                                inner join aca.componente_aprendizaje coa2 on coa2.id_componente_aprendizaje = rca2.id_comp_aprendizaje
                                left join aca.componente_aprendizaje coa1 on coa2.id_componente_aprendizaje=coa1.id_componente_aprendizaje_padre
                          and coa1.id_componente_aprendizaje IN (select rca1.id_comp_aprendizaje from  aca.ciclo_aprendizaje as ca1
                                                                                                           inner join aca.reglamento_ciclo rc1 on ca1.id_reglamento_ciclo=rc1.id_reglamento_ciclo
                                                                                                           inner join aca.reglamento_comp_aprendizaje rca1 on ca1.id_reglamento_comp_aprendizaje=rca1.id_reglamento_comp_aprendizaje
                                                                                                           inner join aca.componente_aprendizaje caa on rca1.id_comp_aprendizaje=caa.id_componente_aprendizaje
                                                                 where ca1.estado='A' and  rca1.estado='A' AND rc1.id_reglamento_ciclo= rc2.id_reglamento_ciclo --and ca1.id_ciclo_aprendizaje=ca2.id_ciclo_aprendizaje
                                                                   and caa.id_componente_aprendizaje_padre=coa2.id_componente_aprendizaje
                          )
                      where    rc2.id_ciclo=c.id_ciclo and cc2.id_calificacion_general=cc.id_calificacion_general
                        and coa2.id_componente_aprendizaje=coa.id_componente_aprendizaje
                        and ca2.estado='A' and rca2.estado='A' and coa2.estado='A')=1 and coa.abreviatura!='SUMA'
        and ( SELECT ISNULL((select  c1.id_ciclo as idCiclo
                             from aca.calificacion_ciclo cc1
                                      inner join aca.calificacion_general cg on cc1.id_calificacion_general=cg.id_calificacion_general
                                      inner join aca.periodo_academico pa1 on cg.id_periodo_academico=pa1.id_periodo_academico
                                      inner join aca.reglamento_ciclo rc on cc1.id_reglamento_ciclo=rc.id_reglamento_ciclo and cg.id_reglamento=rc.id_reglamento
                                      inner join aca.ciclo c1 on c1.id_ciclo = rc.id_ciclo
                                      left join aca.acta_calificacion ac1 on cg.id_calificacion_general=ac1.id_calificacion_general
                                 and ac1.id_ciclo=c.id_ciclo and ac1.id_malla_asignatura=@pi_id_malla_asignatura
                                 and ac1.id_paralelo=@pi_id_paralelo and ac1.estado in('A')
                                      left join aca.acta_apertura aa1 on ac1.id_acta_calificacion=aa1.id_acta_calificacion and aa1.estado='A'
                                 and  aa1.id_acta_apertura in (select max(id_acta_apertura) from aca.acta_apertura aa2 where aa1.id_acta_calificacion=aa2.id_acta_calificacion and aa2.estado='A' )
                             where cc.id_calificacion_general =cc1.id_calificacion_general and c1.id_ciclo=c.id_ciclo
                               and cc1.estado='A' and cg.estado='A'
                               and pa1.estado='A'
                               and rc.estado='A' and c1.estado='A'
                            ),0)) >0
                   then 1 else 0 end as edit
         ,ca.orden as ordenCa, c.orden as ordenCi
    FROM aca.calificacion_ciclo cc
             inner join aca.reglamento_ciclo as rc on rc.id_reglamento_ciclo=cc.id_reglamento_ciclo
             inner join aca.ciclo as c on c.id_ciclo=rc.id_ciclo
             inner join aca.calificacion_general as cg on cc.id_calificacion_general=cg.id_calificacion_general and cg.id_reglamento=rc.id_reglamento
             inner join aca.periodo_academico as pa on pa.id_periodo_academico = cg.id_periodo_academico
             inner join aca.ciclo_aprendizaje as ca on ca.id_reglamento_ciclo = rc.id_reglamento_ciclo
             inner join aca.reglamento_comp_aprendizaje rca on rca.id_reglamento_comp_aprendizaje=ca.id_reglamento_comp_aprendizaje
             inner join aca.componente_aprendizaje coa on coa.id_componente_aprendizaje = rca.id_comp_aprendizaje

    where coa.estado='A' and cc.estado='A' and rc.estado='A' and c.estado='A' and cg.estado='A' --and pao.estado='A'
      and pa.estado='A' and ca.estado='A' and rca.estado='A'  and pa.id_periodo_academico=@pi_id_periodo_academico

      and (c.codigo NOT IN ('CIC1') AND (select ma.UICII from aca.malla_asignatura ma where  ma.id_malla_asignatura=@pi_id_malla_asignatura and ma.estado='A' )=1
        or ( (select ma.UICII from aca.malla_asignatura ma where ma.id_malla_asignatura=@pi_id_malla_asignatura and ma.estado='A' )=0))

      and (coa.codigo  IN ('SUMATIVA','SUMA') AND (select ma.UICII from aca.malla_asignatura ma where  ma.id_malla_asignatura=@pi_id_malla_asignatura and ma.estado='A' )=1
        or ( (select ma.UICII from aca.malla_asignatura ma where ma.id_malla_asignatura=@pi_id_malla_asignatura and ma.estado='A' )=0))

      and ((coa.id_componente_aprendizaje in  ( select case when caapa1.codigo='FORMATIVA'
                                                                then caa1.id_componente_aprendizaje else caapa1.id_componente_aprendizaje end
                                                from aca.malla_asignatura ma1
                                                         inner join aca.malla m1 on ma1.id_malla=m1.id_malla
                                                         inner join aca.asignatura_aprendizaje aa1 on ma1.id_malla_asignatura=aa1.id_malla_asignatura
                                                         inner join aca.componente_aprendizaje caa1 on aa1.id_componente_aprendizaje=caa1.id_componente_aprendizaje
                                                         inner join aca.componente_aprendizaje caapa1 on caa1.id_componente_aprendizaje_padre=caapa1.id_componente_aprendizaje
                                                where ma1.estado='A' and aa1.estado='A'  and caa1.estado='A' and caapa1.estado='A' and (caa1.codigo not in ('NOASISTIDODOCENTE') or  (m1.id_oferta_modalidad  in (124) and caa1.codigo  in ('NOASISTIDODOCENTE') and @pi_id_periodo_academico>=36))
                                                  and aa1.valor>0 and ma1.id_malla_asignatura=@pi_id_malla_asignatura) and coa.codigo in ('DOCENCIA','PRACTICA'))
        or  coa.codigo not in ('DOCENCIA','PRACTICA')
        )


    GROUP by coa.abreviatura   , c.id_ciclo ,coa.id_componente_aprendizaje ,  coa.orden,cc.id_calificacion_general,coa.codigo,ca.orden,c.orden,
             c.descripcion--,coa1.orden
    order by c.orden  , ca.orden
end


select  om.facultad,om.carrera,p.identificacion,p.apellidos,p.nombres,ca.id_componente_aprendizaje,ca.codigo,avg(ec.calificacion) as promedio_ciclo1
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.estudiante_oferta eop on eop.id_estudiante_oferta_padre = eo.id_estudiante_oferta
         inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.ofertas_facultad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.estudiante_calificacion ec on eo.id_estudiante_oferta = ec.id_estudiante_oferta
         inner join aca.acta_calificacion ac on ec.id_acta_calificacion = ac.id_acta_calificacion
         inner join aca.calificacion_general cg on ac.id_calificacion_general = cg.id_calificacion_general
        inner join aca.componente_aprendizaje ca on ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
where  cg.id_periodo_academico = 136 and ca.id_componente_aprendizaje = 9 and ec.estado='A' and ac.id_ciclo= 1
group by om.facultad,om.carrera,p.identificacion,p.apellidos,p.nombres,ca.id_componente_aprendizaje,ca.codigo;

WITH promedios AS (
    SELECT
    om.facultad,
    om.carrera,
    p.identificacion,
    p.apellidos,
    p.nombres,
    ca.id_componente_aprendizaje,
    ca.codigo,
    AVG(CAST(ec.calificacion AS DECIMAL(10,2))) AS promedio_ciclo1
    FROM man.personas p
    INNER JOIN aca.estudiante_oferta eo
    ON eo.id_persona = p.id
    INNER JOIN aca.estudiante_oferta eop
    ON eop.id_estudiante_oferta_padre = eo.id_estudiante_oferta
    INNER JOIN aca.periodo_academico pa
    ON pa.id_periodo_academico = eo.id_periodo_academico
    INNER JOIN aca.tipo_estado_estudiante tee
    ON eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
    INNER JOIN aca.ofertas_facultad om
    ON eo.id_oferta_modalidad = om.id_oferta_modalidad
    INNER JOIN aca.estudiante_calificacion ec
    ON eo.id_estudiante_oferta = ec.id_estudiante_oferta
    INNER JOIN aca.acta_calificacion ac
    ON ec.id_acta_calificacion = ac.id_acta_calificacion
    INNER JOIN aca.calificacion_general cg
    ON ac.id_calificacion_general = cg.id_calificacion_general
    INNER JOIN aca.componente_aprendizaje ca
    ON ec.id_componente_aprendizaje = ca.id_componente_aprendizaje
    WHERE cg.id_periodo_academico = 136
    AND ca.id_componente_aprendizaje = 9
    AND ec.estado = 'A'
    AND ac.id_ciclo = 1
    GROUP BY
    om.facultad,
    om.carrera,
    p.identificacion,
    p.apellidos,
    p.nombres,
    ca.id_componente_aprendizaje,
    ca.codigo
    ),
    ranking AS (
    SELECT *,
    ROW_NUMBER() OVER (
    PARTITION BY facultad
    ORDER BY promedio_ciclo1 DESC
    ) AS puesto
    FROM promedios
    )
SELECT *
FROM ranking
WHERE puesto <= 3
ORDER BY facultad;