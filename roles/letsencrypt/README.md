# Ansible NGINX role

This role generates ACME SSL certificates and configures NGINX Open Source on your target host to use HTTPS.

## Role dependencies
This role require the following roles, that will be applied:
* ``base``
* ``packages``
* ``www``

## Role Variables

This role has several variables. The defaults are the following:
```
letsencrypt_remaining_days: 15
nginx_root_dir: "/var/www"
ssl_key_dir: "/etc/ssl/certs"
domain_name: ""
fqdn: ""
```

