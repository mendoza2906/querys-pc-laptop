use bd_sga_upse

select * from aca.periodo_academico_oferta where id_periodo_academico = 35

select DISTINCT id_acta_calificacion from aca.estudiante_calificacion ec_orig

WHERE ec_orig.usuario_ingreso_id<>'SISTEMAS            '
AND id_acta_calificacion<14643

-- UPDATE aca.estudiante_calificacion
-- SET  calificacion=0 , usuario_ingreso_id='SISTEMAS1'
--     WHERE usuario_ingreso_id<>'SISTEMAS            '
-- AND id_acta_calificacion<14643


SELECT pa.descripcion as periodo,o.descripcion as oferta , a.descripcion as asignatura, p.descripcion as paralelo, c.descripcion as ciclo FROM ACA.acta_calificacion AC
inner join aca.paralelo p on p.id_paralelo=ac.id_paralelo
INNER JOIN ACA.malla_asignatura MA ON AC.id_malla_asignatura=MA.id_malla_asignatura
INNER JOIN ACA.ASIGNATURA A ON MA.id_asignatura=A.id_asignatura
inner join aca.malla m on ma.id_malla=m.id_malla
INNER JOIN ACA.oferta_modalidad OM ON m.id_oferta_modalidad=om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta=o.id_oferta
inner join aca.ciclo c on  c.id_ciclo=ac.id_ciclo
  inner join aca.calificacion_general cg on ac.id_calificacion_general=cg.id_calificacion_general
   inner join aca.periodo_academico pa on cg.id_periodo_academico=pa.id_periodo_academico
    inner join aca.tipo_oferta toff on pa.id_tipo_oferta=toff.id_tipo_oferta
where id_acta_calificacion in (SELECT DISTINCT id_acta_calificacion FROM aca.estudiante_calificacion WHERE usuario_ingreso_id='SISTEMAS1        '   )
and toff.id_tipo_oferta=1


select * from aca.calificacion_ciclo where id_calificacion_general = 15


select * from aca.oferta

select * from aca.periodo_academico

select * from aca.periodo_academico where id_periodo_academico between 1 and 11

select * from aca.malla_asignatura_fusion where id_periodo_academico between 1 and 11

select * from vcc.cronograma where id_periodo_academico between 1 and 11

select * from vcc.estudiante_proyecto where id_periodo_academico between 1 and 11

select * from ppp.itinerario_inscripcion where id_periodo_academico between 1 and 11

select * from mev.modelo_evaluacion_periodo where id_periodo_academico between 1 and 11

select * from cat.ayudante_catedra where id_periodo_academico between 1 and 11

select * from mov.becario where id_periodo_academico between 1 and 11

select * from aca.calificacion_general where id_periodo_academico between 1 and 11

select * from aca.ciclo_componente_moodle where id_periodo_academico between 1 and 11

select * from aca.clase where id_periodo_academico between 1 and 11

select * from aca.comision_integrante where id_periodo_academico between 1 and 11

select * from cmo.concurso where id_periodo_academico between 1 and 11

select * from niv.cursos_nivelacion where id_periodo_academico between 1 and 11

select * from aca.equivalencia_examen_ubicacion where id_periodo_academico between 1 and 11

select * from aca.espacio_fisico_departamento where id_periodo_academico between 1 and 11

select * from aca.horario_academico where id_periodo_academico between 1 and 11

select * from aca.inscripcion where id_periodo_academico between 1 and 11

select * from aca.malla_relacion where id_periodo_academico between 1 and 11

select * from aca.matricula_general where id_periodo_academico between 1 and 11

select * from eva.periodo_evaluacion where id_periodo_academico between 1 and 11

select * from pro.proceso_general where id_periodo_academico between 1 and 11

select * from vin.proyecto_convocatoria where id_periodo_academico between 1 and 11

select * from vin.seguimiento_actividad where id_periodo_academico between 1 and 11

select * from aca.silabo_periodo_academico where id_periodo_academico between 1 and 11

select * from tut.periodo_titulacion where id_periodo_academico between 1 and 11

select * from aca.documentos_matricula where id_periodo_academico between 1 and 11

select * from aca.ciclos_periodo where id_periodo_academico between 1 and 11

select * from aca.documentacion_requisito_nivel_periodo where id_periodo_academico between 1 and 11

select * from aca.estudiante_oferta where id_periodo_academico between 1 and 11

----si
select * from aca.periodo_malla where id_periodo_academico between 1 and 11
---si
select * from aca.periodo_academico_oferta where id_periodo_academico between 1 and 11
---si
select * from aca.planificacion_paralelo where id_periodo_academico between 1 and 11

select * from aca.periodo_academico
-- DBCC CHECKIDENT ('aca.periodo', RESEED, 0);


SELECT * from ppp.resolucion_ppp


select * from ppp.tipo_solicitud_ppp

select * from ppp.tipo_contrato

select * from aca.tipo_docente

select * from vcc.tipo_docente

select * from uath.tipo_contrato

select * from aca.institucion

select * from aca.nivel_formacion

select * from aca.tipo_institucion

select * from aca.tipo_documento

select * from aca.documentos_plan_clase


-- update aa2 set aa2.valor = aa.valor
select aa.id_asignatura_aprendizaje,aa.id_componente_aprendizaje,aa.valor,aa2.id_asignatura_aprendizaje,aa2.id_componente_aprendizaje,aa2.valor
from aca.malla m
         inner join aca.malla_asignatura ma on ma.id_malla = m.id_malla
        inner join aca.asignatura_aprendizaje aa on ma.id_malla_asignatura = aa.id_malla_asignatura
        inner join aca.asignatura_aprendizaje aa2 on aa2.id_malla_asignatura = ma.id_malla_asignatura and aa2.id_componente_aprendizaje = 7
         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
         inner join aca.oferta_modalidad om on om.id_oferta_modalidad = m.id_oferta_modalidad
         inner join aca.oferta o on o.id_oferta = om.id_oferta
         inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
         inner join man.departamentos d on d.id= do.id_departamento
where
    o.id_tipo_oferta = 3 and aa.id_componente_aprendizaje in (6) and aa.valor>0
--   and aa.id_componente_aprendizaje in (18,19)

select * from aca.componente_aprendizaje



