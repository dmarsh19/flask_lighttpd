#!/usr/bin/env python3

from flup.server.fcgi import WSGIServer
from flask_lighttpd import app


if __name__ == '__main__':
    WSGIServer(app).run()

