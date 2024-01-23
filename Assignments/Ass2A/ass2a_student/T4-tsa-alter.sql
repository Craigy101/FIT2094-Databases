--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T4-tsa-alter.sql

--Student ID: 30613043
--Student Name: Grant Fullston
--Unit Code: FIT2094
--Applied Class No: A09 

/* Comments for your marker:




*/

--4(a)

-- ADD TOTAL BOOKINGS COUNTER
ALTER TABLE cabin 
ADD cabin_tot_bookings NUMERIC(8) default 0 not null;

COMMENT ON COLUMN cabin.cabin_tot_bookings IS
    'total bookings no a cabin';

-- ADD THE COUNTER EITHER 0 OR COUNTT OF TOTAL BOOKINGS
UPDATE cabin
SET cabin_tot_bookings = CASE 
    WHEN 
    (select count(cabin_no) from booking
    where booking.resort_id = cabin.resort_id and booking.cabin_no = cabin.cabin_no
    group by resort_id, cabin_no) 
    
    IS NOT NULL 
    
    THEN 
    (select count(cabin_no) from booking
    where booking.resort_id = cabin.resort_id and booking.cabin_no = cabin.cabin_no
    group by resort_id, cabin_no) ELSE 0 END;

select * from cabin order by resort_id, cabin_no;
desc cabin;

commit;

--4(b)

-- CREEATEE A ROLE ENTITY AND ADD TO DB

DROP TABLE role CASCADE CONSTRAINTS PURGE;

CREATE TABLE role (
    role_id        CHAR(1) NOT NULL,
    role_name        VARCHAR(40) NOT NULL,
    job_desc        VARCHAR(250) NOT NULL
    );

COMMENT ON COLUMN role.role_id IS
    'Code for the role id';

COMMENT ON COLUMN role.role_name IS
    'Role title';

COMMENT ON COLUMN role.job_desc IS
    'Role Description';

ALTER TABLE role ADD CONSTRAINT role_pk PRIMARY KEY ( role_id );

Insert into role VALUES ('A', 'Admin', 'Take bookings, and reply to customer inquiries');
Insert into role VALUES ('C', 'Cleaning', 'Clean cabins and maintain resorts public area');
Insert into role VALUES ('M', 'Marketing', 'Prepare and present marketing ideas and deliverables');
commit;

ALTER TABLE staff 
ADD role_id CHAR(1) default 'A' NOT NULL;

COMMENT ON COLUMN staff.role_id IS
     'Code for the role id';

ALTER TABLE staff
    ADD CONSTRAINT staff_role FOREIGN KEY ( role_id )
        REFERENCES role ( role_id );

-- SHOW IT WORKING
select * from role; 
select * from staff;
select * from staff natural join role;

desc role; 
desc staff;


--4(c)

-- ADD CLEANER JOBS, AS MANY TO MANY, NEED A SEPERATEE ENTITY FOR 1 TO M BEING CLEANING_GROUP
DROP TABLE cleaning CASCADE CONSTRAINTS PURGE;

CREATE TABLE cleaning (
    cleaning_id     NUMERIC(10) NOT NULL,
    resort_id        NUMERIC(4) NOT NULL,
    cabin_no        NUMERIC(3) NOT NULL,
    cleaning_date        DATE NOT NULL,
    cleaning_start      DATE NOT NULL,
    cleaning_end           DATE NOT NULL
    );  

COMMENT ON COLUMN cleaning.cleaning_id IS
    'Code for the cleaning job number';

COMMENT ON COLUMN cleaning.resort_id IS
    'Resort is';

COMMENT ON COLUMN cleaning.cabin_no IS
    'Cabin number at the resort';
    
    COMMENT ON COLUMN cleaning.cleaning_date IS
    'Date the clean is scheduled for';

COMMENT ON COLUMN cleaning.cleaning_start IS
    'Start time of cleaning for payroll';

COMMENT ON COLUMN cleaning.cleaning_end IS
    'End time of clening for payroll';

    
ALTER TABLE cleaning ADD CONSTRAINT cleaning_pk PRIMARY KEY ( cleaning_id );

ALTER TABLE cleaning ADD CONSTRAINT cleaning_uniquek UNIQUE ( resort_id,
                                                      cabin_no, cleaning_date);

DROP TABLE cleaning_group CASCADE CONSTRAINTS PURGE;

CREATE TABLE cleaning_group (                                                      
    cleaning_id      NUMERIC(10) NOT NULL,
    staff_id        NUMERIC(5)
    );  

COMMENT ON COLUMN cleaning_group.cleaning_id IS
    'cleaning group id';

COMMENT ON COLUMN cleaning_group.staff_id IS
    'id of the staff member assigned';
    
ALTER TABLE cleaning_group ADD CONSTRAINT cleaning_group_pk PRIMARY KEY ( cleaning_id, staff_id);

ALTER TABLE cleaning_group
    ADD CONSTRAINT cleaninggroup_fk1  FOREIGN KEY ( cleaning_id )
        REFERENCES cleaning ( cleaning_id );

ALTER TABLE cleaning_group
    ADD CONSTRAINT cleaning_group_fk2  FOREIGN KEY ( staff_id )
        REFERENCES staff ( staff_id );

describe staff;
desc cleaning; 
desc cleaning_group;