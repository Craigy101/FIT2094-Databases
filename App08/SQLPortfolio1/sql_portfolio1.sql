--Comment out SET ECHO and SPOOL commands before submitting your portfolio
/*
SET ECHO ON
SPOOL sql_portfolio1_output.txt
*/

--sql_portfolio1.sql

--Student ID: 30613043
--Student Name: Grant Fullston
--Unit Code: FIT2094
--Applied Class No: A09 


/*Task 1: CREATE table POLICY and non FK constraints*/
DROP TABLE policy CASCADE CONSTRAINTS PURGE;

CREATE TABLE policy (
    policy_id      NUMBER(7) NOT NULL,
    prop_no        NUMBER(4) NOT NULL,
    policy_startdate DATE NOT NULL,
    policy_type_code CHAR(1) NOT NULL,
    policy_length NUMBER(3) NOT NULL,
    insurer_code CHAR(3) NOT NULL,
    
    /*Set the unique contents of the surrogate key being the tuple of these 3 attributes*/
    CONSTRAINT policy_uq UNIQUE ( prop_no, policy_startdate, policy_type_code )
);

    /*Set the surrogate key as the primary key*/
ALTER TABLE policy ADD CONSTRAINT policyr_pk PRIMARY KEY ( policy_id );

COMMENT ON COLUMN policy.policy_id IS
    'Unique identifier for policy';
    
COMMENT ON COLUMN policy.prop_no IS
    'Unique 4 digit identifier property number';
    
COMMENT ON COLUMN policy.policy_startdate IS
    'Unique policy start date';

COMMENT ON COLUMN policy.policy_type_code IS
    'Type of policy unique code';

COMMENT ON COLUMN policy.policy_length IS
    'policy length';

COMMENT ON COLUMN policy.insurer_code IS
    'unique insurer code';
    
    
/*Task 1: Add FK constraints*/
/* Default on delete being no action for foreign keys means we don't need to specify*/

ALTER TABLE policy
    ADD CONSTRAINT property_number FOREIGN KEY ( prop_no )
        REFERENCES property ( prop_no ) ;
    
ALTER TABLE policy
    ADD CONSTRAINT policy_type_code FOREIGN KEY ( policy_type_code )
         REFERENCES policy_type ( policy_type_code ) ;

ALTER TABLE policy
    ADD CONSTRAINT insuer_code FOREIGN KEY ( insurer_code )
        REFERENCES insurer ( insurer_code ) ;

/*Commit often before inserts so that there is access to the table for other users*/
commit; 


/*Task 2*/

DROP SEQUENCE policy_seq;

/* Start a sequence at 1 since this is a new inception of the policy*/
CREATE SEQUENCE policy_seq START WITH 1 INCREMENT BY 1;

/*Insert given data*/
INSERT INTO policy VALUES (
    policy_seq.NEXTVAL,
    7145,
    to_date('21-Apr-2023','dd-Mon-yyyy'),
    (
        SELECT
            policy_type_code
        FROM
            policy_type
        WHERE
            upper(policy_type_desc) = upper('Building')
    ),
    12,
    (
        SELECT
            insurer_code
        FROM
            insurer
        WHERE
            upper(insurer_name) = upper('Landlord Association')
    ) 
);

/*Insert given data*/
INSERT INTO policy VALUES (
    policy_seq.NEXTVAL,
    9346,
    to_date('21-Apr-2023','dd-Mon-yyyy'),
    (
        SELECT
            policy_type_code
        FROM
            policy_type
        WHERE
            upper(policy_type_desc) = upper('Building')
    ),
    12,
    (
        SELECT
            insurer_code
        FROM
            insurer
        WHERE
            upper(insurer_name) = upper('Landlord Association')
    ) 
);

commit; /*Commit often, this marks one transaction*/

/*Task 3*/

UPDATE policy
SET
    policy_length = policy_length + 6
WHERE
    prop_no = 7145
    AND
    to_date('21-Apr-2023','dd-Mon-yyyy')= policy_startdate
    AND
    (
        SELECT
            policy_type_code
        FROM
            policy_type
        WHERE
            upper(policy_type_desc) = upper('Building')
    ) = policy_type_code;

INSERT INTO policy VALUES (
    policy_seq.NEXTVAL,
    7145,
    to_date('01-May-2023','dd-Mon-yyyy'),
    (
        SELECT
            policy_type_code
        FROM
            policy_type
        WHERE
            upper(policy_type_desc) = upper('Contents')
    ),
    12,
    (
        SELECT
            insurer_code
        FROM
            insurer
        WHERE
            upper(insurer_name) = upper('Landlord Association')
    ) 
);  
commit; /*Commit often, this marks one transaction*/
    

/*Task 4*/
DELETE FROM policy
WHERE
    prop_no = 7145
    AND
    to_date('01-May-2023','dd-Mon-yyyy')= policy_startdate
    AND
    (
        SELECT
            policy_type_code
        FROM
            policy_type
        WHERE
            upper(policy_type_desc) = upper('Contents')
    ) = policy_type_code;

UPDATE policy
SET
    policy_length = policy_length - 6
WHERE
    prop_no = 7145
    AND
    to_date('21-Apr-2023','dd-Mon-yyyy')= policy_startdate
    AND
    (
        SELECT
            policy_type_code
        FROM
            policy_type
        WHERE
            upper(policy_type_desc) = upper('Building')
    ) = policy_type_code;

commit; /*Commit often, this marks one transaction*/

--Comment out SET ECHO and SPOOL commands before submitting your portfolio
/*
SPOOL OFF
SET ECHO OFF*/