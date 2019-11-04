import psycopg2 as psycopg2

from src.config import getConfig




class Database:
    def __init__(self):
        config = getConfig("config.ini", "postgresql")
        self.connection = psycopg2.connect(**config)
        self.cursor = self.connection.cursor()

    def test(self):
        self.cursor.execute('SELECT version()')

        db_version = self.cursor.fetchone()
        print(db_version)