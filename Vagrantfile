# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"

  config.vm.define "master" do |master|
    master.vm.network "private_network", ip: "192.168.10.32"
    master.vm.network "forwarded_port", guest: 443, host: 4433
    master.vm.provision :hosts, :sync_hosts => true
    master.vm.provider "virtualbox" do |vb|
      vb.memory = "6144"
    end
  end

  (1..8).each do |i|
    config.vm.define "bionic-agent-#{i}" do |agent|
      agent.vm.network "private_network", ip: "192.168.10.#{i}"
      agent.vm.provision :hosts, sync_hosts: true
      agent.vm.provider "virtualbox" do |vb|
        vb.memory = "512"
      end
    end
  end
end
