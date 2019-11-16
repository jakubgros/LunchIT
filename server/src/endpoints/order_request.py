from src.backend import Backend
from src.decorators.exception_handler import exception_handler
from src.endpoints import routes

from flask import request, jsonify
from flask_api import status

@routes.route('/order_request', methods=['POST'])
@exception_handler
def add_new_order_request():
    with Backend() as backend:
        added_order_request_id = backend.add_order_request(request.json)
        return jsonify(order_request_id=added_order_request_id), status.HTTP_200_OK


@routes.route('/order_request', methods=['GET'])
@exception_handler
def order_request_get_all_orders():
    with Backend() as backend:
        orders = backend.get_placed_orders_merged(request.args['id'])
        return jsonify(orders), status.HTTP_200_OK
