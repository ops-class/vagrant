# -*- mode: ruby -*-
# vi: set ft=ruby :
  
VAGRANT_COMMAND = ARGV[0]

Vagrant.configure(2) do |config|

  config.vm.box = "minimal/trusty64"
  config.vm.hostname = "zion"

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "src", "/home/trinity/src", create: true

  if Vagrant.has_plugin?("vagrant-timezone")
    config.timezone.value = :host
  end
  
  config.vm.provider "virtualbox" do |v|
    # 24 Dec 2015 : GWA : This is a fairly lightweight configuration. Feel
    # free to beef it up to improve performance as needed.
    v.name = "ops-class.org 1.0"
    v.cpus = "1"
    v.memory = "512"
    # 24 Dec 2015 : GWA : Uncomment this if you want a GUI environment.
    # vb.gui = true
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
		v.customize ["modifyvm", :id, "--usb", "off"]
		v.customize ["modifyvm", :id, "--usbehci", "off"]
  end

  config.vm.provision "file", source: ".provision/sharedfolders.conf", destination: "/tmp/sharedfolders.conf"
  config.vm.provision "file", source: ".provision/.bashrc", destination: "/tmp/.bashrc"
  config.vm.provision "shell",  path: ".provision/provision.sh"
  
  if VAGRANT_COMMAND == "ssh"
    config.ssh.username = "trinity"
  end
end
