## General

This repo is the answer for a OPS: [Ansible](https://www.ansible.com/): 2 task

### Requirements
* [Terraform](https://www.terraform.io) >= 0.12
* [Ansible](https://www.ansible.com/) ~>2.5.1

**run_machine.tf**
1. Creates VPS in DigitalOcean with Debian 10
2. Deploys local SSH public key to DigitalOcean account
3. Deploys stored SSH public key to VPS
4. Creates Ansible inventory file ``invent.yml`` using ``inventory.tpl`` template file

**nginx.yaml**
1. Installs [nginx](https://nginx.org) webserver
2. Uploads ``nginx.conf`` configuration file, generated according to template from ``template``
directory
3. Uploads vhosts configuration files, generated according to templates from ``template``
directory
3. Reloads nginx configuration

## Usage
**run_machine.tf** Terraform configuration file uses variables, stored in ``terraform.tfvars``:
* **do_token**  - Token for DigitalOcean account
* **ssh_keyfile** - Fullpath to the public SSH keyfile

>Please, replace **"sample"** with your data.

### Running the machine

Replace ``sample`` in ``terraform.tfvars`` file with apropriate data
```
do_token = sample
ssh_keyfile = sample.pub
```
and run these:
```
 $ terraform init
 $ terraform plan
 $ terraform apply
```
To destroy:

``$ terraform destroy``

As a result you'll get a ``invent.yml`` file generated after instance run and ready to be used by Ansible.

### Configuring the machine

Run these:
```
$ ansible-playbook nginx.yaml -i invent.yml
```
This will install nginx using apt and upload valid config files.

