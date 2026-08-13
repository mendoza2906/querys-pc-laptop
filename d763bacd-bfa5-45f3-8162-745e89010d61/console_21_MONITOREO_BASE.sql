use bd_sga_upse

-- CREATE TABLE aud.AuditColumnChanges (
--                                         Id INT IDENTITY(1,1) PRIMARY KEY,
--                                         LoginName NVARCHAR(100),
--                                         UserName NVARCHAR(100),
--                                         EventType NVARCHAR(100),
--                                         TableName NVARCHAR(255),
--                                         ColumnName NVARCHAR(255),
--                                         SchemaName NVARCHAR(255),
--                                         EventDate DATETIME,
--                                         EventDetails NVARCHAR(MAX),
--                                         EventData XML
-- );
--
-- CREATE TABLE aud.AuditSchemaChanges (
--                                         Id INT IDENTITY(1,1) PRIMARY KEY,
--                                         LoginName NVARCHAR(100),
--                                         UserName NVARCHAR(100),
--                                         EventType NVARCHAR(100),
--                                         ObjectName NVARCHAR(255),
--                                         SchemaName NVARCHAR(255),
--                                         EventDate DATETIME,
--                                         EventDetails NVARCHAR(MAX),  -- Nueva columna para detalles adicionales
--                                         EventData XML
-- );

--
-- create TRIGGER DDLTriggerAuditColumnChanges
--     ON DATABASE
--     FOR ALTER_TABLE  -- Captura eventos de ALTER TABLE, que incluyen agregar o quitar columnas
--     AS
-- BEGIN
--     DECLARE @EventData XML
--     SET @EventData = EVENTDATA()
--
--     DECLARE @EventType NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)')
--     DECLARE @LoginName NVARCHAR(255) = @EventData.value('(/EVENT_INSTANCE/LoginName)[1]', 'NVARCHAR(255)')
--     DECLARE @UserName NVARCHAR(255) = @EventData.value('(/EVENT_INSTANCE/UserName)[1]', 'NVARCHAR(255)')
--     DECLARE @TableName NVARCHAR(255) = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(255)')
--     DECLARE @SchemaName NVARCHAR(255) = @EventData.value('(/EVENT_INSTANCE/SchemaName)[1]', 'NVARCHAR(255)')
--     DECLARE @EventDate DATETIME = GETDATE()
--     DECLARE @TSQLCommand NVARCHAR(MAX) = @EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)')
--     DECLARE @ColumnName NVARCHAR(255) = NULL
--
--     -- Intentar extraer el nombre de la columna si es un ADD COLUMN
--     IF @TSQLCommand LIKE '%ADD%'
--         BEGIN
--             SET @ColumnName = LTRIM(RTRIM(SUBSTRING(@TSQLCommand, CHARINDEX('ADD', @TSQLCommand) + 4, CHARINDEX(' ', @TSQLCommand + ' ', CHARINDEX('ADD', @TSQLCommand) + 4) - CHARINDEX('ADD', @TSQLCommand) - 4)))
--         END
--     ELSE IF @TSQLCommand LIKE '%DROP COLUMN %'
--         BEGIN
--             SET @ColumnName = LTRIM(RTRIM(SUBSTRING(@TSQLCommand, CHARINDEX('DROP COLUMN ', @TSQLCommand) + 12, CHARINDEX(' ', @TSQLCommand + ' ', CHARINDEX('DROP COLUMN ', @TSQLCommand) + 12) - CHARINDEX('DROP COLUMN ', @TSQLCommand) - 12)))
--         END
--
--     IF @TSQLCommand LIKE '%SET (LOCK_ESCALATION =%'
--         RETURN;
--
--     -- Insertar el registro en la tabla de auditoría
--     INSERT INTO aud.AuditColumnChanges (LoginName,UserName,EventType, TableName, SchemaName, ColumnName, EventDate, EventDetails, EventData)
--     VALUES (@LoginName,@UserName,@EventType, @TableName, @SchemaName, @ColumnName, @EventDate, @TSQLCommand, @EventData)
-- END
-- GO
--
--
-- CREATE TRIGGER DDLTriggerAuditChanges
--     ON DATABASE
--     FOR
--     CREATE_TABLE, ALTER_TABLE, DROP_TABLE,    -- Tablas
--     CREATE_VIEW, ALTER_VIEW, DROP_VIEW,       -- Vistas
--     CREATE_PROCEDURE, ALTER_PROCEDURE, DROP_PROCEDURE,  -- Procedimientos almacenados
--     CREATE_FUNCTION, ALTER_FUNCTION, DROP_FUNCTION,  -- Funciones escalares y de tabla
--     CREATE_TRIGGER, ALTER_TRIGGER, DROP_TRIGGER,  -- Triggers
--     CREATE_SCHEMA, ALTER_SCHEMA, DROP_SCHEMA  -- Esquemas
--     AS
-- BEGIN
--     DECLARE @EventData XML
--     SET @EventData = EVENTDATA()
--
--     -- Construir un detalle consolidado
--     DECLARE @EventType NVARCHAR(100) = @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)')
--     DECLARE @LoginName NVARCHAR(255) = @EventData.value('(/EVENT_INSTANCE/LoginName)[1]', 'NVARCHAR(255)')
--     DECLARE @UserName NVARCHAR(255) = @EventData.value('(/EVENT_INSTANCE/UserName)[1]', 'NVARCHAR(255)')
--     DECLARE @ObjectName NVARCHAR(255) = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(255)')
--     DECLARE @SchemaName NVARCHAR(255) = @EventData.value('(/EVENT_INSTANCE/SchemaName)[1]', 'NVARCHAR(255)')
--     DECLARE @EventDate DATETIME = GETDATE()
--     DECLARE @EventDetails NVARCHAR(MAX)
--
--     -- Lógica para consolidar detalles
--     SET @EventDetails = CASE
--                             WHEN @EventType = 'ALTER_TABLE'
--                                 THEN 'Altered table: ' + @ObjectName + ' in schema: ' + @SchemaName
--                             ELSE 'EventType: ' + @EventType + ', ObjectName: ' + @ObjectName + ', SchemaName: ' + @SchemaName
--         END
--
--     -- Verificar si ya existe un registro similar en un rango de tiempo para evitar duplicados
--     IF NOT EXISTS (
--         SELECT 1
--         FROM aud.AuditSchemaChanges
--         WHERE EventType = @EventType
--           AND ObjectName = @ObjectName
--           AND EventDate > DATEADD(MINUTE, -10, @EventDate)  -- Solo registra eventos similares en los últimos 10 minutos
--     )
--         BEGIN
--             INSERT INTO aud.AuditSchemaChanges(LoginName,UserName,EventType, ObjectName, SchemaName, EventDate, EventDetails, EventData)
--             VALUES (@LoginName,@UserName, @EventType,@ObjectName,@SchemaName,@EventDate,@EventDetails,@EventData)
--         END
-- END
-- GO

SELECT schema_id, name FROM sys.schemas;

SELECT name AS NombreTabla, create_date AS FechaCreacion
FROM sys.tables
WHERE name = 'certificacion_presupuestaria';

SELECT
    o.name AS NombreTabla,
    s.name AS Esquema,
--     u.name AS UsuarioCreador,
    o.create_date AS FechaCreacion,
    o.modify_date AS FechaModificacion
FROM
    sys.objects o
        JOIN
    sys.schemas s ON o.schema_id = s.schema_id
--         JOIN
--     sys.sysusers u ON o. = u.uid
WHERE
    o.type = 'U' and -- U es el tipo para tablas (User-defined)
    o.name = 'certificacion_presupuestaria';

select * from pre.certificacion_presupuestaria


SELECT s.name  AS Esquema,
       SUM(CASE WHEN o.type = 'U' THEN 1 ELSE 0 END)  AS NumeroDeTablas,
       SUM(CASE WHEN o.type = 'V' THEN 1 ELSE 0 END)  AS NumeroDeVistas,
       SUM(CASE WHEN o.type = 'P' THEN 1 ELSE 0 END)  AS NumeroDeProcedimientos,
       SUM(CASE WHEN o.type = 'TR' THEN 1 ELSE 0 END) AS NumeroDeTriggers,
       SUM(CASE WHEN o.type = 'FN' THEN 1 ELSE 0 END) AS NumeroDeFuncionesEscalares,
       SUM(CASE WHEN o.type = 'IF' THEN 1 ELSE 0 END) AS NumeroDeFuncionesConTablaInlined,
       SUM(CASE WHEN o.type = 'TF' THEN 1 ELSE 0 END) AS NumeroDeFuncionesConTablaMultiStatement
FROM sys.schemas s
         LEFT JOIN
     sys.objects o ON s.schema_id = o.schema_id
where len(s.name)<=5
GROUP BY s.name
ORDER BY NumeroDeTablas DESC, NumeroDeVistas DESC, NumeroDeProcedimientos DESC, NumeroDeTriggers DESC;


-- create schema rel


begin
    DECLARE @TipoObjeto NVARCHAR(2) = 'P';  -- P: Procedimientos almacenados, U: Tablas, V: Vistas, TR: Triggers, FN: Funciones escalares, etc.
    DECLARE @Esquema NVARCHAR(255) = 'bib'; -- Esquema deseado

    SELECT
        s.name AS Esquema,
        o.name AS Objeto,
        o.type_desc AS TipoObjeto
    FROM
        sys.objects o
            JOIN
        sys.schemas s ON o.schema_id = s.schema_id
    WHERE
        o.type = @TipoObjeto
      AND s.name = @Esquema
    ORDER BY
        o.name;
end

select * from sgai.aux_marco_logico

select * from aud.AuditSchemaChanges where cast(EventDate as date) = cast(getdate() as date)

select * from aud.AuditSchemaChanges where SchemaName ='aca'
select * from aud.AuditSchemaChanges where ObjectName='tr_aud_estudiante_calificacion'

select * from aud.AuditColumnChanges where cast(EventDate as date) = cast(getdate() as date)

-- DBCC CHECKIDENT ('aud.AuditColumnChanges', RESEED, 17883)

select d.id_registro, fecha_registro, hora_registro, reportado_por, rol_importante, sistema_afectado, tipo_evento, categoria_evento, descripcion_evento,
       severidad, estado_evento, responsable, fecha_asignacion, solucion_1, solucion_2, solucion_3, solucion_recomendada, fecha_resolucion,
       tiempo_Total_Resolución_Horas, observacion, aprobado_por, fecha_cierre from (
select concat('INC-',cast(a.EventDate as date),'-',RIGHT(REPLICATE('0', 5) + CAST(a.Id AS VARCHAR(5)), 5) ) as id_registro, cast(a.EventDate as date) as fecha_registro,CONVERT(VARCHAR(8), a.EventDate, 108) as hora_registro,
       'Equipo de desarrollo' as reportado_por, 'Desarrollador' as rol_importante,'SGA' as sistema_afectado, a.EventType as tipo_evento, 'Base de Datos' as categoria_evento,
       a.EventDetails as descripcion_evento,case when a.EventType like '%CREATE%' then 'Baja' when a.EventType like '%ALTER%' then 'Media' when a.EventType ='DROP_TABLE' then 'Crítica' else 'Alta' end as severidad,
       'Cerrado' as estado_evento,concat('User database: ',a.LoginName) as responsable,DATEADD(DAY, -1, CAST(a.EventDate AS DATE)) as fecha_asignacion,
       'Aplicación de cambios en la base de datos de producción, posterior a las pruebas en desarrollo' as solucion_1, 'Actualizar base de datos' as solucion_2, 'Actualizar base de datos' as solucion_3,
       'Aplicación de cambios en la base de datos de producción, posterior a las pruebas en desarrollo' as solucion_recomendada,cast(a.EventDate as date) as fecha_resolucion,
       CASE EventType
           WHEN 'ALTER_FUNCTION'   THEN 3 WHEN 'ALTER_PROCEDURE'  THEN 3  WHEN 'ALTER_SCHEMA'     THEN 4   WHEN 'ALTER_TABLE'      THEN 6 WHEN 'ALTER_TRIGGER'    THEN 4
           WHEN 'ALTER_VIEW'       THEN 3   WHEN 'CREATE_FUNCTION'  THEN 4  WHEN 'CREATE_PROCEDURE' THEN 4  WHEN 'CREATE_SCHEMA'    THEN 5 WHEN 'CREATE_TABLE'     THEN 6
           WHEN 'CREATE_TRIGGER'   THEN 4   WHEN 'CREATE_VIEW'      THEN 3  WHEN 'DROP_FUNCTION'    THEN 2  WHEN 'DROP_PROCEDURE'   THEN 2   WHEN 'DROP_SCHEMA'      THEN 3
           WHEN 'DROP_TABLE'       THEN 4 WHEN 'DROP_TRIGGER'     THEN 2  WHEN 'DROP_VIEW'        THEN 2  ELSE 1 END AS tiempo_Total_Resolución_Horas,
    'Evento captura por el esquema auditable de la base de datos' as observacion,'Fabricio Ramos' as aprobado_por,cast(a.EventDate as date) as fecha_cierre,
       ROW_NUMBER() OVER (PARTITION BY cast(a.EventDate as date),a.EventDetails ORDER BY a.EventDate) AS rn, a.EventDate
from aud.AuditSchemaChanges a) as d
where d.rn = 1
order by d.EventDate

select distinct EventType from  aud.AuditSchemaChanges a

select * from aud.AuditColumnChanges

select * from aca.tipo_ingreso_estudiante

select * from aca.tipo_estado_estudiante


-- ALTER SCHEMA tmp TRANSFER dbo.codigo_postal
select * from tmp.CASOS_ESPECIALES_NIV

select * from aca.tipo_documento

select * from man.documentos_ubicacion

select * from man.documentos_archivos

select * from aca.institucion

--OBTENER REFERENCIAS AL OBJETO
begin
    DECLARE @ObjectName NVARCHAR(255) = 'periodo_academico_oferta'; -- Especifica el nombre del objeto
    DECLARE @SchemaName NVARCHAR(255) = 'aca'; -- Especifica el esquema al que pertenece el objeto

    SELECT
        referencing_schema.name AS EsquemaReferenciador,
        referencing_obj.name AS ObjetoReferenciador,
        referencing_obj.type_desc AS TipoObjetoReferenciador,
        referenced_schema.name AS EsquemaReferenciado,
        referenced_obj.name AS ObjetoReferenciado,
        referenced_obj.type_desc AS TipoObjetoReferenciado
    FROM
        sys.sql_expression_dependencies d
            JOIN
        sys.objects referencing_obj ON d.referencing_id = referencing_obj.object_id
            JOIN
        sys.schemas referencing_schema ON referencing_obj.schema_id = referencing_schema.schema_id
            JOIN
        sys.objects referenced_obj ON d.referenced_id = referenced_obj.object_id
            JOIN
        sys.schemas referenced_schema ON referenced_obj.schema_id = referenced_schema.schema_id
    WHERE
        referenced_obj.name = @ObjectName
      AND (referenced_schema.name = @SchemaName or @SchemaName is null)
    ORDER BY
        EsquemaReferenciador, ObjetoReferenciador;
end

--buscar usos de campos
begin
--     DECLARE @ColumnName NVARCHAR(128) = 'es_general';
--     DECLARE @TableName NVARCHAR(128) = 'pro.docente_categoria_evaluacion';
    DECLARE @ColumnName NVARCHAR(128) = 'cupo_nivelacion';
    DECLARE @TableName NVARCHAR(128) = 'periodo_academico_oferta';
    DECLARE @SearchTerm NVARCHAR(256) = '%' + @ColumnName + '%';

-- Buscar en procedimientos almacenados y funciones
    SELECT
        ROUTINE_TYPE AS ObjectType,
        ROUTINE_NAME AS ObjectName,
        ROUTINE_DEFINITION AS ObjectDefinition
    FROM
        INFORMATION_SCHEMA.ROUTINES
    WHERE
        ROUTINE_DEFINITION LIKE @SearchTerm
      AND ROUTINE_DEFINITION LIKE '%' + @TableName + '%'
      AND ROUTINE_DEFINITION NOT LIKE '%sys.%'

    UNION ALL

-- Buscar en vistas
    SELECT
        'VIEW' AS ObjectType,
        TABLE_NAME AS ObjectName,
        VIEW_DEFINITION AS ObjectDefinition
    FROM
        INFORMATION_SCHEMA.VIEWS
    WHERE
        VIEW_DEFINITION LIKE @SearchTerm
      AND VIEW_DEFINITION LIKE '%' + @TableName + '%'
      AND VIEW_DEFINITION NOT LIKE '%sys.%'

    UNION ALL

-- Buscar en triggers
    SELECT
        'TRIGGER' AS ObjectType,
        t.name AS ObjectName,
        m.definition AS ObjectDefinition
    FROM
        sys.triggers t
            JOIN
        sys.sql_modules m ON t.object_id = m.object_id
    WHERE
        m.definition LIKE @SearchTerm
      AND m.definition LIKE '%' + @TableName + '%'
      AND m.definition NOT LIKE '%sys.%';

end


select * from man.idioma

-- ALTER SCHEMA man TRANSFER hdv.idioma

--buscar las relaciones de una tabla con otras tablas
SELECT
    fk.name AS ForeignKeyName,
    SCHEMA_NAME(o1.schema_id) AS EsquemaOrigen,
    OBJECT_NAME(fk.parent_object_id) AS TablaOrigen,
    c1.name AS ColumnaOrigen,
    SCHEMA_NAME(o2.schema_id) AS EsquemaDestino,
    OBJECT_NAME(fk.referenced_object_id) AS TablaDestino,
    c2.name AS ColumnaDestino,

concat('select * from ' ,SCHEMA_NAME(o1.schema_id),'.',OBJECT_NAME(fk.parent_object_id),' where ',c1.name,' in (157,166,167,168,169,170,171,172,173)')
FROM sys.foreign_keys fk
         INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
         INNER JOIN sys.columns c1 ON fkc.parent_object_id = c1.object_id AND fkc.parent_column_id = c1.column_id
         INNER JOIN sys.columns c2 ON fkc.referenced_object_id = c2.object_id AND fkc.referenced_column_id = c2.column_id
         INNER JOIN sys.objects o1 ON o1.object_id = fk.parent_object_id
         INNER JOIN sys.objects o2 ON o2.object_id = fk.referenced_object_id
WHERE OBJECT_NAME(fk.referenced_object_id) = 'oferta';


select * from man.informacion_academica_persona where id_institucion in (811,1768)
select * from rlx.convenio_institucion where id_institucion in (811,1768)
select * from aca.institucion_nivel_formacion where id_institucion in (811,1768)
--ver las relaciones con los foreigns keys
SELECT
    fk.name AS ForeignKeyName,
    SCHEMA_NAME(o1.schema_id) AS EsquemaOrigen,
    OBJECT_NAME(fk.parent_object_id) AS TablaOrigen,
    c1.name AS ColumnaOrigen,
    SCHEMA_NAME(o2.schema_id) AS EsquemaDestino,
    OBJECT_NAME(fk.referenced_object_id) AS TablaDestino,
    c2.name AS ColumnaDestino,

    concat('select * from ' ,SCHEMA_NAME(o1.schema_id),'.',OBJECT_NAME(fk.parent_object_id),' where ',c1.name,' in (157,166,167,168,169,170,171,172,173)')
FROM sys.foreign_keys fk
         INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
         INNER JOIN sys.columns c1 ON fkc.parent_object_id = c1.object_id AND fkc.parent_column_id = c1.column_id
         INNER JOIN sys.columns c2 ON fkc.referenced_object_id = c2.object_id AND fkc.referenced_column_id = c2.column_id
         INNER JOIN sys.objects o1 ON o1.object_id = fk.parent_object_id
         INNER JOIN sys.objects o2 ON o2.object_id = fk.referenced_object_id
WHERE OBJECT_NAME(fk.referenced_object_id) = 'oferta';

select * from aca.oferta_traduccion where id_oferta_traduccion in (8,9)

