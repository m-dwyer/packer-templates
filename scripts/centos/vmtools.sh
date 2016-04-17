#!/usr/bin/env bash

yum -y install bzip2
yum -y --enablerepo=epel install dkms
yum -y install kernel-devel-`uname -r`
yum -y install gcc

mkdir /tmp/virtualbox
mount -o loop /home/vagrant/VBoxGuestAdditions.iso /tmp/virtualbox
sh /tmp/virtualbox/VBoxLinuxAdditions.run
umount /tmp/virtualbox
rm -rf /tmp/virtualbox
rm -f /home/vagrant/VBoxGuestAdditions.iso
