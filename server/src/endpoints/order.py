from flask import request, jsonify

from src.data_models.unit_order import UnitOrderDataModel
from src.server import app, backend

@app.route('/order', methods=['POST'])
def order():
    try:
        userId = backend.authenticate_user(request)
        if(userId is None):
            return 401

        unitOrderDataModel = UnitOrderDataModel(request.json)

        backend.add_order(unitOrderDataModel, userId)

    except Exception as e:
        print(e)
        return jsonify(statusCode=500, errorMsg = str(e)) # failure

    return jsonify(statusCode=200)  # success
