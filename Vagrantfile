# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define 'wordpress' do |wp|
    wp.vm.box = "generic/ubuntu2004"
    wp.ssh.insert_key = false
    wp.ssh.username = "vagrant"
    wp.vm.network "private_network", ip: "192.168.56.2"
    wp.vm.hostname = "wordpress"
    wp.vm.synced_folder ".", "/vagrant"
    wp.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 1024
      vb.linked_clone = false
    end

    wp.vm.provision "shell", path: "setup_wordpress.sh"
  end
end
