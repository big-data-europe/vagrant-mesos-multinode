# -*- mode: ruby -*-
# vi: set ft=ruby :

MASTERGUI = true

SLAVERAM = 2048
MASTERRAM = 4096

NETWORK = "192.168.0."
NETMASK = "255.255.255.0"

MASTERBOX="box-cutter/ubuntu1404-desktop"
MASTERBUILD="bootstrap-master.sh"

SLAVEBOX="ubuntu/trusty64"
SLAVEBUILD="bootstrap-mesoshdfsnode.sh"

# #############################################################################
# The list of machines to be created. This should list all the optional things
# 
MACHINES = {
  "master1" => [NETWORK+"10",MASTERRAM,MASTERGUI,MASTERBOX,"1",MASTERBUILD],
  "master2" => [NETWORK+"11",SLAVERAM,MASTERGUI,MASTERBOX,"2",MASTERBUILD],
  "slave1"  => [NETWORK+"5",SLAVERAM,false,SLAVEBOX,"3",SLAVEBUILD],
  "slave2"  => [NETWORK+"6",SLAVERAM,false,SLAVEBOX,"4",SLAVEBUILD]
}

Vagrant.configure(2) do |config|
  
 # Always share the parent folder.
 MACHINES.each do | (name, cfg) |
   ipaddr, ram, gui, box, id, build = cfg

   # For each of the machines create with the required configurations.
   
   config.vm.define name do |smachine|
      smachine.vm.synced_folder ".", "/vagrant"
      smachine.vm.box     = box
      smachine.vm.network "public_network", ip: ipaddr, :netmask => NETMASK
      smachine.vm.hostname = name
      smachine.vm.provision :shell, path: build, args: [id,ipaddr]
      smachine.vm.provider "virtualbox" do |svbox|
        svbox.name   = "vm"+name
        svbox.gui    = gui
        svbox.memory = ram
        svbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        svbox.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      end
     end
   end
end
