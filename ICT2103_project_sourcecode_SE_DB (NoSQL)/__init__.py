from flask import Flask, request, jsonify, render_template, json, redirect
from flask_mongoengine import MongoEngine
from datetime import datetime
 
app = Flask(__name__)
app.config['MONGODB_SETTINGS'] = {
    'db': 'project2103',
    'host': 'localhost',
    'port': 27017
}
db = MongoEngine()
db.init_app(app)
  
class Vaccination(db.Document):
    date = db.StringField()
    people_vaccinated = db.StringField()
    people_fully_vaccinated = db.StringField()
    total_boosters = db.StringField()
    pub_date = db.DateTimeField(datetime.now)
     
@app.route('/')
def query_records():
    data = Vaccination.objects.all()
    return render_template('useradmin.html', data = data)
  
@app.route('/updateemployee', methods=['POST'])
def updateemployee():
    pk = request.form['pk']
    namepost = request.form['name']
    value = request.form['value']
    employee_rs = Vaccination.objects(id=pk).first()
    if not employee_rs:
        return json.dumps({'error':'data not found'})
    else:
        if namepost == 'date':
            employee_rs.update(date=value)
        elif namepost == 'people_vaccinated':
            employee_rs.update(people_vaccinated=value)
        elif namepost == 'people_fully_vaccinated':
            employee_rs.update(people_fully_vaccinated=value)
        elif namepost == 'total_boosters':
            employee_rs.update(total_boosters=value)
    return json.dumps({'status':'OK'})
     
@app.route('/add', methods=['GET', 'POST'])
def create_record():
    date = request.form['date']
    people_vaccinated = request.form['people_vaccinated']
    people_fully_vaccinated = request.form['people_fully_vaccinated']
    vaccinationsave = Vaccination(date=date, people_vaccinated=people_vaccinated, people_fully_vaccinated=people_fully_vaccinated)
    vaccinationsave.save()
    return redirect('/')
 
@app.route('/delete/<string:getid>', methods = ['POST','GET'])
def delete_employee(getid):
    print(getid)
    employeers = Vaccination.objects(id=getid).first()
    if not employeers:
        return jsonify({'error': 'data not found'})
    else:
        employeers.delete() 
    return redirect('/')
     
if __name__ == '__main__':
    app.run(debug=True)