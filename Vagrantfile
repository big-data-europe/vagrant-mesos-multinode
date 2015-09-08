# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.network "private_network", type: "dhcp"
  
  config.vm.define "master" do |master|
    master.vm.box = "box-cutter/ubuntu1404-desktop"
    master.vm.provision :shell, path: "bootstrap-master.sh"
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

  config.vm.define "hadoopnode1" do |hadoopnode1|
    hadoopnode1.vm.box = "box-cutter/ubuntu1404-desktop"
    hadoopnode1.vm.provision :shell, path: "bootstrap-hadoopnode.sh"
    hadoopnode1.vm.synced_folder ".", "/vagrant"
    hadoopnode1.vm.provider "virtualbox" do |svm1|
      svm1.name = "VagrantHadoopMultiHadoopnode1"
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

  config.vm.define "hadoopnode2" do |hadoopnode2|
    hadoopnode2.vm.box = "box-cutter/ubuntu1404-desktop"
    hadoopnode2.vm.provision :shell, path: "bootstrap-hadoopnode.sh"
    hadoopnode2.vm.synced_folder ".", "/vagrant"
    hadoopnode2.vm.provider "virtualbox" do |svm1|
      svm1.name = "VagrantHadoopMultiHadoopnode2"
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
