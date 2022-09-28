resource "vault_policy" "kubernetes-sign-bootstrap" {
  for_each  = "${local.issuers_content_map}"

  name      = "clusters/${var.cluster_name}/certificates/bootstrap-${format("%s",split(":","${each.key}")[1])}"

  policy = templatefile("templates/vault/vault-certificate-bootstrap-role.tftpl", { 
    cluster_name        = "${var.cluster_name}",
    approle_name        = format("%s",split(":","${each.key}")[1])
    master_instance_list  = local.master_instance_list
    }
  )
}

resource "vault_token_auth_backend_role" "kubernetes-sign" {
  for_each                  = "${local.issuers_content_map}"
  role_name                 = "${format("%s-%s",split(":","${each.key}")[1], var.cluster_name)}"
  allowed_policies          = [vault_policy.kubernetes-sign-bootstrap[each.key].name]
  token_period              = "300"
  renewable                 = false
  allowed_entity_aliases    = []
  allowed_policies_glob     = []
  disallowed_policies       = []
  disallowed_policies_glob  = []
  token_bound_cidrs         = []
  token_policies            = []
  orphan                    = false
  token_type                = "default-service"
}

resource "vault_token" "kubernetes-sign-login" {
  for_each  = "${local.issuers_content_map}"
  role_name = "${vault_token_auth_backend_role.kubernetes-sign[each.key].role_name}"
  policies  = "${vault_token_auth_backend_role.kubernetes-sign[each.key].allowed_policies}"
  metadata  = {}
  ttl = "5m"
}

resource "vault_policy" "kubernetes-sign" {
  for_each  = "${local.issuers_content_map}"

  name      = "clusters/${var.cluster_name}/certificates/${format("%s",split(":","${each.key}")[1])}"

  policy = templatefile("templates/vault/vault-certificate-sign-role.tftpl", { 
    pki_path              = "${local.ssl.intermediate[split(":","${each.key}")[0]].path}",
    cluster_name          = "${var.cluster_name}",
    pki_path_root         = "${local.root_vault_path_pki}",
    base_vault_path_kv    = "${local.base_vault_path_kv}",
    issuer_name           = format("%s",split(":","${each.key}")[1])
    approle_name          = format("%s",split(":","${each.key}")[1])
    master_instance_list  = local.master_instance_list
    }
  )
}

resource "vault_approle_auth_backend_role" "kubernetes-sign" {
  for_each                = "${local.issuers_content_map}"
  backend                 = "${vault_auth_backend.approle.path}"
  role_name               = format("%s-%s",split(":","${each.key}")[1],split(":","${each.key}")[2])
  token_ttl               = 60
  # secret_id_num_uses      = 1
  token_policies          = [vault_policy.kubernetes-sign[each.key].name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}

