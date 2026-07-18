use bd_sga_upse

--MATRIZ MATRICULA PERIODOS v2024
select d.CODIGO_IES, CODIGO_CARRERA, NOMBRE_CARRERA, CIUDAD_CARRERA, TIPO_IDENTIFICACION, IDENTIFICACION, PRIMER_APELLIDO, SEGUNDO_APELLIDO,
       NOMBRES, TOTAL_CREDITOS_APROBADOS,CREDITOS_APROBADOS, NIVEL_ACADEMICO, NUM_MATERIAS_SEGUNDA_MATRICULA, NUM_MATERIAS_TERCERA_MATRICULA, PERDIDA_GRATUIDAD,
       TOTAL_HORAS_APROBADAS, HORAS_APROBADAS_PERIODO, MONTO_AYUDA_ECONOMICA, MONTO_CREDITO_EDUCATIVO, ESTADO from (
select distinct --pa.codigo as PERIODO_ACADEMICO,
    1023 as CODIGO_IES,o.codigo_ces as CODIGO_CARRERA,o.descripcion as NOMBRE_CARRERA,c.descripcion as CIUDAD_CARRERA,
    te.descripcion as TIPO_IDENTIFICACION,p.identificacion AS IDENTIFICACION,p.apellido_paterno as PRIMER_APELLIDO,p.apellido_materno as SEGUNDO_APELLIDO,
    p.nombres as NOMBRES,( select sum(ma1.num_creditos) as creditos
                           from [aca].[fn_record_academico_sga_definitivo](eo.id_estudiante_oferta,null,null,1) as d
                                    inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = d.idMallaAsignatura
                           where ma1.estado='A' and d.periodo not in ('2024-1')) as TOTAL_CREDITOS_APROBADOS,mat.creditos as CREDITOS_APROBADOS,
    (select top (1) niv.orden as semestre
     from aca.matricula_general mg
              inner join aca.estudiante_matricula em1 on em1.id_matricula_general = mg.id_matricula_general
              inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
              inner join aca.estudiante_asignatura ea on em1.id_estudiante_matricula=ea.id_estudiante_matricula
              inner join aca.paralelo par on ea.id_paralelo=par.id_paralelo
              inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje
              inner join aca.malla_asignatura ma on aa.id_malla_asignatura=ma.id_malla_asignatura
              inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
     where   mg.id_periodo_academico = 34 and eo1.id_estudiante_oferta = eo.id_estudiante_oferta
       and eo1.estado='A' and em1.estado='A' and ea.estado='A'
       and mg.estado='A'   and aa.estado='A'
       and ma.estado='A' and niv.estado='A'
     group by em1.id_estudiante_matricula,niv.descripcion_corta ,niv.ORDEN,par.descripcion_corta,par.orden
     order by  count (ea.id_asignatura_aprendizaje) desc,count (par.descripcion_corta) desc) as NIVEL_ACADEMICO, mat.segundas_matriculas as NUM_MATERIAS_SEGUNDA_MATRICULA,
     mat.terceras_matriculas NUM_MATERIAS_TERCERA_MATRICULA,
    iif(eo.mantiene_gratuidad=0,'SI','NO') as PERDIDA_GRATUIDAD,
    ( select sum(ma1.num_horas) as horas
        from [aca].[fn_record_academico_sga_definitivo](eo.id_estudiante_oferta,null,null,1) as d
        inner join aca.malla_asignatura ma1 on ma1.id_malla_asignatura = d.idMallaAsignatura
        where ma1.estado='A' and d.periodo not in ('2024-1')) as TOTAL_HORAS_APROBADAS,
    mat.horas as HORAS_APROBADAS_PERIODO,0 as MONTO_AYUDA_ECONOMICA,
    0 as MONTO_CREDITO_EDUCATIVO,'NO APLICA' as ESTADO
from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.malla m on m.id_malla = eo.id_malla
inner join man.tipo_identificacion te on te.id_tipo_identificacion = p.id_tipo_identificacion
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
inner join (select ea1.id_estudiante_matricula,em1.estado,sum(CASE WHEN ea1.codigo_estado_matricula = 'SEG' THEN 1 ELSE 0 END) AS segundas_matriculas,
                   sum(CASE WHEN ea1.codigo_estado_matricula = 'TER' THEN 1 ELSE 0 END) AS terceras_matriculas,count(ea1.id_estudiante_asignatura) as total,
                   sum (ma1.num_creditos) as creditos, sum(ma1.num_horas) as horas from aca.estudiante_matricula em1
         inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
         inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
         inner join aca.malla_asignatura ma1 on aa1.id_malla_asignatura = ma1.id_malla_asignatura
            where em1.estado='A' and ea1.estado='A' and aa1.estado='A' and ma1.estado='A'
            group by ea1.id_estudiante_matricula, em1.estado ) as mat on mat.id_estudiante_matricula = em.id_estudiante_matricula
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
inner join man.departamentos d on d.id= do.id_departamento
inner join aca.campus c on c.id_campus = o.id_campus
where p.estado='AC' and eo.estado='A' and om.estado='A' and em.estado = 'A' and tee.codigo in ('ACT','OFR','APR')
and  mg.id_periodo_academico in (34)
group by pa.codigo,o.descripcion,o.codigo_ces,o.descripcion,c.descripcion,te.descripcion,p.id,p.identificacion,p.apellidos,p.nombres, p.apellido_paterno,
p.apellido_materno,eo.mantiene_gratuidad,eo.id_estudiante_oferta,mat.creditos,mat.horas,mat.terceras_matriculas,mat.segundas_matriculas
) as d
-- where d.FECHA_INICIO_PRIMER_NIVEL <> '' and d.FECHA_INGRESO_CONVALIDACION <>''
--   where  d.FECHA_INICIO_PRIMER_NIVEL = '' and d.FECHA_INGRESO_CONVALIDACION =''
order by d.NOMBRE_CARRERA,d.PRIMER_APELLIDO,d.SEGUNDO_APELLIDO,d.NOMBRES


select id,identificacion,apellidos,nombres, id_estado_civil,fecha_nace,id_pais_residencia,id_provincia_residencia,id_canton_residencia,id_parroquia_residencia,defuncion from man.personas
where identificacion in ('1316297686',	'0956100333',	'2400047227',	'1750861930',	'0924484082',	'2450167032',	'2450500026',	'1724329378',	'1314250158',	'1315020477',	'1316218054',
                         '1208411395',	'1315565521',	'1315772895',	'1250386891',	'2450879768',	'2400459299',	'2450110875',	'1317327854',	'0958798605',	'1351852791',	'1207411529',
                         '1250656483',	'0942623513',	'0951873108',	'2400332892',	'2400180358',	'0706801891',	'2450299660',	'0928145861',	'2400306979',	'2450021981',	'0940779416',
                         '2450690561',	'0955306790',	'2450301623',	'2400406662',	'0955994041',	'2450021981'    )
--MATRIZ MATRICULA ESTUDIANTES V2024
select distinct d.PERIODO_ACADEMICO,d.CODIGO_IES, CODIGO_CARRERA, NOMBRE_CARRERA, CIUDAD_CARRERA, TIPO_IDENTIFICACION, IDENTIFICACION, PRIMER_APELLIDO,
    SEGUNDO_APELLIDO, NOMBRES, SEXO, FECHA_NACIMIENTO, PAIS_ORIGEN, DISCAPACIDAD, PORCENTAJE_DISCAPACIDAD, NUMERO_CONADIS,
    ETNIA, NACIONALIDAD, EMAIL_INSTITUCIONAL,
    iif(FECHA_INICIO_PRIMER_NIVEL<>'' and FECHA_INGRESO_CONVALIDACION<>''
            and cast(FECHA_INICIO_PRIMER_NIVEL as date)<= cast(FECHA_INGRESO_CONVALIDACION as date),
        FECHA_INICIO_PRIMER_NIVEL,iif(FECHA_INICIO_PRIMER_NIVEL<>'' and FECHA_INGRESO_CONVALIDACION='',FECHA_INICIO_PRIMER_NIVEL,'')) as FECHA_INICIO_PRIMER_NIVEL,
       iif(FECHA_INICIO_PRIMER_NIVEL <>'' and FECHA_INGRESO_CONVALIDACION <>''
               and cast(FECHA_INICIO_PRIMER_NIVEL as date)<= cast(FECHA_INGRESO_CONVALIDACION as date),
           '',FECHA_INGRESO_CONVALIDACION)  as FECHA_INGRESO_CONVALIDACION,
--     FECHA_INICIO_PRIMER_NIVEL,FECHA_INGRESO_CONVALIDACION,
    PAIS_RESIDENCIA, PROVINCIA_RESIDENCIA, CANTON_RESIDENCIA, TIPO_COLEGIO, POLITICA_CUOTA from (
select  distinct top 10 pa.codigo as PERIODO_ACADEMICO,
                1023 as CODIGO_IES,o.codigo_ces as CODIGO_CARRERA,o.descripcion as NOMBRE_CARRERA,c.descripcion as CIUDAD_CARRERA,
    te.descripcion as TIPO_IDENTIFICACION,p.identificacion AS IDENTIFICACION,p.apellido_paterno as PRIMER_APELLIDO,p.apellido_materno as SEGUNDO_APELLIDO,
    p.nombres as NOMBRES,iif(p.sexo='M','HOMBRE','MUJER') as SEXO,CONVERT(VARCHAR(10),p.fecha_nace, 103) as FECHA_NACIMIENTO, iif(p.id_pais_nacionalidad is null,'NO REGISTRA',pn.descripcion) as PAIS_ORIGEN,
    iif(p.id_discapacidad is null,'NINGUNA',dis.descripcion) as DISCAPACIDAD,
    iif(p.id_discapacidad is null or p.id_discapacidad='' or p.porcentaje_dis is null,0,p.porcentaje_dis) as PORCENTAJE_DISCAPACIDAD,
    iif(p.num_carnet_conadis is null or p.num_carnet_conadis='' or p.num_carnet_conadis='0','NO APLICA',p.num_carnet_conadis) as NUMERO_CONADIS,
    iif(p.id_etnia is null,'NO REGISTRA',e.descripcion) as ETNIA,iif(p.id_nacionalidad is null,'NO REGISTRA',nac.descripcion) as NACIONALIDAD,
--     p.direccion,p.email_personal,
    iif(p.email_institucional is null,'NO REGISTRA',p.email_institucional) as EMAIL_INSTITUCIONAL,
    --fecha calculada a traves de la primer matricula del estudiante
--     iif(isnull(mat1.fecha_ing,min(matsis.fechaMatriculaPrimerSemestre)) is null,'',
--         CONVERT(VARCHAR(10),isnull(mat1.fecha_ing,min(matsis.fechaMatriculaPrimerSemestre)), 103)) as FECHA_INICIO_PRIMER_NIVEL,
    --fecha calculada por el inicio del periodo academico del primer semestre
        iif(isnull(mat1.fecha_desde,min(matsis.fechaPrimerSemestre)) is null,'',
            CONVERT(VARCHAR(10),isnull(mat1.fecha_desde,min(matsis.fechaPrimerSemestre)), 103)) as FECHA_INICIO_PRIMER_NIVEL,
    iif(isnull(movi.fecha_ingreso,min(consis.fecha_convalidacion)) is null,'',
        CONVERT(VARCHAR(10),isnull(movi.fecha_ingreso,min(consis.fecha_convalidacion)), 103)) as FECHA_INGRESO_CONVALIDACION,

    iif(p.id_pais_residencia is null,'NO REGISTRA',pr.descripcion) as PAIS_RESIDENCIA,
    iif(p.id_provincia_residencia is null,'NO APLICA',pror.descripcion) as PROVINCIA_RESIDENCIA,
    iif(p.id_canton_residencia is null,'NO APLICA',cr.descripcion) as CANTON_RESIDENCIA,
--     iif(tte.id_tipo_institucion is null,'NO REGISTRA',tte.descripcion) as TIPO_COLEGIO,
    isnull((select  TOP 1 tte.descripcion from man.informacion_academica_persona iap
           inner join aca.institucion ins on ins.id_institucion = iap.id_institucion
           inner join aca.tipo_institucion tte on tte.id_tipo_institucion = ins.id_tipo_institucion
           where iap.id_nivel_formacion =2 and iap.estado='A' and iap.id_persona=p.id
           order by iap.id_informacion_academica_persona
    ),'NO REGISTRA')as TIPO_COLEGIO,
    isnull((select top 1 coalesce((
                                      SELECT MAX( CASE
                                                      WHEN AC.codigo_acciones_afirmativas = 'CONDICION_SOCIOECONOMICA' THEN AC.descripcion
                                                      WHEN AC.codigo_acciones_afirmativas = 'DISCAPACIDAD' THEN AC.descripcion
                                                      WHEN AC.codigo_acciones_afirmativas = 'PUEBLOS_NACIONALIDADES' THEN AC.descripcion ELSE 'OTRAS' END
                                             ) AS ASIGNADO_CUPO
                                      FROM niv.inscripcion_acciones_afirmativas iaff
                                       INNER JOIN niv.acciones_afirmativa ac ON ac.id_acciones_afirmativas = iaff.id_acciones_afirmativas
                                      WHERE iaff.estado = 'A' AND ac.estado = 'A'AND iaff.id_inscripcion = i.id_inscripcion_nivelacion
                                  ) ,'NINGUNA')as Politicas_cuotas
            from niv.inscripcion_nivelacion i
             inner join man.personas p1 on p1.id=i.id_persona
            where i.estado='A' and p1.estado='AC' and i.id_periodo_academico in (28,32)
               and i.id_periodo_academico = 32 and p1.identificacion = p.identificacion
            order by i.id_periodo_academico desc),'NINGUNA') as POLITICA_CUOTA
from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.malla m on m.id_malla = eo.id_malla
inner join man.tipo_identificacion te on te.id_tipo_identificacion = p.id_tipo_identificacion
-- left join aca.movilidad mov on mov.id_estudiante_oferta= eo.id_estudiante_oferta  and mov.estado='A' --and mov.id_subtipo_movilidad not in (7)
left join (
    select eo1.id_estudiante_oferta,min(mov1.fecha_ingreso) as fecha_ingreso from aca.movilidad mov1
    inner join aca.estudiante_oferta eo1 on mov1.id_estudiante_oferta = eo1.id_estudiante_oferta
    where mov1.estado='A'
    group by eo1.id_estudiante_oferta
) as movi on movi.id_estudiante_oferta= eo.id_estudiante_oferta
left join man.nacionalidad nac on nac.id_nacionalidad = p.id_nacionalidad and nac.estado='A'
left join man.lugar pn on pn.id_lugar = p.id_pais_nacionalidad and pn.estado='A'
left join man.discapacidad dis on dis.id_discapacidad = p.id_discapacidad and dis.estado='A'
left join man.etnia e on e.id_etnia = p.id_etnia and e.estado='A'
left join man.lugar pr on pr.id_lugar = p.id_pais_residencia
left join man.lugar pror on pror.id_lugar = p.id_provincia_residencia
left join man.lugar cr on cr.id_lugar = p.id_canton_residencia
-- left join man.informacion_academica_persona iap on iap.id_persona =p.id and iap.id_nivel_formacion =2 and iap.estado='A'
-- left join aca.institucion ins on ins.id_institucion = iap.id_institucion
-- left join aca.tipo_institucion tte on tte.id_tipo_institucion = ins.id_tipo_institucion
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
inner join aca.periodo_academico pan on pan.codigo = pa.codigo and pan.id_tipo_oferta = 1
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
left join (
    select min(pa1.fecha_desde) as fecha_desde,min(ea1.fecha_ing) as fecha_ing,min(em1.id_estudiante_oferta) as id_estudiante_oferta,eo1.id_persona,om1.id_oferta from aca.estudiante_matricula em1
        inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
        inner join aca.periodo_academico pa1 on mg1.id_periodo_academico = pa1.id_periodo_academico
       inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
       inner join aca.oferta_modalidad om1 on eo1.id_oferta_modalidad = om1.id_oferta_modalidad
       inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
       inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
       inner join aca.malla_asignatura ma1 on aa1.id_malla_asignatura = ma1.id_malla_asignatura
    where em1.estado='A' and ea1.estado='A' and aa1.estado='A' and ma1.estado='A' and ma1.id_nivel = 1
    group by eo1.id_persona,om1.id_oferta
) as mat1 on --mat1.id_estudiante_oferta = eo.id_estudiante_oferta
    mat1.id_persona = p.id and mat1.id_oferta = o.id_oferta
left join (select p.IDENTIFICACION,
                iif(rm.id_destino is not null,isnull((select top 1 om1.id_oferta from aca.estudiante_oferta eo1
                inner join man.personas p1 on eo1.id_persona = p1.id
                inner join aca.oferta_modalidad om1 on eo1.id_oferta_modalidad = om1.id_oferta_modalidad
                inner join aca.estudiante_matricula em1 on eo1.id_estudiante_oferta = em1.id_estudiante_oferta
                where eo1.estado='A' and om1.estado='A' and em1.estado='A' and p1.estado='AC' and p1.identificacion=p.IDENTIFICACION and om1.id_oferta = om.id_oferta
                group by om1.id_oferta
                order by om1.id_oferta desc),rm.id_destino),concat(ma.ID_CARRERA_OFERTADA,0)) as id_oferta,
                  concat(clms.NOMBRE,' - ',fac.MODALIDAD) as carrera,
                  n.ID_NIVEL,n.DESCRIPCION,
                  cast(isnull(min(mt.FECHA_INGRESO),min(mt.FECHA_MOD)) as date) as fechaMatriculaPrimerSemestre,
                  cast(min(pd.INICIO) as date) as fechaPrimerSemestre
           from Bd_Academico..MATERIAS_TOMADAS mt
                    inner JOIN Bd_Academico..TE_MATRICULAS ma ON mt.ID_MATRICULA = ma.ID_MATRICULA AND mt.ID_PLAN = ma.ID_PLAN
                    inner join Bd_Academico..CARRERAS_LOCALES_MODALIDAD_SISTEMA clms on clms.ID_CARRERA_OFERTADA = ma.ID_CARRERA_OFERTADA
                    inner join Bd_Academico..VW_CARRERAS_OFERTADAS fac on fac.ID_CARRERA_OFERTADA = ma.ID_CARRERA_OFERTADA
                    inner join Bd_Academico..MATERIAS_PLAN mp on mp.ID_MATERIA_PLAN=mt.ID_MATERIA_PLAN
                    inner join Bd_Academico..MATERIAS m on m.id_materia = mt.id_materia_unico
                    inner JOIN Bd_Academico..PERSONAS p ON ma.ID_PERSONA = p.ID_PERSONA
                    inner join Bd_Personal..TP_CODIGOS cm  on cm.correlativo = mt.cg_estado_materia
                    inner join bd_academico..NIVELES n on n.id_nivel = mt.id_nivel
                    inner join Bd_Personal..TP_CODIGOS pa on pa.CORRELATIVO = ma.CG_PER_ACADEMICO
                    inner join Bd_Academico.dbo.PERIODOS_ACADEMICOS pd on pa.CORRELATIVO = pd.CG_PER_ACADEMICO
                    left join migracion_sga..registros_migracion rm on rm.id_origen = ma.ID_CARRERA_OFERTADA and rm.id_entidad_relacion=2
                    left join aca.oferta_modalidad om on om.id_oferta_modalidad = rm.id_destino
           WHERE mt.estado = 'A' AND ma.ESTADO = 'A' AND p.ESTADO = 'A' AND m.estado = 'A' AND p.estado = 'A' AND cm.ESTADO = 'A' AND n.ESTADO = 'A' and clms.ESTADO='A'
             and ma.CG_PER_ACADEMICO between 5574 and 28152
             and n.ID_NIVEL in ( 1)
           group by p.IDENTIFICACION, rm.id_destino, ma.ID_CARRERA_OFERTADA, fac.MODALIDAD, clms.NOMBRE, n.ID_NIVEL, n.DESCRIPCION,om.id_oferta) as matsis
    on matsis.id_oferta= o.id_oferta and matsis.IDENTIFICACION=p.identificacion
left join (
    select clms.NOMBRE,dm.id_movilidad,p.IDENTIFICACION,cast(min(mo.fecha_ingreso) as date) as fecha_convalidacion,om.id_oferta,sm.descripcion
    from  Bd_Academico.mov.detalle_movilidad dm
    INNER JOIN Bd_Academico.mov.movilidad mo ON mo.id = dm.id_movilidad
    inner join Bd_Academico.mov.subtipo_movilidad sm on mo.id_subtipo_movilidad = sm.id
    inner join Bd_Academico..PERSONAS p on p.ID_PERSONA = mo.id_persona
    inner join Bd_Academico..MATERIAS_PLAN mp on mp.ID_MATERIA_PLAN = dm.id_materia_plan
    inner join Bd_Academico..CARRERAS_LOCALES_MODALIDAD_SISTEMA clms on clms.ID_CARRERA_LOCAL = mp.ID_CARRERA_LOCAL
    inner join migracion_sga..registros_migracion rm on rm.id_origen = clms.ID_CARRERA_OFERTADA and rm.id_entidad_relacion=2
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = rm.id_destino
    where --p.IDENTIFICACION in ('0917513863') and
          dm.estado='A' and mo.estado='A' --and sm.id not in(3)
    group by clms.NOMBRE, dm.id_movilidad, p.IDENTIFICACION, om.id_oferta, sm.descripcion
) as consis on consis.id_oferta=o.id_oferta and consis.IDENTIFICACION = p.identificacion
inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
inner join man.departamentos d on d.id= do.id_departamento
inner join aca.campus c on c.id_campus = o.id_campus
 where p.estado='AC' and eo.estado='A' and om.estado='A' and em.estado = 'A' and tee.codigo in ('ACT','OFR','APR')
 and  mg.id_periodo_academico in (27,30) and p.id_tipo_identificacion = 1
group by pa.codigo,o.descripcion,o.codigo_ces,o.descripcion,c.descripcion,te.descripcion,p.id,p.identificacion,p.apellidos,p.nombres,p.sexo,p.fecha_nace,
          p.id_pais_nacionalidad,pn.descripcion,p.id_discapacidad,dis.descripcion,p.porcentaje_dis,p.id_etnia,e.descripcion,p.id_nacionalidad,nac.descripcion,
    p.direccion,p.email_personal,p.email_institucional,m.fecha_desde,p.id_pais_residencia,pr.descripcion,p.id_provincia_residencia,pror.descripcion,
    p.id_canton_residencia,cr.descripcion,p.celular,p.num_carnet_conadis,pan.id_periodo_academico , p.apellido_paterno,
    p.apellido_materno, movi.fecha_ingreso, mat1.fecha_ing,matsis.fechaMatriculaPrimerSemestre,consis.fecha_convalidacion,
    mat1.fecha_desde,matsis.fechaPrimerSemestre
--     tte.id_tipo_institucion,tte.descripcion,aux.Politicas_cuotas
--  order by o.descripcion,p.apellido_paterno,p.apellido_materno,p.nombres
    ) as d
order by d.NOMBRE_CARRERA,d.PRIMER_APELLIDO,d.SEGUNDO_APELLIDO,d.NOMBRES

--MATRIZ MATRICULA PERIODOS v2025
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
                               where ma1.estado='A' and (d.periodo not in ('2024-2','2025-1') --and ( d.idPeriodoAcademico = @id_periodo_academico and d.origen<>'SGA' )
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
        where ma1.estado='A' and (d.periodo not in ('2024-2','2025-1')
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
    where p.estado='AC' and eo.estado='A' and om.estado='A' and em.estado = 'A' and tee.codigo in ('ACT','OFR','APR')
      and p.identificacion not in ('2450035569')
    and  mg.id_periodo_academico in (@id_periodo_academico)
    group by pa.codigo,o.descripcion,o.codigo_ces,o.descripcion,c.descripcion,te.descripcion,p.id,p.identificacion,p.apellidos,p.nombres, p.apellido_paterno,
    p.apellido_materno,eo.mantiene_gratuidad,eo.id_estudiante_oferta,mat.creditos,mat.horas,mat.terceras_matriculas,mat.segundas_matriculas,tm.descripcion
    ,mat.creditos_aprobados,mat.horas_aprobadas
    ) as d
--     where d.CREDITOS_APROBADOS<>TOTAL_CREDITOS_APROBADOS
    order by d.NOMBRE_CARRERA,d.NOMBRES_APELLIDOS
end


--MATRIZ MATRICULA ESTUDIANTES V2025
begin
    declare @id_periodo_academico_grado int = 36,@id_periodo_academico_niv int = 38
--     select d.*
select distinct d.PERIODO_ACADEMICO,d.CODIGO_IES, CODIGO_CARRERA, CARRERA, CIUDAD_CARRERA, TIPO_IDENTIFICACION, IDENTIFICACION, APELLIDOS_NOMBRES,
    SEXO, FECHA_NACIMIENTO, PAIS_ORIGEN, DISCAPACIDAD, PORCENTAJE_DISCAPACIDAD, NUMERO_CONADIS, ETNIA, NACIONALIDAD, EMAIL_INSTITUCIONAL,FECHA_INICIO_PRIMER_NIVEL,
    iif(FECHA_INGRESO_CONVALIDACION='' and FECHA_INICIO_PRIMER_NIVEL='',FECHA_TRANSICION_CURRICULAR,FECHA_INGRESO_CONVALIDACION) as FECHA_INGRESO_CONVALIDACION
                    ,FECHA_TRANSICION_CURRICULAR,PAIS_RESIDENCIA, PROVINCIA_RESIDENCIA, CANTON_RESIDENCIA, TIPO_COLEGIO, POLITICA_CUOTA,MODALIDAD_ESTUDIO
-- ,tipo_ingreso,estado_cupo
--               ,id_estudiante_oferta,id_estudiante_oferta_padre,fecha_desde
    from (
select distinct pa.codigo as PERIODO_ACADEMICO,
                1023 as CODIGO_IES,o.codigo_ces as CODIGO_CARRERA,o.descripcion as CARRERA,c.descripcion as CIUDAD_CARRERA,
    ti.descripcion as TIPO_IDENTIFICACION,p.identificacion AS IDENTIFICACION,
    concat(p.apellidos,' ',p.nombres) as APELLIDOS_NOMBRES,
    iif(p.sexo='M','HOMBRE','MUJER') as SEXO,CONVERT(VARCHAR(10),p.fecha_nace, 103) as FECHA_NACIMIENTO, iif(p.id_pais_nacionalidad is null,'NO REGISTRA',pn.descripcion) as PAIS_ORIGEN,
    iif(p.id_discapacidad is null,'NINGUNA',dis.descripcion) as DISCAPACIDAD,
    iif(p.id_discapacidad is null or p.id_discapacidad='' or p.porcentaje_dis is null,0,p.porcentaje_dis) as PORCENTAJE_DISCAPACIDAD,
    iif(p.num_carnet_conadis is null or p.num_carnet_conadis='' or p.num_carnet_conadis='0','NO APLICA',p.num_carnet_conadis) as NUMERO_CONADIS,
    iif(p.id_etnia is null,'NO REGISTRA',e.descripcion) as ETNIA,
    iif(e.descripcion='INDIGENA',isnull(nac.descripcion,'NO REGISTRA'),'NO APLICA') as NACIONALIDAD,
    iif(p.email_institucional is null,'NO REGISTRA',p.email_institucional) as EMAIL_INSTITUCIONAL,
        iif(tie.codigo in ('MOV-EXT','MOV','MOV-INTER','RESIDENIO-CARRERA'),'',
             ISNULL( FORMAT(COALESCE(mat1.fecha_desde, sis.fecha_desde,sis2.fecha_desde,sis3.fecha_desde,sis4.fecha_desde), 'yyyy-MM-dd'),'')) as FECHA_INICIO_PRIMER_NIVEL,
--                 mat1.fecha_desde as fecha_mat1,sis.fecha_desde as fecha_mat2,sis1.fecha_desde as fecha_sis1,
--                 case when tie.codigo in ('MOV-EXT','MOV','MOV-INTER') then cast(eo.fecha_desde as varchar(15))  else  isnull(cast(eop.fecha_desde as varchar(10)),'NO APLICA') end as FECHA_INGRESO_CONVALIDACION,
        case when tie.codigo in ('MOV-EXT','MOV','MOV-INTER','RESIDENIO-CARRERA') then FORMAT(COALESCE(movi.fecha_desde,movi1.fecha_desde, pao.fecha_desde), 'yyyy-MM-dd')  else  '' end as FECHA_INGRESO_CONVALIDACION,
        case when tie.codigo in ('REDISENIO-SEDE','CAMBIO-MALLA','RESIDENIO-CARRERA','REDISENIO-SIS-EST','REDISENIO-REV-NORM','RESIDENIO-MODALIDAD') then
--             cast(isnull(movi.fecha_ingreso,pao.fecha_desde) as varchar(10)) else '' end as FECHA_TRANSICION_CURRICULAR
                 FORMAT(COALESCE(movi.fecha_desde,movi1.fecha_desde, pao.fecha_desde), 'yyyy-MM-dd') else '' end as FECHA_TRANSICION_CURRICULAR
        ,eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.fecha_desde as fecha_desde_eo,eop.fecha_desde as fecha_desde_eop
        ,tee.descripcion as estado_cupo,tie.descripcion as tipo_ingreso,te.descripcion as tipo_estudiante
    ,iif(p.id_pais_residencia is null,'NO REGISTRA',pr.descripcion) as PAIS_RESIDENCIA,
    iif(p.id_provincia_residencia is null,'NO APLICA',pror.descripcion) as PROVINCIA_RESIDENCIA,
    iif(p.id_canton_residencia is null,'NO APLICA',cr.descripcion) as CANTON_RESIDENCIA,
    isnull((select  TOP 1 tte.descripcion from man.informacion_academica_persona iap
           inner join aca.institucion ins on ins.id_institucion = iap.id_institucion
           inner join aca.tipo_institucion tte on tte.id_tipo_institucion = ins.id_tipo_institucion
           where iap.id_nivel_formacion =2 and iap.estado='A' and iap.id_persona=p.id
           order by iap.id_informacion_academica_persona
    ),'NO REGISTRA')as TIPO_COLEGIO,
    isnull((select top 1 coalesce((SELECT MAX( CASE
                                                      WHEN AC.codigo_acciones_afirmativas = 'CONDICION_SOCIOECONOMICA' THEN AC.descripcion
                                                      WHEN AC.codigo_acciones_afirmativas = 'DISCAPACIDAD' THEN AC.descripcion
                                                      WHEN AC.codigo_acciones_afirmativas = 'PUEBLOS_NACIONALIDADES' THEN AC.descripcion ELSE 'OTRAS' END
                                             ) AS ASIGNADO_CUPO
                                      FROM niv.inscripcion_acciones_afirmativas iaff
                                    INNER JOIN niv.acciones_afirmativa ac ON ac.id_acciones_afirmativas = iaff.id_acciones_afirmativas
                                    WHERE iaff.estado = 'A' AND ac.estado = 'A'AND iaff.id_inscripcion = i.id_inscripcion_nivelacion
                                  ) ,'NINGUNA')as Politicas_cuotas
            from niv.inscripcion_nivelacion i
            inner join man.personas p1 on p1.id=i.id_persona
            where i.estado='A' and p1.estado='AC' and i.id_periodo_academico in (@id_periodo_academico_niv)
            and i.id_periodo_academico = @id_periodo_academico_niv and p1.identificacion = p.identificacion
            order by i.id_periodo_academico desc),'NINGUNA') as POLITICA_CUOTA,m.descripcion as MODALIDAD_ESTUDIO
from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.periodo_academico pao on pao.id_periodo_academico = eo.id_periodo_academico
left join aca.estudiante_oferta eop on eop.id_estudiante_oferta = eo.id_estudiante_oferta_padre
inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
inner join man.tipo_identificacion ti on ti.id_tipo_identificacion = p.id_tipo_identificacion
left join man.nacionalidad_indigena nac on nac.id_nacionalidad_indigena = p.id_nacionalidad_indigena and nac.estado='A'
left join man.lugar pn on pn.id_lugar = p.id_pais_nacionalidad and pn.estado='A'
left join man.discapacidad dis on dis.id_discapacidad = p.id_discapacidad and dis.estado='A'
left join man.etnia e on e.id_etnia = p.id_etnia and e.estado='A'
left join man.lugar pr on pr.id_lugar = p.id_pais_residencia
left join man.lugar pror on pror.id_lugar = p.id_provincia_residencia
left join man.lugar cr on cr.id_lugar = p.id_canton_residencia
inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join aca.modalidad m on om.id_modalidad = m.id_modalidad
inner join aca.oferta o on o.id_oferta = om.id_oferta
inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
inner join man.departamentos d on d.id= do.id_departamento
inner join aca.campus c on c.id_campus = o.id_campus
--primer semestre carrera sga
left join (
    select min(pa1.fecha_desde) as fecha_desde,min(ea1.fecha_ing) as fecha_ing,min(em1.id_estudiante_oferta) as id_estudiante_oferta,eo1.id_persona,om1.id_oferta from aca.estudiante_matricula em1
    inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
    inner join aca.periodo_academico pa1 on mg1.id_periodo_academico = pa1.id_periodo_academico
    inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
    inner join aca.oferta_modalidad om1 on eo1.id_oferta_modalidad = om1.id_oferta_modalidad
    inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
    inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
    inner join aca.malla_asignatura ma1 on aa1.id_malla_asignatura = ma1.id_malla_asignatura
    where em1.estado='A' and ea1.estado='A' and aa1.estado='A' and ma1.estado='A' and ma1.id_nivel = 1
    group by eo1.id_persona,om1.id_oferta
) as mat1 on --mat1.id_estudiante_oferta = eo.id_estudiante_oferta
    mat1.id_persona = p.id and mat1.id_oferta = o.id_oferta
--primer semestre sisweb
left join (
    select min(pa.fecha_desde) as fecha_desde,min(rm.fecha_matricula) as fecha_ing,min(ro.id_estudiante_oferta) as id_estudiante_oferta,eo.id_persona from mig.record_oferta ro
    inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_estudiante_oferta
    inner join mig .record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
    inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
    inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
    where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A'
    group by eo.id_persona
) as sis on sis.id_estudiante_oferta = eo.id_estudiante_oferta
left join (
    select min(pa.fecha_desde) as fecha_desde,min(rm.fecha_matricula) as fecha_ing,min(ro.id_estudiante_oferta) as id_estudiante_oferta,eo.id_persona
    from mig.record_oferta ro
             inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_estudiante_oferta
             inner join mig.record_oferta rod on rod.id_record_oferta = ro.id_record_oferta_padre
             inner join mig.record_matricula rm on rod.id_record_oferta = rm.id_record_oferta
             inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
             inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
    where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A' and rod.estado='A' and rod.id_tipo_oferta = 2
--       and ro.id_estudiante_oferta = 5994
    group by eo.id_persona
) as sis2 on sis2.id_estudiante_oferta = eo.id_estudiante_oferta
left join (
    select min(pa.fecha_desde) as fecha_desde,min(rm.fecha_matricula) as fecha_ing,ro.id_estudiante_oferta_destino as id_estudiante_oferta,eo.id_persona from mig.record_oferta ro
    inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_estudiante_oferta_destino
    inner join mig .record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
    inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
    inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
    where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A'
    group by eo.id_persona,ro.id_estudiante_oferta_destino
) as sis3 on sis3.id_estudiante_oferta = eo.id_estudiante_oferta
left join (
    select min(pa.fecha_desde) as fecha_desde,min(ra.fecha_registro) as fecha_ing,ro.id_estudiante_oferta_destino as id_estudiante_oferta,eo.id_persona
    from mig.record_oferta ro
             inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_estudiante_oferta_destino
             inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
             inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
    where  ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A'
    group by eo.id_persona,ro.id_estudiante_oferta_destino
) as sis4 on sis4.id_estudiante_oferta = eo.id_estudiante_oferta
left join (
    select eo1.id_estudiante_oferta,min(pa.fecha_desde) as fecha_desde from aca.movilidad mov1
    inner join aca.periodo_academico pa on mov1.id_periodo_academico = pa.id_periodo_academico
    inner join aca.estudiante_oferta eo1 on mov1.id_estudiante_oferta = eo1.id_estudiante_oferta
    where mov1.estado='A'
    group by eo1.id_estudiante_oferta
) as movi on movi.id_estudiante_oferta= eo.id_estudiante_oferta
left join (
    select min(pa.fecha_desde) as fecha_desde,min(ra.fecha_registro) as fecha_ing,ro.id_estudiante_oferta as id_estudiante_oferta
--        pa.fecha_desde as fecha_desde,ra.fecha_registro as fecha_ing,ro.id_estudiante_oferta_destino as id_estudiante_oferta,ra.tipo
    from mig.record_oferta ro
             inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
             inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
    where  ra.estado<>'I' and ro.estado='A' --and ro.id_estudiante_oferta = 9786
      and ra.tipo in ('MOVILIDAD A 8 SEMESTRES - HOM AA','MOVILIDAD A 8 SEMESTRES - HOM VC','MOVILIDAD A 8 SEMESTRES - RECON. CC','MOVILIDAD A 8 SEMESTRES - RECON. TRANSIC.','MOVILIDAD AGROPECUARIA SIN MATRICULA - HOM AA')
    group by ro.id_estudiante_oferta
) as movi1 on movi1.id_estudiante_oferta= eo.id_estudiante_oferta
where p.estado='AC' and eo.estado='A' and em.estado = 'A'
--     and p.identificacion in ('2400260556','1316258183','2450232521','2450715053')
    and p.identificacion not in ('2450035569')
--and ea.estado='A'--and tee.codigo in ('ACT','OFR','APR')
 and  mg.id_periodo_academico in (@id_periodo_academico_grado) and p.id_tipo_identificacion = 1
group by pa.codigo,o.descripcion,o.codigo_ces,o.descripcion,c.descripcion,ti.descripcion,p.id,p.identificacion,p.apellidos,p.nombres,p.sexo,p.fecha_nace,
    p.id_pais_nacionalidad,pn.descripcion,p.id_discapacidad,dis.descripcion,p.porcentaje_dis,p.id_etnia,e.descripcion,p.id_nacionalidad,nac.descripcion,
    p.direccion,p.email_personal,p.email_institucional,p.id_pais_residencia,pr.descripcion,p.id_provincia_residencia,pror.descripcion,
    p.id_canton_residencia,cr.descripcion,p.celular,p.num_carnet_conadis,tie.codigo
    ,tee.descripcion,tie.descripcion,te.descripcion
     ,mat1.fecha_desde,sis.fecha_desde,--sis1.fecha_desde,
      sis2.fecha_desde,sis3.fecha_desde,sis4.fecha_desde
        ,eo.fecha_desde,eop.fecha_desde,eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,pao.fecha_desde,movi.fecha_desde,movi1.fecha_desde,m.descripcion
    ) as d
--     inner join man.personas p on p.identificacion = d.IDENTIFICACION
order by d.CARRERA,d.APELLIDOS_NOMBRES
end

--MATRIZ ESTUDIANTES PASAPORTE V2025
begin
        declare @id_periodo_academico_grado int = 36,@id_periodo_academico_niv int = 38
    --     select d.*
    select distinct d.PERIODO_ACADEMICO,d.CODIGO_IES, CODIGO_CARRERA, CARRERA, CIUDAD_CARRERA, TIPO_IDENTIFICACION, IDENTIFICACION,PRIMER_APELLIDO,SEGUNDO_APELLIDO,NOMBRES,
                    SEXO, FECHA_NACIMIENTO, PAIS_ORIGEN, DISCAPACIDAD, PORCENTAJE_DISCAPACIDAD, NUMERO_CONADIS, ETNIA, NACIONALIDAD, EMAIL_INSTITUCIONAL,
        FECHA_INICIO_PRIMER_NIVEL, FECHA_INGRESO_CONVALIDACION,FECHA_TRANSICION_CURRICULAR
        ,PAIS_RESIDENCIA, PROVINCIA_RESIDENCIA, CANTON_RESIDENCIA, TIPO_COLEGIO, POLITICA_CUOTA
        from (
    select distinct pa.codigo as PERIODO_ACADEMICO,
                    1023 as CODIGO_IES,o.codigo_ces as CODIGO_CARRERA,o.descripcion as CARRERA,c.descripcion as CIUDAD_CARRERA,
        ti.descripcion as TIPO_IDENTIFICACION,p.identificacion AS IDENTIFICACION,
        P.apellido_paterno as PRIMER_APELLIDO,p.apellido_materno as SEGUNDO_APELLIDO ,p.nombres as NOMBRES,
        iif(p.sexo='M','HOMBRE','MUJER') as SEXO,CONVERT(VARCHAR(10),p.fecha_nace, 103) as FECHA_NACIMIENTO, iif(p.id_pais_nacionalidad is null,'NO REGISTRA',pn.descripcion) as PAIS_ORIGEN,
        iif(p.id_discapacidad is null,'NINGUNA',dis.descripcion) as DISCAPACIDAD,
        iif(p.id_discapacidad is null or p.id_discapacidad='' or p.porcentaje_dis is null,0,p.porcentaje_dis) as PORCENTAJE_DISCAPACIDAD,
        iif(p.num_carnet_conadis is null or p.num_carnet_conadis='' or p.num_carnet_conadis='0','NO APLICA',p.num_carnet_conadis) as NUMERO_CONADIS,
        iif(p.id_etnia is null,'NO REGISTRA',e.descripcion) as ETNIA,iif(p.id_nacionalidad is null,'NO REGISTRA',nac.descripcion) as NACIONALIDAD,
        iif(p.email_institucional is null,'NO REGISTRA',p.email_institucional) as EMAIL_INSTITUCIONAL,
            ISNULL( FORMAT(COALESCE(mat1.fecha_desde, sis.fecha_desde,sis1.fecha_desde), 'yyyy-MM-dd'),'NO APLICA') as FECHA_INICIO_PRIMER_NIVEL,
            case when tie.codigo in ('MOV-EXT','MOV','MOV-INTER') then cast(eo.fecha_desde as varchar(15)) else 'NO APLICA' end as FECHA_INGRESO_CONVALIDACION,
            case when tie.codigo in ('REDISENIO-SEDE','CAMBIO-MALLA','RESIDENIO-CARRERA','REDISENIO-SIS-EST','REDISENIO-REV-NORM','RESIDENIO-MODALIDAD') then
                cast(eo.fecha_desde as varchar(15)) else 'NO APLICA' end as FECHA_TRANSICION_CURRICULAR
            ,tee.descripcion as estado_cupo,tie.descripcion as tipo_ingreso,te.descripcion as tipo_estudiante,eo.id_estudiante_oferta
        ,iif(p.id_pais_residencia is null,'NO REGISTRA',pr.descripcion) as PAIS_RESIDENCIA,
        iif(p.id_provincia_residencia is null,'NO APLICA',pror.descripcion) as PROVINCIA_RESIDENCIA,
        iif(p.id_canton_residencia is null,'NO APLICA',cr.descripcion) as CANTON_RESIDENCIA,
        isnull((select  TOP 1 tte.descripcion from man.informacion_academica_persona iap
               inner join aca.institucion ins on ins.id_institucion = iap.id_institucion
               inner join aca.tipo_institucion tte on tte.id_tipo_institucion = ins.id_tipo_institucion
               where iap.id_nivel_formacion =2 and iap.estado='A' and iap.id_persona=p.id
               order by iap.id_informacion_academica_persona
        ),'NO REGISTRA')as TIPO_COLEGIO,
        isnull((select top 1 coalesce((SELECT MAX( CASE
                                                          WHEN AC.codigo_acciones_afirmativas = 'CONDICION_SOCIOECONOMICA' THEN AC.descripcion
                                                          WHEN AC.codigo_acciones_afirmativas = 'DISCAPACIDAD' THEN AC.descripcion
                                                          WHEN AC.codigo_acciones_afirmativas = 'PUEBLOS_NACIONALIDADES' THEN AC.descripcion ELSE 'OTRAS' END
                                                 ) AS ASIGNADO_CUPO
                                          FROM niv.inscripcion_acciones_afirmativas iaff
                                        INNER JOIN niv.acciones_afirmativa ac ON ac.id_acciones_afirmativas = iaff.id_acciones_afirmativas
                                        WHERE iaff.estado = 'A' AND ac.estado = 'A'AND iaff.id_inscripcion = i.id_inscripcion_nivelacion
                                      ) ,'NINGUNA')as Politicas_cuotas
                from niv.inscripcion_nivelacion i
                inner join man.personas p1 on p1.id=i.id_persona
                where i.estado='A' and p1.estado='AC' and i.id_periodo_academico in (@id_periodo_academico_niv)
                and i.id_periodo_academico = @id_periodo_academico_niv and p1.identificacion = p.identificacion
                order by i.id_periodo_academico desc),'NINGUNA') as POLITICA_CUOTA
    from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.malla m on m.id_malla = eo.id_malla
    inner join man.tipo_identificacion ti on ti.id_tipo_identificacion = p.id_tipo_identificacion
    left join man.nacionalidad nac on nac.id_nacionalidad = p.id_nacionalidad and nac.estado='A'
    left join man.lugar pn on pn.id_lugar = p.id_pais_nacionalidad and pn.estado='A'
    left join man.discapacidad dis on dis.id_discapacidad = p.id_discapacidad and dis.estado='A'
    left join man.etnia e on e.id_etnia = p.id_etnia and e.estado='A'
    left join man.lugar pr on pr.id_lugar = p.id_pais_residencia
    left join man.lugar pror on pror.id_lugar = p.id_provincia_residencia
    left join man.lugar cr on cr.id_lugar = p.id_canton_residencia
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
    inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
    inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.oferta o on o.id_oferta = om.id_oferta
    inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
    inner join man.departamentos d on d.id= do.id_departamento
    inner join aca.campus c on c.id_campus = o.id_campus
    --primer semestre carrera sga
    left join (
        select min(pa1.fecha_desde) as fecha_desde,min(ea1.fecha_ing) as fecha_ing,min(em1.id_estudiante_oferta) as id_estudiante_oferta,eo1.id_persona,om1.id_oferta from aca.estudiante_matricula em1
        inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
        inner join aca.periodo_academico pa1 on mg1.id_periodo_academico = pa1.id_periodo_academico
        inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
        inner join aca.oferta_modalidad om1 on eo1.id_oferta_modalidad = om1.id_oferta_modalidad
        inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
        inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
        inner join aca.malla_asignatura ma1 on aa1.id_malla_asignatura = ma1.id_malla_asignatura
        where em1.estado='A' and ea1.estado='A' and aa1.estado='A' and ma1.estado='A' and ma1.id_nivel = 1
        group by eo1.id_persona,om1.id_oferta
    ) as mat1 on --mat1.id_estudiante_oferta = eo.id_estudiante_oferta
        mat1.id_persona = p.id and mat1.id_oferta = o.id_oferta
    --primer semestre sisweb
    left join (
        select min(pa.fecha_desde) as fecha_desde,min(rm.fecha_matricula) as fecha_ing,min(ro.id_estudiante_oferta) as id_estudiante_oferta,eo.id_persona from mig.record_oferta ro
        inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_estudiante_oferta
        inner join mig .record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
        inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
        inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A'
        group by eo.id_persona
    ) as sis on sis.id_estudiante_oferta = eo.id_estudiante_oferta
    left join (
        select min(pa.fecha_desde) as fecha_desde,min(rm.fecha_matricula) as fecha_ing,min(ro.id_estudiante_oferta) as id_estudiante_oferta,eo.id_persona from mig.record_oferta ro
        inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_estudiante_oferta
        inner join mig .record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
        inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
        inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A'
        group by eo.id_persona
    ) as sis1 on sis1.id_estudiante_oferta = eo.id_estudiante_oferta_padre
    where p.estado='AC' and eo.estado='A' and om.estado='A' and em.estado = 'A' --and ea.estado='A'--and tee.codigo in ('ACT','OFR','APR')
     and  mg.id_periodo_academico in (@id_periodo_academico_grado) and p.id_tipo_identificacion = 2
    group by pa.codigo,o.descripcion,o.codigo_ces,o.descripcion,c.descripcion,ti.descripcion,p.id,p.identificacion,p.apellidos,p.nombres,p.sexo,p.fecha_nace,
              p.id_pais_nacionalidad,pn.descripcion,p.id_discapacidad,dis.descripcion,p.porcentaje_dis,p.id_etnia,e.descripcion,p.id_nacionalidad,nac.descripcion,
        p.direccion,p.email_personal,p.email_institucional,m.fecha_desde,p.id_pais_residencia,pr.descripcion,p.id_provincia_residencia,pror.descripcion,
        p.id_canton_residencia,cr.descripcion,p.celular,p.num_carnet_conadis
    --     tte.id_tipo_institucion,tte.descripcion,aux.Politicas_cuotas
        ,tee.descripcion,tie.descripcion,te.descripcion,eo.id_estudiante_oferta,mat1.fecha_desde,sis.fecha_desde,sis1.fecha_desde,tie.codigo,eo.fecha_desde,p.apellido_paterno,p.apellido_materno
    --  order by o.descripcion,p.apellido_paterno,p.apellido_materno,p.nombres
        ) as d
    --     inner join man.personas p on p.identificacion = d.IDENTIFICACION
    order by d.CARRERA,d.PRIMER_APELLIDO,d.SEGUNDO_APELLIDO,d.NOMBRES
end

--MATRIZ MATRICULA PERIODOS v2026

BEGIN

    DECLARE @id_periodo_academico INT = 96;
    IF OBJECT_ID('tempdb..#record') IS NOT NULL
        DROP TABLE #record;

    IF OBJECT_ID('tempdb..#totales') IS NOT NULL
        DROP TABLE #totales;
    -- =========================================
-- 1. TRAER RECORD ACADÉMICO (UNA SOLA VEZ)
-- =========================================
    SELECT
        eo.id_estudiante_oferta,
        f.id_malla_asignatura,
        f.periodo
    INTO #record
    FROM aca.estudiante_oferta eo
    inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
    inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
             CROSS APPLY aca.fn_record_academico_sga_inline(eo.id_estudiante_oferta, NULL, NULL, 1) f
    where em.estado='A' and mg.id_periodo_academico=@id_periodo_academico;


    -- =========================================
-- 2. CALCULAR TOTALES (CRÉDITOS / HORAS)
-- =========================================
    SELECT
        r.id_estudiante_oferta,
        SUM(ma.num_creditos) AS TOTAL_CREDITOS_APROBADOS,
        SUM(ma.num_horas) AS TOTAL_HORAS_APROBADAS
    INTO #totales
    FROM #record r
    INNER JOIN aca.malla_asignatura ma
                        ON ma.id_malla_asignatura = r.id_malla_asignatura
    WHERE ma.estado = 'A' and  r.periodo <= (select codigo from aca.periodo_academico where id_periodo_academico = @id_periodo_academico)
    GROUP BY r.id_estudiante_oferta;


    -- =========================================
-- 3. MATRÍCULA (YA OPTIMIZADO)
-- =========================================
    WITH mat AS (
        SELECT
            em1.id_estudiante_oferta,
            COUNT(CASE WHEN ea1.codigo_estado_matricula = 'SEG' THEN 1 END) AS segundas_matriculas,
            COUNT(CASE WHEN ea1.codigo_estado_matricula = 'TER' THEN 1 END) AS terceras_matriculas,
            SUM(CASE WHEN ISNULL(ea1.aprobado, 0) = 1 THEN ma1.num_creditos ELSE 0 END) AS creditos_aprobados,
            SUM(CASE WHEN ISNULL(ea1.aprobado, 0) = 1 THEN ma1.num_horas ELSE 0 END) AS horas_aprobadas
        FROM aca.estudiante_matricula em1
        INNER JOIN aca.estudiante_asignatura ea1 ON em1.id_estudiante_matricula = ea1.id_estudiante_matricula
        INNER JOIN aca.asignatura_aprendizaje aa1    ON aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
        INNER JOIN aca.malla_asignatura ma1 ON aa1.id_malla_asignatura = ma1.id_malla_asignatura
        INNER JOIN aca.matricula_general mg1 ON em1.id_matricula_general = mg1.id_matricula_general
        WHERE em1.estado='A'
          AND ea1.estado='A'
          AND aa1.estado='A'
          AND ma1.estado='A'
          AND mg1.estado='A'
          AND mg1.id_periodo_academico = @id_periodo_academico
        GROUP BY em1.id_estudiante_oferta
    )
    -- =========================================
-- 4. QUERY FINAL
-- =========================================
    SELECT
        pa.codigo AS PERIODO_ACADEMICO,
        1023 AS CODIGO_IES,
--         eo.id_estudiante_oferta,
        o.codigo_ces AS CODIGO_CARRERA,
        om.carrera AS NOMBRE_CARRERA,
        om.sedeCorta AS CIUDAD_CARRERA,
        te.descripcion AS TIPO_IDENTIFICACION,
        p.identificacion,
        CONCAT(p.apellidos,' ',p.nombres) AS APELLIDOS_NOMBRES,
        ISNULL(t.TOTAL_CREDITOS_APROBADOS,0) AS TOTAL_CREDITOS_APROBADOS,
        ISNULL(m.creditos_aprobados,0) AS CREDITOS_APROBADOS,
        tm.descripcion AS TIPO_MATRICULA,em.id_paralelo as PARALELO, em.id_nivel as NIVEL_ACADEMICO,
        ISNULL(m.segundas_matriculas,0) AS NUM_MATERIAS_SEGUNDA_MATRICULA,
        ISNULL(m.terceras_matriculas,0) AS NUM_MATERIAS_TERCERA_MATRICULA,
        IIF(eo.mantiene_gratuidad=0,'SI','NO') AS PERDIDA_GRATUIDAD,
        ISNULL(t.TOTAL_HORAS_APROBADAS,0) AS TOTAL_HORAS_APROBADAS,
        ISNULL(m.horas_aprobadas,0) AS HORAS_APROBADAS_PERIODO,
        0 AS MONTO_AYUDA_ECONOMICA,0 AS MONTO_CREDITO_EDUCATIVO,
        IIF(tie.codigo in ('MOV', 'CAMBIO-MALLA', 'REDISENIO-SEDE', 'RESIDENIO-CARRERA', 'RESIDENIO-MODALIDAD') and eo.id_periodo_academico =  @id_periodo_academico, 'CAMBIO','NO APLICA')   as ESTADO,
        CASE WHEN tie.codigo in ('MOV') and eo.id_periodo_academico =  @id_periodo_academico then 'CAMBIO CARRERA'
            when tie.codigo in ('REDISENIO-SEDE') and eo.id_periodo_academico =  @id_periodo_academico then 'CAMBIO SEDE'
             WHEN tie.codigo in ('CAMBIO-MALLA','RESIDENIO-CARRERA','RESIDENIO-MODALIDAD') and eo.id_periodo_academico =  @id_periodo_academico then 'REDISEÑO' else 'NO APLICA'  end AS MOTIVO, '' AS FECHA_RETIRO

    FROM man.personas p
    INNER JOIN aca.estudiante_oferta eo ON eo.id_persona = p.id
    INNER JOIN aca.malla malla ON malla.id_malla = eo.id_malla
    INNER JOIN man.tipo_identificacion te  ON te.id_tipo_identificacion = p.id_tipo_identificacion
    INNER JOIN aca.tipo_estado_estudiante tee   ON tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    INNER JOIN aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
    INNER JOIN aca.estudiante_matricula em ON em.id_estudiante_oferta = eo.id_estudiante_oferta
    INNER JOIN aca.tipo_matricula tm ON em.id_tipo_matricula = tm.id_tipo_matricula
    INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = em.id_matricula_general
    INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = mg.id_periodo_academico
    INNER JOIN aca.ofertas_facultad om  ON om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.oferta o on o.id_oferta = om.id_oferta
    LEFT JOIN mat m  ON m.id_estudiante_oferta = eo.id_estudiante_oferta
    LEFT JOIN #totales t ON t.id_estudiante_oferta = eo.id_estudiante_oferta
    WHERE p.estado='AC'
      AND eo.estado='A'
      AND em.estado='A'
--       AND tee.codigo IN ('ACT','OFR','APR')
      AND mg.id_periodo_academico = @id_periodo_academico
    ORDER BY om.carrera, APELLIDOS_NOMBRES;

END
-- 0924274459
-- 0922451208
-- 0916033624
-- 1803732583
-- 0928356187

--15273
--MATRIZ ESTUDIANTES V2026
begin
    declare @id_periodo_academico_grado int = 95,@id_periodo_academico_niv int = 126
--     select d.*
select d.PERIODO_ACADEMICO,d.CODIGO_IES, CODIGO_CARRERA, CARRERA, CIUDAD_CARRERA, TIPO_IDENTIFICACION, IDENTIFICACION, APELLIDOS_NOMBRES,
                case when GENERO='Femenino' and SEXO='HOMBRE' then 'MASCULINO'
                     when GENERO='Masculino' and SEXO='MUJER' then 'FEMENINO'
                     when GENERO='Otro' then 'NO DISPONE'
                     when GENERO='No sabe / No responde' OR GENERO='Prefiere no contestar' then 'NO SABE/NO RESPONDE'
                     when GENERO='Trans femenina' then 'TRANSFEMENINA'
                     when GENERO='Trans masculino' then 'TRANSMASCULINO' ELSE upper(GENERO) end as GENERO,
    SEXO, FECHA_NACIMIENTO, PAIS_ORIGEN, DISCAPACIDAD, PORCENTAJE_DISCAPACIDAD, NUMERO_CONADIS, ETNIA, NACIONALIDAD, EMAIL_INSTITUCIONAL,FECHA_INICIO_PRIMER_NIVEL,
    iif(FECHA_INGRESO_CONVALIDACION='' and FECHA_INICIO_PRIMER_NIVEL='',FECHA_TRANSICION_CURRICULAR,FECHA_INGRESO_CONVALIDACION) as FECHA_INGRESO_CONVALIDACION
                    ,FECHA_TRANSICION_CURRICULAR,PAIS_RESIDENCIA, PROVINCIA_RESIDENCIA, CANTON_RESIDENCIA, TIPO_COLEGIO, POLITICA_CUOTA,MODALIDAD_ESTUDIO--,rn
-- ,tipo_ingreso,estado_cupo
              ,id_estudiante_oferta
    from (
    select pa.codigo as PERIODO_ACADEMICO,
                    1023 as CODIGO_IES,o.codigo_ces as CODIGO_CARRERA,o.descripcion as CARRERA,c.descripcion_corta as CIUDAD_CARRERA,
        ti.descripcion as TIPO_IDENTIFICACION,p.identificacion AS IDENTIFICACION,
        concat(p.apellidos,' ',p.nombres) as APELLIDOS_NOMBRES,
        iif(p.sexo='M','HOMBRE','MUJER') as SEXO, FORMAT(p.fecha_nace, 'dd/MM/yyyy') as FECHA_NACIMIENTO, iif(p.id_pais_nacionalidad is null,'NO REGISTRA',pn.descripcion) as PAIS_ORIGEN,
        iif(p.id_discapacidad is null,'NINGUNA',dis.descripcion) as DISCAPACIDAD,
        iif(p.id_discapacidad is null or p.id_discapacidad='' or p.porcentaje_dis is null,0,p.porcentaje_dis) as PORCENTAJE_DISCAPACIDAD,
        iif(p.num_carnet_conadis is null or p.num_carnet_conadis='' or p.num_carnet_conadis='0','NO APLICA',p.num_carnet_conadis) as NUMERO_CONADIS,
        iif(p.id_etnia is null,'NO REGISTRA',e.descripcion) as ETNIA,
        iif(e.descripcion='INDIGENA',isnull(nac.descripcion,'NO REGISTRA'),'NO APLICA') as NACIONALIDAD,
        iif(p.email_institucional is null,'NO REGISTRA',p.email_institucional) as EMAIL_INSTITUCIONAL,
            iif(tie.codigo in ('MOV-EXT','MOV','MOV-INTER','RESIDENIO-CARRERA','REDISENIO-SEDE'),'',
                 ISNULL( FORMAT(COALESCE(mat1.fecha_desde,sis2.fecha_desde,sis.fecha_desde,sis3.fecha_desde,sis4.fecha_desde), 'dd/MM/yyyy'),'')) as FECHA_INICIO_PRIMER_NIVEL,
            case when tie.codigo in ('MOV-EXT','MOV','MOV-INTER','RESIDENIO-CARRERA') then FORMAT(COALESCE(movi.fecha_desde,movi1.fecha_desde, pao.fecha_desde), 'dd/MM/yyyy')  else  '' end as FECHA_INGRESO_CONVALIDACION,
            case when tie.codigo in ('REDISENIO-SEDE','CAMBIO-MALLA','RESIDENIO-CARRERA','REDISENIO-SIS-EST','REDISENIO-REV-NORM','RESIDENIO-MODALIDAD') then
                     FORMAT(COALESCE(movi.fecha_desde,movi1.fecha_desde, pao.fecha_desde), 'dd/MM/yyyy') else '' end as FECHA_TRANSICION_CURRICULAR
            ,eo.id_estudiante_oferta
--             ,eom.id_estudiante_oferta_origen,eo.id_estudiante_oferta_padre,eo.fecha_desde as fecha_desde_eo
--             ,tee.descripcion as estado_cupo,tie.descripcion as tipo_ingreso,te.descripcion as tipo_estudiante
        ,iif(p.id_pais_residencia is null,'NO REGISTRA',pr.descripcion) as PAIS_RESIDENCIA,
        iif(p.id_provincia_residencia is null,'NO APLICA',pror.descripcion) as PROVINCIA_RESIDENCIA,
        iif(p.id_canton_residencia is null,'NO APLICA',cr.descripcion) as CANTON_RESIDENCIA,
        isnull((select  TOP 1 tte.descripcion from man.informacion_academica_persona iap
               inner join aca.institucion ins on ins.id_institucion = iap.id_institucion
               inner join aca.tipo_institucion tte on tte.id_tipo_institucion = ins.id_tipo_institucion
               where iap.id_nivel_formacion =2 and iap.estado='A' and iap.id_persona=p.id
               order by iap.id_informacion_academica_persona
        ),'NO REGISTRA')as TIPO_COLEGIO,
        isnull((select top 1 coalesce((SELECT MAX( CASE
                                                          WHEN AC.codigo_acciones_afirmativas = 'CONDICION_SOCIOECONOMICA' THEN AC.descripcion
                                                          WHEN AC.codigo_acciones_afirmativas = 'DISCAPACIDAD' THEN AC.descripcion
                                                          WHEN AC.codigo_acciones_afirmativas = 'PUEBLOS_NACIONALIDADES' THEN AC.descripcion ELSE 'OTRAS' END
                                                 ) AS ASIGNADO_CUPO
                                          FROM niv.inscripcion_acciones_afirmativas iaff
                                        INNER JOIN niv.acciones_afirmativa ac ON ac.id_acciones_afirmativas = iaff.id_acciones_afirmativas
                                        WHERE iaff.estado = 'A' AND ac.estado = 'A'AND iaff.id_inscripcion = i.id_inscripcion_nivelacion
                                      ) ,'NINGUNA')as Politicas_cuotas
                from niv.inscripcion_nivelacion i
                inner join man.personas p1 on p1.id=i.id_persona
                where i.estado='A' and p1.estado='AC' and i.id_periodo_academico in (@id_periodo_academico_niv)
                and i.id_periodo_academico = @id_periodo_academico_niv and p1.identificacion = p.identificacion
                order by i.id_periodo_academico desc),'NINGUNA') as POLITICA_CUOTA,m.descripcion as MODALIDAD_ESTUDIO,
                iif(niv.genero is null or niv.genero='',iif(p.sexo='F','Femenino','Masculino'),niv.genero) as GENERO,
                ROW_NUMBER() OVER (PARTITION BY p.identificacion,o.descripcion ORDER BY niv.id_periodo_academico,niv.genero desc) AS rn
    from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join mig.estudiante_oferta_modalidad eom on eo.id_estudiante_oferta = eom.id_estudiante_oferta
    inner join aca.periodo_academico pao on pao.id_periodo_academico = eo.id_periodo_academico
    inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    inner join man.tipo_identificacion ti on ti.id_tipo_identificacion = p.id_tipo_identificacion
    left join man.nacionalidad_indigena nac on nac.id_nacionalidad_indigena = p.id_nacionalidad_indigena and nac.estado='A'
    left join man.lugar pn on pn.id_lugar = p.id_pais_nacionalidad and pn.estado='A'
    left join man.discapacidad dis on dis.id_discapacidad = p.id_discapacidad and dis.estado='A'
    left join man.etnia e on e.id_etnia = p.id_etnia and e.estado='A'
    left join man.lugar pr on pr.id_lugar = p.id_pais_residencia and pr.estado='A'
    left join man.lugar pror on pror.id_lugar = p.id_provincia_residencia and pr.estado='A'
    left join man.lugar cr on cr.id_lugar = p.id_canton_residencia and pr.estado='A'
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
    inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.modalidad m on om.id_modalidad = m.id_modalidad
    inner join aca.oferta o on o.id_oferta = om.id_oferta
    inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
    inner join man.departamentos d on d.id= do.id_departamento
    inner join aca.campus c on c.id_campus = o.id_campus
    --primer semestre carrera sga
    left join (
        select min(pa1.fecha_desde) as fecha_desde,em1.id_estudiante_oferta as id_estudiante_oferta from aca.estudiante_matricula em1
        inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
        inner join aca.periodo_academico pa1 on mg1.id_periodo_academico = pa1.id_periodo_academico
        inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
        inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
        inner join aca.malla_asignatura ma1 on aa1.id_malla_asignatura = ma1.id_malla_asignatura
        where em1.estado='A' and ea1.estado='A' and aa1.estado='A' and ma1.estado='A' and ma1.id_nivel = 1
        group by em1.id_estudiante_oferta
    ) as mat1 on  mat1.id_estudiante_oferta = eom.id_estudiante_oferta_origen
    --primer semestre sisweb
    left join (
        select min(pa.fecha_desde) as fecha_desde,ro.id_estudiante_oferta as id_estudiante_oferta
        from mig.record_oferta ro
        inner join mig .record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
        inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
        inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A'
        group by ro.id_estudiante_oferta
    ) as sis on sis.id_estudiante_oferta = eom.id_estudiante_oferta_origen
    left join (
        select min(pa.fecha_desde) as fecha_desde,ro.id_estudiante_oferta as id_estudiante_oferta
        from mig.record_oferta ro
        inner join mig.record_oferta rod on rod.id_record_oferta = ro.id_record_oferta_padre
        inner join mig.record_matricula rm on rod.id_record_oferta = rm.id_record_oferta
        inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
        inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A' and rod.estado='A' and rod.id_tipo_oferta = 2
        group by ro.id_estudiante_oferta
    ) as sis2 on sis2.id_estudiante_oferta = eom.id_estudiante_oferta_origen
    --buscar primer semestre en rediseños del sisweb
    left join (
        select min(pa.fecha_desde) as fecha_desde,ro.id_estudiante_oferta_destino as id_estudiante_oferta
        from mig.record_oferta ro
        inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
        inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
        inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A'
        group by ro.id_estudiante_oferta_destino
    ) as sis3 on sis3.id_estudiante_oferta = eom.id_estudiante_oferta_origen
    --buscar primer semestre en rediseños del sisweb con homologaciones
    left join (
        select min(pa.fecha_desde) as fecha_desde,ro.id_estudiante_oferta_destino as id_estudiante_oferta
        from mig.record_oferta ro
        inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
        inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where  ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A'
        group by ro.id_estudiante_oferta_destino
    ) as sis4 on sis4.id_estudiante_oferta = eom.id_estudiante_oferta_origen
    --movilidad sga
    left join (
        select mov1.id_estudiante_oferta,min(pa.fecha_desde) as fecha_desde from aca.movilidad mov1
        inner join aca.periodo_academico pa on mov1.id_periodo_academico = pa.id_periodo_academico
        where mov1.estado='A'
        group by mov1.id_estudiante_oferta
    ) as movi on movi.id_estudiante_oferta= eom.id_estudiante_oferta_origen
    --m movilidad sga
    left join (
        select min(pa.fecha_desde) as fecha_desde,min(ra.fecha_registro) as fecha_ing,ro.id_estudiante_oferta as id_estudiante_oferta
        from mig.record_oferta ro
                 inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
                 inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where  ra.estado<>'I' and ro.estado='A' --and ro.id_estudiante_oferta = 9786
          and ra.tipo in ('MOVILIDAD A 8 SEMESTRES - HOM AA','MOVILIDAD A 8 SEMESTRES - HOM VC','MOVILIDAD A 8 SEMESTRES - RECON. CC',
                          'MOVILIDAD A 8 SEMESTRES - RECON. TRANSIC.','MOVILIDAD AGROPECUARIA SIN MATRICULA - HOM AA')
        group by ro.id_estudiante_oferta
    ) as movi1 on movi1.id_estudiante_oferta= eom.id_estudiante_oferta_origen
    left join dbo.persona_nivelacion niv on niv.identificacion = p.identificacion
    where p.estado='AC' and eo.estado='A' and em.estado = 'A'
     and  mg.id_periodo_academico in (@id_periodo_academico_grado) and p.id_tipo_identificacion = 1
    group by pa.codigo,o.descripcion,o.codigo_ces,o.descripcion,c.descripcion,c.descripcion_corta,ti.descripcion,p.id,p.identificacion,p.apellidos,p.nombres,p.sexo,p.fecha_nace,
    p.id_pais_nacionalidad,pn.descripcion,p.id_discapacidad,dis.descripcion,p.porcentaje_dis,p.id_etnia,e.descripcion,p.id_nacionalidad,nac.descripcion,
    p.direccion,p.email_personal,p.email_institucional,p.id_pais_residencia,pr.descripcion,p.id_provincia_residencia,pror.descripcion,
    p.id_canton_residencia,cr.descripcion,p.celular,p.num_carnet_conadis,tie.codigo
    ,tee.descripcion,tie.descripcion,te.descripcion,mat1.fecha_desde,sis.fecha_desde,sis2.fecha_desde,
     sis3.fecha_desde,sis4.fecha_desde
    ,eo.fecha_desde,eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,pao.fecha_desde,movi.fecha_desde,movi1.fecha_desde,m.descripcion
    ,niv.genero,niv.id_periodo_academico,eom.id_estudiante_oferta_origen
    ) as d
    where d.rn=1
order by d.CARRERA,d.APELLIDOS_NOMBRES
end


--MATRIZ ESTUDIANTES V2026 PASAPORTE
begin
    declare @id_periodo_academico_grado int = 96,@id_periodo_academico_niv int = 127
--     select d.*
select distinct d.PERIODO_ACADEMICO,d.CODIGO_IES, CODIGO_CARRERA, CARRERA, CIUDAD_CARRERA, TIPO_IDENTIFICACION, IDENTIFICACION,PRIMER_APELLIDO,SEGUNDO_APELLIDO,NOMBRES,
                case when GENERO='Femenino' and SEXO='HOMBRE' then 'MASCULINO'
                     when GENERO='Masculino' and SEXO='MUJER' then 'FEMENINO'
                     when GENERO='Otro' then 'NO DISPONE'
                     when GENERO='No sabe / No responde' OR GENERO='Prefiere no contestar' then 'NO SABE/NO RESPONDE'
                     when GENERO='Trans femenina' then 'TRANSFEMENINA'
                     when GENERO='Trans masculino' then 'TRANSMASCULINO' ELSE upper(GENERO) end as GENERO,
    SEXO, FECHA_NACIMIENTO, PAIS_ORIGEN, DISCAPACIDAD, PORCENTAJE_DISCAPACIDAD, NUMERO_CONADIS, ETNIA, NACIONALIDAD, EMAIL_INSTITUCIONAL,FECHA_INICIO_PRIMER_NIVEL,
    iif(FECHA_INGRESO_CONVALIDACION='' and FECHA_INICIO_PRIMER_NIVEL='',FECHA_TRANSICION_CURRICULAR,FECHA_INGRESO_CONVALIDACION) as FECHA_INGRESO_CONVALIDACION
                    ,FECHA_TRANSICION_CURRICULAR,PAIS_RESIDENCIA, PROVINCIA_RESIDENCIA, CANTON_RESIDENCIA, TIPO_COLEGIO, POLITICA_CUOTA,MODALIDAD_ESTUDIO--,rn
-- ,tipo_ingreso,estado_cupo
--               ,id_estudiante_oferta,id_estudiante_oferta_padre,fecha_desde
    from (
    select distinct pa.codigo as PERIODO_ACADEMICO,
                    1023 as CODIGO_IES,o.codigo_ces as CODIGO_CARRERA,o.descripcion as CARRERA,c.descripcion as CIUDAD_CARRERA,
        ti.descripcion as TIPO_IDENTIFICACION,p.identificacion AS IDENTIFICACION,
                    P.apellido_paterno as PRIMER_APELLIDO,p.apellido_materno as SEGUNDO_APELLIDO ,p.nombres as NOMBRES,
        iif(p.sexo='M','HOMBRE','MUJER') as SEXO,CONVERT(VARCHAR(10),p.fecha_nace, 103) as FECHA_NACIMIENTO, iif(p.id_pais_nacionalidad is null,'NO REGISTRA',pn.descripcion) as PAIS_ORIGEN,
        iif(p.id_discapacidad is null,'NINGUNA',dis.descripcion) as DISCAPACIDAD,
        iif(p.id_discapacidad is null or p.id_discapacidad='' or p.porcentaje_dis is null,0,p.porcentaje_dis) as PORCENTAJE_DISCAPACIDAD,
        iif(p.num_carnet_conadis is null or p.num_carnet_conadis='' or p.num_carnet_conadis='0','NO APLICA',p.num_carnet_conadis) as NUMERO_CONADIS,
        iif(p.id_etnia is null,'NO REGISTRA',e.descripcion) as ETNIA,
        iif(e.descripcion='INDIGENA',isnull(nac.descripcion,'NO REGISTRA'),'NO APLICA') as NACIONALIDAD,
        iif(p.email_institucional is null,'NO REGISTRA',p.email_institucional) as EMAIL_INSTITUCIONAL,
            iif(tie.codigo in ('MOV-EXT','MOV','MOV-INTER','RESIDENIO-CARRERA'),'',
                 ISNULL( FORMAT(COALESCE(mat1.fecha_desde, sis.fecha_desde,sis2.fecha_desde,sis3.fecha_desde,sis4.fecha_desde), 'yyyy-MM-dd'),'')) as FECHA_INICIO_PRIMER_NIVEL,
            case when tie.codigo in ('MOV-EXT','MOV','MOV-INTER','RESIDENIO-CARRERA') then FORMAT(COALESCE(movi.fecha_desde,movi1.fecha_desde, pao.fecha_desde), 'yyyy-MM-dd')  else  '' end as FECHA_INGRESO_CONVALIDACION,
            case when tie.codigo in ('REDISENIO-SEDE','CAMBIO-MALLA','RESIDENIO-CARRERA','REDISENIO-SIS-EST','REDISENIO-REV-NORM','RESIDENIO-MODALIDAD') then
                     FORMAT(COALESCE(movi.fecha_desde,movi1.fecha_desde, pao.fecha_desde), 'yyyy-MM-dd') else '' end as FECHA_TRANSICION_CURRICULAR
            ,eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.fecha_desde as fecha_desde_eo,eop.fecha_desde as fecha_desde_eop
            ,tee.descripcion as estado_cupo,tie.descripcion as tipo_ingreso,te.descripcion as tipo_estudiante
        ,iif(p.id_pais_residencia is null,'NO REGISTRA',pr.descripcion) as PAIS_RESIDENCIA,
        iif(p.id_provincia_residencia is null,'NO APLICA',pror.descripcion) as PROVINCIA_RESIDENCIA,
        iif(p.id_canton_residencia is null,'NO APLICA',cr.descripcion) as CANTON_RESIDENCIA,
        isnull((select  TOP 1 tte.descripcion from man.informacion_academica_persona iap
               inner join aca.institucion ins on ins.id_institucion = iap.id_institucion
               inner join aca.tipo_institucion tte on tte.id_tipo_institucion = ins.id_tipo_institucion
               where iap.id_nivel_formacion =2 and iap.estado='A' and iap.id_persona=p.id
               order by iap.id_informacion_academica_persona
        ),'NO REGISTRA')as TIPO_COLEGIO,
        isnull((select top 1 coalesce((SELECT MAX( CASE
                                                          WHEN AC.codigo_acciones_afirmativas = 'CONDICION_SOCIOECONOMICA' THEN AC.descripcion
                                                          WHEN AC.codigo_acciones_afirmativas = 'DISCAPACIDAD' THEN AC.descripcion
                                                          WHEN AC.codigo_acciones_afirmativas = 'PUEBLOS_NACIONALIDADES' THEN AC.descripcion ELSE 'OTRAS' END
                                                 ) AS ASIGNADO_CUPO
                                          FROM niv.inscripcion_acciones_afirmativas iaff
                                        INNER JOIN niv.acciones_afirmativa ac ON ac.id_acciones_afirmativas = iaff.id_acciones_afirmativas
                                        WHERE iaff.estado = 'A' AND ac.estado = 'A'AND iaff.id_inscripcion = i.id_inscripcion_nivelacion
                                      ) ,'NINGUNA')as Politicas_cuotas
                from niv.inscripcion_nivelacion i
                inner join man.personas p1 on p1.id=i.id_persona
                where i.estado='A' and p1.estado='AC' and i.id_periodo_academico in (@id_periodo_academico_niv)
                and i.id_periodo_academico = @id_periodo_academico_niv and p1.identificacion = p.identificacion
                order by i.id_periodo_academico desc),'NINGUNA') as POLITICA_CUOTA,m.descripcion as MODALIDAD_ESTUDIO,
                iif(niv.genero is null or niv.genero='',iif(p.sexo='F','Femenino','Masculino'),niv.genero) as GENERO,
                ROW_NUMBER() OVER (PARTITION BY p.identificacion,o.descripcion ORDER BY niv.id_periodo_academico,niv.genero desc) AS rn
    from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.periodo_academico pao on pao.id_periodo_academico = eo.id_periodo_academico
    left join aca.estudiante_oferta eop on eop.id_estudiante_oferta = eo.id_estudiante_oferta_padre
    inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    inner join man.tipo_identificacion ti on ti.id_tipo_identificacion = p.id_tipo_identificacion
    left join man.nacionalidad_indigena nac on nac.id_nacionalidad_indigena = p.id_nacionalidad_indigena and nac.estado='A'
    left join man.lugar pn on pn.id_lugar = p.id_pais_nacionalidad and pn.estado='A'
    left join man.discapacidad dis on dis.id_discapacidad = p.id_discapacidad and dis.estado='A'
    left join man.etnia e on e.id_etnia = p.id_etnia and e.estado='A'
    left join man.lugar pr on pr.id_lugar = p.id_pais_residencia
    left join man.lugar pror on pror.id_lugar = p.id_provincia_residencia
    left join man.lugar cr on cr.id_lugar = p.id_canton_residencia
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
    inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.modalidad m on om.id_modalidad = m.id_modalidad
    inner join aca.oferta o on o.id_oferta = om.id_oferta
    inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
    inner join man.departamentos d on d.id= do.id_departamento
    inner join aca.campus c on c.id_campus = o.id_campus
    --primer semestre carrera sga
    left join (
        select min(pa1.fecha_desde) as fecha_desde,min(ea1.fecha_ing) as fecha_ing,min(em1.id_estudiante_oferta) as id_estudiante_oferta,eo1.id_persona,om1.id_oferta from aca.estudiante_matricula em1
        inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
        inner join aca.periodo_academico pa1 on mg1.id_periodo_academico = pa1.id_periodo_academico
        inner join aca.estudiante_oferta eo1 on em1.id_estudiante_oferta = eo1.id_estudiante_oferta
        inner join aca.oferta_modalidad om1 on eo1.id_oferta_modalidad = om1.id_oferta_modalidad
        inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
        inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
        inner join aca.malla_asignatura ma1 on aa1.id_malla_asignatura = ma1.id_malla_asignatura
        where em1.estado='A' and ea1.estado='A' and aa1.estado='A' and ma1.estado='A' and ma1.id_nivel = 1
        group by eo1.id_persona,om1.id_oferta
    ) as mat1 on --mat1.id_estudiante_oferta = eo.id_estudiante_oferta
        mat1.id_persona = p.id and mat1.id_oferta = o.id_oferta
    --primer semestre sisweb
    left join (
        select min(pa.fecha_desde) as fecha_desde,min(rm.fecha_matricula) as fecha_ing,min(ro.id_estudiante_oferta) as id_estudiante_oferta,eo.id_persona from mig.record_oferta ro
        inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_estudiante_oferta
        inner join mig .record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
        inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
        inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A'
        group by eo.id_persona
    ) as sis on sis.id_estudiante_oferta = eo.id_estudiante_oferta
    left join (
        select min(pa.fecha_desde) as fecha_desde,min(rm.fecha_matricula) as fecha_ing,min(ro.id_estudiante_oferta) as id_estudiante_oferta,eo.id_persona
        from mig.record_oferta ro
                 inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_estudiante_oferta
                 inner join mig.record_oferta rod on rod.id_record_oferta = ro.id_record_oferta_padre
                 inner join mig.record_matricula rm on rod.id_record_oferta = rm.id_record_oferta
                 inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
                 inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A' and rod.estado='A' and rod.id_tipo_oferta = 2
    --       and ro.id_estudiante_oferta = 5994
        group by eo.id_persona
    ) as sis2 on sis2.id_estudiante_oferta = eo.id_estudiante_oferta
    left join (
        select min(pa.fecha_desde) as fecha_desde,min(rm.fecha_matricula) as fecha_ing,ro.id_estudiante_oferta_destino as id_estudiante_oferta,eo.id_persona from mig.record_oferta ro
        inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_estudiante_oferta_destino
        inner join mig .record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
        inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
        inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A'
        group by eo.id_persona,ro.id_estudiante_oferta_destino
    ) as sis3 on sis3.id_estudiante_oferta = eo.id_estudiante_oferta
    left join (
        select min(pa.fecha_desde) as fecha_desde,min(ra.fecha_registro) as fecha_ing,ro.id_estudiante_oferta_destino as id_estudiante_oferta,eo.id_persona
        from mig.record_oferta ro
                 inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_estudiante_oferta_destino
                 inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
                 inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where  ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A'
        group by eo.id_persona,ro.id_estudiante_oferta_destino
    ) as sis4 on sis4.id_estudiante_oferta = eo.id_estudiante_oferta
    left join (
        select eo1.id_estudiante_oferta,min(pa.fecha_desde) as fecha_desde from aca.movilidad mov1
        inner join aca.periodo_academico pa on mov1.id_periodo_academico = pa.id_periodo_academico
        inner join aca.estudiante_oferta eo1 on mov1.id_estudiante_oferta = eo1.id_estudiante_oferta
        where mov1.estado='A'
        group by eo1.id_estudiante_oferta
    ) as movi on movi.id_estudiante_oferta= eo.id_estudiante_oferta
    left join (
        select min(pa.fecha_desde) as fecha_desde,min(ra.fecha_registro) as fecha_ing,ro.id_estudiante_oferta as id_estudiante_oferta
        from mig.record_oferta ro
                 inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
                 inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where  ra.estado<>'I' and ro.estado='A' --and ro.id_estudiante_oferta = 9786
          and ra.tipo in ('MOVILIDAD A 8 SEMESTRES - HOM AA','MOVILIDAD A 8 SEMESTRES - HOM VC','MOVILIDAD A 8 SEMESTRES - RECON. CC','MOVILIDAD A 8 SEMESTRES - RECON. TRANSIC.','MOVILIDAD AGROPECUARIA SIN MATRICULA - HOM AA')
        group by ro.id_estudiante_oferta
    ) as movi1 on movi1.id_estudiante_oferta= eo.id_estudiante_oferta
    left join dbo.persona_nivelacion niv on niv.identificacion = p.identificacion
    where p.estado='AC' and eo.estado='A' and em.estado = 'A' AND
       mg.id_periodo_academico in (@id_periodo_academico_grado) and p.id_tipo_identificacion = 1
    group by pa.codigo,o.descripcion,o.codigo_ces,o.descripcion,c.descripcion,ti.descripcion,p.id,p.identificacion,p.apellidos,p.nombres,p.sexo,p.fecha_nace,
    p.id_pais_nacionalidad,pn.descripcion,p.id_discapacidad,dis.descripcion,p.porcentaje_dis,p.id_etnia,e.descripcion,p.id_nacionalidad,nac.descripcion,
    p.direccion,p.email_personal,p.email_institucional,p.id_pais_residencia,pr.descripcion,p.id_provincia_residencia,pror.descripcion,
    p.id_canton_residencia,cr.descripcion,p.celular,p.num_carnet_conadis,tie.codigo
    ,tee.descripcion,tie.descripcion,te.descripcion,mat1.fecha_desde,sis.fecha_desde,sis2.fecha_desde,sis3.fecha_desde,sis4.fecha_desde
    ,eo.fecha_desde,eop.fecha_desde,eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,pao.fecha_desde,movi.fecha_desde,movi1.fecha_desde,m.descripcion
    ,niv.genero,niv.id_periodo_academico,p.apellido_paterno,p.apellido_materno
    ) as d
--     where d.rn=1
--     inner join man.personas p on p.identificacion = d.IDENTIFICACION
order by d.CARRERA,d.PRIMER_APELLIDO,d.SEGUNDO_APELLIDO,d.NOMBRES
end

--graduados UNOPAC 2026
select CODIGO_IES, CODIGO_CARRERA, CARRERA, CIUDAD_CARRERA, IDENTIFICACION, APELLIDOS_NOMBRES,
--        FECHA_INICIO_PRIMER_NIVEL, FECHA_INGRESO_CONVALIDACION,
       iif(FECHA_INICIO_PRIMER_NIVEL<>'' and FECHA_INGRESO_CONVALIDACION<>'' and cast(FECHA_INICIO_PRIMER_NIVEL as date)<= cast(FECHA_INGRESO_CONVALIDACION as date),
           FECHA_INICIO_PRIMER_NIVEL,iif(FECHA_INICIO_PRIMER_NIVEL<>'' and FECHA_INGRESO_CONVALIDACION='',FECHA_INICIO_PRIMER_NIVEL,'')) as FECHA_INICIO_PRIMER_NIVEL,
       iif(FECHA_INICIO_PRIMER_NIVEL <>'' and FECHA_INGRESO_CONVALIDACION <>'' and cast(FECHA_INICIO_PRIMER_NIVEL as date)<= cast(FECHA_INGRESO_CONVALIDACION as date),
           '',FECHA_INGRESO_CONVALIDACION)  as FECHA_INGRESO_CONVALIDACION,
       FECHA_GRADUACION, MECANISMO_TITULACION, OCUPACION, TIPO from (
SELECT DISTINCT
   CODIGO_IES = '1023',
   CODIGO_CARRERA = ISNULL((SELECT codigo_carrera FROM Bd_Academico..VW_PLAN_ESTUDIOS WHERE ESTADO = 'A' and ID_PLAN = ma.id_plan),''),-- ma.id_plan, mA.ID_CARRERA_LOCAL,
   gr.CARRERA,
   gr.INSTITUCION AS CIUDAD_CARRERA,   --ma.id_persona,
   TIPO_IDENTIFICACION = (SELECT valor_texto FROM bd_personal..tp_codigos WHERE correlativo = p.CG_TIPO_IDENTIFICACION AND estado = 'A'),
   p.IDENTIFICACION,

   p.APELLIDOS + ' ' + p.NOMBRES AS APELLIDOS_NOMBRES,
   SEXO = (SELECT VALOR_TEXTO FROM BD_PERSONAL..TP_CODIGOS WHERE CORRELATIVO = p.CG_SEXO AND ESTADO = 'A'),
   FECHA_INICIO_PRIMER_NIVEL = ISNULL(CONVERT(VARCHAR, (SELECT inicio  FROM bd_Academico..PERIODOS_ACADEMICOS
														WHERE id_detalle in (SELECT MIN(id_detalle_periodo) FROM bd_academico..te_matriculas
																		     WHERE id_persona = ma.id_persona AND id_carrera_local = ma.id_carrera_local
                															AND cg_sistema_estudio = ma.cg_sistema_estudio

																			AND id_nivel IN (1) AND estado = 'A')), 103),''),
   FECHA_INGRESO_CONVALIDACION = CASE WHEN (SELECT COUNT(id_materia_tomada) FROM bd_academico..materias_tomadas mt
                                            WHERE mt.id_matricula IN (SELECT MIN(id_matricula) FROM bd_academico..te_matriculas
								   		                              WHERE id_persona = p.ID_PERSONA	AND id_carrera_local = ma.id_carrera_local
                						                              AND cg_sistema_estudio = ma.cg_sistema_estudio --AND cg_modalidad = ma.cg_modalidad  --
																	  --AND id_nivel IN (1)
																	  AND estado = 'A')
										    AND mt.estado = 'A') > 0
											THEN
												ISNULL(CONVERT(VARCHAR, (SELECT INICIO FROM bd_Academico..PERIODOS_ACADEMICOS
																		WHERE id_detalle = (SELECT MIN(mt.id_detalle_periodo) FROM bd_academico..te_matriculas as m
																							INNER JOIN Bd_Academico..materias_tomadas as mt on m.id_matricula = mt.id_matricula and mt.estado = 'A'
																						WHERE m.id_persona = ma.id_persona AND m.id_carrera_local = ma.id_carrera_local
                																		AND m.cg_sistema_estudio = ma.cg_sistema_estudio AND m.cg_modalidad = ma.cg_modalidad

																						AND m.estado = 'A' )), 103),'')
									  ELSE ''
									  END,
   ISNULL(CONVERT(VARCHAR, gr.fecha_graduacion,103),' - ') AS FECHA_GRADUACION,

   MECANISMO_TITULACION = gr.METODO_TITULACION,
   OCUPACION = '',
   TIPO = ''
FROM bd_academico..personas p
   INNER JOIN bd_academico..te_matriculas ma		ON p.id_persona = ma.id_persona
   inner join bd_academico..eg_listado_graduados gr ON MA.ID_PERSONA = gr.ID_PERSONA AND gr.ID_CARRERA_OFERTADA = ma.ID_CARRERA_OFERTADA
                                                           AND ma.CG_MODALIDAD = gr.CG_MODALIDAD and ma.CG_SISTEMA_ESTUDIO = gr.CG_SISTEMA_ESTUDIO
   LEFT JOIN bd_academico..EDUCACION_SECUNDARIA sec ON p.id_persona = sec.id_persona
WHERE
 p.estado = 'A' AND ma.estado = 'A'
AND (((MONTH(gr.FECHA_GRADUACION) >= 1) AND (YEAR(gr.FECHA_GRADUACION) = 2025)) OR ((MONTH(gr.FECHA_GRADUACION) <= 12) AND (YEAR(gr.FECHA_GRADUACION) = 2025)))
AND ma.ID_PLAN IN (SELECT MAX(ID_PLAN) FROM Bd_Academico..TE_MATRICULAS WHERE ID_PERSONA = p.ID_PERSONA AND ID_CARRERA_OFERTADA = ma.ID_CARRERA_OFERTADA AND ESTADO = 'A'))
as d


--GRADUADOS UNOPAC V2026 SGA
select distinct d.CODIGO_IES, CODIGO_CARRERA, CARRERA, CIUDAD_CARRERA, TIPO_IDENTIFICACION, identificacion, APELLIDOS_NOMBRES, SEXO, FECHA_INICIO_PRIMER_NIVEL,
       iif(FECHA_INGRESO_CONVALIDACION='' and FECHA_INICIO_PRIMER_NIVEL='',FECHA_TRANSICION_CURRICULAR,FECHA_INGRESO_CONVALIDACION) as FECHA_INGRESO_CONVALIDACION,
        FECHA_GRADUACION, MECANISMO_TITULACION,OCUPACION,TIPO from (
select distinct '1023' as CODIGO_IES,o.codigo_ces as CODIGO_CARRERA,ofa.carrera as CARRERA,ofa.sedeCorta as CIUDAD_CARRERA,ti.descripcion as TIPO_IDENTIFICACION,
        p.identificacion,concat(p.apellidos,' ',p.nombres) as APELLIDOS_NOMBRES,iif(p.sexo='M','HOMBRE','MUJER') as SEXO,
        me.FECHA_INICIO_PRIMER_NIVEL, me.FECHA_INGRESO_CONVALIDACION,me.FECHA_TRANSICION_CURRICULAR
    ,CONVERT(VARCHAR(10),cast(g.fecha_graduacion as date), 103)  as FECHA_GRADUACION,g.metodo_titulacion as MECANISMO_TITULACION
        ,iif(c.id is null,'NO','SI') as OCUPACION,iif(c.id is null,'NO APLICA','GSP') as TIPO,eo.id_estudiante_oferta
        from mig.graduados g
         inner join man.personas p on p.id = g.id_persona
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = g.id_oferta_modalidad
         left join aca.estudiante_oferta eo on
             eo.id_estudiante_oferta = g.id_estudiante_oferta and eo.estado='A'
--              eo.id_persona = p.id and eo.id_oferta_modalidad = ofa.id_oferta_modalidad and eo.estado='A'
         left join aca.periodo_academico pao on pao.id_periodo_academico = eo.id_periodo_academico
         left join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
         left join mig.estudiante_oferta_modalidad eom on eo.id_estudiante_oferta = eom.id_estudiante_oferta
         left join aca.oferta o on o.id_oferta = ofa.id_oferta
         left join man.tipo_identificacion ti on ti.id_tipo_identificacion = p.id_tipo_identificacion
         left join mig.matriz_estudiantes_fechas me on me.id_estudiante_oferta = eo.id_estudiante_oferta
         left join uath.contratos_migracion_06_02_2024 c on c.identificacion=p.identificacion and c.EstadoContrato='A'
where
    p.estado='AC' --and YEAR(g.fecha_graduacion)= '2025'
  AND g.fecha_graduacion >= '2025-01-01'
  AND g.fecha_graduacion < '2026-01-01'
--         p.identificacion ='0604378760'
-- group by o.codigo_ces, ofa.carrera, ofa.sedeCorta, ti.descripcion, p.identificacion, p.apellidos, p.nombres, p.sexo, tie.codigo, g.fecha_graduacion, g.metodo_titulacion
--     ,mat1.fecha_desde,sis.fecha_desde--,movi.fecha_desde, movi1.fecha_desde,pao.fecha_desde

    ) as d
order by d.CARRERA,d.APELLIDOS_NOMBRES

select  * from mig.graduados where identificacion='0604378760'
select * from mig.estudiante_oferta_modalidad eom

select * from mig.matriz_estudiantes_fechas eom
--saber las fechas de ingreso de los estudiantes
begin
--         DBCC CHECKIDENT ('mig.matriz_estudiantes_fechas', RESEED, 0);
    truncate table mig.matriz_estudiantes_fechas;
    insert into mig.matriz_estudiantes_fechas
    select d.PERIODO_INGRESO,d.ESTADO_CUPO,d.CARRERA, d.MODALIDAD, CIUDAD_CARRERA, TIPO_IDENTIFICACION, IDENTIFICACION, APELLIDOS_NOMBRES, FECHA_INICIO_PRIMER_NIVEL,
           iif(FECHA_INGRESO_CONVALIDACION='' and FECHA_INICIO_PRIMER_NIVEL='',FECHA_TRANSICION_CURRICULAR,FECHA_INGRESO_CONVALIDACION) as FECHA_INGRESO_CONVALIDACION,
             FECHA_TRANSICION_CURRICULAR,
           id_estudiante_oferta--, fecha_desde, fecha_desde, fecha_desde, fecha_desde, fecha_desde, fecha_desde, fecha_desde
    from (
    select pao.codigo as PERIODO_INGRESO,tee.descripcion as  ESTADO_CUPO,o.descripcion as CARRERA,m.descripcion as MODALIDAD,c.descripcion_corta as CIUDAD_CARRERA,
        ti.descripcion as TIPO_IDENTIFICACION,p.identificacion AS IDENTIFICACION,
        concat(p.apellidos,' ',p.nombres) as APELLIDOS_NOMBRES,
--            iif(tie.codigo in ('MOV-EXT','MOV','MOV-INTER','RESIDENIO-CARRERA','REDISENIO-SEDE'),'',
--                ISNULL( FORMAT(COALESCE(mat1.fecha_desde,sis2.fecha_desde,sis.fecha_desde,sis3.fecha_desde,sis4.fecha_desde), 'dd/MM/yyyy'),'')) as FECHA_INICIO_PRIMER_NIVEL,
--            case when tie.codigo in ('MOV-EXT','MOV','MOV-INTER','RESIDENIO-CARRERA') then FORMAT(COALESCE(movi.fecha_desde,movi1.fecha_desde, pao.fecha_desde), 'dd/MM/yyyy')  else  '' end as FECHA_INGRESO_CONVALIDACION,
            iif(tie.codigo in ('MOV-EXT','MOV','MOV-INTER','RESIDENIO-CARRERA','REDISENIO-SEDE'),'',
                 ISNULL( FORMAT(COALESCE(mat1.fecha_desde,sis2.fecha_desde,sis.fecha_desde,sis3.fecha_desde,sis4.fecha_desde), 'dd/MM/yyyy'),'')) as FECHA_INICIO_PRIMER_NIVEL,
            case when tie.codigo in ('MOV-EXT','MOV','MOV-INTER','RESIDENIO-CARRERA','REDISENIO-SEDE') then FORMAT(COALESCE(movi.fecha_desde,movi1.fecha_desde, pao.fecha_desde), 'dd/MM/yyyy')  else  '' end as FECHA_INGRESO_CONVALIDACION,
            case when tie.codigo in ('REDISENIO-SEDE','CAMBIO-MALLA','RESIDENIO-CARRERA','REDISENIO-SIS-EST','REDISENIO-REV-NORM','RESIDENIO-MODALIDAD') then
                     FORMAT(COALESCE(movi.fecha_desde,movi1.fecha_desde, pao.fecha_desde), 'dd/MM/yyyy') else '' end as FECHA_TRANSICION_CURRICULAR
            ,eo.id_estudiante_oferta--,mat1.fecha_desde,sis2.fecha_desde,sis.fecha_desde,sis3.fecha_desde,sis4.fecha_desde,movi.fecha_desde,movi1.fecha_desde
    from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join mig.estudiante_oferta_modalidad eom on eo.id_estudiante_oferta = eom.id_estudiante_oferta
    inner join aca.periodo_academico pao on pao.id_periodo_academico = eo.id_periodo_academico
    inner join man.tipo_identificacion ti on ti.id_tipo_identificacion = p.id_tipo_identificacion
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
    inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
    inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join aca.modalidad m on om.id_modalidad = m.id_modalidad
    inner join aca.oferta o on o.id_oferta = om.id_oferta
    inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
    inner join man.departamentos d on d.id= do.id_departamento
    inner join aca.campus c on c.id_campus = o.id_campus
    --primer semestre carrera sga
    left join (
        select min(pa1.fecha_desde) as fecha_desde,em1.id_estudiante_oferta as id_estudiante_oferta from aca.estudiante_matricula em1
        inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
        inner join aca.periodo_academico pa1 on mg1.id_periodo_academico = pa1.id_periodo_academico
        inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
        inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
        inner join aca.malla_asignatura ma1 on aa1.id_malla_asignatura = ma1.id_malla_asignatura
        where em1.estado='A' and ea1.estado='A' and aa1.estado='A' and ma1.estado='A' and ma1.id_nivel = 1
        group by em1.id_estudiante_oferta
    ) as mat1 on  mat1.id_estudiante_oferta = eom.id_estudiante_oferta_origen
    --primer semestre sisweb
    left join (
        select min(pa.fecha_desde) as fecha_desde,ro.id_estudiante_oferta as id_estudiante_oferta
        from mig.record_oferta ro
        inner join mig .record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
        inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
        inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A'
        group by ro.id_estudiante_oferta
    ) as sis on sis.id_estudiante_oferta = eom.id_estudiante_oferta_origen
    left join (
        select min(pa.fecha_desde) as fecha_desde,ro.id_estudiante_oferta as id_estudiante_oferta
        from mig.record_oferta ro
        inner join mig.record_oferta rod on rod.id_record_oferta = ro.id_record_oferta_padre
        inner join mig.record_matricula rm on rod.id_record_oferta = rm.id_record_oferta
        inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
        inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A' and rod.estado='A' and rod.id_tipo_oferta = 2
        group by ro.id_estudiante_oferta
    ) as sis2 on sis2.id_estudiante_oferta = eom.id_estudiante_oferta_origen
    --buscar primer semestre en rediseños del sisweb
    left join (
        select min(pa.fecha_desde) as fecha_desde,ro.id_estudiante_oferta_destino as id_estudiante_oferta
        from mig.record_oferta ro
        inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
        inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
        inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A'
        group by ro.id_estudiante_oferta_destino
    ) as sis3 on sis3.id_estudiante_oferta = eom.id_estudiante_oferta_origen
    --buscar primer semestre en rediseños del sisweb con homologaciones
    left join (
        select min(pa.fecha_desde) as fecha_desde,ro.id_estudiante_oferta_destino as id_estudiante_oferta
        from mig.record_oferta ro
        inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
        inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where  ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A'
        group by ro.id_estudiante_oferta_destino
    ) as sis4 on sis4.id_estudiante_oferta = eom.id_estudiante_oferta_origen
    --movilidad sga
    left join (
        select mov1.id_estudiante_oferta,min(pa.fecha_desde) as fecha_desde from aca.movilidad mov1
        inner join aca.periodo_academico pa on mov1.id_periodo_academico = pa.id_periodo_academico
        where mov1.estado='A'
        group by mov1.id_estudiante_oferta
    ) as movi on movi.id_estudiante_oferta= eom.id_estudiante_oferta_origen
    --m movilidad sga
    left join (
        select min(pa.fecha_desde) as fecha_desde,min(ra.fecha_registro) as fecha_ing,ro.id_estudiante_oferta as id_estudiante_oferta
        from mig.record_oferta ro
                 inner join mig.record_asignaturas ra on ro.id_record_oferta = ra.id_record_oferta
                 inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
        where  ra.estado<>'I' and ro.estado='A' --and ro.id_estudiante_oferta = 9786
          and ra.tipo in ('MOVILIDAD A 8 SEMESTRES - HOM AA','MOVILIDAD A 8 SEMESTRES - HOM VC','MOVILIDAD A 8 SEMESTRES - RECON. CC',
                          'MOVILIDAD A 8 SEMESTRES - RECON. TRANSIC.','MOVILIDAD AGROPECUARIA SIN MATRICULA - HOM AA')
        group by ro.id_estudiante_oferta
    ) as movi1 on movi1.id_estudiante_oferta= eom.id_estudiante_oferta_origen
    left join dbo.persona_nivelacion niv on niv.identificacion = p.identificacion
    where p.estado='AC' and eo.estado='A'
    group by mat1.fecha_desde,sis.fecha_desde,sis2.fecha_desde,sis3.fecha_desde,movi.fecha_desde,movi1.fecha_desde,sis4.fecha_desde,pao.fecha_desde,tee.descripcion,
        o.descripcion, m.descripcion, c.descripcion_corta, ti.descripcion, p.identificacion, p.apellidos, p.nombres, tie.codigo, eo.id_estudiante_oferta,pao.codigo
    ) as d
order by d.CARRERA,d.APELLIDOS_NOMBRES
end

select * from rel.oferta_relaciones
select  distinct ore.id_oferta,omo.carrera,omo.modalidad,ore.id_oferta_relacion,omo1.carrera,omo1.modalidad from rel.oferta_relaciones ore
inner join  aca.ofertas_facultad omo on omo.id_oferta=ore.id_oferta
inner join aca.ofertas_facultad omo1 on omo1.id_oferta=ore.id_oferta_relacion
where ore.estado='A'

select  distinct ore.id_oferta,omo.codigo_ces,ore.id_oferta_relacion,omo1.codigo_ces from rel.oferta_relaciones ore
inner join  aca.ofertas_facultad omo on omo.id_oferta=ore.id_oferta
inner join aca.ofertas_facultad omo1 on omo1.id_oferta=ore.id_oferta_relacion
where ore.estado='A'
select * from man.personas where identificacion in ('0942830522','2450476524')

select id_periodo_academico,codigo,descripcion,fecha_desde,fecha_hasta from aca.periodo_academico where codigo in ('2025-1','2025-2')
--                                                                                                       id_tipo_oferta = 1

--    MATRIZ ESTUDIANTES NIVELACION 2026
begin
    declare @id_periodo_academico_niv int = 126
--     select d.*
    select distinct d.PERIODO_ACADEMICO,d.CODIGO_IES, CODIGO_CARRERA, CARRERA, CIUDAD_CARRERA, TIPO_IDENTIFICACION, IDENTIFICACION, APELLIDOS_NOMBRES,
                    case when GENERO='Femenino' and SEXO='HOMBRE' then 'MASCULINO'
                         when GENERO='Masculino' and SEXO='MUJER' then 'FEMENINO'
                         when GENERO='Otro' then 'NO DISPONE'
                         when GENERO='No sabe / No responde' OR GENERO='Prefiere no contestar' then 'NO SABE/NO RESPONDE'
                         when GENERO='Trans femenina' then 'TRANSFEMENINA'
                         when GENERO='Trans masculino' then 'TRANSMASCULINO' ELSE upper(GENERO) end as GENERO,
                    SEXO, FECHA_NACIMIENTO, PAIS_ORIGEN, DISCAPACIDAD, PORCENTAJE_DISCAPACIDAD, NUMERO_CONADIS, ETNIA, NACIONALIDAD, EMAIL_INSTITUCIONAL,
        FECHA_INICIO_PRIMER_NIVEL, FECHA_INGRESO_CONVALIDACION,FECHA_TRANSICION_CURRICULAR,PAIS_RESIDENCIA, PROVINCIA_RESIDENCIA, CANTON_RESIDENCIA, TIPO_COLEGIO, POLITICA_CUOTA,MODALIDAD_ESTUDIO
--     ,id_estudiante_oferta,id_estudiante_matricula,d.fecha_desde
--          estado_cupo,carrera_gra,id_estudiante_matricula,estado,rn
        from (
    select distinct pa.codigo as PERIODO_ACADEMICO,
                    1023 as CODIGO_IES,o.codigo_ces as CODIGO_CARRERA,o.descripcion as CARRERA,om.sedeCorta as CIUDAD_CARRERA,
        ti.descripcion as TIPO_IDENTIFICACION,p.identificacion AS IDENTIFICACION,
        concat(p.apellidos,' ',p.nombres) as APELLIDOS_NOMBRES,
        iif(niv.genero is null or niv.genero='',iif(p.sexo='F','Femenino','Masculino'),niv.genero) as GENERO,    ROW_NUMBER() OVER (PARTITION BY p.identificacion ORDER BY niv.id_periodo_academico,niv.genero desc) AS rn,
        iif(p.sexo='M','HOMBRE','MUJER') as SEXO,CONVERT(VARCHAR(10),p.fecha_nace, 103) as FECHA_NACIMIENTO, iif(p.id_pais_nacionalidad is null,'NO REGISTRA',pn.descripcion) as PAIS_ORIGEN,
        iif(p.id_discapacidad is null,'NINGUNA',dis.descripcion) as DISCAPACIDAD,
        iif(p.id_discapacidad is null or p.id_discapacidad='' or p.porcentaje_dis is null,0,p.porcentaje_dis) as PORCENTAJE_DISCAPACIDAD,
        iif(p.num_carnet_conadis is null or p.num_carnet_conadis='' or p.num_carnet_conadis='0','NO APLICA',p.num_carnet_conadis) as NUMERO_CONADIS,
        iif(p.id_etnia is null,'NO REGISTRA',e.descripcion) as ETNIA,
        iif(e.descripcion='INDIGENA',isnull(nac.descripcion,'NO REGISTRA'),'NO APLICA') as NACIONALIDAD,
        iif(p.email_institucional is not null,p.email_institucional,isnull(p.email_personal,'NO REGISTRA')) as EMAIL_INSTITUCIONAL,
            ISNULL( FORMAT(pa.fecha_desde, 'dd/MM/yyyy'),'NO APLICA') as FECHA_INICIO_PRIMER_NIVEL,
            '' as FECHA_INGRESO_CONVALIDACION,''as FECHA_TRANSICION_CURRICULAR
        ,tee.descripcion as estado_cupo,tie.descripcion as tipo_ingreso,te.descripcion as tipo_estudiante,
         eo.id_estudiante_oferta,o.descripcion as carrera_gra,em.id_estudiante_matricula,em.estado
        ,iif(p.id_pais_residencia is null,'NO REGISTRA',pr.descripcion) as PAIS_RESIDENCIA,
        iif(p.id_provincia_residencia is null,'NO APLICA',pror.descripcion) as PROVINCIA_RESIDENCIA,
        iif(p.id_canton_residencia is null,'NO APLICA',cr.descripcion) as CANTON_RESIDENCIA,
        isnull((select  TOP 1 tte.descripcion from man.informacion_academica_persona iap
               inner join aca.institucion ins on ins.id_institucion = iap.id_institucion
               inner join aca.tipo_institucion tte on tte.id_tipo_institucion = ins.id_tipo_institucion
               where iap.id_nivel_formacion =2 and iap.estado='A' and iap.id_persona=p.id
               order by iap.id_informacion_academica_persona
        ),'NO REGISTRA')as TIPO_COLEGIO,
        isnull((select top 1 coalesce((SELECT MAX( CASE
                                                          WHEN AC.codigo_acciones_afirmativas = 'CONDICION_SOCIOECONOMICA' THEN AC.descripcion
                                                          WHEN AC.codigo_acciones_afirmativas = 'DISCAPACIDAD' THEN AC.descripcion
                                                          WHEN AC.codigo_acciones_afirmativas = 'PUEBLOS_NACIONALIDADES' THEN AC.descripcion ELSE 'OTRAS' END
                                                 ) AS ASIGNADO_CUPO
                                          FROM niv.inscripcion_acciones_afirmativas iaff
                                        INNER JOIN niv.acciones_afirmativa ac ON ac.id_acciones_afirmativas = iaff.id_acciones_afirmativas
                                        WHERE iaff.estado = 'A' AND ac.estado = 'A'AND iaff.id_inscripcion = i.id_inscripcion_nivelacion
                                      ) ,'NINGUNA')as Politicas_cuotas
                from niv.inscripcion_nivelacion i
                inner join man.personas p1 on p1.id=i.id_persona
                where i.estado='A' and p1.estado='AC' and i.id_periodo_academico in (@id_periodo_academico_niv)
                and i.id_periodo_academico = @id_periodo_academico_niv and p1.identificacion = p.identificacion
                order by i.id_periodo_academico desc),'NINGUNA') as POLITICA_CUOTA,om.modalidad as MODALIDAD_ESTUDIO,pa.fecha_desde
    from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
--     left join aca.estudiante_oferta eop on eo.id_estudiante_oferta = eop.id_estudiante_oferta_padre and eo.estado='A'
--     left join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eop.id_oferta_modalidad
    inner join aca.malla m on m.id_malla = eo.id_malla
    inner join man.tipo_identificacion ti on ti.id_tipo_identificacion = p.id_tipo_identificacion
    inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join rel.oferta_relaciones orr on orr.id_oferta = om.id_oferta
    inner join aca.oferta o on orr.id_oferta_relacion = o.id_oferta
    left join man.nacionalidad_indigena nac on nac.id_nacionalidad_indigena = p.id_nacionalidad_indigena and nac.estado='A'
    left join man.lugar pn on pn.id_lugar = p.id_pais_nacionalidad and pn.estado='A'
    left join man.discapacidad dis on dis.id_discapacidad = p.id_discapacidad and dis.estado='A'
    left join man.etnia e on e.id_etnia = p.id_etnia and e.estado='A'
    left join man.lugar pr on pr.id_lugar = p.id_pais_residencia
    left join man.lugar pror on pror.id_lugar = p.id_provincia_residencia
    left join man.lugar cr on cr.id_lugar = p.id_canton_residencia
    inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
    inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
    inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta and em.estado in ('A')
    inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
    inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
    left join dbo.persona_nivelacion niv on niv.identificacion = p.identificacion
    --primer semestre carrera sga
--     left join (
--         select min(pa1.fecha_desde) as fecha_desde,--min(ea1.fecha_ing) as fecha_ing,
--                em1.id_estudiante_oferta as id_estudiante_oferta from aca.estudiante_matricula em1
--         inner join aca.matricula_general mg1 on em1.id_matricula_general = mg1.id_matricula_general
--         inner join aca.periodo_academico pa1 on mg1.id_periodo_academico = pa1.id_periodo_academico
-- --         inner join aca.estudiante_asignatura ea1 on em1.id_estudiante_matricula = ea1.id_estudiante_matricula
-- --         inner join aca.asignatura_aprendizaje aa1 on aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
-- --         inner join aca.malla_asignatura ma1 on aa1.id_malla_asignatura = ma1.id_malla_asignatura
--         where em1.estado='A' --and ea1.estado='A' and aa1.estado='A' and ma1.estado='A'-- and ma1.id_nivel = 11
--         group by em1.id_estudiante_oferta
--     ) as mat1 on mat1.id_estudiante_oferta = eo.id_estudiante_oferta
    where p.estado='AC' and eo.estado='A'
     and  mg.id_periodo_academico in (@id_periodo_academico_niv)
    group by pa.codigo,o.descripcion,o.codigo_ces,o.descripcion,ti.descripcion,p.id,p.identificacion,p.apellidos,p.nombres,p.sexo,p.fecha_nace,
              p.id_pais_nacionalidad,pn.descripcion,p.id_discapacidad,dis.descripcion,p.porcentaje_dis,p.id_etnia,e.descripcion,p.id_nacionalidad,nac.descripcion,
        p.direccion,p.email_personal,p.email_institucional,m.fecha_desde,p.id_pais_residencia,pr.descripcion,p.id_provincia_residencia,pror.descripcion,
        p.id_canton_residencia,cr.descripcion,p.celular,p.num_carnet_conadis,pa.fecha_desde,tee.descripcion,tie.descripcion,te.descripcion,
        eo.id_estudiante_oferta,em.id_estudiante_matricula,em.estado,niv.genero,niv.id_periodo_academico,om.modalidad,om.carrera,om.sedeCorta,o.descripcion
        ) as d
    --     inner join man.personas p on p.identificacion = d.IDENTIFICACION
    where d.rn=1
    order by d.CARRERA,d.APELLIDOS_NOMBRES
end

select distinct estado from aca.estudiante_asignatura

--MATRIZ ESTUDIANTE PERIODO NIV 2026
BEGIN
    DECLARE @id_periodo_academico INT = 133;
    IF OBJECT_ID('tempdb..#record') IS NOT NULL
        DROP TABLE #record;
    IF OBJECT_ID('tempdb..#totales') IS NOT NULL
        DROP TABLE #totales;
    -- =========================================
-- 1. TRAER RECORD ACADÉMICO (UNA SOLA VEZ)
-- =========================================
    SELECT
        eo.id_estudiante_oferta,
        f.id_malla_asignatura,
        f.periodo
    INTO #record
    FROM aca.estudiante_oferta eo
    inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
    inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
             CROSS APPLY aca.fn_record_academico_sga_inline(eo.id_estudiante_oferta, NULL, NULL, 1) f
    where em.estado='A' and mg.id_periodo_academico=@id_periodo_academico;
    -- =========================================
-- 2. CALCULAR TOTALES (CRÉDITOS / HORAS)
-- =========================================
    SELECT
        r.id_estudiante_oferta,
        SUM(ma.num_creditos) AS TOTAL_CREDITOS_APROBADOS,
        SUM(ma.num_horas) AS TOTAL_HORAS_APROBADAS
    INTO #totales
    FROM #record r
    INNER JOIN aca.malla_asignatura ma
                        ON ma.id_malla_asignatura = r.id_malla_asignatura
    WHERE ma.estado = 'A' and  r.periodo <= (select codigo from aca.periodo_academico where id_periodo_academico = @id_periodo_academico)
    GROUP BY r.id_estudiante_oferta;
    -- ========================================
-- 3. MATRÍCULA (YA OPTIMIZADO)
-- =========================================
    WITH mat AS (
        SELECT
            em1.id_estudiante_oferta,
            COUNT(CASE WHEN ea1.codigo_estado_matricula = 'SEG' THEN 1 END) AS segundas_matriculas,
            COUNT(CASE WHEN ea1.codigo_estado_matricula = 'TER' THEN 1 END) AS terceras_matriculas,
            SUM(CASE WHEN ISNULL(ea1.aprobado, 0) = 1 THEN ma1.num_creditos ELSE 0 END) AS creditos_aprobados,
            SUM(CASE WHEN ISNULL(ea1.aprobado, 0) = 1 THEN ma1.num_horas ELSE 0 END) AS horas_aprobadas
        FROM aca.estudiante_matricula em1
        INNER JOIN aca.estudiante_asignatura ea1 ON em1.id_estudiante_matricula = ea1.id_estudiante_matricula
        INNER JOIN aca.asignatura_aprendizaje aa1    ON aa1.id_asignatura_aprendizaje = ea1.id_asignatura_aprendizaje
        INNER JOIN aca.malla_asignatura ma1 ON aa1.id_malla_asignatura = ma1.id_malla_asignatura
        INNER JOIN aca.matricula_general mg1 ON em1.id_matricula_general = mg1.id_matricula_general
        WHERE em1.estado in ('A','T','X')
--           AND ea1.estado='A'
          AND aa1.estado='A'
          AND ma1.estado='A'
          AND mg1.estado='A'
          AND mg1.id_periodo_academico = @id_periodo_academico
        GROUP BY em1.id_estudiante_oferta
    )
    -- =========================================
-- 4. QUERY FINAL
-- =========================================
    SELECT
        pa.codigo AS PERIODO_ACADEMICO,
        1023 AS CODIGO_IES,
--         eo.id_estudiante_oferta,
       '00099' AS CODIGO_CARRERA,
        o.descripcion AS NOMBRE_CARRERA,
        om.sedeCorta AS CIUDAD_CARRERA,
        te.descripcion AS TIPO_IDENTIFICACION,
        p.identificacion,
        CONCAT(p.apellidos,' ',p.nombres) AS APELLIDOS_NOMBRES,
        ISNULL(t.TOTAL_CREDITOS_APROBADOS,0) AS TOTAL_CREDITOS_APROBADOS,
        ISNULL(m.creditos_aprobados,0) AS CREDITOS_APROBADOS,
        tm.descripcion AS TIPO_MATRICULA,em.id_paralelo as PARALELO, 'NIVELACION' as NIVEL_ACADEMICO,
        ISNULL(m.segundas_matriculas,0) AS NUM_MATERIAS_SEGUNDA_MATRICULA,
        ISNULL(m.terceras_matriculas,0) AS NUM_MATERIAS_TERCERA_MATRICULA,
        IIF(eo.mantiene_gratuidad=0,'SI','NO') AS PERDIDA_GRATUIDAD,
        ISNULL(t.TOTAL_HORAS_APROBADAS,0) AS TOTAL_HORAS_APROBADAS,
        ISNULL(m.horas_aprobadas,0) AS HORAS_APROBADAS_PERIODO,
        0 AS MONTO_AYUDA_ECONOMICA,0 AS MONTO_CREDITO_EDUCATIVO,
        CASE WHEN tee.codigo in ('APR')  then 'APROBADO' when tee.codigo in ('INACD') then 'RETIRADO' else 'NO APROBADO ' end  as ESTADO,
        IIF(tee.codigo in ('INACD'), 'SOLICITUD ESTUDIANTE', 'NO APLICA ') AS MOTIVO, IIF(tee.codigo in ('INACD'), FORMAT(em.fecha_mod, 'dd-MM-yyyy'), '') AS FECHA_RETIRO
--             ,tee.descripcion as estado,tee.codigo,em.estado

    FROM man.personas p
    INNER JOIN aca.estudiante_oferta eo ON eo.id_persona = p.id
    INNER JOIN aca.malla malla ON malla.id_malla = eo.id_malla
    INNER JOIN man.tipo_identificacion te  ON te.id_tipo_identificacion = p.id_tipo_identificacion
    INNER JOIN aca.tipo_estado_estudiante tee   ON tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
    INNER JOIN aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
    INNER JOIN aca.estudiante_matricula em ON em.id_estudiante_oferta = eo.id_estudiante_oferta
    INNER JOIN aca.tipo_matricula tm ON em.id_tipo_matricula = tm.id_tipo_matricula
    INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = em.id_matricula_general
    INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = mg.id_periodo_academico
    INNER JOIN aca.ofertas_facultad om  ON om.id_oferta_modalidad = eo.id_oferta_modalidad
    inner join rel.oferta_relaciones orr on orr.id_oferta = om.id_oferta
    inner join aca.oferta o on orr.id_oferta_relacion = o.id_oferta
    LEFT JOIN mat m  ON m.id_estudiante_oferta = eo.id_estudiante_oferta
    LEFT JOIN #totales t ON t.id_estudiante_oferta = eo.id_estudiante_oferta
    WHERE p.estado='AC'
      AND eo.estado='A'
      AND em.estado in ('A','T','X')
--       AND tee.codigo IN ('ACT','OFR','APR')
      AND mg.id_periodo_academico = @id_periodo_academico
    ORDER BY om.carrera, APELLIDOS_NOMBRES;

END