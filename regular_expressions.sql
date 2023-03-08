
select "idVK", count(1) from (
select *, regexp_matches("Clients"."idVK",'([0-9])','g') from "Clients" ) as t
group by "idVK"


create function handle_sports_string(sports character varying(255)) RETURNS character varying(255) 
AS $$ 
DECLARE
	alpha character varying(255);	 
	result_ character varying(255);
	result_final character varying(255);
	result_alpha_temp character varying(255);
	result_beta character varying(255);
	trecker integer;
	temps text[];
	tempr text;
	
BEGIN
	alpha = '1X|Pari|BetBoom|Melbet|Leon|Winline|LigaStavok|Maraphon|FonBet|Baltbet';
	result_ = '';
	result_alpha_temp= '';
	result_final = '';
	trecker = 1;
	for temps in select regexp_matches(sports,alpha,'g')
		loop
			if substring(CAST ( temps[1] AS character varying(255)) similar result_alpha_temp escape '#') ISNULL then
				result_ = concat_ws(',',result_, CAST ( temps[1] AS character varying(255)));
				result_alpha_temp = regexp_replace(result_, ',', '|', 'g');
				raise notice 'Value: %', result_;
				raise notice 'Value_alpha: %', result_alpha_temp;
				
			end if;
		end loop;
	temps =   regexp_split_to_array(alpha,'\|');
	FOREACH tempr in ARRAY temps
		loop
			raise notice 'Book: %', tempr;
			if substring(CAST ( tempr AS character varying(255)) similar result_alpha_temp escape '#') ISNULL then
				result_final = concat_ws(',',result_final, CAST ( tempr AS character varying(255)));
			end if;
		end loop;
	
	
	return substring(result_final from 2);
END;
$$ LANGUAGE plpgsql;

select handle_sports_string('1X1X1XPariBetBoomMaraphon')
select handle_sports_string('1X;1X;Pari;FonBet;LigaStavok')