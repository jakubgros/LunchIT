from flask import request, Blueprint
from src.backend import backend
import simplejson as json
from src.utils.utilities import getUserId
from src.endpoints import routes

@routes.route('/orderRequestForSingleUser', methods=['GET'])
def order_request_for_single_user():
    with backend:
        isAuthorized = backend.authenticate_request(request)

        if isAuthorized == False:
            return "", 401  # unauthenticated

        user_id = getUserId(request)

        order_requests = backend.get_order_requests(user_id)

        return json.dumps(order_requests, default=str, indent=4, sort_keys=True), 200
