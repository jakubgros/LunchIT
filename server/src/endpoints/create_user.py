from flask import request, jsonify
from src.backend import backend
from src.endpoints import routes


@routes.route('/create_account', methods=['POST'])
def create_account():
    with backend:
        req_body = request.json

        if "user_id" not in req_body:
            return jsonify(error="user_id not available in request"), 400

        if "hashed_password" not in req_body:
            return jsonify(error="hashed_password not available in request"), 400

        user_id = req_body["user_id"]
        hashed_password = req_body["hashed_password"]

        has_created = backend.create_user(user_id, hashed_password)

        status = "created" if has_created else "not created"
        return jsonify(status=status), 200
