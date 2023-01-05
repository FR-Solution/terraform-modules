module "k8s-cloud-init-master" {
    source                       = "../k8s-templates/cloud-init-master"
    k8s_global_vars              = var.k8s_global_vars
    master_instance_list         = local.master_instance_list
    master_instance_list_map     = local.master_instance_list_map
    node_group_metadata          = var.master_group.metadata
}   

module "k8s-vault-master" {
    source = "../k8s-vault-master"
    k8s_global_vars   = var.k8s_global_vars
    master_instance_list = local.master_instance_list
    master_instance_list_map = local.master_instance_list_map
}   
