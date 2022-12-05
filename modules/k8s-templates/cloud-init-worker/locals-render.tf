locals {

  cloud-init-worker = flatten([
    for worker_name, worker_content in  var.worker_instance_list_map:
      {"${worker_name}" = templatefile("${path.module}/templates/cloud-init-kubeadm-worker.tftpl", {

        ssh_key                           = file(var.k8s_global_vars.ssh_rsa_path)
        base_local_path_certs             = var.k8s_global_vars.global_path.base_local_path_certs
        ssl                               = var.k8s_global_vars.ssl
        base_path                         = var.base_path
        hostname                          = "${worker_name}-${var.k8s_global_vars.cluster_name}"
        actual_release                    = var.actual-release
        release_vars                      = local.release-vars
        kube_apiserver_lb_fqdn            = var.kube-apiserver-lb-fqdn
        kube_apiserver_port_lb            = var.kube-apiserver-port-lb
        bootstrap_token_all               = var.vault-bootstrap-worker-token[worker_name].client_token

        kubelet-bootstrap-kubeconfig        = module.kubelet-bootstrap-kubeconfig.kubeconfig
       
        kubelet-service                     = module.kubelet-service-worker.kubelet-service
        kubelet-service-d-fraima            = module.kubelet-service-worker.kubelet-service-d-fraima
        kubelet-service-args                = module.kubelet-service-worker.kubelet-service-args[worker_name]
        kubelet-config                      = module.kubelet-service-worker.kubelet-config

        key-keeper-config                   = module.key-keeper-service-worker.key-keeper-config[worker_name]
        key-keeper-service                  = module.key-keeper-service-worker.key-keeper-service

        
        containerd-service                  = module.containerd-service.service
        sysctl-network                      = module.sysctl.network
        modprobe-k8s                        = module.modprobe.k8s
        cni-base                            = module.cni.base
        bashrc-k8s                          = module.bashrc.k8s
        
      })}
    ])

  cloud-init-worker-map = { for item in local.cloud-init-worker :
    keys(item)[0] => values(item)[0]}


}