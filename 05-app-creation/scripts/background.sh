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
rm -rf /opt/jlupin/platform/application/channelMicroservice
rm -rf /opt/jlupin/platform/application/queueMicroservice
rm -rf /opt/jlupin/platform/application/currency-converter-eur
rm -rf /opt/jlupin/platform/application/currency-converter-gbp
rm -rf /opt/jlupin/platform/application/currency-converter-chf
rm -rf /opt/jlupin/platform/application/exchange-rates
rm -rf /opt/jlupin/platform/application/exchange
echo "done" >> /opt/.jlupin-setup

# echo "Starting JLupin platform"
/opt/jlupin/platform/start/start.sh
echo "done" >> /opt/.jlupin-started

# echo "Preparing project structure"
mkdir -p /root/scenario/project
unzip /root/scenario/hello-jlupin.zip -d /root/scenario/project/
rm -rf /root/scenario/project/__MACOSX
echo "done" >> /opt/.project-prepared
