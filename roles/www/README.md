# Ansible NGINX role

This role installs NGINX Open Source on your target host, generates and installs configuration files.

## Role dependencies
This role require the following roles, that will be applied:
* ``base``
* ``packages``

## Role Variables

This role has several variables. The defaults are the following:
```
nginx_root_dir: "/var/www"
domain_name: ""
fqdn:
nginx_sendfile_status: "on"
nginx_tcp_nopush_status: "on"
nginx_tcp_nodelay_status: "on"
nginx_max_connections: 1024
```
