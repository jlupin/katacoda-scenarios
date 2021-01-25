#!/bin/bash

# echo "Installing system dependencies"
apt update && apt install -y curl unzip htop
echo "done" >> /opt/.sys-deps-installed

# echo "Downloading jlupin@1.6.1"
curl https://kacdab-download.s3.eu-central-1.amazonaws.com/platform2.tar.gz -o jlupin.tgz
echo "done" >> /opt/.jlupin-downloaded

# echo "Preparing JLupin"
mkdir -p /opt/jlupin
tar -zxvf jlupin.tgz -C /opt/jlupin
chmod 750 /opt/jlupin/platform/start/start.sh
chmod 750 /opt/jlupin/platform/start/control.sh
sed -i '1iuser root root;' /opt/jlupin/platform/start/configuration/edge.conf
sed -i '/ssl/ s/^#*/#/g' /opt/jlupin/platform/technical/nginx/linux/conf/servers/admin.conf
sed -i 's/  isStartOnMainServerInitialize: true/  isStartOnMainServerInitialize: false/' /opt/jlupin/platform/application/currency-converter-eur/configuration.yml
sed -i 's/  isStartOnMainServerInitialize: true/  isStartOnMainServerInitialize: false/' /opt/jlupin/platform/application/currency-converter-gbp/configuration.yml
sed -i 's/  isStartOnMainServerInitialize: true/  isStartOnMainServerInitialize: false/' /opt/jlupin/platform/application/currency-converter-chf/configuration.yml
sed -i 's/  isStartOnMainServerInitialize: true/  isStartOnMainServerInitialize: false/' /opt/jlupin/platform/application/exchange-rates/configuration.yml
sed -i 's/  isStartOnMainServerInitialize: true/  isStartOnMainServerInitialize: false/' /opt/jlupin/platform/application/exchange/servlet_configuration.yml
sed -i 's/  isStartOnMainServerInitialize: true/  isStartOnMainServerInitialize: false/' /opt/jlupin/platform/application/channelMicroservice/configuration.yml
sed -i 's/  isStartOnMainServerInitialize: true/  isStartOnMainServerInitialize: false/' /opt/jlupin/platform/application/queueMicroservice/configuration.yml
echo "done" >> /opt/.jlupin-setup

# echo "Starting JLupin platform"
/opt/jlupin/platform/start/start.sh
status=$(curl -w "%{http_code}\\n" -H 'Accept: application/json' -H 'Content-Type: application/json' -H 'Connection: keep-alive' --data-raw $'{\n  "value": "12",\n  "currency": "USD"\n}' http://localhost:8000/exchange/convert -s -o /dev/null)

while [[ "$status" != "200" ]]
do
  sleep 5
  status=$(curl -w "%{http_code}\\n" -H 'Accept: application/json' -H 'Content-Type: application/json' -H 'Connection: keep-alive' --data-raw $'{\n  "value": "12",\n  "currency": "USD"\n}' http://localhost:8000/exchange/convert -s -o /dev/null)
done
echo "done" >> /opt/.jlupin-started

# echo "Starting example app"
/opt/jlupin/platform/start/control.sh microservice destroy currency-converter-eur
/opt/jlupin/platform/start/control.sh microservice destroy currency-converter-gbp
/opt/jlupin/platform/start/control.sh microservice destroy currency-converter-chf
/opt/jlupin/platform/start/control.sh microservice destroy exchange-rates
/opt/jlupin/platform/start/control.sh microservice destroy exchange
/opt/jlupin/platform/start/control.sh microservice destroy channelMicroservice
/opt/jlupin/platform/start/control.sh microservice destroy queueMicroservice
echo "done" >> /opt/.jlupin-prepared

# echo "Preparing project structure"
mkdir -p /root/scenario/project
unzip /root/scenario/hello-jlupin.zip -d /root/scenario/project/
rm -rf /root/scenario/project/__MACOSX
echo "done" >> /opt/.project-prepared
