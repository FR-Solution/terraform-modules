
# resource "vault_pki_secret_backend_cert" "terraform-kubeconfig" {
#   depends_on = [module.k8s-vault]

#   backend = module.k8s-global-vars.ssl.intermediate.kubernetes-ca.path
#   name = "kube-apiserver-kubelet-client"

#   common_name = "custom:terraform-kubeconfig"
# }


# # locals {
# #   api_address = tolist(tolist(yandex_lb_network_load_balancer.api-internal.listener)[0].external_address_spec)[0].address
# # }

# resource "null_resource" "cluster" {
#     for_each    = module.k8s-global-vars.ssl_for_each_map.master_instance_list_map

#     triggers = {
#         cluster_instance_ids = join(",", yandex_compute_instance.master[*][each.key].id)
#     }

#     connection {
#         host        = element(yandex_compute_instance.master[*][each.key].network_interface.0.nat_ip_address, 0)
#         user        = "dkot"
#         type        = "ssh"
#         private_key = file("/home/dk/.ssh/id_rsa")
#         agent = "false"
#     }
#     # TODO поправить команду так, что бы не падала сборка
#     provisioner "remote-exec" {
#         inline = [
#             "until cloud-init status | grep -i done; do sleep 1s; done",
#             "until netstat -tulpn | grep 443; do sleep 1s; done",
#             "sudo kubectl --request-timeout=5m cluster-info  --kubeconfig=/etc/kubernetes/kube-apiserver/kubeconfig"
#         ]
#     }
# }
