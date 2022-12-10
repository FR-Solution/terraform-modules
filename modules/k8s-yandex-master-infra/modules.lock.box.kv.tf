
locals {
    secret_id_kv            = module.k8s-vault-master.secret_id_kv 
    role_id_kv              = module.k8s-vault-master.role_id_kv 

    flatten_role_id_kv = flatten([
        for index, value in local.role_id_kv: [
        "${split(":", index)[0]}"
        ]
    ])

    set_role_id_kv = toset(local.flatten_role_id_kv)
    map_role_id_kv = { for item in local.set_role_id_kv :
        item => {}
    }

    flatten_secret_id_kv = flatten([
        for index, value in local.secret_id_kv: [
        "${split(":", index)[0]}"
        ]
    ])

    set_secret_id_kv = toset(local.flatten_secret_id_kv)
    map_secret_id_kv = { for item in local.set_secret_id_kv :
        item => {}
    }
}


resource "yandex_lockbox_secret" "master_key_keeper_approles_role_id_kv" {
    for_each = local.master_instance_list_map
    name = "${each.key}-kv-role-id"
}

resource "yandex_lockbox_secret_version" "master_key_keeper_approles_role_id_kv" {
    for_each = local.master_instance_list_map

    secret_id = yandex_lockbox_secret.master_key_keeper_approles_role_id_kv[each.key].id

    dynamic "entries" {
        for_each = local.map_role_id_kv
        content {
            key        = "${split(":",entries.key)[0]}"
            text_value = module.k8s-vault-master.role_id_kv["${entries.key}:${each.key}"].role_id
        }
    }
}

resource "yandex_lockbox_secret" "master_key_keeper_approles_secret_id_kv" {
    for_each = local.master_instance_list_map
    name = "${each.key}-kv-secret-id"
}

resource "yandex_lockbox_secret_version" "master_key_keeper_approles_secret_id_kv" {
    for_each = local.master_instance_list_map

    secret_id = yandex_lockbox_secret.master_key_keeper_approles_secret_id_kv[each.key].id

    dynamic "entries" {
        for_each = local.map_secret_id_kv
        content {
            key        = "${split(":",entries.key)[0]}"
            text_value = module.k8s-vault-master.secret_id_kv["${entries.key}:${each.key}"].secret_id
        }
    }
}
