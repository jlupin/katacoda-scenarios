#!/bin/bash

# echo "Installing system dependencies"
apt update
apt install -y curl htop
echo "done" >> /opt/.sys-deps-installed

# echo "Downloading jlupin@1.6.1"
curl https://kacdab-download.s3.eu-central-1.amazonaws.com/platform2.tar.gz -o jlupin.tgz
echo "done" >> /opt/.jlupin-downloaded

# echo "Preparing JLupin"
mkdir -p /opt/jlupin/platform1
tar -zxvf jlupin.tgz -C /opt/jlupin/platform1
mv /opt/jlupin/platform1/platform/* /opt/jlupin/platform1
rm -rf /opt/jlupin/platform1/platform
chmod 750 /opt/jlupin/platform1/start/start.sh
chmod 750 /opt/jlupin/platform1/start/control.sh
sed -i '1iuser root root;' /opt/jlupin/platform1/start/configuration/edge.conf
sed -i '/ssl/ s/^#*/#/g' /opt/jlupin/platform1/technical/nginx/linux/conf/servers/admin.conf
sed -i 's/  isStartOnMainServerInitialize: true/  isStartOnMainServerInitialize: false/' /opt/jlupin/platform1/application/currency-converter-eur/configuration.yml
echo "done" >> /opt/.jlupin1-setup

mkdir -p /opt/jlupin/platform2
tar -zxvf jlupin.tgz -C /opt/jlupin/platform2
mv /opt/jlupin/platform2/platform/* /opt/jlupin/platform2
rm -rf /opt/jlupin/platform2/platform
chmod 750 /opt/jlupin/platform2/start/start.sh
chmod 750 /opt/jlupin/platform2/start/control.sh
sed -i '1iuser root root;' /opt/jlupin/platform2/start/configuration/edge.conf
sed -i '/ssl/ s/^#*/#/g' /opt/jlupin/platform2/technical/nginx/linux/conf/servers/admin.conf

sed -i 's/DEBUG_PORT=12998/DEBUG_PORT=13998/' /opt/jlupin/platform2/start/configuration/setenv
sed -i 's/JMX_PORT=9010/JMX_PORT=19010/' /opt/jlupin/platform2/start/configuration/setenv

sed -i 's/  name: NODE_1/  name: NODE_2/' /opt/jlupin/platform2/start/configuration/main.yml
sed -i 's/    port: 9090/    port: 19090/' /opt/jlupin/platform2/start/configuration/main.yml
sed -i 's/    port: 8082/    port: 18082/' /opt/jlupin/platform2/start/configuration/main.yml
sed -i 's/    port: 9095/    port: 19095/' /opt/jlupin/platform2/start/configuration/main.yml
sed -i 's/    port: 9096/    port: 19096/' /opt/jlupin/platform2/start/configuration/main.yml
sed -i 's/    port: 9097/    port: 19097/' /opt/jlupin/platform2/start/configuration/main.yml
sed -i 's/    port: 9098/    port: 19098/' /opt/jlupin/platform2/start/configuration/main.yml
sed -i 's/      begin: 20001/      begin: 40001/' /opt/jlupin/platform2/start/configuration/main.yml
sed -i 's/      end: 30000/      end: 50000/' /opt/jlupin/platform2/start/configuration/main.yml
sed -i 's/      begin: 30001/      begin: 50001/' /opt/jlupin/platform2/start/configuration/main.yml
sed -i 's/      end: 40000/      end: 60000/' /opt/jlupin/platform2/start/configuration/main.yml
sed -i 's/  NODE_1:/  NODE_2:/' /opt/jlupin/platform2/start/configuration/main.yml
sed -i 's/    jlrmcPort: 9090/    jlrmcPort: 19090/' /opt/jlupin/platform2/start/configuration/main.yml
sed -i 's/    queuePort: 9095/    queuePort: 19095/' /opt/jlupin/platform2/start/configuration/main.yml
sed -i 's/    transmissionPort: 9096/    transmissionPort: 19096/' /opt/jlupin/platform2/start/configuration/main.yml
sed -i 's/    informationPort: 9097/    informationPort: 19097/' /opt/jlupin/platform2/start/configuration/main.yml

sed -i 's/    discoveryPort = "9098"/    discoveryPort = "19098"/' /opt/jlupin/platform2/start/configuration/edge.conf
sed -i 's/    discoveryPeersDefaultAdminPort = "8889"/    discoveryPeersDefaultAdminPort = "18889"/' /opt/jlupin/platform2/start/configuration/edge.conf
sed -i 's/    listen  8888;/    listen 18888;/' /opt/jlupin/platform2/start/configuration/edge.conf
sed -i 's/    listen  8889;/    listen 18889;/' /opt/jlupin/platform2/start/configuration/edge.conf

sed -i 's/  listen  8000;/  listen 18000;/' /opt/jlupin/platform2/start/configuration/edge_servers/edge8000.conf
sed -i 's/  server_name edge8000;/  server_name edge18000;/' /opt/jlupin/platform2/start/configuration/edge_servers/edge8000.conf

sed -i 's/  listen  8001;/  listen 18001;/' /opt/jlupin/platform2/start/configuration/edge_servers/edge8001.conf
sed -i 's/  server_name edge8001;/  server_name edge18001;/' /opt/jlupin/platform2/start/configuration/edge_servers/edge8001.conf

sed -i 's/  transmissionPort:  9096/  transmissionPort: 19096/' /opt/jlupin/platform2/start/control/configuration/control.yml
sed -i 's/  transmissionPort:  9096/  transmissionPort: 19096/' /opt/jlupin/platform2/application/webcontrol/control.yml

sed -i "s/  externalPort: '8000'/  externalPort: '18000'/" /opt/jlupin/platform2/application/exchange/servlet_configuration.yml
sed -i "s/  externalPort: '8888'/  externalPort: '18888'/" /opt/jlupin/platform2/application/webcontrol/servlet_configuration.yml

sed -i 's/  isStartOnMainServerInitialize: true/  isStartOnMainServerInitialize: false/' /opt/jlupin/platform2/application/currency-converter-gbp/configuration.yml

echo "done" >> /opt/.jlupin2-setup

# echo "Starting JLupin 1"
/opt/jlupin/platform1/start/start.sh
echo "done" >> /opt/.jlupin1-started

status=$(curl -w "%{http_code}\\n" -H 'Accept: application/json' -H 'Content-Type: application/json' -H 'Connection: keep-alive' --data-raw $'{\n  "value": "12",\n  "currency": "USD"\n}' http://localhost:8000/exchange/convert -s -o /dev/null)

while [[ "$status" != "200" ]]
do
  sleep 5
  status=$(curl -w "%{http_code}\\n" -H 'Accept: application/json' -H 'Content-Type: application/json' -H 'Connection: keep-alive' --data-raw $'{\n  "value": "12",\n  "currency": "USD"\n}' http://localhost:8000/exchange/convert -s -o /dev/null)
done

# echo "Finished"
echo "done" >> /opt/.exchange1-available

# echo "Starting JLupin 2"
/opt/jlupin/platform2/start/start.sh
echo "done" >> /opt/.jlupin2-started

status=$(curl -w "%{http_code}\\n" -H 'Accept: application/json' -H 'Content-Type: application/json' -H 'Connection: keep-alive' --data-raw $'{\n  "value": "12",\n  "currency": "USD"\n}' http://localhost:18000/exchange/convert -s -o /dev/null)

while [[ "$status" != "200" ]]
do
  sleep 5
  status=$(curl -w "%{http_code}\\n" -H 'Accept: application/json' -H 'Content-Type: application/json' -H 'Connection: keep-alive' --data-raw $'{\n  "value": "12",\n  "currency": "USD"\n}' http://localhost:18000/exchange/convert -s -o /dev/null)
done

# echo "Finished"
echo "done" >> /opt/.exchange2-available
