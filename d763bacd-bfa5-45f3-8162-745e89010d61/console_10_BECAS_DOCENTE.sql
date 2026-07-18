use bd_sga_upse;

select * from [pro].[fn_list_periodos_academicos_by_process]('SOLICITUDBECAPOSTGRADO',-1)

select * from pro.tipo_proceso
select * from pro.proceso_calendario pc
where pc.id_proceso_calendario in (65,90)

select dce.* from pro.docente_categoria_evaluacion dce
inner join pro.evaluacion_requisito er on dce.id_evaluacion_requisito = er.id_evaluacion_requisito
         inner join pro.evaluacion_rubrica err on er.id_evaluacion_rubrica = err.id_evaluacion_rubrica
         where dce.descripcion_requisito like '%Cursos de Formación en el área Pedagógica – Didáctica.%'
and err.id_evaluacion_rubrica = 7

select * from pro.evaluacion_rubrica

select pe.* from pro.proceso p
inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
inner join pro.etapa e on e.id_etapa = pe.id_etapa
-- inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
-- inner join pro.etapa_evaluaciones ev on ev.id_proceso_calendario = pc.id_proceso_calendario
where p.id_proceso = 23

select pc.*,e.* from pro.proceso p
inner join pro.proceso_etapa pe on pe.id_proceso = p.id_proceso
inner join pro.etapa e on e.id_etapa = pe.id_etapa
inner join pro.proceso_etapa_rol per on per.id_proceso_etapa = pe.id_proceso_etapa
inner join pro.proceso_calendario pc on pc.id_proceso_etapa = pe.id_proceso_etapa
-- inner join pro.etapa_evaluaciones ev on ev.id_proceso_calendario = pc.id_proceso_calendario
where p.id_proceso = 23

select  * from pro.fn_get_info_user_process(1,'DOCENTE','SOLICITUDBECAPOSTGRADO',27)

select * from pro.etapa

select * from pro.proceso_etapa_rol

select * from seg.roles where id in (29)
select * from pro.proceso


select * from pro.fn_list_all_rubricas_evaluaciones_by_clasificacion (31,16,10,
    442,54,'CONCURSOMERITOPOSTGRADO')


select * from pro.docente_categoria_evaluacion

select * from pro.tipo_beca

select efr.* from aca.espacio_fisico ef1
inner join aca.espacio_fisico_recurso_academico efr on ef1.id_espacio_fisico = efr.id_espacio_fisico
inner join aca.recurso_academico ra on efr.id_recurso_academico = ra.id_recurso_academico
where ef1.id_espacio_fisico in (


select  ef.id_espacio_fisico
			from aca.Espacio_Fisico_Departamento efd
			inner join aca.Espacio_Fisico  ef on ef.id_espacio_fisico=efd.id_espacio_fisico
			where efd.estado='A' and efd.id_departamento= (8) and efd.id_periodo_academico=(30))
and ra.id_recurso_academico = 3