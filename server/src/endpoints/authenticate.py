from flask import request, jsonify
from src.backend import Backend
from src.decorators.exception_handler import exception_handler
from src.endpoints import routes
from flask_api import status

@routes.route('/authenticate', methods=['POST'])
@exception_handler
def authenticate():
    with Backend() as backend:
        req_body = request.json

        if "user_id" not in req_body:
            return jsonify(error="user_id not available in request"), status.HTTP_400_BAD_REQUEST

        if "hashed_password" not in req_body:
            return jsonify(error="hashed_password not available in request"), status.HTTP_400_BAD_REQUEST

        user_id = req_body["user_id"]
        hashed_password = req_body["hashed_password"]

        authenticated_user_id = backend.authenticate_user(user_id, hashed_password)

        if authenticated_user_id is not None:
            print("[authenticate] {user_id} access granted".format(user_id=user_id))
            return jsonify(authenticated=True), status.HTTP_200_OK
        else:
            print("[authenticate] {user_id} access denied".format(user_id=user_id))
            return jsonify(authenticated=False), status.HTTP_200_OK
