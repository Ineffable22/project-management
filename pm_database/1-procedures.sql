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

DROP PROCEDURE IF EXISTS users_one;
-- =========================================================
-- Autor - Fecha Crea  : Cristhian Apaza - 2022-06-05
-- Descripcion         : select a record from the table
-- Autor - Fecha Modif :
-- Descripcion         :
-- =========================================================
DELIMITER $$
CREATE PROCEDURE users_one
( IN pbigid bigint )
BEGIN

    SELECT id , company_id , role_id , name
        , lastname , email , user , password
        , gender , position , department , campus
        , create_at , create_by , update_at , update_by
     FROM users
    WHERE id = pbigid;

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
( INOUT pbigproject_id bigint
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
        project_id = pbigproject_id;

    -- * User * --
    SELECT user INTO pvchcreate_by
    FROM users
    WHERE
        id = pbiguser_id;

    -- * Insert event * --
    INSERT INTO requests_events
        ( project_id , item , table_sta , code_sta
        , date_issue , user_id , create_at , create_by
        , update_at , update_by)
    VALUES
        ( pbigproject_id , pintitem , pinttable_sta , pintcode_sta
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
	id = pbigproject_id;

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
    DECLARE vvch_alias VARCHAR;
    SELECT `alias` INTO vvch_alias
    FROM tables
    WHERE
	`table` = pinttable_typ AND
	code = pintcode_typ;
	
    SELECT CONCAT(vvch_alias, CONVERT(YEAR(pdtmdate_issue), char), '-',
            IF( COUNT(id),
                LPAD(CONVERT(COUNT(id), char), 7, '0'),
                '0000000')) INTO pvchcode
    FROM requests r
    INNER JOIN tables t ON r.table_typ = t.table AND r.code_typ = t.code
        WHERE
        table_typ = pinttable_typ AND
        code_typ = pintcode_typ;

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
