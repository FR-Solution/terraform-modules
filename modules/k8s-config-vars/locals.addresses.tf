locals {
  k8s-addresses = {
    local_api_address = format("%s.1", join(".", slice(split(".",var.service_cidr), 0, 3)) )
    dns_address       = format("%s.10", join(".", slice(split(".",var.service_cidr), 0, 3)) )
    etcd_advertise_client_urls    = join(",", local.etcd_list_servers)
    idp_provider_fqdn             = format("auth.%s"             , var.base_domain)
    base_cluster_fqdn             = format("%s.%s"               , var.cluster_name, var.base_domain)
    wildcard_base_cluster_fqdn    = format("%s.%s.%s", "*"       , var.cluster_name, var.base_domain)
    etcd_server_lb_fqdn           = format("%s.%s.%s", "etcd"    , var.cluster_name, var.base_domain)
    kube_apiserver_lb_fqdn        = format("%s.%s.%s", "api"     , var.cluster_name, var.base_domain)
    kube_apiserver_lb_fqdn_local  = format("%s.%s.%s", "api-int" , var.cluster_name, var.base_domain)

  }

  list_masters                  = formatlist("master-%s.${var.cluster_name}.${var.base_domain}", 
                                            range(var.master_instance_count))

  etcd_list_servers             = formatlist("https://master-%s.${var.cluster_name}.${var.base_domain}:${local.kubernetes-ports.etcd-server-port}", 
                                            range(var.master_instance_count))
  etcd_list_initial_cluster     = formatlist("master-%s.${var.cluster_name}.${var.base_domain}=https://master-%s.${var.cluster_name}.${var.base_domain}:${local.kubernetes-ports.etcd-peer-port}", 
                                            range(var.master_instance_count), 
                                            range(var.master_instance_count))

  
  etcd_initial_cluster          = join(",", local.etcd_list_initial_cluster)
}