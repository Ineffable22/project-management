#!/usr/bin/python3
"""This script starts a Flask web application.
"""
from os import getenv
from flask import Flask, jsonify, make_response
from flask_cors import CORS
from routes import app_views
from dotenv import load_dotenv

load_dotenv()
app = Flask(__name__)
app.register_blueprint(app_views)
cors = CORS(app, resources={r"/*": {"origins": ["http://lowlevel.tech/*", "https://lowlevel.tech/*", "https://www.lowlevel.tech"]}}, secure=False)


@app.teardown_appcontext
def teardown(self):
    """Removes the current mysql connector Session.
    """
    # return storage.close_db()
    return (None)


@app.errorhandler(404)
def error(e):
    """Handler for 404 errors.

    Args:
        e (err): Error message.

    Returns:
        response: json response.
    """
    return make_response(jsonify({"error": "Not found"}), 404)


if __name__ == '__main__':
    host = getenv("APP_HOST") if getenv("APP_HOST") else "0.0.0.0"
    port = getenv("APP_PORT") if getenv("APP_PORT") else 5000
    app.run(host=host, port=port, threaded=True, debug=getenv('APP_DEBUG'))
