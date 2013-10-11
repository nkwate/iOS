import csv
import sqlite3
import os


def buildKeywordSQL(keywords):
	sql = ""
	allKeys = ["Communication", "Core Curriculum", "Ethics, Law, Policy, Health Systems", "Geriatrics", "Non-Pain Symptoms and Syndromes", "Pain - Evaluation", "Pain - Non-Opioids", "Pain - Opioids", "Pediatrics", "Prognosis", "Psychosocial and Spiritual Experience: Patients, Families, and Clinicians"]	
	for key in allKeys:
		if key in keywords:
			sql += "1, "
		else:
			sql += "0, "
	return sql[:-2]

os.system("rm *.sqlite3")
conn = sqlite3.connect('FastFactsDB.sqlite3')
c = conn.cursor()

#make table
c.execute('''CREATE TABLE FastFactsDB
			 (number integer, name text, author text, communication text, core_curriculum integer,
    			 	ethics_law_policy_health_systems integer,
    				geriatrics integer,
    				non_pain_symptoms_syndromes integer,
    				pain_evaluation integer,
    				pain_non_opioids integer,
    				pain_opioids integer,
    				pediatrics integer,
    				prognosis integer,
    				psychosocial_spiritual_experience integer)''')

with open('concatenated.csv', 'rb') as articles:
	reader = csv.reader(articles, delimiter="+")
	for row in reader:
		keywords = reader.next()
		
		row[0] = str(int(row[0]))
		#for st in row:
			#st.replace("'", "")
		print row
		for i in range(1, 3):
			row[i] = '"' + row[i] + '"'	
		sql = "INSERT INTO FastFactsDB VALUES (" + ",".join(row) + ', ' + buildKeywordSQL(keywords) + ");"
		#sql += (', ' + buildKeywordSQL(keywords))
		print sql
		c.execute(sql)
		
conn.commit()
conn.close()		
	
