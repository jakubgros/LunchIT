from src.database.database import Database

from singleton_decorator import singleton
from PIL import Image
import pytesseract

from src.utils.config import get_config


@singleton
class Backend:
    def __init__(self):
        self.db = Database()

        config = get_config("tesseract")
        pytesseract.pytesseract.tesseract_cmd = config["LOCATION_PATH"]

    def __enter__(self):
        return self

    def __exit__(self, exception_type, exception_value, traceback):
        if exception_type is not None:
            self.db.rollback()
        else:
            self.db.commit()

    def place_order(self, order, user_id):
        if self.db.has_order(user_id, order["orderRequestId"]):
            raise Exception("User already ordered meal for the orderRequest")

        order_id = self.db.place_order(order, user_id)

        return order_id

    def has_ordered(self, user_id, order_request_id):
        return self.db.has_order(user_id, order_request_id)

    def get_placed_order(self, order_id):
        return self.db.get_placed_order(order_id)


    def get_placed_orders_merged(self, order_request_id):
        placed_orders = self.db.get_all_placed_orders(order_request_id)

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

    def get_users_order_requests(self, user_id):

        all_order_requests = self.get_all_order_requests()

        order_requests_for_user = list()
        for order_request in all_order_requests:
            order_request['placed_order_id'] = self.db.get_placed_order_id(user_id, order_request['id'])

        return all_order_requests

    def get_all_order_requests(self):
        return self.db.get_all_order_requests()

    def add_order_request(self, order_request):
        return self.db.add_order_request(order_request)

    def create_user(self, user_id, hashed_password):
        return self.db.create_user(user_id, hashed_password)

    def authenticate_user(self, user_id, hashed_password):
        are_credentials_correct = self.db.are_credentials_correct(user_id, hashed_password)

        if not are_credentials_correct:
            return None
        else:
            return user_id

    def image_to_text(self, image):
        return pytesseract.image_to_string(Image.open(image), lang='pol')
