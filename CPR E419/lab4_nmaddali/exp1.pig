--load the txt file
input_lines = LOAD 'gaz_tracts_national.txt' USING PigStorage('\t') AS (usps: chararray, geoid: chararray, pop10:int, hu10: int, aland:long, awater:int, aland_sqmi:double, awater_sqmi: double, intptlat:double, intptlong:double);

--combine columns based on state and sum
states = GROUP input_lines BY usps;
totals = FOREACH states GENERATE group, SUM(input_lines.aland) AS sum;

--order and split
ordered = ORDER totals BY sum DESC;
top = LIMIT ordered 10;

--ouput
STORE top INTO 'lab4_exp1/output';
