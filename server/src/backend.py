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

    def __enter__(self):
        return self

    def __exit__(self, exception_type, exception_value, traceback):
        if exception_type is not None:
            self.db.rollback()
        else:
            self.db.commit()

    def add_order(self, unit_order_data_model, user_id):
        if self.db.has_order(user_id, unit_order_data_model["orderRequestId"]):
            raise Exception("User already ordered meal for the orderRequest")

        order_id = self.db.add_order(unit_order_data_model, user_id)

        return order_id

    def authenticate_user(self, user_id, hashed_password):  # returns None if credentials are not valid, user id else
        does_exist = self.db.does_user_exist(user_id, hashed_password)

        if does_exist == False:
            return None
        else:
            return user_id

    @staticmethod
    def image_to_text(image):
        return pytesseract.image_to_string(Image.open(image), lang='pol')

    def authenticate_request(self, request):
        if "HTTP_AUTHORIZATION" not in request.headers.environ:
            return False

        auth_header = request.headers.environ["HTTP_AUTHORIZATION"]

        (username, hashed_password) = auth_header.split(':', 1)

        if username is None or hashed_password is None:
            return False


        user_id = self.authenticate_user(username, hashed_password)

        return user_id is not None

    def get_order_requests(self, user_id):
        return self.db.get_order_requests(user_id)

    def get_placed_order(self, placed_order_id):
        return self.db.get_placed_order(placed_order_id)

backend = BackEnd() # will be used by other files