"""
"""
import os
import logging

from flask import Flask


# create the application object
app = Flask(__name__)
# pulls in app configuration from settings.py
app.config.from_object('settings')

logging.basicConfig(filename=app.config['APP_LOGFILE'],
                    filemode='a+',
                    level=logging.DEBUG,
                    format='%(asctime)s %(name)s %(levelname)s %(message)s')
LOG = logging.getLogger(__name__)
if not app.config['DEBUG']:
    logging.disable(10)


# import modules (have to import at the end after all app configurations are instantiated)
from .base import base

# register the individual blueprints (modules) to the app
app.register_blueprint(base)

