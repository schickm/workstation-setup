#!/bin/sh
# Targetted to "recent" macos
brew install ansible
ansible-playbook -i inventory.yml workstation.yml
