
resource "yandex_iam_service_account_key" "yandex-k8s-controllers-key" {
  service_account_id = data.yandex_iam_service_account.yandex-k8s-controllers.id
  description        = "key for service account"
  key_algorithm      = "RSA_4096"

}

locals {
  yandex-k8s-controllers-sa = {
    service_account_id  = data.yandex_iam_service_account.yandex-k8s-controllers.id
    created_at          = data.yandex_iam_service_account.yandex-k8s-controllers.created_at
    folder_id           = data.yandex_iam_service_account.yandex-k8s-controllers.folder_id
    vpc_id              = data.yandex_vpc_network.cluster-vpc.id
    route_table_id      = data.yandex_vpc_route_table.cluster-vpc-route-table.id
    service_account_json = {
      id                  = yandex_iam_service_account_key.yandex-k8s-controllers-key.id
      service_account_id  = yandex_iam_service_account_key.yandex-k8s-controllers-key.service_account_id
      created_at          = yandex_iam_service_account_key.yandex-k8s-controllers-key.created_at
      key_algorithm       = yandex_iam_service_account_key.yandex-k8s-controllers-key.key_algorithm
      public_key          = yandex_iam_service_account_key.yandex-k8s-controllers-key.public_key
      private_key         = yandex_iam_service_account_key.yandex-k8s-controllers-key.private_key
    }
  }
}

resource "kubernetes_namespace_v1" "yandex_provider" {
  depends_on = [
    null_resource.cluster,
    yandex_compute_instance.master,
    yandex_lb_target_group.master-tg,
    yandex_lb_network_load_balancer.api-external,
    yandex_dns_recordset.api-external,
    yandex_dns_zone.cluster-external,
    module.firewall
  ]
  metadata {
    name = var.k8s_global_vars.k8s_provider.namespace
  }
}

resource "kubernetes_secret_v1" "yandex_provider" {
    depends_on = [
      null_resource.cluster,
      kubernetes_namespace_v1.yandex_provider,
      module.firewall
    ]
  metadata {
    name = data.yandex_iam_service_account.yandex-k8s-controllers.name
    namespace = var.k8s_global_vars.k8s_provider.namespace
  }

  data = {
    serviceAccountJSON  = base64encode(jsonencode(local.yandex-k8s-controllers-sa.service_account_json))
    folderID            = base64encode(local.yandex-k8s-controllers-sa.folder_id)
    vpcID               = base64encode(local.yandex-k8s-controllers-sa.vpc_id)
    routeTableID        = base64encode(local.yandex-k8s-controllers-sa.route_table_id)
  }

  type = "Opaque"
}

