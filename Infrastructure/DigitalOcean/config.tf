provider "digitalocean" {
  token = var.DIGITAL_OCEAN_TOKEN
}


terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  cloud {
    organization = "Ayman-Organization"
    workspaces {
      name = "DigitalOcean_Kubernetes"
    }
  }
}

