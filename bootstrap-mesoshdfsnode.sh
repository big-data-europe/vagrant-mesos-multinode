#!/usr/bin/env bash

export PATH="/vagrant:$PATH"

#################################################################
# Standard System Updates.

# Now start to setup for building unified views, etc.
apt-get install -y openjdk-7-jre openjdk-7-jdk
apt-get install -y maven bash emacs nano vim
apt-get install -y openssh-server

###############################################################
pwd
echo $PATH
bootstrap-hadoop-setup.sh
bootstrap-mesos-setup.sh
mkdir -p /etc/mesos-slave
cp /vagrant/config-files/masters /etc/mesos-slave/master

# Make sure zookeeper not on slaves
sudo stop zookeeper
echo manual | sudo tee /etc/init/zookeeper.override

# Switch on the services, etc.
update-rc.d mesos-slave defaults
service mesos-slave start

###############################################################
echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant
###############################################################
apt-get autoclean
echo "****** done with bootstrap"
###############################################################
