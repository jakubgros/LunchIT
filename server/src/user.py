from flask_login import UserMixin

from src.backend import Backend


class User(UserMixin):
    def __init__(self, request):
        if "HTTP_AUTHORIZATION" not in request.headers.environ:
            return

        auth_header = request.headers.environ["HTTP_AUTHORIZATION"]
        if len(auth_header) == 0:
            return

        (self.user_id, self.hashed_password) = auth_header.split(':', 1)

    @property
    def is_authenticated(self):

        if self.user_id is None or self.hashed_password is None \
                or len(self.user_id) == 0 or len(self.hashed_password) == 0:
            return None

        with Backend() as backend:
            user_id = backend.authenticate_user(self.user_id, self.hashed_password)

        return user_id is not None

    def get_id(self):
        return self.user_id
