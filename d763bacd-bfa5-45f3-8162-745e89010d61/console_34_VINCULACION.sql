use bd_sga_upse
exec [vcc].[sp_get_proyectos_dirigidos] 791

select count(oferpro.id) from vcc.oferta_proyecto oferpro where oferpro.estado = 'A' and oferpro.id_proyecto = 164

select * from vcc.oferta_proyecto oferpro where oferpro.estado = 'A'

select * from vcc.programa prog where id =49

select * from aca.ofertas_facultad where id_oferta_modalidad = 94

select * from vcc.proyecto where id = 164

select * from seg.usuarios where persona_id = 323
--     {bcrypt}$2a$10$RK7tJeLX4bbS20AtJ2WNs.d21iQcbPVLsiN9siz3eJh5lCqCdaKRO
