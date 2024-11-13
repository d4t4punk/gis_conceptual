-- Table: star_schema.dim_land_area_type

DROP TABLE IF EXISTS star_schema.dim_land_area_type;

CREATE TABLE IF NOT EXISTS star_schema.dim_land_area_type
(
    land_area_type_id integer NOT NULL DEFAULT nextval('star_schema.dim_land_area_type_land_area_type_id_seq1'::regclass),
    land_area_type_name character varying COLLATE pg_catalog."default" NOT NULL,
    land_area_type_description character varying COLLATE pg_catalog."default",
    created_date_utc timestamp with time zone DEFAULT timezone('utc'::text, now()),
    last_updated_date_utc timestamp with time zone,
    created_by_identifier character varying COLLATE pg_catalog."default" NOT NULL,
    last_updated_by_identifier character varying COLLATE pg_catalog."default",
    CONSTRAINT dim_land_area_type_pk PRIMARY KEY (land_area_type_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS star_schema.dim_land_area_type
    OWNER to postgres;