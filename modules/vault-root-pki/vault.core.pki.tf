resource "vault_mount" "core_root_ca" {
  path                      = var.root-pki.key.path
  type                      = "pki"
  description               = var.root-pki.key.description
  default_lease_ttl_seconds = var.root-pki.key.default_lease_ttl_seconds
  max_lease_ttl_seconds     = var.root-pki.key.max_lease_ttl_seconds
}

resource "vault_pki_secret_backend_root_cert" "core_root" {
  backend              = vault_mount.core_root_ca.path
  type                 = var.root-pki.key.type
  common_name          = var.root-pki.key.common_name
  ttl                  = var.root-pki.key.ttl
  format               = var.root-pki.key.format
  private_key_format   = var.root-pki.key.private_key_format
  key_type             = var.root-pki.key.key_type
  key_bits             = var.root-pki.key.key_bits
  exclude_cn_from_sans = var.root-pki.key.exclude_cn_from_sans
  province             = var.root-pki.key.province
}

