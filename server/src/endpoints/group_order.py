from src.decorators.exception_handler import exception_handler
from src.backend.backend import Backend
from src.endpoints import routes

from flask import request, jsonify
from flask_api import status

@routes.route('/group_order', methods=['GET'])
@exception_handler
def order_request_get_all_orders():
    with Backend() as backend:
        orders = backend.get_placed_orders_merged(request.args['id'])
        return jsonify(orders), status.HTTP_200_OK
