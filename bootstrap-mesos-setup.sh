#!/bin/bash
####################################################################
apt-get install -y autoconf libtool
apt-get -y install build-essential python-dev python-boto \
	libcurl4-nss-dev libsasl2-dev maven libapr1-dev libsvn-dev

apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)

echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | \
    tee /etc/apt/sources.list.d/mesosphere.list
apt-get -y update
apt-get -y install mesos marathon
