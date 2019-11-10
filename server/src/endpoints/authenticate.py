from flask import request, jsonify
from src.backend import backend
from src.endpoints import routes

@routes.route('/authenticate', methods=['POST'])
def authenticate():
    with backend:
        reqBody = request.json

        if "user_id" not in reqBody:
            return jsonify(error="user_id not available in request"), 400

        if "hashed_password" not in reqBody:
            return jsonify(error="hashed_password not available in request"), 400

        user_id = reqBody["user_id"]
        hashed_password = reqBody["hashed_password"]

        authenticated_user_id = backend.authenticate_user(user_id, hashed_password)

        if authenticated_user_id is not None:
            print("[authenticate] {user_id} access granted".format(user_id=user_id))
            return jsonify(authenticated=True), 200
        else:
            print("[authenticate] {user_id} access denied".format(user_id=user_id))
            return jsonify(authenticated=False), 200
