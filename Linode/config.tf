provider "linode" {
  token = var.LINODE_TOKEN
}

terraform {
  required_providers {
    digitalocean = {
      source = "linode/linode"
      version = "~> 2.0"
    }
  }
  cloud {
    organization = "Ayman-Organization"
    workspaces {
      name = "Kubernetes"
    }
  }
}
