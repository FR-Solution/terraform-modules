
locals {
    secret_id_ca            = module.k8s-vault-master.secret_id_ca 
    role_id_ca              = module.k8s-vault-master.role_id_ca 

    flatten_role_id_ca = flatten([
        for index, value in local.role_id_ca: [
        "${split(":", index)[0]}"
        ]
    ])

    set_role_id_ca = toset(local.flatten_role_id_ca)
    map_role_id_ca = { for item in local.set_role_id_ca :
        item => {}
    }

    flatten_secret_id_ca = flatten([
        for index, value in local.secret_id_ca: [
        "${split(":", index)[0]}"
        ]
    ])

    set_secret_id_ca = toset(local.flatten_secret_id_ca)
    map_secret_id_ca = { for item in local.set_secret_id_ca :
        item => {}
    }
}


resource "yandex_lockbox_secret" "master_key_keeper_approles_role_id_ca" {
    for_each = local.master_instance_list_map
    name = "${each.key}-ca-role-id"
}

resource "yandex_lockbox_secret_version" "master_key_keeper_approles_role_id_ca" {
    for_each = local.master_instance_list_map

    secret_id = yandex_lockbox_secret.master_key_keeper_approles_role_id_ca[each.key].id

    dynamic "entries" {
        for_each = local.map_role_id_ca
        content {
            key        = "${split(":",entries.key)[0]}"
            text_value = module.k8s-vault-master.role_id_ca["${entries.key}:${each.key}"].role_id
        }
    }
}

resource "yandex_lockbox_secret" "master_key_keeper_approles_secret_id_ca" {
    for_each = local.master_instance_list_map
    name = "${each.key}-ca-secret-id"
}

resource "yandex_lockbox_secret_version" "master_key_keeper_approles_secret_id_ca" {
    for_each = local.master_instance_list_map

    secret_id = yandex_lockbox_secret.master_key_keeper_approles_secret_id_ca[each.key].id

    dynamic "entries" {
        for_each = local.map_secret_id_ca
        content {
            key        = "${split(":",entries.key)[0]}"
            text_value = module.k8s-vault-master.secret_id_ca["${entries.key}:${each.key}"].secret_id
        }
    }
}
