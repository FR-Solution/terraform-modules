locals {
  k8s_api_server_port = var.global_vars.kubernetes-ports.kube-apiserver-port-lb
  pod_cidr            = var.global_vars.k8s_network.pod_cidr
  cluster_name        = var.global_vars.cluster_metadata.cluster_name
}