locals {
    containerd-service                  = file("templates/services/containerd/service.tftpl")
    base-cni                            = file("templates/cni/net.d/99-loopback.conf.tftpl")
    sysctl-network                      = file("templates/sysctl/99-network.conf.tftpl")
    modules-load-k8s                    = file("templates/modules-load.d/k8s.conf.tftpl")
    kubelet-service                     = file("templates/services/kubelet/service.tftpl")
    
    key-keeper-service                  = templatefile("templates/services/key-keeper/service.yaml.tftpl", {
        base_local_path_certs           = local.global_path.base_local_path_certs
    })
    
    kubelet-service-d-fraima            = templatefile("templates/services/kubelet/service.d/10-fraima.conf.tftpl",{
        base_path                       = var.base_path
    })

    kube-apiserver-manifest             = templatefile("templates/manifests/kube-apiserver.yaml.tftpl", {
        secrets                         = local.secrets
        etcd_advertise_client_urls      = local.etcd_advertise_client_urls
        service_cidr                    = local.service_cidr
        base_local_path_certs           = local.global_path.base_local_path_certs
        ssl                             = local.ssl
        etcd_server_lb                  = local.etcd_server_lb_access
        idp_provider_fqdn               = local.idp_provider_fqdn
        idp_provider_realm              = local.idp_provider_realm
        kube-apiserver-image            = local.release-vars[var.actual-release].kube-apiserver.registry
        kubernetes-version              = local.release-vars[var.actual-release].kube-apiserver.version
        base_path                       = var.base_path
        kube-apiserver-port             = var.kube-apiserver-port
        idp-client-id                   = keycloak_openid_client.kube.name
        cluster-name                    = var.cluster_name

    })

    kube-controller-manager-manifest    = templatefile("templates/manifests/kube-controller-manager.yaml.tftpl", {
        service_cidr                    = local.service_cidr
        base_local_path_certs           = local.global_path.base_local_path_certs
        ssl                             = local.ssl
        kube-controller-manager-image   = local.release-vars[var.actual-release].kube-controller-manager.registry
        kubernetes-version              = local.release-vars[var.actual-release].kube-controller-manager.version
        base_path                       = var.base_path
    })
    
    kube-scheduler-manifest             = templatefile("templates/manifests/kube-scheduler.yaml.tftpl", {
        base_local_path_certs           = local.global_path.base_local_path_certs
        ssl                             = local.ssl
        kube-scheduler-image            = local.release-vars[var.actual-release].kube-scheduler.registry
        kubernetes-version              = local.release-vars[var.actual-release].kube-scheduler.version
        base_path                       = var.base_path
    })
}