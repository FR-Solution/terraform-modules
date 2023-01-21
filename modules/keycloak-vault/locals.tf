locals {

    policy_names = flatten([
        for policy_key, policy_value in vault_policy.auth : 
            {"${policy_value.name}": ""}
        ]
    )
    policy_names_map = { for item in local.policy_names :
      keys(item)[0] => values(item)[0]
    }

    policy_name_list = keys(local.policy_names_map)
}