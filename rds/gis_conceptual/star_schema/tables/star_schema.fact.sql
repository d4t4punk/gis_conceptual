-- Table: star_schema.fact

DROP TABLE IF EXISTS star_schema.fact;

CREATE TABLE IF NOT EXISTS star_schema.fact
(
    fact_id bigint NOT NULL DEFAULT nextval('star_schema.fact_fact_id_seq1'::regclass),
    time_id bigint NOT NULL,
    land_area_id bigint,
    land_area_type_id integer,
    precip_in double precision,
    precip_mm double precision,
    temp_min_f double precision,
    temp_max_f double precision,
    temp_avg_f double precision,
    temp_min_c double precision,
    temp_max_c double precision,
    temp_avg_c double precision,
    event_type_id integer,
    crop_type_id integer,
    elevation_ft double precision,
    elevation_m double precision,
    state_boundary_id integer,
    county_boundary_id integer,
    CONSTRAINT fact_pkey PRIMARY KEY (fact_id),
    CONSTRAINT fact_dim_county_boundary_fk FOREIGN KEY (county_boundary_id)
        REFERENCES star_schema.dim_county_boundary (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fact_dim_crop_type_fk FOREIGN KEY (crop_type_id)
        REFERENCES star_schema.dim_crop_type (crop_type_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fact_dim_event_type_fk FOREIGN KEY (event_type_id)
        REFERENCES star_schema.dim_event_type (event_type_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fact_dim_land_area_fk FOREIGN KEY (land_area_id)
        REFERENCES star_schema.dim_land_area (land_area_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fact_dim_land_area_type_fk FOREIGN KEY (land_area_type_id)
        REFERENCES star_schema.dim_land_area_type (land_area_type_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fact_dim_state_boundary_fk FOREIGN KEY (state_boundary_id)
        REFERENCES star_schema.dim_state_boundary (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fact_dim_time_fk FOREIGN KEY (time_id)
        REFERENCES star_schema.dim_time (time_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS star_schema.fact
    OWNER to postgres;
-- Index: fki_fact_dim_county_boundary_fk

-- DROP INDEX IF EXISTS star_schema.fki_fact_dim_county_boundary_fk;

CREATE INDEX IF NOT EXISTS fki_fact_dim_county_boundary_fk
    ON star_schema.fact USING btree
    (county_boundary_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fki_fact_dim_state_boundary_fk

-- DROP INDEX IF EXISTS star_schema.fki_fact_dim_state_boundary_fk;

CREATE INDEX IF NOT EXISTS fki_fact_dim_state_boundary_fk
    ON star_schema.fact USING btree
    (state_boundary_id ASC NULLS LAST)
    TABLESPACE pg_default;