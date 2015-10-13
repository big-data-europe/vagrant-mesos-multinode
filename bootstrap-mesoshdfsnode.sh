#!/usr/bin/env bash
###############################################################
# SLAVE node setup.
SLAVE=$1
IP=$2

###############################################################
export PATH="/vagrant:$PATH"

###############################################################
# Basic setup required.
apt-get install -y openjdk-7-jre openjdk-7-jdk
apt-get install -y maven bash emacs nano vim
apt-get install -y openssh-server
                              # Install/Setup Docker facilities
bootstrap-docker.sh

###############################################################
# Install hadoop and mesos on the slave node (IP has to be
# passed infor it to be set correctly).
bootstrap-hadoop-setup.sh $IP
bootstrap-mesos-setup.sh

###############################################################
mkdir -p /etc/mesos-slave
# cp /vagrant/config-files/masters /etc/mesos-slave/master

# Set current IP (assuming set correctly - requires reboot)
echo ${IP} | tee /etc/mesos-slave/ip

###############################################################
# Configure zookeeper, etc.
mkdir -p /etc/zookeeper/conf
mkdir -p /var/lib/zookeeper
mkdir -p /etc/marathon/conf
echo ${SLAVE}${SLAVE} > /etc/zookeeper/conf/myid
echo ${SLAVE}${SLAVE} > /var/lib/zookeeper/myid
cat /vagrant/config-files/zoo.cfg >> /etc/zookeeper/conf/zoo.cfg
cp /vagrant/config-files/zk.cfg /etc/mesos/zk
cp /vagrant/config-files/marathon.cfg /etc/marathon/conf/zk

###############################################################
# Allow docker containers
echo 'docker,mesos' | tee /etc/mesos-slave/containerizers
# Recommended (http://frankhinek.com/deploy-docker-containers-on-mesos-0-20/)
echo "5mins" | tee /etc/mesos-slave/executor_registration_timeout

###############################################################
# Add slave pointer to the hosts list
echo "127.0.0.1    vmslave${SLAVE}" >> /etc/hosts
echo "${IP}        vmslave${SLAVE}" >> /etc/hosts

###############################################################
# Make sure zookeeper not on slaves
service zookeeper stop
echo manual | sudo tee /etc/init/zookeeper.override

###############################################################
# Switch off the master node stuff
service mesos-master stop
echo manual > /etc/init/mesos-master.override

###############################################################
# Switch on the services, etc.
update-rc.d mesos-slave defaults
service mesos-slave restart

###############################################################
echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant
###############################################################
apt-get autoclean
apt-get autoremove
echo "****** done with slave node bootstrap - REBOOT REQUIRED"
###############################################################
