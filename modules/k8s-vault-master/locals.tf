locals {
  issuers_content_only = flatten([
  for intermediate_name in keys(var.k8s_global_vars.ssl.intermediate) : [
    for issuer_name,issuer in var.k8s_global_vars.ssl.intermediate[intermediate_name].issuers : 
          {
            "${intermediate_name}:${issuer_name}" = merge(var.k8s_global_vars.ssl["global-args"]["issuer-args"], issuer["issuer-args"]) 
          }

      ]
    ]
  )

  issuers_content_labels_master = flatten([
  for intermediate_name in keys(var.k8s_global_vars.ssl.intermediate) : [
    for issuer_name,issuer in var.k8s_global_vars.ssl.intermediate[intermediate_name].issuers : [
      for master_name in var.master_instance_list:  
          {
            "${intermediate_name}:${issuer_name}:${master_name}" = try(issuer.labels, {})
          }
        ]
      ]
    ]
  ) 

  intermediate_content_only_master = flatten([
  for name in keys(var.k8s_global_vars.ssl.intermediate) : [
      for master_name in var.master_instance_list:  
        {"${name}:${master_name}" = {}}
        ]
      ]
  )

  secret_content = flatten([
  for secret_name in keys(var.k8s_global_vars.secrets) : [
      for master_name in var.master_instance_list:  
        {"${secret_name}:${master_name}" = {}}
        ]
      ]
  )

  external_intermediate_content_master = flatten([
  for external_intermediate_name in keys(var.k8s_global_vars.ssl.external_intermediate) : [
      for master_name in var.master_instance_list:
        {"${external_intermediate_name}:${master_name}" = {}}
        ]
      ]
  )

  intermediate_content_master = flatten([
  for name in keys(var.k8s_global_vars.ssl.intermediate) : [
      for master_name in var.master_instance_list:
        {"${name}:${master_name}" = {}}
        ]
      ]
  )

  issuers_content = flatten([
  for intermediate_name in keys(var.k8s_global_vars.ssl.intermediate) : [
    for issuer_name,issuer in var.k8s_global_vars.ssl.intermediate[intermediate_name].issuers : [
      for master_name in var.master_instance_list:  
          {
            "${intermediate_name}:${issuer_name}:${master_name}" = merge(var.k8s_global_vars.ssl["global-args"]["issuer-args"], issuer["issuer-args"]) 
          }
        ]
      ]
    ]
  ) 

  secret_content_only = flatten([
  for secret_name in keys(var.k8s_global_vars.secrets) : 
        {"${secret_name}" = {}}
        ]
  )  

    external_intermediate_content_map_master = { for item in local.external_intermediate_content_master :
      keys(item)[0] => values(item)[0]
    }
    intermediate_content_map_master = { for item in local.intermediate_content_master :
      keys(item)[0] => values(item)[0]
    }
    intermediate_content_map_only_master = { for item in local.intermediate_content_only_master :
      keys(item)[0] => values(item)[0]
    }
    issuers_content_map_master = { for item in local.issuers_content_labels_master :
      keys(item)[0] => values(item)[0] if try(values(item)[0].instance-master, false) == true
    }
    secret_content_map = { for item in local.secret_content :
      keys(item)[0] => values(item)[0]
    }
    secret_content_map_only = { for item in local.secret_content_only :
      keys(item)[0] => values(item)[0]
    }
    issuers_content_map_only = { for item in local.issuers_content_only :
      keys(item)[0] => values(item)[0]
    }

}
