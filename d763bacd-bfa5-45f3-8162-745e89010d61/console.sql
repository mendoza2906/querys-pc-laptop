use bd_sga_upse

select * from pro.etapa_calendario_mensual ec
inner join pro.proceso_etapa_rol per on ec.id_proceso_etapa_rol = per.id_proceso_etapa_rol
where ec.estado