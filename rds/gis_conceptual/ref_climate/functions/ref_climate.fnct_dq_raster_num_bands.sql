-- FUNCTION: ref_climate.fnct_dq_raster_num_bands(bytea)

DROP FUNCTION IF EXISTS ref_climate.fnct_dq_raster_num_bands(bytea);

CREATE OR REPLACE FUNCTION ref_climate.fnct_dq_raster_num_bands(
	rstr_data bytea)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	BEGIN
		-- skn - 2024.11.04 - 
		-- create function to check number of bands in raster file 
		return st_numbands(ST_FromGDALRaster(rstr_data));
	END;
$BODY$;

ALTER FUNCTION ref_climate.fnct_dq_raster_num_bands(bytea)
    OWNER TO postgres;
