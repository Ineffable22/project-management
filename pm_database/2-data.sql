USE project_management;

INSERT INTO companies (`id`, `ruc`, `name`, `tradename`, `address`, `create_at`, `create_by`, `update_at`, `update_by`)
VALUES
(1, '20100202396', 'AUTRISA AUTOMOTRIZ ANDINA S.A.', 'AUTRISA', 'AV. PARRA NRO. 122 URB. VALLECITO', CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL),
(2, '20455307954', 'AUTOMOTRIZ INCAMOTORS S.A.C.', 'INCAMOTORS', 'AV. PARRA NRO. 122', CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL),
(3, '20601818672', 'CONCESIONARIA NOVA AUTOS S.A.C.', 'NOVA AUTOS', 'VAR. UCHUMAYO 4.5 LAT. 2 LT. 695 ALTO EL CURAL SECC. E', CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL);

INSERT INTO roles (`id`, `name`, `description`, `is_active`, `create_at`, `create_by`, `update_at`, `update_by`)
VALUES
(1, 'SOLICITANTE', NULL, 1, CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL),
(2, 'GERENCIA DE TI', NULL, 1, CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL),
(3, 'GERENCIA GENERAL', NULL, 1, CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL),
(4, 'AGENTE', NULL, 1, CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL),
(5, 'JEFE DE PROYECTO', NULL, 1, CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL);


--* Tablas *--
INSERT INTO tables (`table`, `code`, `name`, `alias`, `description`, `is_active`, `create_at`, `create_by`, `update_at`, `update_by`)
VALUES
(1, 1, 'Tablas', 'TAB', 'Tablas generales', 1, CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL),
(1, 2, 'Solicitudes', 'TYP', 'Tablas de solicitudes', 1, CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL),
(1, 3, 'Estados', 'STA', 'Tablas de estados', 1, CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL),
(1, 4, 'Prioridades', 'PRI', 'Tablas de prioridades', 1, CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL);

--* Solicitudes *--
INSERT INTO tables (`table`, `code`, `name`, `alias`, `description`, `is_active`, `create_at`, `create_by`, `update_at`, `update_by`)
VALUES
(2, 1, 'Requerimiento', 'REQ', NULL, 1, CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL),
(2, 2, 'Proyectos', 'PRO', NULL, 1, CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL);

--* Estados *--
INSERT INTO tables (`table`, `code`, `name`, `alias`, `description`, `is_active`, `create_at`, `create_by`, `update_at`, `update_by`)
VALUES
(3, 1, 'Solicitado', 'SLC', NULL, 1, CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL);

--* Prioridades *--
INSERT INTO tables (`table`, `code`, `name`, `alias`, `description`, `is_active`, `create_at`, `create_by`, `update_at`, `update_by`)
VALUES
(3, 1, 'Baja', 'BAJ', NULL, 1, CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL),
(3, 1, 'Normal', 'NOR', NULL, 1, CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL),
(3, 1, 'Alta', 'ALT', NULL, 1, CURRENT_TIMESTAMP(), 'preloaded.data', NULL, NULL);
