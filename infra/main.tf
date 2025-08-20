terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.52.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "central" {
  name        = "central-server"
  image       = "ubuntu-24.04"
  server_type = "cx22"
  location    = "fsn1"
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  ssh_keys    = [var.ssh_key_name]
}

output "server_ip" {
  value = hcloud_server.central.ipv4_address
}
