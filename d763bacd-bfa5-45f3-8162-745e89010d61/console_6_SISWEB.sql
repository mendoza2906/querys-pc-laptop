use Bd_Academico;

select * from dbo.TP_CODIGOS
where VALOR_TEXTO like '%2022%'

select * from dbo.TP_CODIGOS
where CORRELATIVO =27733

select * from dbo.TP_CODIGOS
where ID_CLASIFICACION =33 and VALOR_TEXTO like '%-3%'
order by VALOR_TEXTO

select * from dbo.CLASIFICACIONES_GENERALES cg
where ID_CLASIFICACION in (115,33)

select * from dbo.CLASIFICACIONES_GENERALES cg
inner join dbo.TP_CODIGOS tp on tp.ID_CLASIFICACION = cg.ID_CLASIFICACION

where tp.ID_CLASIFICACION = 104



select * from dbo.TP_CODIGOS
where CORRELATIVO ='4439'

select * from dbo.CLASIFICACIONES_GENERALES cg
inner join dbo.TP_CODIGOS tp on tp.ID_CLASIFICACION = cg.ID_CLASIFICACION

where tp.ID_CLASIFICACION = 104 and cg.ESTADO='A'

use  Bd_Personal;
select p.IDENTIFICACION,p.id_persona,p. ID_CLIENTE,p. CG_TIPO_IDENTIFICACION, p.IDENTIFICACION, p.APELLIDOS, NOMBRES, CG_SEXO, CG_ESTADO_CIVIL, LIBRETA_MILITAR,
                         FEC_NACIMIENTO, CARNE_AFIL_IESS, CG_NACIONALIDAD, CG_LUG_NACIMIENTO, CG_PROVINCIA_NACE, CG_CANTON_NACE, CG_PARROQUIA_NACE,
                         CG_CIUDAD_RESIDE, CG_PROVINCIA_RESIDE, CG_CANTON_RESIDE, CG_PARROQUIA_RESIDE, BARRIO_RESIDE, CG_TIPO_SANGRE, TELEFONO,
                         CELULAR, DIRECCION, E_MAIL, FOTO, FECHA_DIGITACION, FECHA_INGRESO, FECHA_MOD, USUARIO_ING, USUARIO_MOD, ESTADO,
                         c.CG_TIPO_TRABAJADOR, CG_TITULO, DICTA_CLASES, CG_PAIS_TITULO, REGISTRO_TITULO, CG_UNIVERSIDAD_TITULO, CG_DEDICACION,
                         CG_NIVEL_TITULO, ID_CARRERA_LOCAL, ID_ASOCIACION, ID_PG_SEG_USUARIOS, CG_PAIS_RESIDE, EMAIL_INST, CG_PAIS_ORIGEN, CG_DISCAPACIDAD,
                         NUMERO_CONADIS, CG_IDENTIFICACIONETNICA, CG_NAC_INDIGENA, PORC_DISCAPACIDAD,FOTO_IMAGEN from bd_recursos_humanos.dbo.bd_Contratos c
inner join  Bd_Personal.dbo.PF_PERSONAS p on p.ID_PERSONA = c.id_persona
where
--     YEAR(c.Fecha_Contrato) ='2023' and c.EstadoContrato ='A' and
    p.IDENTIFICACION ='2400129876'


select * from personas where apellidos like '%GONZABAY GUALE%' and nombres like '%AZUCENA MERCEDES%'

EXECUTE Bd_Academico..sp_record_notas_estudiantes_historico 108, '12021230587'

exec  bd_sga_upse.[aca].[sp_list_all_carreras_records]  '0928028372' ,null, null , null, null

exec bd_sga_upse.[aca].[sp_list_all_asignaturas_detalle_record] 8251,null,null,
     null,null,null,null

select * from Bd_Academico..te_matriculas where MATRICULA='12021230587'

select * from bd_academico.dbo.materias_tomadas as d
where d.ID_MATERIA_TOMADA in(
SELECT mt.ID_MATERIA_TOMADA
--     FACULTAD = (SELECT FACULTAD FROM bd_academico.dbo.vw_te_carreras_localidad WHERE id_carrera_local = tm.id_carrera_local),
--     CARRERA = (SELECT carrera FROM bd_academico.dbo.vw_te_carreras_localidad WHERE id_carrera_local = tm.id_carrera_local),
--                p.IDENTIFICACION,
--                tm.MATRICULA,
--                p.APELLIDOS + ' ' + p.NOMBRES AS NOMBRE,
--     TIPO = 'MATERIAS',
--     FECHA = CASE WHEN mt.fecha_matricula IS NULL
--                      THEN CONVERT(VARCHAR(20), mt.fecha_ingreso, 103)
--                  ELSE CONVERT(VARCHAR(20), mt.fecha_matricula, 103)
--                    END,
--     PERIODO_ACADEMICO = (SELECT valor_texto FROM Bd_Academico..tp_codigos WHERE correlativo = tm.CG_PER_ACADEMICO AND ESTADO = 'A'),
--     NIVEL = (SELECT descripcion FROM bd_academico.dbo.niveles WHERE id_nivel = mt.id_nivel AND ESTADO = 'A'),
--     mt.ID_MATERIA_PLAN,
--     CONCEPTO = (SELECT MATERIA_NOMBRE from Bd_Academico..VW_MATERIAS_PLAN where ID_MATERIA_PLAN = mt.ID_MATERIA_PLAN),
--     mt.VALOR,
--     ABONO = CASE WHEN (SELECT TOTAL_LINEA FROM Bd_Academico..TE_DETALLE_OTROS_INGRESOS WHERE ID_DET_OTRO_INGRESO = mt.ID_DET_OTRO_INGRESO AND ESTADO = 'A') IS NULL
--                      THEN 0
--                  ELSE (SELECT TOTAL_LINEA FROM Bd_Academico..TE_DETALLE_OTROS_INGRESOS WHERE ID_DET_OTRO_INGRESO = mt.ID_DET_OTRO_INGRESO AND ESTADO = 'A')
--                    END,
--     DEUDA = CASE WHEN (SELECT TOTAL_LINEA FROM Bd_Academico..TE_DETALLE_OTROS_INGRESOS WHERE ID_DET_OTRO_INGRESO = mt.ID_DET_OTRO_INGRESO AND ESTADO = 'A') IS NULL
--                      THEN mt.VALOR
--                  ELSE mt.VALOR - (SELECT TOTAL_LINEA FROM Bd_Academico..TE_DETALLE_OTROS_INGRESOS WHERE ID_DET_OTRO_INGRESO = mt.ID_DET_OTRO_INGRESO AND ESTADO = 'A')
--                    END
FROM bd_academico.dbo.personas p
         INNER JOIN bd_academico.dbo.te_matriculas tm ON tm.id_persona = p.id_persona
         INNER JOIN bd_academico.dbo.materias_tomadas mt ON mt.id_matricula = tm.id_matricula
WHERE tm.estado='A' AND mt.estado='A'
  AND mt.valor > 0 AND mt.valor IS NOT NULL
  AND p.identificacion = '0928077809')


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
where-- (a.NOMBRE like '%INGLES%' or a.NOMBRE like '%ENGLISH%')
--    mt.VER_EN_RECORD =1 and
   p.IDENTIFICACION='2400122236'
  and mt.estado='A'

select p.identificacion as identificacion, mt.MATRICULA as matricula, p.APELLIDOS as apellidos, p.NOMBRES as nombres,
--mt.ID_NIVEL,
tipo=CASE
         WHEN mt.ID_NIVEL IN (11,30)  THEN 'EXTRACURRICULAR'
         WHEN mt.ID_NIVEL IN (1,2,3,4,5,6,7,8,9,10) THEN 'CURRICULAR'
         WHEN mt.ID_NIVEL IN (13,14,15,21,22) THEN 'CURRICULAR'
         ELSE 'OTROS'
           END,mt.ID_NIVEL,
    CONCAT(mt.AÑO,'-',mt.PERIODO) AS periodo,0 as idMallaAsignatura,'sistema 1999-2006' as sistema,
    mt.NOMBREMATERIA as asignatura,
    c.NOMBRE as oferta,
    mt.FINAL AS nota,
    mt.APROBAR AS	aprobado,
    iif(mt.HORAS is null, 0,  mt.HORAS) as horas,
    iif( mt.CREDITOS is null, 0,   mt.CREDITOS) as creditos,
estado=CASE
           WHEN mt.ver_en_record IN (0)  THEN 'E'
           WHEN mt.ver_en_record IN (1) THEN 'A'
           ELSE 'E'
           END,0 as idPeriodoAcademico
from sis.dbo.notas mt
         INNER JOIN Bd_Academico.dbo.PERSONAS p on p.ID_PERSONA=mt.id_persona
         inner join Bd_Academico.dbo.CARRERAS_LOCALES_MODALIDAD_SISTEMA c on c.ID_CARRERA_LOCAL=mt.ID_CARRERA_LOCAL and c.CG_MODALIDAD=mt.CG_MODALIDAD and c.CG_SISTEMA_ESTUDIO=mt.CG_SISTEMA_ESTUDIO
WHERE --(NOMBREMATERIA like '%INGLES%' or NOMBREMATERIA like 'ENGLISH%') and
      p.IDENTIFICACION='2400122236'

select p.identificacion,eo.numero_matricula as matricula,p.apellidos, p.nombres,
--ma.id_nivel,
tipo=CASE
         WHEN ma.id_nivel IN (1,2,3,4,5,6,7,8,9,10) THEN 'CURRICULAR'
         WHEN ma.id_nivel IN (12,13,14,15,16) THEN 'CURRICULAR'
         WHEN ma.id_nivel IN (17,18,19,20,21) THEN 'EXTRACURRICULAR'
         ELSE 'OTROS'
           END,
       ma.id_nivel as idNivel,
       pa.codigo as  periodo, ma.id_malla_asignatura as idMallaAsignatura,'sistema 2022-actualidad' as sistema,
       a.descripcion as asignatura,
       o1.descripcion as oferta,
       ea.promedio as nota,
       iif(ea.aprobado is null, 0, ea.aprobado) as aprobado,
       ma.num_horas as horas,
       ma.num_creditos as creditos,
       ea.estado,mg.id_periodo_academico
from  bd_sga_upse.aca.estudiante_oferta eo
          inner join bd_sga_upse.man.personas p on eo.id_persona=p.id
          inner join  bd_sga_upse.aca.estudiante_matricula em on em.id_estudiante_oferta=eo.id_estudiante_oferta
          inner join bd_sga_upse.aca.estudiante_asignatura ea on ea.id_estudiante_matricula=em.id_estudiante_matricula
          inner join bd_sga_upse.aca.matricula_general mg on mg.id_matricula_general=em.id_matricula_general
          inner join bd_sga_upse.aca.periodo_academico pa on mg.id_periodo_academico= pa.id_periodo_academico
          inner join bd_sga_upse.aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje=ea.id_asignatura_aprendizaje
          inner join bd_sga_upse.aca.malla_asignatura ma on ma.id_malla_asignatura=aa.id_malla_asignatura
          inner join bd_sga_upse.aca.malla ml on ml.id_malla=ma.id_malla
          inner join bd_sga_upse.aca.asignatura a on a.id_asignatura=ma.id_asignatura
          inner join bd_sga_upse.aca.oferta_modalidad om on om.id_oferta_modalidad=eo.id_oferta_modalidad
          inner join bd_sga_upse.aca.oferta o on o.id_oferta=om.id_oferta
          inner join bd_sga_upse.aca.oferta_modalidad om1 on om1.id_oferta_modalidad=ml.id_oferta_modalidad
          inner join bd_sga_upse.aca.oferta o1 on o1.id_oferta=om1.id_oferta
          inner join bd_sga_upse.aca.nivel n on n.id_nivel=ma.id_nivel
where ml.id_malla=20 and p.IDENTIFICACION='2400122236'

select mt.*
--     p.identificacion,m.matricula,p.APELLIDOS as apellidos, p.NOMBRES as nombres,pad.CG_PER_ACADEMICO,
-- tipo=CASE
--          WHEN mt.ID_NIVEL IN (11,30)  THEN 'EXTRACURRICULAR'
--          WHEN mt.ID_NIVEL IN (1,2,3,4,5,6,7,8,9,10) THEN 'CURRICULAR'
--          WHEN mt.ID_NIVEL IN (13,14,15,21,22) THEN 'CURRICULAR'
--          WHEN mt.ID_NIVEL IN (38,47,48,49,50,51) THEN 'EXTRACURRICULAR'
--          ELSE 'OTROS'
--            END,
--        mt.id_nivel as idNivel,
-- periodo = (select valor_texto from Bd_Academico.dbo.TP_CODIGOS where CORRELATIVO=pad.CG_PER_ACADEMICO),
-- -- rm.id_destino as idMallaAsignatura,
-- --modulos aprobados en carrera quitar si se daña
--     iif(mt.ID_NIVEL IN (1,2,3,4,5,6,7,8,9,10,13,14,15,21,22) and a.NOMBRE='INGLES I',1393,rm.id_destino) as idMallaAsignatura,
--     'sistema 2007-2021' as sistema,
--     a.NOMBRE as asignatura,
--     c.NOMBRE as oferta,
--     mt.PROMEDIO AS nota,
--     mt.APROBADO AS aprobado,
--     iif(mp.HORAS_SISTEMA is null, 0,  mp.HORAS_SISTEMA) as horas,
--     iif( mp.CREDITOS is null, 0,   mp.CREDITOS) as creditos,
--     mt.estado,pad.CG_PER_ACADEMICO
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
where-- (a.NOMBRE like '%INGLES%' or a.NOMBRE like '%ENGLISH%')
--    mt.VER_EN_RECORD =1 and
    p.IDENTIFICACION='2450168550'--and pad.CG_PER_ACADEMICO= 5439
  and mt.estado='A' and mt.ID_NIVEL = 4


--cantidad de graduados por ubicacion
select d.*,p.CG_PARROQUIA_RESIDE,p.CG_CANTON_RESIDE,p.CG_CIUDAD_RESIDE,p.BARRIO_RESIDE,p.CG_PROVINCIA_RESIDE from Bd_academico.dbo.EG_LISTADO_GRADUADOS as d
                                                                                                                      inner join Bd_academico..PERSONAS p on p.ID_PERSONA = d.ID_PERSONA
where cast(d.FECHA_GRADUACION as date) between '2022-01-01' and '2024-12-31' and (p.CG_PARROQUIA_RESIDE in (3858) or p.CG_CIUDAD_RESIDE in (1286,2197,2919,3216,3700) )


--TOTAL_GRADUADOS_ULTIMOS_5AÑOS
select d.FACULTAD,d.CARRERA,year(d.FECHA_GRADUACION) as año,count(d.IDENTIFICACION) as Numero_graduados from Bd_academico.dbo.EG_LISTADO_GRADUADOS as d
inner join Bd_academico..PERSONAS p on p.ID_PERSONA = d.ID_PERSONA
where cast(d.FECHA_GRADUACION as date) between '2019-01-01' and '2024-12-31'-- and (p.CG_PARROQUIA_RESIDE in (3858) or p.CG_CIUDAD_RESIDE in (1286,2197,2919,3216,3700) )
group by d.FACULTAD, d.CARRERA,year(d.FECHA_GRADUACION)

--NUMERO_GRADUADOS_POR_UBICACION_Y_SEXO
select d.FACULTAD,d.CARRERA,year(d.FECHA_GRADUACION) as año,cast(iif(sex.VALOR_TEXTO is null,'NO REGISTRA',sex.VALOR_TEXTO) as varchar(500))  as sexo,
       iif(pais.VALOR_TEXTO is null,'NO REGISTRA',pais.VALOR_TEXTO) as pais,iif(pro.VALOR_TEXTO is null,'NO REGISTRA',pro.VALOR_TEXTO) as provincia,
       iif(can.VALOR_TEXTO is null,'NO REGISTRA',can.VALOR_TEXTO) as canton,iif(par.VALOR_TEXTO is null,'NO REGISTRA',par.VALOR_TEXTO) as parroquia,
       count(d.IDENTIFICACION) as NUMERO_GRADUADOS from Bd_academico.dbo.EG_LISTADO_GRADUADOS as d
inner join Bd_academico..PERSONAS p on p.ID_PERSONA = d.ID_PERSONA
left join Bd_Personal..TP_CODIGOS sex on sex.CORRELATIVO = p.CG_SEXO
left join Bd_Personal..TP_CODIGOS pais on pais.CORRELATIVO = p.CG_PAIS_ORIGEN
left join Bd_Personal..TP_CODIGOS pro on pro.CORRELATIVO = p.CG_PROVINCIA_NACE
left join Bd_Personal..TP_CODIGOS can on can.CORRELATIVO = p.CG_CANTON_NACE
left join Bd_Personal..TP_CODIGOS par on par.CORRELATIVO = p.CG_PARROQUIA_NACE
where cast(d.FECHA_GRADUACION as date) between '2019-01-01' and '2024-12-31'-- and (p.CG_PARROQUIA_RESIDE in (3858) or p.CG_CIUDAD_RESIDE in (1286,2197,2919,3216,3700) )
group by d.FACULTAD, d.CARRERA,year(d.FECHA_GRADUACION), pais.VALOR_TEXTO,pro.VALOR_TEXTO,can.VALOR_TEXTO,par.VALOR_TEXTO,sex.VALOR_TEXTO


select * from mov.detalle_movilidad
where calificacion<>calif_inicial



select * from Bd_Personal..TP_CODIGOS pro where pro.CORRELATIVO in (6024,6112)
select * from Bd_Personal..TP_CODIGOS pro where pro.ID_CLASIFICACION =174