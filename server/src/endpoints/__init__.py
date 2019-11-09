from flask import Blueprint

routes = Blueprint('routes', __name__)

#import all endpoints here

from .http.authenticate import *
from .http.get_as_text import *
from .http.order import *
from .http.order_request import *

from .mail.example import *

