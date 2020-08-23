```
sudo apt install -y virtualenv
virtualenv -p python3 superset
source superset/bin/activate
pip3 install apache-superset
fabmanager create-admin --app superset
```
