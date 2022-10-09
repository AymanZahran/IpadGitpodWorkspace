resource "digitalocean_kubernetes_cluster" "do-cluster" {
  name    = "do-cluster"
  region  = "nyc1"
  version = "1.24.4-do.0"
  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}
