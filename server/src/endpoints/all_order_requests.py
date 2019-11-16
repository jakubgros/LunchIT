from src.backend import Backend
import simplejson as json
from src.endpoints import routes
from flask_api import status
@routes.route('/allOrderRequests', methods=['GET'])
def all_order_requests():
    with Backend() as backend:
        order_requests = backend.get_all_order_requests()

        return json.dumps(order_requests, default=str, indent=4, sort_keys=True), status.HTTP_200_OK
