use bd_sga_upse;

---------
select * from niv.inscripcion_nivelacion;

select * from niv.inscripcion_admision;
----------

select * from niv.calificaciones_nivelacion

select * from niv.nivelacion_cupos

select * from niv.cupos_disponibles

select * from niv.asignacion_cupo_new where estado='A'

select * from niv.cupos_postulacion

select * from niv.oferta_postulacion where estado='A'
------------------------
select * from niv.inscripcion_postulacion
select * from pro.proceso_etapa_ejecucion
----------------------------

---se va a eliminar se suple por pro.tipo_proceso_estado
select * from niv.estado_postulacion


select p.descripcion,pe.descripcion,e.descripcion,pe.orden from pro.proceso p
inner join pro.proceso_etapa pe on p.id_proceso = pe.id_proceso
inner join pro.etapa e on pe.id_etapa = e.id_etapa
inner join pro.proceso_general  pg on p.id_proceso = pg.id_proceso
where pg.id_proceso_general = 104 and pe.estado='A' and e.estado='A'
order by pe.orden



-- exec pro.sp_guardar_persona_parentesco
--      @accion = 'I',
--      @id_persona = 323,
--      @id_persona_relacionada = 15749,
--      @id_tipo_parentesco = 16,
--      @fecha_desde = null,
--      @confirmado = 0,
--      @fuente_registro = 'DECLARACION',
--      @observacion = 'Relación declarada por el usuario.',
--      @usuario = 'cmendoza';


select p.identificacion,pa.* from man.informacion_academica_persona pa
         inner join man.personas  p on p.id = pa.id_persona
         where pa.estado='A' and validado = 1

exec  aca.pa_generar_asignaturas_a_matricular_sga  24954,136,3,17041

select * from hdv.tipo_capacitaciones

select * from pro.tipo_conflicto_interes

select * from pro.tipo_parentesco

select * from pro.tipo_vinculo_parentesco

select * from man.discapacidad

select * from pro.regla_integridad

select  p.id,p.identificacion,p.apellidos,p.nombres,pe.identificacion,pe.apellidos,pe.nombres,
        iif(pe.sexo='F',tp.descripcion_femenino,tp.descripcion_masculino) as parentesco,'EXTERNO' as tipo
from man.parentesco_externo pe
         inner join man.personas p on pe.id_persona = p.id
         inner join pro.tipo_parentesco tp on pe.id_tipo_parentesco = tp.id_tipo_parentesco
where p.estado='AC'
-- order by p.apellidos,p.nombres,pe.apellidos,pe.nombres
union all
select  p.id,p.identificacion,p.apellidos,p.nombres,pr.identificacion,pr.apellidos,pr.nombres,
        iif(pr.sexo='F',tp.descripcion_femenino,tp.descripcion_masculino) as parentesco, 'INTERNO' as tipo
from pro.persona_parentesco pp
         inner join man.personas p on pp.id_persona = p.id
         inner join man.personas pr on pr.id = pp.id_persona_relacionada
         inner join pro.tipo_parentesco tp on pp.id_tipo_parentesco = tp.id_tipo_parentesco
where p.estado='AC'
order by p.apellidos,p.nombres--,pr.apellidos,pr.nombres

--  DBCC CHECKIDENT ('pro.regla_integridad', RESEED, 0);

select * from uath.fn_obtener_puesto_y_jefatura_persona('0918849100')

select * from man.personas where identificacion in ('2400206005','2400254286')
--  DBCC CHECKIDENT ('pro.persona_parentesco', RESEED, 0);
select * from pro.persona_parentesco where id_persona in (13145,101701,15749,323)

select * from man.parentesco_externo
select * from man.tipo_identificacion

select distinct identificacion from dbo.persona_nivelacion


select * from pro.postulacion_declaracion_integridad WHERE usuario_ing='0926253006'


SELECT * FROM pro.postulacion_declaracion_parentesco where id_persona_parentesco = 239

-- DBCC CHECKIDENT ('pro.postulacion_declaracion_parentesco', RESEED, 0);

select * from pro.postulacion_declaracion_interes

select * from man.opciones

select * from pro.tipo_vinculo_parentesco

select * from pro.fn_listar_relaciones_persona(323)
select * from pro.fn_listar_parentescos_declarados_postulacion(10587)


select * from pro.fn_listar_relaciones_persona(497)
select * from pro.fn_listar_parentescos_declarados_postulacion(10587)

select * from pro.persona_parentesco where id_persona in (323,15749)
select * from pro.postulacion_declaracion_parentesco where id_persona_parentesco in (86,643    )
select * from man.personas where identificacion='0926253006'

select * from uath.trabajador_ipg
select * from uath.persona_puesto_asignacion
select * from uath.fn_obtener_puesto_y_jefatura_persona('0918849100')

select * from uath.jerarquia_puesto_trabajo
select * from hdv.motivo_salida

select * from even.eventos where id_tipo_evento in (5,2,3) and organizacion not in ('UNIR') and organizador not in ('UPSE | UNIR')


select * from man.personas where profesion is not null

select * from [mig].[sp_listar_personas_by_filter]('carlos mendoza','nombres_completos')



select * from man.personas where identificacion='2400254286'

SELECT * FROM pro.postulacion_declaracion_parentesco where id_postulacion_declaracion_integridad = 2

select * from pro.postulacion_declaracion_interes

select * from pro.persona_parentesco where id_persona = 323


select * from man.persona_cuidado_discapacidad

BEGIN
    ;WITH personal_activo AS
              (
                  /*
                      Personal principal:
                      una sola fila por cada persona que tenga al menos un contrato activo.
                  */
                  SELECT p.id, p.identificacion, p.apellidos, p.nombres,
                         MAX(c.cg_Cargo_txt) AS cargo, c.defTipoContrato_txt
                  FROM man.personas AS p
                           INNER JOIN uath.contratos_migracion_06_02_2024 AS c ON c.identificacion = p.identificacion
                      AND c.EstadoContrato = 'A'
                  WHERE p.estado = 'AC'
                  GROUP BY p.id, p.identificacion, p.apellidos, p.nombres,
                           c.defTipoContrato_txt
              ),
          cargo AS
              (
                  /* ==========================================================
                     RELACIONES EXTERNAS
                     ========================================================== */
                  SELECT pe.id_persona, pe.identificacion AS identificacion_relacion,
                         pe.apellidos AS apellidos_relacion, pe.nombres AS nombres_relacion,
                         CASE
                             WHEN pe.sexo = 'F' THEN tp.descripcion_femenino
                             ELSE tp.descripcion_masculino
                             END AS parentesco,
                         'EXTERNO' AS tipo,
                         CASE
                             WHEN EXISTS
                                 (
                                     SELECT 1
                                     FROM uath.contratos_migracion_06_02_2024 AS ca
                                     WHERE ca.identificacion = pe.identificacion
                                       AND ca.EstadoContrato = 'A'
                                 ) THEN 1
                             ELSE 0
                             END AS tiene_contrato_activo
                  FROM man.parentesco_externo AS pe
                           INNER JOIN pro.tipo_parentesco AS tp ON tp.id_tipo_parentesco = pe.id_tipo_parentesco

                  UNION ALL

                  /* ==========================================================
                     RELACIONES INTERNAS
                     ========================================================== */
                  SELECT pp.id_persona, pr.identificacion AS identificacion_relacion,
                         pr.apellidos AS apellidos_relacion, pr.nombres AS nombres_relacion,
                         CASE
                             WHEN pr.sexo = 'F' THEN tp.descripcion_femenino
                             ELSE tp.descripcion_masculino
                             END AS parentesco,
                         'INTERNO' AS tipo,
                         CASE
                             WHEN EXISTS
                                 (
                                     SELECT 1
                                     FROM uath.contratos_migracion_06_02_2024 AS ca
                                     WHERE ca.identificacion = pr.identificacion
                                       AND ca.EstadoContrato = 'A'
                                 ) THEN 1
                             ELSE 0
                             END AS tiene_contrato_activo
                  FROM pro.persona_parentesco AS pp
                           INNER JOIN man.personas AS pr ON pr.id = pp.id_persona_relacionada
                           INNER JOIN pro.tipo_parentesco AS tp ON tp.id_tipo_parentesco = pp.id_tipo_parentesco
              )
     SELECT pa.id, pa.identificacion, pa.apellidos, pa.nombres,
            pa.cargo, pa.defTipoContrato_txt AS tipoFuncionario,
            CASE
                WHEN EXISTS
                    (
                        SELECT 1
                        FROM man.informacion_academica_persona AS iap
                        WHERE iap.id_persona = pa.id
                    ) THEN 'SI'
                ELSE 'NO'
                END AS tieneInformacionAcademica,
            CASE
                WHEN EXISTS
                    (
                        SELECT 1
                        FROM hdv.persona_certicado AS pc
                        WHERE pc.id_persona = pa.id
                    ) THEN 'SI'
                ELSE 'NO'
                END AS tieneCertificados,
            CASE
                WHEN EXISTS
                    (
                        SELECT 1
                        FROM hdv.persona_capacitacion AS pca
                        WHERE pca.id_persona = pa.id
                    ) THEN 'SI'
                ELSE 'NO'
                END AS tieneCapacitaciones,
            CASE
                WHEN EXISTS
                    (
                        SELECT 1
                        FROM hdv.persona_experiencia_laboral AS pel
                        WHERE pel.id_persona = pa.id
                    ) THEN 'SI'
                ELSE 'NO'
                END AS tieneExperienciaLaboral,
            CASE
                WHEN EXISTS
                    (
                        SELECT 1
                        FROM hdv.persona_referencia AS pref
                        WHERE pref.id_persona = pa.id
                    ) THEN 'SI'
                ELSE 'NO'
                END AS tieneReferencias,
            CASE
                WHEN EXISTS
                    (
                        SELECT 1
                        FROM hdv.persona_certificacion_oficial AS pco
                        WHERE pco.id_persona = pa.id
                    ) THEN 'SI'
                ELSE 'NO'
                END AS tieneCertificacionesOficiales,
            CASE
                WHEN EXISTS
                    (
                        SELECT 1
                        FROM hdv.persona_dato_bancario AS pdb
                        WHERE pdb.id_persona = pa.id
                    ) THEN 'SI'
                ELSE 'NO'
                END AS tieneDatosBancarios,
            COUNT(r.id_persona) AS totalRelaciones,
            SUM(CASE WHEN r.tipo = 'EXTERNO' THEN 1 ELSE 0 END) AS totalExternas,
            SUM(CASE WHEN r.tipo = 'EXTERNO' AND r.tiene_contrato_activo = 1 THEN 1 ELSE 0 END) AS externasConContratoActivo,
            SUM(CASE WHEN r.tipo = 'EXTERNO' AND r.tiene_contrato_activo = 0 THEN 1 ELSE 0 END) AS externasSinContratoActivo,
            SUM(CASE WHEN r.tipo = 'INTERNO' THEN 1 ELSE 0 END) AS totalInternas,
            SUM(CASE WHEN r.tipo = 'INTERNO' AND r.tiene_contrato_activo = 1 THEN 1 ELSE 0 END) AS internasConContratoActivo,
            SUM(CASE WHEN r.tipo = 'INTERNO' AND r.tiene_contrato_activo = 0 THEN 1 ELSE 0 END) AS internasSinContratoActivo,
            CASE
                WHEN EXISTS
                         (
                             SELECT 1
                             FROM man.informacion_academica_persona iap
                             WHERE iap.id_persona = pa.id
                               AND (iap.fecha_ing >= '20260805' OR iap.fecha_mod >= '20260805')
                         )
                    OR EXISTS
                         (
                             SELECT 1
                             FROM hdv.persona_certicado pc
                             WHERE pc.id_persona = pa.id
                               AND (pc.fecha_ing >= '20260805' OR pc.fecha_mod >= '20260805')
                         )
                    OR EXISTS
                         (
                             SELECT 1
                             FROM hdv.persona_capacitacion pca
                             WHERE pca.id_persona = pa.id
                               AND (pca.fecha_ing >= '20260805' OR pca.fecha_mod >= '20260805')
                         )
                    OR EXISTS
                         (
                             SELECT 1
                             FROM hdv.persona_experiencia_laboral pel
                             WHERE pel.id_persona = pa.id
                               AND (pel.fecha_ing >= '20260805' OR pel.fecha_mod >= '20260805')
                         )
                    OR EXISTS
                         (
                             SELECT 1
                             FROM hdv.persona_referencia pref
                             WHERE pref.id_persona = pa.id
                               AND (pref.fecha_ing >= '20260805' OR pref.fecha_mod >= '20260805')
                         )
                    OR EXISTS
                         (
                             SELECT 1
                             FROM hdv.persona_certificacion_oficial pco
                             WHERE pco.id_persona = pa.id
                               AND (pco.fecha_ing >= '20260805' OR pco.fecha_mod >= '20260805')
                         )
                    OR EXISTS
                         (
                             SELECT 1
                             FROM man.parentesco_externo par
                             WHERE par.id_persona = pa.id
                               AND (par.fecha_ing >= '20260805' OR par.fecha_mod >= '20260805')
                         )
                    OR EXISTS
                         (
                             SELECT 1
                             FROM pro.persona_parentesco par
                             WHERE par.id_persona = pa.id
--                                AND (par.fecha_ing >= '20260805' OR par.fecha_mod >= '20260805')
                         )
                    OR EXISTS
                         (
                             SELECT 1
                             FROM hdv.persona_dato_bancario pdb
                             WHERE pdb.id_persona = pa.id
--                                AND (pdb.fecha_ing >= '20260805' OR pdb.fecha_mod >= '20260805')
                         ) THEN 'SI'

                ELSE 'NO'
                END AS actualizoHojaVida
     FROM personal_activo AS pa
              LEFT JOIN cargo AS r ON r.id_persona = pa.id
     GROUP BY pa.id, pa.identificacion, pa.apellidos, pa.nombres,
              pa.cargo, pa.defTipoContrato_txt
     ORDER BY pa.apellidos, pa.nombres;
END;


