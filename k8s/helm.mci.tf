
resource "helm_release" "mci-ru-central1-a" {
  depends_on = [
    helm_release.mcc,
    yandex_resourcemanager_folder_iam_policy.k8s-policy
  ]
  name       = "mci-ru-central1-a"
  chart      = "templates/helm/yandex-machine-controller-instances"
  namespace  = "fraima-ccm"
  create_namespace  = true
  timeout = 6000
  atomic    = true
  values = [
    templatefile("${path.module}/templates/helm/yandex-machine-controller-instances/values.yaml", {
        subnet_id = yandex_vpc_subnet.master-subnets["ru-central1-a"].id
        zone = "ru-central1-a" 
        yandex_cloud_controller_sa  = local.yandex-cloud-controller-sa
        k8s_api_server_fqdn         = module.k8s-yandex-cluster.kube-apiserver-lb-fqdn
        k8s_api_server_port         = module.k8s-yandex-cluster.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
    })
  ]
}

# resource "helm_release" "mci-ru-central1-b" {
#   depends_on = [
#     helm_release.mcc
#   ]
#   name       = "mci-ru-central1-b"
#   chart      = "templates/helm/yandex-machine-controller-instances"
#   namespace  = "fraima-ccm"
#   create_namespace  = true
#   timeout = 6000

#   values = [
#     templatefile("${path.module}/templates/helm/yandex-machine-controller-instances/values.yaml", {
#         subnet_id = yandex_vpc_subnet.master-subnets["ru-central1-b"].id
#         zone = "ru-central1-b" 
#     })
#   ]
# }

# resource "helm_release" "mci-ru-central1-c" {
#   depends_on = [
#     helm_release.mcc
#   ]
#   name       = "mci-ru-central1-c"
#   chart      = "templates/helm/yandex-machine-controller-instances"
#   namespace  = "fraima-ccm"
#   create_namespace  = true
#   timeout = 6000

#   values = [
#     templatefile("${path.module}/templates/helm/yandex-machine-controller-instances/values.yaml", {
#         subnet_id = yandex_vpc_subnet.master-subnets["ru-central1-c"].id
#         zone = "ru-central1-c" 
#     })
#   ]
# }