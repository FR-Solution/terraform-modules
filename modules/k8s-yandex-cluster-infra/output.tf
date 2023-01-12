output "k8s_global_vars" {
  value = module.k8s-global-vars
}

output "kube-apiserver-lb" {
  value = module.k8s-yandex-master-infra.kube-apiserver-lb
}
