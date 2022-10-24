
variable "master-instance-count" {
  type = number
  default = 1
}

variable "worker-instance-count" {
  type = number
  default = 0
}

variable "cluster_name" {
  type = string
  default = "treska"
}

module "certificate-vars" {
    source = "../../modules/k8s-certificate-vars"
    cluster_name    = var.cluster_name
    base_domain     = "dobry-kot.ru"

}

module "k8s-vault" {
    source = "../../modules/k8s-vault"
    k8s_certificate_vars  = module.certificate-vars
    master_instance_count = var.master-instance-count
    worker_instance_count = var.worker-instance-count
    cluster_name          = var.cluster_name

}

module "k8s-master-cloud-init" {
    
    source                = "../../modules/k8s-templates/cloud-init"
    ssh_key_path          = "~/.ssh/id_rsa.pub"
    k8s_certificate_vars  = module.certificate-vars
    vault-bootstrap-master-token = module.k8s-vault.bootstrap-master-token
    master_instance_list_map = module.k8s-vault.master_instance_list_map
}

# output "name" {
#   value = module.k8s-master-cloud-init.kubeconfig
#   sensitive = true
# }

# module "k8s-worker-cloud-init" {
#     source = "../../modules/k8s-vault"
# }


# module "k8s-control-plane" {
#     source = "../../modules/k8s-vault"
# }

# module "k8s-helm" {
#     source = "../../modules/k8s-vault"
# }

# module "k8s-workers" {
#     source = "../../modules/k8s-vault"
# }

