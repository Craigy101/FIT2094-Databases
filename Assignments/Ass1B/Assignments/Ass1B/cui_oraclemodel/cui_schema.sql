-- A09 Group ID 149
-- type Oracle Database 12c

set echo on 
spool output.txt


DROP TABLE approve CASCADE CONSTRAINTS;

DROP TABLE authority CASCADE CONSTRAINTS;

DROP TABLE bin CASCADE CONSTRAINTS;

DROP TABLE bin_type CASCADE CONSTRAINTS;

DROP TABLE contract CASCADE CONSTRAINTS;

DROP TABLE contract_bin_supply CASCADE CONSTRAINTS;

DROP TABLE contract_collection CASCADE CONSTRAINTS;

DROP TABLE driver CASCADE CONSTRAINTS;

DROP TABLE driver_truck_lists CASCADE CONSTRAINTS;

DROP TABLE owner CASCADE CONSTRAINTS;

DROP TABLE owner_of_property CASCADE CONSTRAINTS;

DROP TABLE property CASCADE CONSTRAINTS;

DROP TABLE street CASCADE CONSTRAINTS;

DROP TABLE truck CASCADE CONSTRAINTS;

DROP TABLE waste_type CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE approve (
    ap_no        NUMBER(10) NOT NULL,
    approve_date DATE,
    truck_vin    VARCHAR2(10) NOT NULL,
    driver_no    NUMBER(10) NOT NULL
);

COMMENT ON COLUMN approve.ap_no IS
    'surrogate key of approve';

COMMENT ON COLUMN approve.approve_date IS
    'The date of approved ';

COMMENT ON COLUMN approve.truck_vin IS
    'Truck''s vin';

COMMENT ON COLUMN approve.driver_no IS
    'Driver number';

CREATE UNIQUE INDEX approve__idx ON
    approve (
        driver_no
    ASC );

ALTER TABLE approve ADD CONSTRAINT approve_pk PRIMARY KEY ( ap_no );

ALTER TABLE approve
    ADD CONSTRAINT approve_nk UNIQUE ( approve_date,
                                       truck_vin,
                                       driver_no );

CREATE TABLE authority (
    author_name        VARCHAR2(30) NOT NULL,
    author_ceo_fname   VARCHAR2(30) NOT NULL,
    author_ceo_lname   VARCHAR2(30) NOT NULL,
    author_phone       CHAR(10),
    author_total_area  NUMBER(10, 2) NOT NULL,
    author_street_area NUMBER(10, 2) NOT NULL,
    author_type        VARCHAR2(30) NOT NULL
);

ALTER TABLE authority
    ADD CONSTRAINT "list of types" CHECK ( author_type IN ( 'Borough', 'City', 'District Council'
    , 'Shire', 'Town' ) );

COMMENT ON COLUMN authority.author_name IS
    'The authority name ';

COMMENT ON COLUMN authority.author_ceo_fname IS
    'authority chief executive officer first name ';

COMMENT ON COLUMN authority.author_ceo_lname IS
    'authority chief executive officer last name ';

COMMENT ON COLUMN authority.author_phone IS
    'authority phone number ';

COMMENT ON COLUMN authority.author_total_area IS
    'authority total area';

COMMENT ON COLUMN authority.author_street_area IS
    'street area ';

COMMENT ON COLUMN authority.author_type IS
    'type of authority';

ALTER TABLE authority ADD CONSTRAINT authority_pk PRIMARY KEY ( author_name );

CREATE TABLE bin (
    bin_tag_rfid       CHAR(16) NOT NULL,
    bin_kg             NUMBER(10, 2) NOT NULL,
    bin_replace_reason VARCHAR2(50),
    bin_date_supply    DATE NOT NULL,
    property_id        NUMBER(10) NOT NULL,
    bin_overweight     CHAR(1) NOT NULL,
    street_id          NUMBER(10) NOT NULL,
    author_name        VARCHAR2(30) NOT NULL,
    "ct.no"            NUMBER(10) NOT NULL,
    bin_size           NUMBER(10, 2) NOT NULL,
    waste_type_id      NUMBER(10) NOT NULL
);

ALTER TABLE bin
    ADD CONSTRAINT "fixed list" CHECK ( bin_replace_reason IN ( '', 'Bin Failure (fair use eg. old age)'
    , 'Damaged by owner', 'Damaged during pickup of waste', 'Stolen' ) );

ALTER TABLE bin
    ADD CONSTRAINT overweight CHECK ( bin_overweight IN ( 'N', 'Y' ) );

COMMENT ON COLUMN bin.bin_tag_rfid IS
    'bin RFID tag';

COMMENT ON COLUMN bin.bin_kg IS
    'The collected weight of the bin';

COMMENT ON COLUMN bin.bin_replace_reason IS
    'The reason of replacement of bin';

COMMENT ON COLUMN bin.bin_date_supply IS
    'The suppliy date of bin';

COMMENT ON COLUMN bin.property_id IS
    'Property id number ';

COMMENT ON COLUMN bin.bin_overweight IS
    'The record of the bin is owerweight by input (Y or N)';

COMMENT ON COLUMN bin.street_id IS
    'The street id';

COMMENT ON COLUMN bin.author_name IS
    'The authority name ';

COMMENT ON COLUMN bin."ct.no" IS
    'collection surrogate key';

COMMENT ON COLUMN bin.bin_size IS
    'the size of type of bin';

COMMENT ON COLUMN bin.waste_type_id IS
    'Waste type id ';

ALTER TABLE bin
    ADD CONSTRAINT bin_pk PRIMARY KEY ( bin_tag_rfid,
                                        bin_kg,
                                        bin_size,
                                        waste_type_id );

CREATE TABLE bin_type (
    bin_size                   NUMBER(10, 2) NOT NULL,
    bin_type_stand_cost_supply NUMBER(10, 2) NOT NULL,
    waste_type_id              NUMBER(10) NOT NULL
);

COMMENT ON COLUMN bin_type.bin_size IS
    'the size of type of bin';

COMMENT ON COLUMN bin_type.bin_type_stand_cost_supply IS
    'standard supply cost of bin';

COMMENT ON COLUMN bin_type.waste_type_id IS
    'Waste type id ';

ALTER TABLE bin_type ADD CONSTRAINT bin_type_pk PRIMARY KEY ( bin_size,
                                                              waste_type_id );

CREATE TABLE contract (
    contra_no                   NUMBER(10) NOT NULL,
    contra_date_start           DATE NOT NULL,
    contra_date_end             DATE NOT NULL,
    contra_collection_frequency VARCHAR2(30) NOT NULL,
    author_name                 VARCHAR2(30) NOT NULL
);

ALTER TABLE contract
    ADD CONSTRAINT frequency CHECK ( contra_collection_frequency IN ( 'Fortnightly', 'Monthly'
    , 'Weekly' ) );

COMMENT ON COLUMN contract.contra_no IS
    'contract number';

COMMENT ON COLUMN contract.contra_date_start IS
    'contract start date';

COMMENT ON COLUMN contract.contra_date_end IS
    'contract end date ';

COMMENT ON COLUMN contract.contra_collection_frequency IS
    'bin collection frequency';

COMMENT ON COLUMN contract.author_name IS
    'The authority name ';

ALTER TABLE contract ADD CONSTRAINT contract_pk PRIMARY KEY ( contra_no );

CREATE TABLE contract_bin_supply (
    cost_supply   NUMBER(10, 2) NOT NULL,
    contra_no     NUMBER(10) NOT NULL,
    bin_size      NUMBER(10, 2) NOT NULL,
    waste_type_id NUMBER(10) NOT NULL
);

COMMENT ON COLUMN contract_bin_supply.cost_supply IS
    'bin supply cost';

COMMENT ON COLUMN contract_bin_supply.contra_no IS
    'contract number';

COMMENT ON COLUMN contract_bin_supply.bin_size IS
    'the size of type of bin';

COMMENT ON COLUMN contract_bin_supply.waste_type_id IS
    'Waste type id ';

ALTER TABLE contract_bin_supply ADD CONSTRAINT "CONTRACT_BIN_SUPPL:Y_PK" PRIMARY KEY (
contra_no );

CREATE TABLE contract_collection (
    "ct.no"             NUMBER(10) NOT NULL,
    contra_collect_cost NUMBER(10, 2) NOT NULL,
    contra_no           NUMBER(10) NOT NULL,
    contra_collect_date DATE NOT NULL,
    truck_vin           VARCHAR2(10) NOT NULL,
    driver_no           NUMBER(10) NOT NULL,
    waste_type_id       NUMBER(10) NOT NULL
);

COMMENT ON COLUMN contract_collection."ct.no" IS
    'collection surrogate key';

COMMENT ON COLUMN contract_collection.contra_collect_cost IS
    'The waste collection cost';

COMMENT ON COLUMN contract_collection.contra_no IS
    'contract number';

COMMENT ON COLUMN contract_collection.contra_collect_date IS
    'bin collection date ';

COMMENT ON COLUMN contract_collection.truck_vin IS
    'Truck''s vin';

COMMENT ON COLUMN contract_collection.driver_no IS
    'Driver number';

COMMENT ON COLUMN contract_collection.waste_type_id IS
    'Waste type id ';

CREATE UNIQUE INDEX contract_collection__idx ON
    contract_collection (
        driver_no
    ASC );

CREATE UNIQUE INDEX contract_collection__idxv1 ON
    contract_collection (
        truck_vin
    ASC );

ALTER TABLE contract_collection ADD CONSTRAINT contract_collection_cost_pk PRIMARY KEY
( "ct.no" );

ALTER TABLE contract_collection
    ADD CONSTRAINT collection_no_nk UNIQUE ( contra_no,
                                             contra_collect_date,
                                             waste_type_id );

CREATE TABLE driver (
    driver_no       NUMBER(10) NOT NULL,
    driver_licen_no NUMBER(10) NOT NULL,
    driver_name     VARCHAR2(50) NOT NULL,
    driver_dob      DATE NOT NULL,
    driver_tfn      NUMBER(10) NOT NULL,
    driver_phone    CHAR(10)
);

COMMENT ON COLUMN driver.driver_no IS
    'Driver number';

COMMENT ON COLUMN driver.driver_licen_no IS
    'Driver licence number';

COMMENT ON COLUMN driver.driver_name IS
    'driver''s name ';

COMMENT ON COLUMN driver.driver_dob IS
    'driver''s date of birth';

COMMENT ON COLUMN driver.driver_tfn IS
    'driver''s texfile number';

COMMENT ON COLUMN driver.driver_phone IS
    'driver''s phone number';

ALTER TABLE driver ADD CONSTRAINT driver_pk PRIMARY KEY ( driver_no );

CREATE TABLE driver_truck_lists (
    truck_vin VARCHAR2(10) NOT NULL,
    driver_no NUMBER(10) NOT NULL
);

COMMENT ON COLUMN driver_truck_lists.truck_vin IS
    'Truck''s vin';

COMMENT ON COLUMN driver_truck_lists.driver_no IS
    'Driver number';

ALTER TABLE driver_truck_lists ADD CONSTRAINT driver_truck_pk PRIMARY KEY ( truck_vin
,
                                                                            driver_no
                                                                            );

CREATE TABLE owner (
    owner_id    NUMBER(10) NOT NULL,
    owner_email VARCHAR2(30),
    owner_phone CHAR(10) NOT NULL,
    owner_name  VARCHAR2(30) NOT NULL
);

COMMENT ON COLUMN owner.owner_id IS
    'Owner id ';

COMMENT ON COLUMN owner.owner_email IS
    'Owner email address';

COMMENT ON COLUMN owner.owner_phone IS
    'owner phone number is mandatory';

COMMENT ON COLUMN owner.owner_name IS
    'Owner''s name ';

ALTER TABLE owner ADD CONSTRAINT owner_pk PRIMARY KEY ( owner_id );

CREATE TABLE owner_of_property (
    owner_id    NUMBER(10) NOT NULL,
    property_id NUMBER(10) NOT NULL,
    street_id   NUMBER(10) NOT NULL,
    author_name VARCHAR2(30) NOT NULL
);

COMMENT ON COLUMN owner_of_property.owner_id IS
    'Owner id ';

COMMENT ON COLUMN owner_of_property.property_id IS
    'Property id number ';

COMMENT ON COLUMN owner_of_property.street_id IS
    'The street id';

COMMENT ON COLUMN owner_of_property.author_name IS
    'The authority name ';

ALTER TABLE owner_of_property
    ADD CONSTRAINT owner_list_pk PRIMARY KEY ( owner_id,
                                               property_id,
                                               street_id,
                                               author_name );

CREATE TABLE property (
    property_id NUMBER(10) NOT NULL,
    street_id   NUMBER(10) NOT NULL,
    author_name VARCHAR2(30) NOT NULL
);

COMMENT ON COLUMN property.property_id IS
    'Property id number ';

COMMENT ON COLUMN property.street_id IS
    'The street id';

COMMENT ON COLUMN property.author_name IS
    'The authority name ';

ALTER TABLE property
    ADD CONSTRAINT property_pk PRIMARY KEY ( property_id,
                                             street_id,
                                             author_name );

CREATE TABLE street (
    street_id                NUMBER(10) NOT NULL,
    street_name              VARCHAR2(30) NOT NULL,
    street_length            NUMBER(10, 2) NOT NULL,
    street_road_surface_type VARCHAR2(30) NOT NULL,
    street_lanes_num         NUMBER(10) NOT NULL,
    author_name              VARCHAR2(30) NOT NULL
);

ALTER TABLE street
    ADD CONSTRAINT "set types" CHECK ( street_road_surface_type IN ( 'Asphalt', 'Concrete'
    , 'Unsealed' ) );

COMMENT ON COLUMN street.street_id IS
    'The street id';

COMMENT ON COLUMN street.street_name IS
    'The name of the street';

COMMENT ON COLUMN street.street_length IS
    'The length of street';

COMMENT ON COLUMN street.street_road_surface_type IS
    'The road surface type';

COMMENT ON COLUMN street.street_lanes_num IS
    'the number of lane in one street';

COMMENT ON COLUMN street.author_name IS
    'The authority name ';

ALTER TABLE street ADD CONSTRAINT street_pk PRIMARY KEY ( street_id,
                                                          author_name );

CREATE TABLE truck (
    truck_vin   VARCHAR2(10) NOT NULL,
    truck_rego  VARCHAR2(10) NOT NULL,
    truck_make  VARCHAR2(50),
    truck_model VARCHAR2(50) NOT NULL,
    truck_year  DATE NOT NULL
);

COMMENT ON COLUMN truck.truck_vin IS
    'Truck''s vin';

COMMENT ON COLUMN truck.truck_rego IS
    'truck rego';

COMMENT ON COLUMN truck.truck_make IS
    'The brand of truck';

COMMENT ON COLUMN truck.truck_model IS
    'the model of truck';

COMMENT ON COLUMN truck.truck_year IS
    'The year of truck';

ALTER TABLE truck ADD CONSTRAINT truck_pk PRIMARY KEY ( truck_vin );

CREATE TABLE waste_type (
    waste_type_id    NUMBER(10) NOT NULL,
    waste_type_descr VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN waste_type.waste_type_id IS
    'Waste type id ';

COMMENT ON COLUMN waste_type.waste_type_descr IS
    'waste type description';

ALTER TABLE waste_type ADD CONSTRAINT waste_type_pk PRIMARY KEY ( waste_type_id );

ALTER TABLE contract
    ADD CONSTRAINT "AUTHORITY-CONTRACT" FOREIGN KEY ( author_name )
        REFERENCES authority ( author_name );

ALTER TABLE street
    ADD CONSTRAINT "AUTHORITY-STREET" FOREIGN KEY ( author_name )
        REFERENCES authority ( author_name );

ALTER TABLE bin
    ADD CONSTRAINT binype_to_bin FOREIGN KEY ( bin_size,
                                               waste_type_id )
        REFERENCES bin_type ( bin_size,
                              waste_type_id );

ALTER TABLE contract_bin_supply
    ADD CONSTRAINT "CONTRACT_BIN_SUPPLY-BIN_TYPE" FOREIGN KEY ( bin_size,
                                                                waste_type_id )
        REFERENCES bin_type ( bin_size,
                              waste_type_id );

ALTER TABLE bin
    ADD CONSTRAINT "CONTRACT_COLLECTION-BIN" FOREIGN KEY ( "ct.no" )
        REFERENCES contract_collection ( "ct.no" );

ALTER TABLE contract_collection
    ADD CONSTRAINT "CONTRACT-CONTRACT_COLLECTION" FOREIGN KEY ( contra_no )
        REFERENCES contract ( contra_no );

ALTER TABLE contract_bin_supply
    ADD CONSTRAINT "CONTRACT-CONTRACT_SUPPLY" FOREIGN KEY ( contra_no )
        REFERENCES contract ( contra_no );

ALTER TABLE approve
    ADD CONSTRAINT "DRIVER-APPROVE" FOREIGN KEY ( driver_no )
        REFERENCES driver ( driver_no );

ALTER TABLE contract_collection
    ADD CONSTRAINT "DRIVER-CONTRACT" FOREIGN KEY ( driver_no )
        REFERENCES driver ( driver_no );

ALTER TABLE owner_of_property
    ADD CONSTRAINT owner_to_list FOREIGN KEY ( owner_id )
        REFERENCES owner ( owner_id );

ALTER TABLE owner_of_property
    ADD CONSTRAINT propertty_to_owner_list FOREIGN KEY ( property_id,
                                                         street_id,
                                                         author_name )
        REFERENCES property ( property_id,
                              street_id,
                              author_name );

ALTER TABLE bin
    ADD CONSTRAINT "PROPERTY_-_BIN" FOREIGN KEY ( property_id,
                                                  street_id,
                                                  author_name )
        REFERENCES property ( property_id,
                              street_id,
                              author_name );

ALTER TABLE driver_truck_lists
    ADD CONSTRAINT relation_22 FOREIGN KEY ( truck_vin )
        REFERENCES truck ( truck_vin );

ALTER TABLE driver_truck_lists
    ADD CONSTRAINT relation_23 FOREIGN KEY ( driver_no )
        REFERENCES driver ( driver_no );

ALTER TABLE property
    ADD CONSTRAINT "STREET-PROPERTY" FOREIGN KEY ( street_id,
                                                   author_name )
        REFERENCES street ( street_id,
                            author_name );

ALTER TABLE approve
    ADD CONSTRAINT truck_approve FOREIGN KEY ( truck_vin )
        REFERENCES truck ( truck_vin );

ALTER TABLE contract_collection
    ADD CONSTRAINT "TRUCK-CONTRACT_COLLECTION" FOREIGN KEY ( truck_vin )
        REFERENCES truck ( truck_vin );

ALTER TABLE contract_collection
    ADD CONSTRAINT "WASTE_TYP-CONTRACT_COLLECTION" FOREIGN KEY ( waste_type_id )
        REFERENCES waste_type ( waste_type_id );

ALTER TABLE bin_type
    ADD CONSTRAINT "WASTE_TYPE-BIN_TYPE" FOREIGN KEY ( waste_type_id )
        REFERENCES waste_type ( waste_type_id );



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            15
-- CREATE INDEX                             3
-- ALTER TABLE                             41
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

spool off
set echo off