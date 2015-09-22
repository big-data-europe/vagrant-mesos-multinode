# -*- mode: ruby -*-
# vi: set ft=ruby :

GUI = false

RAM = 2048
SLAVERAM = 2048
MASTERRAM = 4096

NETWORK = "192.168.1."
NETMASK = "255.255.255.0"

MASTERBOX="box-cutter/ubuntu1404-desktop"
SLAVEBOX="ubuntu/trusty64"

MASTERS = {
  "master1" => [NETWORK+"10",MASTERRAM,GUI,MASTERBOX,"1"],
  "master2" => [NETWORK+"11",MASTERRAM,GUI,MASTERBOX,"2"]
}

SLAVES = {
  "slave1" => [NETWORK+"1",SLAVERAM,SLAVEBOX],
  "slave2" => [NETWORK+"2",SLAVERAM,SLAVEBOX]
}

Vagrant.configure(2) do |config|
  SLAVES.each do | (name, cfg) |
    ipaddr, ram, box, id = cfg

    config.vm.define name do |machine|
      machine.vm.box     = box
      machine.vm.guest = :debian
      machine.vm.provider "virtualbox" do |vbox|
        vbox.gui    = false
        vbox.memory = ram
        vbox.customize ["modifyvm", :id, "--vram", 64]
        # vbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        # vbox.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      end
      machine.vm.hostname = name
      machine.vm.network 'private_network', ip: ipaddr, netmask: NETMASK
      machine.vm.provision :shell,
                           path: "bootstrap-mesoshdfsnode.sh",
                           args: id
      machine.vm.synced_folder ".", "/vagrant"
    end
  end

  MASTERS.each do | (name, cfg) |
    ipaddr, ram, gui, box, id = cfg

    config.vm.define name do |machine|
      machine.vm.box     = box
      machine.vm.guest = :debian
      machine.vm.provider "virtualbox" do |vbox|
        vbox.gui    = gui
        vbox.memory = ram
        vbox.customize ["modifyvm", :id, "--vram", 64]
        # vbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        # vbox.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      end
      machine.vm.hostname = name
      machine.vm.network 'private_network', ip: ipaddr, netmask: NETMASK
      machine.vm.provision :shell,
                           path: "bootstrap-master.sh",
                           args: id
      machine.vm.synced_folder ".", "/vagrant"
    end
  end
end
