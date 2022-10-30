locals {
  base-cni  = file("${path.module}/templates/99-loopback.conf.tftpl")
}