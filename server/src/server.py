from src.backend import BackEnd

from flask import Flask


app = Flask(__name__)
backend = BackEnd()

if __name__ == '__main__':
    app.run(debug=True, port='5002')
