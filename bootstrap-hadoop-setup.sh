#!/bin/bash

IP=$1

###############################################################
# Create necessary addition users and groups (default passwords)
addgroup hadoop --disabled-password
adduser --ingroup hadoop hduser --disabled-password
adduser hduser sudo
echo "hduser:password" | chpasswd

# SSH key generation
su "( echo | ssh-keygen -t rsa -P \'\'; cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys)" hduser

###############################################################
# Download hadoop 2.7.1
pushd /vagrant/tmp
 wget -N -c http://mirrors.gigenet.com/apache/hadoop/common/stable/hadoop-2.7.1.tar.gz
 tar vxzf hadoop-2.7.1.tar.gz -C /usr/local
 pushd /usr/local
   mv hadoop-2.7.1 hadoop
   chown -R hduser:hadoop hadoop
 popd
popd

###############################################################
# Setup other services
echo "hduser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/hduser

###############################################################
# Update required configuration files

echo "Copy config files"
pwd
cp /vagrant/config-files/hadoop-env.sh /usr/local/hadoop/etc/hadoop
cp /vagrant/config-files/core-site.xml /usr/local/hadoop/etc/hadoop
cp /vagrant/config-files/yarn-site.xml /usr/local/hadoop/etc/hadoop
cp /vagrant/config-files/hdfs-site.xml /usr/local/hadoop/etc/hadoop
cp /vagrant/config-files/mapred-site.xml.template /usr/local/hadoop/etc/hadoop
cp /vagrant/config-files/hduser.bashrc /home/hduser/.bashrc
cp /vagrant/config-files/hduser.bashrc /home/vagrant/.bashrc
cp /vagrant/config-files/masters /usr/local/hadoop/etc/hadoop/masters
cp /vagrant/config-files/slaves /usr/local/hadoop/etc/hadoop/slaves

###############################################################
# Format the hdfs system
pushd /home/hduser
 echo "format hdfs namenode"
 pwd
 source .bashrc
 hdfs namenode -format
popd
