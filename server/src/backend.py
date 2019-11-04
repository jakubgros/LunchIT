from src.database import Database

try:
    from PIL import Image
except ImportError:
    import Image
import pytesseract


class BackEnd:
    def __init__(self):
        self.db = Database()
        pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract'

    def add_order(self, unit_order_data_model, user_id):
        if self.db.has_order(user_id, unit_order_data_model.orderRequestId):
            raise Exception("User already ordered meal for the orderRequest")

        order_id = self.db.add_order(unit_order_data_model, user_id)

        return order_id

    def authenticate_user(self, request):  # returns None if credentials are not valid, user id else
        if "user_id" not in request.headers.keys():
            return None

        if "hashed_password" not in request.headers.keys():
            return None

        user_id = request.headers["user_id"]
        hashed_password = request.headers["hashed_password"]

        does_exist = self.db.does_user_exist(user_id, hashed_password)

        if does_exist == False:
            return None
        else:
            return user_id

    @staticmethod
    def image_to_text(image):
        return pytesseract.image_to_string(Image.open(image), lang='pol')
