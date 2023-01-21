
# resource "null_resource" "cluster" {
#     for_each    = local.master_instance_list_map

#     triggers = {
#         cluster_instance_ids = join(",", yandex_compute_instance.master[*][each.key].id)
#     }

#     connection {
#         host        = element(yandex_compute_instance.master[*][each.key].network_interface.0.nat_ip_address, 0)
#         user        = var.k8s_global_vars.base.ssh_username
#         type        = "ssh"
#         private_key = file(split(".pub", var.k8s_global_vars.base.ssh_rsa_path)[0])
#         agent = "false"
#     }
#     # TODO поправить команду так, что бы не падала сборка
#     provisioner "remote-exec" {
#         inline = [
#             "until cloud-init status | grep -i done; do sleep 1s; done",
#             "sudo kubectl --request-timeout=5m cluster-info  --kubeconfig=/etc/kubernetes/admin.conf"
#         ]
#     }
# }

# # resource "null_resource" "cluster" {
# #   depends_on = [
# #     yandex_compute_instance.master
# #   ]

# #   provisioner "local-exec" {
# #     command = <<EOT
# #       timeout 10m \
# #       kubectl config set-cluster  ${var.k8s_global_vars.cluster_metadata.cluster_name} \
# #       --server=https://${tolist(tolist(yandex_lb_network_load_balancer.api-external.listener)[0].external_address_spec)[0].address} \
# #       --insecure-skip-tls-verify && \
# #       kubectl \
# #       --request-timeout=5m \
# #       cluster-info
# #     EOT
# #   }
# # }
