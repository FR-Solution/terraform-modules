resource "vault_mount" "core_root_ca" {
  path                      = var.root_vault_path_pki
  type                      = "pki"
  description               = "root infrastruction"
  default_lease_ttl_seconds = 321408000
  max_lease_ttl_seconds     = 321408000
}

resource "vault_pki_secret_backend_root_cert" "core_root" {
  backend              = vault_mount.core_root_ca.path
  type                 = "internal"
  common_name          = "Root CA"
  ttl                  = 321408000
  format               = "pem"
  private_key_format   = "der"
  key_type             = "rsa"
  key_bits             = 4096
  exclude_cn_from_sans = true
  province             = "CA"
}
