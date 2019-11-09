from werkzeug.utils import secure_filename
from flask import request
from .. import routes
from src.backend import backend
from src.utils.validators.file_validators import is_image_file


@routes.route('/getAsText', methods=['GET', 'POST'])  # TODO change to post get only
def getAsText():
    with backend:
        if request.method == 'POST':  # TODO not sure if needed

            if 'file' not in request.files:
                return "file missing in request", 123  # TODO implement status codes

            file = request.files['file']
            if file.filename == '':
                return "No file name", 124

            if file and is_image_file(file.filename):
                filename = secure_filename(file.filename)
                asText = backend.image_to_text(file)
                formatted = " ".join(asText.split())
                print(formatted)
                '''
                file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))'''
                return formatted
