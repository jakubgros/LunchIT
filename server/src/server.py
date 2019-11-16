from flask import Flask
from flask_login import LoginManager

from src.endpoints import *
from src.utils.config import get_config

app = Flask(__name__)

from flask_cors import CORS

app = Flask(__name__)

config = get_config("config.ini", "mail")
config["MAIL_PORT"] = int(config["MAIL_PORT"])
config["MAIL_USE_TLS"] = config["MAIL_USE_TLS"].lower() in ['true', '1']
config["MAIL_USE_SSL"] = config["MAIL_USE_SSL"].lower() in ['true', '1']
app.config.update(config)

app.register_blueprint(routes)

cors = CORS(app)  # TODO adjust on production server

login_manager = LoginManager()
login_manager.init_app(app)

@login_manager.request_loader
def load_user_from_request(request):

    from src.user import User
    user = User(request)
    if user.is_authorized:
        return user
    else:
        return None

if __name__ == '__main__':
    app.run(debug=True, port='5002')


