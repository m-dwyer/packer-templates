#!/usr/bin/env bash

apt-get -y install ca-certificates
wget https://apt.puppetlabs.com/puppetlabs-release-jessie.deb
dpkg -i puppetlabs-release-jessie.deb
apt-get update
apt-get -y install puppet
