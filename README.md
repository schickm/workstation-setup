
## Updating Arch machine



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

 * setup of Fisher (package manager for fish shell)
     * fisher_plugins file is not checked into source either
 * installation of nvm.fish package (via fisher)
