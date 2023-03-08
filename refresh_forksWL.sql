CREATE FUNCTION refresh_forksWL() RETURNS VOID
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
			g2."koefL" AS "koefL"
			FROM getonematch(mtch."teamA",mtch."teamB", mtch."StartT") AS g1
			INNER JOIN getonematch(mtch."teamA",mtch."teamB", mtch."StartT") AS g2
			ON g1."idMatch" != g2."idMatch"
			WHERE (1/(g1."koefW") + 1/(g2."koefL")) < 1 
		LOOP
			INSERT INTO "ForkWL" ("teamA", "bookA", "AddressA",
								 "teamB", "bookB", "AddressB", "Percent")
				VALUES(mtch."teamA",mtch_nq."bookA",mtch_nq."AddressA",
					   mtch."teamB",mtch_nq."bookB",mtch_nq."AddressB",
					  100 - 100*(1/(mtch_nq."koefW") + 1/(mtch_nq."koefL")))
				ON CONFLICT  ON CONSTRAINT "uniqueFork"
				DO UPDATE SET "Percent" = 100 - 100*(1/(mtch_nq."koefW") + 1/(mtch_nq."koefL"));
		END LOOP M2;
	END LOOP;
END;
$$ LANGUAGE plpgsql;