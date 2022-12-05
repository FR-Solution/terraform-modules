locals {
  k8s-addresses = {
    local_api_address             = format("%s.1",  join(".", slice(split(".",var.service_cidr), 0, 3)) )
    dns_address                   = format("%s.10", join(".", slice(split(".",var.service_cidr), 0, 3)) )
    idp_provider_fqdn             = format("auth.%s"             , var.base_domain)
    base_cluster_fqdn             = format("%s.%s"               , var.cluster_name, var.base_domain)
    wildcard_base_cluster_fqdn    = format("%s.%s.%s", "*"       , var.cluster_name, var.base_domain)
    etcd_server_lb_fqdn           = format("%s.%s.%s", "etcd"    , var.cluster_name, var.base_domain)
    kube_apiserver_lb_fqdn        = format("%s.%s.%s", "api"     , var.cluster_name, var.base_domain)
    kube_apiserver_lb_fqdn_local  = format("%s.%s.%s", "api-int" , var.cluster_name, var.base_domain)

  }
}