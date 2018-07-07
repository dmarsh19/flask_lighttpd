#!/bin/bash

as_root()
{
  # Make sure we are root
  if [ $(id -u) -ne 0 ]
    then
      echo "Insufficient privileges."
      exit -1
  fi
}
as_root

if [ ! $1 ] || [ ! $2 ]
  then
    echo "Usage: $0 [PROJECT_NAME] [URL_EXTENSION]"
    echo 'Example: '$0' "flask_lighttpd" "/"'
    exit -1
fi
PROJECT_NAME=$1
URL_EXTENSION=$2
SRV_DEST=/srv/lighttpd/${PROJECT_NAME}_project
LIGHTTPD_CONF=/etc/lighttpd/lighttpd.conf

python3 -m pip install -r requirements.txt

mkdir -m 0755 $SRV_DEST
cp -r $PROJECT_NAME settings.py $SRV_DEST

cat > $SRV_DEST/${PROJECT_NAME}.fcgi << EOF_FCGI
#!/usr/bin/env python3

from flup.server.fcgi import WSGIServer
from $PROJECT_NAME import app


if __name__ == "__main__":
    WSGIServer(app).run()

EOF_FCGI

chmod +x $SRV_DEST/${PROJECT_NAME}.fcgi
chown -R www-data:www-data $SRV_DEST

# if fastcgi successfully enabled, exit code = 0
# if fastcgi mod already enabled, exit code = 2
# on subsequent runs, this should stop from re-writing in lighttpd.conf
lighty-enable-mod fastcgi
if [ $? -eq 0 ]
  then
    echo "" >> $LIGHTTPD_CONF
    echo "#### mod_fastcgi ####" >> $LIGHTTPD_CONF
    echo "fastcgi.server = (" >> $LIGHTTPD_CONF
    echo '  "'${URL_EXTENSION}'" => ( (' >> $LIGHTTPD_CONF
    echo '    "socket" => "'/tmp/${PROJECT_NAME}-fcgi.socket'",' >> $LIGHTTPD_CONF
    echo '    "bin-path" => "'${SRV_DEST}/${PROJECT_NAME}.fcgi'",' >> $LIGHTTPD_CONF
    echo '    "check-local" => "disable",' >> $LIGHTTPD_CONF
    echo '    "max-procs" => 1' >> $LIGHTTPD_CONF
    echo "  ) )" >> $LIGHTTPD_CONF
    echo ")" >> $LIGHTTPD_CONF
    echo "" >> $LIGHTTPD_CONF
fi

service lighttpd restart

exit 0

