
module "k8s-vault-worker" {
    source = "../../k8s-vault-worker"
    k8s_global_vars   = var.k8s_global_vars
    vault_policy_kubernetes_sign_approle = var.vault_policy_kubernetes_sign_approle
    worker_instance_list = local.worker_instance_list
}   
