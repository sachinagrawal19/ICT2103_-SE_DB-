from flask import Flask, render_template, request, redirect, url_for, flash
from flask_mysqldb import MySQL

app = Flask(__name__)
app.secret_key = 'many random bytes'

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = '2103project'

mysql = MySQL(app)

@app.route('/')
def Index():
    cur = mysql.connection.cursor()
    cur.execute("SELECT  * FROM vaccination ORDER BY vaccination_date ASC")
    data = cur.fetchall()
    cur.close()
    return render_template('index.html', data=data )


@app.route('/insert', methods = ['POST'])
def insert():

    if request.method == "POST":
        flash("Data Inserted Successfully")
        vaccination_date = request.form['vaccination_date']
        vaccinated = request.form['vaccinated']
        fully_vaccinated = request.form['fully_vaccinated']
        total_boosters = request.form['total_boosters']
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO vaccination (vaccination_date, vaccinated, fully_vaccinated, total_boosters) VALUES (%s, %s, %s, %s)", (vaccination_date, vaccinated, fully_vaccinated, total_boosters))
        mysql.connection.commit()
        return redirect(url_for('Index'))


@app.route('/delete/<string:vaccination_date>', methods = ['GET'])
def delete(vaccination_date):
    flash("Record Has Been Deleted Successfully")
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM vaccination WHERE vaccination_date=%s", (vaccination_date,))
    mysql.connection.commit()
    return redirect(url_for('Index'))


@app.route('/update',methods=['POST','GET'])
def update():

    if request.method == 'POST':
        vaccination_date = request.form['vaccination_date']
        vaccinated = request.form['vaccinated']
        fully_vaccinated = request.form['fully_vaccinated']
        total_boosters = request.form['total_boosters']
        cur = mysql.connection.cursor()
        cur.execute("""
               UPDATE vaccination
               SET vaccination_date=%s, vaccinated=%s, fully_vaccinated=%s, total_boosters=%s
               WHERE vaccination_date=%s
            """, (vaccination_date, vaccinated, fully_vaccinated, total_boosters, vaccination_date))
        flash("Data Updated Successfully")
        mysql.connection.commit()
        return redirect(url_for('Index'))


if __name__ == "__main__":
    app.run(debug=True)
