
locals {
    secret_id_external_ca            = module.k8s-vault-master.secret_id_external_ca 
    role_id_external_ca              = module.k8s-vault-master.role_id_external_ca 

    flatten_role_id_external_ca = flatten([
        for index, value in local.role_id_external_ca: [
        "${split(":", index)[0]}"
        ]
    ])

    set_role_id_external_ca = toset(local.flatten_role_id_external_ca)
    map_role_id_external_ca = { for item in local.set_role_id_external_ca :
        item => {}
    }

    flatten_secret_id_external_ca = flatten([
        for index, value in local.secret_id_external_ca: [
        "${split(":", index)[0]}"
        ]
    ])

    set_secret_id_external_ca = toset(local.flatten_secret_id_external_ca)
    map_secret_id_external_ca = { for item in local.set_secret_id_external_ca :
        item => {}
    }
}


resource "yandex_lockbox_secret" "master_key_keeper_approles_role_id_external_ca" {
    for_each = local.master_instance_list_map
    name = "${each.key}-external-ca-role-id"
}

resource "yandex_lockbox_secret_version" "master_key_keeper_approles_role_id_external_ca" {
    for_each = local.master_instance_list_map

    secret_id = yandex_lockbox_secret.master_key_keeper_approles_role_id_external_ca[each.key].id

    dynamic "entries" {
        for_each = local.map_role_id_external_ca
        content {
            key        = "${split(":",entries.key)[0]}"
            text_value = module.k8s-vault-master.role_id_external_ca["${entries.key}:${each.key}"].role_id
        }
    }
}

resource "yandex_lockbox_secret" "master_key_keeper_approles_secret_id_external_ca" {
    for_each = local.master_instance_list_map
    name = "${each.key}-external-ca-secret-id"
}

resource "yandex_lockbox_secret_version" "master_key_keeper_approles_secret_id_external_ca" {
    for_each = local.master_instance_list_map

    secret_id = yandex_lockbox_secret.master_key_keeper_approles_secret_id_external_ca[each.key].id

    dynamic "entries" {
        for_each = local.map_secret_id_external_ca
        content {
            key        = "${split(":",entries.key)[0]}"
            text_value = module.k8s-vault-master.secret_id_external_ca["${entries.key}:${each.key}"].secret_id
        }
    }
}
