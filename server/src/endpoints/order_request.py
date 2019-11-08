from flask import request, Blueprint

from src.backend import backend
import simplejson as json

from src.utils.utilities import getUserId

order_request_api = Blueprint("order_request_api", __name__)

@order_request_api.route('/orderRequest', methods=['GET'])
def order_request():
    with backend:
        isAuthorized = backend.authenticate_request(request)

        if isAuthorized == False:
            return "", 401  # unauthenticated

        user_id = getUserId(request)

        order_requests = backend.get_order_requests(user_id)

        return json.dumps(order_requests, default=str, indent=4, sort_keys=True), 200