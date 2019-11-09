from flask import Flask
from flask_mail import Mail
from src.endpoints import *
from src.utils.config import get_config

app = Flask(__name__)

config = get_config("config.ini", "mail")
config["MAIL_PORT"]= int(config["MAIL_PORT"])
config["MAIL_USE_TLS"] = config["MAIL_USE_TLS"].lower() in ['true', '1']
config["MAIL_USE_SSL"] = config["MAIL_USE_SSL"].lower() in ['true', '1']
app.config.update(config)

app.register_blueprint(routes)

mail = Mail(app)

if __name__ == '__main__':
    app.run(debug=True, port='5002')
