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

resource "hcloud_firewall" "central_fw" {
  name = "central-firewall"

  # Allow SSH
  rule {
    description = "Allow SSH"
    direction   = "in"
    protocol    = "tcp"
    port        = "22"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }

  # Allow HTTP
  rule {
    description = "Allow HTTP"
    direction   = "in"
    protocol    = "tcp"
    port        = "80"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }

  # Allow HTTPS
  rule {
    description = "Allow HTTPS"
    direction   = "in"
    protocol    = "tcp"
    port        = "443"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }

  # Allow ICMP (ping)
  rule {
    description = "Allow ICMP"
    direction   = "in"
    protocol    = "icmp"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }

  # (Optional) Allow Kubernetes API externally
  # Only enable if you want to manage the cluster remotely
  # rule {
  #   description = "Allow Kubernetes API"
  #   direction   = "in"
  #   protocol    = "tcp"
  #   port        = "6443"
  #   source_ips  = ["YOUR_IP/32"]
  # }
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
  firewall_ids = [hcloud_firewall.central_fw.id] # attach firewall
}

output "server_ip" {
  value = hcloud_server.central.ipv4_address
}

output "server_ipv6" {
  value = hcloud_server.central.ipv6_address
}
