-- Table: star_schema.dim_time

DROP TABLE IF EXISTS star_schema.dim_time;

CREATE TABLE IF NOT EXISTS star_schema.dim_time
(
    time_id bigint NOT NULL DEFAULT nextval('star_schema.dim_time_time_id_seq1'::regclass),
    time_year integer NOT NULL,
    time_month integer NOT NULL,
    time_day integer NOT NULL,
    time_date date,
    CONSTRAINT dim_time_pkey PRIMARY KEY (time_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS star_schema.dim_time
    OWNER to postgres;