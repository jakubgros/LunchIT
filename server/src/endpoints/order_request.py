from flask import request, jsonify
from src.backend import backend
from src.endpoints import routes


@routes.route('/order_request', methods=['POST'])
def order_request_post():
    with backend:
        try:
            added_order_request_id = backend.add_order_request(request.json)

            return jsonify(order_request_id=added_order_request_id), 200

        except Exception as e:
            print(e)
            return jsonify(error=str(e)), 500  # error server failure


@routes.route('/order_request', methods=['GET'])
def order_request_get_all_orders():
    with backend:
        try:
            orders = backend.get_placed_orders_merged(request.args['id'])

        except Exception as e:  # TODO add sth like this everywhere
            print(e)
            return jsonify(error=str(e)), 500  # error server failure

        return jsonify(orders), 200  # success




