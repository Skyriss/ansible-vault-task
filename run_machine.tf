terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = "~> 2.31"
  }
}

#Variables
variable "do_token" {}
variable "ssh_keyfile" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "domain" {}
variable "nbr" {}
variable "hostname" {}

#Providers
provider "digitalocean" {
  token = var.do_token
}
provider "aws" {
  region = "eu-central-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  
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

#Get DNS zone
data "aws_route53_zone" "selected" {
  name = "${var.domain}"
}

#Add new DNS record
resource "aws_route53_record" "farstone" {
  count = "${var.nbr}"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.hostname}${count.index}.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = ["${digitalocean_droplet.www.ipv4_address}"]
}

output "instance_ipv4_addr" {
  value = digitalocean_droplet.www.ipv4_address
  description = "IP address of created VPS"
}

output "inventory" {
  value = data.template_file.ansible_inventory.rendered
}
