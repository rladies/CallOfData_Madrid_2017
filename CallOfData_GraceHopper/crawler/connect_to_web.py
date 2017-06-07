# -*- coding: UTF-8 -*-
import gzip, re, json, time, os
from termcolor import colored
from unidecode import unidecode
import urllib.request
from urllib.request import Request, urlopen

""" 

WEB PARSERS

"""

def parse_response(url):
    try:
        headers=headers = {
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            'Accept-Encoding': 'gzip, deflate',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36'
        }
        
        web = Request(url, headers=headers)
        response = urlopen(web)
        
        if response.info().get('Content-Encoding') == 'gzip': pagedata = gzip.decompress(response.read())
        else: pagedata = response.read()
            
        return {'status': True, 'response': pagedata}

    except urllib.error.HTTPError as e:
        return {'status': False, 'response': e.code}
    
    except Exception as e:
        print(time.strftime("%Y-%m-%d %H:%M:%S"),'Error not defined parsing web', url, e)
        return {'status': False, 'response': 0}

def parse_response_json(url):
    try:
        web = Request(url)
        web.add_header('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36')
        web = urlopen(web).read()
        web = web.decode('utf-8')
        return {'status': True, 'response': json.loads(web)}

    except urllib.error.HTTPError as e:
        return {'status': False, 'response': e.code}

    except Exception as e:
        print(time.strftime("%Y-%m-%d %H:%M:%S"),'Error not defined parsing json web', url, e)
        return {'status': False, 'response': 0}


""" 

GET CURRENT IP

"""

# python -c "from connect_to_web import *; current_ip()"
def current_ip(printing=False):
    response = parse_response_json('https://api.ipify.org?format=json')['response']
    
    if printing:
        print(response['ip'])
    else:
        return response['ip']



""" 

SAVE FILES

"""

def save_debug_file(file_path, content):
    try:
        if not os.path.exists(os.path.dirname(file_path)):
            print(time.strftime("%Y-%m-%d %H:%M:%S"), colored('New directory:', 'green'), os.path.dirname(file_path))
            os.makedirs(os.path.dirname(file_path))
        f = open(file_path,'w')
        f.write(unidecode(content))
        f.close()
        print(time.strftime("%Y-%m-%d %H:%M:%S"), colored('New file:','green'), file_path)
    except Exception as e:
        print(time.strftime("%Y-%m-%d %H:%M:%S"), colored('Error writing file', 'red'), file_path, e)