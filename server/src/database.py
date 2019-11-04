import psycopg2 as psycopg2

from src.utils.config import get_config


class Database:
    def __init__(self):
        config = get_config("config.ini", "postgresql")
        self.connection = psycopg2.connect(**config)

    def __del__(self):
        self.connection.close()

    def test(self):
        cursor = self.connection.cursor()

        cursor.execute('SELECT version()')

        db_version = cursor.fetchone()

        print(db_version)

        cursor.close()

    def has_order(self, user_id, order_request_id):
        statement = "SELECT COUNT(*) FROM placed_order WHERE user_id={user_id} AND order_request_id={order_request_id" \
            .format(user_id=user_id, order_request_id=order_request_id)

        count = None
        with self.connection:
            with self.connection.cursor() as cursor:
                cursor.execute(statement)
                count = cursor.fetchone()[0]

        if count > 1:
            raise Exception("user can't have more than one placed order for single order request")

        return count == 1

    def add_order(self, placed_order, user_id):
        placed_order_id = self._add_placed_order(user_id, placed_order.data.order_request_id)

        for meal in placed_order.data.meals:
            self._add_order_entry(meal, placed_order_id)

        return placed_order_id

    def _add_placed_order(self, user_id, order_request_id):
        statement = "INSERT INTO placed_order(user_id, order_request_id) VALUES({user_id}, {order_request_id}" \
            .format(user_id=user_id, order_request_id=order_request_id)

        placed_order_id = None
        with self.connection:  # automatically calls commit or rollback()
            with self.connection.cursor() as cursor:
                cursor.execute(statement)
                placed_order_id = cursor.fetchone()[0]

        return placed_order_id

    def _add_order_entry(self, entry, placed_order_id):
        statement = """INSERT INTO order_entry(placed_order_id, meal_name, price, quantity, comment)
            VALUES({placed_order_id}, {meal_name}, {price}, {quantity}, {comment})""" \
            .format(
            placed_order_id=placed_order_id,
            meal_name=entry.food_name,
            price=entry.price,
            quantity=entry.quantity,
            comment="NULL" if entry.comment == "" else entry.comment,
        )

        with self.connection:  # automatically calls commit or rollback()
            with self.connection.cursor() as cursor:
                cursor.execute(statement)

    def does_user_exist(self, user_id, hashed_password):
        statement = "SELECT COUNT(*) FROM user WHERE email={email} AND password={password}" \
            .format(email=user_id, password=hashed_password)

        count = None
        with self.connection:
            with self.connection.cursor() as cursor:
                cursor.execute(statement)
                count = cursor.fetchone()[0]

        return count == 1
