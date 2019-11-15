from flask import request, jsonify
from src.data_models.placed_order import PlacedOrderDataModel
from src.backend import Backend
import json
from src.endpoints import routes

from src.utils.utilities import getUserId

#add decorator for authorization wherever its needed

@routes.route('/order', methods=['POST'])
def orderPost():
    with Backend() as backend:
        try:
            isAuthorized = backend.authenticate_request(request)

            if isAuthorized == False:
                return "", 401  # unauthenticated

            unit_order_data_model = PlacedOrderDataModel(request.json)

            user_id = getUserId(request)
            order_id = backend.add_order(unit_order_data_model.data, user_id)

        except Exception as e:
            print(e)
            return jsonify(error=str(e)), 500  # error server failure

        print(
            "[order] user {user_id} placed order: \n".format(user_id=user_id) + str(json.dumps(request.json, indent=2)))
        return jsonify(id=order_id), 200  # success


@routes.route('/order', methods=['GET'])
def orderGet():
    with backend:
        try:
            isAuthorized = backend.authenticate_request(request)

            if isAuthorized == False:
                return "", 401  # unauthenticated

            placed_order_id = request.args["placed_order_id"]
            order = backend.get_placed_order(placed_order_id)

        except Exception as e:  # TODO add sth like this everywhere
            print(e)
            return jsonify(error=str(e)), 500  # error server failure

        return jsonify(order), 200  # success


