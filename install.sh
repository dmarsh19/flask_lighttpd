#!/bin/bash

PROJECT_NAME="flask_lighttpd"
URL_EXTENSION="/"
SRV_DEST=/srv/lighttpd/${PROJECT_NAME}_project
LIGHTY_CONF=/etc/lighttpd/lighttpd.conf

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

python3 -m pip install -r requirements.txt

mkdir -m 0755 $SRV_DEST
cp -r $PROJECT_NAME ${PROJECT_NAME}.fcgi settings.py $SRV_DEST
chown -R www-data:www-data $SRV_DEST

# if fastcgi successfully enabled, exit code = 0
# if fastcgi mod already enabled, exit code = 2
# on subsequent runs, this should stop from re-writing in lighttpd.conf
lighty-enable-mod fastcgi
if [ $? -eq 0 ]
  then
    echo "" >> $LIGHTY_CONF
    echo "#### mod_fastcgi ####" >> $LIGHTY_CONF
    echo "fastcgi.server = (" >> $LIGHTY_CONF
    echo "  '${URL_EXTENSION}' => ( (" >> $LIGHTY_CONF
    echo "    'socket' => '/tmp/${PROJECT_NAME}-fcgi.socket'," >> $LIGHTY_CONF
    echo "    'bin-path' => ${SRV_DEST}/${PROJECT_NAME}.fcgi'," >> $LIGHTY_CONF
    echo "    'check-local' => 'disable'," >> $LIGHTY_CONF
    echo "    'max-procs' => 1" >> $LIGHTY_CONF
    echo "  ) )" >> $LIGHTY_CONF
    echo ")" >> $LIGHTY_CONF
    echo "" >> $LIGHTY_CONF
fi

service lighttpd restart

exit 0

