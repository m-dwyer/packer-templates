#!/usr/bin/env bash

wget https://apt.puppetlabs.com/puppetlabs-release-jessie.deb
dpkg -i puppetlabs-release-jessie.deb
apt-get update
apt-get -y install puppet
