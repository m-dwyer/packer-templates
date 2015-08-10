# packer-templates

## Intro

Some basic Packer templates for generating Vagrant boxes.

## Requirements

Packer (>= 0.8 to use WinRM communicator with Windows templates)
Vagrant

## Usage

git clone https://github.com/m-dwyer/packer-templates.git
cd packer-templates/
packer build $OS_NAME.json
vagrant box add boxes/$OS_NAME.box --name=$OS_NAME

vagrant init $OS_NAME
vagrant up
