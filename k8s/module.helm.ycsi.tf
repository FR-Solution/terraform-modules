module "k8s-yandex-csi-controller" {
  depends_on = [
    module.cilium
  ]
  source = "../modules/helm-yandex-csi-controller"

  chart_version = "0.0.4"

  global_vars         = local.global_vars
  
  extra_values        = {} 
}
