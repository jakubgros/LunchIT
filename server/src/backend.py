from src.database import Database

from singleton_decorator import singleton
from PIL import Image
import pytesseract

from src.utils.config import get_config


@singleton
class Backend:
    def __init__(self):
        self.db = Database()

        config = get_config("config.ini", "tesseract")
        pytesseract.pytesseract.tesseract_cmd = config["LOCATION_PATH"]

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
        are_credentials_correct = self.db.are_credentials_correct(user_id, hashed_password)

        if are_credentials_correct == False:
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
        if len(auth_header) == 0:
            return False

        (username, hashed_password) = auth_header.split(':', 1)

        if username is None \
                or hashed_password is None\
                or len(username) == 0 \
                or len(hashed_password) == 0:
            return False


        user_id = self.authenticate_user(username, hashed_password)

        return user_id is not None

    def get_order_requests_for_user(self, user_id):
        return self.db.get_order_requests_for_user(user_id)

    def get_placed_order(self, placed_order_id):
        return self.db.get_placed_order(placed_order_id)

    def get_all_order_requests(self):
        return self.db.get_all_order_requests()

    def add_order_request(self, order_request):
        return self.db.add_order_request(order_request)

    def get_placed_orders_merged(self, order_request_id):
        placed_orders = self.db.get_placed_orders(order_request_id)

        merged = dict()
        for order in placed_orders:
            meal_name = order["meal_name"]
            if meal_name not in merged:
                merged[meal_name] = dict()

            comment = "-" if order["comment"] is None\
                else order["comment"]

            if comment not in merged[meal_name]:
                merged[meal_name][comment] = order["quantity"]
            else:
                merged[meal_name][comment] += order["quantity"]

        return merged

    def create_user(self, user_id, hashed_password):
        return self.db.create_user(user_id, hashed_password)