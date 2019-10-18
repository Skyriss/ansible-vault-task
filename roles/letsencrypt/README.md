# Ansible NGINX role

iThis role generates ACME SSL certificates and configures NGINX Open Source on your target host to use HTTPS.


## Role Variables

This role has several variables. The defaults are the following:
```
letsencrypt_remaining_days: 15
nginx_root_dir: "/var/www"
ssl_key_dir: "/etc/ssl/certs"
domain_name: ""
host_params:
  - hostname: ""
    nbr: 1
```
Example: For ``john.doe0.example.com`` .. ``john.doe1.example.com`` fqdn, you need to have ``domain_name: "example.com"`` and
```
host_params:
  - hostname: "john.doe"
    nbr: 2
```

