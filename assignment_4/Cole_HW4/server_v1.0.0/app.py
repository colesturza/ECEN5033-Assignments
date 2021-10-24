import os
from flask import Flask, request

app = Flask(__name__)


@app.route("/")
def hello_world():
    print(f"Received request from {request.remote_addr}")
    hostname = os.uname()[1]
    return f"You've hit {hostname}. A very interesting message."


if __name__ == "__main__":
    app.run()
