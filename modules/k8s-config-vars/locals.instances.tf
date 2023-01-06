


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

}