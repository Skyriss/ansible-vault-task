# Ansible NGINX role

This role installs NGINX Open Source on your target host, generates and installs configuration files.


## Role Variables

This role has several variables. The defaults are the following:
```
nginx_root_dir: "/var/www"
domain_name: ""
host_params:
  - hostname: "_"
  - nbr: 1
nginx_sendfile_status: "on"
nginx_tcp_nopush_status: "on"
nginx_tcp_nodelay_status: "on"
nginx_max_connections: 1024
```
> ``nginx_sendfile_status``,``nginx_tcp_nopush_status``,``nginx_tcp_nodelay_status`` available values are ``on`` or ``off``
Example: For ``john.doe0.example.com`` .. ``john.doe1.example.com`` fqdn, you need to have ``domain_name: "example.com"`` and
```
host_params:
  - hostname: "john.doe"
    nbr: 2
```
