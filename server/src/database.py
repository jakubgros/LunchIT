import psycopg2 as psycopg2

from src.utils.config import get_config


class Database:
    def __init__(self):
        config = get_config("config.ini", "postgresql")
        self.connection = psycopg2.connect(**config)
        self.cursor = self.connection.cursor()

    def test(self):
        self.cursor.execute('SELECT version()')

        db_version = self.cursor.fetchone()
        print(db_version)
