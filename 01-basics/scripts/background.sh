#!/bin/bash

# echo "Installing system dependencies"
apt update && apt install -y curl unzip htop
echo "done" >> /opt/.sys-deps-installed

# echo "Downloading jlupin@1.6.1"
curl https://kacdab-download.s3.eu-central-1.amazonaws.com/platform2.tar.gz -o jlupin.tgz
echo "done" >> /opt/.jlupin-downloaded

# echo "Downloading hello-world"
curl https://kacdab-download.s3.eu-central-1.amazonaws.com/hello-world.zip -o hello-app.zip
echo "done" >> /opt/.app-downloaded

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
echo "done" >> /opt/.jlupin-started

# echo "Starting example app"
unzip hello-app.zip -d /opt/jlupin/platform/application
/opt/jlupin/platform/start/control.sh microservice start hello-world
sleep 1
/opt/jlupin/platform/start/control.sh microservice destroy currency-converter-eur
/opt/jlupin/platform/start/control.sh microservice destroy currency-converter-gbp
/opt/jlupin/platform/start/control.sh microservice destroy currency-converter-chf
/opt/jlupin/platform/start/control.sh microservice destroy exchange-rates
/opt/jlupin/platform/start/control.sh microservice destroy exchange
/opt/jlupin/platform/start/control.sh microservice destroy channelMicroservice
/opt/jlupin/platform/start/control.sh microservice destroy queueMicroservice

status=$(curl -w "%{http_code}\\n" -H 'Connection: keep-alive' http://localhost:8000/hello-world/greeting?name=test -s -o /dev/null)

while [[ "$status" != "200" ]]
do
  sleep 3
  status=$(curl -w "%{http_code}\\n" -H 'Connection: keep-alive' http://localhost:8000/hello-world/greeting?name=test -s -o /dev/null)
done

echo "Finished"
echo "done" >> /opt/.app-available
