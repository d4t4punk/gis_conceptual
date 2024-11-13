-- Table: star_schema.dim_land_area

DROP TABLE IF EXISTS star_schema.dim_land_area;

CREATE TABLE IF NOT EXISTS star_schema.dim_land_area
(
    land_area_id bigint NOT NULL DEFAULT nextval('star_schema.dim_land_area_land_area_id_seq1'::regclass),
    geom geometry,
    created_date_utc timestamp with time zone DEFAULT timezone('utc'::text, now()),
    last_updated_date_utc timestamp with time zone,
    created_by_identifier character varying COLLATE pg_catalog."default",
    last_updated_by_identifier character varying COLLATE pg_catalog."default",
    centroid geometry,
    elevation_ft numeric,
    acres numeric,
    CONSTRAINT dim_land_area_pk PRIMARY KEY (land_area_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS star_schema.dim_land_area
    OWNER to postgres;