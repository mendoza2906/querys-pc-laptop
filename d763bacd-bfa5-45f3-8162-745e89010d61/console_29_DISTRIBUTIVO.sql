use bd_sga_upse


select * from aca.fn_get_validacion_planificacion_paralelo(915,0)

select pp.* from aca.planificacion_paralelo pp
    inner join aca.malla_asignatura ma on ma.id_malla_asignatura=pp.id_malla_asignatura
    inner join aca.malla m on ma.id_malla = m.id_malla
where pp.id_periodo_academico = 95 and m.id_malla = 92 --and ma.id_nivel = 1


select * from aca.fn_get_validacion_planificacion_paralelo(894,0)

SELECT * FROM aca.docente_por_definir

select * from mig.historial_docente


begin
    declare @id_periodo_academico int = 138, @id_oferta_modalidad int = null
    select distinct  ddo.id_distributivo_oferta,ddo.id_distributivo_docente,n.descripcion_corta as nivel,pl.descripcion_corta as paralelo,aux.id_docente,
                     ofa.facultad,ofa.carrera,ma.id_malla_asignatura,asig.descripcion,
                     concat(n.descripcion_corta ,'/', pl.descripcion_corta) as curso,
                     daa.num_estudiantes,case when aux.id_docente is null THEN 'DOCENTE AÚN POR DEFINIR' ELSE aux.nombres END as docente,
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
             select d.id_docente,concat(p.apellidos,' ',p.nombres) as nombres from aca.docente d
                                                                inner join man.personas p on p.id = d.id_persona
             where d.estado='A' and p.estado='AC'
         ) as aux on ddo.id_docente = aux.id_docente
    where ddo.estado='A' and daa.estado='A' and aa.estado='A' and dio.estado in ('A','V','D') and pao.estado='A' and pl.estado='A'
      and  ma.estado='A' and co.estado='A' and asig.estado='A' and n.estado='A' and (m.id_oferta_modalidad = @id_oferta_modalidad or @id_oferta_modalidad is null)
      and  co.codigo in (select dd.codigoHijo from aca.fn_listar_componentes_aprendizajes_reglamento((select mg.id_reglamento from aca.matricula_general mg
                                                                                                      where mg.id_periodo_academico = @id_periodo_academico) ) as dd)
      and ofa.id_tipo_oferta = (select pa.id_tipo_oferta from aca.periodo_academico pa where pa.id_periodo_academico = @id_periodo_academico)
    group by aux.nombres, ddo.id_distributivo_docente,ddo.id_distributivo_oferta,aux.id_docente,
             ma.id_malla_asignatura, asig.descripcion, n.orden, n.descripcion_corta, daa.num_estudiantes,pl.descripcion_corta, pl.id_paralelo, pao.id_reglamento,
             co.codigo, daa.id_docente_asignatura_aprend, aa.id_asignatura_aprendizaje, pao.id_periodo_academico, m.id_oferta_modalidad, ofa.facultad, ofa.carrera
end

select id_periodo_academico,codigo,descripcion from aca.periodo_academico where id_tipo_oferta = 1 and codigo>'2021-1'

--actualizar docente en matricula
begin
    declare @id_periodo_academico int = 136, @id_oferta_modalidad int = null
--     select distinct  ddo.id_distributivo_oferta,ddo.id_distributivo_docente,n.descripcion_corta as nivel,pl.descripcion_corta as paralelo,aux.id_docente,
--                      ofa.facultad,ofa.carrera,ma.id_malla_asignatura,asig.descripcion,
--                      concat(n.descripcion_corta ,'/', pl.descripcion_corta) as curso,
--                      daa.num_estudiantes,case when aux.id_docente is null THEN 'DOCENTE AÚN POR DEFINIR' ELSE concat(aux.apellidos,' ',aux.nombres) END as docente,
--                      isnull([aca].[fn_esc_get_numero_estudiantes_matriculados_by_asignatura_paralelo](ma.id_malla_asignatura,pl.id_paralelo,
--                                                                                                       @id_periodo_academico,null),0) as nuMatriculados,
--                      co.codigo as componente,daa.id_docente_asignatura_aprend,aa.id_asignatura_aprendizaje,pao.id_periodo_academico,m.id_oferta_modalidad,
--                      pao.id_reglamento,ea.id_paralelo,em.id_estudiante_matricula,mg.id_matricula_general,concat(aux1.apellidos,' ',aux1.nombres) as docenteMatricula,ea.id_docente
    update ea set ea.id_docente = aux.id_docente
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
             inner join aca.estudiante_asignatura ea on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje and ea.id_paralelo = pl.id_paralelo
             inner join aca.estudiante_matricula em on ea.id_estudiante_matricula = em.id_estudiante_matricula
             inner join aca.matricula_general mg on em.id_matricula_general = mg.id_matricula_general and mg.id_periodo_academico = @id_periodo_academico
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
             left join
         (
             select d.id_docente,p.nombres,p.apellidos from aca.docente d
                                                                inner join man.personas p on p.id = d.id_persona
             where d.estado='A' and p.estado='AC'
         ) as aux1 on ea.id_docente = aux1.id_docente
    where ddo.estado='A' and daa.estado='A' and aa.estado='A' and dio.estado in ('A','V','D') and pao.estado='A' and pl.estado='A'
      and  ma.estado='A' and co.estado='A' and asig.estado='A' and n.estado='A' and (m.id_oferta_modalidad = @id_oferta_modalidad or @id_oferta_modalidad is null)
      and  co.codigo in (select dd.codigoHijo from aca.fn_listar_componentes_aprendizajes_reglamento((select mg.id_reglamento from aca.matricula_general mg
                                                                                                      where mg.id_periodo_academico = @id_periodo_academico) ) as dd)
      and ofa.id_tipo_oferta = (select pa.id_tipo_oferta from aca.periodo_academico pa where pa.id_periodo_academico = @id_periodo_academico)

      and aux.id_docente <>ea.id_docente
        and  ea.id_docente is not null
--     group by aux.apellidos,aux.nombres, ddo.id_distributivo_docente,ddo.id_distributivo_oferta,aux.id_docente,
--              ma.id_malla_asignatura, asig.descripcion, n.orden, n.descripcion_corta, daa.num_estudiantes,pl.descripcion_corta, pl.id_paralelo, pao.id_reglamento,
--              co.codigo, daa.id_docente_asignatura_aprend, aa.id_asignatura_aprendizaje, pao.id_periodo_academico, m.id_oferta_modalidad, ofa.facultad, ofa.carrera,
--              ea.id_paralelo, em.id_estudiante_matricula, mg.id_matricula_general,aux1.nombres,aux1.apellidos, ea.id_docente
end

select * from aca.ofertas_facultad where id_oferta = 82
-- actualizar ids asignatura aprendizaje a nueva malla entrenamiento deportivo
begin
    declare @id_periodo_academico int = 136, @id_oferta_modalidad int = 82
--         select daa.*
    select distinct  ddo.id_distributivo_oferta,ddo.id_distributivo_docente,n.descripcion_corta as nivel,pl.descripcion_corta as paralelo,aux.id_docente,
                     ofa.facultad,ofa.carrera,ma.id_malla_asignatura,asig.descripcion as asignatura,
                     concat(n.descripcion_corta ,'/', pl.descripcion_corta) as curso,
                     daa.num_estudiantes,case when aux.id_docente is null THEN 'DOCENTE AÚN POR DEFINIR' ELSE concat(aux.apellidos,' ',aux.nombres) END as docente,
                     isnull([aca].[fn_esc_get_numero_estudiantes_matriculados_by_asignatura_paralelo](ma.id_malla_asignatura,pl.id_paralelo,
                                                                                                      @id_periodo_academico,null),0) as nuMatriculados,
                     co.codigo as componente,daa.id_docente_asignatura_aprend,daa.id_asignatura_aprendizaje,
--                     aan.id_asignatura_aprendizaje,man.id_malla_asignatura,
                pao.id_periodo_academico,m.id_oferta_modalidad,
                     pao.id_reglamento
--         update daa set daa.id_asignatura_aprendizaje = aan.id_asignatura_aprendizaje
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
--              left join aca.asignatura an on an.descripcion = asig.descripcion
--              left join aca.malla_asignatura man on man.id_asignatura = an.id_asignatura
--              left join aca.asignatura_aprendizaje aan on aan.id_componente_aprendizaje = aa.id_componente_aprendizaje and aan.id_malla_asignatura = man.id_malla_asignatura
--              left join aca.malla mal2 on mal2.id_malla = man.id_malla and mal2.id_malla = 181
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
--     and ma.id_malla_asignatura in (2641,2643,2647 )
--     and aan.id_asignatura_aprendizaje is not null
--     group by aux.apellidos,aux.nombres, ddo.id_distributivo_docente,ddo.id_distributivo_oferta,aux.id_docente,
--              ma.id_malla_asignatura, asig.descripcion, n.orden, n.descripcion_corta, daa.num_estudiantes,pl.descripcion_corta, pl.id_paralelo, pao.id_reglamento,
--              co.codigo, daa.id_docente_asignatura_aprend, aa.id_asignatura_aprendizaje, pao.id_periodo_academico, m.id_oferta_modalidad, ofa.facultad, ofa.carrera, daa.id_asignatura_aprendizaje,
--              aan.id_asignatura_aprendizaje,man.id_malla_asignatura
end


select do.* from aca.distributivo_oferta do
inner join aca.periodo_academico_oferta pao on do.id_periodo_academico_oferta = pao.id_periodo_academico_oferta
where pao.id_oferta_modalidad = 82 and pao.id_periodo_academico = 136

select distinct a.descripcion,pp.* from aca.planificacion_paralelo pp
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = pp.id_malla_asignatura
inner join aca.malla m on ma.id_malla = m.id_malla
inner join aca.asignatura a on ma.id_asignatura = a.id_asignatura
inner join aca.planificacion_paralelo_detalle ppd on pp.id_planificacion_paralelo = ppd.id_planificacion_paralelo
where pp.id_periodo_academico = 136 and m.id_oferta_modalidad = 82 and m.id_malla = 77