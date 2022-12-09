resource "yandex_iam_service_account" "master-sa" {
  for_each    = local.master_instance_list_map

  name        = "${each.key}-${var.k8s_global_vars.cluster_name}"
  description = "service account to manage VMs in cloud ${var.k8s_global_vars.cluster_name}" 
}

resource "yandex_resourcemanager_folder_iam_binding" "admin-account-iam" {
  for_each    = local.master_instance_list_map
  folder_id   = var.cloud_metadata.folder_id
  role        = "admin"
  members     = [
    "serviceAccount:${yandex_iam_service_account.master-sa[each.key].id}",
  ]
}
