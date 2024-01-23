--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T1-tsa-schema.sql

--Student ID:
--Student Name: Grant Fullston
--Unit Code: FIT2094
--Applied Class No: A09

/* Comments for your marker:




*/

-- Task 1 Add Create table statements for the white TABLES below
-- Ensure all column comments, and constraints (other than FK's)
-- are included. FK constraints are to be added at the end of this script

-- BOOKING

CREATE TABLE booking (
    booking_id         NUMBER(8) NOT NULL,
    resort_id        NUMBER(4) NOT NULL,
    cabin_no        NUMBER(3) NOT NULL,
    booking_from    DATE NOT NULL,
    booking_to      DATE NOT NULL, CHECK (booking_to>booking_from),
    booking_noadults      NUMBER(2) NOT NULL, CHECK (booking_noadults>=1),
    booking_nochildren      NUMBER(2) NOT NULL,
    booking_total_points_cost      NUMBER(4) NOT NULL, CHECK (booking_total_points_cost>=0),
    member_id      NUMBER(6) NOT NULL,
    staff_id   NUMBER(5) NOT NULL
);

-- ADDD COMMENTS
COMMENT ON COLUMN booking.booking_id IS
    'surrogate key added to replace BOOKING composite PK';

COMMENT ON COLUMN booking.resort_id IS
    'Resort identifier, for this booking';

COMMENT ON COLUMN booking.cabin_no IS
    'Cabin number within the resort, for this booking';

COMMENT ON COLUMN booking.booking_from IS
    'Date booking from';

COMMENT ON COLUMN booking.booking_to IS
    'Date booking to';

COMMENT ON COLUMN booking.booking_noadults IS
    'Booking number of adults';

COMMENT ON COLUMN booking.booking_nochildren IS
    'Booking number of children';

COMMENT ON COLUMN booking.booking_total_points_cost  IS
    'Total cost to the member in points for this booking';

COMMENT ON COLUMN booking.member_id IS
    'Unique member id across TSA for member who made this booking';

COMMENT ON COLUMN booking.staff_id IS
    'Staff identifier of staff member who took this booking';

-- ADD THE SURROGATE KEEY AND UNIQUE PRIMARY
ALTER TABLE booking ADD CONSTRAINT booking_pk PRIMARY KEY ( booking_id );

ALTER TABLE booking ADD CONSTRAINT booking_nk UNIQUE ( resort_id,
                                                      cabin_no, booking_from);


-- CABIN

CREATE TABLE cabin (
    resort_id       NUMBER(4) NOT NULL,
    cabin_no       NUMBER(3) NOT NULL,
    cabin_nobedrooms    NUMBER(1) NOT NULL, CHECK (cabin_nobedrooms>=1 AND cabin_nobedrooms <=4),
    cabin_sleeping_capacity NUMBER(2) NOT NULL, CHECK (cabin_sleeping_capacity>=1),
    cabin_bathroom_type      CHAR(1) NOT NULL, CHECK (UPPER(cabin_bathroom_type) LIKE UPPER('c') OR UPPER(cabin_bathroom_type) LIKE UPPER('i')),
    cabin_points_cost_day    NUMBER(4) NOT NULL, CHECK (cabin_points_cost_day>=0),
    cabin_description     VARCHAR2(250) NOT NULL
);

COMMENT ON COLUMN cabin.resort_id IS
    'Resort identifier';

COMMENT ON COLUMN cabin.cabin_no IS
    'Cabin number within the resort';

COMMENT ON COLUMN cabin.cabin_nobedrooms IS
    'Number of bedrooms in cabin (between 1 and 4 bedrooms)';

COMMENT ON COLUMN cabin.cabin_sleeping_capacity IS
    'Cabin sleeping capacity';

COMMENT ON COLUMN cabin.cabin_bathroom_type IS
    'Type of cabin bathroom:
I - Inside cabin bathroom
C - outside common bathroom';

COMMENT ON COLUMN cabin.cabin_points_cost_day IS
    'Number of members points the cabin costs per day';

COMMENT ON COLUMN cabin.cabin_description IS
    'Cabin description';
    
ALTER TABLE cabin ADD CONSTRAINT cabin_pk PRIMARY KEY ( resort_id, cabin_no);   



-- Add all missing FK Constraints below here
                        
ALTER TABLE booking
    ADD CONSTRAINT booking_member FOREIGN KEY ( member_id )
        REFERENCES member ( member_id );

ALTER TABLE booking
    ADD CONSTRAINT booking_staff FOREIGN KEY ( staff_id )
        REFERENCES staff ( staff_id );
        
ALTER TABLE cabin
    ADD CONSTRAINT cabin_resort FOREIGN KEY ( resort_id )
        REFERENCES resort ( resort_id );



  

--**Trigger for checking and updating member.member_points for each booking.**--
--**Run this code before attempting Task 2 and Task 3**--
--**DO NOT REMOVE. DO NOT MODIFY**--
CREATE OR REPLACE TRIGGER check_member_points BEFORE
    INSERT OR DELETE OR UPDATE OF booking_total_points_cost ON booking
    FOR EACH ROW
DECLARE
    var_mem_points NUMBER;
BEGIN
    IF inserting THEN
        SELECT
            member_points
        INTO var_mem_points
        FROM
            member
        WHERE
            member_id = :new.member_id;
            
        IF var_mem_points < :new.booking_total_points_cost THEN
            raise_application_error(-20001, 'Not enough member points for this booking'
            );
        ELSE
            var_mem_points := var_mem_points - :new.booking_total_points_cost;
            UPDATE member
            SET
                member_points = var_mem_points
            WHERE
                member_id = :new.member_id;

        END IF;

        dbms_output.put_line('New booking added for member '
                             || :new.member_id
                             || '. Remaining points for this member: '
                             || var_mem_points);

    END IF;

    IF deleting THEN
        SELECT
            member_points
        INTO var_mem_points
        FROM
            member
        WHERE
            member_id = :old.member_id;
        
        var_mem_points := var_mem_points + :old.booking_total_points_cost;
        
        UPDATE member
        SET
            member_points = var_mem_points
        WHERE
            member_id = :old.member_id;

        dbms_output.put_line('Booking '
                             || :old.booking_id
                             || ' for member '
                             || :old.member_id
                             || ' was deleted. Remaining points for this member: '
                             || var_mem_points);

    END IF;

    IF updating THEN
        SELECT
            member_points
        INTO var_mem_points
        FROM
            member
        WHERE
            member_id = :new.member_id;
            
        var_mem_points := var_mem_points + :old.booking_total_points_cost;
        
        IF var_mem_points < :new.booking_total_points_cost THEN
            raise_application_error(-20001, 'Not enough member points for this booking'
            );
        ELSE
            var_mem_points := var_mem_points - :new.booking_total_points_cost;
            UPDATE member
            SET
                member_points = var_mem_points
            WHERE
                member_id = :new.member_id;

            dbms_output.put_line('Booking '
                                 || :old.booking_id
                                 || ' for member '
                                 || :new.member_id
                                 || ' was updated. Remaining points for this member: '
                                 || var_mem_points);

        END IF;

    END IF;

END;
/
--**End of trigger**--
