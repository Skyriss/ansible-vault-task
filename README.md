## General

This repo is the answer for a OPS: [Ansible](https://www.ansible.com/): 1 task

**run_machine.tf**
1. Creates VPS in DigitalOcean with Debian 10
2. Deploys local SSH public key to DigitalOcean account
3. Deploys stored SSH public key to VPS
4. Creates Ansible inventory file ``invent.yml`` using ``inventory.tpl`` template file

**nginx.yaml**
1. Installs [nginx](https://nginx.org) webserver
2. Uploads and reloads default nginx configuration
3. Reloads nginx configuration

## Usage
**run_machine.tf** Terraform configuration file uses variables:
* **do_token**  - Token for DigitalOcean account
* **ssh_keyfile** - Fullpath to the public SSH keyfile

>Please, replace **"sample"** with your data.

### Running the machine

Run these:
```
 $ terraform init
 $ terraform plan -var="do_token=sample" -var="ssh_keyfile=sample.pub"
 $ terraform apply -var="do_token=sample" -var="ssh_key_name=sample.pub"
```
To destroy:

``$ terraform destroy -var="do_token=sample" -var="ssh_key_name=sample.pub"``

or you can store variables values in external ``sample.terraform.tfvars`` file and rename it to ``terraform.tfvars``:
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

``$ terraform destroy

As a result you'll get a ``invent.yml` file generated after instance run and ready to be used by Ansible.

### Configuring the machine

Run these:
```
$ ansible-playbook nginx.yaml -i invent.yml
```
This will install nginx using apt.

