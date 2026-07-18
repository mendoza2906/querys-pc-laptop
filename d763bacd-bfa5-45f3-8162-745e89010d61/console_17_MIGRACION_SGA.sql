use bd_sga_upse
--   exec  [dbo].[SPMigracionPersonasEstudiantesDiscontinuos]

select mp.ID_MATERIA_PLAN,m.id_malla,aux.descripcion,--mat.NOMBRE,
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
       case when mat.NOMBRE ='METODOLOGIA DE LA INVESTIGACION I' and aux.id_asignatura is null then 690
            when mat.NOMBRE ='METODOLOGIA DE LA INVESTIGACION II' and aux.id_asignatura is null then 691
            else aux.id_asignatura end id_asignatura,
       --aux.descripcion,
       case when mp.TOTAL_HORAS IS null then mp.CREDITOS*48 else mp.TOTAL_HORAS end as nom_horas,
       mp.CREDITOS as num_creditos , 1 as usuario_ingreso_id
from  Bd_Academico.dbo.MATERIAS_PLAN mp
          inner join Bd_Academico.dbo.MATERIAS mat on mat.ID_MATERIA = mp.ID_MATERIA
          inner join Bd_Academico.dbo.NIVELES ni on ni.ID_NIVEL = mp.ID_NIVEL
          inner join  migracion_sga.[dbo].[registros_migracion] rm  on rm.id_origen = mp.ID_PLAN
          inner join [bd_sga_upse].aca.malla m on rm.id_destino= m.id_malla
    --left join (select rm1.id_destino,rm1.id_origen,asi.id_asignatura,asi.descripcion from migracion_sga.[dbo].[registros_migracion] rm1
    --inner join bd_sga_upse.aca.asignatura asi on asi.id_asignatura = rm1.id_destino where rm1.id_entidad_relacion = 3)as aux on aux.descripcion = mat.NOMBRE
          left join ( select rm1.id_destino,rm1.id_origen,asi.id_asignatura,asi.descripcion from bd_sga_upse.aca.asignatura asi
                                                                                                     left join  migracion_sga.[dbo].[registros_migracion] rm1  on asi.id_asignatura = rm1.id_destino and rm1.id_entidad_relacion = 3 where asi.estado='A')
    as aux on aux.descripcion = mat.NOMBRE
where mp.ESTADO='A' and rm.id_entidad_relacion = 4 and ni.ID_NIVEL <>11 and ni.ID_NIVEL not in (40,47,48,49,50,51) and mp.ESTADO='A'
  --and mp.ID_PLAN in (453)
  and	mp.ID_PLAN in (10530)
order by m.id_malla,id_nivel

---proceso de migracion de los datos de nivelacion
SELECT ID_MATRICULA,NIVEL,MATRICULA,AULA,JORNADA,PERIODO_ACADEMICO,FECHA_MATRICULACION,CARRERA,ESTADO,VEZ,OBSERVACION,SITUACION,CURSO,PROMEDIO,USUARIO_INGRESO
FROM Bd_Academico..VW_MATRICULAS where ID_PERSONA = 23855;

select top 10 * from aca.estudiante_oferta

SELECT DISTINCT
    dis.ID_DISTRIBUTIVO,--
    ded.ID_PERSONA, per.IDENTIFICACION, per.APELLIDOS, per.APELLIDOS + ' ' + per.NOMBRES AS NOMBRE,
    pdet.id AS ID_PERIODO_DETALLE, dis.CG_PER_ACADEMICO, paca.VALOR_TEXTO AS PERIODO_ACADEMICO,--
    cloc.ID_CARRERA_OFERTADA AS ID_AREA,
    car.CARRERA AS AREA,
    dis.ID_MATERIA_PLAN, mat.NOMBRE AS MATERIA,
    dis.ID_REGISTRO_AULA, au.DENOMINACION,
    mat.ID_MATERIA, per.NOMBRES,
    per.E_MAIL as EMAIL, per.EMAIL_INST
FROM bd_academico..DISTRIBUTIVO_CARGA_HORARIA dis
         INNER JOIN Bd_Personal..PF_DEDICACION_DOCENTE ded ON dis.ID_DED = ded.ID_DED
         INNER JOIN Bd_Academico..MATERIAS mat ON dis.ID_MATERIA = mat.ID_MATERIA
         INNER JOIN Bd_Academico..NIVELES niv ON dis.ID_NIVEL = niv.ID_NIVEL
         INNER JOIN Bd_Personal..PF_PERSONAS per ON dis.ID_PERSONA = per.ID_PERSONA
         INNER JOIN Bd_Academico..VW_ASIG_AULAS au ON dis.ID_REGISTRO_AULA = au.ID_REGISTRO
         INNER JOIN Bd_Personal..TP_CODIGOS paca ON dis.CG_PER_ACADEMICO = paca.CORRELATIVO
         INNER JOIN bdupse.aca.periodo_detalle pdet ON pdet.id_periodo = dis.ID_PERIODO AND pdet.cg_periodo = dis.CG_PER_ACADEMICO
         INNER JOIN Bd_Academico..VW_TE_CARRERAS_LOCALIDAD car ON dis.ID_CARRERA_LOCAL = car.ID_CARRERA_LOCAL
         INNER JOIN Bd_Academico..CARRERAS_LOCALES_MODALIDAD_SISTEMA cloc ON car.ID_CARRERA_LOCAL = cloc.ID_CARRERA_LOCAL
WHERE dis.ESTADO = 'A' AND ded.ESTADO = 'A' AND mat.ESTADO = 'A' AND per.ESTADO = 'A' AND paca.ESTADO = 'A'
  AND niv.ID_NIVEL = 39 -- CARRERAS DE NIVELACION
  AND ded.ID_FLUJO = 2 --APROBADOS VICERRECTORADO DEDICACION
  AND dis.ID_FLUJO = 2 --APROBADOS VICERRECTORADO DISTRIBUTIVO
  AND ded.ID_SITUACION <> 4

SELECT ID_INSCRIPCION,ID_PLAN,CARRERA,JORNADA,CURSO,OBSERVACION,SITUACION,PROMEDIO,PERIODO,FECHA_INGRESO,ESTADO,USUARIO_INGRESO
FROM Bd_Academico..VW_INSCRIPCIONES where ID_PERSONA= 23855;

select * from bdupse.aca.periodo_detalle
where id in (select ID_PERIODO_DETALLE from Bd_Academico..TE_INSCRIPCIONES where ESTADO = 'A')


SELECT ID_INSCRIPCION,ID_PLAN,CARRERA,JORNADA,CURSO,OBSERVACION,SITUACION,PROMEDIO,PERIODO,FECHA_INGRESO,ESTADO,USUARIO_INGRESO
FROM Bd_Academico..VW_INSCRIPCIONES where IDENTIFICACION= '2400054280';

SELECT MATERIA_NOMBRE,nota,(inasistencia*100) as asistencia, 'aprobado' = case when nota>=80 then 'APROBADO' else 'REPROBADO' end, fecha_ing,usuario_ing,fecha_mod,usuario_mod
FROM bdupse.snu.materias_nivelacion_registro mn, Bd_Academico..VW_MATERIAS_PLAN mp
WHERE mn.id_materia_plan=mp.ID_MATERIA_PLAN and  id_nivelacion_registro=24382 and id_plan=10539 and mn.estado='A'


select * from Bd_academico.dbo.EG_LISTADO_GRADUADOS as d
where cast(d.FECHA_GRADUACION as date)>'2023-12-23'


SELECT CG_INSTITUCION,ID_CARRERA_LOCAL,MATRICULA,CEDULA as IDENTIFICACION,
CARRERA,periodo AS PERIODO_ACADEMICO,FECHA_EGRESO
FROM Bd_Academico..Vw_Eg_Listado_Egresados where id_persona=23855;

SELECT IDENTIFICACION,MATRICULA,CARRERA,TITULO,fecha_graduacion AS FECHA_GRADO,
instrumento AS METODO_TITULACION, promedio_instrumento AS PROMEDIO_TITULACION
FROM bdupse.sge.fun_graduados_carrera (462,2) WHERE identificacion='2400254286'


select*-- id_periodo_academico,id_periodo_academico_anterior,id_periodo_academico_siguiente,codigo,codigo_tipo_periodo,descripcion
from aca.periodo_academico where id_tipo_oferta = 1

select * from Bd_Academico.dbo.TP_CODIGOS where ID_CLASIFICACION = 33

select * from Bd_Academico.dbo.CLASIFICACIONES_GENERALES where ID_CLASIFICACION = 33

SELECT ID_INSCRIPCION,ID_PLAN,CARRERA,JORNADA,CURSO,OBSERVACION,SITUACION,PROMEDIO,PERIODO,FECHA_INGRESO,ESTADO,USUARIO_INGRESO
FROM Bd_Academico..VW_INSCRIPCIONES where IDENTIFICACION= '2400254286';


--ver detalle xd
SELECT tins.ID_INSCRIPCION,
       (SELECT     FACULTAD
        FROM          Bd_Academico.dbo.VW_CARRERAS_OFERTADAS AS VW_CARRERAS_OFERTADAS_2
        WHERE      (ID_CARRERA_OFERTADA = tins.ID_CARRERA_OFERTADA)) AS FACULTAD,
       (SELECT     ESCUELA
        FROM          Bd_Academico.dbo.VW_CARRERAS_OFERTADAS
        WHERE      (ID_CARRERA_OFERTADA = tins.ID_CARRERA_OFERTADA)) AS ESCUELA,
       cof.CARRERA,p.IDENTIFICACION, p.APELLIDOS + ' ' + p.NOMBRES AS NOMBRE,tins.NUMERO,
       cof.ID_CARRERA_LOCAL,tins.ID_REGISTRO_AULA  AS ID_PARALELO,aula.JORNADA,aula.AULA,aula.OBSERVACION,
       per.CG_PER_ACADEMICO,tins.ID_PAGO,p.ID_PERSONA, tins.ESTADO,aula.PARALELO,per.CG_MODALIDAD,
       per.CG_SISTEMA_ESTUDIO,ein.NOMBRE_ESTADO AS SITUACION,tins.FECHA,tins.PROMEDIO,pe.VALOR_TEXTO AS PERIODO,tins.PAGADO,
       tins.CG_PER_MATRICULA,aula.CG_JORNADA,MODALIDADES.VALOR_TEXTO AS MODALIDAD,
       tins.FECHA_INGRESO,tins.USUARIO_INGRESO,tins.ID_SITUACION,p.CG_SEXO,aula.SISTEMA,
       (SELECT     VALOR_TEXTO
        FROM          Bd_Academico.dbo.TP_CODIGOS
        WHERE      (CORRELATIVO = p.CG_SEXO))                        AS SEXO,aula.DENOMINACION AS CURSO,
       tins.ID_PERIODO_DETALLE,tins.ID_PLAN,tins.ID_NIVEL_SIG,ATENDIDO,p.APELLIDOS, p.NOMBRES,p.EMAIL, p.CG_DISCAPACIDAD,p.PORC_DISCAPACIDAD,
       tins.ESTATUS,tins.ID_CARRERA_OFERTADA_IES,
       (select nombre_carrera from Bd_Academico..CARRERAS_LOCALES_MODALIDAD_SISTEMA where ID_CARRERA_OFERTADA =
                                                                                          tins.ID_CARRERA_OFERTADA_IES) as carrera_ofertada
FROM         Bd_Academico.dbo.VW_ASIG_AULAS as aula
                 RIGHT OUTER JOIN Bd_Academico.dbo.TE_INSCRIPCIONES tins
                 INNER JOIN Bd_Academico.dbo.ESTADO_INSCRIPCIONES ein ON tins.ID_SITUACION = ein.ID_SITUACION
                 INNER JOIN Bd_Academico.dbo.PERIODOS_ACADEMICOS per
                 INNER JOIN Bd_Academico.dbo.TP_CODIGOS AS pe ON per.CG_PER_ACADEMICO = pe.CORRELATIVO ON tins.ID_PERIODO_DETALLE = per.ID_DETALLE
                 INNER JOIN Bd_Academico. dbo.TP_CODIGOS AS MODALIDADES ON per.CG_MODALIDAD = MODALIDADES.CORRELATIVO
                 INNER JOIN Bd_Academico.dbo.VW_CARRERAS_OFERTADAS AS cof ON tins.ID_CARRERA_OFERTADA = cof.ID_CARRERA_OFERTADA
                 left JOIN Bd_Academico.dbo.VW_CARRERAS_OFERTADAS AS coreal ON tins.ID_CARRERA_OFERTADA_IES = coreal.ID_CARRERA_OFERTADA
                 INNER JOIN Bd_Academico.dbo.PERSONAS p ON tins.ID_PERSONA = p.ID_PERSONA ON aula.ID_REGISTRO = tins.ID_REGISTRO_AULA
WHERE     (tins.ESTADO not in ('X','C','N','E','I')) --and tins.ID_INSCRIPCION in (22620,35185)
  and p.IDENTIFICACION in (select d.identificacion from (
select dd.identificacion,dd.apellidos,dd.nombres,dd.carrera,count(dd.area) as areas from mig.fn_listar_cupos_from_te_inscripciones(null) as dd
where dd.area is not null
group by dd.identificacion,dd.apellidos,dd.nombres,dd.carrera
having count(dd.area)>1) as d)
order by p.APELLIDOS,p.NOMBRES,pe.VALOR_TEXTO,cof.CARRERA


select * from bdupse.snu.materias_nivelacion_registro mn

select * from bdupse.snu.nivelacion_registro

select * from Bd_Academico.dbo.TP_CODIGOS where CORRELATIVO = 477

select * from Bd_Academico.dbo.TP_CODIGOS where CORRELATIVO in (200,469,227)

--manes que han hecho cambio de carrera interno
SELECT DISTINCT
NOMBRE, IDENTIFICACION, ID_CARRERA_OFERTADA, CARRERA_OFERTADA,
PRIMERA_FECHA_MATRIC = (SELECT MIN(FECHA_MATRICULACION) from Bd_Academico..TE_MATRICULAS
				WHERE ID_CARRERA_LOCAL = m.ID_CARRERA_LOCAL AND ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND ID_PERSONA = m.id_persona and estado = 'A')
FROM Bd_Academico..VW_MATRICULAS m
WHERE estado = 'A' AND CG_PER_ACADEMICO <= 28152
AND ID_CARRERA_OFERTADA <> 196
GROUP BY ID_PERSONA, NOMBRE, IDENTIFICACION, ID_CARRERA_OFERTADA, CARRERA_OFERTADA, ID_CARRERA_LOCAL
HAVING (SELECT COUNT(distinct id_carrera_ofertada) from Bd_Academico..TE_MATRICULAS where ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND ID_PERSONA = m.id_persona and estado = 'A') > 1
ORDER BY NOMBRE, 5 ASC

--manes que vienen de otras universidades
SELECT * FROM BD_ACADEMICO..VW_RECORD_ACADEMICO_TODO_MOVILIDAD
WHERE estado like 'CONVALIDA%'

select * from man.departamentos
select *from aca.departamento_oferta
select top 10 * from aca.estudiante_oferta
SELECT * FROM mig.record_matricula
SELECT * FROM mig.record_asignaturas
select * from mig.record_oferta
select * from aca.tipo_jornada_laboral
select * from aca.tipo_estudiante
select * from aca.estudiante_oferta where estudiante_oferta.id_tipo_ingreso_estudiante in(6)
select * from aca.tipo_ingreso_estudiante
select * from aca.tipo_estado_estudiante

SELECT mn.id_nivelacion_registro,mp.ID_PLAN,MATERIA_NOMBRE,nota,(inasistencia*100) as asistencia, 'aprobado' = case when nota>=80 then 'APROBADO' else 'REPROBADO' end,
       fecha_ing,usuario_ing,fecha_mod,usuario_mod
FROM bdupse.snu.materias_nivelacion_registro mn, Bd_Academico..VW_MATERIAS_PLAN mp
WHERE mn.id_materia_plan=mp.ID_MATERIA_PLAN and  mn.estado='A' and id_nivelacion_registro in (20092,20093) --and id_plan=300
-- DBCC CHECKIDENT ('aca.tipo_ingreso_estudiante', RESEED, 16);

--35922
--3657

--------VISTAS PARA INSERT TABLAS

--INSERT RECORD OFERTAS

    CREATE VIEW mig.insert_data_to_record_ofertas AS
    select --a.gratuidad,a.carrera,
           null as id_record_oferta_padre,d.id_periodo_academico, d.id_periodo_academico_cg, d.id_tipo_jornada_laboral,d.tipo_estudiante, d.id_tipo_ingreso_estudiante,
    d.id_tipo_estado_estudiante, d.id_persona_cg, d.id_carrera_ofertada,d.id_area,d.id_tipo_oferta,d.id_oferta_modalidad, d.id_estudiante_oferta, d.id_modalidad_cg,
    d.modalidad,d.periodo, d.sistema_estudio, d.facultad, d.carrera, d.escuela, d.area, d.numero_matricula, d.numero_matricula_cg,
    iif(a.gratuidad is null or a.gratuidad='MANTIENE GRATUIDAD',1,0) as mantiene_gratuidad,
    d.promedio, d.identificacion,d.nombres, d.apellidos, d.fecha_ingreso, d.id_number, d.table_name, d.estado, d.version,
    d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod from (
    SELECT iif(pa.id_periodo_academico is null and pe.VALOR_TEXTO='2011-1-PRE',103,pa.id_periodo_academico) as id_periodo_academico,per.CG_PER_ACADEMICO as id_periodo_academico_cg,
    case aula.JORNADA when 'NOCTURNO' then 3 when 'VESPERTINA' THEN 2 WHEN 'DIURNO' then 1 else null end as id_tipo_jornada_laboral,1 as tipo_estudiante,
    case  when substring(pe.VALOR_TEXTO,1,4)  < '2012' then 16
    when substring(pe.VALOR_TEXTO,1,4)  < '2017' then 17 when substring(pe.VALOR_TEXTO,1,4) < '2020' then 18
    when substring(pe.VALOR_TEXTO,1,4) < '2022' then 19 when substring(pe.VALOR_TEXTO,1,4)  < '2023' then 1
    when substring(pe.VALOR_TEXTO,1,4)  < '2024' then 7 else null end as id_tipo_ingreso_estudiante,
    null as id_tipo_estado_estudiante,p.ID_PERSONA as id_persona_cg,isnull(tins.ID_CARRERA_OFERTADA_IES,tins.ID_CARRERA_OFERTADA) as id_carrera_ofertada,
    iif(tins.ID_CARRERA_OFERTADA_IES is null,null,tins.ID_CARRERA_OFERTADA) as id_area,1 as id_tipo_oferta,null as id_oferta_modalidad,
    null as id_estudiante_oferta,per.CG_MODALIDAD as id_modalidad_cg,mod.VALOR_TEXTO as modalidad, iif(pe.VALOR_TEXTO='2011-1-PRE','2011-3',pe.VALOR_TEXTO) as periodo,
    aula.SISTEMA as sistema_estudio, cof.FACULTAD AS facultad,isnull(coreal.CARRERA,cof.CARRERA) as carrera,cof.ESCUELA as escuela,
    iif(coreal.CARRERA is null,null,cof.CARRERA)as area,'POR DEFINIR' as numero_matricula,'POR DEFINIR' as numero_matricula_cg,
    1 as mantiene_gratuidad,
    tins.PROMEDIO as promedio,
    p.IDENTIFICACION as identificacion,p.NOMBRES as nombres,p.APELLIDOS as apellidos, tins.FECHA_INGRESO as fecha_ingreso,
    tins.ID_INSCRIPCION as id_number,'Bd_Academico.dbo.TE_INSCRIPCIONES' as table_name,
    tins.ESTADO as estado,0 as version,getdate() as fecha_ing,getdate() as fecha_mod,
    '2400254286' as usuario_ing, '2400254286' as usuario_mod
    FROM         Bd_Academico.dbo.VW_ASIG_AULAS as aula
    RIGHT OUTER JOIN Bd_Academico.dbo.TE_INSCRIPCIONES tins
    INNER JOIN Bd_Academico.dbo.ESTADO_INSCRIPCIONES ein ON tins.ID_SITUACION = ein.ID_SITUACION
    INNER JOIN Bd_Academico.dbo.PERIODOS_ACADEMICOS per
    INNER JOIN Bd_Academico.dbo.TP_CODIGOS AS pe ON per.CG_PER_ACADEMICO = pe.CORRELATIVO ON tins.ID_PERIODO_DETALLE = per.ID_DETALLE
    INNER JOIN Bd_Academico. dbo.TP_CODIGOS AS mod ON per.CG_MODALIDAD = mod.CORRELATIVO
    INNER JOIN Bd_Academico.dbo.PERSONAS p ON tins.ID_PERSONA = p.ID_PERSONA ON aula.ID_REGISTRO = tins.ID_REGISTRO_AULA
    INNER JOIN Bd_Academico.dbo.VW_CARRERAS_OFERTADAS AS cof ON tins.ID_CARRERA_OFERTADA = cof.ID_CARRERA_OFERTADA
    left JOIN Bd_Academico.dbo.VW_CARRERAS_OFERTADAS AS coreal ON tins.ID_CARRERA_OFERTADA_IES = coreal.ID_CARRERA_OFERTADA
    left join aca.periodo_academico pa on pa.codigo = pe.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 1
    left join mig.record_oferta ro on id_number = tins.ID_INSCRIPCION
    WHERE    tins.ESTADO not in('X','C','N','E','I') and ro.id_record_oferta is null
    group by per.CG_MODALIDAD, aula.SISTEMA, cof.FACULTAD,cof.CARRERA,pe.VALOR_TEXTO,  coreal.CARRERA, cof.ESCUELA, p.IDENTIFICACION, p.APELLIDOS,
    p.NOMBRES, tins.PROMEDIO, tins.ESTADO, tins.ID_INSCRIPCION, tins.ID_CARRERA_OFERTADA, p.ID_PERSONA, tins.FECHA_INGRESO,
    tins.ID_CARRERA_OFERTADA_IES, pa.id_periodo_academico, per.CG_PER_ACADEMICO, aula.JORNADA,mod.VALOR_TEXTO
    ) as d
    left join bdupse.snu.aspirante a on a.identificacion = d.identificacion and d.carrera like concat('%',a.carrera,' %')

--INSERT RECORD MATRICULAS
    ALTER VIEW mig.insert_data_to_record_matriculas AS
    select d.id_record_oferta, d.id_periodo_academico, d.id_periodo_academico_cg, d.id_tipo_matricula, d.aula, d.curso, d.vez, d.promedio,
           d.valor_total,iif(d.atendido=1,null,'Matrícula no efectivizada')  as observacion,d.estado_matricula, d.fecha_matricula, d.id_number, d.table_name,
           iif(d.atendido=1,d.estado,'M') as estado,d.version, d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod from(
    SELECT ro.id_record_oferta,iif(pa.id_periodo_academico is null and pe.VALOR_TEXTO='2011-1-PRE',103,pa.id_periodo_academico) as id_periodo_academico,per.CG_PER_ACADEMICO as id_periodo_academico_cg,
           --tins.CG_PER_MATRICULA,tiMat.VALOR_TEXTO as tipoMatricula,
    isnull(tm.id_tipo_matricula,1) as id_tipo_matricula,--rm.curso,
           aula.AULA as aula,aula.DENOMINACION AS curso,iif(tins.ESTATUS=1 or tins.ESTATUS is null,'1 VEZ','2 VEZ') as vez,tins.PROMEDIO as promedio,
           0 as valor_total,null as observacion,ein.NOMBRE_ESTADO AS estado_matricula,tins.FECHA_INGRESO as fecha_matricula,
           tins.ID_INSCRIPCION as id_number,'Bd_Academico.dbo.TE_INSCRIPCIONES' as table_name,tins.ESTADO as estado,
           0 as version,getdate() as fecha_ing,getdate() as fecha_mod,
           '2400254286' as usuario_ing, '2400254286' as usuario_mod,iif(pe.VALOR_TEXTO <'2014-1',1,isnull(tins.atendido,0)) as atendido,pe.VALOR_TEXTO as periodo
    FROM         Bd_Academico.dbo.VW_ASIG_AULAS as aula
    RIGHT OUTER JOIN Bd_Academico.dbo.TE_INSCRIPCIONES tins
    INNER JOIN Bd_Academico.dbo.ESTADO_INSCRIPCIONES ein ON tins.ID_SITUACION = ein.ID_SITUACION
    INNER JOIN Bd_Academico.dbo.PERIODOS_ACADEMICOS per
    INNER JOIN Bd_Academico.dbo.TP_CODIGOS AS pe ON per.CG_PER_ACADEMICO = pe.CORRELATIVO ON tins.ID_PERIODO_DETALLE = per.ID_DETALLE
    INNER JOIN Bd_Academico.dbo.VW_CARRERAS_OFERTADAS AS cof ON tins.ID_CARRERA_OFERTADA = cof.ID_CARRERA_OFERTADA
    INNER JOIN Bd_Academico.dbo.PERSONAS p ON tins.ID_PERSONA = p.ID_PERSONA ON aula.ID_REGISTRO = tins.ID_REGISTRO_AULA
    left join aca.periodo_academico pa on pa.codigo = pe.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 1
    inner join mig.record_oferta ro on id_number = tins.ID_INSCRIPCION
    left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
    left JOIN Bd_Academico.dbo.TP_CODIGOS AS tiMat ON tins.CG_PER_MATRICULA = tiMat.CORRELATIVO
    left join aca.tipo_matricula tm on tm.descripcion = tiMat.VALOR_TEXTO
    WHERE     (tins.ESTADO not in ('X','C','N','E','I')) and rm.id_record_matricula is null
    ) as d

--INSERT RECORD ASIGNATURAS
    CREATE VIEW mig.insert_data_to_record_asignaturas AS
    select d.id_record_oferta, d.id_record_matricula, d.id_periodo_academico, d.id_periodo_academico_cg, d.id_malla_asignatura,
           d.id_materia_plan, d.id_malla, d.id_plan, iif(d.id_paralelo in ('1-2','1/2'),2,iif(d.id_paralelo in ('1-1','1/1'),1,isnull(d.id_paralelo,1))) as id_paralelo,
           d.id_nivel, d.id_nivel_cg, d.nivel,isnull(d.tipo_malla,'CREDITOS') as tipo_malla, d.asignatura, d.vez, d.creditos, d.horas, d.promedio, d.asistencia,
           d.estado_tomada, d.valor_asignatura, d.tipo,d.aprobado, d.estado_aprobacion, d.periodo,d.identificacion_docente, d.docente, d.orden,
           d.fecha_registro, d.id_number, d.table_name,d.estado, d.version,d.fecha_ing,d.fecha_mod, d.usuario_ing, d.usuario_mod from (
    SELECT distinct ro.id_carrera_ofertada,ro.id_record_oferta,rm.id_record_matricula,rm.id_periodo_academico,rm.id_periodo_academico_cg,null as id_malla_asignatura,
           mp.ID_MATERIA_PLAN as id_materia_plan,null as id_malla,mp.ID_PLAN as id_plan,
        CASE
            WHEN PATINDEX('%[0-9]%', rm.curso) > 0
                THEN LEFT(SUBSTRING(rm.curso, PATINDEX('%[0-9]%', rm.curso), LEN(rm.curso)),
                          CHARINDEX(' ', SUBSTRING(rm.curso, PATINDEX('%[0-9]%', rm.curso), LEN(rm.curso)) + ' ') - 1)
            ELSE null -- Devuelve NULL si no encuentra números en la cadena
            END AS id_paralelo,
        11 as id_nivel,39 as id_nivel_cg,'NIVELACION' as nivel,mp.TIPO_PLAN as tipo_malla ,mp.MATERIA_NOMBRE as asignatura,rm.vez as vez,
        mp.CREDITOS as creditos,mp.HORAS_SEMANA as horas,mn.PROMEDIO as promedio,--cast((mn.ASISTENCIA*100) as numeric(5,2)) as asistencia,
        iif((mn.ASISTENCIA*100)>100,100,round((mn.ASISTENCIA*100),2,0)) as asistencia,
               'NORMAL' as estado_tomada,0 as valor_asignatura,'ASIGNATURA' as tipo,
        mn.aprobado as aprobado,case when mn.PROMEDIO>=80 then 'APROBADO' else 'REPROBADO' end as estado_aprobacion,pa.codigo as periodo,
        isnull(doc.IDENTIFICACION,'NO REGISTRA') as identificacion_docente,isnull(doc.nombre_completo,'NO REGISTRA') as docente,
        ROW_NUMBER() OVER (PARTITION BY rm.id_record_matricula ORDER BY mp.MATERIA_NOMBRE) as orden,
        isnull(mn.FECHA_GEN,getdate()) as fecha_registro,
        mn.ID_MATERIA_PRE_INS as id_number,'Bd_Academico.dbo.MATERIA_PRE_INS' as table_name,mn.ESTADO as estado,
        0 as version,getdate() as fecha_ing,getdate() as fecha_mod,
        '2400254286' as usuario_ing, '2400254286' as usuario_mod
    FROM  Bd_Academico.dbo.MATERIA_PRE_INS mn
    inner join Bd_Academico..VW_MATERIAS_PLAN mp on mn.id_materia_plan=mp.ID_MATERIA_PLAN
    inner join mig.record_matricula rm on rm.id_number = mn.ID_INSCRIPCION
    inner join aca.periodo_academico pa on rm.id_periodo_academico = pa.id_periodo_academico
    inner join mig.record_oferta ro on rm.id_record_oferta = ro.id_record_oferta
    left join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
    LEFT JOIN ( select d.* from mig.fn_get_docentes_from_distributivo (null,null,
                                                                      null,null,39) as d ) doc ON doc.ID_MATERIA_PLAN = mp.ID_MATERIA_PLAN
    AND doc.CG_PER_ACADEMICO = rm.id_periodo_academico_cg and doc.id_registro_aula = mn.ID_REGISTRO_AULA
        AND doc.ID_AREA = iif(ro.id_area is not null, ro.id_area, ro.id_carrera_ofertada) AND doc.fila_numero = 1  -- Solo la primera fila de cada materia plan
    WHERE  mn.estado='A' and ra.id_record_asignatura is null
    ) as d

  select * from  Bd_Academico.dbo.MATERIA_PRE_INS
--RECORD MATRICULA SEGUNDA VEZ
    ALTER VIEW mig.insert_data_to_record_matriculas_second as
    select ro1.id_record_oferta, d.id_periodo_academico, d.id_periodo_academico_cg, d.id_tipo_matricula, d.aula, d.curso, d.vez, d.promedio,
    d.valor_total,iif(d.atendido=1,null,'Matrícula no efectivizada')  as observacion,d.estado_matricula, d.fecha_matricula, d.id_number, d.table_name,
    iif(d.atendido=1,d.estado,'M') as estado,d.version, d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod
--     ,d.identificacion,d.carrera
    from(
    SELECT iif(pa.id_periodo_academico is null and pe.VALOR_TEXTO='2011-1-PRE',103,pa.id_periodo_academico) as id_periodo_academico,per.CG_PER_ACADEMICO as id_periodo_academico_cg,
    --tins.CG_PER_MATRICULA,tiMat.VALOR_TEXTO as tipoMatricula,
    isnull(tm.id_tipo_matricula,1) as id_tipo_matricula,--rm.curso,
    aula.AULA as aula,aula.DENOMINACION AS curso,iif(tins.ESTATUS=1 or tins.ESTATUS is null,'1 VEZ','2 VEZ') as vez,tins.PROMEDIO as promedio,
    0 as valor_total,null as observacion,ein.NOMBRE_ESTADO AS estado_matricula,tins.FECHA_INGRESO as fecha_matricula,
    tins.ID_INSCRIPCION as id_number,'Bd_Academico.dbo.TE_INSCRIPCIONES' as table_name,tins.ESTADO as estado,
    0 as version,getdate() as fecha_ing,getdate() as fecha_mod, '2400254286' as usuario_ing, '2400254286' as usuario_mod
    ,iif(pe.VALOR_TEXTO <'2014-1',1,isnull(tins.atendido,0)) as atendido,pe.VALOR_TEXTO as periodo, isnull(coreal.CARRERA,cof.CARRERA) as carrera,p.IDENTIFICACION as identificacion
    FROM         Bd_Academico.dbo.VW_ASIG_AULAS as aula
    RIGHT OUTER JOIN Bd_Academico.dbo.TE_INSCRIPCIONES tins
    INNER JOIN Bd_Academico.dbo.ESTADO_INSCRIPCIONES ein ON tins.ID_SITUACION = ein.ID_SITUACION
    INNER JOIN Bd_Academico.dbo.PERIODOS_ACADEMICOS per
    INNER JOIN Bd_Academico.dbo.TP_CODIGOS AS pe ON per.CG_PER_ACADEMICO = pe.CORRELATIVO ON tins.ID_PERIODO_DETALLE = per.ID_DETALLE
    INNER JOIN Bd_Academico.dbo.PERSONAS p ON tins.ID_PERSONA = p.ID_PERSONA ON aula.ID_REGISTRO = tins.ID_REGISTRO_AULA
    INNER JOIN Bd_Academico.dbo.VW_CARRERAS_OFERTADAS AS cof ON tins.ID_CARRERA_OFERTADA = cof.ID_CARRERA_OFERTADA
    left JOIN Bd_Academico.dbo.VW_CARRERAS_OFERTADAS AS coreal ON tins.ID_CARRERA_OFERTADA_IES = coreal.ID_CARRERA_OFERTADA
    left join aca.periodo_academico pa on pa.codigo = pe.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 1
    left JOIN Bd_Academico.dbo.TP_CODIGOS AS tiMat ON tins.CG_PER_MATRICULA = tiMat.CORRELATIVO
    left join aca.tipo_matricula tm on tm.descripcion = tiMat.VALOR_TEXTO
    WHERE     (tins.ESTADO not in ('X','C','N','E','I'))
    ) as d
    left join mig.record_oferta ro on ro.id_number = d.id_number
    left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
    inner join mig.record_oferta ro1 on ro1.carrera = d.carrera and ro1.identificacion = d.identificacion
    where rm.id_record_matricula is null

--saber los manes que solo tiene primera y segunda vez
    ALTER VIEW mig.list_number_first_and_second as
    select d.* from (
    select dd.identificación,dd.apellidos,dd.nombres,count(CASE WHEN dd.vez='1 VEZ' THEN 1 END) AS primera_vez,
           count(CASE WHEN dd.vez='2 VEZ' THEN 1 END) AS segunda_vez from (
        select d.modalidad,d.periodo, d.sistema_estudio, d.facultad, d.carrera, d.escuela, d.area, d.numero_matricula, d.numero_matricula_cg,
        iif(a.gratuidad is null or a.gratuidad='MANTIENE GRATUIDAD',1,0) as mantiene_gratuidad,iif(d.periodo <'2014-1',1,isnull(d.atendido,0)) as atendido,
        d.promedio,d.vez, d.identificación,d.nombres, d.apellidos, d.fecha_ingreso, d.id_number, d.table_name, d.estado, d.version
        from (
        SELECT iif(pa.id_periodo_academico is null and pe.VALOR_TEXTO='2011-1-PRE',103,pa.id_periodo_academico) as id_periodo_academico,per.CG_PER_ACADEMICO as id_periodo_academico_cg,
        case aula.JORNADA when 'NOCTURNO' then 3 when 'VESPERTINA' THEN 2 WHEN 'DIURNO' then 1 else null end as id_tipo_jornada_laboral,1 as tipo_estudiante,
        case  when substring(pe.VALOR_TEXTO,1,4)  < '2012' then 16
        when substring(pe.VALOR_TEXTO,1,4)  < '2017' then 17  when substring(pe.VALOR_TEXTO,1,4) < '2020' then 18
        when substring(pe.VALOR_TEXTO,1,4) < '2022' then 19 when substring(pe.VALOR_TEXTO,1,4)  < '2023' then 1
        when substring(pe.VALOR_TEXTO,1,4)  < '2024' then 7 else null end as id_tipo_ingreso_estudiante,
        null as id_tipo_estado_estudiante,
        p.ID_PERSONA as id_persona_cg,isnull(tins.ID_CARRERA_OFERTADA_IES,tins.ID_CARRERA_OFERTADA) as id_carrera_ofertada,null as id_oferta_modalidad,
        null as id_estudiante_oferta,per.CG_MODALIDAD as id_modalidad_cg,mod.VALOR_TEXTO as modalidad, iif(pe.VALOR_TEXTO='2011-1-PRE','2011-3',pe.VALOR_TEXTO) as periodo,
        aula.SISTEMA as sistema_estudio, cof.FACULTAD AS facultad,isnull(coreal.CARRERA,cof.CARRERA) as carrera,cof.ESCUELA as escuela,
        iif(coreal.CARRERA is null,null,cof.CARRERA)as area,'POR DEFINIR' as numero_matricula,'POR DEFINIR' as numero_matricula_cg,
        case  when substring(pe.VALOR_TEXTO,1,4)  < '2020' then 1
        when substring(pe.VALOR_TEXTO,1,4) < '2022' then 1 else null end as mantiene_gratuidad,
        tins.PROMEDIO as promedio,
        p.IDENTIFICACION as identificación,p.NOMBRES as nombres,p.APELLIDOS as apellidos, tins.FECHA_INGRESO as fecha_ingreso,
        tins.ID_INSCRIPCION as id_number,'Bd_Academico.dbo.TE_INSCRIPCIONES' as table_name,
        tins.ESTADO as estado,0 as version,getdate() as fecha_ing,getdate() as fecha_mod,
        '2400254286' as usuario_ing, '2400254286' as usuario_mod
        ,iif(tins.ESTATUS is null or tins.ESTATUS=1,'1 VEZ','2 VEZ') as vez,tins.ATENDIDO as atendido
        FROM         Bd_Academico.dbo.VW_ASIG_AULAS as aula
        RIGHT OUTER JOIN Bd_Academico.dbo.TE_INSCRIPCIONES tins
        INNER JOIN Bd_Academico.dbo.ESTADO_INSCRIPCIONES ein ON tins.ID_SITUACION = ein.ID_SITUACION
        INNER JOIN Bd_Academico.dbo.PERIODOS_ACADEMICOS per
        INNER JOIN Bd_Academico.dbo.TP_CODIGOS AS pe ON per.CG_PER_ACADEMICO = pe.CORRELATIVO ON tins.ID_PERIODO_DETALLE = per.ID_DETALLE
        INNER JOIN Bd_Academico. dbo.TP_CODIGOS AS mod ON per.CG_MODALIDAD = mod.CORRELATIVO
        INNER JOIN Bd_Academico.dbo.VW_CARRERAS_OFERTADAS AS cof ON tins.ID_CARRERA_OFERTADA = cof.ID_CARRERA_OFERTADA
        INNER JOIN Bd_Academico.dbo.PERSONAS p ON tins.ID_PERSONA = p.ID_PERSONA ON aula.ID_REGISTRO = tins.ID_REGISTRO_AULA
        left JOIN Bd_Academico.dbo.VW_CARRERAS_OFERTADAS AS coreal ON tins.ID_CARRERA_OFERTADA_IES = coreal.ID_CARRERA_OFERTADA
        left join aca.periodo_academico pa on pa.codigo = pe.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 1
        WHERE    tins.ESTADO not in('X','C','N','E','I')
        group by per.CG_MODALIDAD, aula.SISTEMA, cof.FACULTAD,cof.CARRERA,pe.VALOR_TEXTO,  coreal.CARRERA, cof.ESCUELA, p.IDENTIFICACION, p.APELLIDOS,
        p.NOMBRES, tins.PROMEDIO, tins.ESTADO, tins.ID_INSCRIPCION, tins.ID_CARRERA_OFERTADA, p.ID_PERSONA, tins.FECHA_INGRESO,
        tins.ID_CARRERA_OFERTADA_IES, pa.id_periodo_academico, per.CG_PER_ACADEMICO, aula.JORNADA,mod.VALOR_TEXTO
        ,tins.ESTATUS,tins.ATENDIDO
        ) as d
        left join bdupse.snu.aspirante a on a.identificacion = d.identificación and d.carrera like concat('%',a.carrera,' %')
        left join mig.record_oferta ro on ro.id_number = d.id_number and ro.table_name='Bd_Academico.dbo.TE_INSCRIPCIONES'
        where ro.id_record_oferta is null
    ) as dd
    group by dd.identificación,dd.apellidos,dd.nombres
    -- having count(CASE WHEN dd.vez='1 VEZ' THEN 1 END)>0 and count(CASE WHEN dd.vez='2 VEZ' THEN 1 END)>0
    ) as d

----------FIN DE VISTAS DE INSERT
select * from bdupse.snu.aspirante where identificacion='0923566004'

---aqui estan los cupos de la matriz de senescyt volver aqui.
select * from bdupse.snu.aspirante
where identificacion='0941221236'
--2019-2 se empezo a quitar la gratuidad
--listado con todos los campos
    select * from mig.record_oferta
-- insert into mig.record_oferta
-- hay 8729 registros dobles que en teorian se deberia convertir en 7649 ya que hay 1080 segundas matriculas
select d.id_periodo_academico, d.id_periodo_academico_cg, d.id_tipo_jornada_laboral,d.tipo_estudiante, d.id_tipo_ingreso_estudiante,
       d.id_tipo_estado_estudiante, d.id_persona_cg, d.id_carrera_ofertada, d.id_oferta_modalidad, d.id_estudiante_oferta, d.id_modalidad_cg,
       d.modalidad,d.periodo, d.sistema_estudio, d.facultad,d.carrera, d.carrera, d.escuela, d.area, d.numero_matricula, d.numero_matricula_cg,
       iif(a.gratuidad is null or a.gratuidad='MANTIENE GRATUIDAD',1,0) as mantiene_gratuidad,iif(d.periodo <'2014-1',1,isnull(d.atendido,0)) as atendido,
       d.promedio,d.vez, d.identificación,d.nombres, d.apellidos, d.fecha_ingreso, d.id_number, d.table_name, d.estado, d.version
--        ,d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod
from (
SELECT iif(pa.id_periodo_academico is null and pe.VALOR_TEXTO='2011-1-PRE',103,pa.id_periodo_academico) as id_periodo_academico,per.CG_PER_ACADEMICO as id_periodo_academico_cg,
       case aula.JORNADA when 'NOCTURNO' then 3 when 'VESPERTINA' THEN 2 WHEN 'DIURNO' then 1 else null end as id_tipo_jornada_laboral,1 as tipo_estudiante,
       case  when substring(pe.VALOR_TEXTO,1,4)  < '2012' then 16
    when substring(pe.VALOR_TEXTO,1,4)  < '2017' then 17  when substring(pe.VALOR_TEXTO,1,4) < '2020' then 18
    when substring(pe.VALOR_TEXTO,1,4) < '2022' then 19 when substring(pe.VALOR_TEXTO,1,4)  < '2023' then 1
    when substring(pe.VALOR_TEXTO,1,4)  < '2024' then 7 else null end as id_tipo_ingreso_estudiante,
    null as id_tipo_estado_estudiante,
       p.ID_PERSONA as id_persona_cg,isnull(tins.ID_CARRERA_OFERTADA_IES,tins.ID_CARRERA_OFERTADA) as id_carrera_ofertada,null as id_oferta_modalidad,
       null as id_estudiante_oferta,per.CG_MODALIDAD as id_modalidad_cg,mod.VALOR_TEXTO as modalidad, iif(pe.VALOR_TEXTO='2011-1-PRE','2011-3',pe.VALOR_TEXTO) as periodo,
       aula.SISTEMA as sistema_estudio, cof.FACULTAD AS facultad,isnull(coreal.CARRERA,cof.CARRERA) as carrera,cof.ESCUELA as escuela,
       iif(coreal.CARRERA is null,null,cof.CARRERA)as area,'POR DEFINIR' as numero_matricula,'POR DEFINIR' as numero_matricula_cg,
    case  when substring(pe.VALOR_TEXTO,1,4)  < '2020' then 1
    when substring(pe.VALOR_TEXTO,1,4) < '2022' then 1 else null end as mantiene_gratuidad,
    tins.PROMEDIO as promedio,
       p.IDENTIFICACION as identificación,p.NOMBRES as nombres,p.APELLIDOS as apellidos, tins.FECHA_INGRESO as fecha_ingreso,
       tins.ID_INSCRIPCION as id_number,'Bd_Academico.dbo.TE_INSCRIPCIONES' as table_name,
       tins.ESTADO as estado,0 as version,getdate() as fecha_ing,getdate() as fecha_mod,
       '2400254286' as usuario_ing, '2400254286' as usuario_mod
    ,iif(tins.ESTATUS is null or tins.ESTATUS=1,'1 VEZ','2 VEZ') as vez,tins.ATENDIDO as atendido
    FROM         Bd_Academico.dbo.VW_ASIG_AULAS as aula
    RIGHT OUTER JOIN Bd_Academico.dbo.TE_INSCRIPCIONES tins
    INNER JOIN Bd_Academico.dbo.ESTADO_INSCRIPCIONES ein ON tins.ID_SITUACION = ein.ID_SITUACION
    INNER JOIN Bd_Academico.dbo.PERIODOS_ACADEMICOS per
    INNER JOIN Bd_Academico.dbo.TP_CODIGOS AS pe ON per.CG_PER_ACADEMICO = pe.CORRELATIVO ON tins.ID_PERIODO_DETALLE = per.ID_DETALLE
    INNER JOIN Bd_Academico. dbo.TP_CODIGOS AS mod ON per.CG_MODALIDAD = mod.CORRELATIVO
    INNER JOIN Bd_Academico.dbo.VW_CARRERAS_OFERTADAS AS cof ON tins.ID_CARRERA_OFERTADA = cof.ID_CARRERA_OFERTADA
    INNER JOIN Bd_Academico.dbo.PERSONAS p ON tins.ID_PERSONA = p.ID_PERSONA ON aula.ID_REGISTRO = tins.ID_REGISTRO_AULA
    left JOIN Bd_Academico.dbo.VW_CARRERAS_OFERTADAS AS coreal ON tins.ID_CARRERA_OFERTADA_IES = coreal.ID_CARRERA_OFERTADA
    left join aca.periodo_academico pa on pa.codigo = pe.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 1
WHERE    tins.ESTADO not in('X','C','N','E','I')
group by per.CG_MODALIDAD, aula.SISTEMA, cof.FACULTAD,cof.CARRERA,pe.VALOR_TEXTO,  coreal.CARRERA, cof.ESCUELA, p.IDENTIFICACION, p.APELLIDOS,
         p.NOMBRES, tins.PROMEDIO, tins.ESTADO, tins.ID_INSCRIPCION, tins.ID_CARRERA_OFERTADA, p.ID_PERSONA, tins.FECHA_INGRESO,
         tins.ID_CARRERA_OFERTADA_IES, pa.id_periodo_academico, per.CG_PER_ACADEMICO, aula.JORNADA,mod.VALOR_TEXTO
         ,tins.ESTATUS,tins.ATENDIDO
) as d
left join bdupse.snu.aspirante a on a.identificacion = d.identificación and d.carrera like concat('%',a.carrera,' %')
left join mig.record_oferta ro on ro.id_number = d.id_number and ro.table_name='Bd_Academico.dbo.TE_INSCRIPCIONES'
where
-- d.identificación='0917005688'
-- d.identificación='2450831611'
  d.identificación in (select distinct xd.identificacion from(select dd.identificacion,sum(dd.num_matriculas) as carrera from mig.fn_listar_cupos_from_te_inscripciones(null) as dd
    group by dd.identificacion
    having sum(dd.num_matriculas)>1)as xd) and
    ro.id_record_oferta is null
order by d.apellidos,d.nombres,d.periodo,d.carrera

--saber los manes que solo tiene primera y segunda vez
select * from mig.list_number_first_and_second as d
where (d.primera_vez = 0 and d.segunda_vez>0) or (d.primera_vez > 0 and d.segunda_vez=0)
order by d.apellidos,d.nombres


--201 manes que posiblemente solo es un cupo y sale 2 , deberia haber 402
--estudiantes con areas
select dd.identificacion,dd.apellidos,dd.nombres,dd.carrera,count(dd.area) as areas from mig.fn_listar_cupos_from_te_inscripciones(null) as dd
where dd.area is not null
group by dd.identificacion,dd.apellidos,dd.nombres,dd.carrera
having count(dd.area)>1

--estudiantes con mas de un cupo
select distinct xd.identificacion from(select dd.identificacion,sum(dd.num_matriculas) as carrera from mig.fn_listar_cupos_from_te_inscripciones(null) as dd
group by dd.identificacion
having sum(dd.num_matriculas)=1)as xd

select distinct xd.identificacion from(select dd.identificacion,sum(dd.num_matriculas) as carrera from mig.fn_listar_cupos_from_te_inscripciones(null) as dd
group by dd.identificacion
having sum(dd.num_matriculas)>1)as xd

select  ro.*,mp.MATERIA_NOMBRE from  Bd_Academico.dbo.MATERIA_PRE_INS mn
                       inner join Bd_Academico..VW_MATERIAS_PLAN mp on mn.id_materia_plan=mp.ID_MATERIA_PLAN
                       inner join mig.record_matricula rm on rm.id_number = mn.ID_INSCRIPCION
                       inner join aca.periodo_academico pa on rm.id_periodo_academico = pa.id_periodo_academico
                       inner join mig.record_oferta ro on rm.id_record_oferta = ro.id_record_oferta
where --mn.ID_INSCRIPCION in (22620,35185)
    mn.ID_MATERIA_PRE_INS = 99141

    select *from (
    select distinct tins.ID_INSCRIPCION,tins.ATENDIDO,sum(CASE WHEN mat.estado = 'E' THEN 1 ELSE 0 END) AS total_eliminados,
                    sum(CASE WHEN mat.estado = 'I' THEN 1 ELSE 0 END) AS total_inactivos,
                    count(mat.ID_MATERIA_PRE_INS) as total from Bd_Academico..MATERIA_PRE_INS mat
    inner join Bd_Academico.dbo.TE_INSCRIPCIONES tins on mat.ID_INSCRIPCION = tins.ID_INSCRIPCION
    where tins.ESTADO='A'
    group by tins.ID_INSCRIPCION, tins.ATENDIDO) as d
    where d.total_eliminados=d.total

---ver si los manes que ya matricule si tiene un cupo nuevo

select asp.gratuidad,tins.ESTATUS,ro.* from mig.record_oferta ro
inner join Bd_Academico.dbo.TE_INSCRIPCIONES tins on tins.ID_INSCRIPCION = ro.id_number
inner join bdupse.snu.aspirante asp on asp.identificacion = ro.identificacion
where ro.periodo>'2019-2'

--26582 34915
-- DBCC CHECKIDENT ('mig.record_oferta', RESEED, 34915);
-- delete mig.record_oferta where id_tipo_oferta = 2
select * from mig.record_oferta
--26586 35906
-- DBCC CHECKIDENT ('mig.record_matricula', RESEED, 35906);
-- delete from mig.record_matricula where id_record_matricula>35906
select * from mig.record_matricula

-- update rm set rm.periodo = pa.codigo from mig.record_matricula rm
-- inner join aca.periodo_academico pa on rm.id_periodo_academico = pa.id_periodo_academico

-- update rm set rm.id_tipo_jornada_laboral = case aula.JORNADA when 'NOCTURNO' then 3 when 'VESPERTINA' THEN 2 WHEN 'DIURNO' then 1 else null end from mig.record_matricula rm
-- inner join mig.record_oferta ro on rm.id_record_oferta = ro.id_record_oferta and ro.id_tipo_oferta = 1 and ro.table_name='Bd_Academico.dbo.TE_INSCRIPCIONES'
-- inner join Bd_Academico.dbo.TE_INSCRIPCIONES tins on tins.ID_INSCRIPCION = rm.id_number and rm.table_name='Bd_Academico.dbo.TE_INSCRIPCIONES'
-- inner join Bd_Academico.dbo.VW_ASIG_AULAS as aula ON aula.ID_REGISTRO = tins.ID_REGISTRO_AULA
-- INNER JOIN Bd_Academico.dbo.PERSONAS p on tins.ID_PERSONA = p.ID_PERSONA
--103041 140884
-- DBCC CHECKIDENT ('mig.record_asignaturas', RESEED, 140884);
-- delete mig.record_asignaturas where id_record_asignatura>140884
select * from mig.record_asignaturas


select * from rel.oferta_relaciones

select * from [rel].[fn_relaciones_ofertas_nivelacion_grado] (38)

select * from aca.oferta where id_tipo_oferta = 2

select * from mig.oferta_correspondencia

select pao.id_periodo_academico,om.id_oferta_modalidad,o.descripcion
--        o.descripcion,
--        pao.*
from aca.periodo_academico_oferta pao
         inner join aca.oferta_modalidad om on pao.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
where pao.id_periodo_academico = 36

-- en TE_MATRICULas hay un id_origen que hace referencia a TE_INSCRIPCIONES
select * from mig.fn_listar_cupos_from_te_inscripciones('0921511655')

exec [mig].[sp_generate_datamart_estado_academico] 38,1,10


        --26566
        -- delete from mig.record_oferta
        -- DBCC CHECKIDENT ('mig.record_oferta', RESEED, 0);
        -- select * from mig.record_oferta
        insert into mig.record_oferta
        select * from mig.insert_data_to_record_ofertas as d
        where d.identificacion in (select cx.identificacion from(select dd.identificacion,sum(dd.num_matriculas) as carrera from mig.fn_listar_cupos_from_te_inscripciones(null) as dd
        group by dd.identificacion
        having sum(dd.num_matriculas)=1)as cx)
        order by d.periodo,d.carrera,d.apellidos,d.nombres

                select xd.identificacion,xd.apellidos,xd.nombres from(
                select dd.identificacion,dd.apellidos,dd.nombres,sum(dd.num_matriculas) as carrera from mig.fn_listar_cupos_from_te_inscripciones(null) as dd
                where dd.identificacion not in (select distinct identificacion from mig.record_oferta WITH (NOLOCK))
                group by dd.identificacion,dd.apellidos,dd.nombres
                having sum(dd.num_matriculas)>1)as xd
                order by  xd.apellidos,xd.nombres asc

    select top 5 * from mig.record_oferta
--                 order by id_record_oferta desc

--                 select * from mig.record_oferta where id_record_oferta_padre is not null
--                  DBCC CHECKIDENT ('mig.record_oferta', RESEED, 26566);

--                 select * from mig.record_oferta where identificacion='2450217217'
                ---INSERTAMOS TODOS LOS CUPOS POR PRIMERA VEZ DE LOS MANES QUE TIENE MAS DE UN CUPO
                insert into mig.record_oferta
                select d.id_record_oferta_padre, d.id_periodo_academico, d.id_periodo_academico_cg, d.id_tipo_jornada_laboral, d.tipo_estudiante, d.id_tipo_ingreso_estudiante,
                       d.id_tipo_estado_estudiante, d.id_persona_cg, d.id_carrera_ofertada, d.id_area, d.id_tipo_oferta,d.id_sistema_estudio,d.id_sistema_estudio_cg, d.id_oferta_modalidad, d.id_estudiante_oferta,
                       null,d.id_modalidad_cg, d.modalidad, d.periodo, d.sistema_estudio, d.facultad,d.carrera, d.carrera, d.escuela, d.area, d.numero_matricula, d.numero_matricula_cg,
--                                        iif(tins.ESTATUS is null or tins.ESTATUS=1,'1 VEZ','2 VEZ') as vez,
                       d.mantiene_gratuidad, d.promedio, d.identificacion, d.nombres, d.apellidos, d.fecha_ingreso, d.id_number, d.table_name, d.estado, d.version,
                       d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod
                from mig.insert_data_to_record_ofertas as d
                inner join Bd_Academico.dbo.TE_INSCRIPCIONES tins on tins.ID_INSCRIPCION = d.id_number
                where  d.identificacion='' and
                (tins.ESTATUS is null or tins.ESTATUS=1)
                order by d.apellidos,d.nombres,d.carrera,d.periodo

--                 select rm.* from mig.record_matricula rm
--                 inner join mig.record_oferta ro on ro.id_record_oferta = rm.id_record_oferta
--                 where ro.identificacion=@identificacion



                update mig.record_matricula  set curso= concat('P/',substring(curso,7,14))
                where curso like '%0. P./%'

--                 select rm.* from  mig.record_oferta ro
--                 inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
--                 inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
--                 where ro.identificacion=@identificacion


--                 select @carreras_twice
--             2450608480 tiene un caso de segunda vez en la misma carrera
--             1900794353 tiene un caso de segunda vez en la misma carrera
--             2450656158 tiene un caso de segunda vez pero tomada en otra carrera de resideño
--             2400144651 tiene un caso de segunda vez pero tomada en otra carrera de resideño
--             0923568588  caso que tiene varias ofertas y todas por primera vez
--              0917005688 caso de un man que tiene materias por segunda vez y que su tendria mas de 1 record_oferta con que asociarse.
--              2450831611 caso de un man que tiene materias por segunda vez y que su tendria mas de 1 record_oferta con que asociarse, tiene las misma ofertas antes y despues del cupo.

                --preguntamos si esta persona tiene matriculas por segunda vez

                        --INSERTA COMO UN NUEVO CUPO SOLO SI LA SEGUNDA VEZ TOMO EN OTRA CARRERA CON REDISEÑO- DENTRO LOS CASOS DETERMINADOS
                    insert into mig.record_oferta
                    select top 1 ro.id_record_oferta as id_record_oferta_padre, d.id_periodo_academico, d.id_periodo_academico_cg, d.id_tipo_jornada_laboral, d.tipo_estudiante, d.id_tipo_ingreso_estudiante,
                    d.id_tipo_estado_estudiante, d.id_persona_cg, d.id_carrera_ofertada, d.id_area, d.id_tipo_oferta,d.id_sistema_estudio,d.id_sistema_estudio_cg, d.id_oferta_modalidad,d.id_estudiante_oferta,null,
                    d.id_modalidad_cg, d.modalidad, d.periodo, d.sistema_estudio, d.facultad,d.carrera, d.carrera, d.escuela, d.area, d.numero_matricula, d.numero_matricula_cg,
                    d.mantiene_gratuidad, d.promedio, d.identificacion, d.nombres, d.apellidos, d.fecha_ingreso, d.id_number, d.table_name, d.estado, d.version,
                    d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod--,ro.periodo,ro.carrera
                    --                 ,iif(tins.ESTATUS is null or tins.ESTATUS=1,'1 VEZ','2 VEZ') as vez
                    from mig.insert_data_to_record_ofertas as d
                    inner join Bd_Academico.dbo.TE_INSCRIPCIONES tins on tins.ID_INSCRIPCION = d.id_number
                    inner join mig.oferta_conexion oc on oc.oferta_relacion = d.carrera and oc.id_oferta_relacion =d.id_carrera_ofertada
                    inner join mig.record_oferta ro WITH (NOLOCK) on ro.carrera = oc.oferta and ro.identificacion = d.identificacion
                                                                         and ro.id_tipo_oferta = 1 and ro.table_name='Bd_Academico.dbo.TE_INSCRIPCIONES'
                    where  d.identificacion='' and
                           (tins.ESTATUS=0)
                    order by d.fecha_ingreso desc

                    /*--INSERTA LA MATRICULA DE SEGUNDA VEZ  SI ES DE UN SEGUNDA VEZ POR REDISEÑO
                    --                 insert into mig.record_matricula
                    select d.* from mig.insert_data_to_record_matriculas as d
                    inner join mig.record_oferta ro on ro.id_record_oferta = d.id_record_oferta
                    where ro.identificacion='2450656158'
                    order by d.id_record_oferta*/

                     --INSERTA LA MATRICULA DE SEGUNDA VEZ EN UNA CABECERA EXISTENTE
--                      insert into mig.record_matricula
                    select d.*,ro.identificacion from mig.insert_data_to_record_matriculas_second as d
                    inner join mig.record_oferta ro WITH (NOLOCK) on ro.id_record_oferta = d.id_record_oferta
                    where d.id_record_oferta is not null and ro.fecha_registro<=d.fecha_matricula and ro.identificacion='2400238107'
                    order by d.id_record_oferta desc


                    --INSERTA LAS ASIGNATURAS DE LA MATRICULA CREADA YA SEA SI ES CUPO NUEVO POR SEGUNDA VEZ O MISMO CUPO SEGUNDA VEZ
                    insert into mig.record_asignaturas
                    select d.* from mig.insert_data_to_record_asignaturas as d
                    inner join mig.record_oferta ro WITH (NOLOCK) on ro.id_record_oferta = d.id_record_oferta
                    where ro.identificacion=@identificacion



            DECLARE cur_estudiantes_ofertas CURSOR FOR

--         select me.idCarreraOfertada,@id_oferta_modalidad,@id_estudiante_oferta_cur,me.codigo,me.modalidad,me.sistema,me.carrera,me.identificacion,
--                                @matricula,me.matricula,me.estudiante from @tempMatriculasEstudiante me
--         left join [migracion_sga].[dbo].[registros_migracion] rmo on  rmo.id_origen  = me.idCarreraOfertada and rmo.id_entidad_relacion = 2

            SELECT ID_MATRICULA,NIVEL,MATRICULA,AULA,JORNADA,PERIODO_ACADEMICO,FECHA_MATRICULACION,CARRERA,ESTADO,VEZ,OBSERVACION,SITUACION,CURSO,PROMEDIO,USUARIO_INGRESO
            FROM Bd_Academico..VW_MATRICULAS where ID_PERSONA = 27223;
--         23855    17885
--             acaa
            --51478 registros sin los datos del sga con carreras nuevas
            --48471 sin carreras nuevas
            --32325 sin replica del SGA
            --32270 sin replica del SGA y sin cabeceras retiradas
            -- 34473 final
            -- 32770 sin repetidos
--             insert into mig.record_oferta
            select distinct d.id_record_oferta_padre, d.id_periodo_academico, d.id_periodo_academico_cg, d.id_tipo_jornada_laboral, d.tipo_estudiante, d.id_tipo_ingreso_estudiante,
                   d.id_tipo_estado_estudiante, d.id_persona_cg, d.id_carrera_ofertada, d.id_area,d.id_tipo_oferta,d.id_sistema_estudio,d.id_sistema_estudio_cg, d.id_oferta_modalidad,
                   d.id_estudiante_oferta,null, d.id_modalidad_cg,
                   d.modalidad, d.periodo, d.sistema_estudio, d.facultad,d.carrera, d.carrera, d.escuela, d.area, d.numero_matricula, d.numero_matricula_cg, d.mantiene_gratuidad, d.promedio,
                   d.identificacion, d.nombres, d.apellidos, d.fecha_ingreso, d.id_number, d.table_name, d.estado, d.version, d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod from (
            select distinct null as id_record_oferta_padre,null as id_periodo_academico,null as id_periodo_academico_cg,4 as  id_tipo_jornada_laboral,
                   3 as tipo_estudiante,2 as id_tipo_ingreso_estudiante,1 as id_tipo_estado_estudiante,p.ID_PERSONA as id_persona_cg,
                   isnull(m.ID_CARRERA_OFERTADA,m.ID_CARRERA_LOCAL) as id_carrera_ofertada,
            null as id_area,2 as id_tipo_oferta,mig.id_sistema_estudio,m.CG_SISTEMA_ESTUDIO as id_sistema_estudio_cg,
            aux.id_oferta_modalidad as id_oferta_modalidad,aux.id_estudiante_oferta  as id_estudiante_oferta,m.cg_modalidad as id_modalidad_cg, mo.valor_texto as modalidad, null as periodo,
            isnull(sis.VALOR_TEXTO,'SEMESTRAL') as sistema_estudio,cl.FACULTAD as facultad,
            iif(aux.id_estudiante_oferta is not null,aux.oferta,cl.CARRERA) as carrera, -- cl.CARRERA as carrera,
            cl.ESCUELA as escuela,null as area, aux.numero_matricula as numero_matricula, m.MATRICULA as numero_matricula_cg,1 as mantiene_gratuidad,0 as promedio,
            p.IDENTIFICACION as identificacion,p.nombres as nombres,p.apellidos as apellidos,m.FECHA_MATRICULACION as fecha_ingreso,
--             isnull(m.ID_CARRERA_OFERTADA,m.id_carrera_local) as id_number,
            isnull((select min(m2.ID_MATRICULA) from bd_academico..te_matriculas m2 where m2.estado not in ('E','X') and m2.ID_PERSONA=m.id_persona
                                       and m2.ID_CARRERA_OFERTADA = m.ID_CARRERA_OFERTADA),
                   (select min(m2.ID_MATRICULA) from bd_academico..te_matriculas m2 where m2.estado not in ('E','X') and m2.ID_PERSONA=m.id_persona
                                                                                      and m2.ID_CARRERA_LOCAL = m.ID_CARRERA_LOCAL)) as id_number,
            iif(m.ID_CARRERA_OFERTADA is null,'bd_academico..te_matriculas.id_carrera_local','bd_academico..te_matriculas.ID_CARRERA_OFERTADA') as table_name,
            m.estado as estado,0 as version,getdate() as fecha_ing,getdate() as fecha_mod,
            '2400254286' as usuario_ing, '2400254286' as usuario_mod
            from bd_academico..personas p
            inner join bd_academico..te_matriculas m on p.id_persona=m.id_persona
            inner join Bd_Academico.dbo.vw_te_carreras_localidad cl on cl.id_carrera_local= m.id_carrera_local
            left join Bd_Academico.dbo.tp_codigos mo on mo.correlativo=m.cg_modalidad
            left join Bd_Academico.dbo.tp_codigos sis on  sis.correlativo=m.cg_sistema_estudio
            left join [migracion_sga].[dbo].[registros_migracion] rmo on  rmo.id_origen  = m.ID_CARRERA_OFERTADA and rmo.id_entidad_relacion = 2
            left join (select p.id as idPersona,p.identificacion,eo.id_estudiante_oferta,om.id_oferta_modalidad,eo.numero_matricula,o.descripcion as oferta from man.personas p
            inner join aca.estudiante_oferta eo on eo.id_persona = p.id
            inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
            inner join aca.oferta o on o.id_oferta = om.id_oferta
            inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
            where eo.estado ='A') as aux on aux.id_oferta_modalidad = rmo.id_destino and aux.identificacion = p.identificacion
            left join (select s.id_sistema_estudio,rn.id_origen,rn.id_destino,s.descripcion as sistema_estudio from migracion_sga..registros_migracion rn
                                                                                                                        left join aca.sistema_estudio s on s.id_sistema_estudio = rn.id_destino and s.estado in ('A')
                       where rn.id_entidad_relacion in (40) ) as mig on mig.id_origen = m.CG_SISTEMA_ESTUDIO
            where m.estado not in ('E','X') and p.estado='A' --and p.identificacion='2400254286'
            and m.id_nivel in (select id_nivel from Bd_Academico.dbo.niveles where interfaz=3)
              and m.CG_PER_ACADEMICO <28470
            and cl.CARRERA<>'CENTRO DE IDIOMAS'
            and (aux.id_oferta_modalidad is null or aux.id_oferta_modalidad not in (select d.idOfertaModalidadPregrado from [rel].[fn_relaciones_ofertas_nivelacion_grado] (32) as d
            where d.idOfertaModalidadNivelacion not in (select dd.idOfertaModalidadNivelacion from [rel].[fn_relaciones_ofertas_nivelacion_grado] (15)as dd)))
            ) as d
            left join mig.record_oferta ro on ro.id_number = d.id_number and ro.id_tipo_oferta = 2 and ro.identificacion= d.identificacion
                                                  and ro.id_carrera_ofertada = d.id_carrera_ofertada
--                                                     and ro.carrera = d.carrera
            and ro.numero_matricula_cg = d.numero_matricula_cg
--             inner join (select * from mig.temp_record_oferta) as aux on aux.id_number = d.id_number and aux.valido = 1 and aux.estado=d.estado
            where ro.id_record_oferta is null and d.numero_matricula_cg is not null and d.id_persona_cg  not in(5995)
            order by d.apellidos,d.nombres,d.carrera,d.estado


            select mig.id_sistema_estudio,sis.CORRELATIVO,ro.*
--             update ro set ro.id_sistema_estudio = mig.id_sistema_estudio,ro.id_sistema_estudio_cg= sis.CORRELATIVO
            from mig.record_oferta ro
            left join Bd_Academico..TP_CODIGOS sis on sis.VALOR_TEXTO = ro.sistema_estudio and sis.ID_CLASIFICACION = 19
            left join (select s.id_sistema_estudio,rn.id_origen,rn.id_destino,s.descripcion as sistema_estudio from migracion_sga..registros_migracion rn
                             left join aca.sistema_estudio s on s.id_sistema_estudio = rn.id_destino and s.estado in ('A')
                                            where rn.id_entidad_relacion in (40) ) as mig on mig.id_origen = sis.CORRELATIVO
            WHERE   ro.id_tipo_oferta = 1 and ro.table_name='Bd_Academico.dbo.TE_INSCRIPCIONES'

            select mig.id_sistema_estudio,sis.CORRELATIVO,ro.*
--             update ro set ro.id_sistema_estudio = mig.id_sistema_estudio,ro.id_sistema_estudio_cg= sis.CORRELATIVO
            from mig.record_oferta ro
            left join Bd_Academico..TP_CODIGOS sis on sis.VALOR_TEXTO = ro.sistema_estudio and sis.ID_CLASIFICACION = 19
            left join (select s.id_sistema_estudio,rn.id_origen,rn.id_destino,s.descripcion as sistema_estudio from migracion_sga..registros_migracion rn
                left join aca.sistema_estudio s on s.id_sistema_estudio = rn.id_destino and s.estado in ('A')
            where rn.id_entidad_relacion in (40) ) as mig on mig.id_origen = sis.CORRELATIVO
            WHERE   ro.id_tipo_oferta = 2 --and ro.table_name='Bd_Academico.dbo.TE_INSCRIPCIONES'

            select * from Bd_Academico..TP_CODIGOS where CORRELATIVO in (200,4910)

            select * from Bd_Academico..TP_CODIGOS where ID_CLASIFICACION in (19,121)

            --152109 sin id_record_oferta
            --152114 con  id_record_oferta
            --186139 con  id_record_oferta y anuladas y retiradas
            --151968 sin repetidas
--             insert into mig.record_matricula
                SELECT distinct isnull(ro.id_record_oferta,ro1.id_record_oferta) as id_record_oferta,pa.id_periodo_academico as id_periodo_academico,
                te.CG_PER_ACADEMICO as id_periodo_academico_cg,
                case   when pm.VALOR_TEXTO in ('ORDINARIO DISPOSICION SUPERIOR','ORDINARIA') then 1
                when pm.VALOR_TEXTO in ('EXTRAORDINARIA') THEN 2
                when pm.VALOR_TEXTO in ('ESPECIAL','ESPECIAL DISPOSICION SUPERIOR','ESPECIAL DISPOSICION SUPERIOR','RESOLUCION','RESOLUCION OCAS') then 3 else 1 end  as id_tipo_matricula,
                case aula.JORNADA when 'NOCTURNO' then 3 when 'VESPERTINA' THEN 2 WHEN 'DIURNO' then 1 else null end as id_tipo_jornada_laboral,
                iif(te.ID_NIVEL>10,null,te.ID_NIVEL) as id_nivel, NIVELES.DESCRIPCION AS nivel, isnull(aula.AULA,'NO DEFINIDA') as aula, isnull(aula.DESCRIPCION,'NO DEFINIDO') as curso,
                iif(tr.VALOR_TEXTO='GUAYAQUIL'  or tr.VALOR_TEXTO is null,'1 VEZ',tr.VALOR_TEXTO) as vez,
                isnull(te.PROMEDIO,0) as promedio,isnull(te.VALOR,0) as valor,te.OBSERVACION as observacion,
                --                    p.IDENTIFICACION as identificacion, cl.CARRERA AS CARRERA, te.ID_CARRERA_OFERTADA,te.MATRICULA,
                --                 isnull(replace(iif(LEN(aula.PARALELO)>=3,RIGHT(aula.PARALELO, LEN(aula.PARALELO) - CHARINDEX('/', aula.PARALELO)),aula.PARALELO),'.', ''),1) as id_paralelo,
                ESTADO_MATRICULAS.NOMBRE_ESTADO as estado_matricula,te.FECHA_MATRICULACION as fecha_matricula,per.VALOR_TEXTO as periodo,
                te.ID_MATRICULA as id_number,'Bd_Academico.dbo.TE_MATRICULAS' as table_name,null as id_number_old,null as table_name_old, te.ESTADO as estado,
               0 as version,getdate() as fecha_ing,getdate() as fecha_mod,
               '2400254286' as usuario_ing, '2400254286' as usuario_mod
            FROM   Bd_Academico..TE_MATRICULAS as te
            INNER JOIN Bd_Academico..PERSONAS p ON te.ID_PERSONA = p.ID_PERSONA
            inner join Bd_Academico.dbo.vw_te_carreras_localidad cl on cl.id_carrera_local= te.id_carrera_local
            left JOIN Bd_Academico..NIVELES ON te.ID_NIVEL = NIVELES.ID_NIVEL
            left JOIN Bd_Academico..ESTADO_MATRICULAS ON te.ID_SITUACION = ESTADO_MATRICULAS.ID_SITUACION
            LEFT JOIN Bd_Academico..VW_CARRERAS_OFERTADAS AS cof ON te.ID_CARRERA_OFERTADA = cof.ID_CARRERA_OFERTADA
            LEFT jOIN Bd_Academico..TP_CODIGOS AS per ON te.CG_PER_ACADEMICO = per.CORRELATIVO
            LEFT JOIN Bd_Academico..TP_CODIGOS AS pm ON te.CG_PER_MATRICULA = pm.CORRELATIVO
            LEFT JOIN Bd_Academico..TP_CODIGOS AS tr ON te.CG_TIPO_REGISTRO = tr.CORRELATIVO
            LEFT JOIN Bd_Academico..VW_ASIG_AULAS  as aula ON te.ID_REGISTRO_AULA = aula.ID_REGISTRO
            LEFT JOIN Bd_Academico..PLAN_ESTUDIOS ON te.ID_PLAN = PLAN_ESTUDIOS.ID_PLAN
            left join aca.periodo_academico pa on pa.codigo = per.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 2
            left join mig.record_oferta ro on ro.id_carrera_ofertada = isnull(te.ID_CARRERA_OFERTADA,te.ID_CARRERA_LOCAL) and ro.id_tipo_oferta = 2
            and ro.identificacion= p.identificacion  and ro.numero_matricula_cg = te.MATRICULA and ro.estado not in ('I') --and ro.carrera = cl.CARRERA
            left join mig.record_oferta ro1 on ro1.id_carrera_ofertada = isnull(te.ID_CARRERA_OFERTADA,te.ID_CARRERA_LOCAL) and ro1.id_tipo_oferta = 2
            and ro1.identificacion= p.identificacion and ro.estado not in ('I') --and ro1.carrera = cl.CARRERA
            left join mig.record_matricula rm on rm.id_number = te.ID_MATRICULA and rm.table_name='Bd_Academico.dbo.TE_MATRICULAS'
            WHERE (te.ESTADO IN ('A','N','R','C')) and p.estado='A' and te.CG_PER_ACADEMICO <28470 and cl.CARRERA<>'CENTRO DE IDIOMAS'
            and te.id_nivel in (select id_nivel from Bd_Academico.dbo.niveles where interfaz=3) and p.ID_PERSONA not in(5995)
            and rm.id_record_matricula is null and te.MATRICULA is not null



--             insert into mig.temp_record_oferta
            select id_record_oferta_padre, id_periodo_academico, id_periodo_academico_cg,
                   id_tipo_jornada_laboral, id_tipo_estudiante, id_tipo_ingreso_estudiante, id_tipo_estado_estudiante,
                   id_persona_cg, id_carrera_ofertada, id_area, id_tipo_oferta, id_oferta_modalidad, id_estudiante_oferta,
                   id_modalidad_cg, modalidad, periodo, sistema_estudio, facultad, carrera, escuela, area, numero_matricula,
                   numero_matricula_cg, mantiene_gratuidad, promedio, identificacion, nombres, apellidos, fecha_registro,
                   id_number, table_name,
                   ROW_NUMBER() OVER (PARTITION BY id_record_oferta_padre, id_periodo_academico, id_periodo_academico_cg,
                       id_tipo_jornada_laboral, id_tipo_estudiante, id_tipo_ingreso_estudiante, id_tipo_estado_estudiante,
                       id_persona_cg, id_carrera_ofertada, id_area, id_tipo_oferta, id_oferta_modalidad, id_estudiante_oferta,
                       id_modalidad_cg, modalidad, periodo, sistema_estudio, facultad, carrera, escuela, area, numero_matricula,
                       numero_matricula_cg, mantiene_gratuidad, promedio, identificacion, nombres, apellidos, fecha_registro,
                       id_number, table_name ORDER BY estado) as valido from mig.record_oferta
            where --id_record_oferta in (52649,58159 )
                  id_tipo_oferta = 2
            order by apellidos,nombres,carrera,estado

            select* from mig.record_oferta ro
            where ro.id_tipo_oferta = 2 and ro.id_number in (138348,171343,150525,161880,
            161605,139746,144355,155643,166825,134572,154483,155968,157954,169285,130174,149732,167545,145052,142879,155071,
            157815,158176,61576,151312,168772,29946,35763,124589)

            select * from Bd_Academico..MATERIAS_TOMADAS mt where mt.ID_MATERIA_TOMADA in (8726,8727,
            8728,8729,8730,44976,44977,44978,44979,44980,44981,44982,231659,231660,231661,231662,231663,231665,
            231687,231688,231689,231690,231691,231693,231664,231692,8731)

            --matriculas no migradas
            select *from Bd_Academico..TE_MATRICULAS mt where mt.ID_MATRICULA in (29946,35763)

            select * from mig.record_oferta ro where ro.numero_matricula_cg in ('12007120405')

            select * from mig.record_oferta ro where ro.id_number in (29946,35763)

            select * from Bd_Academico..TE_MATRICULAS mt where mt.ID_MATRICULA in (29946,35763,61628,61636)

            select * from Bd_Academico..PERSONAS where ID_PERSONA in (8063,21225,21240)

            select * from mig.record_oferta ro where ro.identificacion in ('0925080897')

            select * from mig.record_oferta ro where ro.estado='I'

            select * from  Bd_Academico..vw_MATRICULAS where MATRICULA='12007120405'

            select * from  Bd_Academico..te_MATRICULAS where MATRICULA='12007120405'

            select * from mig.temp_record_oferta where identificacion='0925080897'

            select * from Bd_Academico..PERSONAS where ID_PERSONA in (2326)

            --insert asignaturas de grado siswesito
            --946.399 asignaturas
                --803997 sin repetidos
--             insert into mig.record_asignaturas
            select distinct d.id_record_oferta, d.id_record_matricula, d.id_periodo_academico, d.id_periodo_academico_cg, d.id_malla_asignatura, d.id_materia_plan,
                   d.id_malla, d.ID_PLAN,
                   iif(d.id_paralelo in ('A','B','D','C','EX','MULTICARRERA'),1,iif(d.id_paralelo in ('10'),10,convert(int,substring(d.id_paralelo,1,1)))) as id_paralelo
                   , d.id_nivel, d.id_nivel_cg, d.nivel, d.tipo_malla, d.asignatura, d.vez, d.creditos, d.horas, d.promedio, d.asistencia,
                   d.estado_tomada, d.valor, d.tipo, d.aprobado, d.estado_aprobacion, d.periodo, d.identificacion_docente, d.docente,d.orden, d.fecha_registro,
                   d.id_number,d.table_name,null as id_number_old,null as table_name_old, d.estado, d.version, d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod from (
            SELECT  rm.id_record_oferta,rm.id_record_matricula,pa.id_periodo_academico,pad.CG_PER_ACADEMICO as id_periodo_academico_cg,
            maa.id_malla_asignatura,mt.ID_MATERIA_PLAN as id_materia_plan,mal.id_malla,mt.ID_PLAN,
                 isnull(replace(iif(LEN(aula.CG_PARALELO)>=3,RIGHT(aula.PARALELO, LEN(aula.PARALELO) - CHARINDEX('/', aula.PARALELO)),aula.PARALELO),'.', ''),'1') as id_paralelo,
            niv.id_nivel as id_nivel,mt.id_nivel as id_nivel_cg,Isnull(n.DESCRIPCION,'NO DEFINIDO') AS nivel,isnull(tm.VALOR_TEXTO,'NO CLASIFICADO') as tipo_malla,
            isnull(m.NOMBRE,'S/N') as asignatura,
            iif(tr.VALOR_TEXTO='GUAYAQUIL'  or tr.VALOR_TEXTO is null,'1 VEZ',tr.VALOR_TEXTO) as vez,isnull(mt.CREDITOS,0) as creditos,isnull(mt.TOTAL_HORAS,0) as horas,
            isnull(mt.PROMEDIO,0) as promedio,iif(round((mt.ASISTENCIA*100),2,0)>100,100,round((mt.ASISTENCIA*100),2,0)) as asistencia,
            isnull((SELECT valor_texto FROM Bd_Personal..TP_CODIGOS WHERE correlativo = mt.cg_estado_materia AND estado = 'A'),'S/N') as estado_tomada,
            isnull(mt.VALOR,0) as valor,(SELECT isnull(TP_CODIGOS.VALOR_TEXTO,'NO DEFINIDO') from Bd_Personal..TP_CODIGOS WHERE correlativo = mt.cg_tipo_matricula AND estado = 'A') as tipo,
            mt.APROBADO as aprobado, (CASE mt.APROBADO WHEN 1 THEN 'APROBADO' WHEN 0 THEN 'REPROBADO' ELSE 'REPROBADO' END) as estado_aprobacion,
            cp.VALOR_TEXTO as periodo, isnull(doc.IDENTIFICACION,'NO REGISTRA') as identificacion_docente,isnull(doc.nombre_completo,'NO REGISTRA') as docente,
                    ROW_NUMBER() OVER (PARTITION BY rm.id_record_matricula ORDER BY isnull(m.NOMBRE,'S/N')) as orden,
            isnull(mt.FECHA_MATRICULA,isnull(mt.FECHA_INGRESO,getdate()))as fecha_registro,mt.ID_MATERIA_TOMADA as id_number,'Bd_Academico..MATERIAS_TOMADAS' as table_name,mt.ESTADO as estado,
            0 as version,getdate() as fecha_ing,getdate() as fecha_mod, '2400254286' as usuario_ing, '2400254286' as usuario_mod
            FROM   Bd_Academico..TE_MATRICULAS as te
            INNER JOIN Bd_Academico..PERSONAS p ON te.ID_PERSONA = p.ID_PERSONA
            INNER JOIN Bd_Academico..MATERIAS_TOMADAS mt on te.ID_MATRICULA = mt.ID_MATRICULA
            inner join Bd_Academico.dbo.vw_te_carreras_localidad cl on cl.id_carrera_local= te.id_carrera_local
            left join Bd_Academico..MATERIAS_PLAN mp on mp.ID_MATERIA_PLAN=mt.ID_MATERIA_PLAN AND mp.ESTADO = 'A'
            left join bd_academico..NIVELES n on n.id_nivel = mt.id_nivel  AND n.ESTADO = 'A'
            LEFT JOIN Bd_Academico..VW_ASIG_AULAS  as aula ON mt.ID_REGISTRO_AULA = aula.ID_REGISTRO
            left join Bd_Academico..MATERIAS m on m.id_materia = mt.id_materia_unico  AND m.estado = 'A'
            LEFT JOIN Bd_Academico..TP_CODIGOS AS tr ON mt.CG_TIPO_REGISTRO = tr.CORRELATIVO
            LEFT JOIN Bd_Academico..PERIODOS_ACADEMICOS pad ON pad.id_detalle = mt.id_detalle_periodo
            left join Bd_Personal..TP_CODIGOS cp on cp.CORRELATIVO= pad.CG_PER_ACADEMICO
            LEFT JOIN Bd_Academico..PLAN_ESTUDIOS  pe ON mp.ID_PLAN = pe.ID_PLAN
            left join Bd_Personal..TP_CODIGOS tm on tm.CORRELATIVO= pe.CG_TIPO_PLAN
            left join aca.periodo_academico pa on pa.codigo = cp.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 2
            LEFT JOIN ( select d.* from mig.fn_get_docentes_from_distributivo (null,null,
                                                                           null,null,null) as d ) doc ON doc.ID_MATERIA_PLAN = mp.ID_MATERIA_PLAN
            AND doc.CG_PER_ACADEMICO = pad.CG_PER_ACADEMICO and doc.id_registro_aula = mt.ID_REGISTRO_AULA
            AND doc.ID_AREA = te.ID_CARRERA_OFERTADA and doc.id_nivel= mt.ID_NIVEL AND doc.fila_numero = 1
            left join
               (select ma.id_malla_asignatura,rma.id_origen,rma.id_destino from migracion_sga..registros_migracion rma
                inner join aca.malla_asignatura ma on ma.id_malla_asignatura = rma.id_destino
                where rma.id_entidad_relacion in (5,29) and ma.estado='A' ) as maa on maa.id_origen = mt.ID_MATERIA_PLAN
            left join
                (select m.id_malla,m.tipo_plan,rm.id_origen,rm.id_destino from migracion_sga..registros_migracion rm
                inner join aca.malla m on m.id_malla = rm.id_destino
                where rm.id_entidad_relacion in (4) and m.estado in ('A','P')  ) as mal on mal.id_origen = mp.ID_PLAN
            left join
               (select n.id_nivel,rn.id_origen,rn.id_destino,n.descripcion as nivel from migracion_sga..registros_migracion rn
                left join aca.nivel n on n.id_nivel = rn.id_destino and n.estado in ('A')
                where rn.id_entidad_relacion in (6) ) as niv on niv.id_origen = mt.ID_NIVEL
            inner join mig.record_matricula rm on rm.id_number = te.ID_MATRICULA and rm.table_name='Bd_Academico.dbo.TE_MATRICULAS'
            left join mig.record_asignaturas ra on ra.id_number = mt.ID_MATERIA_TOMADA and ra.table_name ='Bd_Academico..MATERIAS_TOMADAS'
            WHERE (te.ESTADO IN ('A','N','R','C')) and p.estado='A' and (mt.ESTADO IN ('A','N','R','C')) and te.CG_PER_ACADEMICO <28470 and cl.CARRERA<>'CENTRO DE IDIOMAS'
            and te.id_nivel in (select id_nivel from Bd_Academico.dbo.niveles where interfaz=3)
            and ra.id_record_asignatura is null ) as d
            order by d.id_number

            select * from Bd_Academico..VW_PLAN_ESTUDIOS where ID_PLAN = 10528
            select * from Bd_Academico..VW_MATERIAS_PLAN where ID_PLAN = 10528


---eliminar estudiantes_ofertas_repetidos

select ro.* from mig.record_oferta ro
where ro.id_tipo_oferta = 2 and ro.id_record_oferta in ( 55088,55089)


select * from mig.record_asignaturas where table_name='Bd_Academico..MATERIAS_TOMADAS'

select * from mig.record_matricula where id_record_oferta = 55089

select ro.id_record_oferta,ro.id_estudiante_oferta,ro.identificacion,ro.apellidos,ro.nombres,ro.carrera,ro.numero_matricula,ro.numero_matricula_cg,
       ro.id_number,ro.estado,count(rm.id_number) as contador_matriculas,
       MIN(CASE WHEN rm.estado = 'A' THEN rm.id_number END) AS id_min_estado_A,
       MIN(CASE WHEN rm.estado = 'N' THEN rm.id_number END) AS id_min_estado_N
from mig.record_oferta ro
         left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta

where ro.identificacion  in (
    select d.identificacion from (
                                     select ro.identificacion,count(ro.id_estudiante_oferta) as repetidos from mig.record_oferta ro
                                     where ro.id_tipo_oferta = 2 and ro.estado not in ('I')
                                       and ro.id_estudiante_oferta is not null
                                     group by ro.identificacion
                                     having count(ro.id_estudiante_oferta)>1) as d
)
  and ro.id_tipo_oferta = 2 and ro.estado not in ('I') and ro.id_estudiante_oferta is not null
group by ro.id_estudiante_oferta, ro.identificacion, ro.apellidos, ro.nombres, ro.carrera, ro.numero_matricula,
         ro.numero_matricula_cg, ro.estado, ro.id_number, ro.id_record_oferta

select * from mig.record_matricula rm where rm.id_record_oferta in (39739)

--ofertas sga
select eo.id_estudiante_oferta,p.identificacion,p.apellidos,p.nombres,om.id_modalidad,o.descripcion,eo.numero_matricula
from aca.estudiante_oferta eo
     inner join man.personas p on eo.id_persona = p.id
     inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
     inner join aca.oferta o on om.id_oferta = o.id_oferta
     inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
where  p.identificacion in ('0928419902')

select ro.* from mig.record_oferta ro
inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
where ro.identificacion='0928419902' and ro.table_name ='bd_academico..te_matriculas.ID_CARRERA_OFERTADA'

select rm.* from mig.record_oferta ro
inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
where ro.id_tipo_oferta = 2 and ro.estado not in ('I')

--     update rm set rm.id_record_oferta = rp.id_record_oferta
    select rp.id_record_oferta as id_record_oferta_activa,rm.*
    from (
            select ro.id_record_oferta,ro.id_estudiante_oferta,ro.identificacion,ro.apellidos,ro.nombres,ro.carrera,ro.numero_matricula,ro.numero_matricula_cg,
               ro.id_number,ro.estado,count(rm.id_number) as contador_matriculas,
               MIN(CASE WHEN rm.estado = 'A' THEN rm.id_number END) AS id_min_estado_A,
               MIN(CASE WHEN rm.estado = 'N' THEN rm.id_number END) AS id_min_estado_N
        from mig.record_oferta ro
                 left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta

        where ro.identificacion  in (
            select d.identificacion from (
                                             select ro.identificacion,count(ro.id_estudiante_oferta) as repetidos from mig.record_oferta ro
                                             where ro.id_tipo_oferta = 2 and ro.estado not in ('I')
                                               and ro.id_estudiante_oferta is not null
                                             group by ro.identificacion
                                             having count(ro.id_estudiante_oferta)>1) as d
        )
          and ro.id_tipo_oferta = 2 and ro.estado not in ('I') and ro.id_estudiante_oferta is not null
        group by ro.id_estudiante_oferta, ro.identificacion, ro.apellidos, ro.nombres, ro.carrera, ro.numero_matricula,
                 ro.numero_matricula_cg, ro.estado, ro.id_number, ro.id_record_oferta
    ) as dd
    inner join mig.record_matricula rm on rm.id_record_oferta = dd.id_record_oferta
    inner join mig.record_oferta ro on rm.id_record_oferta = ro.id_record_oferta
    inner join mig.record_oferta rp on rp.id_number= ro.id_number and rp.id_tipo_oferta = 2 and rp.estado='A'
where dd.estado='N'

---eliminar las cabeceras anuladas vacias
select ro.*
from (
         select ro.id_record_oferta,ro.id_estudiante_oferta,ro.identificacion,ro.apellidos,ro.nombres,ro.carrera,ro.numero_matricula,ro.numero_matricula_cg,
                ro.id_number,ro.estado,count(rm.id_number) as contador_matriculas,
                MIN(CASE WHEN rm.estado = 'A' THEN rm.id_number END) AS id_min_estado_A,
                MIN(CASE WHEN rm.estado = 'N' THEN rm.id_number END) AS id_min_estado_N
         from mig.record_oferta ro
                  left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta

         where ro.identificacion  in (
             select d.identificacion from (
                                              select ro.identificacion,count(ro.id_estudiante_oferta) as repetidos from mig.record_oferta ro
                                              where ro.id_tipo_oferta = 2 and ro.estado not in ('I')
                                                and ro.id_estudiante_oferta is not null
                                              group by ro.identificacion
                                              having count(ro.id_estudiante_oferta)>1) as d
         )
            and ro.estado not in ('I') and ro.id_estudiante_oferta is not null and ro.id_tipo_oferta = 2
         group by ro.id_estudiante_oferta, ro.identificacion, ro.apellidos, ro.nombres, ro.carrera, ro.numero_matricula,
                  ro.numero_matricula_cg, ro.estado, ro.id_number, ro.id_record_oferta
     ) as dd
         inner join mig.record_oferta ro on dd.id_record_oferta = ro.id_record_oferta
where dd.estado='N' and dd.contador_matriculas > 0

select * from mig.record_matricula where id_record_oferta = 40811

select * from mig.record_oferta where id_record_oferta = 40811

select te.* from Bd_Academico..TE_MATRICULAS te
where te.ESTADO in ('A','R','N') and te.CG_PER_ACADEMICO <28470 and te.ID_MATRICULA not in (
    select rm.id_number from mig.record_matricula rm
             inner join mig.record_oferta ro on rm.id_record_oferta = ro.id_record_oferta
             where ro.id_tipo_oferta = 2
    )

--setear el nuevo_id_number en las cabeceras de las ofertas
--     update ro set ro.id_number = dd.id_min_estado_A
select dd.*
from (
         select ro.id_record_oferta,ro.id_estudiante_oferta,ro.identificacion,ro.apellidos,ro.nombres,ro.carrera,ro.numero_matricula,ro.numero_matricula_cg,
                ro.id_number,ro.estado,count(rm.id_number) as contador_matriculas,
                MIN(CASE WHEN rm.estado = 'A' THEN rm.id_number END) AS id_min_estado_A,
                MIN(CASE WHEN rm.estado = 'N' THEN rm.id_number END) AS id_min_estado_N
        from mig.record_oferta ro
        left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
        and ro.id_tipo_oferta = 2 and ro.estado not in ('I') and ro.id_estudiante_oferta is not null
        group by ro.id_estudiante_oferta, ro.identificacion, ro.apellidos, ro.nombres, ro.carrera, ro.numero_matricula,
        ro.numero_matricula_cg, ro.estado, ro.id_number, ro.id_record_oferta
     ) as dd
 inner join mig.record_oferta ro on dd.id_record_oferta = ro.id_record_oferta
where dd.estado='N'
and dd.id_number <> dd.id_min_estado_N
---actualizar las cabeceras de la matricula con el periodo
-- update ro set ro.id_periodo_academico = pa.id_periodo_academico,ro.periodo=pa.codigo
select dd.*
from (
         select ro.id_record_oferta,ro.id_estudiante_oferta,ro.identificacion,ro.apellidos,ro.nombres,ro.carrera,ro.numero_matricula,ro.numero_matricula_cg,
                ro.id_number,ro.estado,count(rm.id_number) as contador_matriculas,
--                 MIN(CASE WHEN rm.estado = 'A' THEN rm.id_periodo_academico END) AS id_min_periodo_academico_estado_A,
--                 MIN(CASE WHEN rm.estado = 'N' THEN rm.id_periodo_academico END) AS id_min_periodo_academico_estado_N,
--             MIN(CASE WHEN rm.estado = 'A' THEN rm.id_periodo_academico_cg END) AS id_min_id_periodo_academico_cg_estado_A,
--             MIN(CASE WHEN rm.estado = 'N' THEN rm.id_periodo_academico_cg END) AS id_min_id_periodo_academico_cg_estado_N,
--             MIN(CASE WHEN rm.estado = 'C' THEN rm.id_periodo_academico_cg END) AS id_min_id_periodo_academico_cg_estado_C,
--             MIN(CASE WHEN rm.estado = 'R' THEN rm.id_periodo_academico_cg END) AS id_min_id_periodo_academico_cg_estado_R,
            case ro.estado
                    when 'A' then MIN(CASE WHEN rm.estado = 'A' THEN rm.id_periodo_academico_cg END)
                    when 'N' then MIN(CASE WHEN rm.estado = 'N' THEN rm.id_periodo_academico_cg END)
                    when 'C' then MIN(CASE WHEN rm.estado = 'C' THEN rm.id_periodo_academico_cg END)
                    when 'R' then MIN(CASE WHEN rm.estado = 'R' THEN rm.id_periodo_academico_cg END)
                    else null end as id_ultimo_periodo_cg,
            case ro.estado
                when 'A' then MIN(CASE WHEN rm.estado = 'A' THEN rm.id_periodo_academico END)
                when 'N' then MIN(CASE WHEN rm.estado = 'N' THEN rm.id_periodo_academico END)
                when 'C' then MIN(CASE WHEN rm.estado = 'C' THEN rm.id_periodo_academico END)
                when 'R' then MIN(CASE WHEN rm.estado = 'R' THEN rm.id_periodo_academico END)
                else null end as id_ultimo_periodo
         from mig.record_oferta ro
            inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta and rm.table_name='Bd_Academico.dbo.TE_MATRICULAS'
         and ro.id_tipo_oferta = 2 and ro.estado not in ('I')
         group by ro.id_estudiante_oferta, ro.identificacion, ro.apellidos, ro.nombres, ro.carrera, ro.numero_matricula,
                  ro.numero_matricula_cg, ro.estado, ro.id_number, ro.id_record_oferta
     ) as dd
     inner join mig.record_oferta ro on dd.id_record_oferta = ro.id_record_oferta
    inner join aca.periodo_academico pa on pa.id_periodo_academico = dd.id_ultimo_periodo
where --dd.estado='R'   and
 ro.id_tipo_oferta = 2 and ro.estado not in ('I')
--   and dd.id_number <> dd.id_min_estado_N

--32707
---actualizar las cabeceras de la matricula con el periodo
-- update ro set ro.id_record_oferta_padre = dd.id_record_oferta_niv
select dd.*
from (
         select ro.id_record_oferta,ro.id_record_oferta_padre,
                rop.id_record_oferta as id_record_oferta_niv,
                ro.id_estudiante_oferta as id_estudiante_oferta_grado,ro.identificacion,ro.apellidos,ro.nombres,ro.carrera as carrera_grado,
                rop.identificacion as identificacion_niv,rop.apellidos as apellidos_niv,rop.nombres as nombres_niv,rop.carrera as carrera_niv,
                ro.numero_matricula,ro.numero_matricula_cg,
                ro.id_number,ro.estado,count(rm.id_number) as contador_matriculas_grado,
                case ro.estado
                    when 'A' then MIN(CASE WHEN rm.estado = 'A' THEN rm.id_periodo_academico_cg END)
                    when 'N' then MIN(CASE WHEN rm.estado = 'N' THEN rm.id_periodo_academico_cg END)
                    when 'C' then MIN(CASE WHEN rm.estado = 'C' THEN rm.id_periodo_academico_cg END)
                    when 'R' then MIN(CASE WHEN rm.estado = 'R' THEN rm.id_periodo_academico_cg END)
                    else null end as id_ultimo_periodo_cg,
                case ro.estado
                    when 'A' then MIN(CASE WHEN rm.estado = 'A' THEN rm.id_periodo_academico END)
                    when 'N' then MIN(CASE WHEN rm.estado = 'N' THEN rm.id_periodo_academico END)
                    when 'C' then MIN(CASE WHEN rm.estado = 'C' THEN rm.id_periodo_academico END)
                    when 'R' then MIN(CASE WHEN rm.estado = 'R' THEN rm.id_periodo_academico END)
                    else null end as id_ultimo_periodo
         from mig.record_oferta ro
            inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta and rm.table_name='Bd_Academico.dbo.TE_MATRICULAS'
            inner join Bd_Academico..TE_MATRICULAS mat on mat.ID_MATRICULA = rm.id_number  and mat.ORIGEN='TE_INSCRIPCIONES' and mat.ID_NIVEL in (1,13)
            inner join mig.record_matricula rmn on rmn.id_number = mat.ID_ORIGEN and rmn.table_name ='Bd_Academico.dbo.TE_INSCRIPCIONES'
            inner join mig.record_oferta rop on rop.id_record_oferta = rmn.id_record_oferta and rop.id_tipo_oferta = 1
                                            and rop.estado not in ('I') and rop.id_persona_cg = mat.ID_PERSONA --and rop.id_carrera_ofertada = ro.id_carrera_ofertada
            where ro.id_tipo_oferta = 2 and ro.estado not in ('I')
--             and ro.identificacion <>rop.identificacion
--               and rop.carrera not like  concat('%',ro.carrera,' %')
         group by ro.id_estudiante_oferta, ro.identificacion, ro.apellidos, ro.nombres, ro.carrera, ro.numero_matricula,
                  ro.numero_matricula_cg, ro.estado, ro.id_number, ro.id_record_oferta, ro.id_record_oferta_padre
                 ,rop.id_record_oferta,rop.carrera,rop.identificacion,rop.apellidos,rop.nombres
     ) as dd
         inner join mig.record_oferta ro on dd.id_record_oferta = ro.id_record_oferta --and ro.id_record_oferta_padre is null
where --dd.estado='R'   and
    ro.id_tipo_oferta = 2 and ro.estado not in ('I') and ro.identificacion='0921580379'


--     TE_INSCRIPCIONES
select ID_NIVEL,ID_ORIGEN,ORIGEN from Bd_Academico..TE_MATRICULAS
                                 where ID_NIVEL in (1,13)
select * from Bd_Academico.dbo.niveles where interfaz=3



select distinct table_name from mig.record_oferta ro where id_record_oferta = 2
select distinct table_name from mig.record_matricula rm
select distinct table_name from mig.record_asignaturas ra

--actualizar informacion en el SGA
select eo.* from (
select --eo.*
    eo.id_estudiante_oferta,p.identificacion,p.apellidos,p.nombres,om.id_modalidad,o.descripcion,eo.numero_matricula,eo.id_periodo_academico,
    eo.fecha_ingreso,tee.descripcion as tipo,tee.observacion--,mg.id_periodo_academico as matricula
    ,(select min(em1.id_estudiante_matricula) from aca.estudiante_matricula em1
        where em1.estado='A' and em1.id_estudiante_oferta=eo.id_estudiante_oferta) as minnima_matricula
from aca.estudiante_oferta eo
         inner join man.personas p on eo.id_persona = p.id
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
        inner join (select ap.identificacion,ap.id_oferta_modalidad_nivelacion from aca.aspirantes_pregrado ap where ap.id_periodo_academico = 23)
as aux on aux.identificacion = p.identificacion and aux.id_oferta_modalidad_nivelacion = om.id_oferta_modalidad
--          left join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
--          left join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
where   o.id_tipo_oferta = 1 and eo.id_periodo_academico is null
) as d
inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = d.id_estudiante_oferta

--actualizar desde el sisweb cupos antes del 2022-1

--     update eo set eo.id_periodo_academico = pa.id_periodo_academico
    select pa.id_periodo_academico,d.*
    from (
    select --eo.*
        eo.id_estudiante_oferta,p.identificacion,p.apellidos,p.nombres,om.id_modalidad,o.descripcion,eo.numero_matricula,eo.id_periodo_academico,aux.PERIODO,
        eo.fecha_ingreso,tee.descripcion as tipo,tee.observacion--,mg.id_periodo_academico as matricula
        ,(select min(em1.id_estudiante_matricula) from aca.estudiante_matricula em1
            where em1.estado='A' and em1.id_estudiante_oferta=eo.id_estudiante_oferta) as minnima_matricula,
          (select min(ea1.codigo_estado_matricula) from aca.estudiante_matricula em1
                            inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
            where em1.estado='A'and ea1.estado='A' and em1.id_estudiante_oferta=eo.id_estudiante_oferta) as vez
    from aca.estudiante_oferta eo
             inner join man.personas p on eo.id_persona = p.id
             inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
             inner join aca.oferta o on om.id_oferta = o.id_oferta
             inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
            inner join (select ap.CEDULA,ap.id_oferta_modalidad,ap.PERIODO from dbo.segunda_matricula_nivelacion_2022 ap )
    as aux on aux.CEDULA = p.identificacion and aux.id_oferta_modalidad = om.id_oferta_modalidad
    --          left join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
    --          left join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
    where   o.id_tipo_oferta = 1
      --and eo.id_periodo_academico is null
    ) as d
    inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = d.id_estudiante_oferta
    inner join aca.periodo_academico pa on pa.codigo = d.PERIODO and pa.id_tipo_oferta = 1

select * from aca.tipo_estado_estudiante

--actualizar desde el sisweb cupos antes del 2022-1

--     update eo set eo.id_periodo_academico = pa.id_periodo_academico
--         update eo set eo.id_tipo_estado_estudiante = 12
    select d.*
    from (
    select --eo.*
        eo.id_estudiante_oferta,p.identificacion,p.apellidos,p.nombres,om.id_modalidad,o.descripcion,eo.numero_matricula,eo.id_periodo_academico,--aux.PERIODO,
        eo.fecha_ingreso,tee.descripcion as tipo,tee.observacion--,mg.id_periodo_academico as matricula
        ,(select min(em1.id_estudiante_matricula) from aca.estudiante_matricula em1
            where em1.estado='A' and em1.id_estudiante_oferta=eo.id_estudiante_oferta) as minima_matricula,
          (select min(ea1.codigo_estado_matricula) from aca.estudiante_matricula em1
                            inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
            where em1.estado='A'and ea1.estado='A' and em1.id_estudiante_oferta=eo.id_estudiante_oferta) as vez,
         (select count(ea1.id_estudiante_asignatura) from aca.estudiante_matricula em1
                            inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
            where em1.estado='A'and ea1.estado='A' and em1.id_estudiante_oferta=eo.id_estudiante_oferta) as todas,
    (select count(ea1.id_estudiante_asignatura) from aca.estudiante_matricula em1
                            inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
            where em1.estado='A'and ea1.estado='A' and ea1.aprobado= 1 and em1.id_estudiante_oferta=eo.id_estudiante_oferta) as aprobadas
    from aca.estudiante_oferta eo
             inner join man.personas p on eo.id_persona = p.id
             inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
             inner join aca.oferta o on om.id_oferta = o.id_oferta
             inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
--             inner join (select ap.CEDULA,ap.id_oferta_modalidad,ap.PERIODO from dbo.segunda_matricula_nivelacion_2022 ap where ap.id_periodo_academico = 15)
--     as aux on aux.CEDULA = p.identificacion and aux.id_oferta_modalidad = om.id_oferta_modalidad
    where   o.id_tipo_oferta = 1  and eo.id_periodo_academico is null --and eo.id_periodo_academico in (120,121,122,123)
    ) as d
    inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = d.id_estudiante_oferta
--     inner join aca.periodo_academico pa on pa.codigo = d.PERIODO and pa.id_tipo_oferta = 1

select * from aca.aspirantes_pregrado where id_periodo_academico = 23




select distinct ro.id_tipo_oferta,ro.id_carrera_ofertada,ro.carrera from mig.record_oferta ro where ro.id_tipo_oferta = 2
and ro.carrera not in (select o.descripcion from aca.oferta o
         inner join aca.oferta_modalidad om on o.id_oferta = om.id_oferta
         where o.id_tipo_oferta=2 and om.estado='A')

select * from mig.record_oferta ro where ro.identificacion ='2400402042'

-- DBCC CHECKIDENT ('mig.oferta_correspondencia', RESEED, 103)

select * from mig.oferta_correspondencia
-- update mig.oferta_correspondencia set oferta_relacion = concat('NIVELACION DE ',oferta_relacion)
where tipo='OFERTAS_GRADO_SISWEB' --and oferta_relacion not like 'NIVELACION DE %'

select * from [rel].[fn_relaciones_ofertas_nivelacion_grado](38) as d

select * from mig.oferta_conexion

    --actualizar carreras de cabeceras de ofertas de nievlacion
select distinct ro.id_tipo_oferta,ro.carrera,oc.oferta_relacion
-- update ro set ro.carrera = oc.oferta_relacion
from mig.record_oferta ro
inner join mig.oferta_correspondencia oc on oc.oferta_original = ro.carrera_original and oc.tipo='OFERTAS_NIVELACION_SISWEB'
where ro.id_tipo_oferta = 1

    --setear oefrta modalidad
select distinct ro.id_tipo_oferta,om.id_oferta_modalidad,ro.id_oferta_modalidad,ro.carrera,ro.identificacion
-- update ro set ro.id_oferta_modalidad = om.id_oferta_modalidad
from mig.record_oferta ro
inner join aca.oferta o on o.descripcion = ro.carrera
inner join aca.oferta_modalidad om on o.id_oferta = om.id_oferta
where ro.id_tipo_oferta = 1 and o.id_tipo_oferta = 1

    --setear  estudiante Oferta si lo hubiese
select distinct ro.id_tipo_oferta,om.id_oferta_modalidad,ro.id_oferta_modalidad,ro.carrera,ro.identificacion,eo.id_estudiante_oferta,ro.id_estudiante_oferta
-- update ro set ro.id_estudiante_oferta = eo.id_estudiante_oferta,ro.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
from mig.record_oferta ro
inner join man.personas p on p.identificacion = ro.identificacion
inner join aca.estudiante_oferta eo on eo.id_oferta_modalidad = ro.id_oferta_modalidad and eo.id_persona = p.id
    and eo.id_periodo_academico = ro.id_periodo_academico
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = ro.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta

where ro.id_tipo_oferta = 1 and o.id_tipo_oferta = 1

select distinct ro.id_oferta_modalidad,ro.carrera,ro.id_carrera_ofertada from mig.record_oferta ro
where ro.id_tipo_oferta = 2

select distinct ro.id_periodo_academico,ro.id_periodo_academico_cg from mig.record_oferta ro
where ro.id_tipo_oferta = 2


select ro.*
-- update ro set ro.carrera = oc.oferta_relacion
from mig.record_oferta ro
where ro.id_tipo_oferta = 1

select om.id_modalidad,o.descripcion from aca.oferta o
         inner join aca.oferta_modalidad om on o.id_oferta = om.id_oferta
         where o.id_tipo_oferta=2 and om.estado='A'

select distinct ro.id_tipo_oferta,ro.carrera_original from mig.record_oferta ro
where id_tipo_oferta is not null

-- and em.estado='A'
--   and em.id_estudiante_matricula in (select min(em1.id_estudiante_matricula) from aca.estudiante_matricula em1
-- where em1.estado='A' and em1.id_estudiante_oferta=eo.id_estudiante_oferta)

select * from aca.estudiante_oferta where id_estudiante_oferta in (14342,14442)


--cruce con matriz desconocida

--     update eo set eo.id_periodo_academico = pa.id_periodo_academico
    select d.*
    from (
    select --eo.*
        eo.id_estudiante_oferta,eo.id_periodo_academico,p.identificacion,p.apellidos,p.nombres,om.id_modalidad,o.descripcion,eo.numero_matricula,
        aux.id_periodo_academico as id_periodo_academico_mat,
        eo.fecha_ingreso,tee.descripcion as tipo,tee.observacion--,mg.id_periodo_academico as matricula
        ,(select min(em1.id_estudiante_matricula) from aca.estudiante_matricula em1
            where em1.estado='A' and em1.id_estudiante_oferta=eo.id_estudiante_oferta) as minnima_matricula,
          (select min(ea1.codigo_estado_matricula) from aca.estudiante_matricula em1
                            inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
            where em1.estado='A'and ea1.estado='A' and em1.id_estudiante_oferta=eo.id_estudiante_oferta) as vez
    from aca.estudiante_oferta eo
             inner join man.personas p on eo.id_persona = p.id
             inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
             inner join aca.oferta o on om.id_oferta = o.id_oferta
             inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
            inner join (select ap.identificacion,ap.id_oferta_modalidad,ap.id_periodo_academico from dbo.aspirantes_segunda_matricula ap )
    as aux on aux.identificacion = p.identificacion and aux.id_oferta_modalidad = om.id_oferta_modalidad
    --          left join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
    --          left join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
    where   o.id_tipo_oferta = 1 --and eo.id_periodo_academico is null
        and eo.id_periodo_academico in (15,24)
    ) as d
    inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = d.id_estudiante_oferta




--and eo.id_periodo_academico is null

select * from aca.aspirantes_pregrado where id_periodo_academico = 23

select * from dbo.aspirantes_segunda_matricula

-- update ap set ap.id_oferta_modalidad = d.idOfertaModalidadNivelacion
select d.ofertaNivelacion,
       ap.carrera,ap.id_oferta_modalidad,ap.CEDULA
from dbo.segunda_matricula_nivelacion_2022 ap
left join [rel].[fn_relaciones_ofertas_nivelacion_grado](24) as d on  d.ofertaGrado like concat(ap.carrera,'%')
where ap.id_oferta_modalidad is null

--recuperar nombres correctos de las carreras
select ro.id_record_oferta,ro.identificacion,ro.carrera,ro.carrera_original,clms.NOMBRE as carrera_completa
-- update ro set ro.carrera_original = clms.NOMBRE,ro.carrera = clms.NOMBRE
from  mig.record_oferta ro
inner join Bd_Academico..CARRERAS_LOCALES_MODALIDAD_SISTEMA clms on clms.ID_CARRERA_OFERTADA = ro.id_carrera_ofertada
where ro.id_tipo_oferta = 2 --and ro.estado not in ('I')
  and ro.table_name='bd_academico..te_matriculas.ID_CARRERA_OFERTADA'

select ro.id_record_oferta,ro.identificacion,ro.carrera,ro.carrera_original,clms.NOMBRE as carrera_completa
-- update ro set ro.carrera_original = clms.NOMBRE,ro.carrera = clms.NOMBRE
from  mig.record_oferta ro
inner join Bd_Academico..CARRERAS_LOCALES_MODALIDAD_SISTEMA clms on clms.ID_CARRERA_LOCAL = ro.id_carrera_ofertada
where ro.id_tipo_oferta = 2 --and ro.estado not in ('I')
  and ro.table_name='bd_academico..te_matriculas.id_carrera_local'

select  distinct table_name from mig.record_oferta where id_tipo_oferta = 1

select * from tmp.aspirantes_pregrado_aux

--1824
-- update ap set ap.CEDULA = substring(ap.CEDULA,2,10)
select --d.ofertaGrado,
       ap.*
from dbo.segunda_matricula_nivelacion_2022 ap
where id_periodo_academico = 15
-- left join [rel].[fn_relaciones_ofertas_nivelacion_grado](24) as d on  d.ofertaGrado like concat(ap.carrera,'%')
-- where ap.id_oferta_modalidad is null

-- select * from [rel].[fn_relaciones_ofertas_nivelacion_grado](24)

select --eo.*
    eo.id_estudiante_oferta,p.identificacion,p.apellidos,p.nombres,om.id_modalidad,o.descripcion,eo.numero_matricula,eo.id_periodo_academico,
    eo.fecha_ingreso,tee.descripcion as tipo,tee.observacion,eo.id_periodo_academico--,mg.id_periodo_academico as matricula
    ,(select min(em1.id_estudiante_matricula) from aca.estudiante_matricula em1
        where em1.estado='A' and em1.id_estudiante_oferta=eo.id_estudiante_oferta) as minnima_matricula,
(select min(ea1.codigo_estado_matricula) from aca.estudiante_matricula em1
                            inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
            where em1.estado='A'and ea1.estado='A' and em1.id_estudiante_oferta=eo.id_estudiante_oferta) as vez
from aca.estudiante_oferta eo
    inner join man.personas p on eo.id_persona = p.id
    inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
    inner join aca.oferta o on om.id_oferta = o.id_oferta
    inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
where   o.id_tipo_oferta = 1  and eo.id_periodo_academico is not null and eo.estado='A'
and eo.id_periodo_academico in (120,121,122,123)


select --d.ofertaGrado,
       ap.CEDULA,ap.CARRERA,id_oferta_modalidad,id_periodo_academico,PERIODO
from dbo.segunda_matricula_nivelacion_2022 ap
-- where ap.id_oferta_modalidad is null
where id_periodo_academico in (15,24)


-- update se set se.id_oferta_modalidad = d.id_oferta_modalidad
select d.*
from (
    select
        eo.id_estudiante_oferta,eo.id_oferta_modalidad,p.identificacion,p.apellidos,p.nombres,om.id_modalidad,o.descripcion as carrera,se.CARRERA as carrera_matriz,
        eo.numero_matricula,eo.id_periodo_academico,
        eo.fecha_ingreso,tee.descripcion as tipo,tee.observacion,se.N
    from aca.estudiante_oferta eo
        inner join man.personas p on eo.id_persona = p.id
        inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
        inner join aca.oferta o on om.id_oferta = o.id_oferta
        inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
        inner join dbo.segunda_matricula_nivelacion_2022 se on se.CEDULA = p.identificacion and se.id_periodo_academico = 15
    where   o.id_tipo_oferta = 1  and eo.id_periodo_academico is null and eo.estado='A'
    -- and se.CARRERA like concat('%',o.descripcion,'%')
--     and o.descripcion like concat('%',se.CARRERA,'%')
) as d
inner join dbo.segunda_matricula_nivelacion_2022 se on se.N = d.N

---juntar todas las ofertas

select distinct ro.id_estudiante_oferta,ro.identificacion,ro.apellidos,ro.nombres,ro.carrera,ro.numero_matricula,ro.id_periodo_academico,
                ro.fecha_registro,tee.descripcion as tipo,tee.observacion,
                (select min(rm1.vez) from mig.record_matricula rm1
                                inner join mig.record_asignaturas ra1 on ra1.id_record_matricula = rm1.id_record_matricula

                where rm1.estado='A'and ra1.estado='A' and rm1.id_record_oferta=ro.id_record_oferta) as vez
                from mig.record_oferta ro
inner join aca.tipo_estado_estudiante tee on ro.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
where ro.identificacion ='2400402042'
union all
select d.* from (
    select --eo.*
        eo.id_estudiante_oferta,p.identificacion,p.apellidos,p.nombres,o.descripcion as carrera,eo.numero_matricula,eo.id_periodo_academico,
        eo.fecha_ingreso,tee.descripcion as tipo,tee.observacion,
    (select min(ea1.codigo_estado_matricula) from aca.estudiante_matricula em1
                                inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
                where em1.estado='A'and ea1.estado='A' and em1.id_estudiante_oferta=eo.id_estudiante_oferta) as vez
    from aca.estudiante_oferta eo
        inner join man.personas p on eo.id_persona = p.id
        inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
        inner join aca.oferta o on om.id_oferta = o.id_oferta
        inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
    where   o.id_tipo_oferta = 1  and eo.id_periodo_academico is not null and eo.estado='A'
    ) as d
where d.identificacion ='2400402042'

select * from aca.tipo_estado_estudiante

--manes que no hicieron uso de su matricula
--     update ro set ro.id_tipo_estado_estudiante = 7
select d.*
from (
select ro.id_record_oferta,ro.identificacion,ro.apellidos,ro.nombres,ro.numero_matricula,ro.numero_matricula_cg,
       ro.modalidad,ro.id_tipo_estado_estudiante,ro.estado,sum(CASE WHEN rm.estado = 'A' THEN 1 ELSE 0 END) AS total_A,
       sum(CASE WHEN rm.estado = 'M' THEN 1 ELSE 0 END) AS total_inactivos_m,sum(CASE WHEN rm.estado in ('H','O') THEN 1 ELSE 0 END) AS total_inactivos_HO from mig.record_oferta ro
inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
where ro.id_tipo_oferta = 1
group by ro.id_record_oferta, ro.identificacion, ro.apellidos, ro.nombres, ro.numero_matricula, ro.numero_matricula_cg, ro.modalidad, ro.id_tipo_estado_estudiante, ro.estado
) as d
inner join mig.record_oferta ro on ro.id_record_oferta = d.id_record_oferta
where d.total_inactivos_m>0

--manes que si efectivaron su cupo y estan en grado
--     update ro set ro.id_tipo_estado_estudiante = 6
select d.*
from (
    select ro.id_record_oferta,ro.identificacion,ro.apellidos,ro.nombres,ro.numero_matricula,ro.numero_matricula_cg,
           ro.carrera,tee1.descripcion as estadoCupo,count(rmp.id_record_matricula) as numero_matriculas_prin,rm.estado_matricula,
           rop.id_record_oferta as id_record_oferta_red,rop.carrera as carrera_res,tee.descripcion,count(rmp.id_record_matricula) as numero_matriculas,
           ro.modalidad,ro.id_tipo_estado_estudiante,ro.estado, roo.id_record_oferta as id_record_oferta_gra,roo.carrera as carrera_gra

    --        sum(CASE WHEN rm.estado = 'M' THEN 1 ELSE 0 END) AS total_inactivos_m,sum(CASE WHEN rm.estado in ('H','O') THEN 1 ELSE 0 END) AS total_inactivos_HO
    from mig.record_oferta ro
    left join aca.tipo_estado_estudiante tee1 on ro.id_tipo_estado_estudiante = tee1.id_tipo_estado_estudiante
    inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
    inner join mig.record_oferta rop on rop.id_record_oferta = ro.id_record_oferta_padre and rop.id_tipo_oferta = 1
    inner join mig.record_matricula rmp on rmp.id_record_oferta = rop.id_record_oferta and rmp.id_nivel = 1
    left join aca.tipo_estado_estudiante tee on rop.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
    left join mig.record_oferta roo on roo.id_record_oferta_padre = ro.id_record_oferta and roo.id_tipo_oferta = 2
    where ro.id_tipo_oferta = 1
    group by ro.id_record_oferta, ro.identificacion, ro.apellidos, ro.nombres, ro.numero_matricula, ro.numero_matricula_cg,rm.estado_matricula,
             ro.modalidad, ro.id_tipo_estado_estudiante, ro.estado, ro.carrera,rop.carrera,rop.id_record_oferta,tee.descripcion,tee1.descripcion,
             roo.carrera,roo.id_record_oferta
) as d
inner join mig.record_oferta ro on ro.id_record_oferta = d.id_record_oferta
where d.estado_matricula='APROBADO'

select * from aca.tipo_estado_estudiante
---aquiiii we
--actualizar datos de los cupos aprobados de los manes normales es que tienen 1 o dos matriculas en un mismo cupo y si tenian relacion entre las matriculas de grado y nivelacion
--     update ro set ro.id_tipo_estado_estudiante = 6
select ro.*
from (
         select ro.id_record_oferta,ro.periodo,ro.identificacion,ro.apellidos,ro.nombres,ro.numero_matricula,ro.numero_matricula_cg,ro.modalidad,ro.id_tipo_estado_estudiante,
                ro.carrera,tee.descripcion as estadoCupoNIv,
                (select count(ro1.id_record_oferta) from mig.record_oferta ro1 where ro1.identificacion = ro.identificacion and ro1.id_tipo_oferta= 2 and ro1.id_tipo_ingreso_estudiante<>11 and
                    ro1.id_record_oferta_padre is null and ro1.estado<>'I' and ro1.periodo>=ro.periodo
                ) as carreras_grado_sisweb,
                (select count(rm.id_record_matricula) from mig.record_matricula rm where rm.id_record_oferta = ro.id_record_oferta) as numero_matriculas_niv,
                (select top 1 rm.vez from mig.record_matricula rm where rm.id_record_oferta = ro.id_record_oferta order by rm.id_number desc) as vez_niv,
                (select top 1 rm.estado_matricula from mig.record_matricula rm where rm.id_record_oferta = ro.id_record_oferta order by rm.id_number desc) as estado_matricula_niv,ro.estado as estado_niv,
                roo.id_record_oferta as id_record_oferta_grado,roo.id_record_oferta_padre as id_record_oferta_grado_padre,roo.carrera as carrera_grado,teeg.descripcion as estadoCupo_grado,
                (select count(rm.id_record_matricula) from mig.record_matricula rm where rm.id_record_oferta = roo.id_record_oferta) as matriculas_carreras_grado,
                (select top 1 rm.estado_matricula from mig.record_matricula rm where rm.id_record_oferta = roo.id_record_oferta order by rm.id_number asc) as estado_matricula_grad,
                (select top 1 rm.estado from mig.record_matricula rm where rm.id_record_oferta = roo.id_record_oferta  order by rm.id_number desc) as estado_registro_grado,
                 roo.id_record_oferta as id_record_oferta_gra,roo.carrera as carrera_gra

         --        sum(CASE WHEN rm.estado = 'M' THEN 1 ELSE 0 END) AS total_inactivos_m,sum(CASE WHEN rm.estado in ('H','O') THEN 1 ELSE 0 END) AS total_inactivos_HO
         from mig.record_oferta ro
                  left join aca.tipo_estado_estudiante tee on ro.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
                  left join mig.record_oferta roo on roo.id_record_oferta_padre = ro.id_record_oferta and roo.id_tipo_oferta = 2
                  left join aca.tipo_estado_estudiante teeg on roo.id_tipo_estado_estudiante = teeg.id_tipo_estado_estudiante
         where ro.id_tipo_oferta = 1  and roo.id_record_oferta is not null --and ro.id_tipo_estado_estudiante is null
         group by ro.id_record_oferta,ro.periodo, ro.identificacion, ro.apellidos, ro.nombres, ro.numero_matricula, ro.numero_matricula_cg,
                  ro.modalidad, ro.id_tipo_estado_estudiante, ro.estado, ro.carrera,tee.descripcion,teeg.descripcion,
                  roo.carrera,roo.id_record_oferta,roo.id_record_oferta_padre
     ) as d
         inner join mig.record_oferta ro on ro.id_record_oferta = d.id_record_oferta
where d.estado_matricula_niv='APROBADO' and d.numero_matriculas_niv>1 and d.estadoCupoNIv ='CUPO INHABILITADO NO USO CUPO'

select * from aca.tipo_ingreso_estudiante

select * from aca.tipo_estado_estudiante

--     update ro set ro.id_tipo_estado_estudiante = case when d.estado_matricula in ('DESERTOR','RETIRADO') then 11
--                                                       when d.estado_matricula in ('NUEVO','REPROBADO') then 9
--                                                       when d.estado_matricula in ('APROBADO') then 6 else null end


--     update ro set ro.id_tipo_estado_estudiante = case when d.estado_matricula in ('DESERTOR','RETIRADO')   then 11
--                                                       when d.estado_matricula in ('NUEVO','REPROBADO')  and d.numero_carreras_niv =1 then 9
--                                                       when d.estado_matricula in ('NUEVO','REPROBADO')  and d.numero_carreras_niv >1 then 12
--                                                       when d.estado_matricula in ('APROBADO') then 6 else null end
--actualizar datos de los cupos aprobados de los manes normales es que tienen 1 o dos matriculas en un mismo cupo y no tienen relacion entre las matriculas de grado y nivelacion
    --volver aqui
--se seteo estaod a los manes que no tenian mas carreras en el sga y en el sisweb
--se seteo estaod a los manes que tenian carreras en el sga
--     update ro set ro.id_tipo_estado_estudiante = case when d.estado_matricula in ('NUEVO','REPROBADO') then 12
--                                                            when d.estado_matricula in ('APROBADO') then 6 else null end
-- update ro set ro.id_tipo_estado_estudiante = case when d.estado_matricula_niv in ('DESERTOR','RETIRADO')   then 11
--                                                   when d.estado_matricula_niv in ('NUEVO','REPROBADO')  and d.numero_matriculas_niv =1 then 9
--                                                   when d.estado_matricula_niv in ('NUEVO','REPROBADO')  and d.numero_matriculas_niv >1 then 12
--                                                   when d.estado_matricula_niv in ('APROBADO') then 6 else null end,ro.fecha_mod=getdate(),ro.usuario_mod='2400254286'
select d.*
-- update ro set ro.id_tipo_estado_estudiante = 6,ro.fecha_mod=getdate(),ro.usuario_mod='2400254286'
--     update ro set ro.id_record_oferta_padre = d.id_record_oferta,ro.fecha_mod=getdate(),ro.usuario_mod='2400254286'
from (
         select ro.id_record_oferta,ro.periodo as periodo_nivelacion,(pag.orden-pa.orden) as num_periodos_validos,roo.periodo as periodo_grado,ro.identificacion,ro.apellidos,ro.nombres,ro.id_estudiante_oferta,--,ro.numero_matricula,ro.numero_matricula_cg,ro.modalidad,
                ro.id_tipo_estado_estudiante,ro.id_oferta_modalidad,
                (select count(ro1.id_record_oferta) from mig.record_oferta ro1 where ro1.identificacion = ro.identificacion and ro1.id_tipo_oferta= 2 and ro1.id_tipo_ingreso_estudiante<>11 and
                                                     ro1.id_record_oferta_padre is null and ro1.estado<>'I' and ro1.periodo>=ro.periodo
                                                                               ) as carreras_grado_sisweb,
                ro.carrera,tee.descripcion as estadoCupoNIv,(select count(rm.id_record_matricula) from mig.record_matricula rm where rm.id_record_oferta = ro.id_record_oferta) as numero_matriculas_niv,
                (select top 1 rm.estado_matricula from mig.record_matricula rm where rm.id_record_oferta = ro.id_record_oferta order by rm.id_number desc) as estado_matricula_niv,ro.estado as estado_niv,
                roo.id_record_oferta as id_record_oferta_grado,roo.id_record_oferta_padre as id_record_oferta_grado_padre,roo.carrera as carrera_grado,teeg.descripcion as estadoCupo_grado,
                (select count(rm.id_record_matricula) from mig.record_matricula rm where rm.id_record_oferta = roo.id_record_oferta) as matriculas_carreras_grado,
                (select top 1 rm.estado_matricula from mig.record_matricula rm where rm.id_record_oferta = roo.id_record_oferta order by rm.id_number asc) as estado_matricula_grad,
                (select top 1 rm.estado from mig.record_matricula rm where rm.id_record_oferta = roo.id_record_oferta  order by rm.id_number desc) as estado_registro_grado,
                (select count(eo.id_oferta_modalidad)
                 from aca.estudiante_oferta eo
                          inner join man.personas p on eo.id_persona = p.id
                          inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
                          inner join aca.oferta o on om.id_oferta = o.id_oferta
                          inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
                 where   o.id_tipo_oferta = 2  and p.identificacion = ro.identificacion and eo.estado='A' and eo.id_estudiante_oferta_padre Is null) as carreras_grado_sga

         --        sum(CASE WHEN rm.estado = 'M' THEN 1 ELSE 0 END) AS total_inactivos_m,sum(CASE WHEN rm.estado in ('H','O') THEN 1 ELSE 0 END) AS total_inactivos_HO
         from mig.record_oferta ro
        inner join aca.periodo_academico pa on pa.codigo=ro.periodo and pa.id_tipo_oferta =2
        left join aca.tipo_estado_estudiante tee on ro.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
        left join mig.record_oferta roo on roo.identificacion = ro.identificacion and ro.id_carrera_ofertada = roo.id_carrera_ofertada
                                         and roo.id_tipo_oferta = 2 and roo.id_tipo_ingreso_estudiante <> 11 and roo.id_record_oferta_padre is null
--                                                and roo.fecha_mod >cast('2024-10-06 20:53:38.000' as datetime2)
        left join aca.periodo_academico pag on pag.codigo = roo.periodo and pag.id_tipo_oferta = 2
        left join aca.tipo_estado_estudiante teeg on roo.id_tipo_estado_estudiante = teeg.id_tipo_estado_estudiante
         where ro.id_tipo_oferta = 1 and ro.id_tipo_estado_estudiante is null and ro.id_estudiante_oferta_destino is null

         group by ro.id_record_oferta,ro.periodo, ro.identificacion, ro.apellidos, ro.nombres, ro.numero_matricula, ro.numero_matricula_cg,
                  ro.modalidad, ro.id_tipo_estado_estudiante, ro.estado, ro.carrera,tee.descripcion,teeg.descripcion,
                  roo.carrera,roo.id_record_oferta,roo.periodo,ro.id_estudiante_oferta, pag.orden,pa.orden,roo.id_record_oferta_padre,ro.id_oferta_modalidad
     ) as d
         inner join mig.record_oferta ro on ro.id_record_oferta = d.id_record_oferta
where d.id_record_oferta_grado is null -- and
--     and d.periodo_nivelacion<'2011-2'
--     and d.estado_matricula_niv<>'APROBADO'
-- and d.carreras_grado_sisweb = 0
-- and d.carreras_grado_sga =0


--volver para aca
select * from mig.estado_academicos where identificacion= '0604844357'
select * from mig.record_oferta where id_record_oferta in (34163,34162)

select  * from mig.record_matricula where id_number in (21650,28771,20189,25310)
and table_name='Bd_Academico.dbo.TE_INSCRIPCIONES'


--actualizar datos de los cupos aprobados de los manes normales es que tienen 1 o dos matriculas y que tienen tiene su sencuencia en el sga
--     update ro set ro.id_tipo_estado_estudiante = case when d.estado_matricula in ('NUEVO','REPROBADO') then 12
--                                                            when d.estado_matricula in ('APROBADO') then 6 else null end

--     update ro set ro.id_tipo_estado_estudiante = case when d.estado_matricula in ('NUEVO','REPROBADO') then 12
--                                                            when d.estado_matricula in ('APROBADO') then 6 else null end
select d.*
from (
         select ro.id_record_oferta,ro.periodo,ro.identificacion,ro.apellidos,ro.nombres,roo.id_estudiante_oferta as id_estudiante_oferta_grado,--ro.numero_matricula_cg,--ro.numero_matricula_cg,ro.modalidad,
                ro.id_tipo_estado_estudiante,
                (select count(ro1.id_record_oferta) from mig.record_oferta ro1 where ro1.identificacion = ro.identificacion and ro1.id_tipo_oferta= 2 and ro1.estado<>'I') as carreras_grado_sisweb,
                ro.carrera,tee.descripcion as estadoCupoNIv,(select count(rm.id_record_matricula) from mig.record_matricula rm where rm.id_record_oferta = ro.id_record_oferta) as numero_matriculas_niv,
                (select min(rm.estado_matricula) from mig.record_matricula rm where rm.id_record_oferta = ro.id_record_oferta) as estado_matricula,ro.estado,aux.id_estudiante_oferta,
                aux.oferta,  aux.numero_matriculas_grado
         from mig.record_oferta ro
            left join aca.tipo_estado_estudiante tee on ro.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
            left join  mig.record_oferta roo on roo.identificacion = ro.identificacion and roo.id_tipo_oferta = 2 and roo.id_carrera_ofertada=ro.id_carrera_ofertada  and roo.id_estudiante_oferta is not null
            left join (select eo.id_estudiante_oferta,o.descripcion as oferta,tee.codigo as estado_cupo,
            (select count(em.id_estudiante_matricula) from aca.estudiante_matricula em
                  where em.estado='A' and em.id_estudiante_oferta=eo.id_estudiante_oferta) as numero_matriculas_grado
                from aca.estudiante_oferta eo
                inner join man.personas p on eo.id_persona = p.id
                inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
                inner join aca.oferta o on om.id_oferta = o.id_oferta
                inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
                where   o.id_tipo_oferta = 2 and eo.estado='A') as aux on aux.id_estudiante_oferta = roo.id_estudiante_oferta
         where ro.id_tipo_oferta = 1 and ro.id_tipo_estado_estudiante is null

         group by ro.id_record_oferta,ro.periodo, ro.identificacion, ro.apellidos, ro.nombres, ro.numero_matricula, ro.numero_matricula_cg,roo.id_estudiante_oferta,
                  ro.modalidad, ro.id_tipo_estado_estudiante, ro.estado, ro.carrera,tee.descripcion,aux.oferta,  aux.numero_matriculas_grado,aux.id_estudiante_oferta

     ) as d
         inner join mig.record_oferta ro on ro.id_record_oferta = d.id_record_oferta
-- where d.id_record_oferta_red is null

select ro.identificacion,ro.carrera,aux.identificacion,aux.oferta,aux.estado_cupo,ron.id_tipo_estado_estudiante,ron.identificacion,ron.carrera from mig.record_oferta ro
                    inner join (select p.identificacion, eo.id_estudiante_oferta,o.descripcion as oferta,tee.codigo as estado_cupo,
                                      (select count(em.id_estudiante_matricula) from aca.estudiante_matricula em where em.estado='A' and em.id_estudiante_oferta=eo.id_estudiante_oferta) as numero_matriculas_grado
                               from aca.estudiante_oferta eo
                                        inner join man.personas p on eo.id_persona = p.id
                                        inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
                                        inner join aca.oferta o on om.id_oferta = o.id_oferta
                                        inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
                               where   o.id_tipo_oferta = 2 and eo.estado='A') as aux on aux.id_estudiante_oferta = ro.id_estudiante_oferta
                                inner join mig.record_oferta ron on ron.id_record_oferta = ro.id_record_oferta_padre

where ro.id_tipo_oferta = 2 and ro.id_tipo_oferta = 2 --and ro.identificacion<>aux.identificacion

select * from mig.record_oferta where identificacion='0919718999'

select te.* from Bd_Academico..vw_MATRICULAS te where te.IDENTIFICACION='0919400887'

select te.* from Bd_Academico..te_MATRICULAS te where te.ID_PERSONA = 7896

select ro.* from mig.record_oferta ro
where ro.id_tipo_oferta = 1 --and ro.id_record_oferta_padre is not null
  and ro.id_tipo_estado_estudiante is null and ro.periodo>'2011-1'




select pa.id_periodo_academico,pa.codigo,pa.descripcion from aca.periodo_academico pa where pa.id_tipo_oferta = 1

select rm.* from mig.record_oferta ro
                  inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
    where ro.id_tipo_oferta = 1

select * from Bd_Academico.dbo.TE_INSCRIPCIONES

select ra.* from mig.record_oferta ro
inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
where ro.id_tipo_oferta = 1 --and ro.id_number=141

select * from aca.tipo_ingreso_estudiante

select  * from aca.estudiante_oferta where id_estudiante_oferta in (64101,63302)

select --eo.*
       eo.id_estudiante_oferta,p.identificacion,p.apellidos,p.nombres,o.descripcion as carrera,eo.numero_matricula,eo.id_periodo_academico,
       eo.fecha_ingreso,tee.descripcion as tipo,tee.observacion,
       (select min(ea1.codigo_estado_matricula) from aca.estudiante_matricula em1
                                                         inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
        where em1.estado='A'and ea1.estado='A' and em1.id_estudiante_oferta=eo.id_estudiante_oferta) as vez
from aca.estudiante_oferta eo
         inner join man.personas p on eo.id_persona = p.id
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
where   o.id_tipo_oferta = 1  and p.identificacion in ('0704676535')
--   and eo.id_tipo_ingreso_estudiante = 14

select * from mig.record_oferta where identificacion='2450115189'




select distinct table_name from mig.record_matricula

select *from mig.record_oferta where id_record_oferta = 64323

--manes de carreras antiguas que deben tener estado
select d.*
from (
         select ro.id_record_oferta,ro.periodo,ro.identificacion,ro.apellidos,ro.nombres,ro.numero_matricula,ro.numero_matricula_cg,ro.modalidad,ro.id_tipo_estado_estudiante,ro.estado as estado_niv,
                ro.carrera,tee1.descripcion as estadoCupoNiv, (select count(rmp.id_record_matricula) from mig.record_matricula rmp where rmp.id_record_oferta =ro.id_record_oferta ) as matriculas_niv,
                (select top 1 rm.estado_matricula from mig.record_matricula rm where rm.id_record_oferta = ro.id_record_oferta order by rm.id_number desc) as estado_matricula_niv,
                rop.id_record_oferta as id_record_oferta_gra,rop.carrera as carrera_gra,tee.descripcion estado_cupo_gra,rop.estado as estado_gra,
                (select count(rmp.id_record_matricula) from mig.record_matricula rmp where rmp.id_record_oferta =rop.id_record_oferta )as numero_matriculas_gra


         --        sum(CASE WHEN rm.estado = 'M' THEN 1 ELSE 0 END) AS total_inactivos_m,sum(CASE WHEN rm.estado in ('H','O') THEN 1 ELSE 0 END) AS total_inactivos_HO
         from mig.record_oferta ro
                  left join aca.tipo_estado_estudiante tee1 on ro.id_tipo_estado_estudiante = tee1.id_tipo_estado_estudiante
                  left join mig.record_oferta rop on rop.id_tipo_oferta = 2 and rop.id_persona_cg = ro.id_persona_cg and rop.id_carrera_ofertada = ro.id_carrera_ofertada
             and rop.id_estudiante_oferta is null and rop.id_record_oferta_padre is null
                  left join aca.tipo_estado_estudiante tee on rop.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         where ro.id_tipo_oferta = 1 and ro.id_tipo_estado_estudiante is null
         group by ro.id_record_oferta,ro.periodo,ro.estado, ro.identificacion, ro.apellidos, ro.nombres, ro.numero_matricula, ro.numero_matricula_cg,
                  ro.modalidad, ro.id_tipo_estado_estudiante, ro.estado, ro.carrera,rop.carrera,rop.id_record_oferta,tee.descripcion,tee1.descripcion,rop.estado
     ) as d
         inner join mig.record_oferta ro on ro.id_record_oferta = d.id_record_oferta
where d.carrera_gra is not null

select * from aca.tipo_ingreso_estudiante

select * from aca.tipo_estado_estudiante

select * from mig.record_oferta ro where ro.id_record_oferta in (31273)

select * from mig.record_matricula ro where ro.id_record_oferta in (39402,39404,39651,39649,56603,56604)

select * from mig.record_oferta ro where ro.identificacion='0906729769'

--manes que han hecho cambio de carrera interno
SELECT DISTINCT
    NOMBRE, IDENTIFICACION, ID_CARRERA_OFERTADA, CARRERA_OFERTADA,
    PRIMERA_FECHA_MATRIC = (SELECT MIN(FECHA_MATRICULACION) from Bd_Academico..TE_MATRICULAS
                            WHERE ID_CARRERA_LOCAL = m.ID_CARRERA_LOCAL AND ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND ID_PERSONA = m.id_persona and estado = 'A')
FROM Bd_Academico..VW_MATRICULAS m
WHERE estado = 'A' AND CG_PER_ACADEMICO <= 28152
  AND ID_CARRERA_OFERTADA <> 196 and IDENTIFICACION='2400018616'
GROUP BY ID_PERSONA, NOMBRE, IDENTIFICACION, ID_CARRERA_OFERTADA, CARRERA_OFERTADA, ID_CARRERA_LOCAL
HAVING (SELECT COUNT(distinct id_carrera_ofertada) from Bd_Academico..TE_MATRICULAS where ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND ID_PERSONA = m.id_persona and estado = 'A') > 1
ORDER BY NOMBRE, 5 ASC

--manes que vienen de otras universidades
SELECT * FROM BD_ACADEMICO..VW_RECORD_ACADEMICO_TODO_MOVILIDAD
WHERE estado like 'CONVALIDA%' and identificacion='0918135138'





---setear los manes que han entrado por homologacion
--192 sin repetidos
--243 repetidos
--188 sin repetidos bien
select distinct ro.*,dd.carrera_completa,tie.descripcion as tipo_ingreso
--     update ro set ro.id_tipo_ingreso_estudiante =  11
from mig.record_oferta ro
inner join aca.tipo_ingreso_estudiante tie on ro.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
inner join (
SELECT distinct d.identificacion,d.matricula,d.estudiante,d.carrera,d.periodo,clms.NOMBRE as carrera_completa,d.sistema,d.modalidad,d.cg_modalidad,d.cg_sistema_estudio,d.id_carrera_ofertada,d.id_persona
FROM BD_ACADEMICO..VW_RECORD_ACADEMICO_TODO_MOVILIDAD as d
inner join Bd_Academico..CARRERAS_LOCALES_MODALIDAD_SISTEMA clms on clms.ID_CARRERA_OFERTADA = d.id_carrera_ofertada
WHERE d.estado like 'CONVALIDA%') as dd on dd.id_carrera_ofertada = ro.id_carrera_ofertada and dd.id_persona= ro.id_persona_cg -- and dd.periodo=ro.periodo
where ro.id_tipo_oferta = 2

select * from mig.record_matricula where id_record_oferta in (60765,60766,60767,60768,60769)

SELECT distinct d.identificacion,d.matricula,d.estudiante,d.carrera,d.periodo,clms.NOMBRE as carrera_completa,d.sistema,d.modalidad,d.cg_modalidad,d.cg_sistema_estudio,d.id_carrera_ofertada,d.id_persona
FROM BD_ACADEMICO..VW_RECORD_ACADEMICO_TODO_MOVILIDAD as d
inner join Bd_Academico..CARRERAS_LOCALES_MODALIDAD_SISTEMA clms on clms.ID_CARRERA_OFERTADA = d.id_carrera_ofertada
WHERE d.estado like 'HOMOLOGA%'

--manes que han hecho homologacion

select d.CARRERA_OFERTADA,d.NOMBRE as carrera_homo,ro.* from mig.record_oferta ro
inner join (
SELECT DISTINCT
NOMBRE, IDENTIFICACION, ID_CARRERA_OFERTADA, CARRERA_OFERTADA,
PRIMERA_FECHA_MATRIC = (SELECT MIN(FECHA_MATRICULACION) from Bd_Academico..TE_MATRICULAS
				WHERE ID_CARRERA_LOCAL = m.ID_CARRERA_LOCAL AND ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND ID_PERSONA = m.id_persona and estado = 'A'),
    ROW_NUMBER() OVER (PARTITION BY IDENTIFICACION,NOMBRE ORDER BY (SELECT MIN(FECHA_MATRICULACION) from Bd_Academico..TE_MATRICULAS
				WHERE ID_CARRERA_LOCAL = m.ID_CARRERA_LOCAL AND ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND ID_PERSONA = m.id_persona
				  and estado = 'A'),ID_CARRERA_OFERTADA) as orden
FROM Bd_Academico..VW_MATRICULAS m
WHERE estado = 'A' AND CG_PER_ACADEMICO <= 28152
AND ID_CARRERA_OFERTADA <> 196
GROUP BY ID_PERSONA, NOMBRE, IDENTIFICACION, ID_CARRERA_OFERTADA, CARRERA_OFERTADA, ID_CARRERA_LOCAL
HAVING (SELECT COUNT(distinct id_carrera_ofertada) from Bd_Academico..TE_MATRICULAS where ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND
  ID_PERSONA = m.id_persona and estado = 'A') > 1) as d on --d.ID_CARRERA_OFERTADA=ro.id_carrera_ofertada and
                                                           d.IDENTIFICACION = ro.identificacion and d.orden = 2
where ro.id_tipo_oferta = 2


select * from aca.tipo_ingreso_estudiante

select * from mig.record_oferta where id_tipo_oferta =1 and id_estudiante_oferta is not null

select * from aca.estudiante_oferta where id_estudiante_oferta=15964

--ya mero revisar a los manes que aprobaron el pre y en sis web y vieron su  primer semestre en el SGA
--al menos mas de 3139
--1544 seghun veo   1519 ahora 1392
select d.*
-- -- update ro set ro.id_tipo_estado_estudiante = 6,ro.fecha_mod=getdate(),ro.usuario_mod='2400254286'
--     update ro set ro.id_estudiante_oferta_destino = d.id_estudiante_oferta,ro.id_tipo_estado_estudiante = 6,ro.fecha_mod=getdate(),ro.usuario_mod='2400254286'
--     update eo set eo.id_tipo_estado_estudiante= 14,--eo.id_tipo_ingreso_estudiante = 2,
--                   eo.fecha_mod=getdate(),eo.usuario_mod='2400254286'
from (
         select
             ro.id_record_oferta,ro.periodo as periodo_nivelacion,ro.id_estudiante_oferta_destino,--(pag.orden-pa.orden) as num_periodos_validos,
--                 eo.periodo as periodo_grado,
                ro.identificacion,ro.apellidos,ro.nombres,ro.id_estudiante_oferta as id_estudiante_oferta_niv,--,ro.numero_matricula,ro.numero_matricula_cg,ro.modalidad,
                ro.id_tipo_estado_estudiante,
                (select count(ro1.id_record_oferta) from mig.record_oferta ro1 where ro1.identificacion = ro.identificacion and ro1.id_tipo_oferta= 2 and ro1.id_tipo_ingreso_estudiante<>11 and
                                                                                     ro1.id_record_oferta_padre is null and ro1.estado<>'I') as carreras_grado_sisweb,
                ro.carrera,tee.descripcion as estadoCupoNIv,(select count(rm.id_record_matricula) from mig.record_matricula rm where rm.id_record_oferta = ro.id_record_oferta) as numero_matriculas_niv,
                (select top 1 rm.estado_matricula from mig.record_matricula rm where rm.id_record_oferta = ro.id_record_oferta order by rm.id_number desc) as estado_matricula_niv,ro.estado as estado_niv,
                eo.id_estudiante_oferta as id_estudiante_oferta_grado, eo.id_estudiante_oferta_padre as id_estudiante_oferta_padre_grado,
                o.descripcion as carrera_grado,teeg.descripcion as estadoCupo_grado,
                (select top 1 pa.id_periodo_academico  from aca.estudiante_matricula em
                inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
                inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
                                                      where em.estado='A' and em.id_estudiante_oferta =eo.id_estudiante_oferta order by em.id_estudiante_matricula asc) as id_primer_periodo_mat,
             (select top 1 pa.id_periodo_academico  from aca.estudiante_matricula em
                inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
                inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
                                                      where em.estado='A' and em.id_estudiante_oferta =eoh.id_estudiante_oferta order by em.id_estudiante_matricula asc) as id_primer_periodo_mat_hibrido
         ,eoH.id_estudiante_oferta AS id_estudiante_oferta_hijo,eo.id_tipo_estado_estudiante as id_tipo_estado_estudiante_grado,eoh.id_tipo_estado_estudiante as id_tipo_estado_estudiante_hijo
                ,(select count(eo.id_oferta_modalidad)
                 from aca.estudiante_oferta eo
                          inner join man.personas p on eo.id_persona = p.id
                          inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
                          inner join aca.oferta o on om.id_oferta = o.id_oferta
                          inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
                     --quitar si falla
--                             left join mig.record_oferta ro on ro.id_oferta_modalidad = om.id_oferta_modalidad and ro.identificacion=p.identificacion
--                                         and ro.id_tipo_oferta = 2 and ro.id_estudiante_oferta = eo.id_estudiante_oferta
                 where   o.id_tipo_oferta = 2  and p.identificacion = ro.identificacion and eo.estado='A'
                   and eo.id_estudiante_oferta_padre Is null)       as carreras_grado_sga,rom.id_record_oferta_padre

         --        sum(CASE WHEN rm.estado = 'M' THEN 1 ELSE 0 END) AS total_inactivos_m,sum(CASE WHEN rm.estado in ('H','O') THEN 1 ELSE 0 END) AS total_inactivos_HO

         from mig.record_oferta ro
        inner join aca.periodo_academico pa on pa.codigo=ro.periodo and pa.id_tipo_oferta =1
        left join mig.record_oferta rog on rog.id_record_oferta_padre = ro.id_record_oferta and rog.id_tipo_oferta =2
        --eliminar a los manes que ya aprobaron la carrera con otro cupo en el sisweb
--         left join mig.record_oferta ropp on ropp.id_carrera_ofertada = ro.id_carrera_ofertada and ropp.id_oferta_modalidad = ro.id_oferta_modalidad
--                                                 and ropp.id_tipo_oferta =2 and ropp.identificacion=ro.identificacion and ropp.id_record_oferta_padre is null and ropp.id_estudiante_oferta is null
        left join aca.tipo_estado_estudiante tee on ro.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
        inner join rel.fn_relaciones_ofertas_nivelacion_grado(15) oreh on oreh.idOfertaModalidadNivelacion = ro.id_oferta_modalidad
        inner join man.personas p on p.identificacion = ro.identificacion and p.estado='AC'
        inner join aca.estudiante_oferta eo on eo.id_oferta_modalidad = oreh.idOfertaModalidadPregrado and eo.id_persona = p.id
        left join mig.record_oferta rom on rom.id_estudiante_oferta = eo.id_estudiante_oferta and rom.id_tipo_oferta = 2
        left join aca.estudiante_oferta eoh on eoh.id_estudiante_oferta_padre = eo.id_estudiante_oferta
        inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
        inner join aca.oferta o on om.id_oferta = o.id_oferta
        inner join aca.tipo_estado_estudiante teeg on eo.id_tipo_estado_estudiante = teeg.id_tipo_estado_estudiante
         where ro.id_tipo_oferta = 1 and o.id_tipo_oferta = 2 and o.estado='A' and eo.estado='A' and ro.id_tipo_estado_estudiante is null and ro.id_estudiante_oferta_destino is null
           and rog.id_record_oferta_padre is null and eo.id_tipo_ingreso_estudiante not in(4,10,11,13,14) and eo.id_estudiante_oferta_padre is null
          --or (ropp.id_record_oferta_padre is not null and ))
--         and p.identificacion='2400163404'
--          and p.identificacion in ('2450403080','2400163404','2400334468','0706204955','2450198086','2450339680','2450686312','2450752445')
         group by ro.id_record_oferta,ro.periodo, ro.identificacion, ro.apellidos, ro.nombres, ro.numero_matricula, ro.numero_matricula_cg,
                  ro.modalidad, ro.id_tipo_estado_estudiante, ro.estado, ro.carrera,tee.descripcion,teeg.descripcion,eoH.id_estudiante_oferta,
                  ro.id_estudiante_oferta,pa.orden,eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,o.descripcion, ro.id_estudiante_oferta_destino
         ,eo.id_tipo_estado_estudiante,eoh.id_tipo_estado_estudiante,--ropp.periodo,
          rom.id_record_oferta_padre
     ) as d
         inner join mig.record_oferta ro on ro.id_record_oferta = d.id_record_oferta
--         inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = d.id_estudiante_oferta_grado
--     where d.id_primer_periodo_mat is null and d.id_primer_periodo_mat_hibrido is null


select * from mig.record_oferta where identificacion ='2400163404'

select * from INACTIVACIONES2012_2023

select * from rel.fn_relaciones_ofertas_nivelacion_grado(15) oreh

select * from mig.record_oferta ro where ro.identificacion in ('AP468441')
select ro.id_record_oferta,ro.id_record_oferta_padre,ro.id_persona_cg,ro.identificacion,ro.id_tipo_oferta,ro.periodo,ro.id_carrera_ofertada,ro.carrera,ro.estado
from mig.record_oferta ro where ro.identificacion in ('0921580379')

select * from aca.tipo_ingreso_estudiante

select * from mig.oferta_conexion
--setear los manes que son cambios de carreras internos o resideños , es decir que no entraron por nivelacion
--3117 CASOS
-- update rot set rot.id_record_oferta_padre = ro.id_record_oferta, rot.id_tipo_ingreso_estudiante = isnull(con.id_tipo_ingreso_estudiante,4)
select distinct  ro.id_record_oferta as id_record_oferta_origen,ro.id_record_oferta_padre as id_record_oferta_padre_origen,ro.identificacion,
       ro.sistema_estudio as sistema_estudio_origen,ro.id_carrera_ofertada as id_carrera_ofertada_origen, concat(ro.carrera,' - ', ro.modalidad) as carrera_origen
       ,tie.descripcion as ingreso_origen,con.tipo,ro1.orden
     ,rot.sistema_estudio as sistema_estudio_destino, rot.id_carrera_ofertada as id_carrera_ofertada_destino, concat(rot.carrera,' - ', rot.modalidad) as carrera_destino
    ,rot.id_record_oferta as id_record_oferta_destino,rot.id_record_oferta_padre as id_record_oferta_padre_destino,tiet.descripcion ingreso_destino
from mig.record_oferta ro
inner join aca.tipo_ingreso_estudiante tie on tie.id_tipo_ingreso_estudiante = ro.id_tipo_ingreso_estudiante
inner join(
    select d.*,d1.ID_CARRERA_OFERTADA as id_carrera_ofertada_tran,d1.CARRERA_OFERTADA as carrera_tran,d1.PRIMERA_FECHA_MATRIC as fecha_tran,d1.orden as orden_tran from (
    SELECT DISTINCT
    NOMBRE, IDENTIFICACION, ID_CARRERA_OFERTADA, CARRERA_OFERTADA,
    PRIMERA_FECHA_MATRIC = (SELECT MIN(FECHA_MATRICULACION) from Bd_Academico..TE_MATRICULAS
                    WHERE ID_CARRERA_LOCAL = m.ID_CARRERA_LOCAL AND ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND ID_PERSONA = m.id_persona and estado = 'A'),
        ROW_NUMBER() OVER (PARTITION BY IDENTIFICACION,NOMBRE ORDER BY (SELECT MIN(FECHA_MATRICULACION) from Bd_Academico..TE_MATRICULAS
                    WHERE ID_CARRERA_LOCAL = m.ID_CARRERA_LOCAL AND ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND ID_PERSONA = m.id_persona
                      and estado = 'A'),ID_CARRERA_OFERTADA) as orden
    FROM Bd_Academico..VW_MATRICULAS m
    WHERE estado = 'A' AND CG_PER_ACADEMICO <= 28152
    AND ID_CARRERA_OFERTADA <> 196
    GROUP BY ID_PERSONA, NOMBRE, IDENTIFICACION, ID_CARRERA_OFERTADA, CARRERA_OFERTADA, ID_CARRERA_LOCAL
    HAVING (SELECT COUNT(distinct id_carrera_ofertada) from Bd_Academico..TE_MATRICULAS where ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND
      ID_PERSONA = m.id_persona and estado = 'A') > 1) as d
    inner join (
    SELECT DISTINCT
    NOMBRE, IDENTIFICACION, ID_CARRERA_OFERTADA, CARRERA_OFERTADA,
    PRIMERA_FECHA_MATRIC = (SELECT MIN(FECHA_MATRICULACION) from Bd_Academico..TE_MATRICULAS
                    WHERE ID_CARRERA_LOCAL = m.ID_CARRERA_LOCAL AND ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND ID_PERSONA = m.id_persona and estado = 'A'),
        ROW_NUMBER() OVER (PARTITION BY IDENTIFICACION,NOMBRE ORDER BY (SELECT MIN(FECHA_MATRICULACION) from Bd_Academico..TE_MATRICULAS
                    WHERE ID_CARRERA_LOCAL = m.ID_CARRERA_LOCAL AND ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND ID_PERSONA = m.id_persona
                      and estado = 'A'),ID_CARRERA_OFERTADA) as orden
    FROM Bd_Academico..VW_MATRICULAS m
    WHERE estado = 'A' AND CG_PER_ACADEMICO <= 28152
    AND ID_CARRERA_OFERTADA <> 196
    GROUP BY ID_PERSONA, NOMBRE, IDENTIFICACION, ID_CARRERA_OFERTADA, CARRERA_OFERTADA, ID_CARRERA_LOCAL
    HAVING (SELECT COUNT(distinct id_carrera_ofertada) from Bd_Academico..TE_MATRICULAS where ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND
      ID_PERSONA = m.id_persona and estado = 'A') > 1) as d1 on d1.IDENTIFICACION = d.identificacion and d1.orden = (d.orden)+1)
        as ro1 on ro1.IDENTIFICACION = ro.identificacion and ro1.ID_CARRERA_OFERTADA = ro.id_carrera_ofertada
inner join mig.record_oferta rot on rot.identificacion = ro.identificacion and rot.id_carrera_ofertada = ro1.id_carrera_ofertada_tran
inner join aca.tipo_ingreso_estudiante tiet on tiet.id_tipo_ingreso_estudiante = rot.id_tipo_ingreso_estudiante
left join mig.oferta_conexion con on con.id_oferta = ro.id_carrera_ofertada and con.id_oferta_relacion = rot.id_carrera_ofertada
where ro.id_tipo_oferta = 2 and rot.id_tipo_oferta = 2 -- and rot.id_record_oferta_padre is null
and rot.id_record_oferta not in (43842,61670,45867,59342,63365,44963,45860,59408,42498,37227,49049,47579,49152)
--PARA SABER LOS CAMBIOS DE SEDE
--  and   SUBSTRING(ro.carrera, 1, CHARINDEX('-',ro.carrera) - 1)= SUBSTRING(rot.carrera, 1, CHARINDEX('-',rot.carrera) - 1)
-- and ro.carrera <> rot.carrera and ro.modalidad = rot.modalidad

--PARA SABER LOS CAMBIOS DE SISTEMAS DE ESTUDIOS
-- AND ro.carrera = rot.carrera and ro.modalidad = rot.modalidad
--PARA SABER LOS CAMBIOS DE MODALIDAD
-- AND ro.carrera = rot.carrera and ro.modalidad <> rot.modalidad

select * from aca.tipo_ingreso_estudiante
--   and ro1.IDENTIFICACION = '0921580379'


    select * from mig.record_oferta where id_record_oferta= 57129




--manes que han hech transicion o cambios de carrera
select * from (
SELECT DISTINCT
NOMBRE, IDENTIFICACION, ID_CARRERA_OFERTADA, CARRERA_OFERTADA,
PRIMERA_FECHA_MATRIC = (SELECT MIN(FECHA_MATRICULACION) from Bd_Academico..TE_MATRICULAS
				WHERE ID_CARRERA_LOCAL = m.ID_CARRERA_LOCAL AND ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND ID_PERSONA = m.id_persona and estado = 'A'),
    ROW_NUMBER() OVER (PARTITION BY IDENTIFICACION,NOMBRE ORDER BY (SELECT MIN(FECHA_MATRICULACION) from Bd_Academico..TE_MATRICULAS
				WHERE ID_CARRERA_LOCAL = m.ID_CARRERA_LOCAL AND ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND ID_PERSONA = m.id_persona
				  and estado = 'A'),ID_CARRERA_OFERTADA) as orden
FROM Bd_Academico..VW_MATRICULAS m
WHERE estado = 'A' AND CG_PER_ACADEMICO <= 28152
AND ID_CARRERA_OFERTADA <> 196
GROUP BY ID_PERSONA, NOMBRE, IDENTIFICACION, ID_CARRERA_OFERTADA, CARRERA_OFERTADA, ID_CARRERA_LOCAL
HAVING (SELECT COUNT(distinct id_carrera_ofertada) from Bd_Academico..TE_MATRICULAS where ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND
  ID_PERSONA = m.id_persona and estado = 'A') > 1) as d
inner join (
SELECT DISTINCT
NOMBRE, IDENTIFICACION, ID_CARRERA_OFERTADA, CARRERA_OFERTADA,
PRIMERA_FECHA_MATRIC = (SELECT MIN(FECHA_MATRICULACION) from Bd_Academico..TE_MATRICULAS
				WHERE ID_CARRERA_LOCAL = m.ID_CARRERA_LOCAL AND ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND ID_PERSONA = m.id_persona and estado = 'A'),
    ROW_NUMBER() OVER (PARTITION BY IDENTIFICACION,NOMBRE ORDER BY (SELECT MIN(FECHA_MATRICULACION) from Bd_Academico..TE_MATRICULAS
				WHERE ID_CARRERA_LOCAL = m.ID_CARRERA_LOCAL AND ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND ID_PERSONA = m.id_persona
				  and estado = 'A'),ID_CARRERA_OFERTADA) as orden
FROM Bd_Academico..VW_MATRICULAS m
WHERE estado = 'A' AND CG_PER_ACADEMICO <= 28152
AND ID_CARRERA_OFERTADA <> 196
GROUP BY ID_PERSONA, NOMBRE, IDENTIFICACION, ID_CARRERA_OFERTADA, CARRERA_OFERTADA, ID_CARRERA_LOCAL
HAVING (SELECT COUNT(distinct id_carrera_ofertada) from Bd_Academico..TE_MATRICULAS where ID_CARRERA_OFERTADA <> 196 AND CG_PER_ACADEMICO <= 28152 AND
  ID_PERSONA = m.id_persona and estado = 'A') > 1) as d1 on d1.IDENTIFICACION = d.identificacion and d1.orden = (d.orden)+1
where d.IDENTIFICACION='0921580379'




select ID_NIVEL,ID_ORIGEN,ORIGEN from Bd_Academico..TE_MATRICULAS
                                 where --ID_NIVEL in (1,13) and
 ID_CARRERA_OFERTADA = 21 and ID_PERSONA = 7108


--     insert into mig.record_matricula
                        select  ro1.carrera , d.carrera,d.identificacion,ro1.id_persona_cg,
                               ro1.id_record_oferta,d.id_periodo_academico, d.id_periodo_academico_cg, d.id_tipo_matricula,d.id_tipo_jornada_laboral,d.id_nivel,d.nivel, d.aula, d.curso, d.vez, d.promedio,
    d.valor_total,iif(d.atendido=1,null,'Matrícula no efectivizada')  as observacion,d.estado_matricula, d.fecha_matricula,d.periodo, d.id_number, d.table_name,
    iif(d.atendido=1,d.estado,'M') as estado,d.version, d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod
--     ,d.identificacion,d.carrera
    from(
    SELECT iif(pa.id_periodo_academico is null and pe.VALOR_TEXTO='2011-1-PRE',103,pa.id_periodo_academico) as id_periodo_academico,per.CG_PER_ACADEMICO as id_periodo_academico_cg,
    --tins.CG_PER_MATRICULA,tiMat.VALOR_TEXTO as tipoMatricula,
    isnull(tm.id_tipo_matricula,1) as id_tipo_matricula,case aula.JORNADA when 'NOCTURNO' then 3 when 'VESPERTINA' THEN 2 WHEN 'DIURNO' then 1 else null end as id_tipo_jornada_laboral,
    11 as id_nivel, 'NIVELACION' AS nivel,
    aula.AULA as aula,aula.DENOMINACION AS curso,iif(tins.ESTATUS=1 or tins.ESTATUS is null,'1 VEZ','2 VEZ') as vez,tins.PROMEDIO as promedio,
    0 as valor_total,null as observacion,ein.NOMBRE_ESTADO AS estado_matricula,tins.FECHA_INGRESO as fecha_matricula,
    tins.ID_INSCRIPCION as id_number,'Bd_Academico.dbo.TE_INSCRIPCIONES' as table_name,tins.ESTADO as estado,
    0 as version,getdate() as fecha_ing,getdate() as fecha_mod, '2400254286' as usuario_ing, '2400254286' as usuario_mod
    ,iif(pe.VALOR_TEXTO <'2014-1',1,isnull(tins.atendido,0)) as atendido,pe.VALOR_TEXTO as periodo, isnull(coreal.CARRERA,cof.CARRERA) as carrera,p.IDENTIFICACION as identificacion
    FROM         Bd_Academico.dbo.VW_ASIG_AULAS as aula
    RIGHT OUTER JOIN Bd_Academico.dbo.TE_INSCRIPCIONES tins
    INNER JOIN Bd_Academico.dbo.ESTADO_INSCRIPCIONES ein ON tins.ID_SITUACION = ein.ID_SITUACION
    INNER JOIN Bd_Academico.dbo.PERIODOS_ACADEMICOS per
    INNER JOIN Bd_Academico.dbo.TP_CODIGOS AS pe ON per.CG_PER_ACADEMICO = pe.CORRELATIVO ON tins.ID_PERIODO_DETALLE = per.ID_DETALLE
    INNER JOIN Bd_Academico.dbo.PERSONAS p ON tins.ID_PERSONA = p.ID_PERSONA ON aula.ID_REGISTRO = tins.ID_REGISTRO_AULA
    INNER JOIN Bd_Academico.dbo.VW_CARRERAS_OFERTADAS AS cof ON tins.ID_CARRERA_OFERTADA = cof.ID_CARRERA_OFERTADA
    left JOIN Bd_Academico.dbo.VW_CARRERAS_OFERTADAS AS coreal ON tins.ID_CARRERA_OFERTADA_IES = coreal.ID_CARRERA_OFERTADA
    left join aca.periodo_academico pa on pa.codigo = pe.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 1
    left JOIN Bd_Academico.dbo.TP_CODIGOS AS tiMat ON tins.CG_PER_MATRICULA = tiMat.CORRELATIVO
    left join aca.tipo_matricula tm on tm.descripcion = tiMat.VALOR_TEXTO
    WHERE     (tins.ESTADO not in ('X','C','N','E','I'))
    ) as d
    left join mig.record_oferta ro WITH (NOLOCK) on ro.id_number = d.id_number and ro.id_tipo_oferta = 1 and ro.table_name='Bd_Academico.dbo.TE_INSCRIPCIONES'
    left join mig.record_matricula rm WITH (NOLOCK) on ro.id_record_oferta = rm.id_record_oferta
    inner join mig.record_oferta ro1 WITH (NOLOCK) on  ro1.identificacion = d.identificacion and ro1.id_tipo_oferta = 1 and ro1.table_name='Bd_Academico.dbo.TE_INSCRIPCIONES'
--     and ro1.id_carrera_ofertada = ro.id_carrera_ofertada
    and ro1.carrera_original = d.carrera
--     where rm.id_record_matricula is null --and d.identificacion='2400238107'
    and d.id_number=19542
        -- in (select top 6 id_number from mig.record_matricula where table_name='Bd_Academico.dbo.TE_INSCRIPCIONES' order by record_matricula.id_record_matricula desc)

          select id_number from mig.record_matricula where table_name='Bd_Academico.dbo.TE_INSCRIPCIONES'

--                     where ro.identificacion=@identificacion

-- insert into mig.record_oferta
select top 2 null as id_record_oferta_padre,
             d.id_periodo_academico, d.id_periodo_academico_cg, d.id_tipo_jornada_laboral, d.tipo_estudiante, d.id_tipo_ingreso_estudiante,
d.id_tipo_estado_estudiante, d.id_persona_cg, d.id_carrera_ofertada, d.id_area, d.id_tipo_oferta, d.id_oferta_modalidad, d.id_estudiante_oferta,null as id_estudiante_oferta,
d.id_modalidad_cg, d.modalidad, d.periodo, d.sistema_estudio, d.facultad,d.carrera, d.carrera, d.escuela, d.area, d.numero_matricula, d.numero_matricula_cg,
d.mantiene_gratuidad, d.promedio, d.identificacion, d.nombres, d.apellidos, d.fecha_ingreso, d.id_number, d.table_name, d.estado, d.version,
d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod--,ro.periodo,ro.carrera
--                 ,iif(tins.ESTATUS is null or tins.ESTATUS=1,'1 VEZ','2 VEZ') as vez
from (select --a.gratuidad,a.carrera,
           null as id_record_oferta_padre,d.id_periodo_academico, d.id_periodo_academico_cg, d.id_tipo_jornada_laboral,d.tipo_estudiante, d.id_tipo_ingreso_estudiante,
    d.id_tipo_estado_estudiante, d.id_persona_cg, d.id_carrera_ofertada,d.id_area,d.id_tipo_oferta,d.id_oferta_modalidad, d.id_estudiante_oferta, d.id_modalidad_cg,
    d.modalidad,d.periodo, isnull(d.sistema_estudio,'SEMESTRAL') as sistema_estudio, d.facultad,d.carrera,d.carrera as carrera_original, d.escuela, d.area, d.numero_matricula, d.numero_matricula_cg,
    iif(a.gratuidad is null or a.gratuidad='MANTIENE GRATUIDAD',1,0) as mantiene_gratuidad,
    d.promedio, d.identificacion,d.nombres, d.apellidos, d.fecha_ingreso, d.id_number, d.table_name, d.estado, d.version,
    d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod from (
    SELECT iif(pa.id_periodo_academico is null and pe.VALOR_TEXTO='2011-1-PRE',103,pa.id_periodo_academico) as id_periodo_academico,per.CG_PER_ACADEMICO as id_periodo_academico_cg,
    case aula.JORNADA when 'NOCTURNO' then 3 when 'VESPERTINA' THEN 2 WHEN 'DIURNO' then 1 else null end as id_tipo_jornada_laboral,1 as tipo_estudiante,
    case  when substring(pe.VALOR_TEXTO,1,4)  < '2012' then 16
    when substring(pe.VALOR_TEXTO,1,4)  < '2017' then 17 when substring(pe.VALOR_TEXTO,1,4) < '2020' then 18
    when substring(pe.VALOR_TEXTO,1,4) < '2022' then 19 when substring(pe.VALOR_TEXTO,1,4)  < '2023' then 1
    when substring(pe.VALOR_TEXTO,1,4)  < '2024' then 7 else null end as id_tipo_ingreso_estudiante,
    null as id_tipo_estado_estudiante,p.ID_PERSONA as id_persona_cg,isnull(tins.ID_CARRERA_OFERTADA_IES,tins.ID_CARRERA_OFERTADA) as id_carrera_ofertada,
    iif(tins.ID_CARRERA_OFERTADA_IES is null,null,tins.ID_CARRERA_OFERTADA) as id_area,1 as id_tipo_oferta,null as id_oferta_modalidad,
    null as id_estudiante_oferta,per.CG_MODALIDAD as id_modalidad_cg,mod.VALOR_TEXTO as modalidad, iif(pe.VALOR_TEXTO='2011-1-PRE','2011-3',pe.VALOR_TEXTO) as periodo,
    aula.SISTEMA as sistema_estudio, cof.FACULTAD AS facultad,isnull(coreal.CARRERA,cof.CARRERA) as carrera,cof.ESCUELA as escuela,
    iif(coreal.CARRERA is null,null,cof.CARRERA)as area,'POR DEFINIR' as numero_matricula,'POR DEFINIR' as numero_matricula_cg,
    1 as mantiene_gratuidad,
    tins.PROMEDIO as promedio,
    p.IDENTIFICACION as identificacion,p.NOMBRES as nombres,p.APELLIDOS as apellidos, tins.FECHA_INGRESO as fecha_ingreso,
    tins.ID_INSCRIPCION as id_number,'Bd_Academico.dbo.TE_INSCRIPCIONES' as table_name,
    tins.ESTADO as estado,0 as version,getdate() as fecha_ing,getdate() as fecha_mod,
    '2400254286' as usuario_ing, '2400254286' as usuario_mod
    FROM         Bd_Academico.dbo.VW_ASIG_AULAS as aula
    RIGHT OUTER JOIN Bd_Academico.dbo.TE_INSCRIPCIONES tins
    INNER JOIN Bd_Academico.dbo.ESTADO_INSCRIPCIONES ein ON tins.ID_SITUACION = ein.ID_SITUACION
    INNER JOIN Bd_Academico.dbo.PERIODOS_ACADEMICOS per
    INNER JOIN Bd_Academico.dbo.TP_CODIGOS AS pe ON per.CG_PER_ACADEMICO = pe.CORRELATIVO ON tins.ID_PERIODO_DETALLE = per.ID_DETALLE
    INNER JOIN Bd_Academico. dbo.TP_CODIGOS AS mod ON per.CG_MODALIDAD = mod.CORRELATIVO
    INNER JOIN Bd_Academico.dbo.PERSONAS p ON tins.ID_PERSONA = p.ID_PERSONA ON aula.ID_REGISTRO = tins.ID_REGISTRO_AULA
    INNER JOIN Bd_Academico.dbo.VW_CARRERAS_OFERTADAS AS cof ON tins.ID_CARRERA_OFERTADA = cof.ID_CARRERA_OFERTADA
    left JOIN Bd_Academico.dbo.VW_CARRERAS_OFERTADAS AS coreal ON tins.ID_CARRERA_OFERTADA_IES = coreal.ID_CARRERA_OFERTADA
    left join aca.periodo_academico pa on pa.codigo = pe.VALOR_TEXTO and pa.estado='A' and pa.id_tipo_oferta = 1
--     left join mig.record_oferta ro WITH (NOLOCK) on id_number = tins.ID_INSCRIPCION
    WHERE    tins.ESTADO not in('X','C','N','E','I') --and ro.id_record_oferta is not null and ro.id_tipo_oferta = 1 and ro.table_name='Bd_Academico.dbo.TE_INSCRIPCIONES'
    group by per.CG_MODALIDAD, aula.SISTEMA, cof.FACULTAD,cof.CARRERA,pe.VALOR_TEXTO,  coreal.CARRERA, cof.ESCUELA, p.IDENTIFICACION, p.APELLIDOS,
    p.NOMBRES, tins.PROMEDIO, tins.ESTADO, tins.ID_INSCRIPCION, tins.ID_CARRERA_OFERTADA, p.ID_PERSONA, tins.FECHA_INGRESO,
    tins.ID_CARRERA_OFERTADA_IES, pa.id_periodo_academico, per.CG_PER_ACADEMICO, aula.JORNADA,mod.VALOR_TEXTO
    ) as d
    left join bdupse.snu.aspirante a on a.identificacion = d.identificacion and d.carrera like concat('%',a.carrera,' %')
                                                           )as d
-- inner join Bd_Academico.dbo.TE_INSCRIPCIONES tins on tins.ID_INSCRIPCION = d.id_number
-- inner join mig.oferta_conexion oc on oc.oferta_relacion = d.carrera and oc.id_oferta_relacion =d.id_carrera_ofertada
-- inner join mig.record_oferta ro WITH (NOLOCK) on ro.carrera_original = oc.oferta and ro.identificacion = d.identificacion
--                                          and ro.id_tipo_oferta = 1 and ro.table_name='Bd_Academico.dbo.TE_INSCRIPCIONES'
where d.id_carrera_ofertada = 196
-- (tins.ESTATUS=0)
order by d.fecha_ingreso desc

select * from migracion_sga..entidades_migracion
select * from migracion_sga..registros_migracion where id_entidad_relacion = 2

select *
-- update rm set rm.id_paralelo = d.id_paraleleo,rm.id_nivel_cg = 39,rm.id_nivel = 11
from (
select isnull((select top 1 ra.id_paralelo from mig.record_asignaturas ra
            where ra.id_record_matricula=rm.id_record_matricula
            group by ra.id_record_matricula, ra.id_paralelo
            order by count(ra.id_paralelo) desc),1) as id_paraleleo,
    rm.id_record_matricula from  mig.record_matricula rm
where rm.table_name='Bd_Academico.dbo.TE_INSCRIPCIONES') as d
inner join mig.record_matricula rm on rm.id_record_matricula = d.id_record_matricula

select n.ID_NIVEL,mig.id_nivel,d.id_paraleleo,rm.*
-- update rm set rm.id_paralelo = d.id_paraleleo,rm.id_nivel_cg = n.ID_NIVEL,rm.id_nivel = mig.id_nivel
from (
select isnull((select top 1 ra.id_paralelo from mig.record_asignaturas ra
    where ra.id_record_matricula=rm.id_record_matricula
    group by ra.id_record_matricula, ra.id_paralelo
    order by count(ra.id_paralelo) desc),1) as id_paraleleo,
rm.id_record_matricula from  mig.record_matricula rm
where rm.table_name='Bd_Academico.dbo.TE_MATRICULAS') as d
inner join mig.record_matricula rm on rm.id_record_matricula = d.id_record_matricula
inner join Bd_Academico..NIVELES n on n.DESCRIPCION = rm.nivel
left join (select n.id_nivel,rn.id_origen,rn.id_destino,n.descripcion as nivel from migracion_sga..registros_migracion rn
                                                                             left join aca.nivel n on n.id_nivel = rn.id_destino and n.estado not in ('I')
where rn.id_entidad_relacion in (6) ) as mig on mig.id_origen = n.ID_NIVEL

select (SELECT tof.id_tipo_oferta FROM [bd_sga_upse].aca.tipo_oferta tof where tof.descripcion =  tf.VALOR_TEXTO) as id_tipo_oferta,
       (SELECT ca.id_campus FROM [bd_sga_upse].aca.campus ca where ca.descripcion =  vis.INSTITUCION) as id_campus,null as id_titulo_academico,2 as id_tipo_departamento,
       null as codigo_ces,SUBSTRING(vis.CARRERA, 1, 4) as prefijo,concat (vis.CARRERA,' - ',(SELECT ca.descripcion_corta FROM [bd_sga_upse].aca.campus ca where ca.descripcion =  vis.INSTITUCION)) as carrera, SUBSTRING(vis.CARRERA, 1, 10)AS descripcion_corta,
       case when o.FECHA_APR_CONSEJO IS null then isnull(o.FECHA_CREACION,'1998-01-01') else o.FECHA_APR_CONSEJO end  as fecha_aprobacion,
       case when o.FECHA_CREACION IS null then '1998-01-01' else o.FECHA_CREACION end  as fecha_inicio_oferta,
       NULL as fecha_fin_oferta, null as fecha_cierre, '664' as usuario_ingreso_id,vis.ESTADO_CARRERA,
       vis.ID_CARRERA_LOCAL, ROW_NUMBER() OVER (PARTITION BY vis.ID_CARRERA_LOCAL  ORDER BY o.FECHA_APR_CONSEJO,o.FECHA_CREACION desc ) as indice
from  [bd_academico].[dbo].VW_TE_CARRERAS_LOCALIDAD vis
          inner join [bd_academico].[dbo].CARRERAS_LOCALES_MODALIDAD_SISTEMA o on vis.ID_CARRERA_LOCAL = o.ID_CARRERA_LOCAL
          inner join  [Bd_Personal].[dbo].[TP_CODIGOS] tf on tf.CORRELATIVO = o.CG_TIPO_OFERTA
          left join migracion_sga..registros_migracion rm on rm.id_origen = vis.ID_CARRERA_LOCAL and rm.id_entidad_relacion=1
where RM.id_destino IS NULL and tf.VALOR_TEXTO = 'PREGRADO'
-- and vis.ID_CARRERA_LOCAL not in (select  distinct fac.ID_CARRERA_LOCAL
--                                  from mig.record_oferta ro
--                                           left join mig.record_matricula rma on ro.id_record_oferta = rma.id_record_oferta
--                                           inner join Bd_Academico..VW_CARRERAS_OFERTADAS fac on fac.ID_CARRERA_OFERTADA = ro.ID_CARRERA_OFERTADA
--                                           left join migracion_sga..registros_migracion rm on rm.id_origen = fac.ID_CARRERA_LOCAL and rm.id_entidad_relacion=1
--                                  WHERE ro.estado='A' and rm.id_destino is null and ro.id_tipo_oferta = 2)
group by vis.ID_CARRERA_LOCAL,vis.CARRERA,vis.INSTITUCION,tf.VALOR_TEXTO,o.CG_TIPO_OFERTA,o.FECHA_APR_CONSEJO,o.FECHA_CREACION, vis.ESTADO_CARRERA
order by  vis.CARRERA


--ofertas por migrar segun sisweb
select (SELECT tof.id_tipo_oferta FROM [bd_sga_upse].aca.tipo_oferta tof where tof.descripcion =  tf.VALOR_TEXTO) as id_tipo_oferta,
       (SELECT ca.id_campus FROM [bd_sga_upse].aca.campus ca where ca.descripcion =  vis.INSTITUCION) as id_campus,null as id_titulo_academico,2 as id_tipo_departamento,
       null as codigo_ces,SUBSTRING(vis.CARRERA, 1, 4) as prefijo,concat (vis.CARRERA,' - ',(SELECT ca.descripcion_corta FROM [bd_sga_upse].aca.campus ca where ca.descripcion =  vis.INSTITUCION)) as carrera, SUBSTRING(vis.CARRERA, 1, 10)AS descripcion_corta,
       case when o.FECHA_APR_CONSEJO IS null then isnull(o.FECHA_CREACION,'1998-01-01') else o.FECHA_APR_CONSEJO end  as fecha_aprobacion,
       case when o.FECHA_CREACION IS null then '1998-01-01' else o.FECHA_CREACION end  as fecha_inicio_oferta,
       NULL as fecha_fin_oferta, null as fecha_cierre, '664' as usuario_ingreso_id,vis.ESTADO_CARRERA,
       vis.ID_CARRERA_LOCAL, ROW_NUMBER() OVER (PARTITION BY vis.ID_CARRERA_LOCAL  ORDER BY o.FECHA_APR_CONSEJO,o.FECHA_CREACION desc ) as indice
from  [bd_academico].[dbo].VW_TE_CARRERAS_LOCALIDAD vis
          inner join [bd_academico].[dbo].CARRERAS_LOCALES_MODALIDAD_SISTEMA o on vis.ID_CARRERA_LOCAL = o.ID_CARRERA_LOCAL
          inner join  [Bd_Personal].[dbo].[TP_CODIGOS] tf on tf.CORRELATIVO = o.CG_TIPO_OFERTA
          left join migracion_sga..registros_migracion rm on rm.id_origen = vis.ID_CARRERA_LOCAL and rm.id_entidad_relacion=1
where RM.id_destino IS NULL and tf.VALOR_TEXTO = 'PREGRADO'
-- and vis.ID_CARRERA_LOCAL not in (select  distinct fac.ID_CARRERA_LOCAL
--                                  from mig.record_oferta ro
--                                           left join mig.record_matricula rma on ro.id_record_oferta = rma.id_record_oferta
--                                           inner join Bd_Academico..VW_CARRERAS_OFERTADAS fac on fac.ID_CARRERA_OFERTADA = ro.ID_CARRERA_OFERTADA
--                                           left join migracion_sga..registros_migracion rm on rm.id_origen = fac.ID_CARRERA_LOCAL and rm.id_entidad_relacion=1
--                                  WHERE ro.estado='A' and rm.id_destino is null and ro.id_tipo_oferta = 2)
group by vis.ID_CARRERA_LOCAL,vis.CARRERA,vis.INSTITUCION,tf.VALOR_TEXTO,o.CG_TIPO_OFERTA,o.FECHA_APR_CONSEJO,o.FECHA_CREACION, vis.ESTADO_CARRERA
order by  vis.CARRERA


---ofertas no migradas sin modalidad no sistema de estudio XD
select d.* from (select  ro.id_tipo_oferta,(SELECT ca.id_campus FROM [bd_sga_upse].aca.campus ca where ca.descripcion =  vis.INSTITUCION) as id_campus,
                         (select top 1 t.id_titulo_academico from Bd_academico.dbo.EG_LISTADO_GRADUADOS eg
                                                                      inner join bd_sga_upse.aca.titulos_academicos t on t.descripcion = eg.TITULO
                          where eg.ID_CARRERA_LOCAL =vis.ID_CARRERA_LOCAL) as id_titulo,2 as id_tipo_departamento,
--                        (select top 1 eg.TITULO from Bd_academico.dbo.EG_LISTADO_GRADUADOS eg where eg.ID_CARRERA_LOCAL =vis.ID_CARRERA_LOCAL) as titulo,
                         null as codigo_ces,SUBSTRING(vis.CARRERA, 1, 4) as prefijo,ro.carrera, SUBSTRING(vis.CARRERA, 1, 10)AS descripcion_corta,
                         concat (vis.CARRERA,' - ',(SELECT ca.descripcion_corta FROM [bd_sga_upse].aca.campus ca where ca.descripcion =  vis.INSTITUCION)) as carrera_concat,
                         case when o.FECHA_APR_CONSEJO IS null then isnull(o.FECHA_CREACION,'1998-01-01') else o.FECHA_APR_CONSEJO end  as fecha_aprobacion,
                         case when o.FECHA_CREACION IS null then '1998-01-01' else o.FECHA_CREACION end  as fecha_inicio_oferta,
                         (select top 1 cast(rm.fecha_matricula as date) from mig.record_oferta ro1
                                                                                 inner join mig.record_matricula rm on ro1.id_record_oferta = rm.id_record_oferta
                          where ro1.id_carrera_ofertada = o.ID_CARRERA_OFERTADA and rm.fecha_matricula is not null order by rm.fecha_matricula desc ) as fecha_fin_oferta,
                         (select top 1 cast(pa.fecha_hasta as date) from mig.record_oferta ro1
                                                                             inner join aca.periodo_academico pa on pa.id_periodo_academico = ro1.id_periodo_academico
                          where ro1.id_carrera_ofertada = o.ID_CARRERA_OFERTADA and ro1.id_periodo_academico is not null order by pa.fecha_hasta desc ) as fecha_cierre,
                         o.EMAIL_CONTACTO as correo,o.EMAIL_CLAVE as clave,vis.DURACION  as duracion,'A' as estado,
                         getdate() as fecha_ingreso, '664' as usuario_ingreso_id,getdate() as fecha_ing,'2400254286' as usuario_ing, '2400254286' usuario_mod,
                         vis.ID_CARRERA_LOCAL, ROW_NUMBER() OVER (PARTITION BY vis.ID_CARRERA_LOCAL  ORDER BY o.FECHA_APR_CONSEJO,o.FECHA_CREACION desc ) as indice
                 from mig.record_oferta ro
                          left join mig.record_matricula rma on ro.id_record_oferta = rma.id_record_oferta
                          inner join [bd_academico].[dbo].CARRERAS_LOCALES_MODALIDAD_SISTEMA o on o.ID_CARRERA_OFERTADA = ro.ID_CARRERA_OFERTADA
                          inner join [bd_academico].[dbo].VW_TE_CARRERAS_LOCALIDAD vis on vis.ID_CARRERA_LOCAL = o.ID_CARRERA_LOCAL
                          left join migracion_sga..registros_migracion rm on rm.id_origen = vis.ID_CARRERA_LOCAL and rm.id_entidad_relacion=1
                 WHERE ro.estado='A' and rm.id_destino is null and ro.id_tipo_oferta = 2
                 group by vis.ID_CARRERA_LOCAL,vis.CARRERA,vis.INSTITUCION,o.CG_TIPO_OFERTA,o.FECHA_APR_CONSEJO,o.FECHA_CREACION, vis.ESTADO_CARRERA, ro.carrera,o.ID_CARRERA_OFERTADA,
                          vis.DURACION, ro.id_tipo_oferta,o.EMAIL_CONTACTO,o.EMAIL_CLAVE) as d

where d.indice = 1 --and d.carrera<>d.carrera_concat
order by d.carrera

---ofertas  modalidades no migradas de las ofertas no migradas
select id_modalidad,id_oferta, id_sistema_estudio, codigo_vigente, perfil_egreso, resultado_aprendizaje, fecha_inicio_oferta,
       estado, version, fecha_ingreso, usuario_ingreso_id, fecha_ing, fecha_mod, usuario_ing, usuario_mod, id_carrera_ofertada
from (select distinct (SELECT ca.id_modalidad FROM [bd_sga_upse].aca.modalidad ca where ca.descripcion =  tf.VALOR_TEXTO) as id_modalidad,ro.carrera,
--                                  ro.sistema_estudio,tf.VALOR_TEXTO,
                       rmo.id_destino as id_oferta,ro.id_sistema_estudio as id_sistema_estudio,
                        'NOVIGENTE' as codigo_vigente, '' as perfil_egreso,'' as resultado_aprendizaje,cast(isnull(o.FECHA_CREACION,(select top 1 cast(rm.fecha_matricula as date) from mig.record_oferta ro1
                                                                                 inner join mig.record_matricula rm on ro1.id_record_oferta = rm.id_record_oferta
                          where ro1.id_carrera_ofertada = o.ID_CARRERA_OFERTADA and rm.fecha_matricula is not null order by rm.fecha_matricula asc ))as date) as fecha_inicio_oferta,
                        (select top 1 cast(rm.fecha_matricula as date) from mig.record_oferta ro1
                                                                                 inner join mig.record_matricula rm on ro1.id_record_oferta = rm.id_record_oferta
                          where ro1.id_carrera_ofertada = o.ID_CARRERA_OFERTADA and rm.fecha_matricula is not null order by rm.fecha_matricula desc ) as fecha_fin_oferta ,
                       'A' as estado,0 as version,  getdate() as fecha_ingreso, '664' as usuario_ingreso_id,getdate() as fecha_ing,getdate() as fecha_mod,'2400254286' as usuario_ing, '2400254286' usuario_mod
                         ,ro.ID_CARRERA_OFERTADA
--                          ROW_NUMBER() OVER (PARTITION BY vis.ID_CARRERA_LOCAL  ORDER BY o.FECHA_APR_CONSEJO,o.FECHA_CREACION desc ) as indice
                 from mig.record_oferta ro
                  left join mig.record_matricula rma on ro.id_record_oferta = rma.id_record_oferta
                  inner join [bd_academico].[dbo].CARRERAS_LOCALES_MODALIDAD_SISTEMA o on o.ID_CARRERA_OFERTADA = ro.ID_CARRERA_OFERTADA
                  inner join [bd_academico].[dbo].VW_TE_CARRERAS_LOCALIDAD vis on vis.ID_CARRERA_LOCAL = o.ID_CARRERA_LOCAL
                  inner join migracion_sga..registros_migracion rmo on rmo.id_origen = vis.ID_CARRERA_LOCAL and rmo.id_entidad_relacion=1
                  left join migracion_sga..registros_migracion rmom on rmom.id_origen = o.ID_CARRERA_OFERTADA  and rmom.id_entidad_relacion=2
                  left join  [Bd_Personal].[dbo].[TP_CODIGOS] tf on tf.CORRELATIVO = o.CG_MODALIDAD
--                   left join  [Bd_Personal].[dbo].[TP_CODIGOS] sis on sis.CORRELATIVO = o.CG_SISTEMA_ESTUDIO
                 WHERE ro.estado='A' and rmo.id_destino is not null and ro.id_tipo_oferta = 2 and rmom.id_destino is null
--                  group by
                     ) as d
where d.carrera<>'INGENIERIA INDUSTRIAL REGIMEN ANTERIOR - MATRIZ'
order by d.id_oferta

-- DBCC CHECKIDENT ('aca.oferta', RESEED, 146);
select id_oferta_modalidad, id_modalidad, id_oferta, id_sistema_estudio, codigo_vigente, perfil_egreso, resultado_aprendizaje, fecha_inicio_oferta, fecha_fin_oferta, estado,
       version, fecha_ingreso, usuario_ingreso_id, fecha_ing, fecha_mod, usuario_ing, usuario_mod from aca.oferta_modalidad

--     126,127


select distinct id_carrera_ofertada,id_oferta_modalidad,carrera,modalidad,sistema_estudio
from mig.record_oferta where carrera in ('INGENIERIA INDUSTRIAL - MATRIZ','INGENIERIA INDUSTRIAL REGIMEN ANTERIOR - MATRIZ')

select * from mig.record_oferta where id_record_oferta in (44431,43934,47083)

select distinct id_carrera_ofertada,carrera,modalidad,sistema_estudio
from mig.record_oferta where  id_carrera_ofertada in (199,51,131,38,66,196)
-- 44431,43934,47083
-- ids actualizados con otro id_carrera_ofertada esta mal en el sisweb

select ID_CARRERA_OFERTADA,ID_CARRERA_LOCAL,CG_MODALIDAD,CG_SISTEMA_ESTUDIO,NOMBRE,NOMBRE_CARRERA from [bd_academico].[dbo].CARRERAS_LOCALES_MODALIDAD_SISTEMA
                                                                                                  where  ID_CARRERA_OFERTADA  in (199,51,131,38,66,196)
--                                                                           ID_CARRERA_OFERTADA in (9,21,53,54)

select * from aca.ofertas_facultad where id_oferta_modalidad in (124,34,18)
select * from mig.record_oferta where identificacion in ('0913985313','0924682214')
select * from migracion_sga..registros_migracion rmom where rmom.id_entidad_relacion=1 and rmom.id_origen in (12,92)
select * from migracion_sga..registros_migracion rmom where rmom.id_entidad_relacion=1 and rmom.id_destino in (147)
select * from migracion_sga..registros_migracion rmom where rmom.id_entidad_relacion=2 and rmom.id_origen in (51)
select * from mig.record_asignaturas where id_record_oferta in (47083,47085)
select * from bd_academico..te_matriculas where ID_MATRICULA in (7654,40344,39797)
select * from Bd_Personal.[dbo].[TP_CODIGOS] where ID_CLASIFICACION =19

select * from Bd_Personal.[dbo].[TP_CODIGOS] where ID_CLASIFICACION =20
-- origen  51 destino 124
-- where d.indice = 1
-- order by d.carrera

select * from aca.sistema_estudio

select * from uath.cargos_departamentos where id_oferta in (110)
select * from uath.cargos_departamentos where id_cargo_departamento in (281,315,332,351)
select * from aca.departamento_oferta where id_oferta in (110)
select * from aca.departamento_oferta where departamento_oferta.id_departamento_oferta in (109)
select * from uath.reforma where id_oferta in (110)
select * from uath.reforma where reforma.id_reforma in (81)
select * from aca.campus
select * from aca.oferta_modalidad


select mov1.* from aca.movilidad mov1
inner join aca.estudiante_oferta eo1 on mov1.id_estudiante_oferta = eo1.id_estudiante_oferta
where mov1.estado='A' and mov1.id_estudiante_oferta = 9786

select min(pa.fecha_desde) as fecha_desde,min(ra.fecha_registro) as fecha_ing,ro.id_estudiante_oferta as id_estudiante_oferta
--        pa.fecha_desde as fecha_desde,ra.fecha_registro as fecha_ing,ro.id_estudiante_oferta_destino as id_estudiante_oferta,ra.tipo
from mig.record_oferta ro
         inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
         inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
where  ra.estado<>'I' and ro.estado='A' and ro.id_estudiante_oferta = 9786
  and ra.tipo in ('MOVILIDAD A 8 SEMESTRES - HOM AA','MOVILIDAD A 8 SEMESTRES - HOM VC','MOVILIDAD A 8 SEMESTRES - RECON. CC','MOVILIDAD A 8 SEMESTRES - RECON. TRANSIC.','MOVILIDAD AGROPECUARIA SIN MATRICULA - HOM AA')
group by ro.id_estudiante_oferta--, pa.fecha_desde, ra.fecha_registro, ra.tipo

select * from aca.oferta where id_tipo_oferta =2

select distinct tipo from mig.record_asignaturas



select * from aca.tipo_estado_estudiante

select * from aca.tipo_ingreso_estudiante

select * from mig.record_oferta where id_tipo_ingreso_estudiante = 24
--     2450809955
select * from mig.record_oferta where record_oferta.id_estudiante_oferta in (654)
select * from mig.record_oferta where id_record_oferta in (50154)
select * from mig.record_asignaturas where id_record_oferta = 50093
select * from mig.record_matricula where id_record_oferta = 28491
select * from Bd_Academico..TE_MATRICULAS where MATRICULA='2022220300787' and ID_PERSONA=48874


select top 1* from aca.estudiante_asignatura

select * from mig.record_oferta where identificacion='2450313354' order by periodo

select * from aca.estudiante_oferta
select * from mig.record_oferta where id_record_oferta =4365
select * from mig.listar_carreras_sisweb niv where identificacion='0928413947' order by periodo_cupo



-- truncate table mig.record_oferta_jerarquia
select * from mig.record_oferta_jerarquia where nodos_max>0
select * from mig.estudiante_oferta_jerarquia
select * from mig.record_oferta where periodo ='2017-2'




select * from mig.record_oferta where id_record_oferta =35387
select * from mig.record_oferta where identificacion='2450577008'


select * from mig.listar_carreras_sisweb niv where identificacion='0927365270' order by periodo_cupo




select ra.id_record_oferta,cast(sum(ra.creditos)*0.05 as decimal(10))from mig.record_matricula rm
  inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
where rm.estado='A' and ra.estado='A' and rm.id_record_oferta =50093
group by ra.id_record_oferta
--acues
select ra.id_record_oferta,count(CASE WHEN p.sexo='F' THEN 1 END) AS doc_mujeres,
           count(CASE WHEN p.sexo='M' THEN 1 END) AS doc_hombres from mig.record_matricula rm
inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
inner join man.personas p on p.identificacion = ra.identificacion_docente
where rm.estado='A' and ra.estado='A' and rm.id_record_oferta =50093
group by ra.id_record_oferta

select rm.id_record_oferta,count(CASE WHEN rm.estado in ('C','H','M','N','O','R') THEN 1 END) AS matriculas_anuladas, count(CASE WHEN rm.estado='A' THEN 1 END) AS matriculas_cursadas from mig.record_matricula rm
where rm.estado<>'I' and rm.id_record_oferta =50093
group by rm.id_record_oferta

select ra.id_record_oferta,count(ra.id_record_asignatura) AS total_asignaturas_cursadas,count(CASE WHEN ra.aprobado=1 THEN 1 END) AS total_asignaturas_aprobadas,
       count(CASE WHEN ra.aprobado=0 THEN 1 END) AS total_asignaturas_reprobadas,sum(ra.creditos) as total_creditos,sum(ra.horas) as horas
from mig.record_matricula rm
         inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
where  rm.ESTADO='A' and rm.id_record_oferta =50093
group by ra.id_record_oferta

select * from aca.tipo_estado_estudiante tee
-- actualizar las matriculas con el record_oferta correcto a atraves de las asignaturas

--     update rm set rm.id_record_oferta = ro.id_record_oferta
select distinct  ro.identificacion,ro.id_record_oferta,rm.*
from mig.record_oferta ro
inner join mig.record_asignaturas ra on ra.id_record_oferta = ro.id_record_oferta
inner join mig.record_matricula rm on rm.id_record_matricula = ra.id_record_matricula
where rm.id_record_oferta<>ra.id_record_oferta

select * from ele.junta_receptora_voto

select * from ele.empadronado

select * from man.personas where identificacion = '1312063199'

--matriculas
select distinct ra.* from mig.record_oferta ro
                              left join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
                              left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
where ro.identificacion='2400162166'

select distinct rm.* from mig.record_oferta ro
                              left join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
                              left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
where ro.identificacion='2400162166'

select distinct ro.* from mig.record_oferta ro
                              left join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
                              left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
where ro.identificacion='2400162166'

select distinct ro.* from mig.record_matricula rm
                     inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
                     inner join mig.record_oferta ro on rm.id_record_oferta = ro.id_record_oferta
where ro.id_tipo_ingreso_estudiante = 24
select m.descripcion,ma.* from aca.malla_asignatura ma
         inner join aca.malla m on ma.id_malla = m.id_malla
         where ma.id_malla_asignatura = 893
--     46369

select distinct ro.* from mig.record_oferta ro
                              left join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
                              left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
where ro.estado='I' and ra.id_record_asignatura is null and rm.id_record_matricula is null

select * from mig.record_asignaturas where id_record_oferta=47083

select * from man.personas where identificacion='0923003065'

select * from aca.tipo_estado_estudiante

select * from aca.tipo_ingreso_estudiante
select * from mig.causistica

select * from mig.estado_academicos where identificacion='2450152299'

--editar estados de las personas del sisweb y que se encontraron los estados tal cual con el mismo periodo solo los cupos normales sin transiciones
select * from mig.record_asignaturas where id_record_matricula in (26578,27851)
select * from mig.record_asignaturas where id_record_oferta = 38799
select * from mig.record_matricula where id_record_oferta in (35123)

select min(pa.fecha_desde) as fecha_desde,min(rm.fecha_matricula) as fecha_ing,min(ro.id_estudiante_oferta) as id_estudiante_oferta,eo.id_persona from mig.record_oferta ro
    inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_estudiante_oferta
    inner join mig .record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
    inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
    inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
    where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A' and ro.id_estudiante_oferta = 5321
    group by eo.id_persona

select * from mig.record_oferta where id_record_oferta in (65024)

select * from mig.record_matricula where id_record_matricula in (31127)

select * from mig.record_matricula where id_record_oferta in (11611)
select * from mig.record_asignaturas where id_record_oferta in (11611)

select * from Bd_Academico..TE_MATRICULAS te where ID_PERSONA = 47187

select * from Bd_Academico..TE_MATRICULAS te where MATRICULA = '12022590828'

--caso de prueba con un monton de cupos
select * from mig.record_oferta where identificacion='0803682814' order by periodo,id_tipo_oferta

select * from mig.listar_carreras_sisweb niv where identificacion='2400259160' order by id_tipo_oferta,periodo_cupo



-- insert into  bd_sga_upse.aca.departamento_oferta
-- (id_oferta,id_departamento,usuario_ingreso_id)
select distinct
--     o.descripcion,
--     vis.FACULTAD,
    o.id_oferta as id_oferta,
       case
        when vis.FACULTAD ='FACULTAD DE CIENCIAS DE LA EDUCACION E IDIOMAS' then 12
        when vis.FACULTAD ='FACULTAD DE CIENCIAS SOCIALES Y DE SALUD' then 9
           else ( select d.id from bd_sga_upse.man.departamentos d where d.estado='AC' and d.id<50 and d.nombre = vis.FACULTAD) end as id_departamento,
       '664' as usuario_ingreso_id
from bd_sga_upse.aca.oferta o
-- inner join aca.oferta_modalidad om on o.id_oferta = om.id_oferta
inner join migracion_sga..registros_migracion rm on rm.id_destino = o.id_oferta and rm.id_entidad_relacion=1
left join [Bd_Academico].[dbo].VW_TE_CARRERAS_LOCALIDAD vis on rm.id_origen = vis.ID_CARRERA_LOCAL
left join aca.departamento_oferta do on o.id_oferta = do.id_oferta and do.estado='A'
where do.id_departamento_oferta is null

select * from aca.departamento_oferta
-- order by  rm.id_destino
select * from man.departamentos
---

select * from mig.record_oferta
where identificacion='0921742037'

select ro.*,(select top 1 rm.fecha_matricula from mig.record_matricula rm where rm.id_record_oferta=ro.id_record_oferta order by rm.fecha_matricula) as fecha_primer_matricula from mig.record_oferta ro
where ro.fecha_registro>='2024-10-01 15:18:26.580'-- and fecha_registro<'2024-10-01 17:50:05.260'

-- update ro set ro.fecha_registro= (select top 1 rm.fecha_matricula from mig.record_matricula rm where rm.id_record_oferta=ro.id_record_oferta and fecha_matricula is not null order by rm.fecha_matricula)
-- from mig.record_oferta ro
-- where ro.fecha_registro is null

select ro.*--, (select top 1 rm.fecha_matricula from mig.record_matricula rm where rm.id_record_oferta=ro.id_record_oferta and fecha_matricula is not null order by rm.fecha_matricula) as fecha_primer_matricula
from mig.record_oferta ro
where ro.fecha_registro is null

select * from mig.record_matricula where id_record_oferta in (36815,36816)

select * from mig.record_asignaturas where id_record_oferta in (36815,36816)


select ro.*--, (select top 1 rm.fecha_matricula from mig.record_matricula rm where rm.id_record_oferta=ro.id_record_oferta and fecha_matricula is not null order by rm.fecha_matricula) as fecha_primer_matricula
from mig.record_oferta ro
where ro.fecha_registro is null

select ro.*
from mig.record_oferta ro
inner join aca.periodo_academico pa on ro.id_periodo_academico = pa.id_periodo_academico
where pa.codigo<>ro.periodo

select * from tmp.CASOS_ESPECIALES_NIV

select * from tmp.NIVELACION_SEM_HIS where CEDULA in ('2400241366','2400132466')

select * from mig.listar_carreras_sisweb niv where identificacion='2400132466' order by id_tipo_oferta,periodo_cupo

select * from aca.tipo_ingreso_estudiante

select * from aca.tipo_estudiante

select * from aca.tipo_jornada_laboral

select * from aca.sistema_estudio

select * from aca.tipo_estado_estudiante

select * from man.tipo_identificacion

select * from man.estado_civil

-- DBCC CHECKIDENT ('man.personas', RESEED, 87057);

select distinct  p.identificacion,p.apellidos as APELLIDOS,p.nombres as NOMBRES,    iif(p.id_etnia is null,'NO REGISTRA',e.descripcion) as ETNIA,
         iif(e.descripcion='INDIGENA',isnull(nac.descripcion,'NO REGISTRA'),'NO APLICA') as NACIONALIDAD from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    left join man.nacionalidad_indigena nac on nac.id_nacionalidad_indigena = p.id_nacionalidad_indigena and nac.estado='A'
    left join man.etnia e on e.id_etnia = p.id_etnia and e.estado='A'
where p.identificacion in ('0250263175',    '0604931691','0605965441','0750749061','0914752753',
'0924485543','0925081127','0928166198','0928310846','1005352529','1005357213','1805403522','2250176431',
'2400083909','2400099988','2400265399','2400308694','2450086539','2450152430','2450153529','2450198680',
'2450330903','2450340944','2450372889','2450619719','2450696949','2450726118','2450773714','2450828625','2450861485'   )

--VER USUARIO GRABO_MATRICULA
begin
    declare @id_periodo_academico int=127
    select       --ea.id_estudiante_asignatura,ea.id_asignatura_aprendizaje,ea.id_paralelo,ea.estado
--     distinct  ea.*
--   distinct  em.*
--             distinct   mr.*
--    distinct em.*
        distinct ea.id_estudiante_asignatura,pa.codigo,om.carrera,p.identificacion,p.apellidos,p.nombres,
                 eo.numero_matricula, ma.id_nivel, ma.id_malla_asignatura,ea.id_paralelo,ea.id_estudiante_asignatura,a.descripcion as asignatura,
                 case when ea.estado is null then 'NO MATRICULADO' when ea.estado = 'X' then 'ANULADA'
                      when ea.estado = 'A' then 'ACTIVA'    when ea.estado = 'I' then 'INACTIVA'
                      else ea.estado end as estado_Matricula,em.estado,em.fecha_ing as fechaMatricula,em.fecha_mod as fechaModMatricula,
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
--         inner join aca.detalle_estudiante_asignatura dea on ea.id_estudiante_asignatura = dea.id_estudiante_asignatura
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
      and   om.id_tipo_oferta = 1
    --        and ea.id_estudiante_asignatura in (545740,558792,570035,551506)
--    and em.estado = 'A'/
--   and em.estado = 'A'
--     order by d.nombre, p.apellidos;
end;

select * from aca.periodo_academico where id_tipo_oferta = 2

select * from pro.proceso

select * from pro.proceso_calendario

select * from man.personas where identificacion in ('0605224302',
    '0928274166',
'1850496462',
'2400211393',
'2400295297',
'2450416231',
'2450845355',
'2450936048'

    )

select * from man.lugar where descripcion ='COLOMBIA'

select * from man.nacionalidad where descripcion ='COLOMBIA'

select * from man.tipo_identificacion

select top 50 * from man.personas
where id>87057 and fecha_nace is null

select * from mig.record_oferta where identificacion in ('2400163396')

select * from man.opciones

select * from aca.ofertas_facultad


select * from mig.record_asignaturas where id_record_oferta = 28986
select * from mig.record_matricula where id_record_oferta = 28986


select vpd.* from  mig.vw_personas_desercion vpd where id_estudiante = 40678

select * from mig.vw_ofertas_desercion order by oferta,facultad

select * from mig.record_oferta where id_oferta_modalidad = 203

select * from mig.vw_tiempo_desercion
select * from mig.vw_niveles

select * from aca.tipo_estado_estudiante

alter view mig.vw_tiempo_desercion as
    select CAST(DENSE_RANK() OVER (ORDER BY d.codigo) AS INT) as id_periodo_academico,d.anio,d.codigo,CAST(DENSE_RANK() OVER (ORDER BY d.codigo) AS INT) AS orden from (
               select p.codigo as anio,pa.codigo
               from aca.periodo_academico pa
                        inner join aca.periodo p on pa.id_periodo = p.id_periodo
               where pa.id_tipo_oferta =2 and pa.estado='A' and pa.codigo between '2012-2' and '2025-1' and p.estado='A' --and pa.codigo_tipo_periodo ='PAORD'
                 and pa.id_periodo_academico not in (128)
               -- order by pa.orden
           ) as d
--     order by d.codigo

select * from mig.record_oferta

select * from mig.record_matricula

select * from mig.record_asignaturas

select * from mig.record_calificaciones

select * from mig.historial_docente

select * from mig.historial_docente_detalle

select * from mig.oferta_conexion

select * from mig.oferta_correspondencia

select * from mig.record_oferta_jerarquia

-- truncate table mig.record_oferta_jerarquia
-- truncate table mig.estudiante_oferta_jerarquia
--ver EN LEA
select * from mig.record_oferta_jerarquia

select * from mig.record_oferta where id_tipo_estado_estudiante in (21,22)
select USU_ID,CEDULA,CC_NUM,APELLIDOS,NOMBRES,CARRERA_ACEPTA_CUPO,PERIODO,NOTA_FINAL from tmp.NIVELACION_SEM_HIS where CEDULA in ('0928350719')

select id_estado_academico,apellidos,nombres,carrera_sga,id_estado_academico,periodo,id_estado_cauistica from mig.estado_academicos where identificacion in ('0928350719')

select id_estado_academico,apellidos,nombres,carrera_sga,id_estado_academico,periodo,id_casuistica from mig.estados_academicos_2025_1 where identificacion in ('0928350719')

select asp.identificacion,asp.nombres,asp.apellidos,asp.carrera,asp.campus,asp.fecha_ing,asp.fecha_mod from bdupse.snu.aspirante asp where asp.identificacion in ('0928350719')
select * from aca.tipo_ingreso_estudiante
---aplanar arbol
begin
    DBCC CHECKIDENT ('mig.record_oferta_jerarquia', RESEED, 0);
    truncate table mig.record_oferta_jerarquia;
    WITH JerarquiaOferta AS (
        -- Paso base: nodos raíz (sin padre)
        SELECT
            p.id as id_persona,p.identificacion,
            ro.id_record_oferta,
            ro.id_record_oferta_padre,
            CONCAT(ro.carrera, ' - ', ro.modalidad, ' - ', ro.sistema_estudio) as carrera,
            ro.id_record_oferta AS id_origen,
            CONCAT(ro.carrera, ' - ', ro.modalidad, ' - ', ro.sistema_estudio) AS nombre_origen,
            0 AS nivel,
            0 AS redisenios,
            0 AS cambios_carrera
        FROM mig.record_oferta ro
        inner jOIN man.personas p  ON p.id = ro.id_persona
--         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = ro.id_oferta_modalidad
        WHERE ro.id_record_oferta_padre IS NULL and ro.estado not in ('I','E')
        UNION ALL
        -- Paso recursivo: buscamos los hijos
        SELECT
            p.id as id_persona,p.identificacion,
            hijo.id_record_oferta,
            hijo.id_record_oferta_padre,
            CONCAT(hijo.carrera, ' - ', hijo.modalidad, ' - ', hijo.sistema_estudio) as carrera,
            padre.id_origen,
            padre.nombre_origen,
            padre.nivel + 1,
            padre.redisenios + CASE WHEN hijo.id_tipo_ingreso_estudiante in (6,20,21,23,24) THEN 1 ELSE 0 END,
            padre.cambios_carrera + CASE WHEN hijo.id_tipo_ingreso_estudiante in (4,11,13,22) THEN 1 ELSE 0 END
        FROM mig.record_oferta hijo
         inner jOIN man.personas p  ON p.id = hijo.id_persona
--          inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = hijo.id_oferta_modalidad
        INNER JOIN JerarquiaOferta padre ON hijo.id_record_oferta_padre = padre.id_record_oferta
        where hijo.estado not in ('I','E') and hijo.id_tipo_estado_estudiante  not in (21,22)
    )
    -- Resultado final: nos quedamos con los nodos finales (sin hijos)
    insert into mig.record_oferta_jerarquia
    SELECT
        id_persona,identificacion,
        id_origen,
        nombre_origen,
        id_record_oferta AS id_final,
        carrera AS nombre_final,
        nivel,
        redisenios,
        cambios_carrera,getdate()
    FROM JerarquiaOferta jo
    WHERE NOT EXISTS (
        SELECT 1
        FROM mig.record_oferta hijos
        WHERE hijos.id_record_oferta_padre = jo.id_record_oferta and hijos.estado not in ('I','E') and hijos.id_tipo_estado_estudiante  not in (21,22)
    );
end

SELECT * FROM mig.record_oferta_jerarquia


begin
    DBCC CHECKIDENT ('mig.estudiante_oferta_jerarquia', RESEED, 0);
    truncate table mig.estudiante_oferta_jerarquia;
    WITH JerarquiaOferta AS (
        -- Paso base: nodos raíz (sin padre)
        SELECT
            p.id as id_persona,p.identificacion,
            eo.id_estudiante_oferta,
            eo.id_estudiante_oferta_padre,
            CONCAT(ofa.carrera, ' - ', ofa.modalidad, ' - ', ofa.sistema_estudio) as carrera,
            eo.id_estudiante_oferta AS id_origen,
            CONCAT(ofa.carrera, ' - ', ofa.modalidad, ' - ', ofa.sistema_estudio) AS nombre_origen,
            0 AS nivel,
            0 AS redisenios,
            0 AS cambios_carrera
        FROM aca.estudiante_oferta eo
        INNER JOIN man.personas p  ON p.id = eo.id_persona
        inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
        WHERE eo.id_estudiante_oferta_padre IS NULL and eo.estado in ('A') and ofa.id_tipo_oferta in (1,2)
        UNION ALL
        -- Paso recursivo: buscamos los hijos
        SELECT
            p.id as id_persona,p.identificacion,
            hijo.id_estudiante_oferta,
            hijo.id_estudiante_oferta_padre,
            CONCAT(ofa.carrera, ' - ', ofa.modalidad, ' - ', ofa.sistema_estudio) as carrera,
            padre.id_origen,
            padre.nombre_origen,
            padre.nivel + 1,
            padre.redisenios + CASE WHEN hijo.id_tipo_ingreso_estudiante in (6,20,21,23,24) THEN 1 ELSE 0 END,
            padre.cambios_carrera + CASE WHEN hijo.id_tipo_ingreso_estudiante in (4,11,13,22) THEN 1 ELSE 0 END
        FROM aca.estudiante_oferta hijo
        INNER JOIN man.personas p  ON p.id = hijo.id_persona
        INNER JOIN JerarquiaOferta padre ON hijo.id_estudiante_oferta_padre = padre.id_estudiante_oferta
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = hijo.id_oferta_modalidad
        where hijo.estado in ('A') and ofa.id_tipo_oferta in (1,2)
    )
    -- Resultado final: nos quedamos con los nodos finales (sin hijos)
    insert into mig.estudiante_oferta_jerarquia
    SELECT
        id_persona,identificacion,
        id_origen,
        nombre_origen,
        id_estudiante_oferta AS id_final,
        carrera AS nombre_final,
        nivel,
        redisenios,
        cambios_carrera,getdate()
    FROM JerarquiaOferta jo
    WHERE NOT EXISTS (
        SELECT 1
        FROM aca.estudiante_oferta hijos
                 inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = hijos.id_oferta_modalidad
        WHERE hijos.id_estudiante_oferta_padre = jo.id_estudiante_oferta
          and hijos.estado in ('A') and ofa.id_tipo_oferta in (1,2)
    );
end


select * from mig.estudiante_oferta_jerarquia

select * from mig.estudiante_oferta_modalidad
--     2450883083
--     0103131728
begin
    DBCC CHECKIDENT ('mig.estudiante_oferta_modalidad', RESEED, 0);
    truncate table mig.estudiante_oferta_modalidad;
        WITH Recursivo AS (
            -- Paso base: cada registro arranca como su propio origen
            SELECT
                eo.id_persona,
                p.identificacion,
                0 as nivel,
                eo.id_estudiante_oferta,
                eo.id_estudiante_oferta_padre,
                ofa.id_tipo_oferta,
                ofa.id_oferta,
                eo.id_estudiante_oferta AS nodo_origen,
                CONCAT(ofa.carrera, ' - ', ofa.modalidad, ' - ', ofa.sistema_estudio) AS carrera_origen
            FROM aca.estudiante_oferta eo
            INNER JOIN man.personas p  ON p.id = eo.id_persona
            INNER JOIN aca.ofertas_facultad ofa ON ofa.id_oferta_modalidad = eo.id_oferta_modalidad
            WHERE eo.estado = 'A' AND ofa.id_tipo_oferta = 2   -- carreras de grado
            UNION ALL
            -- Paso recursivo: subimos hacia el padre
            SELECT
                hijo.id_persona,
                p.identificacion,
                padre.nivel + 1,
                hijo.id_estudiante_oferta,
                hijo.id_estudiante_oferta_padre,
                ofa.id_tipo_oferta,
                ofa.id_oferta,
                padre.nodo_origen,
                padre.carrera_origen
            FROM aca.estudiante_oferta hijo
            INNER JOIN man.personas p  ON p.id = hijo.id_persona
            INNER JOIN aca.ofertas_facultad ofa ON ofa.id_oferta_modalidad = hijo.id_oferta_modalidad
            INNER JOIN Recursivo padre ON hijo.id_estudiante_oferta_padre = padre.id_estudiante_oferta
            and ofa.id_oferta = padre.id_oferta
            WHERE hijo.estado = 'A'
              AND ofa.id_tipo_oferta = 2
        ),
--             select * from Recursivo
             Origenes AS (
                 SELECT r.id_estudiante_oferta,r.identificacion,r.id_estudiante_oferta_padre,r.id_oferta,r.nivel,ofa_padre.id_oferta as id_oferta_padre,
                        ofa_padre.id_tipo_oferta,r.nodo_origen, r.carrera_origen,tie.descripcion
                 FROM Recursivo r
                    LEFT JOIN aca.estudiante_oferta eop  ON eop.id_estudiante_oferta = r.id_estudiante_oferta_padre
                    left join aca.tipo_ingreso_estudiante tie on eop.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
                    LEFT JOIN aca.ofertas_facultad ofa_padre ON ofa_padre.id_oferta_modalidad = eop.id_oferta_modalidad
                 WHERE (r.id_estudiante_oferta_padre IS NULL
                    OR ofa_padre.id_tipo_oferta <> 2 or (ofa_padre.id_oferta<>r.id_oferta and r.nivel=0))
             )
--         select * from Origenes
        insert into  mig.estudiante_oferta_modalidad
        SELECT distinct
            eo.id_persona,
            p.identificacion,
            eo.id_estudiante_oferta,
--             eo.id_estudiante_oferta_padre,
            CONCAT(ofa.carrera, ' - ', ofa.modalidad, ' - ', ofa.sistema_estudio) AS carrera,
            o.nodo_origen,
            o.carrera_origen, r.nivel,
            GETDATE()
        FROM aca.estudiante_oferta eo
        INNER JOIN man.personas p ON p.id = eo.id_persona
        INNER JOIN aca.ofertas_facultad ofa ON ofa.id_oferta_modalidad = eo.id_oferta_modalidad
        inner join Recursivo r on r.id_estudiante_oferta = eo.id_estudiante_oferta
        INNER JOIN Origenes o ON r.nodo_origen = o.id_estudiante_oferta
        WHERE eo.estado = 'A';
END

begin
    DBCC CHECKIDENT ('mig.record_oferta_modalidad', RESEED, 0);
    truncate table mig.record_oferta_modalidad;
        WITH Recursivo AS (
            -- Paso base: cada registro arranca como su propio origen
            SELECT
                ro.id_persona,
                p.identificacion,
                0 as nivel,
                ro.id_record_oferta,
                ro.id_record_oferta_padre,
                ofa.id_tipo_oferta,
                ofa.id_oferta,
                ro.id_record_oferta AS nodo_origen,
                CONCAT(ro.carrera, ' - ', ofa.modalidad, ' - ', ofa.sistema_estudio) AS carrera_origen
            FROM mig.record_oferta ro
            INNER JOIN man.personas p  ON p.id = ro.id_persona
            INNER JOIN aca.ofertas_facultad ofa ON ofa.id_oferta_modalidad = ro.id_oferta_modalidad
            WHERE ro.estado = 'A' AND ro.id_tipo_oferta = 2   -- carreras de grado
            UNION ALL
            -- Paso recursivo: subimos hacia el padre
            SELECT
                hijo.id_persona,
                p.identificacion,
                padre.nivel + 1,
                hijo.id_record_oferta,
                hijo.id_record_oferta_padre,
                ofa.id_tipo_oferta,
                ofa.id_oferta,
                padre.nodo_origen,
                padre.carrera_origen
            FROM mig.record_oferta hijo
            INNER JOIN man.personas p  ON p.id = hijo.id_persona
            INNER JOIN aca.ofertas_facultad ofa ON ofa.id_oferta_modalidad = hijo.id_oferta_modalidad
            INNER JOIN Recursivo padre ON hijo.id_record_oferta_padre = padre.id_record_oferta
            and ofa.id_oferta = padre.id_oferta
            WHERE hijo.estado = 'A'
              AND hijo.id_tipo_oferta = 2
        ),
--             select * from Recursivo
             Origenes AS (
                 SELECT r.id_record_oferta,r.identificacion,r.id_record_oferta_padre,r.id_oferta,r.nivel,ofa_padre.id_oferta as id_oferta_padre,
                        rop.id_tipo_oferta,r.nodo_origen, r.carrera_origen,tie.descripcion
                 FROM Recursivo r
                LEFT JOIN mig.record_oferta rop  ON rop.id_record_oferta = r.id_record_oferta_padre
                left join aca.tipo_ingreso_estudiante tie on rop.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
                LEFT JOIN aca.ofertas_facultad ofa_padre ON ofa_padre.id_oferta_modalidad = rop.id_oferta_modalidad
                 WHERE (r.id_record_oferta_padre IS NULL
                    OR rop.id_tipo_oferta <> 2 or (ofa_padre.id_oferta<>r.id_oferta and r.nivel=0))
             )
--         select * from Origenes
        insert into  mig.record_oferta_modalidad
        SELECT distinct
            ro.id_persona,
            p.identificacion,
            ro.id_record_oferta,
--             eo.id_estudiante_oferta_padre,
            CONCAT(ro.carrera, ' - ', ofa.modalidad, ' - ', ofa.sistema_estudio) AS carrera,
            o.nodo_origen,
            o.carrera_origen, r.nivel,
            GETDATE()
        FROM mig.record_oferta ro
        INNER JOIN man.personas p ON p.id = ro.id_persona
        INNER JOIN aca.ofertas_facultad ofa ON ofa.id_oferta_modalidad = ro.id_oferta_modalidad
        inner join Recursivo r on r.id_record_oferta = ro.id_record_oferta
        INNER JOIN Origenes o ON r.nodo_origen = o.id_record_oferta
        WHERE ro.estado = 'A';
END


select * from mig.record_oferta_jerarquia

select * from mig.record_oferta_modalidad

select * from mig.estudiante_oferta_jerarquia

select * from mig.estudiante_oferta_modalidad

-- truncate table mig.estudiante_oferta_jerarquia_grado
-- insert into mig.estudiante_oferta_jerarquia_grado
select roj.id_estudiante_oferta_jerarquia,roj.id_persona,roj.identificacion,iif(ofa.id_tipo_oferta=1,ro1.id_estudiante_oferta,ro.id_estudiante_oferta) as id_estudiante_oferta_origen,
       iif(ofa.id_tipo_oferta=1,ofa1.carrera,ofa.carrera) as carrera_origen,
       roj.id_estudiante_oferta_origen as id_record_original,roj.carrera_origen as carrera_original,roj.id_estudiante_oferta_final,roj.carrera_final,roj.nodos_max,roj.redisenios,roj.cambios_carrera,roj.fecha_actualizacion
from mig.estudiante_oferta_jerarquia roj
         inner join aca.estudiante_oferta ro on ro.id_estudiante_oferta =roj.id_estudiante_oferta_origen
         inner join aca.estudiante_oferta ro1 on ro1.id_estudiante_oferta_padre =ro.id_estudiante_oferta
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = ro.id_oferta_modalidad
        inner join aca.ofertas_facultad ofa1 on ofa1.id_oferta_modalidad = ro1.id_oferta_modalidad
where ofa1.id_tipo_oferta not in (1)

select * from mig.estudiante_oferta_jerarquia_grado
select * from mig.record_oferta where identificacion='0922076518'
-- insert into mig.record_oferta_jerarquia_grado
--     truncate table mig.record_oferta_jerarquia_grado
      select *  from mig.record_oferta_jerarquia_grado
select * from  mig.record_oferta_jerarquia roj where nodos_max>0
-- insert into mig.record_oferta_jerarquia_grado
select roj.id_record_oferta_jerarquia,roj.id_persona,roj.identificacion,iif(ro.id_tipo_oferta=1,ro1.id_record_oferta,ro.id_record_oferta) as id_record_origen,
       iif(ro.id_tipo_oferta=1,ro1.carrera,ro.carrera) as carrera_origen,
              roj.id_record_origen as id_record_original,roj.carrera_origen as carrera_original,roj.id_record_final,roj.carrera_final,roj.nodos_max,roj.redisenios,roj.cambios_carrera,roj.fecha_actualizacion
       from mig.record_oferta_jerarquia roj
inner join mig.record_oferta ro on ro.id_record_oferta =roj.id_record_origen
inner join mig.record_oferta ro1 on ro1.id_record_oferta_padre =ro.id_record_oferta
where ro1.id_tipo_oferta not in (1)

--Actualizar fceha correcta de ingreso a la carrera
SELECT g.*,ro.fecha_registro, isNULL(cast(DATEDIFF(Month,g.fecha_ingreso_carrera,g.FECHA_GRADUACION)/12.0 as decimal(5,2)),10)
-- update g set g.anio_ingreso = year(ro.fecha_registro),g.fecha_ingreso_carrera = cast(ro.fecha_registro as date)
--     update g set g.duracion_estudios = isNULL(cast(DATEDIFF(Month,g.fecha_ingreso_carrera,g.FECHA_GRADUACION)/12.0 as decimal(5,2)),7)
FROM mig.graduados g
inner join mig.record_oferta ro on ro.id_record_oferta = g.id_record_oferta
where g.duracion_estudios<1 --and cast(ro.fecha_registro as date)<g.fecha_ingreso_carrera

SELECT g.*,roo.fecha_registro,tie.descripcion,tie2.descripcion, isNULL(cast(DATEDIFF(Month,g.fecha_ingreso_carrera,g.FECHA_GRADUACION)/12.0 as decimal(5,2)),10)
-- update g set g.anio_ingreso = year(roo.fecha_registro),g.fecha_ingreso_carrera = cast(roo.fecha_registro as date)
--     update g set g.duracion_estudios = isNULL(cast(DATEDIFF(Month,g.fecha_ingreso_carrera,g.FECHA_GRADUACION)/12.0 as decimal(5,2)),7)
FROM mig.graduados g
inner join mig.record_oferta ro on ro.id_record_oferta = g.id_record_oferta
--         inner join mig.record_oferta_modalidad rom on ro.id_record_oferta = rom.id_record_oferta
inner join mig.record_oferta roo on roo.id_record_oferta = ro.id_record_oferta_padre and roo.id_tipo_oferta = 2
inner join aca.tipo_ingreso_estudiante tie on ro.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
inner join aca.tipo_ingreso_estudiante tie2 on roo.id_tipo_ingreso_estudiante = tie2.id_tipo_ingreso_estudiante
where g.duracion_estudios<1 --and cast(roo.fecha_registro as date)<g.fecha_ingreso_carrera and tie.codigo not in ('MOV','MOV-EXT')


--16226
select ofa.carrera,ofa.modalidad,g.* from mig.graduados g
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = g.id_oferta_modalidad

select * from tmp.hecho_indicadores_auxiliar where id_estudiante = 4977

select * from aca.periodo_academico where id_tipo_oferta = 2

--16293 16941
select * from mig.graduados

select * from mig.record_oferta where identificacion='0943605097'
---generate migrate graduadosss
--15015
-- 447
begin
--     DBCC CHECKIDENT ('mig.graduados', RESEED, 0);
--     truncate table mig.graduados;
    insert into mig.graduados
    select d.id_persona, id_persona_cg, ID_EGRESADO, ID_GRADUADO,--concat(d.id_persona,'-',d.id_oferta_modalidad) as aux,
        isnull((select top 1 c.CORRELATIVO from aca.periodo_academico pa
            inner join Bd_Personal..TP_CODIGOS c on c.VALOR_TEXTO = pa.codigo and  c.ID_CLASIFICACION = 33 and c.ESTADO='A'
            where pa.estado='A' and pa.codigo_tipo_periodo='PAORD' and pa.id_tipo_oferta = 2 and d.FECHA_GRADUACION between pa.fecha_desde and pa.fecha_hasta order by pa.codigo),
            (select top 1 c.CORRELATIVO from aca.periodo_academico pa
            inner join aca.periodo_academico pa2 on pa2.id_periodo_academico =pa.id_periodo_academico_siguiente
            inner join Bd_Personal..TP_CODIGOS c on c.VALOR_TEXTO = pa.codigo and  c.ID_CLASIFICACION = 33 and c.ESTADO='A'
            where pa.id_tipo_oferta = 2 and pa.codigo_tipo_periodo='PAORD' and d.FECHA_GRADUACION between pa.fecha_desde and pa2.fecha_desde order by pa.codigo)) as id_periodo_academico_cg,
        isnull((select top 1 pa.id_periodo_academico from aca.periodo_academico pa
            where pa.estado='A' and pa.codigo_tipo_periodo='PAORD' and pa.id_tipo_oferta = 2 and d.FECHA_GRADUACION between pa.fecha_desde and pa.fecha_hasta order by pa.codigo),
                              (select top 1 pa.id_periodo_academico from aca.periodo_academico pa
                                  inner join aca.periodo_academico pa2 on pa2.id_periodo_academico =pa.id_periodo_academico_siguiente
                                 where pa.id_tipo_oferta = 2 and pa.codigo_tipo_periodo='PAORD' and d.FECHA_GRADUACION between pa.fecha_desde and pa2.fecha_desde order by pa.codigo)) as id_periodo_academico,
            id_oferta_modalidad, IDENTIFICACION,PERSONA,
           ID_METODO, TITULO_METODO, ID_CARRERA, ID_CARRERA_LOCAL, ID_CARRERA_OFERTADA, ID_NIVEL_TERMINAL, CARRERA, CG_TITULO, TITULO, ID_PROMOCION, PROMOCION,
           CG_FACULTAD, FACULTAD, MATRICULA, isnull(ANIO_INGRESO,year(d.fecha_aux)) as ANIO_INGRESO,
           isnull(iif(d.FECHA_INGRESO_CARRERA>d.FECHA_GRADUACION,d.fecha_registro,d.FECHA_INGRESO_CARRERA),d.fecha_aux) as FECHA_INGRESO_CARRERA,
           FECHA_EGRESO, FECHA_GRADUACION, FECHA_SUSTENTACION_EXAMEN, CG_SISTEMA_ESTUDIO, SISTEMA_ESTUDIO, CG_MODALIDAD, MODALIDAD, ID_METODO_TITULACION, METODO_TITULACION,
           NOTA_SUSTENTACION_EXAMEN, duracion_semestres,
           isNULL(cast(DATEDIFF(Month,iif(d.FECHA_INGRESO_CARRERA>d.FECHA_GRADUACION,d.fecha_registro,d.FECHA_INGRESO_CARRERA),d.FECHA_GRADUACION)/12.0 as decimal(5,2)),10) as duracion_estudios,
           iif(isnull(d.ingreso_sis,d.ingreso_sga) in ('MOV','MOV-EXT'),1,0) as movilidad, d.id_estudiante_oferta,d.id_record_oferta
            from(
            select isnull(per.id,eo.id_persona) as id_persona,d.ID_PERSONA as id_persona_cg,d.ID_EGRESADO,d.ID_GRADUADO,null as id_periodo_academico_cg, null as id_periodo_academico,
           rm.id_destino as id_oferta_modalidad,d.PERSONA,d.IDENTIFICACION,d.ID_METODO,d.TITULO_METODO,d.ID_CARRERA,d.ID_CARRERA_LOCAL,d.ID_CARRERA_OFERTADA,ss.ID_NIVEL_TERMINAL,
           d.CARRERA,d.CG_TITULO,d.TITULO,d.ID_PROMOCION,d.PROMOCION,d.CG_FACULTAD,d.FACULTAD,d.MATRICULA,iif(isnull(d.ANIO_INGRESO,year(isnull(d.FECHA_INGRESO_CARRERA,mat.fecha_matricula))) is null
             or isnull(d.ANIO_INGRESO,year(isnull(d.FECHA_INGRESO_CARRERA,mat.fecha_matricula)))<='1970',year(mat.fecha_matricula),isnull(d.ANIO_INGRESO,year(isnull(d.FECHA_INGRESO_CARRERA,mat.fecha_matricula)))) as ANIO_INGRESO,
           iif(isnull(d.FECHA_INGRESO_CARRERA,mat.fecha_matricula) is null or
               isnull(d.FECHA_INGRESO_CARRERA,mat.fecha_matricula) <='1970-01-01',mat.fecha_matricula,isnull(d.FECHA_INGRESO_CARRERA,mat.fecha_matricula)) as FECHA_INGRESO_CARRERA,d.FECHA_EGRESO,d.FECHA_GRADUACION,
           iif(isnull(d.FECHA_SUSTENTACION_EXAMEN,d.FECHA_GRADUACION)='1900-01-01 00:00:00.000',d.FECHA_GRADUACION,isnull(d.FECHA_SUSTENTACION_EXAMEN,d.FECHA_GRADUACION)) as FECHA_SUSTENTACION_EXAMEN,
           d.CG_SISTEMA_ESTUDIO,d.SISTEMA_ESTUDIO,d.CG_MODALIDAD,d.MODALIDAD,iif(d.ID_METODO_TITULACION is null or d.ID_METODO_TITULACION=0,1,d.ID_METODO_TITULACION) as ID_METODO_TITULACION,d.METODO_TITULACION,
           iif(d.NOTA_SUSTENTACION_EXAMEN is null or d.NOTA_SUSTENTACION_EXAMEN=0,70,d.NOTA_SUSTENTACION_EXAMEN) as NOTA_SUSTENTACION_EXAMEN
           ,ofa.duracion_semestres,ing.FECHA_INGRESO_CARRERA as fecha_aux,eo.id_estudiante_oferta,ro.id_record_oferta,ro.fecha_registro
        ,tiee.codigo as ingreso_sga,tier.codigo as ingreso_sis
           from
            Bd_academico.dbo.EG_LISTADO_GRADUADOS as d
            inner JOIN Bd_Academico..PERSONAS p ON d.ID_PERSONA = p.ID_PERSONA
            inner join bd_academico..carreras_locales_modalidad_sistema ss on ss.ID_CARRERA_OFERTADA = d.ID_CARRERA_OFERTADA
            inner join migracion_sga..registros_migracion rm on rm.id_origen=d.ID_CARRERA_OFERTADA and rm.id_entidad_relacion in (2)
            inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = rm.id_destino
            left join mig.record_oferta ro on ro.id_persona_cg = p.ID_PERSONA and ro.id_carrera_ofertada = d.ID_CARRERA_OFERTADA and ro.id_tipo_oferta = 2 and ro.estado='A'
                and ro.id_record_oferta not in (38292,48014,54885,64061,51791,65278,54499,58806,60192,63207,38292,59172,37580,50287)
            left join (select rm2.id_record_oferta,rm2.fecha_matricula,ROW_NUMBER() OVER (PARTITION BY rm2.id_record_oferta  ORDER BY rm2.fecha_matricula ) as indice from mig.record_matricula rm2
               where  rm2.estado='A'
            ) as mat on mat.id_record_oferta = ro.id_record_oferta and indice=1
            left join (select rom.id_record_oferta,rom.id_record_oferta_origen,tie.codigo from mig.record_oferta_modalidad rom
               inner join mig.record_oferta ro2 on rom.id_record_oferta_origen = ro2.id_record_oferta
               inner join aca.tipo_ingreso_estudiante tie on ro2.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
            ) as tier on tier.id_record_oferta = ro.id_record_oferta
            left join man.personas per on per.id = ro.id_persona and per.ESTADO='AC'
            left join man.personas per2 on per2.identificacion=p.IDENTIFICACION and per2.ESTADO='AC'
            left join aca.estudiante_oferta eo on eo.id_persona = per2.id and eo.id_oferta_modalidad = ofa.id_oferta_modalidad and eo.estado='A'
            left join (select eom.id_estudiante_oferta,eom.id_estudiante_oferta_origen,tie.codigo from mig.estudiante_oferta_modalidad eom
                        inner join aca.estudiante_oferta eo2 on eom.id_estudiante_oferta_origen = eo2.id_estudiante_oferta
                        inner join aca.tipo_ingreso_estudiante tie on eo2.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
                                ) as tiee on tiee.id_estudiante_oferta = eo.id_estudiante_oferta
            left join (select dd.ID_PROMOCION,dd.PROMOCION,dd.ID_CARRERA_OFERTADA,dd.FECHA_INGRESO_CARRERA,ROW_NUMBER() OVER (PARTITION BY dd.ID_PROMOCION ORDER BY FECHA_INGRESO_CARRERA desc) as indice
               from Bd_academico.dbo.EG_LISTADO_GRADUADOS as dd
                where dd.FECHA_EGRESO is not null and dd.FECHA_INGRESO_CARRERA >'1970-01-01'
            ) as ing on ing.ID_CARRERA_OFERTADA = d.ID_CARRERA_OFERTADA and ing.ID_PROMOCION=d.ID_PROMOCION and ing.indice = 1
           left join mig.graduados g on g.id_graduado_cg = d.ID_GRADUADO
            where p.ESTADO='A' and d.ID_GRADUADO not in (7989,7991,7992,7993,7994,7995,7996,7997,7998,7999)
            and g.id_graduado is null
            group by per.id,d.ID_PERSONA,d.ID_EGRESADO,d.ID_GRADUADO,
            ro.id_oferta_modalidad,d.PERSONA,d.IDENTIFICACION,d.ID_METODO,d.TITULO_METODO,d.ID_CARRERA,d.ID_CARRERA_LOCAL,d.ID_CARRERA_OFERTADA,ss.ID_NIVEL_TERMINAL,
            d.CARRERA,d.CG_TITULO,d.TITULO,d.ID_PROMOCION,d.PROMOCION,d.CG_FACULTAD,d.FACULTAD,d.MATRICULA,d.ANIO_INGRESO,d.FECHA_INGRESO_CARRERA,d.FECHA_EGRESO,d.FECHA_GRADUACION,
            d.FECHA_SUSTENTACION_EXAMEN,d.CG_SISTEMA_ESTUDIO,d.SISTEMA_ESTUDIO,d.CG_MODALIDAD,d.MODALIDAD,d.ID_METODO_TITULACION,d.METODO_TITULACION,d.NOTA_SUSTENTACION_EXAMEN, rm.id_destino
            ,ofa.duracion_semestres,eo.id_persona,mat.fecha_matricula,eo.id_estudiante_oferta,ro.id_record_oferta,ing.FECHA_INGRESO_CARRERA,ro.fecha_registro,tiee.codigo,tier.codigo
            ) as d
end
--------------------------------------------******************************************************


select min(pa1.fecha_desde) as fecha_desde,min(em1.fecha_ing) as fecha_ing,min(em1.id_estudiante_oferta) as id_estudiante_oferta,eo1.id_persona from aca.estudiante_matricula em1
        inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
        inner join aca.periodo_academico pa1 on mg1.id_periodo_academico = pa1.id_periodo_academico
        inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
        where em1.estado='A' and em1.id_nivel = 1 and eo1.id_estudiante_oferta = 45394
        group by eo1.id_persona

select pa.id_periodo_academico,pa.id_periodo_academico_siguiente,pa.codigo,pa.descripcion,pa.fecha_desde,pa.fecha_hasta--,pa2.fecha_desde
from aca.periodo_academico pa
inner join aca.periodo_academico pa2 on pa2.id_periodo_academico =pa.id_periodo_academico_siguiente
where pa.id_tipo_oferta = 2
order by pa.codigo

select distinct ID_CARRERA_OFERTADA,ID_CARRERA_LOCAL,CARRERA,SISTEMA_ESTUDIO,MODALIDAD from Bd_academico.dbo.EG_LISTADO_GRADUADOS as d
where d.ID_CARRERA_OFERTADA not in (select distinct ro.id_carrera_ofertada from mig.record_oferta ro
where ro.id_tipo_oferta = 2 and ro.estado='A')

select * from mig.record_matricula where id_record_oferta = 38483
select distinct ro.id_carrera_ofertada from mig.record_oferta ro
where ro.id_tipo_oferta = 2 and ro.estado='A'

select * from migracion_sga..entidades_migracion

select * from migracion_sga..registros_migracion rm where rm.id_entidad_relacion in (2)

select * from aca.tipo_ingreso_estudiante

select * from aca.tipo_estado_estudiante

select * from aca.estudiante_oferta where id_estudiante_oferta in (88976, 88978 )

--set egresados
SELECT CG_INSTITUCION,ID_CARRERA_LOCAL,MATRICULA,CEDULA as IDENTIFICACION,
CARRERA,periodo AS PERIODO_ACADEMICO,FECHA_EGRESO
FROM Bd_Academico..Vw_Eg_Listado_Egresados where id_persona=23855;

select ro.* from mig.record_oferta ro
inner join Bd_Academico..Vw_Eg_Listado_Egresados e on e.ID_PERSONA=ro.id_persona_cg and e.ID_CARRERA_OFERTADA=ro.id_carrera_ofertada
where ro.id_tipo_estado_estudiante =1 and ro.estado='A'
select ro.* from mig.record_oferta ro where identificacion='0920348208'
--set graduados
select ro.* from mig.record_oferta ro
inner join mig.graduados e on e.identificacion=ro.identificacion and e.ID_CARRERA_OFERTADA=ro.id_carrera_ofertada
where ro.id_tipo_estado_estudiante =1 and ro.estado='A'

-- update eo set eo.id_tipo_estado_estudiante = 5 ,eo.usuario_mod='2400254286',eo.fecha_mod=getdate()
-- update ro set ro.id_tipo_estado_estudiante = 5 ,ro.usuario_mod='2400254286',ro.fecha_mod=getdate()
select
--     eo.*
    e.modalidad,e.carrera,e.persona,e.metodo_titulacion,e.id_periodo_academico,eo.id_tipo_estado_estudiante,ro.*
from mig.graduados e
inner join aca.ofertas_facultad o on o.id_oferta_modalidad = e.id_oferta_modalidad
inner join mig.record_oferta ro on ro.identificacion= e.identificacion
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = ro.id_oferta_modalidad
inner join aca.estudiante_oferta eo on ro.id_estudiante_oferta = eo.id_estudiante_oferta
where ro.id_tipo_estado_estudiante in (1,4) and ro.estado='A' and o.id_oferta = ofa.id_oferta and ro.id_estudiante_oferta_destino is null
-- and ro.identificacion ='0924089238'

-- update eo set eo.id_tipo_estado_estudiante = 5 ,eo.usuario_mod='2400254286',eo.fecha_mod=getdate(),eo.fecha_hasta =cast(e.fecha_graduacion as date)
select
--     eo.*
    e.modalidad,e.carrera,e.persona,e.metodo_titulacion,e.id_periodo_academico,p.identificacion,tee.descripcion,cast(e.fecha_graduacion as date) as graduacion
from mig.graduados e
         inner join aca.ofertas_facultad o on o.id_oferta_modalidad = e.id_oferta_modalidad
         inner join man.personas p on p.identificacion= e.identificacion
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
        inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
where eo.id_tipo_estado_estudiante in (1,4) and eo.estado='A' and o.id_oferta = ofa.id_oferta

select * from aca.tipo_estado_estudiante
--change modalidad
select distinct ofa.carrera,ofa.modalidad,ofa1.carrera,ofa1.modalidad,ofa1.id_oferta_modalidad,g.*
-- update g set g.id_oferta_modalidad=ofa1.id_oferta_modalidad
from mig.graduados g
inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = g.id_oferta_modalidad
inner join aca.ofertas_facultad ofa1 on ofa1.id_oferta = ofa.id_oferta and ofa1.id_modalidad=1 and ofa1.sistema_estudio='SEMESTRAL'
where ofa.modalidad='HIBRIDA'

select * from mig.graduados

select * from man.personas where identificacion in ('2400159667','2450797275')

-- DBCC CHECKIDENT ('mig.graduados', RESEED, 15040);
-- delete from mig.graduados
-- where id_graduado > 15040

--insert records migrados de centro de idiomas:
select distinct d.id_record_oferta_padre, d.id_periodo_academico, d.id_periodo_academico_cg, d.id_tipo_jornada_laboral, d.tipo_estudiante, d.id_tipo_ingreso_estudiante,
                   d.id_tipo_estado_estudiante, d.id_persona_cg, d.id_carrera_ofertada, d.id_area,d.id_tipo_oferta,d.id_sistema_estudio,d.id_sistema_estudio_cg, d.id_oferta_modalidad,
                   d.id_estudiante_oferta, d.id_modalidad_cg,
                   d.modalidad, d.periodo, d.sistema_estudio, d.facultad,d.carrera, d.carrera, d.escuela, d.area, d.numero_matricula, d.numero_matricula_cg, d.mantiene_gratuidad, d.promedio,
                   d.identificacion, d.nombres, d.apellidos, d.fecha_ingreso, d.id_number, d.table_name, d.estado, d.version, d.fecha_ing, d.fecha_mod, d.usuario_ing, d.usuario_mod from (
            select distinct null as id_record_oferta_padre,null as id_periodo_academico,null as id_periodo_academico_cg,4 as  id_tipo_jornada_laboral,
                   8 as tipo_estudiante,8 as id_tipo_ingreso_estudiante,1 as id_tipo_estado_estudiante,p.ID_PERSONA as id_persona_cg,
                   isnull(m.ID_CARRERA_OFERTADA,m.ID_CARRERA_LOCAL) as id_carrera_ofertada,
            null as id_area,4 as id_tipo_oferta,mig.id_sistema_estudio,m.CG_SISTEMA_ESTUDIO as id_sistema_estudio_cg,
            aux.id_oferta_modalidad as id_oferta_modalidad,aux.id_estudiante_oferta  as id_estudiante_oferta,m.cg_modalidad as id_modalidad_cg, mo.valor_texto as modalidad, null as periodo,
            isnull(sis.VALOR_TEXTO,'SEMESTRAL') as sistema_estudio,cl.FACULTAD as facultad,
            iif(aux.id_estudiante_oferta is not null,aux.oferta,cl.CARRERA) as carrera, -- cl.CARRERA as carrera,
            cl.ESCUELA as escuela,null as area, aux.numero_matricula as numero_matricula, m.MATRICULA as numero_matricula_cg,1 as mantiene_gratuidad,0 as promedio,
            p.IDENTIFICACION as identificacion,p.nombres as nombres,p.apellidos as apellidos,m.FECHA_MATRICULACION as fecha_ingreso,
--             isnull(m.ID_CARRERA_OFERTADA,m.id_carrera_local) as id_number,
            isnull((select min(m2.ID_MATRICULA) from bd_academico..te_matriculas m2 where m2.estado not in ('E','X') and m2.ID_PERSONA=m.id_persona
                                       and m2.ID_CARRERA_OFERTADA = m.ID_CARRERA_OFERTADA),
                   (select min(m2.ID_MATRICULA) from bd_academico..te_matriculas m2 where m2.estado not in ('E','X') and m2.ID_PERSONA=m.id_persona
                                                                                      and m2.ID_CARRERA_LOCAL = m.ID_CARRERA_LOCAL)) as id_number,
            iif(m.ID_CARRERA_OFERTADA is null,'bd_academico..te_matriculas.id_carrera_local','bd_academico..te_matriculas.ID_CARRERA_OFERTADA') as table_name,
            m.estado as estado,0 as version,getdate() as fecha_ing,getdate() as fecha_mod,
            '2400254286' as usuario_ing, '2400254286' as usuario_mod
            from bd_academico..personas p
            inner join bd_academico..te_matriculas m on p.id_persona=m.id_persona
            inner join Bd_Academico.dbo.vw_te_carreras_localidad cl on cl.id_carrera_local= m.id_carrera_local
            left join Bd_Academico.dbo.tp_codigos mo on mo.correlativo=m.cg_modalidad
            left join Bd_Academico.dbo.tp_codigos sis on  sis.correlativo=m.cg_sistema_estudio
            left join [migracion_sga].[dbo].[registros_migracion] rmo on  rmo.id_origen  = m.ID_CARRERA_OFERTADA and rmo.id_entidad_relacion = 2
            left join (select p.id as idPersona,p.identificacion,eo.id_estudiante_oferta,om.id_oferta_modalidad,eo.numero_matricula,o.descripcion as oferta from man.personas p
            inner join aca.estudiante_oferta eo on eo.id_persona = p.id
            inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
            inner join aca.oferta o on o.id_oferta = om.id_oferta
            inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
            where eo.estado ='A') as aux on aux.id_oferta_modalidad = rmo.id_destino and aux.identificacion = p.identificacion
            left join (select s.id_sistema_estudio,rn.id_origen,rn.id_destino,s.descripcion as sistema_estudio from migracion_sga..registros_migracion rn
                                                                                                                        left join aca.sistema_estudio s on s.id_sistema_estudio = rn.id_destino and s.estado in ('A')
                       where rn.id_entidad_relacion in (40) ) as mig on mig.id_origen = m.CG_SISTEMA_ESTUDIO
            where m.estado not in ('E','X') and p.estado='A' --and p.identificacion='2400254286'

            and cl.CARRERA='CENTRO DE IDIOMAS'
            ) as d
            left join mig.record_oferta ro on ro.id_number = d.id_number and ro.id_tipo_oferta = 4 and ro.identificacion= d.identificacion
                                                  and ro.id_carrera_ofertada = d.id_carrera_ofertada
--                                                     and ro.carrera = d.carrera
            and ro.numero_matricula_cg = d.numero_matricula_cg
            where d.id_sistema_estudio_cg = 202
--             inner join (select * from mig.temp_record_oferta) as aux on aux.id_number = d.id_number and aux.valido = 1 and aux.estado=d.estado
--             where ro.id_record_oferta is null and d.numero_matricula_cg is not null and d.id_persona_cg  not in(5995)
            order by d.apellidos,d.nombres,d.carrera,d.estado

