
resource "yandex_lockbox_secret" "master_key_keeper_approles_role_id_all" {
    for_each = local.master_instance_extra_list_map
    name = "${each.key}-all-role-id"
}

resource "yandex_lockbox_secret_version" "master_key_keeper_approles_role_id_all" {
    for_each = local.master_instance_extra_list_map

    secret_id = yandex_lockbox_secret.master_key_keeper_approles_role_id_all[each.key].id

    dynamic "entries" {
        for_each = local.map_role_id_all
        content {
            key        = replace(entries.key, "-", "-${local.extra_cluster_name}-")
            text_value = local.role_id_all[entries.key].role_id
        }
    }
}

resource "yandex_lockbox_secret" "master_key_keeper_approles_secret_id_all" {
    for_each = local.master_instance_extra_list_map
    name = "${each.key}-all-secret-id"
}

resource "yandex_lockbox_secret_version" "master_key_keeper_approles_secret_id_all" {
    for_each = local.master_instance_extra_list_map

    secret_id = yandex_lockbox_secret.master_key_keeper_approles_secret_id_all[each.key].id

    dynamic "entries" {
        for_each = local.map_secret_id_alls
        content {
            key        = replace(entries.key, "-", "-${local.extra_cluster_name}-")
            text_value = local.secret_id_all[entries.key].secret_id
        }
    }
}
