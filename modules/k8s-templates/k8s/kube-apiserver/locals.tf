locals {
  kube-apiserver-audit = file("${path.module}/templates/audit.yaml.tftpl")
}