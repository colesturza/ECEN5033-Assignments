import os
from flask import Flask

app = Flask(__name__)


@app.route("/")
def hello_world():
    return "A very interesting message."


if __name__ == "__main__":
    app.run()
