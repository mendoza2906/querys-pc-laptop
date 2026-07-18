use bd_sga_upse;

select * from seg.persona_codigo where id_persona = 323

select * from pro.proceso_requisito

select * from man.notificacion

select * from aca.periodo_academico where id_tipo_oferta =2

select * from man.personas where identificacion ='2400254286'

SELECT
    CASE
        WHEN pc.id_persona_codigo IS NULL THEN 'NO_EXISTE'
        WHEN pc.fue_usado = 1 THEN 'USADO'
        WHEN pc.estado <> 'A' THEN 'INACTIVO'
        WHEN DATEADD(MINUTE, pc.tiempo_valides_en_minutos, pc.fecha_generacion) < SYSDATETIME()
            THEN 'EXPIRADO'
        ELSE 'VALIDO'
        END AS estado_codigo
FROM man.personas p
         left JOIN seg.persona_codigo pc  ON p.id = pc.id_persona
WHERE p.identificacion = '2400254286'
  AND pc.codigo = 'd03fdess1'

SELECT * FROM ele.fn_obtener_miembros_asignados(1, NULL, NULL, NULL, NULL)
ORDER BY num_mesa_asignada;

--PADRON ELECTORAL
begin
    declare @id_periodo_academico int = 136,@nivel int = 1
--     select  * from (
    select pa.codigo as PERIODO_ACADEMICO,om.facultad,om.carrera,p.identificacion AS IDENTIFICACION,concat(p.apellidos,' ',p.nombres) as NOMBRES_APELLIDOS,eo.numero_matricula,te.descripcion as tipo_estudiante,
           em.id_nivel as SEMESTRE, SUM(DISTINCT IIF(m.tipo_plan = 'CREDITOS', ma.num_creditos, ma.num_horas) ) AS valorMatriculados,  SUM(DISTINCT IIF(m.tipo_plan = 'CREDITOS', ma1.num_creditos, ma1.num_horas) ) AS valorMalla
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.malla m on eo.id_malla = m.id_malla
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
             inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
             inner join aca.malla_asignatura ma1 on ma1.id_nivel = em.id_nivel and ma1.id_malla = eo.id_malla
             inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
             inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
             inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
             inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
    where p.estado='AC' and eo.estado='A' and em.estado = 'A' and ma1.estado='A' and ma.id_nivel>=@nivel and ea.estado='A'
      and  mg.id_periodo_academico in (@id_periodo_academico)
    group by pa.codigo,om.carrera,om.facultad,p.id,p.identificacion,p.apellidos,p.nombres,te.descripcion,em.id_nivel, eo.numero_matricula
    --     ) as d
-- --     where d.CREDITOS_APROBADOS<>TOTAL_CREDITOS_APROBADOS
--     order by d.facultad,d.carrera,d.SEMESTRE,d.NOMBRES_APELLIDOS
end

BEGIN
    DECLARE @id_periodo_academico INT = 136, @nivel INT = 3;
    -- 🔹 Créditos matriculados por estudiante y nivel
    WITH Matriculados AS (
        SELECT
            em.id_estudiante_matricula,em.estado,
            SUM(IIF(m.tipo_plan = 'CREDITOS', ma.num_creditos, ma.num_horas)) AS valorMatriculados
        FROM aca.estudiante_matricula em
                 INNER JOIN aca.estudiante_oferta eo ON em.id_estudiante_oferta = eo.id_estudiante_oferta
                 INNER JOIN aca.malla m ON eo.id_malla = m.id_malla
                 INNER JOIN aca.estudiante_asignatura ea ON em.id_estudiante_matricula = ea.id_estudiante_matricula
                 INNER JOIN aca.asignatura_aprendizaje aa ON ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
                 INNER JOIN aca.malla_asignatura ma ON aa.id_malla_asignatura = ma.id_malla_asignatura
        WHERE em.estado = 'A' AND
            ea.estado  ='A'
        GROUP BY em.id_estudiante_matricula, em.estado
    ),
         -- 🔹 Total de la malla por nivel
         MallaNivel AS (
             SELECT  m.id_malla,  id_nivel, SUM(IIF(m.tipo_plan = 'CREDITOS', ma.num_creditos, ma.num_horas)) AS valorMalla,
                     SUM(IIF(m.tipo_plan = 'CREDITOS', ma.num_creditos, ma.num_horas)*0.6) as valorSesenta
             FROM aca.malla_asignatura ma
                      INNER JOIN aca.malla m  ON ma.id_malla = m.id_malla
             WHERE ma.estado = 'A'
             GROUP BY m.id_malla, id_nivel
         )
    SELECT
        pa.codigo AS PERIODO_ACADEMICO, om.facultad,om.carrera, p.identificacion,
        CONCAT(p.apellidos, ' ', p.nombres) AS NOMBRES_APELLIDOS, eo.numero_matricula,  te.descripcion AS tipo_estudiante, em.id_nivel AS SEMESTRE,

        mtr.valorMatriculados,
        mn.valorMalla,mn.valorSesenta, om.sedeCorta,mtr.estado

    FROM man.personas p
             INNER JOIN aca.estudiante_oferta eo on eo.id_persona = p.id
             INNER JOIN aca.tipo_estudiante te ON eo.id_tipo_estudiante = te.id_tipo_estudiante
             INNER JOIN aca.estudiante_matricula em ON em.id_estudiante_oferta = eo.id_estudiante_oferta
             INNER JOIN aca.matricula_general mg ON mg.id_matricula_general = em.id_matricula_general
             INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = mg.id_periodo_academico
             INNER JOIN aca.ofertas_facultad om ON om.id_oferta_modalidad = eo.id_oferta_modalidad
        -- 🔹 joins a cálculos correctos
             LEFT JOIN Matriculados mtr  ON mtr.id_estudiante_matricula = em.id_estudiante_matricula
             LEFT JOIN MallaNivel mn  ON mn.id_malla = eo.id_malla  AND mn.id_nivel = em.id_nivel
    WHERE p.estado = 'AC' AND eo.estado = 'A'
      AND em.estado = 'A'
--        and p.identificacion in ('0927363069','0957134703','0919659318','2400356040','2450537713','0928018811','2450742883','0928022870','0940825656','2450110024',
--                             '0922585146','0924982846','0929016574','2450773995','0928191139','2400456782','2450637695','0927833400','0928270818','2450265083')
      AND mg.id_periodo_academico = @id_periodo_academico
      AND em.id_nivel >= @nivel and mtr.valorMatriculados>=mn.valorSesenta
    ORDER BY om.facultad,om.carrera, em.id_nivel,NOMBRES_APELLIDOS;
END

begin
    declare @apellidos varchar(100)='Gaspar',@nombres varchar(100)=''
select p.id,p.identificacion,p.apellidos,p.nombres,p.fecha_nace,p.celular
from man.personas P WHERE ((p.apellidos like '%'+@apellidos+'%' and p.nombres like '%'+@nombres+'%') or  (p.apellido_paterno like '%'+@apellidos+'%' and p.primer_nombre like '%'+@nombres+'%'))
end
--     Figueroa Pico César Eubelio
-- García Santos Vladimir Israel
-- Padilla Gallegos Andrés Isidro
--
-- Ivan Coronel
-- Veronica Andrade
-- Daniel Quirumbay
-- Balmaseda
-- Mederos Machado
-- Gaspar
--lista presidente
begin
    declare @id_periodo_academico int = 136,@nivel int = 1
--     select  * from (
    select p.apellidos as APELLIDOS, p.nombres as NOMBRES, concat('ESTUDIANTE DE ',om.carrera ) as CARGO,
           concat(em.id_nivel,' SEMESTRE') as SEMESTRE,tjl.descripcion as 'JORNADA',
           N'UNIVERSIDAD ESTATAL PENÍNSULA DE SANTA ELENA' as universidad,p.identificacion as CEDULA
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.malla m on eo.id_malla = m.id_malla
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
             inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
             inner join aca.malla_asignatura ma1 on ma1.id_nivel = em.id_nivel and ma1.id_malla = eo.id_malla
             inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
             inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
             inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
             inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
             left join aca.tipo_jornada_laboral tjl on em.id_tipo_jornada_laboral = tjl.id_tipo_jornada_laboral
    where p.estado='AC' and eo.estado='A' and em.estado = 'A' and ma1.estado='A' and ma.id_nivel>=@nivel and ea.estado='A'
      and  mg.id_periodo_academico in (@id_periodo_academico) and tjl.id_tipo_jornada_laboral =3
    group by p.id,p.identificacion,p.apellidos,p.nombres,te.descripcion,em.id_nivel, eo.numero_matricula, om.carrera, tjl.descripcion
    order by p.apellidos,p.nombres
    --     ) as d
-- --     where d.CREDITOS_APROBADOS<>TOTAL_CREDITOS_APROBADOS
--     order by d.facultad,d.carrera,d.SEMESTRE,d.NOMBRES_APELLIDOS
end
select * from aca.oferta_modalidad

select * from aca.campus

select * from aca.oferta

select * from aca.modalidad_asignatura

--listar por franja horaria
begin
    declare @id_periodo_academico int = 136,@nivel int = 1
--     select  * from (
    select om.sede,tjl.descripcion,count( distinct p.identificacion) as numero
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.malla m on eo.id_malla = m.id_malla
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
             inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
             inner join aca.malla_asignatura ma1 on ma1.id_nivel = em.id_nivel and ma1.id_malla = eo.id_malla
             inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
             inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
             inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
             inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
             left join aca.tipo_jornada_laboral tjl on em.id_tipo_jornada_laboral = tjl.id_tipo_jornada_laboral
    where p.estado='AC' and eo.estado='A' and em.estado = 'A' and ma1.estado='A' and ma.id_nivel>=@nivel and ea.estado='A'
      and  mg.id_periodo_academico in (@id_periodo_academico) and ma.id_modalidad_asignatura = 1
    group by om.sede, tjl.descripcion
end

select * from aca.moodle where id_periodo_academico = 136

-- http://192.168.40.235

select * from aca.tipo_proceso_moodle

begin
    declare @id_periodo_academico int = 136,@nivel int = 1
    select om.carrera,om.modalidad,em.id_nivel,tjl.descripcion,count( distinct p.identificacion) as numero
    from man.personas p
             inner join aca.estudiante_oferta eo on eo.id_persona = p.id
             inner join aca.malla m on eo.id_malla = m.id_malla
             inner join aca.tipo_estado_estudiante tee on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
             inner join aca.tipo_estudiante te on eo.id_tipo_estudiante = te.id_tipo_estudiante
             inner join aca.estudiante_matricula em on em.id_estudiante_oferta= eo.id_estudiante_oferta
             inner join aca.malla_asignatura ma1 on ma1.id_nivel = em.id_nivel and ma1.id_malla = eo.id_malla
             inner join aca.estudiante_asignatura ea on em.id_estudiante_matricula = ea.id_estudiante_matricula
             inner join aca.asignatura_aprendizaje aa on ea.id_asignatura_aprendizaje = aa.id_asignatura_aprendizaje
             inner join aca.malla_asignatura ma on aa.id_malla_asignatura = ma.id_malla_asignatura
             inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
             inner join aca.periodo_academico pa on pa.id_periodo_academico = mg.id_periodo_academico
             inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
             left join aca.tipo_jornada_laboral tjl on em.id_tipo_jornada_laboral = tjl.id_tipo_jornada_laboral
    where p.estado='AC' and eo.estado='A' and em.estado = 'A' and ma1.estado='A' and ma.id_nivel>=@nivel and ea.estado='A'
      and  mg.id_periodo_academico in (@id_periodo_academico)
    group by om.carrera, tjl.descripcion, em.id_nivel, om.modalidad
    order by om.carrera,em.id_nivel
end