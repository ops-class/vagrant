# -*- mode: ruby -*-
# vi: set ft=ruby :
  
VAGRANT_COMMAND = ARGV[0]

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "zion"

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "src", "/home/trinity/src", create: true

  if Vagrant.has_plugin?("vagrant-timezone")
    config.timezone.value = :host
  end
  
  config.vm.provider "virtualbox" do |v|
    # 24 Dec 2015 : GWA : This is a fairly lightweight configuration. Feel
    # free to beef it up to improve performance as needed.
    v.name = "OS161 Student"
    v.cpus = "1"
    v.memory = "512"
    # 24 Dec 2015 : GWA : Uncomment this if you want a GUI environment.
    # vb.gui = true
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.vm.provision "shell",  inline: <<-SHELL
    # 24 Dec 2015 : GWA : Install OS/161 toolchain and Git.
    add-apt-repository ppa:geoffrey-challen/os161-toolchain
    apt-get update 
    apt-get install -y os161-toolchain git git-doc
    apt-get autoremove -y

    # 24 Dec 2015 : GWA : Bootstrap trinity user.
    useradd trinity -m -s /bin/bash
    rsync -a /etc/skel/ /home/trinity/

    mkdir /home/trinity/.ssh
    cp /home/vagrant/.ssh/authorized_keys /home/trinity/.ssh/
    chmod 0700 /home/trinity/.ssh
    
    echo "trinity ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/trinity
    
    cp /home/vagrant/.bashrc /home/trinity/
    touch /home/trinity/.hushlogin
    mkdir -p /home/trinity/root
    cp /usr/share/examples/sys161/sys161.conf.sample /home/trinity/root/sys161.conf
    chown trinity:trinity -R /home/trinity/
    
    # 24 Dec 2015 : GWA : Try to speed up SSH. Doesn't help much.
    echo >> /etc/ssh/sshd_config
    echo "UseDNS no" >> /etc/ssh/sshd_config
    echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config
    service ssh reload

    cat "America/New_York" > /etc/timezone
    dpkg-reconfigure --frontend noninteractive tzdata
   
    # 24 Dec 2015 : GWA : Remount shared folders with correct ownership.
    mount -t vboxsf -o uid=`id -u trinity`,gid=`id -g trinity` home_trinity_src /home/trinity/src
    updatedb
  SHELL
  
  if VAGRANT_COMMAND == "ssh"
    config.ssh.username = "trinity"
  end
end
