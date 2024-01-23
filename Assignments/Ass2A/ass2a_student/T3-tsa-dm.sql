--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T3-tsa-dm.sql

--Student ID: 30613043
--Student Name: Grant Fullston
--Unit Code: FIT2094
--Applied Class No: A09

---**This command shows the outputs of triggers**---
---**Run the command before running the insert statements.**---
---**Do not remove**---
SET SERVEROUTPUT ON
---**end**---

--3(a)

-- CREATE SEQUENCE
DROP SEQUENCE booking_id_counter;

CREATE SEQUENCE booking_id_counter
INCREMENT BY 10 
START WITH 100;
commit;

--3(b)
-- INSERT PROMPTS MAKING SURE NOT TO HARDCODE, HENNCE SEARCH FOR RESULTS
INSERT INTO cabin VALUES (
     (select resort_id from resort
         where 
        resort_name = 'Awesome Resort'
        and 
        (select town_id from town
        where town_lat =-17.9644 and town_long = 122.2304) = resort.town_id)
        ,
    4,
    4,
    10,
    'i',
    220,
    'Q3b Awesome Resort New Cabin Broome big family on holiday'
);
commit;
   


--3(c)

 INSERT INTO booking VALUES (
    booking_id_counter.nextval,
    (select resort_id from resort
         where 
        resort_name = 'Awesome Resort'
        and 
        (select town_id from town
        where town_lat =-17.9644 and town_long = 122.2304) = resort.town_id),
    4, -- can we use from previous prompt
    to_date('26/05/2023','DD/MM/YYYY'),
    to_date('28/05/2023','DD/MM/YYYY'),
    4,
    4,
    (select cabin_points_cost_day from cabin where resort_id = (select resort_id from resort
         where 
        resort_name = 'Awesome Resort'
        and 
        (select town_id from town
        where town_lat =-17.9644 and town_long = 122.2304) = resort.town_id) and cabin_no = 4) * (to_date('28/05/2023','DD/MM/YYYY') - to_date('26/05/2023','DD/MM/YYYY')) ,
    (select member_id from member where resort_id = 9 and member_no = 2),
    (select staff_id from staff
         where 
        staff_phone = '0493427245')
);
commit;


--3(d)

UPDATE booking
  SET booking_to = booking_to +1
  WHERE resort_id = (select resort_id from resort
         where 
        resort_name = 'Awesome Resort'
        and 
        (select town_id from town
        where town_lat =-17.9644 and town_long = 122.2304) = resort.town_id)
        and cabin_no = 4
        and booking_from = to_date('26/05/2023','DD/MM/YYYY');

commit;

--3(e)

Delete from booking where  

    resort_id = (select resort_id from resort
         where 
        resort_name = 'Awesome Resort'
        and 
        (select town_id from town
        where town_lat =-17.9644 and town_long = 122.2304) = resort.town_id)
    and 
        cabin_no = 4;


Delete from cabin 
where 
    resort_id = (select resort_id from resort
         where 
        resort_name = 'Awesome Resort'
        and 
        (select town_id from town
        where town_lat =-17.9644 and town_long = 122.2304) = resort.town_id)
    and 
        cabin_no = 4;
commit;
