DROP TABLE IF EXISTS "Clients_Sports";
DROP TABLE IF EXISTS "Queries_CL_SP";

SELECT "Clients"."idVK", "Sport"."NameSp" INTO  "Clients_Sports" FROM "Clients"
CROSS JOIN "Sport";

SELECT DISTINCT "idVK", "Sports" INTO "Queries_CL_SP" FROM "Queries";

DELETE FROM "Clients_Sports"
WHERE "Clients_Sports"."idVK" in (SELECT "idVK" FROM "Queries_CL_SP") AND
      "Clients_Sports"."NameSp" in (SELECT "Sports" FROM "Queries_CL_SP")