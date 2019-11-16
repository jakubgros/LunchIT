from src.backend import Backend
import simplejson as json
from src.endpoints import routes

from flask_login import login_required, current_user


@routes.route('/orderRequestForSingleUser', methods=['GET'])
@login_required
def order_request_for_single_user():
    with Backend() as backend:

        order_requests = backend.get_order_requests_for_user(current_user.user_id)
        return json.dumps(order_requests, default=str, indent=4, sort_keys=True), 200

