
variable "master-instance-count" {
  type = number
  default = 2
}

variable "worker-instance-count" {
  type = number
  default = 0
}

variable "cluster_name" {
  type = string
  default = "treska"
}

module "k8s-global-vars" {
    source = "../../modules/k8s-vars"
    cluster_name          = var.cluster_name
    base_domain           = "dobry-kot.ru"
    master_instance_count = var.master-instance-count
    worker_instance_count = var.worker-instance-count

}

module "k8s-vault" {
    source            = "../../modules/k8s-vault"
    k8s_global_vars   = module.k8s-global-vars

}

module "k8s-master-cloud-init" {
    
    source                = "../../modules/k8s-templates/cloud-init"
    ssh_key_path          = "~/.ssh/id_rsa.pub"
    k8s_global_vars       = module.k8s-global-vars
    # vault-bootstrap-master-token = module.k8s-vault.bootstrap-master-token
    vault-bootstrap-master-token = {
      "master-0": {"client_token": "$TOKEN"}
      "master-1": {"client_token": "$TOKEN"}
      "master-2": {"client_token": "$TOKEN"}
    }
}

output "name" {
  value = module.k8s-master-cloud-init
  # sensitive = true

}

