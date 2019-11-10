from flask import Flask, send_from_directory
from src.endpoints import *
from src.utils.config import get_config

WEB_CLIENT_PATH = "C:/Users/jakub/Desktop/LunchIT/web_client" #TODO dehardcode
app = Flask(__name__)

config = get_config("config.ini", "mail")
config["MAIL_PORT"]= int(config["MAIL_PORT"])
config["MAIL_USE_TLS"] = config["MAIL_USE_TLS"].lower() in ['true', '1']
config["MAIL_USE_SSL"] = config["MAIL_USE_SSL"].lower() in ['true', '1']
app.config.update(config)

app.register_blueprint(routes)

@app.route('/lunch_it/<string:page_name>/') #TODO change all endpoints to start with /api/ and this to not contain /lunch_it/
def send_static(page_name):
    file_name = '%s.html' % page_name
    return send_from_directory(WEB_CLIENT_PATH, file_name)

if __name__ == '__main__':
    app.run(debug=True, port='5002')
