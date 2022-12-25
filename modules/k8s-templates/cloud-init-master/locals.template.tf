
locals {
  cloud-init-master = flatten([
    for master_name, master_content in  var.master_instance_list_map:
      {"${master_name}" = templatefile("${path.module}/templates/cloud-init-kubeadm-master-all-packer.tftpl", {
        ssh_username                      = var.k8s_global_vars.ssh_username
        ssh_key                           = file(var.k8s_global_vars.ssh_rsa_path)
        base_local_path_certs             = var.k8s_global_vars.global_path.base_local_path_certs
        ssl                               = var.k8s_global_vars.ssl
        base_path                         = var.k8s_global_vars.global_path
        # hostname                          = "${master_name}-${var.k8s_global_vars.cluster_name}"
        hostname                          = "${master_name}"
        node_name                         = "${master_name}"
        actual_release                    = var.actual-release
        release_vars                      = local.release-vars
        # kube_apiserver_lb_fqdn            = var.kube-apiserver-lb-fqdn
        # kube_apiserver_port_lb            = var.kube-apiserver-port-lb
        # bootstrap_token_all               = var.bootstrap_token_all[master_name].client_token

        # DEDICATED VAULT BOOTSTRAP TOKENS
        # vault-bootstrap-issuer-master-token         = module.k8s-vault-master.bootstrap-issuer-master-token
        # vault-bootstrap-ca-master-token             = module.k8s-vault-master.bootstrap-ca-master-token
        # vault-bootstrap-external-ca-master-token    = module.k8s-vault-master.bootstrap-external-ca-master-token
        # vault-bootstrap-secret-master-token         = module.k8s-vault-master.bootstrap-secret-master-token
        
        kube-apiserver-admin-kubeconfig     = module.kube-apiserver-admin-kubeconfig.kubeconfig
        kubelet-kubeconfig                  = module.kubelet-kubeconfig.kubeconfig
        kube-scheduler-kubeconfig           = module.kube-scheduler-kubeconfig.kubeconfig
        kube-controller-manager-kubeconfig  = module.kube-controller-manager-kubeconfig.kubeconfig

        kubelet-service                     = module.kubelet-service-master.kubelet-service
        kubelet-service-d-fraima            = module.kubelet-service-master.kubelet-service-d-fraima
        kubelet-service-args                = module.kubelet-service-master.kubelet-service-args[master_name]
        kubelet-config                      = module.kubelet-service-master.kubelet-config

        key-keeper-config                   = module.key-keeper-service-master.key-keeper-config[master_name]
        key-keeper-service                  = module.key-keeper-service-master.key-keeper-service

        static-pod-etcd                     = module.static-pod-etcd.manifest[master_name]
        static-pod-kubeadm-config           = module.static-pod-kubeadm-config.manifest[master_name]
        # static-pod-kube-apiserver           = module.static-pod-kube-apiserver.manifest[master_name]
        # static-pod-kube-controller-manager  = module.static-pod-kube-controller-manager.manifest[master_name]
        # static-pod-kube-scheduler           = module.static-pod-kube-scheduler.manifest[master_name]
        kube-apiserver-audit                = module.static-pod-kube-apiserver.kube-apiserver-audit

        containerd-service                  = module.containerd-service.service
        containerd-service-config           = module.containerd-service.service-config
        sysctl-network                      = module.sysctl.network
        modprobe-k8s                        = module.modprobe.k8s
        cni-base                            = module.cni.base
        bashrc-k8s                          = module.bashrc.k8s
      })}
    ])
  cloud-init-master-map = { for item in local.cloud-init-master :
    keys(item)[0] => values(item)[0]}

}

