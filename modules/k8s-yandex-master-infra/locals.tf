

locals {
  
  master_instance_list        = flatten([
    for master-index in range(var.master_group.count): [
     "${var.master_group.name}-${var.k8s_global_vars.extra_cluster_name}-${sum([master-index, 1])}"
    ]
  ])

  master_instance_list_map = { for item in local.master_instance_list :
    item => {}
  }


  instances_disk = flatten([
  for disk_index, disk_name in keys(var.master_group.resources.disk.secondary_disk) : [
      for instance_name in local.master_instance_list:
        {"${disk_name}_${instance_name}" = {}}
        ]
      ]
  )
  instances_disk_map = { for item in local.instances_disk :
    keys(item)[0] => values(item)[0]
  }

}