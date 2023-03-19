from flask import Flask, render_template, json, request
import psycopg2
import os
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)

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
            _hashed_password = generate_password_hash(_password)
            cursor.callproc('sp_createUser', (_name, _email, _password))
            data = cursor.fetchall()
            return_message = str(data[0])
            #print(return_message, "________")
            #conn.commit()
            if return_message.find('successfully'):
                conn.commit()
                cursor.close()
                conn.close()
                return json.dumps({'message': 'User created successfully !'})
            else:
                cursor.close()
                conn.close()
                return json.dumps({'error': str(data[0])})

        else:
            return json.dumps({'html': '<span>Enter the required fields</span>'})

    #except Exception as e:
    #    return json.dumps({'error': str(e)})
    #finally:
    #    cursor.close()
    #    conn.close()


if __name__ == "__main__":
    app.run()