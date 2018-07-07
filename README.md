- **Complete 1base.sh install\setup from infrastructure_project.**

```
cd ~/dev/infrastructure_project
sudo ./9install_webserver.sh lighttpd
cd ~/dev
git clone https://github.com/dmarsh19/flask_lighttpd.git flask_lighttpd_project
cd flask_lighttpd_project
sudo ./install.sh "flask_lighttpd" "/"
```

From a web browser, visit the appropriate URL.

