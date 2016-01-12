#!/usr/bin/env bash
# Install docker stuff (and set it up for 

apt-get install -y apparmor lxc cgroup-lite
apt-get install -y docker.io
usermod -aG docker ${USER}
systemctl start docker
