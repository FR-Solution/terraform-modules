data "yandex_iam_policy" "k8s-policy" {
  binding {
    role = "admin"

    members = local.merge_members_admin
  }
}

resource "yandex_resourcemanager_folder_iam_policy" "k8s-policy" {
  depends_on = [
    module.k8s-yandex-cluster
  ]
  folder_id   = data.yandex_resourcemanager_folder.current.id
  policy_data = data.yandex_iam_policy.k8s-policy.policy_data
}


locals {
  controller_members_admin = [
      "serviceAccount:${yandex_iam_service_account.yandex-cloud-controller.id}",
      "serviceAccount:${yandex_iam_service_account.yandex-csi-controller.id}",
      "serviceAccount:${yandex_iam_service_account.yandex-machine-controller.id}",
    ]
  master_members_admin = module.k8s-yandex-cluster.master_sa_policy

  merge_members_admin = concat(local.controller_members_admin, local.master_members_admin)
}
