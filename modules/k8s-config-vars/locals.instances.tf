# Формируется массивы для будущих for_each с маской "${intermediate_name}:${issuer_name}:${instance}"
locals {

  intermediate_content_worker = flatten([
  for intermediate_name in keys(local.ssl.intermediate) : [
      for worker_name in local.worker_instance_list:
        {"${intermediate_name}:${worker_name}" = {}}
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


  worker_instance_list        = flatten([
    for worker-index in range(var.worker_instance_count): [
     "worker-${sum([worker-index, 1])}"
    ]
  ])

}

locals {

  ssl_for_each_map = {

    intermediate_content_map_worker = { for item in local.intermediate_content_worker :
      keys(item)[0] => values(item)[0]
    }

    external_intermediate_content_map_worker = { for item in local.external_intermediate_content_worker :
      keys(item)[0] => values(item)[0]
    }

    worker_instance_list_map = { for item in local.worker_instance_list :
      item => {}
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

  }

}