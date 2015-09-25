#!/usr/bin/env bash
SLAVE=$1
IP=$2

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

# Get current IP (assuming set correctly)
echo ${IP} | tee /etc/mesos-slave/ip
cp /etc/mesos-slave/ip /etc/mesos-slave/hostname

# Configure zookeeper, etc.
mkdir -p /etc/zookeeper/conf
mkdir -p /var/lib/zookeeper
mkdir -p /etc/marathon/conf
echo ${SLAVE} > /etc/zookeeper/conf/myid
echo ${SLAVE} > /var/lib/zookeeper/myid
cat /vagrant/config-files/zoo.cfg >> /etc/zookeeper/conf/zoo.cfg
cp /vagrant/config-files/zk.cfg /etc/mesos/zk
cp /vagrant/config-files/marathon.cfg /etc/marathon/conf/zk

# Allow docker containers
echo 'docker,mesos' | tee /etc/mesos-slave/containerizers

# Add slave pointer to the hosts list
echo "127.0.0.1    vmslave${SLAVE}" >> /etc/hosts
echo "${IP}        vmslave${SLAVE}" >> /etc/hosts

# Make sure zookeeper not on slaves
service zookeeper stop
echo manual | sudo tee /etc/init/zookeeper.override

# Switch off the master node stuff
service mesos-master stop
echo manual > /etc/init/mesos-master.override

# Switch on the services, etc.
update-rc.d mesos-slave defaults
service mesos-slave restart

###############################################################
echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant
###############################################################
apt-get autoclean
echo "****** done with bootstrap"
###############################################################
