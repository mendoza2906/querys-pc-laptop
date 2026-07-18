use bd_sga_upse
select * from man.personas where identificacion = '0914849112'

select * from tut.planificacion t where t.id_malla_asignatura =1978 and id_periodo_academico = 136
select * from tut.tarea where id_planificacion in (103,104)

select * from man.personas where celular ='0982836016'

select * from persona_nivelacion where apellidos ='FERNANDEZ LOOR'

--tablas de hechos
    select per.identificacion,per.apellidos,per.nombres,pa.codigo,pae.codigo as periodo_ingreso,tpp.descripcion,scc.id_solicitud_cambio_carrera,pu.observacion,
           scc.id_estudiante_oferta id_estudiante_oferta_origen ,eo2.id_estudiante_oferta id_estudiante_oferta_destino,
    ofa.carrera carrera_origen,ofa2.carrera carrera_destino,iif(a.m_homologadas is null,0,a.m_homologadas) materias_homologadas
    from pro.proceso p
    inner join pro.proceso_general pg on pg.id_proceso = p.id_proceso
    inner join aca.periodo_academico pa on pg.id_periodo_academico = pa.id_periodo_academico
    inner join pro.proceso_usuario pu on pg.id_proceso_general = pu.id_proceso_general
    inner join man.personas per on per.id = pu.id_persona
    inner join pro.solicitud_cambio_carrera scc on scc.id_proceso_usuario=pu.id_proceso_usuario
    inner join pro.tipo_proceso_estado tpp on pu.id_tipo_proceso_estado = tpp.id_tipo_proceso_estado
    inner join aca.estudiante_oferta eo on scc.id_estudiante_oferta = eo.id_estudiante_oferta
    inner join aca.ofertas_facultad ofa on eo.id_oferta_modalidad = ofa.id_oferta_modalidad
    left join aca.estudiante_oferta eo2 on eo.id_estudiante_oferta = eo2.id_estudiante_oferta_padre and eo2.estado='A' and eo2.id_periodo_academico= pg.id_periodo_academico
        and eo2.id_tipo_ingreso_estudiante in (4,22) and eo2.id_tipo_estado_estudiante not in (8)
    left join aca.periodo_academico pae on pae.id_periodo_academico = eo2.id_periodo_academico
    left join aca.ofertas_facultad ofa2 on eo2.id_oferta_modalidad = ofa2.id_oferta_modalidad and ofa2.id_tipo_oferta=2
    left join (
        select m.id_estudiante_oferta, m.id_movilidad,count( distinct dm.id_malla_asignatura) m_homologadas from aca.movilidad m
        inner join aca.detalle_movilidad dm on dm.id_movilidad=m.id_movilidad
        where m.estado='A' and dm.estado='A'
        group by m.id_estudiante_oferta, m.id_movilidad
    ) a on a.id_estudiante_oferta=eo2.id_estudiante_oferta
    where p.id_proceso = 2  and pg.estado = 'A' and pu.estado = 'A' and tpp.estado = 'A' and scc.estado='A'

select per.identificacion,per.apellidos,per.nombres,pa.codigo,pae.codigo as periodo_ingreso,tpp.descripcion,scc.id_solicitud_cambio_carrera,pu.observacion,
       scc.id_estudiante_oferta id_estudiante_oferta_origen ,eo2.id_estudiante_oferta id_estudiante_oferta_destino,
       ofa.carrera carrera_origen,ofa2.carrera carrera_destino,iif(a.m_homologadas is null,0,a.m_homologadas) materias_homologadas
from pro.proceso p
         inner join pro.proceso_general pg on pg.id_proceso = p.id_proceso
         inner join aca.periodo_academico pa on pg.id_periodo_academico = pa.id_periodo_academico
         inner join pro.proceso_usuario pu on pg.id_proceso_general = pu.id_proceso_general
         inner join man.personas per on per.id = pu.id_persona
         inner join pro.solicitud_cambio_carrera scc on scc.id_proceso_usuario=pu.id_proceso_usuario
         inner join pro.tipo_proceso_estado tpp on pu.id_tipo_proceso_estado = tpp.id_tipo_proceso_estado
         inner join aca.estudiante_oferta eo on scc.id_estudiante_oferta = eo.id_estudiante_oferta
         inner join aca.ofertas_facultad ofa on eo.id_oferta_modalidad = ofa.id_oferta_modalidad
         left join aca.estudiante_oferta eo2 on eo.id_estudiante_oferta = eo2.id_estudiante_oferta_padre and eo2.estado='A' and eo2.id_periodo_academico= pg.id_periodo_academico
         left join aca.periodo_academico pae on pae.id_periodo_academico = eo2.id_periodo_academico
         left join aca.ofertas_facultad ofa2 on eo2.id_oferta_modalidad = ofa2.id_oferta_modalidad and ofa2.id_tipo_oferta=2
         left join (
    select m.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.id_periodo_academico, m.id_movilidad,count( distinct dm.id_malla_asignatura) m_homologadas from aca.movilidad m
    inner join aca.detalle_movilidad dm on dm.id_movilidad=m.id_movilidad
    inner join aca.estudiante_oferta eo on eo.id_estudiante_oferta  = m.id_estudiante_oferta
    where m.estado='A' and dm.estado='A' and eo.estado='A' and eo.id_tipo_ingreso_estudiante in (4,22) and eo.id_tipo_estado_estudiante not in (8)
    group by m.id_estudiante_oferta,eo.id_estudiante_oferta_padre,eo.id_periodo_academico, m.id_movilidad
) a on a.id_estudiante_oferta=eo2.id_estudiante_oferta and a.id_periodo_academico= pg.id_periodo_academico
where p.id_proceso = 2  and pg.estado = 'A' and pu.estado = 'A' and tpp.estado = 'A' and scc.estado='A'

select * from aca.tipo_estado_estudiante
select * from aca.tipo_ingreso_estudiante

select per.identificacion,per.apellidos,per.nombres,pa.codigo,pae.codigo as periodo_ingreso,tpp.descripcion,scc.id_solicitud_cambio_carrera,pu.observacion,
       scc.id_estudiante_oferta id_estudiante_oferta_origen ,eo2.id_estudiante_oferta id_estudiante_oferta_destino,
       ofa.carrera carrera_origen,ofa2.carrera carrera_destino,iif(a.m_homologadas is null,0,a.m_homologadas) materias_homologadas
from pro.proceso p
         inner join pro.proceso_general pg on pg.id_proceso = p.id_proceso
         inner join aca.periodo_academico pa on pg.id_periodo_academico = pa.id_periodo_academico
         inner join pro.proceso_usuario pu on pg.id_proceso_general = pu.id_proceso_general
         inner join man.personas per on per.id = pu.id_persona
         inner join pro.solicitud_cambio_carrera scc on scc.id_proceso_usuario=pu.id_proceso_usuario
         inner join pro.tipo_proceso_estado tpp on pu.id_tipo_proceso_estado = tpp.id_tipo_proceso_estado
         inner join aca.estudiante_oferta eo on scc.id_estudiante_oferta = eo.id_estudiante_oferta
         inner join aca.ofertas_facultad ofa on eo.id_oferta_modalidad = ofa.id_oferta_modalidad
         left join aca.estudiante_oferta eo2 on eo.id_estudiante_oferta = eo2.id_estudiante_oferta_padre and eo2.estado='A' and eo2.id_periodo_academico= pg.id_periodo_academico
         left join aca.periodo_academico pae on pae.id_periodo_academico = eo2.id_periodo_academico
         left join aca.ofertas_facultad ofa2 on eo2.id_oferta_modalidad = ofa2.id_oferta_modalidad and ofa2.id_tipo_oferta=2
         left join (
    select m.id_estudiante_oferta, m.id_movilidad,
           count( distinct dm.id_malla_asignatura) m_homologadas from aca.movilidad m
            inner join aca.detalle_movilidad dm on dm.id_movilidad=m.id_movilidad
    where m.estado='A' and dm.estado='A'
    group by m.id_estudiante_oferta, m.id_movilidad
) a on a.id_estudiante_oferta=eo2.id_estudiante_oferta
where p.id_proceso = 2  and pg.estado = 'A' and pu.estado = 'A' and tpp.estado = 'A' and scc.estado='A'


-- select * from pro.proceso_usuario pu
-- inner join pro.proceso_general pg on pu.id_proceso_general = pg.id_proceso_general
-- where pg.id_proceso = 2

-- select * from seg.roles r --where id in (34,47,1)
-- -- inner join seg.roles_usuarios ro on r.id = ro.rol_id
-- where r.codigo='COLABORADOR'
--
-- select ro.* from seg.roles_usuarios ro
-- inner join seg.usuarios u on ro.usuario_id = u.id
-- where u.usuario = '0928502673'

select tpp.descripcion,scc.id_solicitud_cambio_carrera,scc.id_estudiante_oferta id_estudiante_oferta_origen ,--eo2.id_estudiante_oferta id_estudiante_oferta_destino,
       offf.carrera carrera_origen,offf2.carrera carrera_destino,iif(a.m_homologadas is null,0,a.m_homologadas) materias_homologadas  from pro.proceso p
         inner join pro.proceso_general pg on pg.id_proceso = p.id_proceso
            inner join pro.proceso_usuario pu on pg.id_proceso_general = pu.id_proceso_general
            inner join pro.solicitud_cambio_carrera scc on scc.id_proceso_usuario=pu.id_proceso_usuario
            inner join pro.tipo_proceso_estado tpp on pu.id_tipo_proceso_estado = tpp.id_tipo_proceso_estado
         inner join aca.estudiante_oferta eo on scc.id_estudiante_oferta = eo.id_estudiante_oferta
         left join aca.estudiante_oferta eo2 on eo.id_estudiante_oferta = eo2.id_estudiante_oferta_padre and eo2.estado='A'
         inner join aca.ofertas_facultad offf on eo.id_oferta_modalidad = offf.id_oferta_modalidad
         left join aca.ofertas_facultad offf2 on eo2.id_oferta_modalidad = offf2.id_oferta_modalidad and offf2.id_tipo_oferta=2
        left join (select m.id_estudiante_oferta, m.id_movilidad,count( distinct dm.id_malla_asignatura) m_homologadas from aca.movilidad m
                            inner join aca.detalle_movilidad dm on dm.id_movilidad=m.id_movilidad
                                                                                 where m.estado='A' and dm.estado='A'
                                                                                 group by m.id_estudiante_oferta, m.id_movilidad) a on a.id_estudiante_oferta=eo2.id_estudiante_oferta
where p.id_proceso = 2  and pg.estado = 'A' and pu.estado = 'A' and tpp.estado = 'A' and scc.estado='A'

select distinct ofa.id_oferta_modalidad,ofa.carrera,ofa.modalidad,ofa.facultad from pro.proceso p
         inner join pro.proceso_general pg on pg.id_proceso = p.id_proceso
            inner join pro.proceso_usuario pu on pg.id_proceso_general = pu.id_proceso_general
            inner join pro.solicitud_cambio_carrera scc on scc.id_proceso_usuario=pu.id_proceso_usuario
            inner join pro.tipo_proceso_estado tpp on pu.id_tipo_proceso_estado = tpp.id_tipo_proceso_estado
         inner join aca.estudiante_oferta eo on scc.id_estudiante_oferta = eo.id_estudiante_oferta
         left join aca.estudiante_oferta eo2 on eo.id_estudiante_oferta = eo2.id_estudiante_oferta_padre and eo2.estado='A'
         inner join aca.ofertas_facultad ofa on eo.id_oferta_modalidad = ofa.id_oferta_modalidad
         left join aca.ofertas_facultad ofa2 on eo2.id_oferta_modalidad = ofa2.id_oferta_modalidad and ofa2.id_tipo_oferta=2
        left join (select m.id_estudiante_oferta, m.id_movilidad,count( distinct dm.id_malla_asignatura) m_homologadas from aca.movilidad m
                            inner join aca.detalle_movilidad dm on dm.id_movilidad=m.id_movilidad
                                                                                 where m.estado='A' and dm.estado='A'
                                                                                 group by m.id_estudiante_oferta, m.id_movilidad) a on a.id_estudiante_oferta=eo2.id_estudiante_oferta
where p.id_proceso = 2  and pg.estado = 'A' and pu.estado = 'A' and tpp.estado = 'A' and scc.estado='A'

select distinct pa.id_periodo_academico,pa.codigo, pa.descripcion from pro.proceso p
         inner join pro.proceso_general pg on pg.id_proceso = p.id_proceso
    inner join aca.periodo_academico pa on pa.id_periodo_academico=pg.id_periodo_academico
            inner join pro.proceso_usuario pu on pg.id_proceso_general = pu.id_proceso_general
            inner join pro.solicitud_cambio_carrera scc on scc.id_proceso_usuario=pu.id_proceso_usuario
            inner join pro.tipo_proceso_estado tpp on pu.id_tipo_proceso_estado = tpp.id_tipo_proceso_estado
         inner join aca.estudiante_oferta eo on scc.id_estudiante_oferta = eo.id_estudiante_oferta
         left join aca.estudiante_oferta eo2 on eo.id_estudiante_oferta = eo2.id_estudiante_oferta_padre and eo2.estado='A'
         inner join aca.ofertas_facultad ofa on eo.id_oferta_modalidad = ofa.id_oferta_modalidad
         left join aca.ofertas_facultad ofa2 on eo2.id_oferta_modalidad = ofa2.id_oferta_modalidad and ofa2.id_tipo_oferta=2
        left join (select m.id_estudiante_oferta, m.id_movilidad,count( distinct dm.id_malla_asignatura) m_homologadas from aca.movilidad m
                            inner join aca.detalle_movilidad dm on dm.id_movilidad=m.id_movilidad
                                                                                 where m.estado='A' and dm.estado='A'
                                                                                 group by m.id_estudiante_oferta, m.id_movilidad) a on a.id_estudiante_oferta=eo2.id_estudiante_oferta
where p.id_proceso = 2  and pg.estado = 'A' and pu.estado = 'A' and tpp.estado = 'A' and scc.estado='A'

select distinct tpp.id_tipo_proceso_estado,tpp.codigo,tpp.descripcion from pro.proceso p
         inner join pro.proceso_general pg on pg.id_proceso = p.id_proceso
    inner join aca.periodo_academico pa on pa.id_periodo_academico=pg.id_periodo_academico
            inner join pro.proceso_usuario pu on pg.id_proceso_general = pu.id_proceso_general
            inner join pro.solicitud_cambio_carrera scc on scc.id_proceso_usuario=pu.id_proceso_usuario
            inner join pro.tipo_proceso_estado tpp on pu.id_tipo_proceso_estado = tpp.id_tipo_proceso_estado
         inner join aca.estudiante_oferta eo on scc.id_estudiante_oferta = eo.id_estudiante_oferta
         left join aca.estudiante_oferta eo2 on eo.id_estudiante_oferta = eo2.id_estudiante_oferta_padre and eo2.estado='A'
         inner join aca.ofertas_facultad ofa on eo.id_oferta_modalidad = ofa.id_oferta_modalidad
         left join aca.ofertas_facultad ofa2 on eo2.id_oferta_modalidad = ofa2.id_oferta_modalidad and ofa2.id_tipo_oferta=2
        left join (select m.id_estudiante_oferta, m.id_movilidad,count( distinct dm.id_malla_asignatura) m_homologadas from aca.movilidad m
                            inner join aca.detalle_movilidad dm on dm.id_movilidad=m.id_movilidad
                                                                                 where m.estado='A' and dm.estado='A'
                                                                                 group by m.id_estudiante_oferta, m.id_movilidad) a on a.id_estudiante_oferta=eo2.id_estudiante_oferta
where p.id_proceso = 2  and pg.estado = 'A' and pu.estado = 'A' and tpp.estado = 'A' and scc.estado='A'


select distinct per.id,per.identificacion,concat(per.nombres,' ',per.apellidos) nombres,per.sexo, (2026 - (year(per.fecha_nace))) edad,per.id_estado_civil,ec.descripcion from pro.proceso p
         inner join pro.proceso_general pg on pg.id_proceso = p.id_proceso
    inner join aca.periodo_academico pa on pa.id_periodo_academico=pg.id_periodo_academico
            inner join pro.proceso_usuario pu on pg.id_proceso_general = pu.id_proceso_general
    inner join man.personas per on pu.id_persona=per.id
    inner join man.estado_civil ec on per.id_estado_civil = ec.id_estado_civil
            inner join pro.solicitud_cambio_carrera scc on scc.id_proceso_usuario=pu.id_proceso_usuario
            inner join pro.tipo_proceso_estado tpp on pu.id_tipo_proceso_estado = tpp.id_tipo_proceso_estado
         inner join aca.estudiante_oferta eo on scc.id_estudiante_oferta = eo.id_estudiante_oferta
         left join aca.estudiante_oferta eo2 on eo.id_estudiante_oferta = eo2.id_estudiante_oferta_padre and eo2.estado='A'
         inner join aca.ofertas_facultad ofa on eo.id_oferta_modalidad = ofa.id_oferta_modalidad
         left join aca.ofertas_facultad ofa2 on eo2.id_oferta_modalidad = ofa2.id_oferta_modalidad and ofa2.id_tipo_oferta=2
        left join (select m.id_estudiante_oferta, m.id_movilidad,count( distinct dm.id_malla_asignatura) m_homologadas from aca.movilidad m
                            inner join aca.detalle_movilidad dm on dm.id_movilidad=m.id_movilidad
                                                                                 where m.estado='A' and dm.estado='A'
                                                                                 group by m.id_estudiante_oferta, m.id_movilidad) a on a.id_estudiante_oferta=eo2.id_estudiante_oferta
where p.id_proceso = 2  and pg.estado = 'A' and pu.estado = 'A' and tpp.estado = 'A' and scc.estado='A'