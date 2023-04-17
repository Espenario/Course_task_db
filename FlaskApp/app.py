from flask import Flask, render_template, json, request, session, redirect
import psycopg2
import os
#from werkzeug.security import generate_password_hash, check_password

app = Flask(__name__)
app.secret_key = 'Everyone should enjoy TFL)'

@app.route("/")
def main():
    return render_template('index.html')

@app.route('/signup')
def display_signup():
    return render_template('signup.html')

def get_db_connection():
    conn = psycopg2.connect(host='localhost',
                            database='space_agency',
                            user=os.environ['DB_USERNAME'],
                            password=os.environ['DB_PASSWORD'])
    return conn

@app.route('/signin')
def display_signin():
    return render_template('signin.html')

@app.route('/api/validateLogin', methods=['POST'])
def validateLogin():
    _username = request.form['inputEmail']
    _password = request.form['inputPassword']

    conn = get_db_connection()
    cursor = conn.cursor()
    #_hashed_password = generate_password_hash(_password)
    #print(_username, '___________________')
    cursor.callproc('sp_validateLogin', (_username,))
    data = cursor.fetchall()
    #return_message = str(data[0])
    #print(str(data[0][3]), data[0][0], '__________________')
    if len(data) > 0:
        if (str(data[0][3]) == _password):
            session['user'] = data[0][0]
            return redirect('/userHome')
        else:
            return render_template('error.html',error = 'Wrong Email address or Password')
    else:
            return render_template('error.html',error = 'Wrong Email address or Password')
    
@app.route('/userHome')
def userHome():
    if session.get('user'):
        return render_template('userhome.html')
    else:
        return render_template('error.html',error = 'Unauthorized Access')
    
@app.route('/showSearch')
def showSearch():
    return render_template('search.html')
    
@app.route('/showAddItem')
def showAddItemMenu():
    return render_template('additemmenu.html')

@app.route('/showAddComp')
def showAddform():
    return render_template('addcomp.html')

@app.route('/addComp',methods=['POST'])
def addWish():
    try:
        if session.get('user'):
            _name = request.form['inputName']
            _date = request.form['inputDate']
            _country = request.form['inputCountry']
            _revenue = request.form['inputRevenue']
            _type = request.form['inputType']
            conn = get_db_connection()
            cursor = conn.cursor()
            cursor.callproc('sp_addCompany',(_name, _date, _country, _revenue, _type,))
            data = cursor.fetchall()[0][0]
            if len(data) is 0:
                conn.commit()
                return redirect('/userHome')
            else:
                return render_template('error.html',error = 'An error occurred!')
        else:
            return render_template('error.html',error = 'Unauthorized Access')
    except Exception as e:
        return render_template('error.html',error = str(e))
    finally:
        cursor.close()
        conn.close()

@app.route('/api/signup',methods=['POST'])
def perform_signup():
    #try:
    _name = request.form['inputName']
    _email = request.form['inputEmail']
    _password = request.form['inputPassword']

    # validate the received values
    if _name and _email and _password:

        #print(os.environ['040403'], '+++++++++++++++++++++++++')

        conn = get_db_connection()
        cursor = conn.cursor()
        #_hashed_password = generate_password_hash(_password)
        cursor.callproc('sp_createUser', (_name, _email, _password))
        data = cursor.fetchall()
        return_message = str(data[0])      
        #conn.commit()
        if return_message.find('successfully') != -1:
            conn.commit()
            #cursor.close()
            #conn.close()
            return redirect('/')
        else:
            #cursor.close()
            #conn.close()
            #print(return_message, "+++++++++++++", return_message.find('successfully'))
            return render_template('error.html',error = 'User with this username has already exist')

    else:
        return json.dumps({'html': '<span>Enter the required fields</span>'})

    #except Exception as e:
    #    return json.dumps({'error': str(e)})
    #finally:
    #    cursor.close()
    #    conn.close()

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect('/')


if __name__ == "__main__":
    app.run()