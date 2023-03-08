create function refresh_forksWL() RETURNS VOID
AS $$ 
DECLARE
    mtch RECORD;
	mtch_nq RECORD;
BEGIN
	RAISE NOTICE 'Gettin unique match...';
	for mtch in 
		select  distinct on ("global_idMatch") "Match"."teamA", 
		"Match"."teamB", "Info"."StartT"
		from "Match"
		inner join "Info"
		on "Match"."idMatch" = "Info"."idMatch"
	loop
		<<M2>>
		for mtch_nq in 
			select g1."NameBk" as "bookA", g1."Address" as "AddressA",
			g2."NameBk" as "bookB",  g2."Address" as "AddressB"
			from getonematch(mtch."teamA",mtch."teamB", mtch."StartT") as g1
			inner join getonematch(mtch."teamA",mtch."teamB", mtch."StartT") as g2
			on g1."idMatch" != g2."idMatch"
			where (1/(g1."koefW") + 1/(g2."koefL")) < 1 
		loop
			INSERT INTO "ForkWL" ("teamA", "bookA", "AddressA",
								 "teamB", "bookB", "AddressB", "Percent")
				VALUES(mtch."teamA",mtch_nq."bookA",mtch_nq."AddressA",
					   mtch."teamB",mtch_nq."bookB",mtch_nq."AddressB",
					  '5') ;
				--ON CONFLICT ("teamA", "bookA","teamB", "bookB" ) 
				--DO NOTHING;
		end loop M2;
	end loop;
end;
$$ LANGUAGE plpgsql;

