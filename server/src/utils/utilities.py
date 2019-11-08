def getUserId(request):
    (username, password) = request.headers.environ["HTTP_AUTHORIZATION"].split(':', 1)
    return username
