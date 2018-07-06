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

# flask, flup6, and dependencies
python3 -m pip install -r requirements.txt

mkdir -p -m 0755 /srv/lighttpd/flask_lighttpd_project
cp -r flask_lighttpd flask_lighttpd.fcgi settings.py /srv/lighttpd/flask_lighttpd_project
chown -R www-data:www-data /srv/lighttpd

# if fastcgi successfully enabled, exit code = 0
# if fastcgi mod already enabled, exit code = 2
# on subsequent runs, this should stop from re-writing in lighttpd.conf
lighty-enable-mod fastcgi
if [ $? -eq 0 ]
  then
    echo "" >> /etc/lighttpd/lighttpd.conf
    echo "#### mod_fastcgi ####" >> /etc/lighttpd/lighttpd.conf
    echo "fastcgi.server = (" >> /etc/lighttpd/lighttpd.conf
    echo '  "/" => ( (' >> /etc/lighttpd/lighttpd.conf
    echo '    "socket" => "/tmp/flask_lighttpd-fcgi.socket",' >> /etc/lighttpd/lighttpd.conf
    echo '    "bin-path" => "/srv/lighttpd/flask_lighttpd_project/flask_lighttpd.fcgi",' >> /etc/lighttpd/lighttpd.conf
    echo '    "check-local" => "disable",' >> /etc/lighttpd/lighttpd.conf
    echo '    "max-procs" => 1' >> /etc/lighttpd/lighttpd.conf
    echo '  ) )' >> /etc/lighttpd/lighttpd.conf
    echo ')' >> /etc/lighttpd/lighttpd.conf
    echo "" >> /etc/lighttpd/lighttpd.conf
fi

service lighttpd restart

exit 0

