/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T2-tsa-insert.sql

--Student ID: 30613043
--Student Name: Grant Fullston
--Unit Code: FIT2094
--Applied Class No: A09

/* Comments for your marker:




*/

---**This command shows the outputs of triggers**---
---**Run the command before running the insert statements.**---
---**Do not remove**---
SET SERVEROUTPUT ON
---**end**---

--------------------------------------
--INSERT INTO cabin
--------------------------------------


--Valid inserts added to the database
INSERT INTO cabin VALUES (
    1,
    1,
    1,
    2,
    'i',
    20,
    'couples retreat'
);

INSERT INTO cabin VALUES (
    1,
    2,
    2,
    4,
    'i',
    30,
    'family retreat'
);

INSERT INTO cabin VALUES (
    1,
    4,
    3,
    6,
    'i',
    50,
    'mid sized party'
);

INSERT INTO cabin VALUES (
    2,
    1,
    1,
    2,
    'i',
    10,
    'couples on holiday'
);

INSERT INTO cabin VALUES (
    2,
    2,
    2,
    4,
    'i',
    20,
    'family on holiday'
);

INSERT INTO cabin VALUES (
    3,
    1,
    2,
    4,
    'i',
    20,
    'family on holiday'
);

INSERT INTO cabin VALUES (
    4,
    1,
    2,
    4,
    'i',
    20,
    'family on holiday'
);

INSERT INTO cabin VALUES (
    5,
    1,
    2,
    4,
    'i',
    20,
    'family on holiday'
);

INSERT INTO cabin VALUES (
    3,
    2,
    1,
    2,
    'i',
    20,
    'couple on holiday'
);

INSERT INTO cabin VALUES (
    4,
    2,
    1,
    2,
    'i',
    20,
    'couple on holiday'
);

INSERT INTO cabin VALUES (
    5,
    2,
    1,
    2,
    'i',
    20,
    'couple on holiday'
);

INSERT INTO cabin VALUES (
    5,
    3,
    3,
    6,
    'i',
    50,
    'big family on holiday'
);
INSERT INTO cabin VALUES (
    5,
    4,
    3,
    6,
    'i',
    50,
    'big family on holiday'
);

INSERT INTO cabin VALUES (
    5,
    5,
    3,
    6,
    'i',
    50,
    'big family on holiday'
);

INSERT INTO cabin VALUES (
    6,
    3,
    3,
    6,
    'i',
    50,
    'big family on holiday'
);

INSERT INTO cabin VALUES (
    3,
    3,
    3,
    6,
    'i',
    50,
    'big family on holiday'
);

INSERT INTO cabin VALUES (
    10,
    1,
    3,
    6,
    'i',
    50,
    'big family on holiday'
);

INSERT INTO cabin VALUES (
    2,
    8,
    3,
    6,
    'i',
    50,
    'big family on holiday'
);

INSERT INTO cabin VALUES (
    3,
    9,
    3,
    6,
    'i',
    50,
    'big family on holiday'
);

INSERT INTO cabin VALUES (
    3,
    10,
    3,
    6,
    'i',
    50,
    'big family on holiday'
);




--Breach of check clause examples that should be rejected 

--Bathroom location not i or c
INSERT INTO cabin VALUES (
    10,
    3,
    3,
    6,
    'd',
    500,
    'big family on holiday'
);

--more than 4 bathrooms 
INSERT INTO cabin VALUES (
    1,
    5,
    6,
    10,
    'i',
    1000,
    'whole squad party'
);

--more than less than 1 bedroom 
INSERT INTO cabin VALUES (
    1,
    5,
    0,
    10,
    'i',
    1000,
    'whole squad party'
);

-- parent key (resort number 520) doesn't exist

INSERT INTO cabin VALUES (
    520,
    3,
    3,
    6,
    'i',
    500,
    'big family on holiday'
);

-- check rejection of non unique primary keys 
INSERT INTO cabin VALUES (
    3,
    3,
    3,
    6,
    'i',
    500,
    'big family on holiday'
);

-- check sleeping no people
INSERT INTO cabin VALUES (
    9,
    1,
    1,
    0,
    'i',
    500,
    'room for none'
);

-- check costs negative points
INSERT INTO cabin VALUES (
    9,
    1,
    1,
    0,
    'i',
    -1,
    'room for none'
);
--------------------------------------
--INSERT INTO booking
--------------------------------------

-- DELETE B4 SUBMIT


-- add valid bookings                                                      
 INSERT INTO booking VALUES (
    1,
    1,
    1,
    to_date('02/03/2023','DD/MM/YYYY'),
    to_date('05/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 1 and cabin_no = 1) * (to_date('05/03/2023','DD/MM/YYYY')- to_date('02/03/2023','DD/MM/YYYY')) ,
    1,
    1
);

 INSERT INTO booking VALUES (
    2,
    1,
    2,
    to_date('06/03/2023','DD/MM/YYYY'),
    to_date('12/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 1 and cabin_no = 2) * (to_date('12/03/2023','DD/MM/YYYY')- to_date('06/03/2023','DD/MM/YYYY')) ,
    1,
    1
);

 INSERT INTO booking VALUES (
    3,
    1,
    1,
    to_date('15/03/2023','DD/MM/YYYY'),
    to_date('18/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 1 and cabin_no = 1) * (to_date('18/03/2023','DD/MM/YYYY')- to_date('15/03/2023','DD/MM/YYYY')) ,
    1,
    1
);

 INSERT INTO booking VALUES (
    4,
    1,
    1,
    to_date('19/03/2023','DD/MM/YYYY'),
    to_date('21/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 1 and cabin_no = 1) * (to_date('21/03/2023','DD/MM/YYYY')- to_date('19/03/2023','DD/MM/YYYY')) ,
    2,
    1
);

 INSERT INTO booking VALUES (
    5,
    1,
    2,
    to_date('22/03/2023','DD/MM/YYYY'),
    to_date('23/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 1 and cabin_no = 2) * (to_date('23/03/2023','DD/MM/YYYY')- to_date('22/03/2023','DD/MM/YYYY')) ,
    2,
    1
);

 INSERT INTO booking VALUES (
    6,
    1,
    2,
    to_date('25/03/2023','DD/MM/YYYY'),
    to_date('28/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 1 and cabin_no = 2) * (to_date('28/03/2023','DD/MM/YYYY')- to_date('25/03/2023','DD/MM/YYYY')) ,
    3,
    1
);

 INSERT INTO booking VALUES (
    7,
    2,
    1,
    to_date('02/03/2023','DD/MM/YYYY'),
    to_date('04/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 2 and cabin_no = 1) * (to_date('04/03/2023','DD/MM/YYYY')- to_date('02/03/2023','DD/MM/YYYY')) ,
    3,
    1
);

 INSERT INTO booking VALUES (
    8,
    2,
    1,
    to_date('05/03/2023','DD/MM/YYYY'),
    to_date('08/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 2 and cabin_no = 1) * (to_date('08/03/2023','DD/MM/YYYY')- to_date('05/03/2023','DD/MM/YYYY')) ,
    4,
    2
);

 INSERT INTO booking VALUES (
    9,
    2,
    1,
    to_date('12/03/2023','DD/MM/YYYY'),
    to_date('15/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 2 and cabin_no = 1) * (to_date('15/03/2023','DD/MM/YYYY')- to_date('12/03/2023','DD/MM/YYYY')) ,
    5,
    2
);

 INSERT INTO booking VALUES (
    10,
    3,
    1,
    to_date('02/03/2023','DD/MM/YYYY'),
    to_date('05/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 3 and cabin_no = 1) * (to_date('05/03/2023','DD/MM/YYYY')- to_date('02/03/2023','DD/MM/YYYY')) ,
    6,
    1
);

 INSERT INTO booking VALUES (
    11,
    3,
    2,
    to_date('02/03/2023','DD/MM/YYYY'),
    to_date('05/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 3 and cabin_no = 2) * (to_date('05/03/2023','DD/MM/YYYY')- to_date('02/03/2023','DD/MM/YYYY')) ,
    7,
    1
);

 INSERT INTO booking VALUES (
    12,
    3,
    3,
    to_date('02/03/2023','DD/MM/YYYY'),
    to_date('05/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 3 and cabin_no = 3) * (to_date('05/03/2023','DD/MM/YYYY')- to_date('02/03/2023','DD/MM/YYYY')) ,
    8,
    1
);

 INSERT INTO booking VALUES (
    13,
    4,
    1,
    to_date('02/03/2023','DD/MM/YYYY'),
    to_date('05/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 4 and cabin_no = 1) * (to_date('05/03/2023','DD/MM/YYYY')- to_date('02/03/2023','DD/MM/YYYY')) ,
    9,
    1
);

 INSERT INTO booking VALUES (
    14,
    5,
    1,
    to_date('02/03/2023','DD/MM/YYYY'),
    to_date('05/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 5 and cabin_no = 1) * (to_date('05/03/2023','DD/MM/YYYY')- to_date('02/03/2023','DD/MM/YYYY')) ,
    10,
    1
);

 INSERT INTO booking VALUES (
    15,
    5,
    1,
    to_date('10/03/2023','DD/MM/YYYY'),
    to_date('15/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 5 and cabin_no = 1) * (to_date('15/03/2023','DD/MM/YYYY')- to_date('10/03/2023','DD/MM/YYYY')) ,
    10,
    1
);

 INSERT INTO booking VALUES (
    16,
    10,
    1,
    to_date('02/03/2023','DD/MM/YYYY'),
    to_date('05/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 10 and cabin_no = 1) * (to_date('05/03/2023','DD/MM/YYYY')- to_date('02/03/2023','DD/MM/YYYY')) ,
    11,
    1
);

 INSERT INTO booking VALUES (
    17,
    5,
    5,
    to_date('02/03/2023','DD/MM/YYYY'),
    to_date('05/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 5 and cabin_no = 5) * (to_date('05/03/2023','DD/MM/YYYY')- to_date('02/03/2023','DD/MM/YYYY')) ,
    12,
    1
);

 INSERT INTO booking VALUES (
    18,
    6,
    3,
    to_date('02/03/2023','DD/MM/YYYY'),
    to_date('05/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 6 and cabin_no = 3) * (to_date('05/03/2023','DD/MM/YYYY')- to_date('02/03/2023','DD/MM/YYYY')) ,
    13,
    1
);

 INSERT INTO booking VALUES (
    19,
    6,
    3,
    to_date('20/03/2023','DD/MM/YYYY'),
    to_date('25/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 6 and cabin_no = 3) * (to_date('25/03/2023','DD/MM/YYYY')- to_date('20/03/2023','DD/MM/YYYY')) ,
    13,
    1
);

 INSERT INTO booking VALUES (
    20,
    6,
    3,
    to_date('26/03/2023','DD/MM/YYYY'),
    to_date('27/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 6 and cabin_no = 3) * (to_date('27/03/2023','DD/MM/YYYY')- to_date('26/03/2023','DD/MM/YYYY')) ,
    13,
    1
);

-- check constraints against invalid bookings

-- check non unique primary key
 INSERT INTO booking VALUES (
    1,
    1,
    1,
    to_date('02/03/2023','DD/MM/YYYY'),
    to_date('05/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 1 and cabin_no = 1) * (to_date('05/03/2023','DD/MM/YYYY')- to_date('02/03/2023','DD/MM/YYYY')) ,
    1,
    1
);

-- check not enough points
 INSERT INTO booking VALUES (
    21,
    1,
    1,
    to_date('06/03/2023','DD/MM/YYYY'),
    to_date('25/04/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 1 and cabin_no = 1) * (to_date('25/04/2023','DD/MM/YYYY')- to_date('02/03/2023','DD/MM/YYYY')) ,
    1,
    1
);

-- check out before check in
 INSERT INTO booking VALUES (
    22,
    1,
    1,
    to_date('06/03/2023','DD/MM/YYYY'),
    to_date('02/03/2023','DD/MM/YYYY'),
    2,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 1 and cabin_no = 1)  ,
    1,
    1
);

-- check no adults
 INSERT INTO booking VALUES (
    23,
    6,
    3,
    to_date('30/03/2023','DD/MM/YYYY'),
    to_date('05/04/2023','DD/MM/YYYY'),
    0,
    0,
    (select cabin_points_cost_day from cabin where resort_id = 6 and cabin_no = 3) * 6,
    13,
    1
);
commit