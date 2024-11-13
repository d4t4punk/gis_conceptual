-- Table: star_schema.dim_county_boundary

DROP TABLE IF EXISTS star_schema.dim_county_boundary;

CREATE TABLE IF NOT EXISTS star_schema.dim_county_boundary
(
    id integer NOT NULL DEFAULT nextval('star_schema.dim_county_boundary_id_seq1'::regclass),
    geom geometry NOT NULL,
    county_name character varying(256) COLLATE pg_catalog."default" NOT NULL,
    county_fips character varying(3) COLLATE pg_catalog."default" NOT NULL,
    created_date_utc timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
    state_id integer,
    CONSTRAINT dim_county_boundary_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS star_schema.dim_county_boundary
    OWNER to postgres;