locals {
    containerd-service                  = file("templates/services/containerd/service.tftpl")
    base-cni                            = file("templates/cni/net.d/99-loopback.conf.tftpl")
    sysctl-network                      = file("templates/sysctl/99-network.conf.tftpl")
    modules-load-k8s                    = file("templates/modules-load.d/k8s.conf.tftpl")
    kubelet-service                     = file("templates/services/kubelet/service.tftpl")
    
    key-keeper-service                  = templatefile("templates/services/key-keeper/service.yaml.tftpl", {
        base_local_path_certs           = local.base_local_path_certs
    })

    kubelet-config                      = templatefile("templates/services/kubelet/config.yaml.tftpl", {
        ssl                             = local.ssl
        kubelet-config-args             = local.kubelet-config-args
        base_path                       = var.base_path
    })
    
    kubelet-service-d-fraima            = templatefile("templates/services/kubelet/service.d/10-fraima.conf.tftpl",{
        base_path                       = var.base_path
    })

    kube-apiserver-manifest             = templatefile("templates/manifests/kube-apiserver.yaml.tftpl", {
        secrets                         = local.secrets
        etcd_advertise_client_urls      = local.etcd_advertise_client_urls
        service_cidr                    = local.service_cidr
        base_local_path_certs           = local.base_local_path_certs
        ssl                             = local.ssl
        etcd_server_lb                  = local.etcd_server_lb_access
        kube-apiserver-image            = var.kube-apiserver-image
        kubernetes-version              = var.kubernetes-version
        base_path                       = var.base_path
        kube-apiserver-port             = var.kube-apiserver-port

    })

    kube-controller-manager-manifest    = templatefile("templates/manifests/kube-controller-manager.yaml.tftpl", {
        service_cidr                    = local.service_cidr
        base_local_path_certs           = local.base_local_path_certs
        ssl                             = local.ssl
        kube-controller-manager-image   = var.kube-controller-manager-image
        kubernetes-version              = var.kubernetes-version
        base_path                       = var.base_path
    })
    
    kube-scheduler-manifest             = templatefile("templates/manifests/kube-scheduler.yaml.tftpl", {
        base_local_path_certs           = local.base_local_path_certs
        ssl                             = local.ssl
        kube-scheduler-image            = var.kube-scheduler-image
        kubernetes-version              = var.kubernetes-version
        base_path                       = var.base_path
    })
}