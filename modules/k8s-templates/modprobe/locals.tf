locals {
  modprobe-k8s = file("${path.module}/templates/k8s.conf.tftpl")
}