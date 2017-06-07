# -*- coding: UTF-8 -*-
import os, json, time
from datetime import datetime
from bs4 import BeautifulSoup
from connect_to_mongo import *
from connect_to_web import *

# python3 -c "from crawler import *; get_abc_anunces('haiti')"

def get_abc_anunces(term):
    pagenum = 0
    
    while True:
        pagenum += 1
        url = 'http://www.abc.es/hemeroteca/'+term+'/pagina-'+str(pagenum)
        page_request = parse_response(url)
        soup = BeautifulSoup(page_request['response'],'html.parser')
        try:
            for new in soup.select('#results-content li'):
                item = {}
                item['term'] = term
                item['title'] = new.select('h2')[0].get_text().replace('\n','').replace('\t','').replace('  ',' ')
                date = new.select('.date')[0].get_text().replace(' ','')
                item['date'] = datetime.strptime(date,"%d/%m/%Y%H:%M:%S")
                print(item)
                insert_one_document('news', item)
        except:
            print('Error')
            break


# python3 -c "from crawler import *; make_totals()"

def make_totals():
    i = 0
    year = 2000
    siria = 0
    siria_t = 0
    haiti = 0
    haiti_t = 0
    for noticia in get_many_documents('news', {}, 0, 0, 'date'):

        i += 1
        if noticia['term'] == 'siria': siria += 1
        if 'siria' in noticia['title'].lower(): siria_t +=1
        if 'hait' in noticia['title'].lower(): haiti_t +=1
        if noticia['term'] == 'haiti': haiti += 1


        if int(noticia['date'].strftime("%Y")) > year:

            siria_in = get_many_documents('inversion', {'term': 'siria', 'year': int(noticia['date'].strftime("%Y"))}, 0, 0, 'date')
            siria_i = (siria_in[0]['amount'])

            haiti_in = get_many_documents('inversion', {'term': 'haiti', 'year': int(noticia['date'].strftime("%Y"))}, 0, 0, 'date')
            haiti_i = (haiti_in[0]['amount'])

            doc = {}
            doc['date'] = noticia['date'].strftime("%Y") + '-01-01'
            doc['siria'] = siria
            doc['siria_t'] = siria_t
            doc['siria_i'] = siria_i
            doc['haiti'] = haiti
            doc['haiti_t'] = haiti_t
            doc['haiti_i'] = haiti_i
            doc['total'] = i

            print(doc)
            insert_one_document('totals', doc)

            # reset
            year = int(noticia['date'].strftime("%Y"))
            siria = 0
            siria_t = 0
            haiti = 0
            i = 0
        


# export to csv
# mongoexport -h localhost:27017 -d callofdata -c totals -o ~/git/call-of-data_2017/web/data.csv --csv -f date,siria,siria_i,siria_t,haiti,haiti_i,haiti_t,total