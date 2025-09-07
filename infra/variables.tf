variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "ssh_key_name" {
  description = "The name of the SSH key uploaded in Hetzner Cloud"
  type        = string
}
