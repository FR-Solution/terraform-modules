Module K8S-vault
================

#### This module is focused on creating a Vault environment for your future K8S cluster.


Resources created:
---------
| NAME                                                      | TYPE     | DESCRIPTIONS                                               |
| ----------------------------------------------------------| -------- | ---------------------------------------------------------- |
| **`vault_mount `**                                        | resource | Created a PKI/KV2 store for future certificates/secrets    |
| **`vault_pki_secret_backend_root_cert `**                 | resource | Generates a new self-signed CA certificate for the PKI     |
| **`vault_pki_secret_backend_intermediate_cert_request `** | resource | Generates a new private key and a CSR for signing the PKI  |
| **`vault_pki_secret_backend_root_sign_intermediate `**    | resource | Creates PKI certificate                                    |
| **`vault_pki_secret_backend_intermediate_set_signed `**   | resource | Submits the CA certificate to the PKI                      |
| **`vault_auth_backend `**                                 | resource | Creates a base authorization path via approle              |
| **`vault_pki_secret_backend_role `**                      | resource | Creates a role on an PKI Secret Backend for Vault          |

Input variables:
---------
| NAME                                                      | TYPE     | DESCRIPTIONS                                               |
| ----------------------------------------------------------| -------- | ---------------------------------------------------------- |
| **`k8s_global_vars `**                                    | any      | Module:k8s-config-vars: base vars                          |


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
```

Attention:
-----------

#### The creation structure depends on the structure of the k8s_global_vars input variable defined through the k8s-global-vars module
#### SEE SPECIFICATION -> [LINK](https://github.com/fraima/terraform-modules/blob/main/modules/k8s-config-vars/locals.certs.tf)