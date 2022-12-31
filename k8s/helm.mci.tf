
resource "helm_release" "mci-ubuntu-22" {
  depends_on = [
    helm_release.mcc,
    yandex_resourcemanager_folder_iam_policy.k8s-policy
  ]
  name       = "mci-ubuntu-22"
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
        image_id = "fd8ueg1g3ifoelgdaqhb"
        resolved = true
        replicas = 5
    })
  ]
}


# resource "helm_release" "mci-debian-11" {
#   depends_on = [
#     helm_release.mcc,
#     yandex_resourcemanager_folder_iam_policy.k8s-policy
#   ]
#   name       = "mci-debian-11"
#   chart      = "templates/helm/yandex-machine-controller-instances"
#   namespace  = "fraima-ccm"
#   create_namespace  = true
#   timeout = 6000
#   atomic    = true
#   values = [
#     templatefile("${path.module}/templates/helm/yandex-machine-controller-instances/values.yaml", {
#         image_id = "fd8npaf03ubk7k40ja8r"
#         subnet_id = yandex_vpc_subnet.master-subnets["ru-central1-a"].id
#         zone = "ru-central1-a" 
#         yandex_cloud_controller_sa  = local.yandex-cloud-controller-sa
#         k8s_api_server_fqdn         = module.k8s-yandex-cluster.kube-apiserver-lb-fqdn
#         k8s_api_server_port         = module.k8s-yandex-cluster.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
#         resolved = true
#         replicas = 1
#     })
#   ]
# }

# resource "helm_release" "mci-almalinux-9" {
#   depends_on = [
#     helm_release.mcc,
#     yandex_resourcemanager_folder_iam_policy.k8s-policy
#   ]
#   name       = "mci-almalinux-9"
#   chart      = "templates/helm/yandex-machine-controller-instances"
#   namespace  = "fraima-ccm"
#   create_namespace  = true
#   timeout = 6000
#   atomic    = true
#   values = [
#     templatefile("${path.module}/templates/helm/yandex-machine-controller-instances/values.yaml", {
#         image_id = "fd8pi1k2vinuvqs80r2q"
#         subnet_id = yandex_vpc_subnet.master-subnets["ru-central1-a"].id
#         zone = "ru-central1-a" 
#         yandex_cloud_controller_sa  = local.yandex-cloud-controller-sa
#         k8s_api_server_fqdn         = module.k8s-yandex-cluster.kube-apiserver-lb-fqdn
#         k8s_api_server_port         = module.k8s-yandex-cluster.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
#         resolved = true
#         replicas = 1
#     })
#   ]
# }

# resource "helm_release" "astralinux-alse" {
#   depends_on = [
#     helm_release.mcc,
#     yandex_resourcemanager_folder_iam_policy.k8s-policy
#   ]
#   name       = "astralinux-alse"
#   chart      = "templates/helm/yandex-machine-controller-instances"
#   namespace  = "fraima-ccm"
#   create_namespace  = true
#   timeout = 6000
#   atomic    = true
#   values = [
#     templatefile("${path.module}/templates/helm/yandex-machine-controller-instances/values.yaml", {
#         image_id = "fd81pgsokk5vtjm1qgie"
#         subnet_id = yandex_vpc_subnet.master-subnets["ru-central1-a"].id
#         zone = "ru-central1-a" 
#         yandex_cloud_controller_sa  = local.yandex-cloud-controller-sa
#         k8s_api_server_fqdn         = module.k8s-yandex-cluster.kube-apiserver-lb-fqdn
#         k8s_api_server_port         = module.k8s-yandex-cluster.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
#         resolved = false
#         replicas = 1
#     })
#   ]
# }
