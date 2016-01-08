#!/bin/sh -e

# 24 Dec 2015 : GWA : Install OS/161 toolchain and Git.
add-apt-repository ppa:geoffrey-challen/os161-toolchain
apt-get update 
apt-get install -y os161-toolchain git git-doc
apt-get autoremove -y

# 24 Dec 2015 : GWA : Bootstrap trinity user.
useradd trinity -u 10000 -m -s /bin/bash
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
dpkg-reconfigure --frontend noninteractive tzdata

# 24 Dec 2015 : GWA : Remount shared folders with correct ownership on
# every boot.
mv /tmp/sharedfolders.conf /etc/init/
chown root:root /etc/init/sharedfolders.conf
mount -t vboxsf -o uid=10000,gid=10000 home_trinity_src /home/trinity/src

updatedb
