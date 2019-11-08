from flask import request, Blueprint

from src.backend import backend
import simplejson as json

from src.utils.utilities import getUserId

order_request_api = Blueprint("order_request_api", __name__)


@order_request_api.route('/orderRequest/todo', methods=['GET'])
def order_request_todo():
    return order_request(request, type="todo")


@order_request_api.route('/orderRequest/notTodo', methods=['GET'])
def order_request_done():
    return order_request(request, type="notTodo")


def order_request(request, type):
    with backend:
        isAuthorized = backend.authenticate_request(request)

        if isAuthorized == False:
            return 401  # unauthenticated

        user_id = getUserId(request)

        if type == "todo":
            order_requests = backend.get_all_order_requests(user_id, need_to_be_done=True)
        elif type == "notTodo":
            order_requests = backend.get_all_order_requests(user_id, need_to_be_done=False)

        return json.dumps(order_requests, default=str, indent=4, sort_keys=True), 200
