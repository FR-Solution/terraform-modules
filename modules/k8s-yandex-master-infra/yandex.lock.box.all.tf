
locals {
    secret_id_all  = module.k8s-vault-master.secret_id_all
    role_id_all    = module.k8s-vault-master.role_id_all 

    flatten_role_id_all = flatten([
        for index, value in local.role_id_all: [
        index
        ]
    ])

    set_role_id_all = toset(local.flatten_role_id_all)
    map_role_id_all = { for item in local.set_role_id_all :
        item => {}
    }

    flatten_secret_id_alls = flatten([
        for index, value in local.secret_id_all: [
        "${index}"
        ]
    ])

    set_secret_id_alls = toset(local.flatten_secret_id_alls)
    map_secret_id_alls = { for item in local.set_secret_id_alls :
        item => {}
    }
}


resource "yandex_lockbox_secret" "master_key_keeper_approles_role_id_all" {
    for_each = local.master_instance_list_map
    name = "${each.key}-all-role-id"
}

resource "yandex_lockbox_secret_version" "master_key_keeper_approles_role_id_all" {
    for_each = local.master_instance_list_map

    secret_id = yandex_lockbox_secret.master_key_keeper_approles_role_id_all[each.key].id

    dynamic "entries" {
        for_each = local.map_role_id_all
        content {
            key        = entries.key
            text_value = module.k8s-vault-master.role_id_all[entries.key].role_id
        }
    }
}

resource "yandex_lockbox_secret" "master_key_keeper_approles_secret_id_all" {
    for_each = local.master_instance_list_map
    name = "${each.key}-all-secret-id"
}

resource "yandex_lockbox_secret_version" "master_key_keeper_approles_secret_id_all" {
    for_each = local.master_instance_list_map

    secret_id = yandex_lockbox_secret.master_key_keeper_approles_secret_id_all[each.key].id

    dynamic "entries" {
        for_each = local.map_secret_id_alls
        content {
            key        = entries.key
            text_value = module.k8s-vault-master.secret_id_all[entries.key].secret_id
        }
    }
}
