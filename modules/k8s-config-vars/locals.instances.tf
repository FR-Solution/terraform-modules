


locals {
  # Формируется массивы для будущих for_each с маской "${intermediate_name}:${issuer_name}"
  issuers_content_only = flatten([
  for intermediate_name in keys(local.ssl.intermediate) : [
    for issuer_name,issuer in local.ssl.intermediate[intermediate_name].issuers : 
          {
            "${intermediate_name}:${issuer_name}" = merge(local.ssl["global-args"]["issuer-args"], issuer["issuer-args"]) 
          }

      ]
    ]
  )

  secret_content_only = flatten([
    for secret_name in keys(local.secrets) : 
          {"${secret_name}" = {}}
    ]
  )  

  ssl_for_each_map = {

    secret_content_map_only = { for item in local.secret_content_only :
      keys(item)[0] => values(item)[0]
    }

    issuers_content_map_only = { for item in local.issuers_content_only :
      keys(item)[0] => values(item)[0]
    }

  }
  
  master_instance_list        = flatten([
    for master-index in range(var.extra_args.master_vars.master_group.count): [
     "${var.extra_args.master_vars.master_group.name}-${sum([master-index, 1])}"
    ]
  ])

  master_instance_list_map = { for item in local.master_instance_list :
    item => {}
  }

  master_instance_extra_list        = flatten([
    for master-index in range(var.extra_args.master_vars.master_group.count): [
     "${var.extra_args.master_vars.master_group.name}-${local.k8s-addresses.extra_cluster_name}-${sum([master-index, 1])}"
    ]
  ])

  master_instance_extra_list_map = { for item in local.master_instance_extra_list :
    item => {}
  }

  master_vars = {
    master_group = var.extra_args.master_vars.master_group
    master_instance_list            = local.master_instance_list
    master_instance_list_map        = local.master_instance_list_map
    master_instance_extra_list      = local.master_instance_extra_list
    master_instance_extra_list_map  = local.master_instance_extra_list_map
  }
}