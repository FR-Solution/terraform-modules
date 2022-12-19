
resource "helm_release" "mci-ru-central1-a" {
  depends_on = [
    helm_release.mcc
  ]
  name       = "mci-ru-central1-a"
  chart      = "templates/helm/yandex-machine-controller-instances"
  namespace  = "fraima-ccm"
  create_namespace  = true
  timeout = 6000

  values = [
    templatefile("${path.module}/templates/helm/yandex-machine-controller-instances/values.yaml", {
        subnet_id = yandex_vpc_subnet.master-subnets["ru-central1-a"].id
        zone = "ru-central1-a" 
    })
  ]
}

resource "helm_release" "mci-ru-central1-b" {
  depends_on = [
    helm_release.mcc
  ]
  name       = "mci-ru-central1-b"
  chart      = "templates/helm/yandex-machine-controller-instances"
  namespace  = "fraima-ccm"
  create_namespace  = true
  timeout = 6000

  values = [
    templatefile("${path.module}/templates/helm/yandex-machine-controller-instances/values.yaml", {
        subnet_id = yandex_vpc_subnet.master-subnets["ru-central1-b"].id
        zone = "ru-central1-b" 
    })
  ]
}

resource "helm_release" "mci-ru-central1-c" {
  depends_on = [
    helm_release.mcc
  ]
  name       = "mci-ru-central1-c"
  chart      = "templates/helm/yandex-machine-controller-instances"
  namespace  = "fraima-ccm"
  create_namespace  = true
  timeout = 6000

  values = [
    templatefile("${path.module}/templates/helm/yandex-machine-controller-instances/values.yaml", {
        subnet_id = yandex_vpc_subnet.master-subnets["ru-central1-c"].id
        zone = "ru-central1-c" 
    })
  ]
}