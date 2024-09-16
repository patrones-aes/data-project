--liquibase formatted sql
--changeset felipe.amaya:1

-----------------
-- SCHEMA DIMENSIONAL 
-----------------

--
-- Name: meta; Type: SCHEMA; Schema: -; Owner: postgres
--
DROP SCHEMA IF EXISTS "dimensional" CASCADE;
CREATE SCHEMA IF NOT EXISTS "dimensional";

--
-- Name: dim_countries; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."dim_countries" (
    "id" SERIAL,
    "name" CHARACTER VARYING NOT NULL,
    "iso_2" CHARACTER VARYING NOT NULL,
    "iso_3" CHARACTER VARYING NOT NULL,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_dim_country PRIMARY KEY ("id")
);

--
-- Name: dim_states; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."dim_states" (
    "id" SERIAL,
    "name" CHARACTER VARYING NOT NULL,
    "country" INTEGER NOT NULL,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_dim_state PRIMARY KEY ("id"),
    CONSTRAINT fk_country FOREIGN KEY ("country") REFERENCES "dimensional"."dim_countries"("id")
);

--
-- Name: dim_cities; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."dim_cities" (
    "id" SERIAL,
    "name" CHARACTER VARYING NOT NULL,
    "state" INTEGER NOT NULL,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_dim_city PRIMARY KEY ("id"),
    CONSTRAINT fk_state FOREIGN KEY ("state") REFERENCES "dimensional"."dim_states"("id")
);

--
-- Name: dim_addresses; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."dim_addresses" (
    "id" SERIAL,
    "address_line_1" CHARACTER VARYING NOT NULL,
    "address_line_2" CHARACTER VARYING,
    "city" INTEGER NOT NULL,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_dim_address PRIMARY KEY ("id"),
    CONSTRAINT fk_city FOREIGN KEY ("city") REFERENCES "dimensional"."dim_cities"("id")
);

--
-- Name: dim_dates; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."dim_dates" (
    "id" SERIAL,
    "day" INTEGER,
    "month" INTEGER,
    "year" INTEGER,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_dim_date PRIMARY KEY ("id")
);

--
-- Name: dim_comments; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."dim_comments" (
    "id" SERIAL,
    "comment" TEXT,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_dim_comment PRIMARY KEY ("id")
);

--
-- Name: dim_statuses; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."dim_statuses" (
    "id" SERIAL,
    "status" CHARACTER VARYING,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_dim_status PRIMARY KEY ("id")
);

--
-- Name: dim_vendors; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."dim_vendors" (
    "id" SERIAL,
    "name" CHARACTER VARYING,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_dim_vendor PRIMARY KEY ("id")
);

--
-- Name: dim_scales; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."dim_scales" (
    id SERIAL,
    value CHARACTER VARYING NOT NULL,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_dim_scale PRIMARY KEY ("id")
);

--
-- Name: dim_job_titles; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."dim_job_titles" (
    "id" SERIAL,
    "title" CHARACTER VARYING NOT NULL,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_dim_job_title PRIMARY KEY ("id")
);

--
-- Name: dim_offices; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."dim_offices" (
    "id" SERIAL,
    "code" INTEGER UNIQUE NOT NULL,
    "address" INTEGER NOT NULL,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_dim_office PRIMARY KEY ("id"),
    CONSTRAINT fk_address FOREIGN KEY ("address") REFERENCES "dimensional"."dim_addresses"("id"),
);

--
-- Name: dim_employees; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."dim_employees" (
    "id" SERIAL,
    "code" INTEGER UNIQUE NOT NULL,
    "first_name" CHARACTER VARYING,
    "last_name" CHARACTER VARYING,
    "email" CHARACTER VARYING,
    "extension" CHARACTER VARYING,
    "job_title" INTEGER NOT NULL,
    "office" INTEGER NOT NULL,
    "manager" INTEGER NOT NULL,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_dim_employee PRIMARY KEY ("id"),
    CONSTRAINT fk_job_title FOREIGN KEY ("job_title") REFERENCES "dimensional"."dim_job_titles"("id"),
    CONSTRAINT fk_office FOREIGN KEY ("office") REFERENCES "dimensional"."dim_offices"("id"),
    CONSTRAINT fk_manager FOREIGN KEY ("manager") REFERENCES "dimensional"."dim_employees"("id")
);

--
-- Name: dim_customers; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."dim_customers" (
    "id" SERIAL,
    "code" INTEGER NOT NULL,
    "first_name" CHARACTER VARYING NOT NULL,
    "last_name" CHARACTER VARYING NOT NULL,
    "phone" CHARACTER VARYING NOT NULL,
    "credit_limit" DECIMAL NOT NULL,
    "address" INTEGER NOT NULL,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_dim_customer PRIMARY KEY ("id"),
    CONSTRAINT fk_address FOREIGN KEY ("address") REFERENCES "dimensional"."dim_addresses"("id"),
);

--
-- Name: dim_products; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."dim_products" (
    "id" SERIAL,
    "code" CHARACTER VARYING NOT NULL,
    "name" CHARACTER VARYING NOT NULL,
    "text_description" TEXT,
    "html_description" TEXT,
    "image" BYTEA,
    "stock_quantity" INTEGER NOT NULL,
    "price" DECIMAL NOT NULL,
    "suggested_price" DECIMAL NOT NULL,
    "vendor" INTEGER NOT NULL,
    "scale" INTEGER NOT NULL,
    CONSTRAINT pk_dim_product PRIMARY KEY ("id"),
    CONSTRAINT fk_vendor FOREIGN KEY ("vendor") REFERENCES "dimensional"."dim_vendors"("id"),
    CONSTRAINT fk_scale FOREIGN KEY ("scale") REFERENCES "dimensional"."dim_scales"("id"),
);

--
-- Name: fact_calls; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."fact_calls" (
    "code" INTEGER NOT NULL UNIQUE,
    "date" INTEGER NOT NULL,
    "customer" INTEGER NOT NULL,
    "product" INTEGER NOT NULL,
    "employee" INTEGER NOT NULL,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_fact_call PRIMARY KEY ("code"),
    CONSTRAINT fk_date FOREIGN KEY ("date") REFERENCES "dimensional"."dim_dates"("id"),
    CONSTRAINT fk_customer FOREIGN KEY ("customer") REFERENCES "dimensional"."dim_customers"("id"),
    CONSTRAINT fk_product FOREIGN KEY ("product") REFERENCES "dimensional"."dim_products"("id"),
    CONSTRAINT fk_employee FOREIGN KEY ("employee") REFERENCES "dimensional"."dim_employees"("id"),
);

--
-- Name: fact_orders; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."fact_orders" (
    "code" INTEGER NOT NULL UNIQUE,
    "date" INTEGER NOT NULL,
    "shipped_date" INTEGER NOT NULL,
    "requested_date" INTEGER NOT NULL,
    "comment" INTEGER NOT NULL,
    "status" INTEGER NOT NULL,
    "customer" INTEGER NOT NULL,
    "product" INTEGER NOT NULL,
    "employee" INTEGER NOT NULL,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_fact_order PRIMARY KEY ("code"),
    CONSTRAINT fk_date FOREIGN KEY ("date") REFERENCES "dimensional"."dim_dates"("id"),
    CONSTRAINT fk_shipped_date FOREIGN KEY ("shipped_date") REFERENCES "dimensional"."dim_dates"("id"),
    CONSTRAINT fk_requested_date FOREIGN KEY ("requested_date") REFERENCES "dimensional"."dim_dates"("id"),
    CONSTRAINT fk_status FOREIGN KEY ("status") REFERENCES "dimensional"."dim_statuses"("id"),
    CONSTRAINT fk_customer FOREIGN KEY ("customer") REFERENCES "dimensional"."dim_customers"("id"),
    CONSTRAINT fk_product FOREIGN KEY ("product") REFERENCES "dimensional"."dim_products"("id"),
    CONSTRAINT fk_employee FOREIGN KEY ("employee") REFERENCES "dimensional"."dim_employees"("id"),
);

--
-- Name: fact_payments; Type: TABLE; Schema: dimensional; Owner: postgres
--
CREATE TABLE "dimensional"."fact_payments" (
    "code" INTEGER NOT NULL UNIQUE,
    "customer" INTEGER NOT NULL,
    "date" INTEGER NOT NULL,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW(),
    CONSTRAINT pk_fact_payment PRIMARY KEY ("code"),
    CONSTRAINT fk_customer FOREIGN KEY ("customer") REFERENCES "dimensional"."dim_customers"("id"),
    CONSTRAINT fk_date FOREIGN KEY ("date") REFERENCES "dimensional"."dim_dates"("id"),
);
