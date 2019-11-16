from flask import request, jsonify
from flask_login import login_required, current_user
from src.data_models.placed_order import PlacedOrderDataModel
from src.backend import Backend
import json
from src.endpoints import routes
from flask_api import status
@routes.route('/order', methods=['POST'])
@login_required
def order_post():
    with Backend() as backend:
        try:
            unit_order_data_model = PlacedOrderDataModel(request.json) #TODO do sth about it
            order_id = backend.add_order(unit_order_data_model.data, current_user.user_id)

        except Exception as e:
            print(e)
            return jsonify(error=str(e)), status.HTTP_500_INTERNAL_SERVER_ERROR

        print(
            "[order] user {user_id} placed order: \n".format(user_id=current_user.user_id) + str(json.dumps(request.json, indent=2)))
        return jsonify(id=order_id), status.HTTP_200_OK  # success


@routes.route('/order', methods=['GET'])
@login_required
def order_get():
    with Backend() as backend:
        try:
            placed_order_id = request.args["placed_order_id"]
            order = backend.get_placed_order(placed_order_id)

        except Exception as e:  # TODO add sth like this everywhere
            print(e)
            return jsonify(error=str(e)), status.HTTP_500_INTERNAL_SERVER_ERROR

        return jsonify(order), status.HTTP_200_OK

