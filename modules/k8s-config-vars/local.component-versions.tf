locals {
  base_versions = {
    kubernetes_version = "v1.23.12"
    image_repository = "k8s.gcr.io"
  }
  component_versions = {
    kubernetes_version  = local.base_versions.kubernetes_version
    image_repository    = local.base_versions.image_repository
    bin = {
        fraimactl = {
            bin_url     = "https://github.com/fraima/fraima/releases/download/v0.0.1/fraimactl-v0.0.1-linux-amd64.tar.gz"
            sha256_url  = "https://github.com/fraima/fraima/releases/download/v0.0.1/fraimactl-v0.0.1-linux-amd64.tar.gz.sha256"
        }
        containerd = {
            bin_url     = "https://github.com/containerd/containerd/releases/download/v1.6.6/containerd-1.6.6-linux-amd64.tar.gz"
            sha256_url  = "https://github.com/containerd/containerd/releases/download/v1.6.6/containerd-1.6.6-linux-amd64.tar.gz.sha256sum"
        }
        runc = {
            bin_url     = "https://github.com/opencontainers/runc/releases/download/v1.1.3/runc.amd64"
            sha256_url  = ""
        }
        kubelet = {
            bin_url     = "https://dl.k8s.io/release/${local.base_versions.kubernetes_version}/bin/linux/amd64/kubelet"
            sha256_url  = "https://dl.k8s.io/${local.base_versions.kubernetes_version}/bin/linux/amd64/kubelet.sha256"
        }
        kubeadm = {
            bin_url     = "https://dl.k8s.io/release/${local.base_versions.kubernetes_version}/bin/linux/amd64/kubeadm"
            sha256_url  = "https://dl.k8s.io/${local.base_versions.kubernetes_version}/bin/linux/amd64/kubeadm.sha256"
        }
        kubectl = {
            bin_url     = "https://dl.k8s.io/release/${local.base_versions.kubernetes_version}/bin/linux/amd64/kubectl"
            sha256_url  = "https://dl.k8s.io/${local.base_versions.kubernetes_version}/bin/linux/amd64/kubectl.sha256"
        }
        crictl = {
            bin_url     = "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.26.0/crictl-v1.26.0-linux-amd64.tar.gz"
            sha256_url  = "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.26.0/crictl-v1.26.0-linux-amd64.tar.gz.sha256"
        }
        etcdctl = {
            bin_url     = "https://github.com/etcd-io/etcd/releases/download/v3.5.5/etcd-v3.5.5-linux-amd64.tar.gz"
            sha256_url  = ""
        }
        key_keeper = {
            bin_url     = "https://github.com/fraima/key-keeper/releases/download/v0.0.1/key-keeper-v0.0.1-linux-amd64.tar.gz"
            sha256_url  = "https://github.com/fraima/key-keeper/releases/download/v0.0.1/key-keeper-v0.0.1-linux-amd64.tar.gz.sha256"
        }
        yc = {
            bin_url     = "https://storage.yandexcloud.net/yandexcloud-yc/release/0.102.0/linux/amd64/yc"
            sha256_url  = ""
        }
    }
    static_pod = {
      etcd = {
        registry = "${local.base_versions.image_repository}/etcd"
        version = "3.5.3-0"
      }
      kube-apiserver = {
        registry = "${local.base_versions.image_repository}/kube-apiserver"
        version = local.base_versions.kubernetes_version
      }
      kube-controller-manager = {
        registry = "${local.base_versions.image_repository}/kube-controller-manager"
        version = local.base_versions.kubernetes_version
      }
      kube-scheduler = {
        registry = "${local.base_versions.image_repository}/kube-scheduler"
        version = local.base_versions.kubernetes_version
      }
    }
  }
}


data "utils_deep_merge_yaml" "component_versions" {
  input = [
    yamlencode(local.component_versions),
    yamlencode(try(var.extra_args.component_versions, {}))
  ]
}
