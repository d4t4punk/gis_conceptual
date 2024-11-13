-- Table: star_schema.dim_crop_type

DROP TABLE IF EXISTS star_schema.dim_crop_type;

CREATE TABLE IF NOT EXISTS star_schema.dim_crop_type
(
    crop_type_id integer NOT NULL DEFAULT nextval('star_schema.dim_crop_type_crop_type_id_seq1'::regclass),
    crop_type_name character varying COLLATE pg_catalog."default" NOT NULL,
    crop_type_description character varying COLLATE pg_catalog."default" NOT NULL,
    crop_specific_species character varying COLLATE pg_catalog."default",
    created_date_utc timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
    created_by_identifier character varying COLLATE pg_catalog."default" NOT NULL,
    last_updated_date_utc timestamp with time zone,
    last_update_by_identifier character varying COLLATE pg_catalog."default",
    CONSTRAINT dim_crop_type_pk PRIMARY KEY (crop_type_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS star_schema.dim_crop_type
    OWNER to postgres;