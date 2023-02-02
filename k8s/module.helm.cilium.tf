module "cilium" {
  depends_on = [
    module.k8s-yandex-cloud-controller
  ]
  source = "../modules/helm-yandex-cilium"

  chart_version = "1.12.0"

  global_vars         = local.global_vars
  cluster_id          = 11
  extra_values        = {} 
}
