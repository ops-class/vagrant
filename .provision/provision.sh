#!/bin/sh -e

# 24 Dec 2015 : GWA : Minimal box is very minimal. Use to get
# add-apt-repository, updatedb, tmux.
sudo apt-get install -y software-properties-common locate tmux bash-completion 
add-apt-repository ppa:geoffrey-challen/os161-toolchain > /dev/null 2>&1 && true
apt-get update 

# 24 Dec 2015 : GWA : Install OS/161 toolchain and Git.
apt-get install -y os161-toolchain git git-doc
apt-get autoremove -y

# 24 Dec 2015 : GWA : Bootstrap trinity user.
id -u trinity > /dev/null 2>&1
if [ $? -ne 0 ] ; then
	useradd trinity -u 10000 -m -s /bin/bash &>/dev/null
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

	echo "America/New_York" > /etc/timezone
	dpkg-reconfigure --frontend noninteractive tzdata 2>/dev/null
fi

# 24 Dec 2015 : GWA : Remount shared folders with correct ownership on
# every boot.
mv /tmp/sharedfolders.conf /etc/init/
chown root:root /etc/init/sharedfolders.conf
mount -t vboxsf -o uid=10000,gid=10000 home_trinity_src /home/trinity/src

updatedb
