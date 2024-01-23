--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T3-tsa-json.sql

--Student ID:30613043
--Student Name: Grant Fullston
--Unit Code: FIT2094
--Applied Class No: A09

/* Comments for your marker:




*/

/*3(a)*/
-- PLEASE PLACE REQUIRED SQL STATEMENT TO GENERATE 
-- THE COLLECTION OF JSON DOCUMENTS HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

SET PAGESIZE 200

SELECT
    JSON_OBJECT ( '_id' VALUE town_id, 
                    'name' VALUE (town_name || ', ' || town_state),
                    'location' VALUE JSON_OBJECT (
                        'latitude' VALUE town_lat,
                        'longitude' VALUE town_long
                        ),
                    'avg_temperature' VALUE JSON_OBJECT (
                        'summer' VALUE town_avg_summer_temp,
                        'winter' VALUE town_avg_winter_temp
                        ),
                    'no_of_resorts' VALUE to_char(count(*)),
                    'resorts' VALUE JSON_ARRAYAGG
                    (
                        JSON_OBJECT
                        (
                            'id' VALUE resort_id,
                            'name' VALUE resort_name,
                            'address' VALUE resort_street_address,
                            'phone' VALUE resort_phone,
                            'year_built' VALUE to_number(to_char(resort_yr_built_purch,'YYYY')),
                            'company_name' VALUE 
                                (select company_name
                                    from
                                    (tsa.resort t3 natural join tsa.company t4
                                    )
                                    where t2.resort_id = t3.resort_id
                                )
                        )
                    )
                    FORMAT JSON )
    || ','
FROM
tsa.town t1 natural join tsa.resort t2

GROUP BY
town_id,town_name,town_state,town_lat,town_long,town_avg_summer_temp,town_avg_winter_temp
ORDER BY
town_id;
