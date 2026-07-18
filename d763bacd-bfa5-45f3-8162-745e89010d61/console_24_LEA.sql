use bd_sga_upse;

--setear valores matriz LEA
-- set periodo correcto
update mig.estados_academicos_automatic  set periodo= case
        WHEN LEFT(PER_ID, 2) = 'I-' THEN CONCAT(RIGHT(PER_ID, 4), '-1')
        WHEN LEFT(PER_ID, 3) = 'II-' THEN CONCAT(RIGHT(PER_ID, 4), '-2')
        ELSE NULL END
where id_periodo_academico =136


select upper([man].[quitarTildes](ofa.carrera,1)) carrera_sin_tilde,carrera,modalidad from aca.ofertas_facultad ofa where ofa.id_tipo_oferta = 2
--set nombre de carrera sisweb
select distinct
    ea2.id_carrera_ofertada,ea2.id_oferta_modalidad,ea2.carrera_sga,concat(ea.CARRERA,' - ',iif(ea.CAMPUS_NOMBRE in ('LA LIBERTAD','SANTA ELENA'),'MATRIZ',ea.CAMPUS_NOMBRE)),
ea.*
--     update ea set ea.id_carrera_ofertada = ea2.id_carrera_ofertada,ea.id_oferta_modalidad = ea2.id_oferta_modalidad
--     update ea set ea.carrera_sga = concat(ea.CARRERA,' - ',iif(ea.CAMPUS_NOMBRE in ('LA LIBERTAD','SANTA ELENA'),'MATRIZ',ea.CAMPUS_NOMBRE))
from mig.estados_academicos_automatic ea
         left join mig.estados_academicos_automatic ea2 on ea2.carrera_sga = ea.carrera_sga  and ea2.CAMPUS_NOMBRE = ea.CAMPUS_NOMBRE and ea2.id_periodo_academico =95
where ea.periodo<'2022-1'   and ea.id_periodo_academico=136   and ea.id_carrera_ofertada is null


-- set ids
select distinct
    ea2.id_carrera_ofertada,ea2.id_oferta_modalidad,    ea.id_carrera_ofertada,ea.id_oferta_modalidad,ea2.carrera_sga,ea.carrera_sga,
    concat(ea.CARRERA,' - ',iif(ea.CAMPUS_NOMBRE in ('LA LIBERTAD','SANTA ELENA'),'MATRIZ',ea.CAMPUS_NOMBRE)),
    ea.*
--     update ea set ea.id_carrera_ofertada = ea2.id_carrera_ofertada,ea.id_oferta_modalidad = ea2.id_oferta_modalidad
from mig.estados_academicos_automatic ea
left join mig.estados_academicos_automatic ea2 on ea2.carrera_sga = ea.carrera_sga and ea2.periodo = ea.periodo and ea2.id_periodo_academico =96
where ea.periodo<'2022-1'   and ea.id_periodo_academico=136   and ea2.id_carrera_ofertada is not null and ea.id_carrera_ofertada is null

select * from mig.record_oferta where id_carrera_ofertada in (55,102)

select * from mig.record_oferta where  periodo ='2018-2'

--3304 3306
   select * from mig.estados_academicos_automatic ea where id_periodo_academico <> 136 and ea.periodo<'2022-1'
-- DBCC CHECKIDENT ('mig.estados_academicos_automatic', RESEED, 3306);

select * from mig.estados_academicos_automatic ea where id_periodo_academico = 136 and ea.periodo<'2022-1'

select distinct
    ea2.id_carrera_ofertada,ea2.id_oferta_modalidad,iif(ea2.id_oferta_modalidad <>63,ea2.id_carrera_ofertada,iif(ea.periodo<'2019-2',38,131)) as id_carrera_ofertada,
    ea.*
--     update ea set ea.id_carrera_ofertada = iif(ea2.id_oferta_modalidad <>63,ea2.id_carrera_ofertada,iif(ea.periodo<'2019-2',38,131))
from mig.estados_academicos_automatic ea
         inner join mig.estados_academicos_automatic ea2 on ea2.id_oferta_modalidad =ea.id_oferta_modalidad and  ea2.id_periodo_academico =95
where ea.periodo<'2022-1'   and ea.id_periodo_academico  <> 95 and ea.id_carrera_ofertada is null and ea2.id_carrera_ofertada is not null and ea2.id_carrera_ofertada<>131


---INGENIERIA INDUSTRIAL - MATRIZ
--     38 < 2019-2
-- 131 >= 2019-2


--set nombre correcto
select distinct
    ofa.id_oferta_modalidad,ofa.carrera,concat(ea.CARRERA,' - ',iif(ea.CAMPUS_NOMBRE in ('LA LIBERTAD','SANTA ELENA'),'MATRIZ',ea.CAMPUS_NOMBRE)),
    ea.*
--     update ea set ea.id_oferta_modalidad = ofa.id_oferta_modalidad,ea.carrera_sga = concat(ea.CARRERA,' - ',iif(ea.CAMPUS_NOMBRE in ('LA LIBERTAD','SANTA ELENA'),'MATRIZ',ea.CAMPUS_NOMBRE))
from mig.estados_academicos_automatic ea
         left join aca.ofertas_facultad ofa on upper([man].[quitarTildes](ofa.carrera,1)) = concat('NIVELACION DE ',ea.carrera_sga) --or ofa.carrera = ea.carrera_sga
    and ofa.id_tipo_oferta = 1
where ea.periodo>='2022-1'  and ea.id_periodo_academico = 136 and ea.carrera_sga is  null

select distinct
    ea.id_oferta_modalidad,ea1.id_oferta_modalidad,ea1.id_carrera_ofertada,ea1.carrera_sga,ea.carrera_sga,
    ea.*
-- update ea set ea.carrera_sga = concat(ea.CARRERA,' - ',iif(ea.CAMPUS_NOMBRE in ('LA LIBERTAD','SANTA ELENA'),'MATRIZ',ea.CAMPUS_NOMBRE))
--     update ea set ea.id_oferta_modalidad = ea1.id_oferta_modalidad
from mig.estados_academicos_automatic ea
         left join mig.estados_academicos_automatic ea1 on ea1.carrera_sga = ea.carrera_sga and ea1.CAMPUS_NOMBRE = ea.CAMPUS_NOMBRE  and ea1.id_periodo_academico  <> 136
where ea.periodo>='2022-1'  and ea.id_periodo_academico  = 136  and ea.id_oferta_modalidad is null and ea1.id_oferta_modalidad is not null and ea1.id_carrera_ofertada is not null
--   and ea.carrera_sga is  null

select * from mig.record_oferta
--                   PEDAGOGÍA DE LOS IDIOMAS NACIONALES Y EXTRANJEROS - MATRIZ
--          PEDAGOGÍA DE LOS IDIOMAS NACIONALES Y EXTRANJEROS - PLAYAS
select * from mig.estado_academicos ea

select * from  mig.estados_academicos_automatic ea where ea.id_periodo_academico= 136 and periodo >='2022-1'
select * from  mig.estados_academicos_automatic ea where ea.id_periodo_academico= 136 and periodo <'2022-1'
--1757
--1232
select * from  mig.estados_academicos_automatic ea where ea.id_periodo_academico <> 95 and periodo <'2022-1'
select * from  mig.estados_academicos_automatic ea where ea.id_periodo_academico= 95 and periodo <'2022-1'
select * from  mig.estados_academicos_automatic ea where ea.id_estado_academico=2612
 select * from   aca.ofertas_facultad ofa where id_tipo_oferta =1

-- update mig.estados_academicos_automatic set id_periodo_academico = 95

select id_periodo_academico,codigo,codigo_tipo_periodo,descripcion from aca.periodo_academico where id_tipo_oferta= 2

select * from mig.causistica

select * from mig.oferta_conexion

 select * from   mig.listar_carreras_sisweb gra where identificacion='2400235673'

select * from   mig.listar_carreras_sga gra where identificacion='0706736477'

select * from mig.record_oferta where identificacion='2400235673'

select * from mig.record_matricula where  id_record_oferta in (37385,37386)


select * from mig.record_oferta where identificacion='0958280505'

select * from mig.record_matricula where  id_record_oferta in (46799,46800)

select * from mig.listar_carreras_sisweb nivn where nivn.identificacion='0706736477'

select * from mig.oferta_conexion
select * from mig.causistica

select * from mig.estado_academicos where id_estado_cauistica = 10

select * from mig.estado_academicos where --carrera_sga='INFORMATICA - MATRIZ' --and
identificacion in ('2450221425','0931086060','0924921927','0802736314')

select * from man.personas where identificacion='2450853003'
select * from Bd_Academico..personas where identificacion='2450853003'

select * from mig.estado_academicos where id_estado_cauistica is null

select --ro.*
tee.descripcion,ro.id_record_oferta,ro.id_tipo_estado_estudiante,ro.identificacion,rm.periodo,ro.carrera, count(case when rm.estado='A' then 1 end )as contador_activas,
       count(case when rm.estado='M' then 1 end )as contador_no_efectivas
from mig.record_oferta ro
inner join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
inner join aca.tipo_estado_estudiante tee on ro.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
where rm.estado='M' and ro.id_tipo_oferta = 1 and ro.id_tipo_estado_estudiante not in (12,16,7)
group by ro.identificacion, ro.id_record_oferta, tee.descripcion, ro.carrera, rm.periodo, ro.id_tipo_estado_estudiante

select * from aca.tipo_estado_estudiante

select * from mig.causistica

select * from mig.record_oferta where identificacion='2450387010'

select * from mig.causistica

select * from mig.record_oferta where identificacion='2450344318'

select * from mig.record_oferta where identificacion='0706326618'

select * from mig.estado_academicos where identificacion='2450215054'



select * from mig.record_oferta where identificacion='0928350388'



select * from mig.estado_academicos where TIPO_CUPO<>'NIVELACION'



select * from mig.estado_academicos where id_estado_academico in (21992,
    21627,
28754,
21507,
26899
    )

select * from mig.listar_carreras_sga gra where gra.identificacion='2400230831'
--estado_academicos_final
select ea.*,ca.casuistica_resumida from mig.estado_academicos ea
inner join mig.causistica ca on ca.id_caso = ea.id_estado_cauistica
where fecha_mod is not null

select * from mig.causistica

select * from mig.estado_academicos where identificacion='0928623636'

select * from mig.estado_academicos where id_estado_cauistica is null

select * from mig.record_oferta where identificacion='0706736477'
select * from mig.listar_carreras_sga gra where gra.identificacion='2450577008'

select * from aca.tipo_estado_estudiante

select * from mig.record_oferta where id_number=18916

select * from Bd_Academico..TE_INSCRIPCIONES where ID_PERSONA=18071

select * from mig.estado_academicos where identificacion='2400305880'
--                                         id_estado_cauistica is  null

select * from mig.record_matricula where id_record_oferta = 34891


select *
-- update ea set ea.id_estado_cauistica =1
from mig.estado_academicos ea where ea.identificacion not in (select p.identificacion from man.personas p)
and ea.identificacion not in (select p.identificacion from Bd_Academico..PERSONAS p)
--      and ea.identificacion not in (select p.identificacion from bdupse.snu.aspirante p)

select p.* from bdupse.snu.aspirante p where p.identificacion='0105972715'

select ea.*,iif(a.identificacion is null,'CASOS DE REVISAR EN LOS ARCHIVITOS DE EXCEL NI RASTROS DE ELLOS EN NINGUN LADO','SI ESTAN CON ALGUN CUPO EN LA TABLITA DE KETTY')as caso from mig.estado_academicos ea
         left join bdupse.snu.aspirante a on a.identificacion = ea.identificacion
         where ea.identificacion not in (select p.identificacion from man.personas p)
                                         and ea.identificacion not in (select p.identificacion from Bd_Academico..PERSONAS p)

select * from aca.estudiante_oferta where id_estudiante_oferta = 18590



select * from mig.record_oferta where id_estudiante_oferta_destino is not null

select * from mig.listar_carreras_sisweb ni where ni.id_estudiante_oferta_destino is not null

select * from aca.tipo_estado_estudiante

select * from Bd_Academico..vw_listado_egresados

select * from Bd_academico.dbo.EG_LISTADO_GRADUADOS as d
select d.* from Bd_academico.dbo.EG_EGRESADOS as d

select o.ID_CARRERA_OFERTADA,d.* from Bd_academico.dbo.EG_EGRESADOS as d
inner join Bd_Academico.dbo.carreras_locales_modalidad_sistema o on o.ID_CARRERA_LOCAL= d.ID_CARRERA_LOCAL and o.CG_MODALIDAD = d.CG_MODALIDAD
                and o.CG_SISTEMA_ESTUDIO = d.CG_SISTEMA_ESTUDIO

select * from Bd_Academico.dbo.carreras_locales_modalidad_sistema as d

select * from aca.tipo_estado_estudiante

select * from aca.tipo_ingreso_estudiante




select d.* from (
select * from mig.listar_carreras_sisweb sis
union all
select * from mig.listar_carreras_sga as sga
)as d
where  d.id_tipo_oferta =1 and d.periodo_primer ='2021-1' and d.identificacion='0927942342'
and ((d.id_oferta_modalidad = 63) or (d.id_carrera_ofertada = 131))



--vista de datos sisweb
-- alter view mig.listar_carreras_sisweb as


select o.ID_CARRERA_OFERTADA,d.ID_EGRESADO,d.ID_PERSONA,d.FECHA_INGRESO,d.FECHA_EGRESO,d.ESTADO,
                              ROW_NUMBER() OVER (PARTITION BY d.FECHA_EGRESO ORDER BY d.FECHA_INGRESO asc ) as indice from Bd_academico.dbo.EG_EGRESADOS as d
                    inner join Bd_Academico..PERSONAS p on d.ID_PERSONA = p.ID_PERSONA
                    inner join Bd_Academico.dbo.carreras_locales_modalidad_sistema o on o.ID_CARRERA_LOCAL= d.ID_CARRERA_LOCAL and o.CG_MODALIDAD = d.CG_MODALIDAD
                    and o.CG_SISTEMA_ESTUDIO = d.CG_SISTEMA_ESTUDIO where d.ESTADO='A' and p.IDENTIFICACION='0705446011'
select * from Bd_academico.dbo.EG_LISTADO_GRADUADOS as g where g.IDENTIFICACION='0705446011'

select * from Bd_academico.dbo.EG_LISTADO_GRADUADOS as g where g.IDENTIFICACION='0705446011'
select d.* from Bd_academico.dbo.EG_EGRESADOS as d where d.ID_PERSONA= 23855

select * from Bd_academico.dbo.EG_LISTADO_GRADUADOS as d where d.ID_PERSONA= 23855

select * from mig.record_oferta where id_estudiante_oferta_destino is not null

select d.*,ROW_NUMBER() OVER (PARTITION BY d.FECHA_EGRESO ORDER BY d.FECHA_INGRESO asc ) as orden
--     o.ID_CARRERA_OFERTADA,d.FECHA_INGRESO,d.FECHA_EGRESO,d.ESTADO
from Bd_academico.dbo.EG_EGRESADOS as d
inner join Bd_Academico..PERSONAS p on d.ID_PERSONA = p.ID_PERSONA
inner join Bd_Academico.dbo.carreras_locales_modalidad_sistema o on o.ID_CARRERA_LOCAL= d.ID_CARRERA_LOCAL and o.CG_MODALIDAD = d.CG_MODALIDAD
                and o.CG_SISTEMA_ESTUDIO = d.CG_SISTEMA_ESTUDIO
where d.ESTADO='A' and p.IDENTIFICACION='0927963272'

select * from mig.estado_academicos where identificacion='2400254286'

select * from mig.causistica


select*
-- update ea set id_estado_cauistica=13,fecha_mod=getdate(),observacion='IDENTIFICACIÓN EN MATRIZ LEA DIFERENTES A LA REGISTRADA EN LOS SISTEMAS'
from mig.estado_academicos ea
where ea.id_estado_academico in (22707,23121)
-- where ea.id_estado_academico in (22168,8889,14916,5454,4832,22590,5792,24943)
-- where ea.id_estado_academico in (22507,22560,22591,22939,23032,23163)


select * from aca.acta_apertura
where id_acta_calificacion in (25546,25547,25548)
select * from aca.acta_apertura where id_acta_apertura in (2282,2283,2284)
select * from aca.acta_apertura_componente where id_acta_apertura in (2282,2283,2284)

--1,2,8,9,10
select id_componente_aprendizaje,abreviatura,descripcion from aca.componente_aprendizaje

-- select*
-- update ea set id_estado_cauistica=23,fecha_mod=getdate(),observacion='IDENTIFICACIÓN EN MATRIZ LEA DIFERENTES A LA REGISTRADA EN LOS SISTEMAS'
-- from mig.estado_academicos ea
-- where ea.id_estado_academico in (25229)

select * from mig.estado_academicos where identificacion='1006515715'

select * from mig.estado_academicos ea
where ea.id_estado_cauistica<>ea.id_casuistica_anterior_2

select *
-- update ea set ea.id_estado_cauistica =1
from bdupse.snu.aspirante ea where  ea.identificacion not in (select p.identificacion from man.personas p where p.estado='AC')
                               and ea.identificacion not in (select p.identificacion from Bd_Academico..PERSONAS p where p.ESTADO='A') and
    concat(ea.apellidos, ' ',ea.nombres)  not in ((select concat(p.apellidos, ' ',p.nombres) from Bd_Academico..PERSONAS p))
                               and concat(ea.apellidos, ' ',ea.nombres) not in ((select concat(p.apellidos, ' ',p.nombres) from man.personas p))

select * from mig.estado_academicos ea
where ea.id_estado_cauistica<>ea.id_casuistica_anterior_2

select aa.identificacion,aa.apellidos,aa.id_casuistica_anterior,aa.nombres,ea.*
from bdupse.snu.aspirante ea
left join mig.estado_academicos aa on aa.nombres = ea.nombres and aa.apellidos = ea.apellidos -- and aa.id_estado_cauistica<>aa.id_casuistica_anterior_2
where
    ea.identificacion not in (select p.identificacion from man.personas p where p.estado='AC')
                               and ea.identificacion not in (select p.identificacion from Bd_Academico..PERSONAS p where p.ESTADO='A') and
    concat(ea.apellidos, ' ',ea.nombres) in ((select concat(p.apellidos, ' ',p.nombres) from Bd_Academico..PERSONAS p))
                               and concat(ea.apellidos, ' ',ea.nombres) in ((select concat(p.apellidos, ' ',p.nombres) from man.personas p))
and aa.id_casuistica_anterior not in (13,23)

select * from aca.tipo_estado_estudiante
select * from aca.tipo_ingreso_estudiante

selecT * from mig.record_oferta where id_estudiante_oferta_destino is not null

selecT * from mig.record_oferta where identificacion in ('2450409418')

select * from Bd_Academico..TE_MATRICULAS te where te.ID_PERSONA = 47761 and MATRICULA='12021811076'

selecT * from mig.record_matricula where id_record_oferta in (67486)
select * from mig.causistica

select * from mig.record_oferta where estado = 'I'

selecT * from mig.estado_academicos where identificacion in ('2450221425','0931086060')
selecT * from mig.record_oferta where identificacion in ('2450221425','0931086060')

select * from mig.record_matricula where id_record_oferta in (66119,66120)


select  * from man.personas where identificacion in ('1006515715')


select * from man.persona_identificacion
select  * from man.personas where identificacion in ('2400156481','2400268898')
select * from Bd_Academico..PERSONAS where IDENTIFICACION in ('1006515715','FB612715')




select*
-- update ea set id_casuistica_anterior_2 = id_estado_cauistica
from mig.estado_academicos ea
where ea.id_estado_academico in (18967,19254,19310,18972,19270)

select * from  mig.estado_academicos ea
where ea.id_estado_cauistica<>ea.id_casuistica_anterior_2


select * from  mig.estado_academicos ea
where --ea.id_estado_cauistica =1 and
      len(ea.identificacion)<>10
and ea.identificacion not in (select p.identificacion from bdupse.snu.aspirante p)

--     0966753634 2490400543 118212842

select * from mig.record_oferta where id_persona_cg in (1195,7188)

--final listar LEA
select ea.*,ca.casuistica_resumida,can.casuistica_resumida
--  EA.id_estado_academico,carrera_sga,periodo,identificacion,apellidos,nombres,id_estado_cauistica,id_casuistica_anterior_2
from mig.estado_academicos ea
         inner join mig.causistica ca on ca.id_caso = ea.id_estado_cauistica
         inner join mig.causistica can on can.id_caso = ea.id_casuistica_anterior_2
where fecha_mod is not null
  and ea.id_casuistica_anterior_2 <>ea.id_estado_cauistica


select distinct observacion from mig.estado_academicos ea
                                     inner join mig.causistica ca on ca.id_caso = ea.id_estado_cauistica
where ea.id_casuistica_anterior_2 <>ea.id_estado_cauistica

update ea set ea.id_estado_cauistica = 13,observacion='NO ERA 3 VEZ MATRICULA ACTIVA',fecha_mod=getdate() from mig.estado_academicos ea  where ea.id_estado_academico = 28416

update ea set ea.id_estado_cauistica = 23, observacion='NO ERA 3 VEZ MATRICULA ACTIVA', fecha_mod=getdate() from mig.estado_academicos ea  where ea.id_estado_academico = 23127


select * from man.lugar
select * from man.personas where identificacion in ('0921980413')
select * from man.personas where   (apellidos like '%ZAMBRANO CORNEJO%' and nombres like '%MARIA ARGELY%')   or
                                identificacion in ('0810161554','0910151554')

select * from mig.record_oferta where identificacion in ('0705527018')
select * from mig.record_asignaturas where id_record_oferta = 61998
-- update  tes.documento_contable set id_persona = 3570 where id_persona =57975

select * from Bd_Academico..personas where (apellidos like '%ZAMBRANO CORNEJO%' and nombres like '%MARIA ARGELY%')
                                        or
    identificacion in ('2400446601','2400105678')

select * from Bd_Academico..personas where  (apellidos like '%ZAMBRANO CORNEJO%' and nombres like '%MARIA ARGELY%')


select p.* from bdupse.snu.aspirante p where -- (apellidos like '%MENDEZ%' and nombres like '%JAVIER%') or
    identificacion in ('0705527018')

select p.* from bdupse.snu.aspirante p where len(identificacion)<>10
select * from man.persona_identificacion

update ea set ea.id_estado_cauistica = 23,observacion='IDENTIFICACIÓN Y NOMBRES DIFERENTES EN MATRIZ LEA Y SISTEMAS',fecha_mod=getdate() from mig.estado_academicos ea  where ea.id_estado_academico = 23094

update ea set ea.id_estado_cauistica = 23,observacion='IDENTIFICACIÓN EN MATRIZ LEA DIFERENTES A LA REGISTRADA EN LOS SISTEMAS Y EXISTIA INFORMACION DIVIDIDA',
              fecha_mod=getdate() from mig.estado_academicos ea  where ea.id_estado_academico = 17990
--ver posibles records divididos
select ro.apellidos,ro.nombres,count(distinct ro.identificacion) from  mig.record_oferta ro
group by ro.apellidos, ro.nombres
having count(distinct ro.identificacion)>1
-- 0940040223

select ro.apellidos,ro.nombres,count(distinct ro.id_persona_cg) from  mig.record_oferta ro
group by ro.apellidos, ro.nombres
having count(distinct ro.identificacion)>1

select * from mig.record_oferta where (apellidos like '%ZAMBRANO CORNEJO%' and nombres like '%MARIA ARGELY%')

select * from mig.record_matricula where  id_record_oferta in (63113,63114,63115)

--me quede en 23 ORDEN ALFABETICO
select * from  mig.estado_academicos ea where identificacion in ('0923670210','0923570210')

select * from mig.estado_academicos where (apellidos like '%TORRES SANCHÉZ%' and nombres like '%ANA JACKELINE%')
select * from mig.estado_academicos where id_estado_cauistica  not in (13,23)
and len(identificacion)<>10

SELECT * FROM mig.estado_academicos WHERE (apellidos LIKE '%[áéíóúÁÉÍÓÚ]%' OR
    apellidos LIKE '%?%' ) and  id_estado_cauistica  not in (13,23)

update ea set ea.id_estado_cauistica = 23,observacion='IDENTIFICACIÓN EN MATRIZ LEA DIFERENTES A LA REGISTRADA EN LOS SISTEMAS Y EXISTIA INFORMACION DIVIDIDA',
              fecha_mod=getdate() from mig.estado_academicos ea  where ea.id_estado_academico = 17990

update ea set ea.id_estado_cauistica = 23,observacion='NUEVOS EGRESADOS Y GRADUADOS',
              fecha_mod=getdate() from mig.estado_academicos ea  where ea.id_estado_academico = 12923

---actualizar matriculas de seguridad industrial
select distinct
       eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.id_periodo_academico,pa.codigo,p.id as id_persona,eo.ultimo_periodo,eo.mantiene_gratuidad,p.identificacion,p.apellidos,p.nombres,o.descripcion as carrera,
       o1.descripcion as carrera_padre,pp.apellidos,pp.nombres,eo.numero_matricula,eo.id_periodo_academico,eo.fecha_ingreso,tee.descripcion as tipo,tee.observacion
-- eop.id_estudiante_oferta,em.*
--     update em set em.id_estudiante_oferta = eop.id_estudiante_oferta
from man.personas p
inner join aca.estudiante_oferta eo on eo.id_persona = p.id
inner join aca.estudiante_oferta eop on eop.id_estudiante_oferta_padre = eo.id_estudiante_oferta
-- inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
-- inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
inner join man.personas pp on pp.id= eop.id_persona
inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
inner join aca.oferta o on om.id_oferta = o.id_oferta
inner join aca.oferta_modalidad om1 on eop.id_oferta_modalidad = om1.id_oferta_modalidad
inner join aca.oferta o1 on om1.id_oferta = o1.id_oferta
where  eo.id_oferta_modalidad in (83) and eo.id_periodo_academico =30-- and mg.id_periodo_academico not in (30)


--actualizar movilidad de estudiantes de seguridad industrial
select distinct eo.*
--     eop.id_estudiante_oferta,eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.id_periodo_academico,m.id_periodo_academico,m.estado,pa.codigo,p.id as id_persona,eo.ultimo_periodo,
--     eo.mantiene_gratuidad,p.identificacion,p.apellidos,p.nombres,o.descripcion as carrera,eo.numero_matricula,eo.id_periodo_academico,eo.fecha_ingreso,tee.descripcion as tipo,tee.observacion
-- eop.id_estudiante_oferta,em.*
--     update m set m.id_estudiante_oferta = eop.id_estudiante_oferta
from man.personas p
    inner join aca.estudiante_oferta eo on eo.id_persona = p.id
    inner join aca.estudiante_oferta eop on eop.id_estudiante_oferta_padre = eo.id_estudiante_oferta
    left join aca.movilidad m on eop.id_estudiante_oferta = m.id_estudiante_oferta
    inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
    inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
    inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
    inner join aca.oferta o on om.id_oferta = o.id_oferta
where  eo.id_oferta_modalidad in (83) and eo.id_periodo_academico =30-- and p.identificacion ='2450933862'-- and m.id_periodo_academico  in (35)
--  p.identificacion='2450058280'
select  distinct ea.* from aca.estudiante_matricula em
inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
where em.id_estudiante_oferta =53034 and em.id_matricula_general = 16-- and em.estado='A'

select top 7 id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta =2


select * from aca.tipo_estado_estudiante
select * from aca.estudiante_malla
select distinct --p.identificacion,p.id,
--                 eo.*
                eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.id_periodo_academico,pa.codigo,p.id as id_persona,eo.ultimo_periodo,eo.mantiene_gratuidad,p.identificacion,p.apellidos,p.nombres,o.descripcion as carrera,
--                 count(em.id_estudiante_matricula) as matriculas,
                eo.numero_matricula,eo.id_periodo_academico,eo.fecha_ingreso,tee.descripcion as tipo,tee.observacion
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
--         inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
         left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
         left join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         left join aca.oferta o on om.id_oferta = o.id_oferta
         left join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
where eo.estado='A' and EO.id_estudiante_oferta > 45377 and eo.id_estudiante_oferta <56481
      and eo.id_estudiante_oferta in (45669, 45690,52950,53031,53032,53033,53034,53035,53036,53037,53038,53100,53192,53252,53253,53254,53255,53256,53257,
53258,53259,53260,53261,53262,53263,53264,53265,53266,53267,53268,53269,53270,53271,53319,53352,
53483,53519,53532,53537,53538,56465,56469,56470,56471)-- and em.estado='A'
-- group by eo.id_estudiante_oferta, eo.id_estudiante_oferta_padre, eo.id_periodo_academico, pa.codigo, p.id, eo.ultimo_periodo,
--          eo.mantiene_gratuidad, p.identificacion, p.apellidos, p.nombres, o.descripcion, eo.numero_matricula, eo.fecha_ingreso, tee.descripcion, tee.observacion

--actualizar actas de calificaciones
select distinct eo.*
--     eop.id_estudiante_oferta,eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.id_periodo_academico,m.id_periodo_academico,m.estado,pa.codigo,p.id as id_persona,eo.ultimo_periodo,
--     eo.mantiene_gratuidad,p.identificacion,p.apellidos,p.nombres,o.descripcion as carrera,eo.numero_matricula,eo.id_periodo_academico,eo.fecha_ingreso,tee.descripcion as tipo,tee.observacion
-- eop.id_estudiante_oferta,em.*
--     update m set m.id_estudiante_oferta = eop.id_estudiante_oferta
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         inner join aca.estudiante_oferta eop on eop.id_estudiante_oferta_padre = eo.id_estudiante_oferta
         left join aca.movilidad m on eop.id_estudiante_oferta = m.id_estudiante_oferta
         inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
         inner join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
where  eo.id_oferta_modalidad in (83) and eo.id_periodo_academico =30



select * from aca.estudiante_matricula where id_estudiante_oferta = 53033

select * from aca.estudiante_asignatura where id_estudiante_matricula = 75894

select * from aca.tipo_ingreso_estudiante

select distinct --p.identificacion,p.id,
                eo.*
--                 eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.id_periodo_academico,pa.codigo,p.id as id_persona,eo.ultimo_periodo,eo.mantiene_gratuidad,p.identificacion,p.apellidos,p.nombres,o.descripcion as carrera,
--                 eo.numero_matricula,eo.id_periodo_academico,eo.fecha_ingreso,tee.descripcion as tipo,tee.observacion
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
         left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
         left join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         left join aca.oferta o on om.id_oferta = o.id_oferta
         left join aca.tipo_estado_estudiante tee on eo.id_tipo_estado_estudiante = tee.id_tipo_estado_estudiante
where  eo.id_oferta_modalidad in (83) and eo.id_periodo_academico =30


select * from aca.malla


select ea.* from aca.estudiante_matricula em
inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
where em.id_estudiante_oferta =44089

select o.descripcion,om.* from aca.oferta_modalidad om
                                   inner join aca.oferta o on om.id_oferta = o.id_oferta
where om.estado='A' and o.id_tipo_oferta = 2

--generar numero de matricula
begin
    declare @id_oferta_modalidad int = 59,@id_periodo_academico int = 14,@codidoPeriodo varchar(25)
    select @codidoPeriodo=CONCAT(SUBSTRING(pa.codigo, 1, 4),SUBSTRING(pa.codigo, 6, 1))  from aca.periodo_academico pa where pa.id_periodo_academico = 14
select
CONCAT(@codidoPeriodo,RIGHT('000' + Ltrim(Rtrim(Rtrim((0)+@id_oferta_modalidad))),3),RIGHT('00' + Ltrim(Rtrim(Rtrim((0)+3))),2) ,RIGHT('00000' + Ltrim(Rtrim(Rtrim((0)+
(select count(p.identificacion) from aca.estudiante_oferta eo
      inner join man.personas p on p.id = eo.id_persona
where eo.id_oferta_modalidad = @id_oferta_modalidad and Cast(eo.fecha_ingreso) and p.estado='AC' and eo.estado='A')+1))),5) )
end

select * from mig.estado_academicos
select * from mig.estados_academicos_automatic


----generar nuevo lea 2025
select * from mig.estados_academicos_automatic ea where id_periodo_academico <>95 and id_casuistica is null
select * from mig.estados_academicos_automatic ea where id_periodo_academico <>95 and periodo<'2022-1'
select * from mig.estados_academicos_automatic ea where OBSERVACION is not null or id_estado_academico in (2339,    2627
    )
select * from  aca.ofertas_facultad ofa where id_tipo_oferta = 1

select * from aca.tipo_estado_estudiante
select * from aca.tipo_ingreso_estudiante

select * from mig.causistica where periodo='2025-2'

select ro.periodo,rj.* from mig.record_oferta_jerarquia rj
         inner join mig.record_oferta ro on ro.id_record_oferta = rj.id_record_origen
         where rj.identificacion='2450344839'

select ro.* from mig.record_oferta ro
where ro.identificacion='2450344839'

select ro.* from mig.record_oferta ro where ro.id_carrera_ofertada in (102,55)
select * from mig.estados_academicos_automatic ea where id_periodo_academico =136

select * from mig.causistica where periodo ='2026-1'
--volver aqui
---revisar solo sisweb 110+52+253
-- select d.*
-- from (
         select ea.id_estado_academico,ea.identificacion,ea.apellidos,ea.nombres,ea.id_oferta_modalidad,ea.id_carrera_ofertada,ea.carrera_sga,ea.periodo,ea.id_casuistica,
                niv.id_record_oferta,niv.id_record_oferta_padre,niv.carrera,niv.periodo_primer,niv.periodo_ultimo,niv.codigo_estado_carrera,
                niv.estado_carrera,niv.codigo_ingreso,niv.tipo_ingreso,niv.estado_registro,
                gra.id_record_oferta as id_record_oferta_gra,gra.id_record_oferta_padre as id_record_oferta_padre_gra,gra.carrera as carrera_gra,gra.periodo_primer as periodo_primer_gra,gra.periodo_ultimo as periodo_ultimo_gra,
                gra.codigo_estado_carrera as codigo_estado_carrera_gra,gra.estado_carrera as estado_carrera_gra,
                gra.codigo_ingreso as codigo_ingreso_gra,gra.tipo_ingreso as tipo_ingreso_gra,gra.estado_registro as estado_registro_gra,gra.numero_matriculas_sga,gra.numero_matriculas_sis,gra.fecha_egreso,gra.fecha_graduacion,gra.id_tipo_oferta,
                gra.reprobo_tercera_vez,
--     update ea set ea.id_casuistica =
                case when niv.codigo_estado_carrera='NO-USO-CUPO' then  1
                     when niv.codigo_estado_carrera='CUPOINACREUBICA' and gra.carrera is null  then  2
                     when niv.codigo_estado_carrera ='ACT' and niv.periodo_ultimo='2026-1' then 6
                     when niv.codigo_estado_carrera in ('INACS','INANUSM','INACD','CUPOOIESS','CUPOINVALIDADO')  then 7
                     when niv.codigo_estado_carrera='ACT' and niv.periodo_ultimo<='2025-1' then 7
                     when niv.codigo_estado_carrera='ACT' and niv.periodo_ultimo>='2025-2' and niv.periodo_ultimo<='2026-1' then 8
                     when niv.codigo_estado_carrera='INACSM' then 26
                     when niv.codigo_estado_carrera='APR' and gra.codigo_estado_carrera ='CARRERANOOCUPADA' then 9
                     when niv.codigo_estado_carrera='APR' and gra.codigo_estado_carrera='ACT' and gra.periodo_primer is null and niv.periodo_primer<='2025-1'
                         and gra.codigo_ingreso not in ('REDISENIO-SEDE','CAMBIO-MALLA','RESIDENIO-CARRERA','REDISENIO-SIS-EST','REDISENIO-REV-NORM','RESIDENIO-MODALIDAD','MOV')
                         and gra.numero_matriculas_sis=0 and gra.numero_matriculas_sga=0 then 9
                     when niv.codigo_estado_carrera='APR' and gra.periodo_primer is null and niv.periodo_ultimo>='2025-2' then 10
                     when niv.codigo_estado_carrera='APR' and gra.periodo_primer is not null and gra.estado_registro in ('N','X','R','T','H','O') then 10
                     when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='ACT' and gra.periodo_primer is not null and gra.periodo_ultimo is not null
                         and gra.fecha_egreso is null and  gra.fecha_graduacion is null and gra.reprobo_tercera_vez=0 then 13
                     when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='ACT' and (gra.numero_matriculas_sis>0 or gra.numero_matriculas_sga>0) then 13
                     when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='ACT' and gra.periodo_primer is null and gra.periodo_ultimo is null
                         and gra.codigo_ingreso in ('REDISENIO-SEDE','CAMBIO-MALLA','RESIDENIO-CARRERA','REDISENIO-SIS-EST','REDISENIO-REV-NORM','RESIDENIO-MODALIDAD','MOV')  then 13
                     when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera = 'PERDIDACARRERA'  then 14
                     when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.reprobo_tercera_vez > 0 and  gra.fecha_graduacion is null and gra.fecha_egreso is null  then 14
                     when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='GRA' then 23
                     when niv.codigo_estado_carrera='APR' and gra.fecha_egreso is not null and  gra.fecha_graduacion is not null then 23
                     when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='EGR' then 24
                     when niv.codigo_estado_carrera='APR' and gra.fecha_egreso is not null and  gra.fecha_graduacion is null then 24 end
--                     as id_estado_set_casuistica
         from mig.estados_academicos_automatic ea
        left join mig.listar_carreras_sisweb niv on niv.identificacion = ea.identificacion and niv.periodo_cupo=ea.periodo and niv.id_carrera_ofertada=ea.id_carrera_ofertada
        and niv.id_tipo_oferta = 1
        left join mig.record_oferta_jerarquia roj on roj.id_record_origen = niv.id_record_oferta and roj.nodos_max>0
        left join mig.listar_carreras_sisweb gra on gra.id_record_oferta = roj.id_record_final
         where ea.TIPO_CUPO in ('NIVELACIÓN','NIVELACION')
--            and niv.id_record_oferta is  null
           and niv.id_estudiante_oferta is null and niv.id_estudiante_oferta_destino is null and gra.id_estudiante_oferta is null and gra.id_estudiante_oferta_destino is null
         and ea.periodo<'2022-1' and ea.id_periodo_academico=136 and ea.id_casuistica is null
--      ) as d
--          inner join mig.estado_academicos ea on ea.id_estado_academico = d.id_estado_academico
-- where d.id_casuistica<>d.id_estado_set_casuistica

--manes que aprobaron el pre een el sisweb y todo lo demas esta en el SGA
-- select d.*
-- from (
         select  distinct ea.id_estado_academico,ea.identificacion,ea.apellidos,ea.nombres,ea.id_oferta_modalidad,ea.id_carrera_ofertada,ea.carrera_sga,ea.periodo,ea.id_casuistica,
                niv.id_record_oferta,niv.id_record_oferta_padre,niv.carrera,niv.periodo_primer,niv.periodo_ultimo,niv.codigo_estado_carrera,
                niv.estado_carrera,niv.codigo_ingreso,niv.tipo_ingreso,niv.estado_registro,
                gra.id_record_oferta as id_record_oferta_gra,gra.id_record_oferta_padre as id_record_oferta_padre_gra,gra.carrera as carrera_gra,gra.periodo_primer as periodo_primer_gra,
                gra.periodo_ultimo as periodo_ultimo_gra,
                gra.codigo_estado_carrera as codigo_estado_carrera_gra,gra.estado_carrera as estado_carrera_gra,
                gra.codigo_ingreso as codigo_ingreso_gra,gra.tipo_ingreso as tipo_ingreso_gra,gra.estado_registro as estado_registro_gra,gra.numero_matriculas_sga,gra.numero_matriculas_sis,gra.fecha_egreso,gra.fecha_graduacion,gra.id_tipo_oferta,
                gra.reprobo_tercera_vez,
--     update ea set ea.id_casuistica =
                          case when niv.codigo_estado_carrera='NO-USO-CUPO' then  1
                               when niv.codigo_estado_carrera='CUPOINACREUBICA' and gra.carrera is null  then  2
                               when niv.codigo_estado_carrera ='ACT' and niv.periodo_ultimo='2026-1' then 6
                               when niv.codigo_estado_carrera in ('INACS','INANUSM','INACD','CUPOOIESS','CUPOINVALIDADO')  then 7
                               when niv.codigo_estado_carrera='ACT' and niv.periodo_ultimo<='2025-1' then 7
                               when niv.codigo_estado_carrera='ACT' and niv.periodo_ultimo>='2025-2' and niv.periodo_ultimo<='2026-1' then 8
                               when niv.codigo_estado_carrera='INACSM' then 26
                               when niv.codigo_estado_carrera='APR' and gra.codigo_estado_carrera ='CARRERANOOCUPADA' then 9
                               when niv.codigo_estado_carrera='APR' and gra.codigo_estado_carrera='ACT' and gra.periodo_primer is null and niv.periodo_primer<='2025-1'
                                   and gra.codigo_ingreso not in ('REDISENIO-SEDE','CAMBIO-MALLA','RESIDENIO-CARRERA','REDISENIO-SIS-EST','REDISENIO-REV-NORM','RESIDENIO-MODALIDAD','MOV')
                                   and gra.numero_matriculas_sis=0 and gra.numero_matriculas_sga=0 then 9
                               when niv.codigo_estado_carrera='APR' and gra.periodo_primer is null and niv.periodo_ultimo>='2025-2' then 10
                               when niv.codigo_estado_carrera='APR' and gra.periodo_primer is not null and gra.estado_registro in ('N','X','R','T','H','O') then 10
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='ACT' and gra.periodo_primer is not null and gra.periodo_ultimo is not null
                                   and gra.fecha_egreso is null and  gra.fecha_graduacion is null and gra.reprobo_tercera_vez=0 then 13
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='ACT' and (gra.numero_matriculas_sis>0 or gra.numero_matriculas_sga>0) then 13
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='ACT' and gra.periodo_primer is null and gra.periodo_ultimo is null
                                   and gra.codigo_ingreso in ('REDISENIO-SEDE','CAMBIO-MALLA','RESIDENIO-CARRERA','REDISENIO-SIS-EST','REDISENIO-REV-NORM','RESIDENIO-MODALIDAD','MOV')  then 13
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera = 'PERDIDACARRERA'  then 14
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.reprobo_tercera_vez > 0 and  gra.fecha_graduacion is null and gra.fecha_egreso is null  then 14
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='GRA' then 23
                               when niv.codigo_estado_carrera='APR' and gra.fecha_egreso is not null and  gra.fecha_graduacion is not null then 23
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='EGR' then 24
                               when niv.codigo_estado_carrera='APR' and gra.fecha_egreso is not null and  gra.fecha_graduacion is null then 24 end
                    as id_estado_set_casuistica
         from mig.estados_academicos_automatic ea
                  left join mig.listar_carreras_sisweb niv on niv.identificacion = ea.identificacion and niv.periodo_cupo=ea.periodo and niv.id_carrera_ofertada=ea.id_carrera_ofertada
             and niv.id_tipo_oferta = 1
            left join mig.record_oferta_jerarquia roj on roj.id_record_origen = niv.id_record_oferta and roj.nodos_max>0
            left join mig.listar_carreras_sisweb grap on grap.id_record_oferta = roj.id_record_final
            left join mig.estudiante_oferta_jerarquia eoj on eoj.id_estudiante_oferta_origen = niv.id_estudiante_oferta_destino
            left join mig.listar_carreras_sga gra on gra.id_estudiante_oferta = eoj.id_estudiante_oferta_final
         where ea.TIPO_CUPO in ('NIVELACIÓN','NIVELACION')
--            and niv.id_record_oferta is  null
           and niv.id_estudiante_oferta_destino is not null
           and grap.id_estudiante_oferta is null and grap.id_estudiante_oferta_destino is null
           and ea.periodo<'2022-1' and ea.id_periodo_academico=136 and ea.id_casuistica is null
--      ) as d
-- where d.id_casuistica<>d.id_estado_set_casuistica

select * from mig.graduados where identificacion='0850009192'
select * from mig.causistica where periodo='2025-1'
--sisweb con continuacion en sga
-- select d.*
-- from (
         select  distinct ea.id_estado_academico,ea.identificacion,ea.apellidos,ea.nombres,ea.id_oferta_modalidad,ea.id_carrera_ofertada,ea.carrera_sga,ea.periodo,ea.id_casuistica,
                          niv.id_record_oferta,niv.id_record_oferta_padre,niv.carrera,niv.periodo_primer,niv.periodo_ultimo,niv.codigo_estado_carrera,
                          niv.estado_carrera,niv.codigo_ingreso,niv.tipo_ingreso,niv.estado_registro,
                          gra.id_record_oferta as id_record_oferta_gra,gra.id_record_oferta_padre as id_record_oferta_padre_gra,gra.carrera as carrera_gra,gra.periodo_primer as periodo_primer_gra,gra.periodo_ultimo as periodo_ultimo_gra,
                          gra.codigo_estado_carrera as codigo_estado_carrera_gra,gra.estado_carrera as estado_carrera_gra,
                          gra.codigo_ingreso as codigo_ingreso_gra,gra.tipo_ingreso as tipo_ingreso_gra,gra.estado_registro as estado_registro_gra,gra.numero_matriculas_sga,gra.numero_matriculas_sis,gra.fecha_egreso,gra.fecha_graduacion,gra.id_tipo_oferta,
                          gra.reprobo_tercera_vez,
--     update ea set ea.id_casuistica =
                          case when niv.codigo_estado_carrera='NO-USO-CUPO' then  1
                               when niv.codigo_estado_carrera='CUPOINACREUBICA' and gra.carrera is null  then  2
                               when niv.codigo_estado_carrera ='ACT' and niv.periodo_ultimo='2026-1' then 6
                               when niv.codigo_estado_carrera in ('INACS','INANUSM','INACD','CUPOOIESS','CUPOINVALIDADO')  then 7
                               when niv.codigo_estado_carrera='ACT' and niv.periodo_ultimo<='2025-1' then 7
                               when niv.codigo_estado_carrera='ACT' and niv.periodo_ultimo>='2025-2' and niv.periodo_ultimo<='2026-1' then 8
                               when niv.codigo_estado_carrera='INACSM' then 26
                               when niv.codigo_estado_carrera='APR' and gra.codigo_estado_carrera ='CARRERANOOCUPADA' then 9
                               when niv.codigo_estado_carrera='APR' and gra.codigo_estado_carrera='ACT' and gra.periodo_primer is null and niv.periodo_primer<='2025-1'
                                   and gra.codigo_ingreso not in ('REDISENIO-SEDE','CAMBIO-MALLA','RESIDENIO-CARRERA','REDISENIO-SIS-EST','REDISENIO-REV-NORM','RESIDENIO-MODALIDAD','MOV')
                                   and gra.numero_matriculas_sis=0 and gra.numero_matriculas_sga=0 then 9
                               when niv.codigo_estado_carrera='APR' and gra.periodo_primer is null and niv.periodo_ultimo>='2025-2' then 10
                               when niv.codigo_estado_carrera='APR' and gra.periodo_primer is not null and gra.estado_registro in ('N','X','R','T','H','O') then 10
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='ACT' and gra.periodo_primer is not null and gra.periodo_ultimo is not null
                                   and gra.fecha_egreso is null and  gra.fecha_graduacion is null and gra.reprobo_tercera_vez=0 then 13
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='ACT' and (gra.numero_matriculas_sis>0 or gra.numero_matriculas_sga>0) then 13
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='ACT' and gra.periodo_primer is null and gra.periodo_ultimo is null
                                   and gra.codigo_ingreso in ('REDISENIO-SEDE','CAMBIO-MALLA','RESIDENIO-CARRERA','REDISENIO-SIS-EST','REDISENIO-REV-NORM','RESIDENIO-MODALIDAD','MOV')  then 13
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera = 'PERDIDACARRERA'  then 14
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.reprobo_tercera_vez > 0 and  gra.fecha_graduacion is null and gra.fecha_egreso is null  then 14
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='GRA' then 23
                               when niv.codigo_estado_carrera='APR' and gra.fecha_egreso is not null and  gra.fecha_graduacion is not null then 23
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='EGR' then 24
                               when niv.codigo_estado_carrera='APR' and gra.fecha_egreso is not null and  gra.fecha_graduacion is null then 24 end
                              as id_estado_set_casuistica
         from mig.estados_academicos_automatic ea
                  left join mig.listar_carreras_sisweb niv on niv.identificacion = ea.identificacion and niv.periodo_cupo=ea.periodo and niv.id_carrera_ofertada=ea.id_carrera_ofertada
             and niv.id_tipo_oferta = 1
                  left join mig.record_oferta_jerarquia roj on roj.id_record_origen = niv.id_record_oferta and roj.nodos_max>0
                  left join mig.listar_carreras_sisweb grap on grap.id_record_oferta = roj.id_record_final
                  left join mig.estudiante_oferta_jerarquia eoj on eoj.id_estudiante_oferta_origen = grap.id_estudiante_oferta
                  left join mig.listar_carreras_sga gra on gra.id_estudiante_oferta = eoj.id_estudiante_oferta_final
         where
             ea.TIPO_CUPO in ('NIVELACIÓN','NIVELACION') and
             niv.id_estudiante_oferta_destino is null and niv.id_estudiante_oferta is null
           and grap.id_estudiante_oferta is not null and grap.id_estudiante_oferta_destino is null
           and ea.periodo<'2022-1' and ea.id_periodo_academico=136 and ea.id_casuistica is null
--      ) as d
-- where d.id_casuistica<>d.id_estado_set_casuistica

--1340
select * from mig.estados_academicos_automatic ea where ea.periodo>='2022-1'
select * from mig.estados_academicos_automatic ea where ea.id_estado_academico =2198
select * from mig.causistica where periodo='2025-1'
---actualizar los cupos del SGA,manes que aprobaron el pre een el sisweb y todo lo demas esta en el SGA
--1290 casos
-- select d.*
-- from (
         select  distinct ea.id_estado_academico,ea.identificacion,ea.apellidos,ea.nombres,ea.id_oferta_modalidad,ea.id_carrera_ofertada,ea.carrera_sga,ea.periodo,ea.id_casuistica,
                          niv.id_record_oferta,niv.id_record_oferta_padre,niv.carrera,niv.periodo_primer,niv.periodo_ultimo,niv.codigo_estado_carrera,
                          niv.estado_carrera,niv.codigo_ingreso,niv.tipo_ingreso,niv.estado_registro,
                          gra.id_record_oferta as id_record_oferta_gra,gra.id_record_oferta_padre as id_record_oferta_padre_gra,gra.carrera as carrera_gra,gra.periodo_primer as periodo_primer_gra,gra.periodo_ultimo as periodo_ultimo_gra,
                          gra.codigo_estado_carrera as codigo_estado_carrera_gra,gra.estado_carrera as estado_carrera_gra,
                          gra.codigo_ingreso as codigo_ingreso_gra,gra.tipo_ingreso as tipo_ingreso_gra,gra.estado_registro as estado_registro_gra,gra.numero_matriculas_sga,gra.numero_matriculas_sis,gra.fecha_egreso,gra.fecha_graduacion,gra.id_tipo_oferta,
                          gra.reprobo_tercera_vez,
--     update ea set ea.id_casuistica =
                          case when niv.codigo_estado_carrera='NO-USO-CUPO' then  1
                               when niv.codigo_estado_carrera='CUPOINACREUBICA' and gra.carrera is null  then  2
                               when niv.codigo_estado_carrera ='ACT' and niv.periodo_ultimo='2026-1' then 6
                               when niv.codigo_estado_carrera in ('INACS','INANUSM','INACD','CUPOOIESS','CUPOINVALIDADO')  then 7
                               when niv.codigo_estado_carrera='ACT' and niv.periodo_ultimo<='2025-1' then 7
                               when niv.codigo_estado_carrera='ACT' and niv.periodo_ultimo>='2025-2' and niv.periodo_ultimo<='2026-1' then 8
                               when niv.codigo_estado_carrera='INACSM' then 26
                               when niv.codigo_estado_carrera='APR' and gra.codigo_estado_carrera ='CARRERANOOCUPADA' then 9
                               when niv.codigo_estado_carrera='APR' and gra.codigo_estado_carrera='ACT' and gra.periodo_primer is null and niv.periodo_primer<='2025-1'
                                   and gra.codigo_ingreso not in ('REDISENIO-SEDE','CAMBIO-MALLA','RESIDENIO-CARRERA','REDISENIO-SIS-EST','REDISENIO-REV-NORM','RESIDENIO-MODALIDAD','MOV')
                                   and gra.numero_matriculas_sis=0 and gra.numero_matriculas_sga=0 then 9
                               when niv.codigo_estado_carrera='APR' and gra.periodo_primer is null and niv.periodo_ultimo>='2025-2' then 10
                               when niv.codigo_estado_carrera='APR' and gra.periodo_primer is not null and gra.estado_registro in ('N','X','R','T','H','O') then 10
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='ACT' and gra.periodo_primer is not null and gra.periodo_ultimo is not null
                                   and gra.fecha_egreso is null and  gra.fecha_graduacion is null and gra.reprobo_tercera_vez=0 then 13
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='ACT' and (gra.numero_matriculas_sis>0 or gra.numero_matriculas_sga>0) then 13
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='ACT' and gra.periodo_primer is null and gra.periodo_ultimo is null
                                   and gra.codigo_ingreso in ('REDISENIO-SEDE','CAMBIO-MALLA','RESIDENIO-CARRERA','REDISENIO-SIS-EST','REDISENIO-REV-NORM','RESIDENIO-MODALIDAD','MOV')  then 13
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera = 'PERDIDACARRERA'  then 14
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.reprobo_tercera_vez > 0 and  gra.fecha_graduacion is null and gra.fecha_egreso is null  then 14
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='GRA' then 23
                               when niv.codigo_estado_carrera='APR' and gra.fecha_egreso is not null and  gra.fecha_graduacion is not null then 23
                               when niv.codigo_estado_carrera in ('APR','CUPOINACREUBICA','EXONERADO') and gra.codigo_estado_carrera='EGR' then 24
                               when niv.codigo_estado_carrera='APR' and gra.fecha_egreso is not null and  gra.fecha_graduacion is null then 24 end
                              as id_estado_set_casuistica
         from mig.estados_academicos_automatic ea
                  left join mig.listar_carreras_sga niv on niv.identificacion = ea.identificacion and niv.periodo_cupo=ea.periodo and niv.id_oferta_modalidad=ea.id_oferta_modalidad
             and niv.id_tipo_oferta = 1
                  left join mig.estudiante_oferta_jerarquia eoj on eoj.id_estudiante_oferta_origen = niv.id_estudiante_oferta and eoj.nodos_max>0
                  left join mig.listar_carreras_sga gra on gra.id_estudiante_oferta = eoj.id_estudiante_oferta_final
         where ea.TIPO_CUPO in ('NIVELACIÓN','NIVELACION')
           and ea.periodo>='2022-1' and ea.id_periodo_academico=136 and ea.id_casuistica is null
--      ) as d
-- where d.id_casuistica<>d.id_estado_set_casuistica

    select * from mig.record_oferta where periodo ='2016-2'
select * from mig.record_oferta where identificacion ='0923675805'

select * from mig.graduados where identificacion ='0940376544'

select * from mig.listar_carreras_sisweb where identificacion in ('0923675805',    '0927089789','2450830019','2400173890'    )
select * from mig.estados_academicos_automatic where id_casuistica is null and id_periodo_academico = 136
select * from mig.estudiante_oferta_jerarquia eoj where eoj.id_estudiante_oferta_origen = 71736
select * from mig.estados_academicos_automatic where id_periodo_academico = 136
select --c.id_caso,c.id_tipo_casuistica,c.casuistica_especifica,
       ea.*
-- update ea set ea.HAC_FECHA_CREACION = getdate(), ea.TIPO_CASUISTICA = c.id_tipo_casuistica,ea.CASUISTICA = c.casuistica_especifica, ea.CODIGO_CASUISTICA=c.id_caso
from mig.estados_academicos_automatic ea
left join mig.causistica c on c.id_caso = ea.id_casuistica and c.periodo='2026-1'
where ea.id_periodo_academico=136

select * from aca.ofertas_facultad where id_tipo_oferta = 1 AND sedeCorta ='PLAYAS'
select * from mig.causistica c
select * from mig.estados_academicos_automatic ea where identificacion='0929927093'

-- 3304 3306
select * from mig.estado_academicos ea