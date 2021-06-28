#!/bin/bash

# echo "Installing system dependencies"
apt update && apt install -y curl unzip htop
echo "done" >> /opt/.sys-deps-installed

# echo "Downloading jlupin@1.6.1"
curl https://jlupin-files.s3.eu-central-1.amazonaws.com/platform2.tar.gz -o jlupin.tgz
curl https://jlupin-files.s3.eu-central-1.amazonaws.com/exchange-1.6.1.0.zip -o exchange.zip
echo "done" >> /opt/.jlupin-downloaded

# echo "Preparing JLupin"
mkdir -p /opt/jlupin
tar -zxvf jlupin.tgz -C /opt/jlupin
chmod 750 /opt/jlupin/platform/start/start.sh
chmod 750 /opt/jlupin/platform/start/control.sh
sed -i '1iuser root root;' /opt/jlupin/platform/start/configuration/edge.conf
sed -i '/ssl/ s/^#*/#/g' /opt/jlupin/platform/technical/nginx/linux/conf/servers/admin.conf
sed -i 's/^  isStartOnMainServerInitialize: true/  isStartOnMainServerInitialize: false/' /opt/jlupin/platform/application/currency-converter-eur/configuration.yml
rm -rf /opt/jlupin/platform/application/channelMicroservice
rm -rf /opt/jlupin/platform/application/queueMicroservice
rm -rf /opt/jlupin/platform/application/exchange
unzip exchange.zip -d /opt/jlupin/platform/application
echo "done" >> /opt/.jlupin-setup

# echo "Starting JLupin platform"
/opt/jlupin/platform/start/start.sh
echo "done" >> /opt/.jlupin-started

status=$(curl -w "%{http_code}\\n" -H 'Accept: application/json' -H 'Content-Type: application/json' -H 'Connection: keep-alive' --data-raw $'{\n  "value": "12",\n  "currency": "USD"\n}' http://localhost:8000/exchange/convert -s -o /dev/null)

while [[ "$status" != "200" ]]
do
  sleep 5
  status=$(curl -w "%{http_code}\\n" -H 'Accept: application/json' -H 'Content-Type: application/json' -H 'Connection: keep-alive' --data-raw $'{\n  "value": "12",\n  "currency": "USD"\n}' http://localhost:8000/exchange/convert -s -o /dev/null)
done

# echo "Finished"
echo "done" >> /opt/.exchange-available
