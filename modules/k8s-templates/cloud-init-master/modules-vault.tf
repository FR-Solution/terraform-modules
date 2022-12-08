
module "k8s-vault-master" {
    source = "../../k8s-vault-master"
    k8s_global_vars   = var.k8s_global_vars
    # vault_policy_kubernetes_sign_approle = var.vault_policy_kubernetes_sign_approle
    master_instance_list = var.master_instance_list
}   
