resource "yandex_iam_service_account" "master-sa" {
  for_each    = local.master_instance_list_map
  name        = "${each.key}-${var.cluster_name}"
  description = "service account to manage VMs in cloud ${var.cluster_name}" 
}

