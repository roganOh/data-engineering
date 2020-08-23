# Superset Installation Instructions (in Ubuntu)

```
sudo apt update
sudo apt install -y build-essential autoconf libtool python3-dev libssl-dev libsasl2-dev libldap2-dev 
sudo apt install -y virtualenv
virtualenv -p python3 superset
source superset/bin/activate
pip3 install image cryptography
pip3 install apache-superset
```

Create a user and group for superset and a home directory
```
groupadd superset
useradd superset -g superset -d /var/lib/superset -m
```

Create a login account for Superset (don't forget to note the credentials somewhere)
```
export FLASK_APP=superset
flask fab create-admin
```

```
superset db upgrade
superset init
```

Create a PostgreSQL user/password and a DB. We will use an external Postgres instance for this


Create a superset config. Don't forget to change ID, PW and DATABASE according to your Postgres credentials
```
$ sudo su - superset
$ cd /var/lib/superset
$ mkdir conf
$ cat > conf/envs
PYTHONPATH=/var/lib/superset/conf
<ctrl + d>

$ cat > conf/superset_config
SUPERSET_WEBSERVER_PORT = 8088
SQLALCHEMY_DATABASE_URI = 'postgresql://ID:PW@127.0.0.1/DATABASE'
<ctrl + d>
$ echo "export PYTHONPATH=$HOME/conf" >> ~/.bashrc
$ . ~/.bashrc
```

Create startup scripts
```
$ sudo -i
# cat > /etc/systemd/system/superset-server.service
[Unit]
Description=Superset server
After=network.target postgresql.service
Wants=postgresql.service

[Service]
EnvironmentFile=/var/lib/superset/conf/envs
User=superset
Group=superset
Type=simple
ExecStart=/usr/local/bin/superset runserver
Restart=on-failure
RestartSec=10s

[Install]
WantedBy=multi-user.target
<ctrl + d>
```

Run the server
```
# systemctl daemon-reload
# systemctl start superset-server
# systemctl status superset-server

● superset-server.service - Superset server
   Loaded: loaded (/etc/systemd/system/superset-server.service; disabled; vendor preset: enabled)
   Active: active (running) since Tue 2018-07-24 05:05:02 UTC; 2min 21s ago
 Main PID: 26409 (/usr/bin/python)
    Tasks: 11
   Memory: 390.4M
      CPU: 8.046s
   CGroup: /system.slice/superset-server.service
           ├─26409 /usr/bin/python /usr/local/bin/superset runserver
           ├─26423 /bin/sh -c gunicorn -w 2 --timeout 60 -b  0.0.0.0:8088 --limit-request-line 0 --limit-request-field_size 0 superset:app
           ├─26424 gunicorn: master [superset:app]
           ├─26428 gunicorn: worker [superset:app]
           └─26430 gunicorn: worker [superset:app]

Jul 24 05:05:05 ip-172-30-1-240 superset[26409]: [2018-07-24 05:05:05 +0000] [26424] [INFO] Listening at: http://0.0.0.0:8088 (26424)
...
```

## See Also
* https://superset.incubator.apache.org/installation.html

