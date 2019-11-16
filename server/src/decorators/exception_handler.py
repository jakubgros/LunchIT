from flask import jsonify
from flask_api import status

import functools


def exception_handler(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except Exception as e:
            print(e)
            return jsonify(error=str(e)), status.HTTP_500_INTERNAL_SERVER_ERROR

    return wrapper
