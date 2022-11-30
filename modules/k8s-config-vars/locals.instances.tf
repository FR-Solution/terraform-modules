# Формируется массивы для будущих for_each с маской "${intermediate_name}:${issuer_name}:${instance}"
locals {

  issuers_content = flatten([
  for intermediate_name in keys(local.ssl.intermediate) : [
    for issuer_name,issuer in local.ssl.intermediate[intermediate_name].issuers : [
      for master_name in local.master_instance_list:  
          {
            "${intermediate_name}:${issuer_name}:${master_name}" = merge(local.ssl["global-args"]["issuer-args"], issuer["issuer-args"]) 
          }
        ]
      ]
    ]
  ) 

  intermediate_content_master = flatten([
  for name in keys(local.ssl.intermediate) : [
      for master_name in local.master_instance_list:
        {"${name}:${master_name}" = {}}
        ]
      ]
  )

  intermediate_content_worker = flatten([
  for intermediate_name in keys(local.ssl.intermediate) : [
      for worker_name in local.worker_instance_list:
        {"${intermediate_name}:${worker_name}" = {}}
        ]
      ]
  )

# Формируется массивы для будущих for_each с маской "${external_intermediate_name}:${issuer_name}:${instance}"
  external_intermediate_content_master = flatten([
  for external_intermediate_name in keys(local.ssl.external_intermediate) : [
      for master_name in local.master_instance_list:
        {"${external_intermediate_name}:${master_name}" = {}}
        ]
      ]
  )

  external_intermediate_content_worker = flatten([
  for external_intermediate_name in keys(local.ssl.external_intermediate) : [
      for worker_name in local.worker_instance_list:
        {"${external_intermediate_name}:${worker_name}" = {}}
        ]
      ]
  )


  secret_content = flatten([
  for secret_name in keys(local.secrets) : [
      for master_name in local.master_instance_list:  
        {"${secret_name}:${master_name}" = {}}
        ]
      ]
  )

}

# Формируется массивы для будущих for_each с маской "${intermediate_name}:${issuer_name}"
locals {
  issuers_content_only = flatten([
  for intermediate_name in keys(local.ssl.intermediate) : [
    for issuer_name,issuer in local.ssl.intermediate[intermediate_name].issuers : 
          {
            "${intermediate_name}:${issuer_name}" = merge(local.ssl["global-args"]["issuer-args"], issuer["issuer-args"]) 
          }

      ]
    ]
  )

  intermediate_content_only_master = flatten([
  for name in keys(local.ssl.intermediate) : [
      for master_name in local.master_instance_list:  
        {"${name}:${master_name}" = {}}
        ]
      ]
  )

  intermediate_content_only_worker = flatten([
  for name in keys(local.ssl.intermediate) : [
      for worker_name in local.worker_instance_list:  
        {"${name}:${worker_name}" = {}}
        ]
      ]
  )

  secret_content_only = flatten([
  for secret_name in keys(local.secrets) : 
        {"${secret_name}" = {}}
        ]
  )  
}

locals {
  issuers_content_labels_master = flatten([
  for intermediate_name in keys(local.ssl.intermediate) : [
    for issuer_name,issuer in local.ssl.intermediate[intermediate_name].issuers : [
      for master_name in local.master_instance_list:  
          {
            "${intermediate_name}:${issuer_name}:${master_name}" = try(issuer.labels, {})
          }
        ]
      ]
    ]
  ) 

  issuers_content_labels_worker = flatten([
  for intermediate_name in keys(local.ssl.intermediate) : [
    for issuer_name,issuer in local.ssl.intermediate[intermediate_name].issuers : [
      for worker_name in local.worker_instance_list:  
          {
            "${intermediate_name}:${issuer_name}:${worker_name}" = try(issuer.labels, {})
          }
        ]
      ]
    ]
  ) 

}

locals {

  master_instance_list        = flatten([
    for master-index in range(var.master_instance_count): [
     "master-${sum([master-index, 1])}"
    ]
  ])

  worker_instance_list        = flatten([
    for worker-index in range(var.worker_instance_count): [
     "worker-${sum([worker-index, 1])}"
    ]
  ])

}

locals {

  ssl_for_each_map = {
    intermediate_content_map_master = { for item in local.intermediate_content_master :
      keys(item)[0] => values(item)[0]
    }
    intermediate_content_map_worker = { for item in local.intermediate_content_worker :
      keys(item)[0] => values(item)[0]
    }

    issuers_content_map = { for item in local.issuers_content :
    keys(item)[0] => values(item)[0]
    }
    
    secret_content_map = { for item in local.secret_content :
      keys(item)[0] => values(item)[0]
    }

    external_intermediate_content_map_master = { for item in local.external_intermediate_content_master :
      keys(item)[0] => values(item)[0]
    }
    external_intermediate_content_map_worker = { for item in local.external_intermediate_content_worker :
      keys(item)[0] => values(item)[0]
    }

    master_instance_list_map = { for item in local.master_instance_list :
      item => {}
    }

    worker_instance_list_map = { for item in local.worker_instance_list :
      item => {}
    }

    intermediate_content_map_only_master = { for item in local.intermediate_content_only_master :
      keys(item)[0] => values(item)[0]
    }
    intermediate_content_map_only_worker = { for item in local.intermediate_content_only_worker :
      keys(item)[0] => values(item)[0]
    }

    secret_content_map_only = { for item in local.secret_content_only :
      keys(item)[0] => values(item)[0]
    }

    issuers_content_map_only = { for item in local.issuers_content_only :
      keys(item)[0] => values(item)[0]
    }

    issuers_content_map_worker = { for item in local.issuers_content_labels_worker :
      keys(item)[0] => values(item)[0] if try(values(item)[0].instance-worker, false) == true
    }
    issuers_content_map_master = { for item in local.issuers_content_labels_master :
      keys(item)[0] => values(item)[0] if try(values(item)[0].instance-master, false) == true
    }
  }

}