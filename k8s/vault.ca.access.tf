resource "vault_policy" "kubernetes-ca-bootstrap" {
  for_each  = toset(keys(local.ssl.intermediate))

  name      = "clusters/${var.cluster_name}/ca/bootstrap-${each.key}"

  policy = templatefile("templates/vault/vault-intermediate-bootstrap-role.tftpl", { 
    cluster_name        = "${var.cluster_name}",
    approle_name        = "${each.key}"
    }
  )
}

resource "vault_token_auth_backend_role" "kubernetes-ca" {
  for_each                  = toset(keys(local.ssl.intermediate))
  role_name                 = "${each.key}"
  allowed_policies          = [vault_policy.kubernetes-ca-bootstrap[each.key].name]
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

resource "vault_token" "kubernetes-ca-login" {
  for_each  = toset(keys(local.ssl.intermediate))
  role_name = "${vault_token_auth_backend_role.kubernetes-ca[each.key].role_name}"
  policies  = "${vault_token_auth_backend_role.kubernetes-ca[each.key].allowed_policies}"
  metadata  = {}
  ttl = "10m"
}

resource "vault_policy" "kubernetes-ca" {
  for_each  = toset(keys(local.ssl.intermediate))
  
  name      = "clusters/${var.cluster_name}/ca/${each.key}"

  policy = templatefile("templates/vault/vault-intermediate-read-role.tftpl", { 
    pki_path           = "${local.ssl.intermediate["${each.key}"].path}",
    cluster_name       = "${var.cluster_name}",
    approle_name       = "${each.key}"
    }
  )
}

resource "vault_approle_auth_backend_role" "kubernetes-ca" {
  for_each  = toset(keys(local.ssl.intermediate))
  backend                 = vault_auth_backend.approle.path
  role_name               = "${each.key}"
  token_ttl               = 60
  token_policies          = [vault_policy.kubernetes-ca[each.key].name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}
