--liquibase formatted sql
--changeset d4.ramirez:1

-----------------
-- SCHEMA META
-----------------

--
-- Name: meta; Type: SCHEMA; Schema: -; Owner: postgres
--
DROP SCHEMA IF EXISTS "meta" CASCADE;
CREATE SCHEMA IF NOT EXISTS "meta";

--
-- Name: databases; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."databases" (
    "code" SERIAL,
    "name" CHARACTER VARYING UNIQUE NOT NULL,
    "ip" CHARACTER VARYING NOT NULL,
    "version" CHARACTER VARYING NOT NULL,
    "port" CHARACTER VARYING NOT NULL,
    CONSTRAINT pk_database PRIMARY KEY ("code")
);

--
-- Name: tables; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."tables" (
    "code" SERIAL,
    "name" CHARACTER VARYING UNIQUE NOT NULL,
    CONSTRAINT pk_table PRIMARY KEY ("code")
);

--
-- Name: database_tables; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."database_tables" (
    "code" SERIAL,
    "database_code" INT NOT NULL,
    "table_code" INT NOT NULL,
    CONSTRAINT pk_database_table PRIMARY KEY ("code"),
    CONSTRAINT fk_database FOREIGN KEY ("database_code") REFERENCES "meta"."databases"("code"),
    CONSTRAINT fk_table FOREIGN KEY ("table_code") REFERENCES "meta"."tables"("code")

 );

--
-- Name: columns; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."columns" (
    "code" SERIAL,
    "name" CHARACTER VARYING UNIQUE NOT NULL,
    CONSTRAINT pk_column PRIMARY KEY ("code")
);

--
-- Name: table_columns; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."table_columns" (
    "code" SERIAL,
    "type" CHARACTER VARYING NOT NULL,
    "key" CHARACTER VARYING,
    "length" INT,
    "database_table_code" INT NOT NULL,
    "column_code" INT NOT NULL,
    CONSTRAINT pk_table_column PRIMARY KEY ("code"),
    CONSTRAINT fk_database_table FOREIGN KEY ("database_table_code") REFERENCES "meta"."database_tables"("code"),
    CONSTRAINT fk_column FOREIGN KEY ("column_code") REFERENCES "meta"."columns"("code")
 );

--
-- Name: entities; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."entities" (
    "code" SERIAL,
    "name" CHARACTER VARYING UNIQUE NOT NULL,
    "description" CHARACTER VARYING NOT NULL,
    CONSTRAINT pk_entity PRIMARY KEY ("code")
);

--
-- Name: entity_tables; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."entity_tables" (
    "code" SERIAL,
    "entity_code" INT NOT NULL,
    "database_table_code" INT NOT NULL,
    CONSTRAINT pk_entity_table PRIMARY KEY ("code"),
    CONSTRAINT fk_entity FOREIGN KEY ("entity_code") REFERENCES "meta"."entities"("code"),
    CONSTRAINT fk_database_table FOREIGN KEY ("database_table_code") REFERENCES "meta"."database_tables"("code")
);

--
-- Name: entity_attributes; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."entity_attributes" (
    "code" SERIAL,
    "name" CHARACTER VARYING UNIQUE NOT NULL,
    "description" CHARACTER VARYING NOT NULL,
    CONSTRAINT pk_entity_attributes PRIMARY KEY ("code")
);

--
-- Name: entity_entity_attributes; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."entity_entity_attributes" (
    "code" SERIAL,
    "entity_code" INT NOT NULL,
    "entity_attribute_code" INT NOT NULL,
    CONSTRAINT pk_entity_entity_attribute PRIMARY KEY ("code"),
    CONSTRAINT fk_entity FOREIGN KEY ("entity_code") REFERENCES "meta"."entities"("code"),
    CONSTRAINT fk_entity_attribute FOREIGN KEY ("entity_attribute_code") REFERENCES "meta"."entity_attributes"("code")
 );

--
-- Name: entity_attributes_columns; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."entity_attributes_columns" (
    "code" SERIAL,
    "entity_entity_attribute_code" INT NOT NULL,
    "table_column_code" INT NOT NULL,
    CONSTRAINT pk_entity_attribute_column PRIMARY KEY ("code"),
    CONSTRAINT fk_entity_entity_attribute FOREIGN KEY ("entity_entity_attribute_code") REFERENCES "meta"."entity_entity_attributes"("code"),
    CONSTRAINT fk_table_column FOREIGN KEY ("table_column_code") REFERENCES "meta"."table_columns"("code")
 );
