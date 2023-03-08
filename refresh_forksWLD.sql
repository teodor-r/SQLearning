CREATE FUNCTION refresh_forksWLD() RETURNS VOID
AS $$ 
DECLARE
    mtch RECORD;
	mtch_nq RECORD;
BEGIN
	RAISE NOTICE 'Gettin unique match...';
	FOR mtch IN
		SELECT  DISTINCT ON ("global_idMatch") "Match"."teamA", 
		"Match"."teamB", "Info"."StartT"
		FROM "Match"
		INNER JOIN "Info"
		ON "Match"."idMatch" = "Info"."idMatch"
	LOOP
		<<M2>>
		FOR mtch_nq IN 
			SELECT g1."NameBk" AS "bookA", g1."Address" AS "AddressA", 
			g1."koefW" AS "koefW",
			g2."NameBk" AS "bookB",  g2."Address" AS "AddressB",
			g2."koefD" AS "koefD",
			g3."NameBk" AS "bookC",  g3."Address" AS "AddressC",
			g3."koefL" AS "koefL"
			FROM getonematch_wld(mtch."teamA",mtch."teamB", mtch."StartT") AS g1
			INNER JOIN getonematch_wld(mtch."teamA",mtch."teamB", mtch."StartT") AS g2
			ON g1."idMatch" != g2."idMatch"
			INNER JOIN getonematch_wld(mtch."teamA",mtch."teamB", mtch."StartT") AS g3
			ON (g1."idMatch" != g3."idMatch" AND g2."idMatch" != g3."idMatch")
			WHERE (1/(g1."koefW") + 1/(g2."koefD") + 1/(g3."koefL")) < 1 
		LOOP
			INSERT INTO "ForkWLD" ("teamA", "bookA", "AddressA",
								   "teamB", "bookB", "AddressB",
								   "teamC", "bookC", "AddressC",
								   "Percent")
				VALUES(mtch."teamA",mtch_nq."bookA",mtch_nq."AddressA",
					   mtch."teamB",mtch_nq."bookB",mtch_nq."AddressB",
					   mtch."teamB",mtch_nq."bookC",mtch_nq."AddressC",
					  100 - 100*(1/(mtch_nq."koefW") + 1/(mtch_nq."koefD")+1/(mtch_nq."koefL") ))
				ON CONFLICT  ON CONSTRAINT "uniqueForkWLD"
				DO UPDATE SET "Percent" = 100 - 100*(1/(mtch_nq."koefW") + 1/(mtch_nq."koefD") + 1/(mtch_nq."koefL"));
		END LOOP M2;
	END LOOP;
END;
$$ LANGUAGE plpgsql;