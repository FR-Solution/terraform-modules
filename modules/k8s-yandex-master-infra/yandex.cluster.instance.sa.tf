resource "yandex_iam_service_account" "master-sa" {
  for_each    = local.master_instance_list_map

  name        = "${each.key}-${var.k8s_global_vars.cluster_name}"
  description = "service account to manage VMs in cloud ${var.k8s_global_vars.cluster_name}" 
}

resource "yandex_resourcemanager_folder_iam_policy" "folder_admin_policy" {
  folder_id   = var.cloud_metadata.folder_id
  policy_data = data.yandex_iam_policy.admin.policy_data
  lifecycle {
    ignore_changes = [
      policy_data
    ]
  }
}