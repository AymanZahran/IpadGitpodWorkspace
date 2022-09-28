provider "linode" {
  token = var.LINODE_TOKEN
}

terraform {
  required_providers {
    digitalocean = {
      source = "linode/linode"
      version = "1.27.1"
    }
  }
  cloud {
    organization = "Ayman-Organization"
    workspaces {
      name = "Kubernetes"
    }
  }
}
