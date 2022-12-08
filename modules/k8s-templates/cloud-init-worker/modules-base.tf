

module "containerd-service" {
    source = "../services/containerd"
}

module "sysctl" {
    source = "../sysctl"
}

module "modprobe" {
    source = "../modprobe"
}

module "cni" {
    source = "../cni"
}

module "bashrc" {
    source = "../bashrc"
    k8s_global_vars = var.k8s_global_vars

}
