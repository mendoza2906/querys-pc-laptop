use bd_sga_upse;


-- /*==============================================================*/
-- /* Table: vacante_oferta                                        */
-- /*==============================================================*/
-- create table pro.vacante_oferta (
--    id_vacante_oferta    int                  identity,
--    id_vacante           int                  not null,
--    id_oferta            integer              not null,
--    estado               char(1)              not null default 'A',
--    version              int                  not null default 0,
--    fecha_ing            datetime2(7)         not null default getdate(),
--    fecha_mod            datetime2(7)         null default getdate(),
--    usuario_ing          varchar(255)         null,
--    usuario_mod          varchar(255)         null,
--    constraint pk_vacante_oferta primary key (id_vacante_oferta)
-- )
-- go
--
-- alter table pro.vacante_oferta
--    add constraint fk_vacante_oferta_reference_vacante foreign key (id_vacante)
--       references pro.vacante (id_vacante)
-- go
--
-- alter table pro.vacante_oferta
--    add constraint fk_vacante_oferta_reference_oferta foreign key (id_oferta)
--       references aca.oferta (id_oferta)
-- go
--
-- alter table pro.vacante
--    add constraint fk_vacante_reference_departam foreign key (id_facultad)
--       references man.departamentos (id)
-- go


------llenar vacantes
select pao.* from aca.oferta o
inner join aca.oferta_modalidad om on o.id_oferta = om.id_oferta
inner join aca.periodo_academico_oferta pao on om.id_oferta_modalidad = pao.id_oferta_modalidad
where pao.id_periodo_academico = 35 and om.id_oferta_modalidad in (85,20)

select top 5 * from pro.vacante v
where id_vacante in (817,818,819,820,821)
-- order by id_vacante desc
select * from pro.proceso_vacante where id_vacante = 818

select * from man.departamentos where tipo ='FAC'

select id_oferta,descripcion from aca.oferta where id_tipo_oferta = 3

select * from pro.vacante_oferta
-----configurar proceso
select * from pro.tipo_proceso
select * from pro.proceso
select * from pro.etapa where descripcion like '%resul%'
select * from [pro].[fn_list_all_facultades_by_process_and_periodo_academico](23,null)

select * from [pro].[fn_list_all_vacantes_by_process](23,null,null)

select * from [pro].[fn_list_evaluaciones_by_process](23,null,116)

SELECT * FROM pro.fn_list_postulaciones_concursos_merito_upse(23,null,null,null,
    null,null,2441)

SELECT d.codigoCategoriaEvaluacionPadre,d.categoriaEvaluacion,d.idEvaluacionRequisito,d.descripcionRequisito,d.idProcesoRequisito,d.idTipoDocumento,d.abreviaturaDocumento
FROM [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion](133,59,null,
                                                                7992,116,'SELCOORDINADORPOSTGRADOS') as d


select * from pro.etapa_ejecucion_documento2
order by id_etapa_ejecucion_documento desc



select * from pro.proceso_general
select * from pro.evaluacion_requisito where id_evaluacion_rubrica = 14

select * from pro.etapa_ejecucion_documento2 where id_etapa_ejecucion_documento = 24330

select * from pro.tipo_categorias_evaluacion

select * from pro.requisito_valor

select * from pro.docente_categoria_evaluacion

select * from [pro].[fn_list_all_postulaciones_concursos_merito](35,null,null,
    null,null,null,null,'SELCOORDINADORPOSTGRADOS',null)

-- 41,120,121,122,48  --requisitos
--28,50,120,123,121,33,83,39,42
select * from pro.proceso_requisito where id_proceso_requisito in (29,41,120,121,122,48,83 )



select * from aca.tipo_documento where descripcion like '%b1%'

select * from pro.evaluacion_requisito

select * from man.opciones
         where padre_id is null and codigo ='upload-documents-concurso-code'

-- update eed2 set id_evaluacion_requisito = dce.id_evaluacion_requisito from pro.etapa_ejecucion_documento2 eed2
-- inner join pro.docente_categoria_evaluacion dce on eed2.id_docente_categoria_evaluacion = dce.id_docente_categoria_evaluacion

select * from pro.etapa_ejecucion_documento2 where id_evaluacion_requisito is null

select * from pro.requisito_valor
select * from cmo.postulacion_vacante where usuario_ing='1710205897'

select * from pro.proceso_usuario2 pu
where usuario_ing ='2400254286'

SELECT * From pro.proceso_general


select * from aca.periodo_academico
--14
select distinct e.codigo,e.descripcion,pg.id_periodo_academico,pc.*
from  pro.proceso pro
inner join pro.proceso_general pg on pg.id_proceso = pro.id_proceso
inner join pro.proceso_etapa pe on pe.id_proceso = pro.id_proceso
inner join pro.etapa e on pe.id_etapa = e.id_etapa
inner join pro.tipo_proceso tp on (tp.id_tipo_proceso=pro.id_tipo_proceso)
inner join pro.proceso_calendario pc on pe.id_proceso_etapa = pc.id_proceso_etapa
where tp.codigo='SELCOORDINADORPOSTGRADOS'

select * from pro.tipo_proceso_estado

select * from pro.tipo_etapa_estado

select top 6 * from pro.proceso_usuario2
order by id_proceso_usuario desc

select * from pro.postulacion_vacante where id_proceso_usuario = 2441

select * from pro.evaluacion_rubrica

select * from pro.etapa_evaluaciones

select pg.*
from  pro.proceso pro
inner join pro.proceso_general pg on pg.id_proceso = pro.id_proceso
inner join pro.tipo_proceso tp on (tp.id_tipo_proceso=pro.id_tipo_proceso)
where pg.id_proceso_general = 23 and pro.estado='A' and pg.estado='A' and tp.estado='A'

select * from pro.proceso_general where id_proceso = 24

select * from pro.proceso_etapa where id_proceso = 25

select pc.* from pro.proceso_calendario pc
inner join pro.proceso_etapa pe on pc.id_proceso_etapa = pe.id_proceso_etapa
where pe.id_proceso = 25

select * from pro.proceso_etapa

select per.*--r.descripcion,r.nombre,e.descripcion
from 		 seg.roles r
		inner join pro.proceso_etapa_rol per on   r.id=per.id_rol
		inner join pro.proceso_etapa pe on pe.id_proceso_etapa=per.id_proceso_etapa
		inner join pro.proceso pro on pro.id_proceso = pe.id_proceso
		inner join pro.etapa e on e.id_etapa = pe.id_etapa
where pe.id_proceso = 2



select * from pro.proceso_vacante

select * from seg.roles

select * from [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_to_evaluar2](35,28,null,
    'REQUISITOS',2467,116,'SELCOORDINADORPOSTGRADOS')

select * from [pro].[fn_list_all_rubricas_evaluaciones_by_clasificacion_to_evaluar2](35,28,null,
    'REQUISITOS',2442,116,'SELCOORDINADORPOSTGRADOS')

select * from pro.etapa_ejecucion_requisito2

select * from [pro].[fn_list_all_rubricas_evaluaciones_procesos] (35,'SELCOORDINADORPOSTGRADOS',28,
    null)

select * from pro.evaluacion_requisito

alter table pro.etapa_ejecucion_requisito2
    alter column id_docente_categoria_evaluacion int null
go

exec [pro].[guardar_proceso_etapa_asignacion_responsables_posgrado]
select cg.id_calificacion_general,ma.id_malla_asignatura,ac.id_paralelo,ac.id_ciclo,count(ac.id_acta_calificacion) from aca.calificacion_general cg
inner join aca.acta_calificacion ac on cg.id_calificacion_general = ac.id_calificacion_general
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = ac.id_malla_asignatura
where cg.estado='A' and ac.estado='A' and ma.estado='A' and cg.id_calificacion_general = 16
group by cg.id_calificacion_general, ma.id_malla_asignatura, ac.id_paralelo, ac.id_ciclo
having count(ac.id_acta_calificacion)>1

