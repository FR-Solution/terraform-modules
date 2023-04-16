locals {
  k8s_api_server      = var.global_vars.k8s-addresses.kube_apiserver_lb_fqdn
  k8s_api_server_port = var.global_vars.kubernetes-ports.kube-apiserver-port-lb
  cluster_name        = var.global_vars.cluster_metadata.cluster_name

  base_values =  yamldecode(templatefile("${path.module}/helm/values.yaml.tftpl", {
    k8s_api_server_fqdn     = local.k8s_api_server
    k8s_api_server_port     = local.k8s_api_server_port
    cluster_name            = local.cluster_name
  }))

  merge_values = merge(local.base_values, var.extra_values.extra_values)
}