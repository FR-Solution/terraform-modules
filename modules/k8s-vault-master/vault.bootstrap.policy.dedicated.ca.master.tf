
# resource "vault_policy" "kubernetes-dedicated-ca-bootstrap-master" {
#   for_each  = local.intermediate_content_map_master

#   name      = "${var.k8s_global_vars.global_path.base_vault_path}/bootstrap-dedicated-ca:${split(":",each.key)[0]}"

#   policy = templatefile("${path.module}/templates/vault/vault-bootstarp-approle-dedicated.tftpl", { 
#     base_vault_path_approle = var.k8s_global_vars.global_path.base_vault_path_approle
#     role_name               = split(":",each.key)[0]
#     master_instance_list    = var.master_instance_list

#     }
#   )
# }
