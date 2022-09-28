resource "linode_lke_cluster" "my-cluster" {
    label       = "lke-cluster"
    k8s_version = "1.21"
    region      = "us-central"
    pool {
        type  = "g6-standard-2"
        count = 3
    }
}