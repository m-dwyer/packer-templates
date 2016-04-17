#!/usr/bin/env bash

wget https://apt.puppetlabs.com/puppetlabs-release-pc1-wily.deb
dpkg -i puppetlabs-release-pc1-wily.deb
apt-get update
apt-get -y install puppet
