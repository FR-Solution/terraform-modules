variable "root-pki" {
  description = "Map of vault with their parameters"
  type = map(object({
    path                      = optional(string, "pki-root")
    description               = optional(string, "Root CA")
    default_lease_ttl_seconds = optional(number, 321408000)
    max_lease_ttl_seconds     = optional(number, 321408000)
    type                      = optional(string, "internal")
    common_name               = optional(string, "Root CA")
    ttl                       = optional(number, 321408000)
    format                    = optional(string, "pem")
    private_key_format        = optional(string, "der")
    key_type                  = optional(string, "rsa")
    key_bits                  = optional(number, 4096)
    exclude_cn_from_sans      = optional(bool,   true)
    province                  = optional(string, "CA")


  }))
  default = {
    "key" = {
      description               = "Root CA"
      path                      = "pki-root"
      type                      = "internal"
      common_name               = "Root CA"
      format                    = "pem"
      key_type                  = "rsa"
      private_key_format        = "der"
      province                  = "CA"
      exclude_cn_from_sans      = true
      default_lease_ttl_seconds = 321408000
      max_lease_ttl_seconds     = 321408000
      ttl                       = 321408000
      key_bits                  = 4096

    }
  }
}
