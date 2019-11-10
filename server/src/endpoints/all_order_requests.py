from src.backend import backend
import simplejson as json
from src.endpoints import routes

@routes.route('/allOrderRequests', methods=['GET'])
def all_order_requests():
    with backend:
        order_requests = backend.get_all_order_requests()

        return json.dumps(order_requests, default=str, indent=4, sort_keys=True), 200
