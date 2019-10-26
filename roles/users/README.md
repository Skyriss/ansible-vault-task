# Ansible NGINX role

This role generates users for system.

## Role dependencies
This role require the following roles, that will be applied:
* ``base``

## Role Variables

This role has several variables. The defaults are the following:
```
users:
  - name: nickname
    comment: John Doe
    groups: ['sudo']
    ssh_keys:
      - key: "ssh-rsa xxx nickname"
        state: present
```

