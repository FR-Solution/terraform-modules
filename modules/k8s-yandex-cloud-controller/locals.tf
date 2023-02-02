locals {
  k8s_api_server_port = local.global_vars.kubernetes-ports.kube-apiserver-port-lb
  pod_cidr            = local.global_vars.k8s_network.pod_cidr
  cluster_name        = local.global_vars.cluster_metadata.cluster_name
}