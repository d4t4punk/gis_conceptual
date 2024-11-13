-- Table: star_schema.dim_precipitation_type

DROP TABLE IF EXISTS star_schema.dim_precipitation_type;

CREATE TABLE IF NOT EXISTS star_schema.dim_precipitation_type
(
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS star_schema.dim_precipitation_type
    OWNER to postgres;