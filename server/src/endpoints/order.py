from flask import request, jsonify

from src.data_models.placed_order import PlacedOrderDataModel
from src.server import app, backend

@app.route('/order', methods=['POST'])
def order():
    try:
        user_id = backend.authenticate_user(request)
        if user_id is None:
            return 401

        unit_order_data_model = PlacedOrderDataModel(request.json)

        order_id = backend.add_order(unit_order_data_model, user_id)

    except Exception as e:
        print(e)
        return jsonify(statusCode=500, errorMsg=str(e)) # failure

    return jsonify(statusCode=200, id=order_id)  # success
