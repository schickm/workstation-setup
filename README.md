
# Setup

Install ansible

```
# Arch
pacman -S ansible
```

Install required community packages
```
ansible-galaxy install -r requirements.yml
```

## Updating Arch machine

```
ansible-playbook -i local-inventory.yml --extra-vars=ansible_sudo_pass=(op read "op://Private/rwgps laptop - matt/password") arch-laptop.yml --tags=some-tag
```

## Setting up on Arch Live ISO

Currently this isn't setup, but in the future these would be the minimum required:

1. Clone repo on machine that is executing ansible.
1. Do bare minimum on Arch to allow Ansible to use it as a target
  - setup a root password: `passwd`
  - install python: `pacman -S python`
## Setting up a Mac

Clone repo and execute `setup_ansible.sh` for installing ansible on macos and triggering workstation setup

This may or may not still work, as I'm switching over to Linux is a daily driver.

# Known areas not handled

## arch-laptop

setup of 1Password cli
Should I make inventory part of gitignore?
