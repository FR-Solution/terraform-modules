
module "k8s-global-vars" {
    source = "github.com/fraima/kubernetes//modules/k8s-vars?ref=main"
    cluster_name          = var.cluster_name
    base_domain           = "dobry-kot.ru"
    master_instance_count = var.master-instance-count
    worker_instance_count = var.worker-instance-count
    vault_server          = var.vault_server
}

module "k8s-vault" {
    source = "github.com/fraima/kubernetes//modules/k8s-vault?ref=main"
    k8s_global_vars   = module.k8s-global-vars

}

module "k8s-master-cloud-init" {
    
    source                = "github.com/fraima/kubernetes//modules/k8s-templates/cloud-init?ref=main"
    ssh_key_path          = "~/.ssh/id_rsa.pub"
    k8s_global_vars       = module.k8s-global-vars
    vault-bootstrap-master-token = module.k8s-vault.bootstrap-master-token

}
