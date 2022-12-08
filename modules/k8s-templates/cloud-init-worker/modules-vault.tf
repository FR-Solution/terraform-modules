
module "k8s-vault-worker" {
    source = "../../k8s-vault-worker"
    k8s_global_vars   = var.k8s_global_vars
    worker_instance_list = var.worker_instance_list
    worker_instance_list_map = var.worker_instance_list_map
    # vault_policy_kubernetes_sign_approle = var.vault_policy_kubernetes_sign_approle
}   
