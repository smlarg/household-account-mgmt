SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

--COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: household_membership_audits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.household_membership_audits (
    id integer NOT NULL,
    household_id integer,
    member_id integer,
    event character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: household_membership_audits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.household_membership_audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: household_membership_audits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.household_membership_audits_id_seq OWNED BY public.household_membership_audits.id;


--
-- Name: households; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.households (
    id integer NOT NULL,
    balance numeric(8,2) DEFAULT 0.0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    notes text
);


--
-- Name: households_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.households_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: households_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.households_id_seq OWNED BY public.households.id;


--
-- Name: members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.members (
    id integer NOT NULL,
    last_name character varying(255),
    first_name character varying(255),
    household_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    phone1 character varying(255),
    phone2 character varying(255),
    address1 character varying(255),
    address2 character varying(255),
    city character varying(255),
    state character varying(255),
    zip character varying(255),
    notes text,
    active boolean DEFAULT true,
    email character varying(255)
);


--
-- Name: members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.members_id_seq OWNED BY public.members.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    id integer NOT NULL,
    amount numeric(8,2) NOT NULL,
    credit boolean NOT NULL,
    message character varying(255),
    household_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    void boolean DEFAULT false
);


--
-- Name: monthly_reports; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.monthly_reports AS
 SELECT date_part('year'::text, classified_transactions.created_at) AS year,
    date_part('month'::text, classified_transactions.created_at) AS month,
    sum(classified_transactions.purchase_amount) AS purchases_amount,
    sum(classified_transactions.investment_amount) AS investments_amount
   FROM ( SELECT transactions.id,
            transactions.amount,
            transactions.credit,
            transactions.message,
            transactions.household_id,
            transactions.created_at,
            transactions.updated_at,
            transactions.void,
            purchases.purchase_id,
            purchases.purchase_amount,
            investments.investment_id,
            investments.investment_amount
           FROM ((public.transactions
             LEFT JOIN ( SELECT transactions_1.id AS purchase_id,
                    transactions_1.amount AS purchase_amount
                   FROM public.transactions transactions_1
                  WHERE (transactions_1.credit = false)) purchases ON ((transactions.id = purchases.purchase_id)))
             LEFT JOIN ( SELECT transactions_1.id AS investment_id,
                    transactions_1.amount AS investment_amount
                   FROM public.transactions transactions_1
                  WHERE (transactions_1.credit = true)) investments ON ((transactions.id = investments.investment_id)))) classified_transactions
  WHERE (classified_transactions.void = false)
  GROUP BY (date_part('year'::text, classified_transactions.created_at)), (date_part('month'::text, classified_transactions.created_at))
  ORDER BY (date_part('year'::text, classified_transactions.created_at)), (date_part('month'::text, classified_transactions.created_at));


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(128) DEFAULT ''::character varying NOT NULL,
    password_salt character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    remember_token character varying(255),
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: household_membership_audits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.household_membership_audits ALTER COLUMN id SET DEFAULT nextval('public.household_membership_audits_id_seq'::regclass);


--
-- Name: households id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.households ALTER COLUMN id SET DEFAULT nextval('public.households_id_seq'::regclass);


--
-- Name: members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members ALTER COLUMN id SET DEFAULT nextval('public.members_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: household_membership_audits household_membership_audits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.household_membership_audits
    ADD CONSTRAINT household_membership_audits_pkey PRIMARY KEY (id);


--
-- Name: households households_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.households
    ADD CONSTRAINT households_pkey PRIMARY KEY (id);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20110104175816'),
('20110104184033'),
('20110113172413'),
('20110113185720'),
('20110113200251'),
('20110118190603'),
('20110120173133'),
('20110120184943'),
('20110123230006'),
('20110401195722'),
('20110401205202'),
('20111005071728'),
('20111027075756'),
('20111113205046'),
('20130115005837'),
('20130115205046'),
('20201031153623');


