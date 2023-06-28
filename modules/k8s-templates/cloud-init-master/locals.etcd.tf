
locals {

  etcd_list_servers             = formatlist("https://%s.${var.k8s_global_vars.cluster_metadata.cluster_name}.${var.k8s_global_vars.cluster_metadata.base_domain}:${var.k8s_global_vars.kubernetes-ports.etcd-server-port}", 
                                            var.k8s_global_vars.master_vars.master_instance_extra_list)


  etcd_initial_cluster_list     = flatten([
        for instance_name in var.k8s_global_vars.master_vars.master_instance_extra_list : [
          "${instance_name}.${var.k8s_global_vars.cluster_metadata.cluster_name}.${var.k8s_global_vars.cluster_metadata.base_domain}=https://${instance_name}.${var.k8s_global_vars.cluster_metadata.cluster_name}.${var.k8s_global_vars.cluster_metadata.base_domain}:${var.k8s_global_vars.kubernetes-ports.etcd-peer-port}"
        ]
    ])

  etcd_initial_cluster          = join(",", local.etcd_initial_cluster_list)

}
