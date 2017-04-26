#!/home/dmarsh/envs/flask_lighttpd_project/bin/python

# activate virtualenv
activate_this = '/home/dmarsh/envs/flask_lighttpd_project/bin/activate_this.py'
with open(activate_this) as f:
    exec(f.read(), dict(__file__=activate_this))

from flup.server.fcgi import WSGIServer
from flask_lighttpd import app

if __name__ == '__main__':
    WSGIServer(app).run()
