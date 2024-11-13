-- FUNCTION: star_schema.fnct_color_classify(numeric, numeric, numeric)

DROP FUNCTION IF EXISTS star_schema.fnct_color_classify(numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION star_schema.fnct_color_classify(
	avg_val numeric,
	std_val numeric,
	val numeric)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	-- Author - Scott Newby
	-- Date - 2024.10.01
	-- State - POC Code
	-- Description -
	-- meant to classify an external dataset based on avg, stddev, and value
	-- used in color classifying precipitation values 
	BEGIN
		
		IF val <= (avg_val - 1 * std_val) THEN
			RETURN 'Very Low';
	    ELSIF val > (avg_val - 1 * std_val) AND val <= (avg_val - 0.25 * std_val) THEN
	        RETURN 'Low';
	    ELSIF val > (avg_val - 0.25 * std_val) AND val <= avg_val THEN
	        RETURN 'Below Average';
	    ELSIF val > avg_val AND val <= (avg_val + 0.25 * std_val) THEN
	        RETURN 'Above Average';
	    ELSIF val > (avg_val + 0.25 * std_val) AND val <= (avg_val + 1 * std_val) THEN
	        RETURN 'High';
	    ELSE
	        RETURN 'Very High';
	    END IF;
		
	END;
$BODY$;

ALTER FUNCTION star_schema.fnct_color_classify(numeric, numeric, numeric)
    OWNER TO postgres;
