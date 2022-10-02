resource "vault_policy" "kubernetes-ca-bootstrap" {
  for_each  = local.intermediate_content_map

  name      = "clusters/${var.cluster_name}/ca/bootstrap-${split(":","${each.key}")[0]}"

  policy = templatefile("templates/vault/vault-intermediate-bootstrap-role.tftpl", { 
    cluster_name          = var.cluster_name
    ca_name               = split(":","${each.key}")[0]
    master_instance_list  = local.master_instance_list
    }
  )
}

resource "vault_policy" "kubernetes-ca" {
  for_each  = local.intermediate_content_map
  
  name      = "clusters/${var.cluster_name}/ca/${split(":","${each.key}")[0]}"

  policy = templatefile("templates/vault/vault-intermediate-read-role.tftpl", { 
    pki_path              = local.ssl.intermediate[split(":","${each.key}")[0]].path
    cluster_name          = var.cluster_name
    ca_name               = split(":","${each.key}")[0]
    master_instance_list  = local.master_instance_list
    }
  )
}
