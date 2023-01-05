locals {
  yandex-cloud-controller-sa = {
    service_account_id  = yandex_iam_service_account.yandex-cloud-controller.id
    created_at          = yandex_iam_service_account.yandex-cloud-controller.created_at
    folder_id           = yandex_iam_service_account.yandex-cloud-controller.folder_id
    id                  = yandex_iam_service_account_key.yandex-cloud-controller-key.id
    key_algorithm       = yandex_iam_service_account_key.yandex-cloud-controller-key.key_algorithm
    public_key          = yandex_iam_service_account_key.yandex-cloud-controller-key.public_key
    private_key         = yandex_iam_service_account_key.yandex-cloud-controller-key.private_key
    vpc_id              = yandex_vpc_network.cluster-vpc.id
    route_table_id      = yandex_vpc_route_table.cluster-vpc-route-table.id
  }
}

resource "helm_release" "ycc" {
  depends_on = [
    yandex_resourcemanager_folder_iam_policy.k8s-policy
  ]
  name       = "ycc"
  chart      = "templates/helm/yandex-cloud-controller"
  namespace  = "fraima-ccm"
  create_namespace  = true
  values = [
    templatefile("templates/helm/yandex-cloud-controller/values.yaml", {
        yandex_cloud_controller_sa = local.yandex-cloud-controller-sa
        cluster_name        = var.cluster_name
        pod_cidr            = var.cidr.pod
        k8s_api_server      = module.k8s-yandex-cluster.k8s_global_vars.kube_apiserver_lb_fqdn
        k8s_api_server_port = module.k8s-yandex-cluster.k8s_global_vars.kubernetes-ports.kube-apiserver-port-lb
    })
  ]
  timeout   = 6000
  wait      = true
  atomic    = true
}
