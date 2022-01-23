import sqlite3

dbfile = 'tipi_mm.db'

conn = sqlite3.connect(dbfile)
cursor = conn.cursor()

sql = 'SELECT * FROM toc'
cursor.execute(sql)
rows = cursor.fetchall()

csv = []
for row in rows:
    name = row[1]
    level = row[2]
    if level == 2:
        name = '\t' + name
    elif level == 3:
        name = '\t\t' + name
    elif level == 4:
        name = '\t\t\t' + name
    elif level == 5:
        name = '\t\t\t\t' + name
    csv.append(name)

with open('toc.csv', 'w' , encoding='utf-8') as writer:
    writer.write('\n'.join(csv))
