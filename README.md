## General

This repo is the answer for a OPS: [Ansible](https://www.ansible.com/): 1 task

**run_machine.tf**
1. Creates VPS in DigitalOcean
2. Deploys local SSH public key to DigitalOcean account
3. Deploys stored SSH public key to VPS
4. Creates Ansible playbook using ``inventory.tpl``template file

**nginx.yaml**
1. Installs [nginx](https://nginx.org) webserver

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

or you can store variables values in external ``sample.tfvars`` file:
```
do_token = sample
ssh_keyfile = sample.pub
```
and run these:
```
 $ terraform init
 $ terraform plan -var-file=sample.tfvars
 $ terraform apply -var-file=sample.tfvars
```
To destroy:

``$ terraform destroy  -var-file=sample.tfvars``

### Configuring the machine
TODO
