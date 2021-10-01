import datetime
import os

from flask import Flask, render_template, redirect, url_for


app = Flask(__name__)

@app.route("/")
def hello():
    return "HELLO.  APP_SECRET_KEY="+os.environ['APP_SECRET_KEY']+"\n"


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)
