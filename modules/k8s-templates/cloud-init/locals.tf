
locals {
  release-vars = {
    v0_1 = {
      kubernetes = {
        version = "v1.23.12"
      }
      etcd = {
        registry = "k8s.gcr.io/etcd"
        version = "3.5.3-0"
      }
      kube-apiserver = {
        registry = "k8s.gcr.io/kube-apiserver"
        version = "v1.23.12"
      }
      kube-controller-manager = {
        registry = "k8s.gcr.io/kube-controller-manager"
        version = "v1.23.12"
      }
      kube-scheduler = {
        registry = "k8s.gcr.io/kube-scheduler"
        version = "v1.23.12"
      }
      kubectl = {
        url = "https://storage.googleapis.com/kubernetes-release/release/v1.23.12/bin/linux/amd64/kubectl"
      
      }
      kubeadm = {
        url = "https://storage.googleapis.com/kubernetes-release/release/v1.23.12/bin/linux/amd64/kubeadm"
      
      }
      kubelet = {
        url = "https://storage.googleapis.com/kubernetes-release/release/v1.23.12/bin/linux/amd64/kubelet"
        
      }
      runc = {
        url = "https://github.com/opencontainers/runc/releases/download/v1.1.3/runc.amd64"
        
      }
      cni = {
        url = "https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz"
        
      }
      containerd = {
        url = "https://github.com/containerd/containerd/releases/download/v1.6.8/containerd-1.6.8-linux-amd64.tar.gz"
        
      }
      crictl = {
        url = "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.23.0/crictl-v1.23.0-linux-amd64.tar.gz"
        
      }
    }
  }
}

locals {
  kubernetes-ca-ssl                                         = var.k8s_global_vars.ssl.intermediate["kubernetes-ca"]
  kube-apiserver-kubeconfig-certificate-authority           = "${local.kubernetes-ca-ssl.host_path}/kubernetes-ca.pem"
  kube-apiserver-kubeconfig-client-certificate              = "${local.kubernetes-ca-ssl.issuers["kube-apiserver-kubelet-client"].certificates["kube-apiserver-kubelet-client"].key-keeper-args.host_path}/kube-apiserver-kubelet-client.pem"
  kube-apiserver-kubeconfig-client-key                      = "${local.kubernetes-ca-ssl.issuers["kube-apiserver-kubelet-client"].certificates["kube-apiserver-kubelet-client"].key-keeper-args.host_path}/kube-apiserver-kubelet-client-key.pem"

  kubelet-kubeconfig-certificate-authority                  = "${local.kubernetes-ca-ssl.host_path}/kubernetes-ca.pem"
  kubelet-kubeconfig-client-certificate                     = "${local.kubernetes-ca-ssl.issuers["kubelet-client"].certificates["kubelet-client"].key-keeper-args.host_path}/kubelet-client.pem"
  kubelet-kubeconfig-client-key                             = "${local.kubernetes-ca-ssl.issuers["kubelet-client"].certificates["kubelet-client"].key-keeper-args.host_path}/kubelet-client-key.pem"

  kube-scheduler-kubeconfig-certificate-authority           = "${local.kubernetes-ca-ssl.host_path}/kubernetes-ca.pem"
  kube-scheduler-kubeconfig-client-certificate              = "${local.kubernetes-ca-ssl.issuers["kube-scheduler-client"].certificates["kube-scheduler-client"].key-keeper-args.host_path}/kube-scheduler-client.pem"
  kube-scheduler-kubeconfig-client-key                      = "${local.kubernetes-ca-ssl.issuers["kube-scheduler-client"].certificates["kube-scheduler-client"].key-keeper-args.host_path}/kube-scheduler-client-key.pem"

  kube-controller-manager-kubeconfig-certificate-authority  = "${local.kubernetes-ca-ssl.host_path}/kubernetes-ca.pem"
  kube-controller-manager-kubeconfig-client-certificate     = "${local.kubernetes-ca-ssl.issuers["kube-controller-manager-client"].certificates["kube-controller-manager-client"].key-keeper-args.host_path}/kube-controller-manager-client.pem"
  kube-controller-manager-kubeconfig-client-key             = "${local.kubernetes-ca-ssl.issuers["kube-controller-manager-client"].certificates["kube-controller-manager-client"].key-keeper-args.host_path}/kube-controller-manager-client-key.pem"
}

locals {
  cloud-init-master = flatten([
    for master_name, master_content in  var.k8s_global_vars.ssl_for_each_map.master_instance_list_map:
      {"${master_name}" = templatefile("${path.module}/templates/cloud-init-kubeadm.tftpl", {

        ssh_key                             = file(var.k8s_global_vars.ssh_rsa_path)
        base_local_path_certs               = var.k8s_global_vars.global_path.base_local_path_certs
        ssl                                 = var.k8s_global_vars.ssl
        base_path                           = var.base_path
        hostname                            = "${master_name}-${var.k8s_global_vars.cluster_name}"
        actual_release                      = var.actual-release
        release_vars                        = local.release-vars
        kube_apiserver_lb_fqdn              = var.kube-apiserver-lb-fqdn
        kube_apiserver_port_lb              = var.kube-apiserver-port-lb
        bootstrap_token_all                 = var.vault-bootstrap-master-token[master_name].client_token

        kube-apiserver-kubeconfig           = module.kube-apiserver-kubeconfig.kubeconfig
        kubelet-kubeconfig                  = module.kubelet-kubeconfig.kubeconfig
        kube-scheduler-kubeconfig           = module.kube-scheduler-kubeconfig.kubeconfig
        kube-controller-manager-kubeconfig  = module.kube-controller-manager-kubeconfig.kubeconfig
        kubelet-service                     = module.kubelet-service.kubelet-service
        kubelet-service-d-fraima            = module.kubelet-service.kubelet-service-d-fraima
        kubelet-service-args                = module.kubelet-service.kubelet-service-args[master_name]
        kubelet-config                      = module.kubelet-service.kubelet-config

        key-keeper-config                   = module.key-keeper-service.key-keeper-config[master_name]
        key-keeper-service                  = module.key-keeper-service.key-keeper-service

        static-pod-etcd                     = module.static-pod-etcd.manifest[master_name]
        static-pod-kubeadm-config           = module.static-pod-kubeadm-config.manifest[master_name]
        # static-pod-kube-apiserver           = module.static-pod-kube-apiserver.manifest[master_name]
        # static-pod-kube-controller-manager  = module.static-pod-kube-controller-manager.manifest[master_name]
        # static-pod-kube-scheduler           = module.static-pod-kube-scheduler.manifest[master_name]

        containerd-service                  = module.containerd-service.service
        sysctl-network                      = module.sysctl.network
        modprobe-k8s                        = module.modprobe.k8s
        cni-base                            = module.cni.base
        bashrc-k8s                          = module.bashrc.k8s
        kube-apiserver-audit                = module.k8s-kube-apiserver.audit
      })}
    ])
  cloud-init-master-map = { for item in local.cloud-init-master :
    keys(item)[0] => values(item)[0]}

}

