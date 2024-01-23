--Comment out SET ECHO and SPOOL commands before submitting your portfolio
/*SET ECHO ON
SPOOL sql_portfolio2_basic_output.txt*/

--****PLEASE ENTER YOUR DETAILS BELOW****
--sql_portfolio2_basic.sql

--Student ID: 30613043
--Student Name: Grant Fullston
--Unit Code:FIT2094
--Applied Class No:A09

SELECT t.tenant_no,
    SUM(dam_cost) AS tot_cost
    
        tenant_title
    || ' '
    || tenant_givname
    || ' '
    || tenant_famname AS tenant_fullname
    
    
/*1*/
SELECT
MAINT_ID ,
MAINT_DATETIME ,
PROP_ADDRESS,
OWNER_GIVNAME/*TODO: TRY CONCACTENATE*/
    || ' '
    || OWNER_FAMNAME AS owner_fullname,
MAINT_DESC,
MAINT_COST
FROM
    rent.maintenance m
    JOIN rent.property p ON m.prop_no = p.prop_no
    JOIN rent.owner o ON o.owner_no = p.owner_no
    
WHERE
    maint_cost>1000 
    AND maint_cost<3000 
    AND  UPPER(maint_assigned) LIKE 'Y'
ORDER BY
    maint_cost DESC, maint_datetime;



/*2*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

SELECT
rent_agreement_no,
r.tenant_no,
tenant_givname
    || ' '
    || tenant_famname AS tenant_name,
prop_address,
OWNER_GIVNAME
    || ' '
    || OWNER_FAMNAME AS owner_fullname,
rent_lease_period
    || ' '
    || 'months' AS rent_lease_period
FROM
    rent.rent r
    JOIN rent.tenant t ON r.tenant_no = t.tenant_no
    JOIN rent.property p ON r.prop_no = p.prop_no
    JOIN rent.owner o ON o.owner_no = p.owner_no
WHERE

SUBSTR(to_char(rent_lease_start,'DD/MM/YY'),7,2) LIKE '22'
AND 
rent_weekly_rate<425
AND
rent_lease_period>5;

/*
--Comment out SET ECHO and SPOOL commands before submitting your portfolio
SPOOL OFF
SET ECHO OFF*/