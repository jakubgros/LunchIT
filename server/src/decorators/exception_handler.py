from flask import jsonify
from flask_api import status

import functools

DEBUG_MODE = True

def exception_handler(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except Exception as e:
            if not DEBUG_MODE:
                return jsonify(error=str(e)), status.HTTP_500_INTERNAL_SERVER_ERROR
            else:
                raise


    return wrapper
