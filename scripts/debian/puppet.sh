#!/usr/bin/env bash

wget https://apt.puppetlabs.com/puppetlabs-release-jessie.deb
sudo dpkg -i puppetlabs-release-jessie.deb
sudo apt-get update
sudo apt-get -y install puppet
