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
  count  = "${var.nbr}"
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
  records = ["${element(digitalocean_droplet.www.*.ipv4_address,count.index)}"]
}

output "instance_ipv4_addr" {
  value = digitalocean_droplet.www.*.ipv4_address
  description = "IP address of created VPS"
}

locals {
  ids = range(1,var.nbr+1)
}

resource "local_file" "ansible_inventory" {
  count = "${var.nbr}"
content = "web:\n    hosts:\n${join("\n",
            formatlist(
              "        %s:\n            ansible_host: %s\n            fqdn: %s\n            vpn_ip: 10.1.0.%s/32",
              aws_route53_record.farstone.*.fqdn,
              digitalocean_droplet.www.*.ipv4_address,
              aws_route53_record.farstone.*.fqdn,
              local.ids))}\n"   
filename = "invent.yml"
}
