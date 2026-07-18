use bd_sga_upse


select * from man.documentos_ubicacion
select * from aca.documento_item
select * from vcc.proyecto
select * from vcc.docente_proyecto
select * from aca.ofertas_facultad where id_tipo_oferta = 1
select * from aca.oferta_traduccion

select * from  aca.planificacion_oferta
select * from aca.tipo_jornada_laboral
select * from aca.periodo_academico pa where pa.id_tipo_oferta = 2

select getdate()

select * from man.personas where identificacion in ('0202018975','0202018974')

select * from aca.subtipo_movilidad

select * from aca.tipo_oferta_movilidad

select * from aca.periodo_academico

select * from aca.tipo_ingreso_estudiante where id_tipo_ingreso_estudiante in (8, 6, 10)
select * from aca.tipo_estado_estudiante tee
-- select * from aca.periodo_academico_oferta where id_periodo_academico_oferta in (825,862)
SELECT TOP 1 id_periodo_academico
FROM aca.periodo_academico per
WHERE GETDATE() BETWEEN per.fecha_desde AND per.fecha_hasta
  AND estado = 'A'
  and per.id_tipo_oferta = 2
ORDER BY per.fecha_desde DESC
select * from [dbu].[listar_reservaciones_pacientes_header](25777,27739)
select * from aca.asignatura_compatibilidad

--insertar planificaciones por oferta
begin

    DECLARE @id_oferta_modalidad INT = NULL;
-- INSERT INTO aca.planificacion_oferta
    SELECT
--     p.id_periodo_academico,
res.id_periodo_academico_oferta_niv,
-- res.facultad,res.carrera,
res.id_paralelo,
res.id_jornada_laboral,
res.estado,
res.version,
res.fecha_ing,
res.fecha_mod,
res.usuario_ing,
res.usuario_mod
    FROM aca.periodo_academico p
             CROSS APPLY (
        SELECT
            distinct ofa.carrera,ofa.facultad,
            pao.id_periodo_academico_oferta,pag.id_periodo_academico_oferta as id_periodo_academico_oferta_niv,
            daa.id_paralelo,
            isnull(
            (
                       SELECT TOP 1 d.idJornada
                       FROM (
                                SELECT tjl1.id_tipo_jornada_laboral AS idJornada,
                                       sum(isnull(DATEDIFF(hour, hac.hora_inicio, hac.hora_fin),0)) AS hora
                                FROM aca.horario_academico hac
                                         inner join aca.malla_asignatura ma on hac.id_malla_asignatura = ma.id_malla_asignatura
                                         inner join aca.malla m1 on ma.id_malla = m1.id_malla
                                         INNER JOIN aca.tipo_horario_jornada_lab thj1 ON thj1.id_tipo_horario_jornada_lab = hac.id_tipo_horario_jornada_lab
                                         INNER JOIN aca.tipo_jornada_laboral tjl1 ON tjl1.id_tipo_jornada_laboral = thj1.id_tipo_jornada_laboral
                                         INNER JOIN aca.dia dia ON dia.id_dia = hac.id_dia
                                         INNER JOIN aca.paralelo p1 ON hac.id_paralelo = p1.id_paralelo
                                WHERE hac.estado = 'A'
                                  AND m1.id_oferta_modalidad= m.id_oferta_modalidad
                                  AND hac.id_paralelo = daa.id_paralelo
                                  AND hac.id_periodo_academico = p.id_periodo_academico
                                GROUP BY tjl1.id_tipo_jornada_laboral
                            ) d
                       ORDER BY d.hora DESC)
                   ,1)
                    AS id_jornada_laboral,
            'A' AS estado,
            0 AS version,
            GETDATE() AS fecha_ing,
            GETDATE() AS fecha_mod,
            '2400254286' AS usuario_ing,
            '2400254286' AS usuario_mod
        FROM aca.distributivo_oferta dio
                 INNER JOIN aca.periodo_academico_oferta pao ON pao.id_periodo_academico_oferta = dio.id_periodo_academico_oferta
                 INNER JOIN aca.distributivo_docente ddo ON ddo.id_distributivo_oferta = dio.id_distributivo_oferta
                 INNER JOIN aca.docente_asignatura_aprend daa ON daa.id_distributivo_docente = ddo.id_distributivo_docente
                 INNER JOIN aca.asignatura_aprendizaje aa ON aa.id_asignatura_aprendizaje = daa.id_asignatura_aprendizaje
                 INNER JOIN aca.componente_aprendizaje co ON co.id_componente_aprendizaje = aa.id_componente_aprendizaje
                 INNER JOIN aca.malla_asignatura ma ON ma.id_malla_asignatura = aa.id_malla_asignatura
                 INNER JOIN aca.malla m ON ma.id_malla = m.id_malla
                 INNER JOIN aca.ofertas_facultad ofa ON ofa.id_oferta_modalidad = m.id_oferta_modalidad
                left join aca.periodo_academico_oferta pag on pag.id_oferta_modalidad = m.id_oferta_modalidad and pag.id_periodo_academico = p.id_periodo_academico
                 INNER JOIN aca.asignatura asig ON asig.id_asignatura = ma.id_asignatura
                 INNER JOIN aca.nivel n ON ma.id_nivel = n.id_nivel
                 INNER JOIN aca.paralelo pl ON daa.id_paralelo = pl.id_paralelo
                 INNER JOIN aca.planificacion_paralelo pp ON pp.id_malla_asignatura = ma.id_malla_asignatura
                 INNER JOIN (
            SELECT dio1.id_distributivo_oferta, pao1.id_oferta_modalidad,
                   ROW_NUMBER() OVER (PARTITION BY pao1.id_oferta_modalidad ORDER BY dio1.id_distributivo_oferta DESC) AS rn
            FROM aca.periodo_academico pa
                     INNER JOIN aca.periodo_academico_oferta pao1 ON pao1.id_periodo_academico = pa.id_periodo_academico
                     INNER JOIN aca.distributivo_oferta dio1 ON pao1.id_periodo_academico_oferta = dio1.id_periodo_academico_oferta
            WHERE dio1.estado IN ('A','V','D','P') AND pao1.estado = 'A'
              AND (pa.id_periodo_academico = p.id_periodo_academico OR pa.id_periodo_academico_padre = p.id_periodo_academico)
        ) AS ud ON ddo.id_distributivo_oferta = ud.id_distributivo_oferta AND ud.rn = 1
        WHERE ddo.estado='A' AND daa.estado='A' AND aa.estado='A' AND dio.estado IN ('A','V','D','P') AND pao.estado='A' AND pl.estado='A'
          AND ma.estado='A' AND co.estado='A' AND asig.estado='A' AND n.estado='A'
          AND (m.id_oferta_modalidad = @id_oferta_modalidad OR @id_oferta_modalidad IS NULL)
          AND (pp.id_periodo_academico = p.id_periodo_academico OR pp.id_periodo_academico = (SELECT pa.id_periodo_academico_padre FROM aca.periodo_academico pa WHERE pa.id_periodo_academico = p.id_periodo_academico))
          AND co.codigo IN (
            SELECT dd.codigoHijo
            FROM aca.fn_listar_componentes_aprendizajes_reglamento(
                         (SELECT mg.id_reglamento FROM aca.matricula_general mg WHERE mg.id_periodo_academico = p.id_periodo_academico)
                 ) dd
        )
          AND ofa.id_tipo_oferta = (
            SELECT pa.id_tipo_oferta FROM aca.periodo_academico pa WHERE pa.id_periodo_academico = p.id_periodo_academico
        )
        GROUP BY pao.id_periodo_academico_oferta, daa.id_paralelo,  pl.id_paralelo, ofa.facultad, ofa.carrera,ma.id_malla_asignatura,m.id_oferta_modalidad,pag.id_periodo_academico_oferta
    ) res
    where p.id_tipo_oferta =1
       and  p.id_periodo_academico =138
end


-- select * from aca.tipo_documento_traduccion

-- select * from hdv.idioma
select * from man.idioma

select * from aca.planificacion_paralelo
--  DBCC CHECKIDENT ('aca.planificacion_paralelo_detalle', RESEED, 14959);

select --pa.codigo,pa.id_tipo_oferta,pp.id_periodo_academico,
--       distinct a.descripcion,
               ppd.*
-- update ppd set ppd.unico_docente = pp.unico_docente
-- update ppd set ppd.cobertura_idioma = 'NOAPLICA'
from aca.planificacion_paralelo_detalle ppd
inner join aca.planificacion_paralelo pp on ppd.id_planificacion_paralelo = pp.id_planificacion_paralelo
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = pp.id_malla_asignatura
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.periodo_academico pa on pa.id_periodo_academico = pp.id_periodo_academico
where pp.id_periodo_academico = 96 and m.id_oferta_modalidad =31 and ma.id_nivel=8 and pa.estado='A' and ma.estado='A' and ppd.estado='A'
and pp.id_planificacion_paralelo not in (8442)

select * from aca.fn_get_validacion_planificacion_paralelo(295,null) order by idMallaAsignatura, paralelo

select * from aca.periodo_academico

select* from migracion_sga..entidades_migracion

select* from migracion_sga..registros_migracion where id_entidad_relacion=41

select * from pro.etapa_ejecucion_requisito2 where id_etapa_ejecucion_requisito = 71727

SELECT  e.*
	from  aca.Planificacion_Paralelo e
inner join aca.Malla_Asignatura ma on e.id_Malla_Asignatura=ma.id_malla_asignatura
inner join aca.periodo_malla pma on  ma.id_malla = pma.id_malla
inner join aca.Malla m on m.id_malla=pma.id_malla
inner join aca.periodo_academico_oferta pao on  pao.id_oferta_modalidad=m.id_oferta_modalidad
inner join aca.periodo_academico pa on pao.id_periodo_academico = pa.id_periodo_academico
where e.id_periodo_academico=pma.id_periodo_academico and pao.id_periodo_academico=pma.id_periodo_academico and
      pao.estado='A' and (pa.id_periodo_academico=96 or pa.id_periodo_academico_padre = 96) and m.id_malla=101 and pma.estado='A' and e.estado='A' and ma.estado='A' and m.estado in ('A','P')

select ppd.*
from aca.planificacion_paralelo_detalle ppd
inner join aca.planificacion_paralelo pp on ppd.id_planificacion_paralelo = pp.id_planificacion_paralelo
where pp.id_periodo_academico = 127

select * from aca.tipo_jornada_laboral

select * from man.idioma

select d.* from aca.fn_get_planificacion_paralelo (902,83) as d

select d.*  from aca.fn_get_planificacion_paralelo_detalle (902,101) as d

select distinct id_periodo_academico_cg,id_periodo_academico,periodo from mig.record_oferta where id_periodo_academico_cg is not null and id_tipo_oferta = 4

select id_periodo_academico,id_periodo_academico_padre,codigo_tipo_periodo,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 1
select distinct * from mig.record_oferta where id_periodo_academico in (82,116)
--  DBCC CHECKIDENT ('aca.planificacion_paralelo_detalle', RESEED, 0);

select * from [pro].[fn_list_evaluaciones_by_process](63,10,null)


select * from pro.evaluaciones_docente_categoria

select * from pro.etapa_evaluaciones

select ppd.*
--     pa.codigo,om.carrera,ma.id_nivel,a.descripcion,ma.id_malla_asignatura--,ppd.*
from aca.planificacion_paralelo pp
    inner join aca.malla_asignatura ma on pp.id_malla_asignatura =ma.id_malla_asignatura
    inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
    inner join aca.malla m on ma.id_malla = m.id_malla
    inner join aca.ofertas_facultad om on om.id_oferta_modalidad = m.id_oferta_modalidad
    inner join aca.periodo_academico pa on pa.id_periodo_academico = pp.id_periodo_academico
    left join  aca.planificacion_paralelo_detalle ppd on pp.id_planificacion_paralelo = ppd.id_planificacion_paralelo
where pp.id_periodo_academico = 27 and ma.id_malla_asignatura = 354

--     ppd.id_planificacion_paralelo_detalle is null

select * from aca.planificacion_paralelo_detalle
begin
DECLARE @id_oferta_modalidad INT = NULL;
-- INSERT INTO aca.planificacion_paralelo_detalle
SELECT
--     p.id_periodo_academico,
    res.id_planificacion_paralelo,
    res.id_paralelo,
    res.id_modalidad_asignatura,
    res.id_numero_vez,
    res.id_jornada_laboral,
    res.id_idioma,
    res.nuMatriculados,
res.unico_docente,
    res.estado,
    res.version,
    res.fecha_ing,
    res.fecha_mod,
    res.usuario_ing,
    res.usuario_mod
FROM aca.periodo_academico p
         CROSS APPLY (
    SELECT
        pp.id_planificacion_paralelo,
        daa.id_paralelo,
        pp.id_modalidad_asignatura,
        pp.id_numero_vez AS id_numero_vez,
        isnull((
            SELECT TOP 1 d.idJornada
            FROM (
                     SELECT hac.id_malla_asignatura, p1.id_paralelo, tjl1.id_tipo_jornada_laboral AS idJornada,
                            DATEDIFF(hour, hac.hora_inicio, hac.hora_fin) AS hora
                     FROM aca.horario_academico hac
                              INNER JOIN aca.tipo_horario_jornada_lab thj1 ON thj1.id_tipo_horario_jornada_lab = hac.id_tipo_horario_jornada_lab
                              INNER JOIN aca.tipo_jornada_laboral tjl1 ON tjl1.id_tipo_jornada_laboral = thj1.id_tipo_jornada_laboral
                              INNER JOIN aca.dia dia ON dia.id_dia = hac.id_dia
                              INNER JOIN aca.paralelo p1 ON hac.id_paralelo = p1.id_paralelo
                     WHERE hac.estado = 'A'
                       AND hac.id_malla_asignatura = ma.id_malla_asignatura
                       AND hac.id_paralelo = daa.id_paralelo
                       AND hac.id_periodo_academico = p.id_periodo_academico
                     GROUP BY hac.id_malla_asignatura, p1.id_paralelo, tjl1.id_tipo_jornada_laboral, hac.hora_inicio, hac.hora_fin
                 ) d
            ORDER BY d.id_malla_asignatura, d.hora DESC
        ),1) AS id_jornada_laboral,
        20 AS id_idioma,
        ISNULL(
                [aca].[fn_esc_get_numero_estudiantes_matriculados_by_asignatura_paralelo](
                        ma.id_malla_asignatura, pl.id_paralelo, p.id_periodo_academico, NULL
                ),
                0
        ) AS nuMatriculados,
        'A' AS estado,pp.unico_docente,
        0 AS version,
        GETDATE() AS fecha_ing,
        GETDATE() AS fecha_mod,
        '2400254286' AS usuario_ing,
        '2400254286' AS usuario_mod
    FROM aca.distributivo_oferta dio
             INNER JOIN aca.periodo_academico_oferta pao ON pao.id_periodo_academico_oferta = dio.id_periodo_academico_oferta
             INNER JOIN aca.distributivo_docente ddo ON ddo.id_distributivo_oferta = dio.id_distributivo_oferta
             INNER JOIN aca.docente_asignatura_aprend daa ON daa.id_distributivo_docente = ddo.id_distributivo_docente
             INNER JOIN aca.asignatura_aprendizaje aa ON aa.id_asignatura_aprendizaje = daa.id_asignatura_aprendizaje
             INNER JOIN aca.componente_aprendizaje co ON co.id_componente_aprendizaje = aa.id_componente_aprendizaje
             INNER JOIN aca.malla_asignatura ma ON ma.id_malla_asignatura = aa.id_malla_asignatura
             INNER JOIN aca.malla m ON ma.id_malla = m.id_malla
             INNER JOIN aca.ofertas_facultad ofa ON ofa.id_oferta_modalidad = m.id_oferta_modalidad
             INNER JOIN aca.asignatura asig ON asig.id_asignatura = ma.id_asignatura
             INNER JOIN aca.nivel n ON ma.id_nivel = n.id_nivel
             INNER JOIN aca.paralelo pl ON daa.id_paralelo = pl.id_paralelo
             INNER JOIN aca.planificacion_paralelo pp ON pp.id_malla_asignatura = ma.id_malla_asignatura
             INNER JOIN (
        SELECT dio1.id_distributivo_oferta, pao1.id_oferta_modalidad,
               ROW_NUMBER() OVER (PARTITION BY pao1.id_oferta_modalidad ORDER BY dio1.id_distributivo_oferta DESC) AS rn
        FROM aca.periodo_academico pa
                 INNER JOIN aca.periodo_academico_oferta pao1 ON pao1.id_periodo_academico = pa.id_periodo_academico
                 INNER JOIN aca.distributivo_oferta dio1 ON pao1.id_periodo_academico_oferta = dio1.id_periodo_academico_oferta
        WHERE dio1.estado IN ('A','V','D','P') AND pao1.estado = 'A'
          AND (pa.id_periodo_academico = p.id_periodo_academico OR pa.id_periodo_academico_padre = p.id_periodo_academico)
    ) AS ud ON ddo.id_distributivo_oferta = ud.id_distributivo_oferta AND ud.rn = 1
    WHERE ddo.estado='A' AND daa.estado='A' AND aa.estado='A' AND dio.estado IN ('A','V','D','P') AND pao.estado='A' AND pl.estado='A'
      AND ma.estado='A' AND co.estado='A' AND asig.estado='A' AND n.estado='A'
      AND (m.id_oferta_modalidad = @id_oferta_modalidad OR @id_oferta_modalidad IS NULL)
      AND (pp.id_periodo_academico = p.id_periodo_academico OR pp.id_periodo_academico = (SELECT pa.id_periodo_academico_padre FROM aca.periodo_academico pa WHERE pa.id_periodo_academico = p.id_periodo_academico))
      AND co.codigo IN (
        SELECT dd.codigoHijo
        FROM aca.fn_listar_componentes_aprendizajes_reglamento(
                     (SELECT mg.id_reglamento FROM aca.matricula_general mg WHERE mg.id_periodo_academico = p.id_periodo_academico)
             ) dd
    )
      AND ofa.id_tipo_oferta = (
        SELECT pa.id_tipo_oferta FROM aca.periodo_academico pa WHERE pa.id_periodo_academico = p.id_periodo_academico
    )
    GROUP BY pp.id_planificacion_paralelo, daa.id_paralelo, pp.id_modalidad_asignatura, ma.id_malla_asignatura,
             pl.id_paralelo, ofa.facultad, ofa.carrera, asig.descripcion, n.descripcion_corta, pl.descripcion_corta,pp.id_numero_vez,pp.unico_docente
) res
    where p.id_periodo_academico =14 and res.id_planificacion_paralelo is not null
end
--14775
select * from aca.planificacion_paralelo_detalle
-- DBCC CHECKIDENT ('aca.planificacion_paralelo_detalle', RESEED, 14775);
--insert into
begin
    declare @id_periodo_academico int = 127, @id_oferta_modalidad int = null
    select
--                      ofa.facultad,ofa.carrera,ma.id_malla_asignatura,asig.descripcion, concat(n.descripcion_corta ,'/', pl.descripcion_corta) as curso,
                     pp.id_planificacion_paralelo,daa.id_paralelo,pp.id_modalidad_asignatura,null as id_numero_vez,
                     (   select top 1 d.idJornada from (
                           select hac.id_malla_asignatura,p1.id_paralelo,p1.descripcion as paralelo,tjl1.id_tipo_jornada_laboral as idJornada,tjl1.descripcion as jornada,
                                  datediff(hour,hac.hora_inicio,hac.hora_fin) as hora from aca.horario_academico hac
                                                                                               inner join aca.tipo_horario_jornada_lab thj1 on thj1.id_tipo_horario_jornada_lab = hac.id_tipo_horario_jornada_lab
                                                                                               inner join aca.tipo_jornada_laboral tjl1 on tjl1.id_tipo_jornada_laboral = thj1.id_tipo_jornada_laboral
                                                                                               inner join aca.dia dia on dia.id_dia = hac.id_dia
                                                                                               inner join aca.paralelo p1 on hac.id_paralelo=p1.id_paralelo
                           where   hac.estado='A' and hac.id_malla_asignatura = ma.id_malla_asignatura and hac.id_paralelo = daa.id_paralelo and hac.id_periodo_academico = @id_periodo_academico
                           group by hac.id_malla_asignatura,p1.id_paralelo,p1.descripcion,tjl1.id_tipo_jornada_laboral,tjl1.descripcion,hac.hora_inicio,hac.hora_fin
                    ) as d
                    order by d.id_malla_asignatura,d.hora desc
                    ) as id_jornada_laboral,20 as id_idioma,
                    isnull([aca].[fn_esc_get_numero_estudiantes_matriculados_by_asignatura_paralelo](ma.id_malla_asignatura,pl.id_paralelo,
                                                                                                     @id_periodo_academico,null),0) as nuMatriculados,
        'A' as estado,0 as version, getdate() as fecha_ing, getdate() as fecha_mod,'2400254286' as usuario_ing, '2400254286' as usuario_mod
    from aca.distributivo_oferta dio
             inner join aca.periodo_academico_oferta pao on pao.id_periodo_academico_oferta = dio.id_periodo_academico_oferta
            inner join aca.periodo_academico pa on pao.id_periodo_academico = pa.id_periodo_academico
             inner join aca.distributivo_docente ddo on ddo.id_distributivo_oferta = dio.id_distributivo_oferta
             inner join aca.docente_asignatura_aprend daa on daa.id_distributivo_docente = ddo.id_distributivo_docente
             inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = daa.id_asignatura_aprendizaje
             inner join aca.componente_aprendizaje co on  co.id_componente_aprendizaje = aa.id_componente_aprendizaje
             inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
             inner join aca.malla m on ma.id_malla = m.id_malla
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
             inner join aca.asignatura asig on asig.id_asignatura = ma.id_asignatura
             inner join aca.nivel n on ma.id_nivel = n.id_nivel
             inner join aca.paralelo pl on daa.id_paralelo = pl.id_paralelo
             inner join aca.planificacion_paralelo pp on pp.id_malla_asignatura = ma.id_malla_asignatura
             inner join (
        SELECT dio1.id_distributivo_oferta, pao1.id_oferta_modalidad, pao1.estado AS estado_pao,  dio1.estado AS estado_dio,  pa.id_periodo_academico,pa.codigo,
               ROW_NUMBER() OVER (PARTITION BY pao1.id_oferta_modalidad ORDER BY dio1.id_distributivo_oferta DESC) AS rn
        FROM aca.periodo_academico pa
                 INNER JOIN aca.periodo_academico_oferta pao1  ON pao1.id_periodo_academico = pa.id_periodo_academico
                 INNER JOIN aca.distributivo_oferta dio1 ON pao1.id_periodo_academico_oferta = dio1.id_periodo_academico_oferta
        WHERE dio1.estado IN ('A','V','D','P') AND pao1.estado = 'A'   and  (pa.id_periodo_academico = @id_periodo_academico or pa.id_periodo_academico_padre = @id_periodo_academico)
    ) as ud ON ddo.id_distributivo_oferta = ud.id_distributivo_oferta AND ud.rn = 1
             left join
         (
             select d.id_docente,p.nombres,p.apellidos from aca.docente d
                                                                inner join man.personas p on p.id = d.id_persona
             where d.estado='A' and p.estado='AC'
         ) as aux on ddo.id_docente = aux.id_docente
    where ddo.estado='A' and daa.estado='A' and aa.estado='A' and dio.estado in ('A','V','D','P') and pao.estado='A' and pl.estado='A'
      and  ma.estado='A' and co.estado='A' and asig.estado='A' and n.estado='A' and (m.id_oferta_modalidad = @id_oferta_modalidad or @id_oferta_modalidad is null)
      and  (pp.id_periodo_academico = @id_periodo_academico or pp.id_periodo_academico= pa.id_periodo_academico_padre)
      and  co.codigo in (select dd.codigoHijo from aca.fn_listar_componentes_aprendizajes_reglamento((select mg.id_reglamento from aca.matricula_general mg
                                                                                                      where mg.id_periodo_academico = @id_periodo_academico) ) as dd)
      and ofa.id_tipo_oferta = (select pa.id_tipo_oferta from aca.periodo_academico pa where pa.id_periodo_academico = @id_periodo_academico)
    group by pp.id_planificacion_paralelo, daa.id_paralelo, pp.id_modalidad_asignatura, ma.id_malla_asignatura, pl.id_paralelo, ofa.facultad, ofa.carrera, asig.descripcion, n.descripcion_corta, pl.descripcion_corta
    order by ofa.facultad,ofa.carrera,n.descripcion_corta ,pl.descripcion_corta
end

select * from aca.matricula_general mg
select * from aca.tipo_matricula_fecha

select id_periodo_academico,id_periodo_academico_padre,codigo_tipo_periodo,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 1


select * from aca.actividad_personal_docente
select * from aca.actividad_docente_detalle

begin
    declare @id_periodo_academico int = 127, @id_oferta_modalidad int = null
    select distinct  ddo.id_distributivo_oferta,ddo.id_distributivo_docente,n.descripcion_corta as nivel,pl.descripcion_corta as paralelo,aux.id_docente,
                     ofa.facultad,ofa.carrera,ma.id_malla_asignatura,asig.descripcion,
                     concat(n.descripcion_corta ,'/', pl.descripcion_corta) as curso,
                     daa.num_estudiantes,case when aux.id_docente is null THEN 'DOCENTE AÚN POR DEFINIR' ELSE concat(aux.apellidos,' ',aux.nombres) END as docente,
                     isnull([aca].[fn_esc_get_numero_estudiantes_matriculados_by_asignatura_paralelo](ma.id_malla_asignatura,pl.id_paralelo,
                                                                                                      @id_periodo_academico,null),0) as nuMatriculados,
                     co.codigo as componente,daa.id_docente_asignatura_aprend,aa.id_asignatura_aprendizaje,pao.id_periodo_academico,m.id_oferta_modalidad,
                     pao.id_reglamento
    from aca.distributivo_oferta dio
             inner join aca.periodo_academico_oferta pao on pao.id_periodo_academico_oferta = dio.id_periodo_academico_oferta
             inner join aca.distributivo_docente ddo on ddo.id_distributivo_oferta = dio.id_distributivo_oferta
             inner join aca.docente_asignatura_aprend daa on daa.id_distributivo_docente = ddo.id_distributivo_docente
             inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = daa.id_asignatura_aprendizaje
             inner join aca.componente_aprendizaje co on  co.id_componente_aprendizaje = aa.id_componente_aprendizaje
             inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
             inner join aca.malla m on ma.id_malla = m.id_malla
             inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
             inner join aca.asignatura asig on asig.id_asignatura = ma.id_asignatura
             inner join aca.nivel n on ma.id_nivel = n.id_nivel
             inner join aca.paralelo pl on daa.id_paralelo = pl.id_paralelo
             inner join (
        SELECT dio1.id_distributivo_oferta, pao1.id_oferta_modalidad, pao1.estado AS estado_pao,  dio1.estado AS estado_dio,  pa.id_periodo_academico,pa.codigo,
               ROW_NUMBER() OVER (PARTITION BY pao1.id_oferta_modalidad ORDER BY dio1.id_distributivo_oferta DESC) AS rn
        FROM aca.periodo_academico pa
                 INNER JOIN aca.periodo_academico_oferta pao1  ON pao1.id_periodo_academico = pa.id_periodo_academico
                 INNER JOIN aca.distributivo_oferta dio1 ON pao1.id_periodo_academico_oferta = dio1.id_periodo_academico_oferta
        WHERE dio1.estado IN ('A','V','D','P') AND pao1.estado = 'A'   and  (pa.id_periodo_academico = @id_periodo_academico or pa.id_periodo_academico_padre = @id_periodo_academico)
    ) as ud ON ddo.id_distributivo_oferta = ud.id_distributivo_oferta AND ud.rn = 1
             left join
         (
             select d.id_docente,p.nombres,p.apellidos from aca.docente d
                                                                inner join man.personas p on p.id = d.id_persona
             where d.estado='A' and p.estado='AC'
         ) as aux on ddo.id_docente = aux.id_docente
    where ddo.estado='A' and daa.estado='A' and aa.estado='A' and dio.estado in ('A','V','D','P') and pao.estado='A' and pl.estado='A'
      and  ma.estado='A' and co.estado='A' and asig.estado='A' and n.estado='A' and (m.id_oferta_modalidad = @id_oferta_modalidad or @id_oferta_modalidad is null)
      and  co.codigo in (select dd.codigoHijo from aca.fn_listar_componentes_aprendizajes_reglamento((select mg.id_reglamento from aca.matricula_general mg
                                                                                                      where mg.id_periodo_academico = @id_periodo_academico) ) as dd)
      and ofa.id_tipo_oferta = (select pa.id_tipo_oferta from aca.periodo_academico pa where pa.id_periodo_academico = @id_periodo_academico)
    group by aux.apellidos,aux.nombres, ddo.id_distributivo_docente,ddo.id_distributivo_oferta,aux.id_docente,
             ma.id_malla_asignatura, asig.descripcion, n.orden, n.descripcion_corta, daa.num_estudiantes,pl.descripcion_corta, pl.id_paralelo, pao.id_reglamento,
             co.codigo, daa.id_docente_asignatura_aprend, aa.id_asignatura_aprendizaje, pao.id_periodo_academico, m.id_oferta_modalidad, ofa.facultad, ofa.carrera
end

select * from aca.matricula_general
select * from aca.tipo_jornada_laboral

-- select * from aca.num_vez_matricula
select * from aca.numero_vez

select * from aca.modalidad_asignatura

select d.* from aca.fn_get_planificacion_paralelo (894,92) as d

select * from aca.planificacion_paralelo pp



select * from mig.estudiante_oferta_jerarquia

select * from aca.modalidad

select * from aca.fn_listar_docentes_asignaturas(78998,null,95)

select * from aca.tipo_documento

select * from aca.tipo_clasificacion_documento

select * from hdv.persona_certicado

select * from man.lugar where fecha_ing is null and usuario_ing is null

update man.lugar set fecha_ing=fecha_ingreso,fecha_mod=fecha_ingreso
--                    ,usuario_ing='2400254286',usuario_mod='2400254286'}
where fecha_ing is null and usuario_ing is null

select * from aca.institucion

select * from man.nacionalidad

select  * from man.personas
where id_pais_nacionalidad = 164 and id_nacionalidad<>5

select  distinct id_nacionalidad from man.personas
where estado='AC'

select * from aca.fn_listar_docentes_asignaturas(null,31,95)

--listar el ultimo distributivo:
begin
declare @id_periodo_academico int = 15, @id_oferta_modalidad int = null
    select distinct  ddo.id_distributivo_oferta,ddo.id_distributivo_docente,n.descripcion_corta as nivel,pl.descripcion_corta as paralelo,aux.id_docente,
                     ofa.facultad,ofa.carrera,ma.id_malla_asignatura,asig.descripcion,
                     concat(n.descripcion_corta ,'/', pl.descripcion_corta) as curso,
                     daa.num_estudiantes,case when aux.id_docente is null THEN 'DOCENTE AÚN POR DEFINIR' ELSE concat(aux.apellidos,' ',aux.nombres) END as docente,
                     isnull([aca].[fn_esc_get_numero_estudiantes_matriculados_by_asignatura_paralelo](ma.id_malla_asignatura,pl.id_paralelo,
                                                                                                      @id_periodo_academico,null),0) as nuMatriculados,
                     co.codigo as componente,daa.id_docente_asignatura_aprend,aa.id_asignatura_aprendizaje,pao.id_periodo_academico,m.id_oferta_modalidad,
                     pao.id_reglamento
    from aca.distributivo_oferta dio
    inner join aca.periodo_academico_oferta pao on pao.id_periodo_academico_oferta = dio.id_periodo_academico_oferta
    inner join aca.distributivo_docente ddo on ddo.id_distributivo_oferta = dio.id_distributivo_oferta
    inner join aca.docente_asignatura_aprend daa on daa.id_distributivo_docente = ddo.id_distributivo_docente
    inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = daa.id_asignatura_aprendizaje
    inner join aca.componente_aprendizaje co on  co.id_componente_aprendizaje = aa.id_componente_aprendizaje
    inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
    inner join aca.malla m on ma.id_malla = m.id_malla
    inner join aca.ofertas_facultad ofa on ofa.id_oferta_modalidad = m.id_oferta_modalidad
    inner join aca.asignatura asig on asig.id_asignatura = ma.id_asignatura
    inner join aca.nivel n on ma.id_nivel = n.id_nivel
    inner join aca.paralelo pl on daa.id_paralelo = pl.id_paralelo
    inner join (
    SELECT dio1.id_distributivo_oferta, pao1.id_oferta_modalidad, pao1.estado AS estado_pao,  dio1.estado AS estado_dio,  pa.id_periodo_academico,pa.codigo,
           ROW_NUMBER() OVER (PARTITION BY pao1.id_oferta_modalidad ORDER BY dio1.id_distributivo_oferta DESC) AS rn
                FROM aca.periodo_academico pa
                 INNER JOIN aca.periodo_academico_oferta pao1  ON pao1.id_periodo_academico = pa.id_periodo_academico
                 INNER JOIN aca.distributivo_oferta dio1 ON pao1.id_periodo_academico_oferta = dio1.id_periodo_academico_oferta
                WHERE dio1.estado IN ('A','V','D') AND pao1.estado = 'A'   and  (pa.id_periodo_academico = @id_periodo_academico or pa.id_periodo_academico_padre = @id_periodo_academico)
    ) as ud ON ddo.id_distributivo_oferta = ud.id_distributivo_oferta AND ud.rn = 1
    left join
        (
            select d.id_docente,p.nombres,p.apellidos from aca.docente d
            inner join man.personas p on p.id = d.id_persona
            where d.estado='A' and p.estado='AC'
        ) as aux on ddo.id_docente = aux.id_docente
    where ddo.estado='A' and daa.estado='A' and aa.estado='A' and dio.estado in ('A','V','D') and pao.estado='A' and pl.estado='A'
    and  ma.estado='A' and co.estado='A' and asig.estado='A' and n.estado='A' and (m.id_oferta_modalidad = @id_oferta_modalidad or @id_oferta_modalidad is null)
    and  co.codigo in (select dd.codigoHijo from aca.fn_listar_componentes_aprendizajes_reglamento((select mg.id_reglamento from aca.matricula_general mg
                                                                                                                        where mg.id_periodo_academico = @id_periodo_academico) ) as dd)
    and ofa.id_tipo_oferta = (select pa.id_tipo_oferta from aca.periodo_academico pa where pa.id_periodo_academico = @id_periodo_academico)
    group by aux.apellidos,aux.nombres, ddo.id_distributivo_docente,ddo.id_distributivo_oferta,aux.id_docente,
             ma.id_malla_asignatura, asig.descripcion, n.orden, n.descripcion_corta, daa.num_estudiantes,pl.descripcion_corta, pl.id_paralelo, pao.id_reglamento,
             co.codigo, daa.id_docente_asignatura_aprend, aa.id_asignatura_aprendizaje, pao.id_periodo_academico, m.id_oferta_modalidad, ofa.facultad, ofa.carrera
end

select * from egr.estudiante_requisito


select * from aca.distributivo_oferta

select * from aca.periodo_academico
select mg.* from aca.matricula_general mg where mg.id_periodo_academico in (95,126)

select d.codigoHijo from aca.fn_listar_componentes_aprendizajes_reglamento(2) as d
