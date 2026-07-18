use bd_sga_upse


select id_periodo_academico,codigo,descripcion from aca.periodo_academico pa where pa.id_tipo_oferta =4
begin
--     declare @id_periodo_academico int=141
    select eo.id_estudiante_oferta, em.id_estudiante_matricula , pa.codigo , d.nombre as facultad, o.descripcion as carrera, p.identificacion,
                 p.id,p.apellidos, p.nombres , eo.numero_matricula,a.descripcion,caa.id_cobro_asignatura,caa.id_documento_detalle
          from man.personas p
                   inner join aca.estudiante_oferta eo on eo.id_persona = p.id
                   inner join aca.tipo_estado_estudiante tee    on tee.id_tipo_estado_estudiante = eo.id_tipo_estado_estudiante
                   inner join aca.estudiante_matricula em on em.id_estudiante_oferta = eo.id_estudiante_oferta
                   inner join aca.matricula_general mg on mg.id_matricula_general = em.id_matricula_general
                   inner join aca.periodo_academico pa on mg.id_periodo_academico = pa.id_periodo_academico
                   inner join aca.estudiante_asignatura ea on ea.id_estudiante_matricula = em.id_estudiante_matricula
--                    inner join aca.matricula_rubro mr on em.id_estudiante_matricula = mr.id_estudiante_matricula
--                    inner join tes.cobro_matricula cm on cm.id_matricula_rubro = mr.id_matricula_rubro
                    inner join tes.cobro_asignatura caa on ea.id_estudiante_asignatura = caa.id_estudiante_asignatura
                   inner join aca.asignatura_aprendizaje aa    on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
                   inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
                   inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
                   inner join aca.oferta_modalidad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
                   inner join aca.oferta o on o.id_oferta = om.id_oferta
                   inner join aca.departamento_oferta do on do.id_oferta = o.id_oferta
                   inner join man.departamentos d on d.id = do.id_departamento
          where --mg.id_periodo_academico = @id_periodo_academico
            em.estado = 'A' --and o.id_tipo_oferta = 4
            and ea.estado = 'A'
          group by eo.id_estudiante_oferta, em.id_estudiante_matricula, pa.codigo, d.nombre, o.descripcion,
                   p.identificacion, p.apellidos, p.nombres, eo.numero_matricula, caa.id_cobro_asignatura, caa.id_documento_detalle, a.descripcion, p.id
--            , ma.id_nivel, ma.id_malla_asignatura,ea.id_paralelo,ea.id_estudiante_asignatura,a.descripcion

end;

select * from tes.cobro_asignatura
select * from tes.documento_detalle where id_documento_detalle=23414
--ids modificados 14569
select * from tes.documento_contable where id_documento_contable in (14568,14569)

select * from tes.documento_contable where id_persona in (38575,84525)
--ids modificados 14569
select * from tes.documento_detalle where id_documento_contable in (14568,14569)

select * from tes.cobro_asignatura where id_documento_detalle in (30672,30671)

select dd.*
--     dc.id_documento_contable,dc.id_persona,dc.codigo,dc.descripcion as des_documento_contable,dc.fecha,dc.total,dc.estado,dd.id_documento_detalle,dd.codigo as codigoDEtalle,
--        dd.descripcion as descripcionCobro,dd.estado,ca.id_cobro_asignatura,ca.activada,ca.id_estudiante_asignatura,ca.estado,com.fecha_pago,com.comprobante,com.link,com.estado
from tes.documento_contable dc
    inner join tes.documento_detalle dd on dc.id_documento_contable = dd.id_documento_contable
    inner join tes.comprobante com on dc.id_documento_contable = com.id_documento_contable
    inner join tes.cobro_asignatura ca on dd.id_documento_detalle = ca.id_documento_detalle
where dc.estado='A' and dd.estado='A' and com.estado in ('A','C') and
      dc.id_documento_contable = 14480

select ca.*
--     dc.id_documento_contable,dc.id_persona,dc.codigo,dc.descripcion as des_documento_contable,dc.fecha,dc.total,dc.estado,dd.id_documento_detalle,dd.codigo as codigoDEtalle,
--        dd.descripcion as descripcionCobro,dd.estado,ca.id_cobro_asignatura,ca.activada,ca.id_estudiante_asignatura,ca.estado,com.fecha_pago,com.comprobante,com.link,com.estado
from tes.documento_contable dc
         inner join tes.documento_detalle dd on dc.id_documento_contable = dd.id_documento_contable
         inner join tes.comprobante com on dc.id_documento_contable = com.id_documento_contable
         inner join tes.cobro_matricula ca on dd.id_documento_detalle = ca.id_documento_detalle
where dc.estado='A' and dd.estado='A' and com.estado in ('A','C') and
    dc.id_documento_contable = 15353

select d.periodo_academico,d.nivel,d.concepto,d.valor,d.abono,d.deuda from  aca.fn_record_rubros ('2450869801') d
-- where d.abono <d.valor and d.concepto is not null
  --se excluye a los estudiantes con convenio de pago
--   and d.identificacion not in ('2400305708','0926362484')

select  d.FACULTAD,d.CARRERA, d.IDENTIFICACION,  d.MATRICULA, d.NOMBRE,TIPO = 'TESORERIA',  CONVERT(VARCHAR(10), d.FECHA, 103) as FECHA,
        d.PERIODO_ACADEMICO, d.NIVEL, ID_MATERIA_PLAN = 0, d.CONCEPTO, d.VALOR, d.ABONO, d.DEUDA
from tes.fun_sgt_deudas_identificacion(getdate(),'2450869801') AS d





select * from pro.fn_consultar_deudas_estudiantes ('2450869801')

select dc.id_documento_contable,dc.id_persona,dc.codigo,dc.descripcion as des_documento_contable,dc.fecha,dc.total,dc.estado,dd.id_documento_detalle,dd.codigo as codigoDEtalle,
       dd.descripcion as descripcionCobro,dd.estado,ca.id_cobro_asignatura,ca.activada,ca.id_estudiante_asignatura,ca.estado,com.fecha_pago,com.comprobante,com.link,
       om.facultad, om.carrera, p.identificacion, p.id,p.apellidos, p.nombres , eo.numero_matricula,a.descripcion
       from tes.documento_contable dc
inner join tes.documento_detalle dd on dc.id_documento_contable = dd.id_documento_contable
inner join tes.comprobante com on dc.id_documento_contable = com.id_documento_contable
inner join tes.cobro_asignatura ca on dd.id_documento_detalle = ca.id_documento_detalle
inner join aca.estudiante_asignatura ea on ea.id_estudiante_asignatura = ca.id_estudiante_asignatura
inner join aca.estudiante_matricula em on ea.id_estudiante_matricula = em.id_estudiante_matricula
inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
inner join man.personas p on p.id = eo.id_persona
inner join aca.asignatura_aprendizaje aa    on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where dc.id_documento_contable=15353
   -- dc.id_persona in (30249)

select dc.id_documento_contable,dc.id_persona,dc.codigo,dc.descripcion as des_documento_contable,dc.fecha,dc.total,dc.estado,dd.id_documento_detalle,dd.codigo as codigoDEtalle,
       dd.descripcion as descripcionCobro,dd.estado,ca.id_cobro_asignatura,ca.activada,ca.id_estudiante_asignatura,ca.estado,com.fecha_pago,com.comprobante,com.link,
       om.facultad, om.carrera, p.identificacion, p.id,p.apellidos, p.nombres , eo.numero_matricula,a.descripcion
from tes.documento_contable dc
         inner join tes.documento_detalle dd on dc.id_documento_contable = dd.id_documento_contable
         inner join tes.comprobante com on dc.id_documento_contable = com.id_documento_contable
         inner join tes.cobro_asignatura ca on dd.id_documento_detalle = ca.id_documento_detalle
         inner join aca.estudiante_asignatura ea on ea.id_estudiante_asignatura = ca.id_estudiante_asignatura
         inner join aca.estudiante_matricula em on ea.id_estudiante_matricula = em.id_estudiante_matricula
         inner join aca.estudiante_oferta eo on em.id_estudiante_oferta = eo.id_estudiante_oferta
         inner join aca.ofertas_facultad om on om.id_oferta_modalidad = eo.id_oferta_modalidad
         inner join man.personas p on p.id = eo.id_persona
         inner join aca.asignatura_aprendizaje aa    on aa.id_asignatura_aprendizaje = ea.id_asignatura_aprendizaje
         inner join aca.malla_asignatura ma on ma.id_malla_asignatura = aa.id_malla_asignatura
         inner join aca.asignatura a on a.id_asignatura = ma.id_asignatura
where ca.id_estudiante_asignatura in (711534)


select * from tes.documento_contable where codigo='CAR-04-18-101'
select * from tes.documento_detalle where codigo='CAR-04-18-101'
select * from tes.documento_cartera

select * from tes.transaccion
select * from tes.comprobante
