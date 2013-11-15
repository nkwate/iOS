import sqlite3

conn = sqlite3.connect('FastFactsDB.sqlite3')
c = conn.cursor()

with open('shortNames.txt', 'rb') as shortNames:
	with open('longNames.txt', 'rb') as longNames:
		#first copy long names to short names, then update the ones that need it
		c.execute('update FastFactsDB set short_name=name')
	
		for shortName in shortNames:
			shortName = shortName.replace("'", "''").rstrip()
			longName = longNames.readline().replace("'", "''").rstrip()
			
			sql = "UPDATE FastFactsDB SET short_name='" + shortName + "' WHERE name='" + longName + "';"
			print sql
			
			print "SELECT * FROM FastFactsDB WHERE name='" + longName + "';"
			c.execute("SELECT * FROM FastFactsDB WHERE name='" + longName + "';")
			c.fetchone()
			
			c.execute(sql)
		
		
c.execute('SELECT * FROM FastFactsDB')
print c.fetchone()

conn.commit()
conn.close()
		
