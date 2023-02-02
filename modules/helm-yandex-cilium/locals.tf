locals {
  k8s_api_server      = var.global_vars.k8s-addresses.kube_apiserver_lb_fqdn
  k8s_api_server_port = var.global_vars.kubernetes-ports.kube-apiserver-port-lb
  cluster_name        = var.global_vars.cluster_metadata.cluster_name
}