# -*- mode: ruby -*-
# vi: set ft=ruby :
def is_arm64()
  `uname -m` == "arm64" || `/usr/bin/arch -64 sh -c "sysctl -in sysctl.proc_translated"`.strip() == "0"
end

Vagrant.configure("2") do |config|
  config.vm.define 'wordpress' do |wp|
    config.vm.box = "starboard/ubuntu-arm64-20.04.5"
    config.vm.box_version = "20221120.20.40.0"
    config.vm.box_download_insecure = true
    config.vm.provider "vmware_desktop" do |v|
        v.ssh_info_public = true
        v.gui = true
        v.linked_clone = false
        v.vmx["ethernet0.virtualdev"] = "vmxnet3"
    end

    wp.vm.provision "shell", path: "setup_wordpress.sh"
  end
  # config.vm.define 'wordpress' do |wp|
  # if is_arm64()
  #   config.vm.box = "net9/ubuntu-24.04-arm64"
  #   config.vm.box_version = "1.1"
  # elsif `uname -m` == "x86_64"
  #   config.vm.box = 'bento/ubuntu-20.04'
  # end
  #   # wp.ssh.insert_key = false
  #   wp.ssh.username = "vagrant"
  #   wp.vm.network "private_network", ip: "192.168.50.2"
  #   wp.vm.hostname = "wordpress"
  #   wp.vm.synced_folder ".", "/vagrant"
  #   wp.vm.provider "virtualbox" do |vb|
  #     vb.gui = false
  #     vb.memory = 1024
  #     vb.linked_clone = false
  #   end
  #
  #   wp.vm.provision "shell", path: "setup_wordpress.sh"
  # end
end
