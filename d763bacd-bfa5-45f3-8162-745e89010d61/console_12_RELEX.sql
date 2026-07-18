
use bd_sga_upse;

select * from bdupse.rel.lininvestig_convenios

select * from  bdupse.rel.convenios c where c.id_convenio = 195

select * from rlx.convenio
select * from rlx.area_convenio
select * from rlx.cobertura_convenio
select * from rlx.convenio_actividad
select * from rlx.convenio_departamento
select * from rlx.convenio_documento

select * from man.personas where identificacion='2400254286'

SELECT * FROM   (SELECT row_number() OVER (ORDER BY fecha_suscripcion DESC) AS rownum,
id_convenio, codigo_conv, cg_tipoconvenio,tipo_convenio,cg_areaconvenio,area_convenio,
nombre_convenio,objeto_convenio, cg_arealaboral, area_laboral, cg_cobertura, cobertura_convenio,
CONVERT(VARCHAR(10), fecha_suscripcion, 111) as fecha_suscripcion,
CONVERT(VARCHAR(10), fecha_caduca, 111) as fecha_caduca, observ_conv, estado_convenio,
bdupse.rel.EntreFechasAnioMesDia(fecha_suscripcion,fecha_caduca) as vigencia,
isnull(plazo,'NO_DEFINIDO') as plazo
FROM bdupse.rel.convenios_upse
WHERE estado_convenio = 'AC') AS A
WHERE A.rownum BETWEEN 1 AND 10;


select * from bdupse.rel.convenios_instituciones ci where ci.id_convenio = 195
select * from bdupse.rel.intituciones_convenios ci where ci.id_convenio = 195


select * from bdupse.sag.instituciones_empresas e where --e.descripcion ='THE H0CHSCHULE BREMEN - CITY UNIVERSITY 0F APPLIE0 SCIENCES'
e.id

select * from Bd_Personal.dbo.tp_codigos where correlativo =2380

select * from Bd_Personal.dbo.tp_codigos where correlativo =5915

select  * from bdupse.ava.personas

select * from bdupse.rel.personas

select  * from bdupse.ava.personas

select  * from bdupse.ava.personas
select  * from bdupse.ava.personas
select  * from bdupse.ava.personas

select * from bdupse.sag.instituciones_ubicacion e where e.id  = 2380

select * from bdupse.rel.coordinador_convenios ci where ci.id_convenio = 195

select * from bdupse.rel.actividad_convenio ci where ci.id_convenio = 195

select * from bdupse.rel.anexo_convenio ci where ci.convenio_id = 195

select * from bdupse.rel.otras_actividades

select * from bdupse.rel.tipoconvenio

select * from bdupse.rel.personas


select * from bd_sga_upse.rlx.tipo_actividad

select * from bd_sga_upse.rlx.tipo_convenio

SELECT id_coordinador, id_convenio, id_persona, identificacion,APELLIDOS_NOMBRES as nomCompleto,
									CONVERT(VARCHAR(10), fecha_iniciocoordinacion, 111) as fecha_inicoordinacion,
									CONVERT(VARCHAR(10), fecha_fincoordinacion, 111) as fecha_fincoordinacion,
									estadocoord
									FROM bdupse.rel.infocoordinador
									WHERE id_convenio = '673'
									AND estadocoord <> 'EL'




USE bd_sga_upse


select *from man.departamentos



select distinct ddo.* from aca.distributivo_docente ddo
inner join aca.docente d on ddo.id_docente = d.id_docente
inner join aca.docente_asignatura_aprend daa on ddo.id_distributivo_docente = daa.id_distributivo_docente
inner join aca.distributivo_dedicacion dd on ddo.id_distributivo_docente = dd.id_distributivo_docente
inner join aca.docente_actividad dac on ddo.id_distributivo_docente = dac.id_distributivo_docente
inner join aca.asignatura_aprendizaje aa on daa.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
inner join aca.distributivo_oferta do on ddo.id_distributivo_oferta = do.id_distributivo_oferta
inner join aca.periodo_academico_oferta pao on do.id_periodo_academico_oferta = pao.id_periodo_academico_oferta
inner join man.personas p on p.identificacion = daa.usuario_mod
where d.id_persona = 1094 and pao.id_periodo_academico = 30 and ddo.id_distributivo_docente = 3025


SELECT ID_INSCRIPCION,ID_PLAN,CARRERA,JORNADA,CURSO,OBSERVACION,SITUACION,PROMEDIO,PERIODO,FECHA_INGRESO,ESTADO,USUARIO_INGRESO
				FROM Bd_Academico..VW_INSCRIPCIONES where IDENTIFICACION= '2400254286';

SELECT MATERIA_NOMBRE,nota,(inasistencia*100) as asistencia, 'aprobado' = case when nota>=80 then 'APROBADO' else 'REPROBADO' end,
					fecha_ing,usuario_ing,fecha_mod,usuario_mod
					FROM  bdupse.snu.materias_nivelacion_registro mn, Bd_Academico..VW_MATERIAS_PLAN mp
					WHERE mn.id_materia_plan=mp.ID_MATERIA_PLAN and  id_nivelacion_registro=15303 and id_plan=300 and mn.estado='A'

SELECT CG_INSTITUCION,ID_CARRERA_LOCAL,MATRICULA,CEDULA as IDENTIFICACION,
	        			CARRERA,periodo AS PERIODO_ACADEMICO,FECHA_EGRESO
	        			FROM Bd_Academico..Vw_Eg_Listado_Egresados where CEDULA ='2400254286'

SELECT IDENTIFICACION,MATRICULA,CARRERA,TITULO,fecha_graduacion AS FECHA_GRADO,
				instrumento AS METODO_TITULACION, promedio_instrumento AS PROMEDIO_TITULACION
				FROM bdupse.sge.fun_graduados_carrera (462,2) WHERE identificacion='2400254286';

select aa.* from aca.malla_asignatura ma
inner join aca.asignatura_aprendizaje aa on ma.id_malla_asignatura = aa.id_malla_asignatura
where ma.id_malla = 139 and aa.id_componente_aprendizaje = 16

select * from aca.componente_aprendizaje

select * from seg.usuarios where usuario ='0916777014'

select * from man.personas where apellidos like '%santos reyes%' and nombres like '%jorge%'

select * from aca.institucion

select * from aca.tipo_institucion

select * from aca.nivel_formacion

select * from rlx.convenio

select * from rlx.subtipo_convenio

select * from rlx.convenio_responsable

select * from ppp.participacion_practicas_preprolab
select * from seg.roles where descripcion like '%administrador%'

select * from sri.establecimiento

select * from seg.roles_usuarios where rol_id = 112

select * from vin.lineas_investigacion
--eliminados
-- select * from vcc.linea_investigacion
-- select * from vcc.sub_linea_investigacion
-- select * from vcc.dominio

select * from vcc.proyecto

select * from sgai.linea_investigacion

select d.*  from [aca].[fn_silabo](2431,30)  as d

select d.*  from [aca].[fn_silabo](2179,32)  as d
select DISTINCT  a.id_asignatura as idAsignatura,a.descripcion as nombreAsignatura,
            ma.num_horas as numHoras, ma.num_creditos as creditos,
            coalesce(aa.valor * pa.numero_semanas,0) as valor,
            coalesce(aa.valor * pa.numero_semanas,0)- coalesce(ISNULL(pca.valor,0) * pa.numero_semanas,0)  as valor2,
            pca.valor
            from aca.asignatura a
            inner JOIN aca.malla_asignatura ma on ma.id_asignatura=a.id_asignatura
            inner JOIN aca.nivel n on ma.id_nivel = n.id_nivel
            inner JOIN aca.malla m on ma.id_malla = m.id_malla
            inner JOIN aca.reglamento r on m.id_reglamento=r.id_reglamento
            inner JOIN aca.periodo_malla pm on pm.id_malla = m.id_malla
            inner JOIN aca.periodo_academico pa on pm.id_periodo_academico = pa.id_periodo_academico
            inner join aca.asignatura_aprendizaje aa on ma.id_malla_asignatura=aa.id_malla_asignatura
            inner join aca.componente_aprendizaje ca on aa.id_componente_aprendizaje=ca.id_componente_aprendizaje
            inner join aca.periodo_academico_oferta pao on pa.id_periodo_academico = pao.id_periodo_academico and pao.id_oferta_modalidad = m.id_oferta_modalidad
            left join aca.periodo_componente_aprendizaje pca on pca.id_periodo_academico_oferta = pao.id_periodo_academico_oferta
                                                                    and pca.id_componente_aprendizaje = ca.id_componente_aprendizaje
            WHERE ma.id_malla_asignatura = 2179
            and pa.id_periodo_academico=32 and aa.estado='A' and aa.valor>0


select * from aca.periodo_componente_aprendizaje

SELECT ta.id as id, ta.codigo as codigo, ta.nombre as nombre,ta.estado as estado,o.id_oferta as idOferta, o.descripcion as oferta
FROM man.departamentos ta left join aca.Departamento_Oferta  do on ta.id =do.id_departamento and do.estado='A'
left join aca.Oferta o on o.id_oferta = do.id_Oferta and o.estado='A' where ta.estado='AC'
order by ta.descripcion

select * from man.departamentos where estado='AC'

select * from aca.oferta where id_oferta = 67

select do.* from aca.departamento_oferta do
inner join aca.oferta o on do.id_oferta = o.id_oferta
where do.estado='A' and o.estado='I'

select * from man.documentos_ubicacion

select * from man.documentos_archivos

select * from pro.etapa_ejecucion_documento where id_tipo_documento = 26


select * from aca.tipo_documento

select * from aca.tipo_archivo

select * from rlx.convenio

-- 43727
--  DBCC CHECKIDENT ('man.personas', RESEED, 43727);
SELECT top 3 * FROM man.personas p
-- where identificacion ='2400254286'
order by id desc

select * from rlx.convenio_institucion

select * from rlx.convenio_responsable

select * from uath.cargo

select * from  aca.institucion

select * from aca.institucion_nivel_formacion inf
inner join aca.institucion i on inf.id_institucion = i.id_institucion
         where inf.estado='A' and i.estado='I'


select * from man.informacion_academica_persona inf
inner join aca.institucion i on inf.id_institucion = i.id_institucion
         where inf.estado='A' and i.estado='I'

select * from rlx.convenio_institucion inf
inner join aca.institucion i on inf.id_institucion = i.id_institucion
         where inf.estado='A' and i.estado='I'

select * from aca.campus inf
inner join aca.institucion i on inf.id_institucion = i.id_institucion
         where inf.estado='A' and i.estado='I'

select * from aca.malla where id_malla = 91

select * from aca.malla_asignatura where id_malla = 139
--insertar replicar docentes
--insert into aca.oferta_docente
select  pao2.id_periodo_academico_oferta, do.id_docente, 'A',getdate(), 664, 0
from aca.oferta_docente do
inner join aca.periodo_academico_oferta pao on do.id_periodo_academico_oferta = pao.id_periodo_academico_oferta
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = pao.id_oferta_modalidad
inner join aca.periodo_academico_oferta pao2 on pao2.id_oferta_modalidad = om.id_oferta_modalidad and pao2.id_periodo_academico = 34 and pao2.estado='A'
where pao.id_periodo_academico = 30 and pao.estado='A' and do.estado='A'

select* from aca.periodo_academico where id_tipo_oferta = 1

select --o.descripcion,
       om.*
from aca.oferta o
inner join aca.oferta_modalidad om on o.id_oferta = om.id_oferta
where om.estado='A' and o.estado='A' and o.id_tipo_oferta = 1 and om.id_oferta_modalidad= 121

select * from rlx.tipo_actividad

select * from card.tipo_actividad


select * from rlx.convenio_actividad ca where ca.id_tipo_actividad in (6)

select * from rlx.tipo_convenio

select * from rlx.subtipo_convenio

select * from aca.modalidad

select * from rlx.actividad_internacional




select ai.nombre_proyecto,ta.descripcion as tipo,mi.descripcion as modalidad_inicio,ai.descripcion,ai.objetivos,iif(i.descripcion is null,ai.otra_institucion,i.descripcion) as institucion,
       p.descripcion as pais,ai.fecha_inicio,ai.fecha_fin,tpe.descripcion as estado,ai.competencias_interculturales,ai.resultados_aprendizaje,ai.numero_sesiones,ai.numero_estudiantes_internos,ai.numero_estudiantes_extranjeros,
       ai.plataformas,ai.confirmacion_compromiso
from  rlx.actividad_internacional ai
inner join rlx.tipo_actividad ta on ai.id_tipo_actividad = ta.id_tipo_actividad
inner join  rlx.modalidad_inicio mi on ai.id_modalidad_inicio = mi.id_modalidad_inicio
inner join man.lugar p on ai.id_lugar = p.id_lugar
    left join aca.institucion i on ai.id_institucion = i.id_institucion
inner join pro.tipo_proceso_estado tpe on ai.id_tipo_proceso_estado = tpe.id_tipo_proceso_estado

