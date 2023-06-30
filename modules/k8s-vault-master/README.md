# Module K8S-vault-master

This module is designed to create an environment in Vault for master nodes.

### Resources created:

| имя                                               | тип      | описание                                                           |
| --------------------------------------------------| -------- | ------------------------------------------------------------------ |
| **`vault_policy `**                               | resource | Defines the permissions for the master node to interact with Vault |
| **`vault_approle_auth_backend_role `**            | resource | Creates an Approle under which access will be initialized          |
| **`vault_approle_auth_backend_role_secret_id `**  | resource | Generates a secret-id, which is a confidential part of the access  |

### Input variables:

| имя                                               | тип      | описание                                                           |
| --------------------------------------------------| -------- | ------------------------------------------------------------------ |
| **`k8s_global_vars `**                            | any      | Module:k8s-config-vars: base vars                                  |

### Output variables:

| имя                                               | тип      | описание                                                           |
| --------------------------------------------------| -------- | ------------------------------------------------------------------ |
| **`secret_id_all `**                              | any      | The secret_id list was generated from the masters                  |
| **`role_id_all `**                                | any      | Map the role_id list was generated from the masters                |

Example:
---------
```terraform

module "k8s-global-vars" {
  source     = "../k8s-config-vars"
  extra_args = var.global_vars
}

module "k8s-vault" {
  depends_on = [
    module.k8s-global-vars
  ]
  source          = "../k8s-vault"
  k8s_global_vars = module.k8s-global-vars
}

module "k8s-vault-master" {
  depends_on = [
    module.k8s-vault
  ]
  source = "../k8s-vault-master"
  k8s_global_vars   = module.k8s-global-vars
}

```