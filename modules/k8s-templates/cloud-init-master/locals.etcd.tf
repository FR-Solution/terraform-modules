
locals {


  list_masters                  = formatlist("%s.${var.k8s_global_vars.cluster_name}.${var.k8s_global_vars.base_domain}", 
                                            var.master_instance_list)

  etcd_list_servers             = formatlist("https://%s.${var.k8s_global_vars.cluster_name}.${var.k8s_global_vars.base_domain}:${var.k8s_global_vars.kubernetes-ports.etcd-server-port}", 
                                            var.master_instance_list)
  etcd_list_initial_cluster     = formatlist("%s.${var.k8s_global_vars.cluster_name}.${var.k8s_global_vars.base_domain}=https://%s.${var.k8s_global_vars.cluster_name}.${var.k8s_global_vars.base_domain}:${var.k8s_global_vars.kubernetes-ports.etcd-peer-port}", 
                                            var.master_instance_list,
                                            var.master_instance_list)

  
  etcd_initial_cluster          = join(",", local.etcd_list_initial_cluster)
  etcd_advertise_client_urls    = join(",", local.etcd_list_servers)

}
