import os
from flask import Flask

app = Flask(__name__)
msg = os.environ["ENDPOINT_MESSAGE"]


@app.route("/")
def hello_world():  # put application's code here
    return msg


if __name__ == "__main__":
    app.run()
