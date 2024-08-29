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
-- Name: data_bases; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."databases" (
    "code" SERIAL,
    "name" CHARACTER VARYING NOT NULL,
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
    "name" CHARACTER VARYING NOT NULL,
    "database" CHARACTER VARYING NOT NULL,
    "entity" CHARACTER VARYING NOT NULL,
    CONSTRAINT pk_table PRIMARY KEY ("code")
);

--
-- Name: columns; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."columns" (
    "code" SERIAL,
    "name" CHARACTER VARYING NOT NULL,
    "type" CHARACTER VARYING NOT NULL,
    "table" CHARACTER VARYING NOT NULL,
    "key" CHARACTER VARYING,
    "length" INT,
    "entity_attribute" CHARACTER VARYING NOT NULL,
    CONSTRAINT pk_column PRIMARY KEY ("code")
);

--
-- Name: entities; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."entities" (
    "code" SERIAL,
    "name" CHARACTER VARYING NOT NULL,
    "description" CHARACTER VARYING NOT NULL,
    CONSTRAINT pk_entity PRIMARY KEY ("code")
);

--
-- Name: entity_attributes; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."entity_attributes" (
    "code" SERIAL,
    "name" CHARACTER VARYING NOT NULL,
    "description" CHARACTER VARYING NOT NULL,
    "entity" CHARACTER VARYING NOT NULL,
    CONSTRAINT pk_entity_attributes PRIMARY KEY ("code")
);
