from flask import request, jsonify, Blueprint

from src.data_models.placed_order import PlacedOrderDataModel
from src.backend import backend
import json

from src.utils.utilities import getUserId

order_api = Blueprint("order_api", __name__)
@order_api.route('/order', methods=['POST'])
def order():
    with backend:
        try:
            isAuthorized = backend.authenticate_request(request)

            if isAuthorized == False:
                return 401 # unauthenticated

            unit_order_data_model = PlacedOrderDataModel(request.json)

            user_id = getUserId(request)
            order_id = backend.add_order(unit_order_data_model.data, user_id)

        except Exception as e:
            print(e)
            return jsonify(errorMsg=str(e)), 500 # error server failure

        print("[order] user {user_id} placed order: \n".format(user_id=user_id) + str(json.dumps(request.json, indent=2)))
        return jsonify(id=order_id), 200 # success
