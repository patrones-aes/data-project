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
-- Name: sources; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."sources" (
    "code" SERIAL,
    "description" CHARACTER VARYING NOT NULL,
    "type" INT NOT NULL,
    "state" CHARACTER VARYING NOT NULL,
    "created_at" TIMESTAMP NOT NULL,
    CONSTRAINT pk_source PRIMARY KEY ("code")
);

--
-- Name: source_types; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."source_types" (
    "code" SERIAL,
    "description" CHARACTER VARYING NOT NULL,
    CONSTRAINT pk_source_type PRIMARY KEY ("code")
);

--
-- Name: data_bases; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."data_bases" (
    "code" SERIAL,
    "name" CHARACTER VARYING NOT NULL,
    "ip" CHARACTER VARYING NOT NULL,
    "version" CHARACTER VARYING NOT NULL,
    "engine" INT NOT NULL,
    "source" INT NOT NULL,
    CONSTRAINT pk_data_base PRIMARY KEY ("code")
);

--
-- Name: data_base_engines; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."data_base_engines" (
    "code" SERIAL,
    "name" CHARACTER VARYING,
    CONSTRAINT pk_data_base_engine PRIMARY KEY ("code")
);

--
-- Name: tables; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."tables" (
    "code" SERIAL,
    "name" CHARACTER VARYING NOT NULL,
    "description" CHARACTER VARYING NOT NULL,
    "data_base" INT NOT NULL,
    CONSTRAINT pk_table PRIMARY KEY ("code")
);

--
-- Name: columns; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."columns" (
    "code" SERIAL,
    "name" CHARACTER VARYING NOT NULL,
    "type" INT NOT NULL,
    "table" INT NOT NULL,
    CONSTRAINT pk_column PRIMARY KEY ("code")
);

--
-- Name: column_types; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."column_types" (
    "code" SERIAL,
    "description" CHARACTER VARYING NOT NULL,
    CONSTRAINT pk_column_type PRIMARY KEY ("code")
);

--
-- Name: entities; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."entities" (
    "code" SERIAL,
    "name" CHARACTER VARYING NOT NULL,
    "description" CHARACTER VARYING NOT NULL,
    "table" INT NOT NULL,
    CONSTRAINT pk_entity PRIMARY KEY ("code")
);

--
-- Name: domain_rules; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."domain_rules" (
    "code" SERIAL,
    "name" CHARACTER VARYING NOT NULL,
    "rule" CHARACTER VARYING NOT NULL,
    "entity" INT NOT NULL,
    CONSTRAINT pk_domain_rule PRIMARY KEY ("code")
);

--
-- Name: entity_attributes; Type: TABLE; Schema: meta; Owner: -
--
CREATE TABLE "meta"."entity_attributes" (
    "code" SERIAL,
    "description" CHARACTER VARYING NOT NULL,
    "entity" INT NOT NULL,
    CONSTRAINT pk_entity_attributes PRIMARY KEY ("code")
);

ALTER TABLE
    "meta"."sources"
ADD
    CONSTRAINT "fk_source_type" FOREIGN KEY ("type") REFERENCES "meta"."source_types"("code") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE
    "meta"."data_bases"
ADD
    CONSTRAINT "fk_engine" FOREIGN KEY ("engine") REFERENCES "meta"."data_base_engines"("code") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE
    "meta"."data_bases"
ADD
    CONSTRAINT "fk_source" FOREIGN KEY ("source") REFERENCES "meta"."sources"("code") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE
    "meta"."tables"
ADD
    CONSTRAINT "fk_data_base" FOREIGN KEY ("data_base") REFERENCES "meta"."data_bases"("code") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE
    "meta"."columns"
ADD
    CONSTRAINT "fk_column_type" FOREIGN KEY ("type") REFERENCES "meta"."column_types"("code") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE
    "meta"."columns"
ADD
    CONSTRAINT "fk_tables" FOREIGN KEY ("table") REFERENCES "meta"."tables"("code") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE
    "meta"."entities"
ADD
    CONSTRAINT "fk_table" FOREIGN KEY ("table") REFERENCES "meta"."tables"("code") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE
    "meta"."domain_rules"
ADD
    CONSTRAINT "fk_entity" FOREIGN KEY ("entity") REFERENCES "meta"."entities"("code") ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE
    "meta"."entity_attributes"
ADD
    CONSTRAINT "fk_entity" FOREIGN KEY ("entity") REFERENCES "meta"."entities"("code") ON DELETE NO ACTION ON UPDATE CASCADE
