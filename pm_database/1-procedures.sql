USE project_management;

DROP PROCEDURE IF EXISTS users_login;
-- =========================================================
-- Autor - Fecha Crea  : Cristhian Apaza - 2022-06-05
-- Descripcion         : select a record from the table
-- Autor - Fecha Modif :
-- Descripcion         :
-- =========================================================
DELIMITER $$
CREATE PROCEDURE users_login
( IN pvchuserr varchar(50)
, IN pvchpassword varchar(50) )
BEGIN

    DECLARE v_user_id, v_role_id bigint;
    SELECT id, role_id INTO v_user_id, v_role_id
    FROM users
    WHERE
        user = pvchuserr AND
        password = pvchpassword;

    -- Info user.
    SELECT id , company_id , role_id , name
        , lastname , email , user , password
        , gender , position , department , campus
    FROM users
    WHERE
        id = v_user_id;

    -- Info role.
    SELECT id , name , description , is_active
    FROM roles
    WHERE id = v_role_id;

    -- Info options.
    SELECT opt.id , opt.name , opt.alias , opt.description, rop.is_active
    FROM options opt
    INNER JOIN roles_options rop ON opt.id = rop.option_id
    WHERE
        rop.role_id = v_role_id AND
        rop.is_active = 1;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS users_one;
-- =========================================================
-- Autor - Fecha Crea  : Cristhian Apaza - 2022-06-21
-- Descripcion         : select a record from the table
-- Autor - Fecha Modif :
-- Descripcion         :
-- =========================================================
DELIMITER $$
CREATE PROCEDURE users_one
( IN pbigid bigint )
BEGIN

    DECLARE v_role_id bigint;
    SELECT role_id INTO v_role_id
    FROM users
    WHERE
        id = pbigid;

    -- Info user.
    SELECT id , company_id , role_id , name
        , lastname , email , user , password
        , gender , position , department , campus
    FROM users
    WHERE
        id = pbigid;

    -- Info role.
    SELECT id , name , description , is_active
    FROM roles
    WHERE id = v_role_id;

    -- Info options.
    SELECT opt.id , opt.name , opt.alias , opt.description, rop.is_active
    FROM options opt
    INNER JOIN roles_options rop ON opt.id = rop.option_id
    WHERE
        rop.role_id = v_role_id AND
        rop.is_active = 1;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS users_all;
-- =========================================================
-- Autor - Fecha Crea  : Cristhian Apaza - 2022-06-05
-- Descripcion         : Select all table
-- Autor - Fecha Modif :
-- Descripcion         :
-- =========================================================
DELIMITER $$
CREATE PROCEDURE users_all()
BEGIN

    SELECT
          id , company_id , role_id , name
        , lastname , email , user , password
        , gender , position , department , campus
        , create_at , create_by , update_at , update_by
    FROM users;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS users_insert;
-- =========================================================
-- Autor - Fecha Crea  : Cristhian Apaza - 2022-06-05
-- Descripcion         : Insert new record from the table
-- Autor - Fecha Modif :
-- Descripcion         :
-- =========================================================
DELIMITER $$
CREATE PROCEDURE users_insert
( INOUT pbigid bigint
, IN pbigcompany_id bigint
, IN pbigrole_id bigint
, IN pvchname varchar(50)
, IN pvchlastname varchar(50)
, IN pvchemail varchar(50)
, IN pvchuserr varchar(50)
, IN pvchpassword varchar(50)
, IN pchrgender char(1)
, IN pvchposition varchar(50)
, IN pvchdepartment varchar(50)
, IN pvchcampus varchar(50)
, IN pdtmcreate_at datetime
, IN pvchcreate_by varchar(50)
, IN pdtmupdate_at datetime
, IN pvchupdate_by varchar(50) )
BEGIN

    INSERT INTO users
        ( id , company_id , role_id , name
        , lastname , email , userr , password
        , gender , position , department , campus
        , create_at , create_by , update_at , update_by)
    VALUES
        ( pbigid , pbigcompany_id , pbigrole_id , pvchname
        , pvchlastname , pvchemail , pvchuserr , pvchpassword
        , pchrgender , pvchposition , pvchdepartment , pvchcampus
        , pdtmcreate_at , pvchcreate_by , pdtmupdate_at , pvchupdate_by);
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS users_update;
-- =========================================================
-- Autor - Fecha Crea  : Cristhian Apaza - 2022-06-05
-- Descripcion         : Update record from the table
-- Autor - Fecha Modif :
-- Descripcion         :
-- =========================================================
DELIMITER $$
CREATE PROCEDURE users_update
( IN pbigid bigint
, IN pbigcompany_id bigint
, IN pbigrole_id bigint
, IN pvchname varchar(50)
, IN pvchlastname varchar(50)
, IN pvchemail varchar(50)
, IN pvchuserr varchar(50)
, IN pvchpassword varchar(50)
, IN pchrgender char(1)
, IN pvchposition varchar(50)
, IN pvchdepartment varchar(50)
, IN pvchcampus varchar(50)
, IN pdtmcreate_at datetime
, IN pvchcreate_by varchar(50)
, IN pdtmupdate_at datetime
, IN pvchupdate_by varchar(50) )
BEGIN

    UPDATE users
      SET company_id = pbigcompany_id
        , role_id = pbigrole_id
        , name = pvchname
        , lastname = pvchlastname
        , email = pvchemail
        , userr = pvchuserr
        , password = pvchpassword
        , gender = pchrgender
        , position = pvchposition
        , department = pvchdepartment
        , campus = pvchcampus
        , update_at = pdtmupdate_at
        , update_by = pvchupdate_by
    WHERE id = pbigid;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS requests_events_insert;
-- =========================================================
-- Autor - Fecha Crea  : Cristhian Apaza - 2022-06-11
-- Descripcion         : Update record from the table
-- Autor - Fecha Modif :
-- Descripcion         :
-- =========================================================
DELIMITER $$
CREATE PROCEDURE requests_events_insert
( INOUT pbigrequest_id bigint
, IN pintitem int
, IN pinttable_sta int
, IN pintcode_sta int
, IN pdtmdate_issue datetime
, IN pbiguser_id bigint
, IN pdtmcreate_at datetime
, IN pvchcreate_by varchar(50)
, IN pdtmupdate_at datetime
, IN pvchupdate_by varchar(50) )
BEGIN

    -- * Correlative * --
    SELECT IF(ISNULL(MAX(item)), 1, MAX(item) + 1)  INTO pintitem
    FROM requests_events
    WHERE
        request_id = pbigrequest_id;

    -- * User * --
    SELECT user INTO pvchcreate_by
    FROM users
    WHERE
        id = pbiguser_id;

    -- * Insert event * --
    INSERT INTO requests_events
        ( request_id , item , table_sta , code_sta
        , date_issue , user_id , create_at , create_by
        , update_at , update_by)
    VALUES
        ( pbigrequest_id , pintitem , pinttable_sta , pintcode_sta
        , pdtmdate_issue , pbiguser_id , CURRENT_TIMESTAMP() , pvchcreate_by
        , NULL , NULL);

    -- * Update Request * --
    UPDATE requests
        SET
          table_sta = pinttable_sta
        , code_sta = pintcode_sta
        , update_at = CURRENT_TIMESTAMP()
        , update_by = pvchcreate_by
    WHERE
	id = pbigrequest_id;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS requests_insert;
-- =========================================================
-- Autor - Fecha Crea  : Cristhian Apaza - 2022-06-11
-- Descripcion         : Update record from the table
-- Autor - Fecha Modif :
-- Descripcion         :
-- =========================================================
DELIMITER $$
CREATE PROCEDURE requests_insert
( INOUT pbigid bigint
, IN pinttable_typ int
, IN pintcode_typ int
, IN pvchcode varchar(50)
, IN pbigcompany_id bigint
, IN pbiguser_id bigint
, IN pvchsubject varchar(50)
, IN pvchreason varchar(250)
, IN pvchname varchar(50)
, IN pvchdescription varchar(250)
, IN pvchdepartment varchar(50)
, IN pvchcampus varchar(50)
, IN pdtmdate_issue datetime
, IN pdtmdate_tentative datetime
, IN pinttable_sta int
, IN pintcode_sta int
, IN pinttable_pri int
, IN pintcode_pri int
, IN pdecpercentage decimal(5, 2)
, IN pdtmcreate_at datetime
, IN pvchcreate_by varchar(50)
, IN pdtmupdate_at datetime
, IN pvchupdate_by varchar(50) )
BEGIN

    -- * Correlative * --
    SELECT IF(ISNULL(MAX(id)), 1, MAX(id) + 1)  INTO pbigid
    FROM requests;

    -- * User * --
    SELECT company_id, department, campus, user INTO pbigcompany_id, pvchdepartment, pvchcampus, pvchcreate_by
    FROM users
    WHERE
        id = pbiguser_id;

    -- * State * --
    SELECT `table`, `code` INTO pinttable_sta, pintcode_sta
    FROM tables
    WHERE
        `table` = 3 AND
        `alias` = 'SOL';

    -- * Insert request * --
    INSERT INTO requests
        ( id , table_typ , code_typ , code
        , company_id , user_id , subject , reason
        , name , description , department , campus
        , date_issue , date_tentative , table_sta , code_sta
        , table_pri , code_pri , percentage , create_at
        , create_by , update_at , update_by)
    VALUES
        ( pbigid , pinttable_typ , pintcode_typ , pvchcode
        , pbigcompany_id , pbiguser_id , pvchsubject , pvchreason
        , pvchname , pvchdescription , pvchdepartment , pvchcampus
        , pdtmdate_issue , pdtmdate_tentative , pinttable_sta , pintcode_sta
        , pinttable_pri , pintcode_pri , pdecpercentage , CURRENT_TIMESTAMP()
        , pvchcreate_by , NULL , NULL);

    -- * Insert event * --
    call requests_events_insert
        ( pbigid
        , NULL
        , pinttable_sta
        , pintcode_sta
        , pdtmdate_issue
        , pbiguser_id
        , pdtmcreate_at
        , pvchcreate_by
        , NULL
        , NULL);

    -- * Recovery Item * --
    call requests_one
    	 ( pbigid
	 , 0);

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS requests_update;
-- =========================================================
-- Autor - Fecha Crea  : Cristhian Apaza - 2022-06-12
-- Descripcion         : Update record from the table
-- Autor - Fecha Modif :
-- Descripcion         :
-- =========================================================
DELIMITER $$
CREATE PROCEDURE requests_update
( IN pbigid bigint
, IN pinttable_typ int
, IN pintcode_typ int
, IN pvchcode varchar(50)
, IN pbigcompany_id bigint
, IN pbiguser_id bigint
, IN pvchsubject varchar(50)
, IN pvchreason varchar(250)
, IN pvchname varchar(50)
, IN pvchdescription varchar(250)
, IN pvchdepartment varchar(50)
, IN pvchcampus varchar(50)
, IN pdtmdate_issue datetime
, IN pdtmdate_tentative datetime
, IN pinttable_sta int
, IN pintcode_sta int
, IN pinttable_pri int
, IN pintcode_pri int
, IN pdecpercentage decimal(5, 2)
, IN pdtmcreate_at datetime
, IN pvchcreate_by varchar(50)
, IN pdtmupdate_at datetime
, IN pvchupdate_by varchar(50) )
BEGIN

    DECLARE v_alias_typ char(3);

    -- * User * --
    SELECT user INTO pvchupdate_by
    FROM users
    WHERE
        id = pbiguser_id;

    -- * State * --
    SELECT `table`, `code` INTO pinttable_sta, pintcode_sta
    FROM tables
    WHERE
        `table` = 3 AND
        `alias` = 'CON';

    -- * Code correlative * --
    SELECT `alias` INTO v_alias_typ
    FROM tables
    WHERE
	    `table` = pinttable_typ AND
	    code = pintcode_typ;

    -- ?SELECT v_alias_typ;

    SELECT CONCAT(v_alias_typ, CONVERT(YEAR(pdtmdate_issue), char), '-', LPAD(CONVERT(COUNT(id), char), 7, '0')) INTO pvchcode
    FROM requests r
    INNER JOIN tables t ON r.table_typ = t.table AND r.code_typ = t.code
    WHERE
        table_typ = pinttable_typ AND
        code_typ = pintcode_typ;

    -- ?SELECT pvchcode;
    -- * Update request * --
    UPDATE requests
        SET
          table_typ = pinttable_typ
        , code_typ = pintcode_typ
        , code = pvchcode
        , name = pvchname
        , description = pvchdescription
        , date_tentative = pdtmdate_tentative
        , table_pri = pinttable_pri
        , code_pri = pintcode_pri
        , update_at = CURRENT_TIMESTAMP()
        , update_by = pvchupdate_by
    WHERE
        id = pbigid;

    -- * Insert event * --
    call requests_events_insert
        ( pbigid
        , NULL
        , pinttable_sta
        , pintcode_sta
        , pdtmdate_issue
        , pbiguser_id
        , pdtmupdate_at
        , pvchupdate_by
        , NULL
        , NULL);

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS requests_all;
-- =========================================================
-- Autor - Fecha Crea  : Cristhian Apaza - 2022-06-13
-- Descripcion         : Update record from the table
-- Autor - Fecha Modif :
-- Descripcion         :
-- =========================================================
DELIMITER $$
CREATE PROCEDURE requests_all
( IN pdtmdate_begin datetime
, IN pdtmdate_end datetime
, IN pbigcompany_id bigint
, IN pvchdepartment varchar(50)
)
BEGIN

    SELECT
          r.id , r.table_typ , r.code_typ
        , IF(r.code = '', CONCAT('SOL', CONVERT(YEAR(r.date_issue), char), '-', LPAD(CONVERT(r.id, char), 7, '0')), r.code) as code
        , r.company_id , r.user_id , r.subject , r.reason
        , IFNULL(r.name, r.subject) as name , r.description , r.department , r.campus
        , r.date_issue , r.date_tentative , r.table_sta , r.code_sta
        , r.table_pri , r.code_pri , r.percentage
        , typ.name as name_typ, sta.name as name_sta, pri.name as name_pri
        , com.name as company_name, com.tradename as company_tradename
	, usr.name as user_name, usr.lastname as user_lastname
	, CONCAT(usr.name, ' ', usr.lastname) as user_fullname
        , r.create_at, r.create_by , r.update_at , r.update_by
    FROM requests r
    LEFT JOIN tables typ ON r.table_typ = typ.table AND r.code_typ = typ.code
    LEFT JOIN tables sta ON r.table_sta = sta.table AND r.code_sta = sta.code
    LEFT JOIN tables pri ON r.table_pri = pri.table AND r.code_pri = pri.code
    LEFT JOIN companies com ON r.company_id = com.id
    LEFT JOIN users usr ON r.user_id = usr.id
    WHERE
        CONVERT(r.date_issue, date) BETWEEN CONVERT(pdtmdate_begin, date) AND CONVERT(pdtmdate_end, date) AND
        r.company_id = IFNULL(pbigcompany_id, r.company_id) AND
        r.department = IFNULL(pvchdepartment, r.department)
    ORDER BY r.id desc;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS requests_one;
-- =========================================================
-- Autor - Fecha Crea  : Cristhian Apaza - 2022-06-13
-- Descripcion         : Update record from the table
-- Autor - Fecha Modif :
-- Descripcion         :
-- =========================================================
DELIMITER $$
CREATE PROCEDURE requests_one
( IN pbigid bigint
, IN pbitdetails bit)
BEGIN

    SELECT
          r.id , r.table_typ , r.code_typ
	, IF(r.code = '', CONCAT('SOL', CONVERT(YEAR(r.date_issue), char), '-', LPAD(CONVERT(r.id, char), 7, '0')), r.code) as code
        , r.company_id , r.user_id , r.subject , r.reason
        , IFNULL(r.name, r.subject) as name , r.description , r.department , r.campus
        , r.date_issue , r.date_tentative , r.table_sta , r.code_sta
        , r.table_pri , r.code_pri , r.percentage
        , typ.name as name_typ, sta.name as name_sta, pri.name as name_pri
	, com.name as company_name, com.tradename as company_tradename
	, usr.name as user_name, usr.lastname as user_lastname
	, CONCAT(usr.name, ' ', usr.lastname) as user_fullname
        , r.create_at, r.create_by , r.update_at , r.update_by
    FROM requests r
    LEFT JOIN tables typ ON r.table_typ = typ.table AND r.code_typ = typ.code
    LEFT JOIN tables sta ON r.table_sta = sta.table AND r.code_sta = sta.code
    LEFT JOIN tables pri ON r.table_pri = pri.table AND r.code_pri = pri.code
    LEFT JOIN companies com ON r.company_id = com.id
    LEFT JOIN users usr ON r.user_id = usr.id
    WHERE
        r.id = pbigid;

    IF (pbitdetails)
    THEN
        SELECT
              re.request_id , re.item , re.table_sta , re.code_sta
            , re.date_issue , re.user_id , sta.name as name_sta
            , re.create_at , re.create_by , re.update_at , re.update_by
        FROM requests_events re
        LEFT JOIN tables sta ON re.table_sta = sta.table AND re.code_sta = sta.code
        WHERE
            re.request_id = pbigid
        ORDER BY re.request_id desc, re.item desc;
    END IF;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS tables_all;
-- =========================================================
-- Autor - Fecha Crea  : Cristhian Apaza - 2022-06-15
-- Descripcion         : Select all table
-- Autor - Fecha Modif :
-- Descripcion         :
-- =========================================================
DELIMITER $$
CREATE PROCEDURE tables_all
( IN pinttable int
, IN pbitall bit )
BEGIN

    SELECT
          `table` , `code` , `name` , `alias`
        , `description` , `is_active`
        , `create_at` , `create_by` , `update_at` , `update_by`
    FROM tables
    WHERE
        `table` = IFNULL(pinttable, `table`) AND
        `is_active` = IF(pbitall, `is_active`, 1);

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS companies_all;
-- =========================================================
-- Autor - Fecha Crea  : Cristhian Apaza - 2022-06-15
-- Descripcion         : Select all companies
-- Autor - Fecha Modif :
-- Descripcion         :
-- =========================================================
DELIMITER $$
CREATE PROCEDURE companies_all ()
BEGIN

    SELECT
          id, ruc, name, tradename, address
        , create_at, create_by, update_at, update_by
    FROM companies;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS departments_all;
-- =========================================================
-- Autor - Fecha Crea  : Cristhian Apaza - 2022-06-15
-- Descripcion         : Select all departments
-- Autor - Fecha Modif :
-- Descripcion         :
-- =========================================================
DELIMITER $$
CREATE PROCEDURE departments_all
( IN pbigcompany_id bigint )
BEGIN

    SELECT DISTINCT
          u.company_id AS company_id
        , c.name AS company_name
        , u.department AS department
    FROM users u
    INNER JOIN companies c ON u.company_id = c.id
    WHERE
        u.company_id = IFNULL(pbigcompany_id, u.company_id);

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS requests_email;
-- =========================================================
-- Autor - Fecha Crea  : Cristhian Apaza - 2022-06-24
-- Descripcion         : Update record from the table
-- Autor - Fecha Modif :
-- Descripcion         :
-- =========================================================
DELIMITER $$
CREATE PROCEDURE requests_email
( IN pbigid bigint)
BEGIN

    DECLARE v_to_name , v_to_email varchar(100);

    -- * Part 1 * --
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_requests AS (
    SELECT
          re.id
        , CONCAT(us.name, ' ', us.lastname) as `to_name`
        , us.email as `to_email`
        , CONCAT('[',
            IF(re.code = '', CONCAT('SOL', CONVERT(YEAR(re.date_issue), char), '-', LPAD(CONVERT(re.id, char), 7, '0')), re.code)
            , ']', ' - Sistema de gestion de proyectos') as `subject`
        , CONCAT('Su ',
            IF(re.code = '', CONCAT('SOL', CONVERT(YEAR(re.date_issue), char), '-', LPAD(CONVERT(re.id, char), 7, '0')), re.code)
            , ' paso a estado de ') as `message`
        , 'www.localhost.com' as `url`
        , 'SMTP.Office365.com' as `host`
        , 587 as `port`
        , 'repuestos@autrisa.com' as `email`
        , 'R123456+' as `password`
    FROM requests re
    INNER JOIN users us ON re.user_id = us.id
    WHERE
        re.id = pbigid);

    -- * Part 2 * --
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_email AS (
    SELECT
          re.*
        , CONCAT(us.name, ' ', us.lastname) as `cc_name`
        , us.email as `cc_email`
        , CONCAT(re.message, sta.name, ' por ', re.to_name) as `text`
        , sta.alias as `alias`
    FROM requests_events rv
    INNER JOIN tmp_requests re ON re.id = rv.request_id
    INNER JOIN tables sta ON rv.table_sta = sta.table AND rv.code_sta = sta.code
    INNER JOIN users us ON rv.user_id = us.id
    ORDER BY
        rv.request_id desc, rv.item desc
    LIMIT 1);

    -- * Part 3 * --
    SELECT `to_name`, `to_email` INTO v_to_name, v_to_email FROM tmp_email;
    IF (EXISTS(SELECT `alias` FROM tmp_email WHERE `alias` = 'SOL'))
    THEN
        UPDATE tmp_email
        SET
          `to_name` = `cc_name`
        , `to_email` = `cc_email`
        , `cc_name` = v_to_name
        , `cc_email` = v_to_email
        , `text` = CONCAT('Tiene un nueva solicitud en el sistema de gestión de proyectos realizada por ', v_to_name);
    END IF;
    IF (EXISTS(SELECT `alias` FROM tmp_email WHERE `alias` = 'CON'))
    THEN
        UPDATE tmp_email
        SET
          `to_name` = 'Gerente' -- `cc_name`
        , `to_email` = 'cristhian.apaza@autrisa.com' -- `cc_email`
        , `cc_name` = v_to_name
        , `cc_email` = v_to_email
        , `text` = CONCAT('Tiene un nueva solicitud por aprobar en el sistema de gestión de proyectos realizada por ', v_to_name);
    END IF;

    -- * Part 4 * --
    SELECT * FROM tmp_email;
    DROP TEMPORARY TABLE IF EXISTS tmp_requests;
    DROP TEMPORARY TABLE IF EXISTS tmp_email;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS dashboard_all;
-- =========================================================
-- Autor - Fecha Crea  : Cristhian Apaza - 2022-06-24
-- Descripcion         : Update record from the table
-- Autor - Fecha Modif :
-- Descripcion         :
-- =========================================================
DELIMITER $$
CREATE PROCEDURE dashboard_all
( IN pintyear bigint
, IN pintmonth bigint)
BEGIN

    DECLARE v_total_request bigint;

    -- * Total * --
    SELECT COUNT(re.id) INTO v_total_request
    FROM requests re
    WHERE
        YEAR(re.date_issue) = pintyear AND
        MONTH(re.date_issue) = pintmonth;

    -- * Dashoard 1 * --
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_dashboard_1 AS (
    SELECT
          re.table_sta
        , re.code_sta
        , COUNT(re.table_sta) as number_sta
        , v_total_request as total
    FROM requests re
    GROUP BY
          re.table_sta
        , re.code_sta
    );

--    SELECT
 --         sta.table as `table_sta`
  --      , sta.code as `code_sta`
   --     , sta.name as `name_sta`
    --    , sta.description as `color_sta`
    --    , IFNULL()
   -- FROM tables sta
   -- LEFT JOIN tmp_dashboard_1 da ON da.table_sta = sta.table AND da.code_sta = sta.code


    -- -- * Requests * --
    -- SELECT
    --       cp.id as `company_id`
    --     , cp.tradename as `company`
    --     , (SELECT COUNT(id) FROM requests sre WHERE sre.code_typ IS NULL AND sre.company_id = re.company_id ) as `number_sol`
    --     , (SELECT COUNT(id) FROM requests sre WHERE sre.code_typ = 1 AND sre.company_id = re.company_id ) as `number_req`
    --     , (SELECT COUNT(id) FROM requests sre WHERE sre.code_typ = 2 AND sre.company_id = re.company_id ) as `number_pro`
    -- FROM companies cp
    -- LEFT JOIN tmp_requests re ON re.company_id = cp.id
    -- GROUP BY
    --       cp.id
    --     , cp.tradename;

    -- -- * Status by company * --
    -- SELECT
    --       cp.id as `company_id`
    --     , cp.tradename as `company_name`
    --     , sta.name as `name_sta`
    --     , COUNT(sta.name) as `number_sta`
    -- FROM companies cp
    -- LEFT JOIN tmp_requests re ON re.company_id = cp.id
    -- LEFT JOIN tables sta ON re.table_sta = sta.table AND re.code_sta = sta.code
    -- GROUP BY
    --       cp.id
    --     , cp.tradename
    --     , sta.name;

    -- * Finally * --
    -- DROP TEMPORARY TABLE IF EXISTS tmp_dashboard_1;

END $$
DELIMITER ;
