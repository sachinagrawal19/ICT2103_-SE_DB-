import csv
from pymongo import MongoClient

mongoClient = MongoClient() 
db = mongoClient.project2103
db.hospitalization.drop()

header = [ "date", "new_hospital_admissions"]
csvfile = open('new-covid-19-hospital-admissions.csv', 'r')
reader = csv.DictReader( csvfile )

for each in reader:
    row={}
    for field in header:
        row[field]=each[field]
        
    print (row)
    db.hospitalization.insert_one(row)


db = mongoClient.project2103
db.icu.drop()

header = [ "date", "new_icu_admissions"]
csvfile = open('new-covid-19-icu-admissions.csv', 'r')
reader = csv.DictReader( csvfile )

for each in reader:
    row={}
    for field in header:
        row[field]=each[field]
        
    print (row)
    db.icu.insert_one(row)


db = mongoClient.project2103
db.vaccination.drop()

header = [ "date", "people_vaccinated", "people_fully_vaccinated", "total_boosters"]
csvfile = open('owid-covid-data.csv', 'r')
reader = csv.DictReader( csvfile )

for each in reader:
    row={}
    for field in header:
        row[field]=each[field]
        
    print (row)
    db.vaccination.insert_one(row)


db = mongoClient.project2103
db.cases.drop()

header = [ "date", "total_cases", "new_cases", "total_deaths", "new_deaths"]
csvfile = open('owid-covid-data.csv', 'r')
reader = csv.DictReader( csvfile )

for each in reader:
    row={}
    for field in header:
        row[field]=each[field]
        
    print (row)
    db.cases.insert_one(row)