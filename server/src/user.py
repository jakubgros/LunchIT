from flask_login import UserMixin

from src.backend import Backend
from src.utils.utilities import getUserId


class User(UserMixin):
    def __init__(self, request):
        with Backend() as backend:
            is_authorized = backend.authenticate_request(request)

            self.is_authorized = is_authorized
            self.user_id = getUserId(request)


    @property
    def is_active(self):
        return True

    @property
    def is_authenticated(self):
        return self.is_authorized

    @property
    def is_anonymous(self):
        return False

    def get_id(self):
        return self.user_id

    def __eq__(self, other):
        return super().__eq__(other)

    def __ne__(self, other):
        return super().__ne__(other)