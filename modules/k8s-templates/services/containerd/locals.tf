locals {
  containerd-service = file("${path.module}/templates/service.tftpl")

  containerd-config = file("${path.module}/templates/config.toml.tftpl")
}