
#### WORKERS ######
##-->

#### MASTERS ######
##-->
resource "yandex_compute_instance" "worker" {
  depends_on = [
    helm_release.base
    ]
  name        = "worker-1-${var.cluster_name}"
  hostname    = format("%s.%s.%s", each.key ,var.cluster_name, var.base_domain)
  platform_id = "standard-v1"
  zone        = var.master-configs.zone
  labels      = {
    "node-role.kubernetes.io/worker" = ""
  }
  resources {
    cores         = var.master_flavor.core
    memory        = var.master_flavor.memory
    core_fraction = var.master_flavor.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.base_os_image
      size = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.master-subnets.id
    nat = true
  }

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = templatefile("templates/cloud-init-worker.tftpl", {

        ssh_key                           = file("~/.ssh/id_rsa.pub")
        base_local_path_certs             = local.base_local_path_certs
        ssl                               = local.ssl
        base_path                         = var.base_path
        kube_apiserver_lb_fqdn            = local.kube_apiserver_lb_fqdn
        kube-apiserver-port-lb            = var.kube-apiserver-port-lb
        kubernetes-ca-chain               = "${base64encode(vault_pki_secret_backend_root_sign_intermediate.intermediate["kubernetes-ca"].issuing_ca)}"
        kubernetes-bootstrap-token        = ""
        kubelet-service-args              = templatefile("templates/services/kubelet/service-args.conf.tftpl", {
          full_instance_name              = format("%s.%s", "worker-1" ,local.base_cluster_fqdn)
          instance_type                   = "worker"
          base_path                       = var.base_path
          base_domain                     = var.base_domain
        })
        kubelet-config                      = templatefile("templates/services/kubelet/config.yaml.tftpl", {
            ssl                             = local.ssl
            kubelet-config-args             = local.kubelet-config-args
            base_path                       = var.base_path
            instance_type                   = "worker"
        })
        kubelet-service-d-fraima          = local.kubelet-service-d-fraima
        containerd-service                = local.containerd-service
        base-cni                          = local.base-cni
        sysctl-network                    = local.sysctl-network
        # kubelet-config                    = local.kubelet-config
        kubelet-service                   = local.kubelet-service
        modules-load-k8s                  = local.modules-load-k8s
      })
  }
}
# 
output "cloud_init_worker" {
    value = "${yandex_compute_instance.worker.network_interface[*].nat_ip_address}"
}
