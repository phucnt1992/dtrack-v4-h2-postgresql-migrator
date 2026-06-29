--
-- PostgreSQL database dump
--

\restrict dLrwzXXSQS0ICOy89E4IxHdEosAmUcHrKrQZkg4QVJoBEXqDNBBaUZw9yoHgXCU

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: AFFECTEDVERSIONATTRIBUTION; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."AFFECTEDVERSIONATTRIBUTION" (
    "ID" bigint NOT NULL,
    "FIRST_SEEN" timestamp with time zone NOT NULL,
    "LAST_SEEN" timestamp with time zone NOT NULL,
    "SOURCE" character varying(255) NOT NULL,
    "UUID" character varying(36) NOT NULL,
    "VULNERABILITY" bigint NOT NULL,
    "VULNERABLE_SOFTWARE" bigint NOT NULL
);


ALTER TABLE public."AFFECTEDVERSIONATTRIBUTION" OWNER TO dtrack;

--
-- Name: AFFECTEDVERSIONATTRIBUTION_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."AFFECTEDVERSIONATTRIBUTION_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."AFFECTEDVERSIONATTRIBUTION_ID_seq" OWNER TO dtrack;

--
-- Name: AFFECTEDVERSIONATTRIBUTION_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."AFFECTEDVERSIONATTRIBUTION_ID_seq" OWNED BY public."AFFECTEDVERSIONATTRIBUTION"."ID";


--
-- Name: ANALYSIS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."ANALYSIS" (
    "ID" bigint NOT NULL,
    "DETAILS" text,
    "JUSTIFICATION" character varying(255),
    "RESPONSE" character varying(255),
    "STATE" character varying(255) NOT NULL,
    "COMPONENT_ID" bigint,
    "PROJECT_ID" bigint,
    "SUPPRESSED" boolean NOT NULL,
    "VULNERABILITY_ID" bigint NOT NULL
);


ALTER TABLE public."ANALYSIS" OWNER TO dtrack;

--
-- Name: ANALYSISCOMMENT; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."ANALYSISCOMMENT" (
    "ID" bigint NOT NULL,
    "ANALYSIS_ID" bigint NOT NULL,
    "COMMENT" text NOT NULL,
    "COMMENTER" character varying(255),
    "TIMESTAMP" timestamp with time zone NOT NULL
);


ALTER TABLE public."ANALYSISCOMMENT" OWNER TO dtrack;

--
-- Name: ANALYSISCOMMENT_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."ANALYSISCOMMENT_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ANALYSISCOMMENT_ID_seq" OWNER TO dtrack;

--
-- Name: ANALYSISCOMMENT_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."ANALYSISCOMMENT_ID_seq" OWNED BY public."ANALYSISCOMMENT"."ID";


--
-- Name: ANALYSIS_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."ANALYSIS_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ANALYSIS_ID_seq" OWNER TO dtrack;

--
-- Name: ANALYSIS_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."ANALYSIS_ID_seq" OWNED BY public."ANALYSIS"."ID";


--
-- Name: APIKEY; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."APIKEY" (
    "ID" bigint NOT NULL,
    "COMMENT" character varying(255),
    "CREATED" timestamp with time zone,
    "IS_LEGACY" boolean DEFAULT false NOT NULL,
    "LAST_USED" timestamp with time zone,
    "PUBLIC_ID" character varying(8),
    "SECRET_HASH" character varying(64)
);


ALTER TABLE public."APIKEY" OWNER TO dtrack;

--
-- Name: APIKEYS_TEAMS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."APIKEYS_TEAMS" (
    "TEAM_ID" bigint NOT NULL,
    "APIKEY_ID" bigint NOT NULL
);


ALTER TABLE public."APIKEYS_TEAMS" OWNER TO dtrack;

--
-- Name: APIKEY_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."APIKEY_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."APIKEY_ID_seq" OWNER TO dtrack;

--
-- Name: APIKEY_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."APIKEY_ID_seq" OWNED BY public."APIKEY"."ID";


--
-- Name: BOM; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."BOM" (
    "ID" bigint NOT NULL,
    "BOM_FORMAT" character varying(255),
    "BOM_VERSION" integer,
    "IMPORTED" timestamp with time zone NOT NULL,
    "PROJECT_ID" bigint NOT NULL,
    "SERIAL_NUMBER" character varying(255),
    "SPEC_VERSION" character varying(255),
    "UUID" character varying(36) NOT NULL
);


ALTER TABLE public."BOM" OWNER TO dtrack;

--
-- Name: BOM_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."BOM_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."BOM_ID_seq" OWNER TO dtrack;

--
-- Name: BOM_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."BOM_ID_seq" OWNED BY public."BOM"."ID";


--
-- Name: COMPONENT; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."COMPONENT" (
    "ID" bigint NOT NULL,
    "AUTHORS" text,
    "BLAKE2B_256" character varying(64),
    "BLAKE2B_384" character varying(96),
    "BLAKE2B_512" character varying(128),
    "BLAKE3" character varying(255),
    "CLASSIFIER" character varying(255),
    "COPYRIGHT" character varying(1024),
    "CPE" character varying(255),
    "DESCRIPTION" character varying(1024),
    "DIRECT_DEPENDENCIES" text,
    "EXTENSION" character varying(255),
    "EXTERNAL_REFERENCES" bytea,
    "FILENAME" character varying(255),
    "GROUP" character varying(255),
    "INTERNAL" boolean,
    "LAST_RISKSCORE" double precision,
    "LICENSE" character varying(255),
    "LICENSE_EXPRESSION" text,
    "LICENSE_URL" character varying(255),
    "MD5" character varying(32),
    "NAME" character varying(255) NOT NULL,
    "TEXT" text,
    "PARENT_COMPONENT_ID" bigint,
    "PROJECT_ID" bigint NOT NULL,
    "PUBLISHER" character varying(255),
    "PURL" character varying(786),
    "PURLCOORDINATES" character varying(786),
    "LICENSE_ID" bigint,
    "SCOPE" character varying(255),
    "SHA1" character varying(40),
    "SHA_256" character varying(64),
    "SHA_384" character varying(96),
    "SHA3_256" character varying(64),
    "SHA3_384" character varying(96),
    "SHA3_512" character varying(128),
    "SHA_512" character varying(128),
    "SUPPLIER" text,
    "SWIDTAGID" character varying(255),
    "UUID" character varying(36) NOT NULL,
    "VERSION" character varying(255),
    CONSTRAINT "COMPONENT_CLASSIFIER_check" CHECK (((("CLASSIFIER")::text = ANY ((ARRAY['NONE'::character varying, 'APPLICATION'::character varying, 'FRAMEWORK'::character varying, 'LIBRARY'::character varying, 'CONTAINER'::character varying, 'OPERATING_SYSTEM'::character varying, 'DEVICE'::character varying, 'FIRMWARE'::character varying, 'FILE'::character varying, 'PLATFORM'::character varying, 'DEVICE_DRIVER'::character varying, 'MACHINE_LEARNING_MODEL'::character varying, 'DATA'::character varying])::text[])) OR ("CLASSIFIER" IS NULL)))
);


ALTER TABLE public."COMPONENT" OWNER TO dtrack;

--
-- Name: COMPONENTANALYSISCACHE; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."COMPONENTANALYSISCACHE" (
    "ID" bigint NOT NULL,
    "CACHE_TYPE" character varying(255) NOT NULL,
    "LAST_OCCURRENCE" timestamp with time zone NOT NULL,
    "RESULT" text,
    "TARGET" character varying(786) NOT NULL,
    "TARGET_HOST" character varying(255) NOT NULL,
    "TARGET_TYPE" character varying(255) NOT NULL,
    "UUID" character varying(36) NOT NULL
);


ALTER TABLE public."COMPONENTANALYSISCACHE" OWNER TO dtrack;

--
-- Name: COMPONENTANALYSISCACHE_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."COMPONENTANALYSISCACHE_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."COMPONENTANALYSISCACHE_ID_seq" OWNER TO dtrack;

--
-- Name: COMPONENTANALYSISCACHE_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."COMPONENTANALYSISCACHE_ID_seq" OWNED BY public."COMPONENTANALYSISCACHE"."ID";


--
-- Name: COMPONENTS_VULNERABILITIES; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."COMPONENTS_VULNERABILITIES" (
    "COMPONENT_ID" bigint NOT NULL,
    "VULNERABILITY_ID" bigint NOT NULL
);


ALTER TABLE public."COMPONENTS_VULNERABILITIES" OWNER TO dtrack;

--
-- Name: COMPONENT_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."COMPONENT_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."COMPONENT_ID_seq" OWNER TO dtrack;

--
-- Name: COMPONENT_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."COMPONENT_ID_seq" OWNED BY public."COMPONENT"."ID";


--
-- Name: COMPONENT_PROPERTY; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."COMPONENT_PROPERTY" (
    "ID" bigint NOT NULL,
    "COMPONENT_ID" bigint NOT NULL,
    "DESCRIPTION" character varying(255),
    "GROUPNAME" character varying(255),
    "PROPERTYNAME" character varying(255) NOT NULL,
    "PROPERTYTYPE" character varying(255) NOT NULL,
    "PROPERTYVALUE" character varying(1024),
    "UUID" character varying(36) NOT NULL
);


ALTER TABLE public."COMPONENT_PROPERTY" OWNER TO dtrack;

--
-- Name: COMPONENT_PROPERTY_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."COMPONENT_PROPERTY_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."COMPONENT_PROPERTY_ID_seq" OWNER TO dtrack;

--
-- Name: COMPONENT_PROPERTY_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."COMPONENT_PROPERTY_ID_seq" OWNED BY public."COMPONENT_PROPERTY"."ID";


--
-- Name: CONFIGPROPERTY; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."CONFIGPROPERTY" (
    "ID" bigint NOT NULL,
    "DESCRIPTION" character varying(255),
    "GROUPNAME" character varying(255) NOT NULL,
    "PROPERTYNAME" character varying(255) NOT NULL,
    "PROPERTYTYPE" character varying(255) NOT NULL,
    "PROPERTYVALUE" text
);


ALTER TABLE public."CONFIGPROPERTY" OWNER TO dtrack;

--
-- Name: CONFIGPROPERTY_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."CONFIGPROPERTY_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."CONFIGPROPERTY_ID_seq" OWNER TO dtrack;

--
-- Name: CONFIGPROPERTY_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."CONFIGPROPERTY_ID_seq" OWNED BY public."CONFIGPROPERTY"."ID";


--
-- Name: DEPENDENCYMETRICS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."DEPENDENCYMETRICS" (
    "ID" bigint NOT NULL,
    "COMPONENT_ID" bigint NOT NULL,
    "CRITICAL" integer NOT NULL,
    "FINDINGS_AUDITED" integer,
    "FINDINGS_TOTAL" integer,
    "FINDINGS_UNAUDITED" integer,
    "FIRST_OCCURRENCE" timestamp with time zone NOT NULL,
    "HIGH" integer NOT NULL,
    "RISKSCORE" double precision NOT NULL,
    "LAST_OCCURRENCE" timestamp with time zone NOT NULL,
    "LOW" integer NOT NULL,
    "MEDIUM" integer NOT NULL,
    "POLICYVIOLATIONS_AUDITED" integer,
    "POLICYVIOLATIONS_FAIL" integer,
    "POLICYVIOLATIONS_INFO" integer,
    "POLICYVIOLATIONS_LICENSE_AUDITED" integer,
    "POLICYVIOLATIONS_LICENSE_TOTAL" integer,
    "POLICYVIOLATIONS_LICENSE_UNAUDITED" integer,
    "POLICYVIOLATIONS_OPERATIONAL_AUDITED" integer,
    "POLICYVIOLATIONS_OPERATIONAL_TOTAL" integer,
    "POLICYVIOLATIONS_OPERATIONAL_UNAUDITED" integer,
    "POLICYVIOLATIONS_SECURITY_AUDITED" integer,
    "POLICYVIOLATIONS_SECURITY_TOTAL" integer,
    "POLICYVIOLATIONS_SECURITY_UNAUDITED" integer,
    "POLICYVIOLATIONS_TOTAL" integer,
    "POLICYVIOLATIONS_UNAUDITED" integer,
    "POLICYVIOLATIONS_WARN" integer,
    "PROJECT_ID" bigint NOT NULL,
    "SUPPRESSED" integer NOT NULL,
    "UNASSIGNED_SEVERITY" integer,
    "VULNERABILITIES" integer NOT NULL
);


ALTER TABLE public."DEPENDENCYMETRICS" OWNER TO dtrack;

--
-- Name: DEPENDENCYMETRICS_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."DEPENDENCYMETRICS_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."DEPENDENCYMETRICS_ID_seq" OWNER TO dtrack;

--
-- Name: DEPENDENCYMETRICS_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."DEPENDENCYMETRICS_ID_seq" OWNED BY public."DEPENDENCYMETRICS"."ID";


--
-- Name: EVENTSERVICELOG; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."EVENTSERVICELOG" (
    "ID" bigint NOT NULL,
    "COMPLETED" timestamp with time zone,
    "STARTED" timestamp with time zone,
    "SUBSCRIBERCLASS" character varying(255) NOT NULL
);


ALTER TABLE public."EVENTSERVICELOG" OWNER TO dtrack;

--
-- Name: EVENTSERVICELOG_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."EVENTSERVICELOG_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."EVENTSERVICELOG_ID_seq" OWNER TO dtrack;

--
-- Name: EVENTSERVICELOG_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."EVENTSERVICELOG_ID_seq" OWNED BY public."EVENTSERVICELOG"."ID";


--
-- Name: FINDINGATTRIBUTION; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."FINDINGATTRIBUTION" (
    "ID" bigint NOT NULL,
    "ALT_ID" character varying(255),
    "ANALYZERIDENTITY" character varying(255) NOT NULL,
    "ATTRIBUTED_ON" timestamp with time zone NOT NULL,
    "COMPONENT_ID" bigint NOT NULL,
    "PROJECT_ID" bigint NOT NULL,
    "REFERENCE_URL" character varying(255),
    "UUID" character varying(36) NOT NULL,
    "VULNERABILITY_ID" bigint NOT NULL
);


ALTER TABLE public."FINDINGATTRIBUTION" OWNER TO dtrack;

--
-- Name: FINDINGATTRIBUTION_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."FINDINGATTRIBUTION_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."FINDINGATTRIBUTION_ID_seq" OWNER TO dtrack;

--
-- Name: FINDINGATTRIBUTION_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."FINDINGATTRIBUTION_ID_seq" OWNED BY public."FINDINGATTRIBUTION"."ID";


--
-- Name: INSTALLEDUPGRADES; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."INSTALLEDUPGRADES" (
    "ID" bigint NOT NULL,
    "ENDTIME" timestamp with time zone,
    "STARTTIME" timestamp with time zone,
    "UPGRADECLASS" character varying(255)
);


ALTER TABLE public."INSTALLEDUPGRADES" OWNER TO dtrack;

--
-- Name: INSTALLEDUPGRADES_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."INSTALLEDUPGRADES_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."INSTALLEDUPGRADES_ID_seq" OWNER TO dtrack;

--
-- Name: INSTALLEDUPGRADES_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."INSTALLEDUPGRADES_ID_seq" OWNED BY public."INSTALLEDUPGRADES"."ID";


--
-- Name: LDAPUSER; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."LDAPUSER" (
    "ID" bigint NOT NULL,
    "DN" character varying(255) NOT NULL,
    "EMAIL" character varying(255),
    "USERNAME" character varying(255)
);


ALTER TABLE public."LDAPUSER" OWNER TO dtrack;

--
-- Name: LDAPUSERS_PERMISSIONS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."LDAPUSERS_PERMISSIONS" (
    "LDAPUSER_ID" bigint NOT NULL,
    "PERMISSION_ID" bigint NOT NULL
);


ALTER TABLE public."LDAPUSERS_PERMISSIONS" OWNER TO dtrack;

--
-- Name: LDAPUSERS_TEAMS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."LDAPUSERS_TEAMS" (
    "TEAM_ID" bigint NOT NULL,
    "LDAPUSER_ID" bigint NOT NULL
);


ALTER TABLE public."LDAPUSERS_TEAMS" OWNER TO dtrack;

--
-- Name: LDAPUSER_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."LDAPUSER_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."LDAPUSER_ID_seq" OWNER TO dtrack;

--
-- Name: LDAPUSER_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."LDAPUSER_ID_seq" OWNED BY public."LDAPUSER"."ID";


--
-- Name: LICENSE; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."LICENSE" (
    "ID" bigint NOT NULL,
    "COMMENT" text,
    "ISCUSTOMLICENSE" boolean,
    "ISDEPRECATED" boolean NOT NULL,
    "FSFLIBRE" boolean,
    "HEADER" text,
    "LICENSEID" character varying(255),
    "NAME" character varying(255) NOT NULL,
    "ISOSIAPPROVED" boolean NOT NULL,
    "SEEALSO" bytea,
    "TEMPLATE" text,
    "TEXT" text,
    "UUID" character varying(36) NOT NULL
);


ALTER TABLE public."LICENSE" OWNER TO dtrack;

--
-- Name: LICENSEGROUP; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."LICENSEGROUP" (
    "ID" bigint NOT NULL,
    "NAME" character varying(255) NOT NULL,
    "RISKWEIGHT" integer NOT NULL,
    "UUID" character varying(36) NOT NULL
);


ALTER TABLE public."LICENSEGROUP" OWNER TO dtrack;

--
-- Name: LICENSEGROUP_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."LICENSEGROUP_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."LICENSEGROUP_ID_seq" OWNER TO dtrack;

--
-- Name: LICENSEGROUP_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."LICENSEGROUP_ID_seq" OWNED BY public."LICENSEGROUP"."ID";


--
-- Name: LICENSEGROUP_LICENSE; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."LICENSEGROUP_LICENSE" (
    "LICENSEGROUP_ID" bigint NOT NULL,
    "LICENSE_ID" bigint NOT NULL
);


ALTER TABLE public."LICENSEGROUP_LICENSE" OWNER TO dtrack;

--
-- Name: LICENSE_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."LICENSE_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."LICENSE_ID_seq" OWNER TO dtrack;

--
-- Name: LICENSE_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."LICENSE_ID_seq" OWNED BY public."LICENSE"."ID";


--
-- Name: MANAGEDUSER; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."MANAGEDUSER" (
    "ID" bigint NOT NULL,
    "EMAIL" character varying(255),
    "FORCE_PASSWORD_CHANGE" boolean NOT NULL,
    "FULLNAME" character varying(255),
    "LAST_PASSWORD_CHANGE" timestamp with time zone NOT NULL,
    "NON_EXPIRY_PASSWORD" boolean NOT NULL,
    "PASSWORD" character varying(255) NOT NULL,
    "SUSPENDED" boolean NOT NULL,
    "USERNAME" character varying(255)
);


ALTER TABLE public."MANAGEDUSER" OWNER TO dtrack;

--
-- Name: MANAGEDUSERS_PERMISSIONS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."MANAGEDUSERS_PERMISSIONS" (
    "MANAGEDUSER_ID" bigint NOT NULL,
    "PERMISSION_ID" bigint NOT NULL
);


ALTER TABLE public."MANAGEDUSERS_PERMISSIONS" OWNER TO dtrack;

--
-- Name: MANAGEDUSERS_TEAMS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."MANAGEDUSERS_TEAMS" (
    "TEAM_ID" bigint NOT NULL,
    "MANAGEDUSER_ID" bigint NOT NULL
);


ALTER TABLE public."MANAGEDUSERS_TEAMS" OWNER TO dtrack;

--
-- Name: MANAGEDUSER_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."MANAGEDUSER_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."MANAGEDUSER_ID_seq" OWNER TO dtrack;

--
-- Name: MANAGEDUSER_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."MANAGEDUSER_ID_seq" OWNED BY public."MANAGEDUSER"."ID";


--
-- Name: MAPPEDLDAPGROUP; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."MAPPEDLDAPGROUP" (
    "ID" bigint NOT NULL,
    "DN" character varying(1024) NOT NULL,
    "TEAM_ID" bigint NOT NULL,
    "UUID" character varying(36) NOT NULL
);


ALTER TABLE public."MAPPEDLDAPGROUP" OWNER TO dtrack;

--
-- Name: MAPPEDLDAPGROUP_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."MAPPEDLDAPGROUP_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."MAPPEDLDAPGROUP_ID_seq" OWNER TO dtrack;

--
-- Name: MAPPEDLDAPGROUP_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."MAPPEDLDAPGROUP_ID_seq" OWNED BY public."MAPPEDLDAPGROUP"."ID";


--
-- Name: MAPPEDOIDCGROUP; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."MAPPEDOIDCGROUP" (
    "ID" bigint NOT NULL,
    "GROUP_ID" bigint NOT NULL,
    "TEAM_ID" bigint NOT NULL,
    "UUID" character varying(36) NOT NULL
);


ALTER TABLE public."MAPPEDOIDCGROUP" OWNER TO dtrack;

--
-- Name: MAPPEDOIDCGROUP_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."MAPPEDOIDCGROUP_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."MAPPEDOIDCGROUP_ID_seq" OWNER TO dtrack;

--
-- Name: MAPPEDOIDCGROUP_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."MAPPEDOIDCGROUP_ID_seq" OWNED BY public."MAPPEDOIDCGROUP"."ID";


--
-- Name: NOTIFICATIONPUBLISHER; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."NOTIFICATIONPUBLISHER" (
    "ID" bigint NOT NULL,
    "DEFAULT_PUBLISHER" boolean NOT NULL,
    "DESCRIPTION" character varying(255),
    "NAME" character varying(255) NOT NULL,
    "PUBLISHER_CLASS" character varying(1024) NOT NULL,
    "TEMPLATE" text,
    "TEMPLATE_MIME_TYPE" character varying(255) NOT NULL,
    "UUID" character varying(36) NOT NULL
);


ALTER TABLE public."NOTIFICATIONPUBLISHER" OWNER TO dtrack;

--
-- Name: NOTIFICATIONPUBLISHER_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."NOTIFICATIONPUBLISHER_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."NOTIFICATIONPUBLISHER_ID_seq" OWNER TO dtrack;

--
-- Name: NOTIFICATIONPUBLISHER_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."NOTIFICATIONPUBLISHER_ID_seq" OWNED BY public."NOTIFICATIONPUBLISHER"."ID";


--
-- Name: NOTIFICATIONRULE; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."NOTIFICATIONRULE" (
    "ID" bigint NOT NULL,
    "ENABLED" boolean NOT NULL,
    "LOG_SUCCESSFUL_PUBLISH" boolean,
    "MESSAGE" character varying(1024),
    "NAME" character varying(255) NOT NULL,
    "NOTIFICATION_LEVEL" character varying(255),
    "NOTIFY_CHILDREN" boolean,
    "NOTIFY_ON" character varying(1024),
    "PUBLISHER" bigint,
    "PUBLISHER_CONFIG" text,
    "SCHEDULE_CRON" character varying(255),
    "SCHEDULE_LAST_TRIGGERED_AT" timestamp with time zone,
    "SCHEDULE_NEXT_TRIGGER_AT" timestamp with time zone,
    "SCHEDULE_SKIP_UNCHANGED" boolean,
    "SCOPE" character varying(255) NOT NULL,
    "TRIGGER_TYPE" character varying(255) DEFAULT 'EVENT'::character varying NOT NULL,
    "UUID" character varying(36) NOT NULL
);


ALTER TABLE public."NOTIFICATIONRULE" OWNER TO dtrack;

--
-- Name: NOTIFICATIONRULE_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."NOTIFICATIONRULE_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."NOTIFICATIONRULE_ID_seq" OWNER TO dtrack;

--
-- Name: NOTIFICATIONRULE_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."NOTIFICATIONRULE_ID_seq" OWNED BY public."NOTIFICATIONRULE"."ID";


--
-- Name: NOTIFICATIONRULE_PROJECTS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."NOTIFICATIONRULE_PROJECTS" (
    "NOTIFICATIONRULE_ID" bigint NOT NULL,
    "PROJECT_ID" bigint
);


ALTER TABLE public."NOTIFICATIONRULE_PROJECTS" OWNER TO dtrack;

--
-- Name: NOTIFICATIONRULE_TAGS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."NOTIFICATIONRULE_TAGS" (
    "NOTIFICATIONRULE_ID" bigint NOT NULL,
    "TAG_ID" bigint NOT NULL
);


ALTER TABLE public."NOTIFICATIONRULE_TAGS" OWNER TO dtrack;

--
-- Name: NOTIFICATIONRULE_TEAMS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."NOTIFICATIONRULE_TEAMS" (
    "NOTIFICATIONRULE_ID" bigint NOT NULL,
    "TEAM_ID" bigint
);


ALTER TABLE public."NOTIFICATIONRULE_TEAMS" OWNER TO dtrack;

--
-- Name: OIDCGROUP; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."OIDCGROUP" (
    "ID" bigint NOT NULL,
    "NAME" character varying(1024) NOT NULL,
    "UUID" character varying(36) NOT NULL
);


ALTER TABLE public."OIDCGROUP" OWNER TO dtrack;

--
-- Name: OIDCGROUP_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."OIDCGROUP_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."OIDCGROUP_ID_seq" OWNER TO dtrack;

--
-- Name: OIDCGROUP_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."OIDCGROUP_ID_seq" OWNED BY public."OIDCGROUP"."ID";


--
-- Name: OIDCUSER; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."OIDCUSER" (
    "ID" bigint NOT NULL,
    "EMAIL" character varying(255),
    "SUBJECT_IDENTIFIER" character varying(255),
    "USERNAME" character varying(255) NOT NULL
);


ALTER TABLE public."OIDCUSER" OWNER TO dtrack;

--
-- Name: OIDCUSERS_PERMISSIONS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."OIDCUSERS_PERMISSIONS" (
    "PERMISSION_ID" bigint NOT NULL,
    "OIDCUSER_ID" bigint NOT NULL
);


ALTER TABLE public."OIDCUSERS_PERMISSIONS" OWNER TO dtrack;

--
-- Name: OIDCUSERS_TEAMS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."OIDCUSERS_TEAMS" (
    "OIDCUSERS_ID" bigint NOT NULL,
    "TEAM_ID" bigint NOT NULL
);


ALTER TABLE public."OIDCUSERS_TEAMS" OWNER TO dtrack;

--
-- Name: OIDCUSER_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."OIDCUSER_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."OIDCUSER_ID_seq" OWNER TO dtrack;

--
-- Name: OIDCUSER_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."OIDCUSER_ID_seq" OWNED BY public."OIDCUSER"."ID";


--
-- Name: PERMISSION; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."PERMISSION" (
    "ID" bigint NOT NULL,
    "DESCRIPTION" text,
    "NAME" character varying(255) NOT NULL
);


ALTER TABLE public."PERMISSION" OWNER TO dtrack;

--
-- Name: PERMISSION_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."PERMISSION_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."PERMISSION_ID_seq" OWNER TO dtrack;

--
-- Name: PERMISSION_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."PERMISSION_ID_seq" OWNED BY public."PERMISSION"."ID";


--
-- Name: POLICY; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."POLICY" (
    "ID" bigint NOT NULL,
    "INCLUDE_CHILDREN" boolean,
    "NAME" character varying(255) NOT NULL,
    "ONLY_LATEST_PROJECT_VERSION" boolean DEFAULT false NOT NULL,
    "OPERATOR" character varying(255) NOT NULL,
    "UUID" character varying(36) NOT NULL,
    "VIOLATIONSTATE" character varying(255) NOT NULL
);


ALTER TABLE public."POLICY" OWNER TO dtrack;

--
-- Name: POLICYCONDITION; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."POLICYCONDITION" (
    "ID" bigint NOT NULL,
    "OPERATOR" character varying(255) NOT NULL,
    "POLICY_ID" bigint NOT NULL,
    "SUBJECT" character varying(255) NOT NULL,
    "UUID" character varying(36) NOT NULL,
    "VALUE" character varying(255) NOT NULL
);


ALTER TABLE public."POLICYCONDITION" OWNER TO dtrack;

--
-- Name: POLICYCONDITION_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."POLICYCONDITION_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."POLICYCONDITION_ID_seq" OWNER TO dtrack;

--
-- Name: POLICYCONDITION_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."POLICYCONDITION_ID_seq" OWNED BY public."POLICYCONDITION"."ID";


--
-- Name: POLICYVIOLATION; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."POLICYVIOLATION" (
    "ID" bigint NOT NULL,
    "COMPONENT_ID" bigint NOT NULL,
    "POLICYCONDITION_ID" bigint NOT NULL,
    "PROJECT_ID" bigint NOT NULL,
    "TEXT" character varying(255),
    "TIMESTAMP" timestamp with time zone NOT NULL,
    "TYPE" character varying(255) NOT NULL,
    "UUID" character varying(36) NOT NULL
);


ALTER TABLE public."POLICYVIOLATION" OWNER TO dtrack;

--
-- Name: POLICYVIOLATION_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."POLICYVIOLATION_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."POLICYVIOLATION_ID_seq" OWNER TO dtrack;

--
-- Name: POLICYVIOLATION_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."POLICYVIOLATION_ID_seq" OWNED BY public."POLICYVIOLATION"."ID";


--
-- Name: POLICY_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."POLICY_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."POLICY_ID_seq" OWNER TO dtrack;

--
-- Name: POLICY_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."POLICY_ID_seq" OWNED BY public."POLICY"."ID";


--
-- Name: POLICY_PROJECTS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."POLICY_PROJECTS" (
    "POLICY_ID" bigint NOT NULL,
    "PROJECT_ID" bigint
);


ALTER TABLE public."POLICY_PROJECTS" OWNER TO dtrack;

--
-- Name: POLICY_TAGS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."POLICY_TAGS" (
    "TAG_ID" bigint NOT NULL,
    "POLICY_ID" bigint NOT NULL
);


ALTER TABLE public."POLICY_TAGS" OWNER TO dtrack;

--
-- Name: PORTFOLIOMETRICS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."PORTFOLIOMETRICS" (
    "ID" bigint NOT NULL,
    "COMPONENTS" integer NOT NULL,
    "CRITICAL" integer NOT NULL,
    "FINDINGS_AUDITED" integer,
    "FINDINGS_TOTAL" integer,
    "FINDINGS_UNAUDITED" integer,
    "FIRST_OCCURRENCE" timestamp with time zone NOT NULL,
    "HIGH" integer NOT NULL,
    "RISKSCORE" double precision NOT NULL,
    "LAST_OCCURRENCE" timestamp with time zone NOT NULL,
    "LOW" integer NOT NULL,
    "MEDIUM" integer NOT NULL,
    "POLICYVIOLATIONS_AUDITED" integer,
    "POLICYVIOLATIONS_FAIL" integer,
    "POLICYVIOLATIONS_INFO" integer,
    "POLICYVIOLATIONS_LICENSE_AUDITED" integer,
    "POLICYVIOLATIONS_LICENSE_TOTAL" integer,
    "POLICYVIOLATIONS_LICENSE_UNAUDITED" integer,
    "POLICYVIOLATIONS_OPERATIONAL_AUDITED" integer,
    "POLICYVIOLATIONS_OPERATIONAL_TOTAL" integer,
    "POLICYVIOLATIONS_OPERATIONAL_UNAUDITED" integer,
    "POLICYVIOLATIONS_SECURITY_AUDITED" integer,
    "POLICYVIOLATIONS_SECURITY_TOTAL" integer,
    "POLICYVIOLATIONS_SECURITY_UNAUDITED" integer,
    "POLICYVIOLATIONS_TOTAL" integer,
    "POLICYVIOLATIONS_UNAUDITED" integer,
    "POLICYVIOLATIONS_WARN" integer,
    "PROJECTS" integer NOT NULL,
    "SUPPRESSED" integer NOT NULL,
    "UNASSIGNED_SEVERITY" integer,
    "VULNERABILITIES" integer NOT NULL,
    "VULNERABLECOMPONENTS" integer NOT NULL,
    "VULNERABLEPROJECTS" integer NOT NULL
);


ALTER TABLE public."PORTFOLIOMETRICS" OWNER TO dtrack;

--
-- Name: PORTFOLIOMETRICS_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."PORTFOLIOMETRICS_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."PORTFOLIOMETRICS_ID_seq" OWNER TO dtrack;

--
-- Name: PORTFOLIOMETRICS_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."PORTFOLIOMETRICS_ID_seq" OWNED BY public."PORTFOLIOMETRICS"."ID";


--
-- Name: PROJECT; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."PROJECT" (
    "ID" bigint NOT NULL,
    "ACTIVE" boolean DEFAULT true NOT NULL,
    "AUTHORS" text,
    "CLASSIFIER" character varying(255),
    "COLLECTION_LOGIC" character varying(255),
    "COLLECTION_TAG" bigint,
    "CPE" character varying(255),
    "DESCRIPTION" character varying(255),
    "DIRECT_DEPENDENCIES" text,
    "EXTERNAL_REFERENCES" bytea,
    "GROUP" character varying(255),
    "IS_LATEST" boolean DEFAULT false NOT NULL,
    "LAST_BOM_IMPORTED" timestamp with time zone,
    "LAST_BOM_IMPORTED_FORMAT" character varying(255),
    "LAST_RISKSCORE" double precision,
    "LAST_VULNERABILITY_ANALYSIS" timestamp with time zone,
    "MANUFACTURER" text,
    "NAME" character varying(255) NOT NULL,
    "PARENT_PROJECT_ID" bigint,
    "PUBLISHER" character varying(255),
    "PURL" character varying(786),
    "SUPPLIER" text,
    "SWIDTAGID" character varying(255),
    "UUID" character varying(36) NOT NULL,
    "VERSION" character varying(255),
    CONSTRAINT "PROJECT_CLASSIFIER_check" CHECK (((("CLASSIFIER")::text = ANY ((ARRAY['NONE'::character varying, 'APPLICATION'::character varying, 'FRAMEWORK'::character varying, 'LIBRARY'::character varying, 'CONTAINER'::character varying, 'OPERATING_SYSTEM'::character varying, 'DEVICE'::character varying, 'FIRMWARE'::character varying, 'FILE'::character varying, 'PLATFORM'::character varying, 'DEVICE_DRIVER'::character varying, 'MACHINE_LEARNING_MODEL'::character varying, 'DATA'::character varying])::text[])) OR ("CLASSIFIER" IS NULL))),
    CONSTRAINT "PROJECT_COLLECTION_LOGIC_check" CHECK (((("COLLECTION_LOGIC")::text = ANY ((ARRAY['NONE'::character varying, 'AGGREGATE_DIRECT_CHILDREN'::character varying, 'AGGREGATE_DIRECT_CHILDREN_WITH_TAG'::character varying, 'AGGREGATE_LATEST_VERSION_CHILDREN'::character varying])::text[])) OR ("COLLECTION_LOGIC" IS NULL)))
);


ALTER TABLE public."PROJECT" OWNER TO dtrack;

--
-- Name: PROJECTMETRICS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."PROJECTMETRICS" (
    "ID" bigint NOT NULL,
    "COLLECTION_LOGIC" character varying(255),
    "COLLECTION_LOGIC_CHANGED" boolean DEFAULT false NOT NULL,
    "COMPONENTS" integer NOT NULL,
    "CRITICAL" integer NOT NULL,
    "FINDINGS_AUDITED" integer,
    "FINDINGS_TOTAL" integer,
    "FINDINGS_UNAUDITED" integer,
    "FIRST_OCCURRENCE" timestamp with time zone NOT NULL,
    "HIGH" integer NOT NULL,
    "RISKSCORE" double precision NOT NULL,
    "LAST_OCCURRENCE" timestamp with time zone NOT NULL,
    "LOW" integer NOT NULL,
    "MEDIUM" integer NOT NULL,
    "POLICYVIOLATIONS_AUDITED" integer,
    "POLICYVIOLATIONS_FAIL" integer,
    "POLICYVIOLATIONS_INFO" integer,
    "POLICYVIOLATIONS_LICENSE_AUDITED" integer,
    "POLICYVIOLATIONS_LICENSE_TOTAL" integer,
    "POLICYVIOLATIONS_LICENSE_UNAUDITED" integer,
    "POLICYVIOLATIONS_OPERATIONAL_AUDITED" integer,
    "POLICYVIOLATIONS_OPERATIONAL_TOTAL" integer,
    "POLICYVIOLATIONS_OPERATIONAL_UNAUDITED" integer,
    "POLICYVIOLATIONS_SECURITY_AUDITED" integer,
    "POLICYVIOLATIONS_SECURITY_TOTAL" integer,
    "POLICYVIOLATIONS_SECURITY_UNAUDITED" integer,
    "POLICYVIOLATIONS_TOTAL" integer,
    "POLICYVIOLATIONS_UNAUDITED" integer,
    "POLICYVIOLATIONS_WARN" integer,
    "PROJECT_ID" bigint NOT NULL,
    "SUPPRESSED" integer NOT NULL,
    "UNASSIGNED_SEVERITY" integer,
    "VULNERABILITIES" integer NOT NULL,
    "VULNERABLECOMPONENTS" integer NOT NULL
);


ALTER TABLE public."PROJECTMETRICS" OWNER TO dtrack;

--
-- Name: PROJECTMETRICS_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."PROJECTMETRICS_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."PROJECTMETRICS_ID_seq" OWNER TO dtrack;

--
-- Name: PROJECTMETRICS_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."PROJECTMETRICS_ID_seq" OWNED BY public."PROJECTMETRICS"."ID";


--
-- Name: PROJECTS_TAGS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."PROJECTS_TAGS" (
    "TAG_ID" bigint NOT NULL,
    "PROJECT_ID" bigint NOT NULL
);


ALTER TABLE public."PROJECTS_TAGS" OWNER TO dtrack;

--
-- Name: PROJECT_ACCESS_TEAMS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."PROJECT_ACCESS_TEAMS" (
    "PROJECT_ID" bigint NOT NULL,
    "TEAM_ID" bigint
);


ALTER TABLE public."PROJECT_ACCESS_TEAMS" OWNER TO dtrack;

--
-- Name: PROJECT_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."PROJECT_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."PROJECT_ID_seq" OWNER TO dtrack;

--
-- Name: PROJECT_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."PROJECT_ID_seq" OWNED BY public."PROJECT"."ID";


--
-- Name: PROJECT_METADATA; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."PROJECT_METADATA" (
    "ID" bigint NOT NULL,
    "AUTHORS" text,
    "PROJECT_ID" bigint NOT NULL,
    "SUPPLIER" text
);


ALTER TABLE public."PROJECT_METADATA" OWNER TO dtrack;

--
-- Name: PROJECT_METADATA_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."PROJECT_METADATA_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."PROJECT_METADATA_ID_seq" OWNER TO dtrack;

--
-- Name: PROJECT_METADATA_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."PROJECT_METADATA_ID_seq" OWNED BY public."PROJECT_METADATA"."ID";


--
-- Name: PROJECT_PROPERTY; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."PROJECT_PROPERTY" (
    "ID" bigint NOT NULL,
    "DESCRIPTION" character varying(255),
    "GROUPNAME" character varying(255) NOT NULL,
    "PROJECT_ID" bigint NOT NULL,
    "PROPERTYNAME" character varying(255) NOT NULL,
    "PROPERTYTYPE" character varying(255) NOT NULL,
    "PROPERTYVALUE" character varying(1024)
);


ALTER TABLE public."PROJECT_PROPERTY" OWNER TO dtrack;

--
-- Name: PROJECT_PROPERTY_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."PROJECT_PROPERTY_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."PROJECT_PROPERTY_ID_seq" OWNER TO dtrack;

--
-- Name: PROJECT_PROPERTY_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."PROJECT_PROPERTY_ID_seq" OWNED BY public."PROJECT_PROPERTY"."ID";


--
-- Name: REPOSITORY; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."REPOSITORY" (
    "ID" bigint NOT NULL,
    "AUTHENTICATIONREQUIRED" boolean,
    "ENABLED" boolean NOT NULL,
    "IDENTIFIER" character varying(255) NOT NULL,
    "INTERNAL" boolean,
    "PASSWORD" character varying(255),
    "RESOLUTION_ORDER" integer NOT NULL,
    "TYPE" character varying(255) NOT NULL,
    "URL" character varying(255),
    "USERNAME" character varying(255),
    "UUID" character varying(36)
);


ALTER TABLE public."REPOSITORY" OWNER TO dtrack;

--
-- Name: REPOSITORY_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."REPOSITORY_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."REPOSITORY_ID_seq" OWNER TO dtrack;

--
-- Name: REPOSITORY_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."REPOSITORY_ID_seq" OWNED BY public."REPOSITORY"."ID";


--
-- Name: REPOSITORY_META_COMPONENT; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."REPOSITORY_META_COMPONENT" (
    "ID" bigint NOT NULL,
    "LAST_CHECK" timestamp with time zone NOT NULL,
    "LATEST_VERSION" character varying(255) NOT NULL,
    "NAME" character varying(255) NOT NULL,
    "NAMESPACE" character varying(255),
    "PUBLISHED" timestamp with time zone,
    "REPOSITORY_TYPE" character varying(255) NOT NULL
);


ALTER TABLE public."REPOSITORY_META_COMPONENT" OWNER TO dtrack;

--
-- Name: REPOSITORY_META_COMPONENT_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."REPOSITORY_META_COMPONENT_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."REPOSITORY_META_COMPONENT_ID_seq" OWNER TO dtrack;

--
-- Name: REPOSITORY_META_COMPONENT_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."REPOSITORY_META_COMPONENT_ID_seq" OWNED BY public."REPOSITORY_META_COMPONENT"."ID";


--
-- Name: SCHEMAVERSION; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."SCHEMAVERSION" (
    "ID" bigint NOT NULL,
    "VERSION" character varying(255)
);


ALTER TABLE public."SCHEMAVERSION" OWNER TO dtrack;

--
-- Name: SCHEMAVERSION_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."SCHEMAVERSION_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."SCHEMAVERSION_ID_seq" OWNER TO dtrack;

--
-- Name: SCHEMAVERSION_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."SCHEMAVERSION_ID_seq" OWNED BY public."SCHEMAVERSION"."ID";


--
-- Name: SERVICECOMPONENT; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."SERVICECOMPONENT" (
    "ID" bigint NOT NULL,
    "AUTHENTICATED" boolean,
    "X_TRUST_BOUNDARY" boolean,
    "DATA" bytea,
    "DESCRIPTION" character varying(1024),
    "ENDPOINTS" bytea,
    "EXTERNAL_REFERENCES" bytea,
    "GROUP" character varying(255),
    "LAST_RISKSCORE" double precision DEFAULT 0 NOT NULL,
    "NAME" character varying(255) NOT NULL,
    "TEXT" text,
    "PARENT_SERVICECOMPONENT_ID" bigint,
    "PROJECT_ID" bigint NOT NULL,
    "PROVIDER_ID" bytea,
    "UUID" character varying(36) NOT NULL,
    "VERSION" character varying(255)
);


ALTER TABLE public."SERVICECOMPONENT" OWNER TO dtrack;

--
-- Name: SERVICECOMPONENTS_VULNERABILITIES; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."SERVICECOMPONENTS_VULNERABILITIES" (
    "VULNERABILITY_ID" bigint NOT NULL,
    "SERVICECOMPONENT_ID" bigint NOT NULL
);


ALTER TABLE public."SERVICECOMPONENTS_VULNERABILITIES" OWNER TO dtrack;

--
-- Name: SERVICECOMPONENT_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."SERVICECOMPONENT_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."SERVICECOMPONENT_ID_seq" OWNER TO dtrack;

--
-- Name: SERVICECOMPONENT_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."SERVICECOMPONENT_ID_seq" OWNED BY public."SERVICECOMPONENT"."ID";


--
-- Name: TAG; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."TAG" (
    "ID" bigint NOT NULL,
    "NAME" character varying(255) NOT NULL
);


ALTER TABLE public."TAG" OWNER TO dtrack;

--
-- Name: TAG_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."TAG_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."TAG_ID_seq" OWNER TO dtrack;

--
-- Name: TAG_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."TAG_ID_seq" OWNED BY public."TAG"."ID";


--
-- Name: TEAM; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."TEAM" (
    "ID" bigint NOT NULL,
    "NAME" character varying(255) NOT NULL,
    "UUID" character varying(36) NOT NULL
);


ALTER TABLE public."TEAM" OWNER TO dtrack;

--
-- Name: TEAMS_PERMISSIONS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."TEAMS_PERMISSIONS" (
    "TEAM_ID" bigint NOT NULL,
    "PERMISSION_ID" bigint NOT NULL
);


ALTER TABLE public."TEAMS_PERMISSIONS" OWNER TO dtrack;

--
-- Name: TEAM_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."TEAM_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."TEAM_ID_seq" OWNER TO dtrack;

--
-- Name: TEAM_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."TEAM_ID_seq" OWNED BY public."TEAM"."ID";


--
-- Name: VEX; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."VEX" (
    "ID" bigint NOT NULL,
    "IMPORTED" timestamp with time zone NOT NULL,
    "PROJECT_ID" bigint NOT NULL,
    "SERIAL_NUMBER" character varying(255),
    "SPEC_VERSION" character varying(255),
    "UUID" character varying(36) NOT NULL,
    "VEX_FORMAT" character varying(255),
    "VEX_VERSION" integer
);


ALTER TABLE public."VEX" OWNER TO dtrack;

--
-- Name: VEX_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."VEX_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."VEX_ID_seq" OWNER TO dtrack;

--
-- Name: VEX_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."VEX_ID_seq" OWNED BY public."VEX"."ID";


--
-- Name: VIOLATIONANALYSIS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."VIOLATIONANALYSIS" (
    "ID" bigint NOT NULL,
    "STATE" character varying(255) NOT NULL,
    "COMPONENT_ID" bigint,
    "POLICYVIOLATION_ID" bigint NOT NULL,
    "PROJECT_ID" bigint,
    "SUPPRESSED" boolean NOT NULL
);


ALTER TABLE public."VIOLATIONANALYSIS" OWNER TO dtrack;

--
-- Name: VIOLATIONANALYSISCOMMENT; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."VIOLATIONANALYSISCOMMENT" (
    "ID" bigint NOT NULL,
    "COMMENT" text NOT NULL,
    "COMMENTER" character varying(255),
    "TIMESTAMP" timestamp with time zone NOT NULL,
    "VIOLATIONANALYSIS_ID" bigint NOT NULL
);


ALTER TABLE public."VIOLATIONANALYSISCOMMENT" OWNER TO dtrack;

--
-- Name: VIOLATIONANALYSISCOMMENT_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."VIOLATIONANALYSISCOMMENT_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."VIOLATIONANALYSISCOMMENT_ID_seq" OWNER TO dtrack;

--
-- Name: VIOLATIONANALYSISCOMMENT_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."VIOLATIONANALYSISCOMMENT_ID_seq" OWNED BY public."VIOLATIONANALYSISCOMMENT"."ID";


--
-- Name: VIOLATIONANALYSIS_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."VIOLATIONANALYSIS_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."VIOLATIONANALYSIS_ID_seq" OWNER TO dtrack;

--
-- Name: VIOLATIONANALYSIS_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."VIOLATIONANALYSIS_ID_seq" OWNED BY public."VIOLATIONANALYSIS"."ID";


--
-- Name: VULNERABILITY; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."VULNERABILITY" (
    "ID" bigint NOT NULL,
    "CREATED" timestamp with time zone,
    "CREDITS" text,
    "CVSSV2BASESCORE" numeric,
    "CVSSV2EXPLOITSCORE" numeric,
    "CVSSV2IMPACTSCORE" numeric,
    "CVSSV2VECTOR" character varying(255),
    "CVSSV3BASESCORE" numeric,
    "CVSSV3EXPLOITSCORE" numeric,
    "CVSSV3IMPACTSCORE" numeric,
    "CVSSV3VECTOR" character varying(255),
    "CVSSV4SCORE" numeric,
    "CVSSV4VECTOR" character varying(255),
    "CWES" character varying(255),
    "DESCRIPTION" text,
    "DETAIL" text,
    "EPSSPERCENTILE" numeric,
    "EPSSSCORE" numeric,
    "FRIENDLYVULNID" character varying(255),
    "OWASPRRBUSINESSIMPACTSCORE" numeric,
    "OWASPRRLIKELIHOODSCORE" numeric,
    "OWASPRRTECHNICALIMPACTSCORE" numeric,
    "OWASPRRVECTOR" character varying(255),
    "PATCHEDVERSIONS" character varying(255),
    "PUBLISHED" timestamp with time zone,
    "RECOMMENDATION" text,
    "REFERENCES" text,
    "SEVERITY" character varying(255),
    "SOURCE" character varying(255) NOT NULL,
    "SUBTITLE" character varying(255),
    "TITLE" character varying(255),
    "UPDATED" timestamp with time zone,
    "UUID" character varying(36) NOT NULL,
    "VULNID" character varying(255) NOT NULL,
    "VULNERABLEVERSIONS" character varying(255)
);


ALTER TABLE public."VULNERABILITY" OWNER TO dtrack;

--
-- Name: VULNERABILITYALIAS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."VULNERABILITYALIAS" (
    "ID" bigint NOT NULL,
    "CVE_ID" character varying(255),
    "GHSA_ID" character varying(255),
    "GSD_ID" character varying(255),
    "INTERNAL_ID" character varying(255),
    "OSV_ID" character varying(255),
    "SNYK_ID" character varying(255),
    "SONATYPE_ID" character varying(255),
    "UUID" character varying(36) NOT NULL,
    "VULNDB_ID" character varying(255)
);


ALTER TABLE public."VULNERABILITYALIAS" OWNER TO dtrack;

--
-- Name: VULNERABILITYALIAS_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."VULNERABILITYALIAS_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."VULNERABILITYALIAS_ID_seq" OWNER TO dtrack;

--
-- Name: VULNERABILITYALIAS_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."VULNERABILITYALIAS_ID_seq" OWNED BY public."VULNERABILITYALIAS"."ID";


--
-- Name: VULNERABILITYMETRICS; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."VULNERABILITYMETRICS" (
    "ID" bigint NOT NULL,
    "COUNT" integer NOT NULL,
    "MEASURED_AT" timestamp with time zone NOT NULL,
    "MONTH" integer,
    "YEAR" integer NOT NULL
);


ALTER TABLE public."VULNERABILITYMETRICS" OWNER TO dtrack;

--
-- Name: VULNERABILITYMETRICS_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."VULNERABILITYMETRICS_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."VULNERABILITYMETRICS_ID_seq" OWNER TO dtrack;

--
-- Name: VULNERABILITYMETRICS_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."VULNERABILITYMETRICS_ID_seq" OWNED BY public."VULNERABILITYMETRICS"."ID";


--
-- Name: VULNERABILITY_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."VULNERABILITY_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."VULNERABILITY_ID_seq" OWNER TO dtrack;

--
-- Name: VULNERABILITY_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."VULNERABILITY_ID_seq" OWNED BY public."VULNERABILITY"."ID";


--
-- Name: VULNERABLESOFTWARE; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."VULNERABLESOFTWARE" (
    "ID" bigint NOT NULL,
    "CPE22" character varying(255),
    "CPE23" character varying(255),
    "EDITION" character varying(255),
    "LANGUAGE" character varying(255),
    "OTHER" character varying(255),
    "PART" character varying(255),
    "PRODUCT" character varying(255),
    "PURL" character varying(255),
    "PURL_NAME" character varying(255),
    "PURL_NAMESPACE" character varying(255),
    "PURL_QUALIFIERS" character varying(255),
    "PURL_SUBPATH" character varying(255),
    "PURL_TYPE" character varying(255),
    "PURL_VERSION" character varying(255),
    "SWEDITION" character varying(255),
    "TARGETHW" character varying(255),
    "TARGETSW" character varying(255),
    "UPDATE" character varying(255),
    "UUID" character varying(36) NOT NULL,
    "VENDOR" character varying(255),
    "VERSION" character varying(255),
    "VERSIONENDEXCLUDING" character varying(255),
    "VERSIONENDINCLUDING" character varying(255),
    "VERSIONSTARTEXCLUDING" character varying(255),
    "VERSIONSTARTINCLUDING" character varying(255),
    "VULNERABLE" boolean NOT NULL
);


ALTER TABLE public."VULNERABLESOFTWARE" OWNER TO dtrack;

--
-- Name: VULNERABLESOFTWARE_ID_seq; Type: SEQUENCE; Schema: public; Owner: dtrack
--

CREATE SEQUENCE public."VULNERABLESOFTWARE_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."VULNERABLESOFTWARE_ID_seq" OWNER TO dtrack;

--
-- Name: VULNERABLESOFTWARE_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dtrack
--

ALTER SEQUENCE public."VULNERABLESOFTWARE_ID_seq" OWNED BY public."VULNERABLESOFTWARE"."ID";


--
-- Name: VULNERABLESOFTWARE_VULNERABILITIES; Type: TABLE; Schema: public; Owner: dtrack
--

CREATE TABLE public."VULNERABLESOFTWARE_VULNERABILITIES" (
    "VULNERABILITY_ID" bigint NOT NULL,
    "VULNERABLESOFTWARE_ID" bigint CONSTRAINT "VULNERABLESOFTWARE_VULNERABILITI_VULNERABLESOFTWARE_ID_not_null" NOT NULL
);


ALTER TABLE public."VULNERABLESOFTWARE_VULNERABILITIES" OWNER TO dtrack;

--
-- Name: AFFECTEDVERSIONATTRIBUTION ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."AFFECTEDVERSIONATTRIBUTION" ALTER COLUMN "ID" SET DEFAULT nextval('public."AFFECTEDVERSIONATTRIBUTION_ID_seq"'::regclass);


--
-- Name: ANALYSIS ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."ANALYSIS" ALTER COLUMN "ID" SET DEFAULT nextval('public."ANALYSIS_ID_seq"'::regclass);


--
-- Name: ANALYSISCOMMENT ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."ANALYSISCOMMENT" ALTER COLUMN "ID" SET DEFAULT nextval('public."ANALYSISCOMMENT_ID_seq"'::regclass);


--
-- Name: APIKEY ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."APIKEY" ALTER COLUMN "ID" SET DEFAULT nextval('public."APIKEY_ID_seq"'::regclass);


--
-- Name: BOM ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."BOM" ALTER COLUMN "ID" SET DEFAULT nextval('public."BOM_ID_seq"'::regclass);


--
-- Name: COMPONENT ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."COMPONENT" ALTER COLUMN "ID" SET DEFAULT nextval('public."COMPONENT_ID_seq"'::regclass);


--
-- Name: COMPONENTANALYSISCACHE ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."COMPONENTANALYSISCACHE" ALTER COLUMN "ID" SET DEFAULT nextval('public."COMPONENTANALYSISCACHE_ID_seq"'::regclass);


--
-- Name: COMPONENT_PROPERTY ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."COMPONENT_PROPERTY" ALTER COLUMN "ID" SET DEFAULT nextval('public."COMPONENT_PROPERTY_ID_seq"'::regclass);


--
-- Name: CONFIGPROPERTY ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."CONFIGPROPERTY" ALTER COLUMN "ID" SET DEFAULT nextval('public."CONFIGPROPERTY_ID_seq"'::regclass);


--
-- Name: DEPENDENCYMETRICS ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."DEPENDENCYMETRICS" ALTER COLUMN "ID" SET DEFAULT nextval('public."DEPENDENCYMETRICS_ID_seq"'::regclass);


--
-- Name: EVENTSERVICELOG ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."EVENTSERVICELOG" ALTER COLUMN "ID" SET DEFAULT nextval('public."EVENTSERVICELOG_ID_seq"'::regclass);


--
-- Name: FINDINGATTRIBUTION ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."FINDINGATTRIBUTION" ALTER COLUMN "ID" SET DEFAULT nextval('public."FINDINGATTRIBUTION_ID_seq"'::regclass);


--
-- Name: INSTALLEDUPGRADES ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."INSTALLEDUPGRADES" ALTER COLUMN "ID" SET DEFAULT nextval('public."INSTALLEDUPGRADES_ID_seq"'::regclass);


--
-- Name: LDAPUSER ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."LDAPUSER" ALTER COLUMN "ID" SET DEFAULT nextval('public."LDAPUSER_ID_seq"'::regclass);


--
-- Name: LICENSE ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."LICENSE" ALTER COLUMN "ID" SET DEFAULT nextval('public."LICENSE_ID_seq"'::regclass);


--
-- Name: LICENSEGROUP ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."LICENSEGROUP" ALTER COLUMN "ID" SET DEFAULT nextval('public."LICENSEGROUP_ID_seq"'::regclass);


--
-- Name: MANAGEDUSER ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MANAGEDUSER" ALTER COLUMN "ID" SET DEFAULT nextval('public."MANAGEDUSER_ID_seq"'::regclass);


--
-- Name: MAPPEDLDAPGROUP ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MAPPEDLDAPGROUP" ALTER COLUMN "ID" SET DEFAULT nextval('public."MAPPEDLDAPGROUP_ID_seq"'::regclass);


--
-- Name: MAPPEDOIDCGROUP ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MAPPEDOIDCGROUP" ALTER COLUMN "ID" SET DEFAULT nextval('public."MAPPEDOIDCGROUP_ID_seq"'::regclass);


--
-- Name: NOTIFICATIONPUBLISHER ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."NOTIFICATIONPUBLISHER" ALTER COLUMN "ID" SET DEFAULT nextval('public."NOTIFICATIONPUBLISHER_ID_seq"'::regclass);


--
-- Name: NOTIFICATIONRULE ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."NOTIFICATIONRULE" ALTER COLUMN "ID" SET DEFAULT nextval('public."NOTIFICATIONRULE_ID_seq"'::regclass);


--
-- Name: OIDCGROUP ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."OIDCGROUP" ALTER COLUMN "ID" SET DEFAULT nextval('public."OIDCGROUP_ID_seq"'::regclass);


--
-- Name: OIDCUSER ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."OIDCUSER" ALTER COLUMN "ID" SET DEFAULT nextval('public."OIDCUSER_ID_seq"'::regclass);


--
-- Name: PERMISSION ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PERMISSION" ALTER COLUMN "ID" SET DEFAULT nextval('public."PERMISSION_ID_seq"'::regclass);


--
-- Name: POLICY ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICY" ALTER COLUMN "ID" SET DEFAULT nextval('public."POLICY_ID_seq"'::regclass);


--
-- Name: POLICYCONDITION ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICYCONDITION" ALTER COLUMN "ID" SET DEFAULT nextval('public."POLICYCONDITION_ID_seq"'::regclass);


--
-- Name: POLICYVIOLATION ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICYVIOLATION" ALTER COLUMN "ID" SET DEFAULT nextval('public."POLICYVIOLATION_ID_seq"'::regclass);


--
-- Name: PORTFOLIOMETRICS ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PORTFOLIOMETRICS" ALTER COLUMN "ID" SET DEFAULT nextval('public."PORTFOLIOMETRICS_ID_seq"'::regclass);


--
-- Name: PROJECT ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECT" ALTER COLUMN "ID" SET DEFAULT nextval('public."PROJECT_ID_seq"'::regclass);


--
-- Name: PROJECTMETRICS ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECTMETRICS" ALTER COLUMN "ID" SET DEFAULT nextval('public."PROJECTMETRICS_ID_seq"'::regclass);


--
-- Name: PROJECT_METADATA ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECT_METADATA" ALTER COLUMN "ID" SET DEFAULT nextval('public."PROJECT_METADATA_ID_seq"'::regclass);


--
-- Name: PROJECT_PROPERTY ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECT_PROPERTY" ALTER COLUMN "ID" SET DEFAULT nextval('public."PROJECT_PROPERTY_ID_seq"'::regclass);


--
-- Name: REPOSITORY ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."REPOSITORY" ALTER COLUMN "ID" SET DEFAULT nextval('public."REPOSITORY_ID_seq"'::regclass);


--
-- Name: REPOSITORY_META_COMPONENT ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."REPOSITORY_META_COMPONENT" ALTER COLUMN "ID" SET DEFAULT nextval('public."REPOSITORY_META_COMPONENT_ID_seq"'::regclass);


--
-- Name: SCHEMAVERSION ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."SCHEMAVERSION" ALTER COLUMN "ID" SET DEFAULT nextval('public."SCHEMAVERSION_ID_seq"'::regclass);


--
-- Name: SERVICECOMPONENT ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."SERVICECOMPONENT" ALTER COLUMN "ID" SET DEFAULT nextval('public."SERVICECOMPONENT_ID_seq"'::regclass);


--
-- Name: TAG ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."TAG" ALTER COLUMN "ID" SET DEFAULT nextval('public."TAG_ID_seq"'::regclass);


--
-- Name: TEAM ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."TEAM" ALTER COLUMN "ID" SET DEFAULT nextval('public."TEAM_ID_seq"'::regclass);


--
-- Name: VEX ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VEX" ALTER COLUMN "ID" SET DEFAULT nextval('public."VEX_ID_seq"'::regclass);


--
-- Name: VIOLATIONANALYSIS ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VIOLATIONANALYSIS" ALTER COLUMN "ID" SET DEFAULT nextval('public."VIOLATIONANALYSIS_ID_seq"'::regclass);


--
-- Name: VIOLATIONANALYSISCOMMENT ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VIOLATIONANALYSISCOMMENT" ALTER COLUMN "ID" SET DEFAULT nextval('public."VIOLATIONANALYSISCOMMENT_ID_seq"'::regclass);


--
-- Name: VULNERABILITY ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VULNERABILITY" ALTER COLUMN "ID" SET DEFAULT nextval('public."VULNERABILITY_ID_seq"'::regclass);


--
-- Name: VULNERABILITYALIAS ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VULNERABILITYALIAS" ALTER COLUMN "ID" SET DEFAULT nextval('public."VULNERABILITYALIAS_ID_seq"'::regclass);


--
-- Name: VULNERABILITYMETRICS ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VULNERABILITYMETRICS" ALTER COLUMN "ID" SET DEFAULT nextval('public."VULNERABILITYMETRICS_ID_seq"'::regclass);


--
-- Name: VULNERABLESOFTWARE ID; Type: DEFAULT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VULNERABLESOFTWARE" ALTER COLUMN "ID" SET DEFAULT nextval('public."VULNERABLESOFTWARE_ID_seq"'::regclass);


--
-- Name: AFFECTEDVERSIONATTRIBUTION AFFECTEDVERSIONATTRIBUTION_COMPOSITE_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."AFFECTEDVERSIONATTRIBUTION"
    ADD CONSTRAINT "AFFECTEDVERSIONATTRIBUTION_COMPOSITE_IDX" UNIQUE ("SOURCE", "VULNERABILITY", "VULNERABLE_SOFTWARE");


--
-- Name: AFFECTEDVERSIONATTRIBUTION AFFECTEDVERSIONATTRIBUTION_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."AFFECTEDVERSIONATTRIBUTION"
    ADD CONSTRAINT "AFFECTEDVERSIONATTRIBUTION_PK" PRIMARY KEY ("ID");


--
-- Name: AFFECTEDVERSIONATTRIBUTION AFFECTEDVERSIONATTRIBUTION_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."AFFECTEDVERSIONATTRIBUTION"
    ADD CONSTRAINT "AFFECTEDVERSIONATTRIBUTION_UUID_IDX" UNIQUE ("UUID");


--
-- Name: ANALYSISCOMMENT ANALYSISCOMMENT_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."ANALYSISCOMMENT"
    ADD CONSTRAINT "ANALYSISCOMMENT_PK" PRIMARY KEY ("ID");


--
-- Name: ANALYSIS ANALYSIS_COMPOSITE_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."ANALYSIS"
    ADD CONSTRAINT "ANALYSIS_COMPOSITE_IDX" UNIQUE ("PROJECT_ID", "COMPONENT_ID", "VULNERABILITY_ID");


--
-- Name: ANALYSIS ANALYSIS_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."ANALYSIS"
    ADD CONSTRAINT "ANALYSIS_PK" PRIMARY KEY ("ID");


--
-- Name: APIKEY APIKEY_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."APIKEY"
    ADD CONSTRAINT "APIKEY_PK" PRIMARY KEY ("ID");


--
-- Name: APIKEY APIKEY_PUBLIC_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."APIKEY"
    ADD CONSTRAINT "APIKEY_PUBLIC_IDX" UNIQUE ("PUBLIC_ID");


--
-- Name: BOM BOM_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."BOM"
    ADD CONSTRAINT "BOM_PK" PRIMARY KEY ("ID");


--
-- Name: BOM BOM_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."BOM"
    ADD CONSTRAINT "BOM_UUID_IDX" UNIQUE ("UUID");


--
-- Name: COMPONENTANALYSISCACHE COMPONENTANALYSISCACHE_COMPOSITE_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."COMPONENTANALYSISCACHE"
    ADD CONSTRAINT "COMPONENTANALYSISCACHE_COMPOSITE_IDX" UNIQUE ("CACHE_TYPE", "TARGET_HOST", "TARGET_TYPE", "TARGET");


--
-- Name: COMPONENTANALYSISCACHE COMPONENTANALYSISCACHE_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."COMPONENTANALYSISCACHE"
    ADD CONSTRAINT "COMPONENTANALYSISCACHE_PK" PRIMARY KEY ("ID");


--
-- Name: COMPONENTANALYSISCACHE COMPONENTANALYSISCACHE_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."COMPONENTANALYSISCACHE"
    ADD CONSTRAINT "COMPONENTANALYSISCACHE_UUID_IDX" UNIQUE ("UUID");


--
-- Name: COMPONENT COMPONENT_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."COMPONENT"
    ADD CONSTRAINT "COMPONENT_PK" PRIMARY KEY ("ID");


--
-- Name: COMPONENT_PROPERTY COMPONENT_PROPERTY_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."COMPONENT_PROPERTY"
    ADD CONSTRAINT "COMPONENT_PROPERTY_PK" PRIMARY KEY ("ID");


--
-- Name: COMPONENT_PROPERTY COMPONENT_PROPERTY_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."COMPONENT_PROPERTY"
    ADD CONSTRAINT "COMPONENT_PROPERTY_UUID_IDX" UNIQUE ("UUID");


--
-- Name: COMPONENT COMPONENT_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."COMPONENT"
    ADD CONSTRAINT "COMPONENT_UUID_IDX" UNIQUE ("UUID");


--
-- Name: CONFIGPROPERTY CONFIGPROPERTY_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."CONFIGPROPERTY"
    ADD CONSTRAINT "CONFIGPROPERTY_PK" PRIMARY KEY ("ID");


--
-- Name: CONFIGPROPERTY CONFIGPROPERTY_U1; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."CONFIGPROPERTY"
    ADD CONSTRAINT "CONFIGPROPERTY_U1" UNIQUE ("GROUPNAME", "PROPERTYNAME");


--
-- Name: DEPENDENCYMETRICS DEPENDENCYMETRICS_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."DEPENDENCYMETRICS"
    ADD CONSTRAINT "DEPENDENCYMETRICS_PK" PRIMARY KEY ("ID");


--
-- Name: EVENTSERVICELOG EVENTSERVICELOG_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."EVENTSERVICELOG"
    ADD CONSTRAINT "EVENTSERVICELOG_PK" PRIMARY KEY ("ID");


--
-- Name: FINDINGATTRIBUTION FINDINGATTRIBUTION_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."FINDINGATTRIBUTION"
    ADD CONSTRAINT "FINDINGATTRIBUTION_PK" PRIMARY KEY ("ID");


--
-- Name: FINDINGATTRIBUTION FINDINGATTRIBUTION_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."FINDINGATTRIBUTION"
    ADD CONSTRAINT "FINDINGATTRIBUTION_UUID_IDX" UNIQUE ("UUID");


--
-- Name: INSTALLEDUPGRADES INSTALLEDUPGRADES_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."INSTALLEDUPGRADES"
    ADD CONSTRAINT "INSTALLEDUPGRADES_PK" PRIMARY KEY ("ID");


--
-- Name: LDAPUSER LDAPUSER_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."LDAPUSER"
    ADD CONSTRAINT "LDAPUSER_PK" PRIMARY KEY ("ID");


--
-- Name: LDAPUSER LDAPUSER_USERNAME_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."LDAPUSER"
    ADD CONSTRAINT "LDAPUSER_USERNAME_IDX" UNIQUE ("USERNAME");


--
-- Name: LICENSEGROUP LICENSEGROUP_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."LICENSEGROUP"
    ADD CONSTRAINT "LICENSEGROUP_PK" PRIMARY KEY ("ID");


--
-- Name: LICENSEGROUP LICENSEGROUP_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."LICENSEGROUP"
    ADD CONSTRAINT "LICENSEGROUP_UUID_IDX" UNIQUE ("UUID");


--
-- Name: LICENSE LICENSE_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."LICENSE"
    ADD CONSTRAINT "LICENSE_PK" PRIMARY KEY ("ID");


--
-- Name: LICENSE LICENSE_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."LICENSE"
    ADD CONSTRAINT "LICENSE_UUID_IDX" UNIQUE ("UUID");


--
-- Name: MANAGEDUSER MANAGEDUSER_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MANAGEDUSER"
    ADD CONSTRAINT "MANAGEDUSER_PK" PRIMARY KEY ("ID");


--
-- Name: MANAGEDUSER MANAGEDUSER_USERNAME_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MANAGEDUSER"
    ADD CONSTRAINT "MANAGEDUSER_USERNAME_IDX" UNIQUE ("USERNAME");


--
-- Name: MAPPEDLDAPGROUP MAPPEDLDAPGROUP_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MAPPEDLDAPGROUP"
    ADD CONSTRAINT "MAPPEDLDAPGROUP_PK" PRIMARY KEY ("ID");


--
-- Name: MAPPEDLDAPGROUP MAPPEDLDAPGROUP_U1; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MAPPEDLDAPGROUP"
    ADD CONSTRAINT "MAPPEDLDAPGROUP_U1" UNIQUE ("TEAM_ID", "DN");


--
-- Name: MAPPEDLDAPGROUP MAPPEDLDAPGROUP_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MAPPEDLDAPGROUP"
    ADD CONSTRAINT "MAPPEDLDAPGROUP_UUID_IDX" UNIQUE ("UUID");


--
-- Name: MAPPEDOIDCGROUP MAPPEDOIDCGROUP_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MAPPEDOIDCGROUP"
    ADD CONSTRAINT "MAPPEDOIDCGROUP_PK" PRIMARY KEY ("ID");


--
-- Name: MAPPEDOIDCGROUP MAPPEDOIDCGROUP_U1; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MAPPEDOIDCGROUP"
    ADD CONSTRAINT "MAPPEDOIDCGROUP_U1" UNIQUE ("TEAM_ID", "GROUP_ID");


--
-- Name: MAPPEDOIDCGROUP MAPPEDOIDCGROUP_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MAPPEDOIDCGROUP"
    ADD CONSTRAINT "MAPPEDOIDCGROUP_UUID_IDX" UNIQUE ("UUID");


--
-- Name: NOTIFICATIONPUBLISHER NOTIFICATIONPUBLISHER_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."NOTIFICATIONPUBLISHER"
    ADD CONSTRAINT "NOTIFICATIONPUBLISHER_PK" PRIMARY KEY ("ID");


--
-- Name: NOTIFICATIONPUBLISHER NOTIFICATIONPUBLISHER_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."NOTIFICATIONPUBLISHER"
    ADD CONSTRAINT "NOTIFICATIONPUBLISHER_UUID_IDX" UNIQUE ("UUID");


--
-- Name: NOTIFICATIONRULE NOTIFICATIONRULE_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."NOTIFICATIONRULE"
    ADD CONSTRAINT "NOTIFICATIONRULE_PK" PRIMARY KEY ("ID");


--
-- Name: NOTIFICATIONRULE_TAGS NOTIFICATIONRULE_TAGS_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."NOTIFICATIONRULE_TAGS"
    ADD CONSTRAINT "NOTIFICATIONRULE_TAGS_PK" PRIMARY KEY ("NOTIFICATIONRULE_ID", "TAG_ID");


--
-- Name: NOTIFICATIONRULE NOTIFICATIONRULE_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."NOTIFICATIONRULE"
    ADD CONSTRAINT "NOTIFICATIONRULE_UUID_IDX" UNIQUE ("UUID");


--
-- Name: OIDCGROUP OIDCGROUP_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."OIDCGROUP"
    ADD CONSTRAINT "OIDCGROUP_PK" PRIMARY KEY ("ID");


--
-- Name: OIDCGROUP OIDCGROUP_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."OIDCGROUP"
    ADD CONSTRAINT "OIDCGROUP_UUID_IDX" UNIQUE ("UUID");


--
-- Name: OIDCUSER OIDCUSER_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."OIDCUSER"
    ADD CONSTRAINT "OIDCUSER_PK" PRIMARY KEY ("ID");


--
-- Name: OIDCUSER OIDCUSER_USERNAME_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."OIDCUSER"
    ADD CONSTRAINT "OIDCUSER_USERNAME_IDX" UNIQUE ("USERNAME");


--
-- Name: PERMISSION PERMISSION_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PERMISSION"
    ADD CONSTRAINT "PERMISSION_IDX" UNIQUE ("NAME");


--
-- Name: PERMISSION PERMISSION_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PERMISSION"
    ADD CONSTRAINT "PERMISSION_PK" PRIMARY KEY ("ID");


--
-- Name: POLICYCONDITION POLICYCONDITION_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICYCONDITION"
    ADD CONSTRAINT "POLICYCONDITION_PK" PRIMARY KEY ("ID");


--
-- Name: POLICYCONDITION POLICYCONDITION_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICYCONDITION"
    ADD CONSTRAINT "POLICYCONDITION_UUID_IDX" UNIQUE ("UUID");


--
-- Name: POLICYVIOLATION POLICYVIOLATION_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICYVIOLATION"
    ADD CONSTRAINT "POLICYVIOLATION_PK" PRIMARY KEY ("ID");


--
-- Name: POLICYVIOLATION POLICYVIOLATION_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICYVIOLATION"
    ADD CONSTRAINT "POLICYVIOLATION_UUID_IDX" UNIQUE ("UUID");


--
-- Name: POLICY POLICY_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICY"
    ADD CONSTRAINT "POLICY_PK" PRIMARY KEY ("ID");


--
-- Name: POLICY_TAGS POLICY_TAGS_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICY_TAGS"
    ADD CONSTRAINT "POLICY_TAGS_PK" PRIMARY KEY ("TAG_ID", "POLICY_ID");


--
-- Name: POLICY POLICY_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICY"
    ADD CONSTRAINT "POLICY_UUID_IDX" UNIQUE ("UUID");


--
-- Name: PORTFOLIOMETRICS PORTFOLIOMETRICS_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PORTFOLIOMETRICS"
    ADD CONSTRAINT "PORTFOLIOMETRICS_PK" PRIMARY KEY ("ID");


--
-- Name: PROJECTMETRICS PROJECTMETRICS_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECTMETRICS"
    ADD CONSTRAINT "PROJECTMETRICS_PK" PRIMARY KEY ("ID");


--
-- Name: PROJECTS_TAGS PROJECTS_TAGS_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECTS_TAGS"
    ADD CONSTRAINT "PROJECTS_TAGS_PK" PRIMARY KEY ("TAG_ID", "PROJECT_ID");


--
-- Name: PROJECT_METADATA PROJECT_METADATA_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECT_METADATA"
    ADD CONSTRAINT "PROJECT_METADATA_PK" PRIMARY KEY ("ID");


--
-- Name: PROJECT_METADATA PROJECT_METADATA_PROJECT_ID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECT_METADATA"
    ADD CONSTRAINT "PROJECT_METADATA_PROJECT_ID_IDX" UNIQUE ("PROJECT_ID");


--
-- Name: PROJECT PROJECT_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECT"
    ADD CONSTRAINT "PROJECT_PK" PRIMARY KEY ("ID");


--
-- Name: PROJECT_PROPERTY PROJECT_PROPERTY_KEYS_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECT_PROPERTY"
    ADD CONSTRAINT "PROJECT_PROPERTY_KEYS_IDX" UNIQUE ("PROJECT_ID", "GROUPNAME", "PROPERTYNAME");


--
-- Name: PROJECT_PROPERTY PROJECT_PROPERTY_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECT_PROPERTY"
    ADD CONSTRAINT "PROJECT_PROPERTY_PK" PRIMARY KEY ("ID");


--
-- Name: PROJECT PROJECT_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECT"
    ADD CONSTRAINT "PROJECT_UUID_IDX" UNIQUE ("UUID");


--
-- Name: REPOSITORY REPOSITORY_COMPOUND_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."REPOSITORY"
    ADD CONSTRAINT "REPOSITORY_COMPOUND_IDX" UNIQUE ("TYPE", "IDENTIFIER");


--
-- Name: REPOSITORY_META_COMPONENT REPOSITORY_META_COMPONENT_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."REPOSITORY_META_COMPONENT"
    ADD CONSTRAINT "REPOSITORY_META_COMPONENT_PK" PRIMARY KEY ("ID");


--
-- Name: REPOSITORY REPOSITORY_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."REPOSITORY"
    ADD CONSTRAINT "REPOSITORY_PK" PRIMARY KEY ("ID");


--
-- Name: SCHEMAVERSION SCHEMAVERSION_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."SCHEMAVERSION"
    ADD CONSTRAINT "SCHEMAVERSION_PK" PRIMARY KEY ("ID");


--
-- Name: SERVICECOMPONENT SERVICECOMPONENT_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."SERVICECOMPONENT"
    ADD CONSTRAINT "SERVICECOMPONENT_PK" PRIMARY KEY ("ID");


--
-- Name: SERVICECOMPONENT SERVICECOMPONENT_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."SERVICECOMPONENT"
    ADD CONSTRAINT "SERVICECOMPONENT_UUID_IDX" UNIQUE ("UUID");


--
-- Name: TAG TAG_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."TAG"
    ADD CONSTRAINT "TAG_PK" PRIMARY KEY ("ID");


--
-- Name: TEAM TEAM_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."TEAM"
    ADD CONSTRAINT "TEAM_PK" PRIMARY KEY ("ID");


--
-- Name: TEAM TEAM_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."TEAM"
    ADD CONSTRAINT "TEAM_UUID_IDX" UNIQUE ("UUID");


--
-- Name: VEX VEX_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VEX"
    ADD CONSTRAINT "VEX_PK" PRIMARY KEY ("ID");


--
-- Name: VEX VEX_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VEX"
    ADD CONSTRAINT "VEX_UUID_IDX" UNIQUE ("UUID");


--
-- Name: VIOLATIONANALYSISCOMMENT VIOLATIONANALYSISCOMMENT_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VIOLATIONANALYSISCOMMENT"
    ADD CONSTRAINT "VIOLATIONANALYSISCOMMENT_PK" PRIMARY KEY ("ID");


--
-- Name: VIOLATIONANALYSIS VIOLATIONANALYSIS_COMPOSITE_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VIOLATIONANALYSIS"
    ADD CONSTRAINT "VIOLATIONANALYSIS_COMPOSITE_IDX" UNIQUE ("PROJECT_ID", "COMPONENT_ID", "POLICYVIOLATION_ID");


--
-- Name: VIOLATIONANALYSIS VIOLATIONANALYSIS_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VIOLATIONANALYSIS"
    ADD CONSTRAINT "VIOLATIONANALYSIS_PK" PRIMARY KEY ("ID");


--
-- Name: VULNERABILITYALIAS VULNERABILITYALIAS_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VULNERABILITYALIAS"
    ADD CONSTRAINT "VULNERABILITYALIAS_PK" PRIMARY KEY ("ID");


--
-- Name: VULNERABILITYALIAS VULNERABILITYALIAS_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VULNERABILITYALIAS"
    ADD CONSTRAINT "VULNERABILITYALIAS_UUID_IDX" UNIQUE ("UUID");


--
-- Name: VULNERABILITYMETRICS VULNERABILITYMETRICS_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VULNERABILITYMETRICS"
    ADD CONSTRAINT "VULNERABILITYMETRICS_PK" PRIMARY KEY ("ID");


--
-- Name: VULNERABILITY VULNERABILITY_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VULNERABILITY"
    ADD CONSTRAINT "VULNERABILITY_PK" PRIMARY KEY ("ID");


--
-- Name: VULNERABILITY VULNERABILITY_U1; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VULNERABILITY"
    ADD CONSTRAINT "VULNERABILITY_U1" UNIQUE ("VULNID", "SOURCE");


--
-- Name: VULNERABILITY VULNERABILITY_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VULNERABILITY"
    ADD CONSTRAINT "VULNERABILITY_UUID_IDX" UNIQUE ("UUID");


--
-- Name: VULNERABLESOFTWARE VULNERABLESOFTWARE_PK; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VULNERABLESOFTWARE"
    ADD CONSTRAINT "VULNERABLESOFTWARE_PK" PRIMARY KEY ("ID");


--
-- Name: VULNERABLESOFTWARE VULNERABLESOFTWARE_UUID_IDX; Type: CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VULNERABLESOFTWARE"
    ADD CONSTRAINT "VULNERABLESOFTWARE_UUID_IDX" UNIQUE ("UUID");


--
-- Name: AFFECTEDVERSIONATTRIBUTION_KEYS_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "AFFECTEDVERSIONATTRIBUTION_KEYS_IDX" ON public."AFFECTEDVERSIONATTRIBUTION" USING btree ("VULNERABILITY", "VULNERABLE_SOFTWARE");


--
-- Name: AFFECTEDVERSIONATTRIBUTION_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "AFFECTEDVERSIONATTRIBUTION_N49" ON public."AFFECTEDVERSIONATTRIBUTION" USING btree ("VULNERABILITY");


--
-- Name: AFFECTEDVERSIONATTRIBUTION_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "AFFECTEDVERSIONATTRIBUTION_N50" ON public."AFFECTEDVERSIONATTRIBUTION" USING btree ("VULNERABLE_SOFTWARE");


--
-- Name: ANALYSISCOMMENT_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "ANALYSISCOMMENT_N49" ON public."ANALYSISCOMMENT" USING btree ("ANALYSIS_ID");


--
-- Name: ANALYSIS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "ANALYSIS_N49" ON public."ANALYSIS" USING btree ("VULNERABILITY_ID");


--
-- Name: ANALYSIS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "ANALYSIS_N50" ON public."ANALYSIS" USING btree ("PROJECT_ID");


--
-- Name: ANALYSIS_N51; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "ANALYSIS_N51" ON public."ANALYSIS" USING btree ("COMPONENT_ID");


--
-- Name: APIKEYS_TEAMS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "APIKEYS_TEAMS_N49" ON public."APIKEYS_TEAMS" USING btree ("TEAM_ID");


--
-- Name: APIKEYS_TEAMS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "APIKEYS_TEAMS_N50" ON public."APIKEYS_TEAMS" USING btree ("APIKEY_ID");


--
-- Name: BOM_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "BOM_N49" ON public."BOM" USING btree ("PROJECT_ID");


--
-- Name: COMPONENTS_VULNERABILITIES_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENTS_VULNERABILITIES_N49" ON public."COMPONENTS_VULNERABILITIES" USING btree ("COMPONENT_ID");


--
-- Name: COMPONENTS_VULNERABILITIES_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENTS_VULNERABILITIES_N50" ON public."COMPONENTS_VULNERABILITIES" USING btree ("VULNERABILITY_ID");


--
-- Name: COMPONENT_BLAKE2B_256_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_BLAKE2B_256_IDX" ON public."COMPONENT" USING btree ("BLAKE2B_256");


--
-- Name: COMPONENT_BLAKE2B_384_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_BLAKE2B_384_IDX" ON public."COMPONENT" USING btree ("BLAKE2B_384");


--
-- Name: COMPONENT_BLAKE2B_512_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_BLAKE2B_512_IDX" ON public."COMPONENT" USING btree ("BLAKE2B_512");


--
-- Name: COMPONENT_BLAKE3_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_BLAKE3_IDX" ON public."COMPONENT" USING btree ("BLAKE3");


--
-- Name: COMPONENT_CLASSIFIER_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_CLASSIFIER_IDX" ON public."COMPONENT" USING btree ("CLASSIFIER");


--
-- Name: COMPONENT_CPE_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_CPE_IDX" ON public."COMPONENT" USING btree ("CPE");


--
-- Name: COMPONENT_GROUP_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_GROUP_IDX" ON public."COMPONENT" USING btree ("GROUP");


--
-- Name: COMPONENT_LAST_RISKSCORE_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_LAST_RISKSCORE_IDX" ON public."COMPONENT" USING btree ("LAST_RISKSCORE");


--
-- Name: COMPONENT_MD5_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_MD5_IDX" ON public."COMPONENT" USING btree ("MD5");


--
-- Name: COMPONENT_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_N49" ON public."COMPONENT" USING btree ("PARENT_COMPONENT_ID");


--
-- Name: COMPONENT_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_N50" ON public."COMPONENT" USING btree ("LICENSE_ID");


--
-- Name: COMPONENT_NAME_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_NAME_IDX" ON public."COMPONENT" USING btree ("NAME");


--
-- Name: COMPONENT_PROJECT_ID_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_PROJECT_ID_IDX" ON public."COMPONENT" USING btree ("PROJECT_ID");


--
-- Name: COMPONENT_PROPERTY_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_PROPERTY_N49" ON public."COMPONENT_PROPERTY" USING btree ("COMPONENT_ID");


--
-- Name: COMPONENT_PURL_COORDINATES_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_PURL_COORDINATES_IDX" ON public."COMPONENT" USING btree ("PURLCOORDINATES");


--
-- Name: COMPONENT_PURL_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_PURL_IDX" ON public."COMPONENT" USING btree ("PURL");


--
-- Name: COMPONENT_SCOPE_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_SCOPE_IDX" ON public."COMPONENT" USING btree ("SCOPE");


--
-- Name: COMPONENT_SHA1_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_SHA1_IDX" ON public."COMPONENT" USING btree ("SHA1");


--
-- Name: COMPONENT_SHA256_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_SHA256_IDX" ON public."COMPONENT" USING btree ("SHA_256");


--
-- Name: COMPONENT_SHA384_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_SHA384_IDX" ON public."COMPONENT" USING btree ("SHA_384");


--
-- Name: COMPONENT_SHA3_256_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_SHA3_256_IDX" ON public."COMPONENT" USING btree ("SHA3_256");


--
-- Name: COMPONENT_SHA3_384_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_SHA3_384_IDX" ON public."COMPONENT" USING btree ("SHA3_384");


--
-- Name: COMPONENT_SHA3_512_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_SHA3_512_IDX" ON public."COMPONENT" USING btree ("SHA3_512");


--
-- Name: COMPONENT_SHA512_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_SHA512_IDX" ON public."COMPONENT" USING btree ("SHA_512");


--
-- Name: COMPONENT_SWID_TAGID_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "COMPONENT_SWID_TAGID_IDX" ON public."COMPONENT" USING btree ("SWIDTAGID");


--
-- Name: DEPENDENCYMETRICS_COMPOSITE_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "DEPENDENCYMETRICS_COMPOSITE_IDX" ON public."DEPENDENCYMETRICS" USING btree ("PROJECT_ID", "COMPONENT_ID");


--
-- Name: DEPENDENCYMETRICS_FIRST_OCCURRENCE_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "DEPENDENCYMETRICS_FIRST_OCCURRENCE_IDX" ON public."DEPENDENCYMETRICS" USING btree ("FIRST_OCCURRENCE");


--
-- Name: DEPENDENCYMETRICS_LAST_OCCURRENCE_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "DEPENDENCYMETRICS_LAST_OCCURRENCE_IDX" ON public."DEPENDENCYMETRICS" USING btree ("LAST_OCCURRENCE");


--
-- Name: DEPENDENCYMETRICS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "DEPENDENCYMETRICS_N49" ON public."DEPENDENCYMETRICS" USING btree ("COMPONENT_ID");


--
-- Name: DEPENDENCYMETRICS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "DEPENDENCYMETRICS_N50" ON public."DEPENDENCYMETRICS" USING btree ("PROJECT_ID");


--
-- Name: FINDINGATTRIBUTION_COMPOUND_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "FINDINGATTRIBUTION_COMPOUND_IDX" ON public."FINDINGATTRIBUTION" USING btree ("COMPONENT_ID", "VULNERABILITY_ID");


--
-- Name: FINDINGATTRIBUTION_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "FINDINGATTRIBUTION_N49" ON public."FINDINGATTRIBUTION" USING btree ("PROJECT_ID");


--
-- Name: FINDINGATTRIBUTION_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "FINDINGATTRIBUTION_N50" ON public."FINDINGATTRIBUTION" USING btree ("VULNERABILITY_ID");


--
-- Name: FINDINGATTRIBUTION_N51; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "FINDINGATTRIBUTION_N51" ON public."FINDINGATTRIBUTION" USING btree ("COMPONENT_ID");


--
-- Name: LDAPUSERS_PERMISSIONS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "LDAPUSERS_PERMISSIONS_N49" ON public."LDAPUSERS_PERMISSIONS" USING btree ("PERMISSION_ID");


--
-- Name: LDAPUSERS_PERMISSIONS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "LDAPUSERS_PERMISSIONS_N50" ON public."LDAPUSERS_PERMISSIONS" USING btree ("LDAPUSER_ID");


--
-- Name: LDAPUSERS_TEAMS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "LDAPUSERS_TEAMS_N49" ON public."LDAPUSERS_TEAMS" USING btree ("TEAM_ID");


--
-- Name: LDAPUSERS_TEAMS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "LDAPUSERS_TEAMS_N50" ON public."LDAPUSERS_TEAMS" USING btree ("LDAPUSER_ID");


--
-- Name: LICENSEGROUP_LICENSE_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "LICENSEGROUP_LICENSE_N49" ON public."LICENSEGROUP_LICENSE" USING btree ("LICENSE_ID");


--
-- Name: LICENSEGROUP_LICENSE_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "LICENSEGROUP_LICENSE_N50" ON public."LICENSEGROUP_LICENSE" USING btree ("LICENSEGROUP_ID");


--
-- Name: LICENSEGROUP_NAME_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "LICENSEGROUP_NAME_IDX" ON public."LICENSEGROUP" USING btree ("NAME");


--
-- Name: LICENSE_LICENSEID_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE UNIQUE INDEX "LICENSE_LICENSEID_IDX" ON public."LICENSE" USING btree ("LICENSEID");


--
-- Name: LICENSE_NAME_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "LICENSE_NAME_IDX" ON public."LICENSE" USING btree ("NAME");


--
-- Name: MANAGEDUSERS_PERMISSIONS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "MANAGEDUSERS_PERMISSIONS_N49" ON public."MANAGEDUSERS_PERMISSIONS" USING btree ("MANAGEDUSER_ID");


--
-- Name: MANAGEDUSERS_PERMISSIONS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "MANAGEDUSERS_PERMISSIONS_N50" ON public."MANAGEDUSERS_PERMISSIONS" USING btree ("PERMISSION_ID");


--
-- Name: MANAGEDUSERS_TEAMS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "MANAGEDUSERS_TEAMS_N49" ON public."MANAGEDUSERS_TEAMS" USING btree ("MANAGEDUSER_ID");


--
-- Name: MANAGEDUSERS_TEAMS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "MANAGEDUSERS_TEAMS_N50" ON public."MANAGEDUSERS_TEAMS" USING btree ("TEAM_ID");


--
-- Name: MAPPEDLDAPGROUP_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "MAPPEDLDAPGROUP_N49" ON public."MAPPEDLDAPGROUP" USING btree ("TEAM_ID");


--
-- Name: MAPPEDOIDCGROUP_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "MAPPEDOIDCGROUP_N49" ON public."MAPPEDOIDCGROUP" USING btree ("GROUP_ID");


--
-- Name: MAPPEDOIDCGROUP_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "MAPPEDOIDCGROUP_N50" ON public."MAPPEDOIDCGROUP" USING btree ("TEAM_ID");


--
-- Name: NOTIFICATIONRULE_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "NOTIFICATIONRULE_N49" ON public."NOTIFICATIONRULE" USING btree ("PUBLISHER");


--
-- Name: NOTIFICATIONRULE_PROJECTS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "NOTIFICATIONRULE_PROJECTS_N49" ON public."NOTIFICATIONRULE_PROJECTS" USING btree ("PROJECT_ID");


--
-- Name: NOTIFICATIONRULE_PROJECTS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "NOTIFICATIONRULE_PROJECTS_N50" ON public."NOTIFICATIONRULE_PROJECTS" USING btree ("NOTIFICATIONRULE_ID");


--
-- Name: NOTIFICATIONRULE_TAGS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "NOTIFICATIONRULE_TAGS_N49" ON public."NOTIFICATIONRULE_TAGS" USING btree ("TAG_ID");


--
-- Name: NOTIFICATIONRULE_TAGS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "NOTIFICATIONRULE_TAGS_N50" ON public."NOTIFICATIONRULE_TAGS" USING btree ("NOTIFICATIONRULE_ID");


--
-- Name: NOTIFICATIONRULE_TEAMS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "NOTIFICATIONRULE_TEAMS_N49" ON public."NOTIFICATIONRULE_TEAMS" USING btree ("TEAM_ID");


--
-- Name: NOTIFICATIONRULE_TEAMS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "NOTIFICATIONRULE_TEAMS_N50" ON public."NOTIFICATIONRULE_TEAMS" USING btree ("NOTIFICATIONRULE_ID");


--
-- Name: OIDCUSERS_PERMISSIONS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "OIDCUSERS_PERMISSIONS_N49" ON public."OIDCUSERS_PERMISSIONS" USING btree ("PERMISSION_ID");


--
-- Name: OIDCUSERS_PERMISSIONS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "OIDCUSERS_PERMISSIONS_N50" ON public."OIDCUSERS_PERMISSIONS" USING btree ("OIDCUSER_ID");


--
-- Name: OIDCUSERS_TEAMS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "OIDCUSERS_TEAMS_N49" ON public."OIDCUSERS_TEAMS" USING btree ("OIDCUSERS_ID");


--
-- Name: OIDCUSERS_TEAMS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "OIDCUSERS_TEAMS_N50" ON public."OIDCUSERS_TEAMS" USING btree ("TEAM_ID");


--
-- Name: POLICYCONDITION_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "POLICYCONDITION_N49" ON public."POLICYCONDITION" USING btree ("POLICY_ID");


--
-- Name: POLICYVIOLATION_COMPONENT_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "POLICYVIOLATION_COMPONENT_IDX" ON public."POLICYVIOLATION" USING btree ("COMPONENT_ID");


--
-- Name: POLICYVIOLATION_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "POLICYVIOLATION_N49" ON public."POLICYVIOLATION" USING btree ("POLICYCONDITION_ID");


--
-- Name: POLICYVIOLATION_PROJECT_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "POLICYVIOLATION_PROJECT_IDX" ON public."POLICYVIOLATION" USING btree ("PROJECT_ID");


--
-- Name: POLICY_NAME_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "POLICY_NAME_IDX" ON public."POLICY" USING btree ("NAME");


--
-- Name: POLICY_PROJECTS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "POLICY_PROJECTS_N49" ON public."POLICY_PROJECTS" USING btree ("POLICY_ID");


--
-- Name: POLICY_PROJECTS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "POLICY_PROJECTS_N50" ON public."POLICY_PROJECTS" USING btree ("PROJECT_ID");


--
-- Name: POLICY_TAGS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "POLICY_TAGS_N49" ON public."POLICY_TAGS" USING btree ("TAG_ID");


--
-- Name: POLICY_TAGS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "POLICY_TAGS_N50" ON public."POLICY_TAGS" USING btree ("POLICY_ID");


--
-- Name: PORTFOLIOMETRICS_FIRST_OCCURRENCE_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PORTFOLIOMETRICS_FIRST_OCCURRENCE_IDX" ON public."PORTFOLIOMETRICS" USING btree ("FIRST_OCCURRENCE");


--
-- Name: PORTFOLIOMETRICS_LAST_OCCURRENCE_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PORTFOLIOMETRICS_LAST_OCCURRENCE_IDX" ON public."PORTFOLIOMETRICS" USING btree ("LAST_OCCURRENCE");


--
-- Name: PROJECTMETRICS_FIRST_OCCURRENCE_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECTMETRICS_FIRST_OCCURRENCE_IDX" ON public."PROJECTMETRICS" USING btree ("FIRST_OCCURRENCE");


--
-- Name: PROJECTMETRICS_LAST_OCCURRENCE_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECTMETRICS_LAST_OCCURRENCE_IDX" ON public."PROJECTMETRICS" USING btree ("LAST_OCCURRENCE");


--
-- Name: PROJECTMETRICS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECTMETRICS_N49" ON public."PROJECTMETRICS" USING btree ("PROJECT_ID");


--
-- Name: PROJECTS_TAGS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECTS_TAGS_N49" ON public."PROJECTS_TAGS" USING btree ("TAG_ID");


--
-- Name: PROJECTS_TAGS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECTS_TAGS_N50" ON public."PROJECTS_TAGS" USING btree ("PROJECT_ID");


--
-- Name: PROJECT_ACCESS_TEAMS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_ACCESS_TEAMS_N49" ON public."PROJECT_ACCESS_TEAMS" USING btree ("PROJECT_ID");


--
-- Name: PROJECT_ACCESS_TEAMS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_ACCESS_TEAMS_N50" ON public."PROJECT_ACCESS_TEAMS" USING btree ("TEAM_ID");


--
-- Name: PROJECT_CLASSIFIER_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_CLASSIFIER_IDX" ON public."PROJECT" USING btree ("CLASSIFIER");


--
-- Name: PROJECT_CPE_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_CPE_IDX" ON public."PROJECT" USING btree ("CPE");


--
-- Name: PROJECT_GROUP_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_GROUP_IDX" ON public."PROJECT" USING btree ("GROUP");


--
-- Name: PROJECT_IS_LATEST_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_IS_LATEST_IDX" ON public."PROJECT" USING btree ("IS_LATEST");


--
-- Name: PROJECT_LASTBOMIMPORT_FORMAT_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_LASTBOMIMPORT_FORMAT_IDX" ON public."PROJECT" USING btree ("LAST_BOM_IMPORTED_FORMAT");


--
-- Name: PROJECT_LASTBOMIMPORT_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_LASTBOMIMPORT_IDX" ON public."PROJECT" USING btree ("LAST_BOM_IMPORTED");


--
-- Name: PROJECT_LAST_RISKSCORE_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_LAST_RISKSCORE_IDX" ON public."PROJECT" USING btree ("LAST_RISKSCORE");


--
-- Name: PROJECT_METADATA_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_METADATA_N49" ON public."PROJECT_METADATA" USING btree ("PROJECT_ID");


--
-- Name: PROJECT_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_N49" ON public."PROJECT" USING btree ("PARENT_PROJECT_ID");


--
-- Name: PROJECT_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_N50" ON public."PROJECT" USING btree ("COLLECTION_TAG");


--
-- Name: PROJECT_NAME_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_NAME_IDX" ON public."PROJECT" USING btree ("NAME");


--
-- Name: PROJECT_PROPERTY_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_PROPERTY_N49" ON public."PROJECT_PROPERTY" USING btree ("PROJECT_ID");


--
-- Name: PROJECT_PURL_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_PURL_IDX" ON public."PROJECT" USING btree ("PURL");


--
-- Name: PROJECT_SWID_TAGID_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_SWID_TAGID_IDX" ON public."PROJECT" USING btree ("SWIDTAGID");


--
-- Name: PROJECT_VERSION_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "PROJECT_VERSION_IDX" ON public."PROJECT" USING btree ("VERSION");


--
-- Name: REPOSITORY_META_COMPONENT_COMPOUND_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE UNIQUE INDEX "REPOSITORY_META_COMPONENT_COMPOUND_IDX" ON public."REPOSITORY_META_COMPONENT" USING btree ("REPOSITORY_TYPE", "NAMESPACE", "NAME");


--
-- Name: REPOSITORY_META_COMPONENT_LASTCHECK_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "REPOSITORY_META_COMPONENT_LASTCHECK_IDX" ON public."REPOSITORY_META_COMPONENT" USING btree ("LAST_CHECK");


--
-- Name: REPOSITORY_UUID_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "REPOSITORY_UUID_IDX" ON public."REPOSITORY" USING btree ("UUID");


--
-- Name: SERVICECOMPONENTS_VULNERABILITIES_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "SERVICECOMPONENTS_VULNERABILITIES_N49" ON public."SERVICECOMPONENTS_VULNERABILITIES" USING btree ("SERVICECOMPONENT_ID");


--
-- Name: SERVICECOMPONENTS_VULNERABILITIES_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "SERVICECOMPONENTS_VULNERABILITIES_N50" ON public."SERVICECOMPONENTS_VULNERABILITIES" USING btree ("VULNERABILITY_ID");


--
-- Name: SERVICECOMPONENT_LAST_RISKSCORE_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "SERVICECOMPONENT_LAST_RISKSCORE_IDX" ON public."SERVICECOMPONENT" USING btree ("LAST_RISKSCORE");


--
-- Name: SERVICECOMPONENT_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "SERVICECOMPONENT_N49" ON public."SERVICECOMPONENT" USING btree ("PROJECT_ID");


--
-- Name: SERVICECOMPONENT_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "SERVICECOMPONENT_N50" ON public."SERVICECOMPONENT" USING btree ("PARENT_SERVICECOMPONENT_ID");


--
-- Name: SUBSCRIBERCLASS_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "SUBSCRIBERCLASS_IDX" ON public."EVENTSERVICELOG" USING btree ("SUBSCRIBERCLASS");


--
-- Name: TAG_NAME_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE UNIQUE INDEX "TAG_NAME_IDX" ON public."TAG" USING btree ("NAME");


--
-- Name: TEAMS_PERMISSIONS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "TEAMS_PERMISSIONS_N49" ON public."TEAMS_PERMISSIONS" USING btree ("TEAM_ID");


--
-- Name: TEAMS_PERMISSIONS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "TEAMS_PERMISSIONS_N50" ON public."TEAMS_PERMISSIONS" USING btree ("PERMISSION_ID");


--
-- Name: VEX_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VEX_N49" ON public."VEX" USING btree ("PROJECT_ID");


--
-- Name: VIOLATIONANALYSISCOMMENT_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VIOLATIONANALYSISCOMMENT_N49" ON public."VIOLATIONANALYSISCOMMENT" USING btree ("VIOLATIONANALYSIS_ID");


--
-- Name: VIOLATIONANALYSIS_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VIOLATIONANALYSIS_N49" ON public."VIOLATIONANALYSIS" USING btree ("POLICYVIOLATION_ID");


--
-- Name: VIOLATIONANALYSIS_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VIOLATIONANALYSIS_N50" ON public."VIOLATIONANALYSIS" USING btree ("COMPONENT_ID");


--
-- Name: VIOLATIONANALYSIS_N51; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VIOLATIONANALYSIS_N51" ON public."VIOLATIONANALYSIS" USING btree ("PROJECT_ID");


--
-- Name: VULNERABILITYALIAS_CVE_ID_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABILITYALIAS_CVE_ID_IDX" ON public."VULNERABILITYALIAS" USING btree ("CVE_ID");


--
-- Name: VULNERABILITYALIAS_GHSA_ID_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABILITYALIAS_GHSA_ID_IDX" ON public."VULNERABILITYALIAS" USING btree ("GHSA_ID");


--
-- Name: VULNERABILITYALIAS_GSD_ID_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABILITYALIAS_GSD_ID_IDX" ON public."VULNERABILITYALIAS" USING btree ("GSD_ID");


--
-- Name: VULNERABILITYALIAS_INTERNAL_ID_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABILITYALIAS_INTERNAL_ID_IDX" ON public."VULNERABILITYALIAS" USING btree ("INTERNAL_ID");


--
-- Name: VULNERABILITYALIAS_OSV_ID_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABILITYALIAS_OSV_ID_IDX" ON public."VULNERABILITYALIAS" USING btree ("OSV_ID");


--
-- Name: VULNERABILITYALIAS_SNYK_ID_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABILITYALIAS_SNYK_ID_IDX" ON public."VULNERABILITYALIAS" USING btree ("SNYK_ID");


--
-- Name: VULNERABILITYALIAS_SONATYPE_ID_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABILITYALIAS_SONATYPE_ID_IDX" ON public."VULNERABILITYALIAS" USING btree ("SONATYPE_ID");


--
-- Name: VULNERABILITYALIAS_VULNDB_ID_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABILITYALIAS_VULNDB_ID_IDX" ON public."VULNERABILITYALIAS" USING btree ("VULNDB_ID");


--
-- Name: VULNERABILITY_CREATED_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABILITY_CREATED_IDX" ON public."VULNERABILITY" USING btree ("CREATED");


--
-- Name: VULNERABILITY_PUBLISHED_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABILITY_PUBLISHED_IDX" ON public."VULNERABILITY" USING btree ("PUBLISHED");


--
-- Name: VULNERABILITY_UPDATED_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABILITY_UPDATED_IDX" ON public."VULNERABILITY" USING btree ("UPDATED");


--
-- Name: VULNERABILITY_VULNID_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABILITY_VULNID_IDX" ON public."VULNERABILITY" USING btree ("VULNID");


--
-- Name: VULNERABLESOFTWARE_CPE23_VERSION_RANGE_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABLESOFTWARE_CPE23_VERSION_RANGE_IDX" ON public."VULNERABLESOFTWARE" USING btree ("CPE23", "VERSIONENDEXCLUDING", "VERSIONENDINCLUDING", "VERSIONSTARTEXCLUDING", "VERSIONSTARTINCLUDING");


--
-- Name: VULNERABLESOFTWARE_CPE_PURL_PARTS_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABLESOFTWARE_CPE_PURL_PARTS_IDX" ON public."VULNERABLESOFTWARE" USING btree ("PART", "VENDOR", "PRODUCT", "PURL_TYPE", "PURL_NAMESPACE", "PURL_NAME");


--
-- Name: VULNERABLESOFTWARE_FULL_PURL_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABLESOFTWARE_FULL_PURL_IDX" ON public."VULNERABLESOFTWARE" USING btree ("PURL_TYPE", "PURL_NAMESPACE", "PURL_NAME", "VERSION");


--
-- Name: VULNERABLESOFTWARE_PART_VENDOR_PRODUCT_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABLESOFTWARE_PART_VENDOR_PRODUCT_IDX" ON public."VULNERABLESOFTWARE" USING btree ("PART", "VENDOR", "PRODUCT");


--
-- Name: VULNERABLESOFTWARE_PURL_TYPE_NS_NAME_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABLESOFTWARE_PURL_TYPE_NS_NAME_IDX" ON public."VULNERABLESOFTWARE" USING btree ("PURL_TYPE", "PURL_NAMESPACE", "PURL_NAME");


--
-- Name: VULNERABLESOFTWARE_PURL_VERSION_RANGE_IDX; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABLESOFTWARE_PURL_VERSION_RANGE_IDX" ON public."VULNERABLESOFTWARE" USING btree ("PURL", "VERSIONENDEXCLUDING", "VERSIONENDINCLUDING", "VERSIONSTARTEXCLUDING", "VERSIONSTARTINCLUDING");


--
-- Name: VULNERABLESOFTWARE_VULNERABILITIES_N49; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABLESOFTWARE_VULNERABILITIES_N49" ON public."VULNERABLESOFTWARE_VULNERABILITIES" USING btree ("VULNERABILITY_ID");


--
-- Name: VULNERABLESOFTWARE_VULNERABILITIES_N50; Type: INDEX; Schema: public; Owner: dtrack
--

CREATE INDEX "VULNERABLESOFTWARE_VULNERABILITIES_N50" ON public."VULNERABLESOFTWARE_VULNERABILITIES" USING btree ("VULNERABLESOFTWARE_ID");


--
-- Name: AFFECTEDVERSIONATTRIBUTION AFFECTEDVERSIONATTRIBUTION_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."AFFECTEDVERSIONATTRIBUTION"
    ADD CONSTRAINT "AFFECTEDVERSIONATTRIBUTION_FK1" FOREIGN KEY ("VULNERABILITY") REFERENCES public."VULNERABILITY"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: AFFECTEDVERSIONATTRIBUTION AFFECTEDVERSIONATTRIBUTION_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."AFFECTEDVERSIONATTRIBUTION"
    ADD CONSTRAINT "AFFECTEDVERSIONATTRIBUTION_FK2" FOREIGN KEY ("VULNERABLE_SOFTWARE") REFERENCES public."VULNERABLESOFTWARE"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ANALYSISCOMMENT ANALYSISCOMMENT_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."ANALYSISCOMMENT"
    ADD CONSTRAINT "ANALYSISCOMMENT_FK1" FOREIGN KEY ("ANALYSIS_ID") REFERENCES public."ANALYSIS"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ANALYSIS ANALYSIS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."ANALYSIS"
    ADD CONSTRAINT "ANALYSIS_FK1" FOREIGN KEY ("COMPONENT_ID") REFERENCES public."COMPONENT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ANALYSIS ANALYSIS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."ANALYSIS"
    ADD CONSTRAINT "ANALYSIS_FK2" FOREIGN KEY ("PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ANALYSIS ANALYSIS_FK3; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."ANALYSIS"
    ADD CONSTRAINT "ANALYSIS_FK3" FOREIGN KEY ("VULNERABILITY_ID") REFERENCES public."VULNERABILITY"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: APIKEYS_TEAMS APIKEYS_TEAMS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."APIKEYS_TEAMS"
    ADD CONSTRAINT "APIKEYS_TEAMS_FK1" FOREIGN KEY ("TEAM_ID") REFERENCES public."TEAM"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: APIKEYS_TEAMS APIKEYS_TEAMS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."APIKEYS_TEAMS"
    ADD CONSTRAINT "APIKEYS_TEAMS_FK2" FOREIGN KEY ("APIKEY_ID") REFERENCES public."APIKEY"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: BOM BOM_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."BOM"
    ADD CONSTRAINT "BOM_FK1" FOREIGN KEY ("PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: COMPONENTS_VULNERABILITIES COMPONENTS_VULNERABILITIES_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."COMPONENTS_VULNERABILITIES"
    ADD CONSTRAINT "COMPONENTS_VULNERABILITIES_FK1" FOREIGN KEY ("COMPONENT_ID") REFERENCES public."COMPONENT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: COMPONENTS_VULNERABILITIES COMPONENTS_VULNERABILITIES_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."COMPONENTS_VULNERABILITIES"
    ADD CONSTRAINT "COMPONENTS_VULNERABILITIES_FK2" FOREIGN KEY ("VULNERABILITY_ID") REFERENCES public."VULNERABILITY"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: COMPONENT COMPONENT_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."COMPONENT"
    ADD CONSTRAINT "COMPONENT_FK1" FOREIGN KEY ("PARENT_COMPONENT_ID") REFERENCES public."COMPONENT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: COMPONENT COMPONENT_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."COMPONENT"
    ADD CONSTRAINT "COMPONENT_FK2" FOREIGN KEY ("PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: COMPONENT COMPONENT_FK3; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."COMPONENT"
    ADD CONSTRAINT "COMPONENT_FK3" FOREIGN KEY ("LICENSE_ID") REFERENCES public."LICENSE"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: COMPONENT_PROPERTY COMPONENT_PROPERTY_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."COMPONENT_PROPERTY"
    ADD CONSTRAINT "COMPONENT_PROPERTY_FK1" FOREIGN KEY ("COMPONENT_ID") REFERENCES public."COMPONENT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: DEPENDENCYMETRICS DEPENDENCYMETRICS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."DEPENDENCYMETRICS"
    ADD CONSTRAINT "DEPENDENCYMETRICS_FK1" FOREIGN KEY ("COMPONENT_ID") REFERENCES public."COMPONENT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: DEPENDENCYMETRICS DEPENDENCYMETRICS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."DEPENDENCYMETRICS"
    ADD CONSTRAINT "DEPENDENCYMETRICS_FK2" FOREIGN KEY ("PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: FINDINGATTRIBUTION FINDINGATTRIBUTION_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."FINDINGATTRIBUTION"
    ADD CONSTRAINT "FINDINGATTRIBUTION_FK1" FOREIGN KEY ("COMPONENT_ID") REFERENCES public."COMPONENT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: FINDINGATTRIBUTION FINDINGATTRIBUTION_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."FINDINGATTRIBUTION"
    ADD CONSTRAINT "FINDINGATTRIBUTION_FK2" FOREIGN KEY ("PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: FINDINGATTRIBUTION FINDINGATTRIBUTION_FK3; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."FINDINGATTRIBUTION"
    ADD CONSTRAINT "FINDINGATTRIBUTION_FK3" FOREIGN KEY ("VULNERABILITY_ID") REFERENCES public."VULNERABILITY"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: LDAPUSERS_PERMISSIONS LDAPUSERS_PERMISSIONS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."LDAPUSERS_PERMISSIONS"
    ADD CONSTRAINT "LDAPUSERS_PERMISSIONS_FK1" FOREIGN KEY ("LDAPUSER_ID") REFERENCES public."LDAPUSER"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: LDAPUSERS_PERMISSIONS LDAPUSERS_PERMISSIONS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."LDAPUSERS_PERMISSIONS"
    ADD CONSTRAINT "LDAPUSERS_PERMISSIONS_FK2" FOREIGN KEY ("PERMISSION_ID") REFERENCES public."PERMISSION"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: LDAPUSERS_TEAMS LDAPUSERS_TEAMS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."LDAPUSERS_TEAMS"
    ADD CONSTRAINT "LDAPUSERS_TEAMS_FK1" FOREIGN KEY ("TEAM_ID") REFERENCES public."TEAM"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: LDAPUSERS_TEAMS LDAPUSERS_TEAMS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."LDAPUSERS_TEAMS"
    ADD CONSTRAINT "LDAPUSERS_TEAMS_FK2" FOREIGN KEY ("LDAPUSER_ID") REFERENCES public."LDAPUSER"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: LICENSEGROUP_LICENSE LICENSEGROUP_LICENSE_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."LICENSEGROUP_LICENSE"
    ADD CONSTRAINT "LICENSEGROUP_LICENSE_FK1" FOREIGN KEY ("LICENSEGROUP_ID") REFERENCES public."LICENSEGROUP"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: LICENSEGROUP_LICENSE LICENSEGROUP_LICENSE_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."LICENSEGROUP_LICENSE"
    ADD CONSTRAINT "LICENSEGROUP_LICENSE_FK2" FOREIGN KEY ("LICENSE_ID") REFERENCES public."LICENSE"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: MANAGEDUSERS_PERMISSIONS MANAGEDUSERS_PERMISSIONS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MANAGEDUSERS_PERMISSIONS"
    ADD CONSTRAINT "MANAGEDUSERS_PERMISSIONS_FK1" FOREIGN KEY ("MANAGEDUSER_ID") REFERENCES public."MANAGEDUSER"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: MANAGEDUSERS_PERMISSIONS MANAGEDUSERS_PERMISSIONS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MANAGEDUSERS_PERMISSIONS"
    ADD CONSTRAINT "MANAGEDUSERS_PERMISSIONS_FK2" FOREIGN KEY ("PERMISSION_ID") REFERENCES public."PERMISSION"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: MANAGEDUSERS_TEAMS MANAGEDUSERS_TEAMS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MANAGEDUSERS_TEAMS"
    ADD CONSTRAINT "MANAGEDUSERS_TEAMS_FK1" FOREIGN KEY ("TEAM_ID") REFERENCES public."TEAM"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: MANAGEDUSERS_TEAMS MANAGEDUSERS_TEAMS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MANAGEDUSERS_TEAMS"
    ADD CONSTRAINT "MANAGEDUSERS_TEAMS_FK2" FOREIGN KEY ("MANAGEDUSER_ID") REFERENCES public."MANAGEDUSER"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: MAPPEDLDAPGROUP MAPPEDLDAPGROUP_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MAPPEDLDAPGROUP"
    ADD CONSTRAINT "MAPPEDLDAPGROUP_FK1" FOREIGN KEY ("TEAM_ID") REFERENCES public."TEAM"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: MAPPEDOIDCGROUP MAPPEDOIDCGROUP_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MAPPEDOIDCGROUP"
    ADD CONSTRAINT "MAPPEDOIDCGROUP_FK1" FOREIGN KEY ("GROUP_ID") REFERENCES public."OIDCGROUP"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: MAPPEDOIDCGROUP MAPPEDOIDCGROUP_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."MAPPEDOIDCGROUP"
    ADD CONSTRAINT "MAPPEDOIDCGROUP_FK2" FOREIGN KEY ("TEAM_ID") REFERENCES public."TEAM"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: NOTIFICATIONRULE NOTIFICATIONRULE_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."NOTIFICATIONRULE"
    ADD CONSTRAINT "NOTIFICATIONRULE_FK1" FOREIGN KEY ("PUBLISHER") REFERENCES public."NOTIFICATIONPUBLISHER"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: NOTIFICATIONRULE_PROJECTS NOTIFICATIONRULE_PROJECTS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."NOTIFICATIONRULE_PROJECTS"
    ADD CONSTRAINT "NOTIFICATIONRULE_PROJECTS_FK1" FOREIGN KEY ("NOTIFICATIONRULE_ID") REFERENCES public."NOTIFICATIONRULE"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: NOTIFICATIONRULE_PROJECTS NOTIFICATIONRULE_PROJECTS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."NOTIFICATIONRULE_PROJECTS"
    ADD CONSTRAINT "NOTIFICATIONRULE_PROJECTS_FK2" FOREIGN KEY ("PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: NOTIFICATIONRULE_TAGS NOTIFICATIONRULE_TAGS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."NOTIFICATIONRULE_TAGS"
    ADD CONSTRAINT "NOTIFICATIONRULE_TAGS_FK1" FOREIGN KEY ("NOTIFICATIONRULE_ID") REFERENCES public."NOTIFICATIONRULE"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: NOTIFICATIONRULE_TAGS NOTIFICATIONRULE_TAGS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."NOTIFICATIONRULE_TAGS"
    ADD CONSTRAINT "NOTIFICATIONRULE_TAGS_FK2" FOREIGN KEY ("TAG_ID") REFERENCES public."TAG"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: NOTIFICATIONRULE_TEAMS NOTIFICATIONRULE_TEAMS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."NOTIFICATIONRULE_TEAMS"
    ADD CONSTRAINT "NOTIFICATIONRULE_TEAMS_FK1" FOREIGN KEY ("NOTIFICATIONRULE_ID") REFERENCES public."NOTIFICATIONRULE"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: NOTIFICATIONRULE_TEAMS NOTIFICATIONRULE_TEAMS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."NOTIFICATIONRULE_TEAMS"
    ADD CONSTRAINT "NOTIFICATIONRULE_TEAMS_FK2" FOREIGN KEY ("TEAM_ID") REFERENCES public."TEAM"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: OIDCUSERS_PERMISSIONS OIDCUSERS_PERMISSIONS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."OIDCUSERS_PERMISSIONS"
    ADD CONSTRAINT "OIDCUSERS_PERMISSIONS_FK1" FOREIGN KEY ("PERMISSION_ID") REFERENCES public."PERMISSION"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: OIDCUSERS_PERMISSIONS OIDCUSERS_PERMISSIONS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."OIDCUSERS_PERMISSIONS"
    ADD CONSTRAINT "OIDCUSERS_PERMISSIONS_FK2" FOREIGN KEY ("OIDCUSER_ID") REFERENCES public."OIDCUSER"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: OIDCUSERS_TEAMS OIDCUSERS_TEAMS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."OIDCUSERS_TEAMS"
    ADD CONSTRAINT "OIDCUSERS_TEAMS_FK1" FOREIGN KEY ("OIDCUSERS_ID") REFERENCES public."OIDCUSER"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: OIDCUSERS_TEAMS OIDCUSERS_TEAMS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."OIDCUSERS_TEAMS"
    ADD CONSTRAINT "OIDCUSERS_TEAMS_FK2" FOREIGN KEY ("TEAM_ID") REFERENCES public."TEAM"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: POLICYCONDITION POLICYCONDITION_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICYCONDITION"
    ADD CONSTRAINT "POLICYCONDITION_FK1" FOREIGN KEY ("POLICY_ID") REFERENCES public."POLICY"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: POLICYVIOLATION POLICYVIOLATION_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICYVIOLATION"
    ADD CONSTRAINT "POLICYVIOLATION_FK1" FOREIGN KEY ("COMPONENT_ID") REFERENCES public."COMPONENT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: POLICYVIOLATION POLICYVIOLATION_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICYVIOLATION"
    ADD CONSTRAINT "POLICYVIOLATION_FK2" FOREIGN KEY ("POLICYCONDITION_ID") REFERENCES public."POLICYCONDITION"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: POLICYVIOLATION POLICYVIOLATION_FK3; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICYVIOLATION"
    ADD CONSTRAINT "POLICYVIOLATION_FK3" FOREIGN KEY ("PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: POLICY_PROJECTS POLICY_PROJECTS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICY_PROJECTS"
    ADD CONSTRAINT "POLICY_PROJECTS_FK1" FOREIGN KEY ("POLICY_ID") REFERENCES public."POLICY"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: POLICY_PROJECTS POLICY_PROJECTS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICY_PROJECTS"
    ADD CONSTRAINT "POLICY_PROJECTS_FK2" FOREIGN KEY ("PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: POLICY_TAGS POLICY_TAGS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICY_TAGS"
    ADD CONSTRAINT "POLICY_TAGS_FK1" FOREIGN KEY ("TAG_ID") REFERENCES public."TAG"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: POLICY_TAGS POLICY_TAGS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."POLICY_TAGS"
    ADD CONSTRAINT "POLICY_TAGS_FK2" FOREIGN KEY ("POLICY_ID") REFERENCES public."POLICY"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: PROJECTMETRICS PROJECTMETRICS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECTMETRICS"
    ADD CONSTRAINT "PROJECTMETRICS_FK1" FOREIGN KEY ("PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: PROJECTS_TAGS PROJECTS_TAGS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECTS_TAGS"
    ADD CONSTRAINT "PROJECTS_TAGS_FK1" FOREIGN KEY ("TAG_ID") REFERENCES public."TAG"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: PROJECTS_TAGS PROJECTS_TAGS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECTS_TAGS"
    ADD CONSTRAINT "PROJECTS_TAGS_FK2" FOREIGN KEY ("PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: PROJECT_ACCESS_TEAMS PROJECT_ACCESS_TEAMS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECT_ACCESS_TEAMS"
    ADD CONSTRAINT "PROJECT_ACCESS_TEAMS_FK1" FOREIGN KEY ("PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: PROJECT_ACCESS_TEAMS PROJECT_ACCESS_TEAMS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECT_ACCESS_TEAMS"
    ADD CONSTRAINT "PROJECT_ACCESS_TEAMS_FK2" FOREIGN KEY ("TEAM_ID") REFERENCES public."TEAM"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: PROJECT PROJECT_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECT"
    ADD CONSTRAINT "PROJECT_FK1" FOREIGN KEY ("COLLECTION_TAG") REFERENCES public."TAG"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: PROJECT PROJECT_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECT"
    ADD CONSTRAINT "PROJECT_FK2" FOREIGN KEY ("PARENT_PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: PROJECT_METADATA PROJECT_METADATA_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECT_METADATA"
    ADD CONSTRAINT "PROJECT_METADATA_FK1" FOREIGN KEY ("PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: PROJECT_PROPERTY PROJECT_PROPERTY_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."PROJECT_PROPERTY"
    ADD CONSTRAINT "PROJECT_PROPERTY_FK1" FOREIGN KEY ("PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: SERVICECOMPONENTS_VULNERABILITIES SERVICECOMPONENTS_VULNERABILITIES_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."SERVICECOMPONENTS_VULNERABILITIES"
    ADD CONSTRAINT "SERVICECOMPONENTS_VULNERABILITIES_FK1" FOREIGN KEY ("VULNERABILITY_ID") REFERENCES public."VULNERABILITY"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: SERVICECOMPONENTS_VULNERABILITIES SERVICECOMPONENTS_VULNERABILITIES_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."SERVICECOMPONENTS_VULNERABILITIES"
    ADD CONSTRAINT "SERVICECOMPONENTS_VULNERABILITIES_FK2" FOREIGN KEY ("SERVICECOMPONENT_ID") REFERENCES public."SERVICECOMPONENT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: SERVICECOMPONENT SERVICECOMPONENT_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."SERVICECOMPONENT"
    ADD CONSTRAINT "SERVICECOMPONENT_FK1" FOREIGN KEY ("PARENT_SERVICECOMPONENT_ID") REFERENCES public."SERVICECOMPONENT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: SERVICECOMPONENT SERVICECOMPONENT_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."SERVICECOMPONENT"
    ADD CONSTRAINT "SERVICECOMPONENT_FK2" FOREIGN KEY ("PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: TEAMS_PERMISSIONS TEAMS_PERMISSIONS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."TEAMS_PERMISSIONS"
    ADD CONSTRAINT "TEAMS_PERMISSIONS_FK1" FOREIGN KEY ("TEAM_ID") REFERENCES public."TEAM"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: TEAMS_PERMISSIONS TEAMS_PERMISSIONS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."TEAMS_PERMISSIONS"
    ADD CONSTRAINT "TEAMS_PERMISSIONS_FK2" FOREIGN KEY ("PERMISSION_ID") REFERENCES public."PERMISSION"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: VEX VEX_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VEX"
    ADD CONSTRAINT "VEX_FK1" FOREIGN KEY ("PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: VIOLATIONANALYSISCOMMENT VIOLATIONANALYSISCOMMENT_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VIOLATIONANALYSISCOMMENT"
    ADD CONSTRAINT "VIOLATIONANALYSISCOMMENT_FK1" FOREIGN KEY ("VIOLATIONANALYSIS_ID") REFERENCES public."VIOLATIONANALYSIS"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: VIOLATIONANALYSIS VIOLATIONANALYSIS_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VIOLATIONANALYSIS"
    ADD CONSTRAINT "VIOLATIONANALYSIS_FK1" FOREIGN KEY ("COMPONENT_ID") REFERENCES public."COMPONENT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: VIOLATIONANALYSIS VIOLATIONANALYSIS_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VIOLATIONANALYSIS"
    ADD CONSTRAINT "VIOLATIONANALYSIS_FK2" FOREIGN KEY ("POLICYVIOLATION_ID") REFERENCES public."POLICYVIOLATION"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: VIOLATIONANALYSIS VIOLATIONANALYSIS_FK3; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VIOLATIONANALYSIS"
    ADD CONSTRAINT "VIOLATIONANALYSIS_FK3" FOREIGN KEY ("PROJECT_ID") REFERENCES public."PROJECT"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: VULNERABLESOFTWARE_VULNERABILITIES VULNERABLESOFTWARE_VULNERABILITIES_FK1; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VULNERABLESOFTWARE_VULNERABILITIES"
    ADD CONSTRAINT "VULNERABLESOFTWARE_VULNERABILITIES_FK1" FOREIGN KEY ("VULNERABILITY_ID") REFERENCES public."VULNERABILITY"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- Name: VULNERABLESOFTWARE_VULNERABILITIES VULNERABLESOFTWARE_VULNERABILITIES_FK2; Type: FK CONSTRAINT; Schema: public; Owner: dtrack
--

ALTER TABLE ONLY public."VULNERABLESOFTWARE_VULNERABILITIES"
    ADD CONSTRAINT "VULNERABLESOFTWARE_VULNERABILITIES_FK2" FOREIGN KEY ("VULNERABLESOFTWARE_ID") REFERENCES public."VULNERABLESOFTWARE"("ID") DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

\unrestrict dLrwzXXSQS0ICOy89E4IxHdEosAmUcHrKrQZkg4QVJoBEXqDNBBaUZw9yoHgXCU

