
module "k8s-vault-master" {
    source = "../k8s-vault-master"
    k8s_global_vars   = var.k8s_global_vars
    master_instance_list = local.master_instance_list
    master_instance_list_map = local.master_instance_list_map
}   

resource "yandex_lockbox_secret" "master_key_keeper_tokens" {
    for_each = local.master_instance_list_map
    name = "${each.key}-${var.k8s_global_vars.cluster_name}"
}

resource "yandex_lockbox_secret_version" "my_version" {
    for_each = local.master_instance_list_map

    secret_id = yandex_lockbox_secret.master_key_keeper_tokens[each.key].id
    entries {
        key        = "token"
        text_value = module.k8s-vault-master.bootstrap-all[each.key].client_token
    }
}