## General

This repo is the answer for a OPS: [Ansible](https://www.ansible.com/): 8 task.
Ansible playbook, used in this repo uses three roles:
* **base** - provides basic OS configuration
* **packages** - is used to install chosen packages
* **www** - installs nginx (using depended packages role), generates and pushes
``nginx.conf`` and ``vhost.conf`` files for HTTP.
* **letsencrypt** - generates and pushes SSL certificates, generates and pushes
``vhost.conf`` files for HTTPS.

### Requirements
* [Terraform](https://www.terraform.io) >= 0.12
* [Ansible](https://www.ansible.com/) >=2.8

**run_machine.tf**
1. Creates VPS in DigitalOcean with Debian 10
2. Deploys local SSH public key to DigitalOcean account
3. Deploys stored SSH public key to VPS
4. Creates Ansible inventory file ``invent.yml`` using ``inventory.tpl`` template file
5. Creates domain names in AWS and links it to created VPS.
6. Runs Ansible playbook with inventory file created

**nginx.yaml**
1. Installs [nginx](https://nginx.org) webserver using apt or yum depending on OS family
2. Uploads ``nginx.conf`` configuration file, generated according to template.
3. Uploads single vhost configuration file, generated according to template.
4. Reloads nginx configuration
5. Generates SSL certificates
6. Uploads vhost configuration file for  HTTPS, generated according to template.

## Usage
**run_machine.tf** Terraform configuration file uses variables, stored in ``terraform.tfvars``:
* **do_token**  - Token for DigitalOcean account
* **ssh_keyfile** - Fullpath to the public SSH keyfile
* **aws_access_key** - AWS access key
* **aws_secret_key** - AWS secret key
* **domain** - top domain name
* **nbr** - Amount of domain names needed
* **hostname** - Base hostname of virtual hosts

>Please, replace **"sample"** with your data.

### Running the machine

Fill ``terraform.tfvars`` file with correct variable values  and run these:
```
 $ terraform init
 $ terraform plan
 $ terraform apply
```
To destroy:

``$ terraform destroy``

As a result you'll get a ``invent.yml`` file generated after instance run and ready to be used by Ansible.  Ansible 
playbook ``nginx.yaml`` will be run also.

### Configuring the machine

Run these:
```
$ ansible-playbook nginx.yaml -i invent.yml -u root
```
This will install nginx using apt and upload valid config files.

