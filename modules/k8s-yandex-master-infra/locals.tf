

locals {

  master_instance_list        = flatten([
    for master-index in range(var.master_group.count): [
     "${var.master_group.name}-${var.k8s_global_vars.k8s-addresses.extra_cluster_name}-${sum([master-index, 1])}"
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

  etcd_member_servers_srv = flatten([
    for master_index, master_value in local.master_instance_list: [
     "0 0 ${var.k8s_global_vars.kubernetes-ports.etcd-peer-port} ${master_value}.${var.k8s_global_vars.cluster_metadata.cluster_name}.${var.k8s_global_vars.cluster_metadata.base_domain}."
    ]
  ])
  etcd_member_clients_srv = flatten([
    for master_index, master_value in local.master_instance_list: [
     "0 0 ${var.k8s_global_vars.kubernetes-ports.etcd-server-port} ${master_value}.${var.k8s_global_vars.cluster_metadata.cluster_name}.${var.k8s_global_vars.cluster_metadata.base_domain}."
    ]
  ])

  secret_id_all  = module.k8s-vault-master.secret_id_all
  role_id_all    = module.k8s-vault-master.role_id_all 

  flatten_role_id_all = flatten([
      for index, value in local.role_id_all: [
      index
      ]
  ])

  set_role_id_all = toset(local.flatten_role_id_all)
  map_role_id_all = { for item in local.set_role_id_all :
      item => {}
  }

  flatten_secret_id_alls = flatten([
      for index, value in local.secret_id_all: [
      "${index}"
      ]
  ])

  set_secret_id_alls = toset(local.flatten_secret_id_alls)
  map_secret_id_alls = { for item in local.set_secret_id_alls :
      item => {}
  }

  default_subnet = [{"${try(var.master_group.default_subnet, "")}": "${var.master_group.default_zone}"}]
  custom_subnet = flatten([
  for instance_name, instance_value in var.master_group.resources_overwrite : 
      {"${try(instance_value.subnet, "")}": "${try(instance_value.zone, var.master_group.default_zone)}"}
    ]
  )
  default_subnet_map = { for item in local.default_subnet :  
    keys(item)[0] => values(item)[0] 
    if keys(item)[0] != ""
  }

  custom_subnet_map = { for item in local.custom_subnet :  
    keys(item)[0] => values(item)[0] 

    if keys(item)[0] != ""
    # !!! Attention, you cannot specify the same subnets for different zones.
    # !!! Do not specify a custom subnet if it matches the default one.

  }

  default_overide = flatten([
  for index in range(var.master_group.count) : 
      {"${var.master_group.name}-${sum([index, 1])}": {
        "zone": "${try(var.master_group.default_zone, "")}"
        "subnet": "${try(var.master_group.default_subnet, "")}"
        }
      }
    ]
  )

  custom_overide = flatten([
  for instance_name, instance_value in var.master_group.resources_overwrite : 
      {"${instance_name}": {
        "zone": "${try(instance_value.zone, var.master_group.default_zone)}"
        "subnet": "${try(instance_value.subnet, var.master_group.default_subnet)}"
        }
      }
    ]
  )

  default_overide_map = { for item in local.default_overide :  
    keys(item)[0] => values(item)[0] 
    if keys(item)[0] != ""
    # !!! Attention, you cannot specify the same subnets for different zones.
    # !!! Do not specify a custom subnet if it matches the default one.

  }

  custom_overide_map = { for item in local.custom_overide :  
    keys(item)[0] => values(item)[0] 
    if keys(item)[0] != ""
    # !!! Attention, you cannot specify the same subnets for different zones.
    # !!! Do not specify a custom subnet if it matches the default one.

  }

  current_subnet = merge(local.default_subnet_map, local.custom_subnet_map ) 
  treska = merge(local.default_overide_map, local.custom_overide_map ) 

}
output "DEBUGER" {
  value = local.treska
}