-- FUNCTION: ref_climate.trg_fnct_blob_to_50x50_raster()

DROP FUNCTION IF EXISTS ref_climate.trg_fnct_blob_to_50x50_raster();

CREATE OR REPLACE FUNCTION ref_climate.trg_fnct_blob_to_50x50_raster()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE 
	clim_dt date;
	dtime_id bigint;
BEGIN
	-- skn - 2024.09.17
	-- 2nd step of processing geotiff image into rasters
	-- first get the climate_date:
	clim_dt := (select (left(left(right(file_name,12),8),4) || '-' || left(right(left(right(file_name,12),8),4),2) || '-' || right(right(left(right(file_name,12),8),4),2))::date from ref_climate.geotiff_blobs WHERE id = NEW.id);
    -- get the effective time dim id
--	dtime_id := (select time_id from star_schema.dim_time where time_date = clim_dt);
	-- create the rasters from the bytea initial step
	INSERT INTO ref_climate.gpcp_rasters(rast, rast_date)
	SELECT ST_Tile(ST_FromGDALRaster(blob_data), 50,50), clim_dt
	FROM ref_climate.geotiff_blobs WHERE id = NEW.id;

	
	-- update 
	RETURN NEW;
END;
$BODY$;

ALTER FUNCTION ref_climate.trg_fnct_blob_to_50x50_raster()
    OWNER TO postgres;
