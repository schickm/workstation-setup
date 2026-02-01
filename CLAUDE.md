# Code style
Use ansible_facts, don't use top-level injected vars (eg. ansible_env.home)
Use "become: true" for privileged operations
For AUR packages, use "become_user: aur_builder" (set up by ansible-prerequisites role)

# Validation
Always run `ansible-lint` on any new or modified Ansible code before considering the task complete

