-- Table: star_schema.dim_state_boundary

DROP TABLE IF EXISTS star_schema.dim_state_boundary;

CREATE TABLE IF NOT EXISTS star_schema.dim_state_boundary
(
    id integer NOT NULL DEFAULT nextval('star_schema.dim_state_boundary_id_seq1'::regclass),
    geom geometry NOT NULL,
    state_name character varying(256) COLLATE pg_catalog."default" NOT NULL,
    state_fips character varying(2) COLLATE pg_catalog."default" NOT NULL,
    created_date_utc timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
    CONSTRAINT dim_state_boundary_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS star_schema.dim_state_boundary
    OWNER to postgres;