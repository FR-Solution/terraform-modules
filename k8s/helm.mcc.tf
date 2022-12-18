
resource "helm_release" "mcc" {
  depends_on = [
    helm_release.coredns
  ]
  name       = "mcc"
  chart      = "templates/helm/machine-controller-manager"
  namespace  = "fraima-ccm"
  create_namespace  = true
  timeout = 6000
}


resource "helm_release" "mci" {
  depends_on = [
    helm_release.mcc
  ]
  name       = "mci"
  chart      = "templates/helm/yandex-machine-controller-instances"
  namespace  = "fraima-ccm"
  create_namespace  = true
  timeout = 6000

  values = [
    templatefile("${path.module}/templates/helm/machine-controller-instances/values.yaml", {
      subnet_id = yandex_vpc_subnet.master-subnets["ru-central1-a"].id
    })
  ]
}