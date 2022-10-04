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
  issuers_content_map = { for item in local.issuers_content :
    keys(item)[0] => values(item)[0]
  }

  intermediate_content = flatten([
  for name in keys(local.ssl.intermediate) : [
      for master_name in local.master_instance_list:  
        {"${name}:${master_name}" = {}}
        ]
      ]
  )
  intermediate_content_map = { for item in local.intermediate_content :
    keys(item)[0] => values(item)[0]
  }

  secret_content = flatten([
  for secret_name in keys(local.secrets) : [
      for master_name in local.master_instance_list:  
        {"${secret_name}:${master_name}" = {}}
        ]
      ]
  )
  secret_content_map = { for item in local.secret_content :
    keys(item)[0] => values(item)[0]
  }

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
  issuers_content_map_only = { for item in local.issuers_content_only :
    keys(item)[0] => values(item)[0]
  }

  intermediate_content_only = flatten([
  for name in keys(local.ssl.intermediate) : [
      for master_name in local.master_instance_list:  
        {"${name}:${master_name}" = {}}
        ]
      ]
  )
  intermediate_content_map_only = { for item in local.intermediate_content_only :
    keys(item)[0] => values(item)[0]
  }

  access_cidr_availability_zones = flatten([for zone_name in keys(var.availability_zones) : [var.availability_zones[zone_name]]])

  secret_content_only = flatten([
  for secret_name in keys(local.secrets) : 
        {"${secret_name}" = {}}
        ]
  )

  secret_content_map_only = { for item in local.secret_content_only :
    keys(item)[0] => values(item)[0]
  }

}

