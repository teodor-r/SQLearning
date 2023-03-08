create function getOneMatch(teamA character varying(255), "teamB" character varying(255), "tStart" timestamp,
						   OUT "idMatch" integer,OUT "NameBk" character varying(255), 
						   OUT "Address" character varying(255),
						   OUT "StartT" character varying(255),
						   OUT "koefW" double precision,
						   OUT "koefL" double precision) RETURNS SETOF record
AS $$ 
	select "Match"."idMatch" , "Match"."NameBk","Match"."Address", "Info"."StartT", 
		"MarketWL"."koefW", "MarketWL"."koefL"
	from "Match"
	inner join "MarketWL"
		on "Match"."idMatch" = "MarketWL"."idMatch"
	inner join "Info"
		on "Match"."idMatch" = "Info"."idMatch"
	where "Match"."teamA" = $1 and "Match"."teamB" = $2 and "Info"."StartT" = $3
		order by "MarketWL"."koefW"
$$ LANGUAGE SQL;