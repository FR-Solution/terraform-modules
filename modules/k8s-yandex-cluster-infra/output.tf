output "k8s_global_vars" {
  value = module.k8s-global-vars
}

output "kube-apiserver-lb" {
  value = module.k8s-masters.kube-apiserver-lb
}

output "k8s-vault" {
  value = module.k8s-vault
}