--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T2-tsa-select.sql

--Student ID:30613043
--Student Name: Grant Fullston
--Unit Code: FIT2094
--Applied Class No: A09

/* Comments for your marker:




*/

/*2(a)*/

select t.town_id, t.town_name, p.poi_type_id, pt.poi_type_descr, COUNT(p.poi_type_id)as POI_COUNT

FROM
    tsa.TOWN t
    JOIN tsa.POINT_OF_INTEREST p ON t.town_id = p.town_id
    JOIN tsa.POI_TYPE pt ON pt.poi_type_id = p.poi_type_id

WHERE
    t.town_id IN
    ( select t.town_id
        from
            tsa.TOWN t
        JOIN tsa.POINT_OF_INTEREST p ON t.town_id = p.town_id
        JOIN tsa.POI_TYPE pt ON pt.poi_type_id = p.poi_type_id
        
        GROUP BY t.town_id
        
        HAVING count(p.poi_type_id )>1
    )

GROUP BY t.town_id,t.town_name, p.poi_type_id,pt.poi_type_descr
    
ORDER BY
    t.town_id,pt.poi_type_descr;

/*2(b)*/


select m.member_id, 
    member_gname
    || ' '
    || member_fname as MEMBER_NAME, 
    r.resort_id, resort_name, 
    (select max(countmax)
            from 
                (select member_id_recby, count(member_id_recby) as countmax
            from tsa.member 
            group by member_id_recby)
    ) as NUMBER_OF_RECCOMENDATIONS
FROM
    member m
    JOIN tsa.resort r ON m.resort_id = r.resort_id

WHERE
    m.member_id IN 
    (
    select member_id_recby
    
    from 
        (
            select member_id_recby, count(member_id_recby) as countmax
            from tsa.member 
            group by member_id_recby
        )
    
    where countmax = 
    (
    select max(count) 
    from 
        (select member_id_recby, count(member_id_recby) as count
                from tsa.member 
                group by member_id_recby) )
    )
order by  r.resort_id,m.member_id;
        


/*2(c)*/
select p.poi_id, poi_name, 
        nvl(to_char(MAX_RATING),'NR')as MAX_RATING, 
        nvl(to_char(MIN_RATING),'NR')as MIN_RATING,
        nvl(to_char(AVG_RATING),'NR')AS AVG_RATING

from (
    select poi_id, 
            max(review_rating) as MAX_RATING, 
            min(review_rating) as MIN_RATING, 
            to_char(avg(review_rating) , '9.9') AS AVG_RATING

        from tsa.point_of_interest natural join tsa.review
        
        group by poi_id
    )t1 
    right outer join tsa.point_of_interest p on p.poi_id = t1.poi_id
    
order by p.poi_id;



/*2(d)
*/

select poi_name, poi_type_descr, town_name, 
    lpad( 'Lat: ' || town_lat || ' Long: ' || town_long ,35, ' ') as town_location,
    reviews_completed,
    
    CASE(percent_of_reviews)
        when '.00%' then 'No reviews completed' 
        else percent_of_reviews
    END as percent_of_reviews

from 
        (   
            (select 
                p.poi_id as poi_id, count(t.review_id) as reviews_completed,
                to_char(
                count(t.review_id)*100/(select max(sum(review_id))
                from tsa.review
                group by review_id), '999.99') || '%'as percent_of_reviews
            from 
                tsa.review t right outer join tsa.point_of_interest p on t.poi_id = p.poi_id
            group by 
                p.poi_id, p.poi_name
                
            ) 
        natural join tsa.point_of_interest natural join tsa.town natural join tsa.poi_type 
        ) 
order by town_name, reviews_completed desc, poi_name;


/*2(e)*/ 
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

-- Comments for marker
-- It was assymed the reccomended by name was 18 characters long as this was the length given in the example we had to match the form for


select t1.resort_id, t1.resort_name,
        t1.member_no,
        t1.member_name,
        to_char(t1.member_date_joined, 'dd-MON-yyyy') as date_joined,
        rpad( t2.member_no ||' ' || t2.member_gname || ' ' || t2.member_fname,18,' ') as reccomended_by_details,
        
        
        lpad( '$' || sum(t1.mc_total) , 13, ' ') as total_charges 
        
        from (
                (
                select      resort_id, 
                            resort_name, 
                            member_no, 
                            member_gname || ' ' || member_fname as member_name,
                            mc_total,
                            member_date_joined,
                            member_id_recby
                            
                from tsa.member_charge natural join tsa.member natural join tsa.resort 
                
                where member_id in 
                        (
                            select member_id
                                from tsa.resort natural join tsa.member
                        
                                where town_id in (
                                        (select town_id 
                                        from tsa.resort) 
                                        minus (
                                            select town_id 
                                            from tsa.town 
                                            where UPPER(town_name) = UPPER('Byron Bay') AND UPPER(town_state) = UPPER('NSW')
                                        )
                                    )
                                AND member_id_recby is not null
                            )  
                ) t1 
            left outer join 
                (select * from tsa.member) t2 
            on t1.member_id_recby = t2.member_id
            )
        where 
 
            (select sum(mc_total)
                from (tsa.member_charge natural join tsa.member natural join tsa.resort)
                where mc_paid_date is not null AND resort_id = t1.resort_id and member_no = t1.member_no
                group by resort_id, member_no)

            <  
            
            (select average_points 
                from 
                                (
                                select resort_id, avg(mc_total) as average_points
                                      from (
                                            select resort_id, sum(mc_total) as mc_total
                                            from (tsa.member_charge natural join tsa.member natural join tsa.resort)
                                            group by resort_id, member_id)
                                      group by resort_id
                                        order by resort_id
                                
                                
                                ) t3
                where t3.resort_id = t1.resort_id
            )
                    
        group by 
            t1.resort_id, t1.resort_name, t1.member_no,t1.member_name,
            to_char(t1.member_date_joined, 'dd-MON-yyyy'),
            t2.member_no ||' ' || t2.member_gname || ' ' || t2.member_fname;
               
                    

/*2(f)*/
----------------------------------------------------------------

select 
        r.resort_id, r.resort_name, p.poi_name,
        t.town_name as poi_town,
        t.town_state as poi_state,

        CASE
            when p.poi_open_time is not null then '09:00 AM' 
            else 'Not Applicable'
        END as poi_opening_time, 
        
        to_char( (
            SELECT
                geodistance(
                   t.town_long, t.town_lat, t1.town_long, t1.town_lat
                ) as dist
            FROM
                dual
                
        ),'990.0') || ' Kms' as distance

from 
    (   
        (
        (
            select t1.town_id as town_id, t2.poi_id as poi_id 
            from 
                (
                
                (select town_id from tsa.town
                order by town_id) t1
                
                natural join 
                
                (select poi_id from tsa.point_of_interest
                order by poi_id) t2
                
                )
        )crosslist
        join tsa.town t on t.town_id = crosslist.town_id
        join tsa.point_of_interest p on crosslist.poi_id = p.poi_id
        join tsa.resort r on r.town_id = t.town_id
        join tsa.town t1 on t1.town_id = p.town_id
        )
    
    )
------------------------------------------------
where 

100>= 

(
    SELECT
        geodistance(
           t.town_long, t.town_lat, t1.town_long, t1.town_lat
        ) as dist
    FROM
        dual
        
) 
order by r.resort_name, distance;