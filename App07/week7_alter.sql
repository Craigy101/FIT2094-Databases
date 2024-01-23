spool week7_alter_soln_output.txt
set echo on

/*
Databases Week 7 Applied Class Sample Solution
week7_alter_soln.sql

Databases units
Author: FIT Database Teaching Team
License: Copyright Monash University, unless otherwise stated. All Rights Reserved.
COPYRIGHT WARNING
Warning
This material is protected by copyright. For use within Monash University only. NOT FOR RESALE.
Do not remove this notice. 
*/

-- 7.3
-- 1. Changing a tables structure
-- ================================================================

ALTER TABLE unit ADD (
    unit_credit_points NUMBER(2, 0) DEFAULT 6 NOT NULL,
    constraint chk_unitcreditpoints check (unit_credit_points in (3,6,12))
);

COMMENT ON COLUMN unit.unit_credit_points IS
    'Unit credit points';

DESC unit;

-- 2. Changing a database structure
-- ================================================================
-- drop table statements
DROP TABLE course CASCADE CONSTRAINTS PURGE;

DROP TABLE course_unit CASCADE CONSTRAINTS PURGE;

-- adding COURSE table
CREATE TABLE course (
    course_code        CHAR(5) NOT NULL,
    course_name        VARCHAR2(30) NOT NULL,
    course_totalpoints NUMBER(3) NOT NULL
);

COMMENT ON COLUMN course.course_code IS
    'Course code';

COMMENT ON COLUMN course.course_name IS
    'Course name';

COMMENT ON COLUMN course.course_totalpoints IS
    'Course total credit points';

ALTER TABLE course ADD CONSTRAINT course_pk PRIMARY KEY ( course_code );

-- adding COURSE_UNIT table

CREATE TABLE course_unit (
    course_code CHAR(5) NOT NULL,
    unit_code   CHAR(7) NOT NULL
);

COMMENT ON COLUMN course_unit.course_code IS
    'Course code';

COMMENT ON COLUMN course_unit.unit_code IS
    'Unit code';

ALTER TABLE course_unit ADD CONSTRAINT course_unit_pk PRIMARY KEY ( course_code,
                                                                    unit_code );

-- adding FKs

ALTER TABLE course_unit
    ADD CONSTRAINT course_courseunit_fk FOREIGN KEY ( course_code )
        REFERENCES course ( course_code );

ALTER TABLE course_unit
    ADD CONSTRAINT unit_courseunit_fk FOREIGN KEY ( unit_code )
        REFERENCES unit ( unit_code );

DESC course;
DESC course_unit;

spool off
set echo off