
resource "helm_release" "ycc" {

  name       = "ycc"
  chart      = "templates/helm/yandex-cloud-controller"
  namespace  = "fraima-ccm"
  create_namespace  = true
  values = [
    templatefile("templates/helm/yandex-cloud-controller/values.yaml", {
        yandex_cloud_controller_sa  = local.yandex-k8s-controllers-sa
        cluster_name                = var.cluster_name
        pod_cidr                    = var.cidr.pod
        k8s_api_server              = module.k8s-yandex-cluster.k8s_global_vars.kube_apiserver_lb_fqdn
        k8s_api_server_port         = module.k8s-yandex-cluster.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
    })
  ]
  timeout   = 6000
  wait      = true
  atomic    = true
}
