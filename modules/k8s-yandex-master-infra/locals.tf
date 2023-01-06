
data "yandex_iam_policy" "admin" {
  binding {
    role = "admin"
    members = local.iam_admin_members
  }
}

locals {
  iam_admin_members = flatten([
    for member, member_value in local.master_instance_list_map : 
          "serviceAccount:${yandex_iam_service_account.master-sa[member].id}"
          ]
    )

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

  etcd_member_servers_srv = flatten([
    for master_index, master_value in local.master_instance_list: [
     "0 0 ${var.k8s_global_vars.kubernetes-ports.etcd-peer-port} ${master_value}.${var.k8s_global_vars.cluster_name}.${var.k8s_global_vars.base_domain}."
    ]
  ])
  etcd_member_clients_srv = flatten([
    for master_index, master_value in local.master_instance_list: [
     "0 0 ${var.k8s_global_vars.kubernetes-ports.etcd-server-port} ${master_value}.${var.k8s_global_vars.cluster_name}.${var.k8s_global_vars.base_domain}."
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
  
}