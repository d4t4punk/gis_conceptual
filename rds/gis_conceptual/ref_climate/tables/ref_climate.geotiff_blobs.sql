-- Table: ref_climate.geotiff_blobs

DROP TABLE IF EXISTS ref_climate.geotiff_blobs;

CREATE TABLE IF NOT EXISTS ref_climate.geotiff_blobs
(
    id bigint NOT NULL DEFAULT nextval('ref_climate.geotiff_blobs_id_seq'::regclass),
    blob_data bytea NOT NULL,
    file_name character varying(256) COLLATE pg_catalog."default",
    CONSTRAINT geotiff_blobs_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS ref_climate.geotiff_blobs
    OWNER to postgres;

-- Trigger: gtrg_blob_to_raster

-- DROP TRIGGER IF EXISTS gtrg_blob_to_raster ON ref_climate.geotiff_blobs;

CREATE TRIGGER gtrg_blob_to_raster
    AFTER INSERT
    ON ref_climate.geotiff_blobs
    FOR EACH ROW
    EXECUTE FUNCTION ref_climate.trg_fnct_blob_to_50x50_raster();