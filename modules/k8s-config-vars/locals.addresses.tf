locals {
  cluster_metadata = {
    cluster_name    = try(var.extra_args.cluster_name, null)   == null ? "default"        : var.extra_args.cluster_name
    base_domain     = try(var.extra_args.base_domain,  null)   == null ? "example.ru"     : var.extra_args.base_domain
  }

  k8s_network = {
    pod_cidr        = try(var.extra_args.pod_cidr,       null) == null ? "10.0.0.0/16"    : var.extra_args.pod_cidr
    node_cidr_mask  = try(var.extra_args.node_cidr_mask, null) == null ? "24"             : var.extra_args.node_cidr_mask
    service_cidr    = try(var.extra_args.service_cidr,   null) == null ? "172.16.0.0/16"  : var.extra_args.service_cidr
  }

  k8s-addresses-main = {
    base_kube_apiserver_lb_fqdn         = format("%s.%s.%s", "api"     , local.cluster_metadata.cluster_name, local.cluster_metadata.base_domain)
    base_kube_apiserver_lb_fqdn_local   = format("%s.%s.%s", "api-int" , local.cluster_metadata.cluster_name, local.cluster_metadata.base_domain)
  }

  k8s-addresses = {
    local_api_address                   = format("%s.1",  join(".", slice(split(".",local.k8s_network.service_cidr), 0, 3)) )
    dns_address                         = format("%s.10", join(".", slice(split(".",local.k8s_network.service_cidr), 0, 3)) )

    idp_provider_fqdn                   = format("auth.%s"          , local.cluster_metadata.base_domain)
    base_cluster_fqdn                   = format("%s.%s"            , local.cluster_metadata.cluster_name, local.cluster_metadata.base_domain)
    wildcard_base_cluster_fqdn          = format("%s.%s.%s", "*"    , local.cluster_metadata.cluster_name, local.cluster_metadata.base_domain)
    etcd_server_lb_fqdn                 = format("%s.%s.%s", "etcd" , local.cluster_metadata.cluster_name, local.cluster_metadata.base_domain)

    extra_cluster_name                  = substr(sha256(local.cluster_metadata.cluster_name), 0, 8)

    kube_apiserver_lb_fqdn_local  = try(var.extra_args.kube_apiserver_lb_fqdn_local, null) == null ? local.k8s-addresses-main.base_kube_apiserver_lb_fqdn_local : var.extra_args.kube_apiserver_lb_fqdn_local
    kube_apiserver_lb_fqdn        = try(var.extra_args.kube_apiserver_lb_fqdn,       null) == null ? local.k8s-addresses-main.base_kube_apiserver_lb_fqdn       : var.extra_args.kube_apiserver_lb_fqdn
  }

}
