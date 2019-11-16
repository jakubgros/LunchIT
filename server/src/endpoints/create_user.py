from src.backend import Backend
from src.decorators.exception_handler import exception_handler
from src.endpoints import routes

from flask import request, jsonify
import flask_api


@routes.route('/create_account', methods=['POST'])
@exception_handler
def create_account():
    with Backend() as backend:
        req_body = request.json

        if "user_id" not in req_body:
            return jsonify(error="user_id not available in request"), flask_api.status.HTTP_400_BAD_REQUEST

        if "hashed_password" not in req_body:
            return jsonify(error="hashed_password not available in request"), flask_api.status.HTTP_400_BAD_REQUEST

        user_id = req_body["user_id"]
        hashed_password = req_body["hashed_password"]

        has_created = backend.create_user(user_id, hashed_password)

        status = "created" if has_created else "not created"
        return jsonify(status=status), flask_api.status.HTTP_200_OK
