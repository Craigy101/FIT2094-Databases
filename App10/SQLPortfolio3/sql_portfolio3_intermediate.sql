--Comment out SET ECHO and SPOOL commands before submitting your portfolio
/*SET ECHO ON
SPOOL sql_portfolio3_intermediate_output.txt*/

--****PLEASE ENTER YOUR DETAILS BELOW****
--sql_portfolio3_intermediate.sql

--Student ID: 30613043
--Student Name: Grant Fullston
--Unit Code: fit2094
--Applied Class No: a09


/*1*/
SELECT t.tenant_no,
    tenant_title
    || ' '
    || tenant_givname
    || ' '
    || tenant_famname AS tenant_fullname,
    COUNT(dam_cost) AS no_incidents,
     to_char(SUM(dam_cost), '$9990.99') AS tot_cost
FROM
    rent.damage d
    JOIN rent.rent r ON d.rent_agreement_no = r.rent_agreement_no
    JOIN rent.tenant t ON t.tenant_no = r.tenant_no 
GROUP BY
    t.tenant_no,tenant_title
    || ' '
    || tenant_givname
    || ' '
    || tenant_famname
    
ORDER BY
    tot_cost desc, t.tenant_no asc;
    
/*2*/

select 
    t.tenant_no,
    tenant_title
    || ' '
    || tenant_givname
    || ' '
    || tenant_famname AS tenant_fullname,
    p.prop_no,
    prop_address,
    Count(rent_agreement_no)
    
FROM
    rent.property p
    JOIN rent.rent r ON p.prop_no = r.prop_no
    JOIN rent.tenant t ON t.tenant_no = r.tenant_no 
    
WHERE upper(prop_address) LIKE upper('%Tasmania%')

GROUP BY
    t.tenant_no, tenant_title || ' ' || tenant_givname || ' ' || tenant_famname, p.prop_no, prop_address
HAVING 
     Count(rent_agreement_no)>1
ORDER BY
    t.tenant_no asc;


--Comment out SET ECHO and SPOOL commands before submitting your portfolio
/*
SPOOL OFF
SET ECHO OFF*/