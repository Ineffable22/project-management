#!/usr/bin/python3
"""This module define a blueprint for routes with Blueprint object"""
from flask import Blueprint


app_views = Blueprint("app_views", __name__, url_prefix='/api')

from routes.index import *
from routes.user import *
from routes.request import *
from routes.table import *
from routes.company import *
