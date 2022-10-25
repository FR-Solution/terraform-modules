locals {
  k8s-addresses = {
    local_api_address = format("%s.1", join(".", slice(split(".",var.service_cidr), 0, 3)) )
    dns_address       = format("%s.10", join(".", slice(split(".",var.service_cidr), 0, 3)) )
  }
}