from flask import Blueprint

routes = Blueprint('routes', __name__)

#import all endpoints here

from src.endpoints.authenticate import *
from src.endpoints.get_as_text import *
from src.endpoints.order import *
from src.endpoints.order_request import *