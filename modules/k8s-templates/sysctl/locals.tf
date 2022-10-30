locals {
  sysctl-network    = file("${path.module}/templates/99-network.conf.tftpl")
}