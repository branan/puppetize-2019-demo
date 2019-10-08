#!/bin/bash
set -e

set +e
# This mv can fail if there is no bak - that's OK.
mv /etc/apt/sources.list.bak /etc/apt/sources.list
set -e

apt-get update
apt-get -y install apache2=2.4.29-1ubuntu4.11
