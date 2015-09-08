#!/usr/bin/env bash
#################################################################
# Standard System Updates.
apt-get install -y xinit xterm iceweasel gnome-terminal gnome-shell
apt-get install -y dkms virtualbox-guest-dkms virtualbox-guest-x11
apt-get install -y gdm3 apache2 libapache2-mod-auth-cas debconf-utils dpkg-dev build-essential quilt gdebi
dpkg-reconfigure gdm3

# Now start to setup for building unified views, etc.
apt-get install -y openjdk-7-jre openjdk-7-jdk
apt-get install -y tomcat7 git maven bash emacs nano vim
apt-get install -y openssh-server
echo "JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64" >> /etc/default/tomcat7

###############################################################
# Create necessary addition users and groups (default passwords)
addgroup hadoop --disabled-password
adduser --ingroup hadoop hduser --disabled-password
adduser hduser sudo
echo "hduser:password" | chpasswd

# SSH key generation
su "( echo | ssh-keygen -t rsa -P \"\" ; cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys)" hduser

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
echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant
echo "hduser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/hduser

###############################################################
# Update required configuration files

pwd
cp /vagrant/config-files/hadoop-env.sh /usr/local/hadoop/etc/hadoop
cp /vagrant/config-files/core-site.xml /usr/local/hadoop/etc/hadoop
cp /vagrant/config-files/yarn-site.xml /usr/local/hadoop/etc/hadoop
cp /vagrant/config-files/hdfs-site.xml /usr/local/hadoop/etc/hadoop
cp /vagrant/config-files/mapred-site.xml.template /usr/local/hadoop/etc/hadoop
cp /vagrant/config-files/hduser.bashrc /home/hduser/.bashrc
cp /vagrant/config-files/masters /usr/local/hadoop/etc/hadoop/masters
cp /vagrant/config-files/slaves /usr/local/hadoop/etc/hadoop/slaves

###############################################################
# Format the hdfs system
source /home/hduser/.bashrc
hdfs namenode -format

x###############################################################
start-dfs.sh
start-yarn.sh
jps

###############################################################
# Run the example suggested
hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.1.jar pi 2 5

###############################################################
apt-get autoclean
echo "****** done with bootstrap"
###############################################################

