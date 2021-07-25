#!/bin/sh

sleep 30;
apt-get install -y apt-transport-https ca-certificates
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list

apt-get update
sleep 30;
apt-get install -y mongodb-org

newip="0.0.0.0"
sed -i -r 's/(\b[0-9]{1,3}.){3}[0-9]{1,3}\b'/$newip/ /etc/mongod.conf

systemctl start mongod
systemctl enable mongod
