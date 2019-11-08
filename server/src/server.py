from flask import Flask
from src.endpoints.authenticate import authenticate_api
from src.endpoints.get_as_text import getAsText_api
from src.endpoints.order import order_api
from src.endpoints.order_request import order_request_api

app = Flask(__name__)

app.register_blueprint(authenticate_api)
app.register_blueprint(getAsText_api)
app.register_blueprint(order_api)
app.register_blueprint(order_request_api)

if __name__ == '__main__':
    app.run(debug=True, port='5002')
