from src.backend.backend import Backend
from src.decorators.exception_handler import exception_handler
from src.endpoints import routes

import simplejson as json
from flask_login import login_required, current_user
from flask_api import status


@routes.route('/user_order_requests', methods=['GET'])
@login_required
@exception_handler
def order_request_for_single_user():
    with Backend() as backend:
        order_requests = backend.get_users_order_requests(current_user.user_id)
        return json.dumps(order_requests, default=str, indent=4, sort_keys=True), status.HTTP_200_OK
