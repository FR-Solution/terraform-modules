locals {
  k8s-addresses-main = {
    base_kube_apiserver_lb_fqdn         = format("%s.%s.%s", "api"     , local.base.cluster_name, local.base.base_domain)
    base_kube_apiserver_lb_fqdn_local   = format("%s.%s.%s", "api-int" , local.base.cluster_name, local.base.base_domain)
  }
  k8s-addresses = {
    local_api_address                   = format("%s.1",  join(".", slice(split(".",local.base.service_cidr), 0, 3)) )
    dns_address                         = format("%s.10", join(".", slice(split(".",local.base.service_cidr), 0, 3)) )
    idp_provider_fqdn                   = format("auth.%s"             , local.base.base_domain)
    base_cluster_fqdn                   = format("%s.%s"               , local.base.cluster_name, local.base.base_domain)
    wildcard_base_cluster_fqdn          = format("%s.%s.%s", "*"       , local.base.cluster_name, local.base.base_domain)
    etcd_server_lb_fqdn                 = format("%s.%s.%s", "etcd"    , local.base.cluster_name, local.base.base_domain)

    kube_apiserver_lb_fqdn_local  = try(var.extra_args.kube_apiserver_lb_fqdn_local, null) == null ? local.k8s-addresses-main.base_kube_apiserver_lb_fqdn_local : var.extra_args.kube_apiserver_lb_fqdn_local
    kube_apiserver_lb_fqdn        = try(var.extra_args.kube_apiserver_lb_fqdn, null)       == null ? local.k8s-addresses-main.base_kube_apiserver_lb_fqdn       : var.extra_args.kube_apiserver_lb_fqdn

    pod_cidr        = try(var.extra_args.pod_cidr, null)       == null ? "10.0.0.0/16" : var.extra_args.pod_cidr
    node_cidr_mask  = try(var.extra_args.node_cidr_mask, null) == null ? "24"          : var.extra_args.node_cidr_mask

  }
}
