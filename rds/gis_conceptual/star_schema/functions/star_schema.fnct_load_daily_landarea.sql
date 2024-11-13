-- FUNCTION: star_schema.fnct_load_daily_landareas()

DROP FUNCTION IF EXISTS star_schema.fnct_load_daily_landareas();

CREATE OR REPLACE FUNCTION star_schema.fnct_load_daily_landareas(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
		-- Author - Scott Newby 
		-- Date - 2024.10.01  
		-- Description -
		-- create function to load land areas daily with
		-- spatial raster join (if available) to determine the precip and
		-- temp values at daily grain 
		-- TODO -
		-- add error handling
		-- return success/failure to caller NOT void
		-- log success/failure
		-- remove hard-coded values from insert statement when appropriate
	DECLARE 
		max_dt date;
		load_dt date;
	BEGIN
		-- get the latest date from the fact-dim_time join
		max_dt = (select max(dt.time_date) from star_schema.fact f inner join star_schema.dim_time dt on f.time_id = dt.time_id);
		-- determine the next day to load
		load_dt = max_dt+1;
		-- log the process
		insert into logging.star_schema_process_logging (proc) values ('star schema daily load');
		-- Only load if the load_date is less-than-equal to today
		if (load_dt <= now()::date) then
			-- insert the records for the load_dt date time - IF raster is available
			INSERT INTO star_schema.fact(
		 		time_id, precip_mm, precip_in, temp_min_c, temp_min_f, temp_max_c, temp_max_f, temp_avg_c, temp_avg_f, land_area_id, land_area_type_id, event_type_id, crop_type_id,county_boundary_id, state_boundary_id)
			select 
				(select time_id from star_schema.dim_time where time_year = EXTRACT(YEAR FROM load_dt) and time_month =  EXTRACT(MONTH FROM load_dt) and time_day =  EXTRACT(DAY FROM load_dt) ),
				st_value(r.rast,1,dla.centroid) AS precip_mm,
				st_value(r.rast,1,dla.centroid)/25.4 AS precip_in,
				st_value(r.rast,2,dla.centroid) AS temp_min_c,
				(st_value(r.rast,2,dla.centroid)*1.8) + 32 AS temp_min_f,
				st_value(r.rast,3,dla.centroid) AS temp_max_c,
				(st_value(r.rast,3,dla.centroid)*1.8) + 32  AS temp_max_f,
				st_value(r.rast,4,dla.centroid) AS temp_avg_c,
				(st_value(r.rast,4,dla.centroid)*1.8) + 32  AS temp_avg_f,
				dla.land_area_id,
				1, --crop area
				1, --daily climate
				3, --corn
				c.id,
				c.state_id
			from star_schema.dim_land_area dla 
				left outer join ref_climate.gpcp_rasters r on st_intersects(r.rast, dla.centroid) and r.rast_date = load_dt
				inner join star_schema.dim_county_boundary c on st_intersects(dla.geom, c.geom);
		else
			raise notice 'already loaded';
		end if;
		
	END;
$BODY$;

ALTER FUNCTION star_schema.fnct_load_daily_landareas()
    OWNER TO postgres;
