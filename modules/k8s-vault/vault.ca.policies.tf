resource "vault_policy" "kubernetes-ca-approle" {
  for_each  = var.k8s_global_vars.ssl_for_each_map.intermediate_content_map
  
  name      = "${var.k8s_global_vars.global_path.base_vault_path}/ca/${split(":","${each.key}")[0]}"

  policy = templatefile("${path.module}/templates/vault/vault-intermediate-read-role.tftpl", { 
    pki_path                = var.k8s_global_vars.ssl.intermediate[split(":","${each.key}")[0]].path
    base_vault_path_approle = var.k8s_global_vars.global_path.base_vault_path_approle,
    ca_name                 = split(":","${each.key}")[0]
    master_instance_list    = var.k8s_global_vars.master_instance_list
    }
  )
}

resource "vault_policy" "external-ca-approle" {
  for_each  = var.k8s_global_vars.ssl_for_each_map.external_intermediate_content_map
  
  name      = "${var.k8s_global_vars.global_path.base_vault_path}/external-ca/${split(":","${each.key}")[0]}"

  policy = templatefile("${path.module}/templates/vault/vault-intermediate-read-role.tftpl", { 
    pki_path                = var.k8s_global_vars.ssl.external_intermediate[split(":","${each.key}")[0]].path
    base_vault_path_approle = var.k8s_global_vars.global_path.base_vault_path_approle,
    ca_name                 = split(":","${each.key}")[0]
    master_instance_list    = var.k8s_global_vars.master_instance_list
    }
  )
}
