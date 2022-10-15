
# #### WORKERS ######
# ##-->

# resource "yandex_compute_instance" "worker" {
#   depends_on = [
#     helm_release.base
#     ]
#     for_each    = local.worker_instance_list_map
#     name        = "${each.key}-${var.cluster_name}"
#     hostname    = format("%s.%s.%s", "${each.key}" ,var.cluster_name, var.base_domain)
#     platform_id = "standard-v1"
#     zone        = var.worker-configs.zone
#     labels      = {
#         "node-role.kubernetes.io/worker" = ""
#     }
#     resources {
#         cores         = var.worker_flavor.core
#         memory        = var.worker_flavor.memory
#         core_fraction = var.worker_flavor.core_fraction
#     }

#     boot_disk {
#         initialize_params {
#         image_id = var.base_os_image
#         size = 20
#         }
#     }

#     network_interface {
#         subnet_id = yandex_vpc_subnet.worker-subnets.id
#         nat = true
#     }

#     lifecycle {
#         ignore_changes = [
#         metadata
#         ]
#     }

#     metadata = {
#         ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
#         user-data = templatefile("templates/cloud-init-worker.tftpl", {

#         ssh_key                           = file("~/.ssh/id_rsa.pub")
#         base_local_path_certs             = local.base_local_path_certs
#         ssl                               = local.ssl
#         base_path                         = var.base_path
#         kube_apiserver_lb_fqdn            = local.kube_apiserver_lb_fqdn
#         kube-apiserver-port-lb            = var.kube-apiserver-port-lb
#         kubernetes-ca-chain               = base64encode(vault_pki_secret_backend_root_sign_intermediate.intermediate["kubernetes-ca"].issuing_ca)
#         kubernetes-bootstrap-token        = ""
#         hostname                          = "${each.key}-${var.cluster_name}"
#         kubernetes-ca-bundle              = vault_pki_secret_backend_root_sign_intermediate.intermediate["kubernetes-ca"].certificate
#         kubernetes-ca-bundle-b64          = base64encode(vault_pki_secret_backend_root_sign_intermediate.intermediate["kubernetes-ca"].certificate)
#         bootstrap_token_all               = vault_token.kubernetes-all-login-bootstrap-worker["${each.key}"].client_token

#         key_keeper_config                 = templatefile("templates/services/key-keeper/config.tftpl", {
#           intermediates                   = local.ssl.intermediate
#           external_intermediates          = local.ssl.external_intermediate
#           base_local_path_vault           = local.base_local_path_vault
#           base_vault_path_approle         = local.base_vault_path_approle
#           base_certificate_atrs           = local.ssl.global-args.key-keeper-args
#           secrets                         = local.secrets
#           cluster_name                    = var.cluster_name
#           base_domain                     = var.base_domain
#           vault_config                    = var.vault_config
#           vault_server                    = var.vault_server
#           bootstrap_token_all             = vault_token.kubernetes-all-login-bootstrap-worker["${each.key}"].client_token
#           availability_zone               = "${each.key}"
#           full_instance_name              = format("%s.%s", "${each.key}" ,local.base_cluster_fqdn)
#           external_instance_name          = "${each.key}-${var.cluster_name}"
#           base_local_path_certs           = local.base_local_path_certs
#           instance_type                   = "worker"
#         })
#         kubelet-service-args              = templatefile("templates/services/kubelet/service-args.conf.tftpl", {
#             full_instance_name            = format("%s.%s", "${each.key}" ,local.base_cluster_fqdn)
#             instance_type                 = "worker"
#             base_path                     = var.base_path
#             base_domain                   = var.base_domain
#         })
#         kubelet-config                    = templatefile("templates/services/kubelet/config.yaml.tftpl", {
#             ssl                           = local.ssl
#             kubelet-config-args           = local.kubelet-config-args
#             base_path                     = var.base_path
#             instance_type                 = "worker"
#         })
#         key-keeper-service                = local.key-keeper-service
#         kubelet-service-d-fraima          = local.kubelet-service-d-fraima
#         containerd-service                = local.containerd-service
#         base-cni                          = local.base-cni
#         sysctl-network                    = local.sysctl-network
#         kubelet-service                   = local.kubelet-service
#         modules-load-k8s                  = local.modules-load-k8s
#         })
#     }
# }
#     # 
# # output "cloud_init_worker" {
# #     value = "${yandex_compute_instance.worker.network_interface[*].nat_ip_address}"
# # }
