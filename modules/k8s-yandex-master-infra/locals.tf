

locals {
  
  master_instance_list        = flatten([
    for master-index in range(var.master_group.count): [
     "${var.master_group.name}-${var.k8s_global_vars.extra_cluster_name}-${sum([master-index, 1])}"
    ]
  ])

  master_instance_list_map = { for item in local.master_instance_list :
    item => {}
  }

}
