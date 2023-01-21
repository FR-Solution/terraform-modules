resource "vault_mount" "core_root_ca" {
  path                      = var.root-pki.extra-args.path
  type                      = "pki"
  description               = var.root-pki.extra-args.description
  default_lease_ttl_seconds = var.root-pki.extra-args.default_lease_ttl_seconds
  max_lease_ttl_seconds     = var.root-pki.extra-args.max_lease_ttl_seconds
}

resource "vault_pki_secret_backend_root_cert" "core_root" {
  backend              = vault_mount.core_root_ca.path
  type                 = var.root-pki.extra-args.type
  common_name          = var.root-pki.extra-args.common_name
  ttl                  = var.root-pki.extra-args.ttl
  format               = var.root-pki.extra-args.format
  private_key_format   = var.root-pki.extra-args.private_key_format
  key_type             = var.root-pki.extra-args.key_type
  key_bits             = var.root-pki.extra-args.key_bits
  exclude_cn_from_sans = var.root-pki.extra-args.exclude_cn_from_sans
  province             = var.root-pki.extra-args.province
}

