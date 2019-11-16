from src.backend.backend import Backend
from src.endpoints import routes
from src.decorators.exception_handler import exception_handler

from flask import request, jsonify
from flask_login import login_required, current_user
from flask_api import status
import json


@routes.route('/order', methods=['POST'])
@login_required
@exception_handler
def order_post():
    with Backend() as backend:
        json_data = request.json
        order_id = backend.place_order(json_data, current_user.user_id)

        print("[order] user {user_id} placed order: \n"
              .format(user_id=current_user.user_id) + str(json.dumps(request.json, indent=2)))

        return jsonify(id=order_id), status.HTTP_200_OK


@routes.route('/order', methods=['GET'])
@login_required
@exception_handler
def order_get():
    with Backend() as backend:
        placed_order_id = request.args["placed_order_id"]
        order = backend.get_placed_order(placed_order_id)
        return jsonify(order), status.HTTP_200_OK
