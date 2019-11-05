from flask import request, jsonify

from src.server import app, backend


@app.route('/authenticate', methods=['POST'])
def authenticate():
    json = request.json

    if "user_id" not in request.headers.keys():
        return jsonify(statusCode=400, error="user_id not available in request")

    if "hashed_password" not in request.headers.keys():
        return jsonify(statusCode=400, error="hashed_password not available in request")

    user_id = request.headers["user_id"]
    hashed_password = request.headers["hashed_password"]

    user_id = backend.authenticate_user(request)
    if user_id is None:
        return jsonify(statusCode=200, authenticated=True)
    else:
        return jsonify(statusCode=200, authenticated=False)