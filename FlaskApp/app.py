from flask import Flask, render_template, json, request, session, redirect, jsonify, flash
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
            flash('Login Successful') 
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
def showAddformComp():
    return render_template('addcomp.html')

@app.route('/addComp',methods=['POST'])
def addComp():
    try:
        if session.get('user'):
            _name = request.form['inputName']
            _date = request.form['inputDate']
            _country = request.form['inputCountry']
            _revenue = request.form['inputRevenue']
            _type = request.form['inputType']
            conn = get_db_connection()
            cursor = conn.cursor()
            if len(_date) == 0:
                cursor.callproc('sp_addCompany',(_name, _country, _revenue, _type,))
            else:
                cursor.callproc('sp_addCompany',(_name, _country, _revenue, _type, _date,))
            data = cursor.fetchall()[0][0]
            if len(data) is 0:
                conn.commit()
                flash('Successful') 
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

@app.route('/showAddLaunch')
def showAddformLaunch():
    return render_template('addlaunch.html')

@app.route('/addLaunch',methods=['POST'])
def addLaunch():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        if session.get('user'):   
            _date = request.form['inputDate']
            _rocket = request.form['inputRocket']
            _payload = request.form['inputPayload']
            _company = request.form['inputCompany']
            # conn = get_db_connection()
            # cursor = conn.cursor()
            if len(_date) == 0:
                cursor.callproc('sp_addLaunch',(_rocket, _payload, _company,))
            else:
                cursor.callproc('sp_addLaunch',(_rocket, _payload, _company, _date,))
            data = cursor.fetchall()[0][0]
            if len(data) is 0:
                conn.commit()
                flash('Successful') 
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

@app.route('/showAddSpacecraft')
def showAddformSpacecraft():
    return render_template('addspacecraft.html')

@app.route('/addSpacecraft',methods=['POST'])
def addSpacecraft():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        if session.get('user'):
            _height = request.form['inputHeight']
            if not _height:
                _height = '1'
            _width = request.form['inputWidth'] 
            if not _width:
                _width = '1'
            _length = request.form['inputLength'] 
            if not _length:
                _length = '1'
            _con_cost = request.form['inputConstrcost']
            if not _con_cost:
                _con_cost = '0'
            _name = request.form['inputName']
            _des_cost = request.form['inputDesigncost']
            if not _des_cost:
                _des_cost = '0'
            _company = request.form['inputCompany']
            _site = request.form['inputSite']
            _engine = request.form['inputEngine']
            # conn = get_db_connection()
            # cursor = conn.cursor()
            cursor.callproc('sp_addSpacecraft',(_height, _width, _length, _con_cost, _name, _des_cost, _company, _site, _engine,))
            data = cursor.fetchall()[0][0]
            if len(data) is 0:
                conn.commit()
                flash('Successful') 
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

@app.route('/showAddNeObject')
def showAddformNeObject():
    return render_template('addneobject.html')

@app.route('/addNeObject',methods=['POST'])
def addNeObject():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        if session.get('user'):
            _spcr_name = request.form['inputName']
            _mission = request.form['inputMission'] 
            _orbit = request.form['inputOrbit'] 
            _altitude = request.form['inputAltitude']
            if not _altitude:
                _altitude = '1000'
            _speed = request.form['inputSpeed']
            if not _speed:
                _speed = '12.0'
            # conn = get_db_connection()
            # cursor = conn.cursor()
            cursor.callproc('sp_addNeObject',(_spcr_name, _mission, _orbit, _altitude, _speed,))
            data = cursor.fetchall()[0][0]
            if len(data) is 0:
                conn.commit()
                flash('Successful') 
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

@app.route('/showAddTransport')
def showAddformTransport():
    return render_template('addtransport.html')

@app.route('/addTransport',methods=['POST'])
def addTransport():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        if session.get('user'):
            _spcr_name = request.form['inputName']
            _cargo_volume = request.form['inputCargoVolume'] 
            if not _cargo_volume:
                _cargo_volume = '1'
            _cur_dest = request.form['inputDestination'] 
            _cargo_type = request.form['inputCargoType']
            _speed = request.form['inputSpeed']
            if not _speed:
                _speed = '0.0'
            # if not _altitude:
            #     _altitude = '1000'
            # _speed = request.form['inputSpeed']
            # if not _speed:
            #     _speed = '12.0'
            # conn = get_db_connection()
            # cursor = conn.cursor()
            cursor.callproc('sp_addTransport',(_spcr_name, _cargo_volume, _speed,  _cur_dest, _cargo_type,))
            data = cursor.fetchall()[0][0]
            if len(data) is 0:
                conn.commit()
                flash('Successful') 
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

@app.route('/showAddMining')
def showAddformMining():
    return render_template('addmining.html')

@app.route('/addMining',methods=['POST'])
def addMining():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        if session.get('user'):
            _spcr_name = request.form['inputName']
            _pr_rate = request.form['inputPrRate'] 
            _material = request.form['inputMaterial'] 
            _start_service = request.form['inputStartService']
            _end_service = request.form['inputEndService']
            cursor.callproc('sp_addMining',(_spcr_name, _pr_rate, _material,  _start_service, _end_service,))
            data = cursor.fetchall()[0][0]
            if len(data) is 0:
                conn.commit()
                flash('Successful') 
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

@app.route('/showAddResearch')
def showAddformResearch():
    return render_template('addresearch.html')

@app.route('/addResearch',methods=['POST'])
def addResearch():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        if session.get('user'):
            _spcr_name = request.form['inputName']
            _obj_study = request.form['InputObjStudy'] 
            _instruments = request.form['inputInstruments'] 
            _start_service = request.form['inputStartService']
            cursor.callproc('sp_addResearch',(_spcr_name, _obj_study, _instruments,  _start_service,))
            data = cursor.fetchall()[0][0]
            if len(data) is 0:
                conn.commit()
                flash('Successful') 
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