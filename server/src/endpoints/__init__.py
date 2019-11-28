from flask import Blueprint

routes = Blueprint('routes', __name__)

# import all endpoints here
from src.endpoints.authenticate import *
from src.endpoints.image_to_text import *
from src.endpoints.order import *
from src.endpoints.order_request_for_single_user import *
from src.endpoints.order_request import *
from src.endpoints.create_user import *
from src.endpoints.has_ordered import *
from src.endpoints.group_order import *