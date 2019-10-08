#!/bin/bash
set -e

set +e
mv /etc/apt/sources.list.bak /etc/apt.sources.list
set -e

cp /etc/apt/sources.list /etc/apt/sources.list.bak
sed -i '/security/d' /etc/apt/sources.list
sed -i '/updates/d' /etc/apt/sources.list
sed -i '/backports/d' /etc/apt/sources.list
apt-get update
apt-get -y install apache2=2.4.29-1ubuntu4
mv /etc/apt/sources.list.bak /etc/apt/sources.list
apt-get update
