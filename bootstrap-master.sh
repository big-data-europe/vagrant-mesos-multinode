#!/usr/bin/env bash
#################################################################
# Standard System Updates.
MASTER=$1

export PATH="/vagrant:$PATH"

# Switch off the automatic updates message
echo "APT::Periodic::Update-Package-Lists \"0\";" > /etc/apt/apt.conf.d/10periodic

apt-get install -y dkms virtualbox-guest-dkms build-essential

# Now start to setup for building unified views, etc.
apt-get install -y openjdk-7-jre openjdk-7-jdk
apt-get install -y git maven bash emacs nano vim firefox
apt-get install -y openssh-server

###############################################################
bootstrap-mesos-setup.sh
bootstrap-hadoop-setup.sh

mkdir -p /etc/zookeeper/conf/myid/var/lib/zookeeper
mkdir -p /etc/zookeeper/conf
echo ${MASTER}${MASTER} > /etc/zookeeper/conf/myid
echo ${MASTER}${MASTER} > /var/lib/zookeeper/myid
cat config-files/zoo.cfg >> /etc/zookeeper/conf/zoo.cfg
# Setup startup....
service zookeeper restart
service mesos-master start
service mesos-slave start
service marathon start

update-rc.d zookeeper defaults
update-rc.d mesos-master defaults
update-rc.d mesos-slave defaults
update-rc.d marathon defaults

echo "127.0.0.1    vmh_master${MASTER}" >> /etc/hosts

###############################################################
# Change the default homepage
echo "user_pref(\"browser.startup.homepage\", \"http://vmh_master${MASTER}:5050\");" >> /etc/firefox/syspref.js
echo "_user_pref(\"browser.startup.homepage\", \"http://vmh_master${MASTER}:5050\");" >> /etc/firefox/browser/defaults/preferences/syspref.js

###############################################################
echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant
###############################################################
apt-get autoclean
echo "****** done with bootstrap - master ${MASTER}"
###############################################################

