##### ROOT #####################
### ->
# resource "vault_pki_secret_backend_root_cert" "core_root" {
#   backend              = vault_mount.core_root_ca.path
#   type                 = "internal"
#   common_name          = "Root CA"
#   ttl                  = 321408000
#   format               = "pem"
#   private_key_format   = "der"
#   key_type             = "rsa"
#   key_bits             = 4096
#   exclude_cn_from_sans = true
#   province             = "CA"
# }

##### K8S INTERMEDIATE ROOT #####################
### ->
resource "vault_pki_secret_backend_root_cert" "root" {
  # depends_on           = [vault_pki_secret_backend_root_cert.core_root]
  for_each             = var.k8s_certificate_vars.ssl.root_ca
  backend              = "${vault_mount.root_ca[each.key].path}"
  type                 = "${each.value.type}"
  common_name          = "${each.value.common_name}"
  ttl                  = 321408000
  format               = "pem"
  private_key_format   = "der"
  key_type             = "rsa"
  key_bits             = 4096
  exclude_cn_from_sans = true
  province             = "CA"
}

##### K8S INTERMEDIATE #####################
### ->
resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate" {
  depends_on  = [vault_pki_secret_backend_root_cert.root]
  for_each    = var.k8s_certificate_vars.ssl.intermediate
  backend     = "${vault_mount.intermediate[each.key].path}"
  type        = "${each.value.type}"
  common_name = "${each.value.common_name}"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "intermediate" {
  for_each      = var.k8s_certificate_vars.ssl.intermediate
  backend       = "${each.value.root_path}"
  csr           = vault_pki_secret_backend_intermediate_cert_request.intermediate[each.key].csr
  common_name   = vault_pki_secret_backend_intermediate_cert_request.intermediate[each.key].common_name
  organization  = "${each.value.organization}"
  province      = "CA"
  revoke        = true
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate" {
  for_each    = var.k8s_certificate_vars.ssl.intermediate
  backend     = vault_mount.intermediate[each.key].path
  certificate = vault_pki_secret_backend_root_sign_intermediate.intermediate[each.key].certificate
}
