from src.decorators.exception_handler import exception_handler
from src.endpoints import routes
from src.backend.backend import Backend
from src.utils.validators.file_validators import is_image_file

from flask import request, jsonify
from flask_api import status

@routes.route('/api/image_to_text', methods=['POST'])
@exception_handler
def get_as_text():
    with Backend() as backend:
        if 'file' not in request.files:
            return jsonify(error="file missing in request"), status.HTTP_400_BAD_REQUEST

        file = request.files['file']
        if file.filename == '':
            return jsonify(error="No file name"), status.HTTP_400_BAD_REQUEST

        if file and is_image_file(file.filename):
            as_text = backend.image_to_text(file)
            formatted = " ".join(as_text.split())
            return jsonify(text=formatted), status.HTTP_200_OK
