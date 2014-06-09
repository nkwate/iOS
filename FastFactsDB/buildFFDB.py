#!/usr/local/bin/python
# -*- coding: utf-8 -*-

import csv
import sqlite3
import os

def buildKeywordSQL(keywords):
	sql = ""
	allKeys = ["Pain (all)", "Opioids Basic", "Opioids Advanced", "Non-Pain Symptoms", "Misc Syndromes", "Communication - Basic", "Communication - Advanced", "Nutrition/Hydration", "Ethics", "Hospice", "Prognosis", "Misc Interventions", "Culture/Spiritual/Grief", "Clinician Self Care", "Palliative Care Practice", "Special Conditions"]
        print keywords
        for key in allKeys:
            print key
            if key in keywords:
                sql += "1, "
            else:
                sql += "0, "
            print sql
        return sql[:-2]

os.system("rm FastFactsDB.sqlite3")
conn = sqlite3.connect('FastFactsDB.sqlite3')
c = conn.cursor()

#make table

#TODO add shortname field in csv and then add to this table making code
c.execute('''CREATE TABLE FastFactsDB
    (number integer, name text, author text, short_name text, article_body text,
    pain integer,
    opioids_basic integer,
    opioids_advanced integer,
    non_pain_symptoms integer,
    misc_syndromes integer,
    communication_basic integer,
    communication_advanced integer,
    nutrition_hydration integer,
    ethics integer,
    hospice integer,
    prognosiS integer,
    misc_interventions integer,
    cultural_spiritual_grief integer,
    clinician_self_care integer,
    palliative_care_practice integer,
    special_conditions integer)''')

with open('concatenated.csv', 'rU') as articles:
    with open('longNames.txt', 'rb') as shortNames:
        with open('articleText.txt', 'rb') as articleBodies:
            reader = csv.reader(articles, delimiter="+")
            for (j, row) in enumerate(reader):
                keywords = reader.next()
                shortName = shortNames.readline()
                articleBody = articleBodies.readline()
                
                #for (k, keyword) in enumerate(keywords):
                #	keywords[k] = keyword.strip()
                keywords = [key.strip() for key in keywords]
                keywords[-1] = keywords[-1].replace(",","")
                print keywords
                
                row[0] = str(int(row[0]))
                #for st in row:
                #st.replace("'", "")
                print row
                for i in range(1, 3):
                    row[i] = '"' + row[i].strip() + '"'
                    row[2] = row[2].replace(",,,,,","")

                
                sql = "INSERT INTO FastFactsDB VALUES (" + ",".join(row) + ', ' + '"' + shortName + '", ' + '"' + articleBody + '", ' + buildKeywordSQL(keywords) + ");"
                #sql += (', ' + buildKeywordSQL(keywords))
                print sql
                c.execute(sql)

conn.commit()
conn.close()
