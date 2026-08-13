use bd_sga_upse

--ELIMINAR LAS MULTICUENTAS EN EL SGA

--PERSONAS CON MAS DE UN REGISTRO EN TABLA MAN.PERSONAS
select * from man.personas where identificacion='1306390013'
select * from man.personas where apellidos LIKE '%VILLON LUCIN%'
select * from man.persona_identificacion where id_persona = 48703
select * from man.tipo_identificacion
select * from mig.record_oferta where identificacion in ('0605123801')
select * from mig.record_oferta where identificacion in ('0919714809','0919714709')

select p.apellidos,p.nombres,p.identificacion,p.fecha_nace,p.celular,p.email_personal from man.personas p
where p.estado='AC' and p.homonimo=0 and concat(p.apellidos,' ',p.nombres) in
                        (select d.nombres from (select concat(p.apellidos,' ',nombres) as nombres,count(p.identificacion) as cedulas
                                                from man.personas p where p.estado='AC' group by p.nombres, p.apellidos having count(p.identificacion) = 2)as d) order by p.apellidos,p.nombres


select p.apellidos,p.nombres,p.identificacion,p.fecha_nace,p.celular,p.email_personal from man.personas p
where p.estado='AC' and p.homonimo=0 and concat(dbo.quitarTildes(p.APELLIDOS),' ',dbo.quitarTildes(p.NOMBRES)) in
                                         (select d.nombres from (select concat(dbo.quitarTildes(p.APELLIDOS),' ',dbo.quitarTildes(p.NOMBRES)) as nombres,count(p.identificacion) as cedulas
                                                                 from man.personas p where p.estado='AC' group by p.nombres, p.apellidos having count(p.identificacion) >= 2
                                                                                                                                         )as d) order by p.apellidos,p.nombres
--volver aqui
--ver duplicados
WITH dupes AS (SELECT p.id as id_persona,p.apellidos,
                      p.nombres,
                      p.identificacion,
                      p.fecha_nace,
                      p.celular,
                      p.email_personal,
                      p.homonimo,
                      p.fecha_ing,
                      ROW_NUMBER() OVER (
                          PARTITION BY p.apellidos, p.nombres
                          ORDER BY p.id
                          )                                               AS rn,
                      COUNT(*) OVER (PARTITION BY p.apellidos, p.nombres) AS cnt
               FROM man.personas p
               WHERE p.estado = 'AC'),
-- Tally/nums para posiciones (ajusta TOP si necesitas más de 100 caracteres)
     nums AS (SELECT TOP (100) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
              FROM sys.all_objects)
SELECT p1.apellidos,
       p1.nombres,p1.id_persona,p2.id_persona,
       p1.identificacion AS identificacion1,
       p2.identificacion AS identificacion2,
       -- Comparaciones (SI/NO)
       CASE
           WHEN (p1.identificacion = p2.identificacion)
               OR (p1.identificacion IS NULL AND p2.identificacion IS NULL)
               THEN 'SI'
           ELSE 'NO'
           END           AS identificacion_igual,

       -- % similitud de identificaciones (si longitudes distintas => 0.00)
       CAST(
               CASE
                   WHEN LEN(p1.identificacion) = LEN(p2.identificacion)
                       THEN 100.0 * COALESCE(ca.num_matches, 0) / NULLIF(LEN(p1.identificacion), 0)
                   ELSE 0
                   END AS DECIMAL(5, 2)
       )                 AS porcentaje_similitud_identificacion,
       p1.fecha_nace     AS fecha_nace1,
       p2.fecha_nace     AS fecha_nace2,
       CASE
           WHEN (p1.fecha_nace = p2.fecha_nace)
               OR (p1.fecha_nace IS NULL AND p2.fecha_nace IS NULL)
               THEN 'SI'
           ELSE 'NO'
           END           AS fechas_nace_iguales,
       p1.celular        AS celular1,
       p2.celular        AS celular2,
       -- Normaliza celular quitando espacios, guiones y '+' antes de comparar
       CASE
           WHEN (
                    NULLIF(REPLACE(REPLACE(REPLACE(p1.celular, ' ', ''), '-', ''), '+', ''), '') =
                    NULLIF(REPLACE(REPLACE(REPLACE(p2.celular, ' ', ''), '-', ''), '+', ''), '')
                    ) OR (p1.celular IS NULL AND p2.celular IS NULL)
               THEN 'SI'
           ELSE 'NO'
           END           AS celular_igual,
       p1.email_personal AS email_personal1,
       p2.email_personal AS email_personal2,
       p1.fecha_ing AS fecha_ing1,
       p2.fecha_ing AS fecha_ing2,
       -- Normaliza correo con TRIM y LOWER
       CASE
           WHEN (LOWER(LTRIM(RTRIM(p1.email_personal))) = LOWER(LTRIM(RTRIM(p2.email_personal))))
               OR (p1.email_personal IS NULL AND p2.email_personal IS NULL)
               THEN 'SI'
           ELSE 'NO'
           END           AS email_personal_iguales,p1.homonimo,p2.homonimo

FROM dupes p1
         JOIN dupes p2
              ON p1.apellidos = p2.apellidos
                  AND p1.nombres = p2.nombres
                  AND p1.rn = 1
                  AND p2.rn = 2
         OUTER APPLY (
    -- OJO: aquí el SUM solo referencia la columna interna "eq" (sin p1/p2)
    SELECT SUM(eq) AS num_matches
    FROM (SELECT CASE
                     WHEN LEN(p1.identificacion) = LEN(p2.identificacion)
                         AND nums.n <= LEN(p1.identificacion)
                         AND SUBSTRING(p1.identificacion, nums.n, 1) = SUBSTRING(p2.identificacion, nums.n, 1)
                         THEN 1
                     ELSE 0
                     END AS eq
          FROM nums) AS x) AS ca
WHERE p1.cnt = 2 and (p1.homonimo = 0 or p2.homonimo = 0)
--   and concat(p1.apellidos,' ',p1.nombres) in ()
ORDER BY p1.apellidos, p1.nombres;


select concat(p.apellidos,' ',nombres) as nombres,count(p.identificacion) as cedulas from man.personas p where p.estado='AC'
group by p.nombres, p.apellidos
having count(p.identificacion) = 2
select * from man.tipo_identificacion
select * from man.estado_civil
select * from mig.listar_carreras_sga where identificacion='0917511602'
select * from mig.record_oferta p where identificacion in ('09857246766',	'0925724676'    )
select * from mig.record_oferta p where id_persona in (58983,74450)
select * from man.personas p where id in (58983,74450)
select * from man.personas p where identificacion in ('2450824848')
select * from man.persona_identificacion where id_persona in (58983,74450)
select * from [mig].[sp_listar_personas_by_filter]('EL6772462','identificacion')
select id,identificacion,apellidos,nombres,sexo,id_estado_civil,fecha_nace,id_pais_nacionalidad,id_provincia_nacionalidad,id_canton_nacionalidad,id_parroquia_nacionalidad,defuncion,homonimo
from man.personas  order by apellidos,nombres,identificacion
--  DBCC CHECKIDENT ('man.persona_identificacion', RESEED, 35);
-- exec tmp.verificar_uso_datos 19295
-- exec tmp.verificar_uso_datos 100729

select identificacion,apellidos,nombres,pais_reside,provincia_reside,canton_reside,parroquia_reside
from persona_nivelacion where concat(apellidos,' ',nombres)='VILLALVA REYES KAORI ADAMARIS'
--                             identificacion in ('2450476516','0921971677')





--VER SI HAY RECORDS HISTORICOS CON CEDULAS ERRONEAS
select ro.* from mig.record_oferta ro
left join man.personas p on ro.identificacion=p.identificacion
where ro.estado='A' and p.estado='IN' and ro.id_persona is null

select p.id,p.identificacion,ro.* from mig.record_oferta ro
left join man.personas p on concat(ro.apellidos,' ',ro.nombres ) = concat(p.apellidos,' ',p.nombres)
where ro.estado='A' and p.estado='AC' and ro.identificacion  in ('0912367843', '0919799282','0924625563','0924089447','0916706886')
  and ro.id_persona is null

-- insert into man.persona_identificacion
select p.id,p.id_tipo_identificacion,p.identificacion,'A',0,getdate(),getdate(),'2400254286','2400254286'
--     p.id,p.id_tipo_identificacion,p.identificacion,p.apellidos,p.nombres, pi.id_persona_identificacion,pi.id_tipo_identificacion,pi.identificacion
from man.personas p
left join man.persona_identificacion pi on p.id=pi.id_persona and p.identificacion=pi.identificacion
where p.estado='AC' and pi.id_persona_identificacion is null and p.id not in (80818,78160)--and pi.id_tipo_identificacion<>pi.id_persona_identificacion

--set provincia
select l.id_lugar,l.descripcion,p.*
-- update p set p.id_provincia_residencia = l.id_lugar
from man.personas p
         left join man.lugar l on p.ciudad=l.descripcion and l.sub_tipo=1
where p.estado='AC' and p.ciudad is not null and p.id_provincia_nacionalidad is null and l.id_lugar is not null

--set canton
 select --lp.id_lugar,lp.descripcion,l.id_lugar,l.descripcion,
        p.*
-- update p set p.id_canton_residencia = l.id_lugar,p.id_provincia_residencia=iif(p.id_provincia_residencia is null,lp.id_lugar,p.id_provincia_residencia)
-- update p set p.id_canton_nacionalidad = l.id_lugar,p.id_provincia_nacionalidad=iif(p.id_provincia_nacionalidad is null,lp.id_lugar,p.id_provincia_nacionalidad)
from man.personas p
left join man.lugar l on p.ciudad=l.descripcion and l.sub_tipo=2
left join man.lugar lp on l.id_lugar_padre=lp.id_lugar
where p.estado='AC' and p.ciudad is not null and p.id_canton_nacionalidad is null and l.id_lugar is not null

select * from man.personas where homonimo =1
--set parroquia
select
--     distinct lpp.id_lugar,lpp.descripcion,lp.id_lugar,lp.descripcion, l.id_lugar,l.descripcion,
    distinct  p.*
-- update p set p.id_parroquia_residencia=l.id_lugar,p.id_canton_residencia=iif(p.id_canton_residencia is null,lp.id_lugar,p.id_canton_residencia),
--              p.id_provincia_residencia=iif(p.id_provincia_residencia is null,lpp.id_lugar,p.id_provincia_residencia)
--     update p set p.id_parroquia_residencia=l.id_lugar
from man.personas p
         inner join man.lugar l on p.ciudad=l.descripcion and l.sub_tipo=3
         left join man.lugar lp on l.id_lugar_padre=lp.id_lugar and lp.id_lugar=p.id_canton_residencia
         left join man.lugar lpp on lp.id_lugar_padre=lpp.id_lugar -- lpp.id_lugar=p.id_provincia_residencia
where p.estado='AC' and p.ciudad is not null and p.id_parroquia_residencia is null and l.id_lugar is not null

--and lp.id_lugar is not null
-- and p.id_canton_residencia is null and p.id_provincia_residencia is null

select --lpp.id_lugar,lpp.descripcion,
       lp.id_lugar,lp.descripcion,l.id_lugar,l.id_lugar_padre,l.descripcion,  p.*
-- update p set p.id_parroquia_nacionalidad=l.id_lugar,p.id_canton_nacionalidad=iif(p.id_canton_nacionalidad is null,lp.id_lugar,p.id_canton_nacionalidad),
--              p.id_provincia_nacionalidad=iif(p.id_provincia_nacionalidad is null,lpp.id_lugar,p.id_provincia_nacionalidad)
from man.personas p
         inner join man.lugar l on p.direccion=l.descripcion and l.sub_tipo=3
         left join man.lugar lp on l.id_lugar_padre=lp.id_lugar and lp.id_lugar=p.id_canton_nacionalidad
         left join man.lugar lpp on lp.id_lugar_padre=lpp.id_lugar and lpp.id_lugar=p.id_provincia_nacionalidad
where p.estado='AC' and p.direccion is not null and p.id_parroquia_nacionalidad is null and l.id_lugar is not null --and lp.id_lugar is not null
--   and p.id_canton_nacionalidad is null and p.id_provincia_nacionalidad is null

--set residencia from nacionalidad
select p.*
-- update p set p.id_parroquia_residencia=iif(p.id_parroquia_residencia is null,p.id_parroquia_nacionalidad,p.id_parroquia_residencia),
--              p.id_canton_residencia=iif(p.id_canton_residencia is null,p.id_canton_nacionalidad,p.id_canton_residencia),
--              p.id_provincia_residencia=iif(p.id_provincia_residencia is null,p.id_provincia_nacionalidad,p.id_provincia_residencia)
from man.personas p
where p.estado='AC' --and p.direccion is not null
and p.id_provincia_residencia is null and p.id_provincia_nacionalidad is not null and p.id_pais_residencia =164 and p.id_canton_residencia is null and p.id_parroquia_residencia is null

--set nacionalidad from residencia
select p.*
-- update p set p.id_parroquia_nacionalidad=iif(p.id_parroquia_nacionalidad is null,p.id_parroquia_residencia,p.id_parroquia_nacionalidad),
--              p.id_canton_nacionalidad=iif(p.id_canton_nacionalidad is null,p.id_canton_residencia,p.id_canton_nacionalidad),
--              p.id_provincia_nacionalidad=iif(p.id_provincia_nacionalidad is null,p.id_provincia_residencia,p.id_provincia_nacionalidad)
from man.personas p
where p.estado='AC' --and p.direccion is not null
  and p.id_provincia_nacionalidad is null and p.id_provincia_residencia is not null and p.id_pais_nacionalidad =164 and p.id_canton_nacionalidad is null and p.id_parroquia_nacionalidad is null

select p.*
-- update p set p.id_parroquia_residencia=iif(p.id_parroquia_residencia is null,p.id_parroquia_nacionalidad,p.id_parroquia_residencia),
--              p.id_canton_residencia=iif(p.id_canton_residencia is null,p.id_canton_nacionalidad,p.id_canton_residencia),
--              p.id_provincia_residencia=iif(p.id_provincia_residencia is null,p.id_provincia_nacionalidad,p.id_provincia_residencia)
from man.personas p
where p.estado='AC' --and p.direccion is not null
  and p.id_provincia_residencia is null and p.id_provincia_nacionalidad is not null and p.id_pais_residencia =164 and p.id_canton_residencia is null and p.id_parroquia_residencia is null

select --lp.id_lugar_padre,lp.descripcion,
       p.*
-- update p set p.id_provincia_nacionalidad=lp.id_lugar_padre
from man.personas p
         inner join man.lugar lp on p.id_canton_nacionalidad=lp.id_lugar
where p.estado='AC' and p.id_provincia_nacionalidad is null and p.id_pais_residencia =164 and p.id_canton_nacionalidad is not null

select --lp.id_lugar_padre,lp.descripcion,
       p.*
-- update p set p.id_provincia_residencia=lp.id_lugar_padre
from man.personas p
         inner join man.lugar lp on p.id_canton_residencia=lp.id_lugar
where p.estado='AC' and p.id_provincia_residencia is null and p.id_pais_residencia =164 and p.id_canton_residencia is not null

select --lp.id_lugar_padre,lp.descripcion,
       p.*
-- update p set p.id_canton_nacionalidad= lp.id_lugar_padre
from man.personas p
         inner join man.lugar lp on p.id_parroquia_nacionalidad=lp.id_lugar
where p.estado='AC' and p.id_pais_residencia =164 and p.id_canton_nacionalidad is null and p.id_parroquia_nacionalidad is not null

select --lp.id_lugar_padre,lp.descripcion,
       p.*
-- update p set p.id_canton_residencia= lp.id_lugar_padre
from man.personas p
         inner join man.lugar lp on p.id_parroquia_residencia=lp.id_lugar
where p.estado='AC' and p.id_pais_residencia =164 and p.id_canton_residencia is null and p.id_parroquia_residencia is not null

--actualizar informacion domiciliaria
select *
-- update p set p.id_provincia_nacionalidad=p.id_provincia_residencia,p.id_canton_nacionalidad=p.id_canton_residencia,
--              p.id_parroquia_nacionalidad=iif(p.id_parroquia_residencia is null,p.id_parroquia_nacionalidad,p.id_parroquia_residencia)
-- update p set p.id_provincia_nacionalidad=d.id_lugar_provincia
--   update p set p.id_provincia_residencia=d.id_lugar_provincia,p.id_canton_residencia=d.id_lugar_canton,p.id_parroquia_residencia =d.id_lugar_parroquia
-- update p set p.id_canton_nacionalidad=d.id_lugar_canton
-- update p set p.id_canton_residencia=d.id_lugar_canton
-- update p set p.id_parroquia_nacionalidad =d.id_lugar_parroquia
-- update p set p.id_parroquia_residencia =d.id_lugar_parroquia
from
             (
select distinct
    l.id_lugar as id_lugar_provincia,l.descripcion as provincia,
                c.id_lugar as id_lugar_canton,c.descripcion as canton,
              pa.id_lugar as id_lugar_parroquia,pa.id_lugar_padre,pa.descripcion as parroquia,
       p.identificacion,pe.direccion as direccion_matriz,pe.provincia_reside,pe.canton_reside,pe.parroquia_reside,row_number() over (partition by pe.identificacion order by pe.id_persona_nivelacion desc) as rn
    ,mig.quitarSoloTildes(REPLACE(pe.parroquia_reside, ', CABECERA CANTONAL', '')) as xd
--        ,pe.ppl,pe.estado_civil,pe.fecha_nace,pe.nacionalidad,pe.porcentaje_discapacidad,pe.ins_barrio_sector,pe.ins_calle_principal,pe.correo, pe.autoidentificacion
-- update p set p.id_canton_residencia= lp.id_lugar_padre
from man.personas p
inner join dbo.persona_nivelacion pe on pe.identificacion = p.identificacion
left join man.lugar l on l.descripcion=mig.quitarSoloTildes(pe.provincia_reside) and l.sub_tipo=1
left join man.lugar c on c.descripcion=mig.quitarSoloTildes(pe.canton_reside) and c.sub_tipo=2
left join man.lugar pa on pa.descripcion=pe.parroquia_reside and pa.id_lugar_padre =p.id_canton_nacionalidad
-- inner join man.lugar pa on pa.descripcion=mig.quitarSoloTildes(pe.parroquia_reside) and pa.id_lugar_padre =p.id_canton_residencia
-- inner join man.lugar pa on pa.descripcion=mig.quitarSoloTildes(REPLACE(pe.parroquia_reside, ', CABECERA CANTONAL', '')) and pa.id_lugar_padre =p.id_canton_residencia
-- inner join man.lugar pa on pa.descripcion=mig.quitarSoloTildes(REPLACE(pe.parroquia_reside, ' ,CABECERA CANTONAL Y CAPITAL PROVINCIAL', '')) and pa.id_lugar_padre =p.id_canton_residencia
where p.estado='AC' and p.id_pais_residencia =164 and p.id_parroquia_residencia is  null) as d
inner join man.personas p on p.identificacion=d.identificacion
where p.estado='AC' and d.rn=1 and p.id_parroquia_residencia is null and d.id_lugar_parroquia is not null
-- and d.parroquia_reside='CALDERÓN'

select --c.id_lugar,
--     update p set p.id_canton_residencia=c.id_lugar
       p.*
    from man.personas p
inner join man.lugar l on l.id_lugar=p.id_canton_residencia
inner join man.lugar c on c.descripcion=l.descripcion and c.sub_tipo=2
where p.id_provincia_residencia =p.id_canton_residencia

select --c.id_lugar,
-- update p set p.id_canton_nacionalidad=c.id_lugar
       p.*
from man.personas p
         inner join man.lugar l on l.id_lugar=p.id_canton_nacionalidad
         inner join man.lugar c on c.descripcion=l.descripcion and c.sub_tipo=2
where p.id_provincia_nacionalidad =p.id_canton_nacionalidad



select *
-- update p set p.fecha_nace =d.fecha_nace
--     update p set p.direccion=d.ins_barrio_sector
-- update p set p.barrio=d.ins_barrio_sector
-- update p  set p.email_personal = d.correo
-- update p set p.celular=d.celular
-- update p set p.numero_domicilio=d.casa_lote
from
    (
        select distinct
            p.identificacion
                      ,pe.direccion as direccion_matriz,pe.provincia_reside,pe.canton_reside,pe.parroquia_reside,row_number() over (partition by pe.identificacion order by pe.id_persona_nivelacion desc) as rn
               ,pe.ppl,pe.estado_civil,pe.fecha_nace,pe.nacionalidad,pe.porcentaje_discapacidad,pe.ins_barrio_sector,pe.ins_calle_principal,pe.correo, pe.autoidentificacion,pe.celular,pe.casa_lote,
                pe.pueblo_indigena
-- update p set p.id_canton_residencia= lp.id_lugar_padre
        from man.personas p
        inner join dbo.persona_nivelacion pe on pe.identificacion = p.identificacion
        where p.estado='AC' and p.id_pais_residencia =164 and (p.id_etnia is null or p.id_etnia='')) as d
        inner join man.personas p on p.identificacion=d.identificacion
where p.estado='AC' and d.rn=1 and d.pueblo_indigena is not null
--   and d.casa_lote NOT LIKE '%[^0-9]%'
--   AND TRY_CAST(d.casa_lote AS INT) IS NOT NULL and len(d.casa_lote)<6 and d.casa_lote not in ('0','00','000','0000','00000','999','9999','99999')
-- and d.parroquia_reside='CALDERÓN'

select d.*
-- update p set p.celular =d.celular
from
    (
        select distinct
            p.identificacion,p.nombres,p.apellidos,p.celular as celularp,row_number() over (partition by pe.identificacion order by pe.id_persona_nivelacion desc) as rn
        from man.personas p
                 inner join dbo.persona_nivelacion pe on pe.identificacion = p.identificacion
        where p.estado='AC' and p.id_pais_residencia =164) as d
        inner join man.personas p on p.identificacion=d.identificacion
where p.estado='AC' and d.rn=1 and p.telefono is  null--and d.celular is not null

select * from dbo.persona_nivelacion where apellidos='ASENCIO TORRES'

select c.id_lugar,c.descripcion as parroquia,p.id_lugar,concat(p.descripcion,'-',c.descripcion) as canton,pr.id_lugar,pr.descripcion as provincia from man.lugar c
inner join man.lugar p on p.id_lugar =c.id_lugar_padre
inner join man.lugar pr on pr.id_lugar =p.id_lugar_padre
where c.estado='A' and c.sub_tipo = 3 --and p.id_lugar_padre=270
order by c.id_lugar

select * from man.lugar where id_lugar =1596

select * from aca.oferta

select * from aca.periodo_academico

--  DBCC CHECKIDENT ('man.lugar', RESEED, 1592);

select * from man.personas where estado='AC'
select * from dbo.persona_nivelacion where identificacion='0104512546'

--actualiza campo id_personas de los records migracion
select ro.*
--     update ro set ro.id_persona=p.id
from mig.record_oferta ro
-- left join man.personas p on ro.identificacion=p.identificacion and p.estado='AC'
where  ro.id_persona is null --and ro.estado='A'

select * from mig.record_oferta ro  where concat(ro.apellidos,' ',ro.nombres ) in ('LAZARO LAZARO ORLANDO ALESANDRO','LAZARO LAZARO ORLANDO ALEXANDRO')

select * from mig.record_matricula rm where rm.id_record_oferta in (47627,    47628    )
select * from mig.record_asignaturas rm where rm.id_record_oferta in (47627,    47628    )

--borrar datos de usuario
begin
    declare @id_persona int = 86957,@estado1 varchar(2) = 'IN', @estado2 varchar(1) = 'I'
--     select *
    update u set u.estado = @estado1
    from seg.usuarios u where u.persona_id = @id_persona

--     select *
    update ro set ro.estado = @estado1
    from seg.roles_usuarios ro
             inner join seg.usuarios u on ro.usuario_id = u.id
    where u.persona_id = @id_persona

--     select *
    update uo set uo.estado = @estado2
    from seg.usuarios u
             inner join seg.usuario_opcion uo on u.id = uo.id_usuario
    where u.persona_id = @id_persona

--     select *
    update rou set rou.estado = @estado1
    from seg.roles_usuario_oferta rou
             inner join seg.roles_usuarios ro on rou.rol_usuario_id = ro.id
             inner join seg.usuarios u on ro.usuario_id = u.id
    where u.persona_id = @id_persona
end

-- C4rl1t0s5991.

select ro.* from  seg.roles_usuarios ro
             inner join seg.usuarios u on ro.usuario_id = u.id
    where u.usuario='1710178615'
--buscar datos en LEA
begin
    declare @identificacion varchar(15) = '2400182321'
    select USU_ID,CEDULA,CC_NUM,APELLIDOS,NOMBRES,CARRERA_ACEPTA_CUPO,PERIODO,NOTA_FINAL from tmp.NIVELACION_SEM_HIS where CEDULA in (@identificacion)

    select id_estado_academico,apellidos,nombres,carrera_sga,id_estado_academico,periodo,id_estado_cauistica from mig.estado_academicos where identificacion in (@identificacion)

    select id_estado_academico,apellidos,nombres,carrera_sga,id_estado_academico,periodo,id_casuistica from mig.estados_academicos_automatic   where identificacion in (@identificacion)

    select asp.identificacion,asp.nombres,asp.apellidos,asp.carrera,asp.campus,asp.fecha_ing,asp.fecha_mod from bdupse.snu.aspirante asp where asp.identificacion in (@identificacion)
end


--buscar las relaciones de una tabla con otras tablas
SELECT
--     fk.name AS ForeignKeyName,
--     SCHEMA_NAME(o1.schema_id) AS EsquemaOrigen,
--     OBJECT_NAME(fk.parent_object_id) AS TablaOrigen,
--     c1.name AS ColumnaOrigen,
--     SCHEMA_NAME(o2.schema_id) AS EsquemaDestino,
--     OBJECT_NAME(fk.referenced_object_id) AS TablaDestino,
--     c2.name AS ColumnaDestino,
concat('select * from ' ,SCHEMA_NAME(o1.schema_id),'.',OBJECT_NAME(fk.parent_object_id),' where ',c1.name,' in (19295,100729)')
FROM sys.foreign_keys fk
         INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
         INNER JOIN sys.columns c1 ON fkc.parent_object_id = c1.object_id AND fkc.parent_column_id = c1.column_id
         INNER JOIN sys.columns c2 ON fkc.referenced_object_id = c2.object_id AND fkc.referenced_column_id = c2.column_id
         INNER JOIN sys.objects o1 ON o1.object_id = fk.parent_object_id
         INNER JOIN sys.objects o2 ON o2.object_id = fk.referenced_object_id
WHERE OBJECT_NAME(fk.referenced_object_id) = 'personas';



select * from aca.comision_integrante
begin
    DECLARE @schema_target sysname = 'man';
    DECLARE @table_target  sysname = 'personas';
    DECLARE @colname_guess sysname = 'id_persona'; -- nombre típico en tablas hijas

    ;WITH target AS (
        SELECT OBJECT_ID(QUOTENAME(@schema_target)+'.'+QUOTENAME(@table_target)) AS target_object_id
    ),
          fkcols AS ( -- columnas que YA tienen FK hacia man.personas
              SELECT fkc.parent_object_id, fkc.parent_column_id
              FROM sys.foreign_key_columns fkc
                       JOIN target t ON t.target_object_id = fkc.referenced_object_id
          ),
          candidates AS ( -- todas las columnas llamadas id_persona en todas las tablas (excepto la propia man.personas)
              SELECT
                  s.name  AS SchemaName,
                  o.name  AS TableName,
                  c.name  AS ColumnName,
                  o.object_id,
                  c.column_id,
                  ty.name AS DataType,
                  c.max_length,
                  c.is_nullable
              FROM sys.columns c
                       JOIN sys.objects o ON c.object_id = o.object_id AND o.type = 'U'
                       JOIN sys.schemas s ON o.schema_id = s.schema_id
                       JOIN sys.types  ty ON c.user_type_id = ty.user_type_id
              WHERE c.name = @colname_guess
                AND o.object_id <> (SELECT target_object_id FROM target)
          )
     SELECT
         c.SchemaName,
         c.TableName,
         c.ColumnName,
         c.DataType,
         c.max_length,
         c.is_nullable
         ,concat('select * from ' ,c.SchemaName,'.',c.TableName,' where ',c.ColumnName,' in (19295,100729)') as query
         ,concat('IF EXISTS (select 1 from ' ,c.SchemaName,'.',c.TableName,' where ',c.ColumnName,' = @id_persona )',   CHAR(13) + CHAR(10)+CHAR(9),
          'INSERT INTO @Consultas VALUES (''select * from ',c.SchemaName,'.',c.TableName,' where ',c.ColumnName,' = '' + CAST(@id_persona AS VARCHAR));',CHAR(13) ) as queryAdvance
     FROM candidates c
              LEFT JOIN fkcols fk
                        ON fk.parent_object_id = c.object_id
                            AND fk.parent_column_id = c.column_id
     WHERE fk.parent_object_id IS NULL
     ORDER BY c.SchemaName, c.TableName;

end



select distinct table_name from mig.record_oferta
select * from mig.record_oferta where id_estudiante_oferta_destino is not null and id_estudiante_oferta is not null
select * from tmp.NIVELACION_SEM_HIS
select * from [aca].[fn_get_all_offers](    '2400108060',null,0,0,0,0)
--caso continuacion de sisweb al sga desde grado - grado exactamente el mismo record tiene registros validos en ambos records
select * from [aca].[fn_get_all_offers]('0927268425',null,null,null,null,null)
--caso continuacion de sisweb al sga desde niv - grado desde el pre hasta la carrera
select * from [aca].[fn_get_all_offers]('2450719840',null,null,null,null,null)
--caso continuacion de sisweb al sga desde grado - grado misma carrera pero con rediseño
select * from [aca].[fn_get_all_offers]('2400012163',null,null,null,null,null)
--caso continuacion de sisweb al sisweb rediseño de nivelacion
select * from [aca].[fn_get_all_offers]('2400173510',null,null,null,null,null)

select * from [mig].[sp_listar_personas_by_filter](?,?)

select * from [aca].[fn_get_all_offers]('0923130223',null,null,null,null,null)

SELECT * FROM aca.fn_listar_matriculas_estudiante(30179) as d ORDER BY d.codigoPeriodoAcademico;

select * from [aca].[fn_get_all_offers]('2400182321',null,null,null,null,null)
select * from [aca].[fn_get_all_matriculas_by_offer](null,35105)
select * from [aca].[fn_get_all_asignaturas_by_matriculas](null,56666)

select * from mig.listar_carreras_sisweb where identificacion in ('2400182321','2450395344','0923136196','2450307182','2450793191','2450270315')

select* from mig.record_asignaturas where id_record_oferta in ( 56666,56667)

select * from [aca].[fn_get_all_asignaturas_by_matriculas](null,56666)

select * from man.personas where identificacion='2450188749'
select * from seg.usuarios where usuario='2450188749'
--eliminar despúes :
--         fn_listar_matriculas_estudiante
        exec [aca].[sp_list_all_matriculas_carreras_niv] '2400255440',null
 --eliminar si o si, antes se usaba para listar todos los records
 exec [aca].[sp_list_all_matriculas_carreras]'2400255440',null
-------------------
select * from aca.nivel
select * from aca.tipo_matricula
select * from aca.tipo_jornada_laboral
select * from aca.malla_asignatura
begin
      declare  @idEstudianteOferta as int=1222,
    @idRecordOferta as int=35187


end

-- case when rm.table_name  in ('Bd_Academico.dbo.TE_INSCRIPCIONES','Bd_Academico.dbo.TE_MATRICULAS') then 'SISWEB'
--                when rm.table_name in ('tmp.NIVELACION_SEM_HIS.USU_ID','tmp.SEM_2012_2.CEDULA','tmp.SEM_2012_2') then 'MATRICES EXCEL' else 'APP ESCRITORIO' end as origen
select distinct ea.* from aca.estudiante_asignatura ea where matricula_excepcional is null
select distinct em.table_name,em.table_name_old from mig.record_asignaturas em --where id_record_matricula is null

select distinct em.* from mig.record_asignaturas em where aprobado=0
select distinct em.estado_tomada
from mig.record_asignaturas em
-- where vez in ('2 VEZ')

select distinct em.* from mig.record_matricula em

select distinct em.* from mig.record_matricula em where observacion='NORMATIVA TRANSITORIA - APROBADA EL 13 DE AGOSTO DE 2020'
select distinct ra.*
--     ro.identificacion,ro.apellidos,ro.nombres,ro.carrera,ro.sistema_estudio,rm.*
from mig.record_asignaturas ra
inner join mig.record_matricula rm on ra.id_record_matricula = rm.id_record_matricula
inner join mig.record_oferta ro on rm.id_record_oferta = ro.id_record_oferta
where ro.identificacion in ('2450020041')

select * from [aca].[fn_get_all_offers]('2450020041',null,null,null,null,null)
select * from [aca].[fn_get_all_matriculas_by_offer](null,35105)
select * from [aca].[fn_get_all_asignaturas_by_matriculas](1456,null)

--setear jornada basada en otros compañeros
select * from mig.record_matricula where id_tipo_jornada_laboral is null

select apellidos,nombres,cg_Cargo_txt,'UNIVERSIDAD ESTATAL PENÍNSULA DE SANTA ELENA','',identificacion,Fecha_Contrato from uath.contratos_migracion_06_02_2024
where EstadoContrato='A' and cast(Fecha_Contrato as date)>'2026-04-22' order by apellidos

select distinct em.estado,em.id_estudiante_oferta,em.id_matricula_general,ea.* from aca.estudiante_asignatura ea
inner join aca.estudiante_matricula em on ea.id_estudiante_matricula = em.id_estudiante_matricula
where ea.estado in ('N','Q')

select distinct em.*
from mig.record_matricula em

select distinct table_name,table_name_old from mig.record_matricula
select distinct codigo_estado_matricula from aca.estudiante_asignatura

select distinct ro.identificacion,ro.apellidos,ro.nombres,rm.id_record_oferta,rm.periodo,ra.id_record_oferta,ra.periodo,ra.asignatura,ra.id_nivel,ra.nivel
from mig.record_asignaturas ra
         inner join mig.record_matricula rm on ra.id_record_matricula = rm.id_record_matricula
         inner join mig.record_oferta ro on rm.id_record_oferta = ro.id_record_oferta
where rm.periodo<>ra.periodo


--ver las materias aprobadas que salen como reprobadas
select distinct ra.*
--     ro.identificacion,ro.apellidos,ro.nombres,rm.id_record_oferta,rm.periodo,ra.id_record_oferta,ra.periodo,ra.asignatura,ra.id_nivel,ra.nivel
from mig.record_asignaturas ra
         inner join mig.record_matricula rm on ra.id_record_matricula = rm.id_record_matricula
         inner join mig.record_oferta ro on rm.id_record_oferta = ro.id_record_oferta
where rm.estado_matricula='APROBADO' and ra.aprobado=0

select * from aca.estudiante_matricula where id_estudiante_oferta = 27635
select * from mig.record_oferta where id_estudiante_oferta_destino is null and id_tipo_oferta = 1
select * from mig.record_asignaturas where estado_aprobacion='APROBADO' and aprobado =0
--2007-1 --2011-3 sobre 70
--2013-1 2014-1 sobre 10
select distinct --ra.*
    ro.id_record_oferta,ro.id_tipo_estado_estudiante,ro.identificacion,ro.apellidos,ro.nombres,ro.carrera,rm.estado_matricula,rm.id_record_oferta,rm.periodo,rm.promedio,ro.periodo,ro.promedio,
    ro.id_periodo_academico,pap.nota_maxima,pap.nota_aprobatoria,
    ra.*
--     update ra set ra.estado_aprobacion='APROBADO',ra.aprobado=1,ra.fecha_mod =getdate()
from mig.record_asignaturas ra
         inner join mig.record_matricula rm on ra.id_record_matricula = rm.id_record_matricula
         inner join mig.record_oferta ro on rm.id_record_oferta = ro.id_record_oferta
        inner join mig.periodo_academico_ponderacion pap on pap.id_periodo_academico = ra.id_periodo_academico
where --ro.identificacion='2400271132'
--     ra.estado_aprobacion='REPROBADO' and ra.aprobado=1 and ra.promedio>=pap.nota_aprobatoria
--     ra.estado_aprobacion='APROBADO' and ra.aprobado=0 and ra.promedio>=pap.nota_aprobatoria
    ra.estado_aprobacion='REPROBADO' and ra.aprobado=0 and ra.promedio>=pap.nota_aprobatoria
-- or ( ro.periodo ='2014-1' and ro.id_tipo_oferta = 1)


--record con posible duplicidad
select * from mig.record_oferta where id_record_oferta in (35105,    36100,
36985,37392,37760,38034,39014,39318,39326,41145,41374,41642,41987,43076,48302,48923,49724,49730,
52162,53326,53649,53894,54747,55508,56059,56510,58171,59753,60653,62290,63327,63787,65140,65834,
67216,67453,67545    )
--record con duplicidad con matriculas retiradas
select * from mig.record_oferta where id_record_oferta in (59755,
    55245,
52450
    )
select * from aca.estudiante_asignatura where estado in ('Q','N')
select * from mig.listar_carreras_sisweb where identificacion='0927268425'
select * from mig.record_oferta where id_tipo_ingreso_estudiante  in (24)
select * from mig.record_oferta where identificacion in ('2400459158') order by identificacion,periodo
select * from aca.tipo_estado_estudiante
select * from aca.tipo_ingreso_estudiante
select * from mig.record_matricula where id_record_oferta in (37654)
select * from mig.record_asignaturas where id_record_oferta in (37654)
select distinct estado from mig.record_oferta-- where id_carrera_ofertada = 31
select distinct tipo from mig.record_asignaturas
select * from mig.record_matricula where id_record_matricula = 42844
select * from mig.record_asignaturas where nivel ='MODULOS' and id_nivel is null and asignatura='COMPUTACION'
select * from aca.nivel
select * from aca.tipo_oferta
select * from mig.record_oferta where id_record_oferta in (35634,    59952,66659,36339,43104,42071 )
select * from Bd_Academico..MATERIAS_TOMADAS where id_MATERIA_TOMADA = 145606
select * from Bd_Academico.dbo.TE_INSCRIPCIONES where id_inscripcion in (14837,    15780    )
select * from Bd_Academico.dbo.MATERIA_PRE_INS where id_inscripcion in (14837,    15780    )
select * from mig.periodo_academico_ponderacion
select * from [aca].[fn_get_all_offers]('2400364135',null,null,null,null,null)
select * from [aca].[fn_get_all_matriculas_by_offer](null,47803)
select * from [aca].[fn_get_all_asignaturas_by_matriculas](null,47803)
select * from [aca].[fn_get_all_records_by_offer](null,38872,null,null,null)
select * from [aca].[fn_get_all_records_by_offer](53923,null,null,null,null)

select * from [aca].[fn_record_academico_sga_definitivo](3309,null,null,1) as d
exec [aca].[sp_list_all_carreras_records] '2400459158',null,null,null,null
exec [aca].[sp_list_all_matriculas_carreras] '2400254286',null
exec [aca].[sp_list_all_asignaturas_detalle_record] 17885,113,'2022237300348',
     '2400223877',null,null,null

select m.* from aca.fn_rpt_asistencias_clase_porcentaje_sin_docente (96,null,null) as m

select   text as text,  datafield as datafield, columngroup as columngroup ,edit as edit, ciclo as ciclo
            from [aca].[sp_get_calificaciones_ciclos](96,1978,2,30) order by ordenCi, ordenCa asc
select * from mig.graduados where identificacion='2450118555'
select * from aca.asignatura_compatibilidad

SELECT
    pa.id_periodo_academico AS idPeriodoAcademico,pa.codigo AS codigoPeriodoAcademico, pa.descripcion AS periodoAcademico, em.id_estudiante_matricula AS idEstudianteMatricula,null as idRecordMatricula,
    n.id_nivel,iif(tof.codigo='PREGRADO',concat(n.descripcion_corta,' - ',n.descripcion),n.descripcion_corta) as nivel,par.descripcion_corta as paralelo,concat(n.descripcion_corta,'/',par.descripcion_corta) as curso,ma.id_malla_asignatura,
    ea.id_estudiante_asignatura as idAsignatura,ma.num_creditos,ma.num_horas,a.descripcion as asignatura,ea.promedio,ea.valor_asignatura,ea.asistencia,
    ea.aprobado,iif(ea.aprobado=1,'APROBADO','REPROBADO') as labelAprobado,ea.matricula_excepcional,nv.descripcion as vez,
    case  when o.id_tipo_oferta=4 and ea.codigo_estado_matricula='PRI'  then 'MÓDULO' when ea.codigo_estado_matricula<>'PRI' then 'REPITE'
          when  (n.id_nivel=nm.id_nivel  or o.id_tipo_oferta in (3,5,6)) and ea.codigo_estado_matricula='PRI' then 'NORMAL'
          when  n.id_nivel<nm.id_nivel and ea.codigo_estado_matricula='PRI' then 'ARRASTRE' when  n.id_nivel>nm.id_nivel and ea.codigo_estado_matricula='PRI' then 'EQUIPARA' else 'OTRO' end as condicionMatricula,
    'ASIGNATURA' as tipo ,case when ea.estado='A' then 'ACTIVO' when ea.estado in ('T','R') then 'RETIRO' when ea.estado in ('X','P') then 'ANULADO'  when ea.estado in ('Q','N') then 'REPLICA PATRICIO 2024-1'
                               when ea.estado='E' then 'ELIMINADO TEMPORALMENTE' else 'ELIMINADO' end as estadoLabel,ea.estado, iif(ma.id_malla_asignatura=ac.id_malla_asignatura,aux.carrera,null)  as otherOffer,'SGA' as origen
,eo.id_malla,m.id_malla
FROM man.personas p
         INNER JOIN aca.estudiante_oferta eo ON p.id = eo.id_persona
         inner join aca.oferta_modalidad om on eo.id_oferta_modalidad = om.id_oferta_modalidad
         inner join aca.oferta o on om.id_oferta = o.id_oferta
         INNER JOIN aca.estudiante_matricula em ON em.id_estudiante_oferta = eo.id_estudiante_oferta
         INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = em.id_matricula_general
         INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = mg.id_periodo_academico
         inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
         inner join aca.numero_vez nv on nv.id_numero_vez = ea.id_numero_vez
         inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
         left join aca.asignatura_compatibilidad ac on aa.id_malla_asignatura = ac.id_malla_asignatura_comp and ac.estado='A' and ac.tipo in ('COMPATIBILIDAD ENTRE CARRERAS','NUEVA_MALLA')
         inner join aca.malla_asignatura ma on (ac.id_malla_asignatura= ma.id_malla_asignatura or aa.id_malla_asignatura = ma.id_malla_asignatura)
--          inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
         inner join aca.malla m on ma.id_malla = m.id_malla
         inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
         inner join aca.nivel n on ma.id_nivel = n.id_nivel
         inner join aca.tipo_oferta tof on n.id_tipo_oferta = tof.id_tipo_oferta
         inner join aca.nivel nm on nm.id_nivel = em.id_nivel
         inner join aca.paralelo par on ea.id_paralelo = par.id_paralelo
         left join (select ma2.id_malla_asignatura,om2.id_oferta_modalidad,concat(om2.carrera,' - ',om2.modalidad,' - ',om2.sistema_estudio) as carrera from aca.malla_asignatura ma2
                                                                                                                                                                 inner join aca.malla m2 on ma2.id_malla = m2.id_malla
                                                                                                                                                                 inner join aca.ofertas_facultad om2 on om2.id_oferta_modalidad = m2.id_oferta_modalidad
                    where ma2.estado='A' and m2.estado in ('A','P') ) as aux on aux.id_malla_asignatura = aa.id_malla_asignatura
WHERE
    em.id_estudiante_oferta = 53923
and eo.id_malla= m.id_malla
  AND mg.estado = 'A' AND pa.estado = 'A'  and par.estado='A' and ea.estado not in ('I','Q')
  and aa.estado='A' and ma.estado='A' and a.estado='A' and o.estado='A' and om.estado='A'

--ACTUALIZAR RECORD ASIGNATURA EL CAMPO RECORD OFERTA:
select  rm.id_record_oferta,ra.*
-- update ra set ra.id_record_oferta = rm.id_record_oferta
from mig.record_asignaturas ra
         inner join mig.record_matricula rm on ra.id_record_matricula = rm.id_record_matricula
where rm.id_record_oferta<>ra.id_record_oferta

select * from mig.graduados where identificacion ='0905313235'


select distinct ro.id_record_oferta,ro.periodo,ro.identificacion,ro.carrera,ro.apellidos,ro.nombres, count( distinct case when  rm.estado='A' then 1 end) as contador_activas,
        count( distinct case when rm.estado='R' then 1 end) as contador_retiradas, count( distinct rm.id_record_matricula) as contador_todas
from mig.record_asignaturas ra
         inner join mig.record_matricula rm on ra.id_record_matricula = rm.id_record_matricula
         inner join mig.record_oferta ro on rm.id_record_oferta = ro.id_record_oferta
         inner join mig.periodo_academico_ponderacion pap on pap.id_periodo_academico = ra.id_periodo_academico
where ro.estado='R'
group by ro.id_record_oferta, ro.identificacion, ro.apellidos, ro.nombres, ro.periodo, ro.carrera


--


--     18	4	CENTROIDIOMAS	EN LINEA	MODULAR	MATRIZ-LA LIBERTAD	CENTRO DE IDIOMAS - MATRIZ NO APLICA	NO APLICA
-- 20	18	8	8	1

select d.*
--     update rm set rm.promedio = d.promedioRed,rm.fecha_mod=getdate()
from (
select distinct
                ro.id_record_oferta,ro.id_tipo_estado_estudiante,ro.identificacion,ro.apellidos,ro.nombres,ro.carrera,rm.id_record_matricula,rm.estado_matricula,rm.estado,rm.periodo,rm.promedio,ro.promedio as promedioReal,
                ro.id_periodo_academico,pap.nota_maxima,pap.nota_aprobatoria, avg(isnull(cast(ra.promedio as decimal(10,4)),0)) as promedioCAL,
          round(avg(isnull(cast(ra.promedio as decimal(10,4)),0)),2) as promedioRed
from mig.record_asignaturas ra
         inner join mig.record_matricula rm on ra.id_record_matricula = rm.id_record_matricula
         inner join mig.record_oferta ro on rm.id_record_oferta = ro.id_record_oferta
         inner join mig.periodo_academico_ponderacion pap on pap.id_periodo_academico = ra.id_periodo_academico
where rm.promedio =0 and rm.estado='A' and ra.estado='A'
and ro.identificacion='0912316718'
group by ro.id_record_oferta, ro.id_tipo_estado_estudiante, ro.identificacion, ro.apellidos, ro.nombres, ro.carrera,rm.id_record_matricula, rm.estado_matricula, rm.periodo, rm.promedio,rm.estado,
         ro.periodo, ro.promedio, ro.id_periodo_academico, pap.nota_maxima, pap.nota_aprobatoria) as d
inner join mig.record_matricula rm on d.id_record_matricula = rm.id_record_matricula
where rm.promedio<>d.promedioRed

select * from [aca].[fn_get_all_offers]('0927942342',null,null,null,null,null)
--VER USUARIO GRABO_MATRICULA
begin
    declare @id_periodo_academico int=136
    select
--   distinct  eo.*
        distinct  ea.*
--          distinct         aa.id_asignatura_aprendizaje,ma.id_nivel,a.descripcion
--         distinct em.*
--             distinct   mr.*
--         distinct em.id_estudiante_matricula,pa.codigo as periodo,om.carrera,p.identificacion,p.apellidos,p.nombres,
--                  eo.numero_matricula, ma.id_nivel, ma.id_malla_asignatura,ea.id_paralelo,ea.id_estudiante_asignatura,a.descripcion as asignatura,
--                  case when ea.estado is null then 'NO MATRICULADO' when ea.estado = 'X' then 'ANULADA'
--                      when ea.estado = 'A' then 'ACTIVA'    when ea.estado = 'I' then 'INACTIVA'
--                      else ea.estado end as estado_Matricula,em.estado,em.fecha_ing as fechaMatricula,em.fecha_mod as fechaModMatricula,
--                  concat(pu.nombres, ' ', pu.apellidos)   as usuarioCreaMatricula,
--                  concat(pu2.nombres, ' ', pu2.apellidos) as usuarioModificomatricula,ea.codigo_estado_matricula,ea.promedio
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
    where -- eo.id_estudiante_oferta = 24109 and em.id_matricula_general = 19
        -- ea.estado='A' and
--     and cast(em.fecha_ing as date)='2024-07-29' --and cast(em.fecha_ing as time(0))='10:04:20'
    --       and om.id_tipo_oferta = 2 --and ea.id_asignatura_aprendizaje = 8725
     p.identificacion in ('2450878158')
--       and aa.id_asignatura_aprendizaje in (1691)
      and  mg.id_periodo_academico = @id_periodo_academico
end

select * from aca.estudiante_asignatura where estado='I' and fecha_ing<'2026-02-26 16:00:37.3380000' and fecha_ing>'2026-02-25 00:00:37.3380000'
--añadir tasa de repitencia a los estudiantes que ven por segunda vez

select * from aca.estudiante_matricula where id_estudiante_matricula = 200813
select *from aca.tipo_estudiante
select * from aca.tipo_estado_estudiante
-- listar records
begin
    select
--     distinct  em.*
--               distinct  p.id,p.id_estado_civil,fecha_nace,p.id_pais_residencia,p.id_provincia_residencia,p.id_canton_residencia,p.id_parroquia_residencia,defuncion,id_pais_nacionalidad
   distinct eo.*
--         distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.id_persona,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,p.identificacion,p.apellidos,p.nombres,tee.descripcion,tie.descripcion,eo.estado
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
            inner join seg.usuarios u on p.id = u.persona_id
    where --eo.id_periodo_academico = @id_periodo_academico and
          p.identificacion in ('2450220302')
--        OR p.id =302492400328379

              --'0953628161','2450323387')
--     and eo.id_periodo_academico not in (28)
--         eo.id_estudiante_oferta = 45393
   and eo.id_tipo_ingreso_estudiante =9
--     eo.id_tipo_estado_estudiante in (21,22)
end;

select top 100 * from aca.estudiante_matricula
select * from aca.tipo_ingreso_estudiante
select * from aca.tipo_matricula_fecha

select * from aca.detalle_movilidad where aprobado = 0

select * from [aca].[fun_record_ingles_estudiante]('2450878158')

select * from aca.fn_requisitos_matricula(66160,136)

SELECT 1 FROM pro.fn_consultar_deudas_estudiantes('0924929102')

select d.periodo_academico,d.nivel,d.concepto,d.valor,d.abono,d.deuda from  aca.fn_record_rubros ('2450005562') d

select * from aca.fn_listar_docentes_asignaturas(76096,null,136) as d where d.orden=3
exec [aca].[pa_generar_asignaturas_a_matricular_sga] 68655,150,1,1
exec [aca].[pa_generar_asignaturas_a_matricular_sga_pruebas] 68655,150,1,1

select id_periodo_academico,codigo from aca.periodo_academico
where id_tipo_oferta=2
  and year(getdate()) BETWEEN year(fecha_desde) AND year(fecha_hasta) --and cast(getdate() as date)>fecha_desde
  and aplica_historico=0

select * from man.documentos_archivos
select * from aca.periodo_academico where id_tipo_oferta = 2

select * from aca.malla where id_malla = 145

select * from man.personas where identificacion in ('0940749643','0930749643')
select * from mig.record_oferta where identificacion ='2450220302'


select * from mig.record_oferta where periodo='2015-1'
select * from seg.usuarios where id = 13906
select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 2

select distinct m.*
from aca.movilidad m
         inner join aca.detalle_movilidad dm on  m.id_movilidad = dm.id_movilidad
         inner join aca.estudiante_oferta eo1 on m.id_estudiante_oferta = eo1.id_estudiante_oferta
         inner join aca.malla_asignatura ma on dm.id_malla_asignatura=ma.id_malla_asignatura
         inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
where  eo1.estado='A' --and dm.estado='A' and  m.estado='A'
  and ma.estado='A' and niv.estado='A' and eo1.id_estudiante_oferta = 78299

select * from mig.record_oferta where periodo in ('1999-1','1999-2')

select * from aca.tipo_ingreso_estudiante

select * from aca.tipo_estado_estudiante

select * from aca.ofertas_facultad where id_tipo_oferta = 1 and id_departamento = 11
select distinct a.descripcion,ofa.carrera,aa.id_asignatura_aprendizaje,ma.* from  aca.malla_asignatura ma
         inner join aca.nivel niv on ma.id_nivel=niv.id_nivel
            inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
            inner join aca.malla m on ma.id_malla = m.id_malla
            inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
            inner join aca.asignatura_aprendizaje aa on ma.id_malla_asignatura = aa.id_malla_asignatura
where ma.estado='A' and niv.estado='A' and m.id_oferta_modalidad in (63,108) and m.id_malla not in (66) and aa.id_componente_aprendizaje = 2
select * from aca.malla where id_oferta_modalidad = 37

select * from aca.componente_aprendizaje
--agregar relaciones en aca.asignatura_compatibilidad
select
--     distinct  em.*
    --       distinct  ea.*--,p.identificacion
--     distinct eo.*
--     distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,
--     eo.ultimo_periodo,p.identificacion,p.apellidos,p.nombres,tee.descripcion,tie.descripcion,eo.estado
        distinct eo.id_oferta_modalidad,m.id_oferta_modalidad,ma.id_malla,m2.descripcion as malla,a.descripcion,
                 ma2.id_malla_asignatura,ma.id_malla_asignatura
from man.personas p
         inner join aca.estudiante_oferta eo on eo.id_persona = p.id
        inner join aca.estudiante_matricula em on eo.id_estudiante_oferta = em.id_estudiante_oferta
        inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
        inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
        inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
        inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
        inner join aca.asignatura a2 on a2.descripcion= a.descripcion
        inner join aca.malla_asignatura ma2 on ma2.id_asignatura = a2.id_asignatura
        inner join aca.malla m2 on ma2.id_malla = m2.id_malla and m2.id_oferta_modalidad = eo.id_oferta_modalidad
    and m2.vigente = 1
        inner join aca.malla m on ma.id_malla = m.id_malla
        inner join aca.ofertas_facultad ofa1 on ofa1.id_oferta_modalidad = m.id_oferta_modalidad
         inner join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
         inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
         inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
         inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
       left join aca.asignatura_compatibilidad ac on ac.id_malla_asignatura_comp = ma.id_malla_asignatura
                                                         and ac.id_malla_asignatura = ma2.id_malla_asignatura
                                                         and ac.estado='A' --and ac.id_asignatura_compatibilidad<=301
where eo.estado='A' and ofa.id_tipo_oferta = 2 and em.estado='A' and ea.estado='A' and eo.id_oferta_modalidad <>m.id_oferta_modalidad
  and ofa1.id_tipo_oferta = 2 and ac.id_asignatura_compatibilidad is null
-- and p.identificacion ='2450097676'

select * from aca.fn_listar_docentes_asignaturas ()

select * from aca.asignatura_compatibilidad where id_asignatura_compatibilidad in (235,236,299,300,301)
select * from aca.asignatura_compatibilidad where id_malla_asignatura in (1062,1068)
select * from aca.periodo_asignatura_compatibilidad

select * from man.fn_get_image_from_person(323)

select * from man.personas where identificacion ='0950739334'

select * from mig.periodo_academico_ponderacion

select * from mig.record_oferta where identificacion='0925451932'
select * from mig.record_asignaturas where id_record_oferta = 44497 order by id_nivel,asignatura
select * from mig.record_oferta where id_record_oferta=44720
select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 4
select * from mig.record_asignaturas where id_record_oferta in (67420,68120)
select * from aca.tipo_estado_estudiante
select * from aca.tipo_ingreso_estudiante

select ro.* from mig.record_oferta ro
left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
left join mig.record_asignaturas ra on ra.id_record_oferta = ro.id_record_oferta
where rm.id_record_matricula is null and ra.id_record_asignatura is null and ro.estado='I' and ro.id_record_oferta>44497


select * from aca.numero_vez

select pii.* from man.persona_imagen pii
inner join man.personas p on p.id = pii.id_persona
where identificacion ='0953918729'

select * from aca.estudiante_asignatura ea where ea.asistencia is not null

select distinct p.identificacion,em.*
from aca.estudiante_oferta eo
    inner join man.personas p on p.id = eo.id_persona
         inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
         inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general
         inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
         where mg.id_periodo_academico=136 and em.estado='I'

select distinct codigo_estado_matricula,nv.id_numero_vez
--     update ea set ea.id_numero_vez = nv.id_numero_vez
from aca.estudiante_asignatura ea
inner join aca.numero_vez nv on ea.codigo_estado_matricula = nv.codigo
-- exec aca.matricula_posgrado 11094,44248,'1207028109',1

SELECT * FROM [tut].[fn_rpt_informe_fin_ciclo](96,9,251)
select * from aca.tipo_ingreso_estudiante
select * from aca.tipo_estado_estudiante
select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 1
-- listar records
begin
    select
--     distinct  em.*
        --       distinct  ea.*--,p.identificacion
        distinct eo.*
--         distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,p.identificacion,p.apellidos,p.nombres,tee.descripcion,tie.descripcion
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
    where --eo.id_periodo_academico = @id_periodo_academico and
        p.identificacion ='0503754236'
--         p.identificacion in ('0928011402')
--           p.identificacion in ('0931042485','1250145222','0928556265','1722825575',
-- '0950342584','0924088974','2450065111','1250270731','2450476524','0923313308','2450287897','0350308342','2450331539','2400181851',
-- '2450513672','2450805466','2450224593','2400184277','0958084329','0940918022','2450891136','2450576158')
--     and eo.id_malla in (22,161)
--     eo.id_estudiante_oferta=43677
end;

select * from tes.rubro

select * from aca.matricula_rubro where id_rubro in (5,6) and estado='I'

select * from aca.equivalencia_examen_ubicacion

select om.id_oferta_modalidad,o.* from aca.oferta o
inner join aca.oferta_modalidad om on o.id_oferta = om.id_oferta
-- inner join aca.estudiante_oferta eo on om.id_oferta_modalidad = eo.id_oferta_modalidad
where o.id_oferta>146

select * from aca.oferta_modalidad where id_oferta>146
select * from aca.oferta where id_oferta>146
SELECT * FROM aca.modalidad
select * from aca.inscripcion
select * from aca.departamento_oferta
-- DBCC CHECKIDENT ('aca.oferta', RESEED, 155);

exec  aca.sp_rpt_record_academico_ayudantias_complete 44363,136

select * from man.personas where identificacion ='2400088411'
select * from man.personas where celular ='2400088411'
select pii.* from man.persona_imagen pii
    inner  join man.personas p on p.id = pii.id_persona
where p.identificacion='2450392523'

select * from man.opciones
         where padre_id is null and estado='AC' and year(fecha_ing)='2025'

select * from aca.campus where id_institucion in (1,1545)
select * from man.informacion_academica_persona where id_institucion in (1,1545)
select * from rlx.convenio_institucion where id_institucion in (1,1545)
select * from uath.horario where id_institucion in (1,1545)
select * from aca.institucion_nivel_formacion where id_institucion in (1,1545)
select * from adq.ordenes_compra where id_institucion in (1,1545)

exec [aca].[sp_rpt_comprobante_matricula_estudiante] null , 87570

select distinct i.* from aca.institucion i
-- inner join aca.institucion_nivel_formacion inf on i.id_institucion = inf.id_institucion

select * from aca.clase where id_clase = 79151
SELECT * FROM aca.asignatura where codigo ='ECO'

SELECT * FROM  man.lugar where descripcion='COLOMBIA'
select * from aca.malla where id_oferta_modalidad = 20
select * from aca.asignatura

--get numero estudiantes
select * from aca.estudiante_oferta where id_oferta_modalidad = 91 and id_periodo_academico = 136

select distinct ro.* from mig.record_oferta ro
                     left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
                     left join mig.record_asignaturas ra on ra.id_record_oferta = ro.id_record_oferta
where ro.identificacion='0104751003'

select * from mig.listar_carreras_sga where identificacion ='0104751003'

select min(pa.fecha_desde) as fecha_desde,min(rm.fecha_matricula) as fecha_ing,min(ro.id_estudiante_oferta) as id_estudiante_oferta,eo.id_persona
from mig.record_oferta ro
         inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta = ro.id_estudiante_oferta
         inner join mig.record_oferta rod on rod.id_record_oferta = ro.id_record_oferta_padre
         inner join mig.record_matricula rm on rod.id_record_oferta = rm.id_record_oferta
         inner join mig.record_asignaturas ra on rm.id_record_matricula = ra.id_record_matricula
         inner join aca.periodo_academico pa on ra.id_periodo_academico = pa.id_periodo_academico
where rm.estado<>'I' and ra.estado<>'I' and ra.id_nivel = 1 and ro.estado='A' and rod.estado='A'and ro.identificacion ='0928022185'
group by eo.id_persona


select distinct ea.* from aca.estudiante_matricula em
                              inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
where em.id_estudiante_oferta =7642

select distinct ro.* from mig.record_oferta ro
                              left join mig.record_matricula rm on ro.id_record_oferta = rm.id_record_oferta
                              left join mig.record_asignaturas ra on ra.id_record_oferta = ro.id_record_oferta
where ro.estado='I' and rm.id_record_matricula is null and ra.id_record_asignatura is null

select * from [aca].[fn_get_all_offers]('0927283804',null,0,0,0,0)


select *from aca.estudiante_matricula where usuario_ing ='0927283804'

select * from man.opciones where nombre='Revisión de Casos Movilidad '


select * from man.documentos_archivos where table_name ='card.cupo_rutina_horario'



--calcular gratuidad
begin
    select
--     distinct  em.*
        --       distinct  ea.*--,p.identificacion
        distinct eo.*
--         distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,p.identificacion,p.apellidos,p.nombres,tee.descripcion,tie.descripcion
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
    where --eo.id_periodo_academico = @id_periodo_academico and
          p.identificacion in ('2450033986')
--     eo.id_estudiante_oferta=60393
end;

select * from man.personas where identificacion in ('2450033986')


select * from aca.tipo_estudiante
select * from aca.tipo_estado_estudiante
select * from aca.tipo_ingreso_estudiante

select dm.* from aca.movilidad m
         inner join aca.detalle_movilidad dm on m.id_movilidad = dm.id_movilidad
         where m.id_estudiante_oferta = 64605

select * from aca.oferta



begin
    select
--     distinct  em.*
        --       distinct  ea.*--,p.identificacion
--         distinct eo.*
        distinct eo.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.numero_matricula,pa.codigo,ofa.facultad,ofa.carrera,p.identificacion,p.apellidos,p.nombres,tee.descripcion,tie.descripcion
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             left join aca.periodo_academico pa on pa.id_periodo_academico = eo.id_periodo_academico
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_ingreso_estudiante tie on eo.id_tipo_ingreso_estudiante = tie.id_tipo_ingreso_estudiante
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = eo.id_oferta_modalidad
    where eo.estado='A' and ofa.id_tipo_oferta  = 2 and eo.id_tipo_estado_estudiante in (1)--eo.id_periodo_academico = @id_periodo_academico and
--           p.identificacion in ('2450033986')
--     eo.id_estudiante_oferta=60393
end;

