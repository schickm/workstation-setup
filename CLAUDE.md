# Code style
Use ansible_facts, don't use top-level injected vars (eg. ansible_env.home)
Use "become: true" for privileged operations

# Validation
Always run `ansible-lint` on any new or modified Ansible code before considering the task complete

