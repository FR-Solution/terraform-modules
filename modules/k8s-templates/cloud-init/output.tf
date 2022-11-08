output "master" {
  value = local.cloud-init-template-map
}

output "worker" {
  value = local.cloud-init-worker-map
}
