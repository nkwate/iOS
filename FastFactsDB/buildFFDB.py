#!/usr/local/bin/python
# -*- coding: utf-8 -*-

import csv
import sqlite3
import os
#add ICU, Cancer, Other Neurologic Disorders keyword?

def buildKeywordSQL(keywords):
	sql = ""
	allKeys = ["Communication", "Core Curriculum", "Ethics, Law, Policy, Health Systems", "Geriatrics", "Non-Pain Symptoms and Syndromes", "Pain – Evaluation", "Pain – Non-Opioids", "Pain – Opioids", "Pediatrics", "Prognosis", "Psychosocial and Spiritual Experience: Patients, Families, and Clinicians", "ICU", "Cancer", "Other Neurological Disorders"]
	for key in allKeys:
		if key in keywords:
			sql += "1, "
		else:
			sql += "0, "
	return sql[:-2]

os.system("rm FastFactsDB.sqlite3")
conn = sqlite3.connect('FastFactsDB.sqlite3')
c = conn.cursor()

#make table

#TODO add shortname field in csv and then add to this table making code
c.execute('''CREATE TABLE FastFactsDB
    (number integer, name text, author text, short_name text,
    communication integer,
    core_curriculum integer,
    ethics_law_policy_health_systems integer,
    geriatrics integer,
    non_pain_symptoms_syndromes integer,
    pain_evaluation integer,
    pain_non_opioids integer,
    pain_opioids integer,
    pediatrics integer,
    prognosis integer,
    psychosocial_spiritual_experience integer,
    icu integer,
    cancer integer,
    other_neurological_disorders integer)''')

with open('concatenated.csv', 'rb') as articles:
	with open('shortNames.txt', 'rb') as shortNames:
		reader = csv.reader(articles, delimiter="+")
		for (j, row) in enumerate(reader):
			keywords = reader.next()
			shortName = shortNames.readline()
            
			#for (k, keyword) in enumerate(keywords):
			#	keywords[k] = keyword.strip()
			keywords = [key.strip() for key in keywords]
            
			row[0] = str(int(row[0]))
			#for st in row:
            #st.replace("'", "")
			print row
			for i in range(1, 3):
				row[i] = '"' + row[i].strip() + '"'
            
			sql = "INSERT INTO FastFactsDB VALUES (" + ",".join(row) + ', ' + '"' + shortName + '", ' + buildKeywordSQL(keywords) + ");"
			#sql += (', ' + buildKeywordSQL(keywords))
			print sql
			c.execute(sql)

conn.commit()
conn.close()
