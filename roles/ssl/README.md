# Ansible SSL role

This role copies local SSL certificate to target NGINX server and configures NGINX Open Source on your target host to use HTTPS.

## Role dependencies
This role require the following roles, that will be applied:
* ``base``
* ``packages``
* ``www``

## Role Variables

This role has several variables. 
```
nginx_root_dir: "/var/www"
ssl_key_dir: "/etc/ssl/certs"
fqdn: ""
```

