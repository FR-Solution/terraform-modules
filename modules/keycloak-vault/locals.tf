locals {

  policy_name_map = flatten([
  for policy_key, policy_value in vault_policy.auth : 
    {"${policy_value.name}": ""}
    ]
  )
  policy_name_list = keys(local.policy_name_map)
}