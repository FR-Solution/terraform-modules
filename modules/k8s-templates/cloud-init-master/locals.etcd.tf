
locals {

  etcd_list_servers             = formatlist("https://%s.${var.k8s_global_vars.cluster_metadata.cluster_name}.${var.k8s_global_vars.cluster_metadata.base_domain}:${var.k8s_global_vars.kubernetes-ports.etcd-server-port}", 
                                            var.k8s_global_vars.master_vars.master_instance_extra_list)

  etcd_advertise_client_urls    = join(",", local.etcd_list_servers)

}
