module "k8s-cloud-init-worker" {
    source                       = "../k8s-templates/cloud-init-worker"
    k8s_global_vars              = var.k8s_global_vars
    worker_instance_list         = local.worker_instance_list
    worker_instance_list_map     = local.worker_instance_list_map
    # vault_policy_kubernetes_sign_approle = var.vault_policy_kubernetes_sign_approle
}