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

    def add_order(self, unitOrderDataModel, userId):
        if self.db.hasOrder(userId, unitOrderDataModel.orderRequestId):
            raise Exception("User already ordered meal for the orderRequest")

        self.db.addOrder(unitOrderDataModel, userId)

    def get_user_id(self, userToken):
        return 1234567890  # TODO

    def authenticate_user(self, request):  # returns None if userToken is not valid, user id else
        if ("userToken" not in request.headers.keys()):
            return None

        userToken = request.headers.userToken
        userId = self.get_user_id(userToken)
        return userId

    def image_to_text(self, image):
        return pytesseract.image_to_string(Image.open(image), lang='pol')
