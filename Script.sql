CREATE TABLE "Sport"(
    "NameSp" VARCHAR(255) NOT NULL PRIMARY KEY
);

CREATE TABLE "Bookmakers"(
    "NameBk" VARCHAR(255) NOT NULL PRIMARY KEY ,
    "Address" VARCHAR(255) NOT NULL,
    "Mirror" VARCHAR(255) NOT NULL,
    "isActive" BOOLEAN NOT NULL
);

CREATE TABLE "Pairs"(
    "NameSp" VARCHAR(255) NOT NULL,
    "NameBk" VARCHAR(255) NOT NULL,
    "isActive" BOOLEAN NOT NULL,
    UNIQUE ("NameSp", "NameBk"),
    PRIMARY KEY ("NameSp","NameBk"),
    FOREIGN KEY ("NameBk") REFERENCES "Bookmakers"("NameBk"),
    FOREIGN KEY ("NameSp") REFERENCES "Sport"("NameSp")
);

CREATE TABLE "League"(
    "NameBk" VARCHAR(255) NOT NULL,
    "NameLg" VARCHAR(255) NOT NULL,
    "NameSp" VARCHAR(255) NOT NULL,
    UNIQUE ("NameBk", "NameLg"),
    PRIMARY KEY ("NameBk","NameLg"),
    FOREIGN KEY ("NameSp") REFERENCES "Sport"("NameSp"),
    FOREIGN KEY ("NameBk") REFERENCES "Bookmakers"("NameBk")
);

CREATE TABLE "Team"(
    "NameSp" VARCHAR(255) NOT NULL,
    "Long" VARCHAR(255) NOT NULL,
    "Short" VARCHAR(255) NOT NULL,
    UNIQUE ("NameSp", "Long"),
    PRIMARY KEY ("NameSp","Long"),
    FOREIGN KEY ("NameSp") REFERENCES "Sport"("NameSp")
);

CREATE TABLE "Match"(
    "idMatch" INTEGER NOT NULL PRIMARY KEY,
    "teamA" VARCHAR(255) NOT NULL,
    "teamB" VARCHAR(255) NOT NULL,
    "NameLg" VARCHAR(255) NOT NULL,
    "NameBk" VARCHAR(255) NOT NULL,
    "NameSp" VARCHAR(255) NOT NULL,
    FOREIGN KEY ("NameSp", "teamA") REFERENCES "Team",
    FOREIGN KEY ("NameSp", "teamB") REFERENCES "Team",
    FOREIGN KEY ("NameBk", "NameLg") REFERENCES "League",
    FOREIGN KEY ("NameBk") REFERENCES "Bookmakers"("NameBk")
);

CREATE TABLE "Clients"(
    "idVK" VARCHAR(255) NOT NULL PRIMARY KEY ,
    "idTG" VARCHAR(255) NOT NULL,
    "ExpiredDate" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE "Queries"(
    "id" INTEGER NOT NULL PRIMARY KEY,
    "idVK" VARCHAR(255) NOT NULL,
    "Bookmakers" VARCHAR(255) NOT NULL,
    "Sports" VARCHAR(255) NOT NULL,
    "Status" BOOLEAN NOT NULL,
    "Tick" DOUBLE PRECISION NOT NULL,
    FOREIGN KEY ("idVK") REFERENCES "Clients"("idVK")
);


CREATE TABLE "Info"(
    "idMatch" INTEGER NOT NULL PRIMARY KEY ,
    "StartT" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "StopT" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "Place" VARCHAR(255) NOT NULL,
    FOREIGN KEY ("idMatch") REFERENCES "Match"("idMatch")
);

CREATE TABLE "MarketWL"(
    "idMatch" INTEGER NOT NULL PRIMARY KEY,
    "koefW" DOUBLE PRECISION NOT NULL,
    "koefL" DOUBLE PRECISION NOT NULL,
    FOREIGN KEY ("idMatch") REFERENCES "Match"("idMatch")
);

CREATE TABLE "MarketWLD"(
    "idMatch" INTEGER NOT NULL PRIMARY KEY ,
    "koefW" DOUBLE PRECISION NOT NULL,
    "koefL" DOUBLE PRECISION NOT NULL,
    "koefD" DOUBLE PRECISION NOT NULL,
    FOREIGN KEY ("idMatch") REFERENCES "Match"("idMatch")
);

CREATE TABLE "MarketWLM"(
    "idMatch" INTEGER NOT NULL,
    "map" INTEGER NOT NULL,
    "koefW" DOUBLE PRECISION NOT NULL,
    "koefL" DOUBLE PRECISION NOT NULL,
    UNIQUE("idMatch", "map"),
    PRIMARY KEY ("idMatch","map"),
    FOREIGN KEY ("idMatch") REFERENCES "Match"("idMatch")
);

CREATE TABLE "MatchMarketsDOTA"(
    "idMatch" INTEGER NOT NULL PRIMARY KEY ,
    "WL" BOOLEAN NOT NULL,
    "WLD" BOOLEAN NOT NULL,
    "FirstBlood" BOOLEAN NOT NULL,
    "WLM" BOOLEAN NOT NULL,
    FOREIGN KEY ("idMatch") REFERENCES "Match"("idMatch")
);

CREATE TABLE "MatchMarketCSGO"(
    "idMatch" INTEGER NOT NULL PRIMARY KEY ,
    "WL" BOOLEAN NOT NULL,
    "WLD" BOOLEAN NOT NULL,
    "WLM" BOOLEAN NOT NULL,
    "FirstRound" BOOLEAN NOT NULL,
    FOREIGN KEY ("idMatch") REFERENCES "Match"("idMatch")
);

CREATE TABLE "MarketFB"(
    "idMatch" INTEGER NOT NULL,
    "map" INTEGER NOT NULL,
    "koefW" DOUBLE PRECISION NOT NULL,
    "koefL" DOUBLE PRECISION NOT NULL,
    UNIQUE("idMatch", "map"),
    PRIMARY KEY ("idMatch","map"),
    FOREIGN KEY ("idMatch") REFERENCES "MatchMarketsDOTA"("idMatch")
);


CREATE TABLE "MarketFR"(
    "idMatch" INTEGER NOT NULL,
    "map" INTEGER NOT NULL,
    "koefW" DOUBLE PRECISION NOT NULL,
    "koefL" DOUBLE PRECISION NOT NULL,
    UNIQUE ("idMatch", "map"),
    PRIMARY KEY ("idMatch","map"),
    FOREIGN KEY ("idMatch") REFERENCES "MatchMarketCSGO"("idMatch")
);

