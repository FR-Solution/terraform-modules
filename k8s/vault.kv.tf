
resource "tls_private_key" "kube_apiserver_sa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
} 

resource "vault_kv_secret_v2" "kube_apiserver_sa" {
  mount = "${vault_mount.kubernetes-secrets.path}"
  name                       = "kube-apiserver-sa"
  cas                        = 1
  delete_all_versions        = true
  data_json = jsonencode(
  {
    private = "${tls_private_key.kube_apiserver_sa_key.private_key_pem   }",
    public = "${tls_private_key.kube_apiserver_sa_key.public_key_pem  }"
  }
  )
}

resource "vault_policy" "kubernetes-kv-bootstrap" {
  for_each  = toset(keys(local.secrets))

  name      = "clusters/${var.cluster_name}/ca/bootstrap-${each.key}"

  policy = templatefile("templates/vault/vault-kv-bootstrap-role.tftpl", { 
    cluster_name        = "${var.cluster_name}",
    approle_name        = "${each.key}"
    }
  )
}

resource "vault_token_auth_backend_role" "kubernetes-kv" {
  for_each                  = toset(keys(local.secrets))
  role_name                 = "${each.key}"
  allowed_policies          = [vault_policy.kubernetes-kv-bootstrap[each.key].name]
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

resource "vault_token" "kubernetes-kv-login" {
  for_each  = toset(keys(local.secrets))
  role_name = "${vault_token_auth_backend_role.kubernetes-kv[each.key].role_name}"
  policies  = "${vault_token_auth_backend_role.kubernetes-kv[each.key].allowed_policies}"
  metadata  = {}
  ttl = "10m"
}

resource "vault_policy" "kubernetes-kv" {
  name      = "clusters/${var.cluster_name}/kv/sa"

  policy = templatefile("templates/vault/vault-kv-read.tftpl", { 
    cluster_name       = "${var.cluster_name}",
    approle_name       = "kube-apiserver-sa"
    }
  )
}

resource "vault_approle_auth_backend_role" "kubernetes-kv" {
  backend                 = "${vault_auth_backend.approle.path}"
  role_name               = "kube-apiserver-sa"
  token_ttl               = 60
  token_policies          = [vault_policy.kubernetes-kv.name]
  secret_id_bound_cidrs   = []
  token_bound_cidrs       = []
}
