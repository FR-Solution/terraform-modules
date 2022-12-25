
# locals {
#     secret_id_cert  = module.k8s-vault-master.secret_id_cert
#     role_id_cert    = module.k8s-vault-master.role_id_cert 

#     flatten_role_id_cert = flatten([
#         for index, value in local.role_id_cert: [
#         "${split(":", index)[0]}:${split(":", index)[1]}"
#         ]
#     ])

#     set_role_id_cert = toset(local.flatten_role_id_cert)
#     map_role_id_cert = { for item in local.set_role_id_cert :
#         item => {}
#     }

#     flatten_secret_id_certs = flatten([
#         for index, value in local.secret_id_cert: [
#         "${split(":", index)[0]}:${split(":", index)[1]}"
#         ]
#     ])

#     set_secret_id_certs = toset(local.flatten_secret_id_certs)
#     map_secret_id_certs = { for item in local.set_secret_id_certs :
#         item => {}
#     }
# }


# resource "yandex_lockbox_secret" "master_key_keeper_approles_role_id_certificates" {
#     for_each = local.master_instance_list_map
#     name = "${each.key}-cert-role-id"
# }

# resource "yandex_lockbox_secret_version" "master_key_keeper_approles_role_id_certificates" {
#     for_each = local.master_instance_list_map

#     secret_id = yandex_lockbox_secret.master_key_keeper_approles_role_id_certificates[each.key].id

#     dynamic "entries" {
#         for_each = local.map_role_id_cert
#         content {
#             key        = "${split(":",entries.key)[1]}"
#             text_value = module.k8s-vault-master.role_id_cert["${entries.key}:${each.key}"].role_id
#         }
#     }
# }

# resource "yandex_lockbox_secret" "master_key_keeper_approles_secret_id_certificates" {
#     for_each = local.master_instance_list_map
#     name = "${each.key}-cert-secret-id"
# }

# resource "yandex_lockbox_secret_version" "master_key_keeper_approles_secret_id_certificates" {
#     for_each = local.master_instance_list_map

#     secret_id = yandex_lockbox_secret.master_key_keeper_approles_secret_id_certificates[each.key].id

#     dynamic "entries" {
#         for_each = local.map_secret_id_certs
#         content {
#             key        = "${split(":",entries.key)[1]}"
#             text_value = module.k8s-vault-master.secret_id_cert["${entries.key}:${each.key}"].secret_id
#         }
#     }
# }
