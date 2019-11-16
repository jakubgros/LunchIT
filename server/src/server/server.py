from flask import Flask
from flask_login import LoginManager
from flask_cors import CORS

from src.endpoints import *

app = Flask(__name__)

app.register_blueprint(routes)

cors = CORS(app)  # TODO adjust on production server

login_manager = LoginManager()
login_manager.init_app(app)


@login_manager.request_loader
def load_user_from_request(req):

    from src.server.user import User
    user = User(req)
    if user.is_authenticated:
        return user
    else:
        return None


def run_server():
    app.run(debug=True, port='5002')


if __name__ == '__main__':
    run_server()

