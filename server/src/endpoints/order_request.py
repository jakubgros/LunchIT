from flask import request, jsonify
from src.backend import Backend
from src.endpoints import routes
from flask_api import status

@routes.route('/order_request', methods=['POST'])
def add_new_order_request():
    with Backend() as backend:
        try:
            added_order_request_id = backend.add_order_request(request.json)

            return jsonify(order_request_id=added_order_request_id), status.HTTP_200_OK

        except Exception as e:
            print(e)
            return jsonify(error=str(e)), status.HTTP_500_INTERNAL_SERVER_ERROR


@routes.route('/order_request', methods=['GET'])
def order_request_get_all_orders():
    with Backend() as backend:
        try:
            orders = backend.get_placed_orders_merged(request.args['id'])

        except Exception as e:  # TODO add sth like this everywhere
            print(e)
            return jsonify(error=str(e)), status.HTTP_500_INTERNAL_SERVER_ERROR
        return jsonify(orders), status.HTTP_200_OK




