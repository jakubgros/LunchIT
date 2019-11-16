from flask import request
from src.endpoints import routes
from src.backend import Backend
from src.utils.validators.file_validators import is_image_file


@routes.route('/getAsText', methods=['GET', 'POST'])
def getAsText():
    with Backend() as backend:
        if 'file' not in request.files:
            return "file missing in request", 123  # TODO implement status codes

        file = request.files['file']
        if file.filename == '':
            return "No file name", 124

        if file and is_image_file(file.filename):
            asText = backend.image_to_text(file)
            formatted = " ".join(asText.split())
            return formatted
