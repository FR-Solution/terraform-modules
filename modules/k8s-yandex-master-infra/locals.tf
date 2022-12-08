

locals {
  
  master_instance_list        = flatten([
    for master-index in range(var.master_group.count): [
     "${var.master_group.name}-${sum([master-index, 1])}"
    ]
  ])

  master_instance_list_map = { for item in local.master_instance_list :
    item => {}
  }

}
