USE bd_sga_upse;

--select * from bdupse.pce.fun_tasa_retencion_estudiantes ('2013-1','2017-2',200,227)

select * from  bdupse.pce.fun_tasa_desercion_estudiantes ('2020-1','2022-2',200,227)

select  distinct carrera,id_carrera_ofertada,id_oferta_modalidad from aca.record_oferta where carrera like '%derecho%'
-- select * from bdupse.pce.fun_tasa_retencion_estudiantes ('2020-2','2022-2',200,227)
select * from bd_sga_upse.aca.fn_tasa_retencion_estudiantil ('2019-1','2021-1',200,227,40)
union all
select * from bd_sga_upse.aca.fn_tasa_retencion_estudiantil ('2019-2','2021-2',200,227,40)
union all
select * from bd_sga_upse.aca.fn_tasa_retencion_estudiantil ('2020-1','2022-1',200,227,40)
union all
select * from bd_sga_upse.aca.fn_tasa_retencion_estudiantil ('2020-2','2022-2',200,227,40)
union all
select * from bd_sga_upse.aca.fn_tasa_retencion_estudiantil ('2021-2','2023-1',200,227,40)
union all
select * from bd_sga_upse.aca.fn_tasa_retencion_estudiantil ('2021-2','2023-2',200,227,40)

exec aca.sp_rpt_total_matriculados_por_ofertas 30  , 9
-- 103                 25



alter function [aca].[fn_tasa_retencion_estudiantil] (@periodo_inicio varchar(10),@periodo_corte varchar(10),
@cg_sistema numeric,@cg_modalidad numeric,@id_carrera_ofertada int)

RETURNS @Temp_carreras_tasa_retencion TABLE(
 [id_tmp] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
 [cg_periodo_inicio] [numeric](18, 0) NULL ,
 [periodo_inicia] [varchar] (10) NULL ,
 [id_carrera_ofertada] [numeric](18, 0) NULL ,
 [institucion] [varchar](300) NULL ,
 [facultad] [varchar](300) NULL ,
 [carrera] [varchar](200) NULL ,
 [mat_primer_semestre] [numeric](18, 0) NULL ,
 [primera_vez_reg] [numeric](18, 0) NULL,
 [homologan_repiten] [numeric](18, 0) NULL ,
 [cg_periodo_corte] [numeric](18, 0) NULL ,
 [periodo_corte] [varchar](10) NULL ,
 [ultimo_semestre] [varchar] (50) NULL ,
 [reg_ultimo_semestre] [numeric](18, 0) NULL ,
 [tasa_retencion] [numeric](18, 2) NULL,
 [sistema_estudio] [varchar] (50) NULL ,
 [modalidad] [varchar] (50) NULL ,
 [id_nivel_inicial] [numeric](18, 0) NULL,
 [id_nivel] [numeric](18, 0) NULL
)
AS
BEGIN
	declare @nivel as varchar(10)
	declare @periodo_1 as numeric
	declare @periodo_2 as numeric
	declare @id_nivel as numeric
-- 	declare @id_carrera_ofertada as numeric
	declare @id_nivel_inicial as numeric
	declare @sistema_estudio as varchar(50)
	declare @modalidad as varchar(50),@idOfertaModalidad int,@idPeriodoAcademico int=0
	    if @periodo_corte in ('2023-1')
	    begin
            set @idOfertaModalidad = 103
	        set @idPeriodoAcademico = 27
        end
	    else if @periodo_corte in ('2023-2')
	    begin
            set @idOfertaModalidad = 103
	        set @idPeriodoAcademico = 30
        end
	    else if @periodo_corte in ('2022-1','2022-2')
	    begin
            set @idOfertaModalidad = 25
        end

--ID DE CADA PERIODO ACADEMICO
set @periodo_1 = (select correlativo from Bd_Academico..tp_codigos where valor_texto = @periodo_inicio)
set @periodo_2 = (select correlativo from Bd_Academico..tp_codigos where valor_texto = @periodo_corte)
select @sistema_estudio = valor_texto  from Bd_Academico..tp_codigos where correlativo = @cg_sistema
select @modalidad = valor_texto  from Bd_Academico..tp_codigos where correlativo = @cg_modalidad
--NUMERO DE PERIODOS O SEMESTRES QUE SE DEBE EVALUAR
if @cg_sistema = 200
begin
	select @id_nivel = count(*) from Bd_Academico..tp_codigos
	where estado = 'A' and valor_texto between @periodo_inicio and @periodo_corte
	and id_clasificacion = 33 and ACTIVO_SIS IS NOT NULL AND CORRELATIVO NOT IN (27729, 28150)
	--SEMESTRE FINAL DE EVALUACION
	select @id_nivel_inicial = min(id_nivel) from Bd_Academico..niveles where estado = 'A' and DURACION_SISTEMA = 10
	select @nivel = DESCRIPCION from Bd_Academico..NIVELES where estado = 'A' and id_nivel = @id_nivel and duracion_sistema = 10

end

if @cg_sistema = 201
begin
	select @id_nivel = count(*) from Bd_Academico..tp_codigos
	where estado = 'A' and valor_texto between @periodo_inicio and @periodo_corte and id_clasificacion = 33 AND CORRELATIVO NOT IN (27729)
	--SEMESTRE FINAL DE EVALUACION
	select @id_nivel_inicial = min(id_nivel) from Bd_Academico..niveles where estado = 'A' and DURACION_SISTEMA = 5
	select @nivel = DESCRIPCION from Bd_Academico..NIVELES where estado = 'A' and id_nivel = @id_nivel and duracion_sistema = 5
end




