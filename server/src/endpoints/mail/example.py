from flask_mail import Message
from src.server import mail
from .. import routes


@routes.route("/testEmail")
def test():
    msg = Message(subject="Hello",
                  sender=("LUNCH IT", "mail.lunchit@gmail.com"),
                  recipients=["kubagros@gmail.com"],
                  body="This is a test email I sent with Gmail and Python!")
    mail.send(msg)

    return "message sent"
