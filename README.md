
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

Then copy over the setup files:

```
scp -r -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null arch-installer root@<machine ip addr>
```

Then run the installer:

```
ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@<machine ip addr> "cd ~/arch-installer && sh bootstrap_install.sh"
```

## Setting up a Mac

Clone repo and execute `setup_ansible.sh` for installing ansible on macos and triggering workstation setup

This may or may not still work, as I'm switching over to Linux is a daily driver.

# Known areas not handled

## arch-laptop

setup of 1Password cli
Should I make inventory part of gitignore?
