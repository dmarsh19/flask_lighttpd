- **Complete 1base.sh install\setup from infrastructure_project.**
- **Ensure /srv exists under root:root ownership with 755 permissions**

```
cd ~/dev
sudo ./infrastructure_project/9install_lighttpd.sh
git clone https://github.com/dmarsh19/flask_lighttpd.git flask_lighttpd_project
cd flask_lighttpd_project
sudo ./install.sh
```

