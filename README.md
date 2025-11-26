
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

# TUI tools installed by roles

| thing        | cli app |
| ---          | ---     |
| git          | tig     |
| bluetooth    | bluetui |
| audio mixing | wiremix |


## Updating Arch machine

```
ansible-playbook -i local-inventory.yml --extra-vars=ansible_sudo_pass=(op read "op://Private/rwgps laptop - matt/password") arch-laptop.yml --tags=some-tag
```

## Setting up on Arch Live ISO ('arch-install' role)

All that is required is setting a root password once logged in to the live ISO:

```
passwd
```

Tasks are all gated behind 'never' tag, so tag needs to be explicitly invoked:

When running ansible, be sure to disable host key checking, since the key is going to shift after install anyways:

```
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i local-inventory.yml --extra-vars=ansible_ssh_password=root file-server-arch.yml --tags=arch-install
```
Currently this isn't fully done.  Implemented so far:

1. Simple partitioning of swap and root partition, but in the future these would be the minimum required:

## Setting up a Mac

Clone repo and execute `setup_ansible.sh` for installing ansible on macos and triggering workstation setup

This may or may not still work, as I'm switching over to Linux is a daily driver.

# Known areas not handled

## arch-laptop

setup of 1Password cli
Should I make inventory part of gitignore?
