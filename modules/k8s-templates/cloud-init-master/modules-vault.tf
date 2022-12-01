locals {
  master_instance_list        = flatten([
    for master-index in range(var.master-instance-count): [
     "master-${sum([master-index, 1])}"
    ]
  ])
  master_instance_list_map = { for item in local.master_instance_list :
    item => {}
  }
  list_masters                  = formatlist("%s.${var.k8s_global_vars.cluster_name}.${var.k8s_global_vars.base_domain}", 
                                            local.master_instance_list)

  etcd_list_servers             = formatlist("https://%s.${var.k8s_global_vars.cluster_name}.${var.k8s_global_vars.base_domain}:${var.k8s_global_vars.kubernetes-ports.etcd-server-port}", 
                                            local.master_instance_list)
  etcd_list_initial_cluster     = formatlist("%s.${var.k8s_global_vars.cluster_name}.${var.k8s_global_vars.base_domain}=https://%s.${var.k8s_global_vars.cluster_name}.${var.k8s_global_vars.base_domain}:${var.k8s_global_vars.kubernetes-ports.etcd-peer-port}", 
                                            local.master_instance_list,
                                            local.master_instance_list)

  
  etcd_initial_cluster          = join(",", local.etcd_list_initial_cluster)
  etcd_advertise_client_urls    = join(",", local.etcd_list_servers)

}


module "k8s-vault-master" {
    source = "../../k8s-vault-master"
    k8s_global_vars   = var.k8s_global_vars
    vault_policy_kubernetes_sign_approle = var.vault_policy_kubernetes_sign_approle
    master_instance_list = local.master_instance_list
}   
