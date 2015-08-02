#!/usr/bin/env bash

sudo yum -y install bzip2
sudo yum -y --enablerepo=epel install dkms
sudo yum -y install kernel-devel-`uname -r`
sudo yum -y install gcc

mkdir /tmp/virtualbox
mount -o loop /home/vagrant/VBoxGuestAdditions.iso /tmp/virtualbox
sh /tmp/virtualbox/VBoxLinuxAdditions.run
umount /tmp/virtualbox
rm -rf /tmp/virtualbox
rm -f /home/vagrant/VBoxGuestAdditions.iso
