USE bd_sga_upse

select * from aca.periodo_academico where id_tipo_oferta = 2
select * from aca.planificacion_paralelo where id_planificacion_paralelo = 13515
select * from aca.planificacion_paralelo_detalle where id_planificacion_paralelo = 13515
select * from [dbo].[aux_aprobados_update]
-- delete from [dbo].[aux_aprobados_update]
select * from aca.ofertas_facultad where id_tipo_oferta = 2
--grado
--grado
begin
    declare @id_periodo_academico int = 96,@id_departamento int = null,@id_oferta_modalidad int = 31
insert into [dbo].[aux_aprobados_update]
select ma.id_malla_asignatura,a.descripcion,
       case when ma.UICII=0
    then
        case when   round(cast (isnull(round(sum(cast(ec.calificacion as decimal(10,2))),0)/2,2) as decimal(10,2)),0) >=70  or  round(cast (isnull(round(sum ( cast (ec.calificacion as decimal(10,2))),0)/2,2) as decimal(10,2)),0)<40 then
         round(cast (isnull(round(sum(cast (ec.calificacion as decimal(10,2))),0)/2,2) as decimal(10,2)),2)
        else
           case when  isnull( (select ec1.calificacion from aca.acta_calificacion ac1
                    inner join aca.estudiante_calificacion ec1 on ec1.id_acta_calificacion = ac1.id_acta_calificacion
                    inner join aca.componente_aprendizaje ca1 on ca1.id_componente_aprendizaje = ec1.id_componente_aprendizaje
                    inner join aca.calificacion_general cg1 on cg1.id_calificacion_general = ac1.id_calificacion_general
                    inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = cg1.id_periodo_academico
                    inner join aca.ciclo c1 on c1.id_ciclo = ac1.id_ciclo
                    where (ca1.codigo = 'SUMATIVA' and c1.codigo in ('RECU'))and ac1.estado in ('A', 'C') and ec1.estado in ('A', 'C')
                    and pa1.id_periodo_academico = cg.id_periodo_academico and ec1.id_estudiante_oferta in (em.id_estudiante_oferta)
                    and ac1.id_malla_asignatura = ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo),0)=0
               then
                      round(cast (isnull(round(sum ( cast (ec.calificacion as decimal(10,2))),0)/2,2) as decimal(10,2)),2)
               else
                        round(cast (isnull(round(cast (isnull(round(sum ( cast (ec.calificacion as decimal(10,2))),0)/2,2) as decimal(10,2)),0) +
                       isnull( (select ec1.calificacion from aca.acta_calificacion ac1
                        inner join aca.estudiante_calificacion ec1 on ec1.id_acta_calificacion = ac1.id_acta_calificacion
                        inner join aca.componente_aprendizaje ca1 on ca1.id_componente_aprendizaje = ec1.id_componente_aprendizaje
                        inner join aca.calificacion_general cg1 on cg1.id_calificacion_general = ac1.id_calificacion_general
                        inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = cg1.id_periodo_academico
                        inner join aca.ciclo c1 on c1.id_ciclo = ac1.id_ciclo
                         where (ca1.codigo = 'SUMATIVA' and c1.codigo in ('RECU')) and ac1.estado in ('A', 'C')and ec1.estado in ('A', 'C')
                           and pa1.id_periodo_academico = cg.id_periodo_academico and ec1.id_estudiante_oferta in (em.id_estudiante_oferta)
                           and ac1.id_malla_asignatura = ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo),0),0)/2 as decimal(10, 2)),2)
                end
             end
    else
           case when max(ec.calificacion) > isnull( (select ec1.calificacion
                         from aca.acta_calificacion ac1
                          inner join aca.estudiante_calificacion ec1 on ec1.id_acta_calificacion = ac1.id_acta_calificacion
                          inner join aca.componente_aprendizaje ca1 on ca1.id_componente_aprendizaje = ec1.id_componente_aprendizaje
                          inner join aca.calificacion_general cg1 on cg1.id_calificacion_general = ac1.id_calificacion_general
                          inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = cg1.id_periodo_academico
                          inner join aca.ciclo c1 on c1.id_ciclo = ac1.id_ciclo
                         where (ca1.codigo = 'SUMATIVA' and c1.codigo in ('RECU')) and ac1.estado in ('A', 'C') and ec1.estado in ('A', 'C') and pa1.id_periodo_academico = cg.id_periodo_academico
                           and ec1.id_estudiante_oferta in (em.id_estudiante_oferta) and ac1.id_malla_asignatura = ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo),0)
then max(ec.calificacion) else
               isnull( (select ec1.calificacion
                         from aca.acta_calificacion ac1
                          inner join aca.estudiante_calificacion ec1 on ec1.id_acta_calificacion = ac1.id_acta_calificacion
                          inner join aca.componente_aprendizaje ca1 on ca1.id_componente_aprendizaje = ec1.id_componente_aprendizaje
                          inner join aca.calificacion_general cg1 on cg1.id_calificacion_general = ac1.id_calificacion_general
                          inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = cg1.id_periodo_academico
                          inner join aca.ciclo c1 on c1.id_ciclo = ac1.id_ciclo
                         where (ca1.codigo = 'SUMATIVA' and c1.codigo in ('RECU')) and ac1.estado in ('A', 'C') and ec1.estado in ('A', 'C') and pa1.id_periodo_academico = cg.id_periodo_academico
                           and ec1.id_estudiante_oferta in (em.id_estudiante_oferta) and ac1.id_malla_asignatura = ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo),0)
               end
           end as promedio,
    round(case when ma.UICII=0 then
        case when round(cast (isnull(round(sum ( cast (ec.calificacion as decimal(10,2))),0)/2,2) as decimal(10,2)),0)>=70  or
                  round(cast (isnull(round(sum ( cast (ec.calificacion as decimal(10,2))),0)/2,2) as decimal(10,2)),0)<40 then
            round(cast (isnull(round(sum ( cast (ec.calificacion as decimal(10,2))),0)/2,2) as decimal(10,2)),0)
            else
               case when  isnull( (select ec1.calificacion
                        from aca.acta_calificacion ac1
                        inner join aca.estudiante_calificacion ec1  on ec1.id_acta_calificacion = ac1.id_acta_calificacion
                        inner join aca.componente_aprendizaje ca1 on ca1.id_componente_aprendizaje = ec1.id_componente_aprendizaje
                        inner join aca.calificacion_general cg1 on cg1.id_calificacion_general = ac1.id_calificacion_general
                        inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = cg1.id_periodo_academico
                        inner join aca.ciclo c1 on c1.id_ciclo = ac1.id_ciclo
                         where (ca1.codigo = 'SUMATIVA' and c1.codigo in ('RECU'))
                           and ac1.estado in ('A', 'C')   and ec1.estado in ('A', 'C')
                           and pa1.id_periodo_academico = cg.id_periodo_academico  and ec1.id_estudiante_oferta in (em.id_estudiante_oferta)
                           and ac1.id_malla_asignatura = ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo),0)=0
               then
                      round(cast (isnull(round(sum ( cast (ec.calificacion as decimal(10,2))),0)/2,2) as decimal(10,2)),2)
               else
                    round( cast (isnull(round(cast (isnull(round(sum ( cast (ec.calificacion as decimal(10,2))),0)/2,2) as decimal(10,2)),0) + isnull( (select ec1.calificacion
                         from aca.acta_calificacion ac1
                          inner join aca.estudiante_calificacion ec1 on ec1.id_acta_calificacion = ac1.id_acta_calificacion
                          inner join aca.componente_aprendizaje ca1 on ca1.id_componente_aprendizaje = ec1.id_componente_aprendizaje
                          inner join aca.calificacion_general cg1 on cg1.id_calificacion_general = ac1.id_calificacion_general
                          inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = cg1.id_periodo_academico
                          inner join aca.ciclo c1 on c1.id_ciclo = ac1.id_ciclo
                         where (ca1.codigo = 'SUMATIVA' and c1.codigo in ('RECU')) and ac1.estado in ('A', 'C') and ec1.estado in ('A', 'C') and pa1.id_periodo_academico = cg.id_periodo_academico
                           and ec1.id_estudiante_oferta in (em.id_estudiante_oferta) and ac1.id_malla_asignatura = ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo),0),0)/2 as decimal(10, 2)),0)
                   end
        end
    else    case when max(ec.calificacion) > isnull( (select ec1.calificacion
                         from aca.acta_calificacion ac1
                          inner join aca.estudiante_calificacion ec1 on ec1.id_acta_calificacion = ac1.id_acta_calificacion
                          inner join aca.componente_aprendizaje ca1 on ca1.id_componente_aprendizaje = ec1.id_componente_aprendizaje
                          inner join aca.calificacion_general cg1 on cg1.id_calificacion_general = ac1.id_calificacion_general
                          inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = cg1.id_periodo_academico
                          inner join aca.ciclo c1 on c1.id_ciclo = ac1.id_ciclo
                         where (ca1.codigo = 'SUMATIVA' and c1.codigo in ('RECU')) and ac1.estado in ('A', 'C') and ec1.estado in ('A', 'C') and pa1.id_periodo_academico = cg.id_periodo_academico
                           and ec1.id_estudiante_oferta in (em.id_estudiante_oferta) and ac1.id_malla_asignatura = ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo),0)
then max(ec.calificacion) else
               isnull( (select ec1.calificacion
                         from aca.acta_calificacion ac1
                          inner join aca.estudiante_calificacion ec1 on ec1.id_acta_calificacion = ac1.id_acta_calificacion
                          inner join aca.componente_aprendizaje ca1 on ca1.id_componente_aprendizaje = ec1.id_componente_aprendizaje
                          inner join aca.calificacion_general cg1 on cg1.id_calificacion_general = ac1.id_calificacion_general
                          inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = cg1.id_periodo_academico
                          inner join aca.ciclo c1 on c1.id_ciclo = ac1.id_ciclo
                         where (ca1.codigo = 'SUMATIVA' and c1.codigo in ('RECU')) and ac1.estado in ('A', 'C') and ec1.estado in ('A', 'C') and pa1.id_periodo_academico = cg.id_periodo_academico
                           and ec1.id_estudiante_oferta in (em.id_estudiante_oferta) and ac1.id_malla_asignatura = ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo),0)
               end
        end,0)

        as promedio_redondeado,
    case when round(cast (isnull(round(sum ( cast (ec.calificacion as decimal(10,2))),0)/2,2) as decimal(10,2)),0)>=70 and ma.UICII=0 then 1
    when     ma.UICII=0 and round( cast (isnull(round(cast (isnull(round(sum ( cast (ec.calificacion as decimal(10,2))),0)/2,2) as decimal(10,2)),0) +
                       isnull((select ec1.calificacion from aca.acta_calificacion ac1
                        inner join aca.estudiante_calificacion ec1 on ec1.id_acta_calificacion = ac1.id_acta_calificacion
                        inner join aca.componente_aprendizaje ca1 on ca1.id_componente_aprendizaje = ec1.id_componente_aprendizaje
                        inner join aca.calificacion_general cg1 on cg1.id_calificacion_general = ac1.id_calificacion_general
                        inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = cg1.id_periodo_academico
                        inner join aca.ciclo c1 on c1.id_ciclo = ac1.id_ciclo
                        where (ca1.codigo = 'SUMATIVA' and c1.codigo in ('RECU'))  and ac1.estado in ('A', 'C') and
                              ec1.estado in ('A', 'C') and pa1.id_periodo_academico = cg.id_periodo_academico
                           and ec1.id_estudiante_oferta in (em.id_estudiante_oferta) and ac1.id_malla_asignatura = ma.id_malla_asignatura
                          and ac1.id_paralelo = ea.id_paralelo),0),0)/2 as decimal(10, 2)),0)>=70  then 1
    when ma.UICII=1 and  max(ec.calificacion) >=70 then 1
     when ma.UICII=1 and
                       isnull( (select ec1.calificacion from aca.acta_calificacion ac1
                      inner join aca.estudiante_calificacion ec1  on ec1.id_acta_calificacion = ac1.id_acta_calificacion
                      inner join aca.componente_aprendizaje ca1 on ca1.id_componente_aprendizaje = ec1.id_componente_aprendizaje
                      inner join aca.calificacion_general cg1 on cg1.id_calificacion_general = ac1.id_calificacion_general
                      inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = cg1.id_periodo_academico
                      inner join aca.ciclo c1 on c1.id_ciclo = ac1.id_ciclo
                    where (ca1.codigo = 'SUMATIVA' and c1.codigo in ('RECU'))
                    and ac1.estado in ('A', 'C') and ec1.estado in ('A', 'C')
                    and pa1.id_periodo_academico = cg.id_periodo_academico and ec1.id_estudiante_oferta in (em.id_estudiante_oferta)
                    and ac1.id_malla_asignatura = ma.id_malla_asignatura and ac1.id_paralelo = ea.id_paralelo),0)>=70 then 1
        else
        0 end as aprobado,
		ea.id_estudiante_asignatura,p.identificacion
		from aca.estudiante_oferta eo
		inner join man.personas p on p.id = eo.id_persona
		inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
		inner join aca.matricula_general mg on em.id_matricula_general=mg.id_matricula_general
		inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula =  em.id_estudiante_matricula
		inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
		inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
		inner join aca.malla m on m.id_malla = ma.id_malla
		inner join aca.oferta_modalidad omo on omo.id_oferta_modalidad=m.id_oferta_modalidad
		inner join aca.departamento_oferta do on do.id_oferta=omo.id_oferta
		inner join aca.nivel n on n.id_nivel = ma.id_nivel
		inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
		inner join aca.calificacion_general cg on cg.id_periodo_academico=mg.id_periodo_academico
		inner join aca.acta_calificacion ac on cg.id_calificacion_general=ac.id_calificacion_general and ac.id_malla_asignatura=ma.id_malla_asignatura and ac.id_paralelo=ea.id_paralelo
		inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion and ec.id_estudiante_oferta=em.id_estudiante_oferta
        inner join aca.componente_aprendizaje ca on ca.id_componente_aprendizaje = ec.id_componente_aprendizaje
        inner join aca.ciclo c on c.id_ciclo=ac.id_ciclo
		where mg.id_periodo_academico in (@id_periodo_academico)
        and     ca.codigo ='SUMA'  and c.codigo in ('CIC1','CIC2') and ac.estado in ('A','C') and  ec.estado in ('A','C')
		and (do.id_departamento=@id_departamento or @id_departamento is null)
		and (omo.id_oferta_modalidad=@id_oferta_modalidad or @id_oferta_modalidad is null)
		and ea.estado ='A' and em.estado ='A' and eo.estado ='A' and mg.estado='A' and m.estado in ('A','P')
		group by a.descripcion,ma.UICII,cg.id_periodo_academico, ma.codigo_malla,ea.id_estudiante_asignatura, ma.id_malla_asignatura, a.descripcion, p.identificacion, em.id_estudiante_oferta,ea.id_paralelo
end
		--select * from aca.estudiante_asignatura where estado='A'

--begin tran
-- UPDATE
--     bd_sga_upse.aca.estudiante_asignatura
-- SET
--     bd_sga_upse.aca.estudiante_asignatura.aprobado =  nm.aprobado,bd_sga_upse.aca.estudiante_asignatura.promedio= nm.promedio
-- FROM bd_sga_upse.aca.estudiante_asignatura eo3
--          inner join [dbo].[aux_aprobados_update] nm on nm.id_estudiante_asignatura= eo3.id_estudiante_asignatura
--
update ea set ea.promedio = rec.promedio,ea.aprobado= rec.aprobado
from dbo.aux_aprobados_update rec
inner join aca.estudiante_asignatura ea on ea.id_estudiante_asignatura = rec.id_estudiante_asignatura
where rec.promedio<>ea.promedio

--
select rec.*,ea.aprobado as aprobado_actual,ea.promedio as promedio_actual,ea.codigo_estado_matricula
from dbo.aux_aprobados_update rec
inner join aca.estudiante_asignatura ea on ea.id_estudiante_asignatura = rec.id_estudiante_asignatura
-- where identificacion =  '0942857921'
where rec.promedio<>ea.promedio


--     1755333885
-- 1729908796


select aau.* from dbo.aux_asistencia_update aau
inner join aca.estudiante_asignatura ea on ea.id_estudiante_asignatura = aau.id_estudiante_asignatura
where aau.porcentaje<>ea.asistencia

-- update ea set ea.asistencia = aau.porcentaje
-- from dbo.aux_asistencia_update aau
-- inner join aca.estudiante_asignatura ea on ea.id_estudiante_asignatura = aau.id_estudiante_asignatura
-- where aau.porcentaje<>ea.asistencia
select distinct ea.id_estudiante_matricula from aca.estudiante_asignatura ea
where ea.aprobado = 1 and ea.asistencia<85 and ea.estado='A'

select * from aca.acta_apertura where id_acta_calificacion = 39215

select * from aca.acta_apertura_componente where id_acta_apertura =3213

--set asistencia
begin
    declare @idPeriodoAcademico int = 140,@idDepartamento int = null,@idOfertaModalidad int = null
    ;WITH AsistenciaDetallada AS
        (SELECT c.id_clase,eo.id_estudiante_oferta, MAX(ISNULL(c.duracion, 0)) AS duracion_clase,SUM(ISNULL(ca.duracion, 0)) AS duracion_asistida,pa.codigo,
                                        dep.nombre  AS departamento,o.descripcion AS oferta,ea.id_estudiante_asignatura, a.descripcion AS asignatura,
                                        CONCAT(n.descripcion_corta, '/', p.descripcion_corta) AS paralelo,CONCAT(per.apellidos, ' ', per.nombres) AS estudiante,per.identificacion AS identificacion
             FROM aca.clase c
              INNER JOIN aca.clases_asistencia ca ON ca.id_clase = c.id_clase
              INNER JOIN aca.estudiante_oferta eo ON eo.id_estudiante_oferta = ca.id_estudiante_oferta
              INNER JOIN man.personas per ON per.id = eo.id_persona
              INNER JOIN aca.matricula_general mg on mg.id_periodo_academico=c.id_periodo_academico
              INNER JOIN aca.estudiante_matricula em on em.id_matricula_general=mg.id_matricula_general and em.id_estudiante_oferta=eo.id_estudiante_oferta and em.estado='A'
              INNER JOIN aca.estudiante_asignatura  ea on em.id_estudiante_matricula=ea.id_estudiante_matricula and ea.estado='A' and c.id_paralelo=ea.id_paralelo
              INNER JOIN aca.paralelo p ON p.id_paralelo = c.id_paralelo
              INNER JOIN aca.malla_asignatura ma ON ma.id_malla_asignatura = c.id_malla_asignatura
              INNER JOIN aca.asignatura_aprendizaje aa on ma.id_malla_asignatura=aa.id_malla_asignatura and ea.id_asignatura_aprendizaje=aa.id_asignatura_aprendizaje and aa.estado='A'
              INNER JOIN aca.asignatura a  ON a.id_asignatura = ma.id_asignatura
              INNER JOIN aca.nivel n ON n.id_nivel = ma.id_nivel
              INNER JOIN aca.malla m ON m.id_malla = ma.id_malla
              INNER JOIN aca.oferta_modalidad om ON om.id_oferta_modalidad = m.id_oferta_modalidad
              INNER JOIN aca.oferta o ON o.id_oferta = om.id_oferta
              INNER JOIN aca.departamento_oferta dof ON dof.id_oferta = o.id_oferta
              INNER JOIN man.departamentos dep ON dep.id = dof.id_departamento
              INNER JOIN aca.periodo_academico pa ON pa.id_periodo_academico = c.id_periodo_academico
    WHERE c.estado = 'A' AND ca.estado = 'A' AND c.id_periodo_academico = @idPeriodoAcademico
    AND (@idDepartamento IS NULL OR dep.id = @idDepartamento)
    AND (@idOfertaModalidad IS NULL OR om.id_oferta_modalidad = @idOfertaModalidad)
    GROUP BY c.id_clase,eo.id_estudiante_oferta,pa.codigo, dep.nombre, o.descripcion, a.descripcion,n.descripcion_corta, p.descripcion_corta,per.apellidos, per.nombres, per.identificacion, ea.id_estudiante_asignatura),
         AgregacionFinal AS (SELECT codigo, departamento,id_estudiante_oferta,id_estudiante_asignatura, oferta, asignatura, paralelo,
                                    (select concat(p.apellidos,' ', p.nombres) from aca.clase c
                                        inner join aca.docente d on d.id_docente=c.id_docente
                                        inner join man.personas p on p.id=d.id_persona
                                     where c.id_clase= max(a.id_clase) ) as  docente, estudiante, identificacion,
                                    COUNT(a.id_clase)        AS numClases, SUM(duracion_clase)    AS horasClases, SUM(duracion_asistida) AS horasAsistidas
                             FROM AsistenciaDetallada a
                             GROUP BY codigo, departamento, oferta, asignatura, paralelo,estudiante,identificacion, id_estudiante_oferta, id_estudiante_asignatura)
    SELECT codigo, departamento, oferta,id_estudiante_asignatura, asignatura, paralelo, docente,id_estudiante_oferta,  identificacion, estudiante, numClases,  horasClases,  horasAsistidas,
           CAST(ROUND(100.0 * horasAsistidas / NULLIF(horasClases, 0), 2) AS DECIMAL(5, 2)) AS porcentaje_raw,
           CAST(
                   CASE
                       WHEN horasClases = 0 THEN 0
                       WHEN 100.0 * horasAsistidas / horasClases < 0 THEN 0
                       WHEN 100.0 * horasAsistidas / horasClases > 100 THEN 100
                       ELSE ROUND(100.0 * horasAsistidas / horasClases, 2)
                       END
               AS DECIMAL(5, 2))                                                            AS porcentaje,
           100.0 - CAST(
                   CASE
                       WHEN horasClases = 0 THEN 0
                       WHEN 100.0 * horasAsistidas / horasClases < 0 THEN 0
                       WHEN 100.0 * horasAsistidas / horasClases > 100 THEN 100
                       ELSE ROUND(100.0 * horasAsistidas / horasClases, 2)
                       END
               AS DECIMAL(5, 2))                                                            AS falta
    FROM AgregacionFinal;
end

--ROLLBACK TRANSACTION
----commit transaction

--DELETE from  dbo.aux_aprobados_update
select * from [dbo].[aux_aprobados_update]
select * from aca.periodo_academico where id_tipo_oferta = 4
--nivelacion
begin
        declare @id_periodo_academico int = 127,@id_departamento int = null,@id_oferta_modalidad int = null
    insert into [dbo].[aux_aprobados_update]
    select ma.id_malla_asignatura,a.descripcion, case when ma.UICII=0 then   cast (isnull(sum ( cast (aux.suma as decimal(10,2))),0)/2 as decimal(10,2)) else max(aux.suma)end as promedio,
    round(case when ma.UICII=0 then   cast (isnull(sum ( cast (aux.suma as decimal(10,2))),0)/2 as decimal(10,2)) else max(aux.suma)end,0) as promedio_redondeado,
    case when (round(case when ma.UICII=0 then   cast (isnull(sum ( cast (aux.suma as decimal(10,2))),0)/2 as decimal(10,2)) else max(aux.suma)end,0))<70 then 0
    when (round(case when ma.UICII=0 then   cast (isnull(sum ( cast (aux.suma as decimal(10,2))),0)/2 as decimal(10,2)) else max(aux.suma)end,0)) is null then 0
    else
    1 end as aprobado,
            --aux.periodo_academico,aux.id_periodo_academico,ma.codigo_malla,
            ea.id_estudiante_asignatura,p.identificacion
            from aca.estudiante_oferta eo
            inner join man.personas p on p.id = eo.id_persona
            inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
            inner join aca.matricula_general mg on em.id_matricula_general=mg.id_matricula_general
            inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula =  em.id_estudiante_matricula
            inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
            inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
            inner join aca.malla m on m.id_malla = ma.id_malla
            inner join aca.oferta_modalidad omo on omo.id_oferta_modalidad=m.id_oferta_modalidad
            inner join aca.departamento_oferta do on do.id_oferta=omo.id_oferta
            inner join aca.nivel n on n.id_nivel = ma.id_nivel
            inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
            left join ( select   ac.id_malla_asignatura,ec.id_estudiante_oferta,pa.codigo as periodo_academico,
            pa.id_periodo_academico,c.id_ciclo,ec.id_estudiante_calificacion
             ,isnull(ec.calificacion,0) as suma from aca.acta_calificacion ac
            inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
            inner join aca.componente_aprendizaje ca on ca.id_componente_aprendizaje = ec.id_componente_aprendizaje
            inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
            inner join aca.periodo_academico pa on pa.id_periodo_academico = cg.id_periodo_academico
            inner join aca.ciclo c on c.id_ciclo=ac.id_ciclo
            where ((ca.codigo ='SUMA'  and c.codigo in ('CIC1','CIC2')) or (ca.codigo ='SUMATIVA'  and c.codigo in ('RECU') ) )
            and ac.estado in ('A','C') and  ec.estado in ('A','C')
            group by ac.id_malla_asignatura,ec.id_estudiante_oferta,pa.codigo,pa.id_periodo_academico,
            c.id_ciclo,ec.calificacion,ec.id_estudiante_calificacion
            --order by  ac.id_malla_asignatura,ec.id_estudiante_oferta,pa.codigo,pa.id_periodo_academico,ec.calificacion desc

            ) as aux on aux.id_estudiante_oferta = em.id_estudiante_oferta
             and aux.id_malla_asignatura = ma.id_malla_asignatura
             and aux.id_periodo_academico=mg.id_periodo_academico
             and aux.id_estudiante_calificacion in(select top(2)  ec1.id_estudiante_calificacion
             from aca.acta_calificacion ac1
            inner join aca.estudiante_calificacion ec1 on ec1.id_acta_calificacion = ac1.id_acta_calificacion
            inner join aca.componente_aprendizaje ca1 on ca1.id_componente_aprendizaje = ec1.id_componente_aprendizaje
            inner join aca.calificacion_general cg1 on cg1.id_calificacion_general = ac1.id_calificacion_general
            inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = cg1.id_periodo_academico
            inner join aca.ciclo c1 on c1.id_ciclo=ac1.id_ciclo
            where ((ca1.codigo ='SUMA'  and c1.codigo in ('CIC1','CIC2')) or (ca1.codigo ='SUMATIVA'  and c1.codigo in ('RECU') ) )
            and ac1.estado in ('A','C') and  ec1.estado in ('A','C')
            and pa1.id_periodo_academico=aux.id_periodo_academico
            and ec1.id_estudiante_oferta in ( aux.id_estudiante_oferta)
            and ac1.id_malla_asignatura=ma.id_malla_asignatura
            and ac1.id_paralelo=ea.id_paralelo
            group by ac1.id_malla_asignatura,ec1.id_estudiante_oferta,pa1.codigo,pa1.id_periodo_academico
            ,c1.id_ciclo,ec1.calificacion,ec1.id_estudiante_calificacion
            order by  ac1.id_malla_asignatura,ec1.id_estudiante_oferta,pa1.codigo,pa1.id_periodo_academico,ec1.calificacion desc
            )
            where mg.id_periodo_academico in (@id_periodo_academico)
              		and (do.id_departamento=@id_departamento or @id_departamento is null)
		    and (omo.id_oferta_modalidad=@id_oferta_modalidad or @id_oferta_modalidad is null)
            and ea.estado ='A' and em.estado ='A' and eo.estado ='A' and mg.estado='A' and m.estado in ('A','P')
            group by a.descripcion,ma.UICII,aux.id_periodo_academico, aux.periodo_academico,ma.codigo_malla,ea.id_estudiante_asignatura,
                     ma.id_malla_asignatura, a.descripcion, p.identificacion
end

--
update ea set ea.promedio = rec.promedio,ea.aprobado= rec.aprobado
from dbo.aux_aprobados_update rec
         inner join aca.estudiante_asignatura ea on ea.id_estudiante_asignatura = rec.id_estudiante_asignatura
where rec.promedio<>ea.promedio


select rec.*,ea.aprobado as aprobado_actual,ea.promedio as promedio_actual,ea.codigo_estado_matricula
from dbo.aux_aprobados_update rec
         inner join aca.estudiante_asignatura ea on ea.id_estudiante_asignatura = rec.id_estudiante_asignatura
where rec.promedio<>ea.promedio

--ROLLBACK TRANSACTION
----commit transaction

--DELETE from  dbo.aux_aprobados_update
select * from [dbo].[aux_aprobados_update]
select * from aca.periodo_academico where id_tipo_oferta = 4
---centro de idiomas

begin
    declare @id_periodo_academico int = 146,@id_departamento int = null,@id_oferta_modalidad int = null
    insert into [dbo].[aux_aprobados_update]
select ma.id_malla_asignatura,a.descripcion, case when
                                                      ma.UICII=0 and  (tof.codigo='POSGRADO' or tof.codigo='CENTROIDIOMAS' ) then    max(aux.suma) else isnull(sum ( cast (aux.suma as decimal(10,2))),0)   end as promedio,
       round(case when ma.UICII=0  and  (tof.codigo='POSGRADO' or tof.codigo='CENTROIDIOMAS' ) then   max(aux.suma) else isnull(sum ( cast (aux.suma as decimal(10,2))),0)
                 end,0) as promedio,
       case when round(case when ma.UICII=0   and  (tof.codigo='POSGRADO' or tof.codigo='CENTROIDIOMAS' ) then    max(aux.suma) else  isnull(sum ( cast (aux.suma as decimal(10,2))),0) end,0)<70 then 0 else 1 end,
       --aux.periodo_academico,aux.id_periodo_academico,ma.codigo_malla,
       ea.id_estudiante_asignatura,p.identificacion
        from aca.estudiante_oferta eo
        inner join man.personas p on eo.id_persona = p.id
        inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
        inner join aca.matricula_general mg on em.id_matricula_general=mg.id_matricula_general
        inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula =  em.id_estudiante_matricula
        inner join aca.asignatura_aprendizaje aa on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
        inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
        inner join aca.malla m on m.id_malla = ma.id_malla
        inner join aca.oferta_modalidad omo on omo.id_oferta_modalidad=m.id_oferta_modalidad
        inner join aca.departamento_oferta do on do.id_oferta=omo.id_oferta
        inner join aca.periodo_academico pa on mg.id_periodo_academico=pa.id_periodo_academico
        inner join aca.tipo_oferta tof on pa.id_tipo_oferta=tof.id_tipo_oferta
        inner join aca.nivel n on n.id_nivel = ma.id_nivel
        inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
         left join ( select   ac.id_malla_asignatura,ec.id_estudiante_oferta,pa.codigo as periodo_academico,
                              pa.id_periodo_academico,c.id_ciclo,ec.id_estudiante_calificacion
                             ,isnull(ec.calificacion,0) as suma from aca.acta_calificacion ac
                     inner join aca.estudiante_calificacion ec on ec.id_acta_calificacion = ac.id_acta_calificacion
                     inner join aca.componente_aprendizaje ca on ca.id_componente_aprendizaje = ec.id_componente_aprendizaje
                     inner join aca.calificacion_general cg on cg.id_calificacion_general = ac.id_calificacion_general
                     inner join aca.periodo_academico pa on pa.id_periodo_academico = cg.id_periodo_academico
                     inner join aca.ciclo c on c.id_ciclo=ac.id_ciclo
                     where ((ca.codigo ='SUMA'  and c.codigo in ('CIC1','CIC2')) or (ca.codigo ='SUMATIVA'  and c.codigo in ('RECU') ) )
                       and ac.estado in ('A','C') and  ec.estado in ('A','C')
                     group by ac.id_malla_asignatura,ec.id_estudiante_oferta,pa.codigo,pa.id_periodo_academico,
                              c.id_ciclo,ec.calificacion,ec.id_estudiante_calificacion
) as aux on aux.id_estudiante_oferta = em.id_estudiante_oferta
    and aux.id_malla_asignatura = ma.id_malla_asignatura and aux.id_periodo_academico=mg.id_periodo_academico
    and aux.id_estudiante_calificacion in(select top(2)  ec1.id_estudiante_calificacion
                                          from aca.acta_calificacion ac1
                                                   inner join aca.estudiante_calificacion ec1 on ec1.id_acta_calificacion = ac1.id_acta_calificacion
                                                   inner join aca.componente_aprendizaje ca1 on ca1.id_componente_aprendizaje = ec1.id_componente_aprendizaje
                                                   inner join aca.calificacion_general cg1 on cg1.id_calificacion_general = ac1.id_calificacion_general
                                                   inner join aca.periodo_academico pa1 on pa1.id_periodo_academico = cg1.id_periodo_academico
                                                   inner join aca.ciclo c1 on c1.id_ciclo=ac1.id_ciclo
                                          where ((ca1.codigo ='SUMA'  and c1.codigo in ('CIC1','CIC2')) or (ca1.codigo ='SUMATIVA'  and c1.codigo in ('RECU') ) )
                                            and ac1.estado in ('A','C') and  ec1.estado in ('A','C')
                                            and pa1.id_periodo_academico=aux.id_periodo_academico
                                            and ec1.id_estudiante_oferta in ( aux.id_estudiante_oferta)
                                            and ac1.id_malla_asignatura=ma.id_malla_asignatura
                                            and ac1.id_paralelo=ea.id_paralelo
                                          group by ac1.id_malla_asignatura,ec1.id_estudiante_oferta,pa1.codigo,pa1.id_periodo_academico
                                                 ,c1.id_ciclo,ec1.calificacion,ec1.id_estudiante_calificacion
                                          order by  ac1.id_malla_asignatura,ec1.id_estudiante_oferta,pa1.codigo,pa1.id_periodo_academico,ec1.calificacion desc
    )
where mg.id_periodo_academico in (@id_periodo_academico)
  and (do.id_departamento=@id_departamento or @id_departamento is null)
  and (omo.id_oferta_modalidad=@id_oferta_modalidad or @id_oferta_modalidad is null)
  and ea.estado ='A' and em.estado ='A' and eo.estado ='A'

--eo.id_estudiante_oferta=3378
group by a.descripcion,ma.UICII,aux.id_periodo_academico, aux.periodo_academico,ma.codigo_malla,ea.id_estudiante_asignatura,
         TOF.CODIGO, ea.id_estudiante_asignatura, p.identificacion, ma.id_malla_asignatura, p.identificacion, ma.id_malla_asignatura, a.descripcion, ma.id_malla_asignatura, a.descripcion

end