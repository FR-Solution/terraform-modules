
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
