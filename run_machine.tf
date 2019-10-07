terraform {
  required_version = ">= 0.12"
}

#Variables
variable "do_token" {}
variable "ssh_keyfile" {}

#Providers
provider "digitalocean" {
  token = var.do_token
}

#Data resource
data "digitalocean_ssh_key" "rebrain" {
  name = "REBRAIN.SSH.PUB.KEY"
}

# Create a new Web Droplet
resource "digitalocean_droplet" "www" {
  image  = "debian-10-x64"
  name   = "webserver"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.rebrain.id,digitalocean_ssh_key.local.id]
  tags = ["alex","glazkov","alexfarstone"]
}

# Deploy a SSH key
resource "digitalocean_ssh_key" "local" {
  name       = "FarStone pub key"
  public_key = file(var.ssh_keyfile)
}

resource "null_resource" "generate_inventfile" {
  provisioner "local-exec" {
    command = "echo \"${data.template_file.ansible_inventory.rendered}\" > invent.yml"
  }
  depends_on = [data.template_file.ansible_inventory]
}

data "template_file" "ansible_inventory" {
  template = file("inventory.tpl")
  vars = {
    hostname = digitalocean_droplet.www.name
    ip_address = digitalocean_droplet.www.ipv4_address
  }
  depends_on = [digitalocean_droplet.www]
}

resource "null_resource" "run_playbook" {
  provisioner "local-exec" {
    command = "ansible-playbook nginx.yaml -i invent.yml -u root"
  }
  depends_on = [null_resource.generate_inventfile]
}

output "instance_ipv4_addr" {
  value = digitalocean_droplet.www.ipv4_address
  description = "IP address of created VPS"
}

output "inventory" {
  value = data.template_file.ansible_inventory.rendered
}
