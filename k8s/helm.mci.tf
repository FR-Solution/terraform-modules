
# resource "helm_release" "mci-ubuntu-22-ru-central1-b" {
#   depends_on = [
#     helm_release.mcc,
#   ]
#   name       = "mg-ubuntu-22-ru-central1-b"

#   repository = "https://helm.fraima.io"
#   chart      = "machine-group"
#   version    = "0.1.5"

#   namespace  = "kube-fraima-ccm"
#   create_namespace  = true
#   timeout = 6000
#   atomic    = true
#   values = [
#     templatefile("${path.module}/templates/helm/yandex-machine-controller-instances/values.yaml", {
#         subnet_id = yandex_vpc_subnet.master-subnets["ru-central1-b"].id
#         zone = "ru-central1-b" 
#         k8s_api_server_fqdn         = module.k8s-yandex-cluster.k8s_global_vars.kube_apiserver_lb_fqdn
#         k8s_api_server_port         = module.k8s-yandex-cluster.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
#         image_id = "fd8kdq6d0p8sij7h5qe3"
#         resolved = true
#         replicas = 1
#     })
#   ]
# }


# resource "helm_release" "mci-ubuntu-22-ru-central1-c" {
#   depends_on = [
#     helm_release.mcc,
#   ]
#   name       = "mg-ubuntu-22-ru-central1-c"

#   repository = "https://helm.fraima.io"
#   chart      = "machine-group"
#   version    = "0.1.5"

#   namespace  = "kube-fraima-ccm"
#   create_namespace  = true
#   timeout = 6000
#   atomic    = true
#   values = [
#     templatefile("${path.module}/templates/helm/yandex-machine-controller-instances/values.yaml", {
#         image_id = "fd8kdq6d0p8sij7h5qe3"
#         subnet_id = yandex_vpc_subnet.master-subnets["ru-central1-c"].id
#         zone = "ru-central1-c" 
#         k8s_api_server_fqdn         = module.k8s-yandex-cluster.k8s_global_vars.kube_apiserver_lb_fqdn
#         k8s_api_server_port         = module.k8s-yandex-cluster.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
#         resolved = true
#         replicas = 1
#     })
#   ]
# }

# resource "helm_release" "mci-almalinux-9" {
#   depends_on = [
#     helm_release.mcc,
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
#         k8s_api_server_fqdn         = module.k8s-yandex-cluster.k8s_global_vars.kube_apiserver_lb_fqdn
#         k8s_api_server_port         = module.k8s-yandex-cluster.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
#         resolved = true
#         replicas = 1
#     })
#   ]
# }

# resource "helm_release" "astralinux-alse" {
#   depends_on = [
#     helm_release.mcc,
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
#         k8s_api_server_fqdn         = module.k8s-yandex-cluster.k8s_global_vars.kube_apiserver_lb_fqdn
#         k8s_api_server_port         = module.k8s-yandex-cluster.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
#         resolved = false
#         replicas = 1
#     })
#   ]
# }
