## General

This repo is the answer for a OPS: [Ansible](https://www.ansible.com/): 10 task.
Ansible playbook, used in this repo uses following roles:
* **base** - provides basic OS configuration
* **packages** - is used to install chosen packages
* **www** - installs nginx (using depended packages role), generates and pushes
``nginx.conf`` and ``vhost.conf`` files for HTTP.
* **ssl** - pushes existing SSL certificates if exists and geberates ``vhost.conf`` files 
for HTTPS.
* **letsencrypt** - generates and pushes SSL certificates, generates and pushes
``vhost.conf`` files for HTTPS.
* **mawalu.wireguard_private_networking** - creates a VPN server

### Requirements
* [Terraform](https://www.terraform.io) >= 0.12
* [Ansible](https://www.ansible.com/) >=2.8
* Debian OS
* [mawalu.wireguard_private_networking](https://galaxy.ansible.com/mawalu/wireguard_private_networking) 
ansible role
> Installing: ``ansible-galaxy install --roles-path %project_root%/roles mawalu.wireguard_private_networking``

> Note: You need to configure inventory file according to Readme for ``mawalu.wireguard_private_networking`` role.
> If you use inventory file via ``run_machine.tf``, inventory file is ready to use.

### Workflow overview

**run_machine.tf**
1. Creates VPS in DigitalOcean with Debian 10
2. Deploys local SSH public key to DigitalOcean account
3. Deploys stored SSH public key to VPS
4. Creates Ansible inventory file ``invent.yml`` using ``inventory.tpl`` template file
5. Creates domain names in AWS and links it to created VPS.
6. Runs Ansible playbook with inventory file created

**nginx.yaml**
1. Creates user
2. Pushes existing secret SSH key
3. Installs [nginx](https://nginx.org) webserver using apt or yum depending on OS family
4. Uploads ``nginx.conf`` configuration file, generated according to template.
5. Uploads single vhost configuration file, generated according to template.
6. Reloads nginx configuration
7. Configures HTTPS:
7.1 Pushes existing SSL certificates
7.2 Generates SSL certificates if there is no existing
8. Uploads vhost configuration file for  HTTPS, generated according to template.
9. Installs all common software
10. Creates a VPN between nodes

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

### Running the machine(s)

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

### Configuring the machine(s)

Run these:
```
$ ansible-playbook nginx.yaml -i invent.yml -u root --vault-id inline@prompt --vault-id files@prompt
```
> Due to this playbook have encrypted passwords, you'll need to input password for inline and files vault-ids


