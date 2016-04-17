#!/usr/bin/env bash

wget https://apt.puppetlabs.com/puppetlabs-release-pc1-wily.deb
sudo dpkg -i puppetlabs-release-pc1-wily.deb
sudo apt-get update
sudo apt-get -y install puppet
