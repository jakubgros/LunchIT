from src.backend.backend import Backend
from src.decorators.exception_handler import exception_handler
from src.endpoints import routes

import simplejson as json
from flask_login import login_required, current_user
from flask_api import status
from flask import request, jsonify


@routes.route('/has_ordered', methods=['GET'])
@login_required
@exception_handler
def has_ordered():
    with Backend() as backend:
        order_request_id = request.args['order_request_id']

        has_ordered = backend.has_ordered(current_user.user_id, order_request_id)
        return jsonify(has_ordered=has_ordered), status.HTTP_200_OK

