-- FUNCTION: star_schema.fnct_update_daily_landareas()

DROP FUNCTION IF EXISTS star_schema.fnct_update_daily_landareas();

CREATE OR REPLACE FUNCTION star_schema.fnct_update_daily_landareas(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	-- Author - Scott Newby
	-- Date - 2024.10.01
	-- State - POC Code
	-- Description -
	-- create function to update land areas daily with
	-- spatial raster join to determine the precip and
	-- temp values at daily grain 
	-- raster resource can be delayed by 2-3 days - if not more
	-- TODO
	-- return success failure to calling routine - NOT void
	-- error handling
	DECLARE 
		t_id bigint;
		rast_dt date;
	BEGIN
		-- get the current raster date
		rast_dt := (select max(rast_date) from ref_climate.gpcp_rasters r);
		-- get the time_id based on the date of the records we're going to update
		t_id := (select dt.time_id from star_schema.fact f inner join star_schema.dim_time dt on f.time_id = dt.time_id where time_date = rast_dt limit 1);
		update star_schema.fact 
		SET
			precip_mm = a.precip_mm,
			precip_in = a.precip_in,
			temp_min_c = a.temp_min_c,
			temp_min_f = a.temp_min_f,
			temp_max_c = a.temp_max_c,
			temp_max_f = a.temp_max_f,
			temp_avg_c = a.temp_avg_c,
			temp_avg_f = a.temp_avg_f
		from ( 
		select  f.fact_id as f_id,
				dla.land_area_id ,
				t.time_id,
				st_value(r.rast,1,dla.centroid)::numeric as precip_mm,
				st_value(r.rast,1,dla.centroid)/25.4 as precip_in,
				st_value(r.rast,2,dla.centroid) as temp_min_c,
				(st_value(r.rast,2,dla.centroid)*1.8) + 32 as temp_min_f,
				st_value(r.rast,3,dla.centroid) as temp_max_c,
				(st_value(r.rast,3,dla.centroid)*1.8) + 32 as temp_max_f,
				st_value(r.rast,4,dla.centroid) as temp_avg_c,
				(st_value(r.rast,4,dla.centroid)*1.8) + 32 as temp_avg_f
		from star_schema.fact f 
			inner join star_schema.dim_land_area dla on f.land_area_id = dla.land_area_id
			inner join star_schema.dim_time t on f.time_id = t.time_id and t.time_id = t_id
			inner join ref_climate.gpcp_rasters r on st_intersects(r.rast, dla.centroid) and r.rast_date = rast_dt
		
) a
	where fact_id = a.f_id;
	
	END;
$BODY$;

ALTER FUNCTION star_schema.fnct_update_daily_landareas()
    OWNER TO postgres;
