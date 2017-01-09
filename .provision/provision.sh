#!/bin/sh -e

# 24 Dec 2015 : GWA : Minimal box is very minimal. Use to get
# add-apt-repository, updatedb, tmux.
export DEBIAN_FRONTEND=noninteractive
APT_FLAGS="-y"
apt-get $APT_FLAGS update
apt-get $APT_FLAGS install software-properties-common locate tmux bash-completion man lsof iotop dos2unix
add-apt-repository ppa:ops-class/os161-toolchain > /dev/null 2>&1 && true
add-apt-repository ppa:git-core/ppa > /dev/null 2>&1 && true
apt-get $APT_FLAGS update
apt-get $APT_FLAGS upgrade
apt-get $APT_FLAGS install os161-toolchain git git-doc
apt-get $APT_FLAGS autoremove --purge

# 24 Dec 2015 : GWA : Bootstrap trinity user.
if ! id -u trinity > /dev/null 2>&1 ; then
	useradd trinity -u 10000 -m -s /bin/bash > /dev/null 2>&1
	rsync -a /etc/skel/ /home/trinity/

	mkdir /home/trinity/.ssh
	cp /home/vagrant/.ssh/authorized_keys /home/trinity/.ssh/
	chmod 0700 /home/trinity/.ssh

	echo "trinity ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/trinity

	touch /home/trinity/.hushlogin
	mv /tmp/.bashrc /home/trinity/
	dos2unix /home/trinity/.bashrc >/dev/null 2>&1
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
