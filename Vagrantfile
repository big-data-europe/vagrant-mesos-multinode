# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.define "master" do |master|
    master.vm.box = "box-cutter/ubuntu1404-desktop"
    master.vm.provision :shell, path: "bootstrap.sh"
    master.vm.synced_folder ".", "/vagrant"
    master.vm.provider "virtualbox" do |mvm|
      mvm.name = "VagrantHadoopMultiMaster"
      mvm.gui = true
      mvm.customize ["modifyvm", :id, "--memory", 4096]
      mvm.customize ["modifyvm", :id, "--vram", 64]
      mvm.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      mvm.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      mvm.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      mvm.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
      # Customize the amount of memory on the VM:
      mvm.memory = "4096"
    end
  end

  config.vm.define "slave1" do |slave1|
    slave1.vm.box = "box-cutter/ubuntu1404-desktop"
    slave1.vm.provision :shell, path: "bootstrap.sh"
    slave1.vm.synced_folder ".", "/vagrant"
    slave1.vm.provider "virtualbox" do |svm1|
      svm1.name = "VagrantHadoopMultiSlave1"
      svm1.gui = true
      svm1.customize ["modifyvm", :id, "--memory", 4096]
      svm1.customize ["modifyvm", :id, "--vram", 64]
      svm1.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      svm1.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      svm1.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      svm1.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
      # Customize the amount of memory on the VM:
      svm1.memory = "4096"
    end
  end
  
end
