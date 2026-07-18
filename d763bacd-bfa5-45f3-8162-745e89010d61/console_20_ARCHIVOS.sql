use bd_sga_upse;

select * from man.documentos_ubicacion

select * from aca.tipo_documento

select * from aca.estudiante_matricula

select * from man.documentos_archivos where id_documento_ubicacion in (18,19,20)

select * from aca.tipo_cohorte

select * from aca.cohorte

select * from aca.cohorte_periodo_academico

select * from aca.matricula_general

select * from aca.tipo_matricula_fecha where id_matricula_general = 26

select * from aca.tipo_clasificacion_documento

select * from man.opciones where opciones.nombre like '% vida%'

select * from man.opciones where padre_id is null

--     select * from dbu.tipo_triage
--     select * from dbu.metricas where id_tipo_metrica_salud = 1
--     select * from dbu.tipo_metrica_salud
--     select * from pro.tipo_proceso_estado
--     select * from dbu.servicio
select * from dbu.examen_fisico


