import psycopg2 as psycopg2

from src.utils.config import get_config
from datetime import datetime

from singleton_decorator import singleton


@singleton
class Database:
    def __init__(self):
        config = get_config("config.ini", "postgresql")
        self.connection = psycopg2.connect(**config)

    def __del__(self):
        self.connection.close()

    def rollback(self):
        self.connection.rollback()

    def commit(self):
        self.connection.commit()

    def has_order(self, user_id, order_request_id):
        with self.connection.cursor() as cursor:
            statement = r"""
                SELECT 
                    COUNT(*)
                FROM
                    lunch_it.placed_order
                WHERE
                        user_id=%(user_id)s 
                    AND 
                        order_request_id=%(order_request_id)s;"""

            args = {
                "user_id": user_id,
                "order_request_id": order_request_id,
            }

            cursor.execute(statement, args)
            count = cursor.fetchone()[0]

            if count > 1:
                raise Exception("User can't have more than one placed order for single order request")

            return count == 1

    def place_order(self, order, user_id):
        order_id = self._add_order(user_id, order["orderRequestId"])

        basket = order["basketData"]
        for meal in basket["meals"]:
            self._add_order_entry(meal, order_id)

        return order_id

    def _add_order(self, user_id, order_request_id):
        with self.connection.cursor() as cursor:
            statement = r"""
                INSERT INTO
                    lunch_it.placed_order(user_id, order_request_id)
                VALUES
                    (%(user_id)s, %(order_request_id)s)
                RETURNING 
                    id;"""

            args = {
                "user_id": user_id,
                "order_request_id": order_request_id,
            }

            cursor.execute(statement, args)
            order_id = cursor.fetchone()[0]

            return order_id

    def _add_order_entry(self, entry, order_id):
        with self.connection.cursor() as cursor:
            statement = r"""
                INSERT INTO 
                    lunch_it.order_entry(placed_order_id, meal_name, price, quantity, comment)
                VALUES
                    (%(placed_order_id)s, %(meal_name)s, %(price)s, %(quantity)s, %(comment)s);"""

            args = {
                "placed_order_id": order_id,
                "meal_name": entry["foodName"],
                "price": entry["price"],
                "quantity": entry["quantity"],
                "comment": None if entry["comment"] == "" else entry["comment"],
            }

            cursor.execute(statement, args)

    def are_credentials_correct(self, user_id, hashed_password):
        with self.connection.cursor() as cursor:
            statement = r"""
                SELECT 
                    COUNT(*) 
                FROM 
                    lunch_it.user 
                WHERE 
                        email=%(email)s 
                    AND 
                        password=%(password)s;"""

            args = {
                "email": user_id,
                "password": hashed_password,
            }

            cursor.execute(statement, args)
            count = cursor.fetchone()[0]

            return count == 1

    def get_order_requests_for_user(self, user_id):
        with self.connection.cursor() as cursor:
            statement = r"""
                SELECT
                    placed_order.id as placed_order_id,
                    name,
                    price_limit,
                    deadline,
                    message,
                    order_request.id as order_request_id,
                    menu_url
                    
                FROM
                    lunch_it.order_request
                LEFT OUTER JOIN
                    lunch_it.placed_order
                ON
                    (order_request.id = placed_order.order_request_id)
                                 
                WHERE
                    deadline > NOW() AND placed_order.id IS NULL /* not expired and not ordered*/
                        OR 
                    ( 
                        placed_order.id IS NOT NULL 
                            AND 
                        placed_order.user_id=%(user_id)s
                    ) /* ordered */
        
                ORDER BY
                    placed_order.id IS NOT NULL,
                    deadline ASC;"""

            args = {
                "user_id": user_id,
            }

            cursor.execute(statement, args)
            all_data = cursor.fetchall()

            result = list()
            for row in all_data:
                result.append({
                    "placed_order_id": row[0],
                    "name": row[1],
                    "price_limit": row[2],
                    "deadline": row[3],
                    "message": row[4],
                    "order_request_id": row[5],
                    "menu_url": row[6],
                })

            return result

    def get_placed_order(self, placed_order_id):
        with self.connection.cursor() as cursor:
            statement = r"""
                SELECT 
                    meal_name,
                    price,
                    quantity,
                    comment
                FROM 
                    lunch_it.order_entry
                WHERE
                    placed_order_id = %(placed_order_id)s;"""

            args = {
                "placed_order_id": placed_order_id,
            }

            cursor.execute(statement, args)
            all_data = cursor.fetchall()

            result = list()
            for row in all_data:
                result.append({
                    "food_name": row[0],
                    "price": row[1],
                    "quantity": row[2],
                    "comment": row[3],
                })

            return result

    def get_all_order_requests(self):
        with self.connection.cursor() as cursor:
            statement = r"""
                SELECT
                    id,
                    price_limit,
                    name,
                    deadline,
                    message,
                    menu_url
    
                FROM
                    lunch_it.order_request
    
                ORDER BY
                    deadline DESC;"""

            cursor.execute(statement)
            all_data = cursor.fetchall()

            result = list()
            for row in all_data:
                result.append({
                    "id": row[0],
                    "price_limit": row[1],
                    "name": row[2],
                    "deadline": row[3],
                    "message": row[4],
                    "menu_url": row[5],
                }) #TODO extract to _process_row(row)

            return result

    def add_order_request(self, order_request):
        with self.connection.cursor() as cursor:
            statement = r"""
                INSERT INTO 
                    lunch_it.order_request(price_limit, name, deadline, message, menu_url)
                VALUES
                    (%(price_limit)s, %(name)s, %(deadline)s, %(message)s, %(menu_url)s)
                RETURNING id;"""

            args = {
                "price_limit": float(order_request["price_limit"]),
                "name": order_request["title"],
                "deadline": datetime.strptime(order_request["deadline"], "%Y-%m-%dT%H:%M"), #TODO move such processing to highest layer
                "message": order_request["message"],
                "menu_url": order_request["menu_url"],
            }

            cursor.execute(statement, args)
            order_request_id = cursor.fetchone()[0]

            return order_request_id

    def get_placed_orders(self, order_request_id):
        with self.connection.cursor() as cursor:
            statement = r"""
                SELECT
                    meal_name,
                    quantity,
                    comment
                FROM
                    lunch_it.order_request
                INNER JOIN
                    lunch_it.placed_order
                ON
                    (order_request.id = placed_order.order_request_id)
                INNER JOIN
                    lunch_it.order_entry
                ON
                    (placed_order.id = order_entry.placed_order_id)
                WHERE
                    order_request.id = %(order_request_id)s;"""

            args = {
                "order_request_id": int(order_request_id),
            }

            cursor.execute(statement, args)
            all_data = cursor.fetchall()

            result = list()
            for row in all_data:
                result.append({
                    "meal_name": row[0],
                    "quantity": row[1],
                    "comment": row[2],
                })

            return result

    def does_user_exist(self, user_id):
        with self.connection.cursor() as cursor:
            statement = r"""
                SELECT 
                    COUNT(*) 
                FROM 
                    lunch_it.user 
                WHERE 
                    email=%(email)s;"""

            args = {
                "email": user_id,
            }

            cursor.execute(statement, args)
            count = cursor.fetchone()[0]

            return count == 1

    def create_user(self, user_id, hashed_password):
        with self.connection.cursor() as cursor:
            if self.does_user_exist(user_id):
                return False

            statement = r"""
                INSERT INTO 
                    lunch_it.user(email, password) 
                VALUES
                    (%(email)s, %(password)s);"""

            args = {
                "email": user_id,
                "password": hashed_password,
            }

            cursor.execute(statement, args)
            return True
