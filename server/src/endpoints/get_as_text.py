from flask import request
from src.endpoints import routes
from src.backend import Backend
from src.utils.validators.file_validators import is_image_file
from flask_api import status

@routes.route('/getAsText', methods=['GET', 'POST'])
def get_as_text():
    with Backend() as backend:
        if 'file' not in request.files:
            return "file missing in request", status.HTTP_400_BAD_REQUEST

        file = request.files['file']
        if file.filename == '':
            return "No file name", status.HTTP_400_BAD_REQUEST

        if file and is_image_file(file.filename):
            asText = backend.image_to_text(file)
            formatted = " ".join(asText.split())
            return formatted, status.HTTP_200_OK
