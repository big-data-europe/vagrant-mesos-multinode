#!/usr/bin/env bash
#################################################################
# Standard System Updates.
MASTER=$1
IP=$2

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

# Stop all services so the details can be updated safely.
service zookeeper stop
service mesos-master stop
service marathon stop

# Configure Zookeeper
mkdir -p /etc/zookeeper/conf
mkdir -p /var/lib/zookeeper
echo ${MASTER} > /etc/zookeeper/conf/myid
echo ${MASTER} > /var/lib/zookeeper/myid
cat /vagrant/config-files/zoo.cfg >> /etc/zookeeper/conf/zoo.cfg
cp /vagrant/config-files/zk.cfg /etc/mesos/zk

# Configure Mesos
# (eth0 is the ip assigned via NAT - provided IP is given on bridged eth1)
echo ${IP} | tee /etc/mesos-master/ip
cp /etc/mesos-master/ip /etc/mesos-master/hostname

# Configure Marathon
mkdir -p /etc/marathon/conf
cp /etc/mesos-master/hostname /etc/marathon/conf
cp /etc/mesos/zk /etc/marathon/conf/master
cp /vagrant/config-files/marathon.cfg /etc/marathon/conf/zk

# Install Chronos (http://master:4400/)
apt-get -y install chronos

# Add master pointer to the hosts list
echo "127.0.0.1    vmmaster${MASTER}" >> /etc/hosts
echo "${IP}        vmmaster${MASTER}" >> /etc/hosts

# Switch off the slave setup
echo manual > /etc/init/mesos-slave.override

# Setup startup....
service zookeeper start
service mesos-master start
service marathon start
service chronos start

update-rc.d zookeeper defaults
update-rc.d mesos-master defaults
update-rc.d marathon defaults
update-rc.d chronos defaults

###############################################################
# Change the default homepage
echo "user_pref(\"browser.startup.homepage\", \"http://${IP}:5050\");" >> /etc/firefox/syspref.js
echo "_user_pref(\"browser.startup.homepage\", \"http://${IP}:5050\");" >> /etc/firefox/pref/syspref.js

###############################################################
echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant
###############################################################
apt-get autoclean
echo "****** done with bootstrap - master ${MASTER}"
###############################################################

