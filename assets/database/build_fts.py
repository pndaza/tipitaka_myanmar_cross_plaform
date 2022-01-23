import os
import sqlite3
import re

def removeHtmlTag(raw_html):
    regex_html_tags = re.compile('<[^>]*>')
    plain_text = re.sub(regex_html_tags, '', raw_html)
    return plain_text

def removePuntutations(plain_text):
    # remove puntutaions inside word
    # single quote , double quote, question mark etc
    regex_puntutations = re.compile('["\'?]')
    plain_text = re.sub(regex_puntutations, '', plain_text)
    return plain_text


words = {}

dbfile = 'tipitaka_pali.db'

conn = sqlite3.connect(dbfile)
cursor = conn.cursor()

print('creating fts table')
cursor.execute('CREATE VIRTUAL TABLE IF NOT EXISTS fts_pages USING FTS4(id, bookid, page, content, paranum)')
print('created fts table')
print('inserting data to fts table')
cursor.execute('SELECT * FROM pages')
rows = cursor.fetchall()

for row in rows:
    id = row[0]
    bookid = row[1]
    page = row[2]
    content = row[3]
    paranum = row[4]

    plain_content = removeHtmlTag(content)
    plain_content = removePuntutations(plain_content)
    wordlist = content.split()

    cursor.execute(f"insert into fts_pages values ({id},'{bookid}',{page}, '{plain_content}', '{paranum}')")

conn.commit()
conn.close()
print('done inserting')
