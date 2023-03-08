import psycopg2
import random
MATCH_COUNT = 5000
con = psycopg2.connect(
    database = 'postgres',
    user = 'postgres',
    password = '22eteben22',
    host = '127.0.0.1',
    port = '5432'
)

cur = con.cursor()

Books = []
Sports = []
def getBooks():
    books = open('Books.txt', 'r')
    data = books.readlines()
    for string in data:
        bk, site, mirror,isActive = string.split(';')
        Books.append(bk)
getBooks()

def getSports():
    sports = open('Sports.txt', 'r')
    data = sports.readlines()
    for string in data:
        sport = string[:-1]
        Sports.append(sport)
    print(Sports)


def generate_bookmakers():
    books = open('Books.txt', 'r')
    data = books.readlines()
    for string in data:
        print(string)
        bk, site, mirror,isActive = string.split(';')
        isActive = isActive[:-1]
        query = "INSERT INTO public.\"Bookmakers\" (\"NameBk\", \"Address\", \"Mirror\", \"isActive\") VALUES (%s, %s, %s, %s);"
        data = (bk,site ,mirror, isActive)
        res = cur.execute(query,data)
        con.commit()
    books.close()

def generate_sports():
    file = open('Sports.txt', 'r')
    lines = file.readlines()
    for sport in lines:
        query = 'INSERT INTO public.\"Sport\" (\"NameSp\") VALUES (%s);'
        data = (sport[:-1],)
        cur.execute(query, data)
        con.commit()

    file.close()

def generate_teams():
    teams = open('Teams.txt', 'r')
    sports = open('Sports.txt', 'r')
    team_list = teams.readlines()
    sport_list = sports.readlines()
    for l in team_list:
        sports_number = random.randint(4, 9)
        gen = random.sample(sport_list, sports_number)
        for sport in gen:
            long, short = l.split(';')
            query = 'INSERT INTO public.\"Team\" (\"Short\", \"Long\", \"NameSp\") VALUES (%s,%s,%s);'
            data = (short[:-1],long, sport[:-1])
            cur.execute(query,data)
            con.commit()
    teams.close()
    sports.close()

def generate_leagues():
    file = open('Leagues.txt', 'r')
    lines = file.readlines()

    for line in lines:
        books_count = random.randint(3, 8)
        books_sport = random.sample(Books, books_count)
        league, sport = line[:-1].split(';')
        for book in books_sport:
            query = 'INSERT INTO public.\"League\" (\"NameBk\", \"NameLg\" ,\"NameSp\") VALUES (%s, %s, %s)'
            data = (book, league ,sport)
            cur.execute(query,data)
            con.commit()
    file.close()

def generate_leagues_pairs():
    query = '''
    SELECT DISTINCT "NameBk", "NameSp" 
    from "League"
    order by "NameBk"
    '''
    cur.execute(query)
    for book, sport in cur.fetchall():
        query = '''
        insert into "Pairs" ("NameSp", "NameBk", "isActive") values (%s, %s, %s)
        '''
        data = (sport, book, True)
        cur.execute(query, data)
        con.commit()

    

'''
generate_bookmakers()
generate_sports()
generate_teams()
generate_leagues()
generate_leagues_pairs()
'''


def generate_date ():

    hour = random.randint(0, 23)
    minute = random.randint(0, 59)
    second = random.randint(0, 59)

    year, month, day = random.randint(2023, 2031), random.randint(1, 12), random.randint(1, 27)
    return psycopg2.Timestamp(year,month,day,hour, minute,second)

def generate_match_info():
    global MATCH_COUNT
    file = open('Place.txt', 'r')
    places = file.readlines()
    begin_time = generate_date()
    end_time = generate_date()
    place = random.choice(places)
    file.close()
    return begin_time, end_time, place
def generate_wl():
    win_prob = random.uniform(5, 95)
    lose_prob = 100 - win_prob
    return  100 / win_prob , 100 / lose_prob
def generate_wld():
    win_prob = random.uniform(5, 95)
    draw_prob = random.uniform(5, 50)
    while win_prob + draw_prob >= 90:
        win_prob /= 2
        draw_prob /= 2
    lose_prob = 100 - win_prob - draw_prob

    return  100/win_prob, 100/lose_prob, 100/draw_prob
def generate_id ():
    alpha = 'qwertyuiopasdfghjklzxcvbnm'
    alpha = alpha + alpha.upper()
    alpha = alpha + '0123456789_.-'
    length = random.randint(5, 15)
    alphalen = len(alpha)
    id = ''
    for _ in range(length):
        idx = random.randint(0, alphalen-1)
        id = id + alpha[idx]
    return id
def generate_address(address, sport, league):
    return address + "/" +  sport + "/" + league + "/" + generate_id()
def insert_query (table_name : str, data: dict):
    query = "INSERT INTO public.\""
    query = query + table_name + "\" ("
    values = "VALUES ("
    for name, value in data.items():
        query = query + "\"" + name + "\", "
        if isinstance(value, (str, bool)):
            values = values + "\'" + str(value) + "\', "
        else:
            values = values + str(value) + ", "
    query = query[:-2] + ") " + values[:-2] + ")"
    return query
id_match = 1

def generate_match_with_markets():
    query_leagues= '''
    SELECT  DISTINCT   "NameSp", "NameLg"
    FROM "League"
    ORDER BY "NameSp"
    '''
    query_sport = '''
    SELECT "Long" 
    from "Team"
    WHERE "Team"."NameSp" = %s
    '''
    cur.execute(query_leagues)
    NameSPLG = cur.fetchall()
    global_match = 1
    id_match = 1
    for NameSp, NameLg in NameSPLG:
        cur.execute(query_sport, (NameSp,))
        teams = cur.fetchall()
        matches_count = random.randint(1, 5)
        for i in range(matches_count):
            teamA, teamB = random.sample(teams, 2)
            tS, tStop, place = generate_match_info()
            query_books = '''
                SELECT  "Bookmakers"."NameBk" , "Address" 
                from  "Bookmakers"
                INNER JOIN "League"
                ON "League"."NameLg" = %s AND "League"."NameBk" = "Bookmakers"."NameBk"
                ORDER BY  "Bookmakers"."NameBk"
                '''
            cur.execute(query_books, (NameLg,))
            books = cur.fetchall()
            WL = True if random.randint(1, 3) == 3 else False
            for NameBk, address in books:
                match_address = generate_address(address, NameSp, NameLg)
                data = {"global_idMatch": global_match, "idMatch": id_match, "teamA": teamA[0], "teamB": teamB[0], "NameLg": NameLg,
                        "NameBk": NameBk, "NameSp": NameSp, "Address": match_address}
                query_for_match = insert_query("Match", data)
                cur.execute(query_for_match)
                if WL:
                    kw, kl = generate_wl()
                    data = {"idMatch": id_match, "koefW": kw, "koefL": kl}
                    cur.execute(insert_query("MarketWL", data))
                else:  # It means WLD (not WL)
                    kw, kl, kd = generate_wld()
                    data = {"idMatch": id_match, "koefW": kw, "koefL": kl, "koefD": kd}
                    cur.execute(insert_query("MarketWLD", data))
                con.commit()
                if NameSp == 'Dota2' or NameSp == 'CS:GO':
                    WLM = True if random.randint(1, 4) == 3 else False
                    FBR = True if random.randint(1, 3) == 3 else False
                    if NameSp == 'Dota2':
                        data = {"idMatch": id_match, "WL": WL, "WLD": not WL, "FirstBlood": FBR, "WLM": WLM}
                        cur.execute(insert_query("MatchMarketDOTA", data))
                    else:
                        data = {"idMatch": id_match, "WL": WL, "WLD": not WL, "FirstRound": FBR, "WLM": WLM}
                        cur.execute(insert_query("MatchMarketCSGO", data))
                    if WLM:
                        kw, kl = generate_wl()
                        for map in range(3):
                            data = {"idMatch": id_match, "map": map + 1, "koefW": kw, "koefL": kl}
                            cur.execute(insert_query("MarketWLM", data))
                    if FBR:
                        if NameSp == 'Dota2':
                            for map in range(3):
                                kw, kl = generate_wl()
                                data = {"idMatch": id_match, "map": map + 1, "koefW": kw, "koefL": kl}
                                cur.execute(insert_query("MarketFB", data))
                        else:
                            for map in range(3):
                                kw, kl = generate_wl()
                                data = {"idMatch": id_match, "map": map + 1, "koefW": kw, "koefL": kl}
                                cur.execute(insert_query("MarketFR", data))
                data = {"idMatch": id_match, "StartT": tS, "StopT": tStop, "Place": place}
                cur.execute(insert_query("Info", data))
                id_match += 1
                con.commit()
            global_match += 1

def generate_clients():
    for _ in range(1000):
        vk, tg = '@' + generate_id(), '@' + generate_id()
        date = generate_date()
        query = '''
        insert into "Clients" ("idVK","idTG", "ExpiredDate") VALUES (%s, %s,%s)
        '''
        data = (vk,tg, date)
        cur.execute(query,data)
        con.commit()

def generate_query():
    cur.execute("SELECT DISTINCT \"idVK\" FROM \"Clients\"")
    id_vk_list = cur.fetchall()
    template = '''
    INSERT INTO "Queries" ("id", "idVK", "Bookmakers", "Sports", "Status", "Tick") VALUES (%s, %s, %s, %s, %s, %s)
    '''
    general_id = 1
    cur.execute("SELECT \"NameBk\", \"NameSp\" FROM \"Match\"")
    books_and_sports = cur.fetchall()
    for id_vk in id_vk_list:
        queries_count = random.randint(0, 5)
        for queries_idx in range (queries_count):
            books_count = random.randint(2, 5)
            sports_count = random.randint(1, 5)
            books = ""
            sports = ""
            for str in  random.sample(Books, books_count):
                books+= str + ";"
            books = books[:-1]
            for str in  random.sample(Sports, sports_count):
                sports+=  str + ";"
            sports = sports[:-1]

            status = True if random.randint(1, 3) != 3 else False
            tick = abs(random.normalvariate(1, 1) * 10.0)
            query_data = (general_id, id_vk[0], books, sports, status, tick)
            cur.execute(template, query_data)
            general_id += 1

    con.commit()

getSports()

#generate_match_with_markets()
#generate_clients()
#generate_match()
generate_query()













cur.close()
cur.close()

