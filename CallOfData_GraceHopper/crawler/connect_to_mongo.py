# -*- coding: UTF-8 -*-
import pymongo, time
from termcolor import colored
from bson.objectid import ObjectId
from pymongo import MongoClient
from datetime import datetime

mongo_uri = 'mongodb://localhost:27017/'
# mongo_uri = 'mongodb://etaira:lealasinstruccionesdeestemedicamento@ns306409.systempix.net:27017/zaratrusta'
database_name = 'callofdata'


""" 

INSERT_ONE DOCUMENT

"""

def insert_one_document(collection, doc):
    try:
        connection = MongoClient(mongo_uri)
        db = connection[database_name]
        coll = db[collection]

        coll.insert_one(doc)
        return True

    except Exception as e:
        print (time.strftime("%Y-%m-%d %H:%M:%S"),colored('Error inserting one document:','red'), e)
        return False


















""" 

UPDATE ONE DOCUMENT

"""

def update_one_document(collection, doc):
    try:
        connection = MongoClient(mongo_uri)
        db = connection[database_name]
        coll = db[collection]

        coll.update({'_id': doc['_id']}, doc, True)
        return True

    except Exception as e:
        print (time.strftime("%Y-%m-%d %H:%M:%S"),colored('Error updating one document:','red'), e)
        return False


"""

UPDATE ONE DOCUMENT FIELD ($SET)

"""
def update_document_field_mdb(collection, doc_id, field_name, field_value):
    try:
        connection = MongoClient(mongo_uri)
        db = connection[database_name]
        coll = db[collection]

        coll.update({'_id': doc_id}, {"$set": {field_name: field_value}}, upsert=False)
        return True
        
    except Exception as e:
        print (time.strftime("%Y-%m-%d %H:%M:%S"),colored('Error updating one document field:','red'), e)
        return False




























""" 

GET DOC BY ID

"""
def get_one_document_id(collection, doc_id, ObjectId_format = False):
    try:
        connection = MongoClient(mongo_uri)
        db = connection[database_name]
        coll = db[collection]

        if ObjectId_format:
            doc = coll.find_one({'_id': ObjectId(doc_id)})
        else:
            doc = coll.find_one({'_id': doc_id})

        return doc

    except Exception as e:
        print (time.strftime("%Y-%m-%d %H:%M:%S"),colored('Error getting one document by ID:','red'), e)
        return False



"""

GET ALL DOCS

"""

def get_many_documents(collection, filter = {}, query_limit = 0, skip = 0, orderby = False, order = 1): 
    batch_length = 50
    try:
        connection = MongoClient(mongo_uri)
        db = connection[database_name]
        coll = db[collection]

        if query_limit > 0:
            if orderby:
                if order == 1:
                    cursor = coll.find(filter,{'timeout': False}).sort([(orderby,pymongo.ASCENDING)]).skip(skip).limit(query_limit)
                else:
                    cursor = coll.find(filter,{'timeout': False}).sort([(orderby,pymongo.DESCENDING)]).skip(skip).limit(query_limit)
            else:
                cursor = coll.find(filter,{'timeout': False}).skip(skip).limit(query_limit)
        else:
            if orderby:
                if order == 1:
                    cursor = coll.find(filter,{'timeout': False}).sort([(orderby,pymongo.ASCENDING)]).batch_size(batch_length)
                else:
                    cursor = coll.find(filter,{'timeout': False}).sort([(orderby,pymongo.DESCENDING)]).batch_size(batch_length)
            else:
                cursor = coll.find(filter,{'timeout': False}).batch_size(batch_length)

        return cursor

    except Exception as e:
        print (time.strftime("%Y-%m-%d %H:%M:%S"),colored('Error getting many documents:','red'), e)
        return False