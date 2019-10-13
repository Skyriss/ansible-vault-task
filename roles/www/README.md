# Ansible NGINX role

This role installs NGINX Open Source on your target host, generates and installs configuration files.


## Role Variables

This role has several variables. The defaults are the following:
```
domain_name: ""
host_params:
  - hostname: "_"
    port: "80"
```
Example: For ``john.doe.example.com`` fqdn, you need to have ``domain_name: "example.com"`` and
```
host_params:
  - hostname: "john.doe"
    port: "80"
```

