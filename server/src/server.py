try:
    from PIL import Image
except ImportError:
    import Image
import pytesseract

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract'

def imageToText(image):
    return pytesseract.image_to_string(Image.open(image), lang='pol')




import os
from flask import Flask, flash, request, redirect, url_for
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = 'C:/Users/jakub/Desktop/LunchIT/src/server/uploads'
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg'])

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/getAsText', methods=['GET', 'POST'])
def getAsText():
    if request.method == 'POST':

        if 'file' not in request.files:
            return "file missing in request", 123

        file = request.files['file']
        if file.filename == '':
            return "No file name", 124

        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            asText = imageToText(file)
            formatted = " ".join(asText.split())
            print(formatted)
            '''
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))'''
            return formatted



    return "success";

if __name__ == '__main__':
    app.run(debug=True, port='5002')


