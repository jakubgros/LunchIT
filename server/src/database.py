import psycopg2 as psycopg2

from src.utils.config import get_config


class Database:
    def __init__(self):
        config = get_config("config.ini", "postgresql")
        self.connection = psycopg2.connect(**config)
        self.cursor = self.connection.cursor()

    def __del__(self):
        self.connection.close()
        self.cursor.close()

    def rollback(self):
        self.connection.rollback()

    def commit(self):
        self.connection.commit()

    def has_order(self, user_id, order_request_id):
        statement = r"""SELECT COUNT(*) FROM lunch_it.placed_order WHERE user_id=%(user_id)s AND order_request_id=%(order_request_id)s;"""
        args = {
            "user_id": user_id,
            "order_request_id": order_request_id,
        }

        self.cursor.execute(statement, args)
        count = self.cursor.fetchone()[0]

        if count > 1:
            raise Exception("user can't have more than one placed order for single order request")

        return count == 1

    def add_order(self, placed_order, user_id):
        placed_order_id = self._add_placed_order(user_id, placed_order["orderRequestId"])

        basket = placed_order["basketData"]
        for meal in basket["meals"]:
            self._add_order_entry(meal, placed_order_id)

        return placed_order_id

    def _add_placed_order(self, user_id, order_request_id):
        statement = r"""INSERT INTO lunch_it.placed_order(user_id, order_request_id) VALUES(%(user_id)s, %(order_request_id)s) RETURNING id"""
        args = {
            "user_id": user_id,
            "order_request_id": order_request_id,
        }

        self.cursor.execute(statement, args)
        placed_order_id = self.cursor.fetchone()[0]

        return placed_order_id

    def _add_order_entry(self, entry, placed_order_id):
        statement = r"""INSERT INTO lunch_it.order_entry(placed_order_id, meal_name, price, quantity, comment)
            VALUES(%(placed_order_id)s, %(meal_name)s, %(price)s, %(quantity)s, %(comment)s)"""
        args = {
            "placed_order_id": placed_order_id,
            "meal_name": entry["foodName"],
            "price": entry["price"],
            "quantity": entry["quantity"],
            "comment": None if entry["comment"] == "" else entry["comment"],
        }

        self.cursor.execute(statement, args)

    def does_user_exist(self, user_id, hashed_password):
        statement = r"""SELECT COUNT(*) FROM lunch_it.user WHERE email=%(email)s AND password=%(password)s"""
        args = {
            "email": user_id,
            "password": hashed_password,
        }

        self.cursor.execute(statement, args)
        count = self.cursor.fetchone()[0]

        return count == 1
