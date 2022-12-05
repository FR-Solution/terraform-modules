module "k8s-cloud-init-master" {
    source                       = "../k8s-templates/cloud-init-master"
    k8s_global_vars              = var.k8s_global_vars
    master_instance_list         = local.master_instance_list
    master_instance_list_map     = local.master_instance_list_map
    vault_policy_kubernetes_sign_approle = var.vault_policy_kubernetes_sign_approle
}