locals {

    worker_instance_list        = flatten([
        for worker-index in range(var.worker_instance_count): [
        "${var.name}-${sum([worker-index, 1])}"
        ]
    ])
    worker_instance_list_map = { for item in local.worker_instance_list :
      item => {}
    }
}

module "k8s-cloud-init-worker" {
    source                       = "../k8s-templates/cloud-init-worker"
    k8s_global_vars              = var.k8s_global_vars
    worker_instance_list         = local.worker_instance_list
    worker_instance_list_map     = local.worker_instance_list_map

}
