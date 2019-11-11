import psycopg2 as psycopg2

from src.utils.config import get_config
from datetime import datetime

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

    def get_order_requests_for_user(self, user_id):
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
            placed_order.id IS NOT NULL /* ordered */

        ORDER BY
            placed_order.id IS NOT NULL,
            deadline ASC
                        """

        args = {
            "user_id": user_id,
        }

        self.cursor.execute(statement, args)
        allData = self.cursor.fetchall()

        result = list()
        for row in allData:
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
        statement = r"""
            SELECT 
                meal_name,
                price,
                quantity,
                comment
            FROM 
                lunch_it.order_entry
            WHERE
                placed_order_id = %(placed_order_id)s
        """

        args = {
            "placed_order_id": placed_order_id,
        }

        self.cursor.execute(statement, args)
        allData = self.cursor.fetchall()

        result = list()
        for row in allData:
            result.append({
                "food_name": row[0],
                "price": row[1],
                "quantity": row[2],
                "comment": row[3],
            })

        return result

    def get_all_order_requests(self):
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
                    deadline DESC
                                """

        self.cursor.execute(statement)
        all_data = self.cursor.fetchall()

        result = list()
        for row in all_data:
            result.append({
                "id": row[0],
                "price_limit": row[1],
                "name": row[2],
                "deadline": row[3],
                "message": row[4],
                "menu_url": row[5],
            })

        return result

    def add_order_request(self, order_request):
        statement = r"""
        INSERT INTO 
            lunch_it.order_request(price_limit, name, deadline, message, menu_url)
            
        VALUES(%(price_limit)s, %(name)s, %(deadline)s, %(message)s, %(menu_url)s)
        
        RETURNING id"""

        args = {
            "price_limit": float(order_request["price_limit"]),
            "name": order_request["title"],
            "deadline": datetime.strptime(order_request["deadline"], "%Y-%m-%dT%H:%M"),
            "message": order_request["message"],
            "menu_url": order_request["menu_url"],
        }

        self.cursor.execute(statement, args)
        order_request_id = self.cursor.fetchone()[0]

        return order_request_id
