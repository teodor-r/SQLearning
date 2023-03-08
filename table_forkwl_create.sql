CREATE TABLE IF NOT EXISTS public."ForkWL"
(
    "teamA" character varying(255) COLLATE pg_catalog."default",
    "bookA" character varying(255) COLLATE pg_catalog."default",
    "AddressA" character varying(255) COLLATE pg_catalog."default",
    "teamB" character varying(255) COLLATE pg_catalog."default",
    "bookB" character varying(255) COLLATE pg_catalog."default",
    "AddressB" character varying(255) COLLATE pg_catalog."default",
    "Percent" double precision,
	CONSTRAINT "uniqueFork" UNIQUE ("AddressA","AddressB")
)